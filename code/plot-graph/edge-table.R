library(igraph)
venice.graph <- readRDS("code/data/venice.graph.bridges.rds")

edge.betweenness.table <- data.frame(
  edge = sapply(E(venice.graph)$name, function(names) names[1]),
  betweenness = edge_betweenness(venice.graph)
  )

head(edge.betweenness.table[order(-edge.betweenness.table$betweenness),], n=10)
