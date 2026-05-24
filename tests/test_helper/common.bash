# tests/test_helper/common.bash — shared loader.
# Source from each .bats file via:
#   load 'test_helper/common'

load "${BATS_TEST_DIRNAME}/test_helper/bats-support/load"
load "${BATS_TEST_DIRNAME}/test_helper/bats-assert/load"

# REPO_ROOT — absolute path to the repo, regardless of where bats is invoked.
REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
export REPO_ROOT
