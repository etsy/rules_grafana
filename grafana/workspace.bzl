load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@io_bazel_rules_docker//container:container.bzl", "container_pull")
load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")

DEFAULT_GRAFANA_TAG = "9.1.1"
DEFAULT_GRAFANA_SHA = "sha256:bd46093a1c8b7e383a82ba0c4abeb0935e828a7580648833d1c9ae047b364cef"

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
