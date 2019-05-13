package laya.d3.resource.models {
	import laya.d3.core.BufferState;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.Vertex.VertexPositionTexture0;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>SkyDome</code> 类用于创建天空盒。
	 */
	public class SkyDome extends SkyMesh {
		/**@private */
		private static var _radius:Number = 1;
		/**@private */
		public static var instance:SkyDome;
		
		/**
		 * @private
		 */
		public static function __init__():void {
			instance = new SkyDome();//TODO:移植为标准Mesh后需要加锁
		}
		
		/**@private */
		private var _stacks:int;
		/**@private */
		private var _slices:int;
		
		/**
		 * 获取堆数。
		 */
		public function get stacks():int {
			return _stacks;
		}
		
		/**
		 * 获取层数。
		 */
		public function get slices():int {
			return _slices;
		}
		
		/**
		 * 创建一个 <code>SkyDome</code> 实例。
		 * @param stacks 堆数。
		 * @param slices 层数。
		 */
		public function SkyDome(stacks:Number = 48, slices:Number = 48) {
			_stacks = stacks;
			_slices = slices;
			var vertexDeclaration:VertexDeclaration = VertexPositionTexture0.vertexDeclaration;
			var vertexFloatCount:int = vertexDeclaration.vertexStride / 4;
			var numberVertices:Number = (_stacks + 1) * (_slices + 1);
			var numberIndices:Number = (3 * _stacks * (_slices + 1)) * 2;
			
			var vertices:Float32Array = new Float32Array(numberVertices * vertexFloatCount);
			var indices:Uint16Array = new Uint16Array(numberIndices);
			
			var stackAngle:Number = Math.PI / _stacks;
			var sliceAngle:Number = (Math.PI * 2.0) / _slices;
			
			// Generate the group of Stacks for the sphere  
			var vertexIndex:int = 0;
			var vertexCount:int = 0;
			var indexCount:int = 0;
			
			for (var stack:int = 0; stack < (_stacks + 1); stack++) {
				var r:Number = Math.sin(stack * stackAngle);
				var y:Number = Math.cos(stack * stackAngle);
				
				// Generate the group of segments for the current Stack  
				for (var slice:int = 0; slice < (_slices + 1); slice++) {
					var x:Number = r * Math.sin(slice * sliceAngle);
					var z:Number = r * Math.cos(slice * sliceAngle);
					vertices[vertexCount + 0] = x * _radius;
					vertices[vertexCount + 1] = y * _radius;
					vertices[vertexCount + 2] = z * _radius;
					
					vertices[vertexCount + 3] = -(slice / _slices) + 0.75;//gzk 改成我喜欢的坐标系 原来是 slice/_slices
					vertices[vertexCount + 4] = stack / _stacks;
					vertexCount += vertexFloatCount;
					if (stack != (_stacks - 1)) {
						// First Face
						indices[indexCount++] = vertexIndex + 1;
						indices[indexCount++] = vertexIndex;
						indices[indexCount++] = vertexIndex + (_slices + 1);
						
						// Second 
						indices[indexCount++] = vertexIndex + (_slices + 1);
						indices[indexCount++] = vertexIndex;
						indices[indexCount++] = vertexIndex + (_slices);
						vertexIndex++;
					}
				}
			}
			
			_vertexBuffer = new VertexBuffer3D(vertices.length * 4, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer.vertexDeclaration = vertexDeclaration;
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, indices.length, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			
			var bufferState:BufferState = new BufferState();
			bufferState.bind();
			bufferState.applyVertexBuffer(_vertexBuffer);
			bufferState.applyIndexBuffer(_indexBuffer);
			bufferState.unBind();
			_bufferState = bufferState;
		}
		
		override public function _render(state:RenderContext3D):void {
			var indexCount:int = _indexBuffer.indexCount;
			LayaGL.instance.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.trianglesFaces += indexCount / 3;
			Stat.renderBatches++;
		}
	}
}