from grafanalib.core import *
from grafanalib._gen import print_dashboard

dashboard = Dashboard(
    title="Python sample",
    rows=[
        Row(panels=[
            Text(content="Hello world!"),
            Graph(
                title="Sample data",
                targets=[
                    Target(),
                ],
            ),
        ]),
    ],
)

print_dashboard(dashboard.auto_panel_ids())
