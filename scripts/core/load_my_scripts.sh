# Skip if PROMPTLY_DISABLE is set
if [[ -n "$PROMPTLY_DISABLE" ]]; then
  return
fi

SCRIPTS_DIR="${0:A:h}/.."

scripts_to_load=(
    #k8s
    "$SCRIPTS_DIR/k8s/kubectl_completion.sh"  # kubectl autocomplete
    "$SCRIPTS_DIR/k8s/kubectl_aliases.sh"     # kubectl aliases
    "$SCRIPTS_DIR/k8s/kubectl_prompt.sh"      # kubectl prompt

    #misc
    "$SCRIPTS_DIR/misc/stern_completion.sh"   # stern autocomplete
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
