FROM python:2

RUN pip install PyVCF argparse pysam ConfigParser
RUN apt-get update && apt-get install -y \
    vim
ENV PYTHONPATH="/usr/local/lib/python3.7/site-packages:/opt/SnpIndelProximityFilter/src"

COPY docker/vimrc /root/.vimrc
COPY . /opt/SnpIndelProximityFilter

WORKDIR /opt/SnpIndelProximityFilter
