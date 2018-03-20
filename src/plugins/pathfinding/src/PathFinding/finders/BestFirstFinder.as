package PathFinding.finders
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class BestFirstFinder extends AStarFinder
	{
		
		public function BestFirstFinder(opt:Object)
		{
			super(opt);
			var orig:Function = this.heuristic;
			this.heuristic = function(dx:Number, dy:Number):Number
			{
				return orig(dx, dy) * 1000000;
			};
		}
	
	}

}