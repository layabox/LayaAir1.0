package laya.webgl {
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.filters.ColorFilter;
	import laya.filters.Filter;
	import laya.layagl.CommandEncoder;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaGLRunner;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.HTMLImage;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.ColorUtils;
	import laya.utils.RunDriver;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.resource.Texture2D;
	import laya.webgl.resource.WebGLRTMgr;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.shader.Shader;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.RenderSprite3D;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * @private
	 */
	public class WebGL {
		public static var mainContext:WebGLContext;
		public static var shaderHighPrecision:Boolean;
		public static var _isWebGL2:Boolean = false;
		public static var isNativeRender_enable:Boolean = false;
		
		//TODO:coverage
		private static function _uint8ArraySlice():Uint8Array {
			var _this:* = __JS__("this");
			var sz:int = _this.length;
			var dec:Uint8Array = new Uint8Array(_this.length);
			for (var i:int = 0; i < sz; i++) dec[i] = _this[i];
			return dec;
		}
		
		//TODO:coverage
		private static function _float32ArraySlice():Float32Array {
			var _this:* = __JS__("this");
			var sz:int = _this.length;
			var dec:Float32Array = new Float32Array(_this.length);
			for (var i:int = 0; i < sz; i++) dec[i] = _this[i];
			return dec;
		}
		
		//TODO:coverage
		private static function _uint16ArraySlice(... arg):Uint16Array {
			var _this:* = __JS__("this");
			var sz:int;
			var dec:Uint16Array;
			var i:int;
			if (arg.length === 0) {
				sz = _this.length;
				dec = new Uint16Array(sz);
				for (i = 0; i < sz; i++)
					dec[i] = _this[i];
				
			} else if (arg.length === 2) {
				var start:int = arg[0];
				var end:int = arg[1];
				
				if (end > start) {
					sz = end - start;
					dec = new Uint16Array(sz);
					for (i = start; i < end; i++)
						dec[i - start] = _this[i];
				} else {
					dec = new Uint16Array(0);
				}
			}
			return dec;
		}
		
		public static function _nativeRender_enable():void {
			if (isNativeRender_enable)
				return;
			isNativeRender_enable = true;
			HTMLImage.create = function(width:int, height:int):Bitmap {
				var tex:Texture2D = new Texture2D(width, height, BaseTexture.FORMAT_R8G8B8A8, false, false);
				tex.wrapModeU = BaseTexture.WARPMODE_CLAMP;
				tex.wrapModeV = BaseTexture.WARPMODE_CLAMP;
				return tex;
			}
			WebGLContext.__init_native();
			Shader.prototype.uploadTexture2D = function(value:*):void {
				var CTX:* = WebGLContext;
				CTX.bindTexture(WebGL.mainContext, CTX.TEXTURE_2D, value);
			}
			RenderState2D.width = Browser.window.innerWidth;
			RenderState2D.height = Browser.window.innerHeight;
			RunDriver.measureText = function(txt:String, font:String):* {
				window["conchTextCanvas"].font = font;
				return window["conchTextCanvas"].measureText(txt);
			}
			RunDriver.enableNative = function():void {
				if (Render.supportWebGLPlusRendering) {
					(LayaGLRunner as Object).uploadShaderUniforms = LayaGLRunner.uploadShaderUniformsForNative;
					//替换buffer的函数
					__JS__("CommandEncoder = window.GLCommandEncoder");
					__JS__("LayaGL = window.LayaGLContext");
				}
				var stage:* = Stage;
				stage.prototype.render = stage.prototype.renderToNative;
			}
			RunDriver.clear = function(color:String):void {
				WebGLContext2D.set2DRenderConfig();//渲染2D前要还原2D状态,否则可能受3D影响
				var c:Array = ColorUtils.create(color).arrColor;
				var gl:* = LayaGL.instance;
				if (c) gl.clearColor(c[0], c[1], c[2], c[3]);
				gl.clear(WebGLContext.COLOR_BUFFER_BIT | WebGLContext.DEPTH_BUFFER_BIT | WebGLContext.STENCIL_BUFFER_BIT);
				RenderState2D.clear();
			}
			RunDriver.drawToCanvas = function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
				offsetX -= sprite.x;
				offsetY -= sprite.y;
				offsetX |= 0;
				offsetY |= 0;
				canvasWidth |= 0;
				canvasHeight |= 0;
				
				var canv:HTMLCanvas = new HTMLCanvas(false);
				var ctx:Context = canv.getContext('2d');
				canv.size(canvasWidth, canvasHeight);
				
				ctx.asBitmap = true;
				ctx._targets.start();
				RenderSprite.renders[_renderType]._fun(sprite, ctx, offsetX, offsetY);
				ctx.flush();
				ctx._targets.end();
				ctx._targets.restore();
				return canv;
			}
			RenderTexture2D.prototype._uv = RenderTexture2D.flipyuv;
			Object["defineProperty"](RenderTexture2D.prototype, "uv", {
					"get":function():* {
						return this._uv;
					},
					"set":function(v:*):void {
							this._uv = v;
					}
				}
			);
			HTMLCanvas.prototype.getTexture = function():Texture {
				if (!this._texture) {
					this._texture = this.context._targets;
					this._texture.uv = RenderTexture2D.flipyuv;
					this._texture.bitmap = this._texture;
				}
				return this._texture;
			}
		}
		
		public static function _webglRender_enable():void {
			if (Render.isWebGL) return;
			Render.isWebGL = true;
			
			//替换函数
			//Webgl渲染器的初始化
			RunDriver.initRender = function(canvas:HTMLCanvas, w:int, h:int):Boolean {
				function getWebGLContext(canvas:*):WebGLContext {
					var gl:WebGLContext;
					var names:Array = ["webgl2", "webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
					if (!Config.useWebGL2) {
						names.shift();
					}
					for (var i:int = 0; i < names.length; i++) {
						try {
							gl = canvas.getContext(names[i], {stencil: Config.isStencil, alpha: Config.isAlpha, antialias: Config.isAntialias, premultipliedAlpha: Config.premultipliedAlpha, preserveDrawingBuffer: Config.preserveDrawingBuffer});//antialias为true,premultipliedAlpha为false,IOS和部分安卓QQ浏览器有黑屏或者白屏底色BUG
						} catch (e:*) {
						}
						if (gl) {
							(names[i] === 'webgl2') && (WebGL._isWebGL2 = true);
							new LayaGL();
							return gl;
						}
					}
					return null;
				}
				var gl:WebGLContext = LayaGL.instance = WebGL.mainContext = getWebGLContext(Render._mainCanvas.source);
				if (!gl)
					return false;
				canvas.size(w, h);	//在ctx之后调用。
				WebGLContext.__init__(gl);
				WebGLContext2D.__init__();
				Submit.__init__();
				
				var ctx:WebGLContext2D = new WebGLContext2D();
				Render._context = ctx;
				canvas._setContext(ctx);
				
				WebGL.shaderHighPrecision = false;
				try {//某些浏览器中未实现此函数，使用try catch增强兼容性。
					var precisionFormat:* = gl.getShaderPrecisionFormat(WebGLContext.FRAGMENT_SHADER, WebGLContext.HIGH_FLOAT);
					precisionFormat.precision ? shaderHighPrecision = true : shaderHighPrecision = false;
				} catch (e:*) {
				}
				//TODO 现在有个问题是 gl.deleteTexture并没有走WebGLContex封装的
				LayaGL.instance = gl;
				System.__init__();
				ShaderDefines2D.__init__();
				Value2D.__init__();
				Shader2D.__init__();
				Buffer2D.__int__(gl);
				BlendMode._init_(gl);
				
				return true;
			}
			
			HTMLImage.create = function(width:int, height:int,format:int):Bitmap {
				var tex:Texture2D = new Texture2D(width, height,format, false, false);
				tex.wrapModeU = BaseTexture.WARPMODE_CLAMP;
				tex.wrapModeV = BaseTexture.WARPMODE_CLAMP;
				return tex;
			}
			
			RunDriver.createRenderSprite = function(type:int, next:RenderSprite):RenderSprite {
				return new RenderSprite3D(type, next);
			}
			RunDriver.changeWebGLSize = function(width:Number, height:Number):void {
				WebGL.onStageResize(width, height);
			}
			
			RunDriver.clear = function(color:String):void {
				//修改需要同步到上面的native实现中
				WebGLContext2D.set2DRenderConfig();//渲染2D前要还原2D状态,否则可能受3D影响
				RenderState2D.worldScissorTest && WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
				var ctx:* = Render.context;
				//兼容浏览器
				var c:Array = (ctx._submits._length == 0 || Config.preserveDrawingBuffer) ? ColorUtils.create(color).arrColor : Laya.stage._wgColor;
				if (c) 
					ctx.clearBG(c[0], c[1], c[2], c[3]);
				else
					ctx.clearBG(0, 0, 0, 0);
				RenderState2D.clear();
			}
			
			RunDriver.drawToCanvas = function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
				offsetX -= sprite.x;
				offsetY -= sprite.y;
				offsetX |= 0;
				offsetY |= 0;
				canvasWidth |= 0;
				canvasHeight |= 0;
				var ctx:WebGLContext2D = new WebGLContext2D();
				ctx.size(canvasWidth, canvasHeight);
				ctx.asBitmap = true;
				ctx._targets.start();
				RenderSprite.renders[_renderType]._fun(sprite, ctx, offsetX, offsetY);
				ctx.flush();
				ctx._targets.end();
				ctx._targets.restore();
				var dt:Uint8Array = ctx._targets.getData(0, 0, canvasWidth, canvasHeight);
				ctx.destroy();
				var imgdata:* = __JS__('new ImageData(canvasWidth,canvasHeight);');	//创建空的imagedata。因为下面要翻转，所以不直接设置内容
				//翻转getData的结果。
				var lineLen:int = canvasWidth * 4;
				var temp:Uint8Array = new Uint8Array(lineLen);
				var dst:Uint8Array = imgdata.data;
				var y:int = canvasHeight - 1;
				var off:int = y * lineLen;
				var srcoff:int = 0;
				for (; y >= 0; y--) {
					dst.set(dt.subarray(srcoff, srcoff + lineLen), off);
					off -= lineLen;
					srcoff += lineLen;
				}
				//imgdata.data.set(dt);
				//画到2d画布上
				var canv:HTMLCanvas = new HTMLCanvas(true);
				canv.size(canvasWidth, canvasHeight);
				var ctx2d:Context = canv.getContext('2d');
				__JS__('ctx2d.putImageData(imgdata, 0, 0);');
				return canv;
			}
			
			RunDriver.getTexturePixels = function(value:Texture, x:Number, y:Number, width:Number, height:Number):* {
				var st:int, dst:int,i:int;
				var tex2d:Texture2D = value.bitmap;
				var texw:int = tex2d.width;
				var texh:int = tex2d.height;
				if (x + width > texw) width -= (x + width) - texw;
				if (y + height > texh) height -= (y + height) - texh;
				if (width <= 0 || height <= 0) return null;
			
				var wstride:int = width * 4;
				var pix:Uint8Array = null;
				try {
					pix = tex2d.getPixels();
				}catch (e:*) {
				}
				if (pix) {
					if(x==0&&y==0&&width==texw&&height==texh)
						return pix;
					//否则只取一部分
					var ret:Uint8Array = new Uint8Array(width * height * 4);
					wstride = texw * 4;
					st= x*4;
					dst = (y+height-1)*wstride+x*4;
					for (i = height - 1; i >= 0; i--) {
						ret.set(dt.slice(dst, dst + width*4),st);
						st += wstride;
						dst -= wstride;
					}
					return ret;
				}
				
				// 如果无法直接获取，只能先渲染出来
				var ctx:WebGLContext2D = new WebGLContext2D();
				ctx.size(width, height);
				ctx.asBitmap = true;
				var uv:Array = null;
				if (x != 0 || y != 0 || width != texw || height != texh) {
					uv = value.uv.concat();	// 复制一份uv
					var stu:Number = uv[0];
					var stv:Number = uv[1];
					var uvw:Number = uv[2] - stu;
					var uvh:Number = uv[7] - stv;
					var uk:Number = uvw / texw;
					var vk:Number = uvh / texh;
					uv = [
						stu + x * uk, 			stv + y * vk,
						stu + (x + width) * uk, stv + y * vk,
						stu + (x + width) * uk, stv + (y + height) * vk,
						stu + x * uk,			stv + (y + height) * vk,
					];
				}
				(ctx as WebGLContext2D)._drawTextureM(value, 0, 0, width, height, null, 1.0, uv); 
				//ctx.drawTexture(value, -x, -y, x + width, y + height);
				ctx._targets.start();
				ctx.flush();
				ctx._targets.end();
				ctx._targets.restore();
				var dt:Uint8Array = ctx._targets.getData(0, 0, width, height);
				ctx.destroy();
				// 上下颠倒一下
				ret = new Uint8Array(width * height * 4);
				st = 0;
				dst = (height-1)*wstride;
				for (i = height - 1; i >= 0; i--) {
					ret.set(dt.slice(dst, dst + wstride),st);
					st += wstride;
					dst -= wstride;
				}
				return ret;
			}
			
			Filter._filter = function(sprite:Sprite, context:*, x:Number, y:Number):void {
				var webglctx:WebGLContext2D = context as WebGLContext2D;
				var next:* = this._next;
				if (next) {
					var filters:Array = sprite.filters, len:int = filters.length;
					//如果只有一个滤镜，那么还用原来的方式
					if (len == 1 && (filters[0].type == Filter.COLOR)) {
						context.save();
						context.setColorFilter(filters[0]);
						next._fun.call(next, sprite, context, x, y);
						context.restore();
						return;
					}
					//思路：依次遍历滤镜，每次滤镜都画到out的RenderTarget上，然后把out画取src的RenderTarget做原图，去叠加新的滤镜
					var svCP:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);	//拷贝用shaderValue
					var b:Rectangle;
					
					var p:Point = Point.TEMP;
					var tMatrix:Matrix = webglctx._curMat;
					var mat:Matrix = Matrix.create();
					tMatrix.copyTo(mat);
					var tPadding:int = 0;	//给glow用
					var tHalfPadding:int = 0;
					var tIsHaveGlowFilter:Boolean = false;
					//这里判断是否存储了out，如果存储了直接用;
					var source:RenderTexture2D = null;
					var out:RenderTexture2D = sprite._cacheStyle.filterCache || null;
					if (!out || sprite.getRepaint() != 0) {
						tIsHaveGlowFilter = sprite._isHaveGlowFilter();
						//glow需要扩展边缘
						if (tIsHaveGlowFilter) {
							tPadding = 50;
							tHalfPadding = 25;
						}
						b = new Rectangle();
						b.copyFrom(sprite.getSelfBounds());
						b.x += sprite.x;
						b.y += sprite.y;
						b.x -= sprite.pivotX + 4;//blur 
						b.y -= sprite.pivotY + 4;//blur
						var tSX:Number = b.x;
						var tSY:Number = b.y;
						//重新计算宽和高
						b.width += (tPadding + 8);//增加宽度 blur  由于blur系数为9
						b.height += (tPadding + 8);//增加高度 blur
						p.x = b.x * mat.a + b.y * mat.c;
						p.y = b.y * mat.d + b.x * mat.b;
						b.x = p.x;
						b.y = p.y;
						p.x = b.width * mat.a + b.height * mat.c;
						p.y = b.height * mat.d + b.width * mat.b;
						b.width = p.x;
						b.height = p.y;
						if (b.width <= 0 || b.height <= 0) {
							return;
						}
						out && WebGLRTMgr.releaseRT(out);// out.recycle();
						source = WebGLRTMgr.getRT(b.width, b.height);
						var outRT:RenderTexture2D = out = WebGLRTMgr.getRT(b.width, b.height);
						sprite._getCacheStyle().filterCache = out;
						//使用RT
						webglctx.pushRT();
						webglctx.useRT(source);
						var tX:Number = sprite.x - tSX + tHalfPadding;
						var tY:Number = sprite.y - tSY + tHalfPadding;
						//执行节点的渲染
						next._fun.call(next, sprite, context, tX, tY);
						webglctx.useRT(outRT);
						for (var i:int = 0; i < len; i++) {
							if (i != 0) {
								//把out往src上画。这只是一个拷贝的过程，下面draw(src) to outRT 才是真正的应用filter
								//由于是延迟执行，不能直接在这里swap。 TODO 改成延迟swap
								webglctx.useRT(source);
								webglctx.drawTarget(outRT, 0, 0, b.width, b.height, Matrix.TEMP.identity(), svCP, null, BlendMode.TOINT.overlay);
								webglctx.useRT(outRT);
							}
							var fil:Filter = filters[i];
							//把src往out上画
							switch (fil.type) {
							case Filter.BLUR: 
								fil._glRender && fil._glRender.render(source, context, b.width, b.height, fil);
								//BlurFilterGLRender.render(source, context, b.width, b.height, fil as BlurFilter);
								break;
							case Filter.GLOW: 
								//GlowFilterGLRender.render(source, context, b.width, b.height, fil as GlowFilter);
								fil._glRender && fil._glRender.render(source, context, b.width, b.height, fil);
								break;
							case Filter.COLOR: 
								webglctx.setColorFilter(fil as ColorFilter);
								webglctx.drawTarget(source, 0, 0, b.width, b.height, Matrix.EMPTY.identity(), Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
								webglctx.setColorFilter(null);
								break;
							}
						}
						webglctx.popRT();
					} else {
						tIsHaveGlowFilter = sprite._cacheStyle.hasGlowFilter || false;
						if (tIsHaveGlowFilter) {
							tPadding = 50;
							tHalfPadding = 25;
						}
						b = sprite.getBounds();
						if (b.width <= 0 || b.height <= 0) {
							return;
						}
						b.width += tPadding;
						b.height += tPadding;
						p.x = b.x * mat.a + b.y * mat.c;
						p.y = b.y * mat.d + b.x * mat.b;
						b.x = p.x;
						b.y = p.y;
						p.x = b.width * mat.a + b.height * mat.c;
						p.y = b.height * mat.d + b.width * mat.b;
						b.width = p.x;
						b.height = p.y;
							//scope.addValue("out", out);
					}
					x = x - tHalfPadding - sprite.x;
					y = y - tHalfPadding - sprite.y;
					p.setTo(x, y);
					mat.transformPoint(p);
					x = p.x + b.x;
					y = p.y + b.y;
					//把最后的out纹理画出来
					webglctx._drawRenderTexture(out, x, y, b.width, b.height, Matrix.TEMP.identity(), 1.0, RenderTexture2D.defuv);
					
					//把对象放回池子中
					//var submit:SubmitCMD = SubmitCMD.create([scope], Filter._recycleScope, this);
					if(source){
						var submit:SubmitCMD = SubmitCMD.create([source], function(s:Texture2D):void{
							s.destroy();
						}, this);
						source = null;
						context.addRenderObject(submit);
					}
					mat.destroy();
				}
			}
			
			HTMLCanvas.prototype.getTexture = function():Texture {
				if (!this._texture) {
					var bitmap:Texture2D = new Texture2D();
					bitmap.loadImageSource(this.source);
					this._texture = new Texture(bitmap);
				}
				return this._texture;
			}
			
			Float32Array.prototype.slice || (Float32Array.prototype.slice = _float32ArraySlice);
			Uint16Array.prototype.slice || (Uint16Array.prototype.slice = _uint16ArraySlice);
			Uint8Array.prototype.slice || (Uint8Array.prototype.slice = _uint8ArraySlice);
		}
		
		//使用webgl渲染器
		public static function enable():Boolean {
			Browser.__init__();
			if (!Browser._supportWebGL)
				return false;
			_webglRender_enable();
			if (Render.isConchApp) 
			{
				_nativeRender_enable();
			}
			return true;
		}
		
		public static function onStageResize(width:Number, height:Number):void {
			if (mainContext == null) return;
			mainContext.viewport(0, 0, width, height);
			RenderState2D.width = width;
			RenderState2D.height = height;
		}
	}
}

