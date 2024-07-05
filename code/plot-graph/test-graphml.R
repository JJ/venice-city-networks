library(igraph)
library(xml2)


venice.graph <- as.undirected( read_graph("code/data/venice.short.graphml",format="graphml") )
venice.graph.xml <- read_xml("code/data/venice.short.graphml")
edges.original <- xml_find_all(venice.graph.xml,".//d1:edge")

print(length(E(venice.graph)$name))
print(length(edges.original))
