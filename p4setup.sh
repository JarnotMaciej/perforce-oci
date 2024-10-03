#!/bin/bash

# Download the Perforce public key
wget https://package.perforce.com/perforce.pubkey -O perforce.pubkey

# Obtain the fingerprint of the public key and verify it
FINGERPRINT=$(gpg -n --import --import-options import-show perforce.pubkey | grep -o "E58131C0AEA7B082C6DC4C937123CB760FF18869")

if [ "$FINGERPRINT" == "E58131C0AEA7B082C6DC4C937123CB760FF18869" ]; then
  echo "Public key fingerprint is valid."
  # Add the public key to your keyring
  wget -qO - https://package.perforce.com/perforce.pubkey | sudo apt-key add -
  
  # Create a new file for the Perforce repository
  echo "deb http://package.perforce.com/apt/ubuntu jammy release" | sudo tee /etc/apt/sources.list.d/perforce.list > /dev/null

  echo "Perforce repository configuration added successfully."
else
  echo "Public key fingerprint is invalid. Exiting."
  exit 1
fi

# Clean up
rm perforce.pubkey