package cameraModule
{
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.Utils3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.ui.Image;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	
	public class OrthographicCamera
	{
		private var translate:Vector3 = new Vector3(500, 500, 0);
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		
		public function OrthographicCamera()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var dialog:Image = Laya.stage.addChild(new Image("../../../../res/threeDimen/texture/earth.png")) as Image;
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 1000)) as Camera;
			camera.transform.rotate(new Vector3(-30, 0, 0), false, false);
			camera.transform.translate(new Vector3(0, 0.5, 500));
			camera.orthographicProjection = true;
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			
			var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			layaMonkey.once(Event.HIERARCHY_LOADED, this, function():void{
				
				layaMonkey.transform.localScale = new Vector3(300, 300, 300);
				Utils3D.convert3DCoordTo2DScreenCoord(translate, translate);
				layaMonkey.transform.position = translate;
				Laya.timer.frameLoop(1, this, function():void{
					layaMonkey.transform.rotate(rotation);
				});
				
			});
			
			Laya.stage.on(Event.RESIZE, null, function():void {
				camera.orthographicVerticalSize = RenderState.clientHeight;
			});
		}
	}
}