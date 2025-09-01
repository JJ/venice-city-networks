library(igraph)
library(osmapiR)
library(ggmap)
library(OpenStreetMap)

venice.graph.undirected <- readRDS("../code/data/venice.graph.undirected.rds")

V(venice.graph.undirected)$betweenness <- betweenness(venice.graph.undirected)
V(venice.graph.undirected)$closeness <- closeness(venice.graph.undirected)
V(venice.graph.undirected)$eigen <- unname(eigen_centrality(venice.graph.undirected)$vector)

venice.city.nodes.df <- data.frame( node = V(venice.graph.undirected)$id,
                                    betweenness = V(venice.graph.undirected)$betweenness,
                                    closeness = V(venice.graph.undirected)$closeness,
                                    eigen = V(venice.graph.undirected)$eigen)

venice.city.nodes.ranked.df <- venice.city.nodes.df[order(-venice.city.nodes.df$betweenness),]

top.25.nodes.betweenness <- venice.city.nodes.ranked.df[1:25,]

top.25.nodes.betweenness.latlon.df <- data.frame(node = top.25.nodes.betweenness$node,
                                                 lat = numeric(nrow(top.25.nodes.betweenness)),
                                                 lon = numeric(nrow(top.25.nodes.betweenness)))
for (i in 1:nrow(top.25.nodes.betweenness.latlon.df)){
  node.info <- osm_get_objects("node",top.25.nodes.betweenness.latlon.df[i,]$node)
  top.25.nodes.betweenness.latlon.df[i,]$lat <- as.numeric(node.info$lat)
  top.25.nodes.betweenness.latlon.df[i,]$lon <- as.numeric(node.info$lon)
}

top.25.nodes.betweenness.with.latlon <- merge(top.25.nodes.betweenness, top.25.nodes.betweenness.latlon.df, by="node")

number.of.nodes <- length(V(venice.graph.undirected)$id)
number.of.edges <- length(E(venice.graph.undirected)$name)

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


## ----ccs.node.figure, echo=F, message=F, fig.pos="h!t", fig.align='center', out.width=c("90%","50%"), fig.show="hold", fig.cap="Top 25 nodes by betweenness centrality (top) and closeness centrality (bottom) in Venice"----
min.lat <- 45.42
max.lat <- 45.45

min.lon <- 12.375
max.lon <- 12.3

venice <- OpenStreetMap::openmap( c(max.lat, max.lon),c(min.lat, min.lon),zoom = 15, 'osm')
basemap <- autoplot( OpenStreetMap::openproj(venice))

betweenness.map <- basemap + geom_point(data=top.25.nodes.betweenness.with.latlon, aes(x=lon, y=lat), color="red", size=2)

ggsave("ccs-2025-venice-top-betweenness.png", plot = betweenness.map, width = 8, height = 6, dpi = 300)

min.lat <- 45.436
max.lat <- 45.439

min.lon <- 12.335
max.lon <- 12.339

venice.top.closeness <- OpenStreetMap::openmap( c(max.lat, max.lon),c(min.lat, min.lon),zoom = 18, 'osm')
top.closeness.basemap <- autoplot( OpenStreetMap::openproj(venice.top.closeness))+ geom_point(data=top.25.nodes.closeness.with.latlon, aes(x=lon, y=lat), color="blue", size=3)

ggsave("ccs-2025-venice-top-closeness.png", plot = top.closeness.basemap, width = 8, height = 6, dpi = 300)


