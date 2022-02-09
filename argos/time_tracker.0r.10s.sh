#!/usr/bin/env bash

if [ -f ~/time_tracking/work_elapsed ]; then
  tt_elapsed=`cat ~/time_tracking/work_elapsed`
fi
echo " | iconName=chronometer"
echo "---"

TTPS=`ps aux |grep time_tracker.sh |grep -v grep`
if [ -z "$tt_elapsed" ]; then
  echo "Timetracker (stopped) | iconName=chronometer  terminal=false"
  RUNNING="Stopped"
else
  if [ -z "$TTPS" ]; then
      echo "Timetracker -ERROR- | iconName=chronometer  terminal=false"
  else
      echo "Timetracker (<span color='white'><tt>$tt_elapsed</tt></span>) | iconName=chronometer  terminal=false"
      RUNNING="Running"
  fi
fi

echo "---"
echo " <span color='green'>start</span> | iconName=chronometer-start bash='nohup ~/bin/time_tracker.sh & >/dev/null' terminal=false"
echo " <span color='lightblue'>context switch</span> | iconName=chronometer-reset bash='touch ~/time_tracking/reset' terminal=false"
echo " <span color='red'>stop</span> | iconName=chronometer-pause bash='touch ~/time_tracking/stop' terminal=false"
