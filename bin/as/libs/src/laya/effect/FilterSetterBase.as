package laya.effect 
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.utils.Utils;
	/**
	 * ...
	 * @author ww
	 */
	public class FilterSetterBase
	{
		public var _filter:*;
		public function FilterSetterBase() 
		{
			
		}
		
		public function paramChanged():void
		{
			Laya.systemTimer.callLater(this, buildFilter);
		}
		
		protected function buildFilter():void
		{
			if (_target)
			{
				addFilter(_target);
			}
		}
		
		protected function addFilter(sprite:Sprite):void
		{
			if (!sprite) return;
			
			if (!sprite.filters)
			{
				sprite.filters = [_filter];
			}else
			{
				
				var preFilters:Array;
				preFilters = sprite.filters;
				if (preFilters.indexOf(_filter) < 0)
				{
				
					preFilters.push(_filter);
					sprite.filters = Utils.copyArray([], preFilters);
				}
			}
		}
		
		protected function removeFilter(sprite:Sprite):void
		{
			if (!sprite) return;
			sprite.filters = null;
		}
		
		private var _target:*;
		public function set target(value:*):void
		{
			if (_target != value)
			{
				//removeFilter(_target as Sprite);
				//addFilter(value as Sprite);
				_target = value;
				paramChanged();
			}
		}

	}

}