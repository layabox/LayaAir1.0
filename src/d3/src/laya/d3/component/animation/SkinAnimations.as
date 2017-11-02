package laya.d3.component.animation {
	import laya.ani.AnimationContent;
	import laya.ani.AnimationState;
	import laya.ani.AnimationTemplet;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	
	/**
	 * <code>SkinAnimations</code> 类用于创建蒙皮动画组件。
	 */
	public class SkinAnimations extends KeyframeAnimations {
		/**
		 * @private
		 */
		protected static function _splitAnimationDatas(indices:Uint8Array, bonesData:Float32Array, subAnimationDatas:Float32Array):void {
			for (var i:int = 0, n:int = indices.length, ii:int = 0; i < n; i++) {
				for (var j:int = 0; j < 16; j++, ii++) {
					subAnimationDatas[ii] = bonesData[(indices[i] << 4) + j];
				}
			}
		}
		
		/** @private */
		protected var _tempCurAnimationData:Vector.<Vector.<Float32Array>>;
		/** @private */
		protected var _tempCurBonesData:Float32Array;
		/** @private */
		protected var _curOriginalData:Float32Array;
		/** @private */
		protected var _lastFrameIndex:int = -1;
		/** @private */
		protected var _curMeshAnimationData:Float32Array;
		/** @private */
		protected var _curBonesDatas:Float32Array;
		/** @private */
		protected var _curAnimationDatas:Vector.<Vector.<Float32Array>>;
		/** @private */
		protected var _ownerMesh:MeshSprite3D;
		/** @private */
		protected var _boneIndexToMeshList:Vector.<Vector.<int>>;
		
		/** @private */
		protected var _oldVersion:Boolean;//TODO:兼容性到代码
		
		/**
		 * 获取骨骼数据。
		 * @return 骨骼数据。
		 */
		public function get curBonesDatas():Float32Array {
			return _curBonesDatas;
		}
		
		override public function set templet(value:AnimationTemplet):void {
			if (_templet !== value) {
				if (_player.state !== AnimationState.stopped)
					_player.stop(true);
				
				_templet = value;
				_player.templet = value;
				_computeBoneIndexToMeshOnTemplet();
				
				_curOriginalData = null;
				_curMeshAnimationData = null;
				_tempCurBonesData = null;
				_tempCurAnimationData = null;
				(_templet._animationDatasCache) || (_templet._animationDatasCache = [[], []]);
				event(Event.ANIMATION_CHANGED, this);
			}
		}
		
		/**
		 * 创建一个新的 <code>SkinAnimations</code> 实例。
		 */
		public function SkinAnimations() {
			super();
			_boneIndexToMeshList = new Vector.<Vector.<int>>();
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMeshOnTemplet():void {
			if (_templet.loaded)
				_computeBoneIndexToMeshOnMesh();
			else
				_templet.once(Event.LOADED, this, _computeBoneIndexToMeshOnMesh);
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMeshOnMesh():void {
			if (_templet._aniVersion === "LAYAANIMATION:02")//TODO:兼容性到代码
				_oldVersion = false;
			else
				_oldVersion = true;
			
			var mesh:Mesh = (_owner as MeshSprite3D).meshFilter.sharedMesh as Mesh;
			if (mesh.loaded)
				_computeBoneIndexToMesh(mesh);
			else
				mesh.on(Event.LOADED, this, _computeBoneIndexToMesh);
		}
		
		/**
		 * @private
		 */
		private function _computeBoneIndexToMesh(mesh:Mesh):void {
			var meshBoneNames:Vector.<String> = mesh._boneNames;
			if (meshBoneNames) {//TODO:兼容性判断
				var binPoseCount:int = meshBoneNames.length;
				var anis:Vector.<AnimationContent> = _templet._anis;
				for (var i:int = 0, n:int = anis.length; i < n; i++) {
					var boneIndexToMesh:Vector.<int> = _boneIndexToMeshList[i];
					(boneIndexToMesh) || (boneIndexToMesh = _boneIndexToMeshList[i] = new Vector.<Vector.<int>>());
					boneIndexToMesh.length = binPoseCount;
					var ani:AnimationContent = anis[i];
					for (var j:int = 0; j < binPoseCount; j++)
						boneIndexToMesh[j] = ani.bone3DMap[meshBoneNames[j]];
				}
			}
		}
		
		/** @private */
		private function _getAnimationDatasWithCache(rate:Number, mesh:Mesh, cacheDatas:Array, aniIndex:int, frameIndex:int):Vector.<Vector.<Float32Array>> {
			var aniDatas:Object = cacheDatas[aniIndex];
			if (!aniDatas) {
				return null;
			} else {
				var rateDatas:Object = aniDatas[rate];
				if (!rateDatas)
					return null;
				else {
					var meshDatas:Array = rateDatas[mesh.id];
					if (!meshDatas)
						return null;
					else
						return meshDatas[frameIndex];
				}
			}
		}
		
		/** @private */
		private function _setAnimationDatasWithCache(rate:Number, mesh:Mesh, cacheDatas:Array, aniIndex:int, frameIndex:Number, animationDatas:Vector.<Vector.<Float32Array>>):void {
			var aniDatas:Object = (cacheDatas[aniIndex]) || (cacheDatas[aniIndex] = {});
			
			var rateDatas:Object = (aniDatas[rate]) || (aniDatas[rate] = {});
			var meshDatas:Array = (rateDatas[mesh.id]) || (rateDatas[mesh.id] = []);
			meshDatas[frameIndex] = animationDatas;
		}
		
		/** @private */
		private function _onAnimationPlayMeshLoaded():void {
			var renderElements:Vector.<RenderElement> = _ownerMesh.meshRender._renderElements;//播放骨骼动画时禁止动态合并
			for (var i:int = 0, n:int = renderElements.length; i < n; i++)
				renderElements[i]._canDynamicBatch = false;
		}
		
		/** @private */
		private function _onAnimationPlay():void {
			_ownerMesh._render._addShaderDefine(SkinnedMeshSprite3D.SHADERDEFINE_BONE);
			var mesh:BaseMesh = _ownerMesh.meshFilter.sharedMesh;
			if (mesh.loaded)
				_onAnimationPlayMeshLoaded();
			else
				mesh.once(Event.LOADED, this, _onAnimationPlayMeshLoaded);
		
		}
		
		/** @private */
		private function _onAnimationStop():void {
			_lastFrameIndex = -1;
			if (_player.returnToZeroStopped) {
				_curBonesDatas = null;
				_curAnimationDatas = null;
				_ownerMesh._render._removeShaderDefine(SkinnedMeshSprite3D.SHADERDEFINE_BONE);
			}
			
			var renderElements:Vector.<RenderElement> = _ownerMesh.meshRender._renderElements;
			for (var i:int = 0, n:int = renderElements.length; i < n; i++)
				renderElements[i]._canDynamicBatch = true;
		}
		
		/**
		 * @private
		 * 初始化载入蒙皮动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:ComponentNode):void {
			super._load(owner);
			_ownerMesh = (owner as MeshSprite3D);
			
			_player.on(Event.PLAYED, this, _onAnimationPlay);
			_player.on(Event.STOPPED, this, _onAnimationStop);
			
			(_owner as MeshSprite3D).meshFilter.on(Event.MESH_CHANGED, this, _computeBoneIndexToMeshOnTemplet);
		}
		
		/**
		 * @private
		 * 更新蒙皮动画组件。
		 * @param	state 渲染状态参数。
		 */
		public override function _update(state:RenderState):void {
			var mesh:Mesh = _ownerMesh.meshFilter.sharedMesh as Mesh;
			if (_player.state !== AnimationState.playing || !_templet || !_templet.loaded || !mesh.loaded)
				return;
			
			var rate:Number = _player.playbackRate * Laya.timer.scale;
			var cachePlayRate:Number = _player.cachePlayRate;
			var isCache:Boolean = _player.isCache && rate >= cachePlayRate;//是否可以缓存
			var frameIndex:int = isCache ? currentFrameIndex : -1;//慢动作或者不缓存时frameIndex为-1
			if (frameIndex !== -1 && _lastFrameIndex === frameIndex)//与上一次更新同帧则直接返回
				return;
			
			var animationClipIndex:int = currentAnimationClipIndex;
			var boneDatasCache:* = _templet._animationDatasCache[0];
			var animationDatasCache:Array = _templet._animationDatasCache[1];
			if (isCache) {
				var cacheAnimationDatas:Vector.<Vector.<Float32Array>> = _getAnimationDatasWithCache(cachePlayRate, mesh, animationDatasCache, animationClipIndex, frameIndex);
				if (cacheAnimationDatas) {
					_curAnimationDatas = cacheAnimationDatas;
					_curBonesDatas = _templet.getAnimationDataWithCache(cachePlayRate, boneDatasCache, animationClipIndex, frameIndex);//有AnimationDatas一定有BoneDatas
					_lastFrameIndex = frameIndex;
					return;
				}
			}
			
			//骨骼数据是否缓存。
			var isCacheBonesDatas:Boolean;
			if (isCache) {
				_curBonesDatas = _templet.getAnimationDataWithCache(cachePlayRate, boneDatasCache, animationClipIndex, frameIndex);
				isCacheBonesDatas = _curBonesDatas ? true : false;
			}
			
			var bones:Vector.<Object> = _templet.getNodes(animationClipIndex);
			var boneFloatCount:int = bones.length * 16;
			
			var inverseAbsoluteBindPoses:Vector.<Matrix4x4> = mesh.InverseAbsoluteBindPoses;
			
			if (_oldVersion) //兼容性代码
				(_curMeshAnimationData) || (_curMeshAnimationData = new Float32Array(boneFloatCount));//使用临时数组，防止对已缓存数据造成破坏
			else
				(_curMeshAnimationData) || (_curMeshAnimationData = new Float32Array(inverseAbsoluteBindPoses.length * 16));//使用临时数组，防止对已缓存数据造成破坏
			
			var i:int, n:int, j:int;
			var curSubAnimationDatas:Vector.<Float32Array>, subMesh:SubMesh, boneIndicesCount:int;
			var subMeshCount:int = mesh.getSubMeshCount();
			if (isCache) {
				_curAnimationDatas = new Vector.<Vector.<Float32Array>>();
				_curAnimationDatas.length = subMeshCount;
				for (i = 0; i < subMeshCount; i++) {
					curSubAnimationDatas = _curAnimationDatas[i] = new Vector.<Float32Array>();
					subMesh = mesh.getSubMesh(i);
					boneIndicesCount = subMesh._boneIndicesList.length;
					curSubAnimationDatas.length = boneIndicesCount;
					for (j = 0; j < boneIndicesCount; j++)
						curSubAnimationDatas[j] = new Float32Array(subMesh._boneIndicesList[j].length * 16);
				}
				(isCacheBonesDatas) || (_curBonesDatas = new Float32Array(boneFloatCount));
			} else {//非缓存或慢动作用临时数组做计算,只new一次
				if (!_tempCurAnimationData) {//使用临时数组，防止对已缓存数据造成破坏
					_tempCurAnimationData = new Vector.<Vector.<Float32Array>>();
					_tempCurAnimationData.length = subMeshCount;
					for (i = 0; i < subMeshCount; i++) {
						curSubAnimationDatas = _tempCurAnimationData[i] = new Vector.<Float32Array>();
						subMesh = mesh.getSubMesh(i);
						boneIndicesCount = subMesh._boneIndicesList.length;
						curSubAnimationDatas.length = boneIndicesCount;
						for (j = 0; j < boneIndicesCount; j++)
							curSubAnimationDatas[j] = new Float32Array(subMesh._boneIndicesList[j].length * 16);
					}
				}
				(_tempCurBonesData) || (_tempCurBonesData = new Float32Array(boneFloatCount));//使用临时数组，防止对已缓存数据造成破坏
				_curAnimationDatas = _tempCurAnimationData;
				_curBonesDatas = _tempCurBonesData;
			}
			
			_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(animationClipIndex)));
			
			if (isCache)
				_templet.getOriginalData(animationClipIndex, _curOriginalData, _player._fullFrames[animationClipIndex], frameIndex, _player.currentFrameTime);
			else//慢动作或者不缓存时
				_templet.getOriginalDataUnfixedRate(animationClipIndex, _curOriginalData, _player.currentPlayTime);
			
			if (_oldVersion) {//兼容性代码
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatasByArrayAndMatrixFastOld(inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData);
				else
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxixOld(bones, _curOriginalData, inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData);
			} else {
				var boneIndexToMesh:Vector.<int> = _boneIndexToMeshList[animationClipIndex];
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatasByArrayAndMatrixFast(inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData, boneIndexToMesh);
				else
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(bones, _curOriginalData, inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData, boneIndexToMesh);
			}
			
			for (i = 0; i < subMeshCount; i++) {
				var boneIndicesList:Vector.<Uint8Array> = mesh.getSubMesh(i)._boneIndicesList;
				boneIndicesCount = boneIndicesList.length;
				curSubAnimationDatas = _curAnimationDatas[i]
				for (j = 0; j < boneIndicesCount; j++)
					_splitAnimationDatas(boneIndicesList[j], _curMeshAnimationData, curSubAnimationDatas[j]);
			}
			
			if (isCache) {
				_setAnimationDatasWithCache(cachePlayRate, mesh, animationDatasCache, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
				(isCacheBonesDatas) || (_templet.setAnimationDataWithCache(cachePlayRate, boneDatasCache, animationClipIndex, frameIndex, _curBonesDatas));//缓存骨骼数据
			}
			
			_lastFrameIndex = frameIndex;
			//if (Render.isConchNode) {//NATIVE
			//for (i = 0, n = mesh.getSubMeshCount(); i < n; i++) {
			//_ownerMesh.meshRender.sharedMaterials[i]._addShaderDefine(SkinnedMeshSprite3D.SHADERDEFINE_BONE);
			//_ownerMesh.meshRender._renderElements[i]._conchSubmesh.setShaderValue(SkinnedMeshSprite3D.BONES, _curAnimationDatas[i], 0);
			//}
			//}
		}
		
		/**
		 * @private
		 * 在渲染前更新蒙皮动画组件渲染参数。
		 * @param	state 渲染状态参数。
		 */
		public override function _preRenderUpdate(state:RenderState):void {
			var subMesh:SubMesh = state.renderElement.renderObj as SubMesh;
			if (_curAnimationDatas)
				subMesh._skinAnimationDatas = _curAnimationDatas[subMesh._indexInMesh];
			else
				subMesh._skinAnimationDatas = null;
		}
		
		/**
		 * @private
		 * 卸载组件时执行
		 */
		override public function _unload(owner:ComponentNode):void {
			(player.state == AnimationState.playing) && (_ownerMesh._render._removeShaderDefine(SkinnedMeshSprite3D.SHADERDEFINE_BONE));
			(_templet && !_templet.loaded) && (_templet.off(Event.LOADED, this, _computeBoneIndexToMeshOnMesh));
			var mesh:Mesh = _ownerMesh.meshFilter.sharedMesh as Mesh;
			(mesh.loaded) || (mesh.off(Event.LOADED, this, _onAnimationPlayMeshLoaded));
			super._unload(owner);
			_tempCurAnimationData = null;
			_tempCurBonesData = null;
			_curOriginalData = null;
			_curMeshAnimationData = null;
			_curBonesDatas = null;
			_curAnimationDatas = null;
			_ownerMesh = null;
		
		}
	}
}