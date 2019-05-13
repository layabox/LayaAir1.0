package laya.d3.core {
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.models.SkyRenderer;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.events.Event;
	import laya.net.Loader;
	
	/**
	 * <code>BaseCamera</code> 类用于创建摄像机的父类。
	 */
	public class BaseCamera extends Sprite3D {
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		
		public static const CAMERAPOS:int = Shader3D.propertyNameToID("u_CameraPos");
		public static const VIEWMATRIX:int = Shader3D.propertyNameToID("u_View");
		public static const PROJECTMATRIX:int = Shader3D.propertyNameToID("u_Projection");
		public static const VPMATRIX:int = 3;//TODO:xx
		public static const VPMATRIX_NO_TRANSLATE:int = Shader3D.propertyNameToID("u_MvpMatrix");
		public static const CAMERADIRECTION:int = Shader3D.propertyNameToID("u_CameraDirection");
		public static const CAMERAUP:int = Shader3D.propertyNameToID("u_CameraUp");
		
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
		
		/** @private 渲染顺序。*/
		public var _renderingOrder:int
		
		/**@private 近裁剪面。*/
		private var _nearPlane:Number;
		/**@private 远裁剪面。*/
		private var _farPlane:Number;
		/**@private 视野。*/
		private var _fieldOfView:Number;
		/**@private 正交投影的垂直尺寸。*/
		private var _orthographicVerticalSize:Number;
		/**@private */
		private var _skyRenderer:SkyRenderer = new SkyRenderer();
		/**@private */
		private var _forward:Vector3 = new Vector3();
		/**@private */
		private var _up:Vector3 = new Vector3();
		
		/**@private */
		protected var _orthographic:Boolean;
		/** @private 渲染目标。*/
		protected var _renderTarget:RenderTexture;
		/**@private 是否使用用户自定义投影矩阵，如果使用了用户投影矩阵，摄像机投影矩阵相关的参数改变则不改变投影矩阵的值，需调用ResetProjectionMatrix方法。*/
		protected var _useUserProjectionMatrix:Boolean;
		
		/** @private */
		public var _shaderValues:ShaderData;
		
		/**清楚标记。*/
		public var clearFlag:int;
		/**摄像机的清除颜色,默认颜色为CornflowerBlue。*/
		public var clearColor:Vector4 = new Vector4(100 / 255, 149 / 255, 237 / 255, 255 / 255);
		/** 可视层位标记遮罩值,支持混合 例:cullingMask=Math.pow(2,0)|Math.pow(2,1)为第0层和第1层可见。*/
		public var cullingMask:int;
		/** 渲染时是否用遮挡剔除。 */
		public var useOcclusionCulling:Boolean;
		
		/**
		 * 获取天空渲染器。
		 * @return 天空渲染器。
		 */
		public function get skyRenderer():SkyRenderer {
			return _skyRenderer;
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
			if (_renderTarget !== value) {
				_renderTarget = value;
				_calculateProjectionMatrix();
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
			_shaderValues = new ShaderData(null);
			
			_fieldOfView = 60;
			_useUserProjectionMatrix = false;
			_orthographic = false;
			
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
		
		/**
		 * 通过RenderingOrder属性对摄像机机型排序。
		 */
		public function _sortCamerasByRenderingOrder():void {
			if (displayedInStage) {
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
			transform.getForward(_forward);
			transform.getUp(_up);
			var cameraSV:ShaderData = _shaderValues;
			cameraSV.setVector3(BaseCamera.CAMERAPOS, transform.position);
			cameraSV.setVector3(BaseCamera.CAMERADIRECTION, _forward);
			cameraSV.setVector3(BaseCamera.CAMERAUP, _up);
		}
		
		/**
		 * @private
		 */
		public function _prepareCameraViewProject(vieMat:Matrix4x4, proMat:Matrix4x4, vieProNoTraSca:Matrix4x4):void {
			var cameraSV:ShaderData = _shaderValues;
			cameraSV.setMatrix4x4(BaseCamera.VIEWMATRIX, vieMat);
			cameraSV.setMatrix4x4(BaseCamera.PROJECTMATRIX, proMat);
			
			transform.worldMatrix.cloneTo(_tempMatrix4x40);//视图矩阵逆矩阵的转置矩阵，移除平移和缩放
			_tempMatrix4x40.transpose();
			Matrix4x4.multiply(proMat, _tempMatrix4x40, vieProNoTraSca);
			cameraSV.setMatrix4x4(BaseCamera.VPMATRIX_NO_TRANSLATE, vieProNoTraSca);
		}
		
		/**
		 * 相机渲染。
		 * @param	shader 着色器。
		 * @param   replacementTag 着色器替换标记。
		 */
		public function render(shader:Shader3D = null, replacementTag:String = null):void {
		}
		
		/**
		 * 增加可视图层,layer值为0到31层。
		 * @param layer 图层。
		 */
		public function addLayer(layer:int):void {
			cullingMask |= Math.pow(2, layer);
		}
		
		/**
		 * 移除可视图层,layer值为0到31层。
		 * @param layer 图层。
		 */
		public function removeLayer(layer:int):void {
			cullingMask &= ~Math.pow(2, layer);
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
			cullingMask = 0;
		}
		
		public function resetProjectionMatrix():void {
			_useUserProjectionMatrix = false;
			_calculateProjectionMatrix();
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
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			(_scene as Scene3D)._addCamera(this);
			super._onActive();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onInActive():void {
			(_scene as Scene3D)._removeCamera(this);
			super._onInActive();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			super._parse(data);
			var clearFlagData:* = data.clearFlag;
			(clearFlagData !== undefined) && (clearFlag = clearFlagData);
			
			orthographic = data.orthographic;
			fieldOfView = data.fieldOfView;
			nearPlane = data.nearPlane;
			farPlane = data.farPlane;
			
			var color:Array = data.clearColor;
			clearColor = new Vector4(color[0], color[1], color[2], color[3]);
			var skyboxMaterial:Object = data.skyboxMaterial;
			if (skyboxMaterial) {
				_skyRenderer.material = Loader.getRes(skyboxMaterial.path);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			//postProcess = null;
			//AmbientLight = null;
			renderTarget = null;
			_skyRenderer.destroy();
			_skyRenderer = null;
			
			Laya.stage.off(Event.RESIZE, this, _onScreenSizeChanged);
			super.destroy(destroyChild);
		}
	}
}