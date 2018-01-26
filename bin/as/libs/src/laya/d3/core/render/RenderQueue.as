package laya.d3.core.render {
	import laya.d3.component.Component3D;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Vector3;
	import laya.d3.shader.Shader3D;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * <code>RenderQuene</code> 类用于实现渲染队列。
	 */
	public class RenderQueue {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0;
		/** 定义非透明渲染队列标记。*/
		public static const OPAQUE:int = 1;//TODO:从零开始
		/** 透明混合渲染队列标记。*/
		public static const TRANSPARENT:int = 2;
		
		/** @private */
		private static var _cameraPosition:Vector3;
		/** @private */
		private var _id:int;
		/** @private */
		private var _needSort:Boolean;
		/** @private */
		public var _renderElements:Array;
		/** @private */
		private var _renderableRenderObjects:Array;
		/** @private */
		private var _dynamicBatchCombineRenderElements:Array;
		/** @private */
		private var _finalElements:Array;
		/** @private */
		private var _scene:Scene;
		
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
		public function RenderQueue(scene:Scene) {
			_id = ++_uniqueIDCounter;
			_needSort = false;
			_scene = scene;
			_renderElements = [];
			_renderableRenderObjects = [];
			
			_dynamicBatchCombineRenderElements = [];
		}
		
		private function _sortOpaqueFunc(a:RenderElement, b:RenderElement):Number {
			if (a._render && b._render)//TODO:临时
				return a._render._distanceForSort - b._render._distanceForSort;
			else
				return 0;
		}
		
		private function _sortAlphaFunc(a:RenderElement, b:RenderElement):Number {
			if (a._render && b._render)//TODO:临时
				return b._render._distanceForSort - a._render._distanceForSort;
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
		 */
		public function _sortOpaque(cameraPos:Vector3):void {
			_cameraPosition = cameraPos;
			_finalElements.sort(_sortOpaqueFunc);
		}
		
		/**
		 * @private
		 * 准备渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _preRender(state:RenderState):void {
			_finalElements = _renderElements.concat(_dynamicBatchCombineRenderElements);
			//_needSort && (_finalElements.sort(_sort)，_needSort=false);//排序函数如果改变，仍需重新排列。//TODO:不排序面变多
		}
		
		/**
		 * @private
		 * 渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState, isTarget:Boolean):void {
			var loopCount:int = Stat.loopCount;
			var scene:Scene = _scene;
			var camera:BaseCamera = state.camera;
			var cameraID:int = camera.id;
			var vbs:Vector.<VertexBuffer3D>;
			var vertexBuffer:VertexBuffer3D, vertexDeclaration:VertexDeclaration, shader:Shader3D;
			var forceUploadParams:Boolean;
			var lastStateMaterial:BaseMaterial, lastStateOwner:Sprite3D;
			for (var i:int = 0, n:int = _finalElements.length; i < n; i++) {
				var renderElement:RenderElement = _finalElements[i];
				var renderObj:IRenderable, material:BaseMaterial, owner:Sprite3D;
				if (renderElement._onPreRenderFunction != null) {//TODO:
					renderElement._onPreRenderFunction.call(renderElement._sprite3D, state);
				}
				
				if (renderElement._type === 0) {
					state.owner = owner = renderElement._sprite3D;
					state.renderElement = renderElement;
					owner._preRenderUpdateComponents(state);//TODO:静态合并组件问题。
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						vbs = renderObj._getVertexBuffers();
						vertexBuffer = renderObj._getVertexBuffer(0);
						vertexDeclaration = vertexBuffer.vertexDeclaration;
						shader = state._shader = material._getShader(scene._shaderDefineValue, vertexDeclaration.shaderDefineValue, owner._shaderDefineValue);//TODO:需要合并vertexDeclaration
						forceUploadParams = shader.bind() || (loopCount !== shader._uploadLoopCount);
						if (vbs) {
							if (shader._uploadVertexBuffer !== vbs || forceUploadParams) {
								for (var j:int = 0; j < vbs.length; j++ ){
									var vb:VertexBuffer3D = vbs[j];
									shader.uploadAttributesX(vb.vertexDeclaration.shaderValues.data, vb);
								}
								shader._uploadVertexBuffer = vbs;
							}
						} else {
							if (shader._uploadVertexBuffer !== vertexBuffer || forceUploadParams) {
								shader.uploadAttributes(vertexDeclaration.shaderValues.data, null);
								shader._uploadVertexBuffer = vertexBuffer;
							}
						}
						
						if (shader._uploadScene !== scene || forceUploadParams) {
							shader.uploadSceneUniforms(scene._shaderValues.data);
							shader._uploadScene = scene;
						}
						
						if (camera !== shader._uploadCamera || shader._uploadSprite3D !== owner || forceUploadParams) {
							shader.uploadSpriteUniforms(owner._shaderValues.data);
							shader._uploadSprite3D = owner;
						}
						
						if (camera !== shader._uploadCamera || forceUploadParams) {
							shader.uploadCameraUniforms(camera._shaderValues.data);
							shader._uploadCamera = camera;
						}
						
						if (shader._uploadMaterial !== material || forceUploadParams) {
							material._upload();
							shader._uploadMaterial = material;
						}
						
						if (lastStateMaterial !== material) {//lastStateMaterial,lastStateOwner存到全局，多摄像机还可优化
							material._setRenderStateBlendDepth();
							material._setRenderStateFrontFace(isTarget, owner.transform);
							lastStateMaterial = material;
							lastStateOwner = owner;
						} else {
							if (lastStateOwner !== owner) {
								material._setRenderStateFrontFace(isTarget, owner.transform);
								lastStateOwner = owner;
							}
						}
						
						renderObj._render(state);
						shader._uploadLoopCount = loopCount;
						
					}
					owner._postRenderUpdateComponents(state);//TODO:静态合并组件问题。
					
				} else if (renderElement._type === 2) {//TODO:合并后组件渲染问题
					var dynamicBatch:DynamicBatch = renderElement.renderObj as DynamicBatch;
					state.owner = owner = renderElement._sprite3D;
					state.renderElement = renderElement;
					state._batchIndexStart = renderElement._tempBatchIndexStart;
					state._batchIndexEnd = renderElement._tempBatchIndexEnd;
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, material)) {
						vertexBuffer = renderObj._getVertexBuffer(0);
						vertexDeclaration = vertexBuffer.vertexDeclaration;
						shader = state._shader = material._getShader(scene._shaderDefineValue, vertexDeclaration.shaderDefineValue, owner._shaderDefineValue);
						forceUploadParams = shader.bind() || (loopCount !== shader._uploadLoopCount);
						
						if (shader._uploadVertexBuffer !== vertexBuffer || forceUploadParams) {
							shader.uploadAttributes(vertexDeclaration.shaderValues.data, null);
							shader._uploadVertexBuffer = vertexBuffer;
						}
						
						if (shader._uploadScene !== scene || forceUploadParams) {
							shader.uploadSceneUniforms(scene._shaderValues.data);
							shader._uploadScene = scene;
						}
						
						if (camera !== shader._uploadCamera || shader._uploadSprite3D !== owner || forceUploadParams) {
							shader.uploadSpriteUniforms(owner._shaderValues.data);
							shader._uploadSprite3D = owner;
						}
						
						if (camera !== shader._uploadCamera || forceUploadParams) {
							shader.uploadCameraUniforms(camera._shaderValues.data);
							shader._uploadCamera = camera;
						}
						
						if (shader._uploadMaterial !== material || forceUploadParams) {
							material._upload();
							shader._uploadMaterial = material;
						}
						
						if (lastStateMaterial !== material) {//lastStateMaterial,lastStateOwner存到全局，多摄像机还可优化
							material._setRenderStateBlendDepth();
							material._setRenderStateFrontFace(isTarget, owner.transform);
							lastStateMaterial = material;
							lastStateOwner = owner;
						} else {
							if (lastStateOwner !== owner) {
								material._setRenderStateFrontFace(isTarget, owner.transform);
								lastStateOwner = owner;
							}
						}
						
						renderObj._render(state);
						shader._uploadLoopCount = loopCount;
						
					}
				}
			}
		}
		
		/**
		 * @private
		 * 渲染队列。
		 * @param	state 渲染状态。
		 */
		public function _renderShadow(state:RenderState, isOnePSSM:Boolean):void {//TODO:SM
			var loopCount:int = Stat.loopCount;
			var scene:Scene = _scene;
			var camera:BaseCamera = state.camera;//TODO:是否直接设置灯光摄像机
			var vertexBuffer:VertexBuffer3D, vertexDeclaration:VertexDeclaration, shader:Shader3D;
			var forceUploadParams:Boolean;
			var lastStateMaterial:BaseMaterial, lastStateOwner:Sprite3D;
			
			for (var i:int = 0, n:int = _finalElements.length; i < n; i++) {
				var renderElement:RenderElement = _finalElements[i];
				var renderObj:IRenderable, material:BaseMaterial, owner:RenderableSprite3D;
				if (renderElement._type === 0) {//TODO:静态合并,动态合并
					state.owner = owner = renderElement._sprite3D;
					//传入灯光的MVP矩阵
					if (!isOnePSSM && (owner._projectionViewWorldUpdateCamera !== camera || owner._projectionViewWorldUpdateLoopCount !== Stat.loopCount)) {
						owner._render._renderUpdate(state._projectionViewMatrix);
						owner._projectionViewWorldUpdateLoopCount = Stat.loopCount;
						owner._projectionViewWorldUpdateCamera = camera;
					}
					state.renderElement = renderElement;
					owner._preRenderUpdateComponents(state);
					renderObj = renderElement.renderObj, material = renderElement._material;
					if (_begainRenderElement(state, renderObj, null)) {
						vertexBuffer = renderObj._getVertexBuffer(0);
						vertexDeclaration = vertexBuffer.vertexDeclaration;
						shader = state._shader = material._getShader(scene._shaderDefineValue, vertexDeclaration.shaderDefineValue, owner._shaderDefineValue);
						forceUploadParams = shader.bind() || (loopCount !== shader._uploadLoopCount);
						if (shader._uploadVertexBuffer !== vertexBuffer || forceUploadParams) {
							//WebGL.mainContext.disableVertexAttribArray(0);
							//WebGL.mainContext.disableVertexAttribArray(1);
							//WebGL.mainContext.disableVertexAttribArray(2);
							//WebGL.mainContext.disableVertexAttribArray(3);
							shader.uploadAttributes(vertexDeclaration.shaderValues.data, null);
							shader._uploadVertexBuffer = vertexBuffer;
						}
						
						if (camera !== shader._uploadCamera || shader._uploadSprite3D !== owner || forceUploadParams) {
							shader.uploadSpriteUniforms(owner._shaderValues.data);
							shader._uploadSprite3D = owner;
						}
						
						if (camera !== shader._uploadCamera || forceUploadParams) {
							shader.uploadCameraUniforms(camera._shaderValues.data);
							shader._uploadCamera = camera;
						}
						
						if (shader._uploadMaterial !== material || forceUploadParams) {
							material._upload();
							shader._uploadMaterial = material;
						}
						
						if (shader._uploadRenderElement !== renderElement || forceUploadParams) {//TODO:是否也删除
							//shader.uploadRenderElementUniforms(renderElement._shaderValue.data);
							//shader._uploadRenderElement = renderElement;
						}
						
						if (lastStateMaterial !== material) {//lastStateMaterial,lastStateOwner存到全局，多摄像机还可优化
							material._setRenderStateFrontFace(false, owner.transform);
							lastStateMaterial = material;
							lastStateOwner = owner;
						} else {
							if (lastStateOwner !== owner) {
								material._setRenderStateFrontFace(false, owner.transform);
								lastStateOwner = owner;
							}
						}
						
						renderObj._render(state);
						shader._uploadLoopCount = loopCount;
					}
					owner._postRenderUpdateComponents(state);
				}
			}
		}
		
		/**
		 * 清空队列中的渲染物体。
		 */
		public function _clearRenderElements():void {
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
		 * 添加动态批处理。
		 * @param renderObj 动态批处理。
		 */
		public function _addDynamicBatchElement(dynamicBatchElement:RenderElement):void {
			_dynamicBatchCombineRenderElements.push(dynamicBatchElement);
		}
	}
}