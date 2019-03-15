#!/usr/bin/env python

"""
sync_dependencies.py updates bazel dependencies between @graknlabs repositories

Example usage:
bazel run @graknlabs_build_tools//ci:sync_dependencies.py \
--source client-python@1a2s3d4f1a2s3d4f1a2s3d4f1a2s3d4f1a2s3d4f \
--targets docs:development examples:development
"""

from __future__ import print_function

import argparse
import json
import os
import subprocess
import sys
import github
import hashlib
import hmac


IS_CIRCLE_ENV = os.getenv('CIRCLECI')
if IS_CIRCLE_ENV is None:
    IS_CIRCLE_ENV = False

GRABL_HOST = 'https://grabl.grakn.ai'
if not IS_CIRCLE_ENV:
    GRABL_HOST = 'http://localhost:8000'

GRABL_SYNC_DEPS = '{0}/sync/dependencies'.format(GRABL_HOST)

CMDLINE_PARSER = argparse.ArgumentParser(description='Automatic updater for GraknLabs inter-repository dependencies')
CMDLINE_PARSER.add_argument('--dry-run', help='Do not perform any real actions')  # TODO(vmax): support this argument
CMDLINE_PARSER.add_argument('--source', required=True)
CMDLINE_PARSER.add_argument('--targets', nargs='+', required=True)

COMMIT_SUBJECT_PREFIX = "//ci:sync-dependencies:"

graknlabs = 'graknlabs'
github_token = os.getenv('GRABL_CREDENTIAL')
github_connection = github.Github(github_token)
github_org = github_connection.get_organization(graknlabs)


def is_building_upstream():
    """ Returns False is running in a forked repo"""
    return graknlabs in os.getenv('CIRCLE_REPOSITORY_URL', '')


def exception_handler(fun):
    """ Decorator printing additional message on CalledProcessError """

    def wrapper(*args, **kwargs):
        # pylint: disable=missing-docstring
        try:
            fun(*args, **kwargs)
        except subprocess.CalledProcessError as ex:
            print('An error occurred when running {ex.cmd}. '
                  'Process exited with code {ex.returncode} '
                  'and message {ex.output}'.format(ex=ex))
            print()
            raise ex

    return wrapper


def check_output_discarding_stderr(*args, **kwargs):
    with open(os.devnull, 'w') as devnull:
        try:
            output = subprocess.check_output(*args, stderr=devnull, **kwargs)
            if type(output) == bytes:
                output = output.decode()
            return output
        except subprocess.CalledProcessError as e:
            print('An error occurred when running "' + str(e.cmd) + '". Process exited with code ' + str(
                e.returncode) + ' and message "' + e.output + '"')
            raise e


def short_commit(commit_sha):
    return subprocess.check_output(['git', 'rev-parse', '--short=7', commit_sha],
                                   cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY")).decode().replace('\n', '')


@exception_handler
def main():
    if not is_building_upstream():
        print('//ci:sync-dependencies aborted: not building the upstream repo on @graknlabs')
        exit(0)

    arguments = CMDLINE_PARSER.parse_args(sys.argv[1:])
    targets = {}
    source_repo, source_commit = arguments.source.split('@')
    source_commit_short = short_commit(source_commit)

    for target in arguments.targets:
        target_repo, target_branch = target.split(':')
        targets[target_repo] = target_branch

    github_repo = github_org.get_repo(source_repo)
    github_commit = github_repo.get_commit(source_commit)
    source_message = github_commit.commit.message

    # TODO: Check that the commit author is @grabl
    if not source_message.startswith(COMMIT_SUBJECT_PREFIX):
        sync_message = '{0} {1}/{2}@{3}'.format(COMMIT_SUBJECT_PREFIX, graknlabs, source_repo, source_commit_short)
    else:
        sync_message = source_message

    print('Requesting the synchronisation of dependency to {0}/{1}@{2} in the following repos:'
          .format(graknlabs, source_repo, source_commit_short))
    for target_repo in targets:
        print('- {0}/{1}:{2}'.format(graknlabs, target_repo, targets[target_repo]))

    sync_data = {
        'source-repo': source_repo,
        'source-commit': source_commit,
        'sync-message': sync_message,
        'targets': targets
    }

    git_token = os.getenv('GRABL_CREDENTIAL')
    signature = hmac.new(git_token, json.dumps(sync_data), hashlib.sha1).hexdigest()

    check_output_discarding_stderr([
        'curl', '-X', 'POST', '--data', json.dumps(sync_data), '-H', 'Content-Type: application/json', '-H', 'X-Hub-Signature: ' + signature, GRABL_SYNC_DEPS
    ])


if __name__ == '__main__':
    main()
