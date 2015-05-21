argv = require('minimist')(process.argv.slice(2))
fs = require('fs')
exec = require('child_process').exec


process_file = (path) =>
  fs.readFileSync(path)
    .toString()
    .split("\n")
    .slice(0, -1) # to compensate for the extra newline

gitit = (repo, users) =>
  users.forEach (user) =>
    exec "git clone https://github.com/#{user}/#{repo}.git repos/#{user}"
    , (error, stdout, stderr) =>
      console.log(stdout)

main = =>
  repo = argv['_'][0]
  # if the f flag is found read from a file
  if argv.f != undefined
    users = process_file(argv.f)
  users = users or argv['_'].slice(1)
  gitit(repo, users)

main() 
