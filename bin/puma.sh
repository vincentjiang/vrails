#! /bin/sh

PUMA_CONFIG_FILE=/home/deployer/vrails/current/config/puma.rb
PUMA_PID_FILE=/home/deployer/vrails/shared/tmp/pids/puma.pid
PUMA_SOCKET=/home/deployer/vrails/shared/tmp/sockets/puma.sock
DEPLOYER=deployer #设置用户

# check if puma process is running
puma_is_running() {
  if [ -S $PUMA_SOCKET ] ; then
    if [ -e $PUMA_PID_FILE ] ; then
      if cat $PUMA_PID_FILE | xargs pgrep -P > /dev/null ; then
        return 0
      else
        echo "No puma process found"
      fi
    else
      echo "No puma pid file found"
    fi
  else
    echo "No puma socket found"
  fi

  return 1
}

case "$1" in
  start)
    echo "Starting puma..."
      if [ -e $PUMA_SOCKET  ] ; then
        rm -f $PUMA_SOCKET
        echo "removed $PUMA_SOCKET"
      fi
      if [ -e $PUMA_CONFIG_FILE ] ; then
        /bin/bash --login -c "bundle exec puma -C $PUMA_CONFIG_FILE"
      else
        bundle exec puma --daemon --bind unix://$PUMA_SOCKET --pidfile $PUMA_PID_FILE
      fi

    echo "done"
    ;;

  stop)
    if [ -e $PUMA_PID_FILE ] ; then
      echo "Stopping puma..."
      /bin/bash --login -c " kill -s SIGTERM `cat $PUMA_PID_FILE` "
      echo "Killed puma PID `cat $PUMA_PID_FILE`"
      rm -f $PUMA_PID_FILE
      rm -f $PUMA_SOCKET
    fi
    if [ -e $PUMA_SOCKET ] ; then # if socket exists
      rm -f $PUMA_SOCKET
      echo "removed  $PUMA_SOCKET"
    fi
    echo "done"
    ;;

  restart)
    if puma_is_running ; then
      echo "Hot-restarting puma..."
      if [ -e $PUMA_PID_FILE ] ; then
        /bin/bash --login -c " kill -s SIGUSR2 `cat $PUMA_PID_FILE` "
        echo "Killed puma PID `cat $PUMA_PID_FILE`"
      fi

      echo "Doublechecking the process restart..."
      sleep 5
      if puma_is_running ; then
        echo "done"
        exit 0
      else
        echo "Puma restart failed :/"
      fi
    fi

    echo "Trying cold reboot"
    $0 start # 表示bin/puma.sh start
    ;;

  status)
    if puma_is_running ; then
      echo "puma is running"
      exit 0
    else
      echo "puma is not running"
      exit 1 # return error
    fi

    ;;

  *)
    echo "Usage: bin/puma.sh {start|stop|restart}" >&2
    ;;
esac