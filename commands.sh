#!/bin/bash

clear

echo -e "Command: \nA. Reek\nB. Rubocop\nC. RSpec\n"
echo -e "D. Mutant data_repository.rb\nE. Mutant orders_manager.rb\nF. Mutant repair_details.rb\nG. Mutant repair_job.rb"
echo -e "H. Mutant repair_order.rb\nI. Mutant repair_part.rb\nJ. Mutant repair_report.rb\n"

read -p "Select command [A, B, ...]: " choice

case "$choice" in
  a|A )
        reek;;
  b|B )
        rubocop --require rubocop-rspec;;
  c|C )
        rspec;;
  d|D )
        bundle exec mutant --include lib/ --require data_repository.rb --use rspec "DataRepository*";;
  e|E )
        bundle exec mutant --include lib/ --require orders_manager.rb --use rspec "OrdersManager*";;
  f|F )
        bundle exec mutant --include lib/ --require repair_details.rb --use rspec "RepairDetails*";;
  g|G )
        bundle exec mutant --include lib/ --require repair_job.rb --use rspec "RepairJob*";;
  h|H )
        bundle exec mutant --include lib/ --require repair_order.rb --use rspec "RepairPart*";;
  i|I )
        bundle exec mutant --include lib/ --require repair_part.rb --use rspec "RepairOrder*";;
  j|J )
        bundle exec mutant --include lib/ --require repair_report.rb --use rspec "RepairReport*";;
  * )
        echo "Invalid letter pressed!"
        exit;;
esac