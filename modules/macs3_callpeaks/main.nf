#!/usr/bin/env nextflow

process CALLPEAKS {
    label 'process_high'
    conda 'envs/macs3_env.yml'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(samplename), path(bam)

    output:
    path('*.narrowPeak')

    script:
    """
    
    """

    stub:
    """
    touch ${samplename}_peaks.narrowPeak
    """
}