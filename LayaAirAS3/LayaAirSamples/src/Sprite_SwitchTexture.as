package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	public class Sprite_SwitchTexture
	{
		private var texture1:String = "res/apes/monkey2.png";
		private var texture2:String = "res/apes/monkey3.png";
		private var flag:Boolean = false;
		
		private var ape:Sprite;
		
		public function Sprite_SwitchTexture()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			Laya.loader.load([texture1, texture2], Handler.create(this, onAssetsLoaded));
		}
		
		private function onAssetsLoaded():void
		{
			ape = new Sprite();
			Laya.stage.addChild(ape);
			
			// 显示默认纹理
			switchTexture();
			
			ape.on("click", this, switchTexture);
		}
		
		private function switchTexture():void
		{
			var textureUrl:String = (flag = !flag) ? texture1 : texture2;
			
			// 更换纹理
			ape.graphics.clear();
			var texture:Texture = Laya.loader.getRes(textureUrl);
			ape.graphics.drawTexture(texture, 0, 0);
			
			// 设置交互区域
			ape.size(texture.width, texture.height);
		}
	}
}