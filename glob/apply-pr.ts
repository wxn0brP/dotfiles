#!/usr/bin/env bun

import { spawnSync, execSync } from "child_process";

function getRepoInfo() {
	const ghRepo = process.env.GITHUB_REPOSITORY;
	if (ghRepo) {
		const parts = ghRepo.split("/");
		if (parts.length === 2)
			return {
				owner: parts[0],
				repo: parts[1],
			};
	}

	let originUrl: string;
	try {
		originUrl = execSync("git config --get remote.origin.url", {
			encoding: "utf-8",
			stdio: [
				"ignore",
				"pipe",
				"ignore",
			],
		}).trim();
	} catch {
		console.error("Not in a git repository or no remote origin.");
		process.exit(1);
	}

	try {
		const url = new URL(originUrl);
		if (url.protocol === "https:") {
			const path = url.pathname.replace(/\.git$/, "").replace(/^\//, "");
			const parts = path.split("/");
			if (parts.length === 2)
				return {
					owner: parts[0],
					repo: parts[1],
				};
		}
	} catch {
		// Not a valid URL
	}

	const match = originUrl.match(/:([^/]+)\/([^/]+?)(\.git)?$/);
	if (match)
		return {
			owner: match[1],
			repo: match[2],
		};

	console.error(`Failed to parse origin URL: ${originUrl}`);
	process.exit(1);
}

function parseLinkHeader(header: string) {
	const links: Record<string, string> = {};
	if (!header) return links;
	for (const part of header.split(",")) {
		const m = part.trim().match(/<([^>]+)>;\s*rel="([^"]+)"/);
		if (m) links[m[2]] = m[1];
	}
	return links;
}

async function getOpenRenovatePrs(owner: string, repo: string, token?: string) {
	const headers: Record<string, string> = {
		Accept: "application/vnd.github.v3+json",
	};
	if (token) headers.Authorization = `token ${token}`;

	const prNumbers: number[] = [];
	let url: string = `https://api.github.com/repos/${owner}/${repo}/pulls?state=open&sort=created&direction=desc&per_page=100`;

	while (url) {
		const response = await fetch(url, {
			headers,
		});
		if (!response.ok) {
			console.error(
				`GitHub API error: ${response.status} - ${await response.text()}`,
			);
			process.exit(1);
		}

		const data = (await response.json()) as Array<Record<string, any>>;
		for (const pr of data) {
			const login = pr.user?.login ?? "";
			const title = pr.title ?? "";
			if (
				login.toLowerCase().includes("renovate") ||
				title.toLowerCase().includes("renovate")
			) {
				prNumbers.push(pr.number as number);
			}
		}

		const links = parseLinkHeader(response.headers.get("link"));
		url = links.next ?? null;
	}

	prNumbers.sort((a, b) => a - b);
	return prNumbers;
}

async function fetchAndApplyDiff(
	owner: string,
	repo: string,
	prNumber: number,
	token?: string,
) {
	const headers: Record<string, string> = {
		Accept: "application/vnd.github.v3.diff",
	};
	if (token) headers.Authorization = `token ${token}`;

	const response = await fetch(
		`https://api.github.com/repos/${owner}/${repo}/pulls/${prNumber}`,
		{
			headers,
		},
	);
	if (!response.ok) {
		console.error(
			`Failed to fetch diff for PR #${prNumber}: ${response.status}`,
		);
		return false;
	}

	const diffContent = await response.text();
	if (!diffContent.trim()) {
		console.log(`PR #${prNumber} has an empty diff.`);
		return false;
	}

	const result = spawnSync(
		"patch",
		[
			"-p1",
			"--forward",
			"--no-backup-if-mismatch",
		],
		{
			input: diffContent,
			encoding: "utf-8",
		},
	);

	if (result.status === 0) {
		console.log(`Applied diff from PR #${prNumber}`);
		return true;
	}

	if (result.status === 1) {
		console.error(`PR #${prNumber} - some hunks were rejected:`);
		console.error(result.stderr);
		return false;
	}

	console.error(`Error applying diff from PR #${prNumber}:`);
	console.error(result.stderr);
	return false;
}

const { owner, repo } = getRepoInfo();
console.log(`Repository: ${owner}/${repo}`);

const token = process.env.GITHUB_TOKEN || process.env.GH_TOKEN;
if (token) {
	console.log("Using GitHub token for authorization.");
} else {
	console.log(
		"No GitHub token found - rate limit may apply (60 requests/hour).",
	);
}

console.log("Looking for open Renovate PRs...");
const prNumbers = await getOpenRenovatePrs(owner, repo, token);

if (prNumbers.length === 0) {
	console.log("No open Renovate PRs found.");
	process.exit(0);
}

console.log(`Found ${prNumbers.length} PR(s): ${prNumbers.join(", ")}`);

let applied = 0;
for (const pr of prNumbers) {
	console.log(`\nFetching and applying diff from PR #${pr}...`);
	if (await fetchAndApplyDiff(owner, repo, pr, token)) applied++;
}

console.log(`\nApplied ${applied} of ${prNumbers.length} diff(s).`);
if (applied < prNumbers.length)
	console.log("Some diffs were not applied (check error messages above).");
