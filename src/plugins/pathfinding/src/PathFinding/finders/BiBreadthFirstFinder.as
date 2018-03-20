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
	public class BiBreadthFirstFinder
	{
		private var allowDiagonal:Boolean;
		private var dontCrossCorners:Boolean;
		private var heuristic:Function;
		private var weight:int;
		private var diagonalMovement:int;
		
		/**
		 * Bi-directional Breadth-First-Search path finder.
		 * @constructor
		 * @param {object} opt
		 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
		 *     Deprecated, use diagonalMovement instead.
		 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
		 *     block corners. Deprecated, use diagonalMovement instead.
		 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
		 */
		public function BiBreadthFirstFinder(opt:Object)
		{
			opt = opt || {};
			this.allowDiagonal = opt.allowDiagonal;
			this.dontCrossCorners = opt.dontCrossCorners;
			this.diagonalMovement = opt.diagonalMovement;
			
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
		}
		
		/**
		 * Find and return the the path.
		 * @return {Array<Array<number>>} The path, including both start and
		 *     end positions.
		 */
		public function findPath(startX:int, startY:int, endX:int, endY:int, grid:Grid):Array
		{
			var startNode:Node = grid.getNodeAt(startX, startY), endNode:Node = grid.getNodeAt(endX, endY), startOpenList:Array = [], endOpenList:Array = [], neighbors:Array, neighbor:Node, node:Node, diagonalMovement:int = this.diagonalMovement, BY_START:int = 0, BY_END:int = 1, i:int, l:int;
			
			// push the start and end nodes into the queues
			startOpenList.push(startNode);
			startNode.opened = true;
			startNode.by = BY_START;
			
			endOpenList.push(endNode);
			endNode.opened = true;
			endNode.by = BY_END;
			
			// while both the queues are not empty
			while (startOpenList.length && endOpenList.length)
			{
				
				// expand start open list
				
				node = startOpenList.shift();
				node.closed = true;
				
				neighbors = grid.getNeighbors(node, diagonalMovement);
				for (i = 0, l = neighbors.length; i < l; ++i)
				{
					neighbor = neighbors[i];
					
					if (neighbor.closed)
					{
						continue;
					}
					if (neighbor.opened)
					{
						// if this node has been inspected by the reversed search,
						// then a path is found.
						if (neighbor.by === BY_END)
						{
							return Util.biBacktrace(node, neighbor);
						}
						continue;
					}
					startOpenList.push(neighbor);
					neighbor.parent = node;
					neighbor.opened = true;
					neighbor.by = BY_START;
				}
				
				// expand end open list
				
				node = endOpenList.shift();
				node.closed = true;
				
				neighbors = grid.getNeighbors(node, diagonalMovement);
				for (i = 0, l = neighbors.length; i < l; ++i)
				{
					neighbor = neighbors[i];
					
					if (neighbor.closed)
					{
						continue;
					}
					if (neighbor.opened)
					{
						if (neighbor.by === BY_START)
						{
							return Util.biBacktrace(neighbor, node);
						}
						continue;
					}
					endOpenList.push(neighbor);
					neighbor.parent = node;
					neighbor.opened = true;
					neighbor.by = BY_END;
				}
			}
			
			// fail to find the path
			return [];
		}
	}

}