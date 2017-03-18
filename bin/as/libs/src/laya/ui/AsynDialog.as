package laya.ui {
	
	/**
	 * 异步Dialog，页面视图先不创建，等资源加载完毕或者网络通讯完毕后，手动调用ready再创建节点，并且弹出
	 * 注意：ready之后页面才真正创建，所有对页面节点的操作必须在ready之后执行
	 */
	public class AsynDialog extends Dialog {
		/**@private */
		protected var _uiView:Object;
		
		/**@private */
		override protected function createView(uiView:Object):void {
			_uiView = uiView;
		}
		
		/**页面准备完毕，可以显示了，ready之后页面才真正创建，所有对页面节点的操作必须在ready之后执行*/
		public function ready():void {
			if (_uiView) {
				super.createView(_uiView);
				_uiView = null;
			}
			_dealDragArea();
			callLater(event, ["ready"]);
		}
		
		override public function show(closeOther:Boolean = false):void {
			manager.lock(true);
			once("ready", this, _open, [false, closeOther]);
			beforeOpen();
		}
		
		override public function popup(closeOther:Boolean = false):void {
			manager.lock(true);
			once("ready", this, _open, [true, closeOther]);
			beforeOpen();
		}
		
		/**
		 * 打开页面之前，可以重构此方法，处理一些资源加载或网络通讯工作，准备完毕后，调用ready来呈现页面
		 */
		public function beforeOpen():void {
		
		}
	}
}