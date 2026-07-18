#!/usr/bin/env bun

import { $, argv } from "bun";
import { readFileSync } from "fs";

const args = argv.slice(2);
let releaseType = "";
let increment = 1;
let dryRun = false;

for (const arg of args) {
    switch (arg) {
        case "-d":
            dryRun = true;
            break;
        case "a":
            releaseType = "alpha";
            break;
        case "b":
            releaseType = "beta";
            break;
        case "p":
            releaseType = "patch";
            break;
        case "m":
            releaseType = "minor";
            break;
        default:
            if (/^\d+$/.test(arg)) {
                increment = parseInt(arg);
            } else {
                console.error("Usage: nsv [a|b|p|m] [increment] [-d]");
                console.error("  a = alpha prerelease");
                console.error("  b = beta prerelease");
                console.error("  p = patch");
                console.error("  m = minor");
                console.error("  -d = dry-run");
                process.exit(1);
            }
    }
}

const currentVersion = JSON.parse(readFileSync("package.json", "utf-8")).version;

let newVersion: string;
const [version, tag] = currentVersion.split("-");
let [major, minor, patch] = version.split(".").map(Number);

switch (releaseType) {
    case "":
        break;
    case "patch":
        newVersion = `${major}.${minor}.${patch + increment}`;
        break;
    case "minor":
        newVersion = `${major}.${minor + increment}.0`;
        break;
    case "alpha":
    case "beta": {
        let preNum = 0;
        if (tag) {
            const [name, num] = tag.split(".");
            if (name === releaseType) {
                preNum = num ? parseInt(num) + 1 : 0;
            } else {
                patch++;
                preNum = 0;
            }
        } else {
            patch++;
            preNum = 0;
        }

        newVersion = `${major}.${minor}.${patch}-${releaseType}.${preNum}`;
        break;
    }
    default:
        console.error(`Error: Unknown release type "${releaseType}"`);
        process.exit(1);
}

let cmd = "standard-version";

if (newVersion)
    cmd += ` -r ${newVersion}`;

if (dryRun)
    cmd += " --dry-run";

console.log("$", cmd);
await $`${{ raw: cmd }}`;
