package laya.d3.core {
	import laya.ani.AnimationState;
	import laya.d3.animation.AnimationNode;
	import laya.d3.component.Animator;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	
	/**
	 * <code>SkinMeshRender</code> 类用于蒙皮渲染器。
	 */
	public class SkinnedMeshRender extends MeshRender {
		/**@private */
		private var _cacheAvatar:Avatar;
		/**@private */
		private var _cacheMesh:Mesh;
		/** @private */
		private var _cacheAnimationNode:Vector.<AnimationNode>;
		/** @private */
		private var _skinnedDatas:Float32Array;
		/** @private */
		private var _publicSubSkinnedDatas:Vector.<Vector.<Float32Array>>;
		
		/**@private */
		public var _cacheAnimator:Animator;
		
		/**
		 * 创建一个新的 <code>SkinMeshRender</code> 实例。
		 */
		public function SkinnedMeshRender(owner:RenderableSprite3D) {
			super(owner);
			
			_cacheAnimationNode = new Vector.<AnimationNode>();
			(_owner as SkinnedMeshSprite3D).meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
		}
		
		/**
		 * @private
		 */
		private static function _splitAnimationDatas(indices:Uint8Array, bonesData:Float32Array, subAnimationDatas:Float32Array):void {
			for (var i:int = 0, n:int = indices.length, ii:int = 0; i < n; i++) {
				for (var j:int = 0; j < 16; j++, ii++)
					subAnimationDatas[ii] = bonesData[(indices[i] << 4) + j];
			}
		}
		
		/**
		 * @private
		 */
		private function _getCacheAnimationNodes():void {
			var meshBoneNames:Vector.<String> = _cacheMesh._boneNames;
			var binPoseCount:int = meshBoneNames.length;
			_cacheAnimationNode.length = binPoseCount;
			var nodeMap:Object = _cacheAnimator._avatarNodeMap;
			for (var i:int = 0; i < binPoseCount; i++)
				_cacheAnimationNode[i] = nodeMap[meshBoneNames[i]];
		}
		
		/**
		 * @private
		 */
		private function _offComputeBoneIndexToMeshEvent(avatar:Avatar, mesh:Mesh):void {
			if (avatar.loaded) {
				if (!mesh.loaded)
					mesh.off(Event.LOADED, this, _getCacheAnimationNodes);
			} else {
				avatar.off(Event.LOADED, this, _computeBoneIndexToMeshWithAsyncMesh);
			}
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMeshWithAsyncAvatar():void {
			if (_cacheAvatar.loaded)
				_computeBoneIndexToMeshWithAsyncMesh();
			else
				_cacheAvatar.once(Event.LOADED, this, _computeBoneIndexToMeshWithAsyncMesh);
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMeshWithAsyncMesh():void {
			if (_cacheMesh.loaded)
				_getCacheAnimationNodes();
			else
				_cacheMesh.on(Event.LOADED, this, _getCacheAnimationNodes);
		}
		
		/**
		 * @private
		 */
		private function _onMeshChanged(meshFilter:MeshFilter, lastMesh:Mesh, mesh:Mesh):void {
			_cacheMesh = mesh;
			var subMeshCount:int = mesh.subMeshCount;
			_skinnedDatas = new Float32Array(mesh.InverseAbsoluteBindPoses.length * 16);
			_publicSubSkinnedDatas = new Vector.<Vector.<Float32Array>>();
			_publicSubSkinnedDatas.length = subMeshCount;
			for (var i:int = 0; i < subMeshCount; i++) {
				var subMeshDatas:Vector.<Float32Array> = _publicSubSkinnedDatas[i] = new Vector.<Float32Array>();
				var boneIndicesList:Vector.<Uint8Array> = mesh.getSubMesh(i)._boneIndicesList;
				for (var j:int = 0, m:int = boneIndicesList.length; j < m; j++)
					subMeshDatas[j] = new Float32Array(boneIndicesList[j].length * 16);
			}
			
			if (_cacheAvatar) {
				(lastMesh) && (_offComputeBoneIndexToMeshEvent(_cacheAvatar, lastMesh));
				(mesh) && (_computeBoneIndexToMeshWithAsyncAvatar());
			}
		}
		
		/**
		 * @private
		 */
		public function _setCacheAvatar(value:Avatar):void {
			if (_cacheAvatar !== value) {
				if (_cacheMesh) {
					(_cacheAvatar) && (_offComputeBoneIndexToMeshEvent(_cacheAvatar, _cacheMesh));
					_cacheAvatar = value;
					if (value) {
						_addShaderDefine(SkinnedMeshSprite3D.SHADERDEFINE_BONE);
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
		override public function _renderUpdate(projectionView:Matrix4x4):void {
			var projViewWorld:Matrix4x4;
			var animator:Animator = _cacheAnimator;
			var subMeshCount:int = _cacheMesh.subMeshCount;
			if (animator) {
				var animatorOwner:Sprite3D = animator.owner as Sprite3D;//根节点不缓存
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, animatorOwner._transform.worldMatrix);
				projViewWorld = animatorOwner.getProjectionViewWorldMatrix(projectionView);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
				
				if (_cacheMesh && _cacheMesh.loaded && _cacheAvatar && _cacheAvatar.loaded) {
					var i:int, n:int, j:int;
					var subSkinnedDatas:Vector.<Vector.<Float32Array>>, boneIndicesCount:int, inverseBindPoses:Vector.<Matrix4x4>, boneIndicesList:Vector.<Uint8Array>, subMeshDatas:Vector.<Float32Array>;
					if (animator.playState !== AnimationState.stopped && animator._canCache) {//停止时使用非缓存模式
						subSkinnedDatas = animator.currentPlayClip._getSkinnedDatasWithCache(_cacheMesh, _cacheAvatar, animator.cachePlayRate, animator.currentFrameIndex);
						if (subSkinnedDatas) {
							for (i = 0; i < subMeshCount; i++)
								(_renderElements[i] as SubMeshRenderElement)._skinAnimationDatas = subSkinnedDatas[i];//TODO:日后确认是否合理
							return;
						}
						
						animator._updateTansformProperty();//避免Animator数据已缓存，无法更新
						inverseBindPoses = _cacheMesh._inverseBindPoses;
						for (i = 0, n = inverseBindPoses.length; i < n; i++)
							Utils3D._mulMatrixArray(_cacheAnimationNode[i]._transform._getWorldMatrix(), inverseBindPoses[i], _skinnedDatas, i * 16);
						
						subSkinnedDatas = new Vector.<Vector.<Float32Array>>();
						subSkinnedDatas.length = subMeshCount;
						for (i = 0; i < subMeshCount; i++) {
							subMeshDatas = subSkinnedDatas[i] = new Vector.<Float32Array>();
							
							boneIndicesList = _cacheMesh.getSubMesh(i)._boneIndicesList;
							boneIndicesCount = boneIndicesList.length;
							subMeshDatas.length = boneIndicesCount;
							for (j = 0; j < boneIndicesCount; j++) {
								subMeshDatas[j] = new Float32Array(boneIndicesList[j].length * 16);
								_splitAnimationDatas(boneIndicesList[j], _skinnedDatas, subMeshDatas[j]);
							}
							(_renderElements[i] as SubMeshRenderElement)._skinAnimationDatas = subMeshDatas;//TODO:日后确认是否合理
						}
						animator.currentPlayClip._cacheSkinnedDatasWithCache(_cacheMesh, _cacheAvatar, animator.cachePlayRate, animator.currentFrameIndex, subSkinnedDatas);
					} else {
						inverseBindPoses = _cacheMesh._inverseBindPoses;
						for (i = 0, n = inverseBindPoses.length; i < n; i++)
							Utils3D._mulMatrixArray(_cacheAnimationNode[i]._transform._getWorldMatrix(), inverseBindPoses[i], _skinnedDatas, i * 16);
						
						for (i = 0; i < subMeshCount; i++) {
							boneIndicesList = _cacheMesh.getSubMesh(i)._boneIndicesList;
							boneIndicesCount = boneIndicesList.length;
							subMeshDatas = _publicSubSkinnedDatas[i]
							for (j = 0; j < boneIndicesCount; j++)
								_splitAnimationDatas(boneIndicesList[j], _skinnedDatas, subMeshDatas[j]);
							(_renderElements[i] as SubMeshRenderElement)._skinAnimationDatas = subMeshDatas;//TODO:日后确认是否合理
						}
					}
				}
			} else {
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, _owner.transform.worldMatrix);
				projViewWorld = _owner.getProjectionViewWorldMatrix(projectionView);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
			}
		}
	}
}