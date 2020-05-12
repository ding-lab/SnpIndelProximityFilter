from __future__ import print_function
import sys
import vcf.filters
import os.path


def eprint(*args, **kwargs):
# Portable printing to stderr, from https://stackoverflow.com/questions/5574702/how-to-print-to-stderr-in-python-2
    print(*args, file=sys.stderr, **kwargs)

# Filter code based on that here:
#   https://pyvcf.readthedocs.io/en/latest/FILTERS.html#adding-a-filter
# as well as VAF Length Depth filter implementation here:
#   https://github.com/ding-lab/VLD_FilterVCF

# Algorithm:
# 

# based on old/varscan_vcf_remap.py:remap_vcf()

def get_indels(f):
    vcf_reader = vcf.Reader(fsock=f)

    for record in vcf_reader:

      #  Continue here - go through all 
      # variants, and if is an indel, add to dictionary of lists,,
      # indels[chrom].push( (record.start, record_end ) )
      # where record_end = record.start + len( record.REF )


class SnvIndelProximityFilter(vcf.filters.Base)
    'Filter variant sites by variant allele frequency (VAF)'

    name = 'proximity'

    @classmethod
    def customize_parser(self, parser):
        parser.add_argument('--distance', type=int, help='Minimum distance between snv and nearest indel required to retain snv call')
        parser.add_argument('--debug', action="store_true", default=False, help='Print debugging information to stderr')
        
    def __init__(self, args):
        self.debug = args.debug
        self.distance = args.distance

        # below becomes Description field in VCF
        self.__doc__ = "Retain SNV variants where distance to nearest indel <= %d" % (self.distance)

        # pre-parse VCF file to get indels record
        self.indels = get_indels(args.input)
            
    def filter_name(self):
        return self.name


    def __call__(self, record):

# if record is snv:
#   for indel in self.indels[record.chrom]:
#       indel_start, indel_end = indel
#       if abs(record.pos - indel_start) < distance || abs(record.pos - indel_end) < distance:
#           if (self.debug):
#               eprint("** FAIL : CHROM SNV.pos = %d, INDEL.pos = %d - %d **")
#           return "IndelProx"
#       if (self.debug):
#           eprint("** PASS CHROM SNV.pos : proximity filter")



