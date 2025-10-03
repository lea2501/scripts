#!/bin/sh
set +x

function show_usage {
    printf "Usage: %s [options [parameters]]\n" "$0"
    printf "\n"
    printf "Options:\n"
    printf " -u|--url           [file download url]\n"
    printf " -f|--file          [file name already downloaded in /tmp directory]\n"
    printf " -n|--name          [directory name]\n"
    printf " -i|--iwad          [doom|doom2|tnt|plutonia|heretic|hexen]\n"
    printf " -e|--engine        [vanilla|nolimit|boom|mbf21|zdoom]\n"
    printf "\n"
    printf " -h|--help, Print help\n"
exit
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ];then
	show_usage
fi
if [ -z "$1" ]; then
	show_usage
fi

while [ -n "$1" ]; do
  case "$1" in
     --url|-u)
        shift
        echo "INFO: download url: $1"
        param_download_url=$1
        ;;
     --file|-f)
        shift
        echo "INFO: already downloaded file name: $1"
        param_already_downloaded_file_name=$1
        ;;
     --name|-n)
        shift
        echo "INFO: map name: $1"
        param_map_name=$1
        ;;
     --game|-i)
        shift
        echo "INFO: iwad: $1"
        param_iwad=$1
        ;;
     --engine|-e)
        shift
        echo "INFO: engine: $1"
        param_engine=$1
        ;;
     *)
        show_usage
        ;;
  esac
shift
done

### Configuration
if [ -z "$param_download_url" ] && [ -z "$param_already_downloaded_file_name" ]; then
	show_usage
fi
if [ -z "$param_map_name" ]; then
	show_usage
fi
if [ -z "$param_iwad" ]; then
	show_usage
fi
if [ -z "$param_engine" ]; then
	show_usage
fi
config_base_dir=$HOME/games/doom
config_download_file_path=$config_base_dir/maps/$param_iwad/$param_engine/$param_map_name

### check parameter values
doom_game="doom doom2 tnt plutonia heretic hexen"
echo "$doom_game" | tr ' ' '\n' | while read -r item; do
	if [ "$item" = "$param_iwad" ]; then touch match; fi
done
if [ ! -f match ]; then echo "ERROR: $param_iwad is not a valid option, valid options are: $doom_game"; exit 1; fi; rm match

engine="vanilla nolimit boom mbf21 zdoom"
echo "$engine" | tr ' ' '\n' | while read -r item; do
	if [ "$item" = "$param_engine" ]; then touch match; fi
done
if [ ! -f match ]; then echo "ERROR: $param_engine is not a valid option, valid options are: $engine"; exit 1; fi; rm match


### Script
if [ -d $config_download_file_path ]; then
	echo "WARNING: map directory $config_download_file_path already exists"
	ls -lahF $config_download_file_path
	exit 0
fi

if [ ! -f /tmp/$param_already_downloaded_file_name ] && [ -z "$param_download_url" ]; then
	cd /tmp || return
	curl -OL "$param_download_url"
	echo "INFO: file downloaded to $config_download_file_path directory"
fi

if [ -f /tmp/$param_download_url ]; then
	cd || return
	mkdir -p $config_download_file_path
	cd $config_download_file_path
	cp -v /tmp/$param_download_url .
	ls -lahF $config_download_file_path
	echo "INFO: file moved to $config_download_file_path directory"
fi
