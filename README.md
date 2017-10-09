# WS_TIME_TRACKER

Workspace TimeTracker service tracks time spent working based on the window manager workspace you spend time on.
TT will prompt for a description of the last time block when it detects you have stopped
working (by switching to a non-working workspace).
 

## Usage

### Start
Add to PATH and run from command line:
```
$ ./time_tracker.sh &
```
Or add to your desktop startup applications

### Stop

To stop the service and record any currently running work block, create an empty
file `$TT_HOME/stop`:
```
$ touch $TT_HOME/stop
```
Note: no time will be recorded if the time block is less than WORK_START_DELAY
TT_HOME is configurable -- default value is ~/time_tracking

To record a new block of work immediately without stopping TimeTracker (and without
switching workspaces and watiting for WORK_STOP_DELAY), create an empty file `$TT_HOME/reset`:
```
$ touch $TT_HOME/reset
```
Note: no time will be recorded if the time block is less than WORK_START_DELAY


## Installation

TT uses `wmctrl` and `yad`

### Ubuntu

```
sudo apt install wmctrl yad
```

### Other

`TBD`


