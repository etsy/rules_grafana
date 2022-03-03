workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules_python
rules_python_version = "0.6.0"

http_archive(
    name = "rules_python",
    sha256 = "8911e8a96ad591afded29c90c1ce4341c988f8e41b1a469c7fb593bd6025e193",
    strip_prefix = "rules_python-%s" % rules_python_version,
    type = "zip",
    urls = [
        "https://github.com/bazelbuild/rules_python/archive/%s.zip" % rules_python_version,
    ],
)

# rules_docker
rules_docker_version = "0.22.0"

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-%s" % rules_docker_version,
    type = "zip",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v%s.zip" % rules_docker_version],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load(
    "@io_bazel_rules_docker//repositories:go_repositories.bzl",
    container_go_deps = "go_deps",
)

container_go_deps()

# end external rules

load("@io_bazel_rules_grafana//grafana:workspace.bzl", "grafana_plugin", "repositories")

repositories()

grafana_plugin(
    name = "grafana_plotly_plugin",
    sha256 = "ba67afef48c9ce6c96978dd8d7e2ff2dc1f09e6cfd7eccf89bfaaf574347cd52",
    type = "zip",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.5/download"],
)
