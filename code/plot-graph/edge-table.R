library(igraph)
venice.graph <- readRDS("code/data/venice.graph.bridges.rds")

edge.betweenness.table <- data.frame(
  edge = sapply(E(venice.graph)$name, function(names) names[1]),
  betweenness = edge_betweenness(venice.graph),
  bridge = E(venice.graph)$bridge
  )

head(edge.betweenness.table[order(-edge.betweenness.table$betweenness),], n=10)

rialto.area <- edge.betweenness.table[grepl("Rialto", edge.betweenness.table$edge),]
head(rialto.area[order(-rialto.area$betweenness),], n=10)

print("Average betweenness of bridges")
mean(edge.betweenness.table[edge.betweenness.table$bridge==TRUE,]$betweenness)
print("Average betweenness of non-bridges")
mean(edge.betweenness.table[edge.betweenness.table$bridge!=TRUE,]$betweenness)
