package laya.d3.core {
	import laya.d3.animation.AnimationNode;
	import laya.d3.component.Animator;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.core.scene.OctreeNode;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.utils.Utils3D;
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.utils.Stat;
	
	/**
	 * <code>SkinMeshRenderer</code> 类用于蒙皮渲染器。
	 */
	public class SkinnedMeshRenderer extends MeshRenderer {
		/**@private */
		private var _cacheAvatar:Avatar;
		/**@private */
		private var _cacheMesh:Mesh;
		/** @private */
		private var _cacheAnimationNode:Vector.<AnimationNode>;
		/** @private */
		private var _skinnedData:Vector.<Vector.<Float32Array>>;
		/** @private */
		private var _skinnedDataLoopMarks:Vector.<int>;
		/** @private */
		private var _localBoundingBoxCorners:Vector.<Vector3>;
		/**@private */
		private var _localBoundBox:BoundBox;
		/**@private */
		private var _cacheAnimator:Animator;
		
		/**@private */
		public var _rootBone:String;
		
		/**用于裁剪的包围球。 */
		public var localBoundSphere:BoundSphere;
		
		/**@private	[NATIVE]*/
		private var _cacheAnimationNodeIndices:Uint16Array;
		
		/**
		 * 获取包围球。
		 * @return 包围球。
		 */
		public function get localBoundBox():BoundBox {
			return _localBoundBox;
		}
		
		/**
		 * 设置包围球。
		 * @param value
		 */
		public function set localBoundBox(value:BoundBox):void {
			_localBoundBox = value;
			value.getCorners(_localBoundingBoxCorners);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get boundingBoxCenter():Vector3 {
			var boundBox:BoundBox = boundingBox;
			Vector3.add(boundBox.min, boundBox.max, _boundingBoxCenter);
			Vector3.scale(_boundingBoxCenter, 0.5, _boundingBoxCenter);
			return _boundingBoxCenter;
		}
		
		/**
		 * 创建一个 <code>SkinnedMeshRender</code> 实例。
		 */
		public function SkinnedMeshRenderer(owner:RenderableSprite3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(owner);
			
			_skinnedDataLoopMarks = new Vector.<int>();
			_cacheAnimationNode = new Vector.<AnimationNode>();
			_localBoundingBoxCorners = new Vector.<Vector3>(8);
		}
		
		/**
		 * @private
		 */
		private function _getCacheAnimationNodes():void {
			var meshBoneNames:Vector.<String> = _cacheMesh._boneNames;
			var bindPoseIndices:Uint16Array = _cacheMesh._bindPoseIndices;
			var innerBindPoseCount:int = bindPoseIndices.length;
			
			if (!Render.isConchApp) {
				_cacheAnimationNode.length = innerBindPoseCount;
				var nodeMap:Object = _cacheAnimator._avatarNodeMap;
				for (var i:int = 0; i < innerBindPoseCount; i++) {
					var node:AnimationNode = nodeMap[meshBoneNames[bindPoseIndices[i]]];
					_cacheAnimationNode[i] = node;
				}
			} else {
				_cacheAnimationNodeIndices = new Uint16Array(innerBindPoseCount);
				var nodeMapC:Object = _cacheAnimator._avatarNodeMap;
				for (i = 0; i < innerBindPoseCount; i++) {
					var nodeC:AnimationNode = nodeMapC[meshBoneNames[bindPoseIndices[i]]];
					_cacheAnimationNodeIndices[i] = nodeC._worldMatrixIndex;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMeshWithAsyncAvatar():void {
			_computeBoneIndexToMeshWithAsyncMesh();
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMeshWithAsyncMesh():void {
			_getCacheAnimationNodes();
		}
		
		/**
		 * @private
		 */
		private function _computeSkinnedData():void {
			if (_cacheMesh && _cacheAvatar) {
				var bindPoses:Vector.<Matrix4x4> = _cacheMesh._inverseBindPoses;
				var bindPoseInices:Uint16Array = _cacheMesh._bindPoseIndices;
				var pathMarks:Vector.<Array> = _cacheMesh._skinDataPathMarks;
				for (var i:int = 0, n:int = _cacheMesh.subMeshCount; i < n; i++) {
					var subBoneIndices:Vector.<Uint16Array> = (_cacheMesh._getSubMesh(i) as SubMesh)._boneIndicesList;
					var subData:Vector.<Float32Array> = _skinnedData[i];
					for (var j:int = 0, m:int = subBoneIndices.length; j < m; j++) {
						var boneIndices:Uint16Array = subBoneIndices[j];
						if (Render.isConchApp)
							_computeSubSkinnedDataNative(_cacheAnimator._animationNodeWorldMatrixs, _cacheAnimationNodeIndices, _cacheMesh._inverseBindPosesBuffer, boneIndices, bindPoseInices, subData[j]);
						else
							_computeSubSkinnedData(bindPoses, boneIndices, bindPoseInices, subData[j], pathMarks);
					}
					(_renderElements[i] as SubMeshRenderElement).skinnedDatas = subData;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _computeSubSkinnedData(bindPoses:Vector.<Matrix4x4>, boneIndices:Uint16Array, bindPoseInices:Uint16Array, data:Float32Array, pathMarks:Vector.<Array>):void {
			for (var k:int = 0, q:int = boneIndices.length; k < q; k++) {
				var index:int = boneIndices[k];
				if (_skinnedDataLoopMarks[index] === Stat.loopCount) {
					var p:Array = pathMarks[index];
					var preData:Float32Array = _skinnedData[p[0]][p[1]];
					var srcIndex:int = p[2] * 16;
					var dstIndex:int = k * 16;
					for (var d:int = 0; d < 16; d++)
						data[dstIndex + d] = preData[srcIndex + d];
				} else {
					Utils3D._mulMatrixArray(_cacheAnimationNode[index].transform.getWorldMatrix(), bindPoses[bindPoseInices[index]], data, k * 16);
					_skinnedDataLoopMarks[index] = Stat.loopCount;
				}
			}
		}
		
		/**
		 * @private
		 */
		override public function _onMeshChange(value:Mesh):void {
			super._onMeshChange(value);
			_cacheMesh = value as Mesh
			
			var subMeshCount:int = value.subMeshCount;
			_skinnedData = new Vector.<Vector.<Float32Array>>(subMeshCount);
			_skinnedDataLoopMarks.length = (value as Mesh)._bindPoseIndices.length;
			for (var i:int = 0; i < subMeshCount; i++) {
				var subBoneIndices:Vector.<Uint16Array> = (value._getSubMesh(i) as SubMesh)._boneIndicesList;
				var subCount:int = subBoneIndices.length;
				var subData:Vector.<Float32Array> = _skinnedData[i] = new Vector.<Float32Array>(subCount);
				for (var j:int = 0; j < subCount; j++)
					subData[j] = new Float32Array(subBoneIndices[j].length * 16);
			}
			
			(_cacheAvatar && value) && (_computeBoneIndexToMeshWithAsyncAvatar());
		}
		
		/**
		 * @private
		 */
		public function _setCacheAnimator(animator:Animator):void {
			_cacheAnimator = animator;
		}
		
		/**
		 * @private
		 */
		public function _setRootBone(name:String):void {
			_rootBone = name;
		}
		
		/**
		 * @private
		 */
		public function _setCacheAvatar(value:Avatar):void {
			if (_cacheAvatar !== value) {
				if (_cacheMesh) {
					_cacheAvatar = value;
					if (value) {
						_defineDatas.add(SkinnedMeshSprite3D.SHADERDEFINE_BONE);
						_computeBoneIndexToMeshWithAsyncAvatar();
					}
				} else {
					_cacheAvatar = value;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingBox():void {//TODO:是否可直接在boundingSphere属性计算优化
			if (_cacheAnimator) {
				if (_localBoundBox == null)
					_boundingBox.toDefault();
				else
					_calculateBoundBoxByInitCorners(_localBoundingBoxCorners);
			} else {
				super._calculateBoundingBox();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {//TODO:是否可直接在boundingSphere属性计算优化
			if (_cacheAnimator) {
				if (localBoundSphere == null)
					_boundingSphere.toDefault();
				else
					_calculateBoundingSphereByInitSphere(localBoundSphere);
			} else {
				super._calculateBoundingSphere();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _updateOctreeNode():void {
			var treeNode:OctreeNode = _treeNode;
			if (treeNode) {
				treeNode.updateObject(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(context:RenderContext3D, transform:Transform3D):void {
			if (_cacheAnimator) {
				_computeSkinnedData();
				var aniOwnerTransParent:Transform3D = (_cacheAnimator.owner as Sprite3D)._transform._parent;
				var worldMat:Matrix4x4 = aniOwnerTransParent ? aniOwnerTransParent.worldMatrix : Matrix4x4.DEFAULT;
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, worldMat);
			} else {
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, transform.worldMatrix);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdateWithCamera(context:RenderContext3D, transform:Transform3D):void {
			var projectionView:Matrix4x4 = context.projectionViewMatrix;
			if (_cacheAnimator) {
				var aniOwnerTransParent:Transform3D = (_cacheAnimator.owner as Sprite3D)._transform._parent;
				var worldMat:Matrix4x4 = aniOwnerTransParent ? aniOwnerTransParent.worldMatrix : Matrix4x4.DEFAULT;
				Matrix4x4.multiply(projectionView, worldMat, _projectionViewWorldMatrix);
			} else {
				Matrix4x4.multiply(projectionView, transform.worldMatrix, _projectionViewWorldMatrix);
			}
			_shaderValues.setMatrix4x4(Sprite3D.MVPMATRIX, _projectionViewWorldMatrix);
			
			if (Laya3D.debugMode)
				_renderRenderableBoundBox();
		}
		
		/**
		 * @private [NATIVE]
		 */
		private function _computeSubSkinnedDataNative(worldMatrixs:Float32Array, cacheAnimationNodeIndices:Uint16Array, inverseBindPosesBuffer:ArrayBuffer, boneIndices:Uint16Array, bindPoseInices:Uint16Array, data:Float32Array):void {
			LayaGL.instance.computeSubSkinnedData(worldMatrixs, cacheAnimationNodeIndices, inverseBindPosesBuffer, boneIndices, bindPoseInices, data);
		}
	}
}