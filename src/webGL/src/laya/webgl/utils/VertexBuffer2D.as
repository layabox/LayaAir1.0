package laya.webgl.utils {
	import laya.renders.Render;
	import laya.layagl.LayaGL;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class VertexBuffer2D extends Buffer2D {
		public static var create:Function = function(vertexStride:int, bufferUsage:int = 0x88e8/* WebGLContext.DYNAMIC_DRAW*/):VertexBuffer2D {
			return new VertexBuffer2D(vertexStride, bufferUsage);
		}
		
		public var _floatArray32:Float32Array;
		public var _uint32Array:Uint32Array;
		
		private var _vertexStride:int;
		
		public function get vertexStride():int {
			return _vertexStride;
		}
		
		public function VertexBuffer2D(vertexStride:int, bufferUsage:int) {
			super();
			_vertexStride = vertexStride;
			_bufferUsage = bufferUsage;
			_bufferType = WebGLContext.ARRAY_BUFFER;
			_buffer = new ArrayBuffer(8);
			_floatArray32 = new Float32Array(_buffer);
			_uint32Array = new Uint32Array(_buffer);
		}
		
		public function getFloat32Array():Float32Array {
			return _floatArray32;
		}
		
		/**
		 * 在当前位置插入float数组。
		 * @param	data
		 * @param	pos
		 */
		public function appendArray(data:Array):void {
			var oldoff:int = _byteLength >> 2;
			setByteLength(_byteLength + data.length * 4);
			var vbdata:Float32Array = getFloat32Array();
			vbdata.set(data, oldoff);
			_upload = true;
		}
		
		override protected function _checkArrayUse():void {
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
			_uint32Array && (_uint32Array = new Uint32Array(_buffer));
		}
		
		//只删除buffer，不disableVertexAttribArray
		public function deleteBuffer():void {
			super._disposeResource();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _bindForVAO():void {
			LayaGL.instance.bindBuffer(WebGLContext.ARRAY_BUFFER, _glBuffer);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bind():Boolean {
			if (_bindedVertexBuffer !== _glBuffer) {
				LayaGL.instance.bindBuffer(WebGLContext.ARRAY_BUFFER, _glBuffer);
				_bindedVertexBuffer = _glBuffer;
				return true;
			}
			return false;
		}
		
		override public function destroy():void {
			super.destroy();
			_byteLength = 0;
			_upload = true;
			_buffer = null;
			_floatArray32 = null;
		}
	
	}

}