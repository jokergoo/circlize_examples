mat = matrix(sample(100, 25), 5)
rownames(mat) = letters[1:5]
colnames(mat) = letters[1:5]

library(circlize)
chordDiagram(mat, directional = TRUE, transparency = 0.5)
