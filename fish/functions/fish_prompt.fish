function fish_prompt
  if not set -q -g __mac_primary_color
      set _mac (cat /sys/class/net/????*/address)[1]
      set -g  __mac_primary_color (set_color -o (echo $_mac |cut -d':' -f 4- |sed s/://g))
      set -g  __mac_secondary_color (set_color -o (echo $_mac |cut -d':' -f -3 |sed s/://g))
  end

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l normal (set_color normal)

  set -l arrow " $red➜ "
  set -l cwd $cyan(prompt_pwd)

  set host (hostname|cut -d . -f 1)
  set user_host "$__mac_primary_color$USER$red$arrow$__mac_secondary_color$host"

  echo ""
  echo -s $user_host $arrow $cwd
  echo -n -s "$__mac_primary_color> " $normal
end
