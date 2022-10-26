workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rules_python
rules_python_version = "0.13.0"

http_archive(
    name = "rules_python",
    sha256 = "090bfe913d05878db759cdab77061042ff826c3a96b8853aa695405f8c992af5",
    strip_prefix = "rules_python-{version}".format(version = rules_python_version),
    url = "https://github.com/bazelbuild/rules_python/archive/{}.zip".format(rules_python_version),
)

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

python_register_toolchains(
    name = "python3_9",
    python_version = "3.9",
)

load("@rules_python//python/pip_install:repositories.bzl", "pip_install_dependencies")

pip_install_dependencies()

# rules_docker
rules_docker_version = "0.22.0"

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "e735c587f8faa7323e5d86c179dd8e07d356dd95dbd3a73fbc653a00fa688d88",
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
