package laya.d3.math {
	
	/**
	 * <code>BoundBox</code> 类用于创建包围盒。
	 */
	public class BoundBox {
		/**最小顶点。*/
		public var min:Vector3;
		/**最大顶点。*/
		public var max:Vector3;
		
		/**
		 * 创建一个 <code>BoundBox</code> 实例。
		 * @param	min 包围盒的最小顶点。
		 * @param	max 包围盒的最大顶点。
		 */
		public function BoundBox(min:Vector3, max:Vector3) {
			this.min = min;
			this.max = max;
		}
		
		/**
		 * 获取包围盒的8个角顶点。
		 * @param	corners 返回顶点的输出队列。
		 */
		public function getCorners(corners:Vector.<Vector3>):void {
			corners.length = 8;
			var mine:Float32Array = min.elements;
			var maxe:Float32Array = max.elements;
			var minX:Number = mine[0];
			var minY:Number = mine[1];
			var minZ:Number = mine[2];
			var maxX:Number = maxe[0];
			var maxY:Number = maxe[1];
			var maxZ:Number = maxe[2];
			corners[0] = new Vector3(minX, maxY, maxZ);
			corners[1] = new Vector3(maxX, maxY, maxZ);
			corners[2] = new Vector3(maxX, minY, maxZ);
			corners[3] = new Vector3(minX, minY, maxZ);
			corners[4] = new Vector3(minX, maxY, minZ);
			corners[5] = new Vector3(maxX, maxY, minZ);
			corners[6] = new Vector3(maxX, minY, minZ);
			corners[7] = new Vector3(minX, minY, minZ);
		}
		
		public function toDefault():void {
			min.toDefault();
			max.toDefault();
		}
		
		/**
		 * 从顶点生成包围盒。
		 * @param	points 所需顶点队列。
		 * @param	result 生成的包围盒。
		 */
		public static function createfromPoints(points:Vector.<Vector3>, out:BoundBox):void {
			if (points == null)
				throw new Error("points");
			
			var min:Vector3 = new Vector3(Number.MAX_VALUE);
			var max:Vector3 = new Vector3(-Number.MAX_VALUE);
			
			for (var i:int = 0; i < points.length; ++i) {
				Vector3.min(min, points[i], min);
				Vector3.max(max, points[i], max);
			}
			
			out.min = min;
			out.max = max;
		}
	
	}
}

