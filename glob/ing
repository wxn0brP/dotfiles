#!/usr/bin/env bun

import { execSync } from "child_process";
import { mkdirSync, readFileSync } from "fs";
import { join, resolve } from "path";

const pkg = JSON.parse(readFileSync("./package.json", "utf-8"));
const { bin } = pkg as Record<string, string>;

const ingDir = join(process.env.HOME!, ".ing");
mkdirSync(ingDir, { recursive: true });

for (const [name, path] of Object.entries(bin)) {
    const ingPath = join(ingDir, name);
    const targetPath = resolve(path);

    try {
        execSync(`rm -rf "${ingPath}"`);
    } catch { }

    execSync(`ln -s "${targetPath}" "${ingPath}"`);
    console.log(`${targetPath} -> ${ingPath}`);
}
