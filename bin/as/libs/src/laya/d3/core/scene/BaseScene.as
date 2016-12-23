package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Layer;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.LightSprite;
	import laya.d3.core.render.RenderConfig;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.DynamicBatchManager;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.models.Sky;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.shader.ValusArray;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * <code>BaseScene</code> 类用于实现场景的父类。
	 */
	public class BaseScene extends Sprite implements ISubmit {		
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
		
		/** @private */
		protected var _invertYProjectionMatrix:Matrix4x4;
		/** @private */
		protected var _invertYProjectionViewMatrix:Matrix4x4;
		/** @private */
		protected var _invertYScaleMatrix:Matrix4x4;
		/** @private */
		protected var _boundFrustum:BoundFrustum;
		/** @private */
		protected var _renderState:RenderState = new RenderState();
		/** @private */
		protected var _lights:Vector.<LightSprite> = new Vector.<LightSprite>;
		/** @private */
		protected var _enableLightCount:int = 3;
		/** @private */
		protected var _renderTargetTexture:RenderTexture;
		/** @private */
		protected var _renderConfigs:Vector.<RenderConfig> = new Vector.<RenderConfig>();
		
		/** @private */
		protected var _customRenderQueneIndex:int = 11;
		/** @private */
		protected var _lastCurrentTime:Number;
		
		/** @private */
		public var _shaderValues:ValusArray;
		
		/** @private */
		public var _frustumCullingObjects:Vector.<RenderObject> = new Vector.<RenderObject>();
		/** @private */
		public var _staticBatchManager:StaticBatchManager;//TODO:释放问题。
		/** @private */
		public var _dynamicBatchManager:DynamicBatchManager;
		/** @private */
		public var _quenes:Vector.<RenderQueue> = new Vector.<RenderQueue>();
		/**  @private 相机的对象池*/
		public var _cameraPool:Vector.<BaseCamera> = new Vector.<BaseCamera>();
		
		/** 是否允许雾化。*/
		public var enableFog:Boolean;
		/** 雾化起始距离。*/
		public var fogStart:Number;
		/** 雾化结束距离。*/
		public var fogRange:Number;
		/** 雾化颜色。*/
		public var fogColor:Vector3;
		/** 是否启用灯光。*/
		public var enableLight:Boolean = true;
		
		/**
		 * 获取当前场景。
		 * @return 当前场景。
		 */
		public function get scene():BaseScene {
			return this;
		}
		
		/**
		 * 创建一个 <code>BaseScene</code> 实例。
		 */
		public function BaseScene() {
			_shaderValues = new ValusArray();
			_invertYProjectionMatrix = new Matrix4x4();
			_invertYProjectionViewMatrix = new Matrix4x4();
			_invertYScaleMatrix = new Matrix4x4();
			Matrix4x4.createScaling(new Vector3(1, -1, 1), _invertYScaleMatrix);
			_staticBatchManager = new StaticBatchManager();
			_dynamicBatchManager = new DynamicBatchManager();
			_boundFrustum = new BoundFrustum(Matrix4x4.DEFAULT);
			enableFog = false;
			fogStart = 300;
			fogRange = 1000;
			fogColor = new Vector3(0.7, 0.7, 0.7);
			
			var renderConfig:RenderConfig;
			renderConfig = _renderConfigs[RenderQueue.OPAQUE] = new RenderConfig();
			
			renderConfig = _renderConfigs[RenderQueue.OPAQUE_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			
			renderConfig = _renderConfigs[RenderQueue.ALPHA_BLEND] = new RenderConfig();
			renderConfig.blend = true;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			renderConfig = _renderConfigs[RenderQueue.ALPHA_BLEND_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			renderConfig.blend = true;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			renderConfig = _renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND] = new RenderConfig();
			renderConfig.blend = true;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE;
			
			renderConfig = _renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			renderConfig.blend = true;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE;
			
			renderConfig = _renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND] = new RenderConfig();
			renderConfig.blend = true;
			renderConfig.depthMask = 0;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			renderConfig = _renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND] = new RenderConfig();
			renderConfig.blend = true;
			renderConfig.depthMask = 0;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE;
			
			renderConfig = _renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			renderConfig.blend = true;
			renderConfig.depthMask = 0;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			renderConfig = _renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			renderConfig.blend = true;
			renderConfig.depthMask = 0;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE;
			
			renderConfig = _renderConfigs[RenderQueue.NONDEPTH_ALPHA_BLEND] = new RenderConfig();
			renderConfig.blend = true;
			renderConfig.depthTest = false;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			renderConfig = _renderConfigs[RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND] = new RenderConfig();
			renderConfig.blend = true;
			renderConfig.depthTest = false;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE;
			
			renderConfig = _renderConfigs[RenderQueue.NONDEPTH_ALPHA_BLEND_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			renderConfig.blend = true;
			renderConfig.depthTest = false;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			renderConfig = _renderConfigs[RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE] = new RenderConfig();
			renderConfig.cullFace = false;
			renderConfig.blend = true;
			renderConfig.depthTest = false;
			renderConfig.sFactor = WebGLContext.SRC_ALPHA;
			renderConfig.dFactor = WebGLContext.ONE;
			
			on(Event.DISPLAY, this, _onDisplay);
			on(Event.UNDISPLAY, this, _onUnDisplay);
		}
		
		override public function createConchModel():* //NATIVE
		{
			var pScene:* = __JS__("new ConchScene()");
			//TODO wyw
			pScene.init(512, 512, 512, 4);
			return pScene;
			;
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
			state.context = WebGL.mainContext;
			state.elapsedTime = _lastCurrentTime ? timer.currTimer - _lastCurrentTime : 0;
			_lastCurrentTime = timer.currTimer;
			state.loopCount = Stat.loopCount;
			state.scene = this;
		}
		
		/**
		 * @private
		 * 场景相关渲染准备设置。
		 * @param gl WebGL上下文。
		 * @return state 渲染状态。
		 */
		protected function _prepareSceneToRender(state:RenderState):void {
			var shaderDefines:ShaderDefines3D = state.shaderDefines;
			(WebGL.frameShaderHighPrecision) && (shaderDefines.addInt(ShaderDefines3D.FSHIGHPRECISION));
			
			if (_lights.length > 0) {
				var lightCount:int = 0;
				for (var i:int = 0; i < _lights.length; i++) {
					var light:LightSprite = _lights[i];
					if (!light.active) continue;
					lightCount++;
					if (lightCount > _enableLightCount)
						break;
					light.updateToWorldState(state);
				}
			}
			if (enableFog) {
				var sceneSV:ValusArray = _shaderValues;
				shaderDefines.addInt(ShaderDefines3D.FOG);
				sceneSV.setValue(BaseScene.FOGSTART, fogStart);
				sceneSV.setValue(BaseScene.FOGRANGE, fogRange);
				sceneSV.setValue(BaseScene.FOGCOLOR, fogColor.elements);
			}
		}
		
		protected function _endRenderToRenderState(state:RenderState):void {
			_shaderValues.data.length = 0;
			state.reset();
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
			if (Render.isConchNode) {//NATIVE
				_prepareSceneToRender(renderState);
				for (var i:int = 0, n:int = _cameraPool.length; i < n; i++) {
					var camera:BaseCamera = _cameraPool[i];
					renderState.camera = camera;
					camera._prepareCameraToRender();
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
		protected function _preRenderScene(gl:WebGLContext, state:RenderState):void {
			_boundFrustum.matrix = state.projectionViewMatrix;
			
			FrustumCulling.RenderObjectCulling(_boundFrustum, this,state.viewMatrix,state.projectionMatrix,state.projectionViewMatrix);
			for (var i:int = 0, iNum:int = _quenes.length; i < iNum; i++)
				(_quenes[i]) && (_quenes[i]._preRender(state));
		}
		
		protected function _clear(gl:WebGLContext, state:RenderState):void {
			var viewport:Viewport = state.viewport;
			var camera:BaseCamera = state.camera;
			var renderTargetHeight:int = camera.renderTargetSize.height;
			gl.viewport(viewport.x, renderTargetHeight - viewport.y - viewport.height, viewport.width, viewport.height);
			var clearFlag:int = 0;
			switch (camera.clearFlag) {
			case BaseCamera.CLEARFLAG_SOLIDCOLOR: 
				if (camera.clearColor) {
					gl.enable(WebGLContext.SCISSOR_TEST);
					gl.scissor(viewport.x, renderTargetHeight - viewport.y - viewport.height, viewport.width, viewport.height);
					var clearColorE:Float32Array = camera.clearColor.elements;
					gl.clearColor(clearColorE[0], clearColorE[1], clearColorE[2], clearColorE[3]);
					
					clearFlag = WebGLContext.COLOR_BUFFER_BIT;
					if (camera.renderTarget) {
						switch (camera.renderTarget.depthStencilFormat) {
						case WebGLContext.DEPTH_COMPONENT16: 
							clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
							break;
						case WebGLContext.STENCIL_INDEX8: 
							clearFlag |= WebGLContext.STENCIL_BUFFER_BIT;
							break;
						case WebGLContext.DEPTH_STENCIL: 
							clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
							clearFlag |= WebGLContext.STENCIL_BUFFER_BIT
							break;
						}
					} else {
						clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
					}
					
					gl.clear(clearFlag);
					//gl.clear(WebGLContext.DEPTH_BUFFER_BIT | WebGLContext.STENCIL_BUFFER_BIT | WebGLContext.COLOR_BUFFER_BIT);
					gl.disable(WebGLContext.SCISSOR_TEST);
				} else {
					gl.clear(WebGLContext.DEPTH_BUFFER_BIT);
						//gl.clear(WebGLContext.DEPTH_BUFFER_BIT | WebGLContext.STENCIL_BUFFER_BIT | WebGLContext.COLOR_BUFFER_BIT);
				}
				break;
			case BaseCamera.CLEARFLAG_SKY: 
			case BaseCamera.CLEARFLAG_DEPTHONLY: 
				if (camera.renderTarget) {
					switch (camera.renderTarget.depthStencilFormat) {
					case WebGLContext.DEPTH_COMPONENT16: 
						clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
						break;
					case WebGLContext.STENCIL_INDEX8: 
						clearFlag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					case WebGLContext.DEPTH_STENCIL: 
						clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
						clearFlag |= WebGLContext.STENCIL_BUFFER_BIT
						break;
					}
				} else {
					clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
				}
				
				//gl.clear(clearFlag);
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
		protected function _renderScene(gl:WebGLContext, state:RenderState):void {
			var camera:BaseCamera = state.camera;
			
			var i:int, n:int;
			var queue:RenderQueue;
			for (i = 0; i < 3; i++) {//非透明队列
				queue = _quenes[i];
				if (queue) {
					queue._setState(gl, state);
					queue._render(state);
				}
			}
			
			if (camera.clearFlag === BaseCamera.CLEARFLAG_SKY) {
				var sky:Sky = camera.sky;
				if (sky) {
					WebGLContext.setCullFace(gl, false);
					WebGLContext.setDepthFunc(gl, WebGLContext.LEQUAL);
					WebGLContext.setDepthMask(gl, 0);
					sky._render(state);
					WebGLContext.setDepthFunc(gl, WebGLContext.LESS);
					WebGLContext.setDepthMask(gl, 1);
				}
			}
			
			for (i = 3, n = _quenes.length; i < n; i++) {//透明队列
				queue = _quenes[i];
				if (queue) {
					queue._sortAlpha(state.camera.transform.position);//TODO:加色法
					queue._setState(gl, state);
					queue._render(state);
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
			WebGLContext._depthMask = 1;
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
			WebGLContext.setDepthMask(gl, 1);
			WebGLContext.setFrontFaceCCW(gl, WebGLContext.CCW);
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
		
		override public function addChildAt(node:Node, index:int):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			
			return super.addChildAt(node, index);
		}
		
		override public function addChild(node:Node):Node {
			if (!(node is Sprite3D))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			
			return super.addChild(node);
		}
		
		public function addFrustumCullingObject(frustumCullingObject:RenderObject):void {
			_frustumCullingObjects.push(frustumCullingObject);
		}
		
		public function removeFrustumCullingObject(frustumCullingObject:RenderObject):void {
			var index:int = _frustumCullingObjects.indexOf(frustumCullingObject);
			(index !== -1) && (_frustumCullingObjects.splice(index, 1));
		}
		
		/**
		 * 获得某个渲染队列。
		 * @param index 渲染队列索引。
		 * @return 渲染队列。
		 */
		public function getRenderQueue(index:int):RenderQueue {
			return (_quenes[index] || (_quenes[index] = new RenderQueue(_renderConfigs[index], this)));
		}
		
		/**
		 * 添加渲染队列。
		 * @param renderConfig 渲染队列配置文件。
		 */
		public function addRenderQuene(renderConfig:RenderConfig):void {
			_quenes[_customRenderQueneIndex++] = new RenderQueue(renderConfig, this);
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
		 * @private
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
			return 1;
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
	
	}

}