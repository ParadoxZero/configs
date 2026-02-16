
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
$env.PROMPT_COMMAND_RIGHT = {|| date now | format date "%r" }

# Add any directory to be included in path here
# do not use alias in the path e.g. ~. Add absolute
# paths
let custom_paths = (
if $nu.os-info.name == "linux" {
    [
        ($env.HOME | path join "depot_tools")
        ($env.HOME | path join ".npm-global" "bin")
        ($env.HOME | path join ".cargo" "bin")
        ($env.HOME | path join "go" "bin")
        "/usr/local/go/bin"
        ($env.HOME | path join "path")
        ($env.HOME | path join ".local" "share" "fnm" "aliases" "default" "bin")
        "/opt/bin/"
        ($env.HOME | path join ".local" "bin")
    ]
} else if $nu.os-info.name == "windows" {
  [
    "c:\\Program Files\\LLVM\\bin",
    "C:\\Users\\sidhin\\.local\\bin"
  ]
})

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
