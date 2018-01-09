wgwgwgsd
gsgsgsdgsd
#!/bin/bash
#20171004
#
#SCIFI@O-MATIC
#Matheus Monteiro
#
#script de instalaçao scifi o-matic
#set -xv

############################################### 
# 1-ADICIONANDO ARQUIVOS E PACOTES ESSENCIAIS #
###############################################  
apt-get install subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget #1> /dev/null 2> /dev/stdout

#yum install subversion git gawk gettext ncurses-devel zlib-devel openssl-devel libxslt wget 

 if [ ! -d "/opt/scifi-o-matic" ]; then
   mkdir /opt/scifi-o-matic
 fi

#verificação da existência do image builder 
#ar71xx
  if [ -d "/opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64" ];
  then
     echo "image builder ar71xx encontrado"

  else
     cd /opt/scifi-o-matic
     wget https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64.tar.bz2
     tar xjf OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64.tar.bz2 
     rm -rf OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64.tar.bz2

    fi

#ramips/mt7620
 if [ -d "/opt/scifi-o-matic/lede-imagebuilder-17.01.4-ramips-mt7620.Linux-x86_64" ];
  then
     echo "image builder ramips/mt7620 encontrado"
  else
     cd /opt/scifi-o-matic
     wget https://downloads.openwrt.org/releases/17.01.4/targets/ramips/mt7620/lede-imagebuilder-17.01.4-ramips-mt7620.Linux-x86_64.tar.xz
     tar xjf lede-imagebuilder-17.01.4-ramips-mt7620.Linux-x86_64.tar.bz2 
     rm -rf lede-imagebuilder-17.01.4-ramips-mt7620.Linux-x86_64.tar.bz2

 fi

############mudar#########
#ADICIONANDO API E CONFIGURAÇÕES
 if [ -d "/opt/scifi-o-matic/wifi-uff" ]; then
  echo "wifi-uff ok"

 else
   wget https://www.dropbox.com/s/s71zjh6iwp74mi2/scifi.tar.bz2?dl=0 -O /usr/o-matic/midia/scifi.tar.bz2
   cd /usr/o-matic/midia
   tar xjf scifi.tar.bz2
   rm -rf scifi.tar.bz2
 fi


#criando o documento de texto contendo os modelos
#geral
if [ -e "/opt/scifi-o-matic/midia/modelo.txt" ]; then
     echo "lista com modelos geral encontrada"
 else
     wget https://www.dropbox.com/s/f6rimop148972rh/modelo.txt?dl=0 -O /usr/o-matic/midia/modelo.txt
 fi
#ar71xx
 if [ -e "/opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/modelo_ar71xx.txt" ]; then
     echo "lista com modelos ar71xx encontrada"
 else
     wget https://www.dropbox.com/s/tb42dxovwsy9bqy/modelos_AR71XX.txt?dl=0 -O /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/modelo_ar71xx.txt
 fi

#ramips
 if [ -e "/opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ramips-mt7620.Linux-x86_64/modelo_ramips.txt" ]; then
     echo "lista com modelos ramips encontrada"
 else
     wget https://www.dropbox.com/s/y7cljwhkqne48pi/modelos_RAMIPS.txt?dl=0 -O /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ramips-mt7620.Linux-x86_64/modelo_ramips.txt
 fi

#escrevendo o arquivo para adicionar os pacotes no image builder
#ar71xx
cat /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/include/target.mk | sed -n '1,296p' > /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/include/target_base.mk

#ramips
cat /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/include/target.mk | sed -n '1,296p' > /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ramips-mt7620.Linux-x86_64/include/target_base.mk

#editando o arquivo
########
#ar71xx#
########
#escrevendo o aquivo target_base.mk
sed -i 's/^DEFAULT_PACKAGES.nas.*/DEFAULT_PACKAGES.nas:=/;s/^DEFAULT_PACKAGES:.*/DEFAULT_PACKAGES:=base-files libc libgcc busybox mtd uci opkg netifd fstools SPPH/;s/^DEFAULT_PACKAGES.router.*/DEFAULT_PACKAGES.router:=/' /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/include/target_base.mk

#retirando o pacote wpad-mini
sed "s/wpad-mini//g" /OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64/target/linux/ar71xx/Makefile > Makefile.old
cat Makefile.old > Makefile
rm Makefile.old

########
#ramips#
########
sed -i 's/^DEFAULT_PACKAGES.nas.*/DEFAULT_PACKAGES.nas:=/;s/^DEFAULT_PACKAGES:.*/DEFAULT_PACKAGES:=base-files libc libgcc busybox mtd uci opkg netifd fstools SPPH/;s/^DEFAULT_PACKAGES.router.*/DEFAULT_PACKAGES.router:=/' /opt/scifi-o-matic/OpenWrt-ImageBuilder-15.05.1-ramips-mt7620.Linux-x86_64/include/target_base.mk

sed "s/wpad-mini//g" /OpenWrt-ImageBuilder-15.05.1-ramips-mt7620.Linux-x86_64/target/linux/ramips/Makefile > Makefile.old
cat Makefile.old > Makefile
rm Makefile.old

#/OpenWrt-ImageBuilder-15.05.1-ramips-mt7620.Linux-x86_64/target/linux/ramips/Makefile

chmod a+x /opt/scifi-o-matic/make_image.sh


