#!/bin/bash
chmod +x mountAndBackupSetup.sh
chmod +x mountAndBackup.sh

cp mountAndBackupSetup.sh $HOME
cp mountAndBackup.sh $HOME

export userid=$(whoami)

echo "The required software will be installed. Make sure to enable the option to allow mounting for non root users (select yes)"
echo "Press enter to continue. You will need to enter the sudo password after pressing enter"
read
sudo apt -y install davfs2
sudo usermod -a -G davfs2 $userid

cd

mkdir ~/stack ~/.davfs2
if [ ! -f ~/.davfs2/secrets ]; then sudo cp /etc/davfs2/secrets ~/.davfs2/secrets; fi
if [ ! -f ~/.davfs2/davfs2.conf ]; then sudo cp /etc/davfs2/davfs2.conf ~/.davfs2/davfs2.conf; fi
sudo chown -R $userid:davfs2 ~/.davfs2/
sudo chmod 600 ~/.davfs2/secrets
sudo chmod 600 ~/.davfs2/davfs2.conf

echo "Enter the URL for the external transip stack, for example https://storage.myorganisation.com/remote.php/webdav/"
read url
echo "Enter the user id for the external transip stack"
read mountuserid
echo "Enter the password for the external transip stack"
read password

echo "Press enter to continue."
sudo echo "$url $mountuserid $password" >> ~/.davfs2/secrets

echo
sudo echo "$url $HOME/stack davfs user,rw,noauto 0 0" #>> /etc/fstab
echo Copy the line above in the /etc/fstab file. Press enter to start editing.
read
sudo vi /etc/fstab

echo
sudo echo "0 4 * * * $userid $HOME/mountAndBackup.sh" #>> /etc/crontab
echo Copy the line above in the /etc/crontab file. Press enter to start editing.
read
sudo vi /etc/crontab

echo "Setup done. Review the files please. "
echo "cat  ~/.davfs2/secrets"
echo "cat /etc/fstab"
echo "cat /etc/crontab"
