package laya.filters {
	
	/**
	 * @private
	 * <code>ColorFilterAction</code> 是一个颜色滤镜应用类。
	 */
	public class ColorFilterAction implements IFilterAction {
		public var data:ColorFilter;
		
		/**
		 * 创建一个 <code>ColorFilterAction</code> 实例。
		 */
		public function ColorFilterAction() {
		}
		
		/**
		 * 给指定的对象应用颜色滤镜。
		 * @param	srcCanvas 需要应用画布对象。
		 * @return 应用了滤镜后的画布对象。
		 */
		public function apply(srcCanvas:*):* {
			var ctx:* = srcCanvas.ctx.ctx;
			var canvas:* = srcCanvas.ctx.ctx.canvas;
			
			if (canvas.width == 0 || canvas.height == 0) return canvas;
			
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
			
			return srcCanvas;
		}
		
		private function getColor(red:int, green:int, blue:int, alpha:Number):Array {
			var rst:Array = [];
			
			if (data._mat && data._alpha) {
				var mat:Float32Array = data._mat;
				var tempAlpha:Float32Array = data._alpha;
				rst[0] = mat[0] * red + mat[1] * green + mat[2] * blue + mat[3] * alpha + tempAlpha[0];
				rst[1] = mat[4] * red + mat[5] * green + mat[6] * blue + mat[7] * alpha + tempAlpha[1];
				rst[2] = mat[8] * red + mat[9] * green + mat[10] * blue + mat[11] * alpha + tempAlpha[2];
				rst[3] = mat[12] * red + mat[13] * green + mat[14] * blue + mat[15] * alpha + tempAlpha[3];
			}
			return rst;
		}
	}
}