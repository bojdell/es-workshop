#!/bin/bash

# generate site html from jade templates
node node_modules/jade/bin/jade.js *.jade -P -o ../public/
