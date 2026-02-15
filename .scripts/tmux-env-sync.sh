#!/bin/bash
printenv | sed 's/^\([^=]*\)=\(.*\)$/set-environment -g \1 "\2"/'
