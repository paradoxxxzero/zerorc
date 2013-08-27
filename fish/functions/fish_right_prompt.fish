# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_color -o red
set __fish_git_prompt_color_prefix -o blue
set __fish_git_prompt_color_suffix -o blue
set __fish_git_prompt_color_bare blue
set __fish_git_prompt_color_merging -o red
set __fish_git_prompt_color_branch -o yellow
set __fish_git_prompt_color_dirtystate -o purple
set __fish_git_prompt_color_stagedstate -o brown
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_stashstate brown
set __fish_git_prompt_color_untrackedfiles -o cyan
set __fish_git_prompt_color_upstream -o green


# Status Chars
set __fish_git_prompt_char_dirtystate ' ⚡'
set __fish_git_prompt_char_stagedstate ' →'
set __fish_git_prompt_char_invalidstate ' ?'
set __fish_git_prompt_char_stashstate ' ♻'
set __fish_git_prompt_char_untrackedfiles ' ★'
set __fish_git_prompt_char_upstream_ahead ' ↑'
set __fish_git_prompt_char_upstream_equal ' ✔'
set __fish_git_prompt_char_upstream_behind ' ↓'
set __fish_git_prompt_char_upstream_diverged ' ↕'

function fish_right_prompt
  set venv ""
  if set -q VIRTUAL_ENV
    set venv (set_color -o blue) " (" (set_color -o yellow) (basename "$VIRTUAL_ENV") (set_color -o blue) ")" (set_color normal)
  end
  printf '%s ' (__fish_git_prompt)
  echo -n -s $venv
end
