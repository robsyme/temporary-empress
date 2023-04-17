process NORMALISE {
    container "robsyme/temporary-empress:1.0.0"
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

    script:
    """
    DeSeq_Norm_NextFlow.R ${matrix} ${subset} ${nsub} ${method}
    """
}

