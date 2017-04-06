package PathFinding.finders
{
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	import PathFinding.core.Node;
	import PathFinding.core.Util;
	import PathFinding.libs.Heap;
	
	/**
	 * ...
	 * @author ...
	 */
	public class JumpPointFinderBase
	{
		public var grid:Grid;
		public var openList:Heap;
		public var startNode:Node;
		public var endNode:Node;
		public var heuristic:Function;
		public var trackJumpRecursion:Boolean;
		
		/**
		 * Base class for the Jump Point Search algorithm
		 * @param {object} opt
		 * @param {function} opt.heuristic Heuristic function to estimate the distance
		 *     (defaults to manhattan).
		 */
		public function JumpPointFinderBase(opt:Object)
		{
			opt = opt || {};
			this.heuristic = opt.heuristic || Heuristic.manhattan;
			this.trackJumpRecursion = opt.trackJumpRecursion || false;
		}
		
		/**
		 * Find and return the path.
		 * @return {Array<Array<number>>} The path, including both start and
		 *     end positions.
		 */
		public function findPath(startX:int, startY:int, endX:int, endY:int, grid:Grid):*
		{
			var openList:Heap = this.openList = new Heap(function(nodeA:Node, nodeB:Node):Number
			{
				return nodeA.f - nodeB.f;
			}), startNode:Node = this.startNode = grid.getNodeAt(startX, startY), endNode:Node = this.endNode = grid.getNodeAt(endX, endY), node:Node;
			
			this.grid = grid;
			
			// set the `g` and `f` value of the start node to be 0
			startNode.g = 0;
			startNode.f = 0;
			
			// push the start node into the open list
			openList.push(startNode);
			startNode.opened = true;
			
			// while the open list is not empty
			while (!openList.empty())
			{
				// pop the position of node which has the minimum `f` value.
				node = openList.pop() as Node;
				node.closed = true;
				
				if (node == endNode)
				{
					return Util.expandPath(Util.backtrace(endNode));
				}
				
				this._identifySuccessors(node);
			}
			
			// fail to find the path
			return [];
		}
		
		/**
		 * Identify successors for the given node. Runs a jump point search in the
		 * direction of each available neighbor, adding any points found to the open
		 * list.
		 * @protected
		 */
		private function _identifySuccessors(node:Node):void
		{
			var grid:Grid = this.grid, heuristic:Function = this.heuristic, openList:Heap = this.openList, endX:int = this.endNode.x, endY:int = this.endNode.y, neighbors:Array, neighbor:Node, jumpPoint:Array, i:int, l:int, x:int = node.x, y:int = node.y, jx:int, jy:int, dx:int, dy:int, d:int, ng:int, jumpNode:Node, abs:Function = Math.abs, max:Function = Math.max;
			
			neighbors = this._findNeighbors(node);
			for (i = 0, l = neighbors.length; i < l; ++i)
			{
				neighbor = neighbors[i];
				jumpPoint = this._jump(neighbor[0], neighbor[1], x, y);
				if (jumpPoint)
				{
					
					jx = jumpPoint[0];
					jy = jumpPoint[1];
					jumpNode = grid.getNodeAt(jx, jy);
					
					if (jumpNode.closed)
					{
						continue;
					}
					
					// include distance, as parent may not be immediately adjacent:
					d = Heuristic.octile(abs(jx - x), abs(jy - y));
					ng = node.g + d; // next `g` value
					
					if (!jumpNode.opened || ng < jumpNode.g)
					{
						jumpNode.g = ng;
						jumpNode.h = jumpNode.h || heuristic(abs(jx - endX), abs(jy - endY));
						jumpNode.f = jumpNode.g + jumpNode.h;
						jumpNode.parent = node;
						
						if (!jumpNode.opened)
						{
							openList.push(jumpNode);
							jumpNode.opened = true;
						}
						else
						{
							openList.updateItem(jumpNode);
						}
					}
				}
			}
		}
		
		public function _jump(x:int, y:int, px:int, py:int):Array{
			return [];
		}
		
		public function _findNeighbors(node:Node):Array{
			return [];
		}
		
	}

}