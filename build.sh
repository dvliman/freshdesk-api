#!/bin/bash 

if [ -e freshdesk-0.1.gem ]; then 
  rm freshdesk-0.1.gem
fi 

gem build freshdesk.gemspec
sudo gem install freshdesk-0.1.gem
