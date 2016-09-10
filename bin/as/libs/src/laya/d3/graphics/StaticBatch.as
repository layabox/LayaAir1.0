package laya.d3.graphics {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * @private
	 * <code>StaticBatch</code> 类用于创建静态批处理。
	 */
	public class StaticBatch implements IRenderable {
		private static var _IDCounter:int = 0;
		public static var maxVertexCount:int = 65535;
		public static var maxIndexCount:int = 120000;
		
		private static function _addToRenderQueueStaticBatch(scene:BaseScene, sprite3D:Sprite3D):void {
			var i:int, n:int;
			if ((sprite3D is MeshSprite3D) && (sprite3D.isStatic))//TODO:可能会移除,目前只针对MeshSprite3D
			{
				var renderElements:Vector.<RenderElement> = (sprite3D as MeshSprite3D).meshRender.renderCullingObject._renderElements;
				for (i = 0, n = renderElements.length; i < n; i++) {
					var renderElement:RenderElement = renderElements[i];
					scene.getRenderQueue(renderElement.material.renderQueue)._addPrepareRenderElementToStaticBatch(renderElement);
				}
			}
			
			for (i = 0, n = sprite3D.numChildren; i < n; i++)
				_addToRenderQueueStaticBatch(scene, sprite3D._childs[i] as Sprite3D);
		}
		
		/**
		 * 合并节点为静态批处理。
		 * @param staticBatchRoot 静态批处理根节点。
		 */
		public static function combine(staticBatchRoot:Sprite3D):void {
			var scene:BaseScene = staticBatchRoot.scene;
			if (!scene)
				throw new Error("BaseScene: staticBatchRoot is not a part of scene.");
			
			_addToRenderQueueStaticBatch(scene, staticBatchRoot);
			var queues:Vector.<RenderQueue> = scene._quenes;
			for (var i:int = 0, n:int = queues.length; i < n; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._finishCombineStaticBatch());
			}
		}
		
		private var _renderQueue:RenderQueue;
		
		private var _vertexDeclaration:VertexDeclaration;
		private var _material:Material;
		
		private var _vertexDatas:Float32Array;
		private var _indexDatas:Uint16Array;
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _renderElements:Vector.<RenderElement>;
		
		private var _combineRenderElementPool:Vector.<RenderElement>;
		private var _combineRenderElementPoolIndex:int;
		
		private var _combineRenderElements:Vector.<RenderElement>;
		private var _currentCombineVertexCount:int;
		private var _currentCombineIndexCount:int;
		
		public var _indexStart:int;
		public var _indexEnd:int;
		
		public var _useFPS:int;
		
		public var id:int;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get VertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer.indexCount / 3;
		}
		
		public function getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function get currentVertexCount():int {
			return _currentCombineVertexCount;
		}
		
		public function get currentIndexCount():int {
			return _currentCombineIndexCount;
		}
		
		public function getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		public function StaticBatch(renderQueue:RenderQueue, vertexDeclaration:VertexDeclaration, material:Material) {
			_renderQueue = renderQueue;
			_useFPS = -1;
			_currentCombineVertexCount = 0;
			_currentCombineIndexCount = 0;
			id = _IDCounter++;
			_vertexDeclaration = vertexDeclaration;
			_material = material;
			
			_renderElements = new Vector.<RenderElement>();
			_combineRenderElements = new Vector.<RenderElement>();
			
			_combineRenderElementPool = new Vector.<RenderElement>();
			_combineRenderElementPoolIndex = 0;
		}
		
		private function _getCombineRenderElementFromPool():RenderElement {
			var renderElement:RenderElement = _combineRenderElementPool[_combineRenderElementPoolIndex++];
			return renderElement || (_combineRenderElementPool[_combineRenderElementPoolIndex - 1] = new RenderElement());
		}
		
		private function _getShader(state:RenderState, vertexBuffer:VertexBuffer3D, material:Material):Shader {
			if (!material)
				return null;
			var def:int = 0;
			var shaderAttribute:* = vertexBuffer.vertexDeclaration.shaderAttribute;
			(shaderAttribute.UV) && (def |= material.shaderDef);
			(shaderAttribute.COLOR) && (def |= ShaderDefines3D.COLOR);
			(state.scene.enableFog) && (def |= ShaderDefines3D.FOG);
			def > 0 && state.shaderDefs.addInt(def);
			var shader:Shader = material.getShader(state);
			return shader;
		}
		
		public function _addCombineRenderObjTest(renderElement:RenderElement):Boolean {
			var renderObj:IRenderable = renderElement.element;
			var indexCount:int = _currentCombineIndexCount + renderObj.getIndexBuffer().indexCount;
			var vertexCount:int = _currentCombineVertexCount + renderObj.getVertexBuffer().vertexCount;
			if (vertexCount > maxVertexCount || indexCount > maxIndexCount)
				return false;
			
			return true;
		}
		
		public function _addCombineRenderObj(renderElement:RenderElement):void {
			var renderObj:IRenderable = renderElement.element;
			
			_combineRenderElements.push(renderElement);
			_currentCombineIndexCount = _currentCombineIndexCount + renderObj.getIndexBuffer().indexCount;
			_currentCombineVertexCount = _currentCombineVertexCount + renderObj.getVertexBuffer().vertexCount;
			_useFPS = Stat.loopCount;
		}
		
		public function _finshCombine():void {
			var curMerVerCount:int = 0;
			var curIndexCount:int = 0;
			
			_vertexDatas = new Float32Array(_vertexDeclaration.vertexStride / 4 * _currentCombineVertexCount);
			_indexDatas = new Uint16Array(_currentCombineIndexCount);
			
			if (_vertexBuffer) {
				_vertexBuffer.dispose();
				_indexBuffer.dispose();
			}
			_vertexBuffer = VertexBuffer3D.create(_vertexDeclaration, _currentCombineVertexCount, WebGLContext.DYNAMIC_DRAW);
			_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _currentCombineIndexCount, WebGLContext.DYNAMIC_DRAW);
			
			for (var i:int = 0, n:int = _combineRenderElements.length; i < n; i++) {
				var rebderElement:RenderElement = _combineRenderElements[i];
				
				var subVertexDatas:Float32Array = rebderElement.getBakedVertexs(0);
				var subIndexDatas:Uint16Array = rebderElement.getBakedIndices();
				
				var indexOffset:int = curMerVerCount / (_vertexDeclaration.vertexStride / 4);
				var indexStart:int = curIndexCount;
				var indexEnd:int = indexStart + subIndexDatas.length;
				
				rebderElement.staticBatch = this;
				rebderElement.staticBatchIndexStart = indexStart;
				rebderElement.staticBatchIndexEnd = indexEnd;
				
				_indexDatas.set(subIndexDatas, curIndexCount);
				for (var k:int = indexStart; k < indexEnd; k++)
					
					_indexDatas[k] = indexOffset + _indexDatas[k];
				
				curIndexCount += subIndexDatas.length;
				
				_vertexDatas.set(subVertexDatas, curMerVerCount);
				
				curMerVerCount += subVertexDatas.length;
			}
			
			_vertexBuffer.setData(_vertexDatas);
			_indexBuffer.setData(_indexDatas);
			
			_combineRenderElements.length = 0;
			_currentCombineIndexCount = 0;
			_currentCombineVertexCount = 0;
		}
		
		public function _addRenderElement(renderElement:RenderElement):void {
			for (var i:int = 0, n:int = _renderElements.length; i < n; i++) {
				if (_renderElements[i].staticBatchIndexStart > renderElement.staticBatchIndexStart) {
					_renderElements.splice(i, 0, renderElement);
					renderElement.isInStaticBatch = true;
					renderElement.ownerRenderQneue = _renderQueue;
					_useFPS = Stat.loopCount;
					return;
				}
			}
			
			_renderElements.push(renderElement);
			renderElement.isInStaticBatch = true;
			renderElement.ownerRenderQneue = _renderQueue;
		}
		
		public function _deleteRenderElement(renderElement:RenderElement):void {
			var index:int = _renderElements.indexOf(renderElement);
			if (index !== -1) {
				_renderElements.splice(index, 1);
				renderElement.isInStaticBatch = false;
				renderElement.ownerRenderQneue = null;
			}
		}
		
		public function _clearRenderElements():void {
			for (var i:int = 0, n:int = _renderElements.length; i < n; i++) {
				_renderElements[i].isInStaticBatch = false;
				_renderElements[i].ownerRenderQneue = null;
			}
			_renderElements.length = 0;
		}
		
		public function _getRenderElement(mergeElements:Array):void {
			_combineRenderElementPoolIndex = 0;//归零对象池
			
			var length:int = _renderElements.length;
			if (length > 0) {
				var merageElement:RenderElement = _getCombineRenderElementFromPool();
				merageElement.type = 1;//代表StaticBatch
				merageElement.staticBatch = null;
				merageElement.element = this;
				mergeElements.push(merageElement);
				merageElement.staticBatchIndexStart = _renderElements[0].staticBatchIndexStart;
				merageElement.staticBatchIndexEnd = _renderElements[0].staticBatchIndexEnd;
				
				if (length > 1) {
					for (var i:int = 1; i < length; i++) {
						var renderElement:RenderElement = _renderElements[i];
						if (_renderElements[i - 1].staticBatchIndexEnd !== renderElement.staticBatchIndexStart) {
							merageElement = _getCombineRenderElementFromPool();
							merageElement.type = 1;//代表StaticBatch
							merageElement.staticBatch = null;
							merageElement.element = this;
							mergeElements.push(merageElement);
							merageElement.staticBatchIndexStart = renderElement.staticBatchIndexStart;
							merageElement.staticBatchIndexEnd = renderElement.staticBatchIndexEnd;
						} else {
							merageElement.staticBatchIndexEnd = renderElement.staticBatchIndexEnd;
						}
					}
				}
			}
		}
		
		public function _render(state:RenderState):Boolean {
			var vb:VertexBuffer3D = _vertexBuffer;
			var ib:IndexBuffer3D = _indexBuffer;
			var material:Material = _material;
			
			//if (material.normalTexture && !vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TANGENT0]) {
			////是否放到事件触发。
			//var vertexDatas:Float32Array = vb.getData();
			//var newVertexDatas:Float32Array = Utils3D.generateTangent(vertexDatas, vb.vertexDeclaration.vertexStride / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TEXTURECOORDINATE0][4] / 4, ib.getData());
			//var vertexDeclaration:VertexDeclaration = Utils3D.getVertexTangentDeclaration(vb.vertexDeclaration.getVertexElements());
			//
			//var newVB:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, WebGLContext.STATIC_DRAW);
			//newVB.setData(newVertexDatas);
			//vb.dispose();
			//_vertexBuffer = vb = newVB;
			//}
			
			vb._bind();
			ib._bind();
			
			if (material) {
				var shader:Shader = _getShader(state, vb, material);
				
				var presz:int = state.shaderValue.length;
				state.shaderValue.pushArray(vb.vertexDeclaration.shaderValues);
				
				state.shaderValue.pushValue(Buffer2D.MATRIX1, Matrix4x4.DEFAULT.elements, -1);//待优化
				state.shaderValue.pushValue(Buffer2D.MVPMATRIX, state.projectionViewMatrix.elements, /*state.camera.transform._worldTransformModifyID + state.camera._projectionMatrixModifyID,从结构上应该从Mesh更新*/ -1);
				if (!material.upload(state, null, shader)) {
					state.shaderValue.length = presz;
					return false;
				}
				state.shaderValue.length = presz;
			}
			var indexCount:int = _indexEnd - _indexStart;
			state.context.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, _indexStart * 2);//2为字节数
			Stat.drawCall++;
			Stat.trianglesFaces += indexCount / 3;
			return true;
		}
	}

}