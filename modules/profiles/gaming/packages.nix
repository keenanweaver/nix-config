{
  pkgs,
  inputs,
  config,
  ...
}:
with pkgs;
{
  games = [
    ## Doom
    acc
    inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.cherry-doom
    chocolate-doom
    crispy-doom
    darkradiant
    doomrunner
    doomseeker
    dsda-doom
    nugget-doom
    inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.nyan-doom
    odamex
    slade
    uzdoom
    woof-doom
    zandronum
    ## Fallout
    fallout-ce
    fallout2-ce
    ## Freespace
    descent3
    dxx-rebirth
    knossosnet
    ## HOMM
    fheroes2
    vcmi
    ## Morrowind
    inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.openmw-validator
    tes3cmd
    openmw
    ## Quake
    ironwail
    quake-injector
    ## Arma
    arma3-unix-launcher
    # (arma3-unix-launcher.override { buildDayZLauncher = true; })
    ## Duke
    rigel-engine
    ## Wolf
    bstone
    ecwolf
    etlegacy
    ## Other
    abuse
    arx-libertatis # Arx Fatalis
    augustus # Caesar 3
    bolt-launcher # RuneScape
    corsix-th # Theme Hospital
    gamma-launcher
    isle-portable
    jazz2
    #katawa-shoujo-re-engineered
    openjk # Jedi Academy
    openloco
    openomf
    openrct2
    openttd
    opentyrian
    openxcom
    openxray # STALKER
    relive # Oddworld
    rsdkv3
    # inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.rsi-launcher-umu
    sdlpop # Prince of Persia
    #serious-sam-classic-vulkan
    sm64ex
    theforceengine # Dark Forces / Outlaws
    urbanterror
    vvvvvv
    wipeout-rewrite
    yarg
    zelda64recomp
  ];
  tools = [
    ## Emulators
    _86box-with-roms
    # archipelago
    # bizhawk
    dosbox-staging
    easyrpg-player
    hypseus-singe
    mednafen
    mednaffe
    mesen
    nuked-sc55
    scummvm
    shadps4
    inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.sheepshaver-bin
    xenia-canary
    ## Input
    joystickwake
    oversteer
    sc-controller
    ## Launchers & utils
    faugus-launcher
    goverlay
    ## Modding
    hedgemodmanager
    limo
    inputs.just-one-more-repo.packages.${stdenv.hostPlatform.system}.r2modman
    ## Other
    adwsteamgtk
    chiaki-ng
    flips
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gswatcher
    igir
    innoextract
    lgogdownloader
    python314Packages.lnkparse3
    parsec-bin
    protonplus
    tochd
    xlink-kai
    xvidcore
    ## Wine
    umu-launcher
    inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.winegui
    inputs.nix-gaming.packages.${stdenv.hostPlatform.system}.wine-tkg
    winetricks
    ## One-and-dones
    /*
      inputs.aaru.packages.${stdenv.hostPlatform.system}.default
         inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.dic-git-full
         glxinfo
         jpsxdec
         mame.tools
         mmv
         inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.ndecrypt-git
         nsz
         inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.sabretools-git
         inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.unshieldsharp-git
         openspeedrun
         ps3-disc-dumper
         inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.redumper-git
         renderdoc
         vgmplay-libvgm
         vgmstream
         vgmtools
         vgmtrans
         vulkan-tools
    */
  ];
  scripts = [
    (writeShellApplication {
      name = "doom-wad-extractor";
      runtimeInputs = [
        fd
        unzip
      ];
      runtimeEnv = {
        IDGAMESARCHIVE_PATH = "/mnt/crusader/Games/Games/Doom/idgames";
        OUTPUT_PATH = "${config.home.homeDirectory}/Games/doom/doom/pwads";
      };
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
    (writeShellApplication {
      name = "script-exodos-nuked";
      runtimeEnv = {
        EXODOS = "/mnt/crusader/Games/eXo/eXoDOS/eXo/eXoDOS";
      };
      runtimeInputs = [
        fd
        sd
      ];
      text = ''
        fd -t file "run.bat" $EXODOS -x sd 'CONFIG -set "mididevice=fluidsynth"' 'CONFIG -set "mididevice=soundcanvas"' {}
      '';
    })
    (writeShellApplication {
      name = "script-game-stuff";
      runtimeEnv = {
        DREAMM = "https://aarongiles.com/dreamm/releases/dreamm-3.0.3-linux-x64.tgz";
        CONTY = "https://api.github.com/repos/Kron4ek/conty/releases/latest";
        GAMES_DIR = "${config.home.homeDirectory}/Games";
        LOCAL_BIN = "${config.home.homeDirectory}/.local/bin";
      };
      runtimeInputs = [
        coreutils
        curl
        fd
        jq
        wget
      ];
      text = ''
        ## DREAMM
        wget -P "$GAMES_DIR"/dreamm $DREAMM
        fd dreamm -e tgz "$GAMES_DIR"/dreamm -x tar xf {} -c "$GAMES_DIR"/dreamm
        ## Conty
        curl $CONTY | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | xargs wget -P "$LOCAL_BIN"
        chmod +x "$LOCAL_BIN"/conty_lite.sh
      '';
    })
    (writeShellApplication {
      name = "script-momw-update";
      runtimeEnv = {
        MODLIST = "i-heart-vanilla-directors-cut";
      };
      runtimeInputs = [
        inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.momw-configurator
        inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.openmw-validator
        inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.umo
        tes3cmd
      ];
      text = ''
        umo sync "$MODLIST"
        umo install "$MODLIST"
        momw-configurator config "$MODLIST" --run-navmeshtool --run-validator
        umo vacuum
      '';
    })
  ];
}
