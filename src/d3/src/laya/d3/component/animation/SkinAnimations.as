package laya.d3.component.animation {
	import laya.ani.AnimationState;
	import laya.d3.core.MeshFilter;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.utils.Stat;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>SkinAnimations</code> 类用于创建蒙皮动画组件。
	 */
	public class SkinAnimations extends KeyframeAnimations {
		/**
		 * @private
		 */
		protected static function _copyBoneAndCache(frameIndex:int, index:Uint8Array, bonesData:Float32Array, out:Vector.<Float32Array>):void {
			var data:Float32Array = out[frameIndex];
			if (!data)
				(data = out[frameIndex] = new Float32Array(index.length * 16));
			else
				return;
			
			for (var i:int = 0, n:int = index.length, ii:int = 0; i < n; i++) {
				for (var j:int = 0; j < 16; j++, ii++) {
					data[ii] = bonesData[(index[i] << 4) + j];
				}
			}
		}
		
		/**
		 * @private
		 */
		protected static function _copyBone(index:Uint8Array, bonesData:Float32Array, out:Float32Array):void {
			for (var i:int = 0, n:int = index.length, ii:int = 0; i < n; i++) {
				for (var j:int = 0; j < 16; j++, ii++) {
					out[ii] = bonesData[(index[i] << 4) + j];
				}
			}
		}
		
		/** @private */
		protected var _tempFrameIndex:int = -1;
		/** @private */
		protected var _tempIsCache:Boolean = false;
		
		/** @private */
		protected var _tempCurBonesData:Float32Array;
		/** @private */
		protected var _tempCurAnimationData:Float32Array;
		/** @private */
		protected var _curOriginalData:Float32Array;
		/** @private */
		protected var _extenData:Float32Array;
		/** @private */
		protected var _lastFrameIndex:int = -1;
		/** @private */
		protected var _curBonesDatas:Float32Array;
		/** @private */
		protected var _curAnimationDatas:Float32Array;
		/** @private */
		protected var _skinAnimationDatas:Array = [];
		
		/** @private */
		protected var _ownerMesh:MeshSprite3D;
		/** @private */
		public var _subAnimationCacheDatas:Array;
		/** @private */
		public var _subAnimationDatas:Array;
		
		/**
		 * 获取骨骼数据。
		 * @return 骨骼数据。
		 */
		public function get curBonesDatas():Float32Array {
			return _curBonesDatas;
		}
		
		/**
		 * 获取动画数据。
		 * @return 动画数据。
		 */
		public function get curAnimationDatas():Float32Array {
			return _curAnimationDatas;
		}
		
		/**
		 * 设置url地址。
		 * @param value 地址。
		 */
		override public function set url(value:String):void {
			_curOriginalData = _extenData = null;//替换文件_extenData不清空会产生BUG，用了旧文件的_extenData
			_subAnimationCacheDatas.length = 0;
			_subAnimationDatas.length = 0;
			super.url = value;
		}
		
		/**
		 * 创建一个新的 <code>SkinAnimations</code> 实例。
		 */
		public function SkinAnimations() {
			_subAnimationCacheDatas = [];
			_subAnimationDatas = [];
			super();
		}
		
		/** @private */
		private function _onAnimationChanged():void {
			_skinAnimationDatas.length = 0;
		}
		
		/** @private */
		private function _onMeshChanged():void {
			_skinAnimationDatas.length = 0;
			_subAnimationCacheDatas.length = 0;
		}
		
		/**
		 * @private
		 * 初始化载入蒙皮动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			_ownerMesh = (owner as MeshSprite3D);
			on(Event.ANIMATION_CHANGED, this, _onAnimationChanged);
			_ownerMesh.meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
			
			player.on(Event.STOPPED, this, function():void {
				_lastFrameIndex = -1;
				if (player.returnToZeroStopped)
					_curBonesDatas = _curAnimationDatas = null;
			});
		}
		
		/**
		 * @private
		 * 预缓存帧动画数据（需确保动画模板、模型模板都已加载完成）。
		 * @param	animationClipIndex 动画索引
		 * @param	meshTemplet 动画模板
		 */
		public function preComputeKeyFrames(animationClipIndex:int):void {
			var maxKeyFrame:int = Math.floor(_templet.getAniDuration(animationClipIndex) / player.cacheFrameRateInterval);
			for (var frameIndex:int = 0; frameIndex <= maxKeyFrame; frameIndex++) {
				var mesh:Mesh = _ownerMesh.meshFilter.sharedMesh as Mesh;
				
				var cacheData:Float32Array = _templet.getAnimationDataWithCache(_skinAnimationDatas, animationClipIndex, frameIndex);
				if (cacheData) {
					continue;
				}
				
				var bones:Vector.<Object> = _templet.getNodes(animationClipIndex);
				var boneFloatCount:int = bones.length * 16;
				_curAnimationDatas = new Float32Array(boneFloatCount);
				_curBonesDatas = new Float32Array(boneFloatCount);
				
				_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(animationClipIndex)));
				
				_templet.getOriginalData(animationClipIndex, _curOriginalData, frameIndex, player.cacheFrameRateInterval * frameIndex/*player.currentFrameTime*/);
				
				var inverseAbsoluteBindPoses:Vector.<Matrix4x4> = (_ownerMesh.meshFilter.sharedMesh as Mesh).InverseAbsoluteBindPoses;
				if (inverseAbsoluteBindPoses) {
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(bones, _curOriginalData, inverseAbsoluteBindPoses, _curBonesDatas, _curAnimationDatas);
				} else {//兼容旧格式
					_extenData || (_extenData = new Float32Array(_templet.getPublicExtData()));
					Utils3D._computeBoneAndAnimationDatas(bones, _curOriginalData, _extenData, _curBonesDatas, _curAnimationDatas);
				}
				
				_templet.setAnimationDataWithCache(_skinAnimationDatas, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
				_templet.setAnimationDataWithCache(_templet._animationDatasCache, animationClipIndex, frameIndex, _curBonesDatas);//缓存骨骼数据
				
				var subMeshCount:int = mesh.getSubMeshCount();
				
				for (var j:int = 0; j < subMeshCount; j++) {
					var subMesh:SubMesh = mesh.getSubMesh(j);
					var subAnimationData:Vector.<Float32Array> = _subAnimationCacheDatas[j];
					(subAnimationData) || (subAnimationData = _subAnimationCacheDatas[j] = new Vector.<Float32Array>);
					_copyBoneAndCache(frameIndex, subMesh._boneIndex, _curAnimationDatas, subAnimationData);
				}
			}
		}
		
		/**
		 * @private
		 * 更新蒙皮动画组件。
		 * @param	state 渲染状态参数。
		 */
		public override function _update(state:RenderState):void {
			player.update(state.elapsedTime);//需最先执行（如不则内部可能触发Stop事件等，如事件中加载新动画，可能_templet未加载完成，导致BUG）
			
			if (player.state !== AnimationState.playing || !_templet || !_templet.loaded)
				return;
			
			var rate:Number = player.playbackRate * state.scene.timer.scale;
			var isCache:Boolean = _tempIsCache = player.isCache && rate >= 1.0;//是否可以缓存
			var frameIndex:int = _tempFrameIndex = isCache ? currentFrameIndex : -1;//慢动作或者不缓存时frameIndex为-1
			if (frameIndex !== -1 && _lastFrameIndex === frameIndex)//与上一次更新同帧则直接返回
				return;
			
			var animationClipIndex:int = currentAnimationClipIndex;
			if (isCache) {
				var cacheAnimationDatas:Float32Array = _templet.getAnimationDataWithCache(_skinAnimationDatas, animationClipIndex, frameIndex);
				if (cacheAnimationDatas) {
					_curAnimationDatas = cacheAnimationDatas;
					_curBonesDatas = _templet.getAnimationDataWithCache(_templet._animationDatasCache, animationClipIndex, frameIndex);//有AnimationDatas一定有BoneDatas
					_lastFrameIndex = frameIndex;
					return;
				}
			}
			
			//骨骼数据是否缓存。
			var isCacheBonesDatas:Boolean;
			if (isCache) {
				_curBonesDatas = _templet.getAnimationDataWithCache(_templet._animationDatasCache, animationClipIndex, frameIndex);
				isCacheBonesDatas = _curBonesDatas ? true : false;
			}
			
			var nodes:Vector.<Object> = _templet.getNodes(animationClipIndex);
			var nodeFloatCount:int = nodes.length * 16;
			if (isCache) {
				_curAnimationDatas = new Float32Array(nodeFloatCount);
				(isCacheBonesDatas) || (_curBonesDatas = new Float32Array(nodeFloatCount));
			} else {//非缓存或慢动作用临时数组做计算,只new一次
				(_tempCurAnimationData) || (_tempCurAnimationData = new Float32Array(nodeFloatCount));//使用临时数组，防止对已缓存数据造成破坏
				(_tempCurBonesData) || (_tempCurBonesData = new Float32Array(nodeFloatCount));//使用临时数组，防止对已缓存数据造成破坏
				_curAnimationDatas = _tempCurAnimationData;
				_curBonesDatas = _tempCurBonesData;
			}
			
			_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(animationClipIndex)));
			
			if (isCache)
				_templet.getOriginalData(animationClipIndex, _curOriginalData, frameIndex, player.currentFrameTime);
			else//慢动作或者不缓存时
				_templet.getOriginalDataUnfixedRate(animationClipIndex, _curOriginalData, player.currentPlayTime);
			
			var inverseAbsoluteBindPoses:Vector.<Matrix4x4> = (_ownerMesh.meshFilter.sharedMesh as Mesh).InverseAbsoluteBindPoses;
			if (inverseAbsoluteBindPoses) {
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatasByArrayAndMatrixFast(inverseAbsoluteBindPoses, _curBonesDatas, _curAnimationDatas);
				else
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(nodes, _curOriginalData, inverseAbsoluteBindPoses, _curBonesDatas, _curAnimationDatas);
			} else {//兼容旧格式
				_extenData || (_extenData = new Float32Array(_templet.getPublicExtData()));
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatas(_extenData, _curBonesDatas, _curAnimationDatas);
				else
					Utils3D._computeBoneAndAnimationDatas(nodes, _curOriginalData, _extenData, _curBonesDatas, _curAnimationDatas);
			}
			
			if (isCache) {
				_templet.setAnimationDataWithCache(_skinAnimationDatas, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
				(isCacheBonesDatas) || (_templet.setAnimationDataWithCache(_templet._animationDatasCache, animationClipIndex, frameIndex, _curBonesDatas));//缓存骨骼数据
			}
			
			_lastFrameIndex = frameIndex;
		}
		
		/**
		 * @private
		 *在渲染前更新蒙皮动画组件渲染参数。
		 * @param	state 渲染状态参数。
		 */
		public override function _preRenderUpdate(state:RenderState):void {
			if (_curAnimationDatas) {
				state.shaderDefs.addInt(ShaderDefines3D.BONE);
				var subMeshIndex:int = state.renderObj.element.indexOfHost;
				var subMesh:SubMesh = (_ownerMesh.meshFilter.sharedMesh as Mesh).getSubMesh(subMeshIndex);
				
				if (_tempIsCache) {
					var subAnimationCacheData:Vector.<Float32Array> = _subAnimationCacheDatas[subMeshIndex];
					(subAnimationCacheData) || (subAnimationCacheData = _subAnimationCacheDatas[subMeshIndex] = new Vector.<Float32Array>);
					_copyBoneAndCache(_tempFrameIndex, subMesh._boneIndex, _curAnimationDatas, subAnimationCacheData);
					state.shaderValue.pushValue(Buffer2D.MATRIXARRAY0, subAnimationCacheData[_tempFrameIndex], -1);
				} else {
					var subAnimationData:Float32Array = _subAnimationDatas[subMeshIndex];
					(subAnimationData) || (subAnimationData = _subAnimationDatas[subMeshIndex] = new Float32Array(subMesh._boneIndex.length * 16));
					
					_copyBone(subMesh._boneIndex, _curAnimationDatas, subAnimationData);
					
					state.shaderValue.pushValue(Buffer2D.MATRIXARRAY0, subAnimationData, -1);
				}
			}
		}
		
		override public function _unload(owner:Sprite3D):void {
			super._unload(owner);
			off(Event.ANIMATION_CHANGED, this, _onAnimationChanged);
			_ownerMesh.meshFilter.off(Event.MESH_CHANGED, this, _onMeshChanged);
		}
	}
}