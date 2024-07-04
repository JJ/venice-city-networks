import osmnx as ox

# Define the place name or address
place_name = "Venice, Italy"

# Download the street network data for Venice
graph = ox.graph_from_place(place_name, network_type="all")

# Save the graph as a shapefile
ox.save_graph_shapefile(graph, filename="venice_network")

print("Data downloaded successfully!")