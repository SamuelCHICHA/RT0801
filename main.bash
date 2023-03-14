#!/usr/bin/bash

if [[ "$EUID" -ne 0 ]]
then
    exec sudo "$0" "$@"
else
    set_hostname()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined host"
            return 1
        fi
        if hostnamectl set-hostname "$1"
        then
            echo "Successfully changed the hostname to $1"
        else
            >&2 echo "Failed to set hostname to $1"
        fi
        return 0
    }

    interface_exists()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined network card id"
            return 1
        fi
        if ip link show "$1"
        then
            echo "Interface exists"
        else
            >&2 echo "Interface does not exist"
        fi
        return 0
    }

    down_interface()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined network card id"
            return 1
        fi
        if ip link set dev "$1" down
        then
            echo "The interface was successfully brought down"
        else
            >&2 echo "Failed to bring down the interface"
        fi
        return 0
    }

    set_interface_ip()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined interface"
            return 1
        fi
        if [[ -z "$2" ]]
        then
            >&2 echo "Undefined ip address"
            return 1
        fi
        if [[ -z "$3" ]]
        then
            >&2 echo "Undefined gateway ip address"
            return 1
        fi
        if [[ $(ls /etc/netplan/*.yaml) ]]
        then
            for file in /etc/netplan/*.yaml
            do
                sed -e "/^  ethernets:/,/^  version:/{/^    enp0s3:/,/^    [[:alnum:]]*:/{/^      /d}}" -e "/[[:space:]]*$1:/a \      dhcp: false\n\      addresses: [$2]\n\      routes:\n\        - to: default\n\          via: $3" -i $file
                echo "Interface configuration successfully changed"
            done      
        else
            netplan generate
        fi
        return 0
    }

    up_interface()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined interface"
            return 1
        fi
        if ip link set dev "$1" up
        then
            echo "The interface was succesfully brought up"
        else
            >&2 echo "Failed to bring up the interface"
        fi
        return 0
    }

    set_dns_server()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined dns server"
            return 1
        fi
        echo "nameserver $1" > /etc/resolv.conf
        return 0
    }

    load_network_config()
    {
        netplan apply
        systemctl restart systemd-networkd
    }

    usage()
    {
        echo "Usage: main.sh [Options]"
        echo "Options"
        echo "-h, -- host"
        echo -e "\tHostname"
        echo "-id"
        echo -e "\tInterface identifier"
        echo "-ip"
        echo -e "\tIpv4 address [X.X.X.X/X]"
        echo "-gtw"
        echo -e "\tGateway ip address [X.X.X.X]"
        echo "-dns"
        echo -e "\tDNS address [X.X.X.X]"
    }

    is_ip()
    {
        if [[ -z "$1" ]]
        then
            >&2 echo "Undefined IP address"
            return 1
        fi
        # oldIFS=$IFS
        # IFS="."
        
        # IFS=$oldIFS

        if [[ "$1" =~ [[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3} ]]
        then
            return 0
        else
            return 1
        fi
    }

    ### Parsing options ###
    while [[ "$1" =~ ^- && ! "$1" == "--" ]]
    do 
        case $1 in
            -h | --host )
                shift
                host="$1"
                ;;
            -id )
                shift
                network_card_id="$1"
                ;;
            -ip )
                shift
                if is_ip "$1"
                then
                    network_card_ip="$1"
                else
                    >&2 echo "Invalid ip address for the interface"
                fi
                ;;
            -gtw | --gateway )
                shift
                if is_ip "$1"
                then
                    gateway_ip="$1"
                else
                    >&2 echo "Invalid ip address for the gateway"
                fi
                ;;
            -dns )
                shift
                if is_ip "$1"
                then
                    dns_ip="$1"
                else
                    >&2 echo "Invalid ip address for the dns"
                fi
                ;;
            --help )
                usage
                exit 0
                ;;
            *)
                >&2 echo "Unknown option: " $1
                usage
                exit 1
                ;;
        esac;
        shift
    done

    if [[ "$1" == '--' ]]
    then 
        shift
    fi

    ### ###
    if [[ -n "$host" ]]
    then
        set_hostname "$host"
    fi
    if [[ -n "$network_card_id" ]]
    then
        if interface_exists "$network_card_id"
        then
            down_interface "$network_card_id"
            set_interface_ip "$network_card_id" "$network_card_ip" "$gateway_ip"
            load_network_config
            up_interface "$network_card_id"
        fi
    fi
    if [[ -n "$dns_ip" ]]
    then
        set_dns_server "$dns_ip"
    fi
    if ping -c 3 archlinux.org > /dev/null
    then
        echo "Connection is established"
    else
        >&2 echo "Connection is not established"
    fi
    sudo -k
    exit 0
fi