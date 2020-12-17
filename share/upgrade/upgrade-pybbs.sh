#!/usr/bin/env bash

VERSION=$1
APP_HOME=$2
SASD=pybbs-$VERSION
KEEP_OLD_CONF=pybbs-conf

function error_exit
{
	echo "$1" 1>&2
	exit 1
}

# stop old instance
echo "stopping old instance ..."
sudo /home/pybbs/bin/stop-pybbs.sh || error_exit "unable to stop pybbs server"

# because use same version info, need keep old config and remove old folder first
# step 1 keep the corrent config
echo "Upgrading pybbs server now ..."
cd $APP_HOME
if [ -d ${KEEP_OLD_CONF} ]; then
  rm -rf ${KEEP_OLD_CONF}/
  mkdir ${KEEP_OLD_CONF}
else
  mkdir ${KEEP_OLD_CONF}
fi
if [ -d ./current ]; then
	OLD=`/bin/readlink -f ./current`
	cp -rf current/conf ${KEEP_OLD_CONF}/
	rm -f current
fi
# step 2 remove old folders
if [ -d $OLD ]; then
	echo "deleting old directory $OLD"
	rm -rf $OLD
fi

#cp ./target/$IHAPID.tar.gz $APP_HOME
tar -zxf $SASD.tar.gz

ln -s $APP_HOME/$SASD $APP_HOME/current
# copy old conf back to current
cp -rf ${KEEP_OLD_CONF}/conf current/

echo "starting new instance ..."
sudo /home/pybbs/bin/start-pybbs.sh || error_exit "unable to start pybbs server"

# do some cleanup
rm $SASD.tar.gz

