
if [ "$#" -ne 1 ]; then
    echo "Usage: sh dse.sh URN"
    exit
fi


export CONFFILE=/vagrant/gen49/conf/gen49-unveil.gradle
echo "Validating using configuration in $CONFFILE"


cd /vagrant/unveil

echo "Cleaning previous UnVEIL results..."
gradle clean

echo Beginning verification for folio $1

gradle -Pfolio=$1 -Pconf=$CONFFILE  dse
