#!/bin/bash

if [ ! -f "${ZNC_HOME}/configs/znc.conf" ]; then
  echo "Copying default ZNC configuration"
  mkdir -p "${ZNC_HOME}/configs"
  cp /znc.conf.default "${ZNC_HOME}/configs/znc.conf"
fi
chown -R znc:znc ${ZNC_HOME}
su znc -c "znc --foreground --datadir ${ZNC_HOME} $@"
