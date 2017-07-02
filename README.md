# HooGraphics
HooGraphics is a Löve2D library intendet to simplify the process of drawing things.
It is a standalone module though it uses a class implementation which comes with the module and will be used locally.
 
## Functionailty
HooGraphics provides a wrapper for every drawable object. 
It is directly integrated into love2D meaning all creation function have been overwritten and using them will provide the wrapper instead.
The usage of all Objects is the same except canvas which needs it's parameters in table form (example further down below).
However. One additional parameter can be supplied that defines the draw data that will be handed over to draw.

Two additional drawables have been added.

## Functions

### love.graphics.draw()
Overwritten function. Can be used as usual or can be supplied with drawable or drawQ without further parameters necessary.

Usage example:

```lua
test = love.graphics.newImage("default.png")
love.graphics.draw(test)
```

### love.graphics.newImage(data, drawData)
data     -> filename or compressed image data

drawData -> table containing additional parameters for drawing or the image.


returns Image Object

Usage example:

```lua
img1 = love.graphics.newImage("default.png")
img2 = love.graphics.newImage("default.png", {x = 100; y = 100}) -- Creates an image that will be rendered at 100 / 100.
img3 = love.grpahics.newImage("default.png", {mipmaps = true}) -- Enables mipmaps (passed through to the original newImage().
img4 = love.grpahics.newImage("default.png", {mipmaps = true; x = 100; y = 100})
```

### love.graphics.newCanvas(drawData, width, height, format, msaa)
(Sorry. I didn't find a good way to wrap this differently)

drawData -> table containing additional parameters for drawing

width    -> The desired canvas width

height   -> The desired canvas height

format   -> [CanvasFormat](https://love2d.org/wiki/CanvasFormat)

msaa     -> The desired number of multisample antialiasing (MSAA) samples used when drawing to the Canvas.


returns Canvas Object

Usage example:
```lua
canvas1 = love.graphics.newCanvas() -- Creates a canvas with screen size and no additional parameters.
canvas2 = love.graphics.newCanvas({x = 100; y = 100}) -- Creates a canvas that will be drawn at 100 / 100.
canvas3 = love.graphics.newCanvas(nil, 100, 100) -- Creates a canvas with the width and height of 100.
canvas4 = love.graphics.newCanvas({x = 100; y = 100}, 100, 100, "hdr", 2) -- Creates a canvas with both parameters, hdr format and MSAAx2 enabled.
```

### love.graphics.newText(font, textstring, drawData)
font -> The [font](https://love2d.org/wiki/Font) to use with this text

textstring -> The string this text should contain

drawData -> table containing additional parameters for drawing


returns Text Object

Usage example:
```lua
font = love.graphics.newFont()
text = love.graphics.newText(font, "Hello World!", {x = 100; y = 100})
```

### love.graphics.newVideo(filenameOrStream, loadaudio, drawData)
filenameOrStream -> The path to the Ogg Theora video file or a video stream object.

loadaudio        -> (bool) Whether to try to load the video's audio into an audio Source. If not explicitly set to true or false, it will try without causing an error if the video has no audio.

drawData         -> table containing additional parameters for drawing


returns Video Object

Usage example:
```lua
video = love.graphics.newVideo("somevideo.ogv", false, {x = 100; y = 100}) 
```

### love.graphics.newParticleSystem(texture, buffer, drawData)
texture  -> A texture (image or canvas) this particle system should use.

buffer   -> The max number of particles at the same time.

drawData -> table containing additional parameters for drawing


returns ParticleSystem Object

Usage example:
```lua
image = love.graphics.newImage("default.png")
particleSystem = love.graphics.newParticleSystem(image, 42, {x = 100; y = 100})
```

### love.graphices.newMesh(data, drawData)
data     -> A table containing parameters for the new Mesh

drawData -> table containing additional parameters for drawing


returns Mesh Object

Usage example:
```lua
-- vertecies are defined outside of this example
mesh1 = love.graphics.newMesh({verticies}, {x = 100; y = 100})
mesh2 = love.graphics.newMesh({verticies, "fan", "dynamic"}, {x = 100; y = 100})
```

### love.graphics.newAnimation(filepath, drawData)
filepath -> Location of the spritesheet

drawData -> table containing additional parameters for drawing


returns Animation Object

```lua
animation = love.graphics.newAnimation("anim.png", {width = 130; height = 150; duration = 2; spriteCount = 27})
love.graphics.draw(animation)
```

## Objects

All Objects contain a name / class type. It's accessible via Object.ObjectType.
```lua
image = love.graphics.newImage("default.png")
image.ObjectType
```

Parents are stored in the `__includes` index (a table).

### Drawable
Drawable is the baseclass of all objects that can be drawn and is the receiver of drawData.

All wrappers are Drawables and have no functionailty besides some minor input verification.

While other Classes can use additional parameters. The draw relevant variables are:

		x 	-> X position on the screen (starting from the left)
		y 	-> Y position on the screen (starting from the top)
		r 	-> Rotation (in radians)
		sx 	-> ScaleX. How much to scale the image on x axis
		sy 	-> ScaleY. How much to scale the image on y axis
		ox 	-> OffsetX. Origin offset on x axis
		oy 	-> OffsetY. Origin offset on y axis
		kx 	-> Shearing factor on x axis
		ky 	-> Shearing factor on y axis
    
Draw data can be modified or set after creating the object by using setDrawData

#### Drawable:setDrawData(drawData)
drawData -> table containing additional parameters for drawing

returns nothing

Usage Example:
```lua
image:setDrawData({x = 200; y = 200, r = 1})
```

Additionally it's possible to bind another variable to a value. This means it will match the bound variable during the drawcall.

#### Drawable:bindValue(variable, table, index)
variable -> (string) The variable that should be kept up to date

table    -> The table containing the variable that should be bound

index    -> The index within the table defining the bound variable


returns true if successful

```lua
player = {x = 100; y = 100}
image = love.graphics.newImage("default.png")
image:bindValue("x", player, "x")
image:bindValue("y", player, "y")
```

For convenience `index` will be set to `varaible` if no index is provided.

```lua
player = {x = 100; y = 100}
image = love.graphics.newImage("default.png")
image:bindValue("x", player) -- Because we want to bind player.x to image.x we can ignore the third argument
image:bindValue("y", player)
```

#### Drawable:unbindValue(variable)
variable -> The index of Drawable that should be unbound (current value will be kept).


returns true if index was removed. False if index didn't exist.

Usage Example:

```lua
player = {x = 100; y = 100}
image = love.graphics.newImage("default.png")
image:bindValue("x", player)
image:bindValue("y", player)
image:unbindValue("x") -- Only y is bound now
```
#### Love2D Objects
The love2D drawable is kept in a variable. However all functions and variables can be accessed as usual.

```lua
image = love.graphics.newImage("default.png")
print(image:getHeight())
```

### Animation
Animation is a simplistic spritesheet animation implementation. Sprites are expected from top left to bottom right with 1 px spacing between sprites.

Animation implements the following additional drawData parameters:

    spriteWidth  -> (number) The width of the individual sprites (single size only)
    spriteHeight -> (number) The height of the individual sprites (single size only)
    spriteCount  -> (number) The amount of sprites within this sprite sheet
    duration     -> How long does it take for the animation to loop? (in seconds)
    paused       -> Set whether or not the animation is paused initially

Ontop of that Animation provides a few additional functions:

When paused the animation will show the last frame continuously until it is played again.

#### Animation:pause()
Pauses the animation.

returns nothing

Usage Example:

```lua
animation:pause()
```

#### Animation:play(restart)
Continues the animation.

restart -> Whether or not to start the animation from the beginning when played


returns nothing

Usage Example:

```lua
animation:setPaused(true)
```



#### Animation:setPaused(paused)
Sets paused state.

paused -> (bool) Whether or not the animation should play.


returns nothing

Usage Example:

```lua
animation:setPaused(true)
```

#### Animation:togglePaused()
Toggles pause state.


returns nothing

UsageExample:

```lua
animation:togglePaused()
```

#### Animation:setProgress(progress)
progress -> (number) The progress through the animation in percent (from 0 - 1)


returns nothing

UsageExample:

```lua
animation:setProgress(0.5)
```

#### Animation:reset()
Resets the animation to the beginning.

returns nothing

UsageExample:
```lua
animation:reset()
```
