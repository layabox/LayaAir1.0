package sprite3dModule
{
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
	
	public class Sprite3DTransform
	{
		
		private var scene:Scene;
		private var layaMonkey1:Sprite3D;
		private var layaMonkey2:Sprite3D;
		private var layaMonkey3:Sprite3D;
		private var _position:Vector3 = new Vector3(-0.6, 0, 0);
		private var _rotate:Vector3 = new Vector3(0, 1, 0);
		private var _scale:Vector3 = new Vector3();
		private var scaleDelta:Number = 0;
		private var scaleValue:Number = 0;
		
		public function Sprite3DTransform()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 0.5, 1));
			camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			
			var completeHandler:Handler = Handler.create(this, onComplete);
			
			Laya.loader.create("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", completeHandler);
		}
		
		public function onComplete():void
		{
			
			layaMonkey1 = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			layaMonkey2 = Sprite3D.instantiate(layaMonkey1, scene, false, new Vector3(0, 0, 0));
			layaMonkey3 = scene.addChild(Sprite3D.instantiate(layaMonkey1, null, false, new Vector3(0.6, 0, 0))) as Sprite3D;
			
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function animate():void
		{
			scaleValue = Math.sin(scaleDelta += 0.1);
			
			_position.y = scaleValue / 2;
			layaMonkey1.transform.position = _position;
			
			layaMonkey2.transform.rotate(_rotate, false, false);
			
			_scale.x = _scale.y = _scale.z = Math.abs(scaleValue);
			layaMonkey3.transform.localScale = _scale;
		}
	}
}