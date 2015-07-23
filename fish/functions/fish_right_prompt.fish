# Fish git prompt

set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'verbose'
set __fish_git_prompt_showcolorhints 'yes'

set __fish_git_prompt_color --bold red
set __fish_git_prompt_color_prefix --bold blue
set __fish_git_prompt_color_suffix --bold blue
set __fish_git_prompt_color_bare blue
set __fish_git_prompt_color_merging --bold red
set __fish_git_prompt_color_branch --bold yellow
set __fish_git_prompt_color_dirtystate --bold purple
set __fish_git_prompt_color_stagedstate --bold brown
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_stashstate brown
set __fish_git_prompt_color_untrackedfiles --bold cyan
set __fish_git_prompt_color_upstream --bold green


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
    set venv (set_color -o blue) "("(set_color -o yellow)(basename "$VIRTUAL_ENV")(set_color -o blue)")"(set_color normal)
  end
  set git (__fish_git_prompt)
  set rp "$git$venv"
  test -n $rp; and printf '%s' $rp
end
