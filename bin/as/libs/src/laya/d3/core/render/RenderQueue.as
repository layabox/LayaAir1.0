package laya.d3.core.render {
	import laya.d3.component.Component3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
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
		private static function _sort(a:RenderObject, b:RenderObject):* {
			var id:int = a.mainSortID - b.mainSortID;
			return (a.owner.isStatic && b.owner.isStatic && id === 0) ? a.triangleCount - b.triangleCount : id;
		}
		
		/** @private */
		private var _id:int;
		/** @private */
		private var _changed:Boolean;
		/** @private */
		private var _needSort:Boolean;
		/** @private */
		private var _renderObjects:Array;
		/** @private */
		private var _staticRenderObjects:Array;
		/** @private */
		private var _staticLength:int;
		/** @private */
		private var _mergeRenderObjects:Array;
		/** @private */
		private var _merageLength:int;
		/** @private */
		private var _renderConfig:RenderConfig;
		/** @private */
		private var _staticBatchManager:StaticBatchManager;//TODO:释放问题。
		
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
			_renderObjects = [];
			_staticRenderObjects = [];
			_staticLength = 0;
			_mergeRenderObjects = [];
			_merageLength = 0;
			_staticBatchManager = new StaticBatchManager();
		}
		
		private function _getStaticRenderObj():RenderObject {
			var o:RenderObject = _staticRenderObjects[_staticLength++];
			return o || (_staticRenderObjects[_staticLength - 1] = new RenderObject());
		}
		
		/**
		 * 重置并清空队列。
		 */
		private function _reset():void {
			_staticLength = 0;
			_merageLength = 0;
			_staticBatchManager._reset();
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
				
				_reset();
				_needSort && (_renderObjects.sort(_sort));//排序函数如果改变，仍需重新排列。
				var lastIsStatic:Boolean = false;
				var lastMaterial:Material;
				var lastVertexDeclaration:VertexDeclaration;
				var lastCanMerage:Boolean;
				var curStaticBatch:StaticBatch;
				
				var currentRenderObjIndex:int = 0;
				var renderObj:RenderObject;
				var renderElement:IRenderable;
				var isStatic:Boolean;
				var lastRenderObj:RenderObject;
				var batchObject:RenderObject;
				var vb:VertexBuffer3D;
				
				for (var i:int = 0, n:int = _renderObjects.length; i < n; i++) {
					renderObj = _renderObjects[i];
					renderElement = renderObj.renderElement;
					isStatic = renderObj.owner.isStatic;
					//isStatic = false;
					
					vb = renderElement.getVertexBuffer(0);
					if ((lastMaterial === renderObj.material) && (lastVertexDeclaration === vb.vertexDeclaration) && lastIsStatic && isStatic && (renderElement.VertexBufferCount === 1) && renderObj.owner.visible) {
						if (!lastCanMerage) {
							curStaticBatch = _staticBatchManager.getStaticBatchQneue(lastVertexDeclaration, lastMaterial);
							
							lastRenderObj = _renderObjects[i - 1];
							
							if (!curStaticBatch.addRenderObj(lastRenderObj) || !curStaticBatch.addRenderObj(renderObj)) {
								_mergeRenderObjects[_merageLength++] = _renderObjects[currentRenderObjIndex];
								lastCanMerage = false;
							} else {
								batchObject = _getStaticRenderObj();
								batchObject.renderElement = curStaticBatch;
								batchObject.type = 1;
								
								_mergeRenderObjects[_merageLength - 1] = batchObject;
								lastCanMerage = true;
							}
						} else {
							if (!curStaticBatch.addRenderObj(renderObj)) {
								_mergeRenderObjects[_merageLength++] = _renderObjects[currentRenderObjIndex];
								lastCanMerage = false;
							}
						}
					} else {
						_mergeRenderObjects[_merageLength++] = _renderObjects[currentRenderObjIndex];
						lastCanMerage = false;
					}
					currentRenderObjIndex++;
					lastIsStatic = isStatic;
					lastMaterial = renderObj.material;
					lastVertexDeclaration = vb.vertexDeclaration;
				}
				
				_staticBatchManager._garbageCollection();
				
				_staticBatchManager._finsh();
			}
		}
		
		/**
		 * @private
		 * 渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState):void {
			var preShaderValue:int = state.shaderValue.length;
			var renObj:RenderObject;
			for (var i:int = 0, n:int = _merageLength; i < n; i++) {
				renObj = _mergeRenderObjects[i];
				var preShadeDef:int;
				if (renObj.type === 0) {
					var owner:Sprite3D = renObj.owner;
					state.owner = owner;
					state.renderObj = renObj;
					preShadeDef = state.shaderDefs.getValue();
					_preRenderUpdateComponents(owner, state);
					(owner.visible) && (renObj.renderElement._render(state));
					_postRenderUpdateComponents(owner, state);
					state.shaderDefs.setValue(preShadeDef);
				} else if (renObj.type === 1) {
					state.owner = null;
					state.renderObj = renObj;
					preShadeDef = state.shaderDefs.getValue();
					(renObj.renderElement._render(state));
					state.shaderDefs.setValue(preShadeDef);
				}
				
				state.shaderValue.length = preShaderValue;
			}
		}
		
		/**
		 * 获取队列中的渲染物体。
		 * @return gl 渲染物体。
		 */
		public function getRenderObj():RenderObject {
			_changed = true;
			_needSort = true;
			var o:RenderObject = new RenderObject();
			_renderObjects.push(o);
			o.renderQneue = this;
			return o;
		}
		
		/**
		 * 删除渲染物体。
		 * @param renderObj 渲染物体。
		 */
		public function deleteRenderObj(renderObj:RenderObject):void {
			_changed = true;
			var index:int = _renderObjects.indexOf(renderObj);
			if (index !== -1) {
				_renderObjects.splice(index, 1);
				renderObj.renderQneue = null;
			}
		}
	
	}
}