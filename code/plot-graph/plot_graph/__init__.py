import igraph as ig
import networkx as nx
import time
import matplotlib.pyplot as plt

def __main__():
    # Load the graph from the graphml file
    graph = ig.Graph.Read_GraphML("../data/venice.graphml")

    # Plot the graph
    ig.plot(graph, target="../data/venice.pdf")

def v2():
    # load the graph using networkx
    G = nx.read_graphml("../data/venice.graphml")
    # plot graph and wait for exit
    nx.draw(G)
    # wait 30 seconds to exit
    time.sleep(30)    


if __name__ == "__main__":
    main()