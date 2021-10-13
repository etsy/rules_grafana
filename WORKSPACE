workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules_python master as of 2020-11-03
rules_python_version = "5be1f76e3ecd1f743f4213f3087c2a0961411782"

git_repository(
    name = "rules_python",
    commit = rules_python_version,
    remote = "https://github.com/bazelbuild/rules_python.git",
)

# rules_docker as of 2021-08-26
rules_docker_version = "0.19.0"

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "5059926d705ce46f078c875baa8d3a58c866da3716a30312c162f96bdc6956a2",
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
