package animationModule
{
	import common.CameraMoveScript;
	import laya.d3.animation.AnimationClip;
	import laya.d3.component.Animator;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BoneLinkSprite3D
	{
		private var statue:int = 0;
		private var dragon1:Sprite3D;
		private var dragon2:Sprite3D;
		private var dragonAnimator1:Animator;
		private var dragonAnimator2:Animator;
		private var _dragonScale:Vector3 = new Vector3(1.5, 1.5, 1.5);
		private var _rotation:Quaternion = new Quaternion( -0.5, -0.5, 0.5, -0.5);
		private var _position:Vector3 = new Vector3( -0.2, 0.0, 0.0);
		private var _scale:Vector3 = new Vector3( 0.75, 0.75, 0.75);
		
		public function BoneLinkSprite3D()
		{
			//初始化引擎
			Laya3D.init(0, 0, true);
			
			//适配模式
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			
			//开启统计信息
			Stat.show();
			
			//预加载所有资源
			var resource:Array = [
				{url: "../../../../res/threeDimen/skinModel/Mount/R_kl_H_001.lh", clas: Sprite3D, priority: 1}, 
				{url: "../../../../res/threeDimen/skinModel/Mount/R_kl_S_009.lh", clas: Sprite3D, priority: 1}, 
				{url: "../../../../res/threeDimen/skinModel/SiPangZi/PanZi.lh", clas: Sprite3D, priority: 1}
			];
			
			Laya.loader.create(resource, Handler.create(this, onLoadFinish));
		}
		
		private function onLoadFinish():void
		{
			//初始化场景
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.ambientColor = new Vector3(1, 1, 1);
			
			//初始化相机
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 3, 5));
			camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			
			//初始化角色精灵
			var role:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			//初始化胖子
			var pangzi:Sprite3D = role.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/SiPangZi/PanZi.lh")) as Sprite3D;
			//获取动画组件
			var animator:Animator = pangzi.getChildAt(0).getComponentByType(Animator) as Animator;
			//获取动画片段
			var totalAnimationClip:AnimationClip = animator.getClip("Take 001");
			//新增动画片段
			animator.addClip(totalAnimationClip, "hello", 296, 346);
			animator.addClip(totalAnimationClip, "ride", 3, 33);
			//播放动画
			animator.play("hello", 1);
			
			Laya.stage.on(Event.MOUSE_UP, this, function():void{
				
				statue ++;
				if (statue % 3 == 1){
					
					animator.play("ride", 1);
					
					dragon1 = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/Mount/R_kl_H_001.lh")) as Sprite3D;
					dragon1.transform.localScale = _dragonScale;
					dragonAnimator1 = dragon1.getChildAt(0).getComponentByType(Animator) as Animator;
					var totalAnimationClip1:AnimationClip = dragonAnimator1.getClip("Take 001");
					totalAnimationClip1.islooping = true;
					dragonAnimator1.addClip(totalAnimationClip1, "run", 50, 65);
					dragonAnimator1.play("run", 1);
					//骨骼关联节点
					dragonAnimator1.linkSprite3DToAvatarNode("point", role);
					
					pangzi.transform.localRotation = _rotation;
					pangzi.transform.localPosition = _position;
					pangzi.transform.localScale = _scale;
				}
				else if (statue % 3 == 2){
					
					animator.play("ride", 1);
					//骨骼取消关联节点
					dragonAnimator1.unLinkSprite3DToAvatarNode(role);
					dragon1.removeSelf();
					
					dragon2 = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/Mount/R_kl_S_009.lh")) as Sprite3D;
					dragon2.transform.localScale = _dragonScale;
					dragonAnimator2 = dragon2.getChildAt(0).getComponentByType(Animator) as Animator;
					var totalAnimationClip2:AnimationClip = dragonAnimator2.getClip("Take 001");
					totalAnimationClip2.islooping = true;
					dragonAnimator2.addClip(totalAnimationClip2, "run", 50, 65);
					dragonAnimator2.play("run", 1);
					//骨骼关联节点
					dragonAnimator2.linkSprite3DToAvatarNode("point", role);
					
					pangzi.transform.localRotation = _rotation;
					pangzi.transform.localPosition = _position;
					pangzi.transform.localScale = _scale;
				}
				else{
					
					animator.play("hello", 1);
					//骨骼取消关联节点
					dragonAnimator2.unLinkSprite3DToAvatarNode(role);
					dragon2.removeSelf();
				}
			});
		}
	}
}