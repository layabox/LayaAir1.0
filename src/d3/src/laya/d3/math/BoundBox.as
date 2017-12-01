package laya.d3.math {
	import laya.d3.core.IClone;
	
	/**
	 * <code>BoundBox</code> 类用于创建包围盒。
	 */
	public class BoundBox implements IClone {
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
		 * @param	out 生成的包围盒。
		 */
		public static function createfromPoints(points:Vector.<Vector3>, out:BoundBox):void {
			if (points == null)
				throw new Error("points");
			
			var min:Vector3 = out.min;
			var max:Vector3 = out.max;
			var minE:Float32Array = min.elements;
			minE[0] = Number.MAX_VALUE;
			minE[1] = Number.MAX_VALUE;
			minE[2] = Number.MAX_VALUE;
			var maxE:Float32Array = max.elements;
			maxE[0] = -Number.MAX_VALUE;
			maxE[1] = -Number.MAX_VALUE;
			maxE[2] = -Number.MAX_VALUE;
			
			for (var i:int = 0, n:int = points.length; i < n; ++i) {
				Vector3.min(min, points[i], min);
				Vector3.max(max, points[i], max);
			}
		}
		
		/**
		 * 合并两个包围盒。
		 * @param	box1 包围盒1。
		 * @param	box2 包围盒2。
		 * @param	out 生成的包围盒。
		 */
		public static function merge(box1:BoundBox, box2:BoundBox, out:BoundBox):void {
			
			Vector3.min(box1.min, box2.min, out.min);
			Vector3.max(box1.max, box2.max, out.max);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:BoundBox = destObject as BoundBox;
			min.cloneTo(dest.min);
			max.cloneTo(dest.max);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:BoundBox = __JS__("new this.constructor(new Vector3(),new Vector3())");
			cloneTo(dest);
			return dest;
		}
	
	}
}

