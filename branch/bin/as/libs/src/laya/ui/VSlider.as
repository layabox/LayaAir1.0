package laya.ui {
	
	/**
	 * 使用 <code>VSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
	 * <p> <code>VSlider</code> 控件采用垂直方向。滑块轨道从下往上扩展，而标签位于轨道的左右两侧。</p>
	 *
	 * @example 以下示例代码，创建了一个 <code>VSlider</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.HSlider;
	 *		import laya.ui.VSlider;
	 *		import laya.utils.Handler;
	 *		public class VSlider_Example
	 *		{
	 *			private var vSlider:VSlider;
	 *			public function VSlider_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], Handler.create(this, onLoadComplete));//加载资源。
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				vSlider = new VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
	 *				vSlider.skin = "resource/ui/vslider.png";//设置 vSlider 的皮肤。
	 *				vSlider.min = 0;//设置 vSlider 最低位置值。
	 *				vSlider.max = 10;//设置 vSlider 最高位置值。
	 *				vSlider.value = 2;//设置 vSlider 当前位置值。
	 *				vSlider.tick = 1;//设置 vSlider 刻度值。
	 *				vSlider.x = 100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
	 *				vSlider.y = 100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
	 *				vSlider.changeHandler = new Handler(this, onChange);//设置 vSlider 位置变化处理器。
	 *				Laya.stage.addChild(vSlider);//把 vSlider 添加到显示列表。
	 *			}
	 *			private function onChange(value:Number):void
	 *			{
	 *				trace("滑块的位置： value=" + value);
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * var vSlider;
	 * Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], laya.utils.Handler.create(this, onLoadComplete));//加载资源。
	 * function onLoadComplete() {
	 *     vSlider = new laya.ui.VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
	 *     vSlider.skin = "resource/ui/vslider.png";//设置 vSlider 的皮肤。
	 *     vSlider.min = 0;//设置 vSlider 最低位置值。
	 *     vSlider.max = 10;//设置 vSlider 最高位置值。
	 *     vSlider.value = 2;//设置 vSlider 当前位置值。
	 *     vSlider.tick = 1;//设置 vSlider 刻度值。
	 *     vSlider.x = 100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
	 *     vSlider.y = 100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
	 *     vSlider.changeHandler = new laya.utils.Handler(this, onChange);//设置 vSlider 位置变化处理器。
	 *     Laya.stage.addChild(vSlider);//把 vSlider 添加到显示列表。
	 * }
	 * function onChange(value) {
	 *     console.log("滑块的位置： value=" + value);
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import HSlider = laya.ui.HSlider;
	 * import VSlider = laya.ui.VSlider;
	 * import Handler = laya.utils.Handler;
	 * class VSlider_Example {
	 *     private vSlider: VSlider;
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], Handler.create(this, this.onLoadComplete));//加载资源。
	 *     }
	 *     private onLoadComplete(): void {
	 *         this.vSlider = new VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
	 *         this.vSlider.skin = "resource/ui/vslider.png";//设置 vSlider 的皮肤。
	 *         this.vSlider.min = 0;//设置 vSlider 最低位置值。
	 *         this.vSlider.max = 10;//设置 vSlider 最高位置值。
	 *         this.vSlider.value = 2;//设置 vSlider 当前位置值。
	 *         this.vSlider.tick = 1;//设置 vSlider 刻度值。
	 *         this.vSlider.x = 100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
	 *         this.vSlider.y = 100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
	 *         this.vSlider.changeHandler = new Handler(this, this.onChange);//设置 vSlider 位置变化处理器。
	 *         Laya.stage.addChild(this.vSlider);//把 vSlider 添加到显示列表。
	 *     }
	 *     private onChange(value: number): void {
	 *         console.log("滑块的位置： value=" + value);
	 *     }
	 * }
	 * </listing>
	 * @see laya.ui.Slider
	 */
	public class VSlider extends Slider {
	
	}
}