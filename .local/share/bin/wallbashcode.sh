#!/usr/bin/env sh

#// set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
readarray -t codeConf < <(find "${confDir}" -mindepth 1 -maxdepth 1 -type d -name "Code*" -o -name "VSCodium*" -o -name "Cursor*" | sort)
readarray -t codeVsix < <(find "$HOME" -mindepth 1 -maxdepth 1 -type d -name ".vscode*" -o -name ".cursor" | sort)
tmpFile="/tmp/$(id -u)$(basename ${0}).tmp"
tgtFile="extensions/undefined_publisher.wallbash-0.0.1/themes/wallbash-color-theme.json"
vsixFile="$HOME/.local/share/swirlface/arcs/Code_Wallbash.vsix"

#// install  ext

for i in "${!codeVsix[@]}" ;do
    if [ ! -f "${codeVsix[i]}/${tgtFile}" ] ; then
        if [ ! -f "${vsixFile}" ] ; then
            echo "[wallbashcode] Missing ${vsixFile}"
            continue
        fi
        case ${codeVsix[i]} in
        *".cursor"*)
            echo "[wallbashcode] Cursor IDE: Manual intervention required for extension installation."
            echo "[wallbashcode] Read the instructions here: https://www.cursor.com/how-to-install-extension "
            ;;
        *)
            pkg_installed code-insiders && code-insiders --install-extension "${vsixFile}"
            pkg_installed code && code --install-extension "${vsixFile}"
            pkg_installed vscodium && vscodium --install-extension "${vsixFile}"
            ;;
        esac
    fi
    [ -d "$(dirname "${codeVsix[i]}/${tgtFile}")" ] && cp "${cacheDir}/landing/wallbashcode.json" "${codeVsix[i]}/${tgtFile}"
done

#// apply theme

for i in "${!codeConf[@]}" ; do
    [ -d "${codeConf[i]}/User" ] || continue
    [ -f "${codeConf[i]}/User/settings.json" ] ||  echo -e "{\n \"workbench.colorTheme\":\"wallbash\" \n}" > "${codeConf[i]}/User/settings.json"
    extTheme="$(jq -r '.["workbench.colorTheme"]' "${codeConf[i]}/User/settings.json")"

    if [ "${extTheme}" != "wallbash" ] ; then
        jq '.["workbench.colorTheme"] = "wallbash"' "${codeConf[i]}/User/settings.json" > "${tmpFile}" && mv "${tmpFile}" "${codeConf[i]}/User/settings.json"
    fi
done
