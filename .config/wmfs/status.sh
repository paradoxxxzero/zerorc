#/bin/sh

# #DATE
# DATECMD=`date +"%A %e %B  %H:%M"`
# DATESEP="$SEPCOL"
# DATE="$DATECMD"

# #MEM
# memfree="`cat /proc/meminfo | grep MemFree | cut -d: -f2 | cut -dk -f1`"
# memtotal="`cat /proc/meminfo | grep MemTotal | cut -d: -f2 | cut -dk -f1`"
# MEMPC=$(echo "scale=5; $memfree/$memtotal*100" | bc -l)

# #CPU
# CPU=`top -n2 -d0.1 | grep "Cpu" | awk {'print $2'} | cut -d. -f1 | tail -n1`

# #Volume
# VOL=`amixer | grep "Master" -A 5 | grep -o "\[.*%" | sed "s/\[//"`

# #MUSIC:O
# MUSICPOS="`mpc -h entrecote | grep \# | awk {'print $4'} | sed -e 's/(//' -e 's/%)//'`"
# MUSICCUR="`printf "%.32s" \"\`mpc -h entrecote current\`\"`"
# MUSIC="\i[900;2;14;14;/home/zero/.config/wmfs/icons/music.png]\ \s[920;14;#D4D4D4;$MUSICCUR]\ $(wmfs-status-gauge 1070 6 30 6 '#0081DE' 1 '#D4D4D4' $MUSICPOS)"

# # Check if mpd is stopped (erase $MUSIC)
# mpc -h entrecote current | grep ".*" > /dev/null 2>&1
# if [ $? -eq 1 ]; then
# MUSIC=""
# fi

# #Battery
# CAPACITY=`cat /proc/acpi/battery/BAT0/info | grep "last\ full\ capacity" | cut -d" " -f9`
# CURRENT=`cat /proc/acpi/battery/BAT0/state | grep "remaining" | cut -d" " -f8`
# BATPC=`gawk -v CONVFMT="%12.2f" -v OFMT="%.5g"  "BEGIN { print $CURRENT / $CAPACITY * 100; }"`
# BAT="\i[1050;2;14;14;/home/zero/.config/wmfs/icons/bat.png]\ $(wmfs-status-gauge 1070 6 30 6 '#0081DE' 1 '#D4D4D4' $BATPC)"

# STATE=`cat /proc/acpi/battery/BAT0/info | grep present | awk '{print $2}'`
# if [ $STATE = "no" ]
# then
#         BAT=""
# fi

# #Affichage
# wmfs -s "$CPU $(wmfs-status-gauge 1130 6 30 6 '#0081DE' 1 '#D4D4D4' $CPU) "

# wmfs -s "$MUSIC $BAT \i[1110;2;14;14;/home/zero/.config/wmfs/icons/cpu.png]\ $(wmfs-status-gauge 1130 6 30 6 '#0081DE' 1 '#D4D4D4' $CPU) \i[1170;2;14;14;/home/zero/.config/wmfs/icons/mem.png]\ $(wmfs-status-gauge 1190 6 30 6 '#0081DE' 1 '#D4D4D4' $MEMPC) \i[1230;2;14;14;/home/zero/.config/wmfs/icons/vol.png]\ $(wmfs-status-gauge 1250 6 30 6 '#0081DE' 1 '#D4D4D4' $VOL) \i[1290;2;14;14;/home/zero/.config/wmfs/icons/time.png]\ \s[1310;14;#D4D4D4;$DATE]\ "

_mpd() {
	############
	# mpd info
	#
	# <mpc> is required for "now playing" informations
	#
	if [ "`mpc -h entrecote 2>&1 | wc -l`" -gt "1" ]; then
		if [ "`mpc -h entrecote | grep "^\[paused\]"`" != "" ]; then
			mpd_current="`mpc -h entrecote current` [pause]"
		else
			mpd_current=`mpc -h entrecote current`
		fi
		mpd_vol=`mpc -h entrecote volume | cut -d ' ' -f2 | cut -d '%' -f1 `
	else
		mpd_current="\o/"
	fi
	mpd="\\#cba642\\$mpd_current \\#fbb279\\$mpd_vol%"
	#
	############
}

_mocp_author(){
	############
	# mocp author info
	#
	# <mocp> is required for "now playing" informations
	#
	author=`mocp -i | grep Artist | awk -F ": " '{print $2}'`
	mocp_author="\\#cba642\\$author"
	#
	############

}

_mocp_song(){
	############
	# mocp author info
	#
	# <mocp> is required for "now playing" informations
	#
	SONG=`mocp -i | grep SongTitle | awk -F ": " '{print $2}'`
	#
	############
}

_network() {
	############
	#	network
	#
	# network usage stats
	#
	# Variables
	ethiface=eth0
	wlaniface=wlan0
	tmpdir=/tmp
	#
	# Functions
	function rx_bytes { # download
		rxethernet=`cat /sys/class/net/$ethiface/statistics/rx_bytes`
		rxwireless=`cat /sys/class/net/$wlaniface/statistics/rx_bytes`
		echo $(($rxethernet+$rxwireless))
	}
	#
	function tx_bytes { # upload
		txethernet=`cat /sys/class/net/$ethiface/statistics/tx_bytes`
		txwireless=`cat /sys/class/net/$wlaniface/statistics/tx_bytes`
		echo $(($txethernet+$txwireless))
	}
	#
	# Download
	lastrxbytes=`cat $tmpdir/last_rxbytes`
	# Upload
	lasttxbytes=`cat $tmpdir/last_txbytes`
	#
	# Download
	rxbytes=`rx_bytes`
	rxresult=$((($rxbytes-lastrxbytes)/1000))
	echo $rxbytes > $tmpdir/last_rxbytes
	#
	# Upload
	txbytes=`tx_bytes`
	txresult=$((($txbytes-lasttxbytes)/1000))
	echo $txbytes > $tmpdir/last_txbytes
	#
	# Output
	network="\\#81ae51\\↓ $rxresult Ko/s | $txresult Ko/s ↑"
	#
	############
}

_battery() {
	############
	# battery state
	#
	bat_percent=$((`cat /sys/class/power_supply/BAT*/charge_now`/`cat /sys/class/power_supply/BAT*/charge_full_design | sed 's/00$//'`))
	bat_acpi=`cat /sys/class/power_supply/BAT*/status`
	#
	# use an arrow to show if battery is charging, discharging or full/AC
	#
	if [ "$bat_acpi" = "Discharging" ]; then
		bat_state="↓"
	elif [ "$bat_acpi" = "Charging" ]; then
		bat_state="↑"
	fi
	#
	# blinking battery percent indicator if bat_percent < 15
	#
	if [ "$bat_percent" -lt "15" ]; then
		bat_fail=1
		if [ "`cat /tmp/batteryfail`" ]; then
			color="\\#ff6b6b\\"
			echo 0 > /tmp/batteryfail
		else
			color="\\#435e87\\"
			echo 1 > /tmp/batteryfail
		fi
	else
		bat_fail=0
		color="\\#1cb259\\"
	fi
	#
	############
	# battery time
	#
	# <acpi> is required
	#
	#bat_remtime="`acpi | cut -d' ' -f5 | cut -d':' -f1,2`"
	#
	############
	battery="$color Bat. $bat_percent% $bat_state"
}

_uptime() {
	############
	# uptime
	#
	uptime=`cut -d'.' -f1 /proc/uptime`
	secs=$((${uptime}%60))
	mins=$((${uptime}/60%60))
	hours=$((${uptime}/3600%24))
	days=$((${uptime}/86400))
	uptime="${mins}m ${secs}s"
	#
	if [ "${hours}" -ne "0" ]; then
	  uptime="${hours}h ${uptime}"
	fi
	#
	if [ "${days}" -ne "0" ]; then
	  uptime="${days}d ${uptime}"
	fi
	#
	############
}

_memory() {
	############
	# memory usage
	#
	memory_used="`free -m | sed -n 's|^-.*:[ \t]*\([0-9]*\) .*|\1|gp'`"
	memory_total="`free -m | sed -n 's|^M.*:[ \t]*\([0-9]*\) .*|\1|gp'`"
	color="\\#F0C0C0\\"
	memory="$color $memory_used/$memory_total Mo"
	#
	############
}

_volume() {
	############
	# volume
	#
	# <amixer> is required
	#
	if [ "`amixer get Master | grep '\[off\]$'`" = "" ]; then
		volume=`amixer get Master | sed -n 's|.*\[\([0-9]*\)\%.*|\1%|pg'`
	else
		volume="[off]"
	fi
	#
	############
}

_date() {
	############
	# date
	#
	sys_date=`date '+%a %d %b %Y'`
	date="\\#ff6b6b\\$sys_date"
	#
	############
}

_hour() {
	############
	# hour
	#
	sys_hour=`date '+%H:%M'`
	hour="\\#1793d1\\$sys_hour"
	#
	############
}

_ompload() {
	############
	# ompload
	#
	# <ompload> is required
	# <cropscreen.sh> is required
	#
	[ -e /tmp/omploadurl ] && ompload_url=`cat /tmp/omploadurl`
	ompload="$ompload_url"
	#
	############
}

_separateur() {
	separateur="•"
}

statustext() {
	############
	# concatenate arguments
	#
	for arg in $@; do
		_${arg}
		args="${args}  `eval echo '$'$arg`"
	done
	#
	############
	# wmfs magic
	#
	wmfs -s "$args"
	#
	############
}

############
# status text
#
# add <variables> from the following list
# mpd network battery uptime volume date hour ompload
#
#statustext ompload mpd network battery date hour
statustext mpd separateur battery separateur memory separateur  date separateur hour
#
############
