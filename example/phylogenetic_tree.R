library(ape)
data(bird.orders)
hc = as.hclust(bird.orders)
labels = hc$labels
ct = cutree(hc, 6)  # cut tree into 6 pieces
n = length(labels)
hc = as.dendrogram(hc)

library(circlize)
circos.par(cell.padding = c(0, 0, 0, 0))
circos.initialize("a", xlim = c(0, n))
maxy = attr(hc, "height")
circos.trackPlotRegion(ylim = c(0, 1), bg.border = NA, track.height = 0.3, 
    panel.fun = function(x, y) {
        for(i in seq_len(n)) {
            circos.text(i-0.5, 0, labels[i], adj = c(1, 0.5), 
                facing = "reverse.clockwise", niceFacing = TRUE,
                col = ct[labels[i]], cex = 0.7)
        }
})

circos.dendrogram = function(dend, maxy=attr(dend, "height")) {
    labels = as.character(labels(dend))
    x = seq_along(labels) - 0.5
    names(x) = labels
    
    is.leaf = function(object) (is.logical(L <- attr(object, "leaf"))) && L
    
    draw.d = function(dend, maxy) {
        leaf = attr(dend, "leaf")
        d1 = dend[[1]]
        d2 = dend[[2]]
        height = attr(dend, 'height')
        midpoint = attr(dend, 'midpoint')
        
        if(is.leaf(d1)) {
            x1 = x[as.character(attr(d1, "label"))]
        } else {
            x1 = attr(d1, "midpoint") + x[as.character(labels(d1))[1]]
        }
        y1 = attr(d1, "height")
        
        if(is.leaf(d2)) {
            x2 = x[as.character(attr(d2, "label"))]
        } else {
            x2 = attr(d2, "midpoint") + x[as.character(labels(d2))[1]]
        }
        y2 = attr(d2, "height")
        
        circos.lines(c(x1, x1), maxy - c(y1, height), straight = TRUE)
        circos.lines(c(x1, x2), maxy - c(height, height))
        circos.lines(c(x2, x2), maxy - c(y2, height), straight = TRUE)
        
        if(!is.leaf(d1)) {
            draw.d(d1, maxy)
        }
        if(!is.leaf(d2)) {
            draw.d(d2, maxy)
        }
    }
    
    draw.d(dend, maxy)
}

circos.trackPlotRegion(ylim = c(0, maxy), bg.border = NA, 
    track.height = 0.4, panel.fun = function(x, y) {
        circos.dendrogram(hc, maxy)
})

circos.clear()
