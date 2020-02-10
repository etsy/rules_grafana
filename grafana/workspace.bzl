load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_python//python:pip.bzl", "pip3_import", "pip_import")
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

DEFAULT_GRAFANALIB_PIP_SPECIFIER = "-e git+https://github.com/weaveworks/grafanalib.git@cca2907cdaf3fce0d32fe701b5748321a39c5d26#egg=grafanalib"

def repositories(
        grafanalib_pip_specifier = DEFAULT_GRAFANALIB_PIP_SPECIFIER,
        use_custom_container = False,
        python2_interpreter = 'python2',
        python3_interpreter = 'python3',
    ):
    """Defines WORKSPACE requirements for `rules_grafana`.  See README.md for detailed usage.

    Args:
        grafanalib_pip_specifier: dependencies for grafanalib url.
        use_custom_container: use a custom container for grafana.
        python2_interpreter: path to python2 for pip
        python3_interpreter: path to python3 for pip
    """

    # `requirements.txt` for `pip_import` must be a file, so turn the argument into one, then import it.
    _dynamic_requirements(
        name = "io_bazel_rules_grafana_dynamic_requirements",
        requirements = [grafanalib_pip_specifier],
    )

    pip_import(
        name = "io_bazel_rules_grafana_deps",
        requirements = "@io_bazel_rules_grafana_dynamic_requirements//:requirements.txt",
        python_interpreter = python2_interpreter,
    )
    pip_import(
        name = "io_bazel_rules_grafana_deps3",
        requirements = "@io_bazel_rules_grafana_dynamic_requirements//:requirements.txt",
        python_interpreter = python3_interpreter,
    )

    container_repositories()

    if not use_custom_container:
        container_pull(
            name = "io_bazel_rules_grafana_docker",
            registry = "index.docker.io",
            repository = "grafana/grafana",
            tag = "6.4.4",
            digest = "sha256:01f35fd54472850715866dfe5e6ec34783064558197a643d5a2b48b7791367dd",
        )

def grafana_plugin(name, urls, sha256, type = None):
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )
