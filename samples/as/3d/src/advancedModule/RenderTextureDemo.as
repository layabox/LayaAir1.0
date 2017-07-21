package advancedModule
{
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	
	public class RenderTextureDemo
	{
		private var scene:Scene;
		private var renderTargetCamera:Camera;
		
		private var layaPlane:Sprite3D;
		
		public function RenderTextureDemo()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/Arena/Arena.ls")) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 1000)) as Camera;
			camera.transform.translate(new Vector3(0, 0.5, 1));
			camera.transform.rotate(new Vector3( -10, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			
			renderTargetCamera = scene.addChild(new Camera(0, 0.1, 1000)) as Camera;
			renderTargetCamera.transform.translate(new Vector3(0, 0.5, 1));
			renderTargetCamera.transform.rotate(new Vector3(-10, 0, 0), true, false);
			renderTargetCamera.renderTarget = new RenderTexture(2048, 2048);
			renderTargetCamera.renderingOrder = -1;
			renderTargetCamera.addComponent(CameraMoveScript);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
            directionLight.specularColor = new Vector3(1.0, 1.0, 1.0);
            directionLight.diffuseColor = new Vector3(1, 1, 1);
            directionLight.direction = new Vector3(0, -1.0, -1.0);
			
			var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			
			layaPlane = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh")) as Sprite3D;
			
            Laya.loader.create([
				"../../../../res/threeDimen/scene/Arena/Arena.ls",
				"../../../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh"
			], Handler.create(this, onComplete));
		}
		
		private function onComplete():void {
			
			setMaterials(scene.getChildByName("scene"));
			layaPlane.transform.localPosition = new Vector3(0, 0.5, -1);
			
            Laya.loader.load(["../../../../res/threeDimen/ui/button.png"], Handler.create(null, function():void {
                var changeActionButton:Button = Laya.stage.addChild(new Button("../../../../res/threeDimen/ui/button.png", "渲染目标")) as Button;
                changeActionButton.size(160, 40);
                changeActionButton.labelBold = true;
                changeActionButton.labelSize = 30;
                changeActionButton.sizeGrid = "4,4,4,4";
                changeActionButton.scale(Browser.pixelRatio, Browser.pixelRatio);
                changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
                changeActionButton.on(Event.CLICK, this, function():void {
					(layaPlane.getChildAt(0) as MeshSprite3D).meshRender.material.diffuseTexture = renderTargetCamera.renderTarget;
                });
            }));
        }
		
		private function setMaterials(spirit3D:Sprite3D):void {
            if (spirit3D is MeshSprite3D) {
                var meshSprite:MeshSprite3D = spirit3D as MeshSprite3D;
                for (var i:int = 0; i <  meshSprite.meshRender.sharedMaterials.length; i++) {
                    var mat:StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as StandardMaterial;
                    mat.disableLight();
                }
            }
            for (var i:int = 0; i < spirit3D._childs.length; i++)
                setMaterials(spirit3D._childs[i]);
        }
	}
}