library(igraph)

venice.graph.undirected <- readRDS("code/data/venice.graph.undirected.rds")

V(venice.graph.undirected)$betweenness <- betweenness(venice.graph.undirected)
V(venice.graph.undirected)$closeness <- closeness(venice.graph.undirected)

venice.city.nodes.df <- data.frame( node = V(venice.graph.undirected)$id,
                                    betweenness = V(venice.graph.undirected)$betweenness,
                                    closeness = V(venice.graph.undirected)$closeness)

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$betweenness),]

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$closeness),]
