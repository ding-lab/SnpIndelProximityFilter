from __future__ import print_function
import sys
import vcf.filters
import vcf
import os.path


def eprint(*args, **kwargs):
# Portable printing to stderr, from https://stackoverflow.com/questions/5574702/how-to-print-to-stderr-in-python-2
    print(*args, file=sys.stderr, **kwargs)

# Filter code based on:
#   https://pyvcf.readthedocs.io/en/latest/FILTERS.html#adding-a-filter

# Obtain information about all indels in VCF
#
# Returns dictionary indexed by chrom of lists; 
# each list contains tuples of (indel.start, indel.end),
#   with start given by POS and end given by POS + len(REF)
# Both start and end are in base-0
def get_indels(vcf_fn):
    vcf_reader = vcf.Reader(open(vcf_fn, 'r'))

    indels = {}
    for record in vcf_reader:
        if record.is_indel:
            if record.CHROM not in indels:
                indels[record.CHROM] = []
            start = record.POS
            end = record.POS + len(record.REF) - 1  # -1 so in base 0
            indels[record.CHROM].append( (start, end) )
        
    return indels

class SnvIndelProximityFilter(vcf.filters.Base):
    'Filter variant sites by variant allele frequency (VAF)'

    name = 'proximity'

    @classmethod
    def customize_parser(self, parser):
        parser.add_argument('--distance', type=int, default=5, help='Minimum distance between snp and nearest indel required to retain snp call')
        parser.add_argument('--debug', action="store_true", default=False, help='Print debugging information to stderr')
        parser.add_argument('--vcf', type=str, help='VCF file being processed')
        
    def __init__(self, args):
        self.debug = args.debug
        self.distance = args.distance

        # below becomes Description field in VCF
        self.__doc__ = "Retain SNV variants where distance to nearest indel >= %d" % (self.distance)

        # pre-parse VCF file to get indels record
        self.indels = get_indels(args.vcf)
        eprint("indels: ", self.indels)

    def filter_name(self):
        return self.name

    # If call is a SNV, evaluate whether it is within a given distance of an indel start or end
    def __call__(self, record):
        if record.is_snp:
            if record.CHROM in self.indels:
                for indel in self.indels[record.CHROM]:
                    indel_start, indel_end = indel
                    if abs(record.POS - indel_start) < self.distance or abs(record.POS - indel_end) < self.distance:
                        note = "snp %s:%d is within %d bp of indel [%d - %d] " % (record.CHROM, record.POS, self.distance, indel_start, indel_end)
                        if (self.debug):
                            eprint("FAIL : ", note)
                        return note
        
            if (self.debug):
                eprint("PASS : snp %s:%d not within %d bp of indel" % (record.CHROM, record.POS, self.distance))

