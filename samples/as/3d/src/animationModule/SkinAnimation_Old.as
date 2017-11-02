package animationModule 
{
	import laya.ani.AnimationTemplet;
	import laya.d3.component.Animator;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	/**
	 * ...
	 * @author 
	 */
	public class SkinAnimation_Old 
	{
		private var zombie:Sprite3D;
		private var changeActionButton:Button;
		private var curStateIndex:int = 0;
		private var skinAniUrl:Array = [
			"../../../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@walk-walk.lsani",
			"../../../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@attack-attack.lsani",
			"../../../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@left_fall-left_fall.lsani",
			"../../../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@right_fall-right_fall.lsani",
			"../../../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@back_fall-back_fall.lsani"
		];
		
		public function SkinAnimation_Old()
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.01, 1000))) as Camera;
			camera.transform.translate(new Vector3(0, 1.5, 3));
			camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.color = new Vector3(1, 1, 1);
			
			var plane:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/Zombie/old/Plane.lh")) as Sprite3D;
			
			zombie = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/Zombie/old/Zombie.lh")) as Sprite3D;
			zombie.once(Event.HIERARCHY_LOADED, this, function():void{
				zombie.transform.rotation = new Quaternion( -0.7071068, 0, 0, -0.7071068);
				zombie.transform.position = new Vector3(0.3, 0, 0);
				addSkinComponent(zombie);
				loadUI();
			});
		}
		
		//遍历节点,添加SkinAnimation动画组件
		public function addSkinComponent(spirit3D:Sprite3D):void{
			
			if (spirit3D is MeshSprite3D) {
				var meshSprite3D:MeshSprite3D = spirit3D as MeshSprite3D;
				var skinAni:SkinAnimations = meshSprite3D.addComponent(SkinAnimations) as SkinAnimations;
				skinAni.templet = AnimationTemplet.load(skinAniUrl[0]);
				skinAni.player.play();
			}
			for (var i:int = 0, n:int = spirit3D._childs.length; i < n; i++)
				addSkinComponent(spirit3D._childs[i]);
		}
		
		//遍历节点,播放动画
		public function playSkinAnimation(spirit3D:Sprite3D, index:int):void{
			
			if (spirit3D is MeshSprite3D) {
				var meshSprite3D:MeshSprite3D = spirit3D as MeshSprite3D;
				var skinAni:SkinAnimations = meshSprite3D.getComponentByType(SkinAnimations) as SkinAnimations;
				skinAni.templet = AnimationTemplet.load(skinAniUrl[index]);
				skinAni.player.play();
			}
			for (var i:int = 0, n:int = spirit3D._childs.length; i < n; i++)
				playSkinAnimation(spirit3D._childs[i], index);
		}
		
		private function loadUI():void {
			
			Laya.loader.load(["../../../../res/threeDimen/ui/button.png"], Handler.create(null, function():void {
				
				changeActionButton = Laya.stage.addChild(new Button("../../../../res/threeDimen/ui/button.png", "切换动作")) as Button;
				changeActionButton.size(160, 40);
				changeActionButton.labelBold = true;
				changeActionButton.labelSize = 30;
				changeActionButton.sizeGrid = "4,4,4,4";
				changeActionButton.scale(Browser.pixelRatio, Browser.pixelRatio);
				changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
				changeActionButton.on(Event.CLICK, this, function():void{
					playSkinAnimation(zombie, ++curStateIndex % skinAniUrl.length);
				});
			}));
		}
		
	}
}