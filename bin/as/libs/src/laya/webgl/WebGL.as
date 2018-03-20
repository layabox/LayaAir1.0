package laya.webgl {
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.filters.Filter;
	import laya.filters.IFilterAction;
	import laya.filters.webgl.ColorFilterActionGL;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.HTMLImage;
	import laya.resource.HTMLSubImage;
	import laya.resource.ResourceManager;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Color;
	import laya.utils.RunDriver;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.atlas.AtlasWebGLCanvas;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.display.GraphicsGL;
	import laya.webgl.resource.IMergeAtlasBitmap;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.resource.WebGLCanvas;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.resource.WebGLSubImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.Shader2X;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.skinAnishader.SkinMesh;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCMDScope;
	import laya.webgl.text.DrawText;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.GlUtils;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.RenderSprite3D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * @private
	 */
	public class WebGL {
		/**@private */
		public static var compressAstc:Object;
		/**@private */
		public static var compressAtc:Object;
		/**@private */
		public static var compressEtc:Object;
		/**@private */
		public static var compressEtc1:Object;
		/**@private */
		public static var compressPvrtc:Object;
		/**@private */
		public static var compressS3tc:Object;
		/**@private */
		public static var compressS3tc_srgb:Object;
		
		public static var mainCanvas:HTMLCanvas;
		public static var mainContext:WebGLContext;
		public static var antialias:Boolean = true;
		/**Shader是否支持高精度。 */
		public static var shaderHighPrecision:Boolean;
		
		private static var _bg_null:Array =/*[STATIC SAFE]*/ [0, 0, 0, 0];
		
		private static function _uint8ArraySlice():Uint8Array {
			var _this:* = __JS__("this");
			var sz:int = _this.length;
			var dec:Uint8Array = new Uint8Array(_this.length);
			for (var i:int = 0; i < sz; i++) dec[i] = _this[i];
			return dec;
		}
		
		private static function _float32ArraySlice():Float32Array {
			var _this:* = __JS__("this");
			var sz:int = _this.length;
			var dec:Float32Array = new Float32Array(_this.length);
			for (var i:int = 0; i < sz; i++) dec[i] = _this[i];
			return dec;
		}
		
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
		
		private static function expandContext():void {
			var from:* = Context.prototype;
			var to:* = __JS__("CanvasRenderingContext2D.prototype");
			to.fillTrangles = from.fillTrangles;
			Buffer2D.__int__(null);
			to.setIBVB = function(x:Number, y:Number, ib:IndexBuffer2D, vb:VertexBuffer2D, numElement:int, mat:Matrix, shader:Shader, shaderValues:ShaderValue, startIndex:int = 0, offset:int = 0):void {
				if (ib === null) {
					this._ib = this._ib || IndexBuffer2D.QuadrangleIB;
					ib = this._ib;
					GlUtils.expandIBQuadrangle(ib, (vb._byteLength / (4 * 16) + 8));
				}
				this._setIBVB(x, y, ib, vb, numElement, mat, shader, shaderValues, startIndex, offset);
			};
			
			to.fillTrangles = function(tex:Texture, x:Number, y:Number, points:Array, m:Matrix):void {
				this._curMat = this._curMat || Matrix.create();
				this._vb = this._vb || VertexBuffer2D.create();
				if (!this._ib) {
					this._ib = IndexBuffer2D.create();
					GlUtils.fillIBQuadrangle(this._ib, length / 4);
				}
				var vb:VertexBuffer2D = this._vb;
				var length:int = points.length >> 4;
				GlUtils.fillTranglesVB(vb, x, y, points, m || this._curMat, 0, 0);
				GlUtils.expandIBQuadrangle(this._ib, (vb._byteLength / (4 * 16) + 8));
				var shaderValues:Value2D = new Value2D(0x01, 0);//     Value2D.create(0x01, 0);
				shaderValues.textureHost = tex;
				//var sd = RenderState2D.worldShaderDefines?shaderValues._withWorldShaderDefines():(Shader.sharders [shaderValues.mainID | shaderValues.defines._value] );
				
				//var sd = new Shader2X("attribute vec4 position; attribute vec2 texcoord; uniform vec2 size; uniform mat4 mmat; varying vec2 v_texcoord; void main() { vec4 pos=mmat*position; gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0); v_texcoord = texcoord; }", "precision mediump float; varying vec2 v_texcoord; uniform sampler2D texture; void main() { vec4 color= texture2D(texture, v_texcoord); color.a*=1.0; gl_FragColor=color; }");
				
				var sd:Shader = new Shader2X("attribute vec2 position; attribute vec2 texcoord; uniform vec2 size; uniform mat4 mmat; varying vec2 v_texcoord; void main() { vec4 p=vec4(position.xy,0.0,1.0);vec4 pos=mmat*p; gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0); v_texcoord = texcoord; }", "precision mediump float; varying vec2 v_texcoord; uniform sampler2D texture; void main() {vec4 color= texture2D(texture, v_texcoord); color.a*=1.0; gl_FragColor= color;}");
				
				__JS__("vb._vertType =3");//表示使用XYUV
				this._setIBVB(x, y, this._ib, vb, length * 6, m, sd, shaderValues, 0, 0);
			}
		}
		
		public static function enable():Boolean {
			Browser.__init__();
			if (Render.isConchApp) {
				if (!Render.isConchWebGL) {
					RunDriver.skinAniSprite = function():* {
						var tSkinSprite:SkinMesh = new SkinMesh()
						return tSkinSprite;
					}
					expandContext();
					return false;
				}
			}
			
			RunDriver.getWebGLContext = function getWebGLContext(canvas:*):WebGLContext {
				var gl:WebGLContext;
				var names:Array = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
				for (var i:int = 0; i < names.length; i++) {
					try {
						gl = canvas.getContext(names[i], {stencil: Config.isStencil, alpha: Config.isAlpha, antialias: Config.isAntialias, premultipliedAlpha: Config.premultipliedAlpha, preserveDrawingBuffer: Config.preserveDrawingBuffer});//antialias为true,premultipliedAlpha为false,IOS和部分安卓QQ浏览器有黑屏或者白屏底色BUG
					} catch (e:*) {
					}
					if (gl)
						return gl;
				}
				return null;
			}
			
			mainContext = RunDriver.getWebGLContext(Render._mainCanvas);
			if (mainContext == null)
				return false;
			
			if (Render.isWebGL) return true;
			
			HTMLImage.create = function(src:String, def:* = null):HTMLImage {
				return new WebGLImage(src, def);
			}
			
			HTMLSubImage.create = function(canvas:*, offsetX:int, offsetY:int, width:int, height:int, atlasImage:*, src:String):WebGLSubImage {
				return new WebGLSubImage(canvas, offsetX, offsetY, width, height, atlasImage, src);
			}
			
			Render.WebGL = WebGL;
			Render.isWebGL = true;
			
			DrawText.__init__();
			
			RunDriver.createRenderSprite = function(type:int, next:RenderSprite):RenderSprite {
				return new RenderSprite3D(type, next);
			}
			RunDriver.createWebGLContext2D = function(c:HTMLCanvas):WebGLContext2D {
				return new WebGLContext2D(c);
			}
			RunDriver.changeWebGLSize = function(width:Number, height:Number):void {
				WebGL.onStageResize(width, height);
			}
			RunDriver.createGraphics = function():GraphicsGL {
				return new GraphicsGL();
			}
			
			var action:* = RunDriver.createFilterAction;
			RunDriver.createFilterAction = action ? action : function(type:int):IFilterAction {
				return new ColorFilterActionGL()
			}
			
			RunDriver.clear = function(color:String):void {
				RenderState2D.worldScissorTest && WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
				var ctx:* = Render.context.ctx;
				//兼容浏览器
				var c:Array = (ctx._submits._length == 0 || Config.preserveDrawingBuffer) ? Color.create(color)._color : Stage._wgColor;
				if (c) ctx.clearBG(c[0], c[1], c[2], c[3]);
				RenderState2D.clear();
			}
			
			RunDriver.addToAtlas = function(texture:Texture, force:Boolean = false):void {
				var bitmap:Bitmap = texture.bitmap;
				if (!Render.optimizeTextureMemory(texture.url, texture)) {
					(bitmap as IMergeAtlasBitmap).enableMerageInAtlas = false;
					return;
				}
				
				if ((bitmap is IMergeAtlasBitmap) && ((bitmap as IMergeAtlasBitmap).allowMerageInAtlas)) {
					bitmap.on(Event.RECOVERED, texture, texture.addTextureToAtlas);
				}
			}
			
			RunDriver.isAtlas = function(bitmap:*):Boolean{
				return bitmap is AtlasWebGLCanvas;
			}
			
			AtlasResourceManager._enable();
			
			RunDriver.beginFlush = function():void {
				var atlasResourceManager:AtlasResourceManager = AtlasResourceManager.instance;
				var count:int = atlasResourceManager.getAtlaserCount();
				for (var i:int = 0; i < count; i++) {
					var atlerCanvas:AtlasWebGLCanvas = atlasResourceManager.getAtlaserByIndex(i).texture;
					(atlerCanvas._flashCacheImageNeedFlush) && (RunDriver.flashFlushImage(atlerCanvas));
				}
			}
			
			RunDriver.drawToCanvas = function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
				if (canvasWidth <= 0 || canvasHeight <= 0) {
					trace("[error] canvasWidth and canvasHeight should greater than zero");	
				}
				offsetX -= sprite.x;
				offsetY -= sprite.y;
				var renderTarget:RenderTarget2D = RenderTarget2D.create(canvasWidth, canvasHeight, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, 0, false);
				renderTarget.start();
				renderTarget.clear(0, 0, 0, 0);
				Render.context.clear();	
				RenderSprite.renders[_renderType]._fun(sprite, Render.context, offsetX, RenderState2D.height - canvasHeight + offsetY);
				Render.context.flush();
				renderTarget.end();
				var pixels:Uint8Array = renderTarget.getData(0, 0, renderTarget.width, renderTarget.height);
				renderTarget.recycle();
				
				var htmlCanvas:* = new WebGLCanvas();
				htmlCanvas._canvas = Browser.createElement("canvas");
				htmlCanvas.size(canvasWidth, canvasHeight);
				var context:* = htmlCanvas._canvas.getContext('2d');
				
				Browser.canvas.size(canvasWidth, canvasHeight);
				var tempContext:* = Browser.context;
				var imgData:* = tempContext.createImageData(canvasWidth, canvasHeight);
				imgData.data.set(__JS__("new Uint8ClampedArray(pixels.buffer)"));
				htmlCanvas._imgData = imgData;
				//下面的事情最好是在getCanvas的时候再做。反正一般也不会调用。这里太啰嗦了
				tempContext.putImageData(imgData, 0, 0);
				
				context.save();
				context.translate(0, canvasHeight);
				context.scale(1, -1);
				context.drawImage(Browser.canvas.source, 0, 0);
				context.restore();
				
				return htmlCanvas;
			}
			
			RunDriver.createFilterAction = function(type:int):* {
				var action:*;
				switch (type) {
				case Filter.COLOR: 
					action = new ColorFilterActionGL();
					break;
				}
				return action;
			}
			
			RunDriver.addTextureToAtlas = function(texture:Texture):void {
				texture._uvID++;
				AtlasResourceManager._atlasRestore++;
				((texture.bitmap as IMergeAtlasBitmap).enableMerageInAtlas) && (AtlasResourceManager.instance.addToAtlas(texture));//资源恢复时重新加入大图集
			}
			
			RunDriver.getTexturePixels = function(value:Texture, x:Number, y:Number, width:Number, height:Number):Array {
				(Render.context.ctx as WebGLContext2D).clear();
				var tSprite:Sprite = new Sprite();
				tSprite.graphics.drawTexture(value, -x, -y);
				
				//启用RenderTarget2D，把精灵上的内容画上去
				var tRenderTarget:RenderTarget2D = RenderTarget2D.create(width, height);
				tRenderTarget.start();
				tRenderTarget.clear(0, 0, 0, 0);
				tSprite.render(Render.context, 0, 0);
				(Render.context.ctx as WebGLContext2D).flush();
				tRenderTarget.end();
				var tUint8Array:Uint8Array = tRenderTarget.getData(0, 0, width, height);
				
				var tArray:Array = [];
				var tIndex:int = 0;
				for (var i:int = height - 1; i >= 0; i--) {
					for (var j:int = 0; j < width; j++) {
						tIndex = (i * width + j) * 4;
						tArray.push(tUint8Array[tIndex]);
						tArray.push(tUint8Array[tIndex + 1]);
						tArray.push(tUint8Array[tIndex + 2]);
						tArray.push(tUint8Array[tIndex + 3]);
					}
				}
				return tArray;
			}
			RunDriver.skinAniSprite = function():* {
				var tSkinSprite:SkinMesh = new SkinMesh()
				return tSkinSprite;
			}
			
			/**
			 * 临时。只是给小游戏用，以后考虑一个正规方法。
			 */
			HTMLCanvas.create = function(type:String, canvas:*= null):WebGLCanvas {
				var ret:WebGLCanvas = new WebGLCanvas();
				ret._imgData = canvas;
				ret.flipY = false;
				return ret;
			}

			
			Filter._filterStart = function(scope:SubmitCMDScope, sprite:*, context:RenderContext, x:Number, y:Number):void {
				var b:Rectangle = scope.getValue("bounds");
				var source:RenderTarget2D = RenderTarget2D.create(b.width, b.height);
				source.start();
				source.clear(0, 0, 0, 0);
				scope.addValue("src", source);
				
				scope.addValue("ScissorTest", RenderState2D.worldScissorTest);
				if (RenderState2D.worldScissorTest) {
					var tClilpRect:Rectangle = new Rectangle();
					tClilpRect.copyFrom((context.ctx as WebGLContext2D)._clipRect)
					scope.addValue("clipRect", tClilpRect);
					RenderState2D.worldScissorTest = false;
					WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
				}
			}
			
			Filter._filterEnd = function(scope:SubmitCMDScope, sprite:*, context:RenderContext, x:Number, y:Number):void {
				var b:Rectangle = scope.getValue("bounds");
				var source:RenderTarget2D = scope.getValue("src");
				source.end();
				var out:RenderTarget2D = RenderTarget2D.create(b.width, b.height);
				out.start();
				out.clear(0, 0, 0, 0);
				scope.addValue("out", out);
				sprite._set$P('_filterCache', out);
				sprite._set$P('_isHaveGlowFilter', scope.getValue("_isHaveGlowFilter"));
			}
			
			Filter._EndTarget = function(scope:SubmitCMDScope, context:RenderContext):void {
				var source:RenderTarget2D = scope.getValue("src");
				source.recycle();
				var out:RenderTarget2D = scope.getValue("out");
				out.end();
				var b:Boolean = scope.getValue("ScissorTest");
				if (b) {
					RenderState2D.worldScissorTest = true;
					WebGL.mainContext.enable(WebGLContext.SCISSOR_TEST);
					context.ctx.save();
					var tClipRect:Rectangle = scope.getValue("clipRect");
					(context.ctx as WebGLContext2D).clipRect(tClipRect.x, tClipRect.y, tClipRect.width, tClipRect.height);
				}
			}
			
			Filter._useSrc = function(scope:SubmitCMDScope):void {
				var source:RenderTarget2D = scope.getValue("out");
				source.end();
				source = scope.getValue("src");
				source.start();
				source.clear(0, 0, 0, 0);
			}
			
			Filter._endSrc = function(scope:SubmitCMDScope):void {
				var source:RenderTarget2D = scope.getValue("src");
				source.end();
			}
			
			Filter._useOut = function(scope:SubmitCMDScope):void {
				var source:RenderTarget2D = scope.getValue("src");
				source.end();
				source = scope.getValue("out");
				source.start();
				source.clear(0, 0, 0, 0);
			}
			
			Filter._endOut = function(scope:SubmitCMDScope):void {
				var source:RenderTarget2D = scope.getValue("out");
				source.end();
			}
			
			//scope:SubmitCMDScope
			Filter._recycleScope = function(scope:SubmitCMDScope):void {
				scope.recycle();
			}
			
			Filter._filter = function(sprite:*, context:*, x:Number, y:Number):void {
				var next:* = this._next;
				if (next) {
					var filters:Array = sprite.filters, len:int = filters.length;
					//如果只有对象只有一个滤镜，那么还用原来的方式
					if (len == 1 && (filters[0].type == Filter.COLOR)) {
						context.ctx.save();
						context.ctx.setFilters([filters[0]]);
						next._fun.call(next, sprite, context, x, y);
						context.ctx.restore();
						return;
					}
					//思路：依次遍历滤镜，每次滤镜都画到out的RenderTarget上，然后把out画取src的RenderTarget做原图，去叠加新的滤镜
					var shaderValue:Value2D
					var b:Rectangle;
					var scope:SubmitCMDScope = SubmitCMDScope.create();
					
					var p:Point = Point.TEMP;
					var tMatrix:Matrix = context.ctx._getTransformMatrix();
					var mat:Matrix = Matrix.create();
					tMatrix.copyTo(mat);
					var tPadding:int = 0;
					var tHalfPadding:int = 0;
					var tIsHaveGlowFilter:Boolean = false;
					//这里判断是否存储了out，如果存储了直接用;
					var out:RenderTarget2D = sprite._$P._filterCache ? sprite._$P._filterCache : null;
					if (!out || sprite._repaint) {
						tIsHaveGlowFilter = sprite._isHaveGlowFilter();
						scope.addValue("_isHaveGlowFilter", tIsHaveGlowFilter);
						if (tIsHaveGlowFilter) {
							tPadding = 50;
							tHalfPadding = 25;
						}
						b = new Rectangle();
						b.copyFrom((sprite as Sprite).getSelfBounds());
						b.x += (sprite as Sprite).x;
						b.y += (sprite as Sprite).y;
						b.x -= (sprite as Sprite).pivotX + 4;//blur 
						b.y -= (sprite as Sprite).pivotY + 4;//blur
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
						out && out.recycle();
						scope.addValue("bounds", b);
						var submit:SubmitCMD = SubmitCMD.create([scope, sprite, context, 0, 0], Filter._filterStart);
						context.addRenderObject(submit);
						(context.ctx as WebGLContext2D)._renderKey = 0;
						(context.ctx as WebGLContext2D)._shader2D.glTexture = null;//绘制前置空下，保证不会被打包进上一个序列
						var tX:Number = sprite.x - tSX + tHalfPadding;
						var tY:Number = sprite.y - tSY + tHalfPadding;
						next._fun.call(next, sprite, context, tX, tY);
						submit = SubmitCMD.create([scope, sprite, context, 0, 0], Filter._filterEnd);
						context.addRenderObject(submit);
						for (var i:int = 0; i < len; i++) {
							if (i != 0) {
								//把out画到src上
								submit = SubmitCMD.create([scope], Filter._useSrc);
								context.addRenderObject(submit);
								shaderValue = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
								Matrix.TEMP.identity();
								context.ctx.drawTarget(scope, 0, 0, b.width, b.height, Matrix.TEMP, "out", shaderValue, null, BlendMode.TOINT.overlay);
								submit = SubmitCMD.create([scope], Filter._useOut);
								context.addRenderObject(submit);
							}
							var fil:* = filters[i];
							fil.action.apply3d(scope, sprite, context, 0, 0);
						}
						submit = SubmitCMD.create([scope, context], Filter._EndTarget);
						context.addRenderObject(submit);
					} else {
						tIsHaveGlowFilter = sprite._$P._isHaveGlowFilter ? sprite._$P._isHaveGlowFilter : false;
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
						scope.addValue("out", out);
					}
					x = x - tHalfPadding - sprite.x;
					y = y - tHalfPadding - sprite.y;
					p.setTo(x, y);
					mat.transformPoint(p);
					x = p.x + b.x;
					y = p.y + b.y;
					shaderValue = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
					//把最后的out纹理画出来
					Matrix.TEMP.identity();
					(context.ctx as WebGLContext2D).drawTarget(scope, x, y, b.width, b.height, Matrix.TEMP, "out", shaderValue, null, BlendMode.TOINT.overlay);
					
					//把对象放回池子中
					submit = SubmitCMD.create([scope], Filter._recycleScope);
					context.addRenderObject(submit);
					mat.destroy();
				}
			}
			
			Float32Array.prototype.slice || (Float32Array.prototype.slice = _float32ArraySlice);
			Uint16Array.prototype.slice || (Uint16Array.prototype.slice = _uint16ArraySlice);
			Uint8Array.prototype.slice || (Uint8Array.prototype.slice = _uint8ArraySlice);
			return true;
		}
		
		public static function onStageResize(width:Number, height:Number):void {
			if (mainContext == null) return;
			mainContext.viewport(0, 0, width, height);
			/*[IF-FLASH]*/
			mainContext.configureBackBuffer(width, height, 0, true);
			RenderState2D.width = width;
			RenderState2D.height = height;
		}
		
		private static function onInvalidGLRes():void {
			AtlasResourceManager.instance.freeAll();
			ResourceManager.releaseContentManagers(true);
			doNodeRepaint(Laya.stage);
			
			mainContext.viewport(0, 0, RenderState2D.width, RenderState2D.height);
			
			Laya.stage.event(Event.DEVICE_LOST);
		
			//Render.context.ctx._repaint = true;
			//alert("释放资源");
		}
		
		public static function doNodeRepaint(sprite:Sprite):void {
			(sprite.numChildren == 0) && (sprite.repaint());
			for (var i:int = 0; i < sprite.numChildren; i++)
				doNodeRepaint(sprite.getChildAt(i) as Sprite);
		}
		
		public static function init(canvas:HTMLCanvas, width:int, height:int):void {
			mainCanvas = canvas;
			HTMLCanvas._createContext = function(canvas:HTMLCanvas):* {
				return new WebGLContext2D(canvas);
			}
			WebGLCanvas._createContext = function(canvas:HTMLCanvas):* {
				return new WebGLContext2D(canvas);
			}
			
			var gl:WebGLContext = WebGL.mainContext;
			if (gl.getShaderPrecisionFormat != null) {//某些浏览器中未实现此函数,提前判断增强兼容性。
				var vertexPrecisionFormat:* = gl.getShaderPrecisionFormat(WebGLContext.VERTEX_SHADER, WebGLContext.HIGH_FLOAT);
				var framePrecisionFormat:* = gl.getShaderPrecisionFormat(WebGLContext.FRAGMENT_SHADER, WebGLContext.HIGH_FLOAT);
				shaderHighPrecision = (vertexPrecisionFormat.precision&&framePrecisionFormat.precision) ? true : false;//存在vs和ps支持精度不一致,以最低的为标准
			} else {
				shaderHighPrecision = false;
			}
			
			compressAstc = gl.getExtension("WEBGL_compressed_texture_astc");
			compressAtc = gl.getExtension("WEBGL_compressed_texture_atc");
			compressEtc = gl.getExtension("WEBGL_compressed_texture_etc");
			compressEtc1 = gl.getExtension("WEBGL_compressed_texture_etc1");
			compressPvrtc = gl.getExtension("WEBGL_compressed_texture_pvrtc");
			compressS3tc = gl.getExtension("WEBGL_compressed_texture_s3tc");
			compressS3tc_srgb = gl.getExtension("WEBGL_compressed_texture_s3tc_srgb");
			//var compresseFormat:Uint32Array = gl.getParameter(WebGLContext.COMPRESSED_TEXTURE_FORMATS);
			//alert(compresseFormat.length);
			
			/*[IF-SCRIPT-BEGIN]
			   gl.deleteTexture1 = gl.deleteTexture;
			   gl.deleteTexture = function(t){
			   if (t == WebGLContext.curBindTexValue)
			   {
			   WebGLContext.curBindTexValue = null;
			   }
			   gl.deleteTexture1(t);
			   }
			   [IF-SCRIPT-END]*/
			
			onStageResize(width, height);
			
			if (mainContext == null)
				throw new Error("webGL getContext err!");
			
			System.__init__();
			AtlasResourceManager.__init__();
			ShaderDefines2D.__init__();
			Submit.__init__();
			WebGLContext2D.__init__();
			Value2D.__init__();
			Shader2D.__init__();
			Buffer2D.__int__(gl);
			BlendMode._init_(gl);
			if (Render.isConchApp) {
				__JS__("conch.setOnInvalidGLRes(WebGL.onInvalidGLRes)");
			}
		}
	}
}