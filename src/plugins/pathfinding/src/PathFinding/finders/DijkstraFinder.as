package PathFinding.finders 
{
	/**
	 * ...
	 * @author ...
	 */
	public class DijkstraFinder extends AStarFinder 
	{
		
		public function DijkstraFinder(opt:Object) 
		{
			super(opt);
			this.heuristic = function(dx:Number, dy:Number):Number {
				return 0;
			};
		}
		
	}

}