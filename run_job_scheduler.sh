#!/bin/bash
for i in {1..10}; do
  bin/rails runner "JobScheduler.new('sched-${i}').start_work!" &
done

sleep 60
