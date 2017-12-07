package laya.display {
	import laya.display.css.Font;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Utils;
	import laya.utils.VectorGraphManager;
	
	/**
	 * <code>Graphics</code> 类用于创建绘图显示对象。Graphics可以同时绘制多个位图或者矢量图，还可以结合save，restore，transform，scale，rotate，translate，alpha等指令对绘图效果进行变化。
	 * Graphics以命令流方式存储，可以通过cmds属性访问所有命令流。Graphics是比Sprite更轻量级的对象，合理使用能提高应用性能(比如把大量的节点绘图改为一个节点的Graphics命令集合，能减少大量节点创建消耗)。
	 * @see laya.display.Sprite#graphics
	 */
	public class Graphics {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		public var _sp:Sprite;
		/**@private */
		public var _one:Array = null;
		/**@private */
		public var _render:Function = _renderEmpty;
		/**@private */
		private var _cmds:Array = null;
		/**@private */
		private var _vectorgraphArray:Array;
		/**@private */
		private var _graphicBounds:GraphicsBounds;
		private static var _cache:Array = [];
		
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
				from.drawTexture = function(tex:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, m:Matrix = null, alpha:Number = 1):void {
					if (!tex) return;
					if (!tex.loaded) {
						tex.once(Event.LOADED, this, function():void {
							this.drawTexture(tex, x, y, width, height, m);
						});
						return;
					}
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
					this.drawImageM(tex.bitmap.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, x, y, width, height, m, alpha);
					this._repaint();
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
		 * 创建一个新的 <code>Graphics</code> 类实例。
		 */
		public function Graphics() {
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
			if (_graphicBounds) _graphicBounds.destroy();
			_graphicBounds = null;
			_vectorgraphArray = null;
			_sp && (_sp._renderType = 0);
			_sp = null;
		}
		
		/**
		 * <p>清空绘制命令。</p>
		 * @param recoverCmds 是否回收绘图指令
		 */	
		public function clear(recoverCmds:Boolean = false):void {
			if (recoverCmds) {
				var tCmd:* = _one;
				if (_cmds) {
					var i:int, len:int = _cmds.length;
					for (i = 0; i < len; i++) {
						tCmd = _cmds[i];
						if (tCmd && (tCmd.callee === Render._context._drawTexture || tCmd.callee === Render._context._drawTextureWithTransform)) {
							tCmd[0] = null;
							_cache.push(tCmd);
						}
					}
					_cmds.length = 0;
				} else if (tCmd) {
					if (tCmd && (tCmd.callee === Render._context._drawTexture || tCmd.callee === Render._context._drawTextureWithTransform)) {
						tCmd[0] = null;
						_cache.push(tCmd);
					}
				}
			} else {
				_cmds = null;
			}
			
			_one = null;
			_render = _renderEmpty;
			
			_sp && (_sp._renderType &= ~RenderSprite.IMAGE & ~RenderSprite.GRAPHICS);
			_repaint();
			if (_vectorgraphArray) {
				for (i = 0, len = _vectorgraphArray.length; i < len; i++) {
					VectorGraphManager.getInstance().deleteShape(_vectorgraphArray[i]);
				}
				_vectorgraphArray.length = 0;
			}
		}
		
		/**@private */
		private function _clearBoundsCache():void {
			if (_graphicBounds) _graphicBounds.reset();
		}
		
		/**@private */
		private function _initGraphicBounds():void {
			if (!_graphicBounds) {
				_graphicBounds = new GraphicsBounds();
				_graphicBounds._graphics = this;
			}
		}
		
		/**
		 * @private
		 * 重绘此对象。
		 */
		public function _repaint():void {
			_clearBoundsCache();
			_sp && _sp.repaint();
		}
		
		/**@private */
		public function _isOnlyOne():Boolean {
			return !_cmds || _cmds.length === 0;
		}
		
		/**
		 * @private
		 * 命令流。存储了所有绘制命令。
		 */
		public function get cmds():Array {
			return _cmds;
		}
		
		public function set cmds(value:Array):void {
			_sp && (_sp._renderType |= RenderSprite.GRAPHICS);
			_cmds = value;
			_render = _renderAll;
			_repaint();
		}
		
		/**
		 * 获取位置及宽高信息矩阵(比较耗CPU，频繁使用会造成卡顿，尽量少用)。
		 * @param realSize	（可选）使用图片的真实大小，默认为false
		 * @return 位置与宽高组成的 一个 Rectangle 对象。
		 */
		public function getBounds(realSize:Boolean = false):Rectangle {
			_initGraphicBounds();
			return _graphicBounds.getBounds(realSize);
		}
		
		/**
		 * @private
		 * @param realSize	（可选）使用图片的真实大小，默认为false
		 * 获取端点列表。
		 */
		public function getBoundPoints(realSize:Boolean = false):Array {
			_initGraphicBounds();
			return _graphicBounds.getBoundPoints(realSize);
		}
		
		private function _addCmd(a:Array):void {
			this._cmds = this._cmds || [];
			a.callee = a.shift();
			this._cmds.push(a);
		}
		
		public function setFilters(fs:Array):void
		{
			_saveToCmd(Render._context._setFilters, fs);
		}
		
		
		/**
		 * 绘制纹理。
		 * @param tex		纹理。
		 * @param x 		（可选）X轴偏移量。
		 * @param y 		（可选）Y轴偏移量。
		 * @param width		（可选）宽度。
		 * @param height	（可选）高度。
		 * @param m			（可选）矩阵信息。
		 * @param alpha		（可选）透明度。
		 */
		public function drawTexture(tex:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, m:Matrix = null, alpha:Number = 1):Array {
			if (!tex || alpha < 0.01) return null;
			if (!width) width = tex.sourceWidth;
			if (!height) height = tex.sourceHeight;
			
			var wRate:Number = width / tex.sourceWidth;
			var hRate:Number = height / tex.sourceHeight;
			width = tex.width * wRate;
			height = tex.height * hRate;
			//width = width - tex.sourceWidth + tex.width;
			//height = height - tex.sourceHeight + tex.height;
			if (tex.loaded && (width <= 0 || height <= 0)) return null;
			
			//处理透明区域裁剪
			//x += tex.offsetX;
			//y += tex.offsetY;
			
			x += tex.offsetX * wRate;
			y += tex.offsetY * hRate;
			
			_sp && (_sp._renderType |= RenderSprite.GRAPHICS);
			
			//var args:* = [tex, x, y, width, height, m, alpha];
			if (_cache.length) {
				var args:Array = _cache.pop();
				args[0] = tex;
				args[1] = x;
				args[2] = y;
				args[3] = width;
				args[4] = height;
				args[5] = m;
				args[6] = alpha;
			} else {
				args = [tex, x, y, width, height, m, alpha];
			}
			
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
			return args;
		}
		
		/**
		*
		* @param texture    贴图
		* @param points     顶点和UV数据[top left, top right, bottom right, bottom left]
		*/
		public function drawTriangles(texture : Texture, x : Number, y : Number, points : Array) : void {
			if (!texture || !points || points.length % 4 != 0 || points.length < 4) {
				return;
			}
			_saveToCmd(Render._context._fillTrangles, [texture, 0, 0, points, null]);
		}
		
		/**
		 * @private 清理贴图并替换为最新的
		 * @param tex
		 */
		public function cleanByTexture(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0):void {
			if (!tex) return clear();
			if (_one && _render === _renderOneImg) {
				if (!width) width = tex.sourceWidth;
				if (!height) height = tex.sourceHeight;
				//				width = width - tex.sourceWidth + tex.width;
				//				height = height - tex.sourceHeight + tex.height;
				var wRate:Number = width / tex.sourceWidth;
				var hRate:Number = height / tex.sourceHeight;
				width = tex.width * wRate;
				height = tex.height * hRate;
				
				//				x += tex.offsetX;
				//				y += tex.offsetY;
				
				x += tex.offsetX * wRate;
				y += tex.offsetY * hRate;
				
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
		 * @param tex 纹理。
		 * @param pos 绘制次数和坐标。
		 */
		public function drawTextures(tex:Texture, pos:Array):void {
			if (!tex) return;
			_saveToCmd(Render._context._drawTextures, [tex, pos]);
		}
		
		/**
		 * 用texture填充。
		 * @param tex		纹理。
		 * @param x			X轴偏移量。
		 * @param y			Y轴偏移量。
		 * @param width		（可选）宽度。
		 * @param height	（可选）高度。
		 * @param type		（可选）填充类型 repeat|repeat-x|repeat-y|no-repeat
		 * @param offset	（可选）贴图纹理偏移
		 *
		 */
		public function fillTexture(tex:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0, type:String = "repeat", offset:Point = null):void {
			if (!tex) return;
			var args:* = [tex, x, y, width, height, type, offset || Point.EMPTY, {}];
			if (!tex.loaded) {
				tex.once(Event.LOADED, this, _textureLoaded, [tex, args]);
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
			_repaint();
			return args;
		}
		
		/**
		 * 设置剪裁区域，超出剪裁区域的坐标不显示。
		 * @param x X 轴偏移量。
		 * @param y Y 轴偏移量。
		 * @param width 宽度。
		 * @param height 高度。
		 */
		public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			_saveToCmd(Render._context._clipRect, [x, y, width, height]);
		}
		
		/**
		 * 在画布上绘制文本。
		 * @param text 在画布上输出的文本。
		 * @param x 开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param y 开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param font 定义字号和字体，比如"20px Arial"。
		 * @param color 定义文本颜色，比如"#ff0000"。
		 * @param textAlign 文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function fillText(text:String, x:Number, y:Number, font:String, color:String, textAlign:String,underLine:int = 0):void {
			_saveToCmd(Render._context._fillText, [text, x, y, font || Font.defaultFont, color, textAlign]);
		}
		
		/**
		 * 在画布上绘制“被填充且镶边的”文本。
		 * @param text			在画布上输出的文本。
		 * @param x				开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param y				开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param font			定义字体和字号，比如"20px Arial"。
		 * @param fillColor		定义文本颜色，比如"#ff0000"。
		 * @param borderColor	定义镶边文本颜色。
		 * @param lineWidth		镶边线条宽度。
		 * @param textAlign		文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function fillBorderText(text:*, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:Number, textAlign:String):void {
			_saveToCmd(Render._context._fillBorderText, [text, x, y, font || Font.defaultFont, fillColor, borderColor, lineWidth, textAlign]);
		}
		
		/**
		 * 在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
		 * @param text		在画布上输出的文本。
		 * @param x			开始绘制文本的 x 坐标位置（相对于画布）。
		 * @param y			开始绘制文本的 y 坐标位置（相对于画布）。
		 * @param font		定义字体和字号，比如"20px Arial"。
		 * @param color		定义文本颜色，比如"#ff0000"。
		 * @param lineWidth	线条宽度。
		 * @param textAlign	文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function strokeText(text:*, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			_saveToCmd(Render._context._strokeText, [text, x, y, font || Font.defaultFont, color, lineWidth, textAlign]);
		}
		
		/**
		 * 设置透明度。
		 * @param value 透明度。
		 */
		public function alpha(value:Number):void {
			_saveToCmd(Render._context._alpha, [value]);
		}
		
		/**
		 * 设置当前透明度。
		 * @param	value 透明度。
		 */
		public function setAlpha(value:Number):void {
			_saveToCmd(Render._context._setAlpha, [value]);
		}
		
		/**
		 * 替换绘图的当前转换矩阵。
		 * @param mat 矩阵。
		 * @param pivotX	（可选）水平方向轴心点坐标。
		 * @param pivotY	（可选）垂直方向轴心点坐标。
		 */
		public function transform(matrix:Matrix, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render._context._transform, [matrix, pivotX, pivotY]);
		}
		
		/**
		 * 旋转当前绘图。(推荐使用transform，性能更高)
		 * @param angle		旋转角度，以弧度计。
		 * @param pivotX	（可选）水平方向轴心点坐标。
		 * @param pivotY	（可选）垂直方向轴心点坐标。
		 */
		public function rotate(angle:Number, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render._context._rotate, [angle, pivotX, pivotY]);
		}
		
		/**
		 * 缩放当前绘图至更大或更小。(推荐使用transform，性能更高)
		 * @param scaleX	水平方向缩放值。
		 * @param scaleY	垂直方向缩放值。
		 * @param pivotX	（可选）水平方向轴心点坐标。
		 * @param pivotY	（可选）垂直方向轴心点坐标。
		 */
		public function scale(scaleX:Number, scaleY:Number, pivotX:Number = 0, pivotY:Number = 0):void {
			_saveToCmd(Render._context._scale, [scaleX, scaleY, pivotX, pivotY]);
		}
		
		/**
		 * 重新映射画布上的 (0,0) 位置。
		 * @param x 添加到水平坐标（x）上的值。
		 * @param y 添加到垂直坐标（y）上的值。
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
		 * @param text 文本内容。
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
		 * @param color 颜色。
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
		 * @param url		图片地址。
		 * @param x			（可选）显示图片的x位置。
		 * @param y			（可选）显示图片的y位置。
		 * @param width		（可选）显示图片的宽度，设置为0表示使用图片默认宽度。
		 * @param height	（可选）显示图片的高度，设置为0表示使用图片默认高度。
		 * @param complete	（可选）加载完成回调。
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
		 * @param fromX		X轴开始位置。
		 * @param fromY		Y轴开始位置。
		 * @param toX		X轴结束位置。
		 * @param toY		Y轴结束位置。
		 * @param lineColor	颜色。
		 * @param lineWidth	（可选）线条宽度。
		 */
		public function drawLine(fromX:Number, fromY:Number, toX:Number, toY:Number, lineColor:String, lineWidth:Number = 1):void {
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			
			var offset:Number = lineWidth % 2 === 0 ? 0 : 0.5;
			var arr:Array = [fromX + offset, fromY + offset, toX + offset, toY + offset, lineColor, lineWidth, tId];
			_saveToCmd(Render._context._drawLine, arr);
		}
		
		/**
		 * 绘制一系列线段。
		 * @param x			开始绘制的X轴位置。
		 * @param y			开始绘制的Y轴位置。
		 * @param points	线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
		 * @param lineColor	线段颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）线段宽度。
		 */
		public function drawLines(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number = 1):void {
			var tId:uint = 0;
			if (!points || points.length < 4) return;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var offset:Number = lineWidth % 2 === 0 ? 0 : 0.5;
			var arr:Array = [x + offset, y + offset, points, lineColor, lineWidth, tId];
			_saveToCmd(Render._context._drawLines, arr);
		}
		
		/**
		 * 绘制一系列曲线。
		 * @param x			开始绘制的 X 轴位置。
		 * @param y			开始绘制的 Y 轴位置。
		 * @param points	线段的点集合，格式[startx,starty,ctrx,ctry,startx,starty...]。
		 * @param lineColor	线段颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）线段宽度。
		 */
		public function drawCurves(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number = 1):void {
			var arr:Array = [x, y, points, lineColor, lineWidth];
			_saveToCmd(Render._context._drawCurves, arr);
		}
		
		/**
		 * 绘制矩形。
		 * @param x			开始绘制的 X 轴位置。
		 * @param y			开始绘制的 Y 轴位置。
		 * @param width		矩形宽度。
		 * @param height	矩形高度。
		 * @param fillColor	填充颜色，或者填充绘图的渐变对象。
		 * @param lineColor	（可选）边框颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）边框宽度。
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? lineWidth / 2 : 0;
			var lineOffset:Number = lineColor ? lineWidth : 0;
			var arr:Array = [x + offset, y + offset, width - lineOffset, height - lineOffset, fillColor, lineColor, lineWidth];
			_saveToCmd(Render._context._drawRect, arr);
		}
		
		/**
		 * 绘制圆形。
		 * @param x			圆点X 轴位置。
		 * @param y			圆点Y 轴位置。
		 * @param radius	半径。
		 * @param fillColor	填充颜色，或者填充绘图的渐变对象。
		 * @param lineColor	（可选）边框颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）边框宽度。
		 */
		public function drawCircle(x:Number, y:Number, radius:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? lineWidth / 2 : 0;
			
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var arr:Array = [x, y, radius - offset, fillColor, lineColor, lineWidth, tId];
			_saveToCmd(Render._context._drawCircle, arr);
		}
		
		/**
		 * 绘制扇形。
		 * @param x				开始绘制的 X 轴位置。
		 * @param y				开始绘制的 Y 轴位置。
		 * @param radius		扇形半径。
		 * @param startAngle	开始角度。
		 * @param endAngle		结束角度。
		 * @param fillColor		填充颜色，或者填充绘图的渐变对象。
		 * @param lineColor		（可选）边框颜色，或者填充绘图的渐变对象。
		 * @param lineWidth		（可选）边框宽度。
		 */
		public function drawPie(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
			var offset:Number = lineColor ? lineWidth / 2 : 0;
			var lineOffset:Number = lineColor ? lineWidth : 0;
			
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var arr:Array = [x + offset, y + offset, radius - lineOffset, startAngle, endAngle, fillColor, lineColor, lineWidth, tId];
			arr[3] = Utils.toRadian(startAngle);
			arr[4] = Utils.toRadian(endAngle);
			_saveToCmd(Render._context._drawPie, arr);
		}
		
		/**
		 * 绘制多边形。
		 * @param x			开始绘制的 X 轴位置。
		 * @param y			开始绘制的 Y 轴位置。
		 * @param points	多边形的点集合。
		 * @param fillColor	填充颜色，或者填充绘图的渐变对象。
		 * @param lineColor	（可选）边框颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）边框宽度。
		 */
		public function drawPoly(x:Number, y:Number, points:Array, fillColor:*, lineColor:* = null, lineWidth:Number = 1):void {
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
			var offset:Number = lineColor ? (lineWidth % 2 === 0 ? 0 : 0.5) : 0;
			var arr:Array = [x + offset, y + offset, points, fillColor, lineColor, lineWidth, tId, tIsConvexPolygon];
			_saveToCmd(Render._context._drawPoly, arr);
		}
		
		/**
		 * 绘制路径。
		 * @param x		开始绘制的 X 轴位置。
		 * @param y		开始绘制的 Y 轴位置。
		 * @param paths	路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y,x,y,x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		 * @param brush	（可选）刷子定义，支持以下设置{fillStyle}。
		 * @param pen	（可选）画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin,lineCap,miterLimit}。
		 */
		public function drawPath(x:Number, y:Number, paths:Array, brush:Object = null, pen:Object = null):void {
			var arr:Array = [x, y, paths, brush, pen];
			_saveToCmd(Render._context._drawPath, arr);
		}
	}
}