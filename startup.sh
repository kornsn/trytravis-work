#!/usr/bin/env bash
# startup script

set -e

function install_ruby {
    echo "Install Ruby"

    # install
    apt update
    apt install -y ruby-full ruby-bundler build-essential

    # check
    ruby -v
    bundle -v
}

function install_mongo {
    echo "Install MongoDB"

    # install
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    apt update
    apt install -y mongodb-org

    # start
    systemctl start mongod
    systemctl enable mongod
}

function deploy {
    echo "Deploy application"

    git clone -b monolith https://github.com/express42/reddit.git
    cd reddit
    bundle install
    puma -d
}

function main {
    echo "This startup script installs ruby and mongodb, deploys application and runs it."

    install_ruby
    install_mongo
    deploy

    echo "Well done. Enjoy!"
}

main
