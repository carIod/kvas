#!/bin/sh
# shellcheck disable=SC2034
[ -n "$_ENV_INCLUDED" ] && return
_ENV_INCLUDED=1
# ------------------------------------------------------------------------------------------
#
# 	ПРОЕКТ КВАС
#
# ------------------------------------------------------------------------------------------
# 	Данный файл все переменные 
# ------------------------------------------------------------------------------------------
#	Разработчик: mail@zeleza.ru
#	Дата: 21/05/2022
#	Лицензия: Apache License 2.0
# ------------------------------------------------------------------------------------------

APP_VERSION=1.1.10
APP_RELEASE=alpha.4

APP_NAME_DESC=КВАС

KVAS_BACKUP_PATH=/opt/etc/.kvas/backup
IPSET_TABLE_NAME=KVAS_UNBLOCK
SSR_NAME=ss-redir
SSR_CMD=/opt/bin/${SSR_NAME}
KVAS_CONF_FILE=/opt/etc/kvas.conf

KVAS_LIST_FILE=/opt/etc/kvas.list
# Файл с тегами
TAGS_FILE=/opt/apps/kvas/etc/conf/tags.list

ADGUARDHOME_CONFIG=/opt/etc/AdGuardHome/AdGuardHome.yaml
ADGUARD_IPSET_FILE=/opt/etc/AdGuardHome/kvas.ipset
ADGUARDHOME_LOG=/opt/var/log/AdGuardHome.log
ADGUARDHOME_DEMON=/opt/etc/init.d/S99adguardhome
ADS_MAIN_SCRIPT=/opt/apps/kvas/bin/main/adblock

SHADOWSOCKS_CONF=/opt/etc/shadowsocks.json

DNSMASQ_IPSET_HOSTS=/opt/etc/dnsmasq.d/kvas.dnsmasq
DNSMASQ_CONFIG=/opt/etc/dnsmasq.conf
DNSMASQ_DEMON=/opt/etc/init.d/S56dnsmasq

DNSCRYPT_CONFIG=/opt/etc/dnscrypt-proxy.toml

ADBLOCK_LIST_EXCEPTION=/opt/etc/adblock/exception.list
ADBLOCK_HOSTS_FILE=/opt/etc/adblock/ads.hosts.list
ADBLOCK_SOURCES_LIST=/opt/etc/adblock/sources.list

#BACKUPs
KVAS_CONFIG_BACKUP=${KVAS_BACKUP_PATH}/kvas.conf
KVAS_LIST_FILE_BACKUP=${KVAS_BACKUP_PATH}/hosts.list
ADGUARDHOME_CONFIG_BACKUP=${KVAS_BACKUP_PATH}/AdGuardHome.yaml
ADGUARD_IPSET_FILE_BACKUP=${KVAS_BACKUP_PATH}/kvas.ipset
SHADOWSOCKS_CONF_BACKUP=${KVAS_BACKUP_PATH}/shadowsocks.json
DNSMASQ_IPSET_HOSTS_BACKUP=${KVAS_BACKUP_PATH}/kvas.dnsmasq
DNSMASQ_CONFIG_BACKUP=${KVAS_BACKUP_PATH}/dnsmasq.conf
DNSCRYPT_CONFIG_BACKUP=${KVAS_BACKUP_PATH}/dnscrypt-proxy.toml
ADBLOCK_LIST_EXCEPTION_BACKUP=${KVAS_BACKUP_PATH}/exception.list
ADBLOCK_HOSTS_FILE_BACKUP=${KVAS_BACKUP_PATH}/ads.hosts.list
ADBLOCK_SOURCES_LIST_BACKUP=${KVAS_BACKUP_PATH}/sources.list




#HOME_PATH=/opt/apps/kvas


#APP_NAME=kvas
INSTALL_LOG=/opt/tmp/kvas.install.log
#CRONTAB_FILE=/opt/etc/crontab
UPDATE_BIN_FILE=/opt/apps/kvas/bin/main/update
#DNS_LOCAL_DEMON_FILE=/opt/etc/ndm/netfilter.d/100-dns-local
#IPSET_REDIRECT_DEMON_FILE=/opt/etc/ndm/netfilter.d/100-proxy-redirect
INFACE_NAMES_FILE=/opt/etc/inface_equals
KVAS_START_FILE=/opt/etc/init.d/S96kvas

# Файл в котором содержатся сети, запросы из которых необходимо исключить
# из обращений к VPN или SHADOWSOCKS подключениям
EXCLUDED_NET_FILE=/opt/apps/kvas/etc/conf/excluded.net

IP_FILTER='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
NET_FILTER='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,3}'
DATE_FORMAT='+%d/%m/%Y %H:%M:%S'

ERROR_LOG_FILE=/opt/tmp/kvas.err.log

MAIN_DNS_PORT=53
LOCALHOST_IP=127.0.0.1
INFACE_REQUEST="${LOCALHOST_IP}:79/rci/show/interface"
INFACE_PART_REQUEST="${LOCALHOST_IP}:79/rci/interface"
SSR_ENTWARE_TEMPL=ezcfg
MINUS=9

RED="\033[1;31m";
GREEN="\033[1;32m";
BLUE="\033[36m";
YELLOW="\033[33m";
NOCL="\033[m";
QST="${RED}?${NOCL}"