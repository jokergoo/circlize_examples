library(circlize)

circos.initializeWithIdeogram()
bed = generateRandomBed(nr = 100, nc = 4)
col_fun = colorRamp2(c(-1, 0, 1), c("green", "black", "red"))
circos.genomicHeatmap(bed, col = col_fun, side = "inside", border = "white")
circos.clear()
