# SnpIndelProximityFilter

Retain SNV variants where distance to nearest indel >= D

## Algorithm

1. Make a list of start and end positions of all indels in VCF, where start is given by POS
   and end is POS + length(REF) - 1
2. For each SNV call, evaluate whether it is within a given distance (default 5) of an indel start or end
   
## Usage
```
Usage:
  bash run_SnpIndelProximityFilter.sh [options] input.vcf

Options:
-h: Print this help message
-d: Dry run. output commands but do not execute them
-v: print filter debug information
-o OUTPUT : Output filename.  Directory will be created.  Default: write to stdout
-D distance: Minimum distance between snv and nearest indel required to retain snv call.  Default is 5
-N: remove filtered variants.  Default is to retain filtered variants with "proximity" in VCF FILTER field
```

## Installation
```
git clone --recursive https://github.com/ding-lab/SnpIndelProximityFilter.git
```

Docker image: `mwyczalkowski/snp_indel_proximity_filter`


# Contact

Matt Wyczalkowski (m.wyczalkowski@wustl.edu)


