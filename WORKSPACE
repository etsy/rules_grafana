workspace(name = "io_bazel_rules_grafana")

git_repository(
        name = "io_bazel_rules_python",
        commit = "8b5d0683a7d878b28fffe464779c8a53659fc645",
        remote = "https://github.com/bazelbuild/rules_python.git",
        )

load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories")

pip_repositories()

git_repository(
    name = "io_bazel_rules_docker",
    commit = "70c904e82aff0aa6fa58dd2b735397e81029c9db",
    remote = "https://github.com/bazelbuild/rules_docker.git",
)

load(
    "@io_bazel_rules_docker//container:container.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_grafana//grafana:workspace.bzl", "repositories")

repositories()

load("@io_bazel_rules_grafana_deps//:requirements.bzl", "pip_install")

pip_install()
