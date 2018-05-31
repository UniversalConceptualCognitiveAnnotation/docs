XML format
----------

The xml format allows easy extension with further layers. The top level of each xml is composed of 
the layers annotated over the passage. Each layer has a unique ID and a set of nodes that it introduces. 
Each node specifies its outbound edges. The ID of a node is formatted as 
`<layer ID>.<node ID within the layer>`. 

Layer 0 is a special layer which specifies the tokens of the passage and their linear order. Its nodes 
are therefore the tokens themselves. Each node may either be of type `Word` or of type `Punctuation`. 
The attribute `paragraph` specifies the number of the paragraph the terminal belongs to, while 
`paragraph_position` specifies the position of the terminal inside that paragraph. The attribute 
`text` specifies the written form of the terminal.

Layer 1 is the foundational layer of UCCA. Although non-terminal nodes of UCCA are generally untyped 
(their type is effectively determined by their inbound and outbound edges), the xml format does separate 
the nodes into three coarse-grained types: 
1. `FN` (regular node)
2. `PNCT` (a node whose only descendant is a punctuation terminal)
3. `LKG` (a linkage node). 
We note that the node type does not provide any additional information, as it can be deterministically 
derived from the identity of its edges. It is therefore only used for easier readability.

Each node specifies its outbound edges through its `edge` elements. The ID of the node to which the edge is
directed is specified by the attribute `toID`. The type of the edge may be either of the following:
1. any of the 13 categories of the foundational layer (abbreviated as `A,P,S,D,C,E,N,R,T,H,L,F,G`; see paper).
2. `LR` (Link Relation) or `LA` (Link Argument) for edges between a linkage node and its Linker or Parallel 
Scenes, respectively.
3. `Terminal` for an edge to a terminal.
4. `U` for an edge to a punctuation pre-terminal.

A node in layer 1 may also be a leaf that represents an implicit unit. In this case, the node would have 
an attribute `implicit` with the value `true`.

Layer 2 is left empty as a place holder where future layers (e.g., coreference, linkage type, 
information structure) can be represented. UCCA is designed to allow an open-ended set of layers 
to be annotated on top of a given passage.


Toy example
-----------

The file toy.xml contains the annotation of a simple sentence `After Graduation, Mary moved to New York 
City`. The terminals can be seen under the element `<layer layerID="0">`.

Consider now the nodes of the foundational layer (those under the element `<layer layerID="1">`).

Consider the node whose ID is `1.1`. It has 5 children, one is a Linker (and therefore the edge leading 
to it bears the type `L`), two are Parallel Scenes (the edge leading to them bear the type `H`), 
2 are punctuation marks (the edges leading to them bear the type `U`). 

Note that edges leading to terminals (i.e., to nodes in layer0) bear the type `Terminal`. 

Consider node `1.13`. This node is of type `LKG`, which means it represents a linkage relation. 
It has three children, a Linker (i.e., the linkage relation; the edge has the tag `LR`), and 
two linkage arguments (bear the type `LA`).
