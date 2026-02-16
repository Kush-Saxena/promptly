# Promptly

A collection of shell scripts for configuring a zsh development environment with Kubernetes tooling and other useful aliases.

## Why Promptly?

Promptly was built with a clear philosophy: **keep it simple, keep it light**.

Instead of pulling in full-fledged frameworks like oh-my-zsh or heavyweight plugin managers that come bundled with hundreds of features you may never use, Promptly takes a minimal approach. Each script is a standalone, readable shell file that does one thing well. 
Also, keeping all custom installed scripts/plugins inside Promptly makes it easier to plug-and-play things and also keeps `.zshrc` cleaner.

- **No framework dependencies** just plain shell scripts that are easy to read, modify, and debug.
- **Fast shell startup** only the scripts you need are sourced, with no plugin resolution overhead.
- **Full transparency** every alias, completion, and prompt tweak lives in a file you can open and understand in minutes.

The trade-off is intentional: the feature set is narrower than a full framework, but the code stays small, predictable, and entirely under your control.

## Directory Structure

```
scripts/
├── core/
│   └── load_my_scripts.sh    # Entry point loader
├── k8s/
│   ├── kubectl_aliases.sh    # Kubectl shorthand aliases
│   ├── kubectl_completion.sh # Kubectl zsh completion
│   └── kubectl_prompt.sh     # Kubernetes-aware prompt
└── misc/
    └── stern_completion.sh   # Stern zsh completion
```

## Trying out the setup

For trying out the setup. Source the loader script from your `.zshrc`:

```sh
source /path/to/promptly/scripts/core/load_my_scripts.sh
```

## Installation

For installing it to start up everytime with ZSH:

```sh
echo "\nsource /path/to/promptly/scripts/core/load_my_scripts.sh" >> ~/.zshrc
```

This will automatically load all the other scripts listed below.

## Scripts

### `scripts/core/load_my_scripts.sh`

Entry point that sources all other scripts in order. It iterates over a list of script paths, checks each exists and is non-empty, and sources it.
You can Set `PROMPTLY_DISABLE=1` to skip loading all of Promptly entirely without removing it from your `.zshrc`.

### `scripts/k8s/kubectl_aliases.sh`

Kubectl aliases extracted from the [oh-my-zsh kubectl plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl) with minor custom changes.
Provides short aliases for common kubectl operations:

| Category | Examples |
|---|---|
| General | `k` (kubectl), `kaf` (apply -f), `kdel` (delete) |
| Context | `kcuc` (use-context), `kcgc` (get-contexts), `kccc` (current-context) |
| Pods | `kgp` (get pods), `kdp` (describe), `kdelp` (delete), `kgpa` (all namespaces) |
| Deployments | `kgd` (get), `ked` (edit), `ksd` (scale), `krrd` (rollout restart) |
| Services | `kgs` (get svc), `kds` (describe svc) |
| Logs | `kl` (logs), `klf` (logs -f), `kl1h` (logs since 1h) |
| Namespaces | `kgns` (get ns), `kcn` (set current namespace) |
| Nodes | `kgno` (get nodes), `kdno` (describe node) |
| Output | `kj` (json + jq), `kjx` (json + fx), `kyq` (yaml + yq) |


### `scripts/k8s/kubectl_completion.sh`

Zsh tab-completion for `kubectl`. Generated from `kubectl completion zsh`. Licensed under Apache 2.0 by The Kubernetes Authors.

### `scripts/misc/stern_completion.sh`

Zsh tab-completion for [stern](https://github.com/stern/stern) (multi-pod log tailing tool). Generated from `stern --completion zsh`.

### `scripts/k8s/kubectl_prompt.sh`

Customizes the zsh prompt to display the current Kubernetes context and namespace. The prompt format is:

```
~/current/dir ~<k8s>~ context-name:namespace >
```

Set `PROMPTLY_DISABLE_KUBE_PROMPT=1` to hide the Kubernetes info from the prompt.

## Disabling Individual Scripts

Every script supports a `PROMPTLY_` prefixed environment variable that lets you skip loading it entirely. Set any of the following in your `.zshrc` **before** sourcing `load_my_scripts.sh`:

| Environment Variable | Script it disables |
|---|---|
| `PROMPTLY_DISABLE` | `load_my_scripts.sh` (disables all of Promptly) |
| `PROMPTLY_DISABLE_COMMON_ALIASES` | `kubectl_aliases.sh` |
| `PROMPTLY_DISABLE_KUBECTL_COMPLETION` | `kubectl_completion.sh` |
| `PROMPTLY_DISABLE_STERN_COMPLETION` | `stern_completion.sh` |
| `PROMPTLY_DISABLE_KUBE_PROMPT` | `kubectl_prompt.sh` |

Example disable stern completion:

```sh
export PROMPTLY_DISABLE_STERN_COMPLETION=1
source /path/to/promptly/scripts/core/load_my_scripts.sh
```

## Reporting Issues

If you run into a bug, unexpected behaviour, or something that just feels off, please open an issue on the repository. When filing an issue, it helps to include:

- The shell and OS you are using (e.g. zsh 5.9 on macOS Sonoma).
- The script that is causing the problem.
- Steps to reproduce the issue, or the error output you are seeing.

Every report big or small helps make Promptly better.

## Contributing

Contributions are welcome! If you have a script or alias set that you find useful in your day-to-day workflow, consider adding it to Promptly. To keep the project consistent, please follow the checklist below when submitting a pull request.

### How to contribute

1. **Fork** the repository and create a new branch for your feature.

2. **Add your script** create a new `.sh` file in the appropriate subdirectory under `scripts/` (e.g. `scripts/k8s/` for Kubernetes-related scripts, `scripts/misc/` for other tools).

3. **Add a disable switch** at the top of your script, add an early-return guard using a `PROMPTLY_` prefixed environment variable so users can opt out of loading it. Follow the existing convention:

   ```sh
   # Skip if PROMPTLY_DISABLE_YOUR_SCRIPT is set
   if [[ -n "$PROMPTLY_DISABLE_YOUR_SCRIPT" ]]; then
     return
   fi
   ```

4. **Register the script in `load_my_scripts.sh`** add your script's path to the `scripts_to_load` array so it gets sourced automatically:

   ```sh
   scripts_to_load=(
       # ... existing entries ...
       "$SCRIPTS_DIR/<category>/your_script.sh"  # Short description of what it does
   )
   ```

5. **Document your script in this README** add a new subsection under [Scripts](#scripts) explaining:
   - **What** the script does.
   - **Why** it exists (the problem it solves or the workflow it improves).
   - Any notable aliases, functions, or configuration it provides.
   - The `PROMPTLY_DISABLE_*` variable that disables it.

   Also add the new environment variable to the table in the [Disabling Individual Scripts](#disabling-individual-scripts) section.

6. **Open a pull request** with a clear description of your changes and the motivation behind them.

### PR Checklist

Before submitting your pull request, make sure you have completed all of the following:

- [ ] Make sure the `.sh` file has a single, focused responsibility.
- [ ] Added a `PROMPTLY_DISABLE_*` environment variable guard at the top of the script.
- [ ] Verified the disable switch works (`export PROMPTLY_DISABLE_YOUR_SCRIPT=1` skips loading).
- [ ] Added the script path to the `scripts_to_load` array in `load_my_scripts.sh`.
- [ ] Added a section in this README under [Scripts](#scripts) explaining what the script does and why.
- [ ] Added the new `PROMPTLY_DISABLE_*` variable to the [Disabling Individual Scripts](#disabling-individual-scripts) table.
- [ ] Tested that the script sources cleanly in a fresh zsh session without errors.
- [ ] Confirmed the script is safe to source multiple times without side effects. (idempotent) 

### Guidelines

- Keep scripts **simple and lightweight**.
- Avoid adding dependencies beyond standard CLI tools.
- Make sure your script is safe to source multiple times without side effects.
- Test that the disable switch works correctly before submitting.
