package laya.display {
	import laya.display.cmd.AlphaCmd;
	import laya.display.cmd.ClipRectCmd;
	import laya.display.cmd.DrawCircleCmd;
	import laya.display.cmd.DrawCurvesCmd;
	import laya.display.cmd.DrawImageCmd;
	import laya.display.cmd.DrawLineCmd;
	import laya.display.cmd.DrawLinesCmd;
	import laya.display.cmd.DrawPathCmd;
	import laya.display.cmd.DrawPieCmd;
	import laya.display.cmd.DrawPolyCmd;
	import laya.display.cmd.DrawRectCmd;
	import laya.display.cmd.DrawTextureCmd;
	import laya.display.cmd.DrawTexturesCmd;
	import laya.display.cmd.DrawTrianglesCmd;
	import laya.display.cmd.FillBorderTextCmd;
	import laya.display.cmd.FillBorderWordsCmd;
	import laya.display.cmd.FillTextCmd;
	import laya.display.cmd.FillTextureCmd;
	import laya.display.cmd.FillWordsCmd;
	import laya.display.cmd.RestoreCmd;
	import laya.display.cmd.RotateCmd;
	import laya.display.cmd.SaveCmd;
	import laya.display.cmd.ScaleCmd;
	import laya.display.cmd.StrokeTextCmd;
	import laya.display.cmd.TransformCmd;
	import laya.display.cmd.TranslateCmd;
	import laya.events.Event;
	import laya.filters.ColorFilter;
	import laya.filters.ColorFilterAction;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.ColorUtils;
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
		public var _one:* = null;
		/**@private */
		public var _render:Function = _renderEmpty;
		/**@private */
		private var _cmds:Array = null;
		/**@private */
		protected var _vectorgraphArray:Array;
		/**@private */
		private var _graphicBounds:GraphicsBounds;
		/**@private */
		public var autoDestroy:Boolean = false;
		
		public function Graphics() {
			_createData();
		}
		
		/**@private */
		public function _createData():void {
		
		}
		
		/**@private */
		public function _clearData():void {
		
		}
		
		/**@private */
		public function _destroyData():void {
		
		}
		
		/**
		 * <p>销毁此对象。</p>
		 */
		public function destroy():void {
			clear(true);
			if (_graphicBounds) _graphicBounds.destroy();
			_graphicBounds = null;
			_vectorgraphArray = null;
			if (_sp) {
				_sp._renderType = 0;
				_sp._setRenderType(0);
				_sp = null;
			}
			_destroyData();
		}
		
		/**
		 * <p>清空绘制命令。</p>
		 * @param recoverCmds 是否回收绘图指令数组，设置为true，则对指令数组进行回收以节省内存开销，建议设置为true进行回收，但如果手动引用了数组，不建议回收
		 */
		public function clear(recoverCmds:Boolean = true):void {
			//TODO:内存回收all
			if (recoverCmds) {
				var tCmd:* = _one;
				if (_cmds) {
					var i:int, len:int = _cmds.length;
					for (i = 0; i < len; i++) {
						tCmd = _cmds[i];
						tCmd.recover();
					}
					_cmds.length = 0;
				} else if (tCmd) {
					tCmd.recover();
				}
			} else {
				_cmds = null;
			}
			
			_one = null;
			_render = _renderEmpty;
			_clearData();
			//_sp && (_sp._renderType &= ~SpriteConst.IMAGE);
			if (_sp) {
				_sp._renderType &= ~SpriteConst.GRAPHICS;
				_sp._setRenderType(_sp._renderType);
			}
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
				_graphicBounds = GraphicsBounds.create();
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
		//TODO:coverage
		public function _isOnlyOne():Boolean {
			return !_cmds || _cmds.length === 0;
		}
		
		/**
		 * @private
		 * 命令流。存储了所有绘制命令。
		 */
		public function get cmds():Array {
			//TODO:单命令不对
			return _cmds;
		}
		
		public function set cmds(value:Array):void {
			if (_sp) {
				_sp._renderType |= SpriteConst.GRAPHICS;
				_sp._setRenderType(_sp._renderType);
			}
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
		
		/**
		 * 绘制单独图片
		 * @param texture		纹理。
		 * @param x 		（可选）X轴偏移量。
		 * @param y 		（可选）Y轴偏移量。
		 * @param width		（可选）宽度。
		 * @param height	（可选）高度。
		 */
		public function drawImage(texture:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):DrawImageCmd {
			if (!texture) return null;
			if (!width) width = texture.sourceWidth;
			if (!height) height = texture.sourceHeight;
			if (texture.getIsReady()) {
				var wRate:Number = width / texture.sourceWidth;
				var hRate:Number = height / texture.sourceHeight;
				width = texture.width * wRate;
				height = texture.height * hRate;
				if (width <= 0 || height <= 0) return null;
				
				x += texture.offsetX * wRate;
				y += texture.offsetY * hRate;
			}
			
			if (_sp) {
				_sp._renderType |= SpriteConst.GRAPHICS;
				_sp._setRenderType(_sp._renderType);
			}
			
			var args:DrawImageCmd = DrawImageCmd.create.call(this, texture, x, y, width, height);
			
			if (_one == null) {
				_one = args;
				_render = _renderOneImg;
					//if(_sp)_sp._renderType |= SpriteConst.IMAGE;
			} else {
				_saveToCmd(null, args);
			}
			//if (!tex.loaded) {
			//tex.once(Event.LOADED, this, _textureLoaded, [tex, args]);
			//}
			_repaint();
			return args;
		}
		
		/**
		 * 绘制纹理，相比drawImage功能更强大，性能会差一些
		 * @param texture		纹理。
		 * @param x 		（可选）X轴偏移量。
		 * @param y 		（可选）Y轴偏移量。
		 * @param width		（可选）宽度。
		 * @param height	（可选）高度。
		 * @param matrix	（可选）矩阵信息。
		 * @param alpha		（可选）透明度。
		 * @param color		（可选）颜色滤镜。
		 * @param blendMode （可选）混合模式。
		 */
		public function drawTexture(texture:Texture, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, matrix:Matrix = null, alpha:Number = 1, color:String = null, blendMode:String = null):DrawTextureCmd {
			if (!texture || alpha < 0.01) return null;
			if (!texture.getIsReady()) return null;
			if (!width) width = texture.sourceWidth;
			if (!height) height = texture.sourceHeight;
			if (texture.getIsReady()) {
				var offset:Number = (!Render.isWebGL && (Browser.onFirefox || Browser.onEdge || Browser.onIE || Browser.onSafari)) ? 0.5 : 0;
				var wRate:Number = width / texture.sourceWidth;
				var hRate:Number = height / texture.sourceHeight;
				width = texture.width * wRate;
				height = texture.height * hRate;
				if (width <= 0 || height <= 0) return null;
				
				x += texture.offsetX * wRate;
				y += texture.offsetY * hRate;
				x -= offset;
				y -= offset;
				width += 2 * offset;
				height += 2 * offset;
			}
			
			if (_sp) {
				_sp._renderType |= SpriteConst.GRAPHICS;
				_sp._setRenderType(_sp._renderType);
			}
			
			if (!Render.isConchApp && !Render.isWebGL && (blendMode || color)) {
				var canvas:HTMLCanvas = new HTMLCanvas();
				canvas.size(width, height);
				var ctx:Context = canvas.getContext('2d');
				ctx.drawTexture(texture, 0, 0, width, height);
				texture = new Texture(canvas);
				
				if (color) {
					var filter:ColorFilterAction = new ColorFilterAction();
					var colorArr:Array = ColorUtils.create(color).arrColor;
					//TODO:
					filter.data = new ColorFilter().color(colorArr[0] * 255, colorArr[1] * 255, colorArr[2] * 255);
					//TODO:
					filter.apply({ctx: {ctx: ctx}});
				}
			}
			
			var args:DrawTextureCmd = DrawTextureCmd.create.call(this, texture, x, y, width, height, matrix, alpha, color, blendMode);
			_repaint();
			
			return _saveToCmd(null, args);
		}
		
		/**
		 * 批量绘制同样纹理。
		 * @param texture 纹理。
		 * @param pos 绘制次数和坐标。
		 */
		public function drawTextures(texture:Texture, pos:Array):DrawTexturesCmd {
			if (!texture) return null;
			return _saveToCmd(Render._context._drawTextures, DrawTexturesCmd.create.call(this, texture, pos));
		}
		
		/**
		 * 绘制一组三角形
		 * @param texture	纹理。
		 * @param x			X轴偏移量。
		 * @param y			Y轴偏移量。
		 * @param vertices  顶点数组。
		 * @param indices	顶点索引。
		 * @param uvData	UV数据。
		 * @param matrix	缩放矩阵。
		 * @param alpha		alpha
		 * @param color		颜色变换
		 * @param blendMode	blend模式
		 */
		public function drawTriangles(texture:Texture, x:Number, y:Number, vertices:Float32Array, uvs:Float32Array, indices:Uint16Array, matrix:Matrix = null, alpha:Number = 1, color:String = null, blendMode:String = null):DrawTrianglesCmd {
			return _saveToCmd(Render._context.drawTriangles, DrawTrianglesCmd.create.call(this, texture, x, y, vertices, uvs, indices, matrix, alpha, color, blendMode));
		}
		
		/**
		 * 用texture填充。
		 * @param texture		纹理。
		 * @param x			X轴偏移量。
		 * @param y			Y轴偏移量。
		 * @param width		（可选）宽度。
		 * @param height	（可选）高度。
		 * @param type		（可选）填充类型 repeat|repeat-x|repeat-y|no-repeat
		 * @param offset	（可选）贴图纹理偏移
		 *
		 */
		public function fillTexture(texture:Texture, x:Number, y:Number, width:Number = 0, height:Number = 0, type:String = "repeat", offset:Point = null):FillTextureCmd {
			if (texture && texture.getIsReady())
				return _saveToCmd(Render._context._fillTexture, FillTextureCmd.create.call(this, texture, x, y, width, height, type, offset || Point.EMPTY, {}));
			else
				return null;
		}
		
		/**
		 * @private
		 * 保存到命令流。
		 */
		public function _saveToCmd(fun:Function, args:*):* {
			if (_sp) {
				_sp._renderType |= SpriteConst.GRAPHICS;
				_sp._setRenderType(_sp._renderType);
			}
			if (_one == null) {
				_one = args;
				_render = _renderOne;
			} else {
				//_sp && (_sp._renderType &= ~SpriteConst.IMAGE);
				_render = _renderAll;
				(_cmds || (_cmds = [])).length === 0 && _cmds.push(_one);
				_cmds.push(args);
			}
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
		public function clipRect(x:Number, y:Number, width:Number, height:Number):ClipRectCmd {
			return _saveToCmd(Render._context._clipRect, ClipRectCmd.create.call(this, x, y, width, height));
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
		public function fillText(text:String, x:Number, y:Number, font:String, color:String, textAlign:String):FillTextCmd {
			return _saveToCmd(Render._context._fillText, FillTextCmd.create.call(this, text, x, y, font || Text.defaultFontStr(), color, textAlign));
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
		public function fillBorderText(text:String, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:Number, textAlign:String):FillBorderTextCmd {
			return _saveToCmd(Render._context._fillBorderText, FillBorderTextCmd.create.call(this, text, x, y, font || Text.defaultFontStr(), fillColor, borderColor, lineWidth, textAlign));
		}
		
		/*** @private */
		public function fillWords(words:Array, x:Number, y:Number, font:String, color:String):FillWordsCmd {
			return _saveToCmd(Render._context._fillWords, FillWordsCmd.create.call(this, words, x, y, font || Text.defaultFontStr(), color));
		}
		
		/*** @private */
		public function fillBorderWords(words:Array, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:int):FillBorderWordsCmd {
			return _saveToCmd(Render._context._fillBorderWords, FillBorderWordsCmd.create.call(this, words, x, y, font || Text.defaultFontStr(), fillColor, borderColor, lineWidth));
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
		public function strokeText(text:String, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):StrokeTextCmd {
			return _saveToCmd(Render._context._strokeText, StrokeTextCmd.create.call(this, text, x, y, font || Text.defaultFontStr(), color, lineWidth, textAlign));
		}
		
		/**
		 * 设置透明度。
		 * @param value 透明度。
		 */
		public function alpha(alpha:Number):AlphaCmd {
			return _saveToCmd(Render._context._alpha, AlphaCmd.create.call(this, alpha));
		}
		
		/**
		 * 替换绘图的当前转换矩阵。
		 * @param mat 矩阵。
		 * @param pivotX	（可选）水平方向轴心点坐标。
		 * @param pivotY	（可选）垂直方向轴心点坐标。
		 */
		public function transform(matrix:Matrix, pivotX:Number = 0, pivotY:Number = 0):TransformCmd {
			return _saveToCmd(Render._context._transform, TransformCmd.create.call(this, matrix, pivotX, pivotY));
		}
		
		/**
		 * 旋转当前绘图。(推荐使用transform，性能更高)
		 * @param angle		旋转角度，以弧度计。
		 * @param pivotX	（可选）水平方向轴心点坐标。
		 * @param pivotY	（可选）垂直方向轴心点坐标。
		 */
		public function rotate(angle:Number, pivotX:Number = 0, pivotY:Number = 0):RotateCmd {
			return _saveToCmd(Render._context._rotate, RotateCmd.create.call(this, angle, pivotX, pivotY));
		}
		
		/**
		 * 缩放当前绘图至更大或更小。(推荐使用transform，性能更高)
		 * @param scaleX	水平方向缩放值。
		 * @param scaleY	垂直方向缩放值。
		 * @param pivotX	（可选）水平方向轴心点坐标。
		 * @param pivotY	（可选）垂直方向轴心点坐标。
		 */
		public function scale(scaleX:Number, scaleY:Number, pivotX:Number = 0, pivotY:Number = 0):ScaleCmd {
			return _saveToCmd(Render._context._scale, ScaleCmd.create.call(this, scaleX, scaleY, pivotX, pivotY));
		}
		
		/**
		 * 重新映射画布上的 (0,0) 位置。
		 * @param x 添加到水平坐标（x）上的值。
		 * @param y 添加到垂直坐标（y）上的值。
		 */
		public function translate(tx:Number, ty:Number):TranslateCmd {
			return _saveToCmd(Render._context._translate, TranslateCmd.create.call(this, tx, ty));
		}
		
		/**
		 * 保存当前环境的状态。
		 */
		public function save():SaveCmd {
			return _saveToCmd(Render._context._save, SaveCmd.create.call(this));
		}
		
		/**
		 * 返回之前保存过的路径状态和属性。
		 */
		public function restore():RestoreCmd {
			return _saveToCmd(Render._context._restore, RestoreCmd.create.call(this));
		}
		
		/**
		 * @private
		 * 替换文本内容。
		 * @param text 文本内容。
		 * @return 替换成功则值为true，否则值为flase。
		 */
		public function replaceText(text:String):Boolean {
			_repaint();
			//todo 该函数现在加速器应该不对
			var cmds:Array = this._cmds;
			if (!cmds) {
				if (_one && _isTextCmd(_one)) {
					_one.text = text;
					return true;
				}
			} else {
				for (var i:int = cmds.length - 1; i > -1; i--) {
					if (_isTextCmd(cmds[i])) {
						cmds[i].text = text;
						return true;
					}
				}
			}
			return false;
		}
		
		/**@private */
		private function _isTextCmd(cmd:*):Boolean {
			var cmdID:String = cmd.cmdID;
			return cmdID == FillTextCmd.ID || cmdID == StrokeTextCmd.ID || cmdID == FillBorderTextCmd.ID;
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
				if (_one && _isTextCmd(_one)) {
					_setTextCmdColor(_one, color);
				}
			} else {
				for (var i:int = cmds.length - 1; i > -1; i--) {
					if (_isTextCmd(cmds[i])) {
						_setTextCmdColor(cmds[i], color);
					}
				}
			}
		}
		
		/**@private */
		private function _setTextCmdColor(cmdO:*, color:String):void {
			var cmdID:String = cmdO.cmdID;
			switch (cmdID) {
			case FillTextCmd.ID: 
			case StrokeTextCmd.ID: 
				cmdO.color = color;
				break;
			case FillBorderTextCmd.ID: 
			case FillBorderWordsCmd.ID: 
			case FillBorderTextCmd.ID: 
				cmdO.fillColor = color;
				break;
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
			if (!tex) {
				tex = new Texture();
				tex.load(url);
				Loader.cacheRes(url, tex);
				tex.once(Event.READY, this, drawImage, [tex, x, y, width, height]);
			} else {
				if (!tex.getIsReady()) {
					tex.once(Event.READY, this, drawImage, [tex, x, y, width, height]);
				} else
					drawImage(tex, x, y, width, height);
			}
			if (complete != null) {
				tex.getIsReady() ? complete.call(_sp) : tex.on(Event.READY, _sp, complete);
			}
		}
		
		/**
		 * @private
		 */
		public function _renderEmpty(sprite:Sprite, context:Context, x:Number, y:Number):void {
		}
		
		/**
		 * @private
		 */
		public function _renderAll(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var cmds:Array = this._cmds, cmd:*;
			for (var i:int = 0, n:int = cmds.length; i < n; i++) {
				(cmd = cmds[i]).run(context, x, y);
			}
		}
		
		/**
		 * @private
		 */
		public function _renderOne(sprite:Sprite, context:Context, x:Number, y:Number):void {
			_one.run(context, x, y);
		}
		
		/**
		 * @private
		 */
		public function _renderOneImg(sprite:Sprite, context:Context, x:Number, y:Number):void {
			_one.run(context, x, y);
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
		public function drawLine(fromX:Number, fromY:Number, toX:Number, toY:Number, lineColor:String, lineWidth:Number = 1):DrawLineCmd {
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			
			var offset:Number = (lineWidth < 1 || lineWidth % 2 === 0) ? 0 : 0.5;
			return _saveToCmd(Render._context._drawLine, DrawLineCmd.create.call(this, fromX + offset, fromY + offset, toX + offset, toY + offset, lineColor, lineWidth, tId));
		}
		
		/**
		 * 绘制一系列线段。
		 * @param x			开始绘制的X轴位置。
		 * @param y			开始绘制的Y轴位置。
		 * @param points	线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
		 * @param lineColor	线段颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）线段宽度。
		 */
		public function drawLines(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number = 1):DrawLinesCmd {
			var tId:uint = 0;
			if (!points || points.length < 4) return null;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			var offset:Number = (lineWidth < 1 || lineWidth % 2 === 0) ? 0 : 0.5;
			return _saveToCmd(Render._context._drawLines, DrawLinesCmd.create.call(this, x + offset, y + offset, points, lineColor, lineWidth, tId));
		}
		
		/**
		 * 绘制一系列曲线。
		 * @param x			开始绘制的 X 轴位置。
		 * @param y			开始绘制的 Y 轴位置。
		 * @param points	线段的点集合，格式[controlX, controlY, anchorX, anchorY...]。
		 * @param lineColor	线段颜色，或者填充绘图的渐变对象。
		 * @param lineWidth	（可选）线段宽度。
		 */
		public function drawCurves(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number = 1):DrawCurvesCmd {
			return _saveToCmd(Render._context._drawCurves, DrawCurvesCmd.create.call(this, x, y, points, lineColor, lineWidth));
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
		public function drawRect(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):DrawRectCmd {
			var offset:Number = (lineWidth >= 1 && lineColor) ? lineWidth / 2 : 0;
			var lineOffset:Number = lineColor ? lineWidth : 0;
			return _saveToCmd(Render._context.drawRect, DrawRectCmd.create.call(this, x + offset, y + offset, width - lineOffset, height - lineOffset, fillColor, lineColor, lineWidth));
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
		public function drawCircle(x:Number, y:Number, radius:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):DrawCircleCmd {
			var offset:Number = (lineWidth >= 1 && lineColor) ? lineWidth / 2 : 0;
			
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			return _saveToCmd(Render._context._drawCircle, DrawCircleCmd.create.call(this, x, y, radius - offset, fillColor, lineColor, lineWidth, tId));
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
		public function drawPie(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number, fillColor:*, lineColor:* = null, lineWidth:Number = 1):DrawPieCmd {
			var offset:Number = (lineWidth >= 1 && lineColor) ? lineWidth / 2 : 0;
			var lineOffset:Number = lineColor ? lineWidth : 0;
			
			var tId:uint = 0;
			if (Render.isWebGL) {
				tId = VectorGraphManager.getInstance().getId();
				if (_vectorgraphArray == null) _vectorgraphArray = [];
				_vectorgraphArray.push(tId);
			}
			return _saveToCmd(Render._context._drawPie, DrawPieCmd.create.call(this, x + offset, y + offset, radius - lineOffset, Utils.toRadian(startAngle), Utils.toRadian(endAngle), fillColor, lineColor, lineWidth, tId));
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
		public function drawPoly(x:Number, y:Number, points:Array, fillColor:*, lineColor:* = null, lineWidth:Number = 1):DrawPolyCmd {
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
			var offset:Number = (lineWidth >= 1 && lineColor) ? (lineWidth % 2 === 0 ? 0 : 0.5) : 0;
			return _saveToCmd(Render._context._drawPoly, DrawPolyCmd.create.call(this, x + offset, y + offset, points, fillColor, lineColor, lineWidth, tIsConvexPolygon, tId));
		}
		
		/**
		 * 绘制路径。
		 * @param x		开始绘制的 X 轴位置。
		 * @param y		开始绘制的 Y 轴位置。
		 * @param paths	路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		 * @param brush	（可选）刷子定义，支持以下设置{fillStyle:"#FF0000"}。
		 * @param pen	（可选）画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin:"bevel|round|miter",lineCap:"butt|round|square",miterLimit}。
		 */
		public function drawPath(x:Number, y:Number, paths:Array, brush:Object = null, pen:Object = null):DrawPathCmd {
			return _saveToCmd(Render._context._drawPath, DrawPathCmd.create.call(this, x, y, paths, brush, pen));
		}
	}
}