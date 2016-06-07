package laya.webgl.utils {
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	
	/**
	 * ...
	 * @author laya
	 */
	public class VertexBuffer extends Buffer {
		public static var create:Function = function(vertexDeclaration:VertexDeclaration,bufferUsage:int = 0x88E8 /*WebGLContext.DYNAMIC_DRAW*/):VertexBuffer {
			return new VertexBuffer(vertexDeclaration,bufferUsage);
		}
		
		protected var _floatArray32:Float32Array;
		
		protected var _vertexDeclaration:VertexDeclaration;
		
		/** @private */
		protected var _attributeMap:* = [];
		/** @private */
		protected var _shaderValues:ValusArray = new ValusArray();
		/** shaderAtrribute。 */
		public var shaderAttribute:* = {};
		
		public function get shaderValues():ValusArray {
			return _shaderValues;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexBuffer(vertexDeclaration:VertexDeclaration,bufferUsage:int) {
			super();
			_vertexDeclaration = vertexDeclaration;
			_bufferUsage = bufferUsage;
			_type = WebGLContext.ARRAY_BUFFER;
			getFloat32Array();
		}
		
		/**
		 * 获取ShaderAttribute。
		 * @param name 名称。
		 */
		public function getShaderAttribute(name:String):Array {
			return shaderAttribute[name];
		}
		
		/**
		 * 添加ShaderAttribute。
		 * @param name 名称。
		 * @param value 值。
		 * @param id 优化id。
		 */
		public function addShaderAttribute(name:String, value:*, id:int):void {
			shaderAttribute[name] = value;
			_attributeMap[name] = _shaderValues.length;
			_shaderValues.pushValue(name, value, id);
		}
		
		/**
		 * 添加或更新ShaderAttribute。
		 * @param name 名称。
		 * @param value 值。
		 * @param id 优化id。
		 */
		public function addOrUpdateShaderAttribute(name:String, value:*, id:int):void {
			if (_attributeMap[name]) {
				shaderAttribute[name] = value;
				_shaderValues.setValue(_attributeMap[name], name, value, id);
			} else {
				addShaderAttribute(name, value, id);
			}
		}
		
		public function getFloat32Array():* {
			return _floatArray32 || (_floatArray32 = new Float32Array(_buffer));
		}
		
		public function bind(ibBuffer:IndexBuffer):void {
			(ibBuffer) && (ibBuffer._bind());
			_bind();
			
			
		}
		
		public function insertData(data:Array, pos:int):void {
			var vbdata:* = getFloat32Array();
			vbdata.set(data, pos);
			_upload = true;
		}
		
		public function bind_upload(ibBuffer:IndexBuffer):void {
			(ibBuffer._bind_upload()) || (ibBuffer._bind());
			(_bind_upload()) || (_bind());
			
		}
		
		override protected function _checkFloatArray32Use():void {
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
		}
		
		override public function disposeCPUData():void {
			super.disposeCPUData();
			_floatArray32 = null;
		}
	
	}

}