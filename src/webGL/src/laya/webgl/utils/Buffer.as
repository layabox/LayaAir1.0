package laya.webgl.utils {
	import laya.resource.Resource;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	
	public class Buffer extends Resource {
		protected static var _gl:WebGLContext;
		protected static var _bindActive:Object = {};
		
		protected var _glBuffer:*;
		protected var _buffer:*;//可能为Float32Array、Uint16Array、Uint8Array、ArrayBuffer等。
		
		protected var _bufferType:int;
		protected var _bufferUsage:int;
		
		public var _byteLength:int = 0;//TODO:私有
		
		public function get byteLength():int {
			return _byteLength;
		}
		
		public function get bufferType():* {
			return _bufferType;
		}
		
		public function get bufferUsage():int {
			return _bufferUsage;
		}
		
		public function Buffer() {
			_gl = WebGL.mainContext;
		}
		
		public function _bind():void {
			activeResource();
			(_bindActive[_bufferType] === _glBuffer) || (_gl.bindBuffer(_bufferType, _bindActive[_bufferType] = _glBuffer), Shader.activeShader = null);
		}
		
		override protected function recreateResource():void {
			startCreate();
			_glBuffer || (_glBuffer = _gl.createBuffer());
			completeCreate();
		}
		
		override protected function detoryResource():void {
			if (_glBuffer) {
				WebGL.mainContext.deleteBuffer(_glBuffer);
				_glBuffer = null;
			}
			memorySize = 0;
		}
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	
	}

}