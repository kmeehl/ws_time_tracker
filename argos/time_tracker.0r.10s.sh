#!/usr/bin/env bash

if [ -f ~/time_tracking/work_elapsed ]; then
  tt_elapsed=`cat ~/time_tracking/work_elapsed`
fi
echo "<span weight='normal' color='red'><tt>$tt_elapsed</tt></span> | iconName=appointment-new-symbolic"
echo "---"

echo "Timetracker(<span color='green'><tt>start</tt></span>) | iconName=appointment-new-symbolic bash=~/bin/time_tracker.sh terminal=false"
echo "Timetracker(<span color='blue'><tt>context switch</tt></span>) | iconName=appointment-new-symbolic bash="touch ~/time_tracking/reset" terminal=false"
echo "Timetracker(<span color='red'><tt>stop</tt></span>) | iconName=appointment-new-symbolic bash="touch ~/time_tracking/stop" terminal=false"
echo "---"
