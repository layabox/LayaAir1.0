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
			
			var point1e:Float32Array = point1.elements;
			var point2e:Float32Array = point2.elements;
			var point3e:Float32Array = point3.elements;
			
			var x1:Number = point2e[0] - point1e[0];
			var y1:Number = point2e[1] - point1e[1];
			var z1:Number = point2e[2] - point1e[2];
			var x2:Number = point3e[0] - point1e[0];
			var y2:Number = point3e[1] - point1e[1];
			var z2:Number = point3e[2] - point1e[2];
			var yz:Number = (y1 * z2) - (z1 * y2);
			var xz:Number = (z1 * x2) - (x1 * z2);
			var xy:Number = (x1 * y2) - (y1 * x2);
			var invPyth:Number = 1 / (Math.sqrt((yz * yz) + (xz * xz) + (xy * xy)));
			
			var x:Number = yz * invPyth;
			var y:Number = xz * invPyth;
			var z:Number = xy * invPyth;
			
			var TEMPVec3e:Float32Array = _TEMPVec3.elements;
			TEMPVec3e[0] = x;
			TEMPVec3e[1] = y;
			TEMPVec3e[2] = z;
			
			var d:Number = -((x * point1e[0]) + (y * point1e[1]) + (z * point1e[2]));
			
			var plane:Plane = new Plane(_TEMPVec3, d);
			return plane;
		}
		
		/**
		 * 更改平面法线向量的系数，使之成单位长度。
		 */
		public function normalize():void {
			var normalE:Float32Array = normal.elements;
			var normalEX:Number = normalE[0];
			var normalEY:Number = normalE[1];
			var normalEZ:Number = normalE[2];
			var magnitude:Number = 1 / Math.sqrt(normalEX * normalEX + normalEY * normalEY + normalEZ * normalEZ);
			
			normalE[0] = normalEX * magnitude;
			normalE[1] = normalEY * magnitude;
			normalE[2] = normalEZ * magnitude;
			
			distance *= magnitude;
		}
	
	}

}
