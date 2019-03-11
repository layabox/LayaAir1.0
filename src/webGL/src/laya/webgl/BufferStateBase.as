package laya.webgl {
	import laya.layagl.LayaGL;
	import laya.webgl.utils.Buffer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BufferStateBase {
		/**@private [只读]*/
		public static var _curBindedBufferState:BufferStateBase;
		
		/**@private [只读]*/
		private var _nativeVertexArrayObject:*;
		
		/**@private [只读]*/
		public var _bindedIndexBuffer:Buffer;
		
		public function BufferStateBase() {
			_nativeVertexArrayObject = LayaGL.instance.createVertexArray();
		}
		
		/**
		 * @private
		 */
		public function bind():void {
			if (_curBindedBufferState !== this) {
				LayaGL.instance.bindVertexArray(_nativeVertexArrayObject);
				_curBindedBufferState = this;
			}
		}
		
		/**
		 * @private
		 */
		public function unBind():void {
			if (_curBindedBufferState === this) {
				LayaGL.instance.bindVertexArray(null);
				_curBindedBufferState = null;
			} else {
				throw "BufferState: must call bind() function first.";
			}
		}
		
		/**
		 * @private
		 */
		public function bindForNative():void {
			LayaGL.instance.bindVertexArray(_nativeVertexArrayObject);
			_curBindedBufferState = this;
		}
		
		/**
		 * @private
		 */
		public function unBindForNative():void {
				LayaGL.instance.bindVertexArray(null);
				_curBindedBufferState = null;
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			LayaGL.instance.deleteVertexArray(_nativeVertexArrayObject);
		}
	
	}

}