#!/bin/sh

for f in ./watchdog/fwatchdog*; do shasum -a 256 $f > $f.sha256; done