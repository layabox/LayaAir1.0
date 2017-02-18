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
	public class TraceFinder
	{
		private var allowDiagonal:Boolean;
		private var dontCrossCorners:Boolean;
		private var diagonalMovement:int;
		private var heuristic:Function;
		
		public function TraceFinder(opt:Object)
		{
			opt = opt || {};
			this.allowDiagonal = opt.allowDiagonal;
			this.dontCrossCorners = opt.dontCrossCorners;
			this.heuristic = opt.heuristic || Heuristic.manhattan;
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
		
		public function findPath(startX:int, startY:int, endX:int, endY:int, grid:Grid):Array
		{
			var openList:Heap = new Heap(function(nodeA:Node, nodeB:Node):int
			{
				return nodeA.f - nodeB.f;
			}), startNode:Node = grid.getNodeAt(startX, startY), endNode:Node = grid.getNodeAt(endX, endY), heuristic:Function = this.heuristic, allowDiagonal:Boolean = this.allowDiagonal, dontCrossCorners:Boolean = this.dontCrossCorners, abs:Function = Math.abs, SQRT2:Number = Math.SQRT2, node:Node, neighbors:Array, neighbor:Node, i:int, l:int, x:int, y:int, ng:int;
			
			startNode.g = 0;
			startNode.f = 0;
			
			openList.push(startNode);
			startNode.opened = true;
			
			while (!openList.empty())
			{
				node = openList.pop() as Node;
				node.closed = true;
				
				if (node === endNode)
				{
					return Util.backtrace(endNode);
				}
				
				neighbors = grid.getNeighbors(node, diagonalMovement);
				for (i = 0, l = neighbors.length; i < l; ++i)
				{
					neighbor = neighbors[i];
					
					if (neighbor.closed)
					{
						continue;
					}
					
					x = neighbor.x;
					y = neighbor.y;
					
					ng = node.g + ((x - node.x === 0 || y - node.y === 0) ? 1 : SQRT2);
					
					if (!neighbor.opened || ng < neighbor.g)
					{
						//neighbor.g = ng;
						//neighbor.h = neighbor.h || weight * heuristic(abs(x - endX), abs(y - endY));
						neighbor.g = ng * l / 9;
						neighbor.h = neighbor.h || heuristic(abs(x - endX), abs(y - endY));
						neighbor.f = neighbor.g + neighbor.h;
						neighbor.parent = node;
						
						if (!neighbor.opened)
						{
							openList.push(neighbor);
							neighbor.opened = true;
						}
						else
						{
							openList.updateItem(neighbor);
						}
					}
				}
			}
			
			return [];
		}
	}

}