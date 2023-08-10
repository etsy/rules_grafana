workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# bazel_skylib released 2023.05.31
bazel_skylib_version = "1.4.2"

http_archive(
    name = "bazel_skylib",
    sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/%s/bazel-skylib-%s.tar.gz" % (bazel_skylib_version, bazel_skylib_version),
)
# end bazel_skylib

# rules_python
rules_python_version = "0.24.0"

http_archive(
    name = "rules_python",
    sha256 = "277eda8a22387cb7660b33bab49a3c921574025c46660ac61453e2af7616e6d1",
    strip_prefix = "rules_python-{version}".format(version = rules_python_version),
    type = "zip",
    url = "https://github.com/bazelbuild/rules_python/archive/{}.zip".format(rules_python_version),
)

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

python_register_toolchains(
    name = "python_3_11",
    python_version = "3.11",
)

load("@python_3_11//:defs.bzl", "interpreter")
load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "io_bazel_rules_grafana_deps",
    python_interpreter_target = interpreter,
    requirements_lock = "//grafana:requirements.txt",
)

load("@io_bazel_rules_grafana_deps//:requirements.bzl", install_deps_grafanalib = "install_deps")

install_deps_grafanalib()

# rules_docker
rules_docker_version = "0.25.0"

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "07ee8ca536080f5ebab6377fc6e8920e9a761d2ee4e64f0f6d919612f6ab56aa",
    strip_prefix = "rules_docker-%s" % rules_docker_version,
    type = "tar.gz",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v%s.tar.gz" % rules_docker_version],
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
    sha256 = "64c5dc82d5b95134df40daeb90be7e4516f3f128a5ef48561edb730cc37c5f1e",
    type = "zip",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.6/download"],
)
