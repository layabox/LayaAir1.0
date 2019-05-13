package laya.d3.math {
	import laya.d3.core.IClone;
	import laya.renders.Render;
	
	/**
	 * <code>Vector2</code> 类用于创建二维向量。
	 */
	public class Vector2 implements IClone {
		/**零向量,禁止修改*/
		public static const ZERO:Vector2 = new Vector2(0.0, 0.0);
		/**一向量,禁止修改*/
		public static const ONE:Vector2 = new Vector2(1.0, 1.0);
		
		/**X轴坐标*/
		public var x:Number;
		/**Y轴坐标*/
		public var y:Number;
		
		/**
		 * 创建一个 <code>Vector2</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 */
		public function Vector2(x:Number = 0, y:Number = 0) {
			this.x = x;
			this.y = y;
		}
		/**
		 * 设置xy值。
		 * @param	x X值。
		 * @param	y Y值。
		 */
		public function setValue(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 缩放二维向量。
		 * @param	a 源二维向量。
		 * @param	b 缩放值。
		 * @param	out 输出二维向量。
		 */
		public static function scale(a:Vector2, b:Number, out:Vector2):void {
			out.x = a.x * b;
			out.y = a.y * b;
		}
		
		/**
		 * 从Array数组拷贝值。
		 * @param  array 数组。
		 * @param  offset 数组偏移。
		 */
		public function fromArray(array:Array, offset:int = 0):void {
			x = array[offset + 0];
			y = array[offset + 1];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector2:Vector2 = destObject as Vector2;
			destVector2.x = x;
			destVector2.y = y;
		}
		
		/**
		 * 求两个二维向量的点积。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @return   点积。
		 */
		public static function dot(a:Vector2, b:Vector2):Number {
			return (a.x * b.x) + (a.y * b.y);
		}
		
		/**
		 * 归一化二维向量。
		 * @param	s 源三维向量。
		 * @param	out 输出三维向量。
		 */
		public static function normalize(s:Vector2, out:Vector2):void {
			var x:Number = s.x, y:Number = s.y;
			var len:Number = x * x + y * y;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				out.x = x * len;
				out.y = y * len;
			}
		}
		
		/**
		 * 计算标量长度。
		 * @param	a 源三维向量。
		 * @return 标量长度。
		 */
		public static function scalarLength(a:Vector2):Number {
			var x:Number = a.x, y:Number = a.y;
			return Math.sqrt(x * x + y * y);
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
		
		public function forNativeElement(nativeElements:Float32Array = null):void
		{		
			if (nativeElements)
			{
				__JS__("this.elements = nativeElements");
				__JS__("this.elements[0] = this.x");
				__JS__("this.elements[1] = this.y");
			}
			else
			{
				__JS__("this.elements = new Float32Array([this.x,this.y])");
			}
			rewriteNumProperty(this, "x", 0);
			rewriteNumProperty(this, "y", 1);
		}
		
		public static function rewriteNumProperty(proto:*, name:String,index:int):void
		{		
			Object["defineProperty"](proto, name, {
				"get":function():* {
					return __JS__("this.elements[index]");
				},
				"set":function(v:*):void {
					__JS__("this.elements[index] = v");
				}
			});
		}
	
	}
}