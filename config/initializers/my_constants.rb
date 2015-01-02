# Restart server after making changes to see them
# Run this to restart server: touch tmp/restart.txt

DEFAULT_MAX_BELIEFS = 25
USER_MAX_BELIEFS = 20

CONN_MULTIPLIER = 2 # a multiplier of 2 means there are twice as many connections as beliefs
# MIN_CONN_COUNT = 1 # smallest connection strength to display

MIN_BELIEF_SIZE = 3
MAX_BELIEF_SIZE = 10
MAX_BELIEF_SIZE_RANGE = MAX_BELIEF_SIZE - MIN_BELIEF_SIZE
MIN_CONN_SIZE = 3
MAX_CONN_SIZE = 6
MAX_CONN_SIZE_RANGE = MAX_CONN_SIZE - MIN_CONN_SIZE