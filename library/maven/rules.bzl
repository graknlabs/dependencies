load("@rules_jvm_external//:defs.bzl", rje_maven_install = "maven_install")
load("@rules_jvm_external//:specs.bzl", rje_maven = "maven")
load(":artifacts.bzl", artifacts_registered = "artifacts")

def warn(msg):
    print('{red}{msg}{nc}'.format(red='\033[0;31m', msg=msg, nc='\033[0m'))


def maven(artifacts_list, overrides={}):
    if len(overrides) > 0:
        warn("There are {} overrides found. Usage of `overrides` attribute of `maven()` is discouraged!".format(len(overrides)))
    for a in artifacts_list:
        if a not in artifacts_registered.keys():
            fail("'" + a + "' has not been declared in @graknlabs_dependencies")
    artifacts_selected = []
    for a in artifacts_list:
        artifact = maven_artifact(a, overrides.get(a, artifacts_registered[a]))
        artifacts_selected.append(artifact)
    rje_maven_install(
        artifacts = artifacts_selected,
        repositories = [
            "https://repo1.maven.org/maven2",
            "https://repo.grakn.ai/repository/maven",
            "https://repo.grakn.ai/repository/maven-snapshot",
        ],
        strict_visibility = True,
        version_conflict_policy = "pinned",
        fetch_sources = True
    )

def maven_artifact(artifact, artifact_info):
    group, artifact_id = artifact.split(':')
    if type(artifact_info) == type(' '):
        artifact = rje_maven.artifact(
            group = group,
            artifact = artifact_id,
            version = artifact_info,
        )
    elif type(artifact_info) == type({}):
        exclusions = []
        for e in artifact_info['exclude']:
            exclusions.append(e)
        artifact = rje_maven.artifact(
            group = group,
            artifact = artifact_id,
            version = artifact_info['version'],
            exclusions = exclusions
        )
    else:
        fail("The info for '" + artifact + "' must either be a 'string' (eg., '1.8.1') or a 'dict' (eg., {'version': '1.8.1', 'exclude': ['org.slf4j:slf4j']})")
    return artifact
