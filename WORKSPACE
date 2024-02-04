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

# rules_oci
http_archive(
    name = "rules_oci",
    sha256 = "6ae66ccc6261d3d297fef1d830a9bb852ddedd3920bbd131021193ea5cb5af77",
    strip_prefix = "rules_oci-1.7.0",
    url = "https://github.com/bazel-contrib/rules_oci/releases/download/v1.7.0/rules_oci-v1.7.0.tar.gz",
)

load("@rules_oci//oci:dependencies.bzl", "rules_oci_dependencies")

rules_oci_dependencies()

load("@rules_oci//oci:repositories.bzl", "LATEST_CRANE_VERSION", "oci_register_toolchains")

oci_register_toolchains(
    name = "oci",
    crane_version = LATEST_CRANE_VERSION,
)
# end rules_oci

# rules_pkg
http_archive(
    name = "rules_pkg",
    sha256 = "e93b7309591cabd68828a1bcddade1c158954d323be2205063e718763627682a",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.10.0/rules_pkg-0.10.0.tar.gz",
        "https://github.com/bazelbuild/rules_pkg/releases/download/0.10.0/rules_pkg-0.10.0.tar.gz",
    ],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()
# end rules_pkg

# container_structure_test
http_archive(
    name = "container_structure_test",
    sha256 = "2da13da4c4fec9d4627d4084b122be0f4d118bd02dfa52857ff118fde88e4faa",
    strip_prefix = "container-structure-test-1.16.0",
    urls = ["https://github.com/GoogleContainerTools/container-structure-test/archive/v1.16.0.zip"],
)

load("@container_structure_test//:repositories.bzl", "container_structure_test_register_toolchain")

container_structure_test_register_toolchain(name = "container_structure_test_toolchain")

# end external rules

load("@io_bazel_rules_grafana//grafana:workspace.bzl", "grafana_plugin", "repositories")

repositories()

grafana_plugin(
    name = "grafana_plotly_plugin",
    sha256 = "64c5dc82d5b95134df40daeb90be7e4516f3f128a5ef48561edb730cc37c5f1e",
    type = "zip",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.6/download"],
)
