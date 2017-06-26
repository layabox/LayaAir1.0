package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.LightSprite;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.DynamicBatchManager;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Sky;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.ICreateResource;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * <code>BaseScene</code> 类用于实现场景。
	 */
	public class Scene extends Sprite implements ISubmit, ICreateResource {
		public static const FOGCOLOR:int = 0;
		public static const FOGSTART:int = 1;
		public static const FOGRANGE:int = 2;
		
		public static const LIGHTDIRECTION:int = 3;
		public static const LIGHTDIRDIFFUSE:int = 4;
		public static const LIGHTDIRAMBIENT:int = 5;
		public static const LIGHTDIRSPECULAR:int = 6;
		
		public static const POINTLIGHTPOS:int = 7;
		public static const POINTLIGHTRANGE:int = 8;
		public static const POINTLIGHTATTENUATION:int = 9;
		public static const POINTLIGHTDIFFUSE:int = 10;
		public static const POINTLIGHTAMBIENT:int = 11;
		public static const POINTLIGHTSPECULAR:int = 12;
		
		public static const SPOTLIGHTPOS:int = 13;
		public static const SPOTLIGHTDIRECTION:int = 14;
		public static const SPOTLIGHTSPOT:int = 15;
		public static const SPOTLIGHTRANGE:int = 16;
		public static const SPOTLIGHTATTENUATION:int = 17;
		public static const SPOTLIGHTDIFFUSE:int = 18;
		public static const SPOTLIGHTAMBIENT:int = 19;
		public static const SPOTLIGHTSPECULAR:int = 20;
		
		public static const SHADOWDISTANCE:int = 21;
		public static const SHADOWLIGHTVIEWPROJECT:int = 22;
		public static const SHADOWMAPPCFOFFSET:int = 23;
		public static const SHADOWMAPTEXTURE1:int = 24;
		public static const SHADOWMAPTEXTURE2:int = 25;
		public static const SHADOWMAPTEXTURE3:int = 26;
		
		/**
		 * @private
		 */
		private static function _sortScenes(a:Node, b:Node):Number {
			if (a.parent === Laya.stage && b.parent === Laya.stage) {
				var stageChildren:Array = Laya.stage._childs;
				return stageChildren.indexOf(a) - stageChildren.indexOf(b);
			} else if (a.parent !== Laya.stage && b.parent !== Laya.stage) {
				return _sortScenes(a.parent, b.parent);
			} else {
				return (a.parent === Laya.stage) ? -1 : 1;
			}
		}
		
		/**
		 * 加载场景,注意:不缓存。
		 * @param url 模板地址。
		 */
		public static function load(url:String):Scene {
			return Laya.loader.create(url, null, null, Scene, null, 1, false);
		}
		
		/**@private */
		private var __loaded:Boolean;
		/**@private */
		private var _url:String;
		
		/** @private */
		protected var _renderState:RenderState = new RenderState();
		/** @private */
		protected var _lights:Vector.<LightSprite> = new Vector.<LightSprite>();
		/** @private */
		private var _lightmaps:Vector.<Texture2D>;
		
		/** @private */
		protected var _enableLightCount:int = 3;
		/** @private */
		protected var _renderTargetTexture:RenderTexture;
		
		/** @private */
		protected var _customRenderQueneIndex:int = 11;
		/** @private */
		protected var _lastCurrentTime:Number;
		/** @private */
		protected var _enableFog:Boolean;
		/** @private */
		protected var _enableDepthFog:Boolean;//不能与_enableFog共存
		/** @private */
		protected var _fogStart:Number;
		/** @private */
		protected var _fogRange:Number;
		/** @private */
		protected var _fogColor:Vector3;
		
		/** @private */
		public var _shaderValues:ValusArray;
		/** @private */
		public var _shaderDefineValue:int;
		
		/** @private */
		public var _cullingRendersLength:int;
		/** @private */
		public var _cullingRenders:Vector.<BaseRender>;
		/** @private */
		public var _dynamicBatchManager:DynamicBatchManager;
		/** @private */
		public var _quenes:Vector.<RenderQueue> = new Vector.<RenderQueue>();
		/**  @private 相机的对象池*/
		public var _cameraPool:Vector.<BaseCamera> = new Vector.<BaseCamera>();
		/** @private */
		public var _renderableSprite3Ds:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>();
		
		/** 是否启用灯光。*/
		public var enableLight:Boolean = true;
		/** 四/八叉树的根节点。*/
		public var treeRoot:ITreeNode;
		/** 四/八叉树的尺寸。*/
		public var treeSize:Vector3;
		/** 四/八叉树的层数。*/
		public var treeLevel:int;
		
		//阴影相关变量
		public var parallelSplitShadowMaps:Vector.<ParallelSplitShadowMap>;
		
		/**
		 * @private
		 */
		public function set _loaded(value:Boolean):void {
			__loaded = value;
		}
		
		/**
		 * 获取资源的URL地址。
		 * @return URL地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 色湖之资源的URL地址。
		 * @param value URL地址。
		 */
		public function set url(value:String):void {
			_url = value;
		}
		
		/**
		 * 获取是否已加载完成。
		 */
		public function get loaded():Boolean {
			return __loaded;
		}
		
		/**
		 * 获取是否允许雾化。
		 * @return 是否允许雾化。
		 */
		public function get enableFog():Boolean {
			return _enableFog;
		}
		
		/**
		 * 设置是否允许雾化。
		 * @param value 是否允许雾化。
		 */
		public function set enableFog(value:Boolean):void {
			if (_enableFog !== value) {
				_enableFog = value;
				if (value) {
					addShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
					removeShaderDefine(ShaderCompile3D.SAHDERDEFINE_DEPTHFOG);
				} else
					removeShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
			}
		}
		
		public function get enableDepthFog():Boolean {
			return _enableDepthFog;
		}
		
		public function set enableDepthFog(v:Boolean):void {
			if (_enableDepthFog != v) {
				_enableDepthFog = v;
				if (v) {
					addShaderDefine(ShaderCompile3D.SAHDERDEFINE_DEPTHFOG);
					removeShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
				} else {
					removeShaderDefine(ShaderCompile3D.SAHDERDEFINE_DEPTHFOG);
				}
			}
		}
		
		/**
		 * 获取雾化颜色。
		 * @return 雾化颜色。
		 */
		public function get fogColor():Vector3 {
			return _fogColor;
		}
		
		/**
		 * 设置雾化颜色。
		 * @param value 雾化颜色。
		 */
		public function set fogColor(value:Vector3):void {
			_fogColor = value;
			_shaderValues.setValue(Scene.FOGCOLOR, value.elements);
		}
		
		/**
		 * 获取雾化起始位置。
		 * @return 雾化起始位置。
		 */
		public function get fogStart():Number {
			return _fogStart;
		}
		
		/**
		 * 设置雾化起始位置。
		 * @param value 雾化起始位置。
		 */
		public function set fogStart(value:Number):void {
			_fogStart = value;
			_shaderValues.setValue(Scene.FOGSTART, value);
		}
		
		/**
		 * 获取雾化范围。
		 * @return 雾化范围。
		 */
		public function get fogRange():Number {
			return _fogRange;
		}
		
		/**
		 * 设置雾化范围。
		 * @param value 雾化范围。
		 */
		public function set fogRange(value:Number):void {
			_fogRange = value;
			_shaderValues.setValue(Scene.FOGRANGE, value);
		}
		
		/**
		 * 获取当前场景。
		 * @return 当前场景。
		 */
		public function get scene():Scene {
			return this;
		}
		
		/**
		 * 获取场景的可渲染精灵。
		 */
		public function get renderableSprite3Ds():Vector.<RenderableSprite3D> {
			return _renderableSprite3Ds.slice();
		}
		
		/**
		 * 创建一个 <code>Scene</code> 实例。
		 */
		public function Scene() {
			__loaded = true;
			_lightmaps = new Vector.<Texture2D>();
			_shaderValues = new ValusArray();
			parallelSplitShadowMaps = new Vector.<ParallelSplitShadowMap>();
			_dynamicBatchManager = new DynamicBatchManager();
			_cullingRenders = new Vector.<BaseRender>();
			_cullingRendersLength = 0;
			enableFog = false;
			fogStart = 300;
			fogRange = 1000;
			fogColor = new Vector3(0.7, 0.7, 0.7);
			(WebGL.frameShaderHighPrecision) && (addShaderDefine(ShaderCompile3D.SHADERDEFINE_FSHIGHPRECISION));
			on(Event.DISPLAY, this, _onDisplay);
			on(Event.UNDISPLAY, this, _onUnDisplay);
		}
		
		/**
		 * 初始化八叉树。
		 * @param	width 八叉树宽度。
		 * @param	height 八叉树高度。
		 * @param	depth 八叉树深度。
		 * @param	center 八叉树中心点
		 * @param	level 八叉树层级。
		 */
		public function initOctree(width:int, height:int, depth:int, center:Vector3, level:int = 6):void {
			treeSize = new Vector3(width, height, depth);
			treeLevel = level;
			treeRoot = new OctreeNode(this, 0);
			treeRoot.init(center, treeSize);
		}
		
		/**
		 * @private
		 */
		private function _onDisplay():void {
			Laya.stage._scenes.push(this);
			Laya.stage._scenes.sort(_sortScenes);
		}
		
		/**
		 * @private
		 */
		private function _onUnDisplay():void {
			var scenes:Array = Laya.stage._scenes;
			scenes.splice(scenes.indexOf(this), 1);
		}
		
		/**
		 * @private
		 * 场景相关渲染准备设置。
		 * @param gl WebGL上下文。
		 * @return state 渲染状态。
		 */
		protected function _prepareUpdateToRenderState(gl:WebGLContext, state:RenderState):void {
			state.elapsedTime = _lastCurrentTime ? timer.currTimer - _lastCurrentTime : 0;
			_lastCurrentTime = timer.currTimer;
			state.scene = this;
		}
		
		/**
		 * @private
		 */
		protected function _prepareSceneToRender(state:RenderState):void {
			var lightCount:int = _lights.length;
			if (lightCount > 0) {
				var renderLightCount:int = 0;
				for (var i:int = 0; i < lightCount; i++) {
					if (!_lights[i].updateToWorldState(state))//TODO:应该直接移除
						continue;
					renderLightCount++;
					if (renderLightCount >= _enableLightCount)
						break;
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function _updateChilds(state:RenderState):void {
			for (var i:int = 0, n:int = _childs.length; i < n; ++i)
				_childs[i]._update(state);
		}
		
		/**
		 * @private
		 */
		protected function _updateChildsConch(state:RenderState):void {//NATIVE
			for (var i:int = 0, n:int = _childs.length; i < n; ++i)
				_childs[i]._updateConch(state);
		}
		
		/**
		 * @private
		 */
		public function _preRenderScene(gl:WebGLContext, state:RenderState):void {
			var view:Matrix4x4 = state._viewMatrix;
			var projection:Matrix4x4 = state._projectionMatrix;
			var projectionView:Matrix4x4 = state._projectionViewMatrix;
			var i:int, iNum:int;
			var camera:BaseCamera = state.camera;
			if (camera.useOcclusionCulling) {
				if (treeRoot)
					FrustumCulling.renderObjectCullingOctree(state._boundFrustum, this, camera, view, projection, projectionView);
				else
					FrustumCulling.renderObjectCulling(state._boundFrustum, this, camera, view, projection, projectionView);
			} else {
				FrustumCulling.renderObjectCullingNoBoundFrustum(this, camera, view, projection, projectionView);
			}
			for (i = 0, iNum = _quenes.length; i < iNum; i++)
				(_quenes[i]) && (_quenes[i]._preRender(state));
		}
		
		/**
		 * @private
		 */
		public function _clear(gl:WebGLContext, state:RenderState):void {
			var viewport:Viewport = state._viewport;
			var camera:BaseCamera = state.camera;
			var vpX:Number = viewport.x;
			var vpY:Number = camera.renderTargetSize.height - viewport.y - viewport.height;
			var vpWidth:Number = viewport.width;
			var vpHeight:Number = viewport.height;
			gl.viewport(vpX, vpY, vpWidth, vpHeight);
			var flag:int = WebGLContext.DEPTH_BUFFER_BIT;
			var renderTarget:RenderTexture = camera.renderTarget;
			switch (camera.clearFlag) {
			case BaseCamera.CLEARFLAG_SOLIDCOLOR: 
				var clearColor:Vector4 = camera.clearColor;
				if (clearColor) {
					gl.enable(WebGLContext.SCISSOR_TEST);
					gl.scissor(vpX, vpY, vpWidth, vpHeight);
					var clearColorE:Float32Array = clearColor.elements;
					gl.clearColor(clearColorE[0], clearColorE[1], clearColorE[2], clearColorE[3]);
					flag |= WebGLContext.COLOR_BUFFER_BIT;
				}
				
				if (renderTarget) {
					(clearColor) || (flag = WebGLContext.COLOR_BUFFER_BIT);
					switch (renderTarget.depthStencilFormat) {
					case WebGLContext.DEPTH_COMPONENT16: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						break;
					case WebGLContext.STENCIL_INDEX8: 
						flag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					case WebGLContext.DEPTH_STENCIL: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						flag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					}
				}
				gl.clear(flag);
				
				if (clearColor)
					gl.disable(WebGLContext.SCISSOR_TEST);
				break;
			case BaseCamera.CLEARFLAG_SKY: 
			case BaseCamera.CLEARFLAG_DEPTHONLY: 
				if (renderTarget) {
					flag = WebGLContext.COLOR_BUFFER_BIT;
					switch (renderTarget.depthStencilFormat) {
					case WebGLContext.DEPTH_COMPONENT16: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						break;
					case WebGLContext.STENCIL_INDEX8: 
						flag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					case WebGLContext.DEPTH_STENCIL: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						flag |= WebGLContext.STENCIL_BUFFER_BIT
						break;
					}
				}
				gl.clear(flag);
				break;
			case BaseCamera.CLEARFLAG_NONE: 
				break;
			default: 
				throw new Error("BaseScene:camera clearFlag invalid.");
			}
		}
		
		/**
		 * @private
		 */
		public function _renderScene(gl:WebGLContext, state:RenderState):void {
			var camera:BaseCamera = state.camera;
			
			var i:int, n:int;
			var queue:RenderQueue;
			for (i = 0; i < 2; i++) {//非透明队列
				queue = _quenes[i];
				if (queue) {
					//queue._sortOpaque(state.camera.transform.position);
					camera.renderTarget ? queue._render(state, true) : queue._render(state, false);
				}
			}
			
			if (camera.clearFlag === BaseCamera.CLEARFLAG_SKY) {
				var sky:Sky = camera.sky;
				if (sky) {
					WebGLContext.setCullFace(gl, false);
					WebGLContext.setDepthFunc(gl, WebGLContext.LEQUAL);
					WebGLContext.setDepthMask(gl, false);
					sky._render(state);
					WebGLContext.setDepthFunc(gl, WebGLContext.LESS);
					WebGLContext.setDepthMask(gl, true);
				}
			}
			
			for (i = 2, n = _quenes.length; i < n; i++) {//透明队列
				queue = _quenes[i];
				if (queue) {
					queue._sortAlpha(state.camera.transform.position);
					camera.renderTarget ? queue._render(state, true) : queue._render(state, false);
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function _set3DRenderConfig(gl:WebGLContext):void {
			gl.disable(WebGLContext.BLEND);//设置3D设置，矫正2D修改后值并配置缓存
			WebGLContext._blend = false;
			gl.blendFunc(WebGLContext.SRC_ALPHA, WebGLContext.ONE_MINUS_SRC_ALPHA);
			WebGLContext._sFactor = WebGLContext.SRC_ALPHA;
			WebGLContext._dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			gl.disable(WebGLContext.DEPTH_TEST);
			WebGLContext._depthTest = false;
			gl.enable(WebGLContext.CULL_FACE);
			WebGLContext._cullFace = true;
			gl.depthMask(1);
			WebGLContext._depthMask = true;
			gl.frontFace(WebGLContext.CW);
			WebGLContext._frontFace = WebGLContext.CW;
		}
		
		/**
		 * @private
		 */
		protected function _set2DRenderConfig(gl:WebGLContext):void {
			WebGLContext.setBlend(gl, true);//还原2D设置，此处用WEBGL强制还原2D设置并非十分合理
			WebGLContext.setBlendFunc(gl, WebGLContext.SRC_ALPHA, WebGLContext.ONE_MINUS_SRC_ALPHA);
			WebGLContext.setDepthTest(gl, false);
			WebGLContext.setCullFace(gl, false);
			WebGLContext.setDepthMask(gl, true);
			WebGLContext.setFrontFace(gl, WebGLContext.CCW);
			gl.viewport(0, 0, RenderState2D.width, RenderState2D.height);//还原2D视口
		}
		
		/**
		 * @private
		 */
		public function _addLight(light:LightSprite):void {
			if (_lights.indexOf(light) < 0) _lights.push(light);
		}
		
		/**
		 * @private
		 */
		public function _removeLight(light:LightSprite):void {
			var index:int = _lights.indexOf(light);
			index >= 0 && (_lights.splice(index, 1));
		}
		
		/**
		 * @private
		 */
		public function _updateScene():void {
			var renderState:RenderState = _renderState;
			_prepareUpdateToRenderState(WebGL.mainContext, renderState);
			
			beforeUpdate(renderState);//更新之前
			_updateChilds(renderState);
			lateUpdate(renderState);//更新之后
		}
		
		/**
		 * @private
		 */
		public function _updateSceneConch():void {//NATIVE
			var renderState:RenderState = _renderState;
			_prepareUpdateToRenderState(WebGL.mainContext, renderState);
			beforeUpdate(renderState);//更新之前
			_updateChildsConch(renderState);
			lateUpdate(renderState);//更新之后
			
			_prepareSceneToRender(renderState);
			for (var i:int = 0, n:int = _cameraPool.length; i < n; i++) {
				var camera:BaseCamera = _cameraPool[i];
				renderState.camera = camera;
				camera._prepareCameraToRender();
			}
		}
		
		/**
		 * @private
		 */
		protected function _preRenderShadow(state:RenderState, lightFrustum:Vector.<BoundFrustum>, shdowQueues:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, nPSSMNum:int):void {//TODO:SM
			if (treeRoot) {
				FrustumCulling.renderShadowObjectCullingOctree(this, lightFrustum, shdowQueues, lightViewProjectMatrix, nPSSMNum);
			} else {
				FrustumCulling.renderShadowObjectCulling(this, lightFrustum, shdowQueues, lightViewProjectMatrix, nPSSMNum);
			}
			for (var i:int = 0, iNum:int = shdowQueues.length; i < iNum; i++)
				(shdowQueues[i]) && (shdowQueues[i]._preRender(state));
		}
		
		/**
		 * @private
		 */
		public function _renderShadowMap(gl:WebGLContext, state:RenderState, sceneCamera:BaseCamera):void {//TODO:SM
			var parallelSplitShadowMap:ParallelSplitShadowMap = parallelSplitShadowMaps[0];
			parallelSplitShadowMap._calcAllLightCameraInfo(sceneCamera);
			var pssmNum:int = parallelSplitShadowMap.PSSMNum;
			_preRenderShadow(state, parallelSplitShadowMap._lightCulling, parallelSplitShadowMap._shadowQuenes, parallelSplitShadowMap._lightVPMatrix[0], pssmNum);
			//增加宏定义
			addShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_CAST_SHADOW);
			var renderTarget:RenderTexture, shadowQuene:RenderQueue, lightCamera:Camera;
			if (pssmNum > 1) {
				for (var i:int = 0; i < pssmNum; i++) {
					//trace(">>>>>i="+i+",size=" + _shadowQuenes[i]._renderElements.length);
					renderTarget = parallelSplitShadowMap.getRenderTarget(i + 1);
					parallelSplitShadowMap.beginRenderTarget(i + 1);
					gl.clearColor(1, 1, 1, 1);
					gl.clear(WebGLContext.COLOR_BUFFER_BIT | WebGLContext.DEPTH_BUFFER_BIT);
					gl.viewport(0, 0, renderTarget.width, renderTarget.height);
					state.camera = lightCamera = parallelSplitShadowMap.getLightCamera(i);
					lightCamera._prepareCameraToRender();
					lightCamera._prepareCameraViewProject(lightCamera.viewMatrix, lightCamera.projectionMatrix);
					state._projectionViewMatrix = parallelSplitShadowMap._lightVPMatrix[i + 1];
					shadowQuene = parallelSplitShadowMap._shadowQuenes[i];
					shadowQuene._preRender(state);//TODO:静态合并和动态合并用，是否调用重复了
					shadowQuene._renderShadow(state, false);
					parallelSplitShadowMap.endRenderTarget(i + 1);
				}
			} else {
				renderTarget = parallelSplitShadowMap.getRenderTarget(1);
				parallelSplitShadowMap.beginRenderTarget(1);
				gl.clearColor(1, 1, 1, 1);
				gl.clear(WebGLContext.COLOR_BUFFER_BIT | WebGLContext.DEPTH_BUFFER_BIT);
				gl.viewport(0, 0, renderTarget.width, renderTarget.height);
				state.camera = lightCamera = parallelSplitShadowMap.getLightCamera(0);
				lightCamera._prepareCameraToRender();
				lightCamera._prepareCameraViewProject(lightCamera.viewMatrix, lightCamera.projectionMatrix);
				state._projectionViewMatrix = parallelSplitShadowMap._lightVPMatrix[0];
				shadowQuene = parallelSplitShadowMap._shadowQuenes[0];
				shadowQuene._preRender(state);//TODO:静态合并和动态合并用，是否调用重复了
				shadowQuene._renderShadow(state, true);
				parallelSplitShadowMap.endRenderTarget(1);
			}
			//去掉宏定义
			removeShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_CAST_SHADOW);
		}
		
		/**
		 * @private
		 */
		public function addTreeNode(renderObj:BaseRender):void {
			treeRoot.addTreeNode(renderObj);
		}
		
		/**
		 * @private
		 */
		public function removeTreeNode(renderObj:BaseRender):void {
			if (!treeSize) return;
			if (renderObj._treeNode) {
				renderObj._treeNode.removeObject(renderObj);
			}
		}
		
		/**
		 * 设置光照贴图。
		 * @param value 光照贴图。
		 */
		public function setlightmaps(value:Vector.<Texture2D>):void {
			_lightmaps = value;
			for (var i:int = 0, n:int = _renderableSprite3Ds.length; i < n; i++)
				_renderableSprite3Ds[i]._render._applyLightMapParams();
		}
		
		/**
		 * 获取光照贴图。
		 * @return 获取光照贴图。
		 */
		public function getlightmaps():Vector.<Texture2D> {
			return _lightmaps;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt(node:Node, index:int):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			
			if (!node || destroyed || node === this) return node;
			if (Sprite(node).zOrder) _set$P("hasZorder", true);
			if (index >= 0 && index <= this._childs.length) {
				if (node._parent === this) {
					var oldIndex:int = getChildIndex(node);
					this._childs.splice(oldIndex, 1);
					this._childs.splice(index, 0, node);
					if (conchModel) {
						conchModel.removeChild(node.conchModel);
						conchModel.addChildAt(node.conchModel, index);
					}
					_childChanged();
				} else {
					node.parent && node.parent.removeChild(node);
					this._childs === ARRAY_EMPTY && (this._childs = []);
					this._childs.splice(index, 0, node);
					conchModel && conchModel.addChildAt(node.conchModel, index);
					node.parent = this;
					
					var sprite3D:Sprite3D = node as Sprite3D;
					sprite3D.transform._onWorldTransform();
					sprite3D._setBelongScene(this);
					(sprite3D.active) && (sprite3D._activeHierarchy());
				}
				return node;
			} else {
				throw new Error("appendChildAt:The index is out of bounds");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChild(node:Node):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			
			if (!node || destroyed || node === this) return node;
			if (Sprite(node).zOrder) _set$P("hasZorder", true);
			if (node._parent === this) {
				var index:int = getChildIndex(node);
				if (index !== _childs.length - 1) {
					this._childs.splice(index, 1);
					this._childs.push(node);
					if (conchModel) {
						conchModel.removeChild(node.conchModel);
						conchModel.addChildAt(node.conchModel, this._childs.length - 1);
					}
					_childChanged();
				}
			} else {
				node.parent && node.parent.removeChild(node);
				this._childs === ARRAY_EMPTY && (this._childs = []);
				this._childs.push(node);
				conchModel && conchModel.addChildAt(node.conchModel, this._childs.length - 1);
				node.parent = this;
				_childChanged();
				
				var sprite3D:Sprite3D = node as Sprite3D;
				sprite3D.transform._onWorldTransform();
				sprite3D._setBelongScene(this);
				(sprite3D.active) && (sprite3D._activeHierarchy());
			}
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt(index:int):Node {
			var node:Node = getChildAt(index);
			if (node) {
				var sprite3D:Sprite3D = node as Sprite3D;
				sprite3D.transform.parent = null;
				(sprite3D.active) && (sprite3D._inActiveHierarchy());
				sprite3D._setUnBelongScene();
				this._childs.splice(index, 1);
				conchModel && conchModel.removeChild(node.conchModel);
				node.parent = null;
			}
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):Node {
			if (_childs && _childs.length > 0) {
				var childs:Array = this._childs;
				if (beginIndex === 0 && endIndex >= n) {
					var arr:Array = childs;
					this._childs = ARRAY_EMPTY;
				} else {
					arr = childs.splice(beginIndex, endIndex - beginIndex);
				}
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					arr[i].parent = null;
					var sprite3D:Sprite3D = arr[i] as Sprite3D;
					sprite3D.transform.parent = null;
					(sprite3D.active) && (sprite3D._inActiveHierarchy());
					sprite3D._setUnBelongScene();
					conchModel && conchModel.removeChild(arr[i].conchModel);
				}
			}
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addFrustumCullingObject(renderObject:BaseRender):void {
			if (treeRoot) {
				addTreeNode(renderObject);
			} else {
				if (_cullingRendersLength === _cullingRenders.length)
					_cullingRenders.push(renderObject);
				else
					_cullingRenders[_cullingRendersLength] = renderObject;
				renderObject._indexInSceneFrustumCullingObjects = _cullingRendersLength++;
			}
		}
		
		/**
		 * @private
		 */
		public function removeFrustumCullingObject(renderObject:BaseRender):void {
			if (treeRoot) {
				removeTreeNode(renderObject);
			} else {
				_cullingRendersLength--;
				var indexInSceneFrustumCullingObjects:int = renderObject._indexInSceneFrustumCullingObjects;
				if (indexInSceneFrustumCullingObjects !== _cullingRendersLength) {
					var endRender:BaseRender = _cullingRenders[_cullingRendersLength];
					_cullingRenders[indexInSceneFrustumCullingObjects] = endRender;
					endRender._indexInSceneFrustumCullingObjects = indexInSceneFrustumCullingObjects;
					renderObject._indexInSceneFrustumCullingObjects = -1;
				}
			}
		}
		
		/**
		 * 获得某个渲染队列。
		 * @param index 渲染队列索引。
		 * @return 渲染队列。
		 */
		public function getRenderQueue(index:int):RenderQueue {
			return (_quenes[index] || (_quenes[index] = new RenderQueue(this)));
		}
		
		/**
		 * 添加渲染队列。
		 * @param renderConfig 渲染队列配置文件。
		 */
		public function addRenderQuene():void {
			_quenes[_customRenderQueneIndex++] = new RenderQueue(this);
		}
		
		/**
		 * 更新前处理,可重写此函数。
		 * @param state 渲染相关状态。
		 */
		public function beforeUpdate(state:RenderState):void {
		}
		
		/**
		 * 更新后处理,可重写此函数。
		 * @param state 渲染相关状态。
		 */
		public function lateUpdate(state:RenderState):void {
		}
		
		/**
		 * 渲染前处理,可重写此函数。
		 * @param state 渲染相关状态。
		 */
		public function beforeRender(state:RenderState):void {
		}
		
		/**
		 * 渲染后处理,可重写此函数。
		 * @param state 渲染相关状态。
		 */
		public function lateRender(state:RenderState):void {
		}
		
		/**
		 * 增加shader宏定义。
		 * @param	define shader宏定义。
		 */
		public function addShaderDefine(define:int):void {
			_shaderDefineValue |= define;
		}
		
		/**
		 * 移除shader宏定义。
		 * @param	define shader宏定义。
		 */
		public function removeShaderDefine(define:int):void {
			_shaderDefineValue &= ~define;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function render(context:RenderContext, x:Number, y:Number):void {
			(Render._context.ctx as WebGLContext2D)._shader2D.glTexture = null;//TODO:临时清空2D合并，不然影响图层合并。
			_childs.length > 0 && context.addRenderObject(this);
			_renderType &= ~RenderSprite.CHILDS;
			super.render(context, x, y);
		}
		
		/**
		 * @private
		 */
		public function renderSubmit():int {
			var gl:WebGLContext = WebGL.mainContext;
			var renderState:RenderState = _renderState;
			_set3DRenderConfig(gl);//设置3D配置
			_prepareSceneToRender(_renderState);
			
			var i:int, n:int, camera:BaseCamera;
			if (Laya3D.debugMode || OctreeNode.debugMode) {
				for (i = 0, n = _cameraPool.length; i < n; i++) {
					Laya3D._debugPhasorSprite.begin(WebGLContext.LINES, renderState);
					camera = _cameraPool[i];
					(camera.activeInHierarchy) && (camera._renderCamera(gl, renderState, this));//TODO:
					Laya3D._debugPhasorSprite.end();
				}
			} else {
				for (i = 0, n = _cameraPool.length; i < n; i++) {
					camera = _cameraPool[i];
					(camera.activeInHierarchy) && (camera._renderCamera(gl, renderState, this));//TODO:
				}
			}
			
			_set2DRenderConfig(gl);//设置2D配置
			return 1;
		}
		
		/**
		 *@private
		 */
		public function onAsynLoaded(url:String, data:*, params:Array):void {
			if (destroyed)//TODO:其它资源是否同样处理
				return;
			
			var json:Object = JSON.parse(data[0] as String);
			if (json.type !== "Scene")
				throw new Error("Scene: the .lh file root type must be Scene,please use other function to  load  this file.");
			
			var innerResouMap:Object = data[1];
			ClassUtils.createByJson(json, this, this, Handler.create(null, Utils3D._parseHierarchyProp, [innerResouMap], false), Handler.create(null, Utils3D._parseHierarchyNode, null, false));
			event(Event.HIERARCHY_LOADED, [this]);
			__loaded = true;
		}
		
		/**
		 * @private
		 */
		public function getRenderType():int {
			return 0;
		}
		
		/**
		 * @private
		 */
		public function releaseRender():void {
		}
		
		/**
		 * @private
		 */
		override public function createConchModel():* { //NATIVE
			var pScene:* = __JS__("new ConchScene()");
			//TODO:wyw
			pScene.init(512, 512, 512, 4);
			return pScene;
		}
	
	}

}