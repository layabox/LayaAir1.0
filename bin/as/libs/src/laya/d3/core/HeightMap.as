package laya.d3.core {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.utils.Picker;
	
	/**
	 * <code>HeightMap</code> 类用于实现高度图数据。
	 */
	public class HeightMap {
		/** @private */
		private static var _tempRay:Ray = new Ray(new Vector3(), new Vector3());
		
		/**
		 * 从网格精灵生成高度图。
		 * @param meshSprite 网格精灵。
		 * @param width	高度图宽度。
		 * @param height 高度图高度。
		 * @param outCellSize 输出 单元尺寸。
		 */
		public static function creatFromMesh(mesh:Mesh, width:int, height:int, outCellSize:Vector2):HeightMap {
			var vertices:Vector.<Vector.<Vector3>> = new Vector.<Vector.<Vector3>>();
			var indexs:Vector.<Uint16Array> = new Vector.<Uint16Array>();
			
			var submesheCount:int = mesh.getSubMeshCount();
			for (var i:int = 0; i < submesheCount; i++) {
				var subMesh:SubMesh = mesh.getSubMesh(i);
				var vertexBuffer:VertexBuffer3D = subMesh._getVertexBuffer();
				var verts:Float32Array = vertexBuffer.getData();
				var subMeshVertices:Vector.<Vector3> = new Vector.<Vector3>();
				
				for (var j:int = 0; j < verts.length; j += vertexBuffer.vertexDeclaration.vertexStride / 4) {
					var position:Vector3 = new Vector3(verts[j + 0], verts[j + 1], verts[j + 2]);
					subMeshVertices.push(position);
				}
				vertices.push(subMeshVertices);
				
				var ib:IndexBuffer3D = subMesh._getIndexBuffer();
				indexs.push(ib.getData());
			}
			
			var boundingBox:BoundBox = mesh.boundingBox;
			var minX:Number = boundingBox.min.x;
			var minZ:Number = boundingBox.min.z;
			var maxX:Number = boundingBox.max.x;
			var maxZ:Number = boundingBox.max.z;
			var minY:Number = boundingBox.min.y;
			var maxY:Number = boundingBox.max.y;
			
			var widthSize:Number = maxX - minX;
			var heightSize:Number = maxZ - minZ;
			var cellWidth:Number = outCellSize.elements[0] = widthSize / (width - 1);
			var cellHeight:Number = outCellSize.elements[1] = heightSize / (height - 1);
			
			var heightMap:HeightMap = new HeightMap(width, height, minY, maxY);
			
			var ray:Ray = _tempRay;
			var rayDirE:Float32Array = ray.direction.elements;//Direction
			rayDirE[0] = 0;
			rayDirE[1] = -1;
			rayDirE[2] = 0;
			
			const heightOffset:Number = 0.1;//OriginalY
			var rayY:Number = maxY + heightOffset;
			ray.origin.elements[1] = rayY;
			
			for (var h:int = 0; h < height; h++) {
				var posZ:Number = minZ + h * cellHeight;
				heightMap._datas[h] = [];
				for (var w:int = 0; w < width; w++) {
					var posX:Number = minX + w * cellWidth;
					
					var rayOriE:Float32Array = ray.origin.elements;
					rayOriE[0] = posX;
					rayOriE[2] = posZ;
					
					var closestIntersection:Number = _getPosition(ray, vertices, indexs);
					heightMap._datas[h][w] = (closestIntersection === Number.MAX_VALUE) ? NaN : rayY - closestIntersection;
				}
			}
			return heightMap;
		}
		
		/**
		 * 从图片生成高度图。
		 * @param image 图片。
		 * @param maxHeight 最小高度。
		 * @param maxHeight 最大高度。
		 */
		public static function createFromImage(texture:Texture2D, minHeight:Number, maxHeight:Number):HeightMap {//TODO:texture类型，临时修复
			var textureWidth:Number = texture.width;
			var textureHeight:Number = texture.height;
			var heightMap:HeightMap = new HeightMap(textureWidth, textureHeight, minHeight, maxHeight);
			var compressionRatio:Number = (maxHeight - minHeight) / 254;
			var pixelsInfo:Uint8Array = texture.getPixels();
			
			var index:int = 0;
			for (var h:int = 0; h <textureHeight ; h++) {
				var colDatas:Array= heightMap._datas[h] = [];
				for (var w:int = 0; w < textureWidth; w++) {
					var r:Number = pixelsInfo[index++];
					var g:Number = pixelsInfo[index++];
					var b:Number = pixelsInfo[index++];
					var a:Number = pixelsInfo[index++];
					
					if (r == 255 && g == 255 && b == 255 && a == 255)
						colDatas[w] = NaN;
					else {
						colDatas[w] = (r + g + b) / 3 * compressionRatio + minHeight;
					}
				}
			}
			return heightMap;
		}
		
		/** @private */
		private static function _getPosition(ray:Ray, vertices:Vector.<Vector.<Vector3>>, indexs:Vector.<Uint16Array>):Number {
			var closestIntersection:Number = Number.MAX_VALUE;
			for (var i:int = 0; i < vertices.length; i++) {
				var subMeshVertices:Vector.<Vector3> = vertices[i];
				var subMeshIndexes:Uint16Array = indexs[i];
				
				for (var j:int = 0; j < subMeshIndexes.length; j += 3) {
					var vertex1:Vector3 = subMeshVertices[subMeshIndexes[j + 0]];
					var vertex2:Vector3 = subMeshVertices[subMeshIndexes[j + 1]];
					var vertex3:Vector3 = subMeshVertices[subMeshIndexes[j + 2]];
					
					var intersection:Number = Picker.rayIntersectsTriangle(ray, vertex1, vertex2, vertex3);
					
					if (!isNaN(intersection) && intersection < closestIntersection) {
						closestIntersection = intersection;
					}
				}
			}
			
			return closestIntersection;
		
		}
		
		/** @private */
		private var _datas:Array;
		/** @private */
		private var _w:int;
		/** @private */
		private var _h:int;
		/** @private */
		private var _minHeight:Number;
		/** @private */
		private var _maxHeight:Number;
		
		/**
		 * 获取宽度。
		 * @return value 宽度。
		 */
		public function get width():int {
			return _w;
		}
		
		/**
		 * 获取高度。
		 * @return value 高度。
		 */
		public function get height():int {
			return _h;
		}
		
		/**
		 * 最大高度。
		 * @return value 最大高度。
		 */
		public function get maxHeight():int {
			return _maxHeight;
		}
		
		/**
		 * 最大高度。
		 * @return value 最大高度。
		 */
		public function get minHeight():int {
			return _minHeight;
		}
		
		/**
		 * 创建一个 <code>HeightMap</code> 实例。
		 * @param width 宽度。
		 * @param height 高度。
		 * @param minHeight 最大高度。
		 * @param maxHeight 最大高度。
		 */
		public function HeightMap(width:int, height:int, minHeight:Number, maxHeight:Number) {
			_datas = [];
			_w = width;
			_h = height;
			_minHeight = minHeight;
			_maxHeight = maxHeight;
		}
		
		/** @private */
		private function _inBounds(row:int, col:int):Boolean {
			return row >= 0 && row < _h && col >= 0 && col < _w;
		}
		
		/**
		 * 获取高度。
		 * @param row 列数。
		 * @param col 行数。
		 * @return 高度。
		 */
		public function getHeight(row:int, col:int):Number {
			if (_inBounds(row, col))
				return _datas[row][col];
			else
				return NaN;
		}
	
	}

}