var exec = require('child_process').exec;
var child1 = exec('npm run watch-assets');
var child2 = exec('npm run watch-js');
var child3 = exec('npm run watch-css');

process.stdin.on('end', function() {
  process.kill(child1.pid);
  process.kill(child2.pid);
  process.kill(child3.pid);
  process.exit(0);
});
process.stdin.resume();
