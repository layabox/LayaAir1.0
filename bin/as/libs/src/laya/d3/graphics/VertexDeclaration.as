package laya.d3.graphics {
	import laya.d3.shader.ShaderDefines3D;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VertexDeclaration {
		public static const _maxVertexDeclarationBit:int = 1000;//TODO：可移除
		public static const maxVertexDeclaration:int = 2147483647 - Math.floor(2147483647 / _maxVertexDeclarationBit) * _maxVertexDeclarationBit;//需在顶点定义类中加异常判断警告TODO：可移除
		/**唯一标识ID计数器。*/
		private static var _uniqueIDCounter:int = 1;
		
		private static function _getTypeSize(format:String):int {
			switch (format) {
			case VertexElementFormat.Single: 
				return 4;
			case VertexElementFormat.Vector2: 
				return 8;
			case VertexElementFormat.Vector3: 
				return 12;
			case VertexElementFormat.Vector4: 
				return 16;
			case VertexElementFormat.Color: 
				return 4;
			case VertexElementFormat.Byte4: 
				return 4;
			case VertexElementFormat.Short2: 
				return 4;
			case VertexElementFormat.Short4: 
				return 8;
			case VertexElementFormat.NormalizedShort2: 
				return 4;
			case VertexElementFormat.NormalizedShort4: 
				return 8;
			case VertexElementFormat.HalfVector2: 
				return 4;
			case VertexElementFormat.HalfVector4: 
				return 8;
			}
			return 0;
		}
		
		public static function getVertexStride(vertexElements:Array):int {
			var curStride:int = 0;
			for (var i:int = 0; i < vertexElements.Length; i++) {
				var element:VertexElement = vertexElements[i];
				var stride:int = element.offset + _getTypeSize(element.elementFormat);
				if (curStride < stride) {
					curStride = stride;
				}
			}
			return curStride;
		}
		
		private var _id:int;
		private var _shaderValues:ValusArray;
		private var _shaderDefine:int;
		//private var _shaderAttribute:*;
		
		private var _vertexStride:int;
		private var _vertexElements:Array;
		private var _vertexElementsDic:Object;
		
		/**
		 * 获取唯一标识ID(通常用于优化或识别)。
		 * @return 唯一标识ID
		 */
		public function get id():int {
			return _id;
		}
		
		public function get vertexStride():int {
			return _vertexStride;
		}
		
		public function get shaderValues():ValusArray//TODO:临时这么做
		{
			return _shaderValues;
		}
		
		public function get shaderDefine():int//TODO:临时这么做
		{
			return _shaderDefine;
		}
		
		public function VertexDeclaration(vertexStride:int, vertexElements:Array) {
			_id = ++_uniqueIDCounter;
			if (_id > maxVertexDeclaration)
				throw new Error("VertexDeclaration: VertexDeclaration count should not large than ", maxVertexDeclaration);
			
			_shaderValues = new ValusArray();
			_vertexElementsDic = {};
			_vertexStride = vertexStride;
			_vertexElements = vertexElements;
			
			for (var i:int = 0; i < vertexElements.length; i++) {
				var vertexElement:VertexElement = vertexElements[i];
				var attributeName:String = vertexElement.elementUsage;
				_vertexElementsDic[attributeName] = vertexElement;
				var value:Array = [_getTypeSize(vertexElement.elementFormat) / 4, WebGLContext.FLOAT, false, _vertexStride, vertexElement.offset];
				_shaderValues.pushValue(attributeName, value);
				
				switch (attributeName) {//TODO:临时
				case VertexElementUsage.TEXTURECOORDINATE0: 
					_shaderDefine |= ShaderDefines3D.UV;
					break;
				case VertexElementUsage.COLOR0: 
					_shaderDefine |= ShaderDefines3D.COLOR;
					break;
				}
			}
		}
		
		public function getVertexElements():Array {
			return _vertexElements.slice();
		}
		
		public function getVertexElementByUsage(usage:String):VertexElement {
			return _vertexElementsDic[usage];
		}
		
		public function unBinding():void {
		
		}
	
	}

}