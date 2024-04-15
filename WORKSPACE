workspace(name = "io_bazel_rules_grafana")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

bazel_skylib_version = "1.5.0"

http_archive(
    name = "bazel_skylib",
    sha256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/%s/bazel-skylib-%s.tar.gz" % (bazel_skylib_version, bazel_skylib_version),
)

# rules_python
rules_python_version = "0.31.0"

http_archive(
    name = "rules_python",
    sha256 = "9110e83a233c9edce177241f3ae95eae4e4cc3b602d845878d76ad4e3bab7c60",
    strip_prefix = "rules_python-{version}".format(version = rules_python_version),
    type = "zip",
    url = "https://github.com/bazelbuild/rules_python/archive/{}.zip".format(rules_python_version),
)

load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")
py_repositories()
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
    sha256 = "56d5499025d67a6b86b2e6ebae5232c72104ae682b5a21287770bd3bf0661abf",
    strip_prefix = "rules_oci-1.7.5",
    url = "https://github.com/bazel-contrib/rules_oci/releases/download/v1.7.5/rules_oci-v1.7.5.tar.gz",
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
    sha256 = "818ab33b42a1421b561f4e44f0cd19cd1a56767d3952045b8042a4da58bd470e",
    type = "zip",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.7/download"],
)
