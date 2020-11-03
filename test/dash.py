from grafanalib.core import *
from grafanalib._gen import print_dashboard
import sys

# this should fail if loaded in python2
if b'test' == 'test':
    sys.exit(1)

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
