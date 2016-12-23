package threeDimen.primaryStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.utils.Stat;
	/*
	 * 此示例展示网页内容和3D混合，可自行添加网页混合内容。
	 */
	public class D3Base_SkinAnimation_3DoverWeb {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		
		public function D3Base_SkinAnimation_3DoverWeb() {
			
			__JS__("var div = document.createElement('div')");
			__JS__("div.innerHTML = '<h1>此内容来源于HTML网页 - h1标签</h1>'");
			__JS__("document.body.appendChild(div)");
			
			Laya3D.init(0, 0, true, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Laya.stage.bgColor = "none";
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.0));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.clearColor = new Vector4(0.0,0.0,0.0,0.0);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			skinMesh = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/dude/dude-him.lm"))) as MeshSprite3D;
			skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			skinAni = skinMesh.addComponent(SkinAnimations) as SkinAnimations;
			skinAni.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/dude/dude.ani");
			skinAni.player.play();
		}
	}
}