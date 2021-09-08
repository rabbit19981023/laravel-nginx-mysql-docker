#!/bin/bash
function help() {
    echo ""
    echo "Help: $0 -r | -root-password <mysql-root-password> " # $0 is this file name
}

function start_mysql_service() {
    service mysql start;
}

function mysql_secure_installation() {

    expect -c "
        spawn mysql_secure_installation

        expect \"Enter current password for root (enter for none):\"
        send \"$MYSQL_ROOT_PASSWORD\r\"

        expect \"Change the root password?\"
        send \"n\r\"

        expect \"Remove anonymous users?\"
        send \"y\r\"

        expect \"Disallow root login remotely?\"
        send \"y\r\"

        expect \"Remove test database and access to it?\"
        send \"y\r\"

        expect \"Reload privilege tables now?\"
        send \"y\r\"

        expect eof
    "
}

while [ "$1" ]; do
    case "$1" in
        -h | --help )
            help; exit 1 ;;
            
        -r | -root-password )
            # check if the $arg after (-r | -root-password) follows the rule:
            # 1. exist
            # 2. not contains a `-` charactor
            if [ "$2" ] && [[ "$2" != *"-"* ]]; then
                MYSQL_ROOT_PASSWORD="$2"
                start_mysql_service
                mysql_secure_installation
                shift 2
            else
                help; exit 1
            fi ;;

        * )
            help; exit 1 ;;
    esac
done
