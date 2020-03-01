# 3D Printable Raspberry Pi Cases

This is a collection of printable Raspberry Pi cases. 

## Board Specification Files *(\*-info.scad)*

This case design is generalized using a specification file for each board which contains coordinate and size information for all components that need case holes for access. 

Spec files also include modules for the raspberry pi imprint, including an abbreviated name, to be printed in the top of the case. 

Finally, board spec files include a module for defining case pegs, which are currently designed to be printed on the outside of the case and help with case-half alignment and a minimal press-fit closure.


## General Case Layout File *(pi-case.scad)*

The generalized case layout is handled by `pi-case.scad`, which also functions as the main interface for rendering STL files using OpenSCAD.

Boards are selected by un-commenting the appropriate `*-info.scad` file in the list of `include <FOO>` statements near the top of the file.

At the bottom of the file you can control which module(s) actually get rendered. If you only need to print a case top, you have that option.


## Library Files

The remainder of the `*.scad` files here are libraries that provide default dimensions of things like walls, or index keys that are used to access component dimensions or coordinates. There is also a `fillets.scad` file, which is a library I've written to hide the ugly details of rendering cubes with various kinds of filleted edges.


## Extending

If you'd like to implement a new board specification file, I'd recommend copying the `pi3B+-info.scad` file and adjusting component locations and sizes there. It's the most modern board I've modeled so far, and components are likely to be most closely matched for any newer boards (such as the Pi 4).

If you'd like to change the logo / imprint on the top of the case, you can copy / create your own board-info scad file, and modify the `imprint()` module. I've included `raspberry.dxf` and `raspberry.png` to make it easier to produce variants of the official logo.

If you'd like to create a new grille pattern on the lower case half, you can create a variant module inside `pi-case.scad` based on `lower_case_with_vents()`, substituting your own custom patterning shape to subtract from the lower case wall.

To change the top case half substantially, you'll have to reimplement `top_cuts()` in `pi-case.scad`, unless you can achieve what you want by hacking the `imprint()` module in the board-info file. Unfortunately, I have not optimized the file for this, and it would be a bit more intensive than changing the lower case pattern.


## Existing STL Files

These STL files are all derived from the OpenSCAD models. To be safest, you might want to regenerate these on your own. I'll try to keep them up to date, but I consider them derivative, temporary files that I just use to bridge the gap from model to Cura-rendered gcode. 
