package laya.effect 
{
	import laya.filters.BlurFilter;
	/**
	 * ...
	 * @author ww
	 */
	public class BlurFilterSetter extends FilterSetterBase 
	{
		private var _strength:Number=4;
		public function BlurFilterSetter() 
		{
			super();
			_filter = new BlurFilter(strength);
		}
		
		override protected function buildFilter():void 
		{
			_filter = new BlurFilter(strength);
			super.buildFilter();
		}
		
		public function get strength():Number 
		{
			return _strength;
		}
		
		public function set strength(value:Number):void 
		{
			_strength = value;
		}
	}

}