#!/usr/bin/expect -f
spawn ssh-copy-id -o StrictHostKeyChecking=accept-new $argv
expect "password:"
send "pureuser\n"
expect eof
