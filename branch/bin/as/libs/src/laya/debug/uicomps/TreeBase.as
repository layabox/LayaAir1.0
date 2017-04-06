///////////////////////////////////////////////////////////
//  TreeBase.as
//  Macromedia ActionScript Implementation of the Class TreeBase
//  Created on:      2016-7-6 上午9:49:47
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.uicomps
{
	import laya.events.Event;
	import laya.ui.Tree;
	import laya.utils.Handler;
	
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2016-7-6 上午9:49:47
	 */
	public class TreeBase extends Tree
	{
		public function TreeBase()
		{
			super();
		}
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_list = new ListBase());
			_list.renderHandler = Handler.create(this, renderItem, null, false);
			_list.repeatX = 1;
			_list.on(Event.CHANGE, this, onListChange);
		}
	}
}