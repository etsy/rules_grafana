load("@io_bazel_rules_docker//container:image.bzl", "container_image")
load("@io_bazel_rules_docker//container:layer.bzl", "container_layer")

def grafana_image(name, datasources, dashboards, visibility=None):
    '''
    Builds a Docker image containing Grafana and the provided dashboards and datasources.
    '''
    container_layer(
        name = "grafana_etc",
        directory = "/etc/grafana",
        files = ["@io_bazel_rules_grafana//grafana:config/grafana.ini"],
    )

    container_layer(
        name = "grafana_dashboards_provisioning",
        directory = "/etc/grafana/provisioning/dashboards/",
        files = ["@io_bazel_rules_grafana//grafana:config/provisioning/dashboards.yaml"],
    )

    container_layer(
        name = "grafana_datasources_provisioning",
        directory = "/etc/grafana/provisioning/datasources/",
        files = datasources,
    )

    container_image(
        name = name,
        base = "@io_bazel_rules_grafana_docker//image",
        layers = [
            "grafana_etc",
            "grafana_dashboards_provisioning",
            "grafana_datasources_provisioning",
        ],
        directory = "/var/lib/grafana/dashboards/",
        env = {
            # This must be a writable path:
            "GF_PATHS_DATA": "/tmp",
        },
        files = dashboards,
        visibility = visibility,
    )
