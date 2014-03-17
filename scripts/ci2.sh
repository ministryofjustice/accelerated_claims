#!/bin/bash

function at_exit {
  echo `ps -Af | grep rails | grep -v grep`
  echo 'killing process...'
  kill `cat application.pid`
  sleep 1
  echo `ps -Af | grep rails | grep -v grep`
}
trap at_exit 0

daemonize -c . -l application.lock -v -p application.pid `which bundle` exec rails s -p 5555
sleep 10

casperjs test ./spec/javascript/ --url='http://localhost:5555/' --no-colors --xunit=log.xml

