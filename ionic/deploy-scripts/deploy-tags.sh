#!/bin/bash

# get the revision number
revision=$(git rev-list --count HEAD)
echo "Revision: $revision"

# create a version number for a new tag
new_tag=$((revision+1))
echo "$new_tag"

# Announce to HipChat
# ROOM_ID can be found at https://cohaesus.hipchat.com/rooms
# AUTH_TOKEN can be found in the Shared-Cohaesus General Passwords folder in LastPass (hipchat auth token) 
ROOM_ID=
AUTH_TOKEN=
MESSAGE="Starting build $new_tag"

echo $(curl \
	-v -L -G \
	-d "room_id=$ROOM_ID&from=IonicApp"	\
	--data-urlencode "message=$MESSAGE"	\
	"https://api.hipchat.com/v1/rooms/message?auth_token=${AUTH_TOKEN}&format=json"
	)

#change the version name in config.xml
cat ./config.xml | sed -e "s/version=\"[0-9]*\"/version\=\"$new_tag\"/g" > ./config.temp.xml
rm ./config.xml
mv ./config.temp.xml ./config.xml

# create a new tag and push it to VCS
git tag -a $new_tag -m "Cohaesus App v$new_tag"
git push origin --tags