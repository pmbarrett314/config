#!/usr/bin/env bats
# Env vars — what sh/.env should set after sourcing.
# Tests source the env layer in setup_file

load 'test_helper/common'

setup_file() {
	load_dotfiles_env
}

# --- always-set ---

@test "PERSONAL_CONFIG_DIR is set" {
	[ -n "${PERSONAL_CONFIG_DIR:-}" ]
}

@test "STARSHIP_CONFIG points at repo" {
	[ "$STARSHIP_CONFIG" = "$REPO_ROOT/starship/starship.toml" ]
}

@test "ATUIN_CONFIG_DIR points at repo" {
	[ "$ATUIN_CONFIG_DIR" = "$REPO_ROOT/atuin" ]
}

@test "INPUTRC points at repo" {
	[ "$INPUTRC" = "$REPO_ROOT/readline/.inputrc" ]
}

@test "TEALDEER_CONFIG_DIR points at repo" {
	[ "$TEALDEER_CONFIG_DIR" = "$REPO_ROOT/tealdeer" ]
}

@test "LG_CONFIG_FILE points at repo" {
	[ "$LG_CONFIG_FILE" = "$REPO_ROOT/lazygit/config.yml" ]
}

@test "TERMINFO_DIRS contains user terminfo" {
	case ":$TERMINFO_DIRS:" in
	*":$HOME/.local/share/terminfo:"*) ;;
	*) return 1 ;;
	esac
}

@test "EDITOR is vim or vi" {
	[ "$EDITOR" = "vim" ] || [ "$EDITOR" = "vi" ]
}

@test "PAGER is less" {
	[ "$PAGER" = "less" ]
}

@test "VISUAL is set" {
	[ -n "${VISUAL:-}" ]
}

@test "PATH contains ~/.local/bin" {
	case ":$PATH:" in
	*":$HOME/.local/bin:"*) ;;
	*) return 1 ;;
	esac
}

# --- conditional (set only when the dependency is installed) ---

@test "MANPAGER set when bat is present" {
	command -v bat >/dev/null 2>&1 || skip "no bat installed"
	[ -n "${MANPAGER:-}" ]
}

@test "FZF_DEFAULT_COMMAND set when fd is present" {
	command -v fd >/dev/null 2>&1 || skip "no fd installed"
	[ -n "${FZF_DEFAULT_COMMAND:-}" ]
}

@test "FZF_CTRL_T_COMMAND set when fd is present" {
	command -v fd >/dev/null 2>&1 || skip "no fd installed"
	[ -n "${FZF_CTRL_T_COMMAND:-}" ]
}

@test "FZF_ALT_C_COMMAND set when fd is present" {
	command -v fd >/dev/null 2>&1 || skip "no fd installed"
	[ -n "${FZF_ALT_C_COMMAND:-}" ]
}

# --- CI invariants ---

@test "GITHUB_TOKEN set in CI (for ubi GH-API auth)" {
	# make sure we have github token so we don't hit rate limts
	[ "${CI:-}" = "true" ] || skip "CI only"
	[ -n "${GITHUB_TOKEN:-}" ]
}
