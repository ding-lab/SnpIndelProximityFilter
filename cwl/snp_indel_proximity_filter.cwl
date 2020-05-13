class: CommandLineTool
cwlVersion: v1.0
id: snp_indel_proximity_filter
baseCommand:
  - /bin/bash
  - /opt/SnpIndelProximityFilter/src/run_SnpIndelProximityFilter.sh 
inputs:
  - id: input
    type: File
    inputBinding:
      position: 0
      prefix: '-i'
    label: VCF file
outputs:
  - id: output
    type: File
    outputBinding:
      glob: output/ProximityFiltered.vcf
label: snp_indel_proximity_filter
arguments:
  - position: 99
#    prefix: ''
    valueFrom: output/ProximityFiltered.vcf
requirements:
  - class: DockerRequirement
    dockerPull: 'mwyczalkowski/snp_indel_proximity_filter:20200513'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 2000

