#!/bin/bash
type uuid > /dev/zero
if [ $? -ne 0 ];then
	apt-get -y install uuid
fi

# $1 -> VPN_IP, $2 -> VPN_USER, $3 -> VPN_PASSWORD, $4 -> USER_LOGINED
# vpn 的 ip 地址
ip=$1
# vpn 链接的名字
name=$1
# vpn 的用户名
user=$2
# vpn 的密码
password=$3
# 当前用户
user_logined=$4
# 唯一 id
unique_id=`uuid`

sed "s/YOUR_NAME/$name/" template | \
    sed "s/YOUR_IP/$ip/" | \
    sed "s/YOUR_UUID/$unique_id/" | \
    sed "s/VPN_USER/$user/" | \
    sed "s/USER_LOGINED/$user_logined/" | \
    sed "s/VPN_PASSWORD/$password/" > /etc/NetworkManager/system-connections/$name
chmod 600 /etc/NetworkManager/system-connections/$name

service network-manager restart

echo "Create vpn $name successfully."
echo "Try to use '""nmcli connection up id ""$name""' to connect vpn."
