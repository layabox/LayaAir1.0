package laya.d3Editor.shape {
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	/**
	 * ...
	 * @author 
	 */
	public class CapsuleShapeLine3D  extends PixelLineSprite3D{
		
		private var color:Color = Color.GREEN;
		
		/** @private */
		private var _radius:Number;
		/** @private */
		private var _height:Number;
		
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
		
		private function reCreateShape():void{
			var lasePosition:Vector3;
			var i:int;
			
			//-----------------------------------x--------------------------------
			var perAngle:Number = (Math.PI * 2.0) / 63;
			var curAngle:Number = 0;
			lasePosition = new Vector3(0, (height - radius * 2) / 2, radius);
			var curPosition:Vector3 = new Vector3();
			for (i = 0; i < 32; i++) {
				curAngle = i * perAngle;
				curPosition.x = 0;
				curPosition.y = Math.sin(curAngle) * radius + (height - radius * 2) / 2;
				curPosition.z = Math.cos(curAngle) * radius;
				setLine(i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			curPosition = new Vector3(0, - (height - radius * 2) / 2, -radius); 
			setLine(32, lasePosition, curPosition, color, color);
			curPosition.cloneTo(lasePosition);
			
			for (i = 0; i < 32; i++) {
				curAngle = i * perAngle;
				curPosition.x = 0;
				curPosition.y = Math.sin(Math.PI + curAngle) * radius - (height - radius * 2) / 2;
				curPosition.z = Math.cos(Math.PI + curAngle) * radius;
				setLine(33 + i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			curPosition = new Vector3(0, (height - radius * 2) / 2, radius); 
			setLine(65, lasePosition, curPosition, color, color);
			
			//-----------------------------------z--------------------------------
			lasePosition = new Vector3(radius, (height - radius * 2) / 2, 0);
			for (i = 0; i < 32; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = Math.sin(curAngle) * radius + (height - radius * 2) / 2;
				curPosition.z = 0;
				setLine(i + 66, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			curPosition = new Vector3(-radius, - (height - radius * 2) / 2, 0); 
			setLine(98, lasePosition, curPosition, color, color);
			curPosition.cloneTo(lasePosition);
			
			for (i = 0; i < 32; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(Math.PI + curAngle) * radius;
				curPosition.y = Math.sin(Math.PI + curAngle) * radius - (height - radius * 2) / 2;
				curPosition.z = 0;
				setLine(99 + i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			curPosition = new Vector3(radius, (height - radius * 2) / 2, 0); 
			setLine(131, lasePosition, curPosition, color, color);
			
			//----------------------------y1--------------------------------
			lasePosition = new Vector3(radius, (height - radius * 2) / 2, 0);
			for (i = 0; i < 64; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = (height - radius * 2) / 2;
				curPosition.z = Math.sin(curAngle) * radius;
				setLine(132 + i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
			
			//----------------------------y2--------------------------------
			lasePosition = new Vector3(radius, -(height - radius * 2) / 2, 0);
			for (i = 0; i < 64; i++) {
				curAngle = i * perAngle;
				curPosition.x = Math.cos(curAngle) * radius;
				curPosition.y = -(height - radius * 2) / 2;
				curPosition.z = Math.sin(curAngle) * radius;
				setLine(196 + i, lasePosition, curPosition, color, color);
				curPosition.cloneTo(lasePosition);
			}
		}
		
		public function CapsuleShapeLine3D(radius:Number = 0.5, height:Number = 2) {
			
			super(260);
			_radius = radius;
			_height = height < radius * 2 ? radius * 2 : height;
			reCreateShape();
		}
		
	}

}