token () {
    local length=${1:-20}
    python -c 'import os, base64, sys; print(base64.urlsafe_b64encode(os.urandom(int(sys.argv[1]))).decode("utf-8").rstrip("="))' $length
}

highstate-analyze () {
    grep -e ID: -e Function: -e Duration: | cut -d : -f 2 | python -c "import sys; lines = [line.strip() for line in sys.stdin]; print('\n'.join('%s %s (%s)' % (f3, f1, f2) for f1, f2, f3 in [lines[i*3:i*3+3] for i in range(len(lines)//3)]))" | sort -nr
}

extract-eqsep-fields () {
    # Allows easy filtering of KEY=VAL KEY2=VAL2 data
    python -c "
import sys
fields = sys.argv[1].split(',') if len(sys.argv) == 2 else []
for line in sys.stdin:
    parts = line.split()
    values = {t[0]: t[1] if len(t) == 2 else '' for t in (part.split('=') for part in parts)}
    if fields:
        print ' '.join('%s=%s' % (key, values[key] if key in values else '') for key in fields)
    else:
        print ' '.join('%s=%s' % (key, val) for key, val in values.items())" $1
}

number_stats () {
    grep -E '[0-9]*(\.[0-9]*)?' \
        | R -q -e "x <- read.csv('stdin', header = F); summary(x); sd(x[ , 1])"
}

psgrep () {
    first=$(echo $1 | cut -c1)
    last=$(echo $1 | cut -c2-)
    ps aux \
        | grep -i "[$first]$last"
}

highlight () {
    grep --color -E "$1|$"
}

cert () {
    echo \
        | openssl s_client -connect "$1":443 -servername "${2:-$1}" \
        | sed -ne '/-BEG/,/-END/p'
}

rev () {
    local new_name="${1%.*}_$(md5 -r $1 | head -c 12).${1##*.}"
    echo "Revving $1 -> $new_name"
    mv "$1" "$new_name"
}

netst () {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        lsof -PniTCP -sTCP:LISTEN
    else
        sudo netstat -tulpn
    fi
}

alias ..='cd ..'
alias ...='cd ../../'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -alhF'
alias l='ls -lhF'
alias sudo='sudo '
alias sumutt='sudo HOME=/root mutt -e "set sort=reverse-date"'
alias serve='python -m SimpleHTTPServer'
alias space='du -shc * .[^.]* | gsort -h'
alias json='python -m json.tool'
alias xml='python -c "from __future__ import print_function; import sys, xml.dom.minidom; ugly_xml = xml.dom.minidom.parseString(sys.stdin.read()); print(ugly_xml.toprettyxml(), end=\"\")"'
alias pc='python -c'
alias fw='sudo iptables -L -v -n --line-numbers'
alias fw6='sudo ip6tables -L -v -n --line-numbers'
alias ptr='dig +short -x'
alias g=git
alias sub=subl
alias uuid='python -c "import uuid; print(uuid.uuid4())"'
alias telnet='echo "Escape is probably Ctrl+5!"; telnet'
alias pubip='curl https://canhazip.com'
