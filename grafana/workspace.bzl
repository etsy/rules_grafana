load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_oci//oci:pull.bzl", "oci_pull")

DEFAULT_GRAFANA_TAG = "10.0.3"
DEFAULT_GRAFANA_SHA = "sha256:da34adacd374f6a4d539669a8d5dbda781aa004d429b2058aba9434a9224a04b"

def repositories(use_custom_container = False):
    """Defines WORKSPACE requirements for `rules_grafana`.  See README.md for detailed usage.

    Args:
        use_custom_container: use a custom container for grafana.
    """
    if not use_custom_container:
        oci_pull(
            name = "io_bazel_rules_grafana_docker",
            image = "index.docker.io/grafana/grafana",
            digest = DEFAULT_GRAFANA_SHA,
        )

def grafana_plugin(name, urls, sha256, type = None):
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )
