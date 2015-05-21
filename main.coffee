argv = require('minimist')(process.argv.slice(2))
fs = require('fs')
exec = require('child_process').exec
_ = require('lodash')
GithubApi = require('github')

from_file = (repo, path) =>
  fs.readFile path, (err, data) =>
    users = data.toString()
    .split("\n")
    .slice(0, -1)
    gitit(repo, users)

from_all_forks = (repo, user) =>
  github = new GithubApi(version: '3.0.0')
  github.repos.getForks {user: user, repo: repo},(err, res) =>
    users = (fork.owner.login for fork in res)
    gitit(repo, users)

from_cmd_args = (repo, argv) =>
  users = argv['_'].slice(1)
  gitit(repo, users)
  

gitit = (repo, users) =>
  users.forEach (user) =>
    #exec "git clone https://github.com/#{user}/#{repo}.git repos/#{user}"
    exec "git clone https://github.com/#{user}/#{repo}.git #{user}"
    , (error, stdout, stderr) =>
      console.log(stdout)

main = =>
  repo = argv['_'][0]
  # if the f flag is found read from a file
  from_file(repo, argv.f) if argv.f != undefined
  from_all_forks(repo, argv.a) if argv.a != undefined
  # if no flags are used
  from_cmd_args(repo, argv) if _.size(argv) == 1

main() 
