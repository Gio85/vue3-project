#!/usr/bin/env bash
ROOT=${PWD}

if ! yarn tsc --skipLibCheck ; then
  echo "💣 ⚠️ tsc failed"
  exit 1
fi

if ! yarn tslint --project ./tsconfig.json ; then
  echo "💣 ⚠️ tslint failed"
  exit 1
fi

if ! yarn pretty-quick --staged ; then
  echo "💣 ⚠️ pretty failed"
  exit 1
fi

