package laya.webgl.resource { 
	public class CharRender_Canvas extends ICharRender {
		private static var canvas:*= null;// HTMLCanvasElement;
		private var ctx:*= null;
		private var lastScaleX:Number = 1.0;
		private var lastScaleY:Number = 1.0;
		private var needResetScale:Boolean = false;
		private var maxTexW:int = 0;
		private var maxTexH:int = 0;
		private var scaleFontSize:Boolean = true;
		private var showDbgInfo:Boolean = false;
		private var supportImageData:Boolean = true;
		public function  CharRender_Canvas(maxw:int, maxh:int, scalefont:Boolean=true, useImageData:Boolean=true, showdbg:Boolean=false):void {
			maxTexW = maxw;
			maxTexH = maxh;
			scaleFontSize = scalefont;
			supportImageData = useImageData;
			showDbgInfo = showdbg;
			if (!canvas) {
				canvas = window.document.createElement('canvas');
				canvas.width = 1024;
				canvas.height = 512;
				//这个canvas是用来获取字体渲染结果的。由于不可见canvas的字体不能小于12，所以要加到body上
				//为了避免被发现，设一个在屏幕外的绝对位置。
				canvas.style.left = "-10000px";
				canvas.style.position = "absolute";        
				__JS__("document.body.appendChild(CharRender_Canvas.canvas);");
				ctx = canvas.getContext('2d');
			}
		}
		
		override public function get canvasWidth():int {
			return canvas.width;
		}
		
		override public function set canvasWidth(w:int):void {
			if (canvas.width == w )
				return;
			canvas.width = w;
			if (w > 2048) {
				console.warn("画文字设置的宽度太大，超过2048了");
			}
			// 重新恢复一下缩放
			ctx.setTransform(1, 0, 0, 1, 0, 0);	// 强制清理缩放			
			ctx.scale(lastScaleX, lastScaleY);
		}
		
		
		public override function getWidth(font:String, str:String):Number {
			if (!ctx) return 0;
			//由于大家公用一个canvas，所以需要在选中的时候做一些配置。
			if(ctx._lastFont!=font){
				ctx.font = font;
				ctx._lastFont = font;
				//console.log('use font ' + font);
			}					
			return ctx.measureText(str).width;
		}
		
		public override function scale(sx:Number, sy:Number):void {
			if ( !supportImageData ) {// supportImageData==false表示用 getCharCanvas，这个自己管理缩放
				lastScaleX = sx;
				lastScaleY = sy;
				return;
			}
			
			if (lastScaleX != sx || lastScaleY != sy ) {
				ctx.setTransform(sx, 0, 0, sy, 0, 0);	// 强制清理缩放			
				lastScaleX = sx;
				lastScaleY = sy;
			}
		}
		
		/**
		 *TODO stroke 
		 * @param	char
		 * @param	font
		 * @param	cri  修改里面的width。
		 * @return
		 */
		public override function getCharBmp( char:String, font:String, lineWidth:int, colStr:String, strokeColStr:String, cri:CharRenderInfo, 
				margin_left:int, margin_top:int, margin_right:int, margin_bottom:int, rect:Array=null):ImageData {
			if (!supportImageData)
				return getCharCanvas(char, font, lineWidth, colStr, strokeColStr, cri, margin_left, margin_top, margin_right, margin_bottom);
			var ctx:* = this.ctx;
				
			//ctx.save();
			//由于大家公用一个canvas，所以需要在选中的时候做一些配置。
			//跟_lastFont比较容易出错，所以比较ctx.font
			if (ctx.font !=font){// ctx._lastFont != font) {	问题：ctx.font=xx 然后ctx==xx可能返回false，例如可能会给自己加"",当字体有空格的时候
				ctx.font = font;
				ctx._lastFont = font;
				//console.log('use font ' + font);
			}			
			
			cri.width = ctx.measureText(char).width;//排版用的width是没有缩放的。后面会用矩阵缩放
			var w:int = cri.width *lastScaleX;//w h 只是clear用的。所以要缩放
			var h:int = cri.height*lastScaleY ;
			w += (margin_left + margin_right)*lastScaleX;
			h += (margin_top + margin_bottom) * lastScaleY;
			w = Math.ceil(w);
			h = Math.ceil(h);
			w = Math.min(w,CharRender_Canvas.canvas.width);
			h = Math.min(h,CharRender_Canvas.canvas.height);
			
			var clearW:int = w + lineWidth * 2 + 1;
			var clearH:int = h + lineWidth * 2 + 1;
			if (rect) {// measureText可能会小于请求的区域。 rect[2]可能为-1
				clearW = Math.max(clearW, rect[0] + rect[2] + 1);
				clearH = Math.max(clearH, rect[1] + rect[3] + 1);
			}
			ctx.clearRect(0, 0, clearW, clearH);
			ctx.save();
			//ctx.textAlign = "end";
			ctx.textBaseline = "top";
			//ctx.translate(CborderSize, CborderSize);
			//ctx.scale(xs, ys);
			if (lineWidth > 0) { 
				ctx.strokeStyle = strokeColStr;
				ctx.lineWidth = lineWidth;
				ctx.strokeText(char, margin_left, margin_top);
			}
			ctx.fillStyle = colStr;
			ctx.fillText(char, margin_left, margin_top);
		
			if ( showDbgInfo) {
				ctx.strokeStyle = '#ff0000';
				ctx.strokeRect(0, 0, w, h);
				ctx.strokeStyle = '#00ff00';
				ctx.strokeRect(margin_left, margin_top, cri.width, cri.height);//原始大小，没有缩放的
			}
			//ctx.restore();
			if (rect) {
				if (rect[2] ==-1) rect[2] = Math.ceil((cri.width+lineWidth*2) * lastScaleX); // 这个没有考虑左右margin
			}
			var imgdt:ImageData = rect?(ctx.getImageData( rect[0], rect[1], rect[2], rect[3] )):(ctx.getImageData( 0, 0, w, h ));
			ctx.restore();
			cri.bmpWidth = imgdt.width;
			cri.bmpHeight = imgdt.height;
			return imgdt;
		}
		
		public function getCharCanvas( char:String, font:String, lineWidth:int, colStr:String, strokeColStr:String, cri:CharRenderInfo, margin_left:int, margin_top:int, margin_right:int, margin_bottom:int):ImageData {
			var ctx:* = this.ctx;
			
			//ctx.save();
			//由于大家公用一个canvas，所以需要在选中的时候做一些配置。
			//跟_lastFont比较容易出错，所以比较ctx.font
			if (ctx.font !=font){// ctx._lastFont != font) {	问题：ctx.font=xx 然后ctx==xx可能返回false，例如可能会给自己加"",当字体有空格的时候
				ctx.font = font;
				ctx._lastFont = font;
				//console.log('use font ' + font);
			}			
			
			cri.width = ctx.measureText(char).width;//排版用的width是没有缩放的。后面会用矩阵缩放
			var w:int = cri.width *lastScaleX;//w h 只是clear用的。所以要缩放
			var h:int = cri.height*lastScaleY ;
			w += (margin_left + margin_right)*lastScaleX;
			h += ((margin_top + margin_bottom) * lastScaleY+1);	// 这个+1只是为了让测试能通过。确实应该加点高度，否则会被裁掉一部分，但是加多少还没找到方法。
			w=Math.min(w,maxTexW);
			h=Math.min(h,maxTexH);
			
			//if (canvas.width != (w + 1) || canvas.height != (h + 1)) {
				canvas.width = Math.min(w + 1, maxTexW);
				canvas.height = Math.min(h + 1,maxTexH);
				ctx.font = font;
			//}
			ctx.clearRect(0, 0, w + 1+lineWidth, h + 1+lineWidth);
			ctx.setTransform(1, 0, 0, 1, 0, 0);	// 强制清理缩放
			ctx.save();
			if (scaleFontSize) {
				//这里的缩放会导致与上面的缩放同时起作用。所以上面保护
				ctx.scale(lastScaleX, lastScaleY);
			}
			ctx.translate(margin_left, margin_top);
			ctx.textAlign = "left";
			ctx.textBaseline = "top";
			//ctx.translate(CborderSize, CborderSize);
			//ctx.scale(xs, ys);
			if (lineWidth > 0) { 
				ctx.strokeStyle = strokeColStr;
				ctx.fillStyle = colStr;
				ctx.lineWidth = lineWidth;
				//ctx.strokeText(char, margin_left, margin_top);
				if (ctx.fillAndStrokeText)
				{
					ctx.fillAndStrokeText(char, 0, 0);
				}else
				{
					ctx.strokeText(char, 0, 0);
					ctx.fillText(char, 0, 0);
				}		
			} else {
				ctx.fillStyle = colStr;
				ctx.fillText(char, 0, 0);
			}
			if ( showDbgInfo) {
				ctx.strokeStyle = '#ff0000';
				ctx.strokeRect(0, 0, w, h);
				ctx.strokeStyle = '#00ff00';
				ctx.strokeRect(0, 0, cri.width, cri.height);//原始大小，没有缩放的
			}
			ctx.restore();
			cri.bmpWidth = canvas.width;
			cri.bmpHeight = canvas.height;
			return canvas;
		}
	}
}