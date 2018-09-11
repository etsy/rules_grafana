# `rules_grafana` for Bazel

Dashboards as code, the [Bazel](https://bazel.build/) way.

Try it out!  `bazel run //example:grafana` to build and load a Docker image,
then run it with `docker run --rm -p 3001:3001 bazel/example:grafana`.
Then load Grafana in your browser at `http://localhost:3001`!

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

Dashboards can be either hard-coded JSON files or Python scripts that generate dashboards.

### JSON dashboards

Use `json_dashboards` to add JSON files containing dashboard to your build.
The JSON must be a complete, valid Grafana 5.0 dashboard;
see the [Grafana docs](http://docs.grafana.org/reference/dashboard/) for details on the JSON format.

```
load("@io_bazel_rules_grafana//grafana:grafana.bzl", "json_dashboards")

json_dashboards(
    name = "dashboards",
    srcs = ["awesome_graphs.json"],
)
```

Unlike using the JSON files directly,
`json_dashboards` will check the syntax of your files
and ensure that each dashboard has a `uid` set,
to ensure it has a consistent URL in Grafana.

### Python dashboards

Dashboards can also be generated with Python,
using the [`grafanalib`](https://github.com/weaveworks/grafanalib) library.
`grafanalib` is automatically imported,
and you can also add other `deps` to help build your dashboard.

Each Python dashboard file should print the complete JSON of a Grafana dashboard.
An easy way to do that is to follow a template like this:

```py
from grafanalib.core import *
from grafanalib._gen import print_dashboard

dashboard = Dashboard(
    # Fill in your dashboard!
)

print_dashboard(dashboard.auto_panel_ids()) # `auto_panel_ids()` call is required!
```

Use `py_dashboards` to add Python files that generate dashboards to your build.

```
load("@io_bazel_rules_grafana//grafana:grafana.bzl", "py_dashboards")

py_dashboards(
    name = "dashboards",
    srcs = ["amazing_graphs.py", "even_better_graphs.py"],
)
```

You can run the Python and see the generated JSON with the `FOO_builder` target created by `py_dashboards`,
where `FOO` is the Python filename without `.py`.
For example, run `bazel run //example:sample_builder` in this repository to see the output of `sample.py`.
The JSON is generated at build time, not a run time, so Python isn't a runtime dependency.

### Docker image

Use `grafana_image` to build your dashboards into a Docker image containing Grafana.
When you run the image, it starts Grafana on port 3001
and serves all of the dashboards you've built,
directly from the container.

The dashboards and datasources are added via [Grafana provisioning](http://docs.grafana.org/administration/provisioning/),
where the configuration and sources are declared and built into the image,
alongside all the dashboards.
You must provide a `datasources.yaml` file declaring your datasources;
see the [Grafana datasources docs](http://docs.grafana.org/administration/provisioning/#datasources) for details of the format.

## API reference

### `json_dashboards`

Processes a set of `.json` Grafana dashboards for inclusion in the image.

Arguments:

- `name`: Unique name for this target.  Required.
- `srcs`: List of labels of `.json` files to build into dashboards.  Required.

### `py_dashboards`

Processes a set of `.py` Grafana dashboards for inclusion in the image.

Arguments:

- `name`: Unique name for this target.  Required.
- `srcs`: List of labels of `.py` files to build into dashboards.  Required.
- `deps`: List of labels of additional `py_library` targets to use while executing the Python dashboards.  Optional, default `[]`.

### `grafana_image`

Builds a Docker image containing Grafana and the provided dashboards and datasources.

Arguments:

- `name`: Unique name for this target.  Required.
- `dashboards`: List of labels of `json_dashboards` and/or `py_dashboards` targets to include in the image.  Required.
- `datasources`: List of labels of `datasources.yaml` files to include in the image ([Grafana datasources docs](http://docs.grafana.org/administration/provisioning/#datasources)).  Required.
