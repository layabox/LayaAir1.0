///////////////////////////////////////////////////////////
//  ContextMenu.as
//  Macromedia ActionScript Implementation of the Class ContextMenu
//  Created on:      2015-10-24 下午2:58:37
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.uicomps
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.debug.view.StyleConsts;
	
	import laya.debug.tools.DisControlTool;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-24 下午2:58:37
	 */
	public class ContextMenu extends Box
	{
		public function ContextMenu()
		{
			super();
			StyleConsts.setViewScale(this);
		}
		public static function init():void
		{
			Laya.stage.on(Event.CLICK,null,cleanMenu);
		}
		private static var _menuList:Array=[];
		public static function cleanMenu(e:Event=null):void
		{
			var i:int;
			var len:int;
			len=_menuList.length;
			for(i=0;i<len;i++)
			{
				if(_menuList[i])
				{
					_menuList[i].removeSelf();
				}
			}
			_menuList.length=0;
			
		}
		public static function showMenu(menu:ContextMenu,posX:Number=-999,posY:Number=-999):void
		{
			cleanMenu();
			adptMenu(menu);
			Laya.stage.addChild(menu);
			DisControlTool.showToStage(menu);
			if (posX != -999 && posY != -999)
			{
				menu.pos(posX, posY);
			}
			_menuList.push(menu);
			
		}
		/**创建菜单*/
		public static function createMenu(... args):ContextMenu {
			return createMenuByArray(args);
		}
		/**创建菜单*/
		public static function createMenuByArray(args:Array):ContextMenu {
			//return null;
			var menu:ContextMenu = new ContextMenu();
			var separatorBefore:Boolean = false;
			var item:ContextMenuItem;
			for (var i:int = 0, n:int = args.length; i < n; i++) {
				var obj:Object = args[i];
				var info:Object = { };
				if (obj is String) {
					info.label = obj;
				}else {
					info = obj;
				}
				if (info.label != "") {
					item= new ContextMenuItem(info.label, separatorBefore);
					item.data = obj;
					menu.addItem(item);
					separatorBefore = false;
				} else {
					item = new ContextMenuItem("", separatorBefore);
					item.data = obj;
					menu.addItem(item);
					separatorBefore = true;
				}
			}
			menu.zOrder = 9999;
			return menu;
		}
		public static function adptMenu(menu:ContextMenu):void
		{
			var tWidth:Number = 80;
			var maxWidth:Number=80;
			var i:int, len:int = menu.numChildren;
			for (i = 0; i < len; i++)
			{
				tWidth = (menu.getChildAt(i) as Sprite).width;
				if (maxWidth < tWidth)
				{
					maxWidth = tWidth;
				}
			}
			for (i = 0; i < len; i++)
			{
				(menu.getChildAt(i) as Sprite).width=maxWidth;

			}
		}
		private var _tY:Number=0;
		public function addItem(item:ContextMenuItem):void
		{
			addChild(item);
			item.y=_tY;
			_tY+=item.height;
			
			item.on(Event.MOUSE_DOWN,this,onClick);
			
		}
		private function onClick(e:Event):void
		{
			//trace("ContextMenu:",e);
			event(Event.SELECT,e);
			removeSelf();
		}
		
		public function show(posX:Number=-999,posY:Number=-999):void
		{
			Laya.timer.once(100, this, showMenu, [this,posX,posY]);
			//showMenu(this,posX,posY);
		}
		
	}
}