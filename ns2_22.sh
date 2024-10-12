sleep 1
echo -e "\nThis script is for Ubuntu 22.04 , for other versions of ubuntu its might not work accurately 😊\n"
sleep 5

echo -e "\nDownloading NS-2.35..."
wget https://sourceforge.net/projects/nsnam/files/allinone/ns-allinone-2.35/ns-allinone-2.35.tar.gz -O ~/ns-allinone-2.35.tar.gz


echo -e "\nModifying sources.list..."

sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

sudo tee /etc/apt/sources.list > /dev/null <<EOF
# Official Ubuntu 22.04 (Jammy Jellyfish) Repositories
deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse

# Bionic (18.04) Repositories for GCC 4.8 and G++ 4.8
deb http://archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu bionic-security main restricted universe multiverse
EOF

echo -e "\nHandling missing GPG key for bionic-updates..."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32


sudo apt update

echo -e "\nInstalling prerequisites..."
sudo apt install -y build-essential autoconf automake libxmu-dev
sudo apt update

echo -e "\nInstalling GCC-4.8 and G++-4.8..."
sudo apt install -y gcc-4.8 g++-4.8

echo -e "\nExtracting NS-2.35..."
tar zxf ~/ns-allinone-2.35.tar.gz -C ~/

echo -e "\nUpdating Makefiles..."
sed -i 's/@CC@/gcc-4.8/g' ~/ns-allinone-2.35/nam-1.15/Makefile.in
sed -i 's/@CXX@/g++-4.8/g' ~/ns-allinone-2.35/nam-1.15/Makefile.in

sed -i 's/@CC@/gcc-4.8/g' ~/ns-allinone-2.35/ns-2.35/Makefile.in
sed -i 's/@CXX@/g++-4.8/g' ~/ns-allinone-2.35/ns-2.35/Makefile.in

sed -i 's/@CC@/gcc-4.8/g' ~/ns-allinone-2.35/otcl-1.14/Makefile.in
sed -i 's/@CXX@/g++-4.8/g' ~/ns-allinone-2.35/otcl-1.14/Makefile.in

sed -i 's/@CC@/gcc-4.8/g' ~/ns-allinone-2.35/xgraph-12.2/Makefile.in
sed -i 's/@CXX@/g++-4.8/g' ~/ns-allinone-2.35/xgraph-12.2/Makefile.in

echo -e "\nUpdating ls.h file..."
sed -i '/void eraseAll()/ s/{.*}/{this->erase(baseMap::begin(), baseMap::end());}/' ~/ns-allinone-2.35/ns-2.35/linkstate/ls.h

echo -e "\nInstalling NS-2..."
cd ~/ns-allinone-2.35/
./install

sleep 1
cd

echo -e "\nUpdating environment variables..."
echo "export PATH=\$PATH:~/ns-allinone-2.35/bin:~/ns-allinone-2.35/tcl8.5.10/unix:~/ns-allinone-2.35/tk8.5.10/unix" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=~/ns-allinone-2.35/otcl-1.14:~/ns-allinone-2.35/lib" >> ~/.bashrc


echo -e "\nApplying new environment variables..."
source ~/.bashrc


rm -f ns-allinone-2.35.tar.gz

echo "NS2 installation completed successfully!😊"

file="ns2_22.sh"
rm -- "$file"