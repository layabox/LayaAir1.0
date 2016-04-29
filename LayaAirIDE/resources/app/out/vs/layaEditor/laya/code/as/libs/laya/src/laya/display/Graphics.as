package laya.display {
	import laya.display.css.Font;
	import laya.events.Event;
	import laya.maths.Bezier;
	import laya.maths.GrahamScan;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.utils.Color;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	/**
	 * <code>Graphics</code> 类用于创建绘图显示对象。
	 * @see laya.display.Sprite#graphics
	 */
	public class Graphics {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _tempMatrix:Matrix = new Matrix();
		/**@private */
		public var _sp:Sprite;
		/**@private */
		public var _one:Array = null;
		/**@private */
		public var _render:Function = _renderEmpty;
		/**@private */
		private var _cmds:Array = null;
		/**@private */
		private var _temp:Array;
		/**@private */
		private var _bounds:Rectangle;
		/**@private */
		private var _rstBoundPoints:Array;
		
		/**
		 *  创建一个新的 <code>Graphics</code> 类实例。
		 */
		public function Graphics() {
			_render = _renderEmpty;
		}
		
		/**
		 * <p>销毁此对象。</p>
		 */
		public function destroy():void {
			clear();
			_temp = null;
			_bounds = null;
			_rstBoundPoints = null;
			_sp && (_sp._renderType = 0);
			_sp = null;
		}
		
		/**
		 * <p>清理此对象。</p>
		 */
		public function clear():void {
			_one = null;
			_render = _renderEmpty;
			_cmds = null;
			_temp && (_temp.length = 0);
			_sp && (_sp._renderType &= ~RenderSprite.IMAGE);
			_sp && (_sp._renderType &= ~RenderSprite.GRAPHICS);
			_repaint();
		}
		
		/**
		 * 返回命令是否为空。
		 */
		public function empty():Boolean {
			return _one === null && (!_cmds || _cmds.length === 0);
		}
		
		/**
		 * @private
		 * 重绘此对象。
		 */
		public function _repaint():void {
			_temp && (_temp.length = 0);
			_sp && _sp.repaint();
		}
		
		/**@private  */
		public function _isOnlyOne():Boolean {
			return !_cmds || _cmds.length === 0;
		}
		
		/**
		 * @private
		 * 命令流。
		 */
		public function get cmds():Array {
			return _cmds;
		}
		
		/** @private */
		public function set cmds(value:Array):void {
			_sp && (_sp._renderType |= RenderSprite.GRAPHICS);
			_cmds = value;
			_render = _renderAll;
			_repaint();
		}
		
		/**
		 * 获取位置及宽高信息矩阵(比较耗，尽量少用)。
		 * @return 位置与宽高组成的 一个 Rectangle 对象。
		 */
		public function getBounds():Rectangle {
			if (!_bounds || !_temp || _temp.length < 1) {
				_bounds = Rectangle._getWrapRec(getBoundPoints(), _bounds)
			}
			return _bounds;
		}
		
		/**
		 * @private
		 * 获取端点列表。
		 */
		public function getBoundPoints():Array {
			if (!_temp || _temp.length < 1)
				_temp = _getCmdPoints();
			return _rstBoundPoints = Utils.setValueArr(_rstBoundPoints, _temp);
		}
		
		private function _getCmdPoints():Array {
			var context:RenderContext = Render.context;
			var cmds:Array = this._cmds;
			var rst:Array;
			rst = _temp || (_temp = []);
			
			rst.length = 0;
			if (!cmds && _one != null) {
				cmds = [_one];
			}
			if (!cmds)
				return [];
			
			var matrixs:Array;
			matrixs = [];
			var tMatrix:Matrix = new Matrix();
			var tempMatrix:Matrix = _tempMatrix;
			var cmd:Object;
			for (var i:int = 0, n:int = cmds.length; i < n; i++) {
				cmd = cmds[i];
				switch (cmd.callee) {
				case context.save: 
					matrixs.push(tMatrix);
					tMatrix = tMatrix.clone();
					break;
				case context.restore: 
					tMatrix = matrixs.pop();
					break;
				case context._scale: 
					tempMatrix.identity();
					tempMatrix.translate(-cmd[2], -cmd[3]);
					tempMatrix.scale(cmd[0], cmd[1]);
					tempMatrix.translate(cmd[2], cmd[3]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._rotate: 
					tempMatrix.identity();
					tempMatrix.translate(-cmd[1], -cmd[2]);
					tempMatrix.rotate(cmd[0]);
					tempMatrix.translate(cmd[1], cmd[2]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._translate: 
					tempMatrix.identity();
					tempMatrix.translate(cmd[0], cmd[1]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._transform: 
					tempMatrix.identity();
					tempMatrix.translate(-cmd[1], -cmd[2]);
					tempMatrix.concat(cmd[0]);
					tempMatrix.translate(cmd[1], cmd[2]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._drawTexture: 
					if (cmd[3] && cmd[4]) {
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
					} else {
						var tex:Texture = cmd[0];
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], tex.width, tex.height), tMatrix);
					}
					break;
				case context._drawRect: 
				case context._fillRect: 
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tMatrix);
					break;
				case context._drawCircle: 
				case context._fillCircle: 
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0] - cmd[2], cmd[1] - cmd[2], cmd[2] + cmd[2], cmd[2] + cmd[2]), tMatrix);
					break;
				case context._drawLine: 
					_addPointArrToRst(rst, [cmd[0], cmd[1], cmd[2], cmd[3]], tMatrix);
					break;
				case context.drawCurves: 
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					//addPointArrToRst(rst, cmd[2], tMatrix, cmd[0], cmd[1]);
					_addPointArrToRst(rst, Bezier.I.getBezierPoints(cmd[2]), tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPoly: 
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					_addPointArrToRst(rst, cmd[2], tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPath: 
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					_addPointArrToRst(rst, _getPathPoints(cmd[2]), tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPie: 
				case context._drawPieWebGL: 
					_addPointArrToRst(rst, _getPiePoints(cmd[0], cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
					break;
					
				}
			}
			if (rst.length > 200) {
				rst = Utils.setValueArr(rst, Rectangle._getWrapRec(rst)._getBoundPoints());
			} else if (rst.length > 8)
				rst = GrahamScan.scanPList(rst);
			return rst;
		}
		
		private function _switchMatrix(tMatix:Matrix, tempMatrix:Matrix):void {
			tempMatrix.concat(tMatix);
			tempMatrix.copy(tMatix);
		}
		
		private static function _addPointArrToRst(rst:Array, points:Array, matrix:Matrix, dx:Number = 0, dy:Number = 0):void {
			var i:int, len:int;
			len = points.length;
			for (i = 0; i < len; i += 2) {
				_addPointToRst(rst, points[i] + dx, points[i + 1] + dy, matrix);
			}
		}
		
		private static function _addPointToRst(rst:Array, x:Number, y:Number, matrix:Matrix):void {
			var _tempPoint:Point = Point.TEMP;
			x = x ? x : 0;
			y = y ? y : 0;
			_tempPoint.setTo(x, y);
			matrix.transformPoint(x, y, _tempPoint);
			rst.push(_tempPoint.x, _tempPoint.y);
		}
		
		/**
		 * 绘制纹理。
		 * @param	tex 纹理。
		 * @param	x X 轴偏移量。
		 * @param	y Y 轴偏移量。
		 * @param	width 宽度。
		 * @param	height 高度。
		 * @param	m 矩阵信息。
		 */
		public function drawTexture(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0, m:Matrix = null):void {
			_sp && (_sp._renderType |= RenderSprite.GRAPHICS);
			if (!width) width = tex.width;
			if (!height) height = tex.height;
			
			var args:* = [tex, x, y, width, height, m];
			if (_one == null) {
				_one = args;
				_render = _renderOneImg;
			} else {
				_render = _renderAll;
				(_cmds || (_cmds = [])).length === 0 && _cmds.push(_one);
				_cmds.push(args);
			}
			
			args.callee = m ? Render.context._drawTextureWithTransform : Render.context._drawTexture;
			_repaint();
		}
		
		private function _textureLoaded(tex:Texture, param:Array):void {
			tex.off(Event.LOADED, this, _textureLoaded);
			param[3] = tex.width;
			param[4] = tex.height;
			_repaint();
		}
		
		/*public function fillImage(img:Texture, x:Number, y:Number, width:Number, height:Number, repeat:Boolean = true):void {
		   debugger;
		   }*/
		
		/**
		 * 绘制渲染对象。
		 * @param	tex 纹理。
		 * @param	x X 轴偏移量。
		 * @param	y Y 轴偏移量。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function drawRenderTarget(tex:Texture, x:Number, y:Number, width:Number, height:Number):void {
			var mat:Matrix = new Matrix(1, 0, 0, -1, 0, height);
			drawTexture(tex, x, y, width, height, mat);
		}
		
		/**
		 * @private
		 * 保存到命令流。
		 */
		public function _saveToCmd(fun:Function, args:Array):Array {
			_sp && (_sp._renderType |= RenderSprite.GRAPHICS);
			if (_one == null) {
				_one = args;
				_render = _renderOne;
			} else {
				_sp && (_sp._renderType &= ~RenderSprite.IMAGE);
				_render = _renderAll;
				(_cmds || (_cmds = [])).length === 0 && _cmds.push(_one);
				_cmds.push(args);
			}
			args.callee = fun;
			_temp && (_temp.length = 0);
			_repaint();
			return args;
		}
		
		/**
		 * 画布的剪裁区域，超出剪裁区域的坐标可以画图，但不能显示。
		 * @param	x X 轴偏移量。
		 * @param	y Y 轴偏移量。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			_saveToCmd(Render.context._clipRect, arguments);
		}
		
		/**
		 * 在画布上绘制“被填充的”文本。
		 * @param	text 在画布上输出的文本。
		 * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param	font 定义字体和字号。
		 * @param	color 定义文本颜色。
		 * @param	textAlign 文本对齐方式。
		 */
		public function fillText(text:String, x:Number, y:Number, font:String, color:String, textAlign:String):void {
			_saveToCmd(Render.context._fillText, [text, x, y, font || Font.defaultFont, color, textAlign]);
		}
		
		/**
		 * 在画布上绘制“被填充且镶边的”文本。
		 * @param	text 在画布上输出的文本。
		 * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param	font 定义字体和字号。
		 * @param	fillColor 定义文本颜色。
		 * @param	borderColor 定义镶边文本颜色。
		 * @param	lineWidth 镶边线条宽度。
		 * @param	textAlign 文本对齐方式。
		 */
		public function fillBorderText(text:*, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:Number, textAlign:String):void {
			_saveToCmd(Render.context._fillBorderText, [text, x, y, font || Font.defaultFont, fillColor, borderColor, lineWidth, textAlign]);
		}
		
		/**
		 * 在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
		 * @param	text 在画布上输出的文本。
		 * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param	font 定义字体和字号。
		 * @param	color 定义文本颜色。
		 * @param	lineWidth 线条宽度。
		 * @param	textAlign 文本对齐方式。
		 */
		public function strokeText(text:*, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			_saveToCmd(Render.context._strokeText, [text, x, y, font || Font.defaultFont, color, lineWidth, textAlign]);
		}
		
		/**
		 * 设置透明度。
		 * @param	value 透明度。
		 */
		public function alpha(value:Number):void {
			_saveToCmd(Render.context._alpha, arguments);
		}
		
		/**
		 * 设置混合模式。
		 * @param	value 混合模式。
		 */
		public function blendMode(value:String):void {
			_saveToCmd(Render.context._blendMode, arguments);
		}
		
		/**
		 * 替换绘图的当前转换矩阵。
		 * @param	mat 矩阵。
		 * @param	pivotX 水平方向轴心点坐标。
		 * @param	pivotY 垂直方向轴心点坐标。
		 */
		public function transform(mat:Matrix, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render.context._transform, [mat, pivotX, pivotY]);
		}
		
		/**
		 * 旋转当前绘图。
		 * @param	angle 旋转角度，以弧度计。
		 * @param	pivotX 水平方向轴心点坐标。
		 * @param	pivotY 垂直方向轴心点坐标。
		 */
		public function rotate(angle:Number, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render.context._rotate, [angle, pivotX, pivotY]);
		}
		
		/**
		 * 缩放当前绘图至更大或更小。
		 * @param	scaleX 水平方向缩放值。
		 * @param	scaleY 垂直方向缩放值。
		 * @param	pivotX 水平方向轴心点坐标。
		 * @param	pivotY 垂直方向轴心点坐标。
		 */
		public function scale(scaleX:Number, scaleY:Number, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render.context._scale, [scaleX, scaleY, pivotX, pivotY]);
		}
		
		/**
		 * 重新映射画布上的 (0,0) 位置。
		 * @param	x 添加到水平坐标（x）上的值。
		 * @param	y 添加到垂直坐标（y）上的值。
		 */
		public function translate(x:Number, y:Number):void {
			_saveToCmd(Render.context._translate, [x, y]);
		}
		
		/**
		 * 保存当前环境的状态。
		 */
		public function save():void {
			_saveToCmd(Render.context.save, arguments);
		}
		
		/**
		 * 返回之前保存过的路径状态和属性。
		 */
		public function restore():void {
			_saveToCmd(Render.context.restore, arguments);
		}
		
		/**
		 * 替换文本内容。
		 * @param	text 文本内容。
		 * @return 替换成功则值为true，否则值为flase。
		 */
		public function replaceText(text:String):Boolean {
			_repaint();
			var cmds:Array = this._cmds;
			if (!cmds) {
				return _one && _one.callee === Render.context._fillText && (_one[0] = text, true);
			}
			for (var i:int = cmds.length - 1; i > -1; i--) {
				if (cmds[i].callee === Render.context._fillText) {
					cmds[i][0] = text;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 替换文本颜色。
		 * @param	color 颜色。
		 * @return 替换成功则值为true，否则值为flase。
		 */
		public function replaceTextColor(color:String):Boolean {
			_repaint();
			var cmds:Array = this._cmds;
			if (!cmds) {
				return _one && (_one.callee === Render.context._fillBorderText || _one.callee === Render.context._fillText) && (_one[4] = color, true);
			}
			for (var i:int = cmds.length - 1; i > -1; i--) {
				if (cmds[i].callee === Render.context._fillText) {
					cmds[i][4] = color;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 加载并显示一个图片。
		 * @param	url 图片地址。
		 * @param	x 显示图片的x位置。
		 * @param	y 显示图片的y位置。
		 * @param	width 显示图片的宽度，设置为0表示使用图片默认宽度。
		 * @param	height 显示图片的高度，设置为0表示使用图片默认高度。
		 * @param	complete 加载完成回调。
		 */
		public function loadImage(url:String, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, complete:Function = null):void {
			var tex:Texture = Loader.getRes(url);
			if (tex) onloaded(tex);
			else Laya.loader.load(url, Handler.create(null, onloaded), null, Loader.IMAGE);
			
			function onloaded(tex:Texture):void {
				if (tex) {
					drawTexture(tex, x, y, width, height);
					if (complete != null) complete.call(_sp, tex);
				}
			}
			//TODO:clear不掉
		}
		
		/**
		 * @private
		 */
		public function _renderEmpty(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
		}
		
		/**
		 * @private
		 */
		public function _renderAll(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var cmds:Array = this._cmds, cmd:*;
			for (var i:int = 0, n:int = cmds.length; i < n; i++) {
				(cmd = cmds[i]).callee.call(context, x, y, cmd);
			}
		}
		
		/**
		 * @private
		 */
		public function _renderOne(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			_one.callee.call(context, x, y, _one);
		}
		
		/**
		 * @private
		 */
		public function _renderOneImg(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			_one.callee.call(context, x, y, _one);
			if (sprite._renderType !== 2305) {
				sprite._renderType |= RenderSprite.IMAGE;
					//TODO:CHIND,IMAGE,GRAHPICS
			}
		}
		
		/**
		 * 绘制一条线。
		 * @param	fromX X 轴开始位置。
		 * @param	fromY Y 轴开始位置。
		 * @param	toX	X 轴结束位置。
		 * @param	toY	Y 轴结束位置。
		 * @param	lineColor 颜色。
		 * @param	lineWidth 线条宽度。
		 */
		public function drawLine(fromX:Number, fromY:Number, toX:Number, toY:Number, lineColor:String, lineWidth:Number = 1):void {
			var arr:Array = [fromX + 0.5, fromY + 0.5, toX + 0.5, toY + 0.5, lineColor, lineWidth];
			_saveToCmd(Render.context._drawLine, arr);
		}
		
		/**
		 * 绘制一系列线段。
		 * @param	x 开始绘制的 X 轴位置。
		 * @param	y 开始绘制的 Y 轴位置。
		 * @param	points 线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
		 * @param	lineColor 线段颜色，或者填充绘图的渐变对象。
		 * @param	lineWidth 线段宽度。
		 */
		public function drawLines(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number = 1):void {
			var arr:Array = [x + 0.5, y + 0.5, points, lineColor, lineWidth];
			if (Render.isWebGl)
				arr[3] = Color.create(lineColor).numColor;
			_saveToCmd(Render.isWebGl ? Render.context.drawLinesWebGL : Render.context.drawLines, arr);
		}
		
		/**
		 * 绘制一系列曲线。
		 * @param	x 开始绘制的 X 轴位置。
		 * @param	y 开始绘制的 Y 轴位置。
		 * @param	points 线段的点集合，格式[startx,starty,ctrx,ctry,startx,starty...]。
		 * @param	lineColor 线段颜色，或者填充绘图的渐变对象。
		 * @param	lineWidth 线段宽度。
		 */
		public function drawCurves(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number = 1):void {
			var arr:Array = [x + 0.5, y + 0.5, points, lineColor, lineWidth];
			if (Render.isWebGl)
				arr[3] = Color.create(lineColor).numColor;
			_saveToCmd(Render.isWebGl ? Render.context.drawCurvesGL : Render.context.drawCurves, arr);
		}
		
		/**
		 * 绘制矩形。
		 * @param	x 开始绘制的 X 轴位置。
		 * @param	y 开始绘制的 Y 轴位置。
		 * @param	width 矩形宽度。
		 * @param	height 矩形高度。
		 * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
		 * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
		 * @param	lineWidth 边框宽度。
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? 0.5 : 0;
			var arr:Array = [x + offset, y + offset, width, height, fillColor, lineColor, lineWidth];
			_saveToCmd(Render.context._drawRect, arr);
		}
		
		/**
		 * 绘制圆形。
		 * @param	x 圆点X 轴位置。
		 * @param	y 圆点Y 轴位置。
		 * @param	radius 半径。
		 * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
		 * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
		 * @param	lineWidth 边框宽度。
		 */
		public function drawCircle(x:Number, y:Number, radius:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? 0.5 : 0;
			var arr:Array = [x + offset, y + offset, radius, fillColor, lineColor, lineWidth];
			if (Render.isWebGl) {
				arr[3] = fillColor ? Color.create(fillColor).numColor : fillColor;
				arr[4] = lineColor ? Color.create(lineColor).numColor : lineColor;
			}
			_saveToCmd(Render.isWebGl ? Render.context._drawCircleWebGL : Render.context._drawCircle, arr);
		}
		
		/**
		 * 绘制扇形。
		 * @param	x 开始绘制的 X 轴位置。
		 * @param	y 开始绘制的 Y 轴位置。
		 * @param	radius 扇形半径。
		 * @param	startAngle 开始角度。
		 * @param	endAngle 结束角度。
		 * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
		 * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
		 * @param	lineWidth 边框宽度。
		 */
		public function drawPie(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? 0.5 : 0;
			var arr:Array = [x + offset, y + offset, radius, startAngle, endAngle, fillColor, lineColor, lineWidth];
			if (Render.isWebGl) {
				startAngle = 90 - startAngle;
				endAngle = 90 - endAngle;
				arr[5] = fillColor ? Color.create(fillColor).numColor : fillColor;
				arr[6] = lineColor ? Color.create(lineColor).numColor : lineColor;
			}
			arr[3] = Utils.toRadian(startAngle);
			arr[4] = Utils.toRadian(endAngle);
			_saveToCmd(Render.isWebGl ? Render.context._drawPieWebGL : Render.context._drawPie, arr);
		}
		
		private function _getPiePoints(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number):Array {
			var rst:Array;
			rst = [x, y];
			var dP:Number = Math.PI / 10;
			var i:Number;
			for (i = startAngle; i < endAngle; i += dP) {
				rst.push(x + radius * Math.cos(i), y + radius * Math.sin(i));
			}
			if (endAngle != i) {
				rst.push(x + radius * Math.cos(endAngle), y + radius * Math.sin(endAngle));
			}
			return rst;
		}
		
		/**
		 * 绘制多边形。
		 * @param	x 开始绘制的 X 轴位置。
		 * @param	y 开始绘制的 Y 轴位置。
		 * @param	points 多边形的点集合。
		 * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
		 * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
		 * @param	lineWidth 边框宽度。
		 */
		public function drawPoly(x:Number, y:Number, points:Array, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? 0.5 : 0;
			var arr:Array = [x + offset, y + offset, points, fillColor, lineColor, lineWidth];
			if (Render.isWebGl) {
				if (fillColor != null) {
					arr[3] = Color.create(fillColor).numColor;
				}
				if (lineColor != null) {
					arr[4] = Color.create(lineColor).numColor;
				}
			}
			_saveToCmd(Render.isWebGl ? Render.context._drawPolyGL : Render.context._drawPoly, arr);
		}
		
		private function _getPathPoints(paths:Array):Array {
			var i:int, len:int;
			var rst:Array = [];
			len = paths.length;
			var tCMD:Array;
			for (i = 0; i < len; i++) {
				tCMD = paths[i];
				if (tCMD.length > 1) {
					rst.push(tCMD[1], tCMD[2]);
					if (tCMD.length > 3) {
						rst.push(tCMD[3], tCMD[4]);
					}
				}
			}
			return rst;
		}
		
		/**
		 * 绘制路径。
		 * @param	x 开始绘制的 X 轴位置。
		 * @param	y 开始绘制的 Y 轴位置。
		 * @param	paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		 * @param	brush 刷子定义，支持以下设置{fillStyle}。
		 * @param	pen 画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin,lineCap,miterLimit}。
		 */
		public function drawPath(x:Number, y:Number, paths:Array, brush:Object = null, pen:Object = null):void {
			var arr:Array = [x + 0.5, y + 0.5, paths, brush, pen];
			_saveToCmd(Render.context._drawPath, arr);
		}
	}
}