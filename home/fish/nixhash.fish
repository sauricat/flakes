set -g hash_abbrs \
    nrn  "nix run nixpkgs#" \
    nsn  "nix shell nixpkgs#" \
    nbn  "nix build nixpkgs#" \
    ndn  "nix develop nixpkgs#" \
    nrp  "nix run path:.#" \
    nsp  "nix shell path:.#" \
    nbp  "nix build path:.#" \
    ndp  "nix develop path:.#"


function expand_on_hash
    set -l token (commandline -pt)
    set -l index (contains -i -- "$token" $hash_abbrs)

    if test -n "$index"
        set -l value_index (math $index + 1)
        commandline -rt $hash_abbrs[$value_index]
    else
        commandline -i "#"
    end
end

function fish_user_key_bindings
    bind \# expand_on_hash
end
