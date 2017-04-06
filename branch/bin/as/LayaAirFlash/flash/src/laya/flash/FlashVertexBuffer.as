/*[IF-FLASH]*/
package laya.flash {
	import flash.display3D.VertexBuffer3D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashVertexBuffer extends VertexBuffer2D {
		public static var create:Function = function(vertexStride:int=0,bufferUsage:int = 0x88E8 /*WebGLContext.DYNAMIC_DRAW*/):VertexBuffer2D {
			return __new(vertexStride,bufferUsage);
		}
		
		private static function  __new (vertexStride:int,bufferUsage:int):FlashVertexBuffer
		{
			return new FlashVertexBuffer(vertexStride,bufferUsage);
		}
		
		private var _activeVStride:int = 4;
		
		public var _flashGLBuff:VertexBuffer3D;
		private var _flashGLBuffSize:int;
		
		private var _vctBuff:Vector.<Number>;
		
		public  var  _selfIB:IndexBuffer2D;
		private var  _maxBufLen : int = 0;
		public function FlashVertexBuffer(vertexStride:int,bufferUsage:int) {
			super(vertexStride,bufferUsage);			
			_vctBuff = new Vector.<Number>();
			if ( vertexStride > 0 ) 
				_activeVStride = vertexStride;
			//else
			//	throw "Error Stride SIZE!";
		}
		
		private function _createGlBuffer(sz:int):* {
			if (_flashGLBuffSize == sz && _flashGLBuff) return _flashGLBuff;
			if (_flashGLBuff) _flashGLBuff.dispose();
			_flashGLBuffSize = sz;
			return _flashGLBuff = FlashWebGLContext.context3D.createVertexBuffer(sz / _activeVStride, _activeVStride);
		}
		
		override public function getFloat32Array():* {
			return _vctBuff;
		}
		
		override public function clear():void {
			_byteLength = 0;
			_upload = true;
		}
		

		/*
		public override function getStride() : int {
			return _activeVStride;
		}*/		
		
		override public function append(data:*):void {
			_upload = true;
			
			if ( data is Float32Array ) {
				
				if (this._byteLength == 0){
					this._vctBuff = new Vector.<Number>();
				}
				//if( this._byteLength == 0 ){
					//_vctBuff = (data as Float32Array).getVecBuf();
					//this._byteLength = _vctBuff.length * 4;
				//}else {
					var tv : Vector.<Number> = (data as Float32Array).getVecBuf();
					for ( var i : int = 0, len : int = tv.length; i < len; i ++ ) {
						_vctBuff.push( tv[i] );
					}
					this._byteLength = _vctBuff.length * 4;
				//}
			}			
		}
		
		override public function getBuffer():ArrayBuffer {
			debugger;
			return null;
		}
		
		/*调试用*/
		override public function get bufferLength():int {
			return _vctBuff.length * FLOAT32;
		}
		
		override public function set byteLength(value:int):void {
			setLength(value);
		}
		
		public function setLength(value:int):void {
			if (_byteLength == value)
				return;
			_byteLength = value;
			value /= FLOAT32;
			if (_maxBufLen < value) {
				memorySize = _byteLength;
				_vctBuff.length = value;
				_maxBufLen = value;
				_upload = true;
			}
		}
		
		override public function _resizeBuffer(nsz:int, copy:Boolean):Buffer2D //是否修改了长度
		{
			setLength(nsz);
			return this;
		}
		
		override protected function detoryResource():void {
			if (_flashGLBuff) {
				_flashGLBuff.dispose();
				_flashGLBuff = null;
			}
		}
		
		override protected function recreateResource():void {
			startCreate();
			_glBuffer = this;
			completeCreate();
		}
		
		override public function insertData(data:Array, pos:int):void {
			for (var i:int = 0, n:int = data.length; i < n; i++) {
				_vctBuff[i + pos] = data[i];
			}
			_upload = true;
		}
		
		override public function bind_upload(ibBuffer:IndexBuffer2D):void {
			if ( _byteLength < 1 ) return;
			if (!_upload ) {
				ibBuffer._bind();
				this._bind();
				return;
			}
			
			_upload = false;
			
			// River: 只所以不使用_lendth/FLOAT32是因为别的地方有可能修改_vctBuffer而修改_byteLength的值			
			var nsz:int = _vctBuff.length;// _byteLength / FLOAT32;
			var count:int = nsz / _activeVStride;
			
			// River: 以下代码处理TriangleFan类的数据组织.
			var idxCount : int = count * 1.5;
			idxCount = idxCount - (idxCount % 3);
			
			(ibBuffer as FlashIndexBuffer) .uploadByCount( idxCount );
			
			_bind();
			
			_maxsize = Math.max(_maxsize, nsz);
			
			_createGlBuffer(nsz);
			
			(_flashGLBuff as VertexBuffer3D).uploadFromVector(_vctBuff, 0, count);
						
			return;
		}
		
		override public function dispose():void 
		{
			if ( !_flashGLBuff ) return;
			
			super.dispose();
			(_selfIB) && (_selfIB.dispose());
		}
	
	}

}