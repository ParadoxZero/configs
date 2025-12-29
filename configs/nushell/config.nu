
#
# Nushell configurations
#
$env.config.show_banner = false
$env.EDITOR = 'nvim'
$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

let cursor_shape = {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: blink_line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }
$env.config.cursor_shape = $cursor_shape


## Prompt configuration ##
# $env.PROMPT_COMMAND = {|| }
# When in normal vi mode:
# $env.PROMPT_INDICATOR_VI_NORMAL = "↪️: "
# When in vi insert-mode:
# $env.PROMPT_INDICATOR_VI_INSERT = "↪️> "
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

# $env.PROMPT_COMMAND = { create-prompt }


# Add any directory to be included in path here
# do not use alias in the path e.g. ~. Add absolute
# paths
mut custom_paths = []
if $nu.os-info.name == "linux" {
  $custom_paths = ($custom_paths | append [
    "/home/sidhin/depot_tools",
    "/home/sidhin/.npm-global/bin/",
    "/home/sidhin/.cargo/bin",
    "/usr/local/go/bin",
    "/home/sidhin/path",
    "/home/sidhin/.local/share/fnm/aliases/default/bin",
    "/opt/bin/",
    "/home/sidhin/.local/bin/",
  ])
} else if $nu.os-info.name == "windows" {
  $custom_paths = ($custom_paths | append [
    "c:\\Program Files\\LLVM\\bin"
  ])
}

$env.PATH = ($custom_paths | append $env.PATH ) 

source ./variables.nu
source ./git.nu
source ./third_party.nu
source ./private.nu

const plat_file = if ($nu.os-info.name == "linux") { 
  "./ubuntu_alias.nu" 
} else if ($nu.os-info.name == "macos") { 
  "./macos_alias.nu"
} else { 
  "./windows_alias.nu" 
}
source $plat_file

echo "⚡Nushell environment ready ...☑️"
