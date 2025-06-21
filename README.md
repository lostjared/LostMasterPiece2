# LostMasterPiece2

![Screenshot 2025-06-21 010930](https://github.com/user-attachments/assets/32f4d5b5-1b04-4377-bfa0-14e864667d85)

![Screenshot 2025-06-21 010948](https://github.com/user-attachments/assets/80b7d6f0-4502-4f7f-b90f-c369bd60df44)

![Screenshot 2025-06-21 011000](https://github.com/user-attachments/assets/2176dc56-470b-40e4-88c9-b45f542eae85)

A 3D puzzle game inspired by Tetris with dynamic visual effects and shader-based backgrounds.

## Overview

LostMasterPiece2 is a modern take on the classic block-falling puzzle game, featuring:
- **3D rendered game pieces** with realistic lighting and textures
- **Dynamic shader backgrounds** that change with user interaction
- **Cross-platform support** (Desktop, Web via Emscripten, Android)
- **Touch and keyboard controls** for versatile gameplay

## Game Concept

### Core Gameplay
The game follows traditional Tetris mechanics with a 3D twist:
- Colored blocks fall from the top of a 3D grid
- Players must arrange falling pieces to create complete rows
- Completed rows are cleared, earning points
- Game speed increases with level progression
- Game ends when blocks reach the top

### 3D Features
- **Rotatable camera**: Use WASD keys to rotate the view around the game grid
- **Zoom control**: Use +/- keys to zoom in and out
- **3D block rendering**: All game pieces are rendered as textured 3D cubes with lighting

## Shader System

One of the unique features of LostMasterPiece2 is its **dynamic shader background system**:

### How It Works
- The game loads fragment shaders from the `data/gfx/` directory
- Shaders are listed in `data/gfx/index.txt` (one filename per line)
- **Every keypress or touch interaction randomly selects a new shader** for the background
- Over 300+ different visual effects are included

### Shader Effects Include
- Kaleidoscopic patterns
- Rainbow spirals and gradients  
- Geometric distortions
- Glitch effects
- Plasma and wave animations
- Mirror and crystal effects
- Psychedelic color transforms

### Adding Custom Shaders
1. Place your `.glsl` fragment shader file in `data/gfx/`
2. Add the filename to `data/gfx/index.txt`
3. Shaders must be compatible with the uniform inputs:
   - `sampler2D textTexture` - background texture
   - `float time_f` - elapsed time in seconds
   - `vec2 iResolution` - screen resolution
   - `float alpha` - fade alpha value

## Controls

### Keyboard
- **Arrow Keys**: Move piece left/right/down
- **Up Arrow**: Shift piece colors
- **Space**: Rotate piece direction
- **Enter**: Drop piece instantly
- **WASD**: Rotate 3D camera view
- **+/-**: Zoom in/out
- **Z/X**: Rotate around Z-axis

### Touch/Mouse
- **Tap/Click**: Randomly change background shader
- **Swipe Up**: Shift piece colors  
- **Swipe Down**: Change piece direction
- **Swipe Left/Right**: Move piece horizontally
- **Double-tap**: Drop piece instantly
- **Two-finger touch**: Drop piece instantly

## Building the Project

### Prerequisites
- C++20 compatible compiler
- SDL2, SDL2_TTF, libmx2 libraries
- OpenGL 3.3+ / OpenGL ES 3.0+
- GLM (OpenGL Mathematics library)
- libpng, zlib

### Desktop (Linux/Windows/macOS)
```bash
mkdir build && cd build
cmake ..
make
```
