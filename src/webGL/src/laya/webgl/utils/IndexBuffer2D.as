package laya.webgl.utils {
	import laya.layagl.LayaGL;
	import laya.webgl.WebGLContext;
	
	public class IndexBuffer2D extends Buffer2D {
		public static var create:Function = function(bufferUsage:int = 0x88e4/* WebGLContext.STATIC_DRAW*/):IndexBuffer2D {
			return new IndexBuffer2D(bufferUsage);
		}
		
		protected var _uint16Array:Uint16Array;
		
		public function IndexBuffer2D(bufferUsage:int = 0x88e4/* WebGLContext.STATIC_DRAW*/) {
			super();
			_bufferUsage = bufferUsage;
			_bufferType = WebGLContext.ELEMENT_ARRAY_BUFFER;
			_buffer = new ArrayBuffer(8);
		}
		
		override protected function _checkArrayUse():void {
			_uint16Array && (_uint16Array = new Uint16Array(_buffer));
		}
		
		public function getUint16Array():Uint16Array {
			return _uint16Array || (_uint16Array = new Uint16Array(_buffer));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _bindForVAO():void {
			LayaGL.instance.bindBuffer(WebGLContext.ELEMENT_ARRAY_BUFFER, _glBuffer);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bind():Boolean {
			if (_bindedIndexBuffer !== _glBuffer) {
				LayaGL.instance.bindBuffer(WebGLContext.ELEMENT_ARRAY_BUFFER, _glBuffer);
				_bindedIndexBuffer = _glBuffer;
				return true;
			}
			return false;
		}
		
		public function destory():void {
			_uint16Array = null;
			_buffer = null;
		}
		
		public function disposeResource():void {
			_disposeResource();
		}
	}
}