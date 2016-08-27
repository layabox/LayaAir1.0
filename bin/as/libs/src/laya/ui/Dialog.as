package laya.ui {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Handler;
	
	/**
	 * <code>Dialog</code> 组件是一个弹出对话框。
	 *
	 * @example 以下示例代码，创建了一个 <code>Dialog</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.Dialog;
	 *		import laya.utils.Handler;
	 *		public class Dialog_Example
	 *		{
	 *			private var dialog:Dialog_Instance;
	 *			public function Dialog_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load("resource/ui/btn_close.png", Handler.create(this, onLoadComplete));//加载资源。
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				dialog = new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
	 *				dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
	 *				dialog.show();//显示 dialog。
	 *				dialog.closeHandler = new Handler(this, onClose);//设置 dialog 的关闭函数处理器。
	 *			}
	 *			private function onClose(name:String):void
	 *			{
	 *				if (name == Dialog.CLOSE)
	 *				{
	 *					trace("通过点击 name 为" + name +"的组件，关闭了dialog。");
	 *				}
	 *			}
	 *		}
	 *	}
	 *	import laya.ui.Button;
	 *	import laya.ui.Dialog;
	 *	import laya.ui.Image;
	 *	class Dialog_Instance extends Dialog
	 *	{
	 *		function Dialog_Instance():void
	 *		{
	 *			var bg:Image = new Image("resource/ui/bg.png");
	 *			bg.sizeGrid = "40,10,5,10";
	 *			bg.width = 150;
	 *			bg.height = 250;
	 *			addChild(bg);
	 *			var image:Image = new Image("resource/ui/image.png");
	 *			addChild(image);
	 *			var button:Button = new Button("resource/ui/btn_close.png");
	 *			button.name = Dialog.CLOSE;//设置button的name属性值。
	 *			button.x = 0;
	 *			button.y = 0;
	 *			addChild(button);
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * var dialog;
	 * Laya.loader.load("resource/ui/btn_close.png", laya.utils.Handler.create(this, loadComplete));//加载资源
	 * (function (_super) {//新建一个类Dialog_Instance继承自laya.ui.Dialog。
	 *     function Dialog_Instance() {
	 *         Dialog_Instance.__super.call(this);//初始化父类
	 *         var bg = new laya.ui.Image("resource/ui/bg.png");//新建一个 Image 类的实例 bg 。
	 *         bg.sizeGrid = "10,40,10,5";//设置 bg 的网格信息。
	 *         bg.width = 150;//设置 bg 的宽度。
	 *         bg.height = 250;//设置 bg 的高度。
	 *         this.addChild(bg);//将 bg 添加到显示列表。
	 *         var image = new laya.ui.Image("resource/ui/image.png");//新建一个 Image 类的实例 image 。
	 *         this.addChild(image);//将 image 添加到显示列表。
	 *         var button = new laya.ui.Button("resource/ui/btn_close.png");//新建一个 Button 类的实例 bg 。
	 *         button.name = laya.ui.Dialog.CLOSE;//设置 button 的 name 属性值。
	 *         button.x = 0;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
	 *         button.y = 0;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
	 *         this.addChild(button);//将 button 添加到显示列表。
	 *     };
	 *     Laya.class(Dialog_Instance,"mypackage.dialogExample.Dialog_Instance",_super);//注册类Dialog_Instance。
	 * })(laya.ui.Dialog);
	 * function loadComplete() {
	 *     console.log("资源加载完成！");
	 *     dialog = new mypackage.dialogExample.Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
	 *     dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
	 *     dialog.show();//显示 dialog。
	 *     dialog.closeHandler = new laya.utils.Handler(this, onClose);//设置 dialog 的关闭函数处理器。
	 * }
	 * function onClose(name) {
	 *     if (name == laya.ui.Dialog.CLOSE) {
	 *         console.log("通过点击 name 为" + name + "的组件，关闭了dialog。");
	 *     }
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Dialog = laya.ui.Dialog;
	 * import Handler = laya.utils.Handler;
	 * class Dialog_Example {
	 *     private dialog: Dialog_Instance;
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load("resource/ui/btn_close.png", Handler.create(this, this.onLoadComplete));//加载资源。
	 *     }
	 *     private onLoadComplete(): void {
	 *         this.dialog = new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
	 *         this.dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
	 *         this.dialog.show();//显示 dialog。
	 *         this.dialog.closeHandler = new Handler(this, this.onClose);//设置 dialog 的关闭函数处理器。
	 *     }
	 *     private onClose(name: string): void {
	 *         if (name == Dialog.CLOSE) {
	 *             console.log("通过点击 name 为" + name + "的组件，关闭了dialog。");
	 *         }
	 *     }
	 * }
	 * import Button = laya.ui.Button;
	 * class Dialog_Instance extends Dialog {
	 *     Dialog_Instance(): void {
	 *         var bg: laya.ui.Image = new laya.ui.Image("resource/ui/bg.png");
	 *         bg.sizeGrid = "40,10,5,10";
	 *         bg.width = 150;
	 *         bg.height = 250;
	 *         this.addChild(bg);
	 *         var image: laya.ui.Image = new laya.ui.Image("resource/ui/image.png");
	 *         this.addChild(image);
	 *         var button: Button = new Button("resource/ui/btn_close.png");
	 *         button.name = Dialog.CLOSE;//设置button的name属性值。
	 *         button.x = 0;
	 *         button.y = 0;
	 *         this.addChild(button);
	 *     }
	 * }
	 * </listing>
	 */
	public class Dialog extends View {
		public static const CLOSE:String = "close";
		public static const CANCEL:String = "cancel";
		public static const SURE:String = "sure";
		public static const NO:String = "no";
		public static const OK:String = "ok";
		public static const YES:String = "yes";
		
		/**@private 表示对话框管理器。*/
		private static var _manager:DialogManager;
		
		/**@private 获取对话框管理器。*/
		public static function get manager():DialogManager {
			return _manager || (_manager = new DialogManager());
		}
		
		/**
		 * 一个布尔值，指定对话框是否居中弹出。
		 *
		 * <p>如果值为true，则居中弹出。</p>
		 */
		public var popupCenter:Boolean = true;
		
		/**
		 * 对话框被关闭时会触发的回调函数处理器。
		 *
		 * <p>回调函数参数为用户点击的按钮名字name:String。</p>
		 */
		public var closeHandler:Handler;
		
		/**
		 * @private (protected)
		 * 一个 <code>Rectangle</code> 矩形对象，用来指定对话框的拖拽区域。
		 */
		protected var _dragArea:Rectangle;
		
		/**@inheritDoc */
		override protected function initialize():void {
			var dragTarget:Sprite = getChildByName("drag") as Sprite;
			if (dragTarget) {
				dragArea = dragTarget.x + "," + dragTarget.y + "," + dragTarget.width + "," + dragTarget.height;
				dragTarget.removeSelf();
			}
			on(Event.CLICK, this, onClick);
		}
		
		/**
		 * @private (protected)
		 * 对象的 <code>Event.CLICK</code> 点击事件侦听处理函数。
		 */
		protected function onClick(e:Event):void {
			var btn:Button = e.target as Button;
			if (btn) {
				switch (btn.name) {
				case CLOSE: 
				case CANCEL: 
				case SURE: 
				case NO: 
				case OK: 
				case YES: 
					close(btn.name);
					break;
				}
			}
		}
		
		/**
		 * 显示对话框（以非模式窗口方式显示）。
		 * @param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
		 */
		public function show(closeOther:Boolean = false):void {
			manager.show(this, closeOther);
		}
		
		/**
		 * 显示对话框（以模式窗口方式显示）。
		 * @param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
		 */
		public function popup(closeOther:Boolean = false):void {
			manager.popup(this, closeOther);
		}
		
		/**
		 * 关闭对话框。
		 * @param type 如果是点击默认关闭按钮触发，则传入关闭按钮的名字(name)，否则为null。
		 */
		public function close(type:String = null):void {
			manager.close(this);
			closeHandler && closeHandler.runWith(type);
		}
		
		/**关闭所有对话框。*/
		public static function closeAll():void {
			manager.closeAll();
		}
		
		/**
		 * 用来指定对话框的拖拽区域。默认值为"0,0,0,0"。
		 * <p><b>格式：</b>构成一个矩形所需的 x,y,width,heith 值，用逗号连接为字符串。
		 * 例如："0,0,100,200"。
		 * </p>
		 *
		 * @see #includeExamplesSummary 请参考示例
		 * @return
		 */
		public function get dragArea():String {
			if (_dragArea) return _dragArea.toString();
			return null;
		}
		
		public function set dragArea(value:String):void {
			if (value) {
				var a:Array = UIUtils.fillArray([0, 0, 0, 0], value, Number);
				_dragArea = new Rectangle(a[0], a[1], a[2], a[3]);
				on(Event.MOUSE_DOWN, this, onMouseDown);
			} else {
				_dragArea = null;
				off(Event.MOUSE_DOWN, this, onMouseDown);
			}
		}
		
		/**
		 * @private
		 */
		private function onMouseDown(e:Event):void {
			var point:Point = this.getMousePoint();
			if (_dragArea.contains(point.x, point.y)) this.startDrag();
			else this.stopDrag();
		}
		
		/**
		 * 弹出框的显示状态；如果弹框处于显示中，则为true，否则为false;
		 * @return
		 */
		public function get isPopup():Boolean {
			return parent != null;
		}
	}
}

import laya.display.Sprite;
import laya.display.Stage;
import laya.events.Event;
import laya.ui.Dialog;

/**
 * <code>DialogManager</code> 类用来管理对话框。
 */
class DialogManager extends Sprite {
	public var dialogLayer:Sprite = new Sprite();
	public var modalLayer:Sprite = new Sprite();
	public var maskLayer:Sprite = new Sprite();
	private var _stage:Stage;
	
	/**
	 * 创建一个新的 <code>DialogManager</code> 类实例。
	 */
	public function DialogManager() {
		this.mouseEnabled = dialogLayer.mouseEnabled = modalLayer.mouseEnabled = maskLayer.mouseEnabled = true;
		addChild(dialogLayer);
		addChild(modalLayer);
		
		_stage = Laya.stage;
		_stage.addChild(this);
		_stage.on(Event.RESIZE, this, onResize);
		onResize(null);
	}
	
	/**
	 * @private
	 * 舞台的 <code>Event.RESIZE</code> 事件侦听处理函数。
	 * @param e
	 */
	private function onResize(e:Event = null):void {
		var width:Number = maskLayer.width = _stage.width;
		var height:Number = maskLayer.height = _stage.height;
		
		maskLayer.graphics.clear();
		maskLayer.graphics.drawRect(0, 0, width, height, UIConfig.popupBgColor);
		maskLayer.alpha = UIConfig.popupBgAlpha;
		
		for (var i:int = dialogLayer.numChildren - 1; i > -1; i--) {
			var item:Dialog = dialogLayer.getChildAt(i) as Dialog;
			if (item.popupCenter) _centerDialog(item);
		}
		for (i = modalLayer.numChildren - 1; i > -1; i--) {
			item = modalLayer.getChildAt(i) as Dialog;
			if (item.isPopup) {
				if (item.popupCenter) _centerDialog(item);
			}
		}
	}
	
	private function _centerDialog(dialog:Dialog):void {
		dialog.x = Math.round(((_stage.width - dialog.width) >> 1) + dialog.pivotX);
		dialog.y = Math.round(((_stage.height - dialog.height) >> 1) + dialog.pivotY);
	}
	
	/**
	 * 显示对话框(非模式窗口类型)。
	 * @param dialog 需要显示的对象框 <code>Dialog</code> 实例。
	 * @param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
	 */
	public function show(dialog:Dialog, closeOther:Boolean = false):void {
		if (closeOther) dialogLayer.removeChildren();
		if (dialog.popupCenter) _centerDialog(dialog);
		dialogLayer.addChild(dialog);
		event(Event.OPEN);
	}
	
	/**
	 * 显示对话框(模式窗口类型)。
	 * @param dialog 需要显示的对象框 <code>Dialog</code> 实例。
	 * @param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
	 */
	public function popup(dialog:Dialog, closeOther:Boolean = false):void {
		if (closeOther) modalLayer.removeChildren();
		if (dialog.popupCenter) _centerDialog(dialog);
		modalLayer.addChild(maskLayer);
		modalLayer.addChild(dialog);
		event(Event.OPEN);
	}
	
	/**
	 * 关闭对话框。
	 * @param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
	 */
	public function close(dialog:Dialog):void {
		dialog.removeSelf();
		if (modalLayer.numChildren < 2) {
			maskLayer.removeSelf();
		} else {
			modalLayer.setChildIndex(maskLayer, modalLayer.numChildren - 2);
		}
		event(Event.CLOSE);
	}
	
	/**
	 * 关闭所有的对话框。
	 */
	public function closeAll():void {
		dialogLayer.removeChildren();
		modalLayer.removeChildren();
		maskLayer.removeSelf();
		event(Event.CLOSE);
	}
}