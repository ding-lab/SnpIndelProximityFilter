#/bin/bash

read -r -d '' USAGE <<'EOF'
Filter all SNP variants within a given distance of an indel

Usage:
  bash run_filter.sh [options] input.vcf

Options:
-h: Print this help message
-d: Dry run. output commands but do not execute them
-v: print filter debug information
-o OUTPUT : Output filename.  Directory will be created.  Default: write to stdout
-D distance: Minimum distance between snv and nearest indel required to retain snv call.  Default is 5
-N: remove filtered variants.  Default is to retain filtered variants with "proximity" in VCF FILTER field
EOF

source /opt/SnpIndelProximityFilter/src/utils.sh
SCRIPT=$(basename $0)

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hdvo:D:N" opt; do
  case $opt in
    h)
      echo "$USAGE"
      exit 0
      ;;
    d)  
      DRYRUN=1
      ;;
    v)  
      ARGS="$ARGS --debug"
      ;;
    o) 
      OUTPUT="$OPTARG"
      ;;
    D) 
      ARGS="$ARGS --distance $OPTARG"
      ;;
    N)  
      FILTER="--no-filtered" 
      ;;
    \?)
      >&2 echo "Invalid option: -$OPTARG"
      >&2 echo "$USAGE"
      exit 1
      ;;
    :)
      >&2 echo "Option -$OPTARG requires an argument."
      >&2 echo "$USAGE"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ "$#" -ne 1 ]; then
    >&2 echo ERROR: Wrong number of arguments
    >&2 echo "$USAGE"
    exit 1
fi
INPUT=$1; shift
confirm $INPUT

if [ $OUTPUT ]; then
    # Make output dir
    OUTDIR=$(dirname $OUTPUT)
    CMD="mkdir -p $OUTDIR"
    run_cmd "$CMD" $DRYRUN
fi

export PYTHONPATH="/opt/SnpIndelProximityFilter/src:$PYTHONPATH"

PYTHON="/usr/local/bin/python"
VCF_FILTER="/usr/local/bin/vcf_filter.py"

PROX_FILTER="$PYTHON $VCF_FILTER $FILTER --local-script SnpIndelProximityFilter.py "  # filter module

# Need to pass VCF twice - once to VCF_FILTER and once to the Proximity Filter
CMD="$PROX_FILTER $INPUT proximity --vcf $INPUT $ARGS "

if [ $OUTPUT ]; then
    CMD="$CMD > $OUTPUT"
fi

run_cmd "$CMD" $DRYRUN

if [ "$OUT_VCF" ]; then
    >&2 echo Written to $OUT_VCF
fi
