package animationModule 
{
	import laya.d3.component.Animator;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
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
	public class SkinAnimationDemo
	{
		private var changeActionButton:Button;
		private var zombieAnimator:Animator;
		private var curStateIndex:int = 0;
		private var clipName:Array = ["walk","attack","left_fall","right_fall","back_fall"];
		
		public function SkinAnimationDemo() 
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
			camera.transform.translate(new Vector3(0, 1.5, 4));
			camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.direction = new Vector3(0, -0.8, -1);
			directionLight.color = new Vector3(1, 1, 1);
			
			var plane:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/Zombie/new/Plane.lh")) as Sprite3D;
			
			var zombie:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/Zombie/new/Zombie.lh")) as Sprite3D;
			zombie.once(Event.HIERARCHY_LOADED, this, function():void{
				//获取Animator动画组件
				zombieAnimator = (zombie.getChildAt(0) as Sprite3D).getComponentByType(Animator) as Animator;
				zombieAnimator.clip.islooping = true;
				loadUI();
			});
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
					//根据名称播放动画
					zombieAnimator.play(clipName[++curStateIndex % clipName.length]);
				});
				
				var aaa:Button = Laya.stage.addChild(new Button("../../../../res/threeDimen/ui/button.png", "aaaa")) as Button;
				aaa.on(Event.CLICK, this, function():void{
					zombieAnimator.stop();
				});
			}));
		}
		
	}
}