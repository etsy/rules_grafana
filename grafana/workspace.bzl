load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_python//python:pip.bzl", "pip_install")
load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

DEFAULT_GRAFANA_TAG = "8.5.5"
DEFAULT_GRAFANA_SHA = "sha256:f247fbae840f874ee3c6c1501f5dde6c768ea07b9893182ebd1f16a10fb725b1"

def _dynamic_requirements_impl(repository_ctx):
    repository_ctx.file("BUILD", "")
    repository_ctx.file("requirements.txt", "\n".join(repository_ctx.attr.requirements))

_dynamic_requirements = repository_rule(
    implementation = _dynamic_requirements_impl,
    attrs = {
        "requirements": attr.string_list(),
    },
)

# release 0.6.2
DEFAULT_GRAFANALIB_PIP_SPECIFIER = "-e git+https://github.com/weaveworks/grafanalib.git@7c1790eb68c4acca7de510067319d5e3e78654b5#egg=grafanalib"

def repositories(
        grafanalib_pip_specifier = DEFAULT_GRAFANALIB_PIP_SPECIFIER,
        use_custom_container = False,
        python3_interpreter = "python3"):
    """Defines WORKSPACE requirements for `rules_grafana`.  See README.md for detailed usage.

    Args:
        grafanalib_pip_specifier: dependencies for grafanalib url.
        use_custom_container: use a custom container for grafana.
        python3_interpreter: path to python3 for pip
    """

    # `requirements.txt` for `pip_import` must be a file, so turn the argument into one, then import it.
    _dynamic_requirements(
        name = "io_bazel_rules_grafana_dynamic_requirements",
        requirements = [grafanalib_pip_specifier],
    )

    pip_install(
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
            tag = DEFAULT_GRAFANA_TAG,
            digest = DEFAULT_GRAFANA_SHA,
        )

def grafana_plugin(name, urls, sha256, type = None):
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )
