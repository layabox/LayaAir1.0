package laya.webgl.text {
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.CharRenderInfo;
	public class TextTexture  extends Resource {
		private static var pool:Array = new Array(10);		// 回收用
		private static var poolLen:int = 0;
		private static var cleanTm:Number = 0;
		
		public  var _source:*;	// webgl 贴图
		public  var _texW:int = 0;
		public  var _texH:int = 0;
		public  var __destroyed:Boolean = false;	//父类有，但是private
		public  var _discardTm:Number = 0;			//释放的时间。超过一定时间会被真正删除
		public  var genID:int = 0; 				// 这个对象会重新利用，为了能让引用他的人知道自己引用的是否有效，加个id
		public  var bitmap:*= { id:0,_glTexture:null};						//samekey的判断用的
		public  var curUsedCovRate:Number = 0; 	// 当前使用到的使用率。根据面积算的
		public  var curUsedCovRateAtlas:Number = 0; 	// 大图集中的占用率。由于大图集分辨率低，所以会浪费一些空间
		public  var lastTouchTm:int = 0;
		public  var ri:CharRenderInfo=null; 		// 如果是独立文字贴图的话带有这个信息
		
		public function TextTexture(textureW:int, textureH:int) {
			super();
			_texW = textureW || TextRender.atlasWidth;
			_texH = textureH || TextRender.atlasWidth;
			bitmap.id = id;
			lock = true;//防止被资源管理清除
		}
		
		public function recreateResource():void {
			if (_source)
				return;
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			bitmap._glTexture = glTex;
			
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTex);
			//gl.bindTexture(WebGLContext.TEXTURE_2D, glTex);
			//var sz:int = _width * _height * 4;
			//分配显存。
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _texW, _texH, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, null);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);	//不能用点采样，否则旋转的时候，非常难看
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			
			//TODO 预乘alpha
			if (TextRender.debugUV) {
				fillWhite();
			}
		}
		
		/**
		 * 
		 * @param	data
		 * @param	x			拷贝位置。
		 * @param	y
		 * @param  uv  
		 * @return uv数组  如果uv不为空就返回传入的uv，否则new一个数组
		 */
		public function addChar(data:ImageData, x:int, y:int, uv:Array = null):Array {
			//if (!Render.isConchApp &&  !__JS__('(data instanceof ImageData)')) {
			if( TextRender.isWan1Wan){
				return addCharCanvas(data , x, y, uv);
			}
			!_source && recreateResource();
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true);
			var dt:* = data.data;
			if ( __JS__('data.data instanceof Uint8ClampedArray') ) 
				dt = new Uint8Array(dt.buffer);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, x, y, data.width, data.height, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, dt);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false);
			var u0:Number;
			var v0:Number;
			var u1:Number;
			var v1:Number;
			if(Render.isConchApp){
				u0 = x / _texW;	// +1 表示内缩一下，反正文字总是有留白。否则会受到旁边的一个像素的影响
				v0 = y / _texH;
				u1 = (x + data.width) / _texW;	// 注意是-1,不是-2
				v1 = (y + data.height) / _texH;
			}else{
				u0 = (x+1) / _texW;	// +1 表示内缩一下，反正文字总是有留白。否则会受到旁边的一个像素的影响
				v0 = (y) / _texH;
				u1 = (x + data.width-1) / _texW;	// 注意是-1,不是-2
				v1 = (y + data.height-1) / _texH;
			}
			uv = uv || new Array(8);
			uv[0] = u0,	uv[1] = v0;
			uv[2] = u1, uv[3] = v0;
			uv[4] = u1, uv[5] = v1;
			uv[6] = u0, uv[7] = v1;
			return uv;
		}
		 
		/**
		 * 玩一玩不支持 getImageData
		 * @param	canv
		 * @param	x
		 * @param	y
		 */
		public function addCharCanvas(canv:Object, x:int, y:int,uv:Array=null):Array {
			!_source && recreateResource();
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, x, y, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, canv);
			!Render.isConchApp && gl.pixelStorei( WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false);
			var u0:Number;
			var v0:Number;
			var u1:Number;
			var v1:Number;
			if(Render.isConchApp){
				u0 = x / _texW;		// +1 表示内缩一下，反正文字总是有留白。否则会受到旁边的一个像素的影响
				v0 = y / _texH;
				u1 = (x + canv.width) / _texW;
				v1 = (y + canv.height) / _texH;
			}else{
				u0 = (x+1) / _texW;		// +1 表示内缩一下，反正文字总是有留白。否则会受到旁边的一个像素的影响
				v0 = (y+1) / _texH;
				u1 = (x + canv.width-1) / _texW;
				v1 = (y + canv.height-1) / _texH;
			}
			uv = uv || new Array(8);
			uv[0] = u0,	uv[1] = v0;
			uv[2] = u1, uv[3] = v0;
			uv[4] = u1, uv[5] = v1;
			uv[6] = u0, uv[7] = v1;
			return uv;
		}
		
		/**
		 * 填充白色。调试用。
		 */
		public function fillWhite():void {
			!_source && recreateResource();
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			var dt:Uint8Array = new Uint8Array(_texW * _texH * 4);
			(dt as Object).fill(0xff);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, 0, 0, _texW, _texH, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, dt);
		}
		
		public function discard():void {
			// 非标准大小不回收。
			if (_texW != TextRender.atlasWidth || _texH != TextRender.atlasWidth) {
				destroy();
				return;
			}
			genID++;
			if (poolLen >= pool.length) {
				pool = pool.concat(new Array(10));
			}
			_discardTm = Laya.stage.getFrameTm();
			pool[poolLen++] = this;
		}
		
		public static function getTextTexture(w:int, h:int):TextTexture {
			if ( w != TextRender.atlasWidth || w != TextRender.atlasWidth )
				return new TextTexture(w, h);
			// 否则从回收池中取
			if (poolLen > 0) {
				var ret:TextTexture = pool[--poolLen];
				if (poolLen > 0)
					clean();	//给个clean的机会。
				return ret;
			}
			return new TextTexture(w, h);
		}
		
		override public function destroy():void {		
			console.log('destroy TextTexture');
			__destroyed = true;
			var gl:WebGLContext = Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
			_source && gl.deleteTexture(_source);
			_source = null;
		}		
		
		/**
		 * 定期清理
		 * 为了简单，只有发生 getAPage 或者 discardPage的时候才检测是否需要清理
		 */
		public static function clean():void {
			var curtm:Number = Laya.stage.getFrameTm();
			if (cleanTm === 0) cleanTm = curtm;
			if (curtm - cleanTm >= TextRender.checkCleanTextureDt) {	//每10秒看看pool中的贴图有没有很老的可以删除的
				for (var i:int = 0; i < poolLen; i++) {
					var p:TextTexture = pool[i];
					if (curtm - p._discardTm >= TextRender.destroyUnusedTextureDt) {//超过20秒没用的删掉
						p.destroy();					//真正删除贴图
						pool[i] = pool[poolLen - 1];
						poolLen--;
						i--;	//这个还要处理，用来抵消i++
					}
				}
				cleanTm = curtm;
			}
		}	
		
		public function touchRect(ri:CharRenderInfo, curloop:int):void {		
			if ( lastTouchTm != curloop) {
				curUsedCovRate = 0;
				curUsedCovRateAtlas = 0;
				lastTouchTm = curloop;
			}
			var texw2:Number = TextRender.atlasWidth * TextRender.atlasWidth;
			var gridw2:Number = TextAtlas.atlasGridW * TextAtlas.atlasGridW;
			curUsedCovRate+= (ri.bmpWidth * ri.bmpHeight) / texw2;
			curUsedCovRateAtlas += ( Math.ceil(ri.bmpWidth / TextAtlas.atlasGridW ) * Math.ceil(ri.bmpHeight / TextAtlas.atlasGridW)) / (texw2 / gridw2);
		}
		
		// 为了与当前的文字渲染兼容的补丁
		public function get texture():* {
			return this;
		}
		public function _getSource():*{	
			return _source;
		}
		
		// for debug
		public function drawOnScreen(x:int, y:int):void {
			
		}
	}
}	