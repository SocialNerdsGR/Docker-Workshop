#!/bin/bash

useradd -ms /bin/bash -u $UID serveruser

exec "$@"