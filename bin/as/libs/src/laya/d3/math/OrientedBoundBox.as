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
		private static var _tempV35:Vector3 = new Vector3();
		/** @private */
		private static var _tempV36:Vector3 = new Vector3();
		
		/** @private */
		private static var _tempM0:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempM1:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private static var _corners:* = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/** @private */
		private static var _rows1:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3()];
		/** @private */
		private static var _rows2:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3()];
		
		/** @private */
		private static var _ray:Ray = new Ray(new Vector3(), new Vector3());
		
		/** @private */
		private static var _boxBound1:BoundBox = new BoundBox(new Vector3(), new Vector3());
		/** @private */
		private static var _boxBound2:BoundBox = new BoundBox(new Vector3(), new Vector3());
		/** @private */
		private static var _boxBound3:BoundBox = new BoundBox(new Vector3(), new Vector3());
		
		/**
		 * 创建一个 <code>OrientedBoundBox</code> 实例。
		 * @param	extents 每个轴长度的一半
		 * @param	transformation  包围盒的位置和缩放,
		 */
		public function OrientedBoundBox(extents:Vector3, transformation:Matrix4x4) {
			
			this.extents = extents;
			this.transformation = transformation;
		}
		
		/**
		 * 根据AABB包围盒创建一个 <code>OrientedBoundBox</code> 实例。
		 * @param	box AABB包围盒。
		 */
		public static function createByBoundBox(box:BoundBox, out:OrientedBoundBox):void {
			var min:Vector3 = box.min;
			var max:Vector3 = box.max;
			
			Vector3.subtract(max, min, _tempV30);
			Vector3.scale(_tempV30, 0.5, _tempV30);
			Vector3.add(min, _tempV30, _tempV31);
			
			Vector3.subtract(max, _tempV31, _tempV32);
			Matrix4x4.translation(_tempV31, _tempM0);
			
			var extents:Vector3 = _tempV32.clone();
			var transformation:Matrix4x4 = _tempM0.clone();
			
			out.extents = extents;
			out.transformation = transformation;
		}
		
		/**
		 * 根据包围盒的最大最小两顶点创建一个 <code>OrientedBoundBox</code> 实例。
		 * @param	min 包围盒的最小顶点。
		 * @param	max 包围盒的最大顶点。
		 */
		public static function createByMinAndMaxVertex(min:Vector3, max:Vector3):OrientedBoundBox {
			
			Vector3.subtract(max, min, _tempV30);
			Vector3.scale(_tempV30, 0.5, _tempV30);
			Vector3.add(min, _tempV30, _tempV31);
			
			Vector3.subtract(max, _tempV31, _tempV32);
			Matrix4x4.translation(_tempV31, _tempM0);
			
			var obb:OrientedBoundBox = new OrientedBoundBox(_tempV32, _tempM0);
			return obb;
		}
		
		/**
		 * 获取OBB包围盒的8个顶点。
		 * @param	corners 返回顶点的输出队列。
		 */
		public function getCorners(corners:Vector.<Vector3>):void {
			var xve:Float32Array = _tempV30.elements;//_tempV30 xv 
			var yve:Float32Array = _tempV31.elements;//_tempV31 yv 
			var zve:Float32Array = _tempV32.elements;//_tempV32 zv 
			
			var extentsE:Float32Array = extents.elements;
			xve[0] = extentsE[0];
			xve[1] = xve[2] = 0;
			
			yve[1] = extentsE[1];
			yve[0] = yve[2] = 0;
			
			zve[2] = extentsE[2];
			zve[0] = zve[1] = 0;
			
			Vector3.TransformNormal(_tempV30, transformation, _tempV30);
			Vector3.TransformNormal(_tempV31, transformation, _tempV31);
			Vector3.TransformNormal(_tempV32, transformation, _tempV32);
			
			var center:Vector3 = _tempV33;//_tempV33 center
			transformation.getTranslationVector(center);
			
			corners.length = 8;
			Vector3.add(center, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[0]);
			
			Vector3.add(center, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[1]);
			
			Vector3.subtract(center, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[2]);
			
			Vector3.subtract(center, _tempV30, _tempV34);
			Vector3.add(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[3]);
			
			Vector3.add(center, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.add(_tempV34, _tempV32, corners[4]);
			
			Vector3.add(center, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[5]);
			
			Vector3.subtract(center, _tempV30, _tempV34);
			Vector3.subtract(_tempV34, _tempV31, _tempV34);
			Vector3.subtract(_tempV34, _tempV32, corners[6]);
			
			Vector3.subtract(center, _tempV30, _tempV34);
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
			transformation.getTranslationVector(_tempV30);
			Vector3.add(_tempV30, translation, _tempV31);
			transformation.setTranslationVector(_tempV31);
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
		public function getCenter(center:Vector3):void {
			transformation.getTranslationVector(center);
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
		 * 该包围盒是否包含空间中多点
		 * @param	point 点
		 * @return  返回位置关系
		 */
		public function containsPoints(points:Vector.<Vector3>):int {
			
			var extentse:Float32Array = extents.elements;
			var extentsex:Number = extentse[0];
			var extentsey:Number = extentse[1];
			var extentsez:Number = extentse[2];
			
			transformation.invert(_tempM0);
			
			var containsAll:Boolean = true;
			var containsAny:Boolean = false;
			
			for (var i:int = 0; i < points.length; i++) {
				
				Vector3.transformCoordinate(points[i], _tempM0, _tempV30);
				
				var _tempV30e:Float32Array = _tempV30.elements;
				var _tempV30ex:Number = Math.abs(_tempV30e[0]);
				var _tempV30ey:Number = Math.abs(_tempV30e[1]);
				var _tempV30ez:Number = Math.abs(_tempV30e[2]);
				
				if (MathUtils3D.nearEqual(_tempV30ex, extentsex) && MathUtils3D.nearEqual(_tempV30ey, extentsey) && MathUtils3D.nearEqual(_tempV30ez, extentsez))
					containsAny = true;
				if (_tempV30ex < extentsex && _tempV30ey < extentsey && _tempV30ez < extentsez)
					containsAny = true;
				else
					containsAll = false;
			}
			
			if (containsAll)
				return ContainmentType.Contains;
			else if (containsAny)
				return ContainmentType.Intersects;
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
		 *  For accuracy, The transformation matrix for both <see cref="OrientedBoundingBox"/> must not have any scaling applied to it.
		 *  Anyway, scaling using Scale method will keep this method accurate.
		 * 该包围盒是否包含空间中另一OBB包围盒
		 * @param	obb OBB包围盒
		 * @return  返回位置关系
		 */
		public function containsOrientedBoundBox(obb:OrientedBoundBox):int {
			var i:int, k:int;
			obb.getCorners(_corners);
			var cornersCheck:int = containsPoints(_corners);
			if (cornersCheck != ContainmentType.Disjoint)
				return cornersCheck;
			
			var sizeAe:Float32Array = extents.elements;
			obb.extents.cloneTo(_tempV35);
			var sizeBe:Float32Array = _tempV35.elements;
			
			_getRows(transformation, _rows1);
			_getRows(obb.transformation, _rows2);
			
			var extentA:Number, extentB:Number, separation:Number, dotNumber:Number;
			for (i = 0; i < 4; i++) {
				for (k = 0; k < 4; k++) {
					if (i == 3 || k == 3) {
						_tempM0.setElementByRowColumn(i, k, 0);
						_tempM1.setElementByRowColumn(i, k, 0);
					} else {
						dotNumber = Vector3.dot(_rows1[i], _rows2[k]);
						_tempM0.setElementByRowColumn(i, k, dotNumber);
						_tempM1.setElementByRowColumn(i, k, Math.abs(dotNumber));
					}
				}
			}
			
			obb.getCenter(_tempV34);
			getCenter(_tempV36);
			Vector3.subtract(_tempV34, _tempV36, _tempV30);
			
			var vsepAe:Float32Array = _tempV31.elements;
			vsepAe[0] = Vector3.dot(_tempV30, _rows1[0]);
			vsepAe[1] = Vector3.dot(_tempV30, _rows1[1]);
			vsepAe[2] = Vector3.dot(_tempV30, _rows1[2]);
			
			var _tempV32e:Float32Array = _tempV32.elements;
			var _tempV33e:Float32Array = _tempV33.elements;
			
			for (i = 0; i < 3; i++) {
				
				_tempV32e[0] = _tempM1.getElementByRowColumn(i, 0);
				_tempV32e[1] = _tempM1.getElementByRowColumn(i, 1);
				_tempV32e[2] = _tempM1.getElementByRowColumn(i, 2);
				
				extentA = sizeAe[i];
				extentB = Vector3.dot(_tempV35, _tempV32);
				separation = Math.abs(vsepAe[i]);
				
				if (separation > extentA + extentB)
					return ContainmentType.Disjoint;
			}
			
			for (k = 0; k < 3; k++) {
				
				_tempV32e[0] = _tempM1.getElementByRowColumn(0, k);
				_tempV32e[1] = _tempM1.getElementByRowColumn(1, k);
				_tempV32e[2] = _tempM1.getElementByRowColumn(2, k);
				
				_tempV33e[0] = _tempM0.getElementByRowColumn(0, k);
				_tempV33e[1] = _tempM0.getElementByRowColumn(1, k);
				_tempV33e[2] = _tempM0.getElementByRowColumn(2, k);
				
				extentA = Vector3.dot(extents, _tempV32);
				extentB = sizeBe[k];
				separation = Math.abs(Vector3.dot(_tempV31, _tempV33));
				
				if (separation > extentA + extentB)
					return ContainmentType.Disjoint;
			}
			
			for (i = 0; i < 3; i++) {
				
				for (k = 0; k < 3; k++) {
					
					var i1:Number = (i + 1) % 3, i2:Number = (i + 2) % 3;
					var k1:Number = (k + 1) % 3, k2:Number = (k + 2) % 3;
					extentA = sizeAe[i1] * _tempM1.getElementByRowColumn(i2, k) + sizeAe[i2] * _tempM1.getElementByRowColumn(i1, k);
					extentB = sizeBe[k1] * _tempM1.getElementByRowColumn(i, k2) + sizeBe[k2] * _tempM1.getElementByRowColumn(i, k1);
					separation = Math.abs(vsepAe[i2] * _tempM0.getElementByRowColumn(i1, k) - vsepAe[i1] * _tempM0.getElementByRowColumn(i2, k));
					if (separation > extentA + extentB)
						return ContainmentType.Disjoint;
				}
			}
			
			return ContainmentType.Intersects;
		
		}
		
		/**
		 * 该包围盒是否包含空间中一条线
		 * @param	point1 点1
		 * @param	point2 点2
		 * @return  返回位置关系
		 */
		public function containsLine(point1:Vector3, point2:Vector3):int {
			
			_corners[0] = point1;
			_corners[1] = point2;
			var cornersCheck:int = containsPoints(_corners);
			if (cornersCheck != ContainmentType.Disjoint)
				return cornersCheck;
			
			var extentsE:Float32Array = extents.elements;
			var extentsX:Number = extentsE[0];
			var extentsY:Number = extentsE[1];
			var extentsZ:Number = extentsE[2];
			
			transformation.invert(_tempM0);
			Vector3.transformCoordinate(point1, _tempM0, _tempV30);
			Vector3.transformCoordinate(point2, _tempM0, _tempV31);
			
			Vector3.add(_tempV30, _tempV31, _tempV32);
			Vector3.scale(_tempV32, 0.5, _tempV32);
			Vector3.subtract(_tempV30, _tempV32, _tempV33);
			
			var _tempV33e:Float32Array = _tempV33.elements;
			var _tempV33X:Number = _tempV33e[0];
			var _tempV33Y:Number = _tempV33e[1];
			var _tempV33Z:Number = _tempV33e[2];
			
			var _tempV34e:Float32Array = _tempV34.elements;
			var _tempV34X:Number = _tempV34e[0] = Math.abs(_tempV33e[0]);
			var _tempV34Y:Number = _tempV34e[1] = Math.abs(_tempV33e[1]);
			var _tempV34Z:Number = _tempV34e[2] = Math.abs(_tempV33e[2]);
			
			var _tempV32e:Float32Array = _tempV32.elements;
			var _tempV32X:Number = _tempV32e[0];
			var _tempV32Y:Number = _tempV32e[1];
			var _tempV32Z:Number = _tempV32e[2];
			
			if (Math.abs(_tempV32X) > extentsX + _tempV34X)
				return ContainmentType.Disjoint;
			
			if (Math.abs(_tempV32Y) > extentsY + _tempV34Y)
				return ContainmentType.Disjoint;
			
			if (Math.abs(_tempV32Z) > extentsZ + _tempV34Z)
				return ContainmentType.Disjoint;
			
			if (Math.abs(_tempV32Y * _tempV33Z - _tempV32Z * _tempV33Y) > (extentsY * _tempV34Z + extentsZ * _tempV34Y))
				return ContainmentType.Disjoint;
			
			if (Math.abs(_tempV32X * _tempV33Z - _tempV32Z * _tempV33X) > (extentsX * _tempV34Z + extentsZ * _tempV34X))
				return ContainmentType.Disjoint;
			
			if (Math.abs(_tempV32X * _tempV33Y - _tempV32Y * _tempV33X) > (extentsX * _tempV34Y + extentsY * _tempV34X))
				return ContainmentType.Disjoint;
			
			return ContainmentType.Intersects;
		
		}
		
		/**
		 * 该包围盒是否包含空间中另一OBB包围盒
		 * @param	box 包围盒
		 * @return  返回位置关系
		 */
		public function containsBoundBox(box:BoundBox):int {
			
			var i:int, k:int;
			var min:Vector3 = box.min;
			var max:Vector3 = box.max;
			
			box.getCorners(_corners);
			var cornersCheck:int = containsPoints(_corners);
			if (cornersCheck != ContainmentType.Disjoint)
				return cornersCheck;
			
			Vector3.subtract(max, min, _tempV30);
			Vector3.scale(_tempV30, 0.5, _tempV30);
			Vector3.add(min, _tempV30, _tempV30);
			
			Vector3.subtract(max, _tempV30, _tempV31);
			
			var sizeAe:Float32Array = extents.elements;
			var sizeBe:Float32Array = _tempV31.elements;
			
			_getRows(transformation, _rows1);
			transformation.invert(_tempM0);
			
			var extentA:Number, extentB:Number, separation:Number, dotNumber:Number;
			
			for (i = 0; i < 3; i++) {
				for (k = 0; k < 3; k++) {
					_tempM1.setElementByRowColumn(i, k, Math.abs(_tempM0.getElementByRowColumn(i, k)));
				}
			}
			
			getCenter(_tempV35);
			Vector3.subtract(_tempV30, _tempV35, _tempV32);
			
			var vsepAe:Float32Array = _tempV31.elements;
			vsepAe[0] = Vector3.dot(_tempV32, _rows1[0]);
			vsepAe[1] = Vector3.dot(_tempV32, _rows1[1]);
			vsepAe[2] = Vector3.dot(_tempV32, _rows1[2]);
			
			var _tempV33e:Float32Array = _tempV33.elements;
			var _tempV34e:Float32Array = _tempV34.elements;
			
			for (i = 0; i < 3; i++) {
				
				_tempV33e[0] = _tempM1.getElementByRowColumn(i, 0);
				_tempV33e[1] = _tempM1.getElementByRowColumn(i, 1);
				_tempV33e[2] = _tempM1.getElementByRowColumn(i, 2);
				
				extentA = sizeAe[i];
				extentB = Vector3.dot(_tempV31, _tempV33);
				separation = Math.abs(vsepAe[i]);
				
				if (separation > extentA + extentB)
					return ContainmentType.Disjoint;
			}
			
			for (k = 0; k < 3; k++) {
				
				_tempV33e[0] = _tempM1.getElementByRowColumn(0, k);
				_tempV33e[1] = _tempM1.getElementByRowColumn(1, k);
				_tempV33e[2] = _tempM1.getElementByRowColumn(2, k);
				
				_tempV34e[0] = _tempM0.getElementByRowColumn(0, k);
				_tempV34e[1] = _tempM0.getElementByRowColumn(1, k);
				_tempV34e[2] = _tempM0.getElementByRowColumn(2, k);
				
				extentA = Vector3.dot(extents, _tempV33);
				extentB = sizeBe[k];
				separation = Math.abs(Vector3.dot(_tempV31, _tempV34));
				
				if (separation > extentA + extentB)
					return ContainmentType.Disjoint;
			}
			
			for (i = 0; i < 3; i++) {
				for (k = 0; k < 3; k++) {
					
					var i1:Number = (i + 1) % 3, i2:Number = (i + 2) % 3;
					var k1:Number = (k + 1) % 3, k2:Number = (k + 2) % 3;
					extentA = sizeAe[i1] * _tempM1.getElementByRowColumn(i2, k) + sizeAe[i2] * _tempM1.getElementByRowColumn(i1, k);
					extentB = sizeBe[k1] * _tempM1.getElementByRowColumn(i, k2) + sizeBe[k2] * _tempM1.getElementByRowColumn(i, k1);
					separation = Math.abs(vsepAe[i2] * _tempM0.getElementByRowColumn(i1, k) - vsepAe[i1] * _tempM0.getElementByRowColumn(i2, k));
					if (separation > extentA + extentB)
						return ContainmentType.Disjoint;
				}
			}
			
			return ContainmentType.Intersects;
		}
		
		/**
		 * 该包围盒是否与空间中另一射线相交
		 * @param	ray
		 * @param	out
		 * @return
		 */
		public function intersectsRay(ray:Ray, out:Vector3):Number {
			
			Vector3.scale(extents, -1, _tempV30);
			
			transformation.invert(_tempM0);
			
			Vector3.TransformNormal(ray.direction, _tempM0, _ray.direction);
			Vector3.transformCoordinate(ray.origin, _tempM0, _ray.origin);
			
			_boxBound1.min = _tempV30;
			_boxBound1.max = extents;
			
			var intersects:Number = Collision.intersectsRayAndBoxRP(_ray, _boxBound1, out);
			
			if (intersects !== -1)
				Vector3.transformCoordinate(out, transformation, out);
			
			return intersects;
		}
		
		private function _getLocalCorners(corners:Vector.<Vector3>):void {
			
			corners.length = 8;
			
			var extentsE:Float32Array = extents.elements;
			
			_tempV30.x = extentsE[0];
			_tempV31.y = extentsE[1];
			_tempV32.z = extentsE[2];
			
			Vector3.add(_tempV30, _tempV31, _tempV33);
			Vector3.add(_tempV33, _tempV32, corners[0]);
			
			Vector3.add(_tempV30, _tempV31, _tempV33);
			Vector3.subtract(_tempV33, _tempV32, corners[1]);
			
			Vector3.subtract(_tempV31, _tempV30, _tempV33);
			Vector3.subtract(_tempV33, _tempV30, corners[2]);
			
			Vector3.subtract(_tempV31, _tempV30, _tempV33);
			Vector3.add(_tempV33, _tempV32, corners[3]);
			
			Vector3.subtract(_tempV30, _tempV31, _tempV33);
			Vector3.add(_tempV33, _tempV32, corners[4]);
			
			Vector3.subtract(_tempV30, _tempV31, _tempV33);
			Vector3.subtract(_tempV33, _tempV32, corners[5]);
			
			Vector3.scale(corners[0], -1, corners[6]);
			
			Vector3.subtract(_tempV32, _tempV30, _tempV33);
			Vector3.subtract(_tempV33, _tempV31, corners[7]);
		
		}
		
		/**
		 * 计算Obb包围盒变换到另一Obb包围盒的矩阵
		 * @param	a Obb包围盒
		 * @param	b Obb包围盒
		 * @param	noMatrixScaleApplied 是否考虑缩放
		 * @param	out 输出变换矩阵
		 */
		public static function getObbtoObbMatrix4x4(a:OrientedBoundBox, b:OrientedBoundBox, noMatrixScaleApplied:Boolean, out:Matrix4x4):void {
			
			var at:Matrix4x4 = a.transformation;
			var bt:Matrix4x4 = b.transformation;
			
			if (noMatrixScaleApplied) {
				
				_getRows(at, _rows1);
				_getRows(bt, _rows2);
				
				for (var i:int = 0; i < 3; i++) {
					for (var k:int = 0; k < 3; k++) {
						out.setElementByRowColumn(i, k, Vector3.dot(_rows2[i], _rows1[k]));
					}
				}
				
				b.getCenter(_tempV30);
				a.getCenter(_tempV31);
				Vector3.subtract(_tempV30, _tempV31, _tempV32);
				var AtoBMe:Float32Array = out.elements;
				AtoBMe[12] = Vector3.dot(_tempV32, _rows1[0]);
				AtoBMe[13] = Vector3.dot(_tempV32, _rows1[1]);
				AtoBMe[14] = Vector3.dot(_tempV32, _rows1[2]);
				AtoBMe[15] = 1;
				
			} else {
				
				at.invert(_tempM0);
				Matrix4x4.multiply(bt, _tempM0, out);
			}
		}
		
		/**
		 * 把一个Obb类型的包围盒b合入另一Obb型包围盒a
		 * @param	a obb包围盒
		 * @param	b obb包围盒
		 * @param	noMatrixScaleApplied 是否考虑缩放
		 */
		public static function merge(a:OrientedBoundBox, b:OrientedBoundBox, noMatrixScaleApplied:Boolean):void {
			
			var ae:Vector3 = a.extents;
			var at:Matrix4x4 = a.transformation;
			
			getObbtoObbMatrix4x4(a, b, noMatrixScaleApplied, _tempM0);
			b._getLocalCorners(_corners);
			
			Vector3.transformCoordinate(_corners[0], _tempM0, _corners[0]);
			Vector3.transformCoordinate(_corners[1], _tempM0, _corners[1]);
			Vector3.transformCoordinate(_corners[2], _tempM0, _corners[2]);
			Vector3.transformCoordinate(_corners[3], _tempM0, _corners[3]);
			Vector3.transformCoordinate(_corners[4], _tempM0, _corners[4]);
			Vector3.transformCoordinate(_corners[5], _tempM0, _corners[5]);
			Vector3.transformCoordinate(_corners[6], _tempM0, _corners[6]);
			Vector3.transformCoordinate(_corners[7], _tempM0, _corners[7]);
			
			Vector3.scale(ae, -1, _boxBound1.min);
			ae.cloneTo(_boxBound1.max);
			
			BoundBox.createfromPoints(_corners, _boxBound2);
			BoundBox.merge(_boxBound2, _boxBound1, _boxBound3);
			
			var box3Min:Vector3 = _boxBound3.min;
			var box3Max:Vector3 = _boxBound3.max;
			
			Vector3.subtract(box3Max, box3Min, _tempV30);
			Vector3.scale(_tempV30, 0.5, _tempV30);
			Vector3.add(box3Min, _tempV30, _tempV32);
			Vector3.subtract(box3Max, _tempV32, ae);
			
			Vector3.transformCoordinate(_tempV32, at, _tempV33);
			//_tempV33.cloneTo(at.getTranslationVector());//TODO:WZY
		
		}
		
		/**
		 * 判断两个包围盒是否相等
		 * @param	obb obb包围盒
		 * @return  Boolean
		 */
		public function equals(obb:OrientedBoundBox):Boolean {
			
			return extents == obb.extents && transformation == obb.transformation;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:OrientedBoundBox = destObject as OrientedBoundBox;
			extents.cloneTo(dest.extents);
			transformation.cloneTo(dest.transformation);
		}
	
	}

}