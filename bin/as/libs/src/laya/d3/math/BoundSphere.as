package laya.d3.math {
	import laya.d3.core.IClone;
	
	/**
	 * <code>BoundSphere</code> 类用于创建包围球。
	 */
	public class BoundSphere implements IClone {
		private static var _tempVector3:Vector3 = new Vector3();
		
		/**包围球的中心。*/
		public var center:Vector3;
		/**包围球的半径。*/
		public var radius:Number;
		
		/**
		 * 创建一个 <code>BoundSphere</code> 实例。
		 * @param	center 包围球的中心。
		 * @param	radius 包围球的半径。
		 */
		public function BoundSphere(center:Vector3, radius:Number) {
			this.center = center;
			this.radius = radius;
		}
		
		public function toDefault():void {
			center.toDefault();
			radius = 0;
		}
		
		/**
		 * 从顶点的子队列生成包围球。
		 * @param	points 顶点的队列。
		 * @param	start 顶点子队列的起始偏移。
		 * @param	count 顶点子队列的顶点数。
		 * @param	result 生成的包围球。
		 */
		public static function createFromSubPoints(points:Vector.<Vector3>, start:int, count:int, out:BoundSphere):void {
			if (points == null) {
				throw new Error("points");
			}
			
			// Check that start is in the correct range 
			if (start < 0 || start >= points.length) {
				throw new Error("start" + start + "Must be in the range [0, " + (points.length - 1) + "]");
			}
			
			// Check that count is in the correct range 
			if (count < 0 || (start + count) > points.length) {
				throw new Error("count" + count + "Must be in the range <= " + points.length + "}");
			}
			
			var upperEnd:int = start + count;
			
			//Find the center of all points. 
			var center:Vector3 = _tempVector3;
			center.elements[0] = 0;
			center.elements[1] = 0;
			center.elements[2] = 0;
			for (var i:int = start; i < upperEnd; ++i) {
				Vector3.add(points[i], center, center);
			}
			
			var outCenter:Vector3 = out.center;
			//This is the center of our sphere. 
			Vector3.scale(center, 1 / count, outCenter);
			
			//Find the radius of the sphere 
			var radius:Number = 0.0;
			for (i = start; i < upperEnd; ++i) {
				//We are doing a relative distance comparison to find the maximum distance 
				//from the center of our sphere. 
				var distance:Number = Vector3.distanceSquared(outCenter, points[i]);
				
				if (distance > radius)
					radius = distance;
			}
			
			//Find the real distance from the DistanceSquared. 
			out.radius = Math.sqrt(radius);
		}
		
		/**
		 * 从顶点队列生成包围球。
		 * @param	points 顶点的队列。
		 * @param	result 生成的包围球。
		 */
		public static function createfromPoints(points:Vector.<Vector3>, out:BoundSphere):void {
			if (points == null) {
				throw new Error("points");
			}
			
			createFromSubPoints(points, 0, points.length, out);
		}
		
		/**
		 * 判断射线是否与碰撞球交叉，并返回交叉距离。
		 * @param	ray 射线。
		 * @return 距离交叉点的距离，-1表示不交叉。
		 */
		public function intersectsRayDistance(ray:Ray):Number {
			return Collision.intersectsRayAndSphereRD(ray, this);
		}
		
		/**
		 * 判断射线是否与碰撞球交叉，并返回交叉点。
		 * @param	ray  射线。
		 * @param	outPoint 交叉点。
		 * @return  距离交叉点的距离，-1表示不交叉。
		 */
		public function intersectsRayPoint(ray:Ray, outPoint:Vector3):Number {
			return Collision.intersectsRayAndSphereRP(ray, this, outPoint);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:BoundSphere = destObject as BoundSphere;
			center.cloneTo(dest.center);
			dest.radius = radius;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:BoundSphere = __JS__("new this.constructor(new Vector3(),new Vector3())");
			cloneTo(dest);
			return dest;
		}
	
	}
}