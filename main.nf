#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Normalise/test-norm
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/Normalise/test-norm
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

// params.fasta = WorkflowMain.getGenomeAttribute(params, 'fasta')

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE & PRINT PARAMETER SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

WorkflowMain.initialise(workflow, params, log)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOW FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// include { TEST_NORM } from './workflows/test-norm'

//
// WORKFLOW: Run main Normalise/test-norm analysis pipeline
//
// workflow NORMALISE_TEST_NORM {
//     TEST_NORM ()
// }

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
// workflow {
//     NORMALISE_TEST_NORM ()
// }



// Show help message
params.help = false

if (params.help){
    helpMessage()
    exit 1
}

def helpMessage() {

  log.info"""
    =========================================
     EMPRESSTX - Downstream normalisation Steps - ${workflow.manifest.version}
    =========================================
    Usage:
    The typical command for running the pipeline is as follows:

    nextflow run  "s3:path" --matrix "s3://path/*.xlsx" --method "Standard" --subset "TRUE" --nsub "800" -profile 'awsbatch'

    Mandatory arguments:
      --matrix                  String     Path to count matrix in Excel format
      --subset                  String     Choose between TRUE/FASLE. Subsets matrix into 1000 genes x 480 samples
      --nsub                    String     Genes to estimate curve in Norm_Vst_Boots method
      -profile                  String     Hardware config to use. awsbatch / slurm / local

    

  """.stripIndent()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE & PRINT PARAMETER SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// WorkflowMain.initialise(workflow, params, log)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOW FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { TEST_NORM } from './workflows/test-norm.nf'

// matrix_ch = Channel.fromPath(params.matrix)
//     matrix_ch.view()
//

// process NORMALISE {
//     container "396758234180.dkr.ecr.us-east-1.amazonaws.com/nf-rnaseq/normalisation:latest"
//     // errorStrategy 'finish'
//     cpus 8
//     memory '52 GB'
//     publishDir "$params.outdir", mode: 'copy'

//     input:
//     path matrix
//     val subset
//     val nsub

//     output:
//     // stdout
//     path "*.csv", optional: true

//     script:
//     """
//     DeSeq_Norm_NextFlow.R ${matrix} ${subset} ${nsub}
//     """
// }

// workflow  {
//     NORMALISE(params.matrix, params.subset, params.nsub)

// }

//
workflow  {
    TEST_NORM()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
