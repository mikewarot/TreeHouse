TreeHouse - A structure build in a tree, for habitation

Based on ideas seen at https://media.handmade-seattle.com/dion-systems/

Also based on ideas I've had forever... but couldn't get passed the UI issues on

  https://wiki.c2.com/?BidirectionalCompiler
  https://wiki.c2.com/?RichSource

Basically, a tree is maintained internally that IS the abstract syntax tree that source code gets compiled to, and source code gets generated as a view from this tree.

At this point, the tree on the left is fixed, and the right side is generated dynamically as you select nodes. If you select text on the right side, in now marks the appropriate node on the left.

![Screen Shot 1](screenshots/v001_main.png?raw=true "TreeHouse - Main Screen")

Documentation in ARC42 format is in treehouse.txt


