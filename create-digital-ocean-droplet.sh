#!/usr/bin/env bash

set -e

SECRETFILE=.digitalocean
if [[ -z $DIGOCEAN_ID ]] || [[ -z $DIGOCEAN_KEY ]]; then
    if [ -e $SECRETFILE ]; then
        . $SECRETFILE
    fi
fi

if [[ -z $DIGOCEAN_ID ]] || [[ -z $DIGOCEAN_KEY ]]; then
    echo "You need to set the environment variables DIGOCEAN_ID and DIGOCEAN_KEY"
    echo "or provide them in the file $SECRETFILE"
    exit 1
fi

BASE_URL='https://api.digitalocean.com/v2'
AUTH="client_id=$DIGOCEAN_ID&api_key=$DIGOCEAN_KEY"

REGION_NAME="Amsterdam 3"
SIZE_NAME="512MB"
IMAGE_NAME="Ubuntu 13.04 x64"

REGION_ID=`curl -s "$BASE_URL/regions" -H "Authorization: Bearer $DIGOCEAN_KEY" | jq ".regions | map(select(.name==\"$REGION_NAME\"))[0].slug"`
echo "ID of Region $REGION_NAME is $REGION_ID"

#SIZE_ID=`curl -s "$BASE_URL/sizes" -H "Authorization: Bearer $DIGOCEAN_KEY" | jq ".sizes | map(select(.name==\"$SIZE_NAME\"))[0].id"`
SIZE_ID=`curl -s "$BASE_URL/sizes" -H "Authorization: Bearer $DIGOCEAN_KEY" | jq ".sizes | map(select(.name==\"$SIZE_NAME\"))"`
echo "ID of Size $SIZE_NAME is $SIZE_ID"

IMAGE_ID=`curl -s "$BASE_URL/images" -H "Authorization: Bearer $DIGOCEAN_KEY" | jq ".images | map(select(.name==\"$IMAGE_NAME\"))"`
echo "ID of Image $IMAGE_NAME is $IMAGE_ID"

SSH_KEY_ID=`curl -s "$BASE_URL/account/keys" -H "Authorization: Bearer $DIGOCEAN_KEY" | jq '.ssh_keys[0].id'`
echo "Activating SSH Key with ID $SSH_KEY_ID"

TIMESTAMP=`date '+%Y%m%d%H%M%S'`
DROPLET_NAME="droplet-$TIMESTAMP"

echo "Creating new Droplet $DROPLET_NAME with these specifications..."

#todo curl -s "$BASE_URL/account/keys" -H "Authorization: Bearer $DIGOCEAN_KEY" -d '{"name":"$DROPLET_NAME","region":"$REGION_ID","size":"512mb","image":"ubuntu-14-04-x64","ssh_keys":null,"backups":false,"ipv6":true,"user_data":null,"private_networking":null,"volumes": null}' "https://api.digitalocean.com/v2/droplets"

RESULT=`curl -s "$BASE_URL/droplets/new?$AUTH&name=$DROPLET_NAME&size_id=$SIZE_ID&image_id=$IMAGE_ID&region_id=$REGION_ID&ssh_key_ids=$SSH_KEY_ID"`
STATUS=`echo $RESULT | jq -r '.status'`
echo "Status: $STATUS"
if [ "$STATUS" != "OK" ]; then
    echo "Something went wrong:"
    echo $RESULT | jq .
    exit 1
fi
DROPLET_ID=`echo $RESULT | jq '.droplet.id'`
echo "Droplet with ID $DROPLET_ID created!"

echo "Waiting for droplet to boot"
for i in {1..60}; do
    DROPLET_STATUS=`curl -s "$BASE_URL/droplets/$DROPLET_ID?$AUTH" | jq -r '.droplet.status'`
    [ "$DROPLET_STATUS" == 'active' ] && break
    echo -n '.'
    sleep 5
done
echo

if [ "$DROPLET_STATUS" != 'active' ]; then
    echo "Droplet did not boot in time. Status: $DROPLET_STATUS"
    exit 1
fi

IP_ADDRESS=`curl -s "$BASE_URL/droplets/$DROPLET_ID?$AUTH" | jq -r '.droplet.ip_address'`

echo "Execute bootstrap script"
BOOTSTRAP_URL="https://gist.github.com/christianberg/6082234/raw/bootstrap.sh"
ssh-keygen -R $IP_ADDRESS
SSH_OPTIONS="-o StrictHostKeyChecking=no"
ssh $SSH_OPTIONS root@$IP_ADDRESS "curl -s $BOOTSTRAP_URL | bash"

echo "*****************************"
echo "* Droplet is ready to use!"
echo "* IP address: $IP_ADDRESS"
echo "*****************************"