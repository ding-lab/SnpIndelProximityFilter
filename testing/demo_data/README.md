vep_filtered.vcf is based on C3L-00448 from,

/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy-hotspot.cwl/8c2c9693-70d7-4644-bf1b-523e7c719dc0/call-vep_filter/execution/results/vep_filter/vep_filtered.vcf

Houxiang Zhu writes,
    In this file, the variant: 
        chr3  10149878    .    C    A 
    should be filtered out, because there is a indel nearby -> 
        chr3  10149875    .    CT   C


vep_filtered.minimal.vcf has just three variants, the indel and snp of interest, and another snp

