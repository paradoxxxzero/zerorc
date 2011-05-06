/usr/bin/scr

if [ -z $(pidof cairo-compmgr) ]; then
    /usr/bin/cairo-compmgr
fi

if [ -z $(pidof devilspie) ]; then
    /usr/bin/devilspie
fi

