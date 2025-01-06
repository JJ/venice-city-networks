import osmnx as ox

def __main__():

    # Define the place name
    place_name = "Venezia-Murano-Burano, Veneto, Italy"

    # Download the street network data for Venice
    graph = ox.graph_from_place(place_name, network_type="walk", simplify=True)
    ox.save_graphml(graph, filepath="../data/venice.graphml",gephi=True)

    print("Data downloaded successfully!")
    ox.plot_graph(graph)
