package laya.d3.core {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.models.Sky;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>BaseCamera</code> 类用于创建摄像机的父类。
	 */
	public class BaseCamera extends Sprite3D {
		public static const CAMERAPOS:int = 0;
		public static const VIEWMATRIX:int = 1;
		public static const PROJECTMATRIX:int = 2;
		public static const VPMATRIX:int = 3;//TODO:xx
		public static const VPMATRIX_NO_TRANSLATE:int = 4;//TODO:xx
		public static const CAMERADIRECTION:int = 5;
		public static const CAMERAUP:int = 6;
		public static const ENVIRONMENTDIFFUSE:int = 7;
		public static const ENVIRONMENTSPECULAR:int = 8;
		public static const SIMLODINFO:int = 9;
		public static const DIFFUSEIRRADMATR:int = 10;
		public static const DIFFUSEIRRADMATG:int = 11;
		public static const DIFFUSEIRRADMATB:int = 12;
		public static const HDREXPOSURE:int = 13;
		
		/**渲染模式,延迟光照渲染，暂未开放。*/
		public static const RENDERINGTYPE_DEFERREDLIGHTING:String = "DEFERREDLIGHTING";
		/**渲染模式,前向渲染。*/
		public static const RENDERINGTYPE_FORWARDRENDERING:String = "FORWARDRENDERING";
		
		/**清除标记，固定颜色。*/
		public static const CLEARFLAG_SOLIDCOLOR:int = 0;
		/**清除标记，天空。*/
		public static const CLEARFLAG_SKY:int = 1;
		/**清除标记，仅深度。*/
		public static const CLEARFLAG_DEPTHONLY:int = 2;
		/**清除标记，不清除。*/
		public static const CLEARFLAG_NONE:int = 3;
		
		/** @private */
		protected static const _invertYScaleMatrix:Matrix4x4 = new Matrix4x4(1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);//Matrix4x4.createScaling(new Vector3(1, -1, 1), _invertYScaleMatrix);
		/** @private */
		protected static const _invertYProjectionMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected static const _invertYProjectionViewMatrix:Matrix4x4 = new Matrix4x4();
		
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
		/**@private 正交投影的垂直尺寸。*/
		private var _orthographicVerticalSize:Number;
		/**@private 天空。*/
		private var _sky:Sky;
		
		/**@private */
		protected var _orthographic:Boolean;
		/** @private 渲染目标。*/
		protected var _renderTarget:RenderTexture;
		/**@private 是否使用用户自定义投影矩阵，如果使用了用户投影矩阵，摄像机投影矩阵相关的参数改变则不改变投影矩阵的值，需调用ResetProjectionMatrix方法。*/
		protected var _useUserProjectionMatrix:Boolean;
		/** @private 表明视口是否使用裁剪空间表达。*/
		protected var _viewportExpressedInClipSpace:Boolean;
		
		/**清楚标记。*/
		public var clearFlag:int;
		/**摄像机的清除颜色。*/
		public var clearColor:Vector4;
		/** 可视遮罩图层。 */
		public var cullingMask:int;
		/** 渲染时是否用遮挡剔除。 */
		public var useOcclusionCulling:Boolean;
		
		/**获取天空。*/
		public function get sky():Sky {
			return _sky;
		}
		
		/**设置天空。*/
		public function set sky(value:Sky):void {
			_sky = value;
			value._ownerCamera = this;
			if (conchModel) {//NATIVE
				conchModel.setSkyMesh(_sky._conchSky);
			}
		}
		
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
		 * 获取渲染场景的渲染目标。
		 * @return 渲染场景的渲染目标。
		 */
		public function get renderTarget():RenderTexture {
			return _renderTarget;
		}
		
		/**
		 * 设置渲染场景的渲染目标。
		 * @param value 渲染场景的渲染目标。
		 */
		public function set renderTarget(value:RenderTexture):void {
			_renderTarget = value;
			if (value != null)
				_renderTargetSize = value.size;
		}
		
		/**
		 * 获取渲染目标的尺寸
		 * @return 渲染目标的尺寸。
		 */
		public function get renderTargetSize():Size {
			return _renderTargetSize;
		}
		
		/**
		 * 设置渲染目标的尺寸
		 * @param value 渲染目标的尺寸。
		 */
		public function set renderTargetSize(value:Size):void {
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
		public function get orthographic():Boolean {
			return _orthographic;
		}
		
		/**
		 * 设置是否正交投影矩阵。
		 * @param 是否正交投影矩阵。
		 */
		public function set orthographic(vaule:Boolean):void {
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
			_sortCamerasByRenderingOrder();
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
		public function BaseCamera(nearPlane:Number = 0.3, farPlane:Number = 1000) {
			_tempVector3 = new Vector3();
			
			_position = new Vector3();
			_up = new Vector3();
			_forward = new Vector3();
			_right = new Vector3();
			
			_fieldOfView = 60;
			_useUserProjectionMatrix = false;
			_orthographic = false;
			
			_viewportExpressedInClipSpace = true;
			_renderTargetSize = Size.fullScreen;
			_orthographicVerticalSize = 10;
			renderingOrder = 0;
			
			_nearPlane = nearPlane;
			_farPlane = farPlane;
			
			cullingMask = 2147483647/*int.MAX_VALUE*/;
			clearFlag = BaseCamera.CLEARFLAG_SOLIDCOLOR;
			useOcclusionCulling = true;
			_calculateProjectionMatrix();
			Laya.stage.on(Event.RESIZE, this, _onScreenSizeChanged);
		}
		
		override public function createConchModel():* {
			return __JS__("new ConchCamera()");
		}
		
		/**
		 * 通过RenderingOrder属性对摄像机机型排序。
		 */
		public function _sortCamerasByRenderingOrder():void {
			if (_displayedInStage) {
				var cameraPool:Vector.<BaseCamera> = scene._cameraPool;//TODO:可优化，从队列中移除再加入
				var n:int = cameraPool.length - 1;
				for (var i:int = 0; i < n; i++) {
					if (cameraPool[i].renderingOrder > cameraPool[n].renderingOrder) {
						var tempCamera:BaseCamera = cameraPool[i];
						cameraPool[i] = cameraPool[n];
						cameraPool[n] = tempCamera;
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function _calculateProjectionMatrix():void {
		
		}
		
		/**
		 * @private
		 */
		private function _onScreenSizeChanged():void {
			_calculateProjectionMatrix();
		}
		
		/**
		 * @private
		 */
		public function _prepareCameraToRender():void {
			Layer._currentCameraCullingMask = cullingMask;
			var cameraSV:ValusArray = _shaderValues;
			cameraSV.setValue(BaseCamera.CAMERAPOS, transform.position.elements);
			cameraSV.setValue(BaseCamera.CAMERADIRECTION, forward.elements);
			cameraSV.setValue(BaseCamera.CAMERAUP, up.elements);
		}
		
		/**
		 * @private
		 */
		public function _prepareCameraViewProject(viewMatrix:Matrix4x4, projectMatrix:Matrix4x4):void {
			var cameraSV:ValusArray = _shaderValues;
			cameraSV.setValue(BaseCamera.VIEWMATRIX, viewMatrix.elements);
			cameraSV.setValue(BaseCamera.PROJECTMATRIX, projectMatrix.elements);
		}
		
		/**
		 * @private
		 */
		public function _renderCamera(gl:WebGLContext, state:RenderState, scene:Scene):void {
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
		
		override protected function _addSelfRenderObjects():void//TODO:是否应该改名 
		{
			var cameraPool:Vector.<BaseCamera> = scene._cameraPool;
			var cmaeraCount:int = cameraPool.length;
			if (cmaeraCount > 0) {
				for (var i:int = cmaeraCount - 1; i >= 0; i--) {
					if (this.renderingOrder <= cameraPool[i].renderingOrder) {
						cameraPool.splice(i + 1, 0, this);
						break;
					}
				}
			} else {
				cameraPool.push(this);
				if (scene.conchModel) {//NATIVE
					scene.conchModel.setCurrentCamera(conchModel);
				}
			}
		}
		
		override protected function _clearSelfRenderObjects():void//TODO:是否应该改名 
		{
			var cameraPool:Vector.<BaseCamera> = scene._cameraPool;
			cameraPool.splice(cameraPool.indexOf(this), 1);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			//postProcess = null;
			//AmbientLight = null;
			(_sky) && (_sky.destroy());
			renderTarget = null;
			
			Laya.stage.off(Event.RESIZE, this, _onScreenSizeChanged);
			super.destroy(destroyChild);
		}
	}
}