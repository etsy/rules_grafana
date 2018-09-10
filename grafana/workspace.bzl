load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories", "pip_import")
pip_repositories()

def repositories():
    pip_import(
        name = "io_bazel_rules_grafana_deps",
        requirements = "@io_bazel_rules_grafana//grafana:requirements.txt",
    )
