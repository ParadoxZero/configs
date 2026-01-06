mkdir ($nu.vendor-autoload-dirs | get 2)
zoxide init nushell | save --force $"($nu.vendor-autoload-dirs | get 2)/zoxide.nu"
carapace _carapace nushell | save --force $"($nu.vendor-autoload-dirs | get 2)/caraspace.nu"
