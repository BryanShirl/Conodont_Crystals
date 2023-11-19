regression <- function(taxa) {
  output <- c("Taxon", "R-squared", "p-value")
  for (i in 1:length(taxa)) {
    conodont <- Data[Data$Taxa == taxa[i],]
    reg = lm(T.index ~ Area, data = conodont)
    output <- rbind(output, c(taxa[i], round(summary(reg)$adj.r.squared,3), if (overall_p(reg) < 0.005) "< 0.005" else overall_p(reg)))
  }
  return(output)
}