package laya.d3.graphics.Vertex {
	import laya.d3.graphics.IVertex;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VertexMesh {
		public static const MESH_POSITION0:int = 0;
		public static const MESH_COLOR0:int = 1;
		public static const MESH_TEXTURECOORDINATE0:int = 2;
		public static const MESH_NORMAL0:int = 3;
		public static const MESH_TANGENT0:int = 5;
		public static const MESH_BLENDINDICES0:int = 6;
		public static const MESH_BLENDWEIGHT0:int = 7;
		public static const MESH_TEXTURECOORDINATE1:int = 8;
		
		/**@private */
		private static var _vertexDeclarationMap:Object = {};
		
		/**
		 * 获取顶点声明。
		 * @param vertexFlag 顶点声明标记字符,格式为:"POSITION,NORMAL,COLOR,UV,UV1,BLENDWEIGHT,BLENDINDICES,TANGENT"。
		 * @return 顶点声明。
		 */
		public static function getVertexDeclaration(vertexFlag:String, compatible:Boolean = true):VertexDeclaration {
			var verDec:VertexDeclaration = _vertexDeclarationMap[vertexFlag];
			if (!verDec) {
				var subFlags:Array = vertexFlag.split(",");
				var offset:int = 0;
				var elements:Array = [];
				for (var i:int = 0, n:int = subFlags.length; i < n; i++) {
					var element:VertexElement;
					switch (subFlags[i]) {
					case "POSITION": 
						element = new VertexElement(offset, VertexElementFormat.Vector3, VertexMesh.MESH_POSITION0);
						offset += 12;
						break;
					case "NORMAL": 
						element = new VertexElement(offset, VertexElementFormat.Vector3, VertexMesh.MESH_NORMAL0);
						offset += 12;
						break;
					case "COLOR": 
						element = new VertexElement(offset, VertexElementFormat.Vector4, VertexMesh.MESH_COLOR0);
						offset += 16;
						break;
					case "UV": 
						element = new VertexElement(offset, VertexElementFormat.Vector2, VertexMesh.MESH_TEXTURECOORDINATE0);
						offset += 8;
						break;
					case "UV1": 
						element = new VertexElement(offset, VertexElementFormat.Vector2, VertexMesh.MESH_TEXTURECOORDINATE1);
						offset += 8;
						break;
					case "BLENDWEIGHT": 
						element = new VertexElement(offset, VertexElementFormat.Vector4, VertexMesh.MESH_BLENDWEIGHT0);
						offset += 16;
						break;
					case "BLENDINDICES": 
						if (compatible) {
							element = new VertexElement(offset, VertexElementFormat.Vector4, VertexMesh.MESH_BLENDINDICES0);//兼容
							offset += 16;
						} else {
							element = new VertexElement(offset, VertexElementFormat.Byte4, VertexMesh.MESH_BLENDINDICES0);
							offset += 4;
						}
						break;
					case "TANGENT": 
						element = new VertexElement(offset, VertexElementFormat.Vector4, VertexMesh.MESH_TANGENT0);
						offset += 16;
						break;
					default: 
						throw "VertexMesh: unknown vertex flag.";
					}
					elements.push(element);
				}
				verDec = new VertexDeclaration(offset, elements);
				_vertexDeclarationMap[vertexFlag] = verDec;
			}
			return verDec;
		}
	}

}