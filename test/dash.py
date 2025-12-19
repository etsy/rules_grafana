import json
import sys
from grafana_foundation_sdk.builders import dashboard as dashboard_builder
from grafana_foundation_sdk.builders import timeseries, prometheus
from grafana_foundation_sdk.cog.encoder import JSONEncoder
from grafana_foundation_sdk.models.dashboard import GridPos

# this should fail if loaded in python2
if b'test' == 'test':
    sys.exit(1)

dashboard = (
    dashboard_builder.Dashboard("Python sample")
    # UID is set by uid_injector based on filename
    .with_panel(
        timeseries.Panel()
        .title("Sample data")
        .grid_pos(GridPos(h=8, w=24, x=0, y=0))
        .with_target(
            prometheus.Dataquery()
            .expr('up{namespace="kube-system"}')
        )
    )
    .build()
)

print(json.dumps(dashboard, cls=JSONEncoder, indent=2))
