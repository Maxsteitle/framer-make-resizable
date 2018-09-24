# framer-Make Resizable
    
### Setup

```coffeescript

makeResizable = require "makeResizable"


# makeResizable(layer you want resizable, minWidth, minHeight, headerHeight)
# minWidth(num): Cannot resize smaller than this number
# minHeight(num): Cannot resize smaller than this number
# headerHeight(num): (Optional) Will allow this layer to be draggable if clicked within this area

makeResizable(layer, 400, 200, 80)

```
