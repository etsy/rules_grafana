import json
from grafana_foundation_sdk.builders import dashboard as dashboard_builder
from grafana_foundation_sdk.builders import text, timeseries
from grafana_foundation_sdk.cog.encoder import JSONEncoder
from grafana_foundation_sdk.models.dashboard import GridPos

dashboard = (
    dashboard_builder.Dashboard("Python sample")
    # UID is set by uid_injector based on filename
    .with_panel(
        text.Panel()
        .title("Hello world!")
        .grid_pos(GridPos(h=8, w=12, x=0, y=0))
    )
    .with_panel(
        timeseries.Panel()
        .title("Sample data")
        .grid_pos(GridPos(h=8, w=12, x=12, y=0))
    )
    .build()
)

print(json.dumps(dashboard, cls=JSONEncoder, indent=2))
