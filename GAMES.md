# Setting up games

This is to quickly set up games for nix, Flatpak, and distrobox that require extra data files.

## From bare-metal
1. Run `script-game-stuff`

## Set up directories
``` bash
    mkdir -p /home/keenan/Games/{daikatana,descent/descent-1,descent/descent-2,quake/quake-1,quake/quake-3,rollercoaster-tycoon,morrowind,blake-stone/aog,blake-stone/ps,jagged-alliance-2/ja2,jagged-alliance-2/unfinished-business,jagged-alliance-2/wildfire,loco,the-force-engine,arx-fatalis}
    mkdir -p /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2
    mkdir -p /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/{serioussam,serioussamse}
```

## Set up games

``` bash
    ## Arx Fatalis
    , innoextract -g '/mnt/crusader/Games/Other/GOG/arx_fatalis/setup_arx_fatalis_1.22_(38577).exe' -d /home/keenan/Games/arx-fatalis
    ## Blake Stone
    , innoextract -g '/mnt/crusader/Games/Other/Zoom/Blake-Stone-Aliens-of-Gold-English-Setup-1.1.exe' -d /home/keenan/Games/blake-stone/aog && mv /home/keenan/Games/blake-stone/aog/app/* /home/keenan/Games/blake-stone/aog
    xh get -d -o /home/keenan/Games/blake-stone/aog/bse90.zip https://bibendovsky.github.io/bstone/files/community/aog/bse90.zip
    xh get -d -o /home/keenan/Games/blake-stone/aog/guystone.zip https://bibendovsky.github.io/bstone/files/community/aog/guystone.zip
    xh get -d -o /home/keenan/Games/blake-stone/aog/lingstone.zip https://bibendovsky.github.io/bstone/files/community/aog/lingstone.zip
    fd . -e zip /home/keenan/Games/blake-stone/aog -x ouch d {} -d /home/keenan/Games/blake-stone/aog
    , innoextract -g '/mnt/crusader/Games/Other/Zoom/Blake-Stone-Planet-Strike-English-Setup-1.1.exe' -d /home/keenan/Games/blake-stone/ps && mv /home/keenan/Games/blake-stone/ps/app/* /home/keenan/Games/blake-stone/ps
    xh get -d -o /home/keenan/Games/blake-stone/ps/bse24.zip https://bibendovsky.github.io/bstone/files/community/ps/bse24.zip
    xh get -d -o /home/keenan/Games/blake-stone/ps/guystrike.zip https://bibendovsky.github.io/bstone/files/community/ps/guystrike.zip
    xh get -d -o /home/keenan/Games/blake-stone/ps/lingstrike.zip https://bibendovsky.github.io/bstone/files/community/ps/lingstrike.zip
    fd . -e zip /home/keenan/Games/blake-stone/ps -x ouch d {} -d /home/keenan/Games/blake-stone/ps
    ## Caesar 3
    , innoextract -g '/mnt/crusader/Games/Other/GOG/caesar_3/setup_caesartm_3_1.0.1.0_(76354).exe' -d /home/keenan/Games/caesar-3 && mv /home/keenan/Games/caesar-3/app/* /home/keenan/Games/caesar-3 && rm -rf /home/keenan/Games/caesar-3/{app,tmp}
    ## Daikatana
    , innoextract -g '/mnt/crusader/Games/Other/GOG/daikatana/setup_daikatana_1.0_(22142).exe' -d /home/keenan/Games/daikatana
    wget -nc https://bitbucket.org/daikatana13/daikatana/downloads/Daikatana-Linux-2023-08-17-x64.tar.bz2 -P /home/keenan/Games/daikatana
    wget -nc https://bitbucket.org/daikatana13/daikatana/downloads/pak6-2022-12-22.zip -P /home/keenan/Games/daikatana
    ## Dark Forces
    , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_dark_forces/setup_star_warstm_dark_forces_1.0.2_(20338).exe' -d /home/keenan/Games/the-force-engine/df
    , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_dark_forces_ii_copy3/setup_star_wars_jedi_knight_-_mysteries_of_the_sith_1.0_(17966).exe' -d /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2 && mv /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2/app/* /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2 && , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_republic_commando_copy3/setup_star_wars_jedi_knight_-_dark_forces_2_1.01_(17966).exe' -d /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots && mv /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots/app/* /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots
    ## Descent
    , innoextract -g '/mnt/crusader/Games/Other/GOG/descent/setup_descent_1.4a_(16596).exe' -d /home/keenan/Games/descent/descent-1 && mv /home/keenan/Games/descent/descent-1/app/* /home/keenan/Games/descent/descent-1 && rm -rf /home/keenan/Games/descent/descent-1/{app,tmp}
    , innoextract -g '/mnt/crusader/Games/Other/GOG/descent_2/setup_descent_2_1.1_(16596).exe' -d /home/keenan/Games/descent/descent-2 && mv /home/keenan/Games/descent/descent-2/app/* /home/keenan/Games/descent/descent-2 && rm -rf /home/keenan/Games/descent/descent-2/{app,tmp}
    , innoextract -g '/mnt/crusader/Games/Other/GOG/descent_3_expansion/setup_descent_3_1.4_(16598).exe' -d /home/keenan/Games/descent/descent-3 && mv /home/keenan/Games/descent/descent-3/app/* /home/keenan/Games/descent/descent-3 && rm -rf /home/keenan/Games/descent/descent-3/{app,tmp}
    ## Diablo
    , innoextract -g '/mnt/crusader/Games/Other/GOG/diablo/setup_diablo_1.09_hellfire_v2_(30037).exe' -I 'DIABDAT.MPQ' -I 'hellfire.mpq' -I 'hfmonk.mpq' -I 'hfmusic.mpq' -I 'hfvoice.mpq' -d /home/keenan/.local/share/diasurgical/devilution && mv /home/keenan/.local/share/diasurgical/devilution/hellfire/* /home/keenan/.local/share/diasurgical/devilution && rm -rf /home/keenan/.local/share/diasurgical/devilution/hellfire
    ## Doom 3
    , innoextract -g '/mnt/crusader/Games/Other/GOG/doom_3_classic/setup_doom_3_1.3.1_(62814).exe' -d '/home/keenan/Games/doom/doom-3'
    , innoextract -g '/mnt/crusader/Games/Other/GOG/doom_3_bfg_edition_game/setup_doom_3_bfg_1.14_(13452).exe' -d /home/keenan/Games/doom/doom-3-bfg && mv /home/keenan/Games/doom/doom-3-bfg/app/* /home/keenan/Games/doom/doom-3-bfg && rm -rf /home/keenan/Games/doom/doom-3-bfg/{tmp,app}
    xh https://api.github.com/repos/RobertBeckebans/RBDOOM-3-BFG/releases/latest | jq -r '.assets[] | select(.name | test("lite")).browser_download_url' | xargs xh get -d -o /home/keenan/Games/doom/doom-3-bfg/rbdoom3bfg.7z
    fd . -e 7z /home/keenan/Games/doom/doom-3-bfg -x ouch d {} -y -d /home/keenan/Games/doom/doom-3-bfg && cp -r /home/keenan/Games/doom/doom-3-bfg/rbdoom3bfg/* /home/keenan/Games/doom/doom-3-bfg && rm -rf /home/keenan/Games/doom/doom-3-bfg/rbdoom3bfg /home/keenan/Games/doom/doom-3-bfg.7z
    ## DOOM 64
    , innoextract -g '/mnt/crusader/Games/Other/GOG/doom_64/setup_doom_64_20220523_(56385).exe' -I 'DOOM64.WAD' -d '/home/keenan/.local/share/doom64ex-plus'
    ## Fallout
    , innoextract -g '/mnt/crusader/Games/Other/GOG/fallout_game/setup_fallout_1.2_(27130).exe' -d /home/keenan/.local/share/fallout-ce && cd /home/keenan/.local/share/fallout-ce && rm -rf __redist __support app commonappdata Extras tmp goggame* && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }' && cd /home/keenan/.local/share/fallout-ce/data/sound/music && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToUpper()) { ren $_.FullName $_.Name.ToUpper() } }' && gamescope -f -w 2560 -h 1440 -- fallout-ce && sleep 3 && sd 'music_path1=sound\\music\\' 'music_path1=data\\sound\\music\\' /home/keenan/.local/share/fallout-ce/fallout.cfg && sd 'music_path2=sound\\music\\' 'music_path2=data\\sound\\music\\' /home/keenan/.local/share/fallout-ce/fallout.cfg
    , innoextract -g /mnt/crusader/Games/Other/GOG/fallout_2_game/setup_fallout2_2.1.0.18.exe -d /home/keenan/.local/share/fallout2-ce && cd /home/keenan/.local/share/fallout2-ce && mv -f app/* . && rm -rf __redist __support app commonappdata Extras tmp goggame* && mv -f sound/ data/ && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }' && cd /home/keenan/.local/share/fallout2-ce/data/sound/music && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToUpper()) { ren $_.FullName $_.Name.ToUpper() } }' && gamescope -f -w 2560 -h 1440 -- fallout2-ce && sleep 3 && sd 'music_path1=sound\\music\\' 'music_path1=data\\sound\\music\\' /home/keenan/.local/share/fallout2-ce/fallout2.cfg && sd 'music_path2=sound\\music\\' 'music_path2=data\\sound\\music\\' /home/keenan/.local/share/fallout2-ce/fallout2.cfg
    ## HOMM
    , innoextract -g '/mnt/crusader/Games/Other/GOG/heroes_of_might_and_magic_2_gold_edition/setup_heroes_of_might_and_magic_2_gold_1.01_(2.1)_(33438).exe' -d /home/keenan/.local/share/fheroes2
    , innoextract -g '/mnt/crusader/Games/Other/GOG/heroes_of_might_and_magic_3_complete_edition/setup_heroes_of_might_and_magic_3_complete_4.0_(3.2)_gog_0.1_(77075).exe' -d /home/keenan/.local/share/vcmi
    ## Jagged Alliance 2
    , innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2/setup_jagged_alliance_2_1.12_(17794).exe' -d /home/keenan/Games/jagged-alliance-2/ja2
    , innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2_unfinished_business/setup_ja2_-_unfinished_business_1.01_(17724).exe' -d /home/keenan/Games/jagged-alliance-2/unfinished-business
    , innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2_wildfire/setup_jagged_alliance_2_wildfire_6.08_(16760).exe' -d /home/keenan/Games/jagged-alliance-2/wildfire
    ## Jazz Jackrabbit 2
    , innoextract -g '/mnt/crusader/Games/Other/GOG/jazz_jackrabbit_2_secret_files/extras/setup_jazz_jackrabbit_2_1.24_jj2_(5.11)_(62338).exe' -d '/home/keenan/.local/share/Jazz² Resurrection/Source' && , innoextract -g '/mnt/crusader/Games/Other/GOG/jazz_jackrabbit_2_christmas_chronicles/setup_jazz_jackrabbit_2_the_christmas_chronicles_1.2x_(16742).exe' -d '/home/keenan/.local/share/Jazz² Resurrection/Source' && cd '/home/keenan/.local/share/Jazz² Resurrection/Source' && rm -rf __redist __support app commonappdata tmp
    ## Jedi Academy
    , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_jedi_academy/setup_star_wars_jedi_knight_-_jedi_academy_1.01_(a)_(10331).exe' -d '/home/keenan/.local/share/openjk/base'
    ## Jedi Outcast
    , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_ii_jedi_outcast/setup_star_wars_jedi_knight_ii_-_jedi_outcast_1.04_(17964).exe' -d '/home/keenan/.local/share/openjo/base'
    ## Locomotion
    , innoextract -g '/mnt/crusader/Games/Other/GOG/chris_sawyers_locomotion/setup_chris_sawyers_locomotion_4.02.176_(22259).exe' -d /home/keenan/Games/loco
    ## Morrowind
    , innoextract -g '/mnt/crusader/Games/Other/GOG/the_elder_scrolls_iii_morrowind_goty_edition_game/setup_the_elder_scrolls_iii_morrowind_goty_1.6.0.1820_gog_0.1_(77582).exe' -d /home/keenan/Games/morrowind
    ## Nox
    , innoextract -g '/mnt/crusader/Games/Other/GOG/nox/setup_nox_2.0.0.20.exe' -d /home/keenan/Games/nox && mv /home/keenan/Games/nox/app/* /home/keenan/Games/nox && rm -rf /home/keenan/Games/nox/{app,tmp}
    ## Oddworld
    , innoextract "/mnt/crusader/Games/Other/Zoom/Oddworld-Abe's-Oddysee-English-Setup-1.5.exe" -d /home/keenan/Games/oddworld/ao && mv /home/keenan/Games/oddworld/ao/app/* /home/keenan/Games/oddworld/ao && rm -rf /home/keenan/Games/oddworld/ao/{app,tmp}
    , innoextract "/mnt/crusader/Games/Other/Zoom/Oddworld-Abe's-Exoddus-English-Setup-1.3.exe" -d /home/keenan/Games/oddworld/ae && mv /home/keenan/Games/oddworld/ae/app/* /home/keenan/Games/oddworld/ae && rm -rf /home/keenan/Games/oddworld/ae/{app,tmp}
    ## Outlaws
    , innoextract -g '/mnt/crusader/Games/Other/GOG/outlaws_a_handful_of_missions/setup_outlaws_2.0_hotfix_(18728).exe' -d /home/keenan/Games/the-force-engine/ol && mv /home/keenan/Games/the-force-engine/ol/app/* /home/keenan/Games/the-force-engine/ol && rm -rf /home/keenan/Games/the-force-engine/ol/{app,tmp}
    ## Perfect Dark
    xh https://api.github.com/repos/fgsfdsfgs/perfect_dark/releases/latest | jq -r '.assets[] | select(.name | test("flatpak")).browser_download_url' | xargs xh get -d -o /home/keenan/.local/bin/perfectdark.flatpak
    flatpak install --user /home/keenan/.local/bin/perfectdark.flatpak
    xh get -d https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Perfect%20Dark%20%28USA%29%20%28Rev%201%29.zip -o /home/keenan/.var/app/io.github.fgsfdsfgs.perfect_dark/data/perfectdark/data/perfectdark.zip
    ouch d --yes /home/keenan/.var/app/io.github.fgsfdsfgs.perfect_dark/data/perfectdark/data/perfectdark.zip -d /home/keenan/.var/app/io.github.fgsfdsfgs.perfect_dark/data/perfectdark/data
    fd . -e z64 '/home/keenan/.var/app/io.github.fgsfdsfgs.perfect_dark/data/perfectdark/data' -x mv {} /home/keenan/.var/app/io.github.fgsfdsfgs.perfect_dark/data/perfectdark/data/pd.ntsc-final.z64
    ## Quake
    , innoextract -g '/mnt/crusader/Games/Other/GOG/quake_the_offering_game/setup_quake_the_offering_2.0.0.6.exe' -d /home/keenan/Games/quake/quake-1
    , innoextract -g '/mnt/crusader/Games/Other/GOG/quake_ii_quad_damage_game/setup_quake2_quad_damage_2.0.0.3.exe' -d /home/keenan/.q2pro && cp -r /home/keenan/.q2pro/app/* /home/keenan/.q2pro
    , innoextract -g '/mnt/crusader/Games/Other/GOG/quake_iii_arena_and_team_arena/setup_quake3_2.0.0.2.exe' -d /home/keenan/.q3a && mv /home/keenan/.q3a/app/* /home/keenan/.q3a && rm -rf /home/keenan/.q3a/tmp /home/keenan/.q3a/app
    mkdir -p /home/keenan/Games/quake/quake-3/base/{baseq3,cpma}
    wget -nc https://cdn.playmorepromode.com/files/cpma/cpma-1.53-nomaps.zip -P /home/keenan/Games/quake/quake-3
    wget -nc https://cdn.playmorepromode.com/files/cpma-mappack-full.zip -P /home/keenan/Games/quake/quake-3
    wget -nc https://cdn.playmorepromode.com/files/cnq3/cnq3-1.53.zip -P /home/keenan/Games/quake/quake-3
    wget -nc https://cdn.playmorepromode.com/files/maps/cpma-mappack-beta-june-2020.zip -P /home/keenan/Games/quake/quake-3
    wget -nc https://files.ioquake3.org/xcsv_hires.zip -P /home/keenan/Games/quake/quake-3
    wget -nc -O /home/keenan/Games/quake/quake-3/pak9hqq37test20181106.pk3 https://github.com/diegoulloao/ioquake3-mac-install/raw/master/extras/extra-pack-resolution.pk3
    wget -nc -O /home/keenan/Games/quake/quake-3/pakxy01Tv5.pk3 https://github.com/diegoulloao/ioquake3-mac-install/raw/master/extras/hd-weapons.pk3
    wget -nc https://raw.githubusercontent.com/twerszko/ioquake3-linux-installer/master/config/q3config.cfg -P /home/keenan/Games/quake/quake-3
    fd 'nomaps*' -e zip /home/keenan/Games/quake/quake-3 -x ouch d --yes {} -d /home/keenan/Games/quake/quake-3/base
    fd 'cnq*' -e zip /home/keenan/Games/quake/quake-3 -x ouch d --yes {} -d /home/keenan/Games/quake/quake-3
    fd . /home/keenan/Games/quake/quake-3/cnq* -x mv {} /home/keenan/Games/quake/quake-3/base
    fd 'xcsv' -e zip /home/keenan/Games/quake/quake-3 -x ouch d --yes {} -d /home/keenan/Games/quake/quake-3
    fd . -e pk3 /home/keenan/Games/quake/quake-3/xcsv* -x cp {} /home/keenan/Games/quake/quake-3/base/cpma
    fd . -e pk3 /home/keenan/Games/quake/quake-3/xcsv* -x cp {} /home/keenan/Games/quake/quake-3/base/baseq3
    fd . -e pk3 /home/keenan/Games/quake/quake-3 -x cp {} /home/keenan/Games/quake/quake-3/base/baseq3
    fd . -e pk3 /home/keenan/Games/quake/quake-3 -x cp {} /home/keenan/Games/quake/quake-3/base/cpma
    ## Rollercoaster Tycoon
    , innoextract -g '/mnt/crusader/Games/Other/GOG/rollercoaster_tycoon_deluxe/setup_rollercoaster_tycoon_deluxe_1.20.015_ddraw_fix_(77749).exe' -d /home/keenan/Games/rollercoaster-tycoon/rct-1
    , innoextract -g '/mnt/crusader/Games/Other/GOG/rollercoaster_tycoon_2/setup_rollercoaster_tycoon_2_triple_thrill_pack_2.01.043_wacky_worlds_patch_(76932).exe' -d /home/keenan/Games/rollercoaster-tycoon/rct-2
    ## RTCW
    , innoextract -g '/mnt/crusader/Games/Other/GOG/return_to_castle_wolfenstein_game/setup_return_to_castle_wolfenstein_2.0.0.2.exe' -d '/home/keenan/.wolf' && mv /home/keenan/.wolf/app/* /home/keenan/.wolf && mv /home/keenan/.wolf/Main /home/keenan/.wolf/main
    ## STALKER
    , innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_call_of_pripyat/setup_stalker_cop_2.1.0.17.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/'{__unpacker,app,DirectX,Foxit,support,tmp}
    , innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_clear_sky/setup_stalker_cs_2.1.0.10.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky/'{__unpacker,app,DirectX,Foxit,support,tmp}
    , innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_shadow_of_chernobyl/setup_stalker_shoc_2.1.0.7.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl/'{__unpacker,app,DirectX,Foxit,support,tmp}
    ## Serious Sam
    , innoextract -g '/mnt/crusader/Games/Other/GOG/serious_sam_the_first_encounter/setup_serious_sam_the_first_encounter_1.05_(21759).exe' -d /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussam && , innoextract -g '/mnt/crusader/Games/Other/GOG/serious_sam_the_second_encounter/setup_serious_sam_the_second_encounter_1.07_(21759).exe' -d /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussamse
    ## Theme Hospital
    , innoextract -g '/mnt/crusader/Games/Other/GOG/theme_hospital/setup_theme_hospital_v3_(28027).exe' -d /home/keenan/Games/theme-hospital
    ## Ultima VII
    , innoextract -g '/mnt/crusader/Games/Other/GOG/ultima_vii_the_black_gate_the_forge_of_virtue/setup_ultima_vii_-_the_black_gate_1.0_(22308).exe' -d /home/keenan/.local/share/exult/forgeofvirtue
    , innoextract -g '/mnt/crusader/Games/Other/GOG/ultima_vii_serpent_isle/setup_ultima_vii_-_serpent_isle_1.0_(22308).exe' -d /home/keenan/.local/share/exult/silverseed
    xh get -d -o /home/keenan/.local/share/exult/exult_audio.zip http://prdownloads.sourceforge.net/exult/exult_audio.zip
    fd 'exult_audio' -e zip /home/keenan/.local/share/exult -x ouch d --yes {} -d /home/keenan/.local/share/exult
    fd 'exult_audio' -e zip /home/keenan/.local/share/exult -x rm {}
    ## X-COM
    , innoextract -g '/mnt/crusader/Games/Other/GOG/xcom_ufo_defense/setup_x-com_ufo_defense_1.14_gog_(76761).exe' -d /home/keenan/.local/share/openxcom/UFO
    , innoextract -g '/mnt/crusader/Games/Other/GOG/xcom_terror_from_the_deep/setup_x-com_terror_from_the_deep_2.1_(28046).exe' -d /home/keenan/.local/share/openxcom/TFTD
    ## Zelda 64
    xh https://api.github.com/repositories/708994262/releases/latest | jq -r '.assets[] | select(.name | test("Linux-x64-AppImage.zip$")).browser_download_url' | xargs xh get -d -o /home/keenan/Games/zelda64/zelda64.zip
    fd 'Zelda64' -e zip /home/keenan/Games/zelda64 -x ouch d --yes {} -d /home/keenan/Games/zelda64
    fd 'Zelda64' -e zip /home/keenan/Games/zelda64 -x rm {}
    fd 'Zelda64' -e AppImage /home/keenan/Games/zelda64 -x chmod +x {}
```