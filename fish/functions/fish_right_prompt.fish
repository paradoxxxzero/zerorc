# Fish git prompt

set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'verbose'
set __fish_git_prompt_showcolorhints 'yes'

set __fish_git_prompt_color red bold
set __fish_git_prompt_color_prefix blue bold
set __fish_git_prompt_color_suffix blue bold
set __fish_git_prompt_color_bare blue
set __fish_git_prompt_color_merging red bold
set __fish_git_prompt_color_branch yellow bold
set __fish_git_prompt_color_dirtystate purple bold
set __fish_git_prompt_color_stagedstate brown bold
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_stashstate brown
set __fish_git_prompt_color_untrackedfiles cyan bold
set __fish_git_prompt_color_upstream green bold


# Status Chars
# set __fish_git_prompt_char_dirtystate ' ⚡'
# set __fish_git_prompt_char_stagedstate ' →'
# set __fish_git_prompt_char_invalidstate ' ?'
# set __fish_git_prompt_char_stashstate ' ♻'
# set __fish_git_prompt_char_untrackedfiles ' ★'
# set __fish_git_prompt_char_upstream_ahead ' ↑'
# set __fish_git_prompt_char_upstream_equal ' ✔'
# set __fish_git_prompt_char_upstream_behind ' ↓'
# set __fish_git_prompt_char_upstream_diverged ' ↕'



function fish_right_prompt
  set venv ""
  if set -q VIRTUAL_ENV
    set venv (set_color -o blue) " (" (set_color -o yellow) (basename "$VIRTUAL_ENV") (set_color -o blue) ")" (set_color normal)
  end
  printf '%s ' (__fish_git_prompt)
  echo -n -s $venv
end
