package laya.d3.math {
	import laya.d3.core.IClone;
	
	/**
	 * <code>Vector2</code> 类用于创建二维向量。
	 */
	public class Vector2 implements IClone {
		/**零向量,禁止修改*/
		public static const ZERO:Vector2 = new Vector2(0.0, 0.0);
		/**一向量,禁止修改*/
		public static const ONE:Vector2 = new Vector2(1.0, 1.0);
		
		/**二维向量元素数组*/
		public var elements:* = new Float32Array(2);
		
		/**
		 * 获取X轴坐标。
		 * @return	X轴坐标。
		 */
		public function get x():Number {
			return this.elements[0];
		}
		
		/**
		 * 设置X轴坐标。
		 * @param value X轴坐标。
		 */
		public function set x(value:Number):void {
			this.elements[0] = value;
		}
		
		/**
		 * 获取Y轴坐标。
		 * @return Y轴坐标。
		 */
		public function get y():Number {
			return this.elements[1];
		}
		
		/**
		 * 设置Y轴坐标。
		 * @param value Y轴坐标。
		 */
		public function set y(value:Number):void {
			this.elements[1] = value;
		}
		
		/**
		 * 创建一个 <code>Vector2</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 */
		public function Vector2(x:Number = 0, y:Number = 0) {
			var v:Float32Array = elements;
			v[0] = x;
			v[1] = y;
		}
		
		/**
		 * 缩放二维向量。
		 * @param	a 源二维向量。
		 * @param	b 缩放值。
		 * @param	out 输出二维向量。
		 */
		public static function scale(a:Vector2, b:Number, out:Vector2):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			e[0] = f[0] * b;
			e[1] = f[1] * b;
		}
		
		/**
		 * 从Array数组拷贝值。
		 * @param  array 数组。
		 * @param  offset 数组偏移。
		 */
		public function fromArray(array:Array, offset:int = 0):void {
			elements[0] = array[offset + 0];
			elements[1] = array[offset + 1];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector2:Vector2 = destObject as Vector2;
			var destE:Float32Array = destVector2.elements;
			var s:Float32Array = this.elements;
			destE[0] = s[0];
			destE[1] = s[1];
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destVector2:Vector2 = __JS__("new this.constructor()");
			cloneTo(destVector2);
			return destVector2;
		}
	
	}
}