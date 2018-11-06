load("@io_bazel_rules_grafana_deps//:requirements.bzl", "requirement")

def _json_dashboard(ctx):
    '''Prepares a single .json Grafana dashboard source for inclusion in the image.'''
    # Every dashboard must have a unique 'uid' in its JSON.  This is used by Grafana to generate the URL, so we want it
    # to be consistent and predictable over time.  Therefore we generate it from the input path, keeping only URL-valid
    # characters, then inject it into the JSON.
    uid = ''.join([c if c.isalnum() else '_' for c in ctx.file.src.basename.elems()])
    ctx.actions.run_shell(
        inputs = [ctx.file.src],
        outputs = [ctx.outputs.json],
        tools = [ctx.executable._uid_injector],
        arguments = [ctx.executable._uid_injector.path, ctx.file.src.path, ctx.outputs.json.path],
        command = '$1 $2 "%s" > $3' % uid,
    )
    return [DefaultInfo(files=depset([ctx.outputs.json]))]

json_dashboard = rule(
    implementation = _json_dashboard,
    attrs = {
        "src": attr.label(
            allow_single_file=[".json"],
        ),
        "_uid_injector": attr.label(
            default="@io_bazel_rules_grafana//grafana:uid_injector",
            executable = True,
            cfg = "host",
        ),
    },
    outputs = {
        "json": "%{src}.generated.json",
    },
)

def json_dashboards(name, srcs, visibility=None):
    '''Processes a set of .json Grafana dashboards for inclusion in the image.'''
    targets = []
    for src in srcs:
        target_name = '%s__%s__generated' % (name, src)
        targets.append(target_name)
        json_dashboard(name=target_name, src=src)
    native.filegroup(name=name, srcs=targets, visibility=visibility)

def _py_dashboard(ctx):
    '''Generate a runnable binary that prints the JSON to stdout, and a genrule that puts the JSON in a file for later
    consumption.'''
    args = [ctx.executable.builder.path, ctx.outputs.json.path]
    ctx.actions.run_shell(
        inputs = [ctx.info_file],
        tools = [ctx.executable.builder],
        outputs = [ctx.outputs.json],
        arguments = args,
        command = "$1 > $2",
    )
    return [DefaultInfo(files=depset([ctx.outputs.json]))]

py_dashboard = rule(
    implementation = _py_dashboard,
    attrs = {
        "builder": attr.label(
             executable=True,
             cfg = "host",
             allow_files = True,
        ),
    },
    outputs = {
        "json": "%{name}.py.json",
    },
)

def _py_dashboard_builder(src, deps=None):
    if deps == None:
        deps = []
    py_binary_name = src.replace('.py', '_builder')
    native.py_binary(
        name = py_binary_name,
        srcs = [src],
        deps = [requirement('grafanalib')] + deps,
        main = src,
    )
    return ":%s" % py_binary_name

def py_dashboards(name, srcs, deps=None, visibility=None):
    '''Processes a set of .py Grafana dashboards for inclusion in the image.'''
    targets = []
    for src in srcs:
        # First run the py file through `py_dashboard`, which runs it with the right python deps and produces a file; then
        # run that generated file thorugh `json_dashboard` to ensure it has a `uid` and stuff.
        py_target_name = src.replace('.py', '')
        py_binary_label = _py_dashboard_builder(src, deps)
        py_dashboard(name=py_target_name, builder=py_binary_label)
        targets.append(py_target_name)
    json_dashboards(name=name, srcs=targets, visibility=visibility)
