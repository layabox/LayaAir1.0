package laya.ui {
	
	/**
	 *
	 * 使用 <code>VScrollBar</code> （垂直 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
	 *
	 * @example 以下示例代码，创建了一个 <code>VScrollBar</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.vScrollBar;
	 *		import laya.ui.VScrollBar;
	 *		import laya.utils.Handler;
	 *		public class VScrollBar_Example
	 *		{
	 *			private var vScrollBar:VScrollBar;
	 *			public function VScrollBar_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, onLoadComplete));
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				vScrollBar = new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
	 *				vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
	 *				vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
	 *				vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
	 *				vScrollBar.changeHandler = new Handler(this, onChange);//设置 vScrollBar 的滚动变化处理器。
	 *				Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
	 *			}
	 *			private function onChange(value:Number):void
	 *			{
	 *				trace("滚动条的位置： value=" + value);
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * var vScrollBar;
	 * var res = ["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"];
	 * Laya.loader.load(res, laya.utils.Handler.create(this, onLoadComplete));//加载资源。
	 * function onLoadComplete() {
	 *     vScrollBar = new laya.ui.VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
	 *     vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
	 *     vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
	 *     vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
	 *     vScrollBar.changeHandler = new laya.utils.Handler(this, onChange);//设置 vScrollBar 的滚动变化处理器。
	 *     Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
	 * }
	 * function onChange(value) {
	 *     console.log("滚动条的位置： value=" + value);
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import VScrollBar = laya.ui.VScrollBar;
	 * import Handler = laya.utils.Handler;
	 * class VScrollBar_Example {
	 *     private vScrollBar: VScrollBar;
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, this.onLoadComplete));
	 *     }
	 *     private onLoadComplete(): void {
	 *         this.vScrollBar = new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
	 *         this.vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
	 *         this.vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
	 *         this.vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
	 *         this.vScrollBar.changeHandler = new Handler(this, this.onChange);//设置 vScrollBar 的滚动变化处理器。
	 *         Laya.stage.addChild(this.vScrollBar);//将此 vScrollBar 对象添加到显示列表。
	 *     }
	 *     private onChange(value: number): void {
	 *         console.log("滚动条的位置： value=" + value);
	 *     }
	 * }
	 * </listing>
	 */
	public class VScrollBar extends ScrollBar {
	
	}
}