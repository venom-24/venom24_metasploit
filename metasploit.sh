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
clean () {

#REMOVIENDO INSTALACIONES ANTERIORES
rm -rf $PREFIX/opt/metasploit-framework $PREFIX/var/lib/postgresql ~/.msf4 2>/dev/null
 rm -f $PREFIX/bin/msfconsole $PREFIX/bin/msfvenom 2>/dev/null
	}

dependencias(){
printf $cyan
echo "       ########INSTALANDO DEPENDENCIAS########"
sleep 1.0
printf $reset
pkg update -y
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config ruby -o Dpkg::Options::="--force-confnew"

python3 -m pip install requests
}

parche(){

#RESOLVIENDO DEPENDENCIAS DE RUBY 3.4.0
find $PREFIX/include -name rbasic.h -exec sed -i 's/const VALUE klass;/VALUE klass;/g' {} +
}

installer_msf(){

printf $cyan
echo           "           ####DESCARGANDO METASPLOIT####"
sleep 1.0
printf $reset

git clone https://github.com/rapid7/metasploit-framework.git  ${PREFIX}/opt/metasploit-framework --depth=1
#Instalando metasploit-framework
printf $cyan
echo         "   ####INSTALANDO GEMAS TARDA UN POCO ESPERA####"
printf $reset

 cd $PREFIX/opt/metasploit-framework                  
gem install bundler                                 
bundle config set --local system 'true'
 bundle install
}

links(){
# Link Metasploit Executables                       
ln -sf $PREFIX/opt/metasploit-framework/msfconsole $PREFIX/bin/msfconsole                                 
ln -sf $PREFIX/opt/metasploit-framework/msfvenom $PREFIX/bin/msfvenom

} 

db_metasploit(){

#creando base de datos
sleep 1.0
printf $reset

rm -rf $PREFIX/var/lib/postgresql > /dev/null 2>&1

initdb $PREFIX/var/lib/postgresql > /dev/null 2>&1   
pg_ctl -D $PREFIX/var/lib/postgresql start > /dev/null 2>&1

#creando database
createdb msf_db > /dev/null 2>&1


#CONFIGURANDO CONEXION AUTOMATICA
mkdir -p $PREFIX/opt/metasploit-framework/config > /dev/null 2>&1

#creando archivo de configuracion yml

cat <<EOF > $PREFIX/opt/metasploit-framework/config/database.yml                                          
production:                                            
adapter: postgresql                                 
database: msf_db                                     
username: $(whoami)                                  
host: localhost                                    
port: 5432
pool: 5                                             
timeout: 5                                        
EOF
echo -e "\e[1;36m METASPLOIT SE A INSTALADO CON EXITO"
echo -e "\e[1;32m Inicialo Con El Comando\e[1;36m msfconsole"
printf $reset
}
clean
dependencias
parche
installer_msf
links
db_metasploit
