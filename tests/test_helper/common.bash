# tests/test_helper/common.bash — shared loader.
# Source from each .bats file via:
#   load 'test_helper/common'

load "${BATS_TEST_DIRNAME}/test_helper/bats-support/load"
load "${BATS_TEST_DIRNAME}/test_helper/bats-assert/load"

# REPO_ROOT — absolute path to the repo, regardless of where bats is invoked.
REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"
export REPO_ROOT

# load_dotfiles_env — source the dotfiles so path and vars match interactive shell
# Call from `setup_file` of test files that need it.
load_dotfiles_env() {
	export PERSONAL_CONFIG_DIR="$REPO_ROOT"
	# shellcheck source=/dev/null
	. "$REPO_ROOT/sh/.include"
	# shellcheck source=/dev/null
	. "$REPO_ROOT/sh/.env"

	# mise activation is in .bashzshrc for interactive shells only
	# don't want to source the whole file for tests but we do need mise
	if command -v mise >/dev/null 2>&1; then
		eval "$(mise activate bash 2>/dev/null)" || true
	fi
}

# skip_unless_full_install — skip a test for when we don't have root
# sets PMB_TEST_MODE=home for that job; default is full.
skip_unless_full_install() {
	if [ "${PMB_TEST_MODE:-full}" != "full" ]; then
		skip "${1:-only checked when system PM ran}"
	fi
}
