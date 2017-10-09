# Workspace Time Tracker

Workspace Time Tracker service tracks time spent working based on the window manager workspace you spend time on.
TT will prompt for a description of the last time block when it detects you have stopped
working (by switching to a non-working workspace).

TT tries to stay out of your way by waiting for WORK_STOP_DELAY seconds after switching from a working workspace to
a non-working workspace to assume you've stopped working. The idea is we all context switch out of work in order to
answer a quick message, check weather, etc -- but it's best assume we've not stopped working unless we've been off
of a working workspace for long enough. Similarly, TT will start recording work until you've been in a working
workspace for WORK_START_DELAY seconds. WORK_STOP_DELAY and WORK_START_DELAY are configurable values in the script.

## Usage

### Start
Add to PATH and run from command line:
```
$ nohup ./time_tracker.sh &
```
Or add to your desktop startup applications

### Stop

To stop the service and record any currently running work block, create an empty
file `$TT_HOME/stop`:
```
$ touch $TT_HOME/stop
```
Note: no time will be recorded if the time block is less than WORK_START_DELAY

By default, TT_HOME is `~/time_tracking`, but it is configurable

To record a new block of work immediately without stopping TimeTracker (and without
switching workspaces and watiting for WORK_STOP_DELAY), create an empty file `$TT_HOME/reset`:
```
$ touch $TT_HOME/reset
```
Note: no time will be recorded if the time block is less than WORK_START_DELAY


## Installation

TT requires [wmctrl](https://www.freedesktop.org/wiki/Software/wmctrl/) and [yad](http://www.webupd8.org/2010/12/yad-zenity-on-steroids-display.html)

### Ubuntu

```
sudo apt install wmctrl yad
```

### Other

`TBD`


