# Example command to run within docker.  Typically, start docker first with 0_start_docker.sh


INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.minimal.vcf"
#INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.vcf"

OUTD="./test_out"
OUT="$OUTD/SIPF.vcf"

/bin/bash /opt/SnpIndelProximityFilter/src/run_SnpIndelProximityFilter.sh -o $OUT $@ $INPUT

echo Written to $OUT
