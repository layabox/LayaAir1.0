package laya.d3.core.camera {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	
	/**
	 * <code>Camera</code> 类用于创建VR摄像机。
	 */
	public class VRCamera extends BaseCamera {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/** @private */
		private var _tempMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		protected var _leftAspectRatio:Number;
		/** @private */
		protected var _leftViewport:Viewport = new Viewport(0, 0, 0, 0);
		/** @private */
		protected var _leftViewMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _leftProjectionMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _leftProjectionViewMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _rightAspectRatio:Number;
		/** @private */
		protected var _rightViewport:Viewport = new Viewport(0, 0, 0, 0);
		/** @private */
		protected var _rightViewMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _rightProjectionMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _rightProjectionViewMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _pupilDistande:int;
		
		/**
		 * 获取左横纵比。
		 * @return 左横纵比。
		 */
		public function get leftAspectRatio():Number {
			if (_leftAspectRatio === 0)
				return _leftViewport.width / _leftViewport.height;
			return _leftAspectRatio;
		}
		
		/**
		 * 设置左横纵比。
		 * @param value 左横纵比。
		 */
		public function set leftAspectRatio(value:Number):void {
			if (leftAspectRatio < 0)
				throw new Error("横纵比必须是正值得Number！");
			_leftAspectRatio = value;
			_calculateLeftProjectionMatrix();
		}
		
		/**
		 * 获取右横纵比。
		 * @return 右横纵比。
		 */
		public function get rightAspectRatio():Number {
			if (_rightAspectRatio === 0)
				return _rightViewport.width / _rightViewport.height;
			return _rightAspectRatio;
		}
		
		/**
		 * 设置右横纵比。
		 * @param value 右横纵比。
		 */
		public function set rightAspectRatio(value:Number):void {
			if (rightAspectRatio < 0)
				throw new Error("横纵比必须是正值得Number！");
			_rightAspectRatio = value;
			_calculateRightProjectionMatrix();
		}
		
		/**
		 * 获取左视图。
		 * @return 左视图。
		 */
		public function get leftViewport():Viewport {
			return _leftViewport;
		}
		
		/**
		 * 设置左视图。
		 * @param value 左视图。
		 */
		public function set leftViewport(vaule:Viewport):void {
			_leftViewport = vaule;
			_calculateLeftProjectionMatrix();
		}
		
		/**
		 * 获取右视图。
		 * @return 右视图。
		 */
		public function get rightViewport():Viewport {
			return _rightViewport;
		}
		
		/**
		 * 设置右视图。
		 * @param value 右视图。
		 */
		public function set rightViewport(vaule:Viewport):void {
			_rightViewport = vaule;
			_calculateRightProjectionMatrix();
		}
		
		/**
		 * 获取左视图矩阵。
		 * @return 左视图矩阵。
		 */
		public function get leftViewMatrix():Matrix4x4 {
			var offsetE:Float32Array = _calculatePupilOffset();
			var tempWorldMat:Matrix4x4 = _tempMatrix;
			transform.worldMatrix.cloneTo(tempWorldMat);
			var worldMatE:Float32Array = tempWorldMat.elements;
			worldMatE[12] -= offsetE[0];
			worldMatE[13] -= offsetE[1];
			worldMatE[14] -= offsetE[2];
			tempWorldMat.invert(_leftViewMatrix);
			return _leftViewMatrix;
		}
		
		/**
		 * 获取右视图矩阵。
		 * @return 右视图矩阵。
		 */
		public function get rightViewMatrix():Matrix4x4 {
			var offsetE:Float32Array = _calculatePupilOffset();
			var tempWorldMat:Matrix4x4 = _tempMatrix;
			transform.worldMatrix.cloneTo(tempWorldMat);
			var worldMatE:Float32Array = tempWorldMat.elements;
			worldMatE[12] += offsetE[0];
			worldMatE[13] += offsetE[1];
			worldMatE[14] += offsetE[2];
			tempWorldMat.invert(_rightViewMatrix);
			return _rightViewMatrix;
		}
		
		/**
		 * 获取左投影矩阵。
		 * @return 左投影矩阵。
		 */
		public function get leftProjectionMatrix():Matrix4x4 {
			return _leftProjectionMatrix;
		}
		
		/**
		 * 获取右投影矩阵。
		 * @return 右投影矩阵。
		 */
		public function get rightProjectionMatrix():Matrix4x4 {
			return _rightProjectionMatrix;
		}
		
		/**
		 * 获取左投影视图矩阵。
		 * @return 左投影视图矩阵。
		 */
		public function get leftProjectionViewMatrix():Matrix4x4 {
			Matrix4x4.multiply(leftProjectionMatrix, leftViewMatrix, _leftProjectionViewMatrix);
			return _leftProjectionViewMatrix;
		}
		
		/**
		 * 获取右投影视图矩阵。
		 * @return 右投影视图矩阵。
		 */
		public function get rightProjectionViewMatrix():Matrix4x4 {
			Matrix4x4.multiply(rightProjectionMatrix, rightViewMatrix, _rightProjectionViewMatrix);
			return _rightProjectionViewMatrix;
		}
		
		/**
		 * 创建一个 <code>VRCamera</code> 实例。
		 * @param	leftViewport 左视口。
		 * @param	rightViewport 右视口。
		 * @param	pupilDistande 瞳距。
		 * @param	fieldOfView 视野。
		 *  @param	leftAspectRatio 左横纵比。
		 *   @param	rightAspectRatio 右横纵比。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function VRCamera(leftViewport:Viewport, rightViewport:Viewport, pupilDistande:int = 8, fieldOfView:Number = Math.PI / 3, leftAspectRatio:Number = 0, rightAspectRatio:Number = 0, nearPlane:Number = 0.1, farPlane:Number = 1000) {
			_leftViewport = leftViewport;
			_rightViewport = rightViewport;
			_pupilDistande = pupilDistande;
			_leftAspectRatio = leftAspectRatio;
			_rightAspectRatio = rightAspectRatio;
			super(fieldOfView, nearPlane, farPlane);
		}
		
		/**
		 * @private
		 * 计算瞳距。
		 */
		private function _calculatePupilOffset():Float32Array {
			var offset:Vector3 = _tempVector3;
			Vector3.scale(right, _pupilDistande / 2, offset);
			return offset.elements;
		}
		
		/**
		 * @private
		 * 计算左投影矩阵。
		 */
		protected function _calculateLeftProjectionMatrix():void {
			
			if (!_isOrthographicProjection) {
				Matrix4x4.createPerspective(fieldOfView, leftAspectRatio, nearPlane, farPlane, _leftProjectionMatrix);
				trace(fieldOfView, leftAspectRatio, nearPlane, farPlane, _leftProjectionMatrix);
			}
			_projectionMatrixModifyID += 0.01 / id;//TODO:可能第二次分屏无法更新
		}
		
		/**
		 * @private
		 * 计算右投影矩阵。
		 */
		protected function _calculateRightProjectionMatrix():void {
			if (!_isOrthographicProjection) {
				Matrix4x4.createPerspective(fieldOfView, rightAspectRatio, nearPlane, farPlane, _rightProjectionMatrix);
				trace(fieldOfView, rightAspectRatio, nearPlane, farPlane, _rightProjectionMatrix);
			}
			_projectionMatrixModifyID += 0.01 / id;//TODO:可能第二次分屏无法更新
		}
		
		/**
		 * @private
		 * 计算投影矩阵。
		 */
		override protected function _calculateProjectionMatrix():void {
			if (!_isOrthographicProjection) {
				Matrix4x4.createPerspective(fieldOfView, leftAspectRatio, nearPlane, farPlane, _leftProjectionMatrix);
				Matrix4x4.createPerspective(fieldOfView, rightAspectRatio, nearPlane, farPlane, _rightProjectionMatrix);
			}
			_projectionMatrixModifyID += 0.01 / id;//TODO:可能第二次分屏无法更新
		}
	
	}
}