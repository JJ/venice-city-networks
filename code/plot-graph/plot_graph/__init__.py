import igraph as ig

def main():
    # Load the graph from the graphml file
    graph = ig.Graph.Read_GraphML("../data/venice.graphml")

    # Plot the graph
    ig.plot(graph)

if __name__ == "__main__":
    main()