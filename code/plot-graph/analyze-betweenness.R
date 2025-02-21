library(igraph)
library(osmapiR)
library(ggmap)
library(OpenStreetMap)
library(dupNodes)

venice.graph.undirected <- readRDS("code/data/venice.graph.undirected.rds")

V(venice.graph.undirected)$betweenness <- betweenness(venice.graph.undirected)
V(venice.graph.undirected)$closeness <- closeness(venice.graph.undirected)
V(venice.graph.undirected)$eigen <- unname(eigen_centrality(venice.graph.undirected)$vector)
V(venice.graph.undirected)$name <- V(venice.graph.undirected)$id # Needed for DNSLbetweenness
V(venice.graph.undirected)$DNSLbetweenness <- DNSLbetweenness_for_graph(venice.graph.undirected)


venice.city.nodes.df <- data.frame( node = V(venice.graph.undirected)$id,
                                    betweenness = V(venice.graph.undirected)$betweenness,
                                    closeness = V(venice.graph.undirected)$closeness,
                                    eigen = V(venice.graph.undirected)$eigen,
                                    DNSLbetweenness = V(venice.graph.undirected)$DNSLbetweenness)

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$betweenness),]

top.25.nodes.betweenness <- venice.city.nodes.ranked.df[1:25,]

# loop over these rows and use osm_get_objects to retrieve the node information
top.25.nodes.betweenness.latlon.df <- data.frame(node = top.25.nodes.betweenness$node,
                                                 lat = numeric(nrow(top.25.nodes.betweenness)),
                                                 lon = numeric(nrow(top.25.nodes.betweenness)))
for (i in 1:nrow(top.25.nodes.betweenness.latlon.df)){
  node.info <- osm_get_objects("node",top.25.nodes.betweenness.latlon.df[i,]$node)
  top.25.nodes.betweenness.latlon.df[i,]$lat <- as.numeric(node.info$lat)
  top.25.nodes.betweenness.latlon.df[i,]$lon <- as.numeric(node.info$lon)
}

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
basemap <- autoplot( OpenStreetMap::openproj(venice))

betweenness.map <- basemap + geom_point(data=top.25.nodes.betweenness.with.latlon, aes(x=lon, y=lat), color="red", size=3)

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$closeness),]

top.25.nodes.closeness <- venice.city.nodes.ranked.df[1:25,]

# loop over these rows and use osm_get_objects to retrieve the node information
top.25.nodes.closeness.latlon.df <- data.frame(node = top.25.nodes.closeness$node,
                                                 lat = numeric(nrow(top.25.nodes.closeness)),
                                                 lon = numeric(nrow(top.25.nodes.closeness)))
for (i in 1:nrow(top.25.nodes.closeness.latlon.df)){
  node.info <- osm_get_objects("node",top.25.nodes.closeness.latlon.df[i,]$node)
  top.25.nodes.closeness.latlon.df[i,]$lat <- as.numeric(node.info$lat)
  top.25.nodes.closeness.latlon.df[i,]$lon <- as.numeric(node.info$lon)
}

top.25.nodes.closeness.with.latlon <- merge(top.25.nodes.closeness, top.25.nodes.closeness.latlon.df, by="node")

closeness.map <- betweenness.map + geom_point(data=top.25.nodes.closeness.with.latlon, aes(x=lon, y=lat), color="blue", size=3)

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$eigen),]
top.25.nodes.eigen <- venice.city.nodes.ranked.df[1:25,]
top.25.nodes.eigen.latlon.df <- data.frame(node = top.25.nodes.eigen$node,
                                           lat = numeric(nrow(top.25.nodes.eigen)),
                                           lon = numeric(nrow(top.25.nodes.eigen)))
for (i in 1:nrow(top.25.nodes.eigen.latlon.df)){
  node.info <- osm_get_objects("node",top.25.nodes.eigen.latlon.df[i,]$node)
  top.25.nodes.eigen.latlon.df[i,]$lat <- as.numeric(node.info$lat)
  top.25.nodes.eigen.latlon.df[i,]$lon <- as.numeric(node.info$lon)
}

top.25.nodes.eigen.with.latlon <- merge(top.25.nodes.eigen, top.25.nodes.eigen.latlon.df, by="node")
eigen.map <- basemap + geom_point(data=top.25.nodes.eigen.with.latlon, aes(x=lon, y=lat), color="green", size=3)


venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$DNSLbetweenness),]
top.25.nodes.DNSLbetweenness <- venice.city.nodes.ranked.df[1:25,]
top.25.nodes.DNSLbetweenness.latlon.df <- data.frame(node = top.25.nodes.DNSLbetweenness$node,
                                                     lat = numeric(nrow(top.25.nodes.DNSLbetweenness)),
                                                     lon = numeric(nrow(top.25.nodes.DNSLbetweenness)))
for (i in 1:nrow(top.25.nodes.DNSLbetweenness.latlon.df)){
  node.info <- osm_get_objects("node",top.25.nodes.DNSLbetweenness.latlon.df[i,]$node)
  top.25.nodes.DNSLbetweenness.latlon.df[i,]$lat <- as.numeric(node.info$lat)
  top.25.nodes.DNSLbetweenness.latlon.df[i,]$lon <- as.numeric(node.info$lon)
}

top.25.nodes.DNSLbetweenness.with.latlon <- merge(top.25.nodes.DNSLbetweenness, top.25.nodes.DNSLbetweenness.latlon.df, by="node")

DNSLbetweenness.map <- basemap + geom_point(data=top.25.nodes.DNSLbetweenness.with.latlon, aes(x=lon, y=lat), color="purple", size=3)
