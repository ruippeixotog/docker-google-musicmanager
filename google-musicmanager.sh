#!/bin/bash
export DISPLAY=:2

SERVER_NAME=${SERVER_NAME-default}

function google-musicmanager {
  if [[ $SPOOF_MAC == "false" ]]; then
    /usr/bin/google-musicmanager "$@"
  else
    /usr/local/bin/macspoof -c 'default_application: [0x00, 0x25, 0x90];' -- /usr/bin/google-musicmanager "$@"
  fi
}

if [ -n "$GOOGLE_USER" ]; then
  google-musicmanager -a "$GOOGLE_USER" -p "$GOOGLE_PASS" -s /music -m "$SERVER_NAME"
else
  google-musicmanager -s /music -m "$SERVER_NAME"
fi

PID=$(ps aux | grep /usr/bin/google-musicmanager | grep -v grep | awk '{print $2}')

while kill -0 "$PID"; do
  sleep 1
done
