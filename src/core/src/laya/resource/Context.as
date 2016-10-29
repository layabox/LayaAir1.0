package laya.resource {
	import laya.maths.Matrix;
	import laya.utils.HTMLChar;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * Context扩展类
	 */
	public dynamic class Context {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/*** @private */
		private static var _default:Context =/*[STATIC SAFE]*/ new Context();
		/*** @private */
		public var _canvas:HTMLCanvas;
		public var _repaint:Boolean = false;
		
		/*** @private */
		public static function __init__(to:*=null):void {			
			/*[IF-FLASH]*/ return;
			var from:* = Context.prototype;
			to = to || __JS__("CanvasRenderingContext2D.prototype");
			
			to.__fillText = to.fillText;
			to.__fillRect = to.fillRect;
			to.__strokeText = to.strokeText;
			var funs:Array = ['drawTextures','fillWords','setIsMainContext','fillRect', 'strokeText', 'fillText', 'transformByMatrix', 'setTransformByMatrix', 'clipRect', 'drawTexture', 'drawTexture2', 'drawTextureWithTransform', 'flush', 'clear', 'destroy', 'drawCanvas', 'fillBorderText'];
			funs.forEach(function(i:String):void {
				to[i] = from[i] || to[i];
			});
		}
		
		public function setIsMainContext():void
		{
		}
		
		/*[IF-FLASH-BEGIN]*/
		/*** @private */
		public function set font(str:String):void {
		}
		
		/*** @private */
		public function set textBaseline(value:String):void {
		}
		
		/*** @private */
		public function set fillStyle(value:*):void {
		}
		
		/*** @private */
		public function translate(x:Number, y:Number):void {
		}
		
		/*** @private */
		public function scale(scaleX:Number, scaleY:Number):void {
		}
		
		/*** @private */
		public function drawImage(... args):void {
		}
		
		/*** @private */
		public function getImageData(... args):* {
		}
		
		/*** @private */
		public function measureText(text:String):* {
			return null;
		}
		
		/*** @private */
		public function setTransform(... args):void {
		}
		
		/*** @private */
		public function beginPath():void {
		}
		
		/*** @private */
		public function set strokeStyle(value:*):void {
		}
		
		/*** @private */
		public function get globalCompositeOperation():String {
			return null;
		}
		
		public function set globalCompositeOperation(value:String):void {
		}
		
		/*** @private */
		public function rect(x:Number, y:Number, width:Number, height:Number):void {
		}
		
		/*** @private */
		public function stroke():void {
		}
		
		/*** @private */
		public function transform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {
		}
		
		/*** @private */
		public function save():void {
		}
		
		/*** @private */
		public function restore():void {
		}
		
		/*** @private */
		public function clip():void {
		}
		
		/*** @private */
		public function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, r:Number):void {
		}
		
		/*** @private */
		public function quadraticCurveTo(cpx:Number, cpy:Number, x:Number, y:Number):void {
		}
		
		/*** @private */
		public function get lineJoin():String {
			return null;
		}
		
		/*** @private */
		public function set lineJoin(value:String):void {
		}
		
		/*** @private */
		public function get lineCap():String {
			return null;
		}
		
		/*** @private */
		public function set lineCap(value:String):void {
		}
		
		/*** @private */
		public function get miterLimit():String {
			return null;
		}
		
		/*** @private */
		public function set miterLimit(value:String):void {
		}
		
		/*** @private */
		public function get globalAlpha():Number {
			return 0;
		}
		
		/*** @private */
		public function set globalAlpha(value:Number):void {
		}
		
		/*** @private */
		public function clearRect(x:Number, y:Number, width:Number, height:Number):void {
		}
		
		/*[IF-FLASH-END]*/
		
		public function drawTextures(tex:Texture, pos:Array, tx:Number, ty:Number):void
		{
			Stat.drawCall += pos.length / 2;
			var w:Number = tex.bitmap.width;
			var h:Number = tex.bitmap.height;		
			for (var i:int = 0, sz:int = pos.length; i < sz; i += 2)
			{
				drawTexture(tex, pos[i], pos[i + 1], w, h, tx, ty);
			}
		}
		
		/*** @private */
		public function drawCanvas(canvas:HTMLCanvas, x:Number, y:Number, width:Number, height:Number):void {
			Stat.drawCall++;
			this.drawImage(canvas.source, x, y, width, height);
		}
		
		/*** @private */
		public function fillRect(x:Number, y:Number, width:Number, height:Number, style:*):void {
			Stat.drawCall++;
			style && (this.fillStyle = style);
			__JS__("this.__fillRect(x, y,width,height)");
		}
		
		/*** @private */
		public function fillText(text:*, x:Number, y:Number, font:String, color:String, textAlign:String):void {
			Stat.drawCall++;
			if (arguments.length > 3 && font != null) {
				this.font = font;
				this.fillStyle = color;
				__JS__("this.textAlign = textAlign");
				this.textBaseline = "top";
			}
			__JS__("this.__fillText(text, x, y)");
		}
		
		/*** @private */
		public function fillBorderText(text:*, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			Stat.drawCall++;
			
			this.font = font;
			this.fillStyle = fillColor;
			this.textBaseline = "top";
			
			__JS__("this.strokeStyle = borderColor");
			__JS__("this.lineWidth = lineWidth");
			__JS__("this.textAlign = textAlign");
			__JS__("this.__strokeText(text, x, y)");
			__JS__("this.__fillText(text, x, y)");
		
		}
		
		/*** @private */
		public function strokeText(text:*, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			Stat.drawCall++;
			if (arguments.length > 3 && font != null) {
				this.font = font;
				__JS__("this.strokeStyle = color");
				__JS__("this.lineWidth = lineWidth");
				__JS__("this.textAlign = textAlign");
				this.textBaseline = "top";
			}
			__JS__("this.__strokeText(text, x, y)");
		}
		
		/*** @private */
		public function transformByMatrix(value:Matrix):void {
			this.transform(value.a, value.b, value.c, value.d, value.tx, value.ty);
		}
		
		/*** @private */
		public function setTransformByMatrix(value:Matrix):void {
			this.setTransform(value.a, value.b, value.c, value.d, value.tx, value.ty);
		}
		
		/*** @private */
		public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			Stat.drawCall++;
			this.beginPath();
			//this.strokeStyle = "red";
			this.rect(x, y, width, height);
			//this.stroke();
			this.clip();
		}
		
		/*** @private */
		public function drawTexture(tex:Texture, x:Number, y:Number, width:Number, height:Number, tx:Number, ty:Number):void {
			Stat.drawCall++;
			var uv:Array = tex.uv, w:Number = tex.bitmap.width, h:Number = tex.bitmap.height;
			this.drawImage(tex.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, x + tx, y + ty, width, height);
		}
		
		/*** @private */
		public function drawTextureWithTransform(tex:Texture, x:Number, y:Number, width:Number, height:Number, m:Matrix, tx:Number, ty:Number,alpha:Number):void {
			Stat.drawCall++;
			var uv:Array = tex.uv, w:Number = tex.bitmap.width, h:Number = tex.bitmap.height;
			this.save();
			alpha != 1 && (this.globalAlpha *= alpha);
			if (m) {
				this.transform(m.a, m.b, m.c, m.d, m.tx + tx, m.ty + ty);
				this.drawImage(tex.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, x , y, width, height);
			}else {
				this.drawImage(tex.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, x+tx , y+ty, width, height);
			}			
			this.restore();
		}
		
		/*** @private */
		public function drawTexture2(x:Number, y:Number, pivotX:Number, pivotY:Number, m:Matrix, alpha:Number, blendMode:String, args2:Array):void {
			'use strict';
			var tex:Texture = args2[0];
			if (!(tex.loaded && tex.bitmap && tex.source))//source内调用tex.active();
			{
				return;
			}
			Stat.drawCall++;
			//TODO:blendMode
			var alphaChanged:Boolean = alpha !== 1;
			if (alphaChanged) {
				var temp:Number = this.globalAlpha;
				this.globalAlpha *= alpha;
			}
			

			var uv:Array = tex.uv, w:Number = tex.bitmap.width, h:Number = tex.bitmap.height;
			if (m) {
				this.save();
				this.transform(m.a, m.b, m.c, m.d, m.tx + x, m.ty + y);
				//this.drawTexture(args2[0], args2[1] - pivotX + x, args2[2] - pivotY + y, args2[3], args2[4], args2[5], 0, 0);
				this.drawImage(tex.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, args2[1] - pivotX , args2[2] - pivotY, args2[3], args2[4]);
				this.restore();
			} else {
				//this.drawTexture(args2[0], args2[1] - pivotX + x, args2[2] - pivotY + y, args2[3], args2[4], args2[5], 0, 0);
				this.drawImage(tex.source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, args2[1] - pivotX + x , args2[2] - pivotY + y, args2[3], args2[4]);
			}
			if (alphaChanged) this.globalAlpha = temp;
		}
		
		/*** @private */
		public function flush():int {
			return 0;
		}
		
		/*** @private */
		public function fillWords(words:Vector.<HTMLChar>, x:Number, y:Number, font:String, color:String):void {
			font && (this.font = font);
			color && (this.fillStyle = color);
			var _this:* = this;
			this.textBaseline = "top";
			__JS__("this.textAlign = 'left'");
			for (var i:int = 0, n:int = words.length; i < n; i++) {
				var a:* = words[i];
				__JS__("this.__fillText(a.char, a.x + x, a.y + y)");
			}
		}
		
		/*** @private */
		public function destroy():void {
			__JS__("this.canvas.width = this.canvas.height = 0");
		}
		
		/*** @private */
		public function clear():void {
			this.clearRect(0, 0, _canvas.width, _canvas.height);
			_repaint = false;
		}
	}
}