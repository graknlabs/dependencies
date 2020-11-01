load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def google_or_tools_darwin():
    http_archive(
        name = "google_ortools_darwin",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_MacOsX-10.15.7_v8.0.8283.tar.gz"],
        strip_prefix = "or-tools_MacOsX-10.15.7_v8.0.8283",
        build_file = "@//:library/ortools/darwin-exports"
    )

def google_or_tools_linux():
    http_archive(
        name = "google_ortools_linux",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_debian-10_v8.0.8283.tar.gz"],
        strip_prefix = "or-tools_Debian-10-64bit_v8.0.8283",
        build_file = "@//:library/ortools/linux-exports"
    )

def google_or_tools_windows():
    http_archive(
        name = "google_ortools_windows",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_VisualStudio2019-64bit_v8.0.8283.zip"],
        strip_prefix = "or-tools_VisualStudio2019-64bit_v8.0.8283",
        build_file = "@//:library/ortools/windows-exports"
    )