package laya.d3.core.render {
	import laya.d3.component.Component3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>RenderQuene</code> 类用于实现渲染队列。
	 */
	public class RenderQueue {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0/*int.MIN_VALUE*/;
		/** 定义非透明渲染队列标记。*/
		public static const OPAQUE:int = 1;//TODO:从零开始
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
		private static var _cameraPosition:Vector3;
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
		
		private function _sortAlphaFunc(a:RenderElement, b:RenderElement):Number {
			if (a._renderObject && b._renderObject)//TODO:临时
				return Vector3.distance(b._renderObject._boundingSphere.center, _cameraPosition) - Vector3.distance(a._renderObject._boundingSphere.center, _cameraPosition);
			else
				return 0;
		}
		
		/**
		 * @private
		 */
		private function _begainRenderElement(state:RenderState, renderObj:IRenderable, material:BaseMaterial):Boolean {
			if (renderObj._beforeRender(state)) {
				state.shaderValue.pushArray(renderObj._getVertexBuffer(0).vertexDeclaration.shaderValues);
				return true;
			}
			return false;
		}
		
		/**
		 * @private
		 */
		private function _endRenderElement(state:RenderState, renderObj:IRenderable, material:BaseMaterial):void {
			material._upload(state, renderObj._getVertexBuffer(0).vertexDeclaration, null);
			renderObj._render(state);
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
		
		///**
		//* @private
		//*/
		//public  function _sortAlpha(/*list:Vector.<RenderElement>, */cameraPosition:Vector3):void {
		//var list:Array = _finalElements;
		//for (var pass:int = 1; pass < list.length; pass++)
		//for (var i:int = 0; i < list.length - 1; i++) {
		//var objectDistance1:Number = Vector3.distance(list[i]._renderCullingObject._boundingSphere.center, cameraPosition);
		//var objectDistance2:Number = Vector3.distance(list[i + 1]._renderCullingObject._boundingSphere.center, cameraPosition);
		//if (objectDistance1 < objectDistance2) {
		//var temp:RenderElement = list[i];// Swap
		//list[i] = list[i + 1];
		//list[i + 1] = temp;
		//}
		//}
		//}
		
		/**
		 * @private
		 */
		public function _sortAlpha(cameraPos:Vector3):void {
			_cameraPosition = cameraPos;
			_finalElements.sort(_sortAlphaFunc);
		}
		
		/**
		 * @private
		 * 应用渲染状态到显卡。
		 * @param gl WebGL上下文。
		 */
		public function _setState(gl:WebGLContext, state:RenderState):void {
			WebGLContext.setDepthTest(gl, _renderConfig.depthTest);
			WebGLContext.setDepthMask(gl, _renderConfig.depthMask);
			
			WebGLContext.setBlend(gl, _renderConfig.blend);
			WebGLContext.setBlendFunc(gl, _renderConfig.sFactor, _renderConfig.dFactor);
			WebGLContext.setCullFace(gl, _renderConfig.cullFace);
			
			if (state.camera.renderTarget)
				WebGLContext.setFrontFaceCCW(gl, _renderConfig.frontFace === WebGLContext.CW ? WebGLContext.CCW : WebGLContext.CW);
			else
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
			var preShadeDef:int = state.shaderDefs.getValue();
			for (var i:int = 0, n:int = _finalElements.length; i < n; i++) {
				var renderElement:RenderElement = _finalElements[i];
				var renderObj:IRenderable, material:BaseMaterial;
				if (renderElement._type === 0) {
					var owner:Sprite3D = renderElement._sprite3D;
					state.owner = owner;
					state.renderElement = renderElement;
					_preRenderUpdateComponents(owner, state);
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						material._setLoopShaderParams(state, state.projectionViewMatrix, owner.transform.worldMatrix, renderElement.renderObj, material);
						_endRenderElement(state, renderObj, material);
					}
					_postRenderUpdateComponents(owner, state);
				} else if (renderElement._type === 1) {//TODO:合并后组件渲染问题
					var staticBatch:StaticBatch = renderElement.renderObj as StaticBatch;
					state.owner = null;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._batchIndexStart;
					state._batchIndexEnd = renderElement._batchIndexEnd;
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						renderElement._material._setLoopShaderParams(state, state.projectionViewMatrix, staticBatch._rootSprite.transform.worldMatrix, renderElement.renderObj, renderElement._material);
						_endRenderElement(state, renderObj, material);
					}
				} else if (renderElement._type === 2) {//TODO:合并后组件渲染问题
					var dynamicBatch:DynamicBatch = renderElement.renderObj as DynamicBatch;
					state.owner = null;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._batchIndexStart;
					state._batchIndexEnd = renderElement._batchIndexEnd;
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						renderElement._material._setLoopShaderParams(state, state.projectionViewMatrix, Matrix4x4.DEFAULT, renderElement.renderObj, renderElement._material);
						_endRenderElement(state, renderObj, material);
					}
				}
				state.shaderDefs.setValue(preShadeDef);
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