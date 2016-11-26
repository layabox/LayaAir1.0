package laya.d3.math {
	
	/**
	 * <code>Vector2</code> 类用于创建二维向量。
	 */
	public class Vector2 {
		/**零向量,禁止修改*/
		public static const ZERO:Vector2 = new Vector2(0.0, 0.0);
		/**一向量,禁止修改*/
		public static const ONE:Vector2 = new Vector2(1.0, 1.0);
		
		/**二维向量元素数组*/
		public var elements:* = new Float32Array(2);
		
		/**
		 * 获取X轴坐标。
		 * @return	x  X轴坐标。
		 */
		public function get x():Number {
			return this.elements[0];
		}
		
		/**
		 * 获取Y轴坐标。
		 * @return	y  Y轴坐标。
		 */
		public function get y():Number {
			return this.elements[1];
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
		 * 从一个克隆二维向量克隆。
		 * @param	v 源二维向量。
		 */
		public function clone(v:Vector2):void {
			var out:Float32Array = elements, s:Float32Array = v.elements;
			out[0] = s[0];
			out[1] = s[1];
		}
	
	}
}