include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {CALLPEAKS} from './modules/macs3_callpeaks'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'

workflow {
    
    // Split the samplesheet csv file to get the name and the condition
    channel.fromPath(params.samplesheet)
           .splitCsv(header : true)
           .map{row -> tuple(row.srr, row.name)}
           .set{samples}

    // Pair up the files from the sample_dir and the samplesheet
    Channel.fromFilePairs(params.sample_dir)
    | join(samples)
    | set{sample_files}
    
    // Create a genome index
    BOWTIE2_BUILD(params.genome)

    // Align the the 6 samples to the reference
    BOWTIE2_ALIGN(sample_files, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)

    // Perform peak-calling
    CALLPEAKS(BOWTIE2_ALIGN.out.bam)

    // Sort the BAM files
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)

    // Index the BAM files
    SAMTOOLS_IDX(SAMTOOLS_SORT.out.sorted)

    // Create the bigwig files
    BAMCOVERAGE(SAMTOOLS_IDX.out.index)
    




}