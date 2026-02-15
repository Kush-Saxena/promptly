kube_prompt() {
  # Skip if PROMPTLY_DISABLE_KUBE_PROMPT is set
  if [[ -n "$PROMPTLY_DISABLE_KUBE_PROMPT" ]]; then
    return
  fi

  if command -v kubectl &> /dev/null; then
    local context=$(kubectl config current-context 2>/dev/null)
    local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    
    if [[ -n "$context" ]]; then
      namespace=${namespace:-default}
      echo " ~<k8s>~ $context:$namespace"
    else
      echo " ~<k8s> <no-context>"
    fi
  fi
}

setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f$(kube_prompt) %F{green}❯%f '


#Modify the PROMPT to whatever way you want to display the information.