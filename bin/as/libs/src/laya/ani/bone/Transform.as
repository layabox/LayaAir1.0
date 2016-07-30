package laya.ani.bone {
	import laya.maths.Matrix;
	
	/**
	 * @private
	 */
	public class Transform {
		
		public var skX:Number = 0;
		public var skY:Number = 0;
		public var scX:Number = 1;
		public var scY:Number = 1;
		public var x:Number = 0;
		public var y:Number = 0;
		private var mMatrix:Matrix;
		
		public function initData(data:*):void {
			if (data.x != undefined) {
				x = data.x;
			}
			if (data.y != undefined) {
				y = data.y;
			}
			if (data.skX != undefined) {
				skX = data.skX;
			}
			if (data.skY != undefined) {
				skY = data.skY;
			}
			if (data.scX != undefined) {
				scX = data.scX;
			}
			if (data.scY != undefined) {
				scY = data.scY;
			}
		}
		
		public function getMatrix():Matrix {
			var tMatrix:Matrix;
			if (mMatrix) {
				tMatrix = mMatrix;
			} else {
				tMatrix = mMatrix = new Matrix();
			}
			tMatrix.a = Math.cos(skY);
			if (skX != 0 || skY != 0) {
				var tAngle:Number = skX * Math.PI / 180;
				var cos:Number = Math.cos(tAngle), sin:Number = Math.sin(tAngle);
				tMatrix.setTo(scX * cos, scX * sin, scY * -sin, scY * cos, x, y);
			} else {
				tMatrix.setTo(scX, skX, skY, scY, x, y);
			}
			return tMatrix;
		}
	}
}