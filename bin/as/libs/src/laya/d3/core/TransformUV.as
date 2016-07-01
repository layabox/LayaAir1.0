package laya.d3.core {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>TransformUV</code> 类用于实现UV变换。
	 */
	public class TransformUV extends EventDispatcher {
		/** @private */
		protected var _tempTitlingV3:Vector3 = new Vector3();
		/** @private */
		protected var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _tempTitlingMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		protected var _matrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _offset:Vector2 = new Vector2();
		/** @private */
		protected var _rotation:Number = 0;
		/** @private */
		protected var _tiling:Vector2 = new Vector2();
		
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
		
		}
		
		/**
		 * @private
		 */
		protected function _updateMatrix():void {
			_tempTitlingV3.elements[0] = _tiling.x;
			_tempTitlingV3.elements[1] = _tiling.y;
			_tempTitlingV3.elements[2] = 1;
			
			Matrix4x4.createScaling(_tempTitlingV3, _tempTitlingMatrix);
			Matrix4x4.createRotationZ(_rotation, _tempRotationMatrix);
			Matrix4x4.multiply(_tempRotationMatrix, _tempTitlingMatrix, _matrix);
			var mate:Float32Array = _matrix.elements;
			mate[12] = _offset.x;
			mate[13] = _offset.y;
			mate[14] = 0;
		}
	
	}

}