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
	public class BreadthFirstFinder
	{
		private var allowDiagonal:Boolean;
		private var dontCrossCorners:Boolean;
		private var heuristic:Function;
		private var weight:int;
		private var diagonalMovement:int;
		
		/**
		 * Breadth-First-Search path finder.
		 * @constructor
		 * @param {Object} opt
		 * @param {boolean} opt.allowDiagonal Whether diagonal movement is allowed.
		 *     Deprecated, use diagonalMovement instead.
		 * @param {boolean} opt.dontCrossCorners Disallow diagonal movement touching
		 *     block corners. Deprecated, use diagonalMovement instead.
		 * @param {DiagonalMovement} opt.diagonalMovement Allowed diagonal movement.
		 */
		public function BreadthFirstFinder(opt:Object)
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
			var openList:Array = [], diagonalMovement:int = this.diagonalMovement, startNode:Node = grid.getNodeAt(startX, startY), endNode:Node = grid.getNodeAt(endX, endY), neighbors:Array, neighbor:Node, node:Node, i:int, l:int;
			
			// push the start pos into the queue
			openList.push(startNode);
			startNode.opened = true;
			
			// while the queue is not empty
			while (openList.length)
			{
				// take the front node from the queue
				node = openList.shift();
				node.closed = true;
				
				// reached the end position
				if (node === endNode)
				{
					return Util.backtrace(endNode);
				}
				
				neighbors = grid.getNeighbors(node, diagonalMovement);
				for (i = 0, l = neighbors.length; i < l; ++i)
				{
					neighbor = neighbors[i];
					
					// skip this neighbor if it has been inspected before
					if (neighbor.closed || neighbor.opened)
					{
						continue;
					}
					
					openList.push(neighbor);
					neighbor.opened = true;
					neighbor.parent = node;
				}
			}
			
			// fail to find the path
			return [];
		}
	}

}