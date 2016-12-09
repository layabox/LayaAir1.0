package laya.d3.math {
	import laya.d3.core.IClone;
	import laya.d3.core.material.StandardMaterial;
	
	/**
	 * <code>Vector4</code> 类用于创建四维向量。
	 */
	public class Vector4 implements IClone{
		/**零向量，禁止修改*/
		public static var ZERO:Vector4 = new Vector4();
		
		/**
		 * 插值四维向量。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @param	t 插值比例。
		 * @param	out 输出向量。
		 */
		public static function lerp(a:Vector4, b:Vector4, t:Number, out:Vector4):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3];
			e[0] = ax + t * (g[0] - ax);
			e[1] = ay + t * (g[1] - ay);
			e[2] = az + t * (g[2] - az);
			e[3] = aw + t * (g[3] - aw);
		}
		
		/**四维向量元素数组*/
		public var elements:* = new Float32Array(4);
		
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
		 * 获取Z轴坐标。
		 * @return	z  Z轴坐标。
		 */
		public function get z():Number {
			return this.elements[2];
		}
		
		/**
		 * 获取W轴坐标。
		 * @return	w  W轴坐标。
		 */
		public function get w():Number {
			return this.elements[3];
		}
		
		/**
		 * 创建一个 <code>Vector4</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 * @param	z  Z轴坐标。
		 * @param	w  W轴坐标。
		 */
		public function Vector4(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0) {
			var v:Float32Array = elements;
			v[0] = x;
			v[1] = y;
			v[2] = z;
			v[3] = w;
		}
		
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector4:Vector4 = destObject as Vector4;
			var destE:Float32Array = destVector4.elements;
			var s:Float32Array = this.elements;
			destE[0] = s[0];
			destE[1] = s[1];
			destE[2] = s[2];
			destE[3] = s[3];
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destVector4:Vector4 = __JS__("new this.constructor()");
			cloneTo(destVector4);
			return destVector4;
		}
		
		
	
	}
}