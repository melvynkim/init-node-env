const { execFile } = require('child_process');
const path = require("path");
const libRootPath = path.resolve(__dirname); // this modules' root path
const args = process.argv;
const projectRootPath = args[2]; // project to initialize

function checkPrerequisites() {
  if (projectRootPath === '') {
    console.log(_usage);
    return 1;
  }
}

function _usage() {
  console.log(
`usage: init-node-env $PWD

$PWD      Pass down current working directory with the project to initialize node env.
  
install: (yarn global add|npm -g install) init-node-env

more info: https://github.com/melvynkim/init-node-env`);
}

function execShellScript(path, args) {
  const child = execFile(`${libRootPath}/lib/${path}`, [args], (error, stdout, stderr) => {
    if (error) {
      throw error;
    }
    console.log(stdout);
    console.log(stderr);
  });
}

// main
checkPrerequisites();
execShellScript('install_dependencies.sh') &&
  execShellScript('add_gitignore.sh', projectRootPath) &&
  execShellScript('add_scripts_to_package_json.sh', projectRootPath) &&
  execShellScript('add_bin.sh', [projectRootPath, libRootPath])