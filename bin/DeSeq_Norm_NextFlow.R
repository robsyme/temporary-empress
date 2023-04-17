#!/usr/bin/env Rscript


args = commandArgs(trailingOnly = TRUE)
print(args)

library("readxl")
library("dplyr")
library("BiocParallel")
library("parallel")
library(DESeq2)
# 
# df = read_excel(args[1], sheet = 1)
# dim(df)
getwd()
Normalization_Function_Next = function(Input_File_Name, Method = 'Standard', Subsetting = TRUE, Nsub = 800){

  # Input_File_Name: File name with count matrix and metadata
  # Method: Method to normalize
  # Subsetting: Whether to subset the count matrix into a 1000 genes * 480 samples. For testing purposes
  # Nsub: Number of genes to estimate dispersion curve in 'Norm_Vst_Boots' method





  # Functions
  Filtered_Prevalence = function(Matrix, Prev_perc ){
    # nrow of Matrix: No of features
    # ncol of Matrix: No of samples

    Matrix_prev = as.matrix(Matrix %>% mutate_if(is.numeric, ~1 * (. != 0)))
    Indx = which(rowSums(Matrix_prev) >= ncol(Matrix)*Prev_perc)
    Matrix_Filt = Matrix[Indx,]
    return(Matrix_Filt)

  }

  #Read data
  umiCounts = read_excel(Input_File_Name, sheet='Count_All')
  Metadata = read_excel(Input_File_Name, sheet='Metadata_Exps_All')
  #Reformating and Filtering for prevalence
  genes = umiCounts$gene_id
  umiCounts =as.data.frame(umiCounts[, c(-1)])
  rownames(umiCounts) = genes
  umiCounts = umiCounts %>% mutate_if(is.numeric, round)
  Count_Filt = Filtered_Prevalence(umiCounts, Prev_perc= 0.2 )
  # Subset to a smaller matrix
  if(Subsetting == TRUE){
    set.seed(12)
    print('subsetting matrix for testing')
    Count_Filt = Count_Filt[sample(1:nrow(Count_Filt),1000),]
    Metadata = Metadata %>% filter(Experiment_Id %in% c('EXP_004'))
    Count_Filt = Count_Filt[,colnames(Count_Filt) %in% Metadata$id]

  }
  Metadata = Metadata[match(colnames(Count_Filt), Metadata$id),]
  # Create Coarse condition
  Metadata$CoarseCondition = paste(Metadata$Cell_line, Metadata$drugs, Metadata$stim, Metadata$CmpSet, sep = "_")
  Metadata$CoarseCondition = factor(gsub('-','_',Metadata$CoarseCondition))

  if (Method == 'Standard'){
    print('Running Standard normalization...')
    ##create a DESeq object
    dds <- DESeqDataSetFromMatrix(countData = Count_Filt, colData = Metadata, design = ~ CoarseCondition)
    startTime <- Sys.time()
    deseqObj = DESeq(dds,
                     parallel = TRUE,
                     fitType = "parametric",
                     BPPARAM = SerialParam())
                     #BPPARAM=MulticoreParam(detectCores() - 2))

    NormCounts = getVarianceStabilizedData(deseqObj)
    endTime <- Sys.time()
    print(endTime - startTime)
  }else if(Method == 'Norm_Vst'){
    print("Running Norm_Vst method: No model fit...")
    dds <- DESeqDataSetFromMatrix(countData = Count_Filt, colData = Metadata, design = ~ CoarseCondition)
    startTime <- Sys.time()
    dds <- estimateSizeFactors(dds)
    dds = estimateDispersions(dds)
    NormCounts = getVarianceStabilizedData(dds)
    endTime <- Sys.time()
    print(endTime - startTime)

  }else if(Method == 'Norm_Vst_Boots'){
    print("Running Norm_Vst method with approx vst boots: No model fit...")
    dds <- DESeqDataSetFromMatrix(countData = Count_Filt, colData = Metadata, design = ~ CoarseCondition)
    startTime <- Sys.time()
    dds <- estimateSizeFactors(dds)
    dds = vst(dds, blind = FALSE, nsub = as.numeric(Nsub))
    NormCounts = assay(dds)
    endTime <- Sys.time()
    print(endTime - startTime)

  }

  return(NormCounts)
}


if (args[4]=="Norm_standard") {
  Norm_standard = Normalization_Function_Next(Input_File_Name = args[1], Method = "Standard", Subsetting = args[2], Nsub = args[3] )
  df=as.data.frame(Norm_standard)
  print(paste0("Size of matrix after normalisation: ",dim(df)))
  write.csv(df,"norm_standard.csv")
} else if (args[4]=="Norm_Vst") {
  Norm_Vst = Normalization_Function_Next(Input_File_Name = args[1], Method = "Norm_Vst", Subsetting = args[2], Nsub = args[3] )
  df=as.data.frame(Norm_Vst)
  print(paste0("Size of matrix after normalisation: ",dim(df)))
  write.csv(df,"norm_vst.csv")
} else if (args[4]=="Norm_Vst_Boots") {
  Norm_Vst_Boots = Normalization_Function_Next(Input_File_Name = args[1], Method = "Norm_Vst_Boots", Subsetting = args[2], Nsub = args[3]  )
  df=as.data.frame(Norm_Vst_Boots)
  print(paste0("Size of matrix after normalisation: ",dim(df)))
  write.csv(df,"norm_vst_bootstrap.csv")
} else {
  print("Invalid method selected. There will be no output matrix!")
}

# Norm_standard = Normalization_Function_Next(Input_File_Name = args[1], Method = "Standard", Subsetting = args[2], Nsub = args[3] )
# Norm_Vst = Normalization_Function_Next(Input_File_Name = args[1], Method = "Norm_Vst", Subsetting = args[2], Nsub = args[3] )
# Norm_Vst_Boots = Normalization_Function_Next(Input_File_Name = args[1], Method = "Norm_Vst_Boots", Subsetting = args[2], Nsub = args[3]  )
# 
# df=as.data.frame(Norm_Vst_Boots)
# dim(df)
# write.csv(df,"norm_vst_boots.csv")

# cor.test(Norm_standard , Norm_Vst_Boots ,method="pearson")

print("normalisation test done")
