package sprite3dModule {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	
	public class Sprite3DClone {
		
		private var scene:Scene;
		
		public function Sprite3DClone() {
			
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 0.5, 1));
			camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			
			Laya.loader.create("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Handler.create(this, onComplete));
		}
		
		public function onComplete():void {
			
			var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			//克隆sprite3d
			var layaMonkey_clone1:Sprite3D = Sprite3D.instantiate(layaMonkey, scene, false, new Vector3(0.6, 0, 0));
			//克隆sprite3d
			var layaMonkey_clone2:Sprite3D = scene.addChild(Sprite3D.instantiate(layaMonkey, null, false, new Vector3(-0.6, 0, 0))) as Sprite3D;
		}
	}
}