package laya.d3.math {
	
	/**
	 * <code>Collision</code> 类用于检测碰撞。
	 */
	public class Collision {
		
		/** @private */
		private static var _tempV30:Vector3 = new Vector3();
		/** @private */
		private static var _tempV31:Vector3 = new Vector3();
		/** @private */
		private static var _tempV32:Vector3 = new Vector3();
		/** @private */
		private static var _tempV33:Vector3 = new Vector3();
		/** @private */
		private static var _tempV34:Vector3 = new Vector3();
		/** @private */
		private static var _tempV35:Vector3 = new Vector3();
		/** @private */
		private static var _tempV36:Vector3 = new Vector3();
		
		
		/**
		 * 创建一个 <code>Collision</code> 实例。
		 */
		public function Collision() {
		
		}
		
		
		/**
		 * 空间中点到平面的距离
		 * @param	plane 平面
		 * @param	point 点
		 */
		public static function distancePlaneToPoint(plane:Plane, point:Vector3):Number {
			
			var dot:Number = Vector3.dot(plane.normal, point);
			return dot - plane.distance;
		}
		
		/**
		 * 空间中点到包围盒的距离
		 * @param	box 包围盒
		 * @param	point 点
		 */
		public static function distanceBoxToPoint(box:BoundBox, point:Vector3):Number {
			
			var boxMine:Float32Array = box.min.elements;
			var boxMineX:Number = boxMine[0];
			var boxMineY:Number = boxMine[1];
			var boxMineZ:Number = boxMine[2];
			
			var boxMaxe:Float32Array = box.max.elements;
			var boxMaxeX:Number = boxMaxe[0];
			var boxMaxeY:Number = boxMaxe[1];
			var boxMaxeZ:Number = boxMaxe[2];
			
			var pointe:Float32Array = point.elements;
			var pointeX:Number = pointe[0];
			var pointeY:Number = pointe[1];
			var pointeZ:Number = pointe[2];
			
			var distance:Number = 0;
			
			if (pointeX < boxMineX)
				distance += (boxMineX - pointeX) * (boxMineX - pointeX);
			if (pointeX > boxMaxeX)
				distance += (boxMaxeX - pointeX) * (boxMaxeX - pointeX);
			
			if (pointeY < boxMineY)
				distance += (boxMineY - pointeY) * (boxMineY - pointeY);
			if (pointeY > boxMaxeY)
				distance += (boxMaxeY - pointeY) * (boxMaxeY - pointeY);
			
			if (pointeZ < boxMineZ)
				distance += (boxMineZ - pointeZ) * (boxMineZ - pointeZ);
			if (pointeZ > boxMaxeZ)
				distance += (boxMaxeZ - pointeZ) * (boxMaxeZ - pointeZ);
			
			return Math.sqrt(distance);
		}
		
		/**
		 * 空间中包围盒到包围盒的距离
		 * @param	box1 包围盒1
		 * @param	box2 包围盒2
		 */
		public static function distanceBoxToBox(box1:BoundBox, box2:BoundBox):Number {
			
			var box1Mine:Float32Array = box1.min.elements;
			var box1MineX:Number = box1Mine[0];
			var box1MineY:Number = box1Mine[1];
			var box1MineZ:Number = box1Mine[2];
			
			var box1Maxe:Float32Array = box1.max.elements;
			var box1MaxeX:Number = box1Maxe[0];
			var box1MaxeY:Number = box1Maxe[1];
			var box1MaxeZ:Number = box1Maxe[2];
			
			var box2Mine:Float32Array = box2.min.elements;
			var box2MineX:Number = box2Mine[0];
			var box2MineY:Number = box2Mine[1];
			var box2MineZ:Number = box2Mine[2];
			
			var box2Maxe:Float32Array = box2.max.elements;
			var box2MaxeX:Number = box2Maxe[0];
			var box2MaxeY:Number = box2Maxe[1];
			var box2MaxeZ:Number = box2Maxe[2];
			
			var distance:Number = 0;
			var delta:Number;
			
			if (box1MineX > box2MaxeX) {
				
				delta = box1MineX - box2MaxeX;
				distance += delta * delta;
			} else if (box2MineX > box1MaxeX) {
				
				delta = box2MineX - box1MaxeX;
				distance += delta * delta;
			}
			
			if (box1MineY > box2MaxeY) {
				
				delta = box1MineY - box2MaxeY;
				distance += delta * delta;
			} else if (box2MineY > box1MaxeY) {
				
				delta = box2MineY - box1MaxeY;
				distance += delta * delta;
			}
			
			if (box1MineZ > box2MaxeZ) {
				
				delta = box1MineZ - box2MaxeZ;
				distance += delta * delta;
			} else if (box2MineZ > box1MaxeZ) {
				
				delta = box2MineZ - box1MaxeZ;
				distance += delta * delta;
			}
			
			return Math.sqrt(distance);
		}
		
		/**
		 * 空间中点到包围球的距离
		 * @param	sphere 包围球
		 * @param	point  点
		 */
		public static function distanceSphereToPoint(sphere:BoundSphere, point:Vector3):Number {
			
			var distance:Number = Math.sqrt(Vector3.distanceSquared(sphere.center, point));
			distance -= sphere.radius;
			
			return Math.max(distance, 0);
		}
		
		/**
		 * 空间中包围球到包围球的距离
		 * @param	sphere1 包围球1
		 * @param	sphere2 包围球2
		 */
		public static function distanceSphereToSphere(sphere1:BoundSphere, sphere2:BoundSphere):Number {
			
			var distance:Number = Math.sqrt(Vector3.distanceSquared(sphere1.center, sphere2.center));
			distance -= sphere1.radius + sphere2.radius;
			
			return Math.max(distance, 0);
		}
		
		
		/**
		 * 空间中射线和三角面是否相交,输出距离
		 * @param	ray 射线
		 * @param	vertex1 三角面顶点1
		 * @param	vertex2	三角面顶点2
		 * @param	vertex3 三角面顶点3
		 * @param	out 点和三角面的距离
		 * @return  是否相交
		 */
		public static function intersectsRayAndTriangleRD(ray:Ray, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3, out:Number):Boolean{
			
			var rayO:Vector3 = ray.origin;
			var rayOe:Float32Array = rayO.elements;
			var rayOeX:Number = rayOe[0];
			var rayOeY:Number = rayOe[1];
			var rayOeZ:Number = rayOe[2];
			
			var rayD:Vector3 = ray.direction;
			var rayDe:Float32Array = rayD.elements;
			var rayDeX:Number = rayDe[0];
			var rayDeY:Number = rayDe[1];
			var rayDeZ:Number = rayDe[2];
			
			var v1e:Float32Array = vertex1.elements;
			var v1eX:Number = v1e[0];
			var v1eY:Number = v1e[1];
			var v1eZ:Number = v1e[2];
			
			var v2e:Float32Array = vertex2.elements;
			var v2eX:Number = v2e[0];
			var v2eY:Number = v2e[1];
			var v2eZ:Number = v2e[2];
			
			var v3e:Float32Array = vertex3.elements;
			var v3eX:Number = v3e[0];
			var v3eY:Number = v3e[1];
			var v3eZ:Number = v3e[2];
			
			var _tempV30e:Float32Array = _tempV30.elements;
			var _tempV30eX:Number = _tempV30e[0];
			var _tempV30eY:Number = _tempV30e[1];
			var _tempV30eZ:Number = _tempV30e[2];
			
			_tempV30eX = v2eX - v1eX;
			_tempV30eY = v2eY - v1eY;
			_tempV30eZ = v2eZ - v1eZ;
			
			var _tempV31e:Float32Array = _tempV31.elements;
			var _tempV31eX:Number = _tempV31e[0];
			var _tempV31eY:Number = _tempV31e[1];
			var _tempV31eZ:Number = _tempV31e[2];
			
			_tempV31eX = v3eX - v1eX;
			_tempV31eY = v3eY - v1eY;
			_tempV31eZ = v3eZ - v1eZ;
			
			var _tempV32e:Float32Array = _tempV32.elements;
			var _tempV32eX:Number = _tempV32e[0];
			var _tempV32eY:Number = _tempV32e[1];
			var _tempV32eZ:Number = _tempV32e[2];
			
			_tempV32eX = (rayDeY * _tempV31eZ) - (rayDeZ * _tempV31eY);
            _tempV32eY = (rayDeZ * _tempV31eX) - (rayDeX * _tempV31eZ);
            _tempV32eZ = (rayDeX * _tempV31eY) - (rayDeY * _tempV31eX);
			
			var determinant:Number = (_tempV30eX * _tempV32eX) + (_tempV30eY * _tempV32eY) + (_tempV30eZ * _tempV32eZ);
			
			if (MathUtils3D.isZero(determinant)){
				
				out = 0;
				return false;
			}
			
			var inversedeterminant:Number = 1 / determinant;
			
			var _tempV33e:Float32Array = _tempV33.elements;
			var _tempV33eX:Number = _tempV33e[0];
			var _tempV33eY:Number = _tempV33e[1];
			var _tempV33eZ:Number = _tempV33e[2];
			
			_tempV33eX = rayOeX - v1eX;
			_tempV33eY = rayOeY - v1eY;
			_tempV33eZ = rayOeZ - v1eZ;
			
			var triangleU:Number = (_tempV33eX * _tempV32eX) + (_tempV33eY * _tempV32eY) + (_tempV33eZ * _tempV32eZ);
			triangleU *= inversedeterminant;
			
			if (triangleU < 0 || triangleU > 1){
				
				out = 0;
				return false;
			}
			
			var _tempV34e:Float32Array = _tempV34.elements;
			var _tempV34eX:Number = _tempV34e[0];
			var _tempV34eY:Number = _tempV34e[1];
			var _tempV34eZ:Number = _tempV34e[2];
			
			_tempV34eX = (_tempV33eY * _tempV30eZ) - (_tempV33eZ * _tempV30eY);
			_tempV34eY = (_tempV33eZ * _tempV30eX) - (_tempV33eX * _tempV30eZ);
			_tempV34eZ = (_tempV33eX * _tempV30eY) - (_tempV33eY * _tempV30eX);
			
			var triangleV:Number = ((rayDeX * _tempV34eX) + (rayDeY * _tempV34eY)) + (rayDeZ * _tempV34eZ);
			triangleV *= inversedeterminant;
			
			if (triangleV < 0 || triangleU + triangleV > 1){
				
				out = 0;
				return false;
			}
			
			var raydistance:Number = (_tempV31eX * _tempV34eX) + (_tempV31eY * _tempV34eY) + (_tempV31eZ * _tempV34eZ);
			raydistance *= inversedeterminant;
			
			if (raydistance < 0){
				
				out = 0;
				return false;
			}
			
			out = raydistance;
			return true;
		}
		
		/**
		 * 空间中射线和三角面是否相交,输出相交点
		 * @param	ray 射线
		 * @param	vertex1 三角面顶点1
		 * @param	vertex2	三角面顶点2
		 * @param	vertex3 三角面顶点3
		 * @param	out 相交点
		 * @return  是否相交
		 */
		public static function intersectsRayAndTriangleRP(ray:Ray, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3, out:Vector3):Boolean{
			
			var distance:Number;
			if (!intersectsRayAndTriangleRD(ray, vertex1, vertex2, vertex3, distance)){
				
				out = Vector3.ZERO;
				return false;
			}
			
			Vector3.scale(ray.direction, distance, _tempV30);
			Vector3.add(ray.origin, _tempV30, out);
			return true;
		}
		
		/**
		 * 空间中射线和点是否相交
		 * @param	sphere1 包围球1
		 * @param	sphere2 包围球2
		 */
		public static function intersectsRayAndPoint(ray:Ray, point:Vector3):Boolean {
			
			Vector3.subtract(ray.origin, point, _tempV30);
			
			var b:Number = Vector3.dot(_tempV30, ray.direction);
			var c:Number = Vector3.dot(_tempV30, _tempV30) - MathUtils3D.zeroTolerance;
			
			if (c > 0 && b > 0)
				return false;
			var discriminant:Number = b * b - c;
			if (discriminant < 0)
				return false;
			return true;
		}
		
		/**
		 * 空间中射线和射线是否相交
		 * @param	ray1 射线1
		 * @param	ray2 射线2
		 * @param	out 相交点
		 */
		public static function intersectsRayAndRay(ray1:Ray, ray2:Ray, out:Vector3):Boolean {
			
			var ray1o:Vector3 = ray1.origin;
			var ray1oe:Float32Array = ray1o.elements;
			var ray1oeX:Number = ray1oe[0];
			var ray1oeY:Number = ray1oe[1];
			var ray1oeZ:Number = ray1oe[2];
			
			var ray1d:Vector3 = ray1.direction;
			var ray1de:Float32Array = ray1d.elements;
			var ray1deX:Number = ray1de[0];
			var ray1deY:Number = ray1de[1];
			var ray1deZ:Number = ray1de[2];
			
			var ray2o:Vector3 = ray2.origin;
			var ray2oe:Float32Array = ray2o.elements;
			var ray2oeX:Number = ray2oe[0];
			var ray2oeY:Number = ray2oe[1];
			var ray2oeZ:Number = ray2oe[2];
			
			var ray2d:Vector3 = ray2.direction;
			var ray2de:Float32Array = ray2d.elements;
			var ray2deX:Number = ray2de[0];
			var ray2deY:Number = ray2de[1];
			var ray2deZ:Number = ray2de[2];
			
			Vector3.cross(ray1d, ray2d, _tempV30);
			var tempV3e:Float32Array = _tempV30.elements;
			var denominator:Number = Vector3.scalarLength(_tempV30);
			
			if (MathUtils3D.isZero(denominator)) {
				
				if (MathUtils3D.nearEqual(ray2oeX, ray1oeX) && MathUtils3D.nearEqual(ray2oeY, ray1oeY) && MathUtils3D.nearEqual(ray2oeZ, ray1oeZ)) {
					out = Vector3.ZERO;
					return true;
				}
			}
			
			denominator = denominator * denominator;
			
			var m11:Number = ray2oeX - ray1oeX;
			var m12:Number = ray2oeY - ray1oeY;
			var m13:Number = ray2oeZ - ray1oeZ;
			var m21:Number = ray2deX;
			var m22:Number = ray2deY;
			var m23:Number = ray2deZ;
			var m31:Number = tempV3e[0];
			var m32:Number = tempV3e[1];
			var m33:Number = tempV3e[2];
			
			var dets:Number = m11 * m22 * m33 + m12 * m23 * m31 + m13 * m21 * m32 - m11 * m23 * m32 - m12 * m21 * m33 - m13 * m22 * m31;
			
			m21 = ray1deX;
			m22 = ray1deY;
			m23 = ray1deZ;
			
			var dett:Number = m11 * m22 * m33 + m12 * m23 * m31 + m13 * m21 * m32 - m11 * m23 * m32 - m12 * m21 * m33 - m13 * m22 * m31;
			
			var s:Number = dets / denominator;
			var t:Number = dett / denominator;
			
			Vector3.scale(ray1d, s, _tempV30);
			Vector3.scale(ray2d, s, _tempV31);
			
			Vector3.add(ray1o, _tempV30, _tempV32);
			Vector3.add(ray2o, _tempV31, _tempV33);
			
			var point1e:Float32Array = _tempV32.elements;
			var point2e:Float32Array = _tempV33.elements;
			
			if (!MathUtils3D.nearEqual(point2e[0], point1e[0]) || !MathUtils3D.nearEqual(point2e[1], point1e[1]) || !MathUtils3D.nearEqual(point2e[2], point1e[2])) {
				out = Vector3.ZERO;
				return false;
			}
			
			out = _tempV32;
			return true;
		}
		
		/**
		 * 空间中平面和三角面是否相交
		 * @param	plane 平面
		 * @param	vertex1 三角面顶点1
		 * @param	vertex2 三角面顶点2
		 * @param	vertex3 三角面顶点3
		 * @return  返回空间位置关系
		 */
		public static function intersectsPlaneAndTriangle(plane:Plane, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3):int{
			
			var test1:int = intersectsPlaneAndPoint(plane, vertex1);
			var test2:int = intersectsPlaneAndPoint(plane, vertex2);
			var test3:int = intersectsPlaneAndPoint(plane, vertex3);
			
			if (test1 == Plane.PlaneIntersectionType_Front && test2 == Plane.PlaneIntersectionType_Front && test3 == Plane.PlaneIntersectionType_Front)
				return Plane.PlaneIntersectionType_Front;
			
			if (test1 == Plane.PlaneIntersectionType_Back && test2 == Plane.PlaneIntersectionType_Back && test3 == Plane.PlaneIntersectionType_Back)
				return Plane.PlaneIntersectionType_Back;
				
			return Plane.PlaneIntersectionType_Intersecting;
		}
		
		/**
		 * 空间中射线和平面是否相交
		 * @param	ray   射线
		 * @param	plane 平面
		 * @param	out 相交距离,如果为0,不相交
		 */
		public static function intersectsRayAndPlaneRD(ray:Ray, plane:Plane, out:Number):Boolean {
			
			var planeNor:Vector3 = plane.normal;
			var direction:Number = Vector3.dot(planeNor, ray.direction);
			
			if (MathUtils3D.isZero(direction)) {
				out = 0;
				return false;
			}
			
			var position:Number = Vector3.dot(planeNor, ray.origin);
			out = (-plane.distance - position) / direction;
			
			if (out < 0) {
				out = 0;
				return false;
			}
			
			return true;
		}
		
		/**
		 * 空间中射线和平面是否相交
		 * @param	ray   射线
		 * @param	plane 平面
		 * @param	out 相交点
		 */
		public static function intersectsRayAndPlaneRP(ray:Ray, plane:Plane, out:Vector3):Boolean {
			
			var distance:Number;
			if (!intersectsRayAndPlaneRD(ray, plane, distance)) {
				
				out = Vector3.ZERO;
				return false;
			}
			
			Vector3.scale(ray.direction, distance, _tempV30);
			Vector3.add(ray.origin, _tempV30, _tempV31);
			out = _tempV31;
			return true;
		}
		
		/**
		 * 空间中射线和包围盒是否相交
		 * @param	ray 射线
		 * @param	box	包围盒
		 * @param	out 相交距离,如果为0,不相交
		 */
		public static function intersectsRayAndBoxRD(ray:Ray, box:BoundBox, out:Number):Boolean {
			
			var rayoe:Float32Array = ray.origin.elements;
			var rayoeX:Number = rayoe[0];
			var rayoeY:Number = rayoe[1];
			var rayoeZ:Number = rayoe[2];
			
			var rayde:Float32Array = ray.direction.elements;
			var raydeX:Number = rayde[0];
			var raydeY:Number = rayde[1];
			var raydeZ:Number = rayde[2];
			
			var boxMine:Float32Array = box.min.elements;
			var boxMineX:Number = boxMine[0];
			var boxMineY:Number = boxMine[1];
			var boxMineZ:Number = boxMine[2];
			
			var boxMaxe:Float32Array = box.max.elements;
			var boxMaxeX:Number = boxMaxe[0];
			var boxMaxeY:Number = boxMaxe[1];
			var boxMaxeZ:Number = boxMaxe[2];
			
			out = 0;
			
			var tmax:Number = MathUtils3D.MaxValue;
			
			if (MathUtils3D.isZero(raydeX)) {
				
				if (rayoeX < boxMineX || rayoeX > boxMaxeX) {
					
					out = 0;
					return false;
				}
			} else {
				
				var inverse:Number = 1 / raydeX;
				var t1:Number = (boxMineX - rayoeX) * inverse;
				var t2:Number = (boxMaxeX - rayoeX) * inverse;
				
				if (t1 > t2) {
					
					var temp:Number = t1;
					t1 = t2;
					t2 = temp;
				}
				
				out = Math.max(t1, out);
				tmax = Math.min(t2, tmax);
				
				if (out > tmax) {
					
					out = 0;
					return false;
				}
			}
			
			if (MathUtils3D.isZero(raydeY)) {
				
				if (rayoeY < boxMineY || rayoeY > boxMaxeY) {
					
					out = 0;
					return false;
				}
			} else {
				
				var inverse1:Number = 1 / raydeY;
				var t3:Number = (boxMineY - rayoeY) * inverse1;
				var t4:Number = (boxMaxeY - rayoeY) * inverse1;
				
				if (t3 > t4) {
					
					var temp1:Number = t3;
					t3 = t4;
					t4 = temp1;
				}
				
				out = Math.max(t3, out);
				tmax = Math.min(t4, tmax);
				
				if (out > tmax) {
					
					out = 0;
					return false;
				}
			}
			
			if (MathUtils3D.isZero(raydeZ)) {
				
				if (rayoeZ < boxMineZ || rayoeZ > boxMaxeZ) {
					
					out = 0;
					return false;
				}
			} else {
				
				var inverse2:Number = 1 / raydeZ;
				var t5:Number = (boxMineZ - rayoeZ) * inverse2;
				var t6:Number = (boxMaxeZ - rayoeZ) * inverse2;
				
				if (t5 > t6) {
					
					var temp2:Number = t5;
					t5 = t6;
					t6 = temp2;
				}
				
				out = Math.max(t5, out);
				tmax = Math.min(t6, tmax);
				
				if (out > tmax) {
					
					out = 0;
					return false;
				}
			}
			
			return true;
		}
		
		/**
		 * 空间中射线和包围盒是否相交
		 * @param	ray 射线
		 * @param	box	包围盒
		 * @param	out 相交点
		 */
		public static function intersectsRayAndBoxRP(ray:Ray, box:BoundBox, out:Vector3):Boolean {
			
			var distance:Number;
			if (!intersectsRayAndBoxRD(ray, box, distance)) {
				
				out = Vector3.ZERO;
				return false;
			}
			
			Vector3.scale(ray.direction, distance, _tempV30);
			Vector3.add(ray.origin, _tempV30, _tempV31);
			
			out = _tempV31;
			return true;
		}
		
		/**
		 * 空间中射线和包围球是否相交
		 * @param	ray    射线
		 * @param	sphere 包围球
		 * @param	out    相交距离,如果为0,不相交
		 */
		public static function intersectsRayAndSphereRD(ray:Ray, sphere:BoundSphere, out:Number):Boolean {
			
			var sphereR:Number = sphere.radius;
			Vector3.subtract(ray.origin, sphere.center, _tempV30);
			
			var b:Number = Vector3.dot(_tempV30, ray.direction);
			var c:Number = Vector3.dot(_tempV30, _tempV30) - (sphereR * sphereR);
			
			if (c > 0 && b > 0) {
				out = 0;
				return false;
			}
			
			var discriminant:Number = b * b - c;
			
			if (discriminant < 0) {
				out = 0;
				return false;
			}
			
			out = -b - Math.sqrt(discriminant);
			
			if (out < 0)
				out = 0;
			
			return true;
		}
		
		/**
		 * 空间中射线和包围球是否相交
		 * @param	ray    射线
		 * @param	sphere 包围球
		 * @param	out    相交点
		 */
		public static function intersectsRayAndSphereRP(ray:Ray, sphere:BoundSphere, out:Vector3):Boolean {
			
			var distance:Number;
			if (!intersectsRayAndSphereRD(ray, sphere, distance)) {
				
				out = Vector3.ZERO;
				return false;
			}
			
			Vector3.scale(ray.direction, distance, _tempV30);
			Vector3.add(ray.origin, _tempV30, _tempV31);
			
			out = _tempV31;
			
			return true;
		}
		
		/**
		 * 空间中包围球和三角面是否相交
		 * @param	sphere 包围球
		 * @param	vertex1 三角面顶点1
		 * @param	vertex2 三角面顶点2
		 * @param	vertex3 三角面顶点3
		 * @return  返回是否相交
		 */
		public static function intersectsSphereAndTriangle(sphere:BoundSphere, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3):Boolean{
			
			var sphereC:Vector3 = sphere.center;
			var sphereR:Number = sphere.radius;
			
			closestPointPointTriangle(sphereC, vertex1, vertex2, vertex3, _tempV30);
			Vector3.subtract(_tempV30, sphereC, _tempV31);
			
			var dot:Number = Vector3.dot(_tempV31, _tempV31);
			
			return dot <= sphereR * sphereR;
		}
		
		/**
		 * 空间中点和平面是否相交
		 * @param	plane  平面
		 * @param	point  点
		 * @return  碰撞状态
		 */
		public static function intersectsPlaneAndPoint(plane:Plane, point:Vector3):int {
			
			var distance:Number = Vector3.dot(plane.normal, point) + plane.distance;
			
			if (distance > 0)
				return Plane.PlaneIntersectionType_Front;
			else if (distance < 0)
				return Plane.PlaneIntersectionType_Back;
			else
				return Plane.PlaneIntersectionType_Intersecting;
		}
		
		/**
		 * 空间中平面和平面是否相交
		 * @param	plane1 平面1
		 * @param	plane2 平面2
		 * @return  是否相交
		 */
		public static function intersectsPlaneAndPlane(plane1:Plane, plane2:Plane):Boolean {
			
			Vector3.cross(plane1.normal, plane2.normal, _tempV30);
			
			var denominator:Number = Vector3.dot(_tempV30, _tempV30);
			
			if (MathUtils3D.isZero(denominator))
				return false;
			
			return true;
		}
		
		/**
		 * 空间中平面和平面是否相交
		 * @param	plane1 平面1
		 * @param	plane2 平面2
		 * @param	line   相交线
		 * @return  是否相交
		 */
		public static function intersectsPlaneAndPlaneRL(plane1:Plane, plane2:Plane, line:Ray):Boolean {
			
			var plane1nor:Vector3 = plane1.normal;
			var plane2nor:Vector3 = plane2.normal;
			
			Vector3.cross(plane1nor, plane2nor, _tempV34);
			var denominator:Number = Vector3.dot(_tempV34, _tempV34);
			
			if (MathUtils3D.isZero(denominator))
				return false;
			
			Vector3.scale(plane2nor, plane1.distance, _tempV30);
			Vector3.scale(plane1nor, plane2.distance, _tempV31);
			Vector3.subtract(_tempV30, _tempV31, _tempV32);
			Vector3.cross(_tempV32, _tempV34, _tempV33);
			
			Vector3.normalize(_tempV34, _tempV34);
			line = new Ray(_tempV33, _tempV34);
			
			return true;
		}
		
		/**
		 * 空间中平面和包围盒是否相交
		 * @param	plane 平面
		 * @param   box  包围盒
		 * @return  碰撞状态
		 */
		public static function intersectsPlaneAndBox(plane:Plane, box:BoundBox):int {
			
			var planeD:Number = plane.distance;
			
			var planeNor:Vector3 = plane.normal;
			var planeNore:Float32Array = planeNor.elements;
			var planeNoreX:Number = planeNore[0];
			var planeNoreY:Number = planeNore[1];
			var planeNoreZ:Number = planeNore[2];
			
			var boxMine:Float32Array = box.min.elements;
			var boxMineX:Number = boxMine[0];
			var boxMineY:Number = boxMine[1];
			var boxMineZ:Number = boxMine[2];
			
			var boxMaxe:Float32Array = box.max.elements;
			var boxMaxeX:Number = boxMaxe[0];
			var boxMaxeY:Number = boxMaxe[1];
			var boxMaxeZ:Number = boxMaxe[2];
			
			_tempV30.elements[0] = (planeNoreX > 0) ? boxMineX : boxMaxeX;
			_tempV30.elements[1] = (planeNoreY > 0) ? boxMineY : boxMaxeY;
			_tempV30.elements[2] = (planeNoreZ > 0) ? boxMineZ : boxMaxeZ;
			
			_tempV31.elements[0] = (planeNoreX > 0) ? boxMaxeX : boxMineX;
			_tempV31.elements[1] = (planeNoreY > 0) ? boxMaxeY : boxMineY;
			_tempV31.elements[2] = (planeNoreZ > 0) ? boxMaxeZ : boxMineZ;
			
			var distance:Number = Vector3.dot(planeNor, _tempV30);
			if (distance + planeD > 0)
				return Plane.PlaneIntersectionType_Front;
			
			distance = Vector3.dot(planeNor, _tempV31);
			if (distance + planeD < 0)
				return Plane.PlaneIntersectionType_Back;
			
			return Plane.PlaneIntersectionType_Intersecting;
		}
		
		/**
		 * 空间中平面和包围球是否相交
		 * @param	plane 平面
		 * @param   sphere 包围球
		 * @return  碰撞状态
		 */
		public static function intersectsPlaneAndSphere(plane:Plane, sphere:BoundSphere):int {
			
			var sphereR:Number = sphere.radius;
			var distance:Number = Vector3.dot(plane.normal, sphere.center) + plane.distance;
			
			if (distance > sphereR)
				return Plane.PlaneIntersectionType_Front;
			if (distance < -sphereR)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
		}
		
		/**
		 * 空间中包围盒和包围盒是否相交
		 * @param	box1 包围盒1
		 * @param   box2 包围盒2
		 * @return  是否相交
		 */
		public static function intersectsBoxAndBox(box1:BoundBox, box2:BoundBox):Boolean {
			
			var box1Mine:Float32Array = box1.min.elements;
			var box1Maxe:Float32Array = box1.max.elements;
			var box2Mine:Float32Array = box2.min.elements;
			var box2Maxe:Float32Array = box2.max.elements;
			
			if (box1Mine[0] > box2Maxe[0] || box2Mine[0] > box1Maxe[0])
				return false;
			if (box1Mine[1] > box2Maxe[1] || box2Mine[1] > box1Maxe[1])
				return false;
			if (box1Mine[2] > box2Maxe[2] || box2Mine[2] > box1Maxe[2])
				return false;
			return true;
		}
		
		/**
		 * 空间中包围盒和包围球是否相交
		 * @param	box 包围盒
		 * @param   sphere 包围球
		 * @return  是否相交
		 */
		public static function intersectsBoxAndSphere(box:BoundBox, sphere:BoundSphere):Boolean {
			
			var sphereC:Vector3 = sphere.center;
			var sphereR:Number = sphere.radius;
			Vector3.Clamp(sphereC, box.min, box.max, _tempV30);
			var distance:Number = Vector3.distanceSquared(sphereC, _tempV30);
			
			return distance <= sphereR * sphereR;
		}
		
		/**
		 * 空间中包围球和包围球是否相交
		 * @param	sphere1 包围球1
		 * @param   sphere2 包围球2
		 * @return  是否相交
		 */
		public static function intersectsSphereAndSphere(sphere1:BoundSphere, sphere2:BoundSphere):Boolean {
			
			var radiisum:Number = sphere1.radius + sphere2.radius;
			return Vector3.distanceSquared(sphere1.center, sphere2.center) <= radiisum * radiisum;
		}
		
		
		/**
		 * 空间中包围盒是否包含另一个点
		 * @param	box 包围盒
		 * @param   point 点
		 * @return  位置关系:0 不想交,1 包含, 2 相交
		 */
		public static function boxContainsPoint(box:BoundBox, point:Vector3):int {
			
			var boxMine:Float32Array = box.min.elements;
			var boxMaxe:Float32Array = box.max.elements;
			var pointe:Float32Array = point.elements;
			
			if (boxMine[0] <= pointe[0] && boxMaxe[0] >= pointe[0] && boxMine[1] <= pointe[1] && boxMaxe[1] >= pointe[1] && boxMine[2] <= pointe[2] && boxMaxe[2] >= pointe[2])
				return ContainmentType.Contains;
			return ContainmentType.Disjoint;
		}
		
		/**
		 * 空间中包围盒是否包含另一个包围盒
		 * @param	box1 包围盒1
		 * @param   box2 包围盒2
		 * @return  位置关系:0 不想交,1 包含, 2 相交
		 */
		public static function boxContainsBox(box1:BoundBox, box2:BoundBox):int {
			
			var box1Mine:Float32Array = box1.min.elements;
			var box1MineX:Number = box1Mine[0];
			var box1MineY:Number = box1Mine[1];
			var box1MineZ:Number = box1Mine[2];
			
			var box1Maxe:Float32Array = box1.max.elements;
			var box1MaxeX:Number = box1Maxe[0];
			var box1MaxeY:Number = box1Maxe[1];
			var box1MaxeZ:Number = box1Maxe[2];
			
			var box2Mine:Float32Array = box2.min.elements;
			var box2MineX:Number = box2Mine[0];
			var box2MineY:Number = box2Mine[1];
			var box2MineZ:Number = box2Mine[2];
			
			var box2Maxe:Float32Array = box2.max.elements;
			var box2MaxeX:Number = box2Maxe[0];
			var box2MaxeY:Number = box2Maxe[1];
			var box2MaxeZ:Number = box2Maxe[2];
			
			if (box1MaxeX < box2MineX || box1MineX > box2MaxeX)
				return ContainmentType.Disjoint;
			
			if (box1MaxeY < box2MineY || box1MineY > box2MaxeY)
				return ContainmentType.Disjoint;
			
			if (box1MaxeZ < box2MineZ || box1MineZ > box2MaxeZ)
				return ContainmentType.Disjoint;
			
			if (box1MineX <= box2MineX && box2MaxeX <= box2MineX && box1MineY <= box2MineY && box2MaxeY <= box1MaxeY && box1MineZ <= box2MineZ && box2MaxeZ <= box1MaxeZ) {
				return ContainmentType.Contains;
			}
			
			return ContainmentType.Intersects;
		}
		
		/**
		 * 空间中包围盒是否包含另一个包围球
		 * @param	box 包围盒
		 * @param   sphere 包围球
		 * @return  位置关系:0 不想交,1 包含, 2 相交
		 */
		public static function boxContainsSphere(box:BoundBox, sphere:BoundSphere):int{
			
			var boxMin:Vector3 = box.min;
			var boxMine:Float32Array = boxMin.elements;
			var boxMineX:Number = boxMine[0];
			var boxMineY:Number = boxMine[1];
			var boxMineZ:Number = boxMine[2];
			
			var boxMax:Vector3 = box.max;
			var boxMaxe:Float32Array = boxMax.elements;
			var boxMaxeX:Number = boxMaxe[0];
			var boxMaxeY:Number = boxMaxe[1];
			var boxMaxeZ:Number = boxMaxe[2];
			
			var sphereC:Vector3 = sphere.center;
			var sphereCe:Float32Array = sphereC.elements;
			var sphereCeX:Number = sphereCe[0];
			var sphereCeY:Number = sphereCe[1];
			var sphereCeZ:Number = sphereCe[2];
			
			var sphereR:Number = sphere.radius;
			
			Vector3.Clamp(sphereC, boxMin, boxMax, _tempV30);
			var distance:Number = Vector3.distanceSquared(sphereC, _tempV30);
			
			if (distance > sphereR * sphereR)
				return ContainmentType.Disjoint;
				
			if ((((boxMineX + sphereR <= sphereCeX) && (sphereCeX <= boxMaxeX - sphereR)) && ((boxMaxeX - boxMineX > sphereR) &&
                (boxMineY + sphereR <= sphereCeY))) && (((sphereCeY <= boxMaxeY - sphereR) && (boxMaxeY - boxMineY > sphereR)) &&
                (((boxMineZ + sphereR <= sphereCeZ) && (sphereCeZ <= boxMaxeZ - sphereR)) && (boxMaxeZ - boxMineZ > sphereR))))
				return ContainmentType.Contains;
			
			return ContainmentType.Intersects;
		}
		
		/**
		 * 空间中包围球是否包含另一个点
		 * @param	sphere 包围球
		 * @param   point 点
		 * @return  位置关系:0 不想交,1 包含, 2 相交
		 */
		public static function sphereContainsPoint(sphere:BoundSphere, point:Vector3):int{
			
			if (Vector3.distanceSquared(point, sphere.center) <= sphere.radius * sphere.radius)
                return ContainmentType.Contains;

            return ContainmentType.Disjoint;
		}
		
		/**
		 * 空间中包围球是否包含另一个三角面
		 * @param	sphere
		 * @param	vertex1 三角面顶点1
		 * @param	vertex2 三角面顶点2
		 * @param	vertex3 三角面顶点3
		 * @return  返回空间位置关系
		 */
		public static function sphereContainsTriangle(sphere:BoundSphere, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3):int{
			
			var test1:int = sphereContainsPoint(sphere, vertex1);
			var test2:int = sphereContainsPoint(sphere, vertex2);
			var test3:int = sphereContainsPoint(sphere, vertex3);
			
			if (test1 == ContainmentType.Contains && test2 == ContainmentType.Contains && test3 == ContainmentType.Contains)
				return ContainmentType.Contains;
				
			if (intersectsSphereAndTriangle(sphere, vertex1, vertex2, vertex3))
				return ContainmentType.Intersects;
				
			return ContainmentType.Disjoint;
		}
		
		/**
		 * 空间中包围球是否包含另一包围盒
		 * @param	sphere 包围球
		 * @param   box 包围盒
		 * @return  位置关系:0 不想交,1 包含, 2 相交
		 */
		public static function sphereContainsBox(sphere:BoundSphere, box:BoundBox):int{
			
			var sphereC:Vector3 = sphere.center;
			var sphereCe:Float32Array = sphereC.elements;
			var sphereCeX:Number = sphereCe[0];
			var sphereCeY:Number = sphereCe[1];
			var sphereCeZ:Number = sphereCe[2];
			
			var sphereR:Number = sphere.radius;
			
			var boxMin:Vector3 = box.min;
			var boxMine:Float32Array = boxMin.elements;
			var boxMineX:Number = boxMine[0];
			var boxMineY:Number = boxMine[1];
			var boxMineZ:Number = boxMine[2];
			
			var boxMax:Vector3 = box.max;
			var boxMaxe:Float32Array = boxMax.elements;
			var boxMaxeX:Number = boxMaxe[0];
			var boxMaxeY:Number = boxMaxe[1];
			var boxMaxeZ:Number = boxMaxe[2];
			
			var _tempV30e:Float32Array = _tempV30.elements;
			var _tempV30eX:Number = _tempV30e[0];
			var _tempV30eY:Number = _tempV30e[1];
			var _tempV30eZ:Number = _tempV30e[2];
			
			if (!intersectsBoxAndSphere(box, sphere))
				return ContainmentType.Disjoint;
			
			var radiusSquared:Number = sphereR * sphereR;
			
			_tempV30eX = sphereCeX - boxMineX;
            _tempV30eY = sphereCeY - boxMaxeY;
            _tempV30eZ = sphereCeZ - boxMaxeZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			_tempV30eX = sphereCeX - boxMaxeX;
            _tempV30eY = sphereCeY - boxMaxeY;
            _tempV30eZ = sphereCeZ - boxMaxeZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			_tempV30eX = sphereCeX - boxMaxeX;
            _tempV30eY = sphereCeY - boxMineY;
            _tempV30eZ = sphereCeZ - boxMaxeZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			_tempV30eX = sphereCeX - boxMineX;
            _tempV30eY = sphereCeY - boxMineY;
            _tempV30eZ = sphereCeZ - boxMaxeZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			_tempV30eX = sphereCeX - boxMineX;
            _tempV30eY = sphereCeY - boxMaxeY;
            _tempV30eZ = sphereCeZ - boxMineZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			_tempV30eX = sphereCeX - boxMaxeX;
            _tempV30eY = sphereCeY - boxMaxeY;
            _tempV30eZ = sphereCeZ - boxMineZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			_tempV30eX = sphereCeX - boxMaxeX;
            _tempV30eY = sphereCeY - boxMineY;
            _tempV30eZ = sphereCeZ - boxMineZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
			
			_tempV30eX = sphereCeX - boxMineX;
            _tempV30eY = sphereCeY - boxMineY;
            _tempV30eZ = sphereCeZ - boxMineZ;
			if (Vector3.scalarLengthSquared(_tempV30) > radiusSquared)
				return ContainmentType.Intersects;
				
			return ContainmentType.Contains;
			
		}
		
		/**
		 * 空间中包围球是否包含另一包围球
		 * @param	sphere1 包围球
		 * @param   sphere2 包围球
		 * @return  位置关系:0 不想交,1 包含, 2 相交
		 */
		public static function sphereContainsSphere(sphere1:BoundSphere, sphere2:BoundSphere):int{
			
			var sphere1R:Number = sphere1.radius;
			var sphere2R:Number = sphere2.radius;
			
			var distance:Number = Vector3.distance(sphere1.center, sphere2.center);
			
			if (sphere1R + sphere2R < distance)
				return ContainmentType.Disjoint;
				
			if (sphere1R - sphere2R < distance)
				return ContainmentType.Intersects;
				
			return ContainmentType.Contains;
		}
		
		
		/**
		 * 空间中点与三角面的最近点
		 * @param	point 点
		 * @param	vertex1 三角面顶点1
		 * @param	vertex2	三角面顶点2
		 * @param	vertex3 三角面顶点3
		 * @param	out 最近点
		 */
		public static function closestPointPointTriangle(point:Vector3, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3, out:Vector3):void{
			
			Vector3.subtract(vertex2, vertex1, _tempV30);
			Vector3.subtract(vertex3, vertex1, _tempV31);
			
			Vector3.subtract(point, vertex1, _tempV32);
			Vector3.subtract(point, vertex2, _tempV33);
			Vector3.subtract(point, vertex3, _tempV34);
			
			var d1:Number = Vector3.dot(_tempV30, _tempV32);
			var d2:Number = Vector3.dot(_tempV31, _tempV32);
			var d3:Number = Vector3.dot(_tempV30, _tempV33);
			var d4:Number = Vector3.dot(_tempV31, _tempV33);
			var d5:Number = Vector3.dot(_tempV30, _tempV34);
			var d6:Number = Vector3.dot(_tempV31, _tempV34);
			
			if (d1 <= 0 && d2 <= 0){
				vertex1.cloneTo(out);
				return;
			}
			
			if (d3 >= 0 && d4 <= d3){
				vertex2.cloneTo(out);
				return;
			}
			
			var vc:Number = d1 * d4 - d3 * d2;
			if (vc <= 0 && d1 >= 0 && d3 <= 0){
				var v:Number = d1 / (d1 - d3);
				Vector3.scale(_tempV30, v, out);
				Vector3.add(vertex1, out, out);
				return;
			}
			
			if (d6 >= 0 && d5 <= d6){
				vertex3.cloneTo(out);
				return;
			}
			
			var vb:Number = d5 * d2 - d1 * d6;
			if (vb <= 0 && d2 >= 0 && d6 <= 0){
				var w:Number = d2 / (d2 - d6);
				Vector3.scale(_tempV31, w, out);
				Vector3.add(vertex1, out, out);
				return;
			}
			
			var va:Number = d3 * d6 - d5 * d4;
            if (va <= 0 && (d4 - d3) >= 0 && (d5 - d6) >= 0){
				var w3:Number = (d4 - d3) / ((d4 - d3) + (d5 - d6));
				Vector3.subtract(vertex3, vertex2, out);
				Vector3.scale(out, w3, out);
				Vector3.add(vertex2, out, out);
				return;
			}
			
			var denom:Number = 1 / (va + vb + vc);
			var v2:Number = vb * denom;
			var w2:Number = vc * denom;
			Vector3.scale(_tempV30, v2, _tempV35);
			Vector3.scale(_tempV31, w2, _tempV36);
			Vector3.add(_tempV35, _tempV36, out);
			Vector3.add(vertex1, out, out);
		}
		
		/**
		 * 空间中平面与一点的最近点
		 * @param	plane 平面
		 * @param	point 点
		 * @param	out 最近点
		 */
		public static function closestPointPlanePoint(plane:Plane, point:Vector3, out:Vector3):void {
			
			var planeN:Vector3 = plane.normal;
			var t:Number = Vector3.dot(planeN, point) - plane.distance;
			
			Vector3.scale(planeN, t, _tempV30);
			Vector3.subtract(point, _tempV30, out);
		}
		
		/**
		 * 空间中包围盒与一点的最近点
		 * @param	box 包围盒
		 * @param	point 点
		 * @param	out 最近点
		 */
		public static function closestPointBoxPoint(box:BoundBox, point:Vector3, out:Vector3):void{
			
			Vector3.max(point, box.min, _tempV30);
			Vector3.min(_tempV30, box.max, out);
		}
		
		/**
		 * 空间中包围球与一点的最近点
		 * @param	sphere 包围球
		 * @param	point 点
		 * @param	out 最近点
		 */
		public static function closestPointSpherePoint(sphere:BoundSphere, point:Vector3, out:Vector3):void{
			
			var sphereC:Vector3 = sphere.center;
			
			Vector3.subtract(point, sphereC, out);
			Vector3.normalize(out, out);
			
			Vector3.scale(out, sphere.radius, out);
			Vector3.add(out, sphereC, out);
		}
		
		/**
		 * 空间中包围球与包围球的最近点
		 * @param	sphere1 包围球1
		 * @param	sphere2 包围球2
		 * @param	out 最近点
		 */
		public static function closestPointSphereSphere(sphere1:BoundSphere, sphere2:BoundSphere, out:Vector3):void{
			
			var sphere1C:Vector3 = sphere1.center;
			
			Vector3.subtract(sphere2.center, sphere1C, out);
			Vector3.normalize(out, out);
			
			Vector3.scale(out, sphere1.radius, out);
			Vector3.add(out, sphere1C, out);
		}
	
	}

}