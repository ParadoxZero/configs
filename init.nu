let vendor_dir = ($nu.vendor-autoload-dirs | last)
mkdir $vendor_dir

# zoxide
if (which zoxide | is-empty) {
  print "⚠️  zoxide not installed — skipping"
} else {
  zoxide init nushell
    | save --force $"($vendor_dir)/zoxide.nu"
}

# carapace
if (which carapace | is-empty) {
  print "⚠️  carapace not installed — skipping"
} else {
  carapace _carapace nushell
    | save --force $"($vendor_dir)/carapace.nu"
}

# starship
if (which starship | is-empty) {
  print "⚠️  starship not installed — skipping"
} else {
  starship init nu
    | save --force $"($vendor_dir)/starship.nu"
}

# fnm
if (which fnm | is-empty) {
  print "⚠️  fnm not installed — skipping"
} else {
  echo "
$env.PATH = (
  $env.PATH
    | append (fnm env --json
      | from json
      | get FNM_MULTISHELL_PATH)
)
" | save --force $"($vendor_dir)/fnm.nu"
}
