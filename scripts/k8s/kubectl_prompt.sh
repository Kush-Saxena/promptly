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
      print -nP " %F{yellow}[%F{cyan}☸ %F{magenta}$context %F{yellow}: %F{blue}$namespace%F{yellow}]%f"
    else
      print -nP " %F{yellow}[%F{cyan}☸ %F{red}<no-context>%F{yellow}]%f"
    fi
  fi
}

setopt PROMPT_SUBST
PROMPT='%F{green}[%F{cyan}%~%F{green}]%f$(kube_prompt) %F{green}❯%f '


#Modify the PROMPT to whatever way you want to display the information.