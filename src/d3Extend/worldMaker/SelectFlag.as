package laya.d3Extend.worldMaker {
	import adobe.utils.CustomActions;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.RenderState;
	import laya.d3.core.material.UnlitMaterial;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.utils.Handler;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.Texture2D;
	/**
	 * ...
	 * @author ...
	 */

	
	public class SelectFlag {
		
		private var planeMaterial:Vector.<UnlitMaterial> = new Vector.<UnlitMaterial>();
		private var posD:Vector3 = new Vector3();
		private var redTilingoffset:Vector4 = new Vector4(1, 1, 0, 0);
		private var greenTilingoffset:Vector4 = new Vector4(1, 1, 0, 0);
		private var blueTilingoffset:Vector4 = new Vector4(1, 1, 0, 0);
			
		public	var selectFlag:Sprite3D;
		private	var redPlane:MeshSprite3D;
		private	var greenPlane:MeshSprite3D;
		private	var bluePlane:MeshSprite3D;
		private var textures:Texture2D;
		private var textures2:Texture2D;
		
		public static const FACTOR:int = 10; 
		
		public var isLoad:Boolean = false;
		
		public var currentScale:Vector3 = new Vector3(1,1,1);
		
		public function SelectFlag() {
				
				Texture2D.load("../../../../res/threeDimen/tiange/222.png",Handler.create(null,function(texture:Texture2D):void{
					textures = texture;
				}));
				Texture2D.load("../../../../res/threeDimen/tiange/Assets/111.png",Handler.create(null,function(texture:Texture2D):void{
					textures2 = texture;
				}));
				Sprite3D.load("../../../../res/threeDimen/tiange/stage.lh", Handler.create(null, function(sprite:Sprite3D):void {
				selectFlag = sprite.getChildByName("flag") as Sprite3D;
				redPlane = selectFlag.getChildByName("red") as MeshSprite3D;
				
				greenPlane =  selectFlag.getChildByName("green") as MeshSprite3D;
				bluePlane = selectFlag.getChildByName("blue") as MeshSprite3D;
				
				
				
				
				planeMaterial.push((redPlane.meshRenderer.sharedMaterial) as UnlitMaterial);
				planeMaterial.push((greenPlane.meshRenderer.sharedMaterial) as UnlitMaterial);
				planeMaterial.push((bluePlane.meshRenderer.sharedMaterial) as UnlitMaterial);
				
				planeMaterial[0].albedoTexture = textures;
				planeMaterial[1].albedoTexture = textures;
				planeMaterial[2].albedoTexture = textures;
				
				
				for (var i:int = 0; i < 3; i++) {
					planeMaterial[i].getRenderState(0).cull = 0;
					planeMaterial[i].renderQueue = 8000;
					planeMaterial[i].getRenderState(0).depthTest = RenderState.DEPTHTEST_OFF;
					
				}
				isLoad = true;
			}));
		}
		
		public function resetFlag(CameraVector3:Vector3):void
		{
				 Vector3.subtract(CameraVector3,selectFlag.transform.position,posD);
				
				var scale:int = selectFlag.transform.scale.x;
				if (posD.x > 0)
				{
					bluePlane.transform.localPositionX = 0.5 ;
					greenPlane.transform.localPositionX = 0.5;
					greenTilingoffset.x = -1;
					blueTilingoffset.x = -1;
					
					
				}
				else
				{
					bluePlane.transform.localPositionX = -0.5;
					greenPlane.transform.localPositionX = -0.5;
					greenTilingoffset.x = 1;
					blueTilingoffset.x = 1
				}
				if (posD.y > 0)
				{
					redPlane.transform.localPositionY = 0.5;
					bluePlane.transform.localPositionY = 0.5;
					redTilingoffset.y = -1;
					blueTilingoffset.y = 1;
					
				}
				else
				{
					redPlane.transform.localPositionY = -0.5;
					bluePlane.transform.localPositionY = -0.5;
					redTilingoffset.y = 1;
					blueTilingoffset.y = -1;
					
				}
				if (posD.z > 0)
				{
					redPlane.transform.localPositionZ = 0.5;
					greenPlane.transform.localPositionZ = 0.5;
					redTilingoffset.x = -1;
					greenTilingoffset.y = -1;
				}
				else
				{
					redPlane.transform.localPositionZ = -0.5;
					greenPlane.transform.localPositionZ = -0.5;
					redTilingoffset.x = 1;
					greenTilingoffset.y = 1;
					
				}
				redPlane.transform.localPositionX = 0;
				greenPlane.transform.localPositionY = 0;
				bluePlane.transform.localPositionZ = 0;
				bluePlane.transform.localPosition = bluePlane.transform.localPosition;
				redPlane.transform.localPosition = redPlane.transform.localPosition;
				greenPlane.transform.localPosition = greenPlane.transform.localPosition;
			
				planeMaterial[0].tilingOffset = redTilingoffset;
				planeMaterial[1].tilingOffset = greenTilingoffset;
				planeMaterial[2].tilingOffset = blueTilingoffset;
				
		}
		
		//颜色面变亮变暗
		//红的是0，蓝的的1，绿的是2
		public function planeLightInvert(PlaneIndex:int,IsLight:Boolean):void
		{
			if (IsLight)
			{
				planeMaterial[PlaneIndex].albedoTexture = textures;
			}
			else
			{
				planeMaterial[PlaneIndex].albedoTexture = textures2;
			}
		}
		
		
		public function resetScalebyCamera(Cameravector:Vector3):void
		{
			var distance:Number = Vector3.distance(selectFlag.transform.position, Cameravector);
			var s = distance / FACTOR;
			currentScale.x = s;
			currentScale.y = s;
			currentScale.z = s;
			selectFlag.transform.scale = currentScale;
			
		}

	}

}