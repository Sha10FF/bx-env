#!/bin/bash

BX_WORKDIR=/etc/nginx
BX_TEMPLATE=bx.template
BX_TARGETDIR=sites-enabled
WWW_DIR=/var/www/public_html

# create nginx configs
cd ${WWW_DIR} || exit

[[ ! (-d "${BX_WORKDIR}/${BX_TARGETDIR}") ]] && mkdir -p "${BX_WORKDIR}/${BX_TARGETDIR}" || exit

for f in *
do
  [[ ! (-d ${f}) ]] && continue

  OUTPUT="${BX_WORKDIR}/${BX_TARGETDIR}/${f}.conf"
  [[ -f ${OUTPUT} ]] && continue

  TEMPLATE="${BX_WORKDIR}/${BX_TEMPLATE}"

  [[ ${f} =~ "." || ${BX_DEFAULT_LOCAL_DOMAIN} == '' ]] && HOST=${f} || HOST="${f}.${BX_DEFAULT_LOCAL_DOMAIN}"
  [[ ${HOST} == ${BX_DEFAULT_HOST} ]] && DEFAULT=" default_server" || DEFAULT=""

  touch "${OUTPUT}" && sed -e "s/%HOST%/${HOST}/; s/%NAME%/${f}/; s/%DEFAULT%/${DEFAULT}/" "${TEMPLATE}" > ${OUTPUT}
done
########################

set -e

[[ $DEBUG == true ]] && set -x

# allow arguments to be passed to nginx
if [[ ${1:0:1} = '-' ]]; then
    EXTRA_ARGS="$@"
    set --
elif [[ ${1} == nginx || ${1} == $(which nginx) ]]; then
    EXTRA_ARGS="${@:2}"
    set --
fi

# default behaviour is to launch nginx
if [[ -z ${1} ]]; then
    echo "Starting nginx..."
    exec $(which nginx) -g "daemon off;" ${EXTRA_ARGS}
else
    exec "$@"
fi