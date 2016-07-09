package laya.d3.graphics {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRender;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StaticBatch implements IRender {
		/** @private */
		public static var maxVertexCount:int = 65535;
		public static var maxIndexCount:int = 120000;
		
		private var _currentVertexCount:int = 0;
		private var _currentIndexCount:int = 0;
		
		private var _elementCount:int;
		
		private var _vertexDeclaration:VertexDeclaration;
		private var _material:Material;
		
		private var _vertexDatas:Float32Array;
		private var _indexDatas:Uint16Array;
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		
		public var _lastRenderObjects:Vector.<IRender>;
		public var _renderObjects:Vector.<IRender>;
		public var _needReMerage:Boolean;
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get VertexBufferCount():int {
			return 1;
		}
		
		public function getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function get currentVertexCount():int {
			return _currentVertexCount;
		}
		
		public function get currentIndexCount():int {
			return _currentIndexCount;
		}
		
		public function getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		public function getBakedVertexs(index:int = 0):Float32Array {
			return null;
		}
		
		public function getBakedIndices():* {
			return null;
		}
		
		private static var ID:int = 0;
		public var id:int = 0;
		
		public function StaticBatch(vertexDeclaration:VertexDeclaration, material:Material) {
			_elementCount = 0;
			_vertexDeclaration = vertexDeclaration;
			_material = material;
			
			_vertexDatas = new Float32Array(_vertexDeclaration.vertexStride / 4 * maxVertexCount);
			_indexDatas = new Uint16Array(maxIndexCount);
			_vertexBuffer = VertexBuffer3D.create(_vertexDeclaration, maxVertexCount, WebGLContext.DYNAMIC_DRAW);
			_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, maxIndexCount, WebGLContext.DYNAMIC_DRAW);
			
			_lastRenderObjects = new Vector.<IRender>();
			_renderObjects = new Vector.<IRender>();
			_needReMerage = false;
			id = ++ID;
		}
		
		/**所有addRenderObj后调用*/
		public function _finsh():void {
			if (!_needReMerage && _lastRenderObjects.length != _renderObjects.length) {
				_needReMerage = true;
			}
			_currentIndexCount = 0;
			_currentVertexCount = 0;
			
			if (_needReMerage) {
				_needReMerage = false;
				
				var curMerVerCount:int = 0;
				var curMerIndCount:int = 0;
				_elementCount = 0;
				
				for (var i:int = 0; i < _renderObjects.length; i++) {
					var renderObj:IRender = _renderObjects[i];
					var subVertexDatas:Float32Array = renderObj.getBakedVertexs();
					var subIndexDatas:Uint16Array = renderObj.getBakedIndices();
					
					var indexOffset:int = curMerVerCount / (_vertexDeclaration.vertexStride / 4);
					var indexStart:int = curMerIndCount;
					var indexEnd:int = indexStart + subIndexDatas.length;
					
					_indexDatas.set(subIndexDatas, curMerIndCount);
					for (var k:int = indexStart; k < indexEnd; k++)
						_indexDatas[k] = indexOffset + _indexDatas[k];
					curMerIndCount += subIndexDatas.length;
					
					_vertexDatas.set(subVertexDatas, curMerVerCount);
					curMerVerCount += subVertexDatas.length;
					
					_elementCount += subIndexDatas.length;
					
				}
				_vertexBuffer.setData(_vertexDatas);
				_indexBuffer.setData(_indexDatas);
			}
			
			_lastRenderObjects = _renderObjects.slice();
			_renderObjects.length = 0;
		}
		
		/**
		 * @private
		 */
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
		
		public function addRenderObj(renderObj:IRender):Boolean {
			var indexCount:int = _currentIndexCount + renderObj.getIndexBuffer().length / 2;//TODO:可能为1
			var vertexCount:int = _currentVertexCount + renderObj.getVertexBuffer().length / _vertexDeclaration.vertexStride;
			
			if (vertexCount > maxVertexCount || indexCount > maxIndexCount)
				return false;
			
			_renderObjects.push(renderObj);//需始终有IB，需处理
			if (!_needReMerage && _lastRenderObjects.indexOf(renderObj) === -1)
				_needReMerage = true;
			
			_currentIndexCount = indexCount;
			_currentVertexCount = vertexCount;
			
			return true;
		}
		
		public function _render(state:RenderState):Boolean {
			
			var vb:VertexBuffer3D = _vertexBuffer;
			var ib:IndexBuffer3D = _indexBuffer;
			var material:Material = _material;
			
			if (material.normalTexture && !vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TANGENT0]) {
				//是否放到事件触发。
				var vertexDatas:Float32Array = vb.getData();
				var newVertexDatas:Float32Array = Utils3D.GenerateTangent(vertexDatas, vb.vertexDeclaration.vertexStride / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TEXTURECOORDINATE0][4] / 4, ib.getData());
				var vertexDeclaration:VertexDeclaration = Utils3D.getVertexTangentDeclaration(vb.vertexDeclaration.getVertexElements());
				
				var newVB:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, WebGLContext.STATIC_DRAW);
				newVB.setData(newVertexDatas);
				vb.dispose();
				_vertexBuffer =vb= newVB;
			}
			
			vb._bind();
			ib._bind();
			
			if (material) {
				var shader:Shader = _getShader(state, vb, material);
				
				var presz:int = state.shaderValue.length;
				state.shaderValue.pushArray(vb.vertexDeclaration.shaderValues);
				
				state.shaderValue.pushValue(Buffer.MATRIX1, Matrix4x4.DEFAULT.elements, -1);//待优化
				state.shaderValue.pushValue(Buffer.MVPMATRIX, state.projectionViewMatrix.elements, state.camera.transform._worldTransformModifyID + state.camera._projectionMatrixModifyID);
				if (!material.upload(state, null, shader)) {
					state.shaderValue.length = presz;
					return false;
				}
				state.shaderValue.length = presz;
			}
			
			state.context.drawElements(WebGLContext.TRIANGLES, _elementCount, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall++;
			Stat.trianglesFaces += _elementCount / 3;
			return true;
		}
	}

}