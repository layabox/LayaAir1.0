package laya.webgl.utils {
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
		
		//Attribute
		public static const POSITION0:String = "POSITION";
		public static const NORMAL0:String = "NORMAL";
		public static const COLOR0:String = "COLOR";
		public static const UV0:String = "UV";
		public static const NEXTUV0:String = "NEXTUV";
		public static const UV1:String = "UV1";
		public static const NEXTUV1:String = "NEXTUV1";
		public static const BLENDWEIGHT0:String = "BLENDWEIGHT";
		public static const BLENDINDICES0:String = "BLENDINDICES";
		
		//Uniform
		public static const MATRIX0:String = "MATRIX0";
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
		public static const CORNERTEXTURECOORDINATE:String = "CORNERTEXTURECOORDINATE";
		public static const VELOCITY:String = "VELOCITY";
		public static const SIZEROTATION:String = "SIZEROTATION";
		public static const RADIUSRADIAN:String = "RADIUSRADIAN";
		public static const AGEADDSCALE:String = "AGEADDSCALE";
		public static const TIME:String = "TIME";
		public static const VIEWPORTSCALE:String = "VIEWPORTSCALE";
		public static const CURRENTTIME:String = "CURRENTTIME";
		public static const DURATION:String = "DURATION";
		public static const GRAVITY:String = "GRAVITY";
		public static const ENDVELOCITY:String = "ENDVELOCITY";
		//.........................................................................................................................
		
		public static const FLOAT32:int = 4;
		public static const SHORT:int = 2;
		
		//! 全局的四边形索引缓冲区.
		public static var QuadrangleIB:Buffer;
		
		private static var _gl:WebGLContext;
		private static var _bindActive:Array = [];
		private static var _COUNT:int = 1;
		
		public static function __int__(gl:WebGLContext):void {
			_gl = gl;
			QuadrangleIB = new Buffer(WebGLContext.ELEMENT_ARRAY_BUFFER, INDEX, null, WebGLContext.STATIC_DRAW);
			GlUtils.fillIBQuadrangle(QuadrangleIB, 16);
		}
		
		public var _length:int = 0;
		public var _upload:Boolean = true;
		
		private var _id:int;
		private var _glTarget:*;
		private var _buffer:ArrayBuffer;
		private var _glBuffer:*;
		private var _bufferUsage:int;
		private var _floatArray32:Float32Array;
		private var _uploadSize:int = 0;
		private var _usage:String;
		private var _maxsize:int = 0;
		
		/**
		 *
		 * @param	glTarget 	缓冲区类型
		 * @param	usage  	如果指定glType为ELEMENT_ARRAY_BUFFER 后 usage会被设置为 INDEX;  多buffr 时候 要对应Shader的别名
		 * @param	frome 	数据
		 * @param	bufferUsage  可以使设置为 gl.STATIC_DRAW   gl.DYNAMIC_DRAW
		 *  example
		 *  多Buffer usage
		 *  public static var bVertex:Buffer = new Buffer(Buffer.ARRAY_BUFFER,Buffer.POSITION,vertices);
		 *	public static var bColors:Buffer = new Buffer(Buffer.ARRAY_BUFFER,Buffer.COLOR, colors);
		 *	public static var bIndices:Buffer = new Buffer(Buffer.ELEMENT_ARRAY_BUFFER, Buffer.INDEX, indices);
		 * 	example
		 *  var _gib = gl.createBuffer();
		 *  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, _gib);
		 *  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, 9000 * bytesPerElement, gl.STATIC_DRAW);
		 */
		public function Buffer(glTarget:*, usage:String = null, frome:* = null, bufferUsage:int = 0x88E8 /*WebGLContext.DYNAMIC_DRAW*/) {
			super();
			//super(Resource.BUFFER, 0, ResourceMgr.GPU);
			lock = true;
			_gl = WebGL.mainContext;
			_id = ++_COUNT;
			_usage = usage;
			glTarget == WebGLContext.ELEMENT_ARRAY_BUFFER && (glTarget = WebGLContext.ELEMENT_ARRAY_BUFFER, _usage = INDEX);
			glTarget == WebGLContext.ARRAY_BUFFER && (glTarget = WebGLContext.ARRAY_BUFFER);
			_glTarget = glTarget;
			_bufferUsage = bufferUsage;
			_buffer = new ArrayBuffer(8);
			
			frome && append(frome);
		}
		
		public function getFloat32Array():Float32Array {
			return _floatArray32 || (_floatArray32 = new Float32Array(_buffer));
		}
		
		public function getUint16Array():Uint16Array {
			return new Uint16Array(_buffer);
		}
		
		public function clear():void {
			_length = 0;
			_upload = true;
		}
		
		public function append(data:*):void {
			_upload = true;
			var szu8:int, n:*;
			if (data is Uint8Array) {
				szu8 = data.length;
				_resizeBuffer(_length + szu8, true);
				n = new Uint8Array(_buffer, _length);
			} else if (data is Float32Array) {
				szu8 = data.length * 4;
				_resizeBuffer(_length + szu8, true);
				n = new Float32Array(_buffer, _length);
			} else if (data is Uint16Array) {
				szu8 = data.length * 2;
				_resizeBuffer(_length + szu8, true);
				n = new Uint16Array(_buffer, _length);
			}
			n.set(data, 0);
			_length += szu8;
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
		}
		
		public function setdata(data:*):void {
			_buffer = data.buffer;
			_upload = true;
			_floatArray32 || (_floatArray32 = new Float32Array(_buffer));
			_length = _buffer.byteLength;
		}
		
		public function getBuffer():ArrayBuffer {
			return _buffer;
		}
		
		/*调试用*/
		public var _uint16:Uint16Array;
		
		public function get uintArray16():Uint16Array {
			_uint16 = new Uint16Array(_buffer);
			return _uint16;
		}
		
		/*调试用*/
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
		
		public function seLength(value:int):void {
			if (_length === value)
				return;
			value <= _buffer.byteLength || (_resizeBuffer(value * 2 + 256, true));
			_length = value;
		}
		
		public function get usage():String {
			return _usage;
		}
		
		public function _resizeBuffer(nsz:int, copy:Boolean):Buffer //是否修改了长度
		{
			if (nsz < _buffer.byteLength)
				return this;
			memorySize = _buffer.byteLength;	//Resource.addCPUMemSize(nsz - _buffer.byteLength);
			if (copy && _buffer && _buffer.byteLength > 0) {
				var newbuffer:ArrayBuffer = new ArrayBuffer(nsz);
				var n:* = new Uint8Array(newbuffer);
				n.set(new Uint8Array(_buffer), 0);
				_buffer = newbuffer;
			} else
				_buffer = new ArrayBuffer(nsz);
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
			_upload = true;
			
			return this;
		}
		
		public function setNeedUpload():void {
			_upload = true;
		}
		
		public function getNeedUpload():Boolean {
			return _upload;
		}
		
		public function bind():void {
			activeResource();
			(_bindActive[_glTarget] === _glBuffer) || (_gl.bindBuffer(_glTarget, _bindActive[_glTarget] = _glBuffer), Shader.activeShader = null);
		}
		
		override protected function recreateResource():void {
			_glBuffer || (_glBuffer = _gl.createBuffer());
			_upload = true;
			memorySize = 0;//待调整
			super.recreateResource();
		}
		
		override protected function detoryResource():void {
			if (_glBuffer) {
				//WebGL.mainContext.deleteBuffer(_glBuffer);
				var glBuffer:* = _glBuffer;
				Laya.timer.frameOnce(1,null, function():void {
					WebGL.mainContext.deleteBuffer(glBuffer);
				});//延迟一帧删除WebGL Buffer,否则农场游戏有Bug,待研究
				_glBuffer = null;
				_upload = true;
				_uploadSize = 0;
				memorySize = 0;//待调整
			}
		}
		
		public function upload():Boolean {
			if (!_upload)
				return false;
			_upload = false;
			bind();
			
			_maxsize = Math.max(_maxsize, _length);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;//Resource.addCPUMemSize(_maxsize + 64 - _buffer.byteLength);
					_buffer = _buffer.slice(0, _maxsize + 64);
					_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
				}
				_maxsize = _length;
			}
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_glTarget, _uploadSize, _bufferUsage);
				
				memorySize = _uploadSize;
			}
			_gl.bufferSubData(_glTarget, 0, _buffer);
			Stat.bufferLen += _length;
			return true;
		}
		
		public function subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			if (!_upload)
				return false;
			_upload = false;
			bind();
			
			_maxsize = Math.max(_maxsize, _length);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;//Resource.addCPUMemSize(_maxsize + 64 - _buffer.byteLength);
					_buffer = _buffer.slice(0, _maxsize + 64);
					_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
				}
				_maxsize = _length;
			}
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_glTarget, _uploadSize, _bufferUsage);
				
				memorySize = _uploadSize;
			}
			if (dataStart || dataLength) {
				var subBuffer:ArrayBuffer = _buffer.slice(dataStart, dataLength);
				_gl.bufferSubData(_glTarget, offset, subBuffer);
			} else {
				_gl.bufferSubData(_glTarget, offset, _buffer);
			}
			
			return true;
		}
		
		public function upload_bind():void {
			(_upload && upload()) || bind();
		}
		
		/**
		 * 释放CPU中的内存（upload()后确定不再使用时可使用）
		 */
		public  function disposeCPUData():void
		{
			_buffer = null;
			_floatArray32 = null;
		}
		
		override public function dispose():void {
			_resourceManager = null;
			super.dispose();
		}
	}

}