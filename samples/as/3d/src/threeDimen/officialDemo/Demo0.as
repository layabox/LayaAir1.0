package threeDimen.officialDemo {
	import laya.d3.Laya3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.Material;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.tempelet.MeshTemplet;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class Demo0 {
		private var skinMesh:Mesh;
		private var skinAni:SkinAnimations;
		
		public function Demo0() {
			
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 4, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0.0, 16.74, -9.81));
			scene.currentCamera.transform.rotate(new Vector3(-50, 180, 0), true, false);
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
				alert( Laya.stage.width);
				alert( Laya.stage.height);
			});
			
			//var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			//directionLight.ambientColor = new Vector3(1.0, 1.0, 1.0);
			//directionLight.specularColor = new Vector3(0.3, 0.3, 0.3);
			//directionLight.diffuseColor = new Vector3(1.6, 1.6, 1.6);
			//directionLight.direction = new Vector3(-0.5, -1.0, -0);
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			var staticMesh:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			//staticMesh.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				//var templet:MeshTemplet = (sprite.getChildAt(0) as Mesh).templet;
				//templet.on(Event.LOADED, null, function(templet:MeshTemplet):void {
					//for (var i:int = 0; i < templet.materials.length; i++) {
						//var material:Material = templet.materials[i];
						//material.luminance = 3.5;
					//}
				//});
			//});
			staticMesh.loadHierarchy("1.lh");
			//staticMesh.transform.localScale = new Vector3(10, 10, 10);
		}
	}
}