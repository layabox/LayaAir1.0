package laya.webgl.resource {
	import laya.maths.Arith;
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Utils;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.atlas.AtlasManager;
	import laya.webgl.text.DrawTextChar;
	
	/**
	 * ...
	 * @author
	 */
	public class WebGLCharImage extends Bitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _ctx:*;
		/**HTML Canvas，绘制字符载体,非私有数据载体*/
		public var canvas:*;
		/**字符*/
		public var char:DrawTextChar;
		/***是否创建WebGLTexture,值为false时不根据src创建私有WebGLTexture,同时销毁时也只清空source=null,不调用WebGL.mainContext.deleteTexture，目前只有大图合集用到,将HTML Image subImage到公共纹理上*/
		public var createOwnSource:Boolean;
		
		public const borderSize:int = 4;
		
		/**
		 * WebGLCharImage依赖于外部canvas,自身并无私有数据载体
		 * @param	canvas
		 * @param	char
		 */
		public function WebGLCharImage(canvas:*, char:DrawTextChar = null) {
			super();
			this.canvas = canvas;
			this.char = char;
			
			var bIsConchApp:Boolean = System.isConchApp;
			if (bIsConchApp) {
				__JS__("ctx = ConchTextCanvas;")
			} else {
				_ctx = canvas.getContext('2d', undefined);
			}
			
			var xs:Number = char.xs, ys:Number = char.ys;
			var t:* = null;
			if (bIsConchApp) {
				_ctx.font = char.font;
				t = _ctx.measureText(char.char);
				char.width = t.width1 * xs;
				char.height = t.height * ys;
			} else {
				t = Utils.measureText(char.char, char.font);
				char.width = t.width * xs;
				char.height = t.height * ys;
			}
			_w = char.width + borderSize * 2;
			_h = char.height + borderSize * 2;
		}
		
		private function size(w:Number, h:Number):void {
			_w = w;
			_h = h;
			canvas && (canvas.height = h, canvas.width = w);//canvas为公用，其它地方也可能修改其尺寸
		}
		
		override protected function recreateResource():void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var char:DrawTextChar = this.char;
			
			var bIsConchApp:Boolean = System.isConchApp;
			var xs:Number = char.xs, ys:Number = char.ys;
			size(char.width + borderSize * 2, char.height + borderSize * 2);
			
			if (bIsConchApp) {
				/*
				 *  参数说明：格式为	样式(normal、italic、oblique)	加粗	font-size	字体	borderSize	border颜色	DecorationLine(0代表没有 1下划线 2中划线 3上划线)	线的颜色
				 *  参数说明：格式为	normal 100 16px Arial 1 #ff0000 1 #00ff00
				 */
				var sFont:String = "normal 100 " + char.fontSize + "px Arial";
				if (char.borderColor) {
					sFont += " 1 " + char.borderColor;
				}
				_ctx.font = sFont;
				_ctx.textBaseline = "top";
				_ctx.fillStyle = char.fillColor;
				_ctx.fillText(char.char, borderSize, borderSize, null, null, null);
			} else {
				_ctx.save();
				(_ctx as Object).clearRect(0, 0, char.width + borderSize * 4, char.height + borderSize * 4);
				
				_ctx.font = char.font;
				
				_ctx.textBaseline = "top";
				if (xs != 1 || ys != 1) {
					alert("xs=" + xs + ",ys=" + ys);
					_ctx.scale(xs, ys);
				}
				
				_ctx.translate(borderSize, borderSize);
				
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
			super.recreateResource();
		}
		
		override public function copyTo(dec:Bitmap):void {
			var d:WebGLCharImage = dec as WebGLCharImage;
			d._ctx = _ctx;
			d.canvas = canvas;
			d.char = char;
			super.copyTo(dec);
		}
	}

}

