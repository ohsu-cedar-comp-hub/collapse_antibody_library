import datetime
import sys
import os
import pandas as pd
import json


timestamp = ('{:%Y-%m-%d_%H:%M:%S}'.format(datetime.datetime.now()))

configfile:"omic_config.yaml"

SAMPLES, = glob_wildcards("samples/raw/{sample}_R1.fastq.gz")

fastq_ext = ['R1','R2']

with open('cluster.json') as json_file:
    json_dict = json.load(json_file)

rule_dirs = list(json_dict.keys())
rule_dirs.pop(rule_dirs.index('__default__'))


for rule in rule_dirs:
    if not os.path.exists(os.path.join(os.getcwd(),'logs',rule)):
        log_out = os.path.join(os.getcwd(), 'logs', rule)
        os.makedirs(log_out)
        print(log_out)


def message(mes):
    sys.stderr.write("|--- " + mes + "\n")


for sample in SAMPLES:
    message("Sample " + sample + " will be processed")


rule all:
    input:
        expand("samples/fastqc/{sample}/{sample}_{fastq_ext}_fastqc.zip", sample = SAMPLES, fastq_ext = fastq_ext),
        "results/compiled_antibody_counts.txt"

include: "rules/preprocess.smk"
include: "rules/quantify.smk"
