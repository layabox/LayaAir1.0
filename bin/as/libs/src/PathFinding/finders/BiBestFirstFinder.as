package PathFinding.finders
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class BiBestFirstFinder extends BiAStarFinder
	{
		
		public function BiBestFirstFinder(opt:Object)
		{
			super(opt);
			var orig:Function = this.heuristic;
			this.heuristic = function(dx, dy):Number
			{
				return orig(dx, dy) * 1000000;
			};
		}
	
	}

}