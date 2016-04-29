package laya.webgl {
	import laya.display.Sprite;
	import laya.filters.Filter;
	import laya.filters.IFilterAction;
	import laya.events.Event;
	import laya.filters.webgl.ColorFilterActionGL;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Bitmap;
	import laya.resource.HTMLCanvas;
	import laya.resource.ResourceManager;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Color;
	import laya.utils.Stat;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.display.GraphicsGL;
	import laya.webgl.resource.IMergeAtlasBitmap;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.resource.WebGLCanvas;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.resource.WebGLCharImage;
	import laya.webgl.resource.WebGLSubImage;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCMDScope;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.RenderSprite3D;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * ...
	 * @author laya
	 */
	public class WebGL {
		public static var mainCanvas:HTMLCanvas;
		public static var mainContext:WebGLContext;
		public static var antialias:Boolean = true;
		
		private static var _bg_null:Array =/*[STATIC SAFE]*/ [0, 0, 0, 0];
		private static var _isExperimentalWebgl:Boolean = false;
		
		public static function enable():Boolean {
			if (!isWebGLSupported()) return false;
			
			__JS__("HTMLImage=WebGLImage");
			__JS__("HTMLCanvas=WebGLCanvas");
			__JS__("HTMLSubImage=WebGLSubImage");
			System.changeDefinition("HTMLImage", WebGLImage);
			System.changeDefinition("HTMLCanvas", WebGLCanvas);
			System.changeDefinition("HTMLSubImage", WebGLSubImage);
			
			Render.WebGL = WebGL;
			System.createRenderSprite = function(type:int, next:RenderSprite):RenderSprite {
				return new RenderSprite3D(type, next);
			}
			System.createWebGLContext2D = function(c:HTMLCanvas):WebGLContext2D {
				return new WebGLContext2D(c);
			}
			System.changeWebGLSize = function(width:Number, height:Number):void {
				WebGL.onStageResize(width, height);
			}
			System.createGraphics = function():GraphicsGL {
				return new GraphicsGL();
			}
			
			var action:* = System.createFilterAction;
			System.createFilterAction = action ? action : function(type:int):IFilterAction {
				return new ColorFilterActionGL()
			}
			Render.clear = function(color:String):void {
				RenderState2D.worldScissorTest && WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
				var c:Array = Color.create(color)._color;
				Render.context.ctx.clearBG(c[0], c[1], c[2], c[3]);
				RenderState2D.clear();
			}
			
			System.addToAtlas = function(texture:Texture, force:Boolean = false):void {
				var bitmap:Bitmap = texture.bitmap;
				if ((bitmap is IMergeAtlasBitmap) && ((bitmap as IMergeAtlasBitmap).allowMerageInAtlas)) {
					bitmap.on(Event.RECOVERED, null, function(bm:Bitmap):void {
						((bitmap as IMergeAtlasBitmap).enableMerageInAtlas) && (AtlasResourceManager.instance.addToAtlas(texture));//资源恢复时重新加入大图集
					});
				}
			}
			AtlasResourceManager.enable();
			
			System.drawToCanvas = function(sprite:Sprite, _renderType:int, canvasWidth:Number, canvasHeight:Number, offsetX:Number, offsetY:Number):* {
				var renderTarget:RenderTarget2D = new RenderTarget2D(canvasWidth, canvasHeight, false, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, 0);
				renderTarget.start();
				renderTarget.clear(1.0, 0.0, 0.0, 1.0);
				sprite.render(Render.context, -offsetX, RenderState2D.height - canvasHeight - offsetY);
				Render.context.flush();
				renderTarget.end();
				var pixels:Uint8Array = renderTarget.getData(0, 0, renderTarget.width, renderTarget.height);
				renderTarget.dispose();
				return pixels;
			}
			
			System.createFilterAction = function(type:int):* {
				var action:*;
				switch (type) {
				case Filter.COLOR: 
					action = new ColorFilterActionGL();
					break;
				}
				return action;
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
				sprite._filterCache = out;
				sprite._isHaveGlowFilter = scope.getValue("isHaveGlowFilter");
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
					tMatrix.copy(mat);
					var tPadding:int = 0;
					var tHalfPadding:int = 0;
					var tIsHaveGlowFilter:Boolean = false;
					//这里判断是否存储了out，如果存储了直接用;
					var out:RenderTarget2D = sprite._filterCache ? sprite._filterCache : null;
					if (!out || sprite._repaint) {
						
						tIsHaveGlowFilter = sprite.isHaveGlowFilter();
						scope.addValue("isHaveGlowFilter", tIsHaveGlowFilter);
						if (tIsHaveGlowFilter) {
							tPadding = 50;
							tHalfPadding = 25;
						}
						b = new Rectangle();
						b.copyFrom((sprite as Sprite).getBounds());
						//重新计算宽和高
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
						if (b.width <= 0 || b.height <= 0) {
							return;
						}
						out && out.recycle();
						scope.addValue("bounds", b);
						var submit:SubmitCMD = SubmitCMD.create([scope, sprite, context, 0, 0], Filter._filterStart);
						context.addRenderObject(submit);
						(context.ctx as WebGLContext2D)._shader2D.glTexture = null;//绘制前置空下，保证不会被打包进上一个序列
						//旋转偏移
						var tSx:Number = sprite.x - sprite.pivotX;
						var tSy:Number = sprite.y - sprite.pivotY;
						//绘制当前物品(在src纹理上，画上物品,由于左下角开始画，所以计算下偏移)
						var tSpriteX:Number = tSx * mat.a + tSy * mat.c;
						var tSpriteY:Number = tSy * mat.d + tSx * mat.b;
						var tX:Number = -b.x + tSpriteX + tHalfPadding - mat.tx / mat.a + sprite.pivotX;
						var tY:Number = -b.y + tSpriteY + tHalfPadding - mat.ty / mat.d + sprite.pivotY;
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
								context.ctx.drawTarget(scope, 0, 0, b.width, b.height, Matrix.TEMP, "out", shaderValue);
								submit = SubmitCMD.create([scope], Filter._useOut);
								context.addRenderObject(submit);
							}
							var fil:* = filters[i];
							fil.action.apply3d(scope, sprite, context, 0, 0);
						}
						submit = SubmitCMD.create([scope, context], Filter._EndTarget);
						context.addRenderObject(submit);
					} else {
						tIsHaveGlowFilter = sprite._isHaveGlowFilter ? sprite._isHaveGlowFilter : false;
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
						scope.addValue("out", out);
					}
					x = x - tHalfPadding - sprite.x;
					y = y - tHalfPadding - sprite.y;
					mat.transformPoint(x, y, p);
					x = p.x + b.x;
					y = p.y + b.y;
					shaderValue = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
					//把最后的out纹理画出来
					Matrix.TEMP.identity();
					context.ctx.drawTarget(scope, x, y, b.width, b.height, Matrix.TEMP, "out", shaderValue);
					//把对象放回池子中
					submit = SubmitCMD.create([scope], Filter._recycleScope);
					context.addRenderObject(submit);
					mat.destroy();
				}
			}
			return true;
		}
		
		public static function isWebGLSupported():String {
			var canvas:* = Browser.createElement('canvas');
			var gl:WebGLContext;
			var names:Array = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
			for (var i:int = 0; i < names.length; i++) {
				try {
					gl = canvas.getContext(names[i]);
				} catch (e:*) {
				}
				if (gl) return names[i];
			}
			return null;
		}
		
		public static function onStageResize(width:Number, height:Number):void {
			mainContext.viewport(0, 0, width, height);
			RenderState2D.width = width;
			RenderState2D.height = height;
		}
		
		public static function isExperimentalWebgl():Boolean {
			return _isExperimentalWebgl;
		}
		
		/**只有微信或QQ且是experimental-webgl模式下起作用*/
		public static function addRenderFinish():void {
			if (_isExperimentalWebgl) {
				Render.finish = function():void {
					Render.context.ctx.finish();
				}
			}
		}
		
		// 去掉finish的代码
		public static function removeRenderFinish():void {
			if (_isExperimentalWebgl) {
				Render.finish = function():void {
				}
			}
		}
		
		private static function onInvalidGLRes():void {
			AtlasResourceManager.instance.freeAll();
			ResourceManager.releaseContentManagers(true);
		
			doNodeRepaint(Laya.stage);
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
			
			var webGLName:String = isWebGLSupported();
			var gl:WebGLContext = mainContext = canvas.getContext(webGLName, {stencil: true, alpha: false, antialias: true, premultipliedAlpha: false}) as WebGLContext;
			
			_isExperimentalWebgl = (webGLName != "webgl" && (Browser.onWeiXin || Browser.onMQQBrowser));
			
			Browser.window.SetupWebglContext && Browser.window.SetupWebglContext(gl);
			
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
			Buffer.__int__(gl);
			BlendMode._init_(gl);
			if (System.isConchApp) {
				__JS__("conch.setOnInvalidGLRes(WebGL.onInvalidGLRes)");
			}
		}
	}
}