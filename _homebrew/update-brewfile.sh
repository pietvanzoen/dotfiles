#!/bin/bash

set -ex

BREWFILE="$(dirname $BASH_SOURCE[0])/Brewfile"

brew leaves | sed -E "s/(.*)/brew '\1'/g" > $BREWFILE
