package laya.ui {
	
	/**
	 * 异步Dialog的生命周期:show或者popup > onCreate(如果没有创建过) > onOpen > onClose > onDestroy(如果销毁)
	 * onCreate在页面未创建时执行一次，再次打开页面不会再执行，适合写一些只执行一次的逻辑，比如资源加载，节点事件监听
	 * onOpen在页面每次打开都会执行，适合做一些每次都需要处理的事情，比如消息请求，根据数据初始化页面
	 * onClose在每次关闭的时候调用，适合关闭时停止动画，网络消息监听等逻辑
	 * onDestroy在页面被销毁的时候调用，适合置空引用对象
	 */
	public class AsynDialog extends Dialog {
		/**@private */
		protected var _uiView:Object;
		/**打开时是否关闭其他页面*/
		public var isCloseOther:Boolean;
		
		/**@private */
		override protected function createView(uiView:Object):void {
			_uiView = uiView;
		}
		
		override protected function _open(modal:Boolean, closeOther:Boolean, showEffect:Boolean):void {
			isModal = modal;
			isCloseOther = closeOther;
			manager.lock(true);
			if (_uiView) onCreated();
			else onOpen();
		}
		
		/**
		 * 在页面未创建时执行一次，再次打开页面不会再执行，适合写一些只执行一次的逻辑，比如资源加载，节点事件监听
		 */
		public function onCreated():void {
			createUI();
			onOpen();
		}
		
		/**根据节点数据创建UI*/
		public function createUI():void {
			super.createView(_uiView);
			_uiView = null;
			_dealDragArea();
		}
		
		/**
		 * 在页面每次打开都会执行，适合做一些每次都需要处理的事情，比如消息请求，根据数据初始化页面
		 */
		public function onOpen():void {
			manager.open(this, isCloseOther);
			manager.lock(false);
		}
		
		override public function close(type:String = null, showEffect:Boolean = true):void {
			manager.close(this);
			onClose();
		}
		
		/**
		 * 在每次关闭的时候调用，适合关闭时停止动画，网络消息监听等逻辑
		 */
		public function onClose():void {
		
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_uiView = null;
			onDestroy();
		}
		
		/**
		 * 在页面被销毁的时候调用，适合置空引用对象
		 */
		public function onDestroy():void {
		
		}
	}
}