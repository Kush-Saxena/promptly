# Skip if PROMPTLY_DISABLE is set
if [[ -n "$PROMPTLY_DISABLE" ]]; then
  return
fi

# SCRIPT_DIR="${0:A:h}"  # zsh-specific way
SCRIPT_DIR="$(dirname "$0")"


scripts_to_load=(
    "$SCRIPT_DIR/scripts/kubectl_completion.sh"  # kubectl autocomplete
    "$SCRIPT_DIR/scripts/common_aliases.sh" #common aliases
    "$SCRIPT_DIR/scripts/stern_completion.sh" #Load stern autocomplete
    "$SCRIPT_DIR/scripts/kubectl_prompt.sh" #Load stern autocomplete
)
echo "Loading custom init scripts"
for script_path in "${scripts_to_load[@]}";do
    # echo "Loading $script_path"
    if [[ -s $script_path ]]; then 
	source $script_path
    else
	echo "Unable to load $script_path"
    fi
done
