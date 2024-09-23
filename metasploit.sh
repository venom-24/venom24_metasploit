#!/data/data/com.termux/files/usr/bin/bash

#Author:VeNOM24
#Data: 21/09/24
#BARIABLES
                red='\033[1;31m'
                green='\033[1;32m'
                yellow='\033[1;33m'
                blue='\033[1;34m'                                    magenta='\033[1;35m'                                 cyan='\033[1;36m'                                    reset='\033[0m'

#BANNER
clear

echo -e "\e[1;34m        ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
echo
echo -e "\e[1;31m        M|E|T|A|S|P|L|O|I|T| |EN| |T|E|R|M|U|X"
echo
echo -e "\e[1;31m        A|U|T|H|O|R| |VENOM24|"
echo
echo -e "\e[1;34m        ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
sleep 1.0

printf $cyan
echo "
"
echo       "          #####INSTALANDO DEPENDENCIAS#####"
sleep 1.0
printf $reset
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config ruby -o Dpkg::Options::="--force-confnew"

python3 -m pip install requests

#Borrando carpeta existente de metasploit_f

if [ -d "${PREFIX}/opt/metasploit-framework" ]; then   
	rm -rf ${PREFIX}/opt/metasploit-framework          
fi

#Descargando metasploit-framework

if [ ! -d "${PREFIX}/opt" ]; then                      
	mkdir ${PREFIX}/opt                                
fi
printf $cyan
echo           "           ####DESCARGANDO METASPLOIT####"
sleep 1.0
printf $reset

git clone https://github.com/rapid7/metasploit-framework.git --depth=1 ${PREFIX}/opt/metasploit-framework

#Instalando metasploit-framework
printf $cyan
echo               "       ####INSTALANDO METASPLOIT####"
sleep 1.0
printf $reset

cd ${PREFIX}/opt/metasploit-framework
gem install bundler
VERSION_DE_NOKOGIRI=$(cat Gemfile.lock | grep -i nokogiri | sed 's/nokogiri [\(\)]/(/g' | cut -d ' ' -f 5 | grep -oP "(.).[[:digit:]][\w+]?[.].")
gem install nokogiri -v $VERSION_DE_NOKOGIRI -- --with-cflags="-Wno-implicit-function-declaration -Wno-deprecated-declarations -Wno-incompatible-function-pointer-types" --use-system-libraries
#install 
bundle install                                      
gem install actionpack                               
bundle update activesupport                         
bundle update --bundler
bundle install -j$(nproc --all)

# Link Metasploit Executables                       
ln -sf ${PREFIX}/opt/metasploit-framework/msfconsole ${PREFIX}/bin/                                       
ln -sf ${PREFIX}/opt/metasploit-framework/msfvenom ${PREFIX}/bin/                                        
ln -sf ${PREFIX}/opt/metasploit-framework/msfrpcd ${PREFIX}/bin/                                         
termux-elf-cleaner ${PREFIX}/lib/ruby/gems/*/gems/pg-*/lib/pg_ext.so


echo -e "\e[1;36m METASPLOIT SE A INSTALADO CON EXITO"
echo
echo -e "\e[1;32m Inicialo Con El Comando\e[1;36m msfconsole"
