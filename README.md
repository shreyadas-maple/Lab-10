# Lab 10 - Differential Peak Analysis

## Background

We will be analyzing data from this paper: https://pmc.ncbi.nlm.nih.gov/articles/PMC7889151/

They performed ATACseq in a cancer cell line and were looking at how the
chromatin environment was changing following IL31 stimulation.

## Setup

For today's lab, try your best to put together a nextflow pipeline that will quickly
generate a genome index for the human genome, align the 6 samples to the reference, 
perform peak calling using MACS3, sort and index the BAM files, and generate a bigWig. 

In the interest of time, we are going to skip quality control and assume that the data
is of high quality. We will also skip filtering out mitochondrial alignments, shifting
the reads to account for the 9bp duplication induced by the transposon nicking, and other
post-alignment QC checks. We will also return to using Conda as there seems to be issues
with MACS3 and containers and our cluster. 

As we discussed, ATACseq data processing is highly similar to the beginning of most NGS 
experiments. We do set a few special parameters in BowTie2 to account for some of the nuances
of ATACseq.

1. `-X 2000` - This parameter controls the maximum fragment length that is valid for paired
end reads. We set this value to 2000 to capture events where the paired end reads
capture positions across multiple nucleosomes. Remember that each nucleosome may have
~147bp of DNA sequence wound around it and so di-, tri- and multiple nucleosome events
may span a larger distance than expected. 

2. `--no-discordant` and `--no-mixed` - Both of these flags are meant to ensure that the
only alignments BowTie2 keep are those where both pairs properly align. Remember that in 
an ATACseq experiment, each sequenced end of a read pair corresponds to a transposition event
where the transposon bound and nicked the original sequence. These flags ensure that we only
keep reads where both of the read pair align as expected. 


## Tasks

### First Hour

1. Generate a workflow that performs the functions described above
- You will need to figure out the command for MACS3 and how to call peaks on ATACseq data
- The rest of the modules have been provided for you as we've already worked with them
- Use the 1st hour for this, and after, I will provide some sample outputs to work with in
diffbind

2. Your initial channel will need to include the original samples as well as their actual
names. Please use the samplesheet, Channel.fromFilePairs and an appropriate nextflow operator
to create the initial channel with the same structure as seen in the input of BOWTIE2_ALIGN 
- a tuple with the first value being the SRR identifier, the second being the file, and the
third being the name from the samplesheet. 

### Second Hour

1. Once you've generated data, try to figure out how to use the DiffBind package to 
call differentially accessible regions. Export the significant results as a BED file
- I've given you a lot of guidance on how to use various tools. Sometimes, you may be asked
to figure out how to use something on your own. Try to figure out DiffBind and how to run it.
- You can start with default parameters in DiffBind. Generally speaking, you usually can start
with default parameters for *most* well-documented tools and adjust if necessary depending on
the results you see. 

2. Open a genome browser and load the BAMS, bigWigs, and BED file of significantly
differentially accessible regions and try to confirm if you see similar results as the
paper.
- Can you think of more high-throughputs ways of visualizing these differentially accessible regions?

## DiffBind

The basic steps in DiffBind should sound very familiar. We encode all the information about our
samples in a CSV. DiffBind requires the BAM files as well as results from a standard peak caller.
It uses the peak calls to generate a consensus set of peaks to define regions of interest. It then
uses the BAM files and these regions of interest to quantify how many reads fall into these locations.
This becomes the eventual input quantification matrix.

Generally speaking, we read in our data, normalize the counts, determine a model design and contrast, 
and perform differential binding analysis. On the backend, DiffBind utilizes DESeq2 to normalize and 
test for differential binding sites. Although there are many ways to customize how you run DiffBind, 
we will start with default parameters and inspect how well we are able to reproduce the results we see
in the original paper. 

## Extra

If you manage to do all of this, you can see if you can produce a figure like the one found in refs/. You will need the BED file of outputs from DiffBind and the bigWigs generated from DeepTools.