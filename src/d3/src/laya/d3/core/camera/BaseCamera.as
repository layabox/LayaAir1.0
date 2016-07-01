package laya.d3.core.camera {
	import laya.d3.core.Layer;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>BaseCamera</code> 类用于创建摄像机的父类。
	 */
	public class BaseCamera extends Sprite3D {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** @private */
		protected var _tempVector3:Vector3 = new Vector3();
		
		/** @private */
		protected var _up:Vector3 = new Vector3();
		/** @private */
		protected var _forward:Vector3 = new Vector3();
		/** @private */
		protected var _right:Vector3 = new Vector3();
		/** @private */
		protected var _nearPlane:Number;
		/** @private */
		protected var _farPlane:Number;
		/** @private */
		protected var _fieldOfView:Number;
		/** @private */
		protected var _isOrthographicProjection:Boolean = false;
		/** @private */
		public var _projectionMatrixModifyID:Number = 0;
		
		/** 可视遮罩图层。 */
		public var cullingMask:int;
		/** 初始清除颜色。 */
		public var clearColor:Vector4;
		
		/**
		 * 获取视野。
		 * @return 视野。
		 */
		public function get fieldOfView():Number {
			return _fieldOfView;
		}
		
		/**
		 * 设置视野。
		 * @param value 视野。
		 */
		public function set fieldOfView(value:Number):void {
			_fieldOfView = value;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取近裁面。
		 * @return 近裁面。
		 */
		public function get nearPlane():Number {
			return _nearPlane;
		}
		
		/**
		 * 设置近裁面。
		 * @param value 近裁面。
		 */
		public function set nearPlane(value:Number):void {
			_nearPlane = value;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取远裁面。
		 * @return 远裁面。
		 */
		public function get farPlane():Number {
			return _farPlane;
		}
		
		/**
		 * 设置远裁面。
		 * @param value 远裁面。
		 */
		public function set farPlane(vaule:Number):void {
			_farPlane = vaule;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取是否正交投影模式。
		 * @return 是否正交投影模式。
		 */
		public function get isOrthographicProjection():Boolean {
			return _isOrthographicProjection;
		}
		
		/**
		 * 获取上向量。
		 * @return 上向量。
		 */
		public function get up():Vector3 {
			var worldMatrixe:Float32Array = transform.worldMatrix.elements;
			var upe:Float32Array = _up.elements;
			upe[0] = worldMatrixe[4];
			upe[1] = worldMatrixe[5];
			upe[2] = worldMatrixe[6];
			return _up;
		}
		
		/**
		 * 获取右向量。
		 * @return 右向量。
		 */
		public function get right():Vector3 {
			var worldMatrixe:Float32Array = transform.worldMatrix.elements;
			var righte:Float32Array = _right.elements;
			righte[0] = worldMatrixe[0];
			righte[1] = worldMatrixe[1];
			righte[2] = worldMatrixe[2];
			return _right;
		}
		
		/**
		 * 获取前向量。
		 * @return 前向量。
		 */
		public function get forward():Vector3 {
			var worldMatrixe:Float32Array = transform.worldMatrix.elements;
			var forwarde:Float32Array = _forward.elements;
			forwarde[0] = -worldMatrixe[8];
			forwarde[1] = -worldMatrixe[9];
			forwarde[2] = -worldMatrixe[10];
			return _forward;
		}
		
		/**
		 * 创建一个 <code>BaseCamera</code> 实例。
		 * @param	fieldOfView 视野。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function BaseCamera(fieldOfView:Number = Math.PI / 3, nearPlane:Number = 0.1, farPlane:Number = 1000) {
			_fieldOfView = fieldOfView;
			
			_nearPlane = nearPlane;
			_farPlane = farPlane;
			cullingMask = 2147483647/*int.MAX_VALUE*/;
			clearColor = new Vector4(100.0 / 255.0, 149.0 / 255.0, 237.0 / 255.0, 255.0 / 255.0);//CornflowerBlue
			_calculateProjectionMatrix();
		}
		
		/**
		 * @private
		 * 计算投影矩阵，可重写此函数。
		 */
		protected function _calculateProjectionMatrix():void {
		}
		
		/**
		 * 向前移动。
		 * @param distance 移动距离。
		 */
		public function moveForward(distance:Number):void {
			_tempVector3.elements[0] = _tempVector3.elements[1] = 0;
			_tempVector3.elements[2] = distance;
			transform.translate(_tempVector3);
		}
		
		/**
		 * 向右移动。
		 * @param distance 移动距离。
		 */
		public function moveRight(distance:Number):void {
			_tempVector3.elements[1] = _tempVector3.elements[2] = 0;
			_tempVector3.elements[0] = distance;
			transform.translate(_tempVector3);
		}
		
		/**
		 * 向上移动。
		 * @param distance 移动距离。
		 */
		public function moveVertical(distance:Number):void {
			_tempVector3.elements[0] = _tempVector3.elements[2] = 0;
			_tempVector3.elements[1] = distance;
			
			transform.translate(_tempVector3, false);
		}
		
		/**
		 * 增加可视图层。
		 * @param layer 图层。
		 */
		public function addLayer(layer:Layer):void {
			
			if (layer.number === 29 || layer.number == 30)//29和30为预留蒙版层,已默认存在
				return;
			
			cullingMask = cullingMask | layer.mask;
		}
		
		/**
		 * 移除可视图层。
		 * @param layer 图层。
		 */
		public function removeLayer(layer:Layer):void {
			//29和30为预留蒙版层,不能移除
			if (layer.number === 29 || layer.number == 30)
				return;
			cullingMask = cullingMask & ~layer.mask;
		}
		
		/**
		 * 增加所有图层。
		 */
		public function addAllLayers():void {
			cullingMask = 2147483647/*int.MAX_VALUE*/;
		}
		
		/**
		 * 移除所有图层。
		 */
		public function removeAllLayers():void {
			cullingMask = 0 | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
		}
	
	}
}