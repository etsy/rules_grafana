#!/bin/bash

# Image entrypoint.

# Update the `mtime` of all the dashboards to now.  Grafana only updated provisioned dashboards that are newer than a
# timestamp stored in the DB.  As rules_docker forces the timestamps to 1970-01-01, it never notices the updates.  This
# forces an update on every start.
touch /var/lib/grafana/dashboards/*.json
# Call the underlying entrypoint to start the server.
exec /run.sh "$@"
