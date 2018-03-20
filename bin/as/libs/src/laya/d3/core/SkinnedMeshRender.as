package laya.d3.core {
	import laya.ani.AnimationState;
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.component.Animator;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.core.scene.ITreeNode;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
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
		private var _cacheAnimationNodeIndex:Vector.<int>;
		/** @private */
		private var _subSkinnedDatas:Vector.<Vector.<Float32Array>>;
		/** @private */
		private var _localBoundingBoxCorners:Vector.<Vector3>;
		/**@private */
		private var _localBoundBox:BoundBox;
		/**@private */
		private var _cacheAnimator:Animator;
		/**@private */
		private var _rootIndex:int;
		
		/**@private */
		public var _rootBone:String;
		
		/**用于裁剪的包围球。 */
		public var localBoundSphere:BoundSphere;
		
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
		 * 创建一个新的 <code>SkinnedMeshRender</code> 实例。
		 */
		public function SkinnedMeshRender(owner:RenderableSprite3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(owner);
			_owner.transform.off(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatNeedChange);//移除super内构造函数无用事件注册
			
			_cacheAnimationNodeIndex = new Vector.<int>();
			_cacheAnimationNode = new Vector.<AnimationNode>();
			_localBoundingBoxCorners = new Vector.<Vector3>(8);
			(_owner as SkinnedMeshSprite3D).meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
		}
		
		/**
		 * @private
		 */
		private static function _splitAnimationDatas(indices:Uint8Array, bonesData:Float32Array, subAnimationDatas:Float32Array):void {
			for (var i:int = 0, n:int = indices.length, ii:int = 0; i < n; i++) {
				var index:int = indices[i] << 4;
				for (var j:int = 0; j < 16; j++, ii++)
					subAnimationDatas[ii] = bonesData[index + j];
			}
		}
		
		/**
		 * @private
		 */
		private function _getCacheAnimationNodes():void {
			var meshBoneNames:Vector.<String> = _cacheMesh._boneNames;
			var binPoseCount:int = meshBoneNames.length;
			_cacheAnimationNode.length = binPoseCount;
			_cacheAnimationNodeIndex.length = binPoseCount;
			var avatarNodes:Vector.<AnimationNode> = _cacheAnimator._avatarNodes;
			var nodeMap:Object = _cacheAnimator._avatarNodeMap;
			for (var i:int = 0; i < binPoseCount; i++) {
				var node:AnimationNode = nodeMap[meshBoneNames[i]];
				_cacheAnimationNode[i] = node;
				_cacheAnimationNodeIndex[i] = avatarNodes.indexOf(node);
			}
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
			
			(lastMesh && !lastMesh.loaded) && (mesh.off(Event.LOADED, this, _onMeshLoaded));
			if (mesh.loaded)
				_onMeshLoaded(mesh);
			else
				mesh.on(Event.LOADED, this, _onMeshLoaded);
			
			if (_cacheAvatar) {
				(lastMesh) && (_offComputeBoneIndexToMeshEvent(_cacheAvatar, lastMesh));
				(mesh) && (_computeBoneIndexToMeshWithAsyncAvatar());
			}
		}
		
		/**
		 * @private
		 */
		private function _onMeshLoaded(mesh:Mesh):void {
			var subMeshCount:int = mesh.subMeshCount;
			_subSkinnedDatas = new Vector.<Vector.<Float32Array>>();
			_subSkinnedDatas.length = subMeshCount;
			for (var i:int = 0; i < subMeshCount; i++) {
				var subMeshDatas:Vector.<Float32Array> = _subSkinnedDatas[i] = new Vector.<Float32Array>();
				var boneIndicesList:Vector.<Uint8Array> = mesh.getSubMesh(i)._boneIndicesList;
				for (var j:int = 0, m:int = boneIndicesList.length; j < m; j++)
					subMeshDatas[j] = new Float32Array(boneIndicesList[j].length * 16);
			}
		}
		
		/**
		 * @private
		 */
		public function _setCacheAnimator(animator:Animator):void {
			_cacheAnimator = animator;
			(_rootBone) && (_rootIndex = animator._avatarNodes.indexOf(animator._avatarNodeMap[_rootBone]));
		}
		
		/**
		 * @private
		 */
		public function _setRootBone(name:String):void {
			_rootBone = name;
			(_cacheAnimator) && (_rootIndex = _cacheAnimator._avatarNodes.indexOf(_cacheAnimator._avatarNodeMap[name]));
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
		override protected function _calculateBoundingBox():void {
			if (_hasIndependentBound) {
				if (_cacheAnimator) {
					var rootBone:AnimationNode = _cacheAnimator._avatarNodeMap[_rootBone];
					if (rootBone == null || _localBoundBox == null)
						_boundingBox.toDefault();
					else
						_calculateBoundBoxByInitCorners(_localBoundingBoxCorners);
				}
			} else {//兼容代码
				super._calculateBoundingBox();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			if (_hasIndependentBound) {
				if (_cacheAnimator) {
					var rootBone:AnimationNode = _cacheAnimator._avatarNodeMap[_rootBone];
					if (rootBone == null || localBoundSphere == null)
						_boundingSphere.toDefault();
					else
						_calculateBoundingSphereByInitSphere(localBoundSphere);
					
				}
			} else {//兼容代码
				super._calculateBoundingSphere();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _updateOctreeNode():void {
			var treeNode:ITreeNode = _treeNode;
			if (treeNode) {
				treeNode.updateObject(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(projectionView:Matrix4x4):Boolean {
			var projViewWorld:Matrix4x4;
			var animator:Animator = _cacheAnimator;
			var subMeshCount:int = _cacheMesh.subMeshCount;
			var ownerTrans:Transform3D = _owner.transform;
			var cache:Boolean = animator._canCache;
			if (animator) {
				var curAvatarAnimationDatas:Vector.<Float32Array> = _cacheAnimator._curAvatarNodeDatas;
				if (_hasIndependentBound) {
					var ownWorMat:Matrix4x4 = ownerTrans.worldMatrix;
					if (cache)
						Utils3D.matrix4x4MultiplyMFM((_cacheAnimator.owner as Sprite3D).transform.worldMatrix, curAvatarAnimationDatas[_rootIndex], ownWorMat);
					else
						Utils3D.matrix4x4MultiplyMFM((_cacheAnimator.owner as Sprite3D).transform.worldMatrix, animator._avatarNodeMap[_rootBone].transform.getWorldMatrix(), ownWorMat);
					ownerTrans.worldMatrix = ownWorMat;//TODO:涉及到更新顺序，必须先更新父再更新子
				}
				//else{}//兼容性代码
				
				var aniOwner:Sprite3D = animator.owner as Sprite3D;//根节点不缓存
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, aniOwner._transform.worldMatrix);
				projViewWorld = aniOwner.getProjectionViewWorldMatrix(projectionView);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
				
				if (_cacheMesh && _cacheMesh.loaded && _cacheAvatar && _cacheAvatar.loaded) {
					var i:int, n:int;
					var inverseBindPoses:Vector.<Matrix4x4> = _cacheMesh._inverseBindPoses;
					var skinnedDatas:Float32Array = _cacheMesh._skinnedDatas;
					if (cache) {
						for (i = 0, n = inverseBindPoses.length; i < n; i++)
							Utils3D._mulMatrixArray(curAvatarAnimationDatas[_cacheAnimationNodeIndex[i]], inverseBindPoses[i], skinnedDatas, i * 16);
					} else {
						for (i = 0, n = inverseBindPoses.length; i < n; i++)
							Utils3D._mulMatrixArray(_cacheAnimationNode[i].transform.getWorldMatrix(), inverseBindPoses[i], skinnedDatas, i * 16);
					}
					
					for (i = 0; i < subMeshCount; i++) {
						var boneIndicesList:Vector.<Uint8Array> = _cacheMesh.getSubMesh(i)._boneIndicesList;
						var boneIndicesCount:int = boneIndicesList.length;
						var subSkinnedDatas:Vector.<Float32Array> = _subSkinnedDatas[i];
						for (var j:int = 0; j < boneIndicesCount; j++)
							_splitAnimationDatas(boneIndicesList[j], skinnedDatas, subSkinnedDatas[j]);
						(_renderElements[i] as SubMeshRenderElement)._skinAnimationDatas = subSkinnedDatas;//TODO:日后确认是否合理
					}
				}
			} else {
				_setShaderValueMatrix4x4(Sprite3D.WORLDMATRIX, ownerTrans.worldMatrix);
				projViewWorld = _owner.getProjectionViewWorldMatrix(projectionView);
				_setShaderValueMatrix4x4(Sprite3D.MVPMATRIX, projViewWorld);
			}
			
			if (Laya3D.debugMode)
				_renderRenderableBoundBox();
			return true;
		}
		
		//.......................................兼容代码........................................
		public var _hasIndependentBound:Boolean = true;//false为兼容模式
		//.......................................兼容代码........................................
	}
}