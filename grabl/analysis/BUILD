package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

kt_jvm_binary(
    name = "dependency-analysis",
    srcs = ["DependencyAnalysis.kt"],
    main_class = "grabl.analysis.DependencyAnalysisKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:org_zeroturnaround_zt_exec",
    ],
)