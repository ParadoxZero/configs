let vendor_dir = $nu.vendor-autoload-dirs | last
mkdir $vendor_dir
zoxide init nushell | save --force $"($vendor_dir)/zoxide.nu"
carapace _carapace nushell | save --force $"($vendor_dir)/caraspace.nu"
