rule fastqc:
    input:
        fwd = "samples/raw/{sample}_R1.fastq.gz",
        rev = "samples/raw/{sample}_R2.fastq.gz"
    output:
        fwd = "samples/fastqc/{sample}/{sample}_R1_fastqc.zip",
        rev = "samples/fastqc/{sample}/{sample}_R2_fastqc.zip"
    conda:
        "../envs/fastqc.yaml"
    shell:
        """fastqc --outdir samples/fastqc/{wildcards.sample} --extract -t 6 -f fastq {input.fwd} {input.rev}"""

rule trim_extra_R1:
    input:
        "samples/raw/{sample}_R1.fastq.gz"
    output:
        "samples/trimmed/{sample}_R1_t.fastq.gz"
    conda:
        "../envs/trimmomatic.yaml"
    shell:
        "trimmomatic SE {input} {output} TAILCROP:95"

rule trim_extra_R2:
    input:
        "samples/raw/{sample}_R2.fastq.gz"
    output:
        "samples/trimmed/{sample}_R2_t.fastq.gz"
    conda:
        "../envs/trimmomatic.yaml"
    shell:
        "trimmomatic SE {input} {output} TAILCROP:95"

    shell:
        """
        
        """
