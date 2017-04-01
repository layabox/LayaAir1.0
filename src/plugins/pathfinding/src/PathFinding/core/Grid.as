package PathFinding.core
{
	/**
	 * ...
	 * @author dongketao
	 */
	public class Grid
	{
		public var width:int;
		public var height:int;
		public var nodes:Array;
		
		/**
		 * The Grid class, which serves as the encapsulation of the layout of the nodes.
		 * @constructor
		 * @param {number|Array<Array<(number|boolean)>>} width_or_matrix Number of columns of the grid, or matrix
		 * @param {number} height Number of rows of the grid.
		 * @param {Array<Array<(number|boolean)>>} [matrix] - A 0-1 matrix
		 *     representing the walkable status of the nodes(0 or false for walkable).
		 *     If the matrix is not supplied, all the nodes will be walkable.  */
		public function Grid(width_or_matrix:*, height:int, matrix:Array = null)
		{
			var width:int;
			if (width_or_matrix is Number)
			{
				width = width_or_matrix;
			}
			else
			{
				height = width_or_matrix.length;
				width = width_or_matrix[0].length;
				matrix = width_or_matrix;
			}
			/**
			 * The number of columns of the grid.
			 * @type number
			 */
			this.width = width;
			/**
			 * The number of rows of the grid.
			 * @type number
			 */
			this.height = height;
			/**
			 * A 2D array of nodes.
			 */
			this.nodes = this._buildNodes(width, height, matrix);
		}
		
		///**
		 //* 从图片生成AStar图。
		 //* @param texture AStar图资源。
		 //*/
		//public static function createGridFromAStarMap(texture:Texture2D):Grid{
			//var textureWidth:Number = texture.width;
			//var textureHeight:Number = texture.height;
			//
			//var pixelsInfo:Uint8Array = texture.getPixels();
			//var aStarArr:Array = new Array();
			//var index:int = 0;
			//
			//for (var w:int = 0; w < textureWidth; w++ ){
				//
				//var colaStarArr:Array = aStarArr[w] = [];
				//for (var h:int = 0; h < textureHeight; h++ ){
					//
					//var r:Number = pixelsInfo[index++];
					//var g:Number = pixelsInfo[index++];
					//var b:Number = pixelsInfo[index++];
					//var a:Number = pixelsInfo[index++];
					//
					//if (r == 255 && g == 255 && b == 255 && a == 255)
						//colaStarArr[h] = 1;
					//else {
						//colaStarArr[h] = 0;
					//}
				//}
			//}
			//
			//var gird:Grid = new Grid(textureWidth, textureHeight, aStarArr);
			//return gird;
		//}
		
		/**
		 * Build and return the nodes.
		 * @private
		 * @param {number} width
		 * @param {number} height
		 * @param {Array<Array<number|boolean>>} [matrix] - A 0-1 matrix representing
		 *     the walkable status of the nodes.
		 * @see Grid
		 */
		public function _buildNodes(width:int, height:int, matrix:Array = null):Array
		{
			var i:int, j:int, nodes:Array = new Array();
			for (i = 0; i < height; ++i)
			{
				nodes[i] = new Array();
				for (j = 0; j < width; ++j)
				{
					nodes[i][j] = new Node(j, i);
				}
			}
			if (matrix == null)
			{
				return nodes;
			}
			if (matrix.length != height || matrix[0].length != width)
			{
				throw new Error('Matrix size does not fit');
			}
			for (i = 0; i < height; ++i)
			{
				for (j = 0; j < width; ++j)
				{
					if (matrix[i][j])
					{
						// 0, false, null will be walkable
						// while others will be un-walkable
						nodes[i][j].walkable = false;
					}
				}
			}
			return nodes;
		}
		
		public function getNodeAt(x:int, y:int):Node
		{
			return this.nodes[y][x];
		}
		
		/**
		 * Determine whether the node at the given position is walkable.
		 * (Also returns false if the position is outside the grid.)
		 * @param {number} x - The x coordinate of the node.
		 * @param {number} y - The y coordinate of the node.
		 * @return {boolean} - The walkability of the node.
		 */
		public function isWalkableAt(x:int, y:int):Boolean
		{
			return this.isInside(x, y) && this.nodes[y][x].walkable;
		}
		
		/**
		 * Determine whether the position is inside the grid.
		 * XXX: `grid.isInside(x, y)` is wierd to read.
		 * It should be `(x, y) is inside grid`, but I failed to find a better
		 * name for this method.
		 * @param {number} x
		 * @param {number} y
		 * @return {boolean}
		 */
		public function isInside(x:int, y:int):Boolean
		{
			return (x >= 0 && x < this.width) && (y >= 0 && y < this.height);
		}
		
		/**
		 * Set whether the node on the given position is walkable.
		 * NOTE: throws exception if the coordinate is not inside the grid.
		 * @param {number} x - The x coordinate of the node.
		 * @param {number} y - The y coordinate of the node.
		 * @param {boolean} walkable - Whether the position is walkable.
		 */
		public function setWalkableAt(x:int, y:int, walkable:Boolean):void
		{
			this.nodes[y][x].walkable = walkable;
		}
		
		/**
		 * Get the neighbors of the given node.
		 *
		 *     offsets      diagonalOffsets:
		 *  +---+---+---+    +---+---+---+
		 *  |   | 0 |   |    | 0 |   | 1 |
		 *  +---+---+---+    +---+---+---+
		 *  | 3 |   | 1 |    |   |   |   |
		 *  +---+---+---+    +---+---+---+
		 *  |   | 2 |   |    | 3 |   | 2 |
		 *  +---+---+---+    +---+---+---+
		 *
		 *  When allowDiagonal is true, if offsets[i] is valid, then
		 *  diagonalOffsets[i] and
		 *  diagonalOffsets[(i + 1) % 4] is valid.
		 * @param {Node} node
		 * @param {diagonalMovement} diagonalMovement
		 */
		public function getNeighbors(node:Node, diagonalMovement:int):Array
		{
			var x:int = node.x, y:int = node.y, neighbors:Array = [], s0:Boolean = false, d0:Boolean = false, s1:Boolean = false, d1:Boolean = false, s2:Boolean = false, d2:Boolean = false, s3:Boolean = false, d3:Boolean = false, nodes:Array = this.nodes;
			// ↑
			if (this.isWalkableAt(x, y - 1))
			{
				neighbors.push(nodes[y - 1][x]);
				s0 = true;
			}
			// →
			if (this.isWalkableAt(x + 1, y))
			{
				neighbors.push(nodes[y][x + 1]);
				s1 = true;
			}
			// ↓
			if (this.isWalkableAt(x, y + 1))
			{
				neighbors.push(nodes[y + 1][x]);
				s2 = true;
			}
			// ←
			if (this.isWalkableAt(x - 1, y))
			{
				neighbors.push(nodes[y][x - 1]);
				s3 = true;
			}
			if (diagonalMovement == DiagonalMovement.Never)
			{
				return neighbors;
			}
			if (diagonalMovement == DiagonalMovement.OnlyWhenNoObstacles)
			{
				d0 = s3 && s0;
				d1 = s0 && s1;
				d2 = s1 && s2;
				d3 = s2 && s3;
			}
			else if (diagonalMovement == DiagonalMovement.IfAtMostOneObstacle)
			{
				d0 = s3 || s0;
				d1 = s0 || s1;
				d2 = s1 || s2;
				d3 = s2 || s3;
			}
			else if (diagonalMovement == DiagonalMovement.Always)
			{
				d0 = true;
				d1 = true;
				d2 = true;
				d3 = true;
			}
			else
			{
				throw new Error('Incorrect value of diagonalMovement');
			}
			// ↖
			if (d0 && this.isWalkableAt(x - 1, y - 1))
			{
				neighbors.push(nodes[y - 1][x - 1]);
			}
			// ↗
			if (d1 && this.isWalkableAt(x + 1, y - 1))
			{
				neighbors.push(nodes[y - 1][x + 1]);
			}
			// ↘
			if (d2 && this.isWalkableAt(x + 1, y + 1))
			{
				neighbors.push(nodes[y + 1][x + 1]);
			}
			// ↙
			if (d3 && this.isWalkableAt(x - 1, y + 1))
			{
				neighbors.push(nodes[y + 1][x - 1]);
			}
			return neighbors;
			//if (!allowDiagonal) {
				//return neighbors;
			//}
			//if (dontCrossCorners) {
				//d0 = s3 && s0;
				//d1 = s0 && s1;
				//d2 = s1 && s2;
				//d3 = s2 && s3;
			//}
			//else {
				//d0 = s3 || s0;
				//d1 = s0 || s1;
				//d2 = s1 || s2;
				//d3 = s2 || s3;
			//}
			//if (d0 && this.isWalkableAt(x - 1, y - 1))
			//{
				//neighbors.push(nodes[y - 1][x - 1]);
			//}
			//// ↗
			//if (d1 && this.isWalkableAt(x + 1, y - 1))
			//{
				//neighbors.push(nodes[y - 1][x + 1]);
			//}
			//// ↘
			//if (d2 && this.isWalkableAt(x + 1, y + 1))
			//{
				//neighbors.push(nodes[y + 1][x + 1]);
			//}
			//// ↙
			//if (d3 && this.isWalkableAt(x - 1, y + 1))
			//{
				//neighbors.push(nodes[y + 1][x - 1]);
			//}
			//return neighbors;
		}
		
		/**
		 * Get a clone of this grid.
		 * @return {Grid} Cloned grid.
		 */
		public function clone():Grid
		{
			var i:int, j:int,
			
			width:int = this.width, height:int = this.height, thisNodes:Array = this.nodes,
			
			newGrid:Grid = new Grid(width, height), newNodes:Array = new Array();
			
			for (i = 0; i < height; ++i)
			{
				newNodes[i] = new Array();
				for (j = 0; j < width; ++j)
				{
					newNodes[i][j] = new Node(j, i, thisNodes[i][j].walkable);
				}
			}
			
			newGrid.nodes = newNodes;
			
			return newGrid;
		}
		
		public function reset():void{
			var _node:Node;
			for (var i:Number = 0; i < height; ++i)
			{
				for (var j:Number = 0; j < width; ++j)
				{
					_node = this.nodes[i][j];
					_node.g = 0;
					_node.f = 0;
					_node.h = 0;
					_node.by = 0;
					_node.parent = null;
					_node.opened = null;
					_node.closed = null;
					_node.tested = null;
				}
			}
		}
	}

}