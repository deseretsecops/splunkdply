#! /bin/bash
wget "https://dzr-api-amzn-us-west-2-fa88.api-upe.p.hmr.sophos.com/api/download/16e355570c28540139656c1641807bf7/SophosSetup.sh" -P /tmp/
sleep 5
cd /tmp
chmod a+x /tmp/SophosSetup.sh
sudo ./SophosSetup.sh