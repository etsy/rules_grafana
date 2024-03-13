load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_oci//oci:pull.bzl", "oci_pull")

DEFAULT_GRAFANA_TAG = "10.4.0"
DEFAULT_GRAFANA_SHA = "sha256:c7ae30e06ee76656f4faf37df1f0d0dfb6941a706b66800a7b289a304d31d771"

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

    # rules_pkg
    http_archive(
        # Use our own namespace of rules_pkg so we don't conflict with others.
        name = "rules_pkg_grafana",
        sha256 = "e93b7309591cabd68828a1bcddade1c158954d323be2205063e718763627682a",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.10.0/rules_pkg-0.10.0.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.10.0/rules_pkg-0.10.0.tar.gz",
        ],
    )
    # end rules_pkg

def grafana_plugin(name, urls, sha256, type = None):
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )
