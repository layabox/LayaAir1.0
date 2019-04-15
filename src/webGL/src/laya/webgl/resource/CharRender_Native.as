package laya.webgl.resource { 
	import laya.utils.ColorUtils;
	public class CharRender_Native extends ICharRender{
		private var lastFont:String = '';
		//TODO:coverage
		public function  CharRender_Native():void {
		}
		
		//TODO:coverage
		public override function getWidth(font:String, str:String):Number {
			if (!window.conchTextCanvas) return 0;
			//TODO 先取消判断，保证字体信息一致
			//if (lastFont != font) { 
				window.conchTextCanvas.font	= font;
				lastFont = font;
				//console.log('use font ' + font);
			//}					
			//getTextBitmapData
			return window.conchTextCanvas.measureText(str).width;
		}
		
		public override function scale(sx:Number, sy:Number):void {
			
		}
		/**
		 *TODO stroke 
		 * @param	char
		 * @param	font
		 * @param	size  返回宽高
		 * @return
		 */
		//TODO:coverage
		public override function getCharBmp( char:String, font:String, lineWidth:int, colStr:String, strokeColStr:String, size:CharRenderInfo, 
				margin_left:int, margin_top:int, margin_right:int, margin_bottom:int, rect:Array=null):ImageData {

			if (!window.conchTextCanvas) return null;
			//window.conchTextCanvas.getTextBitmapData();
			
			//TODO 先取消判断，保证字体信息一致
			//if(lastFont!=font){
				window.conchTextCanvas.font	= font;
				lastFont = font;
			//}						
			var w:int = size.width = window.conchTextCanvas.measureText(char).width;
			var h:int = size.height ;
			w += (margin_left + margin_right);
			h += (margin_top + margin_bottom);
			var c1:ColorUtils = ColorUtils.create(strokeColStr);
			var nStrokeColor:uint = c1.numColor;
			var c2:ColorUtils = ColorUtils.create(colStr);
			var nTextColor:uint = c2.numColor;
			var textInfo:* = window.conchTextCanvas.getTextBitmapData(char, nTextColor, lineWidth>2?2:lineWidth, nStrokeColor);
			//window.Laya.LayaGL.instance.texSubImage2D(1,2,0,0,textInfo.width,textInfo.height,0,0,textInfo.bitmapData);
			//var ret = new ImageData();
			size.bmpWidth = textInfo.width;
			size.bmpHeight = textInfo.height;
			return textInfo;
			/*
			ctx.clearRect(0,0, w, h);
			//ctx.textAlign = "end";
			ctx.textBaseline = "top";
			if (lineWidth > 0) { 
				ctx.strokeStyle = colStr;
				ctx.lineWidth = lineWidth;
				ctx.strokeText(char, margin_left, margin_top);
			} else {
				ctx.fillStyle = colStr;
				ctx.fillText(char, margin_left, margin_top);
			}
			if ( CharBook.debug) {
				ctx.strokeStyle = '#ff0000';
				ctx.strokeRect(0, 0, w, h);
				ctx.strokeStyle = '#00ff00';
				ctx.strokeRect(margin_left, margin_top, size.width, size.height);
			}
			//ctx.restore();
			return ctx.getImageData( 0,0, w, h );
			*/
		}
	}
}