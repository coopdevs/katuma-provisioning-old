#!/bin/sh

cd $HOME
git clone git@github.com:coopdevs/katuma.git
cd katuma
bundle install
bundle exec rake db:setup

cd $HOME
git clone git@github.com:coopdevs/katuma-web.git
cd katuma-web
yarn install
