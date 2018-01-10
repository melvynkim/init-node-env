#!/usr/bin/env node
const spawn = require('child_process').spawnSync;
const path = require("path");
const libRootPath = path.resolve(__dirname); // this modules' root path
const args = process.argv;
const projectRootPath = args[2]; // project to initialize

let isVerbose = false;

function printUsage() {
  console.log(
`> usage:

init-node-env $PWD [--verbose]

- $PWD      Pass down current working directory with the project to initialize node env.
- verbose   Print all output, including stdout, stderr.
  
> To Install:

(yarn global add|npm -g install) init-node-env

> For more info:

https://github.com/melvynkim/init-node-env`);
}

function die(exitCode) {
  printUsage();
  process.exit(exitCode ? exitCode : 1);
}

function execShellScript(module, args, isVerbose) {
  console.log(`info: installing ${module}`);
  const child = spawn(`${libRootPath}/lib/${module}.sh`, args);

  if (isVerbose) {
    console.log(child.output.toString());
    console.log(child.stdout.toString());
    console.log(child.stderr.toString());
  }
}

// main
if (args && args instanceof Array) {
  switch(args.length) {
    case 4: {
      if (args[3] === '--verbose') {
        isVerbose = true;
      } else {
        die(2);
      }
      break;
    }
    case 3: {
      // TODO: check if valid PWD
      break;
    }
    default: {
      die(3);
    }
  }
  execShellScript('install_dependencies', [projectRootPath], isVerbose)
  execShellScript('add_gitignore', [projectRootPath], isVerbose)
  execShellScript('add_scripts_to_package_json', [projectRootPath], isVerbose)
  execShellScript('add_bin', [projectRootPath, libRootPath], isVerbose)
} else {
  die(4);
}