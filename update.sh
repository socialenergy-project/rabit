#!/bin/bash
. ~/.bash_profile


# import rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
set -euxo pipefail
error_handler() {
  echo "******* FAILED *******" 1>&2
}

trap error_handler ERR

# enter deploy directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# pull new code
git pull # --recurse-submodules
# git submodule update --recursive --remote
# git submodule foreach git pull

# git pull 

# install new gems
bundle install

# update the database
RAILS_ENV=production rails db:migrate

# create new seeds
[ "$1" == --seed ] && RAILS_ENV=production rails db:seed

# and the static files
RAILS_ENV=production rails assets:precompile || echo "Not compiled"

# and restart the server
passenger-config restart-app .


# commit the new assets back to the repo
# git add .
# git commit -m "Asset precompile"
# git push

