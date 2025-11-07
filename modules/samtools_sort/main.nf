#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_single'
    conda 'envs/samtools_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(samplename), path(bam)

    output:
    tuple val(samplename), path("*sorted.bam"), emit: sorted

    script:
    """
    samtools sort $bam > ${samplename}.sorted.bam
    """

    stub:
    """
    touch ${samplename}.sorted.bam
    """
}