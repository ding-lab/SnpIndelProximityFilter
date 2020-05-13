# Launch docker environment for testing SnpIndelProximityFilter

SYSTEM=docker   # MGI and compute1
IMAGE="mwyczalkowski/snp_indel_proximity_filter:20200513"
START_DOCKERD="../../docker/WUDocker"  # https://github.com/ding-lab/WUDocker.git

VOLUME_MAPPING="../demo_data:/data"

# Also need: /storage1/fs1/dinglab/Active/CPTAC3/Common/CPTAC3.catalog
>&2 echo Launching $IMAGE on $SYSTEM
CMD="bash $START_DOCKERD/start_docker.sh -I $IMAGE -M $SYSTEM $@ $VOLUME_MAPPING"
echo Running: $CMD
eval $CMD

