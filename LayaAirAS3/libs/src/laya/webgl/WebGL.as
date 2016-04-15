package laya.webgl {
	import laya.display.Sprite;
	import laya.filters.Filter;
	import laya.filters.IFilterAction;
	import laya.events.Event;
	import laya.filters.webgl.ColorFilterActionGL;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.resource.Bitmap;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Color;
	import laya.utils.Stat;
	import laya.webgl.atlas.AtlasManager;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.display.GraphicsGL;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.resource.WebGLCanvas;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.resource.WebGLCharImage;
	import laya.webgl.resource.WebGLSubImage;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
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
				//受大图合集管理器管理，从资源管理器中移除，bitmap为WebGLImage或WebGLCanvas时加入，可能为WebGLAtlasTexture
				var bitmap:* = texture.bitmap;
				var isEnable:Boolean = AtlasManager.enabled || force;
				var bMerge:Boolean = false;
				if (System.isConchApp) {
					bMerge = (Render.isWebGl && isEnable && (bitmap is WebGLImage || __JS__('bitmap == ConchTextCanvas')) && bitmap.width < AtlasManager.atlasLimitWidth && bitmap.height < AtlasManager.atlasLimitHeight);
				} else {
					bMerge = (Render.isWebGl && isEnable && (bitmap is WebGLImage || bitmap is WebGLSubImage || bitmap is WebGLCharImage) && bitmap.width < AtlasManager.atlasLimitWidth && bitmap.height < AtlasManager.atlasLimitHeight);
				}
				if (bMerge) {
					bitmap.createOwnSource = false;
					(bitmap.resourceManager) && (bitmap.resourceManager.removeResource(bitmap));//待调整
					
					//AtlasManager.instance.addToAtlas(texture);//加入大图合集
					if (System.isConchApp && __JS__('bitmap == ConchTextCanvas')) {
						//TODO wyw
						trace(">>>>conchApp resotre todo todo");
					} else {
						bitmap.on(Event.RECOVERED, this, function(bitmap:Bitmap):void {
							(AtlasManager.enable) && (AtlasManager.instance.addToAtlas(texture));//资源释放或恢复时重新加入大图集
						});
					}
				}
			}
			
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
			
			Filter._filter = function(sprite:*, context:*, x:Number, y:Number):void {
				var next:* = this._next;
				if (next) {
					var filters:Array = sprite.filters, len:int = filters.length;
					
					if (len == 1 && filters[0].type == Filter.COLOR) {
						context.ctx.save();
						context.ctx.setFilters(sprite.filters);
						next._fun.call(next, sprite, context, x, y);
						context.ctx.restore();
						return;
					}
					/*
					   var b:Rectangle = sprite.getBounds();
					
					   var scope:SubmitCMDScope = SubmitCMDScope.create();
					   //这里判断是否存储了out，如果存储了直接用;
					   var out:RenderTarget2D = sprite._filterCache ? sprite._filterCache : null;
					   if (!out || sprite._repaint) {
					   trace("reFilter");
					   out && (out.destroy(), out.recycle());
					   scope.addValue("bounds", b);
					   var submit:SubmitCMD = SubmitCMD.create([scope, sprite, context, 0, 0], Filter._filterStart);
					   context.addRenderObject(submit);
					   next._fun.call(next, sprite, context, -b.x + sprite.x + 10, -b.y + sprite.y + 10);
					   submit = SubmitCMD.create([scope, sprite, context, 0, 0], Filter._filterEnd);
					   context.addRenderObject(submit);
					   for (var i:int = 0; i < len; i++) {
					   var fil:* = filters[i];
					   fil.action.apply3d(scope, sprite, context, 0, 0);
					   }
					   submit = SubmitCMD.create([scope], Filter._EndTarget);
					   context.addRenderObject(submit);
					   } else scope.addValue("out", out);
					
					   var mat:Matrix = context.ctx._getTransformMatrix();
					   var p:Point = Point.TEMP;
					   mat.transformPoint(b.x, b.y, p);
					   var shaderValue:Value2D = Value2D.createShderValue(ShaderDefines2D.TEXTURE2D, filters);
					   context.ctx.drawTarget(scope, p.x + x - sprite.x - 10, p.y + y - sprite.y - 10, b.width + 20, b.height + 20, Matrix.EMPTY, "out", shaderValue);
					
					   submit = SubmitCMD.create([scope], Filter._recycleScope);
					   context.addRenderObject(submit);
					 */
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
			Value2D.needRezise = true;
		}
		
		public static function isExperimentalWebgl():Boolean {
			return _isExperimentalWebgl;
		}
		
		//只有微信且是experimental-webgl模式下起作用
		public static function addRenderFinish():void {
			if (_isExperimentalWebgl) {
				Render.finish = function():void {
					Render.context.ctx.finish();
				}
			}
		}
		
		public static function init(canvas:HTMLCanvas, width:int, height:int):void {
			mainCanvas = canvas;
			HTMLCanvas._createContext = function(canvas:HTMLCanvas):* {
				return new WebGLContext2D(canvas);
			}
			
			var webGLName:String = isWebGLSupported();
			var gl:WebGLContext = mainContext = canvas.getContext(webGLName, {stencil: true, alpha: false, antialias: true, premultipliedAlpha: false}) as WebGLContext;
			
			_isExperimentalWebgl = (webGLName == "experimental-webgl" && (Browser.onWeiXin || Browser.onMQQBrowser));
			
			Browser.window.SetupWebglContext && Browser.window.SetupWebglContext(gl);
			
			onStageResize(width, height);
			
			if (mainContext == null)
				throw new Error("webGL getContext err!");
			
			System.__init__();
			AtlasManager.__init__();
			ShaderDefines2D.__init__();
			Submit.__init__();
			WebGLContext2D.__init__();
			Value2D.__init__();
			Shader2D.__init__();
			Buffer.__int__(gl);
			BlendMode._init_(gl);
		}
	}

}