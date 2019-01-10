load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories", "pip_import")
pip_repositories()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
    container_repositories = "repositories",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def repositories():
    pip_import(
        name = "io_bazel_rules_grafana_deps",
        requirements = "@io_bazel_rules_grafana//grafana:requirements.txt",
    )

    container_repositories()

    container_pull(
        name = "io_bazel_rules_grafana_docker",
        registry = "index.docker.io",
        repository = "grafana/grafana",
        tag = "5.4.2",
    )

def grafana_plugin(name, urls, sha256, type=None):
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )
