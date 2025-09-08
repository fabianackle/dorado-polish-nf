#!/usr/bin/env nextflow
workflow {
    bam_ch = Channel.fromPath(params.bam)
    bai_ch = Channel.fromPath(params.bai)
    reference_ch = Channel.fromPath(params.reference)
    DORADO_POLISH(bam_ch, bai_ch, reference_ch)
}

process DORADO_POLISH {
    cpus 8
    memory '16 GB'
    time '8h'
    clusterOptions '--gpus=A100:1'
    container 'ontresearch/dorado:latest'
    tag "${params.sample_id}"

    publishDir params.outdir, mode: 'copy', pattern: '*.fastq.gz'

    input:
    path bam
    path bai
    path reference

    output:
    path "${params.sample_id}_polished.fastq"

    script:
    """
    dorado polish ${bam} ${reference} \
        --qualities \
        --ignore-read-groups \
        --batchsize 250 \
        > ${params.sample_id}_polished.fastq

    gzip ${params.sample_id}_polished.fastq   
    """
}
