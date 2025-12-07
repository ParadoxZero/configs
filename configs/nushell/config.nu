
#
# Nushell configurations
#
$env.config.show_banner = false
$env.EDITOR = 'nvim'
$env.config.edit_mode = 'vi'

# Add any directory to be included in path here
# do not use alias in the path e.g. ~. Add absolute
# paths
let custom_paths = [
  "/home/sidhin/depot_tools",
  "/home/sidhin/.npm-global/bin/",
  "/home/sidhin/.cargo/bin",
  "/home/sidhin/path",
  "/home/sidhin/.local/share/fnm/aliases/default/bin"
]

$env.PATH = ($custom_paths | append $env.PATH ) 

source ./variables.nu
source ./git.nu
source ./third_party.nu

echo "⚡Sidhin's environment initialized ...☑️"
