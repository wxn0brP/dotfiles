#!/usr/bin/env bun

import { $ } from "bun";
import { cpSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import { userInfo } from "os";
import { basename, join, resolve } from "path";

const dir = Bun.argv[2];
if (!dir) {
	console.log("Please provide a directory name");
	process.exit(1);
}

const isSubFront = dir === ".";

mkdirSync(isSubFront ? "front" : dir, {
	recursive: true,
});
process.chdir(isSubFront ? "front" : dir);

const pkgName =
	Bun.argv[3] ||
	(isSubFront ? basename(process.cwd()) : basename(resolve(dir)));

const NIT_USER = process.env.NIT_USER || userInfo().username;
const dots = join(process.env.HOME!, "dotfiles", "nit");

mkdirSync(`src`, {
	recursive: true,
});

let useServer: boolean;
let hasFlankerUi: boolean;
let hasFlankerDialog: boolean;
let hasScss: boolean;
let hasGenJs: boolean;

cpSync(join(dots, "front", "front", "index.html"), `index.html`);
cpSync(join(dots, "front", "front", "tsconfig.json"), `tsconfig.json`);
if (hasFlankerUi) {
	const tsconfig = JSON.parse(readFileSync("tsconfig.json", "utf-8"));
	tsconfig.compilerOptions ??= {};
	tsconfig.compilerOptions.types ??= [];
	if (!tsconfig.compilerOptions.types.includes("@wxn0brp/flanker-ui"))
		tsconfig.compilerOptions.types.push("@wxn0brp/flanker-ui");
	writeFileSync("tsconfig.json", JSON.stringify(tsconfig, null, "\t") + "\n");
}

if (!isSubFront) {
	cpSync(join(dots, "biome.json"), "biome.json");
	cpSync(join(dots, ".gitignore"), ".gitignore");
}

writeFileSync(`src/index.ts`, "");

console.log(
	`\n--- nitf: Configure frontend project${isSubFront ? " (sub: front/)" : ""} ---\n`,
);

process.stdin.resume();
let inputBuf = "";
process.stdin.on("data", chunk => {
	inputBuf += chunk.toString();
});

async function ask(question: string, default_ = false): Promise<any> {
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

async function prompt() {
	if (isSubFront) {
		const pattern = "front/src/**/*";
		const srcPattern = "src/**/*";
		const addBiomeIncludes = await ask(
			`Add "${pattern}" to biome.json files.includes?`,
		);
		if (addBiomeIncludes) {
			const biome = JSON.parse(readFileSync("../biome.json", "utf-8"));
			biome.files = biome.files || {};
			biome.files.includes = biome.files.includes || [];
			if (!biome.files.includes.includes(pattern))
				biome.files.includes.push(pattern);
			if (!biome.files.includes.includes(srcPattern))
				biome.files.includes.push(srcPattern);
			writeFileSync("../biome.json", JSON.stringify(biome, null, "\t") + "\n");
		}
	}

	useServer = await ask("Enable built-in server in suglite?");

	hasFlankerUi = await ask("Add @wxn0brp/flanker-ui?");
	hasFlankerDialog = false;
	if (hasFlankerUi)
		hasFlankerDialog = await ask("  Add @wxn0brp/flanker-dialog?");

	hasScss = await ask("Add SCSS (sass)?");
	hasGenJs = await ask("Add gen.js (auto-import modules)?");

	process.stdin.pause();
}

function generate() {
	const scripts: Record<string, string> = {
		build: "bun build src/index.ts --outdir dist --target browser --sourcemap",
	};

	if (hasScss)
		scripts["build:scss"] =
			"bunx sass --load-path=node_modules scss:dist --style compressed";

	if (hasGenJs) {
		const prefix = "bun run gen.js && ";
		for (const key of Object.keys(scripts)) {
			scripts[key] = prefix + scripts[key];
		}
	}

	const suglite: Record<string, any> = {
		cmd: "bun run build",
		watch: [
			"src",
		],
	};

	if (useServer) {
		suglite.server = Math.floor(Math.random() * 10000 + 10000);
		suglite.server_map = {
			dir: {
				"/": "public",
				"-/": "dist",
			},
		};
	}

	if (hasGenJs) {
		suglite.ignore = [
			`src/__all_modules.ts`,
		];
	}

	writeFileSync(`suglite.json5`, JSON.stringify(suglite, null, "\t") + "\n");

	const multiTsc: Record<string, any> = {
		cmd: "tsc --noEmit",
		watch: [
			"src",
		],
	};
	if (hasGenJs) {
		multiTsc.ignore = [
			`src/__all_modules.ts`,
		];
	}
	const multi: Record<string, any>[] = [
		multiTsc,
	];

	if (hasScss) {
		multi.push({
			cmd: "bun run build:scss",
			watch: [
				"scss",
			],
		});
	}

	writeFileSync(
		`suglite.multi.json5`,
		JSON.stringify(multi, null, "\t") + "\n",
	);

	const devDeps: Record<string, string> = {
		typescript: "^7",
	};
	if (hasFlankerUi) devDeps["@wxn0brp/flanker-ui"] = "^0.5.1";
	if (hasFlankerDialog) devDeps["@wxn0brp/flanker-dialog"] = "^0.1.0";
	if (hasScss) devDeps["sass"] = "^1";

	const pkg: Record<string, any> = {
		name: isSubFront ? "front" : pkgName,
		version: "0.0.1",
		private: true,
		type: "module",
		scripts,
		devDependencies: devDeps,
	};

	if (isSubFront) {
		writeFileSync(`package.json`, JSON.stringify(pkg, null, "\t") + "\n");
	} else {
		pkg.devDependencies = {
			...devDeps,
			"@wxn0brp/biome": "*",
		};
		writeFileSync("package.json", JSON.stringify(pkg, null, "\t") + "\n");
	}

	if (hasScss) {
		mkdirSync(`scss`, {
			recursive: true,
		});
		const scssContent = hasFlankerDialog
			? `@use "@wxn0brp/flanker-dialog/dist/style";`
			: "// SCSS entry point";
		writeFileSync(`scss/index.scss`, scssContent + "\n\n");
	}

	if (hasFlankerDialog) {
		let html = readFileSync(`index.html`, "utf-8");
		html = html.replace(
			"</body>",
			'\t<div id="FD-prompt"></div>\n\t<div id="FD-message"></div>\n\n</body>',
		);
		writeFileSync(`index.html`, html);
	}

	const template = hasFlankerDialog
		? join(dots, "front", "templates", "flanker.ts")
		: hasFlankerUi
			? join(dots, "front", "templates", "flanker-ui.ts")
			: join(dots, "front", "templates", "plain.ts");
	cpSync(template, `src/index.ts`);

	if (hasGenJs) cpSync(join(dots, "front", "front", "gen.js"), `gen.js`);

	if (!isSubFront) {
		const license = readFileSync(join(dots, "LICENSE"), "utf-8")
			.replace(/\$date/g, new Date().getFullYear().toString())
			.replace(/\$NIT_USER/g, NIT_USER);
		writeFileSync("LICENSE", license);
	}
}

await prompt();
generate();

console.log("\nInstalling dependencies...\n");
await $`bun install`;
await $`bumr`;
