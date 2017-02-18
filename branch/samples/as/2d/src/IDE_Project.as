// TestView.as
package  {
	import game.ui.test.TestPageUI;
	import laya.display.Text;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Label;

	public class TestView extends TestPageUI {

		public function TestView() {
			//btn是编辑器界面设定的，代码里面能直接使用，并且有代码提示
			btn.on(Event.CLICK, this, onBtnClick);
			btn2.on(Event.CLICK, this, onBtn2Click);
		}

		private function onBtnClick():void {
			//手动控制组件属性
			radio.selectedIndex = 1;
			clip.index = 8;
			tab.selectedIndex = 2;
			combobox.selectedIndex = 0;
			check.selected = true;
		}

		private function onBtn2Click():void {
			//通过赋值可以简单快速修改组件属性
			//赋值有两种方式：
			//简单赋值，比如：progress:0.2，就是更改progress组件的value为2
			//复杂复制，可以通知某个属性，比如：label:{color:"#ff0000",text:"Hello LayaAir"}
			box.dataSource = {slider: 50, scroll: 80, progress: 0.2, input: "This is a input", label: {color: "#ff0000", text: "Hello LayaAir"}};

			//list赋值，先获得一个数据源数组
			var arr:Array = [];
			for (var i:int = 0; i < 100; i++) {
				arr.push({label: "item " + i, clip: i % 9});
			}

			//给list赋值更改list的显示
			list.array = arr;

			//还可以自定义list渲染方式，可以打开下面注释看一下效果
			//list.renderHandler = new Handler(this, onListRender);
		}

		private function onListRender(item:Box, index:int):void {
			//自定义list的渲染方式
			var label:Label = item.getChildByName("label") as Label;
			if (index % 2) {
				label.color = "#ff0000";
			} else {
				label.color = "#000000";
			}
		}
	}
}

// Main.as
package {
	import laya.net.Loader;
	import laya.utils.Handler;
	import view.TestView;

	public class Main {

		public function Main() {
			//初始化引擎
			Laya.init(600, 400);

			//加载引擎需要的资源
			Laya.loader.load([{url: "res/atlas/comp.json", type: Loader.ATLAS}], Handler.create(this, onLoaded));
		}

		private function onLoaded():void {
			//示例UI界面
			var testView:TestView = new TestView();
			Laya.stage.addChild(testView);
		}
	}
}