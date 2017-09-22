package laya.d3.core {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	
	/**
	 * <code>TerrainMeshSprite3D</code> 类用于创建网格。
	 */
	public class MeshTerrainSprite3D extends MeshSprite3D {
		/** @private */
		private static var _tempVector3:Vector3 = new Vector3();
		/** @private */
		private static var _tempMatrix4x4:Matrix4x4 = new Matrix4x4();
		
		/**
		 * 从网格创建一个TerrainMeshSprite3D实例和其高度图属性。
		 * @param mesh 网格。
		 * @param heightMapWidth 高度图宽度。
		 * @param heightMapHeight 高度图高度。
		 * @param name 名字。
		 */
		public static function createFromMesh(mesh:Mesh, heightMapWidth:Number, heightMapHeight:Number, name:String = null):MeshTerrainSprite3D {
			var meshTerrainSprite3D:MeshTerrainSprite3D = new MeshTerrainSprite3D(mesh, null, name);
			
			if (mesh.loaded)
				meshTerrainSprite3D._initCreateFromMesh(heightMapWidth, heightMapHeight);
			else
				mesh.once(Event.LOADED, meshTerrainSprite3D, meshTerrainSprite3D._initCreateFromMesh, [heightMapWidth, heightMapHeight]);
			return meshTerrainSprite3D;
		}
		
		/**
		 * 从网格创建一个TerrainMeshSprite3D实例、图片读取高度图属性。
		 * @param mesh 网格。
		 * @param image 高度图。
		 * @param name 名字。
		 */
		public static function createFromMeshAndHeightMap(mesh:Mesh, texture:Texture2D, minHeight:Number, maxHeight:Number, name:String = null):MeshTerrainSprite3D {
			var meshTerrainSprite3D:MeshTerrainSprite3D = new MeshTerrainSprite3D(mesh, null, name);
			
			if (mesh.loaded)
				meshTerrainSprite3D._initCreateFromMeshHeightMap(texture, minHeight, maxHeight);
			else
				mesh.once(Event.LOADED, meshTerrainSprite3D, meshTerrainSprite3D._initCreateFromMeshHeightMap, [texture,minHeight, maxHeight]);
			
			return meshTerrainSprite3D;
		}
		
		/** @private */
		private var _minX:Number;
		/** @private */
		private var _minZ:Number;
		/** @private */
		private var _cellSize:Vector2;
		/** @private */
		private var _heightMap:HeightMap;
		
		/**
		 * 获取地形X轴最小位置。
		 * @return  地形X轴最小位置。
		 */
		public function get minX():Number {
			var worldMat:Matrix4x4 = transform.worldMatrix;
			var worldMatE:Float32Array = worldMat.elements;
			return _minX * _getScaleX() + worldMatE[12];
		}
		
		/**
		 * 获取地形Z轴最小位置。
		 * @return  地形X轴最小位置。
		 */
		public function get minZ():Number {
			var worldMat:Matrix4x4 = transform.worldMatrix;
			var worldMatE:Float32Array = worldMat.elements;
			return _minZ * _getScaleZ() + worldMatE[14];
		}
		
		/**
		 * 获取地形X轴长度。
		 * @return  地形X轴长度。
		 */
		public function get width():Number {
			return (_heightMap.width - 1) * _cellSize.x * _getScaleX();
		}
		
		/**
		 * 获取地形Z轴长度。
		 * @return  地形Z轴长度。
		 */
		public function get depth():Number {
			return (_heightMap.height - 1) * _cellSize.y * _getScaleZ();
		}
		
		/**
		 * 创建一个 <code>TerrainMeshSprite3D</code> 实例。
		 * @param mesh 网格。
		 * @param heightMap 高度图。
		 * @param name 名字。
		 */
		public function MeshTerrainSprite3D(mesh:Mesh, heightMap:HeightMap, name:String = null) {
			super(mesh, name);
			_heightMap = heightMap;
			_cellSize = new Vector2();
		}
		
		/**
		 * @private
		 */
		private function _disableRotation():void {
			var rotation:Quaternion = transform.rotation;
			rotation.elements[0] = 0;
			rotation.elements[1] = 0;
			rotation.elements[2] = 0;
			rotation.elements[3] = 1;
			transform.rotation = rotation;
		}
		
		/**
		 * @private
		 */
		private function _getScaleX():Number {
			var worldMat:Matrix4x4 = transform.worldMatrix;
			var worldMatE:Float32Array = worldMat.elements;
			var m11:Number = worldMatE[0];
			var m12:Number = worldMatE[1];
			var m13:Number = worldMatE[2];
			return Math.sqrt((m11 * m11) + (m12 * m12) + (m13 * m13));
		}
		
		/**
		 * @private
		 */
		private function _getScaleZ():Number {
			var worldMat:Matrix4x4 = transform.worldMatrix;
			var worldMatE:Float32Array = worldMat.elements;
			var m31:Number = worldMatE[8];
			var m32:Number = worldMatE[9];
			var m33:Number = worldMatE[10];
			return Math.sqrt((m31 * m31) + (m32 * m32) + (m33 * m33));
		}
		
		/**
		 * @private
		 */
		private function _initCreateFromMesh(heightMapWidth:int, heightMapHeight:int):void {
			_heightMap = HeightMap.creatFromMesh(meshFilter.sharedMesh as Mesh, heightMapWidth, heightMapHeight, _cellSize);
			
			var boundingBox:BoundBox = meshFilter.sharedMesh.boundingBox;
			var min:Vector3 = boundingBox.min;
			var max:Vector3 = boundingBox.max;
			_minX = min.x;
			_minZ = min.z;
		}
		
		/**
		 * @private
		 */
		private function _initCreateFromMeshHeightMap(texture:Texture2D, minHeight:Number, maxHeight:Number):void {
			var boundingBox:BoundBox = meshFilter.sharedMesh.boundingBox;
			
			if (texture.loaded) {
				_heightMap = HeightMap.createFromImage(texture, minHeight, maxHeight);
				_computeCellSize(boundingBox);
			} else {
				texture.once(Event.LOADED, null, function():void {
					_heightMap = HeightMap.createFromImage(texture, minHeight, maxHeight);
					_computeCellSize(boundingBox);
				});
			}
			
			var min:Vector3 = boundingBox.min;
			var max:Vector3 = boundingBox.max;
			_minX = min.x;
			_minZ = min.z;
		}
		
		/**
		 * @private
		 */
		private function _computeCellSize(boundingBox:BoundBox):void {
			var min:Vector3 = boundingBox.min;
			var max:Vector3 = boundingBox.max;
			var minX:Number = min.x;
			var minZ:Number = min.z;
			var maxX:Number = max.x;
			var maxZ:Number = max.z;
			
			var widthSize:Number = maxX - minX;
			var heightSize:Number = maxZ - minZ;
			
			_cellSize.elements[0] = widthSize / (_heightMap.width - 1);
			_cellSize.elements[1] = heightSize / (_heightMap.height - 1);
		}
		
		/**
		 * @private
		 */
		override public function _update(state:RenderState):void {
			_disableRotation();
			super._update(state);
		}
		
		/**
		 * 获取地形高度。
		 * @param x X轴坐标。
		 * @param z Z轴坐标。
		 */
		public function getHeight(x:Number, z:Number):Number {
			_tempVector3.elements[0] = x;
			_tempVector3.elements[1] = 0;
			_tempVector3.elements[2] = z;
			
			_disableRotation();
			var worldMat:Matrix4x4 = transform.worldMatrix;
			worldMat.invert(_tempMatrix4x4);
			
			Vector3.transformCoordinate(_tempVector3, _tempMatrix4x4, _tempVector3);
			x = _tempVector3.elements[0];
			z = _tempVector3.elements[2];
			
			var c:Number = (x - _minX) / _cellSize.x;
			var d:Number = (z - _minZ) / _cellSize.y;
			var row:Number = Math.floor(d);
			var col:Number = Math.floor(c);
			
			var s:Number = c - col;
			var t:Number = d - row;
			
			var uy:Number;
			var vy:Number;
			var worldMatE:Float32Array = worldMat.elements;
			var m21:Number = worldMatE[4];
			var m22:Number = worldMatE[5];
			var m23:Number = worldMatE[6];
			var scaleY:Number = Math.sqrt((m21 * m21) + (m22 * m22) + (m23 * m23));
			var translateY:Number = worldMatE[13];
			
			var h01:Number = _heightMap.getHeight(row, col + 1);
			var h10:Number = _heightMap.getHeight((row + 1), col);
			if (isNaN(h01) || isNaN(h10))
				return NaN;
			
			if (s + t <= 1.0) {
				var h00:Number = _heightMap.getHeight(row, col);
				if (isNaN(h00))
					return NaN;
				
				uy = h01 - h00;
				vy = h10 - h00;
				return (h00 + s * uy + t * vy) * scaleY + translateY;
			} else {
				var h11:Number = _heightMap.getHeight((row + 1), col + 1);
				if (isNaN(h11))
					return NaN;
				
				uy = h10 - h11;
				vy = h01 - h11;
				return (h11 + (1.0 - s) * uy + (1.0 - t) * vy) * scaleY + translateY;
			}
		}
	
	}

}