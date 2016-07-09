/*[IF-FLASH]*/
package laya.flash
{
	import flash.display3D.IndexBuffer3D;
	
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.IndexBuffer2D;
	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashIndexBuffer extends IndexBuffer2D
	{		
		public static var create:Function = function():*
		{
			return __new();
		}
			
	    private static function __new():FlashIndexBuffer
		{
			return new FlashIndexBuffer();
		}
		
		private var _buffData:Uint16Array;
		private var _dataSize:int = SHORT;
		private var _activeVStride:int = 4;
		
		public var _flashGLBuff:IndexBuffer3D;
		private var _flashGLBuffSize:int;
		private var _uploadIbSize:int;
		
		private var _vctBuff:Vector.<uint>;
		
		
		public function FlashIndexBuffer()
		{
			super();
			
			_buffData = new Uint16Array();
			_vctBuff = new Vector.<uint>();
		}
		
		private function _createGlBuffer(sz:int):*
		{
			if (_flashGLBuffSize == sz && _flashGLBuff)
				return _flashGLBuff;
			_flashGLBuffSize = sz;
			if (_flashGLBuff)
				_flashGLBuff.dispose();
			return _flashGLBuff = FlashWebGLContext.context3D.createIndexBuffer(sz);
		}
		
		override public function getUint16Array():Uint16Array
		{
			return _buffData as Uint16Array;
		}
		
		override public function clear():void
		{
			_length = 0;
			_buffData.length = 0;
			_upload = true;
		}
		
		override public function append(data:*):void
		{
			_upload = true;
			
			if (data is Uint16Array)
			{
				if( this._length == 0 ){
					_vctBuff = (data as Uint16Array).getVecBuf();
					this._length = _vctBuff.length;// * 2;
				}else {
					var tv : Vector.<uint> = (data as Uint16Array).getVecBuf();
					for ( var i : int = 0, len :int = tv.length; i < len; i ++ ) {
						_vctBuff.push( tv[i] );
					}
					this._length = _vctBuff.length;// * 2;
				}
			}
		}
		
		override public function getBuffer():ArrayBuffer
		{
			debugger;
			return null;
		}
		
		/*调试用*/
		override public function get bufferLength():int
		{
			return _buffData.length * _dataSize;
		}
		
		override public function set length(value:int):void
		{
			setLength(value);
		}
		
		public override function get length() : int {
			return this._length;
		}
		
		public function setLength(value:int):void
		{
			if (_length === value)
				return;
			_length = value;
			memorySize = _length;
			value /= _dataSize;
			_buffData.length = value;
			_upload = true;
		}
		
		override public function _resizeBuffer(nsz:int, copy:Boolean):Buffer //是否修改了长度
		{
			setLength(nsz);
			return this;
		}
		
		override protected function detoryResource():void
		{
			if (_flashGLBuff)
			{
				_flashGLBuff.dispose();
				_flashGLBuff = null;
			}
		}
		
		override protected function recreateResource():void
		{
			startCreate();
			_glBuffer = this;
			compoleteCreate();
		}
		
		public function uploadByCount(count:int):void
		{
			// River: 加入另外的条件，确保Polygon Draw不用每次上传顶点.
			if ( _uploadIbSize == count )
			{
				_bind();
				return;
			}
			// ATTENTION TO FIX:
			//@{ River added: Sprite_DrawPath.as这个Demo会出现自己组织的索引数据			
			if ( count <= _vctBuff.length ){
				if ( _buffData.length < count ) {
					count = _vctBuff.length;
					_upload = false;					
				}
			}
			//@}
			
			_uploadIbSize = count;
			if (_vctBuff.length < count || _upload)
			{
				_upload = false;
				_vctBuff.length = count;
				for (var i:int = 0; i < count; i++)
					_vctBuff[i] = _buffData[i];
			}
			_createGlBuffer(count);
			_bind();
			_flashGLBuff.uploadFromVector(_vctBuff, 0, count);
		}
	
	}

}