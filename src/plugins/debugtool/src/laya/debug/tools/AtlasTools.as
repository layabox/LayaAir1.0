package laya.debug.tools
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.resource.Texture;
	//import laya.webgl.atlas.Atlaser;
	//import laya.webgl.atlas.AtlasResourceManager;
	/**
	 * tianpeng
	 * @author 
	 */
	public class AtlasTools 
	{
		
		private var mSprite:Sprite;
		private var mIndex:int = 0;
		private var mTextureDic:Object = { };
		
		private static var mInstance:AtlasTools;
		
		public function AtlasTools() 
		{
			
		}
		
		public static function getInstance():AtlasTools
		{
			return mInstance ||= new AtlasTools();
		}
		
		public function start():void
		{
			if (!Render.isWebGL) return;
			if (mSprite == null)
			{
				mSprite = new Sprite();
			}
			Laya.stage.addChild(mSprite);
			showNext();
		}
		
		public function end():void
		{
			if (!Render.isWebGL) return;
			if (mSprite)
			{
				Laya.stage.removeChild(mSprite);
			}
		}
		
		public function showNext():void
		{
			if (!Render.isWebGL) return;
			if (mSprite == null)
			{
				mSprite = new Sprite();
			}
			Laya.stage.addChild(mSprite);
			mIndex ++;
			var resManager:*;
			__JS__("resManager = laya.webgl.atlas.AtlasResourceManager.instance;");
			var tCount:int =  resManager.getAtlaserCount();
			if (mIndex >= tCount)
			{
				mIndex = 0;
			}
			var tTexture:Texture;
			if (mTextureDic[mIndex])
			{
				tTexture = mTextureDic[mIndex];
			}else {
				var tAtlaser:* = resManager.getAtlaserByIndex(mIndex);
				if (tAtlaser && tAtlaser.texture)
				{
					//tTexture = Texture.create(tAtlaser.texture, 0, 0, 2048, 2048);
					tTexture = new Texture(tAtlaser.texture,null);
					mTextureDic[mIndex] = tTexture;
				}
			}
			if (tTexture)
			{
				mSprite.graphics.clear();
				mSprite.graphics.save();
				mSprite.graphics.alpha(0.9);
				mSprite.graphics.drawRect(0, 0, 1024, 1024, "#efefefe");
				mSprite.graphics.restore();
				mSprite.graphics.drawTexture(tTexture, 0, 0, 1024, 1024);
				mSprite.graphics.fillText((mIndex + 1).toString() +"/" + tCount.toString(),25,100,"40px Arial","#ff0000","left");
			}
		}
		
	}

}