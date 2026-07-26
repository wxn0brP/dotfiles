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
const L_NIT_USER = NIT_USER.toLowerCase();
const dots = join(process.env.HOME!, "dotfiles", "nit");

mkdirSync(".github/workflows", {
	recursive: true,
});
mkdirSync("rusalka", {
	recursive: true,
});
mkdirSync("src", {
	recursive: true,
});

cpSync(
	join(dots, "lib", ".github", "workflows", "build.yml"),
	".github/workflows/build.yml",
);
cpSync(join(dots, "lib", "rusalka", "build.ts"), "rusalka/build.ts");
cpSync(join(dots, "lib", "tsconfig.json"), "tsconfig.json");
cpSync(join(dots, "lib", "suglite.json5"), "suglite.json5");
cpSync(join(dots, "biome.json"), "biome.json");
cpSync(join(dots, ".gitignore"), ".gitignore");

writeFileSync("src/index.ts", "");

const pkg = {
	name: `@${L_NIT_USER}/${pkgName}`,
	version: "0.0.1",
	main: "dist/index.js",
	types: "dist/index.d.ts",
	description: "",
	repository: {
		type: "git",
		url: `https://github.com/${NIT_USER}/${pkgName}.git`,
	},
	homepage: `https://github.com/${NIT_USER}/${pkgName}`,
	author: NIT_USER,
	license: "MIT",
	type: "module",
	scripts: {
		build: "tsc && tsc-alias",
	},
	devDependencies: {
		"@types/bun": "*",
		"@wxn0brp/biome": "*",
		"tsc-alias": "^1",
		typescript: "^7",
	},
	files: [
		"dist",
	],
	exports: {
		".": {
			types: "./dist/index.d.ts",
			import: "./dist/index.js",
			default: "./dist/index.js",
		},
		"./*": {
			types: "./dist/*.d.ts",
			import: "./dist/*.js",
			default: "./dist/*.js",
		},
	},
};

writeFileSync("package.json", JSON.stringify(pkg, null, "\t") + "\n");

const license = readFileSync(join(dots, "LICENSE"), "utf-8")
	.replace(/\$date/g, new Date().getFullYear().toString())
	.replace(/\$NIT_USER/g, NIT_USER);
writeFileSync("LICENSE", license);

await $`bun install`;
await $`bumr`;
