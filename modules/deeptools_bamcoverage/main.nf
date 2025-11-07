#!/usr/bin/env nextflow

process BAMCOVERAGE {
    label 'process_medium'
    conda 'envs/deeptools_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(samplename), path(bam), path(bai)

    output:
    tuple val(samplename), path('*.bw'), emit: bigwig

    script:
    """
    bamCoverage -b $bam -o ${samplename}.bw -p $task.cpus
    """

    stub:
    """
    touch ${samplename}.bw
    """
}