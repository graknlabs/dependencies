#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def grpc_dependencies():
    git_repository(
        name = "com_github_grpc_grpc",
        remote = "https://github.com/graknlabs/grpc",
        commit = "4a1528f6f20a8aa68bdbdc9a66286ec2394fc170"
    )
    git_repository(
        name = "io_grpc_grpc_java",
        remote = "https://github.com/grpc/grpc-java",
        commit = "62e8655f1bc4dfb474afbf332ca7571c1454e6ef"
    )
    git_repository(
        name = "stackb_rules_proto",
        remote = "https://github.com/stackb/rules_proto",
        commit = "d9a123032f8436dbc34069cfc3207f2810a494ee",
    )
