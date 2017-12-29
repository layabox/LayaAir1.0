package materialModule 
{
	import common.CameraMoveScript;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.SkyBox;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author ...
	 */
	public class PBRStandardMaterialDemo 
	{
		
		public function PBRStandardMaterialDemo() 
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/PBRMaterialScene/Showcase.ls")) as Scene;
			
			scene.once(Event.HIERARCHY_LOADED, this, function():void
			{
				var camera:Camera = scene.getChildByName("Main Camera") as Camera;
				camera.addComponent(CameraMoveScript);
				camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
				var skyBox:SkyBox = new SkyBox();
				camera.sky = skyBox;
				skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");
				
				//实例PBR材质
				var mat:PBRStandardMaterial = new PBRStandardMaterial();
				//反射贴图
				mat.albedoTexture = Texture2D.load('../../../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_AlbedoTransparency.png');
				//法线贴图
				mat.normalTexture = Texture2D.load('../../../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_Normal.png');
				//金属光滑度贴图
				mat.metallicGlossTexture = Texture2D.load('../../../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_MetallicSmoothness.png');
				//遮挡贴图
				mat.occlusionTexture = Texture2D.load('../../../../res/threeDimen/scene/PBRMaterialScene/Assets/PBR Barrel/Materials/Textures/Barrel_Occlusion.png');
				//反射颜色
				mat.albedoColor = new Vector4(1, 1, 1, 1);
				//光滑度缩放系数
				mat.smoothnessTextureScale = 1.0;
				//遮挡贴图强度
				mat.occlusionTextureStrength = 1.0;
				//法线贴图缩放洗漱
				mat.normalScale = 1;
				//光滑度数据源:从金属度贴图/反射贴图获取。
				mat.smoothnessSource = PBRStandardMaterial.SmoothnessSource_MetallicGlossTexture_Alpha;
				
				var barrel:MeshSprite3D = scene.getChildByName("Wooden_Barrel") as MeshSprite3D;
				var barrel1:MeshSprite3D = scene.getChildByName("Wooden_Barrel (1)") as MeshSprite3D;
				var barrel2:MeshSprite3D = scene.getChildByName("Wooden_Barrel (2)") as MeshSprite3D;
				var barrel3:MeshSprite3D = scene.getChildByName("Wooden_Barrel (3)") as MeshSprite3D;
				
				barrel.meshRender.sharedMaterial = mat;
				barrel1.meshRender.sharedMaterial = mat;
				barrel2.meshRender.sharedMaterial = mat;
				barrel3.meshRender.sharedMaterial = mat;
			}
		}
		
	}

}