load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@io_bazel_rules_docker//container:container.bzl", "container_pull")
load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

DEFAULT_GRAFANA_TAG = "10.0.3"
DEFAULT_GRAFANA_SHA = "sha256:da34adacd374f6a4d539669a8d5dbda781aa004d429b2058aba9434a9224a04b"

def repositories(use_custom_container = False):
    """Defines WORKSPACE requirements for `rules_grafana`.  See README.md for detailed usage.

    Args:
        use_custom_container: use a custom container for grafana.
    """
    container_repositories()

    if not use_custom_container:
        container_pull(
            name = "io_bazel_rules_grafana_docker",
            registry = "index.docker.io",
            repository = "grafana/grafana",
            tag = DEFAULT_GRAFANA_TAG,
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
