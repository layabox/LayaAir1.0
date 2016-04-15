package
{
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	
	import laya.ui.List;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	public class Tween_EaseFunctionGraph
	{
		private var duration:int = 3000;
		private var graphWidth:int = 350;
		private var testStartValue:int = 100;
		private var testEndValue:int = 300;
		private var initialX:int = 100;
		
		private var loopInterval:int = 20;
		private var xSpeed:int = graphWidth / (duration / loopInterval);
		
		private var tween:Tween;
		
		private var path:Array = [];
		private var obj:Object = { };
		
		private var prevX:int;
		
		public function Tween_EaseFunctionGraph() 
		{
			Laya.init(550, 400);
			Laya.stage.bgColor = "#3D3D3D";
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			createEaseFunctionList();
			drawGuides();
		}
		
		private function createEaseFunctionList():void
		{
			var easeFunctionsList:List = new List();
			
			easeFunctionsList.itemRender = ListItemRender;
			easeFunctionsList.pos(5,5);

			easeFunctionsList.repeatX = 1;
			easeFunctionsList.repeatY = 100;

			easeFunctionsList.vScrollBarSkin = '';

			easeFunctionsList.selectEnable = true;
			easeFunctionsList.selectHandler = new Handler(this, onEaseFunctionChange, [easeFunctionsList]);
			easeFunctionsList.renderHandler = new Handler(this, renderList);
			Laya.stage.addChild(easeFunctionsList);

			var data:Array = [];
			data.push('backIn', 'backOut', 'backInOut');
			data.push('bounceIn', 'bounceOut', 'bounceInOut');
			data.push('circIn', 'circOut', 'circInOut');
			data.push('cubicIn', 'cubicOut', 'cubicInOut');
			data.push('elasticIn', 'elasticOut', 'elasticInOut');
			data.push('expoIn', 'expoOut', 'expoInOut');
			data.push('linearIn', 'linearOut', 'linearInOut');
			data.push('linearNone');
			data.push('QuadIn', 'QuadOut', 'QuadInOut');
			data.push('quartIn', 'quartOut', 'quartInOut');
			data.push('quintIn', 'quintOut', 'quintInOut');
			data.push('sineIn', 'sineOut', 'sineInOut');
			data.push('strongIn', 'strongOut', 'strongInOut');

			easeFunctionsList.array = data;
		}

		private function renderList(item:ListItemRender):void
		{
			item.setLabel(item.dataSource);
		}
		
		private function onEaseFunctionChange(list:List):void
		{
			obj.val = testStartValue;
			prevX = initialX;
			path.length = 0;
			
			tween && tween.clear();
			tween = Tween.to(obj, { val : testEndValue }, duration, Ease[list.selectedItem], new Handler(this, onTweenComplete));
			
			Laya.timer.clear(this, drawGraph);
			Laya.timer.loop(loopInterval, this, drawGraph);
		}
		
		private function onTweenComplete():void
		{
			Laya.timer.clear(this, drawGraph);
		}
		
		private var old:int;
		private function drawGraph():void
		{
			path.push(["lineTo", prevX, obj.val]);
			trace(obj.val - old);
			old = obj.val;
			prevX += xSpeed;
			Laya.stage.graphics.drawLine
			Laya.stage.graphics.drawPath(0, 0, path, null, { strokeStyle:"cyan", lineWidth:1 });
		}
		
		private function drawGuides():void
		{
			var guideColor:String = "#007878";
			var aimPointRadius:int = 25;
			
			Laya.stage.graphics.drawLine(
				0, testStartValue, 
				Laya.stage.width, testStartValue, 
				guideColor);
			Laya.stage.graphics.drawLine(
				0, testEndValue, 
				Laya.stage.width, testEndValue, 
				guideColor);
			
			Laya.stage.graphics.drawLine(
				initialX, testStartValue - aimPointRadius, 
				initialX, testStartValue + aimPointRadius, 
				guideColor);
			Laya.stage.graphics.drawLine(
				initialX + graphWidth, testEndValue - aimPointRadius, 
				initialX + graphWidth, testEndValue + aimPointRadius, 
				guideColor);
		}
	}
}

import laya.ui.Box;
import laya.ui.Label;
class ListItemRender extends Box
{
	private var label:Label;
	
	public function ListItemRender()
	{
		size(100, 20);
		
		label = new Label();
		label.fontSize = 12;
		label.color = "#FFFFFF";
		addChild(label);
	}
	
	public function setLabel(value:String):void
	{
		label.text = value;
	}
}