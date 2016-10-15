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
	 * @author ...
	 */
	public class BiAStarFinder
	{
		public var allowDiagonal:Boolean;
		public var dontCrossCorners:Boolean;
		public var diagonalMovement:int;
		public var heuristic:Function;
		public var weight:int;
		
		/**
		 * A* path-finder.
		 * based upon https://github.com/bgrins/javascript-astar
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
		 */
		public function BiAStarFinder(opt:Object)
		{
			opt = opt || {};
			this.allowDiagonal = opt.allowDiagonal;
			this.dontCrossCorners = opt.dontCrossCorners;
			this.diagonalMovement = opt.diagonalMovement;
			this.heuristic = opt.heuristic || Heuristic.manhattan;
			this.weight = opt.weight || 1;
			
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
			
			//When diagonal movement is allowed the manhattan heuristic is not admissible
			//It should be octile instead
			if (this.diagonalMovement == DiagonalMovement.Never)
			{
				this.heuristic = opt.heuristic || Heuristic.manhattan;
			}
			else
			{
				this.heuristic = opt.heuristic || Heuristic.octile;
			}
		}
		
		/**
		 * Find and return the the path.
		 * @return {Array<Array<number>>} The path, including both start and
		 *     end positions.
		 */
		public function findPath(startX:int, startY:int, endX:int, endY:int, grid:Grid):Array
		{
			var cmp:Function = function(nodeA:Node, nodeB:Node):int
			{
				return nodeA.f - nodeB.f;
			};
			var startOpenList:Heap = new Heap(cmp), endOpenList:Heap = new Heap(cmp), startNode:Node = grid.getNodeAt(startX, startY), endNode:Node = grid.getNodeAt(endX, endY), heuristic:Function = this.heuristic, diagonalMovement:int = this.diagonalMovement, weight:int = this.weight, abs:Function = Math.abs, SQRT2:Number = Math.SQRT2, node:Node, neighbors:Array, neighbor:Node, i:int, l:int, x:int, y:int, ng:int, BY_START:int = 1, BY_END:int = 2;
			
			// set the `g` and `f` value of the start node to be 0
			// and push it into the start open list
			startNode.g = 0;
			startNode.f = 0;
			startOpenList.push(startNode);
			startNode.opened = BY_START;
			
			// set the `g` and `f` value of the end node to be 0
			// and push it into the open open list
			endNode.g = 0;
			endNode.f = 0;
			endOpenList.push(endNode);
			endNode.opened = BY_END;
			
			// while both the open lists are not empty
			while (!startOpenList.empty() && !endOpenList.empty())
			{
				
				// pop the position of start node which has the minimum `f` value.
				node = startOpenList.pop() as Node;
				node.closed = true;
				
				// get neigbours of the current node
				neighbors = grid.getNeighbors(node, diagonalMovement);
				for (i = 0, l = neighbors.length; i < l; ++i)
				{
					neighbor = neighbors[i];
					
					if (neighbor.closed)
					{
						continue;
					}
					if (neighbor.opened === BY_END)
					{
						return Util.biBacktrace(node, neighbor);
					}
					
					x = neighbor.x;
					y = neighbor.y;
					
					// get the distance between current node and the neighbor
					// and calculate the next g score
					ng = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);
					
					// check if the neighbor has not been inspected yet, or
					// can be reached with smaller cost from the current node
					if (!neighbor.opened || ng < neighbor.g)
					{
						neighbor.g = ng;
						neighbor.h = neighbor.h || weight * heuristic(abs(x - endX), abs(y - endY));
						neighbor.f = neighbor.g + neighbor.h;
						neighbor.parent = node;
						
						if (!neighbor.opened)
						{
							startOpenList.push(neighbor);
							neighbor.opened = BY_START;
						}
						else
						{
							// the neighbor can be reached with smaller cost.
							// Since its f value has been updated, we have to
							// update its position in the open list
							startOpenList.updateItem(neighbor);
						}
					}
				} // end for each neighbor
				
				// pop the position of end node which has the minimum `f` value.
				node = endOpenList.pop() as Node;
				node.closed = true;
				
				// get neigbours of the current node
				neighbors = grid.getNeighbors(node, diagonalMovement);
				for (i = 0, l = neighbors.length; i < l; ++i)
				{
					neighbor = neighbors[i];
					
					if (neighbor.closed)
					{
						continue;
					}
					if (neighbor.opened === BY_START)
					{
						return Util.biBacktrace(neighbor, node);
					}
					
					x = neighbor.x;
					y = neighbor.y;
					
					// get the distance between current node and the neighbor
					// and calculate the next g score
					ng = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);
					
					// check if the neighbor has not been inspected yet, or
					// can be reached with smaller cost from the current node
					if (!neighbor.opened || ng < neighbor.g)
					{
						neighbor.g = ng;
						neighbor.h = neighbor.h || weight * heuristic(abs(x - startX), abs(y - startY));
						neighbor.f = neighbor.g + neighbor.h;
						neighbor.parent = node;
						
						if (!neighbor.opened)
						{
							endOpenList.push(neighbor);
							neighbor.opened = BY_END;
						}
						else
						{
							// the neighbor can be reached with smaller cost.
							// Since its f value has been updated, we have to
							// update its position in the open list
							endOpenList.updateItem(neighbor);
						}
					}
				} // end for each neighbor
			} // end while not open list empty
			
			// fail to find the path
			return [];
		}
	}

}