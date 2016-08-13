package laya.d3.core.scene {
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.light.LightSprite;
	import laya.d3.core.render.RenderConfig;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.RenderTarget;
	import laya.d3.shader.ShaderDefines3D;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * <code>BaseScene</code> 类用于实现场景的父类。
	 */
	public class BaseScene extends Sprite implements ISubmit {
		/** 定义顶点着色模式的标记。*/
		public static const VERTEX_SHADING:int = 0;
		/** 定义像素着色模式的标记。*/
		public static const PIXEL_SHADING:int = 1;
		
		/** @private */
		protected var _renderState:RenderState = new RenderState();
		/** @private */
		protected var _lights:Vector.<LightSprite> = new Vector.<LightSprite>;
		/** @private */
		protected var _enableLightCount:int = 3;
		/** @private */
		protected var _renderTargetTexture:RenderTarget;
		/** @private */
		protected var _shadingMode:int = ShaderDefines3D.PIXELSHADERING;
		/** @private */
		protected var _renderConfigs:Vector.<RenderConfig> = new Vector.<RenderConfig>();
		/** @private */
		protected var _quenes:Vector.<RenderQueue> = new Vector.<RenderQueue>();
		/** @private */
		protected var _customRenderQueneIndex:int = 11;
		/** @private */
		protected var _lastCurrentTime:Number;
		
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
		/** 当前摄像机。*/
		public var currentCamera:BaseCamera;
		
		/**
		 * 获取当前场景。
		 * @return 当前场景。
		 */
		public function get scene():BaseScene {
			return this;
		}
		
		/**
		 * 获取着色模式。
		 * @return  着色模式。
		 */
		public function get shadingMode():int {
			return _shadingMode == ShaderDefines3D.VERTEXSHADERING ? BaseScene.VERTEX_SHADING : ShaderDefines3D.PIXELSHADERING;
		}
		
		/**
		 * 设置着色模式。
		 * @param value 着色模式。
		 */
		public function set shadingMode(value:int):void {
			if (value !== BaseScene.VERTEX_SHADING && value !== BaseScene.PIXEL_SHADING) throw Error("Scene set shadingMode,must:0 or 1,value=" + value);
			_shadingMode = value === BaseScene.VERTEX_SHADING ? ShaderDefines3D.VERTEXSHADERING : ShaderDefines3D.PIXELSHADERING;
		}
		
		/**
		 * 创建一个 <code>BaseScene</code> 实例。
		 */
		public function BaseScene() {
			enableFog = false;
			fogStart = 300;
			fogRange = 1000;
			fogColor = new Vector3(0.7, 0.7, 0.7);
			
			_renderConfigs[RenderQueue.NONEWRITEDEPTH] = new RenderConfig();
			_renderConfigs[RenderQueue.NONEWRITEDEPTH].depthTest = false;
			
			_renderConfigs[RenderQueue.OPAQUE] = new RenderConfig();
			
			_renderConfigs[RenderQueue.OPAQUE_DOUBLEFACE] = new RenderConfig();
			_renderConfigs[RenderQueue.OPAQUE_DOUBLEFACE].cullFace = false;
			
			_renderConfigs[RenderQueue.ALPHA_BLEND_DOUBLEFACE] = new RenderConfig();
			_renderConfigs[RenderQueue.ALPHA_BLEND_DOUBLEFACE].cullFace = false;
			_renderConfigs[RenderQueue.ALPHA_BLEND_DOUBLEFACE].blend = true;
			_renderConfigs[RenderQueue.ALPHA_BLEND_DOUBLEFACE].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.ALPHA_BLEND_DOUBLEFACE].dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE] = new RenderConfig();
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE].cullFace = false;
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE].blend = true;
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE].dFactor = WebGLContext.ONE;
			
			_renderConfigs[RenderQueue.ALPHA_BLEND] = new RenderConfig();
			_renderConfigs[RenderQueue.ALPHA_BLEND].blend = true;
			_renderConfigs[RenderQueue.ALPHA_BLEND].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.ALPHA_BLEND].dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND] = new RenderConfig();
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND].blend = true;
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.ALPHA_ADDTIVE_BLEND].dFactor = WebGLContext.ONE;
			
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE] = new RenderConfig();
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE].cullFace = false;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE].blend = true;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE].depthMask = 0;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE].dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE] = new RenderConfig();
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE].cullFace = false;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE].blend = true;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE].depthMask = 0;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE].dFactor = WebGLContext.ONE;
			
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND] = new RenderConfig();
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND].blend = true;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND].depthMask = 0;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_BLEND].dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND] = new RenderConfig();
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND].blend = true;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND].depthMask = 0;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND].sFactor = WebGLContext.SRC_ALPHA;
			_renderConfigs[RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND].dFactor = WebGLContext.ONE;
		}
		
		/**
		 * @private
		 * 清除背景色。
		 * @param gl WebGL上下文。
		 */
		protected function _clearColor(gl:WebGLContext):void {
			var clearColore:Float32Array = currentCamera.clearColor.elements;
			gl.clearColor(clearColore[0], clearColore[1], clearColore[2], clearColore[3]);
			gl.clear(WebGLContext.COLOR_BUFFER_BIT | WebGLContext.DEPTH_BUFFER_BIT);
		
		}
		
		/**
		 * @private
		 * 场景相关渲染准备设置。
		 * @param gl WebGL上下文。
		 * @return state 渲染状态。
		 */
		protected function _prepareScene(gl:WebGLContext, state:RenderState):void {
			Layer._currentCameraCullingMask = currentCamera.cullingMask;
			
			state.context = WebGL.mainContext;
			state.worldTransformModifyID = 1;
			
			state.elapsedTime = _lastCurrentTime ? timer.currTimer - _lastCurrentTime : 0;
			_lastCurrentTime = timer.currTimer;
			
			state.reset();
			state.loopCount = Stat.loopCount;
			state.shadingMode = _shadingMode;
			state.scene = this;
			state.camera = currentCamera;
			
			var shaderValue:ValusArray = state.worldShaderValue;
			var loopCount:int = Stat.loopCount;
			currentCamera && shaderValue.pushValue(Buffer2D.CAMERAPOS, currentCamera.transform.position.elements, loopCount);
			
			if (_lights.length > 0)//灯光相关
			{
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
			if (enableFog)//雾化
			{
				state.worldShaderValue.pushValue(Buffer2D.FOGSTART, fogStart, loopCount);
				state.worldShaderValue.pushValue(Buffer2D.FOGRANGE, fogRange, loopCount);
				state.worldShaderValue.pushValue(Buffer2D.FOGCOLOR, fogColor.elements, loopCount);
			}
		}
		
		/**
		 * @private
		 */
		protected function _updateScene(state:RenderState):void {
			_updateChilds(state);
		}
		
		/**
		 * @private
		 */
		protected function _updateChilds(state:RenderState):void {
			for (var i:int = 0, n:int = _childs.length; i < n; ++i) {
				var child:Sprite3D = _childs[i];
				child._update(state);
			}
		}
		
		/**
		 * @private
		 */
		protected function _preRenderScene(gl:WebGLContext, state:RenderState):void {
			for (var i:int = 0; i < _quenes.length; i++) {
				if (_quenes[i]) {
					_quenes[i]._preRender(state);
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function _renderScene(gl:WebGLContext, state:RenderState):void {
			var viewport:Viewport = state.viewport;
			gl.viewport(viewport.x, RenderState.clientHeight - viewport.y - viewport.height, viewport.width, viewport.height);
			for (var i:int = 0; i < _quenes.length; i++) {
				if (_quenes[i]) {
					_quenes[i]._setState(gl);
					_quenes[i]._render(state);
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
			WebGLContext.setCullFace(gl, true);
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
		
		override public function removeChildAt(index:int):Node {
			var node:Node = getChildAt(index);
			if (node) {
				this._childs.splice(index, 1);
				model && model.removeChild(node.model);
				node.parent = null;
				
				(node as Sprite3D)._clearSelfAndChildrenRenderObjects();
			}
			return node;
		}
		
		/**
		 * 获得某个渲染队列。
		 * @param index 渲染队列索引。
		 * @return 渲染队列。
		 */
		public function getRenderQueue(index:int):RenderQueue {
			return (_quenes[index] || (_quenes[index] = new RenderQueue(_renderConfigs[index])));
		}
		
		/**
		 * 获得某个渲染队列的渲染物体。
		 * @param index 渲染队列索引。
		 * @return 渲染物体。
		 */
		public function getRenderObject(index:int):RenderObject {
			return (_quenes[index] || (_quenes[index] = new RenderQueue(_renderConfigs[index]))).getRenderObj();
		}
		
		/**
		 * 添加渲染队列。
		 * @param renderConfig 渲染队列配置文件。
		 */
		public function addRenderQuene(renderConfig:RenderConfig):void {
			_quenes[_customRenderQueneIndex++] = new RenderQueue(renderConfig);
		}
		
		/**
		 * 更新前处理,可重写此函数。
		 * @param state 渲染相关状态。
		 */
		public function beforeUpate(state:RenderState):void {
		}
		
		/**
		 * 更新后处理,可重写此函数。
		 * @param state 渲染相关状态。
		 */
		public function lateUpate(state:RenderState):void {
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