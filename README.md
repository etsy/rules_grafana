# `rules_grafana` for Bazel

Dashboards as code, the [Bazel](https://bazel.build/) way.

## Installing

Load `io_bazel_rules_grafana` by adding the following to your `WORKSPACE`:

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "io_bazel_rules_grafana",
    commit = "{HEAD}", # replace with a real commit hash
    remote = "https://github.com/etsy/rules_grafana.git",
)

load("@io_bazel_rules_grafana//grafana:workspace.bzl", grafana_repositories="repositories")
grafana_repositories()
load("@io_bazel_rules_grafana_deps//:requirements.bzl", "pip_install")
pip_install()
```

`rules_grafana` also depends on [`rules_python`](https://github.com/bazelbuild/rules_python) and
[`rules_docker`](https://github.com/bazelbuild/rules_docker).
If you don't already have these libraries in your `WORKSPACE`,
add them above the previous block:

- [`rules_python` setup](https://github.com/bazelbuild/rules_python#setup).
- [`rules_docker` setup](https://github.com/bazelbuild/rules_docker#setup).

## Usage

`rules_grafana` makes it easy to build dashboards and incorporate them into your Bazel build,
and to build a complete, runnable Docker image.
