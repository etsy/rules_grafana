load("@rules_oci//oci:defs.bzl", "oci_image")
load("@rules_pkg_grafana//pkg:tar.bzl", "pkg_tar")

def grafana_image(name, datasources, dashboards, plugins = [], env = {}, visibility = None):
    """
    Builds a Docker image containing Grafana and the provided dashboards and datasources.

    Args:
        name: Unique name for this target.
        datasources: List of labels of `datasources.yaml` files to include in the image.
        dashboards: List of labels of `json_dashboards` and/or `py_dashboards` targets to include in the image.
        plugins: List of labels of `grafana_plugin` targets.
        env: Dictionary of environment variant names to values, set in the Docker image when Grafana is run.
        visibility: Controls whether the rule can be used by other packages.
    """
    pkg_tar(
        name = "%s_grafana_etc" % name,
        allow_duplicates_with_different_content = False,
        package_dir = "/etc/grafana",
        srcs = [
            "@io_bazel_rules_grafana//grafana:config/grafana.ini",
            "@io_bazel_rules_grafana//grafana:config/entrypoint.sh",
        ],
    )

    pkg_tar(
        name = "%s_grafana_dashboards_provisioning" % name,
        allow_duplicates_with_different_content = False,
        package_dir = "/etc/grafana/provisioning/dashboards/",
        srcs = ["@io_bazel_rules_grafana//grafana:config/provisioning/dashboards.yaml"],
    )

    pkg_tar(
        name = "%s_grafana_datasources_provisioning" % name,
        allow_duplicates_with_different_content = False,
        package_dir = "/etc/grafana/provisioning/datasources/",
        srcs = datasources,
    )

    pkg_tar(
        name = "%s_grafana_plugins" % name,
        allow_duplicates_with_different_content = False,
        package_dir = "/var/lib/grafana/plugins/",
        # rules_docker directory structure did not include external directory.
        strip_prefix = "/external",
        srcs = plugins,
    )

    pkg_tar(
        name = "%s_dashboards" % name,
        allow_duplicates_with_different_content = False,
        # Dashboard files must be writable for entrypoint.sh.
        mode = "0o666",  # octal
        package_dir = "/var/lib/grafana/dashboards/",
        srcs = dashboards,
    )

    # Copy the env, then add necessary settings:
    env = dict(**env)
    env.update({
        # This must be a writable path:
        "GF_PATHS_DATA": "/tmp",
    })

    oci_image(
        name = name,
        base = "@io_bazel_rules_grafana_docker",
        tars = [
            "%s_grafana_etc" % name,
            "%s_grafana_dashboards_provisioning" % name,
            "%s_grafana_datasources_provisioning" % name,
            "%s_grafana_plugins" % name,
            "%s_dashboards" % name,
        ],
        entrypoint = ["/etc/grafana/entrypoint.sh"],
        env = env,
        visibility = visibility,
    )
