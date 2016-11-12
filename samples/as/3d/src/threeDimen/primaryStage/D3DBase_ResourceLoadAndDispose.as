package threeDimen.primaryStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	public class D3DBase_ResourceLoadAndDispose {
		
		public function D3DBase_ResourceLoadAndDispose() {
			//前言:3D资源为高级类型,需调用Laya.loader.create()接口创建，基本类型如JSON，BUFFER,TEXT请使用Laya.loader.load()加载;
			Laya3D.init(0, 0);
			
			var processHandler:Handler = Handler.create(this, onProcessChange, null, false);//创建进度处理Handler，注意：后面要对应释放
			
			//1:批量加载复杂模式。
			//Laya.loader.create([
			//{url:"../../../../res/threeDimen/staticModel/sphere/sphere.lh", clas:Sprite3D, priority:1}, 
			//{url:"../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm", clas:Mesh, priority:1},
			//{url:"../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat", clas:StandardMaterial, priority:1},
			//{url:"../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg", clas:Texture2D, priority:1},
			//{url:"../../../../res/threeDimen/skyBox/skyCube.ltc", clas:TextureCube, priority:1},
			//{url:"../../../../res/threeDimen/skinModel/dude/dude.ani", clas:AnimationTemplet, priority:1}
			//], null, processHandler);
			
			//2:批量加载简单模式。
			Laya.loader.create([
			"../../../../res/threeDimen/staticModel/sphere/sphere.lh", 
			"../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm", 
			"../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat", 
			"../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg", 
			"../../../../res/threeDimen/skyBox/skyCube.ltc", 
			"../../../../res/threeDimen/skinModel/dude/dude.ani"], null, processHandler);
			
			//3:单独加载模式。
			//加载层级文件，与其它资源区别为通常不缓存。
			var hierarchyUrl:String = "../../../../res/threeDimen/staticModel/sphere/sphere.lh";
			//var sprite:Sprite3D = Laya.loader.create(hierarchyUrl, null, null, Sprite3D, 1, false);//复杂加载。
			var sprite:Sprite3D = Sprite3D.load(hierarchyUrl);//简单加载，为复杂加载的封装。
			
			//加载网格文件。
			var meshUrl:String = "../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm";
			//var mesh:Sprite3D = Laya.loader.create(meshUrl, null, null, Mesh);//复杂加载。
			var mesh:Mesh = Mesh.load(meshUrl);//简单加载，为复杂加载的封装。
			
			//加载材质文件。
			var materialUrl:String = "../../../../res/threeDimen/staticModel/sphere/spheregridWhiteBlack.lmat";
			//var material:StandardMaterial = Laya.loader.create(materialUrl, null, null, StandardMaterial);//复杂加载。
			var material:StandardMaterial=StandardMaterial.load(materialUrl);//简单加载，为复杂加载的封装。
			
			//加载Texture2D文件。
			var texture2DUrl:String = "../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg";
			//var texture2D:Texture2D = Laya.loader.create(texture2DUrl, null, null, Texture2D);//复杂加载。
			var texture2D:Texture2D=Texture2D.load(texture2DUrl);//简单加载，为复杂加载的封装。
			
			//加载TextureCube文件。
			var textureCubeUrl:String = "../../../../res/threeDimen/skyBox/skyCube.ltc";
			//var textureCube:TextureCube = Laya.loader.create(textureCubeUrl, null, null, TextureCube);//复杂加载。
			var textureCube:TextureCube = TextureCube.load(textureCubeUrl);//简单加载，为复杂加载的封装。*/
			
			//加载动画模板文件。
			var animationTempletUrl:String = "../../../../res/threeDimen/skinModel/dude/dude.ani";
			//var animationTemplet:AnimationTemplet = Laya.loader.create(keyframesAniTempletUrl, null, null, AnimationTemplet);//复杂加载。
			var animationTemplet:AnimationTemplet =AnimationTemplet.load(animationTempletUrl);//简单加载，为复杂加载的封装。
			
			processHandler.recover();//释放进度处理Handler
		}
		
		public function onProcessChange(process:Number):void {
			trace("Process:", process);
		}
	
	}

}