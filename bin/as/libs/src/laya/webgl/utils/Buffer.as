package laya.webgl.utils {
	import laya.resource.Resource;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	
	public class Buffer extends Resource {
		protected static var _gl:WebGLContext;
		
		public static var _bindActive:Object = {};
		public static var _bindVertexBuffer:*;
		public static var _enableAtributes:Array = [];
		
		protected var _glBuffer:*;
		protected var _buffer:*;//可能为Float32Array、Uint16Array、Uint8Array、ArrayBuffer等。
		
		protected var _bufferType:int;
		protected var _bufferUsage:int;
		
		public var _byteLength:int = 0;
		
		public function get bufferUsage():int {
			return _bufferUsage;
		}
		
		public function Buffer() {
			_gl = WebGL.mainContext;
		}
		
		public function _bind():void {
			activeResource();
			if (_bindActive[_bufferType] !== _glBuffer) {
				(_bufferType === WebGLContext.ARRAY_BUFFER) && (_bindVertexBuffer = _glBuffer);
				_gl.bindBuffer(_bufferType, _bindActive[_bufferType] = _glBuffer);
				BaseShader.activeShader = null;
			}
		}
		
		override protected function recreateResource():void {
			_glBuffer || (_glBuffer = _gl.createBuffer());
			completeCreate();
		}
		
		override protected function disposeResource():void {
			if (_glBuffer) {
				WebGL.mainContext.deleteBuffer(_glBuffer);
				_glBuffer = null;
			}
			memorySize = 0;
		}
	
	}

}