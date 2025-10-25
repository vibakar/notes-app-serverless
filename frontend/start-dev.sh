#!/bin/sh

envsubst < ./public/runtime-config.template.js > ./public/runtime-config.js

npx vite