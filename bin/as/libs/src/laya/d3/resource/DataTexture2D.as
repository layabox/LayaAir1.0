package laya.d3.resource {
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.maths.Arith;
	import laya.utils.Utils;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class DataTexture2D extends BaseTexture {
		/**
		 * * 把所有的lod排列在一层上，这里记录每一lod的位置信息
		 */
		static private var lodasatlas:Boolean = false;
		public var simLodInfo:Float32Array;
		public static var simLodRect:Uint32Array = new Uint32Array([
			//x,y,w,h,
			0, 0, 							512, 	256,
			512, 0, 						256, 	128,
			512+256, 0, 					128, 	64,
			512+256+128, 0, 				64, 	32,
			512+256+128+64, 0, 				32, 	16,
			512+256+128+64+32, 0, 			16, 	8,
			512+256+128+64+32+16, 0, 		8, 		4,
			512+256+128+64+32+16+8, 0, 		4, 		2,
			512+256+128+64+32+16+8+4, 0, 	2, 		1,
			512+256+128+64+32+16+8+4+2, 0, 	1, 		1
		]);
		
		//先只接收RGBA int8的
		public static function create(data:ArrayBuffer, w:int, h:int, magfilter:int = WebGLContext.LINEAR, minfilter:int = WebGLContext.LINEAR, mipmap:Boolean = true):DataTexture2D {
			if (!data || data.byteLength < (w * h * 4))
				throw 'DataTexture2D create error';
			var ret:DataTexture2D = new DataTexture2D();
			ret._buffer = data;
			ret._width = w;
			ret._height = h;
			ret._mipmap = mipmap;
			ret._magFifter = magfilter;
			ret._minFifter = minfilter;
			//直接设置数据的话，就认为是加载完成
			ret._size = new Size(ret._width, ret._height);
			if (ret._conchTexture) {
				alert('怎么给runtime传递datatexture数据');
			} else
				ret.activeResource();
			return ret;
		}
		
		private function genDebugMipmaps():* {
			//生成9层
			var ret:* = [];
			ret.push(new Uint8Array((new Uint32Array(512 * 256)).fill(0xff0000ff).buffer));
			ret.push(new Uint8Array((new Uint32Array(256 * 128)).fill(0xff0080ff).buffer));
			ret.push(new Uint8Array((new Uint32Array(128 * 64)).fill(0xff00ffff).buffer));
			ret.push(new Uint8Array((new Uint32Array(64 * 32)).fill(0xff00ff00).buffer));
			ret.push(new Uint8Array((new Uint32Array(32 * 16)).fill(0xff804000).buffer));
			ret.push(new Uint8Array((new Uint32Array(16 * 8)).fill(0xffff0000).buffer));
			ret.push(new Uint8Array((new Uint32Array(8 * 4)).fill(0xffff0080).buffer));
			ret.push(new Uint8Array((new Uint32Array(4 * 2)).fill(0x0).buffer));
			ret.push(new Uint8Array((new Uint32Array(2 * 1)).fill(0xff808080).buffer));
			ret.push(new Uint8Array((new Uint32Array(1 * 1)).fill(0xffffffff).buffer));
			return ret;
		}
		
		/**
		 * 加载Texture2D。
		 * @param url Texture2D地址。
		 */
		public static function load(url:String, w:int = 0, h:int = 0, magfilter:int = WebGLContext.LINEAR, minfilter:int = WebGLContext.LINEAR):DataTexture2D {
			var extension:String = Utils.getFileExtension(url);
			if (extension === 'mipmaps') {
				var ret:DataTexture2D = Laya.loader.create(url, null, null, DataTexture2D, [function(data:ArrayBuffer):* {
					this._mipmaps = [];
					var szinfo:Uint32Array = new Uint32Array(data);
					this._width = szinfo[0];
					var validw:int = 512;
					if (DataTexture2D.lodasatlas) {
						this._width *= 2;//因为要把lod合并到一起，所以*2
						validw = 1024;
					}
					if (this._width != validw) {
						console.error("现在只支持512x256的环境贴图。当前的是" + szinfo[0]);
						throw "现在只支持512x256的环境贴图。当前的是" + szinfo[0];
					}
					this._height = szinfo[1];
					var curw:int = DataTexture2D.lodasatlas ? this._width / 2 : this._width;
					var curh:int = this._height;
					var cursz:int = 8;
					while (true) {
						var curbufsz:int = curw * curh * 4;
						if (cursz + curbufsz > data.byteLength) {
							throw "load mipmaps data size error ";
						}
						var tbuf:Uint8Array = new Uint8Array(data, cursz, curbufsz);
						this._mipmaps.push(tbuf);
						cursz += curbufsz;
						if (curw == 1 && curh == 1) {
							break;
						}
						curw /= 2;
						curh /= 2;
						if (curw < 1) curw = 1;
						if (curh < 1) curh = 1;
					}
					//DEBUG
					//this._mipmaps = this.genDebugMipmaps();
					return null;
				}]);
				
				//假设目前只允许原始大小为512x256的环境贴图。展开后大小为1024
				//load函数一调用，这个就要存在，所以不能放在下载完成中。
				if (DataTexture2D.lodasatlas) {
					ret.simLodInfo = new Float32Array(40);
					for (var i:int = 0; i < ret.simLodInfo.length; ) {
						ret.simLodInfo[i] = (simLodRect[i] + 0.5) / 1024;	//这时候还不知道多大，假设都是这个值
						i++;
						ret.simLodInfo[i] = (simLodRect[i] + 0.5) / 256;
						i++;
						ret.simLodInfo[i] = Math.max(simLodRect[i] - 1, 0.1) / 1024;
						i++;
						ret.simLodInfo[i] = Math.max(simLodRect[i] - 1.5, 0.1) / 256;	//这个数字是凑出来的
						i++;
					}
				}
				return ret;
			} else if (typeof(w) == 'number') {
				return Laya.loader.create(url, null, null, DataTexture2D, [function(data:*):* {
					this._width = w;
					this._height = h;
					this._buffer = data;
					return null;
				}]);
			} else if (typeof(w) == 'function') {
				return Laya.loader.create(url, null, null, DataTexture2D, [w]);
			} else {
				throw new Error("unknown params.");
			}
		}
		
		/**@private 文件路径全名。*/
		private var _src:String;
		/**@private Imagedata */
		private var _buffer:ArrayBuffer;
		private var _mipmaps:Array;
		/**@private 异步加载锁*/
		private var _recreateLock:Boolean = false;
		/**@private 异步加载完成后是否需要释放（有可能在恢复过程中,再次被释放，用此变量做标记）*/
		private var _needReleaseAgain:Boolean = false;
		
		/**
		 * 获取文件路径全名。
		 */
		public function get src():String {
			return _src;
		}
		
		/**
		 * 创建一个 <code>Texture2D</code> 实例。
		 */
		public function DataTexture2D() {
			super();
			_type = WebGLContext.TEXTURE_2D;
		}
		
		/**
		 * @private
		 */
		private function _onTextureLoaded(buff:ArrayBuffer):void {
		/*
		   this._buffer = buff;
		   var w:int = img.width;
		   var h:int = img.height;
		   _width = w;
		   _height = h;
		   _size = new Size(w, h);
		 */
		}
		
		/**
		 * @private
		 */
		private function _createWebGlTexture():void {
			if (!_buffer && !_mipmaps)
				throw "create GLTextur err:no data";
			
			var gl:WebGLContext = WebGL.mainContext;
			//var exts =  gl.getSupportedExtensions();
			gl.getExtension("EXT_shader_texture_lod");
			var glTexture:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, _type, glTexture);
			
			if (this._mipmaps) {
				if (DataTexture2D.lodasatlas) {
					var infoi:int = 0;
					gl.texImage2D(_type, 0, WebGLContext.RGBA, _width, _height, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, null);
					for (var i:int = 0; i < this._mipmaps.length; i++) {
						if (_mipmaps[i].byteLength != cw * ch * 4) {
							throw "mipmap size error  level:" + i;
						}
						gl.texSubImage2D(_type, 0, simLodRect[infoi++], simLodRect[infoi++], simLodRect[infoi++], simLodRect[infoi++], WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, new Uint8Array(_mipmaps[i]));
					}
					this.minFifter = WebGLContext.LINEAR;
					this.magFifter = WebGLContext.LINEAR;
				} else {
					var cw:int = this._width;
					var ch:int = this._height;
					infoi = 0;
					gl.texImage2D(_type, 0, WebGLContext.RGBA, _width, _height, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, null);
					for (i = 0; i < this._mipmaps.length; i++) {
						if (_mipmaps[i].byteLength != cw * ch * 4) {
							throw "mipmap size error  level:" + i;
						}
						gl.texImage2D(_type, i, WebGLContext.RGBA, cw, ch, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, new Uint8Array(_mipmaps[i]));
						cw /= 2;
						ch /= 2;
						if (cw < 1) cw = 1;
						if (ch < 1) ch = 1;
						this.minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR;
						this.magFifter = WebGLContext.LINEAR;
					}
				}
				this.mipmap = false;
			} else {
				gl.texImage2D(_type, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, new Uint8Array(_buffer));
			}
			
			var minFifter:int = this._minFifter;
			var magFifter:int = this._magFifter;
			var repeat:int = this._repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE;
			
			var isPot:Boolean = Arith.isPOT(w, h);//提前修改内存尺寸，忽悠异步影响
			if (isPot) {
				if (this._mipmap || this._mipmaps)
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				
				gl.texParameteri(_type, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_S, repeat);
				if (this._mipmaps)
					gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
				else
					gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, repeat);
				this._mipmap && gl.generateMipmap(_type);
			} else {
				throw "data texture must be POT";
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			//TODO 需要删除原始数据么
			if (this.src && this.src.length > 0)
				this._buffer = null;
			
			if (isPot)
				memorySize = w * h * 4 * (1 + 1 / 3);//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4;
			_recreateLock = false;
		}
		
		/**
		 * 重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		 */
		override protected function recreateResource():void {
			if (!_buffer && (_src == null || _src === ""))
				return;
			
			_needReleaseAgain = false;
			if (!_buffer && !_mipmaps) {
				_recreateLock = true;
				var _this:DataTexture2D = this;
					//TODO 怎么恢复
			} else {
				if (_recreateLock) {
					return;
				}
				_createWebGlTexture();
				completeCreate();//处理创建完成后相关操作
			}
		}
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var imgdata:*;//width,height,data
			if (params) {
				imgdata = params[0].call(this, data);
			}
			if (imgdata) {
				this._width = imgdata.width;
				this._height = imgdata.height;
				this._buffer = imgdata.data;
			}
			_src = url;
			_size = new Size(this._width, this._height);
			if (_conchTexture) {//NATIVE
				//_conchTexture.setTexture2DImage(_image);
				alert('怎么给runtime传递datatexture数据');
			} else
				activeResource();
			
			_endLoaded();
		}
		
		/**
		 * 返回图片像素。
		 * @return 图片像素。
		 */
		public function getPixels():Uint8Array {
			return new Uint8Array(this._buffer);
		}
		
		/**
		 * 销毁资源。
		 */
		override protected function disposeResource():void {
			if (_recreateLock) {
				_needReleaseAgain = true;
			}
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				_buffer = null;
				memorySize = 0;
			}
		}
	}
}

