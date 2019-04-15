package laya.d3.math {
	
	/**
	 * <code>Plane</code> 类用于创建平面。
	 */
	public class Plane {
		
		/** @private */
		private static var _TEMPVec3:Vector3 = new Vector3();
		/**平面的向量*/
		public var normal:Vector3;
		/**平面到坐标系原点的距离*/
		public var distance:Number;
		/**平面与其他几何体相交类型*/
		public static var PlaneIntersectionType_Back:int = 0;
		public static var PlaneIntersectionType_Front:int = 1;
		public static var PlaneIntersectionType_Intersecting:int = 2;
		
		/**
		 * 创建一个 <code>Plane</code> 实例。
		 * @param	normal 平面的向量
		 * @param	d  平面到原点的距离
		 */
		public function Plane(normal:Vector3, d:Number = 0) {
			this.normal = normal;
			distance = d;
		}
		
		/**
		 * 创建一个 <code>Plane</code> 实例。
		 * @param	point1 第一点
		 * @param	point2 第二点
		 * @param	point3 第三点
		 */
		public static function createPlaneBy3P(point1:Vector3, point2:Vector3, point3:Vector3):Plane {
			var x1:Number = point2.x - point1.x;
			var y1:Number = point2.y - point1.y;
			var z1:Number = point2.z - point1.z;
			var x2:Number = point3.x - point1.x;
			var y2:Number = point3.y - point1.y;
			var z2:Number = point3.z - point1.z;
			var yz:Number = (y1 * z2) - (z1 * y2);
			var xz:Number = (z1 * x2) - (x1 * z2);
			var xy:Number = (x1 * y2) - (y1 * x2);
			var invPyth:Number = 1 / (Math.sqrt((yz * yz) + (xz * xz) + (xy * xy)));
			
			var x:Number = yz * invPyth;
			var y:Number = xz * invPyth;
			var z:Number = xy * invPyth;
			
			_TEMPVec3.x = x;
			_TEMPVec3.y = y;
			_TEMPVec3.z = z;
			
			var d:Number = -((x * point1.x) + (y * point1.y) + (z * point1.z));
			
			var plane:Plane = new Plane(_TEMPVec3, d);
			return plane;
		}
		
		/**
		 * 更改平面法线向量的系数，使之成单位长度。
		 */
		public function normalize():void {
			var normalEX:Number = normal.x;
			var normalEY:Number = normal.y;
			var normalEZ:Number = normal.z;
			var magnitude:Number = 1 / Math.sqrt(normalEX * normalEX + normalEY * normalEY + normalEZ * normalEZ);
			
			normal.x = normalEX * magnitude;
			normal.y = normalEY * magnitude;
			normal.z = normalEZ * magnitude;
			
			distance *= magnitude;
		}
	
	}

}
