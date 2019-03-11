package laya.d3.math {
	import laya.d3.core.IClone;
	
	/**
	 * <code>Color</code> 类用于创建颜色实例。
	 */
	public class Color implements IClone {
		/**
		 * 红色
		 */
		public static const RED:Color = new Color(1, 0, 0, 1);
		/**
		 * 绿色
		 */
		public static const GREEN:Color = new Color(0, 1, 0, 1);
		/**
		 * 蓝色
		 */
		public static const BLUE:Color = new Color(0, 0, 1, 1);
		/**
		 * 蓝绿色
		 */
		public static const CYAN:Color = new Color(0, 1, 1, 1);
		/**
		 * 黄色
		 */
		public static const YELLOW:Color = new Color(1, 0.92, 0.016, 1);
		/**
		 * 品红色
		 */
		public static const MAGENTA:Color = new Color(1, 0, 1, 1);
		/**
		 * 灰色
		 */
		public static const GRAY:Color = new Color(0.5, 0.5, 0.5, 1);
		/**
		 * 白色
		 */
		public static const WHITE:Color = new Color(1, 1, 1, 1);
		/**
		 * 黑色
		 */
		public static const BLACK:Color = new Color(0, 0, 0, 1);
		
		/**[只读]向量元素集合。*/
		public var elements:Float32Array;
		
		/**
		 * 获取red分量。
		 * @return  red分量。
		 */
		public function get r():Number {
			return this.elements[0];
		}
		
		/**
		 * 设置red分量。
		 * @param value red分量。
		 */
		public function set r(value:Number):void {
			this.elements[0] = value;
		}
		
		/**
		 * 获取green分量。
		 * @return	green分量。
		 */
		public function get g():Number {
			return this.elements[1];
		}
		
		/**
		 * 设置green分量。
		 * @param	value  green分量。
		 */
		public function set g(value:Number):void {
			this.elements[1] = value;
		}
		
		/**
		 * 获取blue分量。
		 * @return	 blue分量。
		 */
		public function get b():Number {
			return this.elements[2];
		}
		
		/**
		 * 设置blue分量。
		 * @param	value  blue分量。
		 */
		public function set b(value:Number):void {
			this.elements[2] = value;
		}
		
		/**
		 * 获取alpha分量。
		 * @return	alpha分量。
		 */
		public function get a():Number {
			return this.elements[3];
		}
		
		/**
		 * 设置alpha分量。
		 * @param value	alpha分量。
		 */
		public function set a(value:Number):void {
			this.elements[3] = value;
		}
		
		/**
		 * 创建一个 <code>Color</code> 实例。
		 * @param	r  颜色的red分量。
		 * @param	g  颜色的green分量。
		 * @param	b  颜色的blue分量。
		 * @param	a  颜色的alpha分量。
		 */
		public function Color(r:Number = 1, g:Number = 1, b:Number = 1, a:Number = 1) {
			var v:Float32Array = elements = new Float32Array(4);
			v[0] = r;
			v[1] = g;
			v[2] = b;
			v[3] = a;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destColor:Color = destObject as Color;
			var destE:Float32Array = destColor.elements;
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
			var dest:Color = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	
	}

}