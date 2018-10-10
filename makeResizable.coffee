makeResizable = (layer, minWidth, minHeight, headerHeight) =>

	# Variables
	maxwidth = 200
	panStartPoint = 0
	windowStartPoint = 0
	windowStartPointX = 0
	windowStartWidth = 0
	windowStartHeight = 0
	maxX = 0
	maxY = 0
	margin = 15

	# Detect headerHeight
	layer.on Events.TouchMove, (e) ->
		cursorY = e.y - layer.y
		if headerHeight?
			if cursorY <= headerHeight
				layer.draggable.enabled = true
				layer.draggable.momentum = false
			else
				layer.draggable.enabled = false
		else
			layer.draggable.enabled = true
			layer.draggable.momentum = false
	layer.onDrag ->
		updateEdges()

	layer.on "change:index", ->
		for edge in edges
			edge.index = layer.index


	# Functions
	updateEdges = ->
		top.props =
			x: layer.x + margin/2
			midY: layer.y
			height: margin
			width: layer.width - margin
		brCorner.props =
			midX: layer.width + layer.x
			midY: layer.height + layer.y
		blCorner.props =
			midX: layer.x
			midY: layer.height + layer.y
		tlCorner.props =
			midX: layer.x
			midY: layer.y
		trCorner.props =
			midX: layer.width + layer.x
			midY: layer.y
		bottom.props =
			x: layer.x + margin/2
			midY: layer.y + layer.height
			height: margin
			width: layer.width - margin
		left.props =
			midX: layer.x
			width: margin
			y: layer.y + margin/2
			height: layer.height - margin
		right.props =
			midX: layer.x + layer.width
			width: margin
			y: layer.y + margin/2
			height: layer.height - margin

	updatePoints = (edge) ->
		maxY = layer.maxY - minHeight
		maxX = layer.maxX - minWidth
		windowStartPoint = layer.y
		windowStartHeight = layer.height
		panStartPoint = Canvas.convertPointToScreen(edge)
		windowStartPointX = layer.x
		windowStartWidth = layer.width
		return windowStartWidth
		return windowStartPointX
		return maxY
		return maxX
		return windowStartPoint
		return windowStartHeight
		return panStartPoint

	# Create Edges
	brCorner = new Layer
		name: ".brCorner"
		midX: layer.width + layer.x
		midY: layer.height + layer.y
		size: margin

	blCorner = new Layer
		name: ".blCorner"
		midX: layer.x
		midY: layer.height + layer.y
		size: margin

	tlCorner = new Layer
		name: ".tlCorner"
		midX: layer.x
		midY: layer.y
		size: margin

	trCorner = new Layer
		name: ".trCorner"
		midX: layer.width + layer.x
		midY: layer.y
		size: margin

	top = new Layer
		name: ".top"
		x: layer.x + margin/2
		midY: layer.y
		height: margin
		width: layer.width - margin

	bottom = new Layer
		name: ".bottom"
		x: layer.x + margin/2
		midY: layer.y + layer.height
		height: margin
		width: layer.width - margin

	left = new Layer
		name: ".left"
		midX: layer.x
		width: margin
		y: layer.y + margin/2
		height: layer.height - margin

	right = new Layer
		name: ".right"
		midX: layer.x + layer.width
		width: margin
		y: layer.y + margin/2
		height: layer.height - margin

	edges = [brCorner, blCorner, tlCorner, trCorner, top, bottom, left, right]
	for edge in edges
		edge.draggable.momentum = false
		edge.backgroundColor = null
		edge.onPanEnd ->
			updateEdges()
			document.body.style.cursor = "auto"
		edge.index = layer.index
		edge.onPanStart ->
			@index = layer.index + 1
		edge.onPanEnd ->
			@index = layer.index

	# Edge logic
	top.onMouseMove ->
		if layer.height is minHeight
			@style.cursor = "n-resize"
		else
			@style.cursor = "ns-resize"
	top.onPanStart ->
		updatePoints(top)
	top.onPan ->
		pointInScreen = Canvas.convertPointToScreen(top)
		panOffset = Utils.pointSubtract(panStartPoint, pointInScreen)
		layer.y = Math.min(maxY, windowStartPoint - panOffset.y)
		layer.height = Math.max(windowStartHeight + panOffset.y, minHeight)
		if layer.height is minHeight
			document.body.style.cursor = "n-resize"
		else
			document.body.style.cursor = "ns-resize"

	bottom.onMouseMove ->
		if layer.height is minHeight
			@style.cursor = "s-resize"
		else
			@style.cursor = "ns-resize"
	bottom.onPanStart ->
		updatePoints(bottom)
	bottom.onPan ->
		pointInScreen = Canvas.convertPointToScreen(bottom)
		panOffset = Utils.pointSubtract(panStartPoint, pointInScreen)
		layer.height = Math.max(windowStartHeight - panOffset.y, minHeight)
		if layer.height is minHeight
			document.body.style.cursor = "s-resize"
		else
			document.body.style.cursor = "ns-resize"


	left.onMouseMove ->
		if layer.width is minWidth
			@style.cursor = "w-resize"
		else
			@style.cursor = "ew-resize"
	left.onPanStart ->
		updatePoints(left)
	left.onPan ->
		pointInScreen = Canvas.convertPointToScreen(left)
		panOffset = Utils.pointSubtract(panStartPoint, pointInScreen)
		layer.x = Math.min(maxX, windowStartPointX - panOffset.x)
		layer.width = Math.max(windowStartWidth + panOffset.x, minWidth)
		if layer.width is minWidth
			document.body.style.cursor = "w-resize"
		else
			document.body.style.cursor = "ew-resize"

	right.onMouseMove ->
		if layer.width is minWidth
			@style.cursor = "e-resize"
		else
			@style.cursor = "ew-resize"
	right.onPanStart ->
		updatePoints(right)
	right.onPan ->
		pointInScreen = Canvas.convertPointToScreen(right)
		panOffset = Utils.pointSubtract(panStartPoint, pointInScreen)
		layer.width = Math.max(windowStartWidth - panOffset.x, minWidth)
		if layer.width is minWidth
			document.body.style.cursor = "e-resize"
		else
			document.body.style.cursor = "ew-resize"

	blCorner.onMouseMove ->
		if layer.width is minWidth and layer.height is minHeight
			@style.cursor = "sw-resize"
		else
			@style.cursor = "nesw-resize"
	blCorner.onPanStart ->
		updatePoints(blCorner)
	blCorner.onPan ->
		pointInScreen = Canvas.convertPointToScreen(blCorner)
		panOffset = Utils.pointSubtract(pointInScreen, panStartPoint)
		layer.x = Math.min(maxX, windowStartPointX + panOffset.x)
		layer.width = Math.max(windowStartWidth - panOffset.x, minWidth)
		layer.height =  Math.max(windowStartHeight + panOffset.y, minHeight)
		if layer.width is minWidth and layer.height is minHeight
			document.body.style.cursor = "sw-resize"
		else
			document.body.style.cursor = "nesw-resize"

	tlCorner.onMouseMove ->
		if layer.width is minWidth and layer.height is minHeight
			@style.cursor = "nw-resize"
		else
			@style.cursor = "nwse-resize"
	tlCorner.onPanStart ->
		updatePoints(tlCorner)
	tlCorner.onPan ->
		pointInScreen = Canvas.convertPointToScreen(tlCorner)
		panOffset = Utils.pointSubtract(pointInScreen, panStartPoint)
		layer.x = Math.min(maxX, windowStartPointX + panOffset.x)
		layer.width = Math.max(windowStartWidth - panOffset.x, minWidth)
		layer.height =  Math.max(windowStartHeight - panOffset.y, minHeight)
		layer.y = Math.min(maxY, windowStartPoint + panOffset.y)
		if layer.width is minWidth and layer.height is minHeight
			document.body.style.cursor = "nw-resize"
		else
			document.body.style.cursor = "nwse-resize"

	trCorner.onMouseMove ->
		if layer.width is minWidth and layer.height is minHeight
			@style.cursor = "ne-resize"
		else
			@style.cursor = "nesw-resize"
	trCorner.onPanStart ->
		updatePoints(trCorner)
	trCorner.onPan ->
		pointInScreen = Canvas.convertPointToScreen(trCorner)
		panOffset = Utils.pointSubtract(pointInScreen, panStartPoint)
		layer.width = Math.max(windowStartWidth + panOffset.x, minWidth)
		layer.height =  Math.max(windowStartHeight - panOffset.y, minHeight)
		layer.y = Math.min(maxY, windowStartPoint + panOffset.y)
		if layer.width is minWidth and layer.height is minHeight
			document.body.style.cursor = "ne-resize"
		else
			document.body.style.cursor = "nesw-resize"


	brCorner.onMouseMove ->
		if layer.width is minWidth and layer.height is minHeight
			this.style.cursor = "se-resize"
		else
			this.style.cursor = "nwse-resize"
	brCorner.onPanStart ->
		updatePoints(brCorner)
	brCorner.onPan ->
		pointInScreen = Canvas.convertPointToScreen(brCorner)
		panOffset = Utils.pointSubtract(panStartPoint, pointInScreen)
		layer.width = Math.max(windowStartWidth - panOffset.x, minWidth)
		layer.height =  Math.max(windowStartHeight  - panOffset.y, minHeight)
		if layer.width is minWidth and layer.height is minHeight
			document.body.style.cursor = "se-resize"
		else
			document.body.style.cursor = "nwse-resize"
module.exports = makeResizable
