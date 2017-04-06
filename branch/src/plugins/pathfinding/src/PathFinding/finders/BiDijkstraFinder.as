package PathFinding.finders 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BiDijkstraFinder extends BiAStarFinder 
	{
		
		public function BiDijkstraFinder(opt:Object) 
		{
			super(opt);
			this.heuristic = function(dx:Number, dy:Number):Number {
				return 0;
			};
		}
		
	}

}