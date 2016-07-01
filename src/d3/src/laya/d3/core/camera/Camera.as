package laya.d3.core.camera {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Viewport;
	
	/**
	 * <code>Camera</code> 类用于创建普通摄像机。
	 */
	public class Camera extends BaseCamera {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/** @private */
		protected var _aspectRatio:Number;
		/** @private */
		protected var _viewport:Viewport = new Viewport(0, 0, 0, 0);
		/** @private */
		protected var _viewMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _projectionMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _projectionViewMatrix:Matrix4x4 = new Matrix4x4();
		
		/**
		 * 获取横纵比。
		 * @return 横纵比。
		 */
		public function get aspectRatio():Number {
			if (_aspectRatio === 0) {
				return _viewport.width / _viewport.height;
			}
			return _aspectRatio;
		}
		
		/**
		 * 设置横纵比。
		 * @param value 横纵比。
		 */
		public function set aspectRatio(value:Number):void {
			if (aspectRatio < 0)
				throw new Error("横纵比必须是正值得Number！");
			_aspectRatio = value;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取视口。
		 * @return 视口。
		 */
		public function get viewport():Viewport {
			return _viewport;
		}
		
		/**
		 * 设置视口。
		 * @param value 视口。
		 */
		public function set viewport(vaule:Viewport):void {
			_viewport = vaule;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取视图矩阵。
		 * @return 视图矩阵。
		 */
		public function get viewMatrix():Matrix4x4 {
			transform.worldMatrix.invert(_viewMatrix);
			return _viewMatrix;
		}
		
		/**
		 * 获取投影矩阵。
		 * @return 投影矩阵。
		 */
		public function get projectionMatrix():Matrix4x4 {
			return _projectionMatrix;
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
		 *  @param	viewport 视口。
		 * @param	fieldOfView 视野。
		 *  @param	aspectRatio 横纵比。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function Camera(viewport:Viewport, fieldOfView:Number = Math.PI / 3, aspectRatio:Number = 0, nearPlane:Number = 0.1, farPlane:Number = 1000) {
			_viewport = viewport;
			_aspectRatio = aspectRatio;
			super(fieldOfView, nearPlane, farPlane);
		}
		
		/**
		 * @private
		 * 计算投影矩阵。
		 */
		override protected function _calculateProjectionMatrix():void {
			if (!_isOrthographicProjection)
				Matrix4x4.createPerspective(fieldOfView, aspectRatio, nearPlane, farPlane, _projectionMatrix);
			
			_projectionMatrixModifyID += 0.01 / id;
		}
	}
}