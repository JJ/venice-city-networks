library(igraph)
library(xml2)
library(dplyr)

venice.graph <- read_graph("code/data/venice.graphml",format="graphml")
venice.graph.xml <- read_xml("code/data/venice.graphml")
edges <- xml_find_all(venice.graph.xml,".//d1:edge")

for (i in 1:length(edges)){
  if ( length(xml_find_all(edges[i],"./d1:data[@key='d1']") ) >= 1 ) {
    E(venice.graph)[i]$bridge <- TRUE
    E(venice.graph)[i]$color <- "red"
  } else {
    E(venice.graph)[i]$bridge <- FALSE
    E(venice.graph)[i]$color <- "gold"
  }
  E(venice.graph)[i]$osmid <- xml_text(xml_find_all(edges[i],"./d1:data[@key='d0']"))
  if ( length( xml_find_all(edges[i],"./d1:data[@key='d2']") ) >= 1 ) {
    E(venice.graph)[i]$place.name <- xml_text(xml_find_all(edges[i],"./d1:data[@key='d2']"))
  } else {
    E(venice.graph)[i]$place.name <- paste0( "OSMID=",E(venice.graph)[i]$osmid)
  }

  E(venice.graph)[i]$highway.type <- xml_text(xml_find_all(edges[i],"./d1:data[@key='d3']"))
  if ( length(xml_find_all(edges[i],"./d1:data[@key='d9']")) >= 1 ) {
    E(venice.graph)[i]$sotoportego <- xml_text(xml_find_all(edges[i],"./d1:data[@key='d9']"))
  } else {
    E(venice.graph)[i]$sotoportego <- FALSE
  }
}

venice.graph.undirected <- as.undirected(venice.graph)

for ( edge in E(venice.graph.undirected) ){
  source <- ends(venice.graph.undirected, edge)[1]
  target <- ends(venice.graph.undirected, edge)[2]

  directed.edge <- get.edge.ids(venice.graph, c(source, target), directed = TRUE)
  E(venice.graph.undirected)[edge]$bridge <- E(venice.graph)[directed.edge]$bridge
  E(venice.graph.undirected)[edge]$color <- E(venice.graph)[directed.edge]$color
  E(venice.graph.undirected)[edge]$place.name <- E(venice.graph)[directed.edge]$place.name
  E(venice.graph.undirected)[edge]$osmid <- E(venice.graph)[directed.edge]$osmid
  E(venice.graph.undirected)[edge]$highway.type <- E(venice.graph)[directed.edge]$highway.type
  E(venice.graph.undirected)[edge]$sotoportego <- E(venice.graph)[directed.edge]$sotoportego
  edge.name <- unlist(E(venice.graph.undirected)[edge]$name)
  if ( length(edge.name)==2 & edge.name[1] == edge.name[2] ) {
    E(venice.graph.undirected)[edge]$name <- edge.name[1]
  }
}

saveRDS(venice.graph.undirected, file="code/data/venice.graph.undirected.rds")
save(venice.graph.undirected, file="code/data/venice.graph.undirected.Rdata")
