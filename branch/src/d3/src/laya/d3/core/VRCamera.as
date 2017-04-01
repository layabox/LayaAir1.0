package laya.d3.core {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.utils.Size;
	
	/**
	 * <code>Camera</code> 类用于创建VR摄像机。
	 */
	public class VRCamera extends BaseCamera {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** @private */
		private var _tempMatrix:Matrix4x4;
		
		/** @private 左横纵比。*/
		private var _leftAspectRatio:Number;
		/** @private 在屏幕空间中摄像机的左视口。*/
		private var _leftViewport:Viewport;
		/** @private 在裁剪空间中摄像机的视口。*/
		private var _leftNormalizedViewport:Viewport;
		/** @private 左视图矩阵。*/
		private var _leftViewMatrix:Matrix4x4;
		/**@private 左投影矩阵。*/
		private var _leftProjectionMatrix:Matrix4x4;
		/** @private 左投影视图矩阵。*/
		private var _leftProjectionViewMatrix:Matrix4x4;
		
		/** @private 左横纵比。*/
		private var _rightAspectRatio:Number;
		/** @private 在屏幕空间中摄像机的左视口。*/
		private var _rightViewport:Viewport;
		/** @private 在裁剪空间中摄像机的视口。*/
		private var _rightNormalizedViewport:Viewport;
		/** @private 左视图矩阵。*/
		private var _rightViewMatrix:Matrix4x4;
		/**@private 左投影矩阵。*/
		private var _rightProjectionMatrix:Matrix4x4;
		/** @private 左投影视图矩阵。*/
		private var _rightProjectionViewMatrix:Matrix4x4;
		/** @private 瞳距。*/
		private var _pupilDistande:int;
		
		/**
		 * 获取左横纵比。
		 * @return 左横纵比。
		 */
		public function get leftAspectRatio():Number {
			if (_leftAspectRatio === 0) {
				var lVp:Viewport = leftViewport;
				return lVp.width / lVp.height;
			}
			return _leftAspectRatio;
		}
		
		/**
		 * 获取右横纵比。
		 * @return 右横纵比。
		 */
		public function get rightAspectRatio():Number {
			if (_rightAspectRatio === 0) {
				var rVp:Viewport = rightViewport;
				return rVp.width / rVp.height;
			}
			return _rightAspectRatio;
		}
		
		/**
		 * 设置横纵比。
		 * @param value 横纵比。
		 */
		public function set aspectRatio(value:Number):void {
			if (value < 0)
				throw new Error("VRCamera: the aspect ratio has to be a positive real number.");
			_leftAspectRatio = value;
			_rightAspectRatio = value;
			_calculateRightProjectionMatrix();
		}
		
		/**
		 * 获取屏幕空间的左视口。
		 * @return 屏幕空间的左视口。
		 */
		public function get leftViewport():Viewport {
			if (_viewportExpressedInClipSpace) {
				var nVp:Viewport = _leftNormalizedViewport;
				var size:Size = renderTargetSize;
				var sizeW:int = size.width;
				var sizeH:int = size.height;
				_leftViewport.x = nVp.x * sizeW;
				_leftViewport.y = nVp.y * sizeH;
				_leftViewport.width = nVp.width * sizeW;
				_leftViewport.height = nVp.height * sizeH;
			}
			return _leftViewport;
		}
		
		/**
		 * 获取屏幕空间的右视口。
		 * @return 屏幕空间的右视口。
		 */
		public function get rightViewport():Viewport {
			if (_viewportExpressedInClipSpace) {
				var nVp:Viewport = _rightNormalizedViewport;
				var size:Size = renderTargetSize;
				var sizeW:int = size.width;
				var sizeH:int = size.height;
				_rightViewport.x = nVp.x * sizeW;
				_rightViewport.y = nVp.y * sizeH;
				_rightViewport.width = nVp.width * sizeW;
				_rightViewport.height = nVp.height * sizeH;
			}
			return _rightViewport;
		}
		
		/**
		 * 设置屏幕空间的视口。
		 * @param 屏幕空间的视口。
		 */
		public function set viewport(value:Viewport):void {
			if (renderTarget != null && (value.x < 0 || value.y < 0 || value.width == 0 || value.height == 0))
				throw new Error("VRCamera: viewport size invalid.", "value");
			_viewportExpressedInClipSpace = false;
			_leftViewport = new Viewport(0, 0, value.width / 2, value.height);
			_rightViewport = new Viewport(value.width / 2, 0, value.width / 2, value.height);
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取裁剪空间的左视口。
		 * @return 裁剪空间的左视口。
		 */
		public function get leftNormalizedViewport():Viewport {
			if (!_viewportExpressedInClipSpace) {
				var vp:Viewport = _leftViewport;
				var size:Size = renderTargetSize;
				var sizeW:int = size.width;
				var sizeH:int = size.height;
				_leftNormalizedViewport.x = vp.x / sizeW;
				_leftNormalizedViewport.y = vp.y / sizeH;
				_leftNormalizedViewport.width = vp.width / sizeW;
				_leftNormalizedViewport.height = vp.height / sizeH;
			}
			return _leftNormalizedViewport;
		}
		
		/**
		 * 获取裁剪空间的右视口。
		 * @return 裁剪空间的右视口。
		 */
		public function get rightNormalizedViewport():Viewport {
			if (!_viewportExpressedInClipSpace) {
				var vp:Viewport = _rightViewport;
				var size:Size = renderTargetSize;
				var sizeW:int = size.width;
				var sizeH:int = size.height;
				_rightNormalizedViewport.x = vp.x / sizeW;
				_rightNormalizedViewport.y = vp.y / sizeH;
				_rightNormalizedViewport.width = vp.width / sizeW;
				_rightNormalizedViewport.height = vp.height / sizeH;
			}
			return _rightNormalizedViewport;
		}
		
		/**
		 * 设置裁剪空间的视口。
		 * @return 裁剪空间的视口。
		 */
		public function set normalizedViewport(value:Viewport):void {
			if (value.x < 0 || value.y < 0 || (value.x + value.width) > 1 || (value.x + value.height) > 1)
				throw new Error("VRCamera: viewport size invalid.", "value");
			_viewportExpressedInClipSpace = true;
			
			_leftNormalizedViewport = new Viewport(0, 0, value.width / 2, value.height);
			_rightNormalizedViewport = new Viewport(value.width / 2, 0, value.width / 2, value.height);
			
			_calculateProjectionMatrix();
		}
		
		public function get needLeftViewport():Boolean {
			var nVp:Viewport = leftNormalizedViewport;
			return nVp.x === 0 && nVp.y === 0 && nVp.width === 1 && nVp.height === 1;
		}
		
		public function get needRightViewport():Boolean {
			var nVp:Viewport = rightNormalizedViewport;
			return nVp.x === 0 && nVp.y === 0 && nVp.width === 1 && nVp.height === 1;
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
		 * @param	leftAspectRatio 左横纵比。
		 * @param	rightAspectRatio 右横纵比。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function VRCamera(pupilDistande:Number = 0.1, leftAspectRatio:Number = 0, rightAspectRatio:Number = 0, nearPlane:Number = 0.1, farPlane:Number = 1000) {
			_tempMatrix = new Matrix4x4();
			_leftViewMatrix = new Matrix4x4();
			_leftProjectionMatrix = new Matrix4x4();
			_leftProjectionViewMatrix = new Matrix4x4();
			_leftViewport = new Viewport(0, 0, 0, 0);
			_leftNormalizedViewport = new Viewport(0, 0, 0.5, 1);
			_leftAspectRatio = leftAspectRatio;
			
			_rightViewMatrix = new Matrix4x4();
			_rightProjectionMatrix = new Matrix4x4();
			_rightProjectionViewMatrix = new Matrix4x4();
			_rightViewport = new Viewport(0, 0, 0, 0);
			_rightNormalizedViewport = new Viewport(0.5, 0, 0.5, 1);
			_rightAspectRatio = rightAspectRatio;
			
			_pupilDistande = pupilDistande;
			super(nearPlane, farPlane);
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
		private function _calculateLeftProjectionMatrix():void {
			if (!_useUserProjectionMatrix) {
				if (orthographicProjection) {
					var leftHalfWidth:Number = orthographicVerticalSize * leftAspectRatio * 0.5;
					var leftHalfHeight:Number = orthographicVerticalSize * 0.5;
					Matrix4x4.createOrthogonal(-leftHalfWidth, leftHalfWidth, -leftHalfHeight, leftHalfHeight, nearPlane, farPlane, _leftProjectionMatrix);
				} else {
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, leftAspectRatio, nearPlane, farPlane, _rightProjectionMatrix);
				}
			}
			_projectionMatrixModifyID += 0.01 / id;
		}
		
		/**
		 * @private
		 * 计算右投影矩阵。
		 */
		private function _calculateRightProjectionMatrix():void {
			if (!_useUserProjectionMatrix) {
				if (orthographicProjection) {
					var rightHalfWidth:Number = orthographicVerticalSize * rightAspectRatio * 0.5;
					var rightHalfHeight:Number = orthographicVerticalSize * 0.5;
					
					Matrix4x4.createOrthogonal(-rightHalfWidth, rightHalfWidth, rightHalfHeight, rightHalfHeight, nearPlane, farPlane, _rightProjectionMatrix);
				} else {
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, rightAspectRatio, nearPlane, farPlane, _rightProjectionMatrix);
				}
			}
			_projectionMatrixModifyID += 0.01 / id;
		}
		
		/**
		 * @private
		 * 计算投影矩阵。
		 */
		override protected function _calculateProjectionMatrix():void {
			if (!_useUserProjectionMatrix) {
				if (orthographicProjection) {
					var leftHalfWidth:Number = orthographicVerticalSize * leftAspectRatio * 0.5;
					var leftHalfHeight:Number = orthographicVerticalSize * 0.5;
					var rightHalfWidth:Number = orthographicVerticalSize * rightAspectRatio * 0.5;
					var rightHalfHeight:Number = orthographicVerticalSize * 0.5;
					
					Matrix4x4.createOrthogonal(-leftHalfWidth, leftHalfWidth, -leftHalfHeight, leftHalfHeight, nearPlane, farPlane, _leftProjectionMatrix);
					Matrix4x4.createOrthogonal(-rightHalfWidth, rightHalfWidth, rightHalfHeight, rightHalfHeight, nearPlane, farPlane, _rightProjectionMatrix);
				} else {
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, leftAspectRatio, nearPlane, farPlane, _leftProjectionMatrix);
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, rightAspectRatio, nearPlane, farPlane, _rightProjectionMatrix);
				}
			}
			_projectionMatrixModifyID += 0.01 / id;
		}
	
	}
}