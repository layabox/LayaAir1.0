package PathFinding.finders
{
	import PathFinding.core.DiagonalMovement;
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	import PathFinding.core.Node;
	import PathFinding.core.Util;
	import PathFinding.libs.Heap;
	
	/**
	 * ...
	 * @author dongketao
	 */
	public class IDAStarFinder
	{
		private var allowDiagonal:Boolean;
		private var dontCrossCorners:Boolean;
		private var heuristic:Function;
		private var weight:int;
		private var diagonalMovement:int;
		private var trackRecursion:Boolean;
		private var timeLimit:Number;
		
		/**
		 * Iterative Deeping A Star (IDA*) path-finder.
		 *
		 * Recursion based on:
		 *   http://www.apl.jhu.edu/~hall/AI-Programming/IDA-Star.html
		 *
		 * Path retracing based on:
		 *  V. Nageshwara Rao, Vipin Kumar and K. Ramesh
		 *  "A Parallel Implementation of Iterative-Deeping-A*", January 1987.
		 *  ftp://ftp.cs.utexas.edu/.snapshot/hourly.1/pub/AI-Lab/tech-reports/UT-AI-TR-87-46.pdf
		 *
		 * @author Gerard Meier (www.gerardmeier.com)
		 *
		 * @constructor
		 * @param {Object} opt
		 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
		 *     Deprecated, use diagonalMovement instead.
		 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
		 *     block corners. Deprecated, use diagonalMovement instead.
		 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
		 * @param {function} opt.heuristic Heuristic function to estimate the distance
		 *     (defaults to manhattan).
		 * @param {number} opt.weight Weight to apply to the heuristic to allow for
		 *     suboptimal paths, in order to speed up the search.
		 * @param {boolean} opt.trackRecursion Whether to track recursion for
		 *     statistical purposes.
		 * @param {number} opt.timeLimit Maximum execution time. Use <= 0 for infinite.
		 */
		public function IDAStarFinder(opt:Object)
		{
			opt = opt || {};
			this.allowDiagonal = opt.allowDiagonal;
			this.dontCrossCorners = opt.dontCrossCorners;
			this.diagonalMovement = opt.diagonalMovement;
			this.heuristic = opt.heuristic || Heuristic.manhattan;
			this.weight = opt.weight || 1;
			this.trackRecursion = opt.trackRecursion || false;
			this.timeLimit = opt.timeLimit || Infinity; // Default: no time limit.
			
			if (!this.diagonalMovement)
			{
				if (!this.allowDiagonal)
				{
					this.diagonalMovement = DiagonalMovement.Never;
				}
				else
				{
					if (this.dontCrossCorners)
					{
						this.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;
					}
					else
					{
						this.diagonalMovement = DiagonalMovement.IfAtMostOneObstacle;
					}
				}
			}
			
			// When diagonal movement is allowed the manhattan heuristic is not
			// admissible, it should be octile instead
			if (this.diagonalMovement === DiagonalMovement.Never)
			{
				this.heuristic = opt.heuristic || Heuristic.manhattan;
			}
			else
			{
				this.heuristic = opt.heuristic || Heuristic.octile;
			}
		}
		
		/**
		 * Find and return the the path. When an empty array is returned, either
		 * no path is possible, or the maximum execution time is reached.
		 *
		 * @return {Array<Array<number>>} The path, including both start and
		 *     end positions.
		 */
		public function findPath(startX:int, startY:int, endX:int, endY:int, grid:Grid):Array
		{
			// Used for statistics:
			var nodesVisited:int = 0;
			
			// Execution time limitation:
			var startTime:Number = new Date().getTime();
			
			// Heuristic helper:
			var h:Function = function(a:Node, b:Node):Number
			{
				return this.heuristic(Math.abs(b.x - a.x), Math.abs(b.y - a.y));
			}/*.bind(this);*/
			
			// Step cost from a to b:
			var cost:Function = function(a:Node, b:Node):Number
			{
				return (a.x === b.x || a.y === b.y) ? 1 : Math.SQRT2;
			};
			
			/**
			 * IDA* search implementation.
			 *
			 * @param {Node} The node currently expanding from.
			 * @param {number} Cost to reach the given node.
			 * @param {number} Maximum search depth (cut-off value).
			 * @param {Array<Array<number>>} The found route.
			 * @param {number} Recursion depth.
			 *
			 * @return {Object} either a number with the new optimal cut-off depth,
			 * or a valid node instance, in which case a path was found.
			 */
			var search:Function = function(node:Node, g:int, cutoff:int, route:int, depth:int):*
			{
				nodesVisited++;
				
				// Enforce timelimit:
				if (this.timeLimit > 0 && new Date().getTime() - startTime > this.timeLimit * 1000)
				{
					// Enforced as "path-not-found".
					return Infinity;
				}
				
				var f:Number = g + h(node, end) * this.weight;
				
				// We've searched too deep for this iteration.
				if (f > cutoff)
				{
					return f;
				}
				
				if (node == end)
				{
					route[depth] = [node.x, node.y];
					return node;
				}
				
				var min:int, t:int, k:int, neighbour:Node;
				
				var neighbours:Array = grid.getNeighbors(node, this.diagonalMovement);
				
				// Sort the neighbours, gives nicer paths. But, this deviates
				// from the original algorithm - so I left it out.
				//neighbours.sort(function(a, b){
				//    return h(a, end) - h(b, end);
				//});
				
				/*jshint -W084 */ //Disable warning: Expected a conditional expression and instead saw an assignment
				for (k = 0, min = Infinity; neighbour = neighbours[k]; ++k)
				{
					/*jshint +W084 */ //Enable warning: Expected a conditional expression and instead saw an assignment
					if (this.trackRecursion)
					{
						// Retain a copy for visualisation. Due to recursion, this
						// node may be part of other paths too.
						neighbour.retainCount = neighbour.retainCount + 1 || 1;
						
						if (neighbour.tested != true)
						{
							neighbour.tested = true;
						}
					}
					
					t = search(neighbour, g + cost(node, neighbour), cutoff, route, depth + 1);
					
					if (t is Node)
					{
						route[depth] = [node.x, node.y];
						
						// For a typical A* linked list, this would work:
						// neighbour.parent = node;
						return t;
					}
					
					// Decrement count, then determine whether it's actually closed.
					if (this.trackRecursion && (--neighbour.retainCount) === 0)
					{
						neighbour.tested = false;
					}
					
					if (t < min)
					{
						min = t;
					}
				}
				
				return min;
			
			}/*.bind(this);*/
			
			// Node instance lookups:
			var start:Node = grid.getNodeAt(startX, startY);
			var end:Node = grid.getNodeAt(endX, endY);
			
			// Initial search depth, given the typical heuristic contraints,
			// there should be no cheaper route possible.
			var cutOff:Number = h(start, end);
			
			var j:int, route:Array, t:int;
			
			// With an overflow protection.
			for (j = 0; true; ++j)
			{
				
				route = [];
				
				// Search till cut-off depth:
				t = search(start, 0, cutOff, route, 0);
				
				// Route not possible, or not found in time limit.
				if (t == Infinity)
				{
					route = [];
					break;
					//return [];
				}
				
				// If t is a node, it's also the end node. Route is now
				// populated with a valid path to the end node.
				if (t is Node)
				{
					break;
					//return route;
				}
				
				// Try again, this time with a deeper cut-off. The t score
				// is the closest we got to the end node.
				cutOff = t;
			}
			
			// This _should_ never to be reached.
			return route;
		}
	}

}