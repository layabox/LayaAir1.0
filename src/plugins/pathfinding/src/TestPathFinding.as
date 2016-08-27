package
{
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	import PathFinding.finders.AStarFinder;
	import PathFinding.finders.BestFirstFinder;
	import PathFinding.finders.BiAStarFinder;
	import PathFinding.finders.BiBestFirstFinder;
	import PathFinding.finders.BiBreadthFirstFinder;
	import PathFinding.finders.BiDijkstraFinder;
	import PathFinding.finders.BreadthFirstFinder;
	import PathFinding.finders.DijkstraFinder;
	import PathFinding.finders.IDAStarFinder;
	import PathFinding.finders.JPFAlwaysMoveDiagonally;
	import PathFinding.finders.JPFMoveDiagonallyIfAtMostOneObstacle;
	import PathFinding.finders.JPFMoveDiagonallyIfNoObstacles;
	import PathFinding.finders.JPFNeverMoveDiagonally;
	import PathFinding.finders.JumpPointFinder;
	import PathFinding.finders.JumpPointFinderBase;
	import PathFinding.finders.TraceFinder;
	
	/**
	 * ...
	 * @author dongketao
	 */
	public class TestPathFinding
	{
		
		public function TestPathFinding()
		{
			var opt:Object = {allowDiagonal: true, dontCrossCorners: false, heuristic: Heuristic["manhattan"], weight: 1};
			var astart:AStarFinder = new AStarFinder(opt);
			var grid:Grid = new Grid(64, 36);
			var path:Array = astart.findPath(23, 16, 33, 16, grid);
			trace(path.toString());
		}
	
	}

}