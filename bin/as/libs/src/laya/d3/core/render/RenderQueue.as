package laya.d3.core.render {
	import laya.d3.component.Component3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderQuene</code> 类用于实现渲染队列。
	 */
	public class RenderQueue {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0/*int.MIN_VALUE*/;
		/** 定义只读渲染队列标记。*/
		public static const NONEWRITEDEPTH:int = 0;
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
		
		/**
		 *@private
		 */
		private static function _sortPrepareStaticBatch(a:RenderElement, b:RenderElement):* {
			var id:int = a.mainSortID - b.mainSortID;
			return (id === 0) ? a.triangleCount - b.triangleCount : id;
		}
		
		/** @private */
		private var _id:int;
		/** @private */
		private var _changed:Boolean;
		/** @private */
		private var _needSort:Boolean;
		/** @private */
		private var _renderElements:Array;
		/** @private */
		private var _renderableRenderObjects:Array;
		/** @private */
		private var _renderConfig:RenderConfig;
		/** @private */
		private var _staticBatchManager:StaticBatchManager;//TODO:释放问题。
		
		/** @private */
		private var _prepareStaticBatchCombineElements:Array;
		/** @private */
		private var _staticBatchCombineRenderElements:Array;
		/** @private */
		private var _finalElements:Array;
		
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
		public function RenderQueue(renderConfig:RenderConfig) {
			_id = ++_uniqueIDCounter;
			_changed = false;
			_needSort = false;
			_renderConfig = renderConfig;
			_renderElements = [];
			_renderableRenderObjects = [];
			_staticBatchManager = new StaticBatchManager(this);
			
			_prepareStaticBatchCombineElements = [];
			_staticBatchCombineRenderElements = [];
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
			if (_changed) {
				_changed = false;
				_staticBatchCombineRenderElements.length = 0;
				_staticBatchManager._getRenderElements(_staticBatchCombineRenderElements);
				_finalElements = _renderElements.concat(_staticBatchCombineRenderElements);
				//_needSort && (_finalElements.sort(_sort)，_needSort=false);//排序函数如果改变，仍需重新排列。//TODO:不排序面变多
			}
		}
		
		/**
		 * @private
		 * 渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState):void {
			var preShaderValue:int = state.shaderValue.length;
			var renElement:RenderElement;
			for (var i:int = 0, n:int = _finalElements.length; i < n; i++) {
				renElement = _finalElements[i];
				var preShadeDef:int;
				if (renElement.type === 0) {
					var owner:Sprite3D = renElement.sprite3D;
					state.owner = owner;
					state.renderObj = renElement;
					preShadeDef = state.shaderDefs.getValue();
					_preRenderUpdateComponents(owner, state);
					renElement.element._render(state);
					_postRenderUpdateComponents(owner, state);
					state.shaderDefs.setValue(preShadeDef);
				} else if (renElement.type === 1) {
					var staticBatch:StaticBatch = renElement.element as StaticBatch;
					staticBatch._indexStart = renElement.staticBatchIndexStart;
					staticBatch._indexEnd = renElement.staticBatchIndexEnd;
					state.owner = null;
					state.renderObj = renElement;
					preShadeDef = state.shaderDefs.getValue();
					(renElement.element._render(state));
					state.shaderDefs.setValue(preShadeDef);
				}
				
				state.shaderValue.length = preShaderValue;
			}
		}
		
		/**
		 * 添加渲染物体。
		 * @param renderObj 渲染物体。
		 */
		public function _addRenderElement(renderElement:RenderElement):void {
			if (renderElement.staticBatch && (renderElement.staticBatch === _staticBatchManager.getStaticBatchQneue(renderElement.element.getVertexBuffer().vertexDeclaration, renderElement.material))) {
				renderElement.staticBatch._addRenderElement(renderElement);
			} else {
				_renderElements.push(renderElement);
				renderElement.ownerRenderQneue = this;
			}
			
			_changed = true;
			_needSort = true;
		}
		
		/**
		 * 删除渲染物体。
		 * @param renderObj 渲染物体。
		 */
		public function _deleteRenderElement(renderElement:RenderElement):void {
			if (renderElement.staticBatch && renderElement.isInStaticBatch) {
				renderElement.staticBatch._deleteRenderElement(renderElement);
			} else {
				var index:int = _renderElements.indexOf(renderElement);
				if (index !== -1) {
					_renderElements.splice(index, 1);
					renderElement.ownerRenderQneue = null;
				}
			}
			
			_changed = true;
		}
		
		/**
		 * 清空队列中的渲染物体。
		 */
		public function _clearRenderElements():void {
			for (var i:int = 0, n:int = _renderElements.length; i < n; i++)
				_renderElements[i].ownerRenderQneue = null;
			_renderElements.length = 0;
			
			_staticBatchManager._clearRenderElements();
		}
		
		/** @private */
		public function _addPrepareRenderElementToStaticBatch(renderElement:RenderElement):void {
			_prepareStaticBatchCombineElements.push(renderElement);
		}
		
		/** @private */
		public function _finishCombineStaticBatch():void {
			_prepareStaticBatchCombineElements.sort(_sortPrepareStaticBatch);//排序函数如果改变，仍需重新排列。//TODO:不排序面变多,造成一个staticBatch调用多次
			
			var lastMaterial:Material;
			var lastVertexDeclaration:VertexDeclaration;
			var lastCanMerage:Boolean;
			var curStaticBatch:StaticBatch;
			
			var renderObj:RenderElement;
			var renderElement:IRenderable;
			var lastRenderObj:RenderElement;
			var vb:VertexBuffer3D;
			
			for (var i:int = 0, n:int = _prepareStaticBatchCombineElements.length; i < n; i++) {
				renderObj = _prepareStaticBatchCombineElements[i];
				renderElement = renderObj.element;
				
				vb = renderElement.getVertexBuffer(0);
				if ((lastMaterial === renderObj.material) && (lastVertexDeclaration === vb.vertexDeclaration) && (renderElement.VertexBufferCount === 1)) {
					if (!lastCanMerage) {
						curStaticBatch = _staticBatchManager.getStaticBatchQneue(lastVertexDeclaration, lastMaterial);//TODO:一个材质满了之后没有new第二个批处理。
						
						lastRenderObj = _prepareStaticBatchCombineElements[i - 1];
						
						if (!curStaticBatch._addCombineRenderObjTest(lastRenderObj) || !curStaticBatch._addCombineRenderObjTest(renderObj)) {
							lastCanMerage = false;
						} else {
							curStaticBatch._addCombineRenderObj(lastRenderObj);
							curStaticBatch._addCombineRenderObj(renderObj);
							lastCanMerage = true;
						}
					} else {
						if (!curStaticBatch._addCombineRenderObjTest(renderObj))
							lastCanMerage = false;
						else
							curStaticBatch._addCombineRenderObj(renderObj)
					}
				} else {
					lastCanMerage = false;
				}
				lastMaterial = renderObj.material;
				lastVertexDeclaration = vb.vertexDeclaration;
			}
			_staticBatchManager._garbageCollection();
			_staticBatchManager._finshCombine();
			_prepareStaticBatchCombineElements.length = 0;
		}
	
	}
}