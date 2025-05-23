#!/bin/bash
set -e

HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE"

echo "Update AntiZapret VPN files:"

rm -f download/*

UPDATE_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/update.sh"
UPDATE_PATH="update.sh"

PARSE_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/parse.sh"
PARSE_PATH="parse.sh"

DOALL_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/doall.sh"
DOALL_PATH="doall.sh"

HOSTS_LINK_1="https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv.gz"
HOSTS_PATH_1="download/dump.csv.gz"

HOSTS_LINK_2="https://antifilter.download/list/domains.lst"
HOSTS_PATH_2="download/domains.lst"

NXDOMAIN_LINK="https://raw.githubusercontent.com/zapret-info/z-i/master/nxdomain.txt"
NXDOMAIN_PATH="download/nxdomain.txt"

INCLUDE_HOSTS_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/download/include-hosts.txt"
INCLUDE_HOSTS_PATH="download/include-hosts.txt"

INCLUDE_IPS_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/download/include-ips.txt"
INCLUDE_IPS_PATH="download/include-ips.txt"

INCLUDE_ADBLOCK_HOSTS_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/download/include-adblock-hosts.txt"
INCLUDE_ADBLOCK_HOSTS_PATH="download/include-adblock-hosts.txt"

EXCLUDE_ADBLOCK_HOSTS_LINK="https://raw.githubusercontent.com/GubernievS/AntiZapret-VPN/main/setup/root/antizapret/download/exclude-adblock-hosts.txt"
EXCLUDE_ADBLOCK_HOSTS_PATH="download/exclude-adblock-hosts.txt"

ADGUARD_LINK="https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
ADGUARD_PATH="download/adguard.txt"

function download {
	local path="${HERE}/${1}"
	local tmp_path="${path}.tmp"
	local link=$2
	echo "$path"
	curl -fL "$link" -o "$tmp_path"
	local_size="$(stat -c '%s' "$tmp_path")"
	remote_size="$(curl -fsSLI "$link" | grep -i content-length | cut -d ':' -f 2 | sed 's/[[:space:]]//g')"
	if [[ "$local_size" != "$remote_size" ]]; then
		echo "Failed to download $path! Size on server is different"
		rm -f "$tmp_path"
		exit 1
	fi
	mv -f "$tmp_path" "$path"
	if [[ "$path" == *.sh ]]; then
		chmod +x "$path"
	fi
}

download $UPDATE_PATH $UPDATE_LINK
download $PARSE_PATH $PARSE_LINK
download $DOALL_PATH $DOALL_LINK
download $HOSTS_PATH_1 $HOSTS_LINK_1
download $HOSTS_PATH_2 $HOSTS_LINK_2
download $NXDOMAIN_PATH $NXDOMAIN_LINK
download $INCLUDE_HOSTS_PATH $INCLUDE_HOSTS_LINK
download $INCLUDE_IPS_PATH $INCLUDE_IPS_LINK
download $INCLUDE_ADBLOCK_HOSTS_PATH $INCLUDE_ADBLOCK_HOSTS_LINK
download $EXCLUDE_ADBLOCK_HOSTS_PATH $EXCLUDE_ADBLOCK_HOSTS_LINK
download $ADGUARD_PATH $ADGUARD_LINK

gunzip -f "$HOSTS_PATH_1" || > dump.csv

exit 0