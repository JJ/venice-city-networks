library(igraph)
library(osmapiR)
library(ggmap)
library(OpenStreetMap)

venice.graph.undirected <- readRDS("code/data/venice.graph.undirected.rds")

V(venice.graph.undirected)$betweenness <- betweenness(venice.graph.undirected)
V(venice.graph.undirected)$closeness <- closeness(venice.graph.undirected)

venice.city.nodes.df <- data.frame( node = V(venice.graph.undirected)$id,
                                    betweenness = V(venice.graph.undirected)$betweenness,
                                    closeness = V(venice.graph.undirected)$closeness)

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$betweenness),]

top.25.nodes.betweenness <- venice.city.nodes.ranked.df[1:25,]

# loop over these rows and use osm_get_objects to retrieve the node information
top.25.nodes.betweenness.latlon.df <- data.frame(node = top.25.nodes.betweenness$node,
                                                 lat = numeric(nrow(top.25.nodes.betweenness)),
                                                 lon = numeric(nrow(top.25.nodes.betweenness)))
for (i in 1:nrow(top.25.nodes.betweenness.latlon.df)){
  node.info <- osm_get_objects("node",top.25.nodes.betweenness.latlon.df[i,]$node)
  top.25.nodes.betweenness.latlon.df[i,]$lat <- node.info$lat
  top.25.nodes.betweenness.latlon.df[i,]$lon <- node.info$lon
}

# merge top.25.nodes.betweenness with top.25.nodes.betweenness.latlon.df
top.25.nodes.betweenness.with.latlon <- merge(top.25.nodes.betweenness, top.25.nodes.betweenness.latlon.df, by="node")

# min.lat <- min(top.25.nodes.betweenness.with.latlon$lat)
# max.lat <- max(top.25.nodes.betweenness.with.latlon$lat)
#
# min.lon <- min(top.25.nodes.betweenness.with.latlon$lon)
# max.lon <- max(top.25.nodes.betweenness.with.latlon$lon)

min.lat <- 45.42
max.lat <- 45.45

min.lon <- 12.375
max.lon <- 12.3

venice <- OpenStreetMap::openmap( c(max.lat, max.lon),c(min.lat, min.lon),zoom = 15, 'osm')
autoplot( OpenStreetMap::openproj(venice))
venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$closeness),]
