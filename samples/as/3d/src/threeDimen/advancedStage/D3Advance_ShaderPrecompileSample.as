package threeDimen.advancedStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class D3Advance_ShaderPrecompileSample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		
		public function D3Advance_ShaderPrecompileSample() {
			Laya3D.init(0, 0, true);
			//开启Shader编译调试模式，可在输出宏定义编译值。
			ShaderCompile3D.debugMode = true;
			
			var sc:ShaderCompile3D = ShaderCompile3D.get("SIMPLE");
			//部分低端移动设备不支持高精度shader,所以如果在PC端或高端移动设备输出的宏定义值需做判断移除高精度宏定义
			if (WebGL.frameShaderHighPrecision)
				sc.precompileShaderWithShaderDefine(73,4,20);
			else
				sc.precompileShaderWithShaderDefine(73 - ShaderCompile3D.SHADERDEFINE_FSHIGHPRECISION,4,20);
			
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.0));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.clearColor = null;
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			skinMesh = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/dude/dude-him.lm"))) as MeshSprite3D;
			skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			skinAni = skinMesh.addComponent(SkinAnimations) as SkinAnimations;
			skinAni.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/dude/dude-Take 001.lsani");
			skinAni.player.play();
		}
	}
}