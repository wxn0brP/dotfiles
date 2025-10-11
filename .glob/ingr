#!/usr/bin/env bun

import { execSync } from "child_process";
import { existsSync, mkdirSync, readdirSync } from "fs";

process.chdir(process.env.HOME + "");
if (!existsSync(".ingr")) mkdirSync(".ingr", { recursive: true });
process.chdir(".ingr");

const name = process.argv[2];

if (name) {
    if (existsSync(name)) {
        console.log(`Updating ${name}`);
        process.chdir(name);
        execSync("git pull", { stdio: "inherit" });
        execSync("bun install", { stdio: "inherit" });
        execSync("ing", { stdio: "inherit" });
        process.chdir("..");
        process.exit(0);
    }
    execSync(`git clone https://github.com/wxn0brP/${name}`, { stdio: "inherit" });
    process.chdir(name);
    execSync("bun install", { stdio: "inherit" });
    console.log(`Installed ${name}`);
    execSync("ing", { stdio: "inherit" });
} else {
    const dirs = readdirSync(".", { withFileTypes: true }).filter(d => d.isDirectory()).map(d => d.name);
    for (const dir of dirs) {
        process.chdir(`${dir}`);
        execSync("git pull", { stdio: "inherit" });
        execSync("bun install", { stdio: "inherit" });
        console.log(`Installed ${dir}`);
        execSync("ing", { stdio: "inherit" });
        process.chdir("..");
    }
    console.log("All updated");
}