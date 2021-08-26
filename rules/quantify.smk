rule trim_antibody_sqnc:
    input:
        "samples/trimmed/{sample}_R1_t.fastq.gz"
    output:
        "samples/trimmed_antibody/{sample}_R1_t.fastq.gz"
    conda:
        "../envs/trimmomatic.yaml"
    shell:
        "trimmomatic SE {input} {output} HEADCROP:30 TAILCROP:10"

rule collapse:
    input:
        "samples/trimmed_antibody/{sample}_R1_t.fastq.gz"
    output:
        "samples/antibody_counts/{sample}_counts.txt"
    shell:
        "zcat {input} | awk 'NR % 4 == 2' | sort -k1 | uniq -c > {output}"

rule compile:
    input:
        expand("samples/antibody_counts/{sample}_counts.txt", sample = SAMPLES)
    output:
        "results/compiled_antibody_counts.txt"
    script:
        "../scripts/merge_counts.R"
