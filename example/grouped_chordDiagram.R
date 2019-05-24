
df = read.table(textConnection("
 brand_from model_from brand_to model_to
      VOLVO        s80      BMW  5series
        BMW    3series      BMW  3series
      VOLVO        s60    VOLVO      s60
      VOLVO        s60    VOLVO      s80
        BMW    3series     AUDI       s4
       AUDI         a4      BMW  3series
       AUDI         a5     AUDI       a5
"), header = TRUE, stringsAsFactors = FALSE)

brand = c(structure(df$brand_from, names=df$model_from), structure(df$brand_to,names= df$model_to))
brand = brand[!duplicated(names(brand))]
brand = brand[order(brand, names(brand))]
brand_color = structure(2:4, names = unique(brand))
model_color = structure(2:8, names = names(brand))

library(circlize)
gap.after = do.call("c", lapply(table(brand), function(i) c(rep(2, i-1), 8)))
circos.par(gap.after = gap.after, cell.padding = c(0, 0, 0, 0))

chordDiagram(df[, c(2, 4)], order = names(brand), grid.col = model_color,
    directional = 1, annotationTrack = "grid", preAllocateTracks = list(
        list(track.height = 0.02))
)

circos.track(track.index = 2, panel.fun = function(x, y) {
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    sector.index = get.cell.meta.data("sector.index")
    circos.text(mean(xlim), mean(ylim), sector.index, col = "white", cex = 0.6, facing = "inside", niceFacing = TRUE)
}, bg.border = NA)

for(b in unique(brand)) {
  model = names(brand[brand == b])
  highlight.sector(sector.index = model, track.index = 1, col = brand_color[b], 
    text = b, text.vjust = -1, niceFacing = TRUE)
}

circos.clear()
