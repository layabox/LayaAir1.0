package laya.d3.utils {
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	
	/**
	 * <code>Picker</code> 类用于创建拾取。
	 */
	public class Picker {
		private static var _tempVector30:Vector3 = new Vector3();
		private static var _tempVector31:Vector3 = new Vector3();
		private static var _tempVector32:Vector3 = new Vector3();
		private static var _tempVector33:Vector3 = new Vector3();
		private static var _tempVector34:Vector3 = new Vector3();
		private static var _tempVector35:Vector3 = new Vector3();
		private static var _tempVector36:Vector3 = new Vector3();
		private static var _tempVector37:Vector3 = new Vector3();
		
		/**
		 * 创建一个 <code>Picker</code> 实例。
		 */
		public function Picker() {
		}
		
		/**
		 * 计算鼠标生成的射线。
		 * @param	point 鼠标位置。
		 * @param	viewPort 视口。
		 * @param	projectionMatrix 透视投影矩阵。
		 * @param	viewMatrix 视图矩阵。
		 * @param	world 世界偏移矩阵。
		 * @return  out  输出射线。
		 */
		public static function calculateCursorRay(point:Vector2, viewPort:Viewport, projectionMatrix:Matrix4x4, viewMatrix:Matrix4x4, world:Matrix4x4, out:Ray):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x:Number = point.elements[0];
			var y:Number = point.elements[1];
			
			var nearSource:Vector3 = _tempVector30;
			var nerSourceE:Float32Array = nearSource.elements;
			nerSourceE[0] = x;
			nerSourceE[1] = y;
			nerSourceE[2] = viewPort.minDepth;
			
			var farSource:Vector3 = _tempVector31;
			var farSourceE:Float32Array = farSource.elements;
			farSourceE[0] = x;
			farSourceE[1] = y;
			farSourceE[2] = viewPort.maxDepth;
			
			var nearPoint:Vector3 = out.origin;
			var farPoint:Vector3 = _tempVector32;
			
			viewPort.unprojectFromWVP(nearSource, projectionMatrix, viewMatrix, world, nearPoint);
			viewPort.unprojectFromWVP(farSource, projectionMatrix, viewMatrix, world, farPoint);
			
			var outDire:Float32Array = out.direction.elements;
			outDire[0] = farPoint.x - nearPoint.x;
			outDire[1] = farPoint.y - nearPoint.y;
			outDire[2] = farPoint.z - nearPoint.z;
			Vector3.normalize(out.direction, out.direction);
		}
		
		/**
		 * 计算射线和三角形碰撞并返回碰撞三角形和碰撞距离。
		 * @param	ray 射线。
		 * @param	positions 顶点数据。
		 * @param	indices 索引数据。
		 * @param	outVertex0 输出三角形顶点0。
		 * @param	outVertex1 输出三角形顶点1。
		 * @param	outVertex2 输出三角形顶点2。
		 * @return   射线距离三角形的距离，返回Number.NaN则不相交。
		 */
		public static function rayIntersectsPositionsAndIndices(ray:Ray, vertexDatas:Float32Array, vertexDeclaration:VertexDeclaration, indices:Uint16Array, outHitInfo:RaycastHit):Boolean {
			var vertexStrideFloatCount:int = vertexDeclaration.vertexStride / 4;
			var positionVertexElementOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.POSITION0).offset / 4;
			var closestIntersection:Number = Number.MAX_VALUE;
			var closestTriangleVertexIndex1:int = -1;
			var closestTriangleVertexIndex2:int = -1;
			var closestTriangleVertexIndex3:int = -1;
			
			for (var j:int = 0; j < indices.length; j += 3) {
				var vertex1:Vector3 = _tempVector35;
				var vertex1E:Float32Array = vertex1.elements;
				var vertex1Index:int = indices[j] * vertexStrideFloatCount;
				var vertex1PositionIndex:int = vertex1Index + positionVertexElementOffset;
				vertex1E[0] = vertexDatas[vertex1PositionIndex];
				vertex1E[1] = vertexDatas[vertex1PositionIndex + 1];
				vertex1E[2] = vertexDatas[vertex1PositionIndex + 2];
				
				var vertex2:Vector3 = _tempVector36;
				var vertex2E:Float32Array = vertex2.elements;
				var vertex2Index:int = indices[j + 1] * vertexStrideFloatCount;
				var vertex2PositionIndex:int = vertex2Index + positionVertexElementOffset;
				vertex2E[0] = vertexDatas[vertex2PositionIndex];
				vertex2E[1] = vertexDatas[vertex2PositionIndex + 1];
				vertex2E[2] = vertexDatas[vertex2PositionIndex + 2];
				
				var vertex3:Vector3 = _tempVector37;
				var vertex3E:Float32Array = vertex3.elements;
				var vertex3Index:int = indices[j + 2] * vertexStrideFloatCount;
				var vertex3PositionIndex:int = vertex3Index + positionVertexElementOffset;
				vertex3E[0] = vertexDatas[vertex3PositionIndex];
				vertex3E[1] = vertexDatas[vertex3PositionIndex + 1];
				vertex3E[2] = vertexDatas[vertex3PositionIndex + 2];
				
				var intersection:Number = Picker.rayIntersectsTriangle(ray, vertex1, vertex2, vertex3);
				
				if (!isNaN(intersection) && intersection < closestIntersection) {
					closestIntersection = intersection;
					closestTriangleVertexIndex1 = vertex1Index;
					closestTriangleVertexIndex2 = vertex2Index;
					closestTriangleVertexIndex3 = vertex3Index;
				}
			}
			
			if (closestIntersection !== Number.MAX_VALUE) {//TODO:是否能检测到
				outHitInfo.distance = closestIntersection;
				
				Vector3.scale(ray.direction, closestIntersection, outHitInfo.position);
				Vector3.add(ray.origin, outHitInfo.position, outHitInfo.position);
				
				var trianglePositions:Array = outHitInfo.trianglePositions;
				var position0:Vector3 = trianglePositions[0];
				var position1:Vector3 = trianglePositions[1];
				var position2:Vector3 = trianglePositions[2];
				var position0E:Float32Array = position0.elements;
				var position1E:Float32Array = position1.elements;
				var position2E:Float32Array = position2.elements;
				
				var closestVertex1PositionIndex:int = closestTriangleVertexIndex1 + positionVertexElementOffset;
				position0E[0] = vertexDatas[closestVertex1PositionIndex];
				position0E[1] = vertexDatas[closestVertex1PositionIndex + 1];
				position0E[2] = vertexDatas[closestVertex1PositionIndex + 2];
				
				var closestVertex2PositionIndex:int = closestTriangleVertexIndex2 + positionVertexElementOffset;
				position1E[0] = vertexDatas[closestVertex2PositionIndex];
				position1E[1] = vertexDatas[closestVertex2PositionIndex + 1];
				position1E[2] = vertexDatas[closestVertex2PositionIndex + 2];
				
				var closestVertex3PositionIndex:int = closestTriangleVertexIndex3 + positionVertexElementOffset;
				position2E[0] = vertexDatas[closestVertex3PositionIndex];
				position2E[1] = vertexDatas[closestVertex3PositionIndex + 1];
				position2E[2] = vertexDatas[closestVertex3PositionIndex + 2];
				
				var normalVertexElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.NORMAL0);
				if (normalVertexElement) {
					var normalVertexElementOffset:int = normalVertexElement.offset / 4;
					var triangleNormals:Array = outHitInfo.triangleNormals;
					var normal0:Vector3 = triangleNormals[0];
					var normal1:Vector3 = triangleNormals[1];
					var normal2:Vector3 = triangleNormals[2];
					var normal0E:Float32Array = normal0.elements;
					var normal1E:Float32Array = normal1.elements;
					var normal2E:Float32Array = normal2.elements;
					
					var closestVertex1NormalIndex:int = closestTriangleVertexIndex1 + normalVertexElementOffset;
					normal0E[0] = vertexDatas[closestVertex1NormalIndex];
					normal0E[1] = vertexDatas[closestVertex1NormalIndex + 1];
					normal0E[2] = vertexDatas[closestVertex1NormalIndex + 2];
					
					var closestVertex2NormalIndex:int = closestTriangleVertexIndex2 + normalVertexElementOffset;
					normal1E[0] = vertexDatas[closestVertex2NormalIndex];
					normal1E[1] = vertexDatas[closestVertex2NormalIndex + 1];
					normal1E[2] = vertexDatas[closestVertex2NormalIndex + 2];
					
					var closestVertex3NormalIndex:int = closestTriangleVertexIndex3 + normalVertexElementOffset;
					normal2E[0] = vertexDatas[closestVertex3NormalIndex];
					normal2E[1] = vertexDatas[closestVertex3NormalIndex + 1];
					normal2E[2] = vertexDatas[closestVertex3NormalIndex + 2];
				}
				return true;
			} else {
				outHitInfo.position.toDefault();
				outHitInfo.distance =Number.MAX_VALUE;
				outHitInfo.trianglePositions[0].toDefault();
				outHitInfo.trianglePositions[1].toDefault();
				outHitInfo.trianglePositions[2].toDefault();
				outHitInfo.triangleNormals[0].toDefault();
				outHitInfo.triangleNormals[1].toDefault();
				outHitInfo.triangleNormals[2].toDefault();
				return false;
			}
		}
		
		/**
		 * 计算射线和三角形碰撞并返回碰撞距离。
		 * @param	ray 射线。
		 * @param	vertex1 顶点1。
		 * @param	vertex2 顶点2。
		 * @param	vertex3 顶点3。
		 * @return   射线距离三角形的距离，返回Number.NaN则不相交。
		 */
		public static function rayIntersectsTriangle(ray:Ray, vertex1:Vector3, vertex2:Vector3, vertex3:Vector3):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var result:Number;
			// Compute vectors along two edges of the triangle.
			var edge1:Vector3 = _tempVector30, edge2:Vector3 = _tempVector31;
			
			Vector3.subtract(vertex2, vertex1, edge1);
			Vector3.subtract(vertex3, vertex1, edge2);
			
			// Compute the determinant.
			var directionCrossEdge2:Vector3 = _tempVector32;
			Vector3.cross(ray.direction, edge2, directionCrossEdge2);
			
			var determinant:Number;
			determinant = Vector3.dot(edge1, directionCrossEdge2);
			
			// If the ray is parallel to the triangle plane, there is no collision.
			if (determinant > -Number.MIN_VALUE && determinant < Number.MIN_VALUE) {
				result = Number.NaN;
				return result;
			}
			
			var inverseDeterminant:Number = 1.0 / determinant;
			
			// Calculate the U parameter of the intersection point.
			var distanceVector:Vector3 = _tempVector33;
			Vector3.subtract(ray.origin, vertex1, distanceVector);
			
			var triangleU:Number;
			triangleU = Vector3.dot(distanceVector, directionCrossEdge2);
			triangleU *= inverseDeterminant;
			
			// Make sure it is inside the triangle.
			if (triangleU < 0 || triangleU > 1) {
				result = Number.NaN;
				return result;
			}
			
			// Calculate the V parameter of the intersection point.
			var distanceCrossEdge1:Vector3 = _tempVector34;
			Vector3.cross(distanceVector, edge1, distanceCrossEdge1);
			
			var triangleV:Number;
			triangleV = Vector3.dot(ray.direction, distanceCrossEdge1);
			triangleV *= inverseDeterminant;
			
			// Make sure it is inside the triangle.
			if (triangleV < 0 || triangleU + triangleV > 1) {
				result = Number.NaN;
				return result;
			}
			
			// Compute the distance along the ray to the triangle.
			var rayDistance:Number;
			rayDistance = Vector3.dot(edge2, distanceCrossEdge1);
			rayDistance *= inverseDeterminant;
			
			// Is the triangle behind the ray origin?
			if (rayDistance < 0) {
				result = Number.NaN;
				return result;
			}
			
			result = rayDistance;
			return result;
		}
	
	}

}