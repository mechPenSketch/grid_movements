# Grid Movement

## Getting Started

### Requirement
Godot Engine v3.x

### Installing as a Project
After downloading, open Godot Engine Project Manager. Click Import, go to the folder you've downloaded, and select "project.godot".

### Installing as a Plugin
After downloading, copy the folder"addons/snap_map" to your project file. On your project, go to Project > Project Settings > Plugins (tab) and check "Snap Map"

## Usage

### Example
The scene contains a player (green) and an obstacle (orange). The player can move in any direction, using arrow keys. The obstacle blocks the player's way.

### Plugin
There are additional nodes unique to this plugin:
* SnapboundTiles (extended from TileMap) - its cell size can be adjusted such that the grid step for snapping will also be automatically updated.
* ColShapePiece (extended from CollisionShape2D) - its shape size can be adjusted automatically based on changes to grid step.
* RayCastPiece (extended from Raycast2D) - where it can cast to depends on its direction (Vector2) in proportion to grid step.

## Author
* mechPenSketch

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgements
* GDquest for tutorials
* I remember a youtube video that gave me the idea of using the Tween Node, but I can't find it.
