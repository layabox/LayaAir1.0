package laya.d3.core {
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.component.Animator;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.graphics.FrustumCulling;
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
		private static var _tempMatrix4x4:Matrix4x4 = new Matrix4x4();
		
		/**@private */
		private var _cacheAvatar:Avatar;
		/**@private */
		private var _cacheMesh:Mesh;
		/** @private */
		private var _cacheAnimationNode:Vector.<AnimationNode>;
		/** @private */
		public var _skinnedData:Vector.<Vector.<Float32Array>>;
		/** @private */
		private var _skinnedDataLoopMarks:Vector.<int>;
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
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get boundingSphere():BoundSphere {
			_calculateBoundingSphere();
			return _boundingSphere;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get boundingBox():BoundBox {
			_calculateBoundingBox();
			return _boundingBox;
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
		}
		
		/**
		 * @private
		 */
		private function _getCacheAnimationNodes():void {
			var meshBoneNames:Vector.<String> = _cacheMesh._boneNames;
			var bindPoseIndices:Uint16Array = _cacheMesh._bindPoseIndices;
			var innerBindPoseCount:int = bindPoseIndices.length;
			
			if (!Render.supportWebGLPlusAnimation) {
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
				var meshBindPoseIndices:Uint16Array = _cacheMesh._bindPoseIndices;
				var pathMarks:Vector.<Array> = _cacheMesh._skinDataPathMarks;
				for (var i:int = 0, n:int = _cacheMesh.subMeshCount; i < n; i++) {
					var subMeshBoneIndices:Vector.<Uint16Array> = (_cacheMesh._getSubMesh(i) as SubMesh)._boneIndicesList;
					var subData:Vector.<Float32Array> = _skinnedData[i];
					for (var j:int = 0, m:int = subMeshBoneIndices.length; j < m; j++) {
						var boneIndices:Uint16Array = subMeshBoneIndices[j];
						if (Render.supportWebGLPlusAnimation)
							_computeSubSkinnedDataNative(_cacheAnimator._animationNodeWorldMatrixs, _cacheAnimationNodeIndices, _cacheMesh._inverseBindPosesBuffer, boneIndices, meshBindPoseIndices, subData[j]);
						else
							_computeSubSkinnedData(bindPoses, boneIndices, meshBindPoseIndices, subData[j], pathMarks);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _computeSubSkinnedData(bindPoses:Vector.<Matrix4x4>, boneIndices:Uint16Array, meshBindPoseInices:Uint16Array, data:Float32Array, pathMarks:Vector.<Array>):void {
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
					Utils3D._mulMatrixArray(_cacheAnimationNode[index].transform.getWorldMatrix(), bindPoses[meshBindPoseInices[index]], data, k * 16);
					_skinnedDataLoopMarks[index] = Stat.loopCount;
				}
			}
		}
		
		/**
		 * @private
		 */
		override public function _onMeshChange(value:Mesh):void {
			super._onMeshChange(value);
			_cacheMesh = value as Mesh;
			
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
			if (_cacheAnimator && _rootBone) {
				if (_localBoundBox == null) {
					_boundingBox.toDefault();
				} else {
					var worldMat:Matrix4x4 = _tempMatrix4x4;
					var rootBone:AnimationNode = _cacheAnimator._avatarNodeMap[_rootBone];
					Utils3D.matrix4x4MultiplyMFM((_cacheAnimator.owner as Sprite3D).transform.worldMatrix, rootBone.transform.getWorldMatrix(), worldMat);
					localBoundBox.tranform(worldMat, _boundingBox);
				}
			} else {
				super._calculateBoundingBox();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {//TODO:是否可直接在boundingSphere属性计算优化
			if (_cacheAnimator&& _rootBone) {
				if (localBoundSphere == null){
					_boundingSphere.toDefault();
				}
				else{
					var worldMat:Matrix4x4 = _tempMatrix4x4;
					var rootBone:AnimationNode = _cacheAnimator._avatarNodeMap[_rootBone];
					Utils3D.matrix4x4MultiplyMFM((_cacheAnimator.owner as Sprite3D).transform.worldMatrix, rootBone.transform.getWorldMatrix(), worldMat);
					localBoundBox.tranform(worldMat, _boundingBox);
					
					var center:Vector3 = _boundingSphere.center;
					var max:Vector3 = _boundingBox.max;
					Vector3.add(_boundingBox.min, max, center);
					Vector3.scale(center, 0.5, center);
					_boundingSphere.radius = Math.max(Math.max(max.x - center.x, max.y - center.y), max.z - center.z);
					
					if (Render.supportWebGLPlusCulling) {//[NATIVE]
						var buffer:Float32Array = FrustumCulling._cullingBuffer;
						buffer[_cullingBufferIndex + 1] = center.x;
						buffer[_cullingBufferIndex + 2] = center.y;
						buffer[_cullingBufferIndex + 3] = center.z;
						buffer[_cullingBufferIndex + 4] = _boundingSphere.radius;
					}
				}
			} else {
				super._calculateBoundingSphere();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _changeRenderObjectsByMesh(mesh:Mesh):void {
			var count:int = mesh.subMeshCount;
			_renderElements.length = count;
			for (var i:int = 0; i < count; i++) {
				var renderElement:RenderElement = _renderElements[i];
				if (!renderElement) {
					var material:BaseMaterial = sharedMaterials[i];
					renderElement = _renderElements[i] = new RenderElement();
					renderElement.setTransform(_owner._transform);
					renderElement.render = this;
					renderElement.material = material ? material : BlinnPhongMaterial.defaultMaterial;//确保有材质,由默认材质代替。
				}
				renderElement.setGeometry(mesh._getSubMesh(i));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(context:RenderContext3D, transform:Transform3D):void {
			if (_cacheAnimator) {
				_computeSkinnedData();
				var aniOwnerTrans:Transform3D = (_cacheAnimator.owner as Sprite3D)._transform;
				_shaderValues.setMatrix4x4(Sprite3D.WORLDMATRIX, aniOwnerTrans.worldMatrix);
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
				var aniOwnerTrans:Transform3D = (_cacheAnimator.owner as Sprite3D)._transform;
				Matrix4x4.multiply(projectionView, aniOwnerTrans.worldMatrix, _projectionViewWorldMatrix);
			} else {
				Matrix4x4.multiply(projectionView, transform.worldMatrix, _projectionViewWorldMatrix);
			}
			_shaderValues.setMatrix4x4(Sprite3D.MVPMATRIX, _projectionViewWorldMatrix);
		}
		
		/**
		 * @private [NATIVE]
		 */
		private function _computeSubSkinnedDataNative(worldMatrixs:Float32Array, cacheAnimationNodeIndices:Uint16Array, inverseBindPosesBuffer:ArrayBuffer, boneIndices:Uint16Array, bindPoseInices:Uint16Array, data:Float32Array):void {
			LayaGL.instance.computeSubSkinnedData(worldMatrixs, cacheAnimationNodeIndices, inverseBindPosesBuffer, boneIndices, bindPoseInices, data);
		}
	}
}