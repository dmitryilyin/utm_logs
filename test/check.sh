#!/bin/sh
find test -type f -o -type l | xargs -I @ ls -la '@'
