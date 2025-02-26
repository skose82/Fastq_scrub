#!/usr/bin/env nextflow
/* 
 * pipeline input parameters 
 */
params.reads = "${launchDir}/fastqs/*.fastq.gz"
params.outdir = "${launchDir}/output/"

/*if paired end 
#params.reads = "${launchDir}/fastqs/foo_{1,2}.fq" 
*/

log.info """\

         FASTQ_SCRUB - N F   P I P E L I N E    
         ===================================
        	v1.2 S.H.Kose. 2025
         ===================================



         
         """
         .stripIndent()

 
/* 
 * Check fastq quality with fastqc
 */


process fastqc {
    publishDir "${params.outdir}", mode: 'copy'
    debug true

    input:
    path reads  
      

    output:
    file "*"
    
    script:
    """
    fastqc ${reads} 
    """
}

process multiqc {
    publishDir "${params.outdir}", mode: 'copy'
    debug true

    input:
    file x

    output:
    file "multiqc_report.html"
	file "multiqc_data"

    script:
    """
    multiqc -f $x
    """
}


workflow {
    Channel.fromPath(params.reads, checkIfExists: true)| fastqc | collect | multiqc
}


