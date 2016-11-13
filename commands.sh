#!/bin/bash

clear

echo -e "Command: \nA. Reek\nB. Rubocop\nC. RSpec\n"
echo -e "D. Mutant detail.rb\nE. Mutant job.rb"
echo -e "F. Mutant order.rb\nG. Mutant part.rb\nH. Mutant _report.rb\n"

read -p "Select command [A, B, ...]: " choice

case "$choice" in
  a|A )
        reek;;
  b|B )
        rubocop --require rubocop-rspec;;
  c|C )
        rspec;;
  d|D )
        bundle exec mutant --include app/models/ --require detail.rb --use rspec "Detail*";;
  e|E )
        bundle exec mutant --include app/models/ --require job.rb --use rspec "Job*";;
  f|F )
        bundle exec mutant --include app/models/ --require order.rb --use rspec "Part*";;
  g|G )
        bundle exec mutant --include app/models/ --require part.rb --use rspec "Order*";;
  h|H )
        bundle exec mutant --include app/models/ --require report.rb --use rspec "Report*";;
  * )
        echo "Invalid letter pressed!"
        exit;;
esac