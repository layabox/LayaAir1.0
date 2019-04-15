package laya.d3.math {
	import laya.d3.core.IClone;
	
	/**
	 * <code>BoundBox</code> 类用于创建包围盒。
	 */
	public class BoundBox implements IClone {
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector31:Vector3 = new Vector3();
		
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
		 * @private
		 */
		private function _rotateExtents(extents:Vector3, rotation:Matrix4x4, out:Vector3):void {
			var extentsX:Number = extents.x;
			var extentsY:Number = extents.y;
			var extentsZ:Number = extents.z;
			var matElements:Float32Array = rotation.elements;
			out.x = Math.abs(matElements[0] * extentsX) + Math.abs(matElements[4] * extentsY) + Math.abs(matElements[8] * extentsZ);
			out.y = Math.abs(matElements[1] * extentsX) + Math.abs(matElements[5] * extentsY) + Math.abs(matElements[9] * extentsZ);
			out.z = Math.abs(matElements[2] * extentsX) + Math.abs(matElements[6] * extentsY) + Math.abs(matElements[10] * extentsZ);
		}
		
		/**
		 * 获取包围盒的8个角顶点。
		 * @param	corners 返回顶点的输出队列。
		 */
		public function getCorners(corners:Vector.<Vector3>):void {
			corners.length = 8;
			var minX:Number = min.x;
			var minY:Number = min.y;
			var minZ:Number = min.z;
			var maxX:Number = max.x;
			var maxY:Number = max.y;
			var maxZ:Number = max.z;
			corners[0] = new Vector3(minX, maxY, maxZ);
			corners[1] = new Vector3(maxX, maxY, maxZ);
			corners[2] = new Vector3(maxX, minY, maxZ);
			corners[3] = new Vector3(minX, minY, maxZ);
			corners[4] = new Vector3(minX, maxY, minZ);
			corners[5] = new Vector3(maxX, maxY, minZ);
			corners[6] = new Vector3(maxX, minY, minZ);
			corners[7] = new Vector3(minX, minY, minZ);
		}
		
		/**
		 * 获取中心点。
		 * @param	out
		 */
		public function getCenter(out:Vector3):void {
			Vector3.add(min, max, out);
			Vector3.scale(out, 0.5, out);
		}
		
		/**
		 * 获取范围。
		 * @param	out
		 */
		public function getExtent(out:Vector3):void {
			Vector3.subtract(max, min, out);
			Vector3.scale(out, 0.5, out);
		}
		
		/**
		 * 设置中心点和范围。
		 * @param	center
		 */
		public function setCenterAndExtent(center:Vector3, extent:Vector3):void {
			Vector3.subtract(center, extent, min);
			Vector3.add(center, extent, max);
		}
		
		/**
		 * @private
		 */
		public function tranform(matrix:Matrix4x4, out:BoundBox):void {
			var center:Vector3 = _tempVector30;
			var extent:Vector3 = _tempVector31;
			getCenter(center);
			getExtent(extent);
			Vector3.transformCoordinate(center, matrix, center);
			_rotateExtents(extent, matrix,extent);
			out.setCenterAndExtent(center,extent);
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
			min.x = Number.MAX_VALUE;
			min.y = Number.MAX_VALUE;
			min.z = Number.MAX_VALUE;
			max.x = -Number.MAX_VALUE;
			max.y = -Number.MAX_VALUE;
			max.z = -Number.MAX_VALUE;
			
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

