package laya.d3.core.render {
	import laya.d3.component.Component3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.StaticBatch;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderQuene</code> 类用于实现渲染队列。
	 */
	public class RenderQueue {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0/*int.MIN_VALUE*/;
		/** 定义非透明渲染队列标记。*/
		public static const OPAQUE:int = 1;
		/** 定义非透明、双面渲染队列标记。*/
		public static const OPAQUE_DOUBLEFACE:int = 2;
		
		/** 透明混合渲染队列标记。*/
		public static const ALPHA_BLEND:int = 3;
		/** 透明混合、双面渲染队列标记。*/
		public static const ALPHA_BLEND_DOUBLEFACE:int = 4;
		/** 透明加色混合。*/
		public static const ALPHA_ADDTIVE_BLEND:int = 5;
		/** 透明加色混合、双面渲染队列标记。*/
		public static const ALPHA_ADDTIVE_BLEND_DOUBLEFACE:int = 6;
		
		/** 定义深度只读、透明混合渲染队列标记。*/
		public static const DEPTHREAD_ALPHA_BLEND:int = 7;
		/** 定义深度只读、透明混合、双面渲染队列标记。*/
		public static const DEPTHREAD_ALPHA_BLEND_DOUBLEFACE:int = 8;
		/** 定义深度只读、透明加色混合。*/
		public static const DEPTHREAD_ALPHA_ADDTIVE_BLEND:int = 9;
		/** 定义深度只读、透明加色混合、双面渲染队列标记。*/
		public static const DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE:int = 10;
		
		/** 定义无深度测试、透明混合渲染队列标记。*/
		public static const NONDEPTH_ALPHA_BLEND:int = 11;
		/** 定义无深度测试、透明混合、双面渲染队列标记。*/
		public static const NONDEPTH_ALPHA_BLEND_DOUBLEFACE:int = 12;
		/** 定义无深度测试、透明加色混合。*/
		public static const NONDEPTH_ALPHA_ADDTIVE_BLEND:int = 13;
		/** 定义无深度测试、透明加色混合、双面渲染队列标记。*/
		public static const NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE:int = 14;
		
		/** @private */
		private var _id:int;
		/** @private */
		private var _needSort:Boolean;
		/** @private */
		private var _renderElements:Array;
		/** @private */
		private var _staticBatches:Array;
		/** @private */
		private var _renderableRenderObjects:Array;
		/** @private */
		private var _renderConfig:RenderConfig;
		/** @private */
		private var _staticBatchCombineRenderElements:Array;
		/** @private */
		private var _dynamicBatchCombineRenderElements:Array;
		/** @private */
		private var _finalElements:Array;
		/** @private */
		private var _scene:BaseScene;
		
		/**
		 * 获取唯一标识ID(通常用于优化或识别)。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 创建一个 <code>RenderQuene</code> 实例。
		 * @param renderConfig 渲染配置。
		 */
		public function RenderQueue(renderConfig:RenderConfig, scene:BaseScene) {
			_id = ++_uniqueIDCounter;
			_needSort = false;
			_renderConfig = renderConfig;
			_scene = scene;
			_renderElements = [];
			_renderableRenderObjects = [];
			
			_staticBatchCombineRenderElements = [];
			_dynamicBatchCombineRenderElements = [];
			_staticBatches = [];
		}
		
		/**
		 * @private
		 * 更新组件preRenderUpdate函数
		 * @param	state 渲染相关状态
		 */
		protected function _preRenderUpdateComponents(sprite3D:Sprite3D, state:RenderState):void {
			for (var i:int = 0; i < sprite3D.componentsCount; i++) {
				var component:Component3D = sprite3D.getComponentByIndex(i);
				(!component.started) && (component._start(state), component.started = true);
				(component.isActive) && (component._preRenderUpdate(state));
			}
		}
		
		/**
		 * @private
		 * 更新组件postRenderUpdate函数
		 * @param	state 渲染相关状态
		 */
		protected function _postRenderUpdateComponents(sprite3D:Sprite3D, state:RenderState):void {
			for (var i:int = 0; i < sprite3D.componentsCount; i++) {
				var component:Component3D = sprite3D.getComponentByIndex(i);
				(!component.started) && (component._start(state), component.started = true);
				(component.isActive) && (component._postRenderUpdate(state));
			}
		}
		
		/**
		 * @private
		 * 应用渲染状态到显卡。
		 * @param gl WebGL上下文。
		 */
		public function _setState(gl:WebGLContext):void {
			WebGLContext.setDepthTest(gl, _renderConfig.depthTest);
			WebGLContext.setDepthMask(gl, _renderConfig.depthMask);
			
			WebGLContext.setBlend(gl, _renderConfig.blend);
			WebGLContext.setBlendFunc(gl, _renderConfig.sFactor, _renderConfig.dFactor);
			WebGLContext.setCullFace(gl, _renderConfig.cullFace);
			WebGLContext.setFrontFaceCCW(gl, _renderConfig.frontFace);
		}
		
		/**
		 * @private
		 * 准备渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _preRender(state:RenderState):void {
			_staticBatchCombineRenderElements.length = 0;
			for (var i:int = 0, n:int = _staticBatches.length; i < n; i++)
				_staticBatches[i]._getRenderElement(_staticBatchCombineRenderElements);
			
			_finalElements = _renderElements.concat(_staticBatchCombineRenderElements, _dynamicBatchCombineRenderElements);
			//_needSort && (_finalElements.sort(_sort)，_needSort=false);//排序函数如果改变，仍需重新排列。//TODO:不排序面变多
		}
		
		/**
		 * @private
		 * 渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState):void {
			var preShaderValue:int = state.shaderValue.length;
			var renderElement:RenderElement;
			for (var i:int = 0, n:int = _finalElements.length; i < n; i++) {
				renderElement = _finalElements[i];
				var preShadeDef:int;
				if (renderElement._type === 0) {
					var owner:Sprite3D = renderElement._sprite3D;
					state.owner = owner;
					state.renderElement = renderElement;
					preShadeDef = state.shaderDefs.getValue();
					_preRenderUpdateComponents(owner, state);
					renderElement.renderObj._render(state);
					_postRenderUpdateComponents(owner, state);
					state.shaderDefs.setValue(preShadeDef);
				} else if (renderElement._type === 1) {
					var staticBatch:StaticBatch = renderElement.renderObj as StaticBatch;
					state.owner = null;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._batchIndexStart;
					state._batchIndexEnd = renderElement._batchIndexEnd;
					preShadeDef = state.shaderDefs.getValue();
					renderElement.renderObj._render(state);
					state.shaderDefs.setValue(preShadeDef);
				} else if (renderElement._type === 2) {
					var dynamicBatch:DynamicBatch = renderElement.renderObj as DynamicBatch;
					state.owner = null;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._batchIndexStart;
					state._batchIndexEnd = renderElement._batchIndexEnd;
					preShadeDef = state.shaderDefs.getValue();
					renderElement.renderObj._render(state);
					state.shaderDefs.setValue(preShadeDef);
				}
				
				state.shaderValue.length = preShaderValue;
			}
		}
		
		/**
		 * 清空队列中的渲染物体。
		 */
		public function _clearRenderElements():void {
			_staticBatches.length = 0;
			_dynamicBatchCombineRenderElements.length = 0;
			_renderElements.length = 0;
			_needSort = true;
		}
		
		/**
		 * 添加渲染物体。
		 * @param renderObj 渲染物体。
		 */
		public function _addRenderElement(renderElement:RenderElement):void {
			_renderElements.push(renderElement);
			_needSort = true;
		}
		
		/**
		 * 添加静态批处理。
		 * @param renderObj 静态批处理。
		 */
		public function _addStaticBatch(staticBatch:StaticBatch):void {
			_staticBatches.push(staticBatch)
		}
		
		/**
		 * 添加动态批处理。
		 * @param renderObj 动态批处理。
		 */
		public function _addDynamicBatchElement(dynamicBatchElement:RenderElement):void {
			_dynamicBatchCombineRenderElements.push(dynamicBatchElement);
		}
	}
}