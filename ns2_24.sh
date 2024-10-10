sleep 1
echo -e "\nThis script is for Ubuntu 24.04 , for other versions of ubuntu its might not work accurately 😊\n"
sleep 5

echo -e "\nDownloading NS-2.35..."
wget https://sourceforge.net/projects/nsnam/files/allinone/ns-allinone-2.35/ns-allinone-2.35.tar.gz -O ~/ns-allinone-2.35.tar.gz

echo -e "\nInstalling prerequisites..."
sudo apt update
sudo apt install -y build-essential autoconf automake libxmu-dev

echo -e "\nModifying sources.list..."
sudo tee -a /etc/apt/sources.list.d/ubuntu.sources <<EOF


Types: deb
URIs: http://in.archive.ubuntu.com/ubuntu/
Suites: bionic-updates bionic
Components: main universe
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

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

file="ns2_24.sh"
rm -- "$file"