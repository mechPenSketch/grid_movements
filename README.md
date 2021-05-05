# Grid Movement

## Getting Started

### Requirement
Godot Engine v3.x

### Installing as a Project
After downloading, open Godot Engine Project Manager. Click Import, go to the folder you've downloaded, and select "project.godot".

### Installing as a Plugin
After downloading, copy the folder "addons/snap_map" to your project file. On your project, go to Project > Project Settings > Plugins (tab) and check "Snap Map"

## Usage

### Example
The scene contains a player (green) and 2 obstacles (orange and purple). The player can move in any direction, using arrow keys. The obstacle blocks the player's way.

### Plugin
There are additional nodes unique to this plugin:
* SnapboundTiles (extended from TileMap) - its cell size can be adjusted such that the grid step for snapping will also be automatically updated.
* PlayingPiece (extended from Area2D) - a playing piece to be moved around a map of tiles.
* ColShapePiece (extended from CollisionShape2D) - its shape size can be adjusted automatically based on changes to grid step.
  * ColShapePieceEx (extended from ColShapePiece) - use this to cover more than one tiles.
* RayCastPiece (extended from Raycast2D) - where it can cast to depends on its direction (Vector2) in proportion to grid step.

If a PlayingPiece has a TileMap as its parent, its grid position can be viewed. To find the grid position, go to the Scene Dock, and on the Scene Tree, mouse over the PlayingPiece.

## Author
* mechPenSketch

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgements
* GDquest for tutorials
* I remember a youtube video that gave me the idea of using the Tween Node, but I can't find it.
