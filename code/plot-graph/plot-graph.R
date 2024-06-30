library(igraph)

venice.graph <- as.undirected( read_graph("data/venice.graphml",format="graphml") )

# graph.betw <- betweenness(venice.graph)
E(venice.graph)$width <- round(log(edge_betweenness(venice.graph))/2)
E(venice.graph)[ E(venice.graph)$width == -Inf]$width = 1

plot(venice.graph,vertex.label=NA,vertex.shape="none",edge.color=E(venice.graph)$width)

