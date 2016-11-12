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
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.utils.Utils;
	import laya.utils.VectorGraphManager;
	
	/**
	 * <code>Graphics</code> 类用于创建绘图显示对象。
	 * @see laya.display.Sprite#graphics
	 */
	public class Graphics {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private */
		private static var _tempMatrix:Matrix = new Matrix();
		/**@private */
		private static var _initMatrix:Matrix = new Matrix();
		/**@private */
		private static var _tempPoints:Array = [];
		/**@private */
		private static var _tempMatrixArrays:Array = [];
		/**@private */
		private static var _tempCmds:Array = [];
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
		/**@private */
		private var _vectorgraphArray:Array;
		
		/**@private */
		public static function __init__():void {
			if (Render.isConchNode) {
				var from:* = Graphics.prototype;
				var to:* = __JS__("ConchGraphics.prototype");
				var list:Array = ["clear", "destroy", "alpha", "rotate", "transform", "scale", "translate", "save", "restore", "clipRect", "blendMode", "fillText", "fillBorderText", "_fands", "drawRect", "drawCircle", "drawPie", "drawPoly", "drawPath", "drawImageM", "drawLine", "drawLines", "_drawPs", "drawCurves", "replaceText", "replaceTextColor", "_fillImage", "fillTexture", "setSkinMesh", "drawParticle", "drawImageS"];
				for (var i:int = 0, len:int = list.length; i <= len; i++) {
					var temp:String = list[i];
					from[temp] = to[temp];
				}
				from._saveToCmd = null;
				if (to.drawImageS) {
					from.drawTextures = function(tex:Texture, pos:Array):void {
						if (!tex) return;
						if (!(tex.loaded && tex.bitmap && tex.source))//source内调用tex.active();
						{
							return;
						}
						//处理透明区域裁剪
						var uv:Array = tex.uv, w:Number = tex.bitmap.width, h:Number = tex.bitmap.height;
						this.drawImageS(tex.bitmap.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, tex.offsetX, tex.offsetY, tex.width, tex.height, pos);
					}
				}
				from.drawTexture = function(tex:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, m:Matrix = null):void {
					if (!tex) return;
					if (!(tex.loaded && tex.bitmap && tex.source))//source内调用tex.active();
					{
						return;
					}
					if (!width) width = tex.sourceWidth;
					if (!height) height = tex.sourceHeight;
					
					width = width - tex.sourceWidth + tex.width;
					height = height - tex.sourceHeight + tex.height;
					if (width <= 0 || height <= 0) return;
					
					//处理透明区域裁剪
					x += tex.offsetX;
					y += tex.offsetY;
					var uv:Array = tex.uv, w:Number = tex.bitmap.width, h:Number = tex.bitmap.height;
					this.drawImageM(tex.bitmap.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, x, y, width, height, m);
				}
				from.fillTexture = function(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0, type:String = "repeat", offset:Point = null):void {
					if (!tex) return;
					if (tex.loaded) {
						var ctxi:* = Render._context.ctx;
						var w:Number = tex.bitmap.width, h:Number = tex.bitmap.height, uv:Array = tex.uv;
						var pat:*;
						if (tex.uv != Texture.DEF_UV) {
							pat = ctxi.createPattern(tex.bitmap.source, type, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h);
						} else {
							pat = ctxi.createPattern(tex.bitmap.source, type);
						}
						var sX:Number = 0, sY:Number = 0;
						if (offset) {
							x += offset.x % tex.width;
							y += offset.y % tex.height;
							sX -= offset.x % tex.width;
							sY -= offset.y % tex.height;
						}
						this._fillImage(pat, x, y, sX, sY, width, height);
					}
				}
			}
		}
		
		/**
		 *  创建一个新的 <code>Graphics</code> 类实例。
		 */
		public function Graphics() {
			_render = _renderEmpty;
			if (Render.isConchNode) {
				__JS__("this._nativeObj=new _conchGraphics();");
				__JS__("this.id=this._nativeObj.conchID;");
			}
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
		 * <p>清空绘制命令。</p>
		 */
		public function clear():void {
			_one = null;
			_render = _renderEmpty;
			_cmds = null;
			_temp && (_temp.length = 0);
			_sp && (_sp._renderType &= ~RenderSprite.IMAGE);
			_sp && (_sp._renderType &= ~RenderSprite.GRAPHICS);
			_repaint();
			if (_vectorgraphArray) {
				for (var i:int = 0, n:int = _vectorgraphArray.length; i < n; i++) {
					VectorGraphManager.getInstance().deleteShape(_vectorgraphArray[i]);
				}
				_vectorgraphArray.length = 0;
			}
		
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
			return _rstBoundPoints = Utils.copyArray(_rstBoundPoints, _temp);
		}
		
		private function _addCmd(a:Array):void {
			this._cmds = this._cmds || [];
			a.callee = a.shift();
			this._cmds.push(a);
		}
		
		private function _getCmdPoints():Array {
			var context:RenderContext = Render._context;
			var cmds:Array = this._cmds;
			var rst:Array;
			rst = _temp || (_temp = []);
			
			rst.length = 0;
			if (!cmds && _one != null) {
				_tempCmds.length = 0;
				_tempCmds.push(_one);
				cmds = _tempCmds;
			}
			if (!cmds)
				return rst;
			
			var matrixs:Array;
			matrixs = _tempMatrixArrays;
			matrixs.length = 0;
			var tMatrix:Matrix = _initMatrix;
			tMatrix.identity();
			var tempMatrix:Matrix = _tempMatrix;
			var cmd:Object;
			for (var i:int = 0, n:int = cmds.length; i < n; i++) {
				cmd = cmds[i];
				switch (cmd.callee) {
				case context.save: 
				case 7: //save
					matrixs.push(tMatrix);
					tMatrix = tMatrix.clone();
					break;
				case context.restore: 
				case 8: //restore
					tMatrix = matrixs.pop();
					break;
				case context._scale: 
				case 5://scale
					tempMatrix.identity();
					tempMatrix.translate(-cmd[2], -cmd[3]);
					tempMatrix.scale(cmd[0], cmd[1]);
					tempMatrix.translate(cmd[2], cmd[3]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._rotate: 
				case 3://case context._rotate: 
					tempMatrix.identity();
					tempMatrix.translate(-cmd[1], -cmd[2]);
					tempMatrix.rotate(cmd[0]);
					tempMatrix.translate(cmd[1], cmd[2]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._translate: 
				case 6://translate
					tempMatrix.identity();
					tempMatrix.translate(cmd[0], cmd[1]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._transform: 
				case 4://context._transform:
					tempMatrix.identity();
					tempMatrix.translate(-cmd[1], -cmd[2]);
					tempMatrix.concat(cmd[0]);
					tempMatrix.translate(cmd[1], cmd[2]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case 16://case context._drawTexture: 
				case 24://case context._fillTexture
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tMatrix);
					break;
				case 17://case context._drawTextureTransform: 
					tMatrix.copyTo(tempMatrix);
					tempMatrix.concat(cmd[4]);
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tempMatrix);
					break;
				case context._drawTexture: 
				case context._fillTexture: 
					if (cmd[3] && cmd[4]) {
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
					} else {
						var tex:Texture = cmd[0];
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], tex.width, tex.height), tMatrix);
					}
					break;
				case context._drawTextureWithTransform: 
					tMatrix.copyTo(tempMatrix);
					tempMatrix.concat(cmd[5]);
					if (cmd[3] && cmd[4]) {
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], cmd[3], cmd[4]), tempMatrix);
					} else {
						tex = cmd[0];
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], tex.width, tex.height), tempMatrix);
					}
					break;
				case context._drawRect: 
				case 13://case context._drawRect:
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tMatrix);
					break;
				case context._drawCircle: 
				case context._fillCircle: 
				case 14://case context._drawCircle
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0] - cmd[2], cmd[1] - cmd[2], cmd[2] + cmd[2], cmd[2] + cmd[2]), tMatrix);
					break;
				case context._drawLine: 
				case 20://drawLine
					_tempPoints.length = 0;
					var lineWidth:Number;
					lineWidth = cmd[5] * 0.5;
					if (cmd[0] == cmd[2]) {
						_tempPoints.push(cmd[0] + lineWidth, cmd[1], cmd[2] + lineWidth, cmd[3], cmd[0] - lineWidth, cmd[1], cmd[2] - lineWidth, cmd[3]);
					} else if (cmd[1] == cmd[3]) {
						_tempPoints.push(cmd[0], cmd[1] + lineWidth, cmd[2], cmd[3] + lineWidth, cmd[0], cmd[1] - lineWidth, cmd[2], cmd[3] - lineWidth);
					} else {
						_tempPoints.push(cmd[0], cmd[1], cmd[2], cmd[3]);
					}
					
					_addPointArrToRst(rst, _tempPoints, tMatrix);
					break;
				case context._drawCurves: 
				case 22://context._drawCurves: 
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					//addPointArrToRst(rst, cmd[2], tMatrix, cmd[0], cmd[1]);
					_addPointArrToRst(rst, Bezier.I.getBezierPoints(cmd[2]), tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPoly: 
				case context._drawLines: 
				case 18://drawpoly
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					_addPointArrToRst(rst, cmd[2], tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPath: 
				case 19://drawPath
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					_addPointArrToRst(rst, _getPathPoints(cmd[2]), tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPie: 
				case 15://drawPie
					_addPointArrToRst(rst, _getPiePoints(cmd[0], cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
					break;
					
				}
			}
			if (rst.length > 200) {
				rst = Utils.copyArray(rst, Rectangle._getWrapRec(rst)._getBoundPoints());
			} else if (rst.length > 8)
				rst = GrahamScan.scanPList(rst);
			return rst;
		}
		
		private function _switchMatrix(tMatix:Matrix, tempMatrix:Matrix):void {
			tempMatrix.concat(tMatix);
			tempMatrix.copyTo(tMatix);
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
			_tempPoint.setTo(x ? x : 0, y ? y : 0);
			matrix.transformPoint(_tempPoint);
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
		public function drawTexture(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0, m:Matrix = null, alpha:Number = 1):void {
			if (!tex) return;
			if (!width) width = tex.sourceWidth;
			if (!height) height = tex.sourceHeight;
			
			width = width - tex.sourceWidth + tex.width;
			height = height - tex.sourceHeight + tex.height;
			if (tex.loaded && (width <= 0 || height <= 0)) return;
			
			//处理透明区域裁剪
			x += tex.offsetX;
			y += tex.offsetY;
			
			_sp && (_sp._renderType |= RenderSprite.GRAPHICS);
			
			var args:* = [tex, x, y, width, height, m, alpha];
			args.callee = (m || alpha != 1) ? Render._context._drawTextureWithTransform : Render._context._drawTexture;
			if (_one == null && !m && alpha == 1) {
				_one = args;
				_render = _renderOneImg;
			} else {
				_saveToCmd(args.callee, args);
			}
			if (!tex.loaded) {
				tex.once(Event.LOADED, this, _textureLoaded, [tex, args]);
			}
			_repaint();
		}
		
		/**
		 * @private 清理贴图并替换为最新的
		 * @param	tex
		 */
		public function cleanByTexture(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0):void {
			if (!tex) return clear();
			if (_one && _render === _renderOneImg) {
				if (!width) width = tex.sourceWidth;
				if (!height) height = tex.sourceHeight;
				width = width - tex.sourceWidth + tex.width;
				height = height - tex.sourceHeight + tex.height;
				
				x += tex.offsetX;
				y += tex.offsetY;
				
				_one[0] = tex;
				_one[1] = x;
				_one[2] = y;
				_one[3] = width;
				_one[4] = height;
			} else {
				clear();
				tex && drawTexture(tex, x, y, width, height);
			}
		}
		
		/**
		 * 批量绘制同样纹理。
		 * @param	tex 纹理。
		 * @param	pos 绘制次数和坐标。
		 */
		public function drawTextures(tex:Texture, pos:Array):void {
			if (!tex) return;
			_saveToCmd(Render._context._drawTextures, [tex, pos]);
		}
		
		/**
		 * 用texture填充
		 * @param	tex 纹理。
		 * @param	x X 轴偏移量。
		 * @param	y Y 轴偏移量。
		 * @param	width 宽度。
		 * @param	height 高度。
		 * @param 	type 填充类型 repeat|repeat-x|repeat-y|no-repeat
		 * @param	offset 贴图纹理偏移
		 *
		 */
		public function fillTexture(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0, type:String = "repeat", offset:Point = null):void {
			if (!tex) return;
			var args:* = [tex, x, y, width, height, type, offset];
			if (!tex.loaded) {
				tex.once(Event.LOADED, this, _textureLoaded, [tex, args]);
			}
			if (Render.isWebGL) {
				var tFillTextureSprite:* = RunDriver.fillTextureShader(tex, x, y, width, height);
				args.push(tFillTextureSprite);
			}
			_saveToCmd(Render._context._fillTexture, args);
		}
		
		private function _textureLoaded(tex:Texture, param:Array):void {
			param[3] = param[3] || tex.width;
			param[4] = param[4] || tex.height;
			_repaint();
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
		 * 设置剪裁区域，超出剪裁区域的坐标不显示。
		 * @param	x X 轴偏移量。
		 * @param	y Y 轴偏移量。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			_saveToCmd(Render._context._clipRect, [x, y, width, height]);
		}
		
		/**
		 * 在画布上绘制文本。
		 * @param	text 在画布上输出的文本。
		 * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param	font 定义字号和字体，比如"20px Arial"。
		 * @param	color 定义文本颜色，比如"#ff0000"。
		 * @param	textAlign 文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function fillText(text:String, x:Number, y:Number, font:String, color:String, textAlign:String):void {
			_saveToCmd(Render._context._fillText, [text, x, y, font || Font.defaultFont, color, textAlign]);
		}
		
		/**
		 * 在画布上绘制“被填充且镶边的”文本。
		 * @param	text 在画布上输出的文本。
		 * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param	font 定义字体和字号，比如"20px Arial"。
		 * @param	fillColor 定义文本颜色，比如"#ff0000"。
		 * @param	borderColor 定义镶边文本颜色。
		 * @param	lineWidth 镶边线条宽度。
		 * @param	textAlign 文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function fillBorderText(text:*, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:Number, textAlign:String):void {
			_saveToCmd(Render._context._fillBorderText, [text, x, y, font || Font.defaultFont, fillColor, borderColor, lineWidth, textAlign]);
		}
		
		/**
		 * 在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
		 * @param	text 在画布上输出的文本。
		 * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param	font 定义字体和字号，比如"20px Arial"。
		 * @param	color 定义文本颜色，比如"#ff0000"。
		 * @param	lineWidth 线条宽度。
		 * @param	textAlign 文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function strokeText(text:*, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			_saveToCmd(Render._context._strokeText, [text, x, y, font || Font.defaultFont, color, lineWidth, textAlign]);
		}
		
		/**
		 * 设置透明度。
		 * @param	value 透明度。
		 */
		public function alpha(value:Number):void {
			_saveToCmd(Render._context._alpha, [value]);
		}
		
		/**
		 * 替换绘图的当前转换矩阵。
		 * @param	mat 矩阵。
		 * @param	pivotX 水平方向轴心点坐标。
		 * @param	pivotY 垂直方向轴心点坐标。
		 */
		public function transform(matrix:Matrix, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render._context._transform, [matrix, pivotX, pivotY]);
		}
		
		/**
		 * 旋转当前绘图。
		 * @param	angle 旋转角度，以弧度计。
		 * @param	pivotX 水平方向轴心点坐标。
		 * @param	pivotY 垂直方向轴心点坐标。
		 */
		public function rotate(angle:Number, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render._context._rotate, [angle, pivotX, pivotY]);
		}
		
		/**
		 * 缩放当前绘图至更大或更小。
		 * @param	scaleX 水平方向缩放值。
		 * @param	scaleY 垂直方向缩放值。
		 * @param	pivotX 水平方向轴心点坐标。
		 * @param	pivotY 垂直方向轴心点坐标。
		 */
		public function scale(scaleX:Number, scaleY:Number, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render._context._scale, [scaleX, scaleY, pivotX, pivotY]);
		}
		
		/**
		 * 重新映射画布上的 (0,0) 位置。
		 * @param	x 添加到水平坐标（x）上的值。
		 * @param	y 添加到垂直坐标（y）上的值。
		 */
		public function translate(x:Number, y:Number):void {
			_saveToCmd(Render._context._translate, [x, y]);
		}
		
		/**
		 * 保存当前环境的状态。
		 */
		public function save():void {
			_saveToCmd(Render._context._save, []);
		}
		
		/**
		 * 返回之前保存过的路径状态和属性。
		 */
		public function restore():void {
			_saveToCmd(Render._context._restore, []);
		}
		
		/**
		 * @private
		 * 替换文本内容。
		 * @param	text 文本内容。
		 * @return 替换成功则值为true，否则值为flase。
		 */
		public function replaceText(text:String):Boolean {
			_repaint();
			var cmds:Array = this._cmds;
			if (!cmds) {
				if (_one && _isTextCmd(_one.callee)) {
					if (_one[0].toUpperCase) _one[0] = text;
					else _one[0].setText(text);
					return true;
				}
			} else {
				for (var i:int = cmds.length - 1; i > -1; i--) {
					if (_isTextCmd(cmds[i].callee)) {
						if (cmds[i][0].toUpperCase) cmds[i][0] = text;
						else cmds[i][0].setText(text);
						return true;
					}
				}
			}
			return false;
		}
		
		/**@private */
		private function _isTextCmd(fun:Function):Boolean {
			return fun === Render._context._fillText || fun === Render._context._fillBorderText || fun === Render._context._strokeText;
		}
		
		/**
		 * @private
		 * 替换文本颜色。
		 * @param	color 颜色。
		 */
		public function replaceTextColor(color:String):void {
			_repaint();
			var cmds:Array = this._cmds;
			if (!cmds) {
				if (_one && _isTextCmd(_one.callee)) {
					_one[4] = color;
					if (!_one[0].toUpperCase) _one[0].changed = true;
				}
			} else {
				for (var i:int = cmds.length - 1; i > -1; i--) {
					if (_isTextCmd(cmds[i].callee)) {
						cmds[i][4] = color;
						if (!cmds[i][0].toUpperCase) cmds[i][0].changed = true;
					}
				}
			}
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
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var arr:Array = [fromX + 0.5, fromY + 0.5, toX + 0.5, toY + 0.5, lineColor, lineWidth, tId];
			_saveToCmd(Render._context._drawLine, arr);
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
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var arr:Array = [x + 0.5, y + 0.5, points, lineColor, lineWidth, tId];
			_saveToCmd(Render._context._drawLines, arr);
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
			_saveToCmd(Render._context._drawCurves, arr);
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
			_saveToCmd(Render._context._drawRect, arr);
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
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var arr:Array = [x + offset, y + offset, radius, fillColor, lineColor, lineWidth, tId];
			_saveToCmd(Render._context._drawCircle, arr);
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
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var arr:Array = [x + offset, y + offset, radius, startAngle, endAngle, fillColor, lineColor, lineWidth, tId];
			arr[3] = Utils.toRadian(startAngle);
			arr[4] = Utils.toRadian(endAngle);
			_saveToCmd(Render._context._drawPie, arr);
		}
		
		private function _getPiePoints(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number):Array {
			var rst:Array = _tempPoints;
			_tempPoints.length = 0;
			rst.push(x, y);
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
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
				var tIsConvexPolygon:Boolean = false;
				//这里加入多加形是否是凸边形
				if (points.length > 6) {
					tIsConvexPolygon = false;
				} else {
					tIsConvexPolygon = true;
				}
			}
			var arr:Array = [x + offset, y + offset, points, fillColor, lineColor, lineWidth, tId, tIsConvexPolygon];
			_saveToCmd(Render._context._drawPoly, arr);
		}
		
		private function _getPathPoints(paths:Array):Array {
			var i:int, len:int;
			var rst:Array = _tempPoints;
			rst.length = 0;
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
		 * @param	paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y,x,y,x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		 * @param	brush 刷子定义，支持以下设置{fillStyle}。
		 * @param	pen 画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin,lineCap,miterLimit}。
		 */
		public function drawPath(x:Number, y:Number, paths:Array, brush:Object = null, pen:Object = null):void {
			var arr:Array = [x + 0.5, y + 0.5, paths, brush, pen];
			_saveToCmd(Render._context._drawPath, arr);
		}
	}
}