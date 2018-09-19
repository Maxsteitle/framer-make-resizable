# framer-Make Resizable

### Download with Framer Modules

<a href='https://open.framermodules.com/framer-make-resizable'>
    <img alt='Install with Framer Modules'
    src='https://www.framermodules.com/assets/badge@2x.png' width='160' height='40' /></a>
    
    
### Setup

```coffeescript

makeResizable = require "makeResizable"


# makeResizable(layer you want resizable, minWidth, minHeight, headerHeight)
# minWidth(num): Cannot resize smaller than this number
# minHeight(num): Cannot resize smaller than this number
# headerHeight(num): (Optional) Will allow this layer to be draggable if clicked within this area

makeResizable(layer, 400, 200, 80)

```
