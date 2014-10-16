#!/bin/bash
export DISPLAY=:2

SERVER_NAME=${SERVER_NAME-default}

if [ -n "$GOOGLE_USER" ]; then
  /usr/bin/google-musicmanager -a "$GOOGLE_USER" -p "$GOOGLE_PASS" -s /music -m "$SERVER_NAME"
else
  /usr/bin/google-musicmanager -s /music -m "$SERVER_NAME"
fi

PID=$(ps aux | grep /usr/bin/google-musicmanager | grep -v grep | awk '{print $2}')

while kill -0 "$PID"; do
  sleep 1
done
