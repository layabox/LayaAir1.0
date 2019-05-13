package laya.d3.core {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Plane;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.RenderTexture;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.d3.utils.Picker;
	import laya.events.Event;
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Camera</code> 类用于创建摄像机。
	 */
	public class Camera extends BaseCamera {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** @private */
		private static var _tempVector20:Vector2 = new Vector2();
		
		/** @private */
		public static var _updateMark:int = 0;
		
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
		public var _projectionViewMatrixNoTranslateScale:Matrix4x4;
		/** @private */
		private var _boundFrustum:BoundFrustum;
		/** @private */
		private var _updateViewMatrix:Boolean = true;
		
		/** @private [NATIVE]*/
		public var _boundFrustumBuffer:Float32Array;
		
		/**是否允许渲染。*/
		public var enableRender:Boolean = true;
		
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
			if (_renderTarget)
				_calculationViewport(_normalizedViewport, _renderTarget.width, _renderTarget.height);
			else
				_calculationViewport(_normalizedViewport, RenderContext3D.clientWidth, RenderContext3D.clientHeight);//屏幕尺寸会动态变化,需要重置
			return _viewport;
		}
		
		/**
		 * 设置屏幕空间的视口。
		 * @param 屏幕空间的视口。
		 */
		public function set viewport(value:Viewport):void {
			var width:int;
			var height:int;
			if (_renderTarget) {
				width = _renderTarget.width;
				height = _renderTarget.height;
			} else {
				width = RenderContext3D.clientWidth;
				height = RenderContext3D.clientHeight;
			}
			_normalizedViewport.x = value.x / width;
			_normalizedViewport.y = value.y / height;
			_normalizedViewport.width = value.width / width;
			_normalizedViewport.height = value.height / height;
			_calculationViewport(_normalizedViewport, width, height);
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取裁剪空间的视口。
		 * @return 裁剪空间的视口。
		 */
		public function get normalizedViewport():Viewport {
			return _normalizedViewport;
		}
		
		/**
		 * 设置裁剪空间的视口。
		 * @return 裁剪空间的视口。
		 */
		public function set normalizedViewport(value:Viewport):void {
			var width:int;
			var height:int;
			if (_renderTarget) {
				width = _renderTarget.width;
				height = _renderTarget.height;
			} else {
				width = RenderContext3D.clientWidth;
				height = RenderContext3D.clientHeight;
			}
			if (_normalizedViewport !== value)
				value.cloneTo(_normalizedViewport);
			_calculationViewport(value, width, height);
			_calculateProjectionMatrix();
		}
		
		/**
		 * 获取视图矩阵。
		 * @return 视图矩阵。
		 */
		public function get viewMatrix():Matrix4x4 {
			if (_updateViewMatrix) {
				var scale:Vector3 = transform.scale;
				var scaleX:Number = scale.x;
				var scaleY:Number = scale.y;
				var scaleZ:Number = scale.z;
				var viewMatE:Float32Array = _viewMatrix.elements;
				
				transform.worldMatrix.cloneTo(_viewMatrix)
				viewMatE[0] /= scaleX;//忽略缩放
				viewMatE[1] /= scaleX;
				viewMatE[2] /= scaleX;
				viewMatE[4] /= scaleY;
				viewMatE[5] /= scaleY;
				viewMatE[6] /= scaleY;
				viewMatE[8] /= scaleZ;
				viewMatE[9] /= scaleZ;
				viewMatE[10] /= scaleZ;
				_viewMatrix.invert(_viewMatrix);
				_updateViewMatrix = false;
			}
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
			_boundFrustum.matrix = projectionViewMatrix;
			if (Render.supportWebGLPlusCulling) {
				var near:Plane = _boundFrustum.near;
				var far:Plane = _boundFrustum.far;
				var left:Plane = _boundFrustum.left;
				var right:Plane = _boundFrustum.right;
				var top:Plane = _boundFrustum.top;
				var bottom:Plane = _boundFrustum.bottom;
				var nearNE:Vector3 = near.normal;
				var farNE:Vector3 = far.normal;
				var leftNE:Vector3 = left.normal;
				var rightNE:Vector3 = right.normal;
				var topNE:Vector3 = top.normal;
				var bottomNE:Vector3 = bottom.normal;
				var buffer:Float32Array = _boundFrustumBuffer;
				buffer[0] = nearNE.x, buffer[1] = nearNE.y, buffer[2] = nearNE.z, buffer[3] = near.distance;
				buffer[4] = farNE.x, buffer[5] = farNE.y, buffer[6] = farNE.z, buffer[7] = far.distance;
				buffer[8] = leftNE.x, buffer[9] = leftNE.y, buffer[10] = leftNE.z, buffer[11] = left.distance;
				buffer[12] = rightNE.x, buffer[13] = rightNE.y, buffer[14] = rightNE.z, buffer[15] = right.distance;
				buffer[16] = topNE.x, buffer[17] = topNE.y, buffer[18] = topNE.z, buffer[19] = top.distance;
				buffer[20] = bottomNE.x, buffer[21] = bottomNE.y, buffer[22] = bottomNE.z, buffer[23] = bottom.distance;
			}
			
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
			_projectionViewMatrixNoTranslateScale = new Matrix4x4();
			_viewport = new Viewport(0, 0, 0, 0);
			_normalizedViewport = new Viewport(0, 0, 1, 1);
			_aspectRatio = aspectRatio;
			_boundFrustum = new BoundFrustum(Matrix4x4.DEFAULT);
			if (Render.supportWebGLPlusCulling)
				_boundFrustumBuffer = new Float32Array(24);
			
			super(nearPlane, farPlane);
			transform.on(Event.TRANSFORM_CHANGED, this, _onTransformChanged);
		}
		
		/**
		 *	通过蒙版值获取蒙版是否显示。
		 * 	@param  layer 层。
		 * 	@return 是否显示。
		 */
		public function _isLayerVisible(layer:int):Boolean {
			return (Math.pow(2, layer) & cullingMask) != 0;
		}
		
		/**
		 * @private
		 */
		public function _onTransformChanged(flag:int):void {
			flag &= Transform3D.TRANSFORM_WORLDMATRIX;//过滤有用TRANSFORM标记
			(flag) && (_updateViewMatrix = true);
		}
		
		/**
		 * @private
		 */
		private function _calculationViewport(normalizedViewport:Viewport, width:int, height:int):void {
			_viewport.x = normalizedViewport.x * width;//不应限制x范围
			_viewport.y = normalizedViewport.y * height;//不应限制y范围
			_viewport.width = Math.min(Math.max(normalizedViewport.width * width, 0), width);
			_viewport.height = Math.min(Math.max(normalizedViewport.height * height, 0), height);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			super._parse(data);
			var viewport:Array = data.viewport;
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
					Matrix4x4.createOrthoOffCenter(-halfWidth, halfWidth, -halfHeight, halfHeight, nearPlane, farPlane, _projectionMatrix);
				} else {
					Matrix4x4.createPerspective(3.1416 * fieldOfView / 180.0, aspectRatio, nearPlane, farPlane, _projectionMatrix);
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _getCanvasHeight():int {
			if (_renderTarget)
				return _renderTarget.height;
			else
				return RenderContext3D.clientHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function render(shader:Shader3D = null, replacementTag:String = null):void {
			if (!_scene) //自定义相机渲染需要加保护判断是否在场景中,否则报错
				return;
			
			var gl:WebGLContext = LayaGL.instance;
			var context:RenderContext3D = RenderContext3D._instance;
			var scene:Scene3D = context.scene = _scene as Scene3D;
			if (scene.parallelSplitShadowMaps[0]) {//TODO:SM
				ShaderData.setRuntimeValueMode(false);
				var parallelSplitShadowMap:ParallelSplitShadowMap = scene.parallelSplitShadowMaps[0];
				parallelSplitShadowMap._calcAllLightCameraInfo(this);
				scene._defineDatas.add(Scene3D.SHADERDEFINE_CAST_SHADOW);//增加宏定义
				for (var i:int = 0, n:int = parallelSplitShadowMap.shadowMapCount; i < n; i++) {
					var smCamera:Camera = parallelSplitShadowMap.cameras[i];
					context.camera = smCamera;
					context.projectionViewMatrix = smCamera.projectionViewMatrix;//TODO:重复计算浪费
					FrustumCulling.renderObjectCulling(smCamera, scene, context, scene._castShadowRenders);
					
					var shadowMap:RenderTexture = parallelSplitShadowMap.cameras[i + 1].renderTarget;
					shadowMap._start();
					context.camera = smCamera;
					context.viewport = smCamera.viewport;
					smCamera._prepareCameraToRender();
					smCamera._prepareCameraViewProject(smCamera.viewMatrix, smCamera.projectionMatrix, smCamera._projectionViewMatrixNoTranslateScale);
					scene._clear(gl, context);
					var queue:RenderQueue = scene._opaqueQueue;//阴影均为非透明队列
					queue._render(context, false);//TODO:临时改为False
					shadowMap._end();
				}
				scene._defineDatas.remove(Scene3D.SHADERDEFINE_CAST_SHADOW);//去掉宏定义
				ShaderData.setRuntimeValueMode(true);
			}
			
			context.camera = this;
			
			scene._preRenderScript();//TODO:duo相机是否重复
			
			var viewMat:Matrix4x4, projectMat:Matrix4x4;
			viewMat = context.viewMatrix = viewMatrix;
			var renderTar:RenderTexture = _renderTarget;
			if (renderTar) {
				renderTar._start();
				Matrix4x4.multiply(_invertYScaleMatrix, _projectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, projectionViewMatrix, _invertYProjectionViewMatrix);
				projectMat = context.projectionMatrix = _invertYProjectionMatrix;//TODO:
				context.projectionViewMatrix = _invertYProjectionViewMatrix;//TODO:
			} else {
				projectMat = context.projectionMatrix = _projectionMatrix;//TODO:
				context.projectionViewMatrix = projectionViewMatrix;//TODO:
			}
			context.viewport = viewport;
			_prepareCameraToRender();
			_prepareCameraViewProject(viewMat, projectMat, _projectionViewMatrixNoTranslateScale);
			scene._preCulling(context, this);
			scene._clear(gl, context);
			scene._renderScene(gl, context, shader, replacementTag);
			scene._postRenderScript();//TODO:duo相机是否重复
			(renderTar) && (renderTar._end());
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
			finalPoint.x = point.x * vp.width;
			finalPoint.y = point.y * vp.height;
			
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
			//if (out.z < 0.0 || out.z > 1.0)// TODO:是否需要近似判断
			//{
			//outE[0] = outE[1] = outE[2] = NaN;
			//} else {
			out.x = out.x / Laya.stage.clientScaleX;
			out.y = out.y / Laya.stage.clientScaleY;
			//}
		}
		
		/**
		 * 计算从世界空间准换三维坐标到裁切空间。
		 * @param	position 世界空间的位置。
		 * @return  out  输出位置。
		 */
		public function worldToNormalizedViewportPoint(position:Vector3, out:Vector3):void {
			Matrix4x4.multiply(_projectionMatrix, _viewMatrix, _projectionViewMatrix);
			normalizedViewport.project(position, _projectionViewMatrix, out);
			//if (out.z < 0.0 || out.z > 1.0)// TODO:是否需要近似判断
			//{
			//outE[0] = outE[1] = outE[2] = NaN;
			//} else {
			out.x = out.x / Laya.stage.clientScaleX;
			out.y = out.y / Laya.stage.clientScaleY;
			//}
		}
		
		/**
		 * 转换2D屏幕坐标系统到3D正交投影下的坐标系统，注:只有正交模型下有效。
		 * @param   source 源坐标。
		 * @param   out 输出坐标。
		 * @return 是否转换成功。
		 */
		public function convertScreenCoordToOrthographicCoord(source:Vector3, out:Vector3):Boolean {//TODO:是否应该使用viewport宽高
			if (_orthographic) {
				var clientWidth:int = RenderContext3D.clientWidth;
				var clientHeight:int = RenderContext3D.clientHeight;
				var ratioX:Number = orthographicVerticalSize * aspectRatio / clientWidth;
				var ratioY:Number = orthographicVerticalSize / clientHeight;
				out.x = (-clientWidth / 2 + source.x) * ratioX;
				out.y = (clientHeight / 2 - source.y) * ratioY;
				out.z = (nearPlane - farPlane) * (source.z + 1) / 2 - nearPlane;
				Vector3.transformCoordinate(out, transform.worldMatrix, out);
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			transform.off(Event.TRANSFORM_CHANGED, this, _onTransformChanged);
			super.destroy(destroyChild);
		}
	}
}