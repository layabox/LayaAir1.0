///////////////////////////////////////////////////////////
//  ListBase.as
//  Macromedia ActionScript Implementation of the Class ListBase
//  Created on:      2016-7-6 上午9:42:46
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.uicomps
{
	import laya.events.Event;
	import laya.ui.List;
	
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2016-7-6 上午9:42:46
	 */
	public class ListBase extends List
	{
		public function ListBase()
		{
			super();
		}
		override public function set selectedIndex(value:int):void {
			if (_selectedIndex != value) {
				_selectedIndex = value;
				changeSelectStatus();
				event(Event.CHANGE);
				selectHandler && selectHandler.runWith(value);
			}
			
			if (selectEnable && _scrollBar) {
			var numX:int = _isVertical ? repeatX : repeatY;
			if (value < _startIndex || (value + numX > _startIndex + repeatX * repeatY)) {
			scrollTo(value);
			}
			}
		}
	}
}