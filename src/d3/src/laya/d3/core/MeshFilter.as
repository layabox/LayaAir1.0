package laya.d3.core {
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexElement;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.shader.DefineDatas;
	
	/**
	 * <code>MeshFilter</code> 类用于创建网格过滤器。
	 */
	public class MeshFilter {
		/** @private */
		private var _owner:RenderableSprite3D;
		/** @private */
		private var _sharedMesh:Mesh;
		
		/**
		 * 获取共享网格。
		 * @return 共享网格。
		 */
		public function get sharedMesh():Mesh {
			return _sharedMesh;
		}
		
		/**
		 * 设置共享网格。
		 * @return  value 共享网格。
		 */
		public function set sharedMesh(value:Mesh):void {
			if (_sharedMesh !== value) {
				var defineDatas:DefineDatas = _owner._render._defineDatas;
				var lastValue:Mesh = _sharedMesh;
				if (lastValue) {
					lastValue._removeReference();
					defineDatas.remove(_getMeshDefine(lastValue));
				}
				value._addReference();
				_sharedMesh = value;
				defineDatas.add(_getMeshDefine(value));
				(_owner._render as MeshRenderer)._changeRenderObjectsByMesh(value);
			}
			(_owner._render as MeshRenderer)._onMeshChange(value);
		}
		
		/**
		 * 创建一个新的 <code>MeshFilter</code> 实例。
		 * @param owner 所属网格精灵。
		 */
		public function MeshFilter(owner:RenderableSprite3D) {
			_owner = owner;
		}
		
		/**
		 * @private
		 */
		private function _getMeshDefine(mesh:Mesh):int {
			var define:int;
			for (var i:int = 0, n:int = mesh._subMeshCount; i < n; i++) {
				var subMesh:SubMesh = mesh._getSubMesh(i) as SubMesh;
				var vertexElements:Array = subMesh._vertexBuffer._vertexDeclaration.vertexElements;
				for (var j:int = 0, m:int = vertexElements.length; j < m; j++) {
					var vertexElement:VertexElement = vertexElements[j];
					var name:int = vertexElement.elementUsage;
					switch (name) {
					case VertexMesh.MESH_COLOR0: 
						define |= MeshSprite3D.SHADERDEFINE_COLOR;
						break
					case VertexMesh.MESH_TEXTURECOORDINATE0: 
						define |= MeshSprite3D.SHADERDEFINE_UV0;
						break;
					case VertexMesh.MESH_TEXTURECOORDINATE1: 
						define |= MeshSprite3D.SHADERDEFINE_UV1;
						break;
					}
				}
			}
			return define;
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void {
			_owner = null;
			(_sharedMesh) && (_sharedMesh._removeReference(), _sharedMesh = null);
		}
	
	}

}