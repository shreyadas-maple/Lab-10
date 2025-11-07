#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_single'
    conda 'envs/samtools_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(samplename), path(bam)

    output:
    tuple val(samplename), path(bam), path("*.bai"), emit: index

    script:
    """
    samtools index $bam
    """

    stub:
    """
    touch ${samplename}.sorted.bam.bai
    """
}