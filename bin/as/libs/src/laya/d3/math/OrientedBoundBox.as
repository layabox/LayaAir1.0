package laya.d3.math {
	
	/**
	 * <code>OrientedBoundBox</code> 类用于创建OBB包围盒。
	 */
	public class OrientedBoundBox {
		
		/**每个轴长度的一半*/
		public var extents:Vector3;
		/**这个矩阵表示包围盒的位置和缩放,它的平移向量表示该包围盒的中心*/
		public var transformation:Matrix4x4;
		
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
		private static var _tempM0:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempM1:Matrix4x4 = new Matrix4x4();
		
		/**
		 * 根据AABB包围盒创建一个 <code>OrientedBoundBox</code> 实例。
		 * @param	box AABB包围盒。
		 */
		public function OrientedBoundBox(box:BoundBox) {
			
			var min:Vector3 = box.min;
			var max:Vector3 = box.max;
			
			Vector3.subtract(max, min, _tempV30);
			Vector3.scale(_tempV30, 0.5, _tempV30);
			Vector3.add(min, _tempV30, _tempV31);
			
			Vector3.subtract(max, _tempV31, extents);
			Matrix4x4.translation(_tempV31, transformation);
		}
		
		/**
		 * 根据包围盒的最大最小两顶点创建一个 <code>OrientedBoundBox</code> 实例。
		 * @param	min 包围盒的最小顶点。
		 * @param	max 包围盒的最大顶点。
		 */
		//public static function createByMinAndMaxVertex(min:Vector3, max:Vector3) {
		
		//	Vector3.subtract(max, min, _tempV30);
		//	Vector3.scale(_tempV30, 0.5, _tempV30);
		//	Vector3.add(min, _tempV30, _tempV31);
		
		//	Vector3.subtract(max, _tempV31, extents);
		//	Matrix4x4.translation(_tempV31, transformation);
		//}
		
		/**
		 * 获取OBB包围盒的8个角顶点。
		 * @param	corners 返回顶点的输出队列。
		 */
		public function getCorners(corners:Vector.<Vector3>):void {
			
			var extentsE:Float32Array = extents.elements;
			
			corners.length = 8;
			
			_tempV30.x = extentsE[0];
			_tempV31.y = extentsE[1];
			_tempV32.z = extentsE[2];
			
			Vector3.TransformNormal(_tempV30, transformation, _tempV30);
			Vector3.TransformNormal(_tempV31, transformation, _tempV31);
			Vector3.TransformNormal(_tempV32, transformation, _tempV32);
			
			_tempV33 = transformation.translationVector;
			
			Vector3.add(_tempV33, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[0]);
			
			Vector3.add(_tempV33, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[1]);
			
			Vector3.subtract(_tempV33, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[2]);
			
			Vector3.subtract(_tempV33, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[3]);
			
			Vector3.add(_tempV33, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[4]);
			
			Vector3.add(_tempV33, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[5]);
			
			Vector3.subtract(_tempV33, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[6]);
			
			Vector3.subtract(_tempV33, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[7]);
		
		}
		
		/**
		 * 变换该包围盒的矩阵信息。
		 * @param	mat 矩阵
		 */
		public function transform(mat:Matrix4x4):void {
			
			Matrix4x4.multiply(transformation, mat, transformation);
		}
		
		/**
		 * 缩放该包围盒
		 * @param	scaling 各轴的缩放比。
		 */
		public function scale(scaling:Vector3):void {
			
			Vector3.multiply(extents, scaling, extents);
		}
		
		/**
		 * 平移该包围盒。
		 * @param	translation 平移参数
		 */
		public function translate(translation:Vector3):void {
			
			var v3:Vector3 = transformation.translationVector;
			Vector3.add(v3, translation, _tempV30);
			transformation.translationVector = _tempV30;
		}
		
		/**
		 * 该包围盒的尺寸。
		 * @param	out 输出
		 */
		public function Size(out:Vector3):void {
			
			Vector3.scale(extents, 2, out);
		}
		
		/**
		 * 该包围盒需要考虑的尺寸
		 * @param	out 输出
		 */
		public function getSize(out:Vector3):void {
			
			var extentsE:Float32Array = extents.elements;
			_tempV30.x = extentsE[0];
			_tempV31.y = extentsE[1];
			_tempV32.z = extentsE[2];
			
			Vector3.TransformNormal(_tempV30, transformation, _tempV30);
			Vector3.TransformNormal(_tempV31, transformation, _tempV31);
			Vector3.TransformNormal(_tempV31, transformation, _tempV32);
			
			var oe:Float32Array = out.elements;
			oe[0] = Vector3.scalarLength(_tempV30);
			oe[1] = Vector3.scalarLength(_tempV31);
			oe[2] = Vector3.scalarLength(_tempV32);
		}
		
		/**
		 * 该包围盒需要考虑尺寸的平方
		 * @param	out 输出
		 */
		public function getSizeSquared(out:Vector3):void {
			
			var extentsE:Float32Array = extents.elements;
			_tempV30.x = extentsE[0];
			_tempV31.y = extentsE[1];
			_tempV32.z = extentsE[2];
			
			Vector3.TransformNormal(_tempV30, transformation, _tempV30);
			Vector3.TransformNormal(_tempV31, transformation, _tempV31);
			Vector3.TransformNormal(_tempV31, transformation, _tempV32);
			
			var oe:Float32Array = out.elements;
			oe[0] = Vector3.scalarLengthSquared(_tempV30);
			oe[1] = Vector3.scalarLengthSquared(_tempV31);
			oe[2] = Vector3.scalarLengthSquared(_tempV32);
		}
		
		/**
		 * 该包围盒的几何中心
		 */
		public function getCenter():Vector3 {
			
			return transformation.translationVector;
		}
		
		/**
		 * 该包围盒是否包含空间中一点
		 * @param	point 点
		 * @return  返回位置关系
		 */
		public function containsPoint(point:Vector3):int {
			
			var extentsE:Float32Array = extents.elements;
			var extentsEX:Number = extentsE[0];
			var extentsEY:Number = extentsE[1];
			var extentsEZ:Number = extentsE[2];
			
			transformation.invert(_tempM0);
			
			Vector3.transformCoordinate(point, _tempM0, _tempV30);
			
			var _tempV30e:Float32Array = _tempV30.elements;
			var _tempV30ex:Number = Math.abs(_tempV30e[0]);
			var _tempV30ey:Number = Math.abs(_tempV30e[1]);
			var _tempV30ez:Number = Math.abs(_tempV30e[2]);
			
			if (MathUtils3D.nearEqual(_tempV30ex, extentsEX) && MathUtils3D.nearEqual(_tempV30ey, extentsEY) && MathUtils3D.nearEqual(_tempV30ez, extentsEZ))
				return ContainmentType.Intersects;
			if (_tempV30ex < extentsEX && _tempV30ey < extentsEY && _tempV30ez < extentsEZ)
				return ContainmentType.Contains;
			else
				return ContainmentType.Disjoint;
		}
		
		/**
		 * 该包围盒是否包含空间中一包围球
		 * @param	sphere 包围球
		 * @param	ignoreScale 是否考虑该包围盒的缩放
		 * @return  返回位置关系
		 */
		public function containsSphere(sphere:BoundSphere, ignoreScale:Boolean = false):int {
			
			var extentsE:Float32Array = extents.elements;
			var extentsEX:Number = extentsE[0];
			var extentsEY:Number = extentsE[1];
			var extentsEZ:Number = extentsE[2];
			
			var sphereR:Number = sphere.radius;
			
			transformation.invert(_tempM0);
			Vector3.transformCoordinate(sphere.center, _tempM0, _tempV30);
			
			var locRadius:Number;
			
			if (ignoreScale) {
				
				locRadius = sphereR;
			} else {
				
				Vector3.scale(Vector3.UnitX, sphereR, _tempV31);
				Vector3.TransformNormal(_tempV31, _tempM0, _tempV31);
				locRadius = Vector3.scalarLength(_tempV31);
			}
			
			Vector3.scale(extents, -1, _tempV32);
			Vector3.Clamp(_tempV30, _tempV32, extents, _tempV33);
			var distance:Number = Vector3.distanceSquared(_tempV30, _tempV33);
			
			if (distance > locRadius * locRadius)
				return ContainmentType.Disjoint;
			
			var tempV30e:Float32Array = _tempV30.elements;
			var tempV30ex:Number = tempV30e[0];
			var tempV30ey:Number = tempV30e[1];
			var tempV30ez:Number = tempV30e[2];
			
			var tempV32e:Float32Array = _tempV32.elements;
			var tempV32ex:Number = tempV32e[0];
			var tempV32ey:Number = tempV32e[1];
			var tempV32ez:Number = tempV32e[2];
			
			if ((((tempV32ex + locRadius <= tempV30ex) && (tempV30ex <= extentsEX - locRadius)) && ((extentsEX - tempV32ex > locRadius) && (tempV32ey + locRadius <= tempV30ey))) && (((tempV30ey <= extentsEY - locRadius) && (extentsEY - tempV32ey > locRadius)) && (((tempV32ez + locRadius <= tempV30ez) && (tempV30ez <= extentsEZ - locRadius)) && (extentsEZ - tempV32ez > locRadius)))) {
				return ContainmentType.Contains;
			}
			
			return ContainmentType.Intersects;
		}
		
		private static function _getRows(mat:Matrix4x4, out:Vector.<Vector3>):void {
			out.length = 3;
			
			var mate:Float32Array = mat.elements;
			
			var row0e:Float32Array = out[0].elements;
			row0e[0] = mate[0];
			row0e[1] = mate[1];
			row0e[2] = mate[2];
			
			var row1e:Float32Array = out[1].elements;
			row1e[0] = mate[4];
			row1e[1] = mate[5];
			row1e[2] = mate[6];
			
			var row2e:Float32Array = out[2].elements;
			row2e[0] = mate[8];
			row2e[1] = mate[9];
			row2e[2] = mate[10];
		}
	
	/**
	 * 该包围盒是否包含空间中另一OBB包围盒
	 * @param	sphere 包围球
	 * @return  返回位置关系
	 */
		 //public function containsSphere(obb:OrientedBoundBox):int {
	
		 //to do
		 //}
	
	}

}