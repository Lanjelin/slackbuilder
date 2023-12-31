# SlackBuilder

A Docker image for building packages for slackware.  
Using [aclemons/slackware:15.0](https://hub.docker.com/r/aclemons/slackware) as baseimage.  

Uses 3 different pre-defined paths, and things will be execured in listed order.  
`/build-deps` - any `.txz` here will be installed, then any `.sh` will be executed. Will travel subdirectories.  
`/slackbuild` - executes the first `.SlackBuild` found.  
`/output` - optional directory for outputs.  

Environment-variables can be passed to both `.sh`and `.SlackBuild`.  

#### Example docker run:
```bash
docker run --rm --name SlackBuilder\
  -v /mnt/user/data/slackpkg/pass/build-deps:/build-deps \
  -v /mnt/user/data/slackpkg/pass/build:/slackbuild \
  -v /mnt/user/data/slackpkg/pass/output:/output \
  -e OUTPUT=/output \
  -e TMP=/tmp \
  ghcr.io/lanjelin/slackbuilder:latest
```

#### Example .zshrc/.bashrc function
```bash
slackbuild () {
  [[ $# -eq 0 ]] && BD="$PWD" || BD="$(realpath $1)"
  [[ ! -d "$BD" ]] && echo "Must be a directory" && return 1
  docker run --rm --name SlackBuilder \
  -v "$BD/build-deps":"/build-deps" \
  -v "$BD/slackbuild":"/slackbuild" \
  -v "$BD/output":"/output" \
  -e OUTPUT=/output \
  -e TMP=/tmp \
  ghcr.io/lanjelin/slackbuilder:latest
}
```
