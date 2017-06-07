package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.runtime.IConchRenderObject;
	import laya.utils.Browser;
	import laya.utils.StringKey;
	import laya.utils.Utils;
	
	/**
	 * ...
	 * @author
	 */
	public class DOM_Form
	{
		private var form:Sprite;
		private var rowHeight:int = 30;
		private var rowSpacing:int = 10;
		
		public function DOM_Form()
		{
			Laya.init(600, 400);
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Laya.stage.bgColor = "#FFFFFF";
			
			form = new Sprite();
			form.size(250, 120);
			form.pos((Laya.stage.width - form.width) / 2, (Laya.stage.height - form.height) / 2);
			Laya.stage.addChild(form);
			
			var rowHeightDelta = rowSpacing + rowHeight;
			
			// 显示左侧标签
			showLabel("邮箱", 0, rowHeightDelta * 0);
			showLabel("出生日期", 0, rowHeightDelta * 1);
			showLabel("密码", 0, rowHeightDelta * 2);
			
			// 显示右侧输入框
			var emailInput:Object = createInputElement();
			var birthdayInput:Object = createInputElement();
			var passwordInput:Object = createInputElement();
			
			birthdayInput.type = "date";
			passwordInput.type = "password";
			
			Laya.stage.on(Event.RESIZE, this, fitDOMElements, [emailInput, birthdayInput, passwordInput]);
		}
		
		private function showLabel(label:String, x:int, y:int):void
		{
			var t:Text = new Text();
			t.height = rowHeight;
			t.valign = "middle";
			t.fontSize = 15;
			t.font = "SimHei";
			t.text = label;
			t.pos(x, y);
			form.addChild(t);
		}
		
		private function createInputElement():Object
		{
			var input:Object = Browser.createElement("input");
			input.style.zIndex = Render.canvas.zIndex + 1;
			input.style.width = "100px";
			Browser.document.body.appendChild(input);
			return input;
		}
		
		private function fitDOMElements():void
		{
			var dom:Object;
			for (var i = 0; i < arguments.length; i++)
			{
				dom = arguments[i];
				Utils.fitDOMElementInArea(dom, form, 100, i * (rowSpacing + rowHeight), 150, rowHeight);
			}
		}
	}

}