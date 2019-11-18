load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_python//python:pip.bzl", "pip_import")
load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

def _dynamic_requirements_impl(repository_ctx):
    repository_ctx.file("BUILD", "")
    repository_ctx.file("requirements.txt", "\n".join(repository_ctx.attr.requirements))

_dynamic_requirements = repository_rule(
    implementation = _dynamic_requirements_impl,
    attrs = {
        "requirements": attr.string_list(),
    },
)

DEFAULT_GRAFANALIB_PIP_SPECIFIER = "-e git+https://github.com/weaveworks/grafanalib.git@b0375148133e1f9b0c78777c8ec818cf018235e0#egg=grafanalib"

def repositories(grafanalib_pip_specifier = DEFAULT_GRAFANALIB_PIP_SPECIFIER):
    """Defines WORKSPACE requirements for `rules_grafana`.  See README.md for detailed usage."""

    # `requirements.txt` for `pip_import` must be a file, so turn the argument into one, then import it.
    _dynamic_requirements(
        name = "io_bazel_rules_grafana_dynamic_requirements",
        requirements = [grafanalib_pip_specifier],
    )
    pip_import(
        name = "io_bazel_rules_grafana_deps",
        requirements = "@io_bazel_rules_grafana_dynamic_requirements//:requirements.txt",
    )

    container_repositories()

    container_pull(
        name = "io_bazel_rules_grafana_docker",
        registry = "index.docker.io",
        repository = "grafana/grafana",
        tag = "6.4.2",
        digest = "sha256:41333de8ca11b15f405d8a67bdb5034b138ad3a539de3e549e768d24dfea2b72",
    )

def grafana_plugin(name, urls, sha256, type = None):
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )
