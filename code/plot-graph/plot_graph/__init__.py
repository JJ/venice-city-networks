import igraph as ig

def __main__():
    # Load the graph from the graphml file
    graph = ig.Graph.Read_GraphML("../data/venice.graphml")

    # Plot the graph
    ig.plot(graph, target="../data/venice.pdf")

if __name__ == "__main__":
    main()