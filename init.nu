let vendor_dir = ($nu.vendor-autoload-dirs | last)
mkdir $vendor_dir

# zoxide
if (which zoxide | is-empty) {
  print "⚠️  zoxide not installed — skipping"
  rm --force $"($vendor_dir)/zoxide.nu"
} else {
  zoxide init nushell
    | save --force $"($vendor_dir)/zoxide.nu"
}

# carapace
if (which carapace | is-empty) {
  print "⚠️  carapace not installed — skipping"
  rm --force $"($vendor_dir)/carapace.nu"
} else {
  carapace _carapace nushell
    | save --force $"($vendor_dir)/carapace.nu"
}

# starship
if (which starship | is-empty) {
  print "⚠️  starship not installed — skipping"
  rm --force $"($vendor_dir)/starship.nu"
} else {
  starship init nu
    | save --force $"($vendor_dir)/starship.nu"
}

# fnm
if (which fnm | is-empty) {
  print "⚠️  fnm not installed — skipping"
  rm --force $"($vendor_dir)/fnm.nu"
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

# Calendar URL
print ""
print "Outlook calendar version:"
print "  1. Consumer (outlook.cloud.microsoft)  [default]"
print "  2. Work / School (outlook.office.com)"
let calendar_choice = (input "Choose [1/2]: " | str trim)
let calendar_url = if $calendar_choice == "2" {
  "https://outlook.office.com/calendar/view/week"
} else {
  "https://outlook.cloud.microsoft/calendar/view/week"
}
$"# Calendar URL for waybar clock click set by init.nu\n$env.CALENDAR_URL = \"($calendar_url)\"\n"
  | save --force $"($vendor_dir)/calendar_env.nu"
print $"✔  CALENDAR_URL set to ($calendar_url)"
