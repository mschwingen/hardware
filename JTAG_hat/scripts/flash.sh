#!/bin/bash
cd ~
scripts/target-power 1
date >>flash.log
set -o pipefail
openocd -f flash/autoflash.cfg -c "program flash/autoflash.elf verify reset exit" 2>&1 | tee -a flash.log
rc=$?
scripts/target-power 0
exit $rc
