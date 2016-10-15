package laya.d3.resource.models {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * @private
	 * <code>PrimitiveMesh</code> 类用于创建基本网格的父类。
	 */
	public class PrimitiveMesh extends BaseMesh implements IRenderable {
		protected var _numberVertices:int;
		protected var _numberIndices:int;
		protected var _vertexBuffer:VertexBuffer3D;
		protected var _indexBuffer:IndexBuffer3D;
		
		/** @private */
		public var _indexOfHost:int;
		
		public function get indexOfHost():int {
			return _indexOfHost;
		}
		
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer.indexCount / 3;
		}
		
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		/**
		 * 获取网格顶点
		 * @return 网格顶点。
		 */
		override public function get positions():Vector.<Vector3>//WEBGL1.0不能从Buffer显存中获取内存数据
		{
			var vertices:Vector.<Vector3> = new Vector.<Vector3>();
			
			var positionElement:VertexElement;
			var vertexElements:Array = _vertexBuffer.vertexDeclaration.getVertexElements();
			var j:int;
			for (j = 0; j < vertexElements.length; j++) {
				var vertexElement:VertexElement = vertexElements[j];
				if (vertexElement.elementFormat === VertexElementFormat.Vector3 && vertexElement.elementUsage === VertexElementUsage.POSITION0) {
					positionElement = vertexElement;
					break;
				}
			}
			
			var verticesData:Float32Array = _vertexBuffer.getData();
			for (j = 0; j < verticesData.length; j += _vertexBuffer.vertexDeclaration.vertexStride / 4) {
				var ofset:int = j + positionElement.offset / 4;
				var position:Vector3 = new Vector3(verticesData[ofset + 0], verticesData[ofset + 1], verticesData[ofset + 2]);
				vertices.push(position);
			}
			
			return vertices;
		}
		
		public function PrimitiveMesh() {
			super();
			_indexOfHost = 0;
		}
		
		override public function getRenderElement(index:int):IRenderable {
			return this;
		}
		
		override public function getRenderElementsCount():int {
			return 1;
		}
		
		override protected function detoryResource():void {
			(_vertexBuffer) && (_vertexBuffer.dispose(), _vertexBuffer = null);
			(_indexBuffer) && (_indexBuffer.dispose(), _indexBuffer = null);
			memorySize = 0;
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			_vertexBuffer._bind();
			_indexBuffer._bind();
			return  true;
		}
		
		public function _render(state:RenderState):void {
			state.context.drawElements(WebGLContext.TRIANGLES, _numberIndices, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall++;
			Stat.trianglesFaces += _numberIndices / 3;
		}
	
	}

}