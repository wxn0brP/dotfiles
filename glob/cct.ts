#!/usr/bin/env bun

import { $, argv } from "bun";
import { homedir } from "os";
import { join } from "path";

function paths() {
	const dir = join(homedir(), ".cloudflared");
	return {
		dir,
		make: join(dir, "config-make.yml"),
		out: join(dir, "config.yml"),
	};
}

interface IngressEntry {
	hostname?: string;
	service: string;
}

interface Config {
	tunnel: string;
	"credentials-file": string;
	ingress: IngressEntry[];
}

const args = argv.slice(2);

if (args.length === 0) {
	console.error("Usage: cct <service...> [port]");
	process.exit(1);
}

const { make, out } = paths();

const services: string[] = [];
let fPort: number | null = null;

for (const arg of args) {
	if (/^\d+$/.test(arg)) {
		fPort = parseInt(arg);
	} else {
		services.push(arg);
	}
}

const templateText = await Bun.file(make).text();
const config = Bun.YAML.parse(templateText) as Config;

const include = new Set(services);
if (fPort !== null) include.add("f");

const filtered: IngressEntry[] = [];

for (const entry of config.ingress) {
	if (entry.service === "http_status:404") continue;

	const subdomain = (entry.hostname || "").split(".")[0];
	if (!include.has(subdomain)) continue;

	if (subdomain === "f" && fPort !== null) {
		filtered.push({
			...entry,
			service: `http://localhost:${fPort}`,
		});
	} else {
		filtered.push(entry);
	}
}

const catchAll = config.ingress.find(e => e.service === "http_status:404");
if (catchAll) filtered.push(catchAll);

config.ingress = filtered;

await Bun.write(out, Bun.YAML.stringify(config, null, 2));

console.log(`Wrote config to ${out}`);
console.log(
	`Services: ${filtered
		.filter((e: any) => e.service !== "http_status:404")
		.map((e: any) => e.hostname?.split(".")[0] || "?")
		.join(", ")}`,
);

await $`cloudflared tunnel run`;
