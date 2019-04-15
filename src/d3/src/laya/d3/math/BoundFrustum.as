package laya.d3.math {
	
	/**
	 * <code>BoundFrustum</code> 类用于创建锥截体。
	 */
	public class BoundFrustum {
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
		/** @private */
		private static var _tempV37:Vector3 = new Vector3();
		
		/**4x4矩阵*/
		private var _matrix:Matrix4x4;
		/**近平面*/
		private var _near:Plane;
		/**远平面*/
		private var _far:Plane;
		/**左平面*/
		private var _left:Plane;
		/**右平面*/
		private var _right:Plane;
		/**顶平面*/
		private var _top:Plane;
		/**底平面*/
		private var _bottom:Plane;
		
		/**
		 * 创建一个 <code>BoundFrustum</code> 实例。
		 * @param	matrix 锥截体的描述4x4矩阵。
		 */
		public function BoundFrustum(matrix:Matrix4x4) {
			_matrix = matrix;
			_near = new Plane(new Vector3());
			_far = new Plane(new Vector3());
			_left = new Plane(new Vector3());
			_right = new Plane(new Vector3());
			_top = new Plane(new Vector3());
			_bottom = new Plane(new Vector3());
			_getPlanesFromMatrix(_matrix, _near, _far, _left, _right, _top, _bottom);
		}
		
		/**
		 * 获取描述矩阵。
		 * @return  描述矩阵。
		 */
		public function get matrix():Matrix4x4 {
			return _matrix;
		}
		
		/**
		 * 设置描述矩阵。
		 * @param matrix 描述矩阵。
		 */
		public function set matrix(matrix:Matrix4x4):void {
			_matrix = matrix;
			_getPlanesFromMatrix(_matrix, _near, _far, _left, _right, _top, _bottom);
		}
		
		/**
		 * 获取近平面。
		 * @return  近平面。
		 */
		public function get near():Plane {
			return _near;
		}
		
		/**
		 * 获取远平面。
		 * @return  远平面。
		 */
		public function get far():Plane {
			
			return _far;
		}
		
		/**
		 * 获取左平面。
		 * @return  左平面。
		 */
		public function get left():Plane {
			
			return _left;
		}
		
		/**
		 * 获取右平面。
		 * @return  右平面。
		 */
		public function get right():Plane {
			
			return _right;
		}
		
		/**
		 * 获取顶平面。
		 * @return  顶平面。
		 */
		public function get top():Plane {
			
			return _top;
		}
		
		/**
		 * 获取底平面。
		 * @return  底平面。
		 */
		public function get bottom():Plane {
			
			return _bottom;
		}
		
		/**
		 * 判断是否与其他锥截体相等。
		 * @param	other 锥截体。
		 */
		public function equalsBoundFrustum(other:BoundFrustum):Boolean {
			
			return _matrix.equalsOtherMatrix(other.matrix)
		}
		
		/**
		 * 判断是否与其他对象相等。
		 * @param	obj 对象。
		 */
		public function equalsObj(obj:Object):Boolean {
			
			if (obj is BoundFrustum) {
				var bf:BoundFrustum = obj as BoundFrustum;
				return equalsBoundFrustum(bf);
			}
			return false;
		}
		
		/**
		 * 获取锥截体的任意一平面。
		 * 0:近平面
		 * 1:远平面
		 * 2:左平面
		 * 3:右平面
		 * 4:顶平面
		 * 5:底平面
		 * @param	index 索引。
		 */
		public function getPlane(index:int):Plane {
			switch (index) {
			case 0: 
				return _near;
			case 1: 
				return _far;
			case 2: 
				return _left;
			case 3: 
				return _right;
			case 4: 
				return _top;
			case 5: 
				return _bottom;
			default: 
				return null;
			}
		}
		
		/**
		 * 根据描述矩阵获取锥截体的6个面。
		 * @param  m 描述矩阵。
		 * @param  np   近平面。
		 * @param  fp    远平面。
		 * @param  lp   左平面。
		 * @param  rp  右平面。
		 * @param  tp    顶平面。
		 * @param  bp 底平面。
		 */
		private static function _getPlanesFromMatrix(m:Matrix4x4, np:Plane, fp:Plane, lp:Plane, rp:Plane, tp:Plane, bp:Plane):void {//适用于OPENGL规则
			var matrixE:Float32Array = m.elements;
			var m11:Number = matrixE[0];
			var m12:Number = matrixE[1];
			var m13:Number = matrixE[2];
			var m14:Number = matrixE[3];
			var m21:Number = matrixE[4];
			var m22:Number = matrixE[5];
			var m23:Number = matrixE[6];
			var m24:Number = matrixE[7];
			var m31:Number = matrixE[8];
			var m32:Number = matrixE[9];
			var m33:Number = matrixE[10];
			var m34:Number = matrixE[11];
			var m41:Number = matrixE[12];
			var m42:Number = matrixE[13];
			var m43:Number = matrixE[14];
			var m44:Number = matrixE[15];
			
			//近平面
			var nearNorE:Vector3 = np.normal;
			nearNorE.x = m14 + m13;
			nearNorE.y = m24 + m23;
			nearNorE.z = m34 + m33;
			np.distance = m44 + m43;
			np.normalize();
			
			//远平面
			var farNorE:Vector3 = fp.normal;
			farNorE.x = m14 - m13;
			farNorE.y = m24 - m23;
			farNorE.z = m34 - m33;
			fp.distance = m44 - m43;
			fp.normalize();
			
			//左平面
			var leftNorE:Vector3 = lp.normal;
			leftNorE.x = m14 + m11;
			leftNorE.y = m24 + m21;
			leftNorE.z = m34 + m31;
			lp.distance = m44 + m41;
			lp.normalize();
			
			//右平面
			var rightNorE:Vector3 = rp.normal;
			rightNorE.x = m14 - m11;
			rightNorE.y = m24 - m21;
			rightNorE.z = m34 - m31;
			rp.distance = m44 - m41;
			rp.normalize();
			
			//顶平面
			var topNorE:Vector3 = tp.normal;
			topNorE.x = m14 - m12;
			topNorE.y = m24 - m22;
			topNorE.z = m34 - m32;
			tp.distance = m44 - m42;
			tp.normalize();
			
			//底平面
			var bottomNorE:Vector3 = bp.normal;
			bottomNorE.x = m14 + m12;
			bottomNorE.y = m24 + m22;
			bottomNorE.z = m34 + m32;
			bp.distance = m44 + m42;
			bp.normalize();
		}
		
		/**
		 * 锥截体三个相交平面的交点。
		 * @param  p1  平面1。
		 * @param  p2  平面2。
		 * @param  p3  平面3。
		 */
		private static function _get3PlaneInterPoint(p1:Plane, p2:Plane, p3:Plane):Vector3 {
			var p1Nor:Vector3 = p1.normal;
			var p2Nor:Vector3 = p2.normal;
			var p3Nor:Vector3 = p3.normal;
			
			Vector3.cross(p2Nor, p3Nor, _tempV30);
			Vector3.cross(p3Nor, p1Nor, _tempV31);
			Vector3.cross(p1Nor, p2Nor, _tempV32);
			
			var a:Number = Vector3.dot(p1Nor, _tempV30);
			var b:Number = Vector3.dot(p2Nor, _tempV31);
			var c:Number = Vector3.dot(p3Nor, _tempV32);
			
			Vector3.scale(_tempV30, -p1.distance / a, _tempV33);
			Vector3.scale(_tempV31, -p2.distance / b, _tempV34);
			Vector3.scale(_tempV32, -p3.distance / c, _tempV35);
			
			Vector3.add(_tempV33, _tempV34, _tempV36);
			Vector3.add(_tempV35, _tempV36, _tempV37);
			
			var v:Vector3 = _tempV37;
			
			return v;
		}
		
		/**
		 * 锥截体的8个顶点。
		 * @param  corners  返回顶点的输出队列。
		 */
		public function getCorners(corners:Vector.<Vector3>):void {
			
			_get3PlaneInterPoint(_near, _bottom, _right).cloneTo(corners[0]);
			_get3PlaneInterPoint(_near, _top, _right).cloneTo(corners[1]);
			_get3PlaneInterPoint(_near, _top, _left).cloneTo(corners[2]);
			_get3PlaneInterPoint(_near, _bottom, _left).cloneTo(corners[3]);
			_get3PlaneInterPoint(_far, _bottom, _right).cloneTo(corners[4]);
			_get3PlaneInterPoint(_far, _top, _right).cloneTo(corners[5]);
			_get3PlaneInterPoint(_far, _top, _left).cloneTo(corners[6]);
			_get3PlaneInterPoint(_far, _bottom, _left).cloneTo(corners[7]);
		}
		
		/**
		 * 与点的位置关系。返回-1,包涵;0,相交;1,不相交
		 * @param  point  点。
		 */
		public function containsPoint(point:Vector3):int {
			
			var result:int = Plane.PlaneIntersectionType_Front;
			var planeResult:int = Plane.PlaneIntersectionType_Front;
			
			for (var i:int = 0; i < 6; i++) {
				
				switch (i) {
				case 0: 
					planeResult = CollisionUtils.intersectsPlaneAndPoint(_near, point);
					break;
				case 1: 
					planeResult = CollisionUtils.intersectsPlaneAndPoint(_far, point);
					break;
				case 2: 
					planeResult = CollisionUtils.intersectsPlaneAndPoint(_left, point);
					break;
				case 3: 
					planeResult = CollisionUtils.intersectsPlaneAndPoint(_right, point);
					break;
				case 4: 
					planeResult = CollisionUtils.intersectsPlaneAndPoint(_top, point);
					break;
				case 5: 
					planeResult = CollisionUtils.intersectsPlaneAndPoint(_bottom, point);
					break;
				}
				
				switch (planeResult) {
				case Plane.PlaneIntersectionType_Back: 
					return ContainmentType.Disjoint;
				case Plane.PlaneIntersectionType_Intersecting: 
					result = Plane.PlaneIntersectionType_Intersecting;
					break;
				}
			}
			
			switch (result) {
			case Plane.PlaneIntersectionType_Intersecting: 
				return ContainmentType.Intersects;
			default: 
				return ContainmentType.Contains;
			}
		}
		
		/**
		 * 与包围盒的位置关系。返回-1,包涵;0,相交;1,不相交
		 * @param  box  包围盒。
		 */
		public function containsBoundBox(box:BoundBox):int {
			var p:Vector3 = _tempV30, n:Vector3 = _tempV31;
			var boxMin:Vector3 = box.min;
			var boxMax:Vector3 = box.max;
			var result:int = ContainmentType.Contains;
			for (var i:int = 0; i < 6; i++) {
				var plane:Plane = getPlane(i);
				
				var planeNor:Vector3 = plane.normal;
				
				if (planeNor.x >= 0) {
					p.x = boxMax.x;
					n.x = boxMin.x;
				} else {
					p.x = boxMin.x;
					n.x = boxMax.x;
				}
				if (planeNor.y >= 0) {
					p.y = boxMax.y;
					n.y = boxMin.y;
				} else {
					p.y = boxMin.y;
					n.y = boxMax.y;
				}
				if (planeNor.z >= 0) {
					p.z = boxMax.z;
					n.z = boxMin.z;
				} else {
					p.z = boxMin.z;
					n.z = boxMax.z;
				}
				
				if (CollisionUtils.intersectsPlaneAndPoint(plane, p) === Plane.PlaneIntersectionType_Back)
					return ContainmentType.Disjoint;
				
				if (CollisionUtils.intersectsPlaneAndPoint(plane, n) === Plane.PlaneIntersectionType_Back)
					result = ContainmentType.Intersects;
			}
			
			return result;
		}
		
		/**
		 * 与包围球的位置关系。返回-1,包涵;0,相交;1,不相交
		 * @param  sphere  包围球。
		 */
		public function containsBoundSphere(sphere:BoundSphere):int {
			var result:int = Plane.PlaneIntersectionType_Front;
			var planeResult:int = Plane.PlaneIntersectionType_Front;
			for (var i:int = 0; i < 6; i++) {
				switch (i) {
				case 0: 
					planeResult = CollisionUtils.intersectsPlaneAndSphere(_near, sphere);
					break;
				case 1: 
					planeResult = CollisionUtils.intersectsPlaneAndSphere(_far, sphere);
					break;
				case 2: 
					planeResult = CollisionUtils.intersectsPlaneAndSphere(_left, sphere);
					break;
				case 3: 
					planeResult = CollisionUtils.intersectsPlaneAndSphere(_right, sphere);
					break;
				case 4: 
					planeResult = CollisionUtils.intersectsPlaneAndSphere(_top, sphere);
					break;
				case 5: 
					planeResult = CollisionUtils.intersectsPlaneAndSphere(_bottom, sphere);
					break;
				}
				
				switch (planeResult) {
				
				case Plane.PlaneIntersectionType_Back: 
					return ContainmentType.Disjoint;
				case Plane.PlaneIntersectionType_Intersecting: 
					result = Plane.PlaneIntersectionType_Intersecting;
					break;
				}
			}
			
			switch (result) {
			
			case Plane.PlaneIntersectionType_Intersecting: 
				return ContainmentType.Intersects;
			default: 
				return ContainmentType.Contains;
			}
		}
	}

}