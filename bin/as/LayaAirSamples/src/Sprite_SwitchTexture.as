package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Sprite_SwitchTexture
	{
		private var texture1:String = "res/apes/monkey2.png";
		private var texture2:String = "res/apes/monkey3.png";
		private var flag:Boolean = false;
		
		private var ape:Sprite;
		
		public function Sprite_SwitchTexture()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load([texture1, texture2], Handler.create(this, onAssetsLoaded));
		}
		
		private function onAssetsLoaded():void
		{
			ape = new Sprite();
			Laya.stage.addChild(ape);
			ape.pivot(55, 72);
			ape.pos(Laya.stage.width / 2, Laya.stage.height / 2);
			
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