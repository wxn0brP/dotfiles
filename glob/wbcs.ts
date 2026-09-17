#!/usr/bin/env bun

import { $, argv } from "bun";
import { existsSync, realpathSync } from "fs";
import { homedir, userInfo } from "os";
import { basename, join } from "path";

const HELP = `Usage: wbcs [name]

Creates a systemd unit file at /etc/systemd/system/w-<name>.service.

If <name> is omitted, uses the current directory's basename.
`;

if (argv.includes("--help") || argv.includes("-h")) {
	console.log(HELP);
	process.exit(0);
}

const name = argv[2] ?? basename(process.cwd());

if (!/^[a-zA-Z0-9._-]+$/.test(name)) {
	console.error(`Error: invalid name "${name}" (allowed: a-zA-Z0-9._-)`);
	process.exit(1);
}

const cwd = realpathSync(process.cwd());
const user = userInfo().username;
const group = (await $`id -gn ${user}`.text()).trim();
const bunHome = join(homedir(), ".bun", "bin", "bun");
const bunPath = existsSync(bunHome)
	? bunHome
	: (await $`which bun`.text()).trim();

if (!bunPath) {
	console.error("Error: bun not found at ~/.bun/bin/bun or in PATH");
	process.exit(1);
}

const entryPath = join(cwd, "src", "index.ts");
if (!existsSync(entryPath)) {
	console.warn(`Warning: ${entryPath} does not exist`);
}

const target = `/etc/systemd/system/w-${name}.service`;

if (existsSync(target)) {
	const answer = prompt(`File ${target} exists. Overwrite? [y/N] `);
	if (answer?.toLowerCase() !== "y") {
		console.log("Aborted.");
		process.exit(0);
	}
}

const content = `[Unit]
Description=${name} Service (Bun)
After=network.target
Wants=network.target

[Service]
Type=simple
User=${user}
Group=${group}

WorkingDirectory=${cwd}
ExecStart=${bunPath} run ${cwd}/src/index.ts

Restart=always
RestartSec=5

StandardOutput=journal
StandardError=journal

Environment="NODE_ENV=production"
Environment="PATH=/home/${user}/.bun/bin:/usr/local/bin:/usr/bin:/bin"

NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
`;

const tmp = `/tmp/wbcs-${name}-${process.pid}.service`;
await Bun.write(tmp, content);
await $`sudo install -m 644 ${tmp} ${target} && rm ${tmp}`;

console.log(`Wrote ${target}\n`);
console.log(`Next:
  sudo systemctl daemon-reload
  sudo systemctl enable --now w-${name}.service
  ksctl w-${name}.service l   # tail logs`);
