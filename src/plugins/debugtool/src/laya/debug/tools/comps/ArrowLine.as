///////////////////////////////////////////////////////////
//  ArrowLine.as
//  Macromedia ActionScript Implementation of the Class ArrowLine
//  Created on:      2015-12-30 下午2:03:32
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.comps
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	
	import laya.debug.tools.ValueChanger;
	
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-30 下午2:03:32
	 */
	public class ArrowLine extends Sprite
	{
		public function ArrowLine(sign:String="X")
		{
			super();
			this.sign = sign;
			addChild(lenControl);
			addChild(rotationControl);
			lenControl.on(Event.MOUSE_DOWN,this,controlMouseDown);
			drawMe();
			
		}
		public var lineLen:Number=160;
		public var arrowLen:Number=10;
		public var lenControl:Rect=new Rect();
		public var rotationControl:Rect = new Rect();
		public var sign:String = "Y";
		public function drawMe():void
		{
			var g:Graphics;
			g=graphics;
			g.clear();
			g.drawLine(0,0,lineLen,0,"#ffff00");
			g.drawLine(lineLen,0,lineLen-arrowLen,-arrowLen,"#ff0000");
			g.drawLine(lineLen, 0, lineLen - arrowLen, arrowLen, "#ff0000");
			g.fillText(sign, 50, -5,"","#ff0000","left");
			
			if(_isMoving&&_targetChanger)
			{
				g.fillText(_targetChanger.key+":"+_targetChanger.value.toFixed(2), lineLen-15, -25,"","#ffff00","center");
			}
			lenControl.posTo(lineLen-15,0);
			rotationControl.posTo(lineLen+10,0);
			this.size(arrowLen,lineLen);
		}

		private var lenChanger:ValueChanger=ValueChanger.create(this,"lineLen");
		private var lenControlXChanger:ValueChanger=ValueChanger.create(lenControl,"x");
		public var _targetChanger:ValueChanger;
		public function set targetChanger(changer:ValueChanger):void
		{
			if(_targetChanger)
			{
				_targetChanger.dispose();
			}
			_targetChanger=changer;
		}
		public function get targetChanger():ValueChanger
		{
			return _targetChanger;
		}
		private function clearMoveEvents():void
		{
			Laya.stage.off(Event.MOUSE_MOVE,this,stageMouseMove);
			Laya.stage.off(Event.MOUSE_UP,this,stageMouseUp);
		}
		private var _isMoving:Boolean=false;
		private function controlMouseDown(e:Event):void
		{
			clearMoveEvents();

			lenControlXChanger.record();
			lenChanger.record();
			if(targetChanger)
			{
				targetChanger.record();
			}

			_isMoving=true;
			Laya.stage.on(Event.MOUSE_MOVE,this,stageMouseMove);
			Laya.stage.on(Event.MOUSE_UP,this,stageMouseUp);
		}
		private function stageMouseMove(e:Event):void
		{
			lenControlXChanger.value=mouseX;
			//lenChanger.showValueByAdd(lenControlXChanger.dValue);
			//if(targetChanger)
			//{
				//targetChanger.showValueByAdd(lenControlXChanger.dValue);
			//}
			
			lenChanger.showValueByScale(lenControlXChanger.scaleValue);
			if(targetChanger)
			{
				targetChanger.showValueByScale(lenControlXChanger.scaleValue);
			}
			drawMe();
		}
		private function stageMouseUp(e:Event):void
		{
			_isMoving=false;
			noticeChange();
			clearMoveEvents();
			lenControlXChanger.recover();
			lenChanger.recover();
//			lenControl.x=preX;
//			lineLen=preLen;
			drawMe();
		}
		private function noticeChange():void
		{
			var dLen:Number;
			dLen=lenChanger.dValue;
			trace("lenChange:",dLen);
		}
	}
}