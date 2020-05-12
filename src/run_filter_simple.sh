# simple wrapper for running SnpIndelProximityFilter.py
# * some arguments will be passed verbatim to script
# Details about calling filter: https://pyvcf.readthedocs.io/en/latest/FILTERS.html#adding-a-filter

# some arguments need to be intercepted:
# --no-filtered is passed to vcf_filter.py directly

# for now, we want to remove the --no-filtered argument we typically use since we need to keep
# variants
FILTER=""
# FILTER=" --no-filtered" 
# OUTPUT="--output OUTPUT"
# INPUT
# dryrun at this level

# Args passed to proximity filter:
# --distance 'Minimum distance between snv and nearest indel required to retain snv call'
# --debug 'Print debugging information to stderr'

source utils.sh

ARGS="$@"

mkdir -p test_out
OUTPUT="--output test_out/SIPF.vcf"

# this is hard-coded for testing only
#INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.minimal.vcf"
# this is known good VCF
INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.vcf"


export PYTHONPATH="/opt/SnpIndelProximityFilter/src:$PYTHONPATH"
# MERGE_FILTER="vcf_filter.py --no-filtered --local-script merge_filter.py"  # filter module

PYTHON="/usr/local/bin/python"
VCF_FILTER="/usr/local/bin/vcf_filter.py"

PROX_FILTER="$PYTHON $VCF_FILTER $FILTER $OUTPUT --local-script SnpIndelProximityFilter.py "  # filter module

# Need to pass VCF twice - once to VCF_FILTER and once to the Proximity Filter
CMD="$PROX_FILTER $INPUT proximity --vcf $INPUT $ARGS "

#MERGE_FILTER="$PYTHON $VCF_FILTER $FILTER $OUTPUT --local-script DemoFilter.py"  # filter module
#CMD="$MERGE_FILTER $INPUT sq $ARGS "

run_cmd "$CMD" $DRYRUN

if [ "$OUT_VCF" ]; then
    >&2 echo Written to $OUT_VCF
fi
