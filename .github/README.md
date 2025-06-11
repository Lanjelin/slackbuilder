# SlackBuilder

A Docker image for building packages for slackware.
Using [aclemons/slackware:15.0](https://hub.docker.com/r/aclemons/slackware) as baseimage.

Uses the following pre-defined paths, and things will be execured in listed order.  
- `/build-deps` - any `.txz` here will be installed, then any `.sh` will be executed. Will travel subdirectories.  
- `/slackbuild` - executes the first `.SlackBuild` found.  
- `/output` - optional directory for outputs.  
- `/logs` - optional directory for logs.  

Environment-variables can be passed to both `.sh`and `.SlackBuild`.  
Set environment variable `VERBOSITY` to adjust the amount of information printed to the console output when running. Setting `VERBOSITY=0` will force everything to be printed to the log files, `VERBOSITY=1` will only print a minimum amount of information to the console and `VERBOSITY=2` will print everything to the console. The log files will always be populated irrespectively of the `VERBOSITY`. Not setting `VERBOSITY` is the same than `VERBOSITY=2`.

#### Example docker run:
```bash
docker run --rm --name SlackBuilder\
  -v /mnt/user/data/slackpkg/pass/build-deps:/build-deps \
  -v /mnt/user/data/slackpkg/pass/build:/slackbuild \
  -v /mnt/user/data/slackpkg/pass/output:/output \
  -v /mnt/user/data/slackpkg/pass/logs:/logs \
  -e OUTPUT=/output \
  -e TMP=/tmp \
  -e VERBOSITY=1 \
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
  -v "$BD/logs":"/logs" \
  -e OUTPUT=/output \
  -e TMP=/tmp \
  ghcr.io/lanjelin/slackbuilder:latest
}
```
