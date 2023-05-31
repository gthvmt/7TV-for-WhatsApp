#!/bin/bash
curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
apt install -y nodejs
npm install -g semantic-release @semantic-release/git semantic-release-gitmoji semantic-release-flutter-plugin
npx semantic-release
