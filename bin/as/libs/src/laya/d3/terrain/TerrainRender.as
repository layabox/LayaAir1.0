package laya.d3.terrain {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.Transform3D;
	import laya.d3.graphics.RenderObject;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.renders.RenderSprite;
	import laya.resource.IDispose;
	
	/**
	 * <code>MeshRender</code> 类用于网格渲染器。
	 */
	public class TerrainRender extends BaseRender {
		/** @private */
		private static var _tempBoudingBoxCorners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		/** @private */
		private var _terrainSprite3DOwner:TerrainChunk;
		
		/**
		 * 创建一个新的 <code>MeshRender</code> 实例。
		 */
		public function TerrainRender(owner:TerrainChunk) {
			super(owner);
			_terrainSprite3DOwner = owner;
			sharedMaterial = new TerrainMaterial();
		}
		
		override protected function _calculateBoundingSphere():void {
			var terrainFilter:TerrainFilter = _terrainSprite3DOwner.terrainFilter;
			if (terrainFilter == null) {
				_boundingSphere.toDefault();
			} else {
				var meshBoundingSphere:BoundSphere = terrainFilter._originalBoundingSphere;
				var maxScale:Number;
				var transform:Transform3D = _terrainSprite3DOwner.transform;
				var scale:Vector3 = transform.scale;
				if (scale.x >= scale.y && scale.x >= scale.z)
					maxScale = scale.x;
				else
					maxScale = scale.y >= scale.z ? scale.y : scale.z;
				Vector3.transformCoordinate(meshBoundingSphere.center, transform.worldMatrix, _boundingSphere.center);
				_boundingSphere.radius = meshBoundingSphere.radius * maxScale;
			}
		}
		
		override protected function _calculateBoundingBox():void {
			var terrainFilter:TerrainFilter = _terrainSprite3DOwner.terrainFilter;
			if ( terrainFilter ) {
				_boundingBox.toDefault();
			} else {
				var worldMat:Matrix4x4 = _terrainSprite3DOwner.transform.worldMatrix;
				var corners:Vector.<Vector3> = terrainFilter._boundingBoxCorners;
				for (var i:int = 0; i < 8; i++)
					Vector3.transformCoordinate(corners[i], worldMat, _tempBoudingBoxCorners[i]);
				BoundBox.createfromPoints(_tempBoudingBoxCorners, _boundingBox);
			}
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			_terrainSprite3DOwner = null;
		}
	}
}