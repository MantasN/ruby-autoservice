#!/bin/bash

clear

echo -e "Command: \nA. Reek\nB. Rubocop\nC. RSpec\n"
echo -e "D. Mutant detail.rb\nE. Mutant job.rb"
echo -e "F. Mutant part.rb\nG. Mutant order.rb\nH. Mutant report.rb\n"

read -p "Select command [A, B, ...]: " choice

case "$choice" in
  a|A )
        reek;;
  b|B )
        rubocop --require rubocop-rspec;;
  c|C )
        rspec;;
  d|D )
        RAILS_ENV=test bundle exec mutant -r ./config/environment --jobs 1 --use rspec Detail;;
  e|E )
        RAILS_ENV=test bundle exec mutant -r ./config/environment --jobs 1 --use rspec Job;;
  f|F )
        RAILS_ENV=test bundle exec mutant -r ./config/environment --jobs 1 --use rspec Part;;
  g|G )
        RAILS_ENV=test bundle exec mutant -r ./config/environment --jobs 1 --use rspec Order;;
  h|H )
        RAILS_ENV=test bundle exec mutant -r ./config/environment --jobs 1 --use rspec Report;;
  * )
        echo "Invalid letter pressed!"
        exit;;
esac