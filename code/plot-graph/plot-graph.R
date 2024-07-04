library(igraph)
library(xml2)
library(dplyr)

venice.graph <- as.undirected( read_graph("code/data/venice.graphml",format="graphml") )
venice.graph.xml <- read_xml("code/data/venice.graphml")
edges.original <- xml_find_all(venice.graph.xml,".//d1:edge")

# process edges.original extracting for every one attributes source and target, and aggregating data nodes with key d2 and d3


# Initialize empty vector
edge.lty <- NULL

# assign type 1 if pedestrian, 2 if footway, 3 if ['steps', 'pedestrian'], 4 if ['steps', 'pedestrian', 'footway'] , 5 if service, 6 for anything else
for (i in 1:length(edge.type)){
  if (edge.type[i] == "pedestrian") edge.lty <- c(edge.lty,1)
  else if (edge.type[i] == "footway") edge.lty <- c(edge.lty,2)
  else if (edge.type[i] == "steps") edge.lty <- c(edge.lty,3)
  else if (edge.type[i] == "['steps', 'pedestrian']") edge.lty <- c(edge.lty,4)
  else if (edge.type[i] == "['steps', 'pedestrian', 'footway']") edge.lty <- c(edge.lty,5)
  else if (edge.type[i] == "service") edge.lty <- c(edge.lty,6)
  else edge.lty <- c(edge.lty,7)
}

# graph.betw <- betweenness(venice.graph)
E(venice.graph)$width <- round(log(edge_betweenness(venice.graph))/2)
E(venice.graph)[ E(venice.graph)$width == -Inf]$width = 1
E(venice.graph)$lty <- edge.lty

plot(venice.graph,vertex.label=NA,vertex.shape="none",edge.color=E(venice.graph)$width, edge.lty = E(venice.graph)$lty)

