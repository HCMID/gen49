
if [ "$#" -ne 1 ]; then
    echo "Usage: sh validate.sh URN"
    exit
fi


export CONFFILE= /vagrant/gen49/conf/gen49-unveil.gradle
echo "Validating using configuration in $CONFFILE"


cd /vagrant/hmt-mom

echo "Cleaning previous HMT MOM results..."
gradle clean

echo Beginning verification for folio $1

gradle -Pfolio=$1 -Pconf=/vagrant/gen49/configs/vm-mom-config.gradle  validate
