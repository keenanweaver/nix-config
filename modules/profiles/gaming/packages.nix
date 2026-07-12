{
  flake.modules = {
    homeManager.gaming-profile =
      {
        config,
        pkgs,
        inputs,
        ...
      }:
      {
        home.packages = with pkgs; [
          local.game-wrapper
          easyrpg-player
          faugus-launcher
          goverlay
          oversteer
          protonplus
          inputs.rom-properties.packages.${stdenv.hostPlatform.system}.rp_kde6
          sc-controller
          umu-launcher
          inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.winegui
          inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.wine-tkg
          winetricks
          (writeShellApplication {
            name = "doom-wad-extractor";
            runtimeEnv = {
              IDGAMESARCHIVE_PATH = "/mnt/crusader/Games/Games/Doom/idgames";
              OUTPUT_PATH = "${config.home.homeDirectory}/Games/doom/doom/pwads";
            };
            runtimeInputs = [
              fd
              unzip
            ];
            text = ''
              # Check if search pattern was provided
              if [ $# -eq 0 ]; then
                  echo "Usage: doom-wad-extractor <search_pattern> [additional_patterns...]"
                  echo "Example: doom-wad-extractor 'swtw' 'flotsam'"
                  echo ""
                  echo "Set IDGAMESARCHIVE_PATH environment variable to override default path"
                  echo "Current path: $IDGAMESARCHIVE_PATH"
                  exit 1
              fi

              # Push to the idgames directory
              pushd "$IDGAMESARCHIVE_PATH" > /dev/null || exit 1

              # Run fd with all provided arguments, filtering for archive files
              echo "Searching for: $*"

              # Combine all results from multiple fd searches
              all_results=()
              for pattern in "$@"; do
                  while IFS= read -r line; do
                      all_results+=("$line")
                  done < <(fd "$pattern" -e zip -e wad -e pk3)
              done

              # Remove duplicates and sort
              mapfile -t results < <(printf '%s\n' "''${all_results[@]}" | sort -u)

              # Check if any results were found
              if [ ''${#results[@]} -eq 0 ]; then
                  echo "No files found matching: $1"
                  popd > /dev/null || exit 1
                  exit 1
              fi

              # Display results with numbers
              echo -e "\nFound ''${#results[@]} file(s):"
              for i in "''${!results[@]}"; do
                  printf "%d) %s\n" $((i+1)) "''${results[$i]}"
              done

              # Get user selection
              echo -e "\nEnter the numbers to extract (space-separated, e.g., '1 3 5'), 'all' for all files, or press Enter for first result:"
              read -r selection

              # Default to first result if empty
              if [ -z "$selection" ]; then
                  selection="1"
              fi

              # Create output directory if it doesn't exist
              mkdir -p "$OUTPUT_PATH"

              # Process selection
              if [ "$selection" = "all" ]; then
                  selected_indices=("''${!results[@]}")
              else
                  # Parse space-separated numbers
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
              # Extract selected files
              if [ ''${#selected_indices[@]} -eq 0 ]; then
                  echo "No valid selections made."
              else
                  echo -e "\nProcessing ''${#selected_indices[@]} file(s) to $OUTPUT_PATH"
                  for idx in "''${selected_indices[@]}"; do
                      file="''${results[$idx]}"
                      filename=$(basename "$file")
                      extension="''${filename##*.}"
                      filename_no_ext="''${filename%.*}"

                      # Determine subfolder based on path
                      subfolder=""
                      file_lower=$(echo "$file" | tr '[:upper:]' '[:lower:]')
                      if [[ "$file_lower" == *"doom2"* ]]; then
                          subfolder="doom2"
                      elif [[ "$file_lower" == *"doom"* ]]; then
                          subfolder="doom"
                      fi

                      if [ -n "$subfolder" ]; then
                          target_dir="$OUTPUT_PATH/$subfolder/$filename_no_ext"
                      else
                          target_dir="$OUTPUT_PATH/$filename_no_ext"
                      fi

                      if [[ "$extension" =~ ^(wad|pk3)$ ]]; then
                          echo "Copying: $file"
                          mkdir -p "$target_dir"
                          cp "$file" "$target_dir/"
                      else
                          echo "Extracting: $file"
                          mkdir -p "$target_dir"
                          unzip -o -d "$target_dir" "$file"

                          # Check if there's a single directory with the same name (case-insensitive)
                          shopt -s nocasematch
                          for dir in "$target_dir"/*; do
                              if [ -d "$dir" ]; then
                                  dir_name=$(basename "$dir")
                                  if [[ "$dir_name" == "$filename_no_ext" ]]; then
                                      echo "Flattening nested directory..."
                                      # Move contents up one level
                                      mv "$dir"/* "$target_dir/" 2>/dev/null || true
                                      # Remove the now-empty directory
                                      rmdir "$dir" 2>/dev/null || true
                                      break
                                  fi
                              fi
                          done
                          shopt -u nocasematch
                      fi
                  done
                  echo -e "\nProcessing complete!"
              fi

              # Pop back to original directory
              popd > /dev/null || exit 1
            '';
          })
        ];
      };
    nixos.gaming-profile = {
      programs = {
        gsr = {
          enable = true;
          ui.enable = true;
        };
      };
    };
  };
}
