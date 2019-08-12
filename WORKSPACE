workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules go
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "a82a352bffae6bee4e95f68a8d80a70e87f42c4741e6a448bec11998fcc82329",
    url = "https://github.com/bazelbuild/rules_go/releases/download/0.18.5/rules_go-0.18.5.tar.gz",
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

# rules gazelle
http_archive(
    name = "bazel_gazelle",
    sha256 = "3c681998538231a2d24d0c07ed5a7658cb72bfb5fd4bf9911157c0e9ac6a2687",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.17.0/bazel-gazelle-0.17.0.tar.gz"],
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

# rules_python master as of 2019-08-12
rules_python_version = "4b84ad270387a7c439ebdccfd530e2339601ef27"
git_repository(
    name = "rules_python",
    commit = rules_python_version,
    remote = "https://github.com/bazelbuild/rules_python.git",
)
load("@rules_python//python:pip.bzl", "pip_repositories")

pip_repositories()

# rules_docker master on 2019-08-10
rules_docker_version = "03de60d444fafa165e3eef669fa64f31a6424d0f"
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "28629532945596f3145b94d9aa0f0236d8b6bb46898ce888922cff9be03a1fd6",
    strip_prefix = "rules_docker-%s" % rules_docker_version,
    type = "zip",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/%s.zip" % rules_docker_version,]
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)
load(
    "@io_bazel_rules_docker//repositories:go_repositories.bzl",
    container_go_deps = "go_deps",
)

container_go_deps()

# end external rules

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
