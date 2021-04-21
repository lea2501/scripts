#!/bin/ksh
while true; do
	BATT=$(apm -l)
	VALUE=10
	#echo "Batt: $BATT"
	if [ "${BATT}" -le "${VALUE}" ];
	then
		$(doas shutdown -hp now)
	fi
	sleep 300;
done
