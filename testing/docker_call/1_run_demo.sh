IMAGE="mwyczalkowski/snp_indel_proximity_filter:latest"

INPUT="/opt/SnpIndelProximityFilter/testing/demo_data/vep_filtered.vcf"
OUT="/data/test_output/SIPF.vcf"
ARGS="-v"

# This is what we want to run in docker
CMD_INNER="/bin/bash /opt/SnpIndelProximityFilter/src/run_SnpIndelProximityFilter.sh -o $OUT $ARGS $@ $INPUT"


SYSTEM=docker   # docker MGI or compute1
START_DOCKERD="../../docker/WUDocker"  # https://github.com/ding-lab/WUDocker.git

VOLUME_MAPPING="../demo_data:/data"

>&2 echo Launching $IMAGE on $SYSTEM
CMD_OUTER="bash $START_DOCKERD/start_docker.sh -I $IMAGE -M $SYSTEM -c \"$CMD_INNER\" $@ $VOLUME_MAPPING "
echo Running: $CMD_OUTER
eval $CMD_OUTER
