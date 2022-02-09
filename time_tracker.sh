#!/bin/bash

#### USAGE ####

# TimeTracker service tracks time spent working based on the WM workspace you spend time on.
# TT will prompt for a description of the last time block when it detects you have stopped
# working by switching to a non-working workspace.

# To stop the service and record any currently running work block, create an empty
# file `stop` in TT_HOME:
#
# $ touch $TT_HOME/stop
# Note: no time will be recorded if the time block is less than WORK_START_DELAY

# To record a new block of work immediately without stopping TimeTracker (and without
# switching workspaces and watiting for WORK_STOP_DELAY), create an empty file `reset`
# in $TT_HOME:
#
# $ touch $TT_HOME/reset
# Note: no time will be recorded if the time block is less than WORK_START_DELAY

###############

# Location to store time tracking files. Timestamps are partitioned by month.
TT_HOME=~/time_tracking

# [Integer] | [Integer-range] Zero-indexed identifier of the desktops you use to work.
# By default, the first(0th) workspace is the only workspace considered non-working,
# ie. personal use.
WORKING_WORKSPACES="[1-9]"

# [Seconds] Delay when switching from working workspace to non-working workspace
# before work is considered to have stopped. Switching to non-working workspace
# and then back to working workspace in less than WORK_STOP_DELAY seconds will
# cause working time to keep running.
WORK_STOP_DELAY=90

# [Seconds] Delay after switching to working workspace before work is considered
# to have started. Switching from non-working workspace to working workspace in
# less than WORK_START_DELAY will prevent recording start of work time.
WORK_START_DELAY=60

# Working time recording is in minutes. WORK_RECORD_PRECISION is how many digits
# after the decimal point to show in the records
WORK_RECORD_PRECISION=1

# $TT_HOME/work_elapsed shows the current elapsed time in the currently running
# work time block, in minutes. This file can be read by other apps/tools to show
# current work status. WORK_ELAPSED_PRECISION is how many digits after the
# decimal point to show.
WORK_ELAPSED_PRECISION=0

current_ws ()
{
  wmctrl -d | grep \* | cut -d " " -f 1
}

ws_changed()
{
  ws=$(current_ws)
  echo "ws: $ws"
  case "$ws" in
  $WORKING_WORKSPACES)
    if [ "$W_START" == "" ]; then
      W_START=`date +%s`
    fi
  ;;
  *)
    NW_START=`date +%s`
    if [ "$W_START" != "" ]; then
      w_elapsed=`expr $(date +%s) - $W_START`
      if [ "$w_elapsed" -lt "$WORK_START_DELAY" ]; then
        W_START=""
      fi
    fi
  ;;
  esac
}

work_finished()
{
  immediate=$1

  if [ "$W_START" == "" ]; then
    return
  fi

  now=`date +%s`
  W_elapsed=`expr $now - $W_START`
  if [ "$W_elapsed" -lt "$WORK_START_DELAY" ]; then
    return
  fi

  if [ "$immediate" != true ]; then
    now=`expr $(date +%s) - $WORK_STOP_DELAY`
    echo "new now: $now"
  fi
  W_elapsed=`expr $now - $W_START`
  W_elapsed=`echo "scale=$WORK_RECORD_PRECISION; $W_elapsed / 60" | bc`

  timestamp=`date +%a-%Y/%m/%d`
  human_range="$(date -d @$W_START +%a-%Y/%m/%d@%H:%M) to $(date -d @$now +%a-%Y/%m/%d@%H:%M)"
  time_file=`date +%m-%Y`
  (
  w_response=$(yad --entry --title "Time Tracking: what did you work on?" --geometry=500x50+700+500 --text "From $human_range" --sticky --on-top --center)
  if [ "$w_response" == "" ]; then
    w_response="---"
  fi
  echo -e "$timestamp\t$W_elapsed\t$w_response" >> $TT_HOME/$time_file
  ) &
  W_START=""
}

reset ()
{
  work_finished true
  NW_START=""
  W_START=""
  rm $TT_HOME/work_elapsed
  ws_changed
}

WS=$(current_ws)
ws_changed
while [ true ] ; do
  # check for stop
  if [ -f $TT_HOME/stop ]; then
    reset
    rm $TT_HOME/stop
    exit 0
  fi

  # check for reset
  if [ -f $TT_HOME/reset ]; then
    reset
    rm $TT_HOME/reset
  fi

  if [ $WS != $(current_ws) ] ; then
    ws_changed
    WS=$(current_ws)
  elif [ $WS == 0 ] && [ "$NW_START" != "" ] && [ "$W_START" != "" ] ; then
    elapsed=`expr $(date +%s) - $NW_START`
    if [ "$elapsed" -gt "$WORK_STOP_DELAY" ]; then
      work_finished
    fi
  fi

  if [ "$W_START" != "" ]; then
      w_elapsed=`expr $(date +%s) - $W_START`
      if [ "$w_elapsed" -gt "$WORK_START_DELAY" ]; then
        echo "scale=$WORK_ELAPSED_PRECISION; $(expr $(date +%s) - $W_START) / 60" | bc > $TT_HOME/work_elapsed
      else
        echo "--" > $TT_HOME/work_elapsed
      fi
  elif [ -f $TT_HOME/work_elapsed ]; then
    rm $TT_HOME/work_elapsed
  fi
  sleep 1
done
