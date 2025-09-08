#!/usr/bin/env nextflow
workflow {
    DORADO_POLISH()
}

process DORADO_POLISH {
    cpus 8
    memory '16 GB'
    time '8h'
    clusterOptions '--gpus=A100:1'
    container 'ontresearch/dorado:latest'
    tag "${params.sample_id}"

    publishDir params.outdir, mode: 'copy', pattern: '*.fastq.gz'

    script:
    """
    dorado polish ${params.bam} ${params.reference} \
        --qualities \
        --ignore-read-groups \
        --batchsize 250 \
        > ${params.sample_id}_polished.fastq

    gzip ${params.sample_id}_polished.fastq   
    """
}
