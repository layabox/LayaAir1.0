package threeDimen.primaryStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class D3Base_SkinAnimation_MultiMeshSample {
		public function D3Base_SkinAnimation_MultiMeshSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 1.8, 2.0));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.clearColor = null;
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(2.0, 2.0, 1.6);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			
			var rootSkinMesh:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			var skinMesh0:MeshSprite3D = rootSkinMesh.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT0.lm"))) as MeshSprite3D;
			var skinMesh1:MeshSprite3D = rootSkinMesh.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT1.lm"))) as MeshSprite3D;
			var skinMesh2:MeshSprite3D = rootSkinMesh.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT2.lm"))) as MeshSprite3D
			var skinMesh3:MeshSprite3D = rootSkinMesh.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT3.lm"))) as MeshSprite3D;
			
			var skinAni0:SkinAnimations = skinMesh0.addComponent(SkinAnimations) as SkinAnimations;
			skinAni0.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
			skinAni0.player.play(0, 0.6);
			var skinAni1:SkinAnimations = skinMesh1.addComponent(SkinAnimations) as SkinAnimations;
			skinAni1.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani")
			skinAni1.player.play(0, 0.6);
			var skinAni2:SkinAnimations = skinMesh2.addComponent(SkinAnimations) as SkinAnimations;
			skinAni2.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
			skinAni2.player.play(0, 0.6);
			var skinAni3:SkinAnimations = skinMesh3.addComponent(SkinAnimations) as SkinAnimations;
			skinAni3.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
			skinAni3.player.play(0, 0.6);
		}
	
	}

}