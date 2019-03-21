load("@io_bazel_rules_docker//container:image.bzl", "container_image")
load("@io_bazel_rules_docker//container:layer.bzl", "container_layer")

def grafana_image(name, datasources, dashboards, plugins=[], env={}, visibility=None):
    '''
    Builds a Docker image containing Grafana and the provided dashboards and datasources.
    '''
    container_layer(
        name = "%s_grafana_etc" % name,
        directory = "/etc/grafana",
        files = ["@io_bazel_rules_grafana//grafana:config/grafana.ini"],
    )

    container_layer(
        name = "%s_grafana_dashboards_provisioning" % name,
        directory = "/etc/grafana/provisioning/dashboards/",
        files = ["@io_bazel_rules_grafana//grafana:config/provisioning/dashboards.yaml"],
    )

    container_layer(
        name = "%s_grafana_datasources_provisioning" % name,
        directory = "/etc/grafana/provisioning/datasources/",
        files = datasources,
    )

    container_layer(
        name = "%s_grafana_plugins" % name,
        # Extra trailing plugins/ dir with data_path is required to preserve plugin structure.
        directory = "/var/lib/grafana/plugins/plugins/",
        files = plugins,
        data_path = '.',
    )

    # Copy the env, then add necessary settings:
    env = dict(**env)
    env.update({
        # This must be a writable path:
        "GF_PATHS_DATA": "/tmp",
    })

    container_image(
        name = name,
        base = "@io_bazel_rules_grafana_docker//image",
        layers = [
            "%s_grafana_etc" % name,
            "%s_grafana_dashboards_provisioning" % name,
            "%s_grafana_datasources_provisioning" % name,
            "%s_grafana_plugins" % name,
        ],
        directory = "/var/lib/grafana/dashboards/",
        env = env,
        files = dashboards,
        visibility = visibility,
    )
