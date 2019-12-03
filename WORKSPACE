workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules go
bazel_rules_go_version = "v0.20.2"

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "b9aa86ec08a292b97ec4591cf578e020b35f98e12173bbd4a921f84f583aebd9",
    url = "https://github.com/bazelbuild/rules_go/releases/download/%s/rules_go-%s.tar.gz" % (bazel_rules_go_version, bazel_rules_go_version),
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

# rules gazelle
http_archive(
    name = "bazel_gazelle",
    sha256 = "86c6d481b3f7aedc1d60c1c211c6f76da282ae197c3b3160f54bd3a8f847896f",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.19.1/bazel-gazelle-v0.19.1.tar.gz"],
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

# rules_python master as of 2019-11-15
rules_python_version = "94677401bc56ed5d756f50b441a6a5c7f735a6d4"

git_repository(
    name = "rules_python",
    commit = rules_python_version,
    remote = "https://github.com/bazelbuild/rules_python.git",
)

load("@rules_python//python:pip.bzl", "pip_repositories")

pip_repositories()

# rules_docker master on 2019-10-25
rules_docker_version = "0.12.1"

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "8137d638349b076a1462f06d33d3ec5aaef607c0944fd73478447a7bc313e918",
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

load("@io_bazel_rules_grafana_deps//:requirements.bzl", "pip_install")
load("@io_bazel_rules_grafana_deps3//:requirements.bzl", pip_install3 = "pip_install")

pip_install()
pip_install3()

grafana_plugin(
    name = "grafana_plotly_plugin",
    sha256 = "ba67afef48c9ce6c96978dd8d7e2ff2dc1f09e6cfd7eccf89bfaaf574347cd52",
    type = "zip",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.5/download"],
)
