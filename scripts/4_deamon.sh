export USER_IOV=devops # "iov" is not recommended

# assert that USER_IOV exists
id ${USER_IOV} && echo '✅ All good!' || echo "❌ ${USER_IOV} does not exist."

# constants
VOLUME="$(pwd)/tmp/base_chain"
DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILDS="$DIR_CURRENT_FOLDER/builds"
DIR_TEMP_BUILD_STARNAME10="$DIR_TEMP_BUILD/starname10"
DIR_TEMP_BUILD_STARNAME11="$DIR_TEMP_BUILD/starname11"

export CHAIN_ID=testing # IBC enabled Starname (IOV) chain id
export DIR_STARNAMED="$DIR_CURRENT_FOLDER/builds" # directory for starnamed related artifacts
export VOLUME=$VOLUME

# create an environment file for the Starname Asset Name Service
cat <<__EOF_STARNAMED_ENV__ > starnamed.env
# operator variables
CHAIN_ID=${CHAIN_ID}
MONIKER=$(hostname)
SIGNER=${SIGNER}
USER_IOV=${USER_IOV}

# directories (without spaces to ease pain)
DIR_STARNAMED=${DIR_STARNAMED}
DIR_WORK=$VOLUME

# paths for starnamed and it's required libwasmvm.so
PATH=${PATH}:${DIR_STARNAMED}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${DIR_STARNAMED}

# artifacts
STARNAMED=https://github.com/iov-one/starnamed/releases/download/v0.10.12/starnamed-0.10.12-linux-amd64.tar.gz
__EOF_STARNAMED_ENV__

chgrp ${USER_IOV} starnamed.env
chmod g+r starnamed.env

set -o allexport ; source /etc/systemd/system/starnamed.env ; set +o allexport # pick-up env vars

# create starnamed.service
cat <<__EOF_STARNAMED_SERVICE__ > starnamed.service
[Unit]
Description=Starname Asset Name Service
After=network-online.target

[Service]
Type=simple
User=$(id ${USER_IOV} -u -n)
Group=$(id ${USER_IOV} -g -n)
EnvironmentFile=/etc/systemd/system/starnamed.env
ExecStart=${DIR_STARNAMED}/starnamed.sh
LimitNOFILE=4096
#Restart=on-failure
#RestartSec=3
StandardError=journal
StandardOutput=journal
SyslogIdentifier=starnamed

[Install]
WantedBy=multi-user.target
__EOF_STARNAMED_SERVICE__

systemctl daemon-reload


# create starnamed.sh, a wrapper for starnamed
cat <<__EOF_STARNAMED_SH__ > starnamed.sh
#!/bin/bash

cosmovisor run start --home $DIR_WORK \\
  --minimum-gas-prices='1.0ustake' \\
  --moniker='${MONIKER}' \\
  --p2p.laddr='tcp://0.0.0.0:26656' \\
  --p2p.persistent_peers='' \\
  --rpc.laddr='tcp://127.0.0.1:16657' \\
  --grpc.enable \\
  --rpc.unsafe \\
  

__EOF_STARNAMED_SH__

chgrp ${USER_IOV} starnamed.sh
chmod a+x starnamed.sh

# initialize the Starname Asset Name Service
su - ${USER_IOV}
set -o allexport ; source /etc/systemd/system/starnamed.env ; set +o allexport # pick-up env vars

systemctl enable starnamed.service
journalctl -f -u starnamed.service & systemctl start starnamed.service # watch the chain sync until it intentionlly panics after block 4597999

exit # root