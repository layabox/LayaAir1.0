package laya.filters {
	
	public class ColorFilterAction implements IFilterAction {
		private var data:ColorFilter
		
		public function ColorFilterAction() {
		}
		
		public function apply(srcCanvas:*):* {
			var ctx:* = srcCanvas.ctx.ctx;
			var canvas:* = srcCanvas.ctx.ctx.canvas;
			
			if (canvas.width == 0 || canvas.height == 0) return canvas;
			//以下注释代码为带偏移的画布预备
			
			//			canvas.height=srcCanvas.height;
			//			canvas.width=srcCanvas.width;
			//			ctx.drawImage(srcCanvas,0,0);
			
			//          var sx:Number;
			//			var sy:Number;
			//			var w:Number;
			//			var h:Number;
			//			sx = canvas.clientLeft;
			//			sy = canvas.clientTop;
			//			w = canvas.clientWidth;
			//			h = canvas.clientHeight;
			//			var imgdata=ctx.getImageData(sx,sy,w,h);
			
			var imgdata:* = ctx.getImageData(0, 0, canvas.width, canvas.height);
			
			var data:Array = imgdata.data;
			var nData:Array;
			for (var i:int = 0, n:int = data.length; i < n; i += 4) {
				nData = getColor(data[i], data[i + 1], data[i + 2], data[i + 3]);
				
				//空白像素不计算
				if (data[i + 3] == 0) continue;
				//if((data[i+3]==0)||(data[i]==0)&&(data[i+1]==0)&&(data[i+2]==0)) continue;
				//if((data[i+3]==0)&&(data[i]==0)&&(data[i+1]==0)&&(data[i+2]==0)) continue;
				
				data[i] = nData[0];
				data[i + 1] = nData[1];
				data[i + 2] = nData[2];
				data[i + 3] = nData[3];
			}
			ctx.putImageData(imgdata, 0, 0);
			//ctx.putImageData(imgdata,sx,sy);
			return srcCanvas;
		}
		
		private function getColor(red:int, green:int, blue:int, alpha:Number):Array {
			var rst:Array = [];
			
			if (data._elements) {
				var a:Float32Array = data._elements;
				rst[0] = a[0] * red + a[1] * green + a[2] * blue + a[3] * alpha + a[4];
				rst[1] = a[5] * red + a[6] * green + a[7] * blue + a[8] * alpha + a[9];
				rst[2] = a[10] * red + a[11] * green + a[12] * blue + a[13] * alpha + a[14];
				rst[3] = a[15] * red + a[16] * green + a[17] * blue + a[18] * alpha + a[19];
			}
			return rst;
		}
	}
}