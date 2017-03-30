
NAME=`dd bs=1 count=12 if=/dev/c0d0 skip=1024 2> /dev/null | cat`
user add -m -g users $NAME
su -K $NAME
