library(circlize)

circos.initializeWithIdeogram()
bed = generateRandomBed(nr = 150, fun = function(k) sample(letters, k, replace = TRUE))
bed[1, 4] = "aaaaa"
circos.genomicLabels(bed, labels.column = 4, side = "inside")
circos.clear()
