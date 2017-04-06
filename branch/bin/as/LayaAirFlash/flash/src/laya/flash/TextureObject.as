/*[IF-FLASH]*/package laya.flash 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DWrapMode;
	import flash.display3D.textures.Texture;
	import laya.webgl.WebGLContext;

	/**
	 * ...
	 * @author rivetr
	 */
	public class TextureObject 
	{
		public static var _context3D:Context3D;
		private static var _lastSamplerID : int = -1;
		private var _texture : Texture;
		private var _width : int = 0;
		private var _height : int = 0;
		private var _stateArr : Object = {};
		private var _uid : uint = 0;
		
		private var _wrap : String = Context3DWrapMode.CLAMP;
		private var _filter : String = Context3DTextureFilter.NEAREST;
		private var _mipfilter : String = Context3DMipFilter.MIPNONE;
		
		private var _dinit : Boolean = false;
		
		public function TextureObject() 
		{		
			_texture = null;
		}
		
		private function _to2(x:Number):Number {
			x--;
			x |= x >> 1;
			x |= x >> 2;
			x |= x >> 4;
			x |= x >> 8;
			x |= x >> 16;
			x++;
			return x;
		}		
		
		public function set dinit( _b : Boolean ) : void {
			_dinit = _b;
		}
		public function get dinit() : Boolean {
			return _dinit;
		}
		
		public static function clearSampler() : void {
			_lastSamplerID = -1;
		}
		
		public function get width() : int {
			return _width;
		}
		public function get height() : int {
			return _height;
		}
		
		public function get texture() : Texture {
			return _texture;
		}
		
		public function getTexFromSize( wid : int, heig : int ) : Texture {
			if ( ( _width == wid ) && (_height == heig ) ) return _texture;
			if ( _texture != null ) _texture.dispose();
			_width = _to2(wid); _height = _to2(heig);
			_texture = _context3D.createTexture( _width, _height, Context3DTextureFormat.BGRA, false );
			_dinit = false;
			return _texture;
		}
		
		public function dispose() : void {
			if ( _texture ) {
				_texture.dispose();
				_texture = null;			
			}
		}
		
		public function addTexParameteri( pname:*, param:* ) : void {
			_stateArr[pname] = param;
			_uid = 0;
			for ( var c : * in _stateArr ) {
				_uid = c * 10 + _stateArr[c];
			}
			
			// 此处转化为Stage3D对应的参数，减少运行时判断的开销
			if ( pname == WebGLContext.TEXTURE_WRAP_S ) {
				if ( param == WebGLContext.CLAMP_TO_EDGE ) {
					_wrap = Context3DWrapMode.CLAMP;
				}
				if ( param == WebGLContext.REPEAT ) {
					_wrap = Context3DWrapMode.REPEAT;
				}
			}
			
			if ( pname == WebGLContext.TEXTURE_MAG_FILTER ) {
				if ( param == WebGLContext.LINEAR )
					_filter = Context3DTextureFilter.LINEAR;
				else
					_filter = Context3DTextureFilter.NEAREST;
			}
			
			if ( pname == WebGLContext.TEXTURE_MIN_FILTER ) {
				if ( param == WebGLContext.LINEAR ) {
					_mipfilter = Context3DMipFilter.MIPNONE;
				}else if ( param == WebGLContext.LINEAR_MIPMAP_LINEAR ) {
					_mipfilter = Context3DMipFilter.MIPLINEAR;
				}else
					_mipfilter = Context3DMipFilter.MIPNEAREST;
			}
		}
				
		/**
		 * 每次设置纹理时，需要同时判断uid是否与上次的设置相同，不同则需要设置状态.
		 * @param	idx
		 */
		public function setTexSamplerState( idx : int ) : void {
			if ( _uid == _lastSamplerID ) return;
			//_context3D.setSamplerStateAt( idx, _wrap, _filter, _mipfilter );
			_context3D.setSamplerStateAt( idx, _wrap, _filter, Context3DMipFilter.MIPNONE );
			_lastSamplerID = _uid;
		}
		
	}

}