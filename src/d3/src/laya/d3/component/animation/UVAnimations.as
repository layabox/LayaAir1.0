package laya.d3.component.animation {
	import laya.ani.AnimationState;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.shader.ShaderDefines3D;
	import laya.events.Event;
	import laya.utils.Byte;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * <code>UVAnimations</code> 类用于创建UV动画组件。
	 */
	public class UVAnimations extends KeyframeAnimations {
		/** @private */
		private var _subMeshIndexToNodeIndex:Vector.<int> = new Vector.<int>();
		/** @private */
		private var _keyframeAges:Vector.<Number> = new Vector.<Number>();
		/** @private */
		private var _ages:Vector.<Number> = new Vector.<Number>();
		/** @private */
		private var _bufferUsages:Vector.<*> = new Vector.<*>();
		/** @private */
		private var _originalShaderAttributes:Vector.<Vector.<Array>> = new Vector.<Vector.<Array>>();
		/** @private */
		private var _nodes:Vector.<*>;
		/** @private */
		private var _lasstInitIndex:int = -1;
		/** @private */
		//private var _subMeshes:Vector.<SubMesh>;
		/** @private */
		private var _materials:Vector.<BaseMaterial>;
		/** @private */
		private var _mesh:MeshSprite3D;
		/** @private */
		private var _meshDataInited:Boolean;
		/** @private */
		private var _uvShaderValues:Vector.<Vector.<Array>> = new Vector.<Vector.<Array>>();
		/** @private */
		private var _uvNextShaderValues:Vector.<Vector.<Array>> = new Vector.<Vector.<Array>>();
		/** @private */
		private var _uvAnimationBuffers:Vector.<Vector.<VertexBuffer3D>> = new Vector.<Vector.<VertexBuffer3D>>();
		/** @private */
		private var _uvDatasCount:int;
		
		/**
		 * 创建一个新的 <code>UVAnimations</code> 实例。
		 */
		public function UVAnimations() {
			super();
			_meshDataInited = false;
		}
		
		/**
		 * @private
		 * 初始化Mesh相关数据函数。
		 */
		private function _initMeshData():void {
			_materials = _mesh.meshRender.sharedMaterials;
			//_subMeshes = _mesh.mesh.subMeshes;
			_meshDataInited = true;
		}
		
		/**
		 * @private
		 * 初始化UV动画相关数据函数。
		 */
		private function _initAnimationData(animationIndex:int):void {
			//if (_lasstInitIndex !== animationIndex) {
				//_nodes = _templet.getNodes(animationIndex);
				//for (var i:int = 0; i < _nodes.length; i++) {
					//var node:* = _nodes[i];
					//var extenData:ArrayBuffer = node.extenData;
					//var extenDaraReader:Byte = new Byte(extenData);
					//var belongSubMeshIndex:int = extenDaraReader.getInt32();
					//_uvDatasCount = extenDaraReader.getInt32();
					//var subMesh:SubMesh = _subMeshes[belongSubMeshIndex];
					//_subMeshIndexToNodeIndex[belongSubMeshIndex] = i;
					//
					////初始化一次
					//if (!_bufferUsages[i]) {
						//_bufferUsages[i] = {}
						//for (var key:String in subMesh._bufferUsage)//更新bufferUsage，多VB模式下需要
							//_bufferUsages[i][key] = subMesh._bufferUsage[key];
					//}
					//
					//_originalShaderAttributes[i] = new Vector.<Array>();
					//for (var c:int = 0; c < _uvDatasCount; c++) {
						//if (c === 0)
							//_originalShaderAttributes[i][c] = subMesh.getMaterial(subMesh._meshTemplet.materials).getShaderAttribute("UV");//保存初始UV0ShaderAttribute
						//else
							//_originalShaderAttributes[i][c] = subMesh.getMaterial(subMesh._meshTemplet.materials).getShaderAttribute("UV" + c.toString());//保存初始UV1ShaderAttribute
					//}
					//
					//var bufferUsage:* = _bufferUsages[i];
					//_uvAnimationBuffers[i] = new Vector.<VertexBuffer2D>;
					//for (c = 0; c < _uvDatasCount; c++) {
						//var subKeyframeWidth:int = node.keyframeWidth / _uvDatasCount;//平分UV数据
						//var animationDatas:Float32Array = new Float32Array(node.keyFrame.length * subKeyframeWidth);
						//var currentLength:int = 0;
						//for (var j:int = 0; j < node.keyFrame.length; j++) {
							//animationDatas.set(node.keyFrame[j].data.subarray(c * subKeyframeWidth, (c + 1) * subKeyframeWidth), currentLength);
							//currentLength += subKeyframeWidth;
						//}
						//
						//_uvAnimationBuffers[i][c] = VertexBuffer3D.create(new VertexDeclaration(-1),WebGLContext.STATIC_DRAW);
						//if (c === 0)
							//bufferUsage["UV"] = bufferUsage["NEXTUV"] = _uvAnimationBuffers[i][c];
						//else
							//bufferUsage["UV" + c.toString()] = bufferUsage["NEXTUV" + c.toString()] = _uvAnimationBuffers[i][c];
						//
						//_uvAnimationBuffers[i][c].clear();
						//_uvAnimationBuffers[i][c].append(animationDatas);//TODO:待调整
						//_uvAnimationBuffers[i][c].upload();
					//}
				//}
				//_lasstInitIndex = animationIndex;
			//}
		}
		
		/**
		 * @private
		 * 初始化载入UV动画组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void {
			if (owner is MeshSprite3D)
				_mesh = owner as MeshSprite3D;
			else
				throw new Error("该Sprite3D并非Mesh");
			
			owner.on(Event.LOADED, this, function(mesh:MeshSprite3D):void {
				//(!_meshDataInited) && (_initMeshData());//初始化所需Mesh相关数据
				//(player.State == AnimationState.playing) && (_templet) && (_templet.loaded) && (_initAnimationData(currentAnimationClipIndex));
			});
			
			on(Event.LOADED, this, function():void {
				//(!_meshDataInited) && (_initMeshData());//初始化所需Mesh相关数据
				//(player.State == AnimationState.playing) && (_mesh.mesh) && (_mesh.mesh.loaded) && (_initAnimationData(currentAnimationClipIndex));
			});
			
			player.on(Event.PLAYED, this, function():void {
				//(_templet) && (_templet.loaded) && (_mesh.mesh) && (_mesh.mesh.loaded) && (_initAnimationData(currentAnimationClipIndex));
			});
			
			player.on(Event.STOPPED, this, function():void {
				//if (player.returnToZeroStopped) {
					//if (owner is MeshSprite3D) {
						//var templet:Mesh = (owner as MeshSprite3D).mesh;
						//var materials:Vector.<Material> = templet.materials;
						//var subMeshs:Vector.<SubMeshTemplet> = templet.subMeshes;
						//for (var i:int = 0; i < subMeshs.length; i++)//待处理，同模板实例会受影响
						//{
							//var uvAniNodeIndex:* = _subMeshIndexToNodeIndex[i];
							//if (uvAniNodeIndex != null) {
								//for (var c:int = 0; c < _uvDatasCount; c++)//TODO:待调整
								//{
									//if (c === 0)
										//_originalShaderAttributes[uvAniNodeIndex] && (materials[subMeshs[i].material].addOrUpdateShaderAttribute("UV", _originalShaderAttributes[uvAniNodeIndex][c], -1));
									//else
										//_originalShaderAttributes[uvAniNodeIndex] && (materials[subMeshs[i].material].addOrUpdateShaderAttribute("UV" + c.toString(), _originalShaderAttributes[uvAniNodeIndex][c], -1));
								//}
							//}
						//}
					//}
				//}
			});
		}
		
		/**
		 * @private
		 * 更新UV动画组件。
		 * @param	state 渲染状态参数。
		 */
		public override function _update(state:RenderState):void {
			player.update(state.elapsedTime);//需最先执行（如不则内部可能触发Stop事件等，如事件中加载新动画，可能_templet未加载完成，导致BUG）
			
			if (!_templet || !_templet.loaded || player.state !== AnimationState.playing)
				return;
			
			var animationClipIndex:int = currentAnimationClipIndex;
			var unfixedIndexes:Uint32Array = _templet.getNodesCurrentFrameIndex(animationClipIndex, player.currentPlayTime);
			
			for (var i:int = 0; i < _nodes.length; i++) {
				var index:int = unfixedIndexes[i];
				_keyframeAges[i] = (player.currentPlayTime - _nodes[i].keyFrame[index].startTime) / _nodes[i].keyFrame[index].duration;
				_ages[i] = player.currentPlayTime / _nodes[i].playTime;
				var subkeyframeWidth:int = _nodes[i].keyframeWidth / _uvDatasCount;
				
				(_uvShaderValues[i]) || (_uvShaderValues[i] = new Vector.<Array>());
				(_uvNextShaderValues[i]) || (_uvNextShaderValues[i] = new Vector.<Array>());
				for (var c:int = 0; c < _uvDatasCount; c++)//平分keyframe宽度
				{
					var uvShaderValue:Array = [2, WebGLContext.FLOAT, false, 0, (index) * subkeyframeWidth * 4];
					var uvNextShaderValue:Array = [2, WebGLContext.FLOAT, false, 0, (index + 1) * subkeyframeWidth * 4];
					
					_uvShaderValues[i][c] = uvShaderValue;
					_uvNextShaderValues[i][c] = uvNextShaderValue;
				}
			}
			super._update(state);
		}
		
		/**
		 * @private
		 *在渲染前更新UV动画组件渲染参数。
		 * @param	state 渲染状态参数。
		 */
		public override function _preRenderUpdate(state:RenderState):void {
			//if (!_templet || !_templet.loaded || player.State !== AnimationState.playing)
				//return;
			//
			//var subMeshIndex:int = state.renderObj.renderElement.indexOfHost;
			//var subMesh:SubMeshTemplet = _subMeshes[subMeshIndex];
			//var uvAniNodeIndex:* = _subMeshIndexToNodeIndex[subMeshIndex];
			//(player.State !== AnimationState.stopped) && (uvAniNodeIndex != null) && (state.shaderDefs.addInt(ShaderDefines3D.MIXUV));
			//var material:Material = subMesh.getMaterial(_materials);
			//if ((uvAniNodeIndex != null) && player.State !== AnimationState.stopped) {
				//state.shaderValue.pushValue(Buffer2D.FLOAT0, _keyframeAges[uvAniNodeIndex], -1);
				//state.shaderValue.pushValue(Buffer2D.UVAGEX, _ages[uvAniNodeIndex], -1);
				//
				//for (var c:int = 0; c < _uvDatasCount; c++) {
					//if (c === 0) {
						////material.addOrUpdateShaderAttribute("UV", _uvShaderValues[uvAniNodeIndex][c], -1);
						////material.addOrUpdateShaderAttribute("NEXTUV", _uvNextShaderValues[uvAniNodeIndex][c], -1);
					//} else {
						////material.addOrUpdateShaderAttribute("UV" + c.toString(), _uvShaderValues[uvAniNodeIndex][c], -1);
						////material.addOrUpdateShaderAttribute("NEXTUV" + c.toString(), _uvNextShaderValues[uvAniNodeIndex][c], -1);
					//}
				//}
				//
				//subMesh._finalBufferUsageDic = _bufferUsages[uvAniNodeIndex];
			//}
		}
	
	}
}