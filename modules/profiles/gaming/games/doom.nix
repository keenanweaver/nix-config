{
  flake.modules.homeManager.doom =
    {
      inputs,
      config,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        (writeShellApplication {
          name = "doom-wad-extractor";
          runtimeEnv = {
            IDGAMESARCHIVE_PATH = "/mnt/crusader/Games/Games/Doom/idgames";
            OUTPUT_PATH = "${config.home.homeDirectory}/Games/doom/doom/pwads";
          };
          runtimeInputs = [
            coreutils
            fd
            unzip
          ];
          text = ''
            if [ $# -eq 0 ]; then
                echo "Usage: doom-wad-extractor <search_pattern> [additional_patterns...]"
                echo "Example: doom-wad-extractor 'swtw' 'flotsam'"
                echo ""
                echo "Set IDGAMESARCHIVE_PATH environment variable to override default path"
                echo "Current path: $IDGAMESARCHIVE_PATH"
                exit 1
            fi

            pushd "$IDGAMESARCHIVE_PATH" > /dev/null || exit 1

            echo "Searching for: $*"

            mapfile -t results < <(
                for pattern in "$@"; do
                    fd "$pattern" -e zip -e wad -e pk3
                done | sort -u
            )

            if [ ''${#results[@]} -eq 0 ]; then
                echo "No files found matching: $*"
                popd > /dev/null || exit 1
                exit 1
            fi

            echo -e "\nFound ''${#results[@]} file(s):"
            for i in "''${!results[@]}"; do
                printf "%d) %s\n" $((i+1)) "''${results[$i]}"
            done

            echo -e "\nEnter the numbers to extract (space-separated, e.g., '1 3 5'), 'all' for all files, or press Enter for first result:"
            read -r selection

            if [ -z "$selection" ]; then
                selection="1"
            fi

            mkdir -p "$OUTPUT_PATH"

            if [ "$selection" = "all" ]; then
                selected_indices=("''${!results[@]}")
            else
                read -ra numbers <<< "$selection"
                declare -A seen
                selected_indices=()
                for num in "''${numbers[@]}"; do
                    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ''${#results[@]} ]; then
                        idx=$((num-1))
                        if [ -z "''${seen[$idx]:-}" ]; then
                            selected_indices+=("$idx")
                            seen[$idx]=1
                        fi
                    else
                        echo "Warning: Invalid selection '$num' - skipping"
                    fi
                done
            fi
            if [ ''${#selected_indices[@]} -eq 0 ]; then
                echo "No valid selections made."
            else
                echo -e "\nProcessing ''${#selected_indices[@]} file(s) to $OUTPUT_PATH"
                for idx in "''${selected_indices[@]}"; do
                    file="''${results[$idx]}"
                    filename=$(basename "$file")
                    extension="''${filename##*.}"
                    filename_no_ext="''${filename%.*}"

                    file_lower="''${file,,}"
                    subfolder=""
                    case "$file_lower" in
                        *doom2*) subfolder="doom2" ;;
                        *doom*) subfolder="doom" ;;
                    esac

                    target_dir="$OUTPUT_PATH''${subfolder:+/$subfolder}/$filename_no_ext"
                    mkdir -p "$target_dir"

                    if [[ "$extension" =~ ^(wad|pk3)$ ]]; then
                        echo "Copying: $file"
                        cp "$file" "$target_dir/"
                    else
                        echo "Extracting: $file"
                        unzip -o -d "$target_dir" "$file"

                        for dir in "$target_dir"/*; do
                            if [ -d "$dir" ]; then
                                dir_name=$(basename "$dir")
                                if [ "''${dir_name,,}" = "''${filename_no_ext,,}" ]; then
                                    echo "Flattening nested directory..."
                                    mv "$dir"/* "$target_dir/" 2>/dev/null || true
                                    rmdir "$dir" 2>/dev/null || true
                                    break
                                fi
                            fi
                        done
                    fi
                done
                echo -e "\nWAD is ready!"
            fi

            popd > /dev/null || exit 1
          '';
        })
        chocolate-doom
        crispy-doom
        darkradiant
        doomrunner
        doomseeker
        dsda-doom
        inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.cherry-doom
        inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.nyan-doom
        nugget-doom
        odamex
        slade
        uzdoom
        woof-doom
        zandronum
      ];
    };
}
