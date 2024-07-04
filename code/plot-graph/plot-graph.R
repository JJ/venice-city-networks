library(igraph)
library(xml2)
library(dplyr)

venice.graph <- as.undirected( read_graph("code/data/venice.graphml",format="graphml") )
venice.graph.xml <- read_xml("code/data/venice.graphml")
edge.type <- xml_text(xml_find_all(venice.graph.xml,".//d1:data[@key='d3']"))

edge.type %>% table

# graph.betw <- betweenness(venice.graph)
E(venice.graph)$width <- round(log(edge_betweenness(venice.graph))/2)
E(venice.graph)[ E(venice.graph)$width == -Inf]$width = 1

plot(venice.graph,vertex.label=NA,vertex.shape="none",edge.color=E(venice.graph)$width)

