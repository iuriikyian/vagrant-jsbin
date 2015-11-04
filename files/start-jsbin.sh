#/bin/bash

. /home/vagrant/.nvm/nvm.sh
cd /home/vagrant/jsbin
node ./bin/jsbin & 1 > nohup.log 2 > nohup-error.log
