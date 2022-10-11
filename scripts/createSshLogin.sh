KEY_OWNER="Cody Garrett"
KEY_NAME="automatic.key"
KEY_NAME_PUB="$KEY_NAME.pub"
mkdir ~/.ssh
chmod 0700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 0644 ~/.ssh/authorized_keys
ssh-keygen -t rsa -b 4096 -C "$KEY_OWNER" -f "$KEY_NAME" -P ""
cat "$KEY_NAME.pub" >> ~/.ssh/authorized_keys
echo "Very Important!"
echo "The next screen that will come up will display the key needed for login."
echo "You must copy this in it's entirety in order to login using what was setup in the previous commands."
echo ""
echo "Press enter to continue..."
read
clear
echo ""
echo "##################"
echo "## Private Key: ##"
echo "##################"
echo ""
cat $KEY_NAME
echo ""
echo "###########################"
echo "## Authorized Key Entry: ##"
echo "###########################"
echo ""
cat $KEY_NAME_PUB
echo ""
rm -f "$KEY_NAME" "$KEY_NAME_PUB"