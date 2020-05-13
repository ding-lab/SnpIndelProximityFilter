#/bin/bash

# simple wrapper for running SnpIndelProximityFilter.py
# * some arguments will be passed verbatim to script
# Details about calling filter: https://pyvcf.readthedocs.io/en/latest/FILTERS.html#adding-a-filter

# some arguments need to be intercepted:
# --no-filtered is passed to vcf_filter.py directly

# Defining --no-filtered removes calls which fail the filter, otherwise they are retained but marked as 
# "proximity" in variant filter field
# FILTER=" --no-filtered" 
FILTER=""


# OUTPUT=argument is passed
# INPUT
# dryrun at this level

# Args passed to proximity filter:
# --distance 'Minimum distance between snv and nearest indel required to retain snv call'
# --debug 'Print debugging information to stderr'

source utils.sh

ARGS="$@"

# if blank, write to STDOUT
#OUTPUT="test_out/SIPF.vcf"

INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.minimal.vcf"
#INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.vcf"

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
