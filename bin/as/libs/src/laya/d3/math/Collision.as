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
		public static function distancePlaneToPoint(plane:Plane, point:Vector3):Number{

			var dot:Number = Vector3.dot(plane.normal, point);
			return dot - plane.distance;
		}
		
		/**
		 * 空间中点到包围盒的距离
		 * @param	box 包围盒
		 * @param	point 点
		 */
		public static function distanceBoxToPoint(box:BoundBox, point:Vector3):Number{
			
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
		public static function distanceBoxToBox(box1:BoundBox, box2:BoundBox):Number{
			
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
			
			if (box1MineX > box2MaxeX){
				
				var delta:Number = box1MineX - box2MaxeX;
				distance += delta * delta;
			}
			else if(box2MineX > box1MaxeX){
				
				var delta:Number = box2MineX - box1MaxeX;
				distance += delta * delta;
			}
			
			if (box1MineY > box2MaxeY){
				
				var delta:Number = box1MineY - box2MaxeY;
				distance += delta * delta;
			}
			else if(box2MineY > box1MaxeY){
				
				var delta:Number = box2MineY - box1MaxeY;
				distance += delta * delta;
			}
			
			if (box1MineZ > box2MaxeZ){
				
				var delta:Number = box1MineZ - box2MaxeZ;
				distance += delta * delta;
			}
			else if(box2MineZ > box1MaxeZ){
				
				var delta:Number = box2MineZ - box1MaxeZ;
				distance += delta * delta;
			}
			
			return Math.sqrt(distance);
		}
		
		/**
		 * 空间中点到包围球的距离
		 * @param	sphere 包围球
		 * @param	point  点
		 */
		public static function distanceSphereToPoint(sphere:BoundSphere, point:Vector3):Number{
			
			var distance:Number = Math.sqrt(Vector3.distanceSquared(sphere.center, point));
			distance -= sphere.radius;
			
			return Math.max(distance,0);
		}
		
		/**
		 * 空间中包围球到包围球的距离
		 * @param	sphere1 包围球1
		 * @param	sphere2 包围球2
		 */
		public static function distanceSphereToSphere(sphere1:BoundSphere, sphere2:BoundSphere):Number{
			
			var distance:Number =  Math.sqrt(Vector3.distanceSquared(sphere1.center, sphere2.center));
			distance -= sphere1.radius + sphere2.radius ;
			
			return Math.max(distance,0);
		}
		
		/**
		 * 空间中射线和点是否相交
		 * @param	sphere1 包围球1
		 * @param	sphere2 包围球2
		 */
		public static function intersectsRayAndPoint(ray:Ray, point:Vector3):Boolean{
			
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
		public static function intersectsRayAndRay(ray1:Ray, ray2:Ray, out:Vector3):Boolean{
			
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
			
			if (MathUtils3D.isZero(denominator)){
				
				if (MathUtils3D.nearEqual(ray2oeX, ray1oeX) && MathUtils3D.nearEqual(ray2oeY, ray1oeY) && MathUtils3D.nearEqual(ray2oeZ, ray1oeZ)){
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
			
			if (!MathUtils3D.nearEqual(point2e[0], point1e[0]) || !MathUtils3D.nearEqual(point2e[1], point1e[1]) || !MathUtils3D.nearEqual(point2e[2], point1e[2])){
				out = Vector3.ZERO;
				return false;
			}
			
			out = _tempV32;
			return true;
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
			
			if (MathUtils3D.isZero(direction)){
				out = 0;
			return false;
			}
			
			var position:Number = Vector3.dot(planeNor, ray.origin);
			out = ( -plane.distance - position) / direction;
			
			if (out < 0){
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
			if (!intersectsRayAndPlaneRD(ray, plane, distance)){
				
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
			
			var rayoe:Float32Array = ray.origin.elements;;
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
			
			if (MathUtils3D.isZero(raydeX)){
				
				if (rayoeX < boxMineX || rayoeX > boxMaxeX){
				
					out = 0;
					return false;
				}
			}else{
				
				var inverse:Number = 1 / raydeX;
				var t1:Number = (boxMineX - rayoeX) * inverse;
				var t2:Number = (boxMaxeX - rayoeX) * inverse;
				
				if (t1 > t2){
				
					var temp:Number = t1;
					t1 = t2;
					t2 = temp;
				}
				
				out = Math.max(t1, out);
				tmax = Math.min(t2, tmax);
				
				if (out > tmax){
					
					out = 0;
					return false;
				}
			}
			
			if (MathUtils3D.isZero(raydeY)){
				
				if (rayoeY < boxMineY || rayoeY > boxMaxeY){
				
					out = 0;
					return false;
				}
			}else{
				
				var inverse:Number = 1 / raydeY;
				var t1:Number = (boxMineY - rayoeY) * inverse;
				var t2:Number = (boxMaxeY - rayoeY) * inverse;
				
				if (t1 > t2){
				
					var temp:Number = t1;
					t1 = t2;
					t2 = temp;
				}
				
				out = Math.max(t1, out);
				tmax = Math.min(t2, tmax);
				
				if (out > tmax){
					
					out = 0;
					return false;
				}
			}
			
			if (MathUtils3D.isZero(raydeZ)){
				
				if (rayoeZ < boxMineZ || rayoeZ > boxMaxeZ){
				
					out = 0;
					return false;
				}
			}else{
				
				var inverse:Number = 1 / raydeZ;
				var t1:Number = (boxMineZ - rayoeZ) * inverse;
				var t2:Number = (boxMaxeZ - rayoeZ) * inverse;
				
				if (t1 > t2){
				
					var temp:Number = t1;
					t1 = t2;
					t2 = temp;
				}
				
				out = Math.max(t1, out);
				tmax = Math.min(t2, tmax);
				
				if (out > tmax){
					
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
		public static function intersectsRayAndBoxRP(ray:Ray, box:BoundBox, out:Vector3):Boolean{
			
			var distance:Number;
			if (!intersectsRayAndBoxRD(ray, box, distance)){
				
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
		public static function intersectsRayAndSphereRD(ray:Ray, sphere:BoundSphere, out:Number):Boolean{
			
			var sphereR:Number = sphere.radius;
			Vector3.subtract(ray.origin, sphere.center, _tempV30);
			
			var b:Number = Vector3.dot(_tempV30, ray.direction);
			var c:Number = Vector3.dot(_tempV30, _tempV30) - (sphereR * sphereR);
			
			if (c > 0 && b > 0){
                out = 0;
                return false;
            }

            var discriminant:Number = b * b - c;

            if (discriminant < 0)
            {
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
		public static function intersectsRayAndSphereRP(ray:Ray, sphere:BoundSphere, out:Vector3):Boolean{
			
			var distance:Number;
			if (!intersectsRayAndSphereRD(ray, sphere, distance)){
				
				out = Vector3.ZERO;
				return false;
			}
			
			Vector3.scale(ray.direction, distance, _tempV30);
			Vector3.add(ray.origin, _tempV30, _tempV31);
			
			out = _tempV31;
			
			return true;
		}
		
		/**
		 * 空间中点和平面是否相交
		 * @param	plane  平面
		 * @param	point  点
		 */
		public static function intersectsPlaneAndPoint(plane:Plane, point:Vector3):int{
			
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
		 */
		public static function intersectsPlaneAndPlane(plane1:Plane, plane2:Plane):Boolean{
			
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
		 */
		public static function intersectsPlaneAndPlaneRL(plane1:Plane, plane2:Plane, line:Ray):Boolean{
			
			var plane1nor:Vector3 = plane1.normal;
			var plane2nor:Vector3 = plane2.normal;
			
			Vector3.cross(plane1nor, plane2nor, _tempV34);
			var denominator:Number = Vector3.dot(_tempV34, _tempV34);
			
			if (MathUtils3D.isZero(denominator))
				return false;
			
			Vector3.scale(plane2nor, plane1.distance, _tempV30);
			Vector3.scale(plane1nor, plane2.distance, _tempV31);
			Vector3.subtract(_tempV30,_tempV31,_tempV32);
			Vector3.cross(_tempV32, _tempV34, _tempV33);
			
			Vector3.normalize(_tempV34, _tempV34);
			line = new Ray(_tempV33, _tempV34);
			
			return true;
		}
		
		
		/**
		 * 空间中平面和包围盒是否相交
		 * @param	plane 平面
		 * @param   box  包围盒
		 */
		public static function intersectsPlaneAndBox(plane:Plane, box:BoundBox):int{
			
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
		 */
		public static function intersectsPlaneAndSphere(plane:Plane, sphere:BoundSphere):int{
			
			var sphereR:Number = sphere.radius;
			var distance:Number = Vector3.dot(plane.normal, sphere.center)+plane.distance;
			
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
		 */
		public static function intersectsBoxAndBox(box1:BoundBox, box2:BoundBox):Boolean{
			
			var box1Mine:Float32Array = box1.min.elements;
			var box1MineY:Number = box1Mine[1];
			var box1MineZ:Number = box1Mine[2];
			
			var box1Maxe:Float32Array = box1.max.elements;
			var box1MaxeY:Number = box1Maxe[1];
			var box1MaxeZ:Number = box1Maxe[2];
			
			var box2Mine:Float32Array = box2.min.elements;
			var box2MineY:Number = box2Mine[1];
			var box2MineZ:Number = box2Mine[2];
			
			var box2Maxe:Float32Array = box2.max.elements;
			var box2MaxeY:Number = box2Maxe[1];
			var box2MaxeZ:Number = box2Maxe[2];
			
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
		 */
		public static function intersectsBoxAndSphere(box:BoundBox, sphere:BoundSphere):Boolean{
		
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
		 */
		public static function intersectsSphereAndSphere(sphere1:BoundSphere, sphere2:BoundSphere):Boolean{
			var radiisum:Number = sphere1.radius + sphere2.radius;
			return Vector3.distanceSquared(sphere1.center, sphere2.center) <= radiisum * radiisum;
		}
	
		
	}

}