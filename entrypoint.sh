#!/bin/bash

# Handle loging
log_output() {
  local lvl="$1"
  local logfile="$2"
  if [[ -n "$VERBOSITY" ]] && [[ $lvl -gt $VERBOSITY ]]; then
    cat >> "/logs/$logfile"
  else
    tee -a "/logs/$logfile"
  fi
}

# Install builder packages
cd /build-deps
echo | log_output 1 install.log
echo '#####  Installing Packages  #####' '' | log_output 1 install.log
find /build-deps -type f \( -name "*.txz" -o -name "*.tgz" -o -name "*.tlz" -o -name "*.tbz" \) | while read -r pkg; do
  echo | log_output 2 install.log
  echo "*** $pkg" | log_output 1 install.log
  installpkg "$pkg" 2>&1 | log_output 2 install.log
done

# Run scripts
echo | log_output 1 scripts.log
echo '#####  Running Scripts  #####' | log_output 1 scripts.log
find /build-deps -type f -name "*.sh" | while read -r script; do
  echo | log_output 2 scripts.log
  echo "*** $script" | log_output 1 scripts.log
  /bin/bash "$script" 2>&1 | log_output 2 scripts.log
done

# Run SlackBuild
cd /slackbuild
echo | log_output 1 build.log
echo '#####  Running SlackBuild  #####' | log_output 1 build.log
find /slackbuild -type f -name "*.SlackBuild" | while read -r sb; do
  echo | log_output 2 build.log
  echo "*** $sb" | log_output 1 build.log
  /bin/bash "$sb" 2>&1 | log_output 2 build.log
  break
done
