from grafanalib.core import *
from grafanalib._gen import print_dashboard

dashboard = Dashboard(
    title="Python sample",
    rows=[
        Row(panels=[
            Graph(
                title="Sample data",
                targets=[
                    Target(expr='up{namespace="kube-system"}', ),
                ],
            ),
        ]),
    ],
)

print_dashboard(dashboard)
