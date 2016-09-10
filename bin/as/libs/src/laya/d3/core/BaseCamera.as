package laya.d3.core {
	import laya.d3.core.Layer;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTarget;
	import laya.d3.resource.models.Sky;
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.maths.Rectangle;
	
	/**
	 * <code>BaseCamera</code> 类用于创建摄像机的父类。
	 */
	public class BaseCamera extends Sprite3D {
		/**延迟光照渲染，暂未开放。*/
		public static const RENDERINGTYPE_DEFERREDLIGHTING:String = "DEFERREDLIGHTING";
		/**前向渲染。*/
		public static const RENDERINGTYPE_FORWARDRENDERING:String = "FORWARDRENDERING";
		/**相机的对象池*/
		public static const _cameraPool:Vector.<BaseCamera> = new Vector.<BaseCamera>(2);
		
		/**
		 * 获取主摄像机，确保已经使用RenderingOrder排序。
		 * @return 主摄像机。
		 */
		public static function get mainCamera():BaseCamera {
			for (var i:int = _cameraPool.length - 1; i >= 0; i--) {
				if (_cameraPool[i].masterCamera == null && _cameraPool[i].enable)
					return _cameraPool[i];
			}
			return null;
		}
		
		/**
		 * 通过RenderingOrder属性对摄像机机型排序。
		 */
		public static function _sortCamerasByRenderingOrder():void {
			var n:int = _cameraPool.length - 1;
			for (var i:int = 0; i < n; i++) {
				if (_cameraPool[i].renderingOrder > _cameraPool[n].renderingOrder) {
					var tempCamera:BaseCamera = _cameraPool[i];
					_cameraPool[i] = _cameraPool[n];
					_cameraPool[n] = tempCamera;
				}
			}
		}
		
		//private static const Vector3[] cornersWorldSpace:Vector.<Vector3> = new Vector.<Vector3>(8);
		//private static const  boundingFrustum:BoundingFrustum = new BoundingFrustum(Matrix4x4.Identity);
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** @private */
		protected var _tempVector3:Vector3;
		
		/** @private 位置。*/
		private var _position:Vector3;
		/**@private 向上向量。*/
		private var _up:Vector3;
		/**@private 前向量。*/
		private var _forward:Vector3;
		/** @private 右向量。*/
		private var _right:Vector3;
		
		/** @private 此相机的主人相机，注意：一个相机不能同时既是主人相机又是奴隶相机。*/
		private var _masterCamera:BaseCamera;
		/** @private 此相机的奴隶相机，注意：一个相机不能同时既是主人相机又是奴隶相机。*/
		private var _slavesCameras:Vector.<BaseCamera>;
		/** @private 渲染目标。*/
		private var _renderTarget:RenderTarget;
		/** @private 渲染顺序。*/
		private var _renderingOrder:int;
		/**@private 渲染目标尺寸。*/
		private var _renderTargetSize:Size;
		
		/**@private 近裁剪面。*/
		private var _nearPlane:Number;
		/**@private 远裁剪面。*/
		private var _farPlane:Number;
		/**@private 视野。*/
		private var _fieldOfView:Number;
		/**@private 是否为正交投影。*/
		private var _orthographic:Boolean;
		/**@private 正交投影的垂直尺寸。*/
		private var _orthographicVerticalSize:Number;
		
		/**@private 是否使用用户自定义投影矩阵，如果使用了用户投影矩阵，摄像机投影矩阵相关的参数改变则不改变投影矩阵的值，需调用ResetProjectionMatrix方法。*/
		protected var _useUserProjectionMatrix:Boolean;
		/** @private 表明视口是否使用裁剪空间表达。*/
		protected var _viewportExpressedInClipSpace:Boolean;
		
		/** @private */
		public var _projectionMatrixModifyID:Number = 0;
		/**存储多相机的渲染结果，不必拷贝到更大的渲染目标上，帮助减少内存消耗,通常引擎内部使用，如果性能敏感，且有更多的内存空间可避免使用。*/
		public var _partialRenderTarget:RenderTarget;
		
		/**摄像机的清除颜色。*/
		public var clearColor:Vector4;
		/** 可视遮罩图层。 */
		public var cullingMask:int;
		/**天空。*/
		public var sky:Sky;
		
		/**获取位置。*/
		public function get position():Vector3 {
			var worldMatrixe:Float32Array = transform.worldMatrix.elements;
			var positione:Float32Array = _position.elements;
			positione[0] = worldMatrixe[12];
			positione[1] = worldMatrixe[13];
			positione[2] = worldMatrixe[14];
			return _position;
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
		 * 获取渲染场景的渲染目标，渲染目标同时存储主人相机和奴隶相机的结果。
		 * @return 渲染场景的渲染目标。
		 */
		public function get renderTarget():RenderTarget {
			if (_masterCamera != null)
				return _masterCamera.renderTarget;
			
			return _renderTarget;
		}
		
		/**
		 * 设置渲染场景的渲染目标，渲染目标同时存储主人相机和奴隶相机的结果。
		 * @param value 渲染场景的渲染目标。
		 */
		public function set renderTarget(value:RenderTarget):void {
			if (_masterCamera != null)
				return;
			
			_renderTarget = value;
			if (value != null)
				_renderTargetSize = value.size;
		}
		
		/**
		 * 获取渲染目标的尺寸
		 * @return 渲染目标的尺寸。
		 */
		public function get renderTargetSize():Size {
			if (_masterCamera != null)
				return _masterCamera.renderTargetSize;
			return _renderTargetSize;
		}
		
		/**
		 * 设置渲染目标的尺寸
		 * @param value 渲染目标的尺寸。
		 */
		public function set renderTargetSize(value:Size):void {
			if (_masterCamera != null)
				return;
			
			if (renderTarget != null && _renderTargetSize != value) {
				// Recreate render target with new size
				//AssetContentManager userContentManager = AssetContentManager.CurrentContentManager;
				//AssetContentManager.CurrentContentManager = renderTarget.ContentManager;
				//renderTarget.Dispose();
				//renderTarget = new RenderTarget(value, RenderTarget.SurfaceFormat, RenderTarget.DepthFormat, RenderTarget.Antialiasing);
				//AssetContentManager.CurrentContentManager = userContentManager;
			}
			_renderTargetSize = value;
			_calculateProjectionMatrix();
		}
		
		/**
		 *获取主人摄像机，渲染类型、清除颜色和渲染目标值均来自主人摄像机。
		 * @return 主人摄像机。
		 */
		public function get masterCamera():BaseCamera {
			return _masterCamera;
		}
		
		/**
		 *设置主人摄像机，渲染类型、清除颜色和渲染目标值均来自主人摄像机。
		 * @param 主人摄像机。
		 */
		public function set masterCamera(value:BaseCamera):void {
			if (_slavesCameras.length != 0 || (value != null && value.masterCamera != null))
				throw new Error("BaseCamera: A camera can't be master and slave simultaneity.");
			if (masterCamera != null) {//移除旧主人相机。
				var slavesCameras:Vector.<BaseCamera> = masterCamera._slavesCameras;
				slavesCameras.splice(slavesCameras.indexOf(this), 1);
			}
			masterCamera = value;//设置新主人。
			
			if (value != null) {
				value._slavesCameras.push(this);
				for (var i:int = 0; i < value._slavesCameras.length; i++) {//对努力相机进行排序
					var count:int = value._slavesCameras.length;
					if (value._slavesCameras[i].renderingOrder > value._slavesCameras[count - 1].renderingOrder) {
						var temp:BaseCamera = value._slavesCameras[count - 1];
						value._slavesCameras[count - 1] = value._slavesCameras[i];
						value._slavesCameras[i] = temp;
					}
				}
				//if (_renderTarget != null)
				//RenderTarget.Release(_renderTarget);
				_renderTarget = null;
			}
		}
		
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
		 * 获取是否正交投影矩阵。
		 * @return 是否正交投影矩阵。
		 */
		public function get orthographicProjection():Boolean {
			return _orthographic;
		}
		
		/**
		 * 设置是否正交投影矩阵。
		 * @param 是否正交投影矩阵。
		 */
		public function set orthographicProjection(vaule:Boolean):void {
			_orthographic = vaule;
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取正交投影垂直矩阵尺寸。
		 * @return 正交投影垂直矩阵尺寸。
		 */
		public function get orthographicVerticalSize():Number {
			return _orthographicVerticalSize;
		}
		
		/**
		 * 设置正交投影垂直矩阵尺寸。
		 * @param 正交投影垂直矩阵尺寸。
		 */
		public function set orthographicVerticalSize(vaule:Number):void {
			_orthographicVerticalSize = vaule;
			_calculateProjectionMatrix();
		}
		
		public function get renderingOrder():int {
			return _renderingOrder;
		}
		
		public function set renderingOrder(value:int):void {
			_renderingOrder = value;
			//_sortCamerasByRenderingOrder();
		}
		
		
		
		///**@private 后期处理。*/
		//private var  _postProcess:PostProess;
		
		///**环境光。*/
		//public var AmbientLight:AmbientLight
		
		
		///**获取摄像机的后期处理。*/
		//public  function get postProcess():PostProess
		//{
		//return _postProcess
		//}
		
		///**设置摄像机的后期处理。*/
		//public  function set postProcess(value:PostProess):void
		//{
		//_postProcess = value;
		//if (value == null && luminanceTexture != null)
		//RenderTarget.Release(luminanceTexture);
		//}
		
		///**亮度纹理，用于postProcess,通常引擎内部使用。*/
		//public var _luminanceTexture:RenderTarget;
		
		/**
		 * 创建一个 <code>BaseCamera</code> 实例。
		 * @param	fieldOfView 视野。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function BaseCamera(nearPlane:Number = 0.1, farPlane:Number = 1000) {
			_tempVector3 = new Vector3();
			
			_up = new Vector3();
			_forward = new Vector3();
			_right = new Vector3();
			
			_fieldOfView = 60;
			_useUserProjectionMatrix = false;
			_orthographic = false;
			
			_viewportExpressedInClipSpace = true;
			_slavesCameras = new Vector.<BaseCamera>();
			_renderTargetSize = Size.fullScreen;
			_orthographicVerticalSize = 10;
			renderingOrder = 0;
			
			_nearPlane = nearPlane;
			_farPlane = farPlane;
			
			cullingMask = 2147483647/*int.MAX_VALUE*/;
			clearColor = new Vector4(100.0 / 255.0, 149.0 / 255.0, 237.0 / 255.0, 255.0 / 255.0);//CornflowerBlue
			_calculateProjectionMatrix();
			Laya.stage.on(Event.RESIZE, this, _onScreenSizeChanged);
		}
		
		protected function _calculateProjectionMatrix():void {
		
		}
		
		private function _onScreenSizeChanged():void {
			_calculateProjectionMatrix();
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
		
		public function ResetProjectionMatrix():void {
			_useUserProjectionMatrix = false;
			_calculateProjectionMatrix();
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			//postProcess = null;
			//AmbientLight = null;
			//Sky = null;
			masterCamera = null;
			renderTarget = null;
			
			Laya.stage.off(Event.RESIZE, this, _onScreenSizeChanged);
			super.destroy(destroyChild);
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
	
		//public void BoundingFrustumViewSpace(Vector3[] cornersViewSpace)
		//{
		//if (cornersViewSpace.Length != 4)
		//throw new ArgumentOutOfRangeException("cornersViewSpace");
		//boundingFrustum.Matrix = ViewMatrix * ProjectionMatrix;
		//boundingFrustum.GetCorners(cornersWorldSpace);
		//// Transform form world space to view space
		//for (int i = 0; i < 4; i++)
		//{
		//cornersViewSpace[i] = Vector3.Transform(cornersWorldSpace[i + 4], ViewMatrix);
		//}
		//
		//// Swap the last 2 values.
		//Vector3 temp = cornersViewSpace[3];
		//cornersViewSpace[3] = cornersViewSpace[2];
		//cornersViewSpace[2] = temp;
		//} // BoundingFrustumViewSpace
	
		//public void BoundingFrustumWorldSpace(Vector3[] cornersWorldSpaceResult)
		//{
		//if (cornersWorldSpaceResult.Length != 4)
		//throw new ArgumentOutOfRangeException("cornersViewSpace");
		//boundingFrustum.Matrix = ViewMatrix * ProjectionMatrix;
		//boundingFrustum.GetCorners(cornersWorldSpace);
		//// Transform form world space to view space
		//for (int i = 0; i < 4; i++)
		//{
		//cornersWorldSpaceResult[i] = cornersWorldSpace[i + 4];
		//}
		//
		//// Swap the last 2 values.
		//Vector3 temp = cornersWorldSpaceResult[3];
		//cornersWorldSpaceResult[3] = cornersWorldSpaceResult[2];
		//cornersWorldSpaceResult[2] = temp;
		//} // BoundingFrustumWorldSpace
	
	}
}