///////////////////////////////////////////////////////////
//  Axis.as
//  Macromedia ActionScript Implementation of the Class Axis
//  Created on:      2015-12-30 下午2:37:05
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.comps
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.maths.Point;
	
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.ValueChanger;
	
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-30 下午2:37:05
	 */
	public class Axis extends Sprite
	{
		public function Axis()
		{
			super();
			this.mouseEnabled=true;
			this.size(1,1);
			initMe();
			xAxis.rotationControl.on(Event.MOUSE_DOWN,this,controlMouseDown);
			yAxis.rotationControl.on(Event.MOUSE_DOWN, this, controlMouseDown);
			controlBox.on(Event.MOUSE_DOWN, this, controlBoxMouseDown);
			this.on(Event.DRAG_MOVE, this, dragging);
		}
		public var xAxis:ArrowLine=new ArrowLine("X");
		public var yAxis:ArrowLine=new ArrowLine("Y");
		public var controlBox:Rect=new Rect();
		public var _target:Sprite;
		
		private var _lenType:Array = 
		[
		  ["width","height"],
		  ["scaleX","scaleY"]
		];
		private var _type:int=1;
		public function set target(tar:Sprite):void
		{
			_target=tar;
			updateChanges();
		}
		private function updateChanges():void
		{
			if(_target)
			{
				var params:Array;
				params=_lenType[_type];
				xAxis.targetChanger=ValueChanger.create(_target,params[0]);
				yAxis.targetChanger=ValueChanger.create(_target,params[1]);
			}
		}
		public function set type(lenType:int):void
		{
		      _type=lenType;
			  updateChanges();
		}
		public function get type():int
		{
			return _type;
		}
		public function switchType():void
		{
			_type++;
			_type=_type%_lenType.length;
			type=_type;
		}
		private function controlBoxMouseDown(e:Event):void
		{
			this.startDrag();
			
		}
		private var _point:Point = new Point();
		private function dragging():void
		{
			if (_target)
			{
				_point.setTo(this.x, this.y);
				DisControlTool.transPoint(this.parent as Sprite, _target.parent as Sprite,_point);
				//trace("point:",);
				_target.pos(_point.x,_point.y);
			}
		}
		public function get target():Sprite
		{
			return _target;
		}
		public function initMe():void
		{
			addChild(xAxis);
			addChild(yAxis);
			yAxis.rotation=90;
			addChild(controlBox);
			controlBox.posTo(0,0);
		}
		
		private function clearMoveEvents():void
		{
			Laya.stage.off(Event.MOUSE_MOVE,this,stageMouseMove);
			Laya.stage.off(Event.MOUSE_UP,this,stageMouseUp);
		}

		private var oPoint:Point=new Point();
		
		private var myRotationChanger:ValueChanger=ValueChanger.create(this,"rotation");
		
		private var targetRotationChanger:ValueChanger=ValueChanger.create(null,"rotation");
		
		private var stageMouseRotationChanger:ValueChanger=new ValueChanger();
		
		private function controlMouseDown(e:Event):void
		{
			targetRotationChanger.target=target;
			clearMoveEvents();
			oPoint.setTo(0,0);
			myRotationChanger.record();
			oPoint=this.localToGlobal(oPoint);
			
			
			stageMouseRotationChanger.value=getStageMouseRatation();
			stageMouseRotationChanger.record();
			targetRotationChanger.record();


			Laya.stage.on(Event.MOUSE_MOVE,this,stageMouseMove);
			Laya.stage.on(Event.MOUSE_UP,this,stageMouseUp);
		}
		private function getStageMouseRatation():Number
		{
			return MathUtil.getRotation(oPoint.x,oPoint.y,Laya.stage.mouseX,Laya.stage.mouseY);
		}
		private function stageMouseMove(e:Event):void
		{

			stageMouseRotationChanger.value=getStageMouseRatation();
			var dRotation:Number;
			dRotation=-stageMouseRotationChanger.dValue;
			
			if(target)
			{
				targetRotationChanger.showValueByAdd(dRotation);
			}else
			{
				myRotationChanger.showValueByAdd(dRotation);
			}
			
		}
		private function stageMouseUp(e:Event):void
		{
			noticeChange();
			clearMoveEvents();

		}
		private function noticeChange():void
		{
	         trace("rotate:",-stageMouseRotationChanger.dValue);
		}
	}
}