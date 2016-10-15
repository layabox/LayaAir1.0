package laya.d3.core {
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.utils.Picker;
	import laya.d3.utils.Size;
	
	/**
	 * <code>Camera</code> 类用于创建摄像机。
	 */
	public class Camera extends BaseCamera {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _tempVector2:Vector2 = new Vector2();
		
		/** @private 横纵比。*/
		private var _aspectRatio:Number;
		/** @private 在屏幕空间中摄像机的视口。*/
		private var _viewport:Viewport;
		/** @private 在裁剪空间中摄像机的视口。*/
		private var _normalizedViewport:Viewport;
		/** @private 视图矩阵。*/
		private var _viewMatrix:Matrix4x4;
		/**@private 投影矩阵。*/
		private var _projectionMatrix:Matrix4x4;
		/** @private 投影视图矩阵。*/
		private var _projectionViewMatrix:Matrix4x4;
		
		/**
		 * 获取横纵比。
		 * @return 横纵比。
		 */
		public function get aspectRatio():Number {
			if (_aspectRatio === 0) {
				var vp:Viewport = viewport;
				return vp.width / vp.height;
			}
			return _aspectRatio;
		}
		
		/**
		 * 设置横纵比。
		 * @param value 横纵比。
		 */
		public function set aspectRatio(value:Number):void {
			if (value < 0)
				throw new Error("Camera: the aspect ratio has to be a positive real number.");
			_aspectRatio = value;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取屏幕空间的视口。
		 * @return 屏幕空间的视口。
		 */
		public function get viewport():Viewport {
			if (_viewportExpressedInClipSpace) {
				var nVp:Viewport = _normalizedViewport;
				var size:Size = renderTargetSize;
				var sizeW:int = size.width;
				var sizeH:int = size.height;
				_viewport.x = nVp.x * sizeW;
				_viewport.y = nVp.y * sizeH;
				_viewport.width = nVp.width * sizeW;
				_viewport.height = nVp.height * sizeH;
			}
			return _viewport;
		}
		
		/**
		 * 设置屏幕空间的视口。
		 * @param 屏幕空间的视口。
		 */
		public function set viewport(value:Viewport):void {
			if (renderTarget != null && (value.x < 0 || value.y < 0 || value.width == 0 || value.height == 0))
				throw new Error("Camera: viewport size invalid.", "value");
			_viewportExpressedInClipSpace = false;
			_viewport = value;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取裁剪空间的视口。
		 * @return 裁剪空间的视口。
		 */
		public function get normalizedViewport():Viewport {
			if (!_viewportExpressedInClipSpace) {
				var vp:Viewport = _viewport;
				var size:Size = renderTargetSize;
				var sizeW:int = size.width;
				var sizeH:int = size.height;
				_normalizedViewport.x = vp.x / sizeW;
				_normalizedViewport.y = vp.y / sizeH;
				_normalizedViewport.width = vp.width / sizeW;
				_normalizedViewport.height = vp.height / sizeH;
			}
			return _normalizedViewport;
		}
		
		/**
		 * 设置裁剪空间的视口。
		 * @return 裁剪空间的视口。
		 */
		public function set normalizedViewport(value:Viewport):void {
			if (value.x < 0 || value.y < 0 || (value.x + value.width) > 1 || (value.x + value.height) > 1)
				throw new Error("Camera: viewport size invalid.", "value");
			_viewportExpressedInClipSpace = true;
			_normalizedViewport = value;
			
			_calculateProjectionMatrix();
		}
		
		public function get needViewport():Boolean {
			var nVp:Viewport = normalizedViewport;
			return nVp.x === 0 && nVp.y === 0 && nVp.width === 1 && nVp.height === 1;
		}
		
		/**
		 * 获取视图矩阵。
		 * @return 视图矩阵。
		 */
		public function get viewMatrix():Matrix4x4 {
			transform.worldMatrix.invert(_viewMatrix);
			return _viewMatrix;
		}
		
		/**获取投影矩阵。*/
		public function get projectionMatrix():Matrix4x4 {
			return _projectionMatrix;
		}
		
		/**设置投影矩阵。*/
		public function set projectionMatrix(value:Matrix4x4):void {
			_projectionMatrix = value;
			_useUserProjectionMatrix = true;
		}
		
		/**
		 * 获取视图投影矩阵。
		 * @return 视图投影矩阵。
		 */
		public function get projectionViewMatrix():Matrix4x4 {
			Matrix4x4.multiply(projectionMatrix, viewMatrix, _projectionViewMatrix);
			return _projectionViewMatrix;
		}
		
		/**
		 * 创建一个 <code>Camera</code> 实例。
		 * @param	viewport 视口。
		 * @param	fieldOfView 视野。
		 * @param	aspectRatio 横纵比。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function Camera(aspectRatio:Number = 0, nearPlane:Number = 0.1, farPlane:Number = 1000) {
			_viewMatrix = new Matrix4x4();
			_projectionMatrix = new Matrix4x4();
			_projectionViewMatrix = new Matrix4x4();
			_viewport = new Viewport(0, 0, 0, 0);
			_normalizedViewport = new Viewport(0, 0, 1, 1);
			_aspectRatio = aspectRatio;
			super(nearPlane, farPlane);
		}
		
		/**
		 * @private
		 * 计算投影矩阵。
		 */
		override protected function _calculateProjectionMatrix():void {
			if (!_useUserProjectionMatrix) {
				if (orthographicProjection) {
					var halfWidth:Number = orthographicVerticalSize * aspectRatio * 0.5;
					var halfHeight:Number = orthographicVerticalSize * 0.5;
					Matrix4x4.createOrthogonal(-halfWidth, halfWidth, -halfHeight, halfHeight, nearPlane, farPlane, _projectionMatrix);
				} else {
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, aspectRatio, nearPlane, farPlane, _projectionMatrix);
				}
			}
			_projectionMatrixModifyID += 0.01 / id;
		}
		
		/**
		 * 计算从屏幕空间生成的射线。
		 * @param	point 屏幕空间的位置位置。
		 * @return  out  输出射线。
		 */
		public function viewportPointToRay(point:Vector2, out:Ray):void {
			Picker.calculateCursorRay(point, viewport, _projectionMatrix, viewMatrix, null, out);
		}
		
		/**
		 * 计算从裁切空间生成的射线。
		 * @param	point 裁切空间的位置。。
		 * @return  out  输出射线。
		 */
		public function normalizedViewportPointToRay(point:Vector2, out:Ray):void {
			var finalPoint:Vector2 = _tempVector2;
			var vp:Viewport = viewport;
			var nVpPosE:Float32Array = point.elements;
			var vpPosE:Float32Array = finalPoint.elements;
			vpPosE[0] = nVpPosE[0] * vp.width;
			vpPosE[1] = nVpPosE[1] * vp.height;
			
			Picker.calculateCursorRay(finalPoint, viewport, _projectionMatrix, viewMatrix, null, out);
		}
		
		/**
		 * 计算从世界空间准换三维坐标到屏幕空间。
		 * @param	position 世界空间的位置。
		 * @return  out  输出位置。
		 */
		public function worldToViewportPoint(position:Vector3, out:Vector3):void {
			Matrix4x4.multiply(_projectionMatrix, _viewMatrix, _projectionViewMatrix);
			viewport.project(position, _projectionViewMatrix, out);
			if (out.z < 0.0 || out.z > 1.0)// TODO:是否需要近似判断
			{
				var outE:Float32Array = out.elements;
				outE[0] = outE[1] =outE[2] =NaN;
			}
		}
		
		/**
		 * 计算从世界空间准换三维坐标到裁切空间。
		 * @param	position 世界空间的位置。
		 * @return  out  输出位置。
		 */
		public function worldToNormalizedViewportPoint(position:Vector3, out:Vector3):void {
			Matrix4x4.multiply(_projectionMatrix, _viewMatrix, _projectionViewMatrix);
			normalizedViewport.project(position, _projectionViewMatrix, out);
			if (out.z < 0.0 || out.z > 1.0)// TODO:是否需要近似判断
			{
				var outE:Float32Array = out.elements;
				outE[0] = outE[1] =outE[2] =NaN;
			}
		}
	}
}