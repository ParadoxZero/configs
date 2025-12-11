
#
# Nushell configurations
#
$env.config.show_banner = false
$env.EDITOR = 'nvim'
$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true


## Prompt configuration ##
# $env.PROMPT_COMMAND = {|| }
# When in normal vi mode:
$env.PROMPT_INDICATOR_VI_NORMAL = "↪️: "
# When in vi insert-mode:
$env.PROMPT_INDICATOR_VI_INSERT = "↪️> "
$env.PROMPT_COMMAND_RIGHT = {|| date now | format date "%r" }

# Custom prompt 
# Abbrevate $home to ~
# Append git branch if exists
def create-prompt [] {
    mut current = $env.PWD
    if $current == $nu.home-path {
      $current = "~"
    } else if ($current | str starts-with $nu.home-path) {
      $current = $current | path relative-to $nu.home-path
      $current = $"~/($current)"
    } 

    let current = $"\e[1m($current)(ansi reset)"

   let prompt = try {
          let b = (git rev-parse --abbrev-ref HEAD err> /dev/null)
          $"($current) [($b | str trim)]\n"
        } catch {
          $"($current)\n" 
        }
  $prompt
}

$env.PROMPT_COMMAND = { create-prompt }


# Add any directory to be included in path here
# do not use alias in the path e.g. ~. Add absolute
# paths

mut custom_paths = []
if $nu.os-info.name == "linux" {
  $custom_paths = ($custom_paths | append [
    "/home/sidhin/depot_tools",
    "/home/sidhin/.npm-global/bin/",
    "/home/sidhin/.cargo/bin",
    "/home/sidhin/path",
    "/home/sidhin/.local/share/fnm/aliases/default/bin"
  ])
}

$env.PATH = ($custom_paths | append $env.PATH ) 

source ./variables.nu
source ./git.nu
source ./third_party.nu

echo "⚡Nushell environment ready ...☑️"
