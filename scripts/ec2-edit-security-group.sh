#!/bin/bash
# this script is simply a placeholder. it downloads and runs the script from gist.github.com/savishy.
# reference: http://max.disposia.org/notes/bash-exec-gist.html
# https://gist.github.com/atenni/5604615

raw_gist_path=https://gist.github.com/savishy/f898534420127da0f14cebcda89c68cd/raw/ec2-cli-cleanup-group.sh

# TODO for some reason, $0 also needs to be passed. why?
echo "-- please wait, downloading script"
bash -c "$(curl -fsSL $raw_gist_path)" $0 $1 $2
