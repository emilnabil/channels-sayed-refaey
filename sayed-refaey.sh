#!/bin/sh
# Command:
# wget https://raw.githubusercontent.com/emilnabil/channel-emil-nabil/main/installer.sh -qO - | /bin/sh
###########################################
MY_URL="https://raw.githubusercontent.com/emilnabil/channel-emil-nabil/main"

echo "******************************************************************************************************************"
echo "        DOWNLOAD AND INSTALL CHANNEL"
echo "=================================================================================================================="

echo "        REMOVE OLD CHANNELS..."
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/enigma2/userbouquet.*
rm -rf /etc/enigma2/epg.dat
rm -rf /etc/enigma2/timers.xml
rm -rf /home/root/.cache/enigma2

echo "        INSTALLING NEW CHANNELS..."
cd /tmp || exit 1

if wget -q "${MY_URL}/channels_backup_by_Emil-Nabil.tar.gz"; then
    if [ -s channels_backup_by_Emil-Nabil.tar.gz ]; then
        tar -xzf channels_backup_by_Emil-Nabil.tar.gz -C /
        rm -f channels_backup_by_Emil-Nabil.tar.gz
        echo "        CHANNELS INSTALLED SUCCESSFULLY"
    else
        echo "        ERROR: Downloaded file is empty"
        rm -f channels_backup_by_Emil-Nabil.tar.gz
        exit 1
    fi
else
    echo "        ERROR: Failed to download channels file"
    exit 1
fi

echo "        FIXING PERMISSIONS..."
chmod 644 /etc/enigma2/lamedb 2>/dev/null
chmod 644 /etc/enigma2/*.tv 2>/dev/null
chmod 644 /etc/enigma2/*.radio 2>/dev/null
chmod 644 /etc/enigma2/userbouquet.* 2>/dev/null

echo "        INSTALLING ASTRA-SM PATCH"
if command -v opkg >/dev/null 2>&1; then
    opkg update >/dev/null 2>&1
    opkg install astra-sm >/dev/null 2>&1
    echo "        ASTRA-SM INSTALLED"
fi

echo "        RELOADING CHANNELS..."
sleep 2
if command -v wget >/dev/null 2>&1; then
    wget -qO- http://127.0.0.1/web/servicelistreload?mode=0 >/dev/null 2>&1
    wget -qO- http://127.0.0.1/web/servicelistreload?mode=2 >/dev/null 2>&1
    echo "        CHANNELS RELOADED VIA WEBIF"
fi

echo "****************************************************************************************************************************"
echo "#       CHANNEL INSTALLED SUCCESSFULLY       #"
echo "*********************************************************"
echo "********************************************************************************"
echo "   UPLOADED BY >>>> EMIL_NABIL"
echo "========================================================================================================================="
echo "        INSTALLATION COMPLETE"
echo "**********************************************************************************"
echo "        If Enigma2 doesn't restart automatically, please reboot manually"
echo "**********************************************************************************"

exit 0


