#!/usr/bin/env nextflow

process BOWTIE2_BUILD {
    label 'process_high'
    conda 'envs/bowtie2_env.yml'

    input:
    path(genome)

    output:
    path('bowtie2_index'), emit: index
    val genome.baseName, emit: name

    script:
    """
    mkdir bowtie2_index
    bowtie2-build --threads $task.cpus $genome bowtie2_index/${genome.baseName}
    """

    stub:
    """
    mkdir bowtie2_index
    """
}