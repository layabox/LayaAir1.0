package laya.d3Editor.shape 
{
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	
	/**
	 * 圆锥
	 * @author zyh
	 */
	public class ConeShapeLine3D extends PixelLineSprite3D 
	{
		
		/** @private */
		private var _radius:Number;
		/** @private */
		private var _height:Number;
		
		private var color:Color = Color.GREEN;
		
		public function ConeShapeLine3D(radius:Number = 0.5, height:Number = 1) 
		{
			super(68);
			_radius = radius;
			_height = height < radius * 2 ? radius * 2 : height;
			reCreateShape();
		}
		
		/**
		 * 返回半径
		 * @return 半径
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * 设置半径（改变此属性会重新生成顶点和索引）
		 * @param  value 半径
		 */
		public function set radius(value:Number):void {
			if (_radius !== value) {
				_radius = value;
				reCreateShape();
			}
		}
		
		/**
		 * 返回高度
		 * @return 高度
		 */
		public function get height():Number {
			return _height;
		}
		
		/**
		 * 设置高度（改变此属性会重新生成顶点和索引）
		 * @param  value 高度
		 */
		public function set height(value:Number):void {
			if (_height !== value) {
				_height = value;
				reCreateShape();
			}
		}
		
		private function reCreateShape():void 
		{
			var perAngle:Number = (Math.PI * 2.0) / 63;
			var curAngle:Number = 0;
			var _h:Number = this.height / 2;
			var lasePosition:Vector3 = new Vector3(0, _h, 0);
			var curPosition:Vector3 = new Vector3(0, -_h, this.radius);
			this.setLine(0, lasePosition, curPosition, color, color);
		
			curPosition = new Vector3(this.radius, -_h, 0);
			this.setLine(1, lasePosition, curPosition, color, color);

			curPosition = new Vector3( -this.radius, -_h, 0);
			this.setLine(2, lasePosition, curPosition, color, color);
			
			curPosition = new Vector3(0, -_h, -this.radius);
			this.setLine(3, lasePosition, curPosition, color, color);
			
			lasePosition = new Vector3(radius, -_h , 0);
			for (var i:int = 0; i < 64; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = -_h ;
				curPosition.z = Math.sin(curAngle) * radius;
				setLine(4 + i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
		}
		
	}

}