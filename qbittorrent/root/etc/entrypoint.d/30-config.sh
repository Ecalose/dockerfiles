QB_CONF_FILE="/data/config/qBittorrent.conf"

BT_PORT=${BT_PORT:-34567}
WEBUI_PORT=${WEBUI_PORT:-8080}
if [ ! -s $QB_CONF_FILE ]; then
    echo "Initializing qBittorrent configuration..."
    cat > $QB_CONF_FILE << EOF
[AutoRun]
enabled=true
program=dl-finish \"%K\"

[BitTorrent]
Session\DefaultSavePath=/data/downloads
Session\Port=${BT_PORT}
Session\TempPath=/data/temp

[LegalNotice]
Accepted=true

[Preferences]
General\Locale=zh_CN
WebUI\LocalHostAuth=false
WebUI\Port=${WEBUI_PORT}
EOF
fi

echo "Overriding required parameters..."
sed -i "{
    s!Session\\\Port=.*!Session\\\Port=${BT_PORT}!g;
    s!WebUI\\\Port=.*!WebUI\\\Port=${WEBUI_PORT}!g;
    s!WebUI\\\LocalHostAuth=.*!WebUI\\\LocalHostAuth=false!g;
}" $QB_CONF_FILE

major_ver=$(qbittorrent-nox --version | sed 's|qBittorrent v||' | awk -F. '{print $1}')
minor_ver=$(qbittorrent-nox --version | sed 's|qBittorrent v||' | awk -F. '{print $2}')

if [[ $major_ver -eq 4 && $minor_ver -ge 5 ]]; then
    sed -i -E 's|General\\Locale=.+|General\\Locale=zh_CN|' $QB_CONF_FILE
elif [[ $major_ver -eq 4 && $minor_ver -lt 5 ]]; then
    sed -i -E 's|General\\Locale=.+|General\\Locale=zh|' $QB_CONF_FILE
fi