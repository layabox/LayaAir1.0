package advancedModule 
{
	import common.CameraMoveScript;
	import laya.d3.core.scene.Scene;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author ...
	 */
	public class PBRDemo 
	{
		
		public function PBRDemo() 
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/PBRScene/Demo.ls")) as Scene;
			
			scene.once(Event.HIERARCHY_LOADED, this, function():void
			{
				var camera:Camera = scene.getChildByName("Camera") as Camera;
				camera.addComponent(CameraMoveScript);
			}
		}
		
	}

}