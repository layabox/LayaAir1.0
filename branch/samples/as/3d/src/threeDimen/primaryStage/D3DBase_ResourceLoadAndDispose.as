package threeDimen.primaryStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	public class D3DBase_ResourceLoadAndDispose {
	 	public var texture:Texture
		public var sprite:Sprite3D;
		public var mesh:Mesh;
		public var material:StandardMaterial;
		public var texture2D:Texture2D;
		public var  textureCube:TextureCube;
		public var animationTemplet:AnimationTemplet;
		public var processHandler:Handler;
		
		public function D3DBase_ResourceLoadAndDispose() {
			//前言:3D资源为高级类型,需调用Laya.loader.create()接口创建，基本类型如JSON，BUFFER,TEXT请使用Laya.loader.load()加载;
			Laya3D.init(0, 0);
			
			processHandler = Handler.create(this, onProcessChange, null, false);//创建进度处理Handler，注意：后面要对应释放
			var completeHandler:Handler = Handler.create(this, onComplete);//创建完成事件处理Handler
			
			Laya.loader.maxLoader = 4;
			//一:资源释放。
			//1.批量加载复杂模式。
			Laya.loader.create([
			//2D:
			//{url:"../../../../res/bg.jpg", clas:Texture, priority:1}
			//{url:"../../../../res/fighter/fighter.atlas", clas:null, priority:1}
			
			//3D:
			//{url:"../../../../res/threeDimen/staticModel/sphere/sphere.lh", clas:Sprite3D, priority:1}//注意：加载层级文件会自动加载所包含的模型文件、材质文件、贴图文件。
			
			//{url:"../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm", clas:Mesh, priority:1}//}//注意：加载模型文件会自动加载所包含的材质文件、贴图文件。
			
			//{url:"../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat", clas:StandardMaterial, priority:1}//注意：加载材质文件会自动加载所包含的贴图文件。
			
			//{url:"../../../../res/threeDimen/skyBox/skyCube.ltc", clas:TextureCube, priority:1},//注意：加载立方体贴图文件会自动加载所包含的贴图文件。
			
			{url:"../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg", clas:Texture2D, priority:1,params:[true]}//注意：params对应Texture2D的构造函数参数。
			
			//{url:"../../../../res/threeDimen/skinModel/dude/dude.ani", clas:AnimationTemplet, priority:1}
			], completeHandler, processHandler);
			
			
			/*
			//二.批量加载简单模式。
			Laya.loader.create([
			//2D:
			//不支持:"../../../../res/bg.jpg"//注意：不支持Texture简单加载,必须用复杂类型，因为create模型类型是Texture2D
			"../../../../res/fighter/fighter.atlas"
			
			//3D:
			"../../../../res/threeDimen/staticModel/sphere/sphere.lh"//注意：加载层级文件会自动加载所包含的模型文件、材质文件、贴图文件。
			
			"../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"//注意：加载模型文件会自动加载所包含的材质文件、贴图文件。
			
			"../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat"//注意：加载材质文件会自动加载所包含的贴图文件。
			
			"../../../../res/threeDimen/skyBox/skyCube.ltc" //注意：加载立方体贴图文件会自动加载所包含的贴图文件。
			
			"../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg" 
			
			"../../../../res/threeDimen/skinModel/dude/dude.ani"], completeHandler, processHandler);
			*/
			
			
			////三.单独加载模式。
			////2D:
			////加载Texture文件。
			//var textureUrl:String = "../../../../res/bg.jpg";
			 //texture = Laya.loader.create(textureUrl, null, null, Texture);//复杂加载。
			//
			//var atlasUrl:String = "../../../../res/fighter/fighter.atlas";
			//Laya.loader.create(atlasUrl, null, null, null);//复杂加载。
			////不支持:图集不能立即返回，不支持简单加载
			//
			////3D:
			////加载层级文件，与其它资源区别为通常不缓存。
			//var hierarchyUrl:String = "../../../../res/threeDimen/staticModel/sphere/sphere.lh";
			//// sprite = Laya.loader.create(hierarchyUrl, null, null, Sprite3D, 1, false);//复杂加载。
			 //sprite = Sprite3D.load(hierarchyUrl);//简单加载，为复杂加载的封装。
			//
			////加载网格文件。
			//var meshUrl:String = "../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm";
			//// mesh = Laya.loader.create(meshUrl, null, null, Mesh);//复杂加载。
			 //mesh = Mesh.load(meshUrl);//简单加载，为复杂加载的封装。
			//
			////加载材质文件。
			//var materialUrl:String = "../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat";
			//// material = Laya.loader.create(materialUrl, null, null, StandardMaterial);//复杂加载。
			 //material=StandardMaterial.load(materialUrl);//简单加载，为复杂加载的封装。
			//
			////加载Texture2D文件。
			//var texture2DUrl:String = "../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg";
			//// texture2D = Laya.loader.create(texture2DUrl, null, null, Texture2D);//复杂加载。
			 //texture2D=Texture2D.load(texture2DUrl);//简单加载，为复杂加载的封装。
			//
			////加载TextureCube文件。
			//var textureCubeUrl:String = "../../../../res/threeDimen/skyBox/skyCube.ltc";
			//// textureCube = Laya.loader.create(textureCubeUrl, null, null, TextureCube);//复杂加载。
			 //textureCube = TextureCube.load(textureCubeUrl);//简单加载，为复杂加载的封装。
			//
			////加载动画模板文件。
			//var animationTempletUrl:String = "../../../../res/threeDimen/skinModel/dude/dude.ani";
			//// animationTemplet = Laya.loader.create(keyframesAniTempletUrl, null, null, AnimationTemplet);//复杂加载。
			 //animationTemplet =AnimationTemplet.load(animationTempletUrl);//简单加载，为复杂加载的封装。
			
		   
		}
		
		public function onComplete():void {
			//二:资源释放 注意：图集以及套嵌资源需要去Loader里面查询。
			//texture.destroy();
			
			//sprite.destroy();
			//mesh.dispose();
			//material.dispose();
			//texture2D.dispose();
			//textureCube.dispose();
			//animationTemplet.dispose();
			
			processHandler.recover();//释放进度处理Handler
		}
		
		public function onProcessChange(process:Number):void {
			trace("Process:", process);
		}
	
	}

}