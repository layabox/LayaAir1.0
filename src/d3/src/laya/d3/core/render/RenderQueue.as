package laya.d3.core.render {
	import laya.d3.component.Component3D;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Vector3;
	import laya.d3.shader.Shader3D;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.BaseShader;
	
	/**
	 * @private
	 * <code>RenderQuene</code> 类用于实现渲染队列。
	 */
	public class RenderQueue {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0;
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
				return true;
			}
			return false;
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
			var preShadeDef:int = state.shaderDefines.getValue();
			var loopCount:int = Stat.loopCount;
			var scene:BaseScene = _scene;
			var camera:BaseCamera = state.camera;
			var cameraID:int = camera.id;
			var vertexBuffer:VertexBuffer3D, vertexDeclaration:VertexDeclaration, lastBindShader:BaseShader, shader:Shader3D;
			var needForceUpdate:Boolean, isNewCamera:Boolean;
			
			for (var i:int = 0, n:int = _finalElements.length; i < n; i++) {
				var renderElement:RenderElement = _finalElements[i];
				var renderObj:IRenderable, material:BaseMaterial,owner:Sprite3D;
				if (renderElement._type === 0) {
					state.owner = owner = renderElement._sprite3D;
					state.renderElement = renderElement;
					_preRenderUpdateComponents(owner, state);
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						vertexBuffer = renderObj._getVertexBuffer(0);
						vertexDeclaration = vertexBuffer.vertexDeclaration;
						lastBindShader = BaseShader.bindShader;
						material._setMaterialShaderDefineParams(owner,state.shaderDefines);
						shader = material._getShader(state.shaderDefines, vertexDeclaration.shaderDefineValue);
						shader.bind();
						needForceUpdate = (loopCount !== shader._uploadLoopCount) || (shader !== lastBindShader);
						isNewCamera = cameraID !== shader._uploadCameraID;
						
						if (shader._uploadVertexBuffer !== vertexBuffer || needForceUpdate) {
							shader.uploadAttributes(vertexDeclaration.shaderValues.data, null);
							shader._uploadVertexBuffer = vertexBuffer;
						}
						
						if (shader._uploadScene !== scene || needForceUpdate) {       
							shader.uploadSceneUniforms(scene._shaderValues.data);
							shader._uploadScene = scene;
						}
						
						if (shader._uploadCamera !== camera || needForceUpdate) {
							shader.uploadCameraUniforms(camera._shaderValues.data);
							shader._uploadCamera = camera;
						}
						
						if (shader._uploadSprite3D !== owner || needForceUpdate) {
							shader.uploadSpriteUniforms(owner._shaderValues.data);
							shader._uploadSprite3D = owner;
						}
						
						if (shader._uploadMaterial !== material || needForceUpdate) {
							material._setMaterialShaderParams(state, state.projectionViewMatrix, owner.transform.worldMatrix, renderElement.renderObj, material);//TODO:或许可以取消
							material._upload();
							shader._uploadMaterial = material;
						}
						
						if (shader._uploadRenderElement !== renderElement || needForceUpdate) {
							shader.uploadRenderElementUniforms(renderElement._shaderValue.data);
							shader._uploadRenderElement = renderElement;
						}
						
						renderObj._render(state);
						shader._uploadLoopCount = loopCount;
						shader._uploadCameraID = cameraID;
					}
					_postRenderUpdateComponents(owner, state);
				} else if (renderElement._type === 1) {//TODO:合并后组件渲染问题
					var staticBatch:StaticBatch = renderElement.renderObj as StaticBatch;
					state.owner = owner;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._batchIndexStart;
					state._batchIndexEnd = renderElement._batchIndexEnd;
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						vertexBuffer = renderObj._getVertexBuffer(0);
						vertexDeclaration = vertexBuffer.vertexDeclaration;
						lastBindShader = BaseShader.bindShader;
						material._setMaterialShaderDefineParams(owner,state.shaderDefines);
						shader = material._getShader(state.shaderDefines, vertexDeclaration.shaderDefineValue);
						shader.bind();
						needForceUpdate = (loopCount !== shader._uploadLoopCount) || (shader !== lastBindShader);
						isNewCamera = cameraID !== shader._uploadCameraID;
						
						if (shader._uploadVertexBuffer !== vertexBuffer || needForceUpdate) {
							shader.uploadAttributes(vertexDeclaration.shaderValues.data, null);
							shader._uploadVertexBuffer = vertexBuffer;
						}
						
						if (shader._uploadScene !== scene || needForceUpdate) {
							shader.uploadSceneUniforms(scene._shaderValues.data);
							shader._uploadScene = scene;
						}
						
						if (shader._uploadCamera !== camera || needForceUpdate) {
							shader.uploadCameraUniforms(camera._shaderValues.data);
							shader._uploadCamera = camera;
						}
						
						owner = staticBatch._rootSprite;
						if (shader._uploadSprite3D !== owner || needForceUpdate) {
							shader.uploadSpriteUniforms(owner._shaderValues.data);
							shader._uploadSprite3D = owner;
						}
						
						if (shader._uploadMaterial !== material || needForceUpdate) {
							material._setMaterialShaderParams(state, state.projectionViewMatrix, owner.transform.worldMatrix, renderElement.renderObj, material);//TODO:或许可以取消
							material._upload();
							shader._uploadMaterial = material;
						}
						
						if (shader._uploadRenderElement !== renderElement || needForceUpdate) {
							shader.uploadRenderElementUniforms(renderElement._shaderValue.data);
							shader._uploadRenderElement = renderElement;
						}
						
						renderObj._render(state);
						shader._uploadLoopCount = loopCount;
						shader._uploadCameraID = cameraID;
					}
				} else if (renderElement._type === 2) {//TODO:合并后组件渲染问题
					var dynamicBatch:DynamicBatch = renderElement.renderObj as DynamicBatch;
					state.owner = owner = renderElement._sprite3D;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._batchIndexStart;
					state._batchIndexEnd = renderElement._batchIndexEnd;
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						vertexBuffer = renderObj._getVertexBuffer(0);
						vertexDeclaration = vertexBuffer.vertexDeclaration;
						lastBindShader = BaseShader.bindShader;
						material._setMaterialShaderDefineParams(owner,state.shaderDefines);
						shader = material._getShader(state.shaderDefines, vertexDeclaration.shaderDefineValue);
						shader.bind();
						needForceUpdate = (loopCount !== shader._uploadLoopCount) || (shader !== lastBindShader);
						isNewCamera = cameraID !== shader._uploadCameraID;
						
						if (shader._uploadVertexBuffer !== vertexBuffer || needForceUpdate) {
							shader.uploadAttributes(vertexDeclaration.shaderValues.data, null);
							shader._uploadVertexBuffer = vertexBuffer;
						}
						
						if (shader._uploadScene !== scene || needForceUpdate) {
							shader.uploadSceneUniforms(scene._shaderValues.data);
							shader._uploadScene = scene;
						}
						
						if (shader._uploadCamera !== camera || needForceUpdate) {
							shader.uploadCameraUniforms(camera._shaderValues.data);
							shader._uploadCamera = camera;
						}
						
						if (shader._uploadSprite3D !== owner || needForceUpdate) {
							shader.uploadSpriteUniforms(owner._shaderValues.data);
							shader._uploadSprite3D = owner;
						}
						
						if (shader._uploadMaterial !== material || needForceUpdate) {
							material._setMaterialShaderParams(state, state.projectionViewMatrix, owner.transform.worldMatrix, renderElement.renderObj, material);//TODO:或许可以取消
							material._upload();
							shader._uploadMaterial = material;
						}
						
						if (shader._uploadRenderElement !== renderElement || needForceUpdate) {
							shader.uploadRenderElementUniforms(renderElement._shaderValue.data);
							shader._uploadRenderElement = renderElement;
						}
						
						renderObj._render(state);
						shader._uploadLoopCount = loopCount;
						shader._uploadCameraID = cameraID;
					}
				}
				state.shaderDefines.setValue(preShadeDef);
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