package common 
{
	import laya.d3.core.Camera;
	import laya.d3.core.HeightMap;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.MeshTerrainSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author asanwu
	 */
	public class CreateHeightMap
	{
		//生成高度图的宽度
		public var width:int = 64;
		//生成高度图的高度
		public var height:int = 64;
		
		public function CreateHeightMap()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(0, 0.1, 2000))) as Camera;
			
			//3d场景
			var sceneSprite3d:Sprite3D = scene.addChild(Sprite3D.load("maze/maze.lh")) as Sprite3D;
			
			sceneSprite3d.once(Event.HIERARCHY_LOADED, this, function():void
			{
				var v2:Vector2 = new Vector2();
				//获取3d场景中需要采集高度数据的网格精灵,这里需要美术根据场景中可行走区域建模型
				var meshSprite3D:MeshSprite3D = sceneSprite3d.getChildAt(0) as MeshSprite3D;
				var heightMap:HeightMap = HeightMap.creatFromMesh(meshSprite3D.meshFilter.sharedMesh as Mesh, width, height, v2);
				var maxHeight:Number = heightMap.maxHeight;
				var minHeight:Number = heightMap.minHeight;
				//获取最大高度和最小高度,使用高度图时需要此数据
				trace("-----------------------------");
				trace(maxHeight, minHeight);
				trace("-----------------------------");
				var compressionRatio:Number = (maxHeight - minHeight) / 254;
				//把高度数据画到canvas画布上,并保存为png图片
				pringScreen(width, height, compressionRatio, minHeight, heightMap);
			});
		}
		
		private function pringScreen(tWidth:Number, tHeight:Number, cr:Number, min:Number, th:HeightMap):void
		{
			var pixel:* = Laya.stage.drawToCanvas(tWidth, tHeight, 0, 0);
			
			var tRed:Number, tGreed:Number, tBlue:Number, tAlpha:Number;
			tRed = tGreed = tBlue = tAlpha = 0xFF;
			var tStr:String = "";
			
			var ncanvas:* = Browser.createElement('canvas');
			ncanvas.setAttribute('width', tWidth.toString());
			ncanvas.setAttribute('height', tHeight.toString());
			
			var ctx:* = ncanvas.getContext("2d");
			
			var tI:int = 0;
			for (var i:int = 0; i < tHeight; i++)
			{
				for (var j:int = 0; j < tWidth; j++)
				{
					var oriHeight:Number = th.getHeight(i, j);
					if (isNaN(oriHeight))
					{
						tRed = 255;
						tGreed = 255;
						tBlue = 255;
					}
					else
					{
						var height:Number = Math.round((oriHeight - min) / cr);
						tRed = height;
						tGreed = height;
						tBlue = height;
					}
					tAlpha = 1;
					
					tStr = "rgba(" + tRed.toString() + "," + tGreed.toString() + "," + tBlue.toString() + "," + tAlpha.toString() + ")";
					__JS__('ctx.fillStyle = tStr');
					__JS__('ctx.fillRect(j, i, 1, 1)');
					
				}
			}
			var image = ncanvas.toDataURL("image/png").replace("image/png", "image/octet-stream;Content-Disposition: attachment;filename=foobar.png");
			__JS__('window.location.href=image');
		}
	}
}