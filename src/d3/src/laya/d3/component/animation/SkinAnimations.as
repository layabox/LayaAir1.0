package laya.d3.component.animation {
	import laya.ani.AnimationState;
	import laya.ani.AnimationTemplet;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Stat;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>SkinAnimations</code> 类用于创建蒙皮动画组件。
	 */
	public class SkinAnimations extends KeyframeAnimations {
		/**
		 * @private
		 */
		protected static function _computeSubMeshAniDatas(subMeshIndex:int, index:Uint8Array, bonesData:Float32Array, animationDatas:Array):void {
			var data:Float32Array = animationDatas[subMeshIndex];
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
		protected var _tempCurAnimationData:Array;
		/** @private */
		protected var _tempCurBonesData:Float32Array;
		/** @private */
		protected var _curOriginalData:Float32Array;
		/** @private */
		protected var _extenData:Float32Array;
		/** @private */
		protected var _lastFrameIndex:int = -1;
		/** @private */
		protected var _curMeshAnimationData:Float32Array;
		/** @private */
		protected var _curBonesDatas:Float32Array;
		/** @private */
		protected var _curAnimationDatas:Array;
		/** @private */
		protected var _ownerMesh:MeshSprite3D;
		
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
		public function get curAnimationDatas():Array {
			return _curAnimationDatas;
		}
		
		/**
		 * 设置url地址。
		 * @param value 地址。
		 */
		override public function set url(value:String):void {
			super.url = value;
			_curOriginalData = _extenData = null;//替换文件_extenData不清空会产生BUG，用了旧文件的_extenData
			_curMeshAnimationData = null;
			_tempCurBonesData = null;
			_tempCurAnimationData = null;
			(_templet._animationDatasCache) || (_templet._animationDatasCache = [[], []]);
		}
		
		override public function set templet(value:AnimationTemplet):void {
			super.templet = value;
			_curOriginalData = _extenData = null;//替换文件_extenData不清空会产生BUG，用了旧文件的_extenData
			_curMeshAnimationData = null;
			_tempCurBonesData = null;
			_tempCurAnimationData = null;
			(_templet._animationDatasCache) || (_templet._animationDatasCache = [[], []]);
		}
		
		/**
		 * 创建一个新的 <code>SkinAnimations</code> 实例。
		 */
		public function SkinAnimations() {
			super();
		}
		
		/** @private */
		private function _getAnimationDatasWithCache(rate:Number, mesh:Mesh, cacheDatas:Array, aniIndex:int, frameIndex:int):Array {
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
		private function _setAnimationDatasWithCache(rate:Number, mesh:Mesh, cacheDatas:Array, aniIndex:int, frameIndex:Number, animationDatas:Array):void {
			var aniDatas:Object = (cacheDatas[aniIndex]) || (cacheDatas[aniIndex] = {});
			
			var rateDatas:Object = (aniDatas[rate]) || (aniDatas[rate] = {});
			var meshDatas:Array = (rateDatas[mesh.id]) || (rateDatas[mesh.id] = []);
			meshDatas[frameIndex] = animationDatas;
		}
		
		/** @private */
		private function _onAnimationPlayMeshLoaded():void {
			var renderElements:Vector.<RenderElement> = _ownerMesh.meshRender.renderObject._renderElements;//播放骨骼动画时禁止动态合并
			for (var i:int = 0, n:int = renderElements.length; i < n; i++)
				renderElements[i]._canDynamicBatch = false;
		}
		
		/** @private */
		private function _onAnimationPlay():void {
			var mesh:BaseMesh = _ownerMesh.meshFilter.sharedMesh;
			if (mesh.loaded)
				_onAnimationPlayMeshLoaded();
			else
				mesh.on(Event.LOADED, this, _onAnimationPlayMeshLoaded);
		}
		
		/** @private */
		private function _onAnimationStop():void {
			_lastFrameIndex = -1;
			if (_player.returnToZeroStopped) {
				_curBonesDatas = null;
				_curAnimationDatas = null;
			}
			
			var renderElements:Vector.<RenderElement> = _ownerMesh.meshRender.renderObject._renderElements;
			for (var i:int = 0, n:int = renderElements.length; i < n; i++)
				renderElements[i]._canDynamicBatch = true;
		}
		
		/**
		 * @private
		 * 初始化载入蒙皮动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			super._load(owner);
			_ownerMesh = (owner as MeshSprite3D);
			
			_player.on(Event.PLAYED, this, _onAnimationPlay);
			_player.on(Event.STOPPED, this, _onAnimationStop);
		}
		
		/**
		 * 预缓存帧动画数据（需确保动画模板、模型模板都已加载完成）。
		 * @param	animationClipIndex 动画索引
		 * @param	meshTemplet 动画模板
		 */
		public function preComputeKeyFrames(animationClipIndex:int):void {
			if (!_templet.loaded || !_ownerMesh.meshFilter.sharedMesh.loaded)
				throw new Error("SkinAnimations: must to be sure animation templet and mesh templet has loaded.");
			
			var cachePlayRate:Number = _player.cachePlayRate;
			var cacheFrameRateInterval:Number = _player.cacheFrameRateInterval * cachePlayRate;
			var maxKeyFrame:int = Math.floor(_templet.getAniDuration(animationClipIndex) / cacheFrameRateInterval);
			for (var frameIndex:int = 0; frameIndex <= maxKeyFrame; frameIndex++) {
				
				var boneDatasCache:* = _templet._animationDatasCache[0];
				var animationDatasCache:Array = _templet._animationDatasCache[1];
				var mesh:Mesh = _ownerMesh.meshFilter.sharedMesh as Mesh;
				var cacheAnimationDatas:Array = _getAnimationDatasWithCache(cachePlayRate, mesh, animationDatasCache, animationClipIndex, frameIndex);
				if (cacheAnimationDatas) {
					continue;
				}
				
				var bones:Vector.<Object> = _templet.getNodes(animationClipIndex);
				var boneFloatCount:int = bones.length * 16;
				
				(_curMeshAnimationData) || (_curMeshAnimationData = new Float32Array(boneFloatCount));//使用临时数组，防止对已缓存数据造成破坏
				var i:int, n:int;
				_curAnimationDatas = [];
				for (i = 0, n = mesh.getSubMeshCount(); i < n; i++)
					_curAnimationDatas[i] = new Float32Array(mesh.getSubMesh(i)._boneIndices.length * 16);
				_curBonesDatas = new Float32Array(boneFloatCount);
				
				_curOriginalData || (_curOriginalData = new Float32Array(_templet.getTotalkeyframesLength(animationClipIndex)));
				_templet.getOriginalData(animationClipIndex, _curOriginalData, _player._fullFrames[animationClipIndex], frameIndex, cacheFrameRateInterval * frameIndex/*player.currentFrameTime*/);
				
				var inverseAbsoluteBindPoses:Vector.<Matrix4x4> = mesh.InverseAbsoluteBindPoses;
				if (inverseAbsoluteBindPoses) {
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(bones, _curOriginalData, inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData);
				} else {//兼容旧格式
					_extenData || (_extenData = new Float32Array(_templet.getPublicExtData()));
					Utils3D._computeBoneAndAnimationDatas(bones, _curOriginalData, _extenData, _curBonesDatas, _curMeshAnimationData);
				}
				
				for (i = 0, n = mesh.getSubMeshCount(); i < n; i++) {
					var subMesh:SubMesh = mesh.getSubMesh(i);
					_computeSubMeshAniDatas(i, subMesh._boneIndices, _curMeshAnimationData, _curAnimationDatas);
				}
				
				_setAnimationDatasWithCache(cachePlayRate, mesh, animationDatasCache, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
				_templet.setAnimationDataWithCache(cachePlayRate, boneDatasCache, animationClipIndex, frameIndex, _curBonesDatas);//缓存骨骼数据
			}
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
				var cacheAnimationDatas:Array = _getAnimationDatasWithCache(cachePlayRate, mesh, animationDatasCache, animationClipIndex, frameIndex);
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
			
			(_curMeshAnimationData) || (_curMeshAnimationData = new Float32Array(boneFloatCount));//使用临时数组，防止对已缓存数据造成破坏
			var i:int, n:int;
			if (isCache) {
				_curAnimationDatas = [];
				for (i = 0, n = mesh.getSubMeshCount(); i < n; i++)
					_curAnimationDatas[i] = new Float32Array(mesh.getSubMesh(i)._boneIndices.length * 16);
				(isCacheBonesDatas) || (_curBonesDatas = new Float32Array(boneFloatCount));
			} else {//非缓存或慢动作用临时数组做计算,只new一次
				if (!_tempCurAnimationData) {//使用临时数组，防止对已缓存数据造成破坏
					_tempCurAnimationData = [];
					for (i = 0, n = mesh.getSubMeshCount(); i < n; i++)
						_tempCurAnimationData[i] = new Float32Array(mesh.getSubMesh(i)._boneIndices.length * 16);
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
			
			var inverseAbsoluteBindPoses:Vector.<Matrix4x4> = mesh.InverseAbsoluteBindPoses;
			if (inverseAbsoluteBindPoses) {
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatasByArrayAndMatrixFast(inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData);
				else
					Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix(bones, _curOriginalData, inverseAbsoluteBindPoses, _curBonesDatas, _curMeshAnimationData);
			} else {//兼容旧格式
				_extenData || (_extenData = new Float32Array(_templet.getPublicExtData()));
				if (isCache && isCacheBonesDatas)
					Utils3D._computeAnimationDatas(_extenData, _curBonesDatas, _curMeshAnimationData);
				else
					Utils3D._computeBoneAndAnimationDatas(bones, _curOriginalData, _extenData, _curBonesDatas, _curMeshAnimationData);
			}
			
			for (i = 0, n = mesh.getSubMeshCount(); i < n; i++) {
				var subMesh:SubMesh = mesh.getSubMesh(i);
				_computeSubMeshAniDatas(i, subMesh._boneIndices, _curMeshAnimationData, _curAnimationDatas);
			}
			
			if (isCache) {
				_setAnimationDatasWithCache(cachePlayRate, mesh, animationDatasCache, animationClipIndex, frameIndex, _curAnimationDatas);//缓存动画数据
				(isCacheBonesDatas) || (_templet.setAnimationDataWithCache(cachePlayRate, boneDatasCache, animationClipIndex, frameIndex, _curBonesDatas));//缓存骨骼数据
			}
			
			_lastFrameIndex = frameIndex;
			if (Render.isConchNode) {//NATIVE
				for (i = 0, n = mesh.getSubMeshCount(); i < n; i++) {
					_ownerMesh.meshRender.sharedMaterials[i]._addShaderDefine(ShaderDefines3D.BONE);
					_ownerMesh.meshRender.renderObject._renderElements[i]._conchSubmesh.setShaderValue(RenderElement.BONES, _curAnimationDatas[i],0);
				}
			}
		}
		
		/**
		 * @private
		 *在渲染前更新蒙皮动画组件渲染参数。
		 * @param	state 渲染状态参数。
		 */
		public override function _preRenderUpdate(state:RenderState):void {
			if (_curAnimationDatas) {
				state.shaderDefines.addInt(ShaderDefines3D.BONE);
				var renderElement:RenderElement = state.renderElement;
				var subMeshIndex:int = renderElement.renderObj.indexOfHost;
				renderElement._shaderValue.setValue(RenderElement.BONES, _curAnimationDatas[subMeshIndex]);//TODO:
			}
		}
		
		/**
		 * @private
		 * 卸载组件时执行
		 */
		override public function _unload(owner:Sprite3D):void {
			super._unload(owner);
			_tempCurAnimationData = null;
			_tempCurBonesData = null;
			_curOriginalData = null;
			_extenData = null;
			_curMeshAnimationData = null;
			_curBonesDatas = null;
			_curAnimationDatas = null;
			_ownerMesh = null;
		}
	}
}