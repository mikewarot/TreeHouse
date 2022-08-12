# TreeHouse 
  Notes in a structure similar to ARC42

1. ## Introduction and Goals

  TreeHouse is a program that explores the relationships between an abstract syntax tree and source code.     The quality goals are simple:
  
  - Minumum viable product -- This prototype just needs to be good enough to convey the concepts demostrated to an audience
  - Not too crashy -- This prototype should work at least 90% of the time in front of an audience without frustrating everyone too much that the demo stops
  - Visible connectivity -- It should clearly show that editing one part of a tree or its source makes applicable changes and context switches in the other

  The stakeholders:
  - Mike Warot -- primary author, who has an idea to explore
  - Everyone else -- an audience the author hopes to reach with ideas about direct manipulation of syntax trees, annotation of source code, and other concepts otherwise hard to demonstrate

2. ## Constraints

  Treehouse has the following constraints
  - No budget -- there is a budget of 0 BTC, $0.00 for this project
  - Author limitations -- Mike has various other health issues
  - Bus Number of ZERO -- Mike is the ONLY author of this project

3. Scope and Context

  Business
  - Treehouse is not part of any business plan, or corporation. It sits firmly in the space of open software projects that are just starting out.
  Technical
  - Treehouse is a self contained Win32 GUI application designed for use by a single user. It makes very minimal use of disk and other resources.
  - Treehouse is not intended to be anything more than an exploration of concepts, and a prototype

4. Solution Strategy
  Treehouse leans heavily upon the visual tools provided through the Win32 Common controls and the Lazarus interface to same. All the GUI elements are provided for the program with minimal practical overhead.

5. Building Blocks
  Treehouse has two main elements at this time, as shown in the main screenshot. 
  - A tree view, containing the "abstract syntax tree"
  - A memo view, containing the "source code" generated from the currently selected node of the abstract syntax tree.

6. Runtime
  Treehouse has two mutually modifying views
  - The tree view, which generates source code and stuffs it into the Memo view when a new node is selected by the user. This is done in TreeView1Change
  - The memo view, which selects the appropriate node upon selection by the user. This is done in Memo1Click

7. Deployment
  Treehouse is a Lazarus GUI application, developed in a Windows enviroment, cross-platform use has not been tested.
    Clone the repository to a local drive, open treehouse.lpi -- the main project file
    Compile and run treehouse.exe

8. Cross Cutting Concepts
  Treehouse shows the same data in multiple views. Thus any modification to the structure stored in the tree will effect that in the memo view.

9. Architecture Decisions
  August 2022 - Use Lazarus GUI because it offers a way to get a GUI up and running with minimal effort

10. Quality Requirements
  - The GUI shall load or save a tree in less than 1 second on a machine with an SSD disk.
  - The GUI shall respond and complete any action in less than 1 second

11. Risks and Technical Debt
  - Risk - Treehouse is dependent on Lazarus, and the Windows 32 Common Controls
  - Debt - The mapping of nodes to memo items is done in an array of fixed size, it's an ugly kludge, but it does work.
  - Debt - Code is mixed with gui elements, and needs to be separated
  - Debt - String constants are directly stored in the tree file, and leading spaces and special characters cause *undefined* behaviour.

12. Glossary
  - AST - Abstract Syntax Tree, a data structure that contains all the defining characteristics of a program, once removed from the constraints of the source code, including comments, variable names, etc.
  
So, there is is... documentation in ARC42 format (abridged)

