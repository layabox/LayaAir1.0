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
			var astart1:AStarFinder = new AStarFinder(opt);
			var astart2:BestFirstFinder = new BestFirstFinder(opt);
			var astart3:BiAStarFinder = new BiAStarFinder(opt);
			var astart4:BiBestFirstFinder = new BiBestFirstFinder(opt);
			var astart5:BiBreadthFirstFinder = new BiBreadthFirstFinder(opt);
			var astart6:BiDijkstraFinder = new BiDijkstraFinder(opt);
			var astart7:BreadthFirstFinder = new BreadthFirstFinder(opt);
			var astart8:DijkstraFinder = new DijkstraFinder(opt);
			var astart9:IDAStarFinder = new IDAStarFinder(opt);
			var astart10:JPFAlwaysMoveDiagonally = new JPFAlwaysMoveDiagonally(opt);
			var astart11:JPFMoveDiagonallyIfAtMostOneObstacle = new JPFMoveDiagonallyIfAtMostOneObstacle(opt);
			var astart12:JPFMoveDiagonallyIfNoObstacles = new JPFMoveDiagonallyIfNoObstacles(opt);
			var astart13:JPFNeverMoveDiagonally = new JPFNeverMoveDiagonally(opt);
			var astart14:JumpPointFinder = new JumpPointFinder(opt);
			var astart15:JumpPointFinderBase = new JumpPointFinderBase(opt);
			var astart16:TraceFinder = new TraceFinder(opt);
			var grid:Grid = new Grid(64, 36);
			var path:Array = astart1.findPath(23, 16, 33, 16, grid);
			trace(path.toString());
		}
	
	}

}