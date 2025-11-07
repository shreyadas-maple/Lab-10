#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    conda 'envs/bowtie2_env.yml'

    input:
    tuple val(srr), path(reads), val(samplename)
    path bt2
    val name

    output:
    tuple val(samplename), path('*bam'), emit: bam

    script:
    """
    bowtie2 -p 8 -x $bt2/$name -1 ${reads[0]} -2 ${reads[1]} --no-mixed --no-discordant -X 2000 | samtools view -bS - > ${samplename}.bam
    """

    stub:
    """
    touch ${samplename}.bam
    """
}