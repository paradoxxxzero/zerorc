function bd -d "Go back"
    if test $argv
        cd (echo $PWD | sed "s|\(.*/"$argv"[^/]*/\).*|\1|")
    else
        cd ..
    end
end
