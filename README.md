# `rules_grafana` for Bazel

Dashboards as code, the [Bazel](https://bazel.build/) way.
Write Grafana dashboards with Python
and build them into a reusable Docker image.

## Try it out

```bash
# Build and load the Docker image
bazel run //example:grafana_load

# Run the container
docker run --rm -p 3000:3000 rules_grafana/example:latest

# Open Grafana in your browser
open http://localhost:3000
```

## Installation

### From Bazel Central Registry (recommended)

Add to your `MODULE.bazel`:

```starlark
bazel_dep(name = "rules_grafana", version = "2.0.0")

# For plugins and container setup
grafana = use_extension("@rules_grafana//grafana:extensions.bzl", "grafana")
use_repo(grafana, "grafana_oci")

# Optional: Add plugins
grafana.plugin(
    name = "my_plugin",
    urls = ["https://grafana.com/api/plugins/my-plugin/versions/1.0.0/download"],
    sha256 = "...",
    type = "zip",
)
use_repo(grafana, "my_plugin")
```

### From GitHub (before BCR publication)

```starlark
bazel_dep(name = "rules_grafana", version = "2.0.0")
git_override(
    module_name = "rules_grafana",
    remote = "https://github.com/etsy/rules_grafana.git",
    branch = "grafana-foundation-sdk",
)

# For plugins and container setup
grafana = use_extension("@rules_grafana//grafana:extensions.bzl", "grafana")
use_repo(grafana, "grafana_oci")
```

## Bazel compatibility

Requires Bazel 8.0.0 or later with bzlmod enabled.

`rules_grafana` depends on [`rules_python`](https://github.com/bazelbuild/rules_python) and
[`rules_oci`](https://github.com/bazel-contrib/rules_oci), but these are automatically managed
through Bazel's module system.

## Usage

`rules_grafana` makes it easy to build dashboards and incorporate them into your Bazel build,
and to build a complete, runnable Docker image.

Dashboards can be either hard-coded JSON files or Python scripts that generate dashboards.

### JSON dashboards

Use `json_dashboards` to add JSON files containing dashboards to your build.
The JSON must be a complete, valid Grafana dashboard;
see the [Grafana docs](http://docs.grafana.org/reference/dashboard/) for details on the JSON format.

```python
load("@rules_grafana//grafana:grafana.bzl", "json_dashboards")

json_dashboards(
    name = "dashboards",
    srcs = ["awesome_graphs.json"],
)
```

Unlike using the JSON files directly,
`json_dashboards` will check the syntax of your files
and ensure that each dashboard has a `uid` set,
to ensure it has a [consistent URL in Grafana](http://docs.grafana.org/administration/provisioning/#reuseable-dashboard-urls).

### Python dashboards

Dashboards can also be generated with Python using the
[`grafana-foundation-sdk`](https://github.com/grafana/grafana-foundation-sdk) library.
The SDK provides type-safe builders for creating Grafana dashboards programmatically.

Each Python dashboard file should print the complete JSON of a Grafana dashboard.
Here's a template to get started:

```python
import json
from grafana_foundation_sdk.builders import dashboard as dashboard_builder
from grafana_foundation_sdk.builders import text, timeseries
from grafana_foundation_sdk.cog.encoder import JSONEncoder
from grafana_foundation_sdk.models.dashboard import GridPos

dashboard = (
    dashboard_builder.Dashboard("My Dashboard")
    .with_panel(
        text.Panel()
        .title("Welcome")
        .grid_pos(GridPos(h=4, w=24, x=0, y=0))
    )
    .with_panel(
        timeseries.Panel()
        .title("Metrics")
        .grid_pos(GridPos(h=8, w=12, x=0, y=4))
    )
    .build()
)

print(json.dumps(dashboard, cls=JSONEncoder, indent=2))
```

Use `py_dashboards` to add Python files that generate dashboards to your build.

```python
load("@rules_grafana//grafana:grafana.bzl", "py_dashboards")

py_dashboards(
    name = "dashboards",
    srcs = ["amazing_graphs.py", "even_better_graphs.py"],
)
```

You can run the Python and see the generated JSON with the `FOO_builder` target created by `py_dashboards`,
where `FOO` is the Python filename without `.py`.
For example, run `bazel run //example:sample_builder` in this repository to see the output of `sample.py`.
The JSON is generated at build time, not at run time, so Python isn't a runtime dependency.

### Docker image

Use `grafana_image` to build your dashboards into a Docker image containing Grafana.
When you run the image, it starts Grafana on port 3000
and serves all of the dashboards you've built,
directly from the container.

```python
load("@rules_grafana//grafana:image.bzl", "grafana_image")
load("@rules_oci//oci:defs.bzl", "oci_load")

grafana_image(
    name = "grafana",
    dashboards = [":dashboards"],
    datasources = [":datasources.yaml"],
)

# To run locally, load the image into Docker:
oci_load(
    name = "grafana_load",
    image = ":grafana",
    repo_tags = ["my-grafana:latest"],
)
```

Then run:

```bash
bazel run //:grafana_load
docker run --rm -p 3000:3000 my-grafana:latest
```

The dashboards and datasources are added via [Grafana provisioning](http://docs.grafana.org/administration/provisioning/),
where the configuration and sources are declared and built into the image,
alongside all the dashboards.
You must provide a `datasources.yaml` file declaring your datasources;
see the [Grafana datasources docs](http://docs.grafana.org/administration/provisioning/#datasources) for details of the format.

### Plugins

Grafana plugins can be installed into the image too.
Use the `grafana` module extension to download plugins:

```starlark
# In your MODULE.bazel
grafana = use_extension("@rules_grafana//grafana:extensions.bzl", "grafana")
grafana.plugin(
    name = "grafana_plotly_plugin",
    urls = ["https://grafana.com/api/plugins/natel-plotly-panel/versions/0.0.7/download"],
    sha256 = "818ab33b42a1421b561f4e44f0cd19cd1a56767d3952045b8042a4da58bd470e",
    type = "zip",
)
use_repo(grafana, "grafana_plotly_plugin")
```

Then pass the plugin to the image rule's `plugins` list as `@grafana_plotly_plugin//:plugin`.

### Custom Grafana image

The default version of Grafana (12.0) may not suit your needs.
You can override the container by modifying the grafana extension in your MODULE.bazel.

## API Reference

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
- `plugins`: List of labels of plugin targets from the grafana extension, like `@your_plugin_name//:plugin`.  Optional.
- `env`: Dictionary of environment variant names to values, set in the Docker image when Grafana is run.  Optional.
    Useful for setting runtime configs with `GF_` variables.
- `tags`: List of tags to apply to the target.  Optional.

### Module extension: `grafana`

Module extension for managing Grafana plugins and container configuration.

#### `grafana.plugin`

Downloads a Grafana plugin for inclusion in a `grafana_image`.

Arguments:

- `name`: Unique name for this plugin repository.  Required.
- `urls`: List of strings of mirror URLs referencing the plugin archive.  Required.
- `sha256`: String of the expected SHA-256 hash of the download.  Required.
- `type`: The archive type of the downloaded file as a string;
          takes the same values as the `type` attribute of Bazel's `http_archive` rule.
          Optional, as the archive type can be determined from the plugin's file extension.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[Apache 2.0](LICENSE)
