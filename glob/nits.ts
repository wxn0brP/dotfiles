#!/usr/bin/env bun

import { $ } from "bun";
import { cpSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import * as os from "os";
import { basename, join, resolve } from "path";
const dir = Bun.argv[2];
if (!dir) {
	console.log("Please provide a directory name");
	process.exit(1);
}

mkdirSync(dir, {
	recursive: true,
});
process.chdir(dir);

const pkgName =
	Bun.argv[3] ||
	(dir === "." ? basename(process.cwd()) : basename(resolve(dir)));

const NIT_USER = process.env.NIT_USER || os.userInfo().username;
const dots = join(process.env.HOME!, "dotfiles", "nit");

mkdirSync("src", {
	recursive: true,
});

cpSync(join(dots, "server", "tsconfig.json"), "tsconfig.json");
cpSync(join(dots, "biome.json"), "biome.json");
cpSync(join(dots, ".gitignore"), ".gitignore");

writeFileSync("src/index.ts", "");

process.stdin.resume();

let inputBuf = "";
process.stdin.on("data", chunk => {
	inputBuf += chunk.toString();
});

function ask(question: string, default_ = false): Promise<boolean> {
	const hint = default_ ? "Y/n" : "y/N";
	process.stdout.write(`${question} (${hint}): `);
	return new Promise(resolve => {
		function tryRead() {
			const idx = inputBuf.indexOf("\n");
			if (idx === -1) {
				setTimeout(tryRead, 10);
				return;
			}
			const answer = inputBuf.substring(0, idx).trim();
			inputBuf = inputBuf.substring(idx + 1);
			resolve(answer === "" ? default_ : answer.toLowerCase() === "y");
		}
		tryRead();
	});
}

console.log("\n--- nits: Configure server project ---\n");

const hasDb = await ask("Add DB (Valthera)?");
const hasFf = await ask("Add FalconFrame?");

let template: string;
const devDeps: Record<string, string> = {
	"@types/bun": "*",
	"@wxn0brp/biome": "*",
	typescript: "^7",
};

if (hasDb) devDeps["@wxn0brp/db"] = "^0.112.0";
if (hasFf) devDeps["@wxn0brp/falcon-frame"] = "^0.9.2";

if (!hasDb && !hasFf) {
	template = "plain";
} else if (hasDb && !hasFf) {
	template = "db";
} else if (hasFf && !hasDb) {
	template = "ff";
} else {
	template = "ff-db";
}

process.stdin.pause();

const tplBase = join(dots, "server", "templates");

cpSync(join(tplBase, "index", `${template}.ts`), "src/index.ts");

if (hasFf) {
	cpSync(join(tplBase, "modules", "app.ts"), "src/app.ts");
}
if (hasDb) {
	cpSync(join(tplBase, "modules", "db.ts"), "src/db.ts");
}

const suglite: Record<string, unknown> = {
	cmd: "bun run dev",
	watch: [
		"src",
	],
};
writeFileSync("suglite.json5", JSON.stringify(suglite, null, "\t") + "\n");

const scripts: Record<string, string> = {
	start: "bun run src/index.ts",
};

const pkg: Record<string, unknown> = {
	name: pkgName,
	version: "0.0.1",
	private: true,
	description: "",
	repository: {
		type: "git",
		url: `https://github.com/${NIT_USER}/${pkgName}.git`,
	},
	homepage: `https://github.com/${NIT_USER}/${pkgName}`,
	author: NIT_USER,
	license: "MIT",
	type: "module",
	scripts,
	devDependencies: devDeps,
};

writeFileSync("package.json", JSON.stringify(pkg, null, "\t") + "\n");

const license = readFileSync(join(dots, "LICENSE"), "utf-8")
	.replace(/\$date/g, new Date().getFullYear().toString())
	.replace(/\$NIT_USER/g, NIT_USER);
writeFileSync("LICENSE", license);

console.log(`\nTemplate: ${template}`);
if (hasFf) console.log("  modules: app.ts");
if (hasDb) console.log("  modules: db.ts");
console.log("Installing dependencies...\n");
await $`bun install`;
await $`bumr`;
