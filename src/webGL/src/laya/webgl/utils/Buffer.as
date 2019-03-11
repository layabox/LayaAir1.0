package laya.webgl.utils {
	import laya.layagl.LayaGL;
	
	public class Buffer {
		public static var _bindedVertexBuffer:*;	//当前gl绑定的VertexBuffer
		public static var _bindedIndexBuffer:*;		//当前gl绑定的indexBuffer
		
		protected var _glBuffer:*;
		protected var _buffer:*;//可能为Float32Array、Uint16Array、Uint8Array、ArrayBuffer等。
		
		protected var _bufferType:int;
		protected var _bufferUsage:int;
		
		public var _byteLength:int = 0;
		
		public function get bufferUsage():int {
			return _bufferUsage;
		}
		
		public function Buffer() {
			_glBuffer = LayaGL.instance.createBuffer()
		}
		
		/**
		 * @private
		 * 绕过全局状态判断,例如VAO局部状态设置
		 */
		public function _bindForVAO():void {
		}
		
		/**
		 * @private
		 */
		//TODO:coverage
		public function bind():Boolean {
			return false;
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			if (_glBuffer) {
				LayaGL.instance.deleteBuffer(_glBuffer);
				_glBuffer = null;
			}
		}
	}
}