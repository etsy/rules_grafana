"""Bazel module extensions for rules_grafana."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_oci//oci:pull.bzl", "oci_pull")

DEFAULT_GRAFANA_TAG = "11.6.9"
DEFAULT_GRAFANA_SHA = "sha256:129fc95da485ade43720ab7ca725c34ce15ea3c03fadb68309e65829a929e3c5"

def _grafana_plugin_impl(name, urls, sha256, type = None):
    """Implementation for grafana_plugin rule."""
    http_archive(
        name = name,
        urls = urls,
        sha256 = sha256,
        type = type,
        build_file_content = "filegroup(name='plugin', srcs=glob(['**/*']), visibility=['//visibility:public'])",
    )

_grafana_plugin_tag = tag_class(
    attrs = {
        "name": attr.string(mandatory = True),
        "urls": attr.string_list(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "type": attr.string(),
    },
)

def _grafana_extension_impl(module_ctx):
    """Implementation for grafana module extension."""
    
    # Pull default grafana container
    oci_pull(
        name = "grafana_oci",
        image = "index.docker.io/grafana/grafana",
        digest = DEFAULT_GRAFANA_SHA,
        platforms = ["linux/amd64"],
    )
    
    # Process grafana_plugin tags
    for mod in module_ctx.modules:
        for plugin in mod.tags.plugin:
            _grafana_plugin_impl(
                name = plugin.name,
                urls = plugin.urls,
                sha256 = plugin.sha256,
                type = plugin.type,
            )
    
    # Collect all created repositories
    direct_deps = ["grafana_oci"]
    for mod in module_ctx.modules:
        for plugin in mod.tags.plugin:
            direct_deps.append(plugin.name)
    
    return module_ctx.extension_metadata(
        reproducible = True,
        root_module_direct_deps = direct_deps,
        root_module_direct_dev_deps = [],
    )

grafana = module_extension(
    implementation = _grafana_extension_impl,
    tag_classes = {
        "plugin": _grafana_plugin_tag,
    },
)