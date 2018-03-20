///////////////////////////////////////////////////////////
//  DisController.as
//  Macromedia ActionScript Implementation of the Class DisController
//  Created on:      2016-1-14 下午4:32:47
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Sprite;
	
	import laya.debug.tools.comps.Axis;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2016-1-14 下午4:32:47
	 */
	public class DisController
	{
		public function DisController()
		{
			init();
			arrowAxis = new Axis();
			
			arrowAxis.mouseEnabled=true;
		}
		private var arrowAxis:Axis;
		private var _target:Sprite;
		private var recInfo:RecInfo;
		
		private static var _container:Sprite;
		private static function init():void
		{
			if (_container) 
			{
				DisControlTool.setTop(_container);
				return;
			};
			_container=new Sprite();
			_container.mouseEnabled=true;
			Laya.stage.addChild(_container);
		}
		public function set target(target:Sprite):void
		{
			this._target=target;
			if(target)
			{
				_container.addChild(arrowAxis);
				Laya.timer.loop(100, this, updateMe);
			}else
			{
				arrowAxis.removeSelf();
				Laya.timer.clear(this, updateMe);
				
			}
			arrowAxis.target=target;
			updateMe();
		}
		public function get target():Sprite
		{
			return _target;
		}
		public function set type(lenType:int):void
		{
			arrowAxis.type=lenType;
		}
		public function get type():int
		{
			return arrowAxis.type;
		}
		public function switchType():void
		{
			arrowAxis.switchType();
		}
		private function updateMe():void
		{
			if(!_target) return;
			recInfo=RecInfo.getGlobalRecInfo(_target,0,0,1,0,0,1);
			trace("rotation:", recInfo.rotation);
			trace("pos:", recInfo.x, recInfo.y);
			trace("scale:", recInfo.width, recInfo.height);
			
			arrowAxis.x = recInfo.x;
			arrowAxis.y = recInfo.y;
			arrowAxis.rotation = recInfo.rotation;
			arrowAxis.yAxis.rotation = recInfo.rotationV-recInfo.rotation;
		}
		public static var I:DisController=new DisController();
	}
}