library(igraph)

# read ../data/venice.graphml into venice.graph
venice.graph <- read_graph("data/venice.graphml",format="graphml")
plot(venice.graph)
#
