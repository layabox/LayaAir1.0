package laya.ui {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Component;
	import laya.ui.Dialog;
	import laya.utils.Ease;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	/**
	 * <code>DialogManager</code> 对话框管理容器，所有的对话框都在该容器内，并且受管理器管理。
	 * 任意对话框打开和关闭，都会出发管理类的open和close事件
	 * 可以通过UIConfig设置弹出框背景透明度，模式窗口点击边缘是否关闭，点击窗口是否切换层次等
	 * 通过设置对话框的zOrder属性，可以更改弹出的层次
	 */
	public class DialogManager extends Sprite {
		/**遮罩层*/
		public var maskLayer:Sprite = new Sprite();
		/**锁屏层*/
		public var lockLayer:Sprite;
		
		/**弹出对话框效果，可以设置一个效果代替默认的弹出效果，如果不想有任何效果，可以赋值为null*/
		public var popupEffect:Function = function(dialog:Sprite):void {
			dialog.scale(1, 1);
			Tween.from(dialog, {x: Laya.stage.width / 2, y: Laya.stage.height / 2, scaleX: 0, scaleY: 0}, 300, Ease.backOut);
		}
		
		/**关闭对话框效果，可以设置一个效果代替默认的关闭效果，如果不想有任何效果，可以赋值为null*/
		public var closeEffect:Function = function(dialog:Sprite):void {
			var _this:DialogManager = this;
			Tween.to(dialog, {x: Laya.stage.width / 2, y: Laya.stage.height / 2, scaleX: 0, scaleY: 0}, 300, Ease.strongOut, Handler.create(_this, _this._doClose, [dialog]));
		}
		
		/**
		 * 创建一个新的 <code>DialogManager</code> 类实例。
		 */
		public function DialogManager() {
			this.mouseEnabled = maskLayer.mouseEnabled = true;
			this.zOrder = 1000;
			
			Laya.stage.addChild(this);
			Laya.stage.on(Event.RESIZE, this, _onResize);
			if (UIConfig.closeDialogOnSide) maskLayer.on("click", this, _closeOnSide);
			_onResize(null);
		}
		
		private function _closeOnSide():void {
			var dialog:Dialog = getChildAt(numChildren - 1) as Dialog;
			if (dialog is Dialog) dialog.close("side");
		}
		
		/**设置锁定界面，如果为空则什么都不显示*/
		public function setLockView(value:Component):void {
			if (!lockLayer) {
				lockLayer = new Box();
				lockLayer.mouseEnabled = true;
				lockLayer.size(Laya.stage.width, Laya.stage.height);
			}
			lockLayer.removeChildren();
			if (value) {
				value.centerX = value.centerY = 0;
				lockLayer.addChild(value);
			}
		}
		
		/**@private */
		private function _onResize(e:Event = null):void {
			var width:Number = maskLayer.width = Laya.stage.width;
			var height:Number = maskLayer.height = Laya.stage.height;
			if (lockLayer) lockLayer.size(width, height);
			
			maskLayer.graphics.clear();
			maskLayer.graphics.drawRect(0, 0, width, height, UIConfig.popupBgColor);
			maskLayer.alpha = UIConfig.popupBgAlpha;
			
			for (var i:int = numChildren - 1; i > -1; i--) {
				var item:Dialog = getChildAt(i) as Dialog;
				if (item.popupCenter) _centerDialog(item);
			}
		}
		
		private function _centerDialog(dialog:Dialog):void {
			dialog.x = Math.round(((Laya.stage.width - dialog.width) >> 1) + dialog.pivotX);
			dialog.y = Math.round(((Laya.stage.height - dialog.height) >> 1) + dialog.pivotY);
		}
		
		/**
		 * 显示对话框(非模式窗口类型)。
		 * @param dialog 需要显示的对象框 <code>Dialog</code> 实例。
		 * @param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
		 */
		public function open(dialog:Dialog, closeOther:Boolean = false):void {
			if (closeOther) removeChildren();
			if (dialog.popupCenter) _centerDialog(dialog);
			addChild(dialog);
			if (dialog.isModal || this._$P["hasZorder"]) timer.callLater(this, _checkMask);
			popupEffect && popupEffect(dialog);
			event(Event.OPEN);
		}
		
		/**
		 * 锁定所有层，显示加载条信息，防止双击
		 */
		public function lock(value:Boolean):void {
			if (lockLayer) {
				if (value) addChild(lockLayer);
				else lockLayer.removeSelf();
			}
		}
		
		/**
		 * 关闭对话框。
		 * @param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
		 */
		public function close(dialog:Dialog):void {
			if (closeEffect != null) closeEffect(dialog);
			else _doClose(dialog);
		}
		
		private function _doClose(dialog:Dialog):void {
			dialog.removeSelf();
			dialog.isModal && _checkMask();
			dialog.closeHandler && dialog.closeHandler.run();
			event(Event.CLOSE);
		}
		
		/**
		 * 关闭所有的对话框。
		 */
		public function closeAll():void {
			removeChildren();
			event(Event.CLOSE);
		}
		
		/**
		 * 根据组获取所有对话框
		 * @param	group 组名称
		 * @return	对话框数组
		 */
		public function getDialogsByGroup(group:String):Array {
			var arr:Array = [];
			for (var i:int = numChildren - 1; i > -1; i--) {
				var item:Dialog = getChildAt(i) as Dialog;
				if (item.group === group) {
					arr.push(item);
				}
			}
			return arr;
		}
		
		/**
		 * 根据组关闭所有弹出框
		 * @param	group 需要关闭的组名称
		 */
		public function closeByGround(group:String):Array {
			var arr:Array = [];
			for (var i:int = numChildren - 1; i > -1; i--) {
				var item:Dialog = getChildAt(i) as Dialog;
				if (item.group === group) {
					item.close();
				}
			}
			return arr;
		}
		
		/**@private 发生层次改变后，重新检查遮罩层是否正确*/
		public function _checkMask():void {
			maskLayer.removeSelf();
			for (var i:int = numChildren - 1; i > -1; i--) {
				var dialog:Dialog = getChildAt(i) as Dialog;
				if (dialog && dialog.isModal) {
					//trace(numChildren,i);
					addChildAt(maskLayer, i);
					return;
				}
			}
		}
	}
}