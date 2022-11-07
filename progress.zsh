#!/bin/sh

# Main function
PROGRESS_DELAY=0.075

function update_prc {
    PRC=`printf "%.0f" ${1}`  # Uses the argument as the percentage.
    SHW=`printf "%3d\n" ${PRC}`
}

function update_tme {
    # updates the time
    SEC=`printf "%04d\n" $(($(date +"%s")-${TME}))`; SEC="$SEC sec"
}
echo " Zapping ..."
progress() {
    # Defining colors with escape sequences
    PROGRESS_DELAY=0.05
    LR='\033[1;31m'  # Bright Red
    LY='\033[1;33m'  # Bright Yellow
    LW='\033[1;37m'  # Bold White
    NC='\033[0m'     # Restore to default

    # $1 (first argument) is 0, then the time (TME) is "now"
    if [ "${1}" = "0" ]; then
        TME=$(date +"%s");
    fi

    SEC=`printf "%04d\n" $(($(date +"%s")-${TME}))`; SEC="$SEC sec"
    PRC=`printf "%.0f" ${1}`  # Uses the argument as the percentage. Should be calculated every time
    SHW=`printf "%3d\n" ${PRC}`
    LNE=`printf "%.0f" $((${PRC}/2))`
    LRR=`printf "%.0f" $((${PRC}/2-12))`; if [ ${LRR} -le 0 ]; then LRR=0; fi;
    LYY=`printf "%.0f" $((${PRC}/2-24))`; if [ ${LYY} -le 0 ]; then LYY=0; fi;
    LCC=`printf "%.0f" $((${PRC}/2-36))`; if [ ${LCC} -le 0 ]; then LCC=0; fi;
    LGG=`printf "%.0f" $((${PRC}/2-48))`; if [ ${LGG} -le 0 ]; then LGG=0; fi;

    LRR_=""
    LYY_=""
    LCC_=""
    LGG_=""

    # Each loop changes one of the 4 colors

    for ((i=1;i<=13;i++))
    do
        DOTS=""; for ((ii=${i};ii<13;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}▇"; else LRR_="${LRR_}."; fi
        echo -ne "  ${LW}${SEC}  ${LY}${LRR_}${DOTS}${LY}............${LY}............${LY}............ ${SHW}%${NC}\r"
        if [ ${LNE} -ge 1 ]; then update_prc $(($i + $i + 1)); update_tme $(($i + $i + 4)); run_scripts $(($i + $i + 1)); fi
    done
    for ((i=14;i<=25;i++))
    do
        DOTS=""; for ((ii=${i};ii<25;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LYY_="${LYY_}▇"; else LYY_="${LYY_}."; fi
        echo -ne "  ${LW}${SEC}  ${LY}${LRR_}${LY}${LYY_}${DOTS}${LY}............${LY}............ ${SHW}%${NC}\r"
        if [ ${LNE} -ge 14 ]; then update_prc $(($i + $i + 1)); update_tme $(($i + $i + 4)); run_scripts $(($i + $i + 2)); fi
    done
    for ((i=26;i<=37;i++))
    do
        DOTS=""; for ((ii=${i};ii<37;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}▇"; else LCC_="${LCC_}."; fi
        echo -ne "  ${LW}${SEC}  ${LY}${LRR_}${LY}${LYY_}${LY}${LCC_}${DOTS}${LY}............ ${SHW}%${NC}\r"
        if [ ${LNE} -ge 26 ]; then update_prc $(($i + $i + 1)); update_tme $(($i + $i + 4)); run_scripts $(($i + $i + 3)); fi
    done
    for ((i=38;i<=49;i++))
    do
        DOTS=""; for ((ii=${i};ii<49;ii++)); do DOTS="${DOTS}."; done
        if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}▇"; else LGG_="${LGG_}."; fi
        echo -ne "  ${LW}${SEC}  ${LY}${LRR_}${LY}${LYY_}${LY}${LCC_}${LY}${LGG_}${DOTS} ${SHW}%${NC}\r"
        if [ ${LNE} -ge 38 ]; then update_prc $(($i + $i + 1)); update_tme $(($i + $i + 4)); run_scripts $(($i + $i + 4)); fi
    done
}

echo ""
