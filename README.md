# Grid Movement

## Getting Started

### Requirement
Godot Engine v3.x

### Installation
After downloading, open Godot Engine Project Manager. Click Import, go to the folder you've downloaded, and select "project.godot".

## Usage
The scene contains a player (green) and an obstacle (orange). The player can move in any direction, using arrow keys. The obstacle blocks the player's way.

~~The main TileMap (with MainMap.gd attached) can have its cell size adjusted such that the grid step for snapping will also be automatically update.~~Due to an oversight, not only it doesn't work, it also doesn't run due to the following output:
```
Parser Error: The identifier "CanvasItemEditor" isn't declared in the current scope.
```
For now, I've commented out the part of the script that supposed to resize the grid step, and in the meantime, I'll find the solution.

## Author
* mechPenSketch

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgements
* GDquest for tutorials
* I remember a youtube video that gave me the idea of using the Tween Node, but I can't find it.
