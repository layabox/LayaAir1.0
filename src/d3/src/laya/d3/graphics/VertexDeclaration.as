package laya.d3.graphics {
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>VertexDeclaration</code> 类用于生成顶点声明。
	 */
	public class VertexDeclaration {
		/**@private */
		private static var _uniqueIDCounter:int = 1;
		
		/**@private */
		private var _id:int;
		/**@private */
		private var _vertexStride:int;
		/**@private */
		private var _vertexElementsDic:Object;
		/**@private */
		public var _shaderValues:ShaderData;
		/**@private */
		public var _defineDatas:DefineDatas;
		
		/**@private [只读]*/
		public var vertexElements:Array;
		
		/**
		 * 获取唯一标识ID(通常用于优化或识别)。
		 * @return 唯一标识ID
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * @private
		 */
		public function get vertexStride():int {
			return _vertexStride;
		}
		
		/**
		 * 创建一个 <code>VertexDeclaration</code> 实例。
		 * @param	vertexStride 顶点跨度。
		 * @param	vertexElements 顶点元素集合。
		 */
		public function VertexDeclaration(vertexStride:int, vertexElements:Array) {
			_id = ++_uniqueIDCounter;
			_defineDatas = new DefineDatas();
			_vertexElementsDic = {};
			_vertexStride = vertexStride;
			this.vertexElements = vertexElements;
			var count:int = vertexElements.length;
			_shaderValues = new ShaderData(null);
			
			for (var j:int = 0; j < count; j++) {
				var vertexElement:VertexElement = vertexElements[j];
				var name:int = vertexElement.elementUsage;
				_vertexElementsDic[name] = vertexElement;
				var value:Int32Array = new Int32Array(5);
				var elmentInfo:Array = VertexElementFormat.getElementInfos(vertexElement.elementFormat);
				value[0] = elmentInfo[0];
				value[1] = elmentInfo[1];
				value[2] = elmentInfo[2];
				value[3] = _vertexStride;
				value[4] = vertexElement.offset;
				_shaderValues.setAttribute(name, value);
			}
		}
		
		/**
		 * @private
		 */
		public function getVertexElementByUsage(usage:int):VertexElement {
			return _vertexElementsDic[usage];
		}
		
		/**
		 * @private
		 */
		public function unBinding():void {
		
		}
	
	}

}