#!/bin/ksh

if [ ! -f /etc/chromium/policies/managed/openbsd.json ]; then
    {
		echo "{"
		echo "    \"BackgroundModeEnabled\": false,"
        echo "    \"NewTabPageLocation\": \"about:blank\""
		echo "}"
    } > /tmp/openbsd.json
    doas mkdir -p /etc/chromium/policies/managed
    doas mv /tmp/openbsd.json /etc/chromium/policies/managed/openbsd.json
fi
