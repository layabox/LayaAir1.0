package laya.d3.core {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.OrientedBoundBox;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.RenderTexture;
	import laya.d3.utils.Picker;
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Camera</code> 类用于创建摄像机。
	 */
	public class Camera extends BaseCamera {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _tempVector20:Vector2 = new Vector2();
		
		/** @private */
		private var _aspectRatio:Number;
		/** @private */
		private var _viewport:Viewport;
		/** @private */
		private var _normalizedViewport:Viewport;
		/** @private */
		private var _viewMatrix:Matrix4x4;
		/**@private */
		private var _projectionMatrix:Matrix4x4;
		/** @private */
		private var _projectionViewMatrix:Matrix4x4;
		/** @private */
		private var _boundFrustumUpdate:Boolean;
		/** @private */
		private var _boundFrustum:BoundFrustum;
		/** @private */
		private var _orientedBoundBox:OrientedBoundBox;
		
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
			if (value.x < 0) {
				value.x = 0;
				console.warn("Camera: viewport.x must large than 0.0.");
			}
			if (value.y < 0) {
				value.y = 0;
				console.warn("Camera: viewport.y must large than 0.0.");
			}
			if (value.x + value.width > 1.0) {
				value.width = 1.0 - value.x;
				console.warn("Camera: viewport.width + viewport.x must less than 1.0.");
			}
			if ((value.y + value.height) > 1.0) {
				value.height = 1.0 - value.y;
				console.warn("Camera: viewport.height + viewport.y must less than 1.0.");
			}
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
		 * 获取摄像机视锥。
		 */
		public function get boundFrustum():BoundFrustum {
			if (_boundFrustumUpdate)
				_boundFrustum.matrix = projectionViewMatrix;
			
			return _boundFrustum;
		}
		
		/**
		 * 创建一个 <code>Camera</code> 实例。
		 * @param	aspectRatio 横纵比。
		 * @param	nearPlane 近裁面。
		 * @param	farPlane 远裁面。
		 */
		public function Camera(aspectRatio:Number = 0, nearPlane:Number = 0.3, farPlane:Number = 1000) {
			_viewMatrix = new Matrix4x4();
			_projectionMatrix = new Matrix4x4();
			_projectionViewMatrix = new Matrix4x4();
			_viewport = new Viewport(0, 0, 0, 0);
			_normalizedViewport = new Viewport(0, 0, 1, 1);
			_aspectRatio = aspectRatio;
			_boundFrustumUpdate = true;
			_boundFrustum = new BoundFrustum(Matrix4x4.DEFAULT);
			super(nearPlane, farPlane);
			transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChanged);
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatrixChanged():void {
			_boundFrustumUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, json:Object):void {
			var color:Array = customProps.clearColor;
			clearColor = new Vector4(color[0], color[1], color[2], color[3]);
			var viewport:Array = customProps.viewport;
			normalizedViewport = new Viewport(viewport[0], viewport[1], viewport[2], viewport[3]);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateProjectionMatrix():void {
			if (!_useUserProjectionMatrix) {
				if (_orthographic) {
					var halfWidth:Number = orthographicVerticalSize * aspectRatio * 0.5;
					var halfHeight:Number = orthographicVerticalSize * 0.5;
					Matrix4x4.createOrthoOffCenterRH(-halfWidth, halfWidth, -halfHeight, halfHeight, nearPlane, farPlane, _projectionMatrix);
				} else {
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, aspectRatio, nearPlane, farPlane, _projectionMatrix);
				}
			}
			_boundFrustumUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _update(state:RenderState):void {
			if (conchModel) {//NATIVE
				conchModel.setViewMatrix(viewMatrix.elements);
				conchModel.setProjectMatrix(projectionMatrix.elements);
			}
			super._update(state);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderCamera(gl:WebGLContext, state:RenderState, scene:Scene):void {
			(scene.parallelSplitShadowMaps[0]) && (scene._renderShadowMap(gl, state, this));//TODO:SM
			state.camera = this;
			_prepareCameraToRender();
			scene._preRenderUpdateComponents(state);
			
			var viewMat:Matrix4x4, projectMat:Matrix4x4;
			viewMat = state._viewMatrix = viewMatrix;
			var renderTar:RenderTexture = _renderTarget;
			if (renderTar) {
				renderTar.start();
				Matrix4x4.multiply(_invertYScaleMatrix, _projectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, projectionViewMatrix, _invertYProjectionViewMatrix);
				projectMat = state._projectionMatrix = _invertYProjectionMatrix;//TODO:
				state._projectionViewMatrix = _invertYProjectionViewMatrix;//TODO:
			} else {
				projectMat = state._projectionMatrix = _projectionMatrix;//TODO:
				state._projectionViewMatrix = projectionViewMatrix;//TODO:
			}
			
			_prepareCameraViewProject(viewMat, projectMat);
			state._viewport = viewport;
			scene._preRenderScene(gl, state, boundFrustum);
			scene._clear(gl, state);
			scene._renderScene(gl, state);
			scene._postRenderUpdateComponents(state);
			
			(renderTar) && (renderTar.end());
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
			var finalPoint:Vector2 = _tempVector20;
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
			var outE:Float32Array = out.elements;
			if (out.z < 0.0 || out.z > 1.0)// TODO:是否需要近似判断
			{
				outE[0] = outE[1] = outE[2] = NaN;
			} else {
				outE[0] = outE[0] / Laya.stage.clientScaleX;
				outE[1] = outE[1] / Laya.stage.clientScaleY;
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
			var outE:Float32Array = out.elements;
			if (out.z < 0.0 || out.z > 1.0)// TODO:是否需要近似判断
			{
				outE[0] = outE[1] = outE[2] = NaN;
			} else {
				outE[0] = outE[0] / Laya.stage.clientScaleX;
				outE[1] = outE[1] / Laya.stage.clientScaleY;
			}
		}
		
		/**
		 * 转换2D屏幕坐标系统到3D正交投影下的坐标系统，注:只有正交模型下有效。
		 * @param   source 源坐标。
		 * @param   out 输出坐标。
		 * @return 是否转换成功。
		 */
		public function convertScreenCoordToOrthographicCoord(source:Vector3, out:Vector3):Boolean {//TODO:是否应该使用viewport宽高
			if (_orthographic) {
				var clientWidth:int = RenderState.clientWidth;
				var clientHeight:int = RenderState.clientHeight;
				var ratioX:Number = orthographicVerticalSize * aspectRatio / clientWidth;
				var ratioY:Number = orthographicVerticalSize / clientHeight;
				var sE:Array = source.elements;
				var oE:Array = out.elements;
				oE[0] = (-clientWidth / 2 + sE[0]) * ratioX;
				oE[1] = (clientHeight / 2 - sE[1]) * ratioY;
				oE[2] = (nearPlane - farPlane) * (sE[2] + 1) / 2 - nearPlane;
				Vector3.transformCoordinate(out, transform.worldMatrix, out);
				return true;
			} else {
				return false;
			}
		}
	}
}