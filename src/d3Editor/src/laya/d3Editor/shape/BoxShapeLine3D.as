package laya.d3Editor.shape {
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	/**
	 * ...
	 * @author 
	 */
	public class BoxShapeLine3D extends PixelLineSprite3D{
		
		private var color:Color = Color.GREEN;
		
		/** @private */
		private var _long:Number;
		/** @private */
		private var _width:Number;
		/** @private */
		private var _height:Number;
		
		/**
		 * 返回长度
		 * @return 长
		 */
		public function get long():Number {
			return _long;
		}
		
		/**
		 * 设置长度
		 * @param  value 长度
		 */
		public function set long(value:Number):void {
			if (_long !== value) {
				_long = value;
				reCreateShape();
			}
		}
		
		/**
		 * 返回宽度
		 * @return 宽
		 */
		public function get width():Number {
			return _width;
		}
		
		/**
		 * 设置宽度
		 * @param  value 宽度
		 */
		public function set width(value:Number):void {
			if (_width !== value) {
				_width = value;
				reCreateShape();
			}
		}
		
		/**
		 * 返回高度
		 * @return 高
		 */
		public function get height():Number {
			return _height;
		}
		
		/**
		 * 设置高度
		 * @param  value 高度
		 */
		public function set height(value:Number):void {
			if (_height !== value) {
				_height = value;
				reCreateShape();
			}
		}
		
		private var startPosition:Vector3 = new Vector3();
		private var endPosition:Vector3 = new Vector3();
		private function reCreateShape():void{
			
			var staPose:Float32Array = startPosition.elements;
			var endPose:Float32Array = endPosition.elements;
			
			//--------------------------------上---------------------------------------
			staPose[0] = -long/2;  staPose[1] = height/2;  staPose[2] = width/2;
			endPose[0] = -long/2;  endPose[1] = height/2;  endPose[2] = -width/2;
			setLine(0, startPosition, endPosition, color, color);
			
			staPose[0] = -long/2;  staPose[1] = height/2;  staPose[2] = -width/2;
			endPose[0] = long/2;  endPose[1] = height/2;  endPose[2] = -width/2;
			setLine(1, startPosition, endPosition, color, color);
			
			staPose[0] = long/2;  staPose[1] = height/2;  staPose[2] = -width/2;
			endPose[0] = long/2;  endPose[1] = height/2;  endPose[2] = width/2;
			setLine(2, startPosition, endPosition, color, color);
			
			staPose[0] = long/2;  staPose[1] = height/2;  staPose[2] = width/2;
			endPose[0] = -long/2;  endPose[1] = height/2;  endPose[2] = width/2;
			setLine(3, startPosition, endPosition, color, color);
			
			//--------------------------------底---------------------------------------
			staPose[0] = -long/2;  staPose[1] = -height/2;  staPose[2] = width/2;
			endPose[0] = -long/2;  endPose[1] = -height/2;  endPose[2] = -width/2;
			setLine(4, startPosition, endPosition, color, color);
			
			staPose[0] = -long/2;  staPose[1] = -height/2;  staPose[2] = -width/2;
			endPose[0] = long/2;  endPose[1] = -height/2;  endPose[2] = -width/2;
			setLine(5, startPosition, endPosition, color, color);
			
			staPose[0] = long/2;  staPose[1] = -height/2;  staPose[2] = -width/2;
			endPose[0] = long/2;  endPose[1] = -height/2;  endPose[2] = width/2;
			setLine(6, startPosition, endPosition, color, color);
			
			staPose[0] = long/2;  staPose[1] = -height/2;  staPose[2] = width/2;
			endPose[0] = -long/2;  endPose[1] = -height/2;  endPose[2] = width/2;
			setLine(7, startPosition, endPosition, color, color);
			
			//--------------------------------底---------------------------------------
			staPose[0] = -long/2;  staPose[1] = height/2;  staPose[2] = width/2;
			endPose[0] = -long/2;  endPose[1] = -height/2;  endPose[2] = width/2;
			setLine(8, startPosition, endPosition, color, color);
			
			staPose[0] = -long/2;  staPose[1] = height/2;  staPose[2] = -width/2;
			endPose[0] = -long/2;  endPose[1] = -height/2;  endPose[2] = -width/2;
			setLine(9, startPosition, endPosition, color, color);
			
			staPose[0] = long/2;  staPose[1] = height/2;  staPose[2] = -width/2;
			endPose[0] = long/2;  endPose[1] = -height/2;  endPose[2] = -width/2;
			setLine(10, startPosition, endPosition, color, color);
			
			staPose[0] = long/2;  staPose[1] = height/2;  staPose[2] = width/2;
			endPose[0] = long/2;  endPose[1] = -height/2;  endPose[2] = width/2;
			setLine(11, startPosition, endPosition, color, color);
		}
		
		public function BoxShapeLine3D(long:Number = 10, height:int = 10, width:Number = 10) {
			super(12);
			_long = long;
			_height = height;
			_width = width;
			reCreateShape();
		}
		
	}

}