package laya.webgl.resource {
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.utils.Utils;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.text.DrawTextChar;
	
	public class WebGLCharImage extends Bitmap implements IMergeAtlasBitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private const borderSize:int = 12;
		private var _ctx:*;
		/***是否创建私有Source*/
		private var _allowMerageInAtlas:Boolean;
		/**是否允许加入大图合集*/
		private var _enableMerageInAtlas:Boolean;
		/**HTML Canvas，绘制字符载体,非私有数据载体*/
		public var canvas:*;
		/**字符*/
		public var char:DrawTextChar;
		
		public function get atlasSource():* {
			return canvas;
		}
		
		/**
		 * 是否创建私有Source
		 * @return 是否创建
		 */
		public function get allowMerageInAtlas():Boolean {
			return _allowMerageInAtlas;
		}
		
		/**
		 * 是否创建私有Source
		 * @return 是否创建
		 */
		public function get enableMerageInAtlas():Boolean {
			return _enableMerageInAtlas;
		}
		
		/**
		 * 是否创建私有Source,通常禁止修改
		 * @param value 是否创建
		 */
		public function set enableMerageInAtlas(value:Boolean):void {
			_enableMerageInAtlas = value;
		}
		
		/**
		 * WebGLCharImage依赖于外部canvas,自身并无私有数据载体
		 * @param	canvas
		 * @param	char
		 */
		public function WebGLCharImage(canvas:*, char:DrawTextChar = null) {
			super();
			this.canvas = canvas;
			this.char = char;
			_enableMerageInAtlas = true;
			
			var bIsConchApp:Boolean = Render.isConchApp;
			if (bIsConchApp) {
				__JS__("this._ctx = canvas;")
			} else {
				_ctx = canvas.getContext('2d', undefined);
			}
			
			var xs:Number = char.xs, ys:Number = char.ys;
			var t:* = null;
			if (bIsConchApp) {
				_ctx.font = char.font;
				t = _ctx.measureText(char.char);
				char.width = t.width * xs;
				char.height = t.height * ys;
			} else {
				t = Utils.measureText(char.char, char.font);
				char.width = t.width * xs;
				char.height = t.height * ys;
			}
			onresize(char.width + borderSize * 2, char.height + borderSize * 2);
		}
		
		override protected function recreateResource():void {
			startCreate();
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var char:DrawTextChar = this.char;
			
			var bIsConchApp:Boolean = Render.isConchApp;
			var xs:Number = char.xs, ys:Number = char.ys;
			onresize(char.width + borderSize * 2, char.height + borderSize * 2);
			canvas && (canvas.height = _h, canvas.width = _w);//canvas为公用，其它地方也可能修改其尺寸
			if (bIsConchApp) {
				/*
				 *  参数说明：格式为	样式(normal、italic、oblique)	加粗	font-size	字体	borderSize	border颜色	DecorationLine(0代表没有 1下划线 2中划线 3上划线)	线的颜色
				 *  参数说明：格式为	normal 100 16px Arial 1 #ff0000 1 #00ff00
				 */
				var nFontSize:int = char.fontSize;
				if (xs != 1 || ys != 1) {
					//TODO先凑合一下，回头再把scale信息传入到C++
					nFontSize = parseInt(nFontSize * ((xs > ys) ? xs : ys) + "");
				}
				var sFont:String = "normal 100 " + nFontSize + "px Arial";
				if (char.borderColor) {
					sFont += " 1 " + char.borderColor;
				}
				_ctx.font = sFont;
				_ctx.textBaseline = "top";
				_ctx.fillStyle = char.fillColor;
				_ctx.fillText(char.char, borderSize, borderSize, null, null, null);
			} else {
				_ctx.save();
				(_ctx as Object).clearRect(0, 0, char.width + borderSize * 2, char.height + borderSize * 2);
				
				_ctx.font = char.font;
				
				_ctx.textBaseline = "top";
				_ctx.translate(borderSize, borderSize);
				if (xs != 1 || ys != 1) {
					_ctx.scale(xs, ys);
				}
				
				if (char.fillColor && char.borderColor) {
					__JS__("this._ctx.strokeStyle = char.borderColor");
					__JS__("this._ctx.lineWidth = char.lineWidth");
					_ctx.strokeText(char.char, 0, 0, null, null, 0, null);
					_ctx.fillStyle = char.fillColor;
					_ctx.fillText(char.char, 0, 0, null, null, null);
				} else {
					if (char.lineWidth === -1) {
						_ctx.fillStyle = char.fillColor ? char.fillColor : "white";
						_ctx.fillText(char.char, 0, 0, null, null, null);
					} else {
						__JS__("this._ctx.strokeStyle = char.borderColor?char.borderColor:'white'");
						__JS__("this._ctx.lineWidth = char.lineWidth");
						_ctx.strokeText(char.char, 0, 0, null, null, 0, null);
					}
				}
				
				_ctx.restore();
			}
			
			char.borderSize = borderSize;
			completeCreate();
		}
		
		private function onresize(w:Number, h:Number):void {
			_w = w;
			_h = h;
			
			if ((_w < AtlasResourceManager.atlasLimitWidth && _h < AtlasResourceManager.atlasLimitHeight)) {//文字强制加入大图合集
				_allowMerageInAtlas = true
			} else {
				_allowMerageInAtlas = false;
				throw new Error("文字尺寸超出大图合集限制！");
			}
		}
		
		public function clearAtlasSource():void {//canvas为公用绘制载体,资源恢复时会使用,无需清空
		}
	}

}

