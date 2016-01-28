#! /bin/sh

root=$(dirname $0)
npm=$(which npm)
supervisor=$(which supervisor)
lsc=`which lsc`

if [ -z $npm ]; then
  echo 'npm is not install. Cannot really help you'
fi

if [ -z $supervisor ]; then
  echo "supervisor is not installed. Let's do that..."
  if ! $npm install -g supervisor; then
    echo 'Unable to install supervisor'
    exit 1
  fi
  supervisor=$(which supervisor)
fi

if [ -z $lsc ]; then
  echo "Livescript is not installed. Let's do that..."
  if ! $npm install -g livescript; then
    echo 'Unable to install supervisor'
    exit 1
  fi
  lsc=$(which lsc)
fi

cd $root

pushd client
echo "Updating client's node modules"
$npm install
popd

pushd server
echo "Updating server's node modules"
$npm install
echo "Starting supervised server"
$supervisor -w .. -e node,js,ls,json -x $lsc index.ls
popd
