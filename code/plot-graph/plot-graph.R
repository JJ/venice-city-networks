library(igraph)
library(xml2)
library(dplyr)

venice.graph <- read_graph("code/data/venice.graphml",format="graphml")
venice.graph.xml <- read_xml("code/data/venice.graphml")
edge.type <- xml_text(xml_find_all(venice.graph.xml,".//d1:data[@key='d3']"))
E(venice.graph)$type <- edge.type
bridge <- xml_text(xml_find_all(venice.graph.xml,".//d1:data[@key='d1']"))

edge.lty <- NULL

for (i in 1:length(edge.type)){
  if (grepl("steps",edge.type[i]) == TRUE ) edge.lty <- c(edge.lty,2)
  else if ( grepl("pedestrian",edge.type[i]) == TRUE ) edge.lty <- c(edge.lty,1)
  else if ( grepl("footway",edge.type[i]) == TRUE ) edge.lty <- c(edge.lty,3)
  else if ( grepl("service",edge.type[i]) == TRUE ) edge.lty <- c(edge.lty,4)
  else if ( grepl("unclassified",edge.type[i]) == TRUE ) edge.lty <- c(edge.lty,5)
  else if ( grepl("primary",edge.type[i]) == TRUE ) edge.lty <- c(edge.lty,6)
  else edge.lty <- c(edge.lty,7)
}

E(venice.graph)$edge.lty <- edge.lty

venice.graph.undirected <- as.undirected(venice.graph)

for ( edge in E(venice.graph.undirected) ){
  source <- ends(venice.graph.undirected, edge)[1]
  target <- ends(venice.graph.undirected, edge)[2]

  # select edge in venice.graph with source source and target target
  directed.edge <- get.edge.ids(venice.graph, c(source, target), directed = TRUE)
  E(venice.graph.undirected)[edge]$edge.lty <- E(venice.graph)[directed.edge]$edge.lty
}

# E(venice.graph.undirected)$width <- round(log(edge_betweenness(venice.graph.undirected))/2)
E(venice.graph.undirected)[ E(venice.graph.undirected)$width == -Inf]$width = 1

plot(venice.graph.undirected,vertex.label=NA,vertex.shape="none",edge.color=E(venice.graph.undirected)$width, edge.lty = E(venice.graph.undirected)$edge.lty)

saveRDS(venice.graph.undirected, file="code/data/venice.graph.undirected.rds")
save(venice.graph.undirected, file="code/data/venice.graph.undirected.Rdata")
