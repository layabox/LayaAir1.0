package laya.d3.component {
	import PathFinding.core.Grid;
	import PathFinding.finders.AStarFinder;
	import laya.d3.core.MeshTerrainSprite3D;
	import laya.d3.core.Sprite3D;
	
	/**
	 * <code>PathFinding</code> 类用于创建寻路。
	 */
	public class PathFind extends Component3D {
		/** @private */
		private var _meshTerrainSprite3D:MeshTerrainSprite3D
		/** @private */
		private var _finder:AStarFinder;
		/** @private */
		public var _setting:Object;
		
		/**寻路网格。*/
		public var grid:Grid;
		
		/**
		 * 获取寻路设置。
		 * @return 寻路设置。
		 */
		public function get setting():Object {
			return _setting;
		}
		
		/**
		 * 设置寻路设置。
		 * @param value 寻路设置。
		 */
		public function set setting(value:Object):void {
			(value) && (_finder = new AStarFinder(value));
			_setting = value;
		}
		
		/**
		 * 创建一个新的 <code>PathFinding</code> 实例。
		 */
		public function PathFind() {
		
		}
		
		/**
		 * @private
		 * 初始化载入蒙皮动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			if (!owner is MeshTerrainSprite3D)
				throw new Error("PathFinding: The owner must MeshTerrainSprite3D!");
			
			super._load(owner);
			_meshTerrainSprite3D = owner as MeshTerrainSprite3D;
		}
		
		/**
		 * 寻找路径。
		 * @param	startX 开始X。
		 * @param	startZ 开始Z。
		 * @param	endX 结束X。
		 * @param	endZ 结束Z。
		 * @return  路径。
		 */
		public function findPath(startX:Number, startZ:Number, endX:Number, endZ:Number):Array {
			var minX:Number = _meshTerrainSprite3D.minX;
			var minZ:Number = _meshTerrainSprite3D.minZ;
			var cellX:Number = _meshTerrainSprite3D.width / grid.width;
			var cellZ:Number = _meshTerrainSprite3D.depth / grid.height
			var halfCellX:Number = cellX / 2;
			var halfCellZ:Number = cellZ / 2;
			
			var gridStartX:Number = Math.floor((startX - minX) / cellX);
			var gridStartZ:Number = Math.floor((startZ - minZ) / cellZ);
			var gridEndX:Number = Math.floor((endX - minX) / cellX);
			var gridEndZ:Number = Math.floor((endZ - minZ) / cellZ);
			
			var boundWidth:Number = grid.width - 1;
			var boundHeight:Number = grid.height - 1;
			(gridStartX > boundWidth) && (gridStartX = boundWidth);
			(gridStartZ > boundHeight) && (gridStartZ = boundHeight);
			(gridStartX < 0) && (gridStartX = 0);
			(gridStartZ < 0) && (gridStartZ = 0);
			
			(gridEndX > boundWidth) && (gridEndX = boundWidth);
			(gridEndZ > boundHeight) && (gridEndZ = boundHeight);
			(gridEndX < 0) && (gridEndX = 0);
			(gridEndZ < 0) && (gridEndZ = 0);
			
			var path:Array = _finder.findPath(gridStartX, gridStartZ, gridEndX, gridEndZ, grid);
			grid.reset();
			
			for (var i:int = 1; i < path.length - 1; i++) {
				var gridPos:Array = path[i];
				gridPos[0] = gridPos[0] * cellX + halfCellX + minX;
				gridPos[1] = gridPos[1] * cellZ + halfCellZ + minZ;
			}
			
			if (path.length == 1) {
				path[0][0] = endX;
				path[0][1] = endX;
			} else if (path.length > 1) {
				path[0][0] = startX;
				path[0][1] = startZ;
				path[path.length - 1][0] = endX;
				path[path.length - 1][1] = endZ;
			}
			return path;
		}
	
	}

}