library(stringr)
files <- unlist(snakemake@input)

for (i in 1:length(files)) {
    samp <- unlist(strsplit(files[i], "/"))[3]
    sampname <- str_replace(samp,"_counts.txt","")
    df <- read.table(files[i],header = F,stringsAsFactors=F)
    df <- data.frame(df$V2,df$V1)
    colnames(df) <- c("antibody_sequence",sampname)
    if (i==1) {
        final <- df
    } else {
    final <- merge(final, df, by = "antibody_sequence", all = TRUE)
    }
}

final[is.na(final)] <- 0
write.table(final, snakemake@output[[1]], row.names = F, quote = F, sep = "\t")
