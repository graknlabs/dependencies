load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def google_or_tools_osx():
    http_archive(
        name = "google_ortools_darwin",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_MacOsX-10.15.7_v8.0.8283.tar.gz"],
        strip_prefix = "or-tools_MacOsX-10.15.7_v8.0.8283",
        build_file = "@//:library/ortools/archive-exports-files"
    )
