workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules_python master as of 2019-04-21
rules_python_version = "f7a96a4756aeda1cd0ece89f9813fc2c393c20a8"
git_repository(
    name = "io_bazel_rules_python",
    commit = rules_python_version,
    remote = "https://github.com/bazelbuild/rules_python.git",
)

load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories")

pip_repositories()

# rules_docker master as of 2019-04-21
rules_docker_version = "3332026921c918c9bfaa94052578d0ca578aab66"
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "8af10dccb3efab3ecb0ae29cf4f0a55ba2c11d711317ec95ed79793c7774068f",
    strip_prefix = "rules_docker-%s" % rules_docker_version,
    urls = ["https://github.com/bazelbuild/rules_docker/archive/%s.tar.gz" % rules_docker_version],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_grafana//grafana:workspace.bzl", "repositories", "grafana_plugin")

repositories()

load("@io_bazel_rules_grafana_deps//:requirements.bzl", "pip_install")

pip_install()

grafana_plugin(
    name = "grafana_plotly_plugin",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.5/download"],
    type = "zip",
    sha256 = "ba67afef48c9ce6c96978dd8d7e2ff2dc1f09e6cfd7eccf89bfaaf574347cd52",
)
