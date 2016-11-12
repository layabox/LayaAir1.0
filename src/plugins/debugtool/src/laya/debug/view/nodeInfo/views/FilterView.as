package laya.debug.view.nodeInfo.views 
{
	import laya.display.Input;
	import laya.debug.view.nodeInfo.NodeInfosItem;
	/**
	 * ...
	 * @author ww
	 */
	public class FilterView extends UIViewBase 
	{
		
		public function FilterView() 
		{
			super();
			
		}
		private var input:Input;
		override public function createPanel():void 
		{
			input = new Input();
			input.size(400, 500);
			input.multiline = true;
			input.bgColor = "#ff00ff";
			input.fontSize = 24;
			addChild(input);
		}
		
		override public function show():void 
		{
			input.text = NodeInfosItem.showValues.join("\n");
			super.show();
		}
		override public function close():void 
		{
			super.close();
			NodeInfosItem.showValues = input.text.split("\n");
		}
	}

}