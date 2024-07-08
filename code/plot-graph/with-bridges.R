library(igraph)
library(xml2)
library(dplyr)

venice.graph <- read_graph("code/data/venice.graphml",format="graphml")
venice.graph.xml <- read_xml("code/data/venice.graphml")
edges <- xml_find_all(venice.graph.xml,".//d1:edge")

edge.lty <- NULL

for (i in 1:length(edges)){
  if ( grepl('\"d1\"', edges[i]) ) {
    E(venice.graph)[i]$bridge <- TRUE
    edge.lty <- c(edge.lty,2)
  } else
    edge.lty <- c(edge.lty,1)
}

E(venice.graph)$edge.lty <- edge.lty

venice.graph.undirected <- as.undirected(venice.graph)

for ( edge in E(venice.graph.undirected) ){
  source <- ends(venice.graph.undirected, edge)[1]
  target <- ends(venice.graph.undirected, edge)[2]

  directed.edge <- get.edge.ids(venice.graph, c(source, target), directed = TRUE)
  E(venice.graph.undirected)[edge]$edge.lty <- E(venice.graph)[directed.edge]$edge.lty
}

# graph.betw <- betweenness(venice.graph)
E(venice.graph.undirected)$width <- round(log(edge_betweenness(venice.graph.undirected))/2)
E(venice.graph.undirected)[ E(venice.graph.undirected)$width == -Inf]$width = 1

plot(venice.graph.undirected,vertex.label=NA,vertex.shape="none",edge.color=E(venice.graph.undirected)$edge.lty, edge.lty = E(venice.graph)$edge.lty)

venice.graph.bridges <- venice.graph.undirected
saveRDS(venice.graph.bridges, file="code/data/venice.graph.bridges.rds")
save(venice.graph.bridges, file="code/data/venice.graph.bridges.Rdata")
