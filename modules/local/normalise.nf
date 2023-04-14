process NORMALISE {
    container "396758234180.dkr.ecr.us-east-1.amazonaws.com/nf-rnaseq/normalisation:v2"
    // errorStrategy 'finish'
    cpus 2
    memory '37 GB'
    publishDir "${params.outdir}", mode: 'copy'
    label 'process_high'

    input:
    path matrix
    val subset
    val nsub
    val method

    output:
    path ('*.csv'), optional: true
    // stdout

    script:
    """
    DeSeq_Norm_NextFlow.R ${matrix} ${subset} ${nsub} ${method}
    """
}

