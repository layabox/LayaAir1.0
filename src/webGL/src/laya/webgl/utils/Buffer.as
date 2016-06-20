package laya.webgl.utils {
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Byte;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.submit.Submit;
	
	/**
	 * ...
	 * @author laya
	 */
	public class Buffer extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		//语义类型枚举
		public static const INDEX:String = "INDEX";
		
		//Uniform
		public static const MVPMATRIX:String = "MVPMATRIX";
		public static const MATRIX1:String = "MATRIX1";
		public static const MATRIX2:String = "MATRIX2";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		public static const NORMALTEXTURE:String = "NORMALTEXTURE";
		public static const SPECULARTEXTURE:String = "SPECULARTEXTURE";
		public static const EMISSIVETEXTURE:String = "EMISSIVETEXTURE";
		public static const AMBIENTTEXTURE:String = "AMBIENTTEXTURE";
		public static const REFLECTTEXTURE:String = "REFLECTTEXTURE";
		public static const MATRIXARRAY0:String = "MATRIXARRAY0";
		public static const FLOAT0:String = "FLOAT0";
		public static const UVAGEX:String = "UVAGEX";
		
		public static const CAMERAPOS:String = "CAMERAPOS";
		public static const LUMINANCE:String = "LUMINANCE";
		public static const ALPHATESTVALUE:String = "ALPHATESTVALUE";
		
		public static const FOGCOLOR:String = "FOGCOLOR";
		public static const FOGSTART:String = "FOGSTART";
		public static const FOGRANGE:String = "FOGRANGE";
		
		public static const MATERIALAMBIENT:String = "MATERIALAMBIENT";
		public static const MATERIALDIFFUSE:String = "MATERIALDIFFUSE";
		public static const MATERIALSPECULAR:String = "MATERIALSPECULAR";
		public static const MATERIALREFLECT:String = "MATERIALREFLECT";
		
		public static const LIGHTDIRECTION:String = "LIGHTDIRECTION";
		public static const LIGHTDIRDIFFUSE:String = "LIGHTDIRDIFFUSE";
		public static const LIGHTDIRAMBIENT:String = "LIGHTDIRAMBIENT";
		public static const LIGHTDIRSPECULAR:String = "LIGHTDIRSPECULAR";
		
		public static const POINTLIGHTPOS:String = "POINTLIGHTPOS";
		public static const POINTLIGHTRANGE:String = "POINTLIGHTRANGE";
		public static const POINTLIGHTATTENUATION:String = "POINTLIGHTATTENUATION";
		public static const POINTLIGHTDIFFUSE:String = "POINTLIGHTDIFFUSE";
		public static const POINTLIGHTAMBIENT:String = "POINTLIGHTAMBIENT";
		public static const POINTLIGHTSPECULAR:String = "POINTLIGHTSPECULAR";
		
		public static const SPOTLIGHTPOS:String = "SPOTLIGHTPOS";
		public static const SPOTLIGHTDIRECTION:String = "SPOTLIGHTDIRECTION";
		public static const SPOTLIGHTSPOT:String = "SPOTLIGHTSPOT";
		public static const SPOTLIGHTRANGE:String = "SPOTLIGHTRANGE";
		public static const SPOTLIGHTATTENUATION:String = "SPOTLIGHTATTENUATION";
		public static const SPOTLIGHTDIFFUSE:String = "SPOTLIGHTDIFFUSE";
		public static const SPOTLIGHTAMBIENT:String = "SPOTLIGHTAMBIENT";
		public static const SPOTLIGHTSPECULAR:String = "SPOTLIGHTSPECULAR";
		
		//................................................................................................................
		public static const TIME:String = "TIME";
		public static const VIEWPORTSCALE:String = "VIEWPORTSCALE";
		public static const CURRENTTIME:String = "CURRENTTIME";
		public static const DURATION:String = "DURATION";
		public static const GRAVITY:String = "GRAVITY";
		public static const ENDVELOCITY:String = "ENDVELOCITY";
		//.........................................................................................................................
		
		public static const FLOAT32:int = 4;
		public static const SHORT:int = 2;
		
		protected static var _gl:WebGLContext;
		protected static var _bindActive:Object = {};
		protected static var _COUNT:int = 1;
		
		public static function __int__(gl:WebGLContext):void {
			_gl = gl;
			IndexBuffer2D.QuadrangleIB = IndexBuffer2D.create(WebGLContext.STATIC_DRAW);
			GlUtils.fillIBQuadrangle(IndexBuffer2D.QuadrangleIB, 16);
		}
		
		public var _length:int = 0;
		public var _upload:Boolean = true;
		
		protected var _id:int;
		protected var _type:*;
		protected var _buffer:ArrayBuffer;
		protected var _glBuffer:*;
		protected var _bufferUsage:int;
		protected var _uploadSize:int = 0;
		protected var _maxsize:int = 0;
		
		public function get bufferType():* {
			return _type;
		}
		
		public function get bufferLength():int {
			return _buffer.byteLength;
		}
		
		public function get length():int {
			return _length;
		}
		
		public function set length(value:int):void {
			if (_length === value)
				return;
			value <= _buffer.byteLength || (_resizeBuffer(value * 2 + 256, true));
			_length = value;
		}
		
		public function Buffer() {
			super();
			lock = true;
			_gl = WebGL.mainContext;
			_id = ++_COUNT;
			Render.isFlash || (_buffer = new ArrayBuffer(8));
		}
		
		private function _bufferData():void {
			_maxsize = Math.max(_maxsize, _length);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;
					_buffer = _buffer.slice(0, _maxsize + 64);
					_checkArrayUse();
				}
				_maxsize = _length;
			}
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_type, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			_gl.bufferSubData(_type, 0, _buffer);
		}
		
		private function _bufferSubData(offset:int = 0, dataStart:int = 0, dataLength:int = 0):void {
			_maxsize = Math.max(_maxsize, _length);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;
					_buffer = _buffer.slice(0, _maxsize + 64);
					_checkArrayUse();
				}
				_maxsize = _length;
			}
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_type, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			
			if (dataStart || dataLength) {
				var subBuffer:ArrayBuffer = _buffer.slice(dataStart, dataLength);
				_gl.bufferSubData(_type, offset, subBuffer);
			} else {
				_gl.bufferSubData(_type, offset, _buffer);
			}
		}
		
		protected function _checkArrayUse():void {
		}
		
		override protected function recreateResource():void {
			startCreate();
			_glBuffer || (_glBuffer = _gl.createBuffer());
			compoleteCreate();
		}
		
		override protected function detoryResource():void {
			if (_glBuffer) {
				WebGL.mainContext.deleteBuffer(_glBuffer);
				_glBuffer = null;
				_upload = true;
				_uploadSize = 0;
				memorySize = 0;
			}
		}
		
		public function _bind():void {
			activeResource();
			(_bindActive[_type] === _glBuffer) || (_gl.bindBuffer(_type, _bindActive[_type] = _glBuffer), Shader.activeShader = null);
		}
		
		public function _bind_upload():Boolean {
			if (!_upload)
				return false;
			
			_upload = false;
			_bind();
			_bufferData();
			return true;
		}
		
		public function _bind_subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			if (!_upload)
				return false;
			
			_upload = false;
			_bind();
			_bufferSubData(offset, dataStart, dataLength);
			return true;
		}
		
		public function _resizeBuffer(nsz:int, copy:Boolean):Buffer //是否修改了长度
		{
			if (nsz < _buffer.byteLength)
				return this;
			memorySize = nsz;
			if (copy && _buffer && _buffer.byteLength > 0) {
				var newbuffer:ArrayBuffer = new ArrayBuffer(nsz);
				var n:* = new Uint8Array(newbuffer);
				n.set(new Uint8Array(_buffer), 0);
				_buffer = newbuffer;
			} else
				_buffer = new ArrayBuffer(nsz);
			_checkArrayUse();
			_upload = true;
			
			return this;
		}
		
		public function append(data:*):void {
			_upload = true;
			var byteLength:int, n:*;
			byteLength = data.byteLength;
			if (data is Uint8Array) {
				_resizeBuffer(_length + byteLength, true);
				n = new Uint8Array(_buffer, _length);
			} else if (data is Uint16Array) {
				_resizeBuffer(_length + byteLength, true);
				n = new Uint16Array(_buffer, _length);
			} else if (data is Float32Array) {
				_resizeBuffer(_length + byteLength, true);
				n = new Float32Array(_buffer, _length);
			}
			n.set(data, 0);
			_length += byteLength;
			_checkArrayUse();
		}
		
		/*
		   public function setdata(data:*):void {
		   _buffer = data.buffer;
		   _upload = true;
		   _length = _buffer.byteLength;
		   _checkFloatArray32Use();
		   }
		 */
		public function getBuffer():ArrayBuffer {
			return _buffer;
		}
		
		public function setNeedUpload():void {
			_upload = true;
		}
		
		public function getNeedUpload():Boolean {
			return _upload;
		}
		
		public function upload():Boolean {
			var scuess:Boolean = _bind_upload();
			_gl.bindBuffer(_type, null);
			_bindActive[_type] = null;
			Shader.activeShader = null
			return scuess;
		}
		
		public function subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			var scuess:Boolean = _bind_subUpload();
			_gl.bindBuffer(_type, null);
			_bindActive[_type] = null;
			Shader.activeShader = null
			return scuess;
		}
		
		public function clear():void {
			_length = 0;
			_upload = true;
		}
		
		/**
		 * 释放CPU中的内存（upload()后确定不再使用时可使用）
		 */
		public function disposeCPUData():void {
			_buffer = null;
		}
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	}

}