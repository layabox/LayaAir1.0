package laya.d3.core {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>TransformUV</code> 类用于实现UV变换。
	 */
	public class TransformUV extends EventDispatcher implements IClone {
		/** @private */
		protected static var _tempOffsetV3:Vector3 = new Vector3(0, 0, 0);
		/** @private */
		protected static var _tempRotationQua:Quaternion = new Quaternion();
		/** @private */
		protected static var _tempTitlingV3:Vector3 = new Vector3(1, 1, 1);
		
		/** @private */
		protected var _matrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _offset:Vector2 = new Vector2();
		/** @private */
		protected var _rotation:Number = 0;
		/** @private */
		protected var _tiling:Vector2;
		
		/** @private */
		protected var _matNeedUpdte:Boolean = false;
		
		/**
		 *获取变换矩阵。
		 * @return 变换矩阵。
		 */
		public function get matrix():Matrix4x4 {
			if (_matNeedUpdte) {
				_updateMatrix();
				_matNeedUpdte = false;
			}
			return _matrix;
		}
		
		/**
		 *获取偏移。
		 * @return 偏移。
		 */
		public function get offset():Vector2 {
			return _offset;
		}
		
		/**
		 *设置偏移。
		 * @param value 偏移。
		 */
		public function set offset(value:Vector2):void {
			_offset = value;
			_matNeedUpdte = true;
		}
		
		/**
		 *获取旋转。
		 * @return 旋转。
		 */
		public function get rotation():Number {
			return _rotation;
		}
		
		/**
		 *设置旋转。
		 * @param value 旋转。
		 */
		public function set rotation(value:Number):void {
			_rotation = value;
			_matNeedUpdte = true;
		}
		
		/**
		 *获取平铺次数。
		 * @return 平铺次数。
		 */
		public function get tiling():Vector2 {
			return _tiling;
		}
		
		/**
		 *设置平铺次数。
		 * @param value 平铺次数。
		 */
		public function set tiling(value:Vector2):void {
			_tiling = value;
			_matNeedUpdte = true;
		}
		
		/**
		 * 创建一个 <code>TransformUV</code> 实例。
		 */
		public function TransformUV() {
			_tiling = new Vector2(1.0, 1.0);
		}
		
		/**
		 * @private
		 */
		protected function _updateMatrix():void {
			_tempOffsetV3.elements[0] = _offset.x;
			_tempOffsetV3.elements[1] = _offset.y;
			Quaternion.createFromYawPitchRoll(0, 0, _rotation, _tempRotationQua);
			_tempTitlingV3.elements[0] = _tiling.x;
			_tempTitlingV3.elements[1] = _tiling.y;
			
			Matrix4x4.createAffineTransformation(_tempOffsetV3, _tempRotationQua, _tempTitlingV3, _matrix);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			destObject._matrix = _matrix.clone();
			destObject._offset = _offset.clone();
			destObject._rotation = _rotation;
			destObject._tiling = _tiling.clone();
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:TransformUV = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	
	}

}