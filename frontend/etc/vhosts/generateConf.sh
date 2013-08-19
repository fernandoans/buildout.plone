#!/bin/bash
#./generateConf.sh portal

TEMPLATE="../templates/portal.conf.in"
VAR_PORTALID=$1
VAR_PLONE_SITE_ID=$2
VAR_MIRROR_NGINX="../../var/www/$VAR_PORTALID/mirror"
VAR_TMP_NGINX="../../var/www/$VAR_PORTALID/tmp"

if [ $1 -a $2 ]; then
    if [ -f $TEMPLATE ]; then
        if [ -f ./$VAR_PORTALID.conf ]; then
            echo "O arquivo $VAR_PORTALID.conf já existe.";
        else
            cat $TEMPLATE | sed -e s/VAR_PORTALID/$VAR_PORTALID/g | sed -e s/VAR_PLONE_SITE_ID/$VAR_PLONE_SITE_ID/g | tee ./$VAR_PORTALID.conf 1>/dev/null;
            echo "O arquivo $VAR_PORTALID.conf foi criado com sucesso!";
            if [ ! -d $VAR_MIRROR_NGINX ]; then
                mkdir -p $VAR_MIRROR_NGINX;
                echo "Criando o diretório MIRROR em: $VAR_MIRROR_NGINX";
            fi
            if [ ! -d $VAR_TMP_NGINX ]; then
                mkdir -p $VAR_TMP_NGINX;
                echo "Criando o diretório TMP em: $VAR_MIRROR_NGINX";
            fi
        fi
    else
        echo "O arquivo $TEMPLATE não foi encontrado.";
    fi
else
    echo "Falta argumento."
fi