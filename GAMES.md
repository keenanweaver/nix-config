# Setting up games

This is to quickly set up games for nix, Flatpak, and distrobox that require extra data files.

## Set up directories
``` bash
    mkdir -p /home/keenan/Games/{descent/descent-1,descent/descent-2,quake/quake-1,quake/quake-3,RCT,morrowind,blake-stone/aog,blake-stone/ps,jagged-alliance-2/ja2,jagged-alliance-2/unfinished-business,jagged-alliance-2/wildfire,loco,arx-fatalis}
    mkdir -p /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2
    mkdir -p '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source'
    mkdir -p /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/{serioussam,serioussamse}
```

## Download game files

``` bash
    ## Zelda 64
    curl https://api.github.com/repos/Mr-Wiseguy/Zelda64Recomp/releases/latest | jq -r '.assets[] | select(.name | test("Linux.tar.gz$")).browser_download_url' | wget -i- -N -P /home/keenan/Games
    fd 'Zelda64' -e tar.gz /home/keenan/Games -x ouch d --yes {} -d /home/keenan/Games
    fd 'Zelda64' -t d /home/keenan/Games -x mv {} /home/keenan/Games/zelda64
    fd 'Zelda64' -e tar.gz /home/keenan/Games -x rm {}

    ## Quake 3 / CPMA
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
```

* `, innoextract -g '/mnt/crusader/Games/Other/GOG/quake_the_offering_game/setup_quake_the_offering_2.0.0.6.exe' -d /home/keenan/Games/quake/quake-1`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/rollercoaster_tycoon_deluxe/setup_rollercoaster_tycoon_deluxe_1.20.015_(17822).exe' -d /home/keenan/Games/RCT`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/the_elder_scrolls_iii_morrowind_goty_edition_game/setup_tes_morrowind_goty_2.0.0.7.exe' -d /home/keenan/Games/morrowind`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/blake_stone_aliens_of_gold/setup_blake_stone_-_aliens_of_gold_1.0_(28043).exe' -d /home/keenan/Games/blake-stone/aog`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/blake_stone_planet_strike/setup_blake_stone_-_planet_strike_1.01_(28043).exe' -d /home/keenan/Games/blake-stone/ps`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2/setup_jagged_alliance_2_1.12_(17794).exe' -d /home/keenan/Games/jagged-alliance-2/ja2`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2_unfinished_business/setup_ja2_-_unfinished_business_1.01_(17724).exe' -d /home/keenan/Games/jagged-alliance-2/unfinished-business`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2_wildfire/setup_jagged_alliance_2_wildfire_6.08_(16760).exe' -d /home/keenan/Games/jagged-alliance-2/wildfire`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/caesar_3/setup_caesar3_2.0.0.9.exe' -d /home/keenan/Games/caesar-3 && mv /home/keenan/Games/caesar-3/app/* /home/keenan/Games/caesar-3 && rm -rf /home/keenan/Games/caesar-3/app /home/keenan/Games/caesar-3/tmp`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/theme_hospital/setup_theme_hospital_v3_(28027).exe' -d /home/keenan/Games/theme-hospital`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/descent/setup_descent_1.4a_(16596).exe' -d /home/keenan/Games/descent/descent-1 && mv /home/keenan/Games/descent/descent-1/app/* /home/keenan/Games/descent/descent-1 && rm -rf /home/keenan/Games/descent/descent-1/app /home/keenan/Games/descent/descent-1/tmp`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/descent_2/setup_descent_2_1.1_(16596).exe' -d /home/keenan/Games/descent/descent-2 && mv /home/keenan/Games/descent/descent-2/app/* /home/keenan/Games/descent/descent-2 && rm -rf /home/keenan/Games/descent/descent-2/app /home/keenan/Games/descent/descent-2/tmp`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/xcom_ufo_defense/setup_x-com_ufo_defense_1.2_(28046).exe' -d /home/keenan/.local/share/openxcom/UFO`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/xcom_terror_from_the_deep/setup_x-com_terror_from_the_deep_2.1_(28046).exe' -d /home/keenan/.local/share/openxcom/TFTD`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_dark_forces/setup_star_warstm_dark_forces_1.0.2_(20338).exe' -d /home/keenan/.var/app/io.github.theforceengine.tfe/data`
* `, innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_call_of_pripyat/setup_stalker_cop_2.1.0.17.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/'{__unpacker,app,DirectX,Foxit,support,tmp}`
* `, innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_clear_sky/setup_stalker_cs_2.1.0.10.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Clear Sky/'{__unpacker,app,DirectX,Foxit,support,tmp}`
* `, innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_shadow_of_chernobyl/setup_stalker_shoc_2.1.0.7.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Shadow of Chernobyl/'{__unpacker,app,DirectX,Foxit,support,tmp}`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/chris_sawyers_locomotion/setup_chris_sawyers_locomotion_4.02.176_(22259).exe' -d /home/keenan/Games/loco`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/arx_fatalis/setup_arx_fatalis_1.22_(38577).exe' -d /home/keenan/Games/arx-fatalis`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_ii_jedi_outcast/setup_star_wars_jedi_knight_ii_-_jedi_outcast_1.04_(17964).exe' -d '/home/keenan/.local/share/openjo/base'`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_jedi_academy/setup_star_wars_jedi_knight_-_jedi_academy_1.01_(a)_(10331).exe' -d '/home/keenan/.local/share/openjk/base'`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/return_to_castle_wolfenstein_game/setup_return_to_castle_wolfenstein_2.0.0.2.exe' -d '/home/keenan/.wolf' && mv /home/keenan/.wolf/app/* /home/keenan/.wolf && mv /home/keenan/.wolf/Main /home/keenan/.wolf/main`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/doom_3_classic/setup_doom_3_1.3.1_(62814).exe' -d '/home/keenan/.var/app/org.dhewm3.Dhewm3/data/dhewm3'`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/doom_3_bfg_edition_game/setup_doom_3_bfg_1.14_(13452).exe' -d /home/keenan/.local/share/rbdoom3bfg && mv /home/keenan/.local/share/rbdoom3bfg/app/* /home/keenan/.local/share/rbdoom3bfg && rm -rf /home/keenan/.local/share/rbdoom3bfg/tmp /home/keenan/.local/share/rbdoom3bfg/app`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/doom_64/setup_doom_64_20220523_(56385).exe' -I 'DOOM64.WAD' -d '/home/keenan/.local/share/doom64ex-plus/'`
* `, innoextract -g /mnt/crusader/Games/Other/GOG/fallout_game/setup_fallout_1.2_\(27130\).exe -d /home/keenan/.local/share/fallout-ce && cd /home/keenan/.local/share/fallout-ce && rm -rf __redist __support app commonappdata Extras tmp goggame* && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }' && cd /home/keenan/.local/share/fallout-ce/data/sound/music && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToUpper()) { ren $_.FullName $_.Name.ToUpper() } }' && gamescope -f -w 2560 -h 1440 -- fallout-ce && sleep 3 && sd 'music_path1=sound\\music\\' 'music_path1=data\\sound\\music\\' /home/keenan/.local/share/fallout-ce/fallout.cfg && sd 'music_path2=sound\\music\\' 'music_path2=data\\sound\\music\\' /home/keenan/.local/share/fallout-ce/fallout.cfg`
* `, innoextract -g /mnt/crusader/Games/Other/GOG/fallout_2_game/setup_fallout2_2.1.0.18.exe -d /home/keenan/.local/share/fallout2-ce && cd /home/keenan/.local/share/fallout2-ce && mv -f app/* . && rm -rf __redist __support app commonappdata Extras tmp goggame* && mv -f sound/ data/ && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }' && cd /home/keenan/.local/share/fallout2-ce/data/sound/music && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToUpper()) { ren $_.FullName $_.Name.ToUpper() } }' && gamescope -f -w 2560 -h 1440 -- fallout2-ce && sleep 3 && sd 'music_path1=sound\\music\\' 'music_path1=data\\sound\\music\\' /home/keenan/.local/share/fallout2-ce/fallout2.cfg && sd 'music_path2=sound\\music\\' 'music_path2=data\\sound\\music\\' /home/keenan/.local/share/fallout2-ce/fallout2.cfg`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/diablo/setup_diablo_1.09_hellfire_v2_(30038).exe' -I 'DIABDAT.MPQ' -I 'hellfire.mpq' -I 'hfmonk.mpq' -I 'hfmusic.mpq' -I 'hfvoice.mpq' -d /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution && mv /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution/hellfire/* /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution && rm -rf /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution/hellfire`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_dark_forces_ii_copy3/setup_star_wars_jedi_knight_-_mysteries_of_the_sith_1.0_(17966).exe' -d /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2 && mv /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2/app/* /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2 && , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_republic_commando_copy3/setup_star_wars_jedi_knight_-_dark_forces_2_1.01_(17966).exe' -d /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots && mv /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots/app/* /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/jazz_jackrabbit_2_secret_files/extras/setup_jazz_jackrabbit_2_1.24_jj2_(5.11)_(62338).exe' -d '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source' && , innoextract -g '/mnt/crusader/Games/Other/GOG/jazz_jackrabbit_2_christmas_chronicles/setup_jazz_jackrabbit_2_cc_1.2x_(16742).exe' -d '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source' && cd '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source' && rm -rf __redist __support app commonappdata tmp`
* `, innoextract -g '/mnt/crusader/Games/Other/GOG/serious_sam_the_first_encounter/setup_serious_sam_the_first_encounter_1.05_(21759).exe' -d /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussam && , innoextract -g '/mnt/crusader/Games/Other/GOG/serious_sam_the_second_encounter/setup_serious_sam_the_second_encounter_1.07_(21759).exe' -d /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussamse`