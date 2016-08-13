package  {
	import laya.d3.component.Component3D;
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderState;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.webgl.WebGL;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.resource.WebGLImageCube;
	
	/**
	 * <code>Laya3D</code> 类用于初始化3D设置。
	 */
	public class Laya3D {
		
		/**
		 * 创建一个 <code>Laya3D</code> 实例。
		 */
		public function Laya3D() {
		}
		
		/**
		 * 初始化Laya3D相关设置。
		 * @param	width  3D画布宽度。
		 * @param	height 3D画布高度。
		 */
		public static function init(width:Number, height:Number):void {
			if (!WebGL.enable()) {
				alert("Laya3D init err,must support webGL!");
				return;
			}
			//AtlasResourceManager._disable();
			
			Loader.parserMap = {"TextureCube": _loadTextureCube};
			//Loader.parserMap = {"Material": _loadMaterial};
			
			RunDriver.changeWebGLSize = function(width:Number, height:Number):void {
				WebGL.onStageResize(width, height);
				RenderState.clientWidth = width;
				RenderState.clientHeight = height;
			}
			Render.is3DMode = true;
			Laya.init(width, height);
			Layer.__init__();
			ShaderDefines3D.__init__();
			Shader3D.__init__();
			Component3D.__init__();
			_regClassforJson();
		}
		
		private static function _regClassforJson():void {
			ClassUtils.regClass("Sprite3D", Sprite3D);
			ClassUtils.regClass("MeshSprite3D", MeshSprite3D);
			ClassUtils.regClass("Material", Material);
		}
		
		private static function _loadTextureCube(loader:Loader):void {
			Laya.loader.load(loader.url, Handler.create(null, function(data:Object):void {
				var preBasePath:String = URL.basePath;
				URL.basePath = URL.getPath(URL.formatURL(loader.url));//此处更换URL路径会影响模型寻找贴图的路径
				var webGLImageCube:WebGLImageCube = new WebGLImageCube([data.px, data.nx, data.py, data.ny, data.pz, data.nz], data.size);
				URL.basePath = preBasePath;
				webGLImageCube.on(Event.LOADED, null, function(imgCube:WebGLImageCube):void {
					var cubeTexture:Texture = new Texture(webGLImageCube);
					loader.endLoad(cubeTexture);
				});
			}), null, Loader.JSON, 1, false);
		}
	
		//private static function _loadMaterial(loader:Loader):void {
		//Laya.loader.load(loader.url, Handler.create(null, function(data:Object):void {
		//var m:Material = new Material();
		//var preBasePath:String = URL.basePath;
		//URL.basePath = URL.getPath(URL.formatURL(loader.url));
		//ClassUtils.createByJson(data, m, null, Handler.create(null, Utils3D._parseMaterial, null, false));
		//URL.basePath = preBasePath;
		//loader.endLoad(m);
		//}), null, Loader.TEXT, 1);
		//}
	}
}