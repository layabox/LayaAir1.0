package laya.d3.component {
	import laya.components.Component;
	import laya.d3.animation.AnimationClip;
	import laya.d3.animation.AnimationEvent;
	import laya.d3.animation.AnimationNode;
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.animation.AnimatorStateScript;
	import laya.d3.animation.KeyframeNode;
	import laya.d3.animation.KeyframeNodeList;
	import laya.d3.core.Avatar;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.layagl.LayaGL;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.utils.Timer;
	
	/**
	 * <code>Animator</code> 类用于创建动画组件。
	 */
	public class Animator extends Component {
		/** @private */
		private static var _tempVector3Array0:Float32Array = /*[STATIC SAFE]*/ new Float32Array(3);
		/** @private */
		private static var _tempVector3Array1:Float32Array = /*[STATIC SAFE]*/ new Float32Array(3);
		/** @private */
		private static var _tempQuaternionArray0:Float32Array =/*[STATIC SAFE]*/ new Float32Array(4);
		/** @private */
		private static var _tempQuaternionArray1:Float32Array =/*[STATIC SAFE]*/ new Float32Array(4);
		
		/** 裁剪模式_始终播放动画。*/
		public static const CULLINGMODE_ALWAYSANIMATE:int = 0;
		/** 裁剪模式_不可见时完全不播放动画。*/
		public static const CULLINGMODE_CULLCOMPLETELY:int = 2;
		
		/**
		 * @private
		 */
		public static function _update(scene:Scene3D):void {
			var pool:SimpleSingletonList = scene._animatorPool;
			var elements:Vector.<Animator> = pool.elements as Vector.<Animator>;
			for (var i:int = 0, n:int = pool.length; i < n; i++) {
				var animator:Animator = elements[i];
				(animator && animator.enabled) && (animator._update());
			}
		}
		
		/**@private */
		private var _speed:Number;
		/**@private */
		private var _avatar:Avatar;
		/**@private */
		private var _keyframeNodeOwnerMap:Object;
		/**@private */
		private var _keyframeNodeOwners:Vector.<KeyframeNodeOwner> = new Vector.<KeyframeNodeOwner>();
		/**@private */
		private var _updateMark:int;
		/**@private */
		private var _controllerLayers:Vector.<AnimatorControllerLayer>;
		/**@private */
		public var _linkSprites:Object;
		
		/**@private	*/
		public var _avatarNodeMap:Object;
		/**@private */
		public var _linkAvatarSpritesData:Object = {};
		/**@private */
		public var _linkAvatarSprites:Vector.<Sprite3D> = new Vector.<Sprite3D>();
		/**@private */
		public var _renderableSprites:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>();
		
		/**	裁剪模式*/
		public var cullingMode:int = CULLINGMODE_CULLCOMPLETELY;
		
		/**@private	[NATIVE]*/
		public var _animationNodeLocalPositions:Float32Array;
		/**@private	[NATIVE]*/
		public var _animationNodeLocalRotations:Float32Array;
		/**@private	[NATIVE]*/
		public var _animationNodeLocalScales:Float32Array;
		/**@private	[NATIVE]*/
		public var _animationNodeWorldMatrixs:Float32Array;
		/**@private	[NATIVE]*/
		public var _animationNodeParentIndices:Int16Array;
		
		/**
		 * 获取avatar。
		 * @return avator。
		 */
		public function get avatar():Avatar {
			return _avatar;
		}
		
		/**
		 * 设置avatar。
		 * @param value avatar。
		 */
		public function set avatar(value:Avatar):void {
			if (_avatar !== value) {
				_avatar = value;
				if (value) {
					_getAvatarOwnersAndInitDatasAsync();
					(owner as Sprite3D)._changeHierarchyAnimatorAvatar(this, value);
				} else {
					var parent:Node = owner._parent;
					(owner as Sprite3D)._changeHierarchyAnimatorAvatar(this, parent ? (parent as Sprite3D)._hierarchyAnimator._avatar : null);
				}
			}
		}
		
		/**
		 * 获取动画的播放速度,1.0为正常播放速度。
		 * @return 动画的播放速度。
		 */
		public function get speed():Number {
			return _speed;
		}
		
		/**
		 * 设置动画的播放速度,1.0为正常播放速度。
		 * @param 动画的播放速度。
		 */
		public function set speed(value:Number):void {
			_speed =value;
		}
		
		/**
		 * 创建一个 <code>Animation</code> 实例。
		 */
		public function Animator() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_controllerLayers = new Vector.<AnimatorControllerLayer>();
			
			_linkSprites = {};
			_speed = 1.0;
			_keyframeNodeOwnerMap = {};
			_updateMark = 0;
		}
		
		/**
		 * @private
		 */
		private function _linkToSprites(linkSprites:Object):void {
			for (var k:String in linkSprites) {
				var nodeOwner:Sprite3D = owner as Sprite3D;
				var path:Vector.<String> = linkSprites[k];
				for (var j:int = 0, m:int = path.length; j < m; j++) {
					var p:String = path[j];
					if (p === "") {
						break;
					} else {
						nodeOwner = nodeOwner.getChildByName(p) as Sprite3D;
						if (!nodeOwner)
							break;
					}
				}
				(nodeOwner) && (linkSprite3DToAvatarNode(k, nodeOwner));//此时Avatar文件已经加载完成
			}
		}
		
		/**
		 * @private
		 */
		private function _addKeyframeNodeOwner(clipOwners:Vector.<KeyframeNodeOwner>, node:KeyframeNode, propertyOwner:*):void {
			var nodeIndex:int = node._indexInList;
			var fullPath:String = node.fullPath;
			var keyframeNodeOwner:KeyframeNodeOwner = _keyframeNodeOwnerMap[fullPath];
			if (keyframeNodeOwner) {
				keyframeNodeOwner.referenceCount++;
				clipOwners[nodeIndex] = keyframeNodeOwner;
			} else {
				var property:* = propertyOwner;
				for (var i:int = 0, n:int = node.propertyCount; i < n; i++) {
					property = property[node.getPropertyByIndex(i)];
					if (!property)
						break;
				}
				
				keyframeNodeOwner = _keyframeNodeOwnerMap[fullPath] = new KeyframeNodeOwner();
				keyframeNodeOwner.fullPath = fullPath;
				keyframeNodeOwner.indexInList = _keyframeNodeOwners.length;
				keyframeNodeOwner.referenceCount = 1;
				keyframeNodeOwner.propertyOwner = propertyOwner;
				var propertyCount:int = node.propertyCount;
				var propertys:Vector.<String> = new Vector.<String>(propertyCount);
				for (i = 0; i < propertyCount; i++)
					propertys[i] = node.getPropertyByIndex(i);
				keyframeNodeOwner.property = propertys;
				keyframeNodeOwner.type = node.type;
				
				if (property) {//查询成功后赋默认值
					if (node.type === 0)
						keyframeNodeOwner.defaultValue = property;
					else
						keyframeNodeOwner.defaultValue = property.elements.slice();
				}
				
				_keyframeNodeOwners.push(keyframeNodeOwner);
				clipOwners[nodeIndex] = keyframeNodeOwner;
			}
		}
		
		/**
		 * @private
		 */
		private function _removeKeyframeNodeOwner(nodeOwners:Vector.<KeyframeNodeOwner>, node:KeyframeNode):void {
			var fullPath:String = node.fullPath;
			var keyframeNodeOwner:KeyframeNodeOwner = _keyframeNodeOwnerMap[fullPath];
			if (keyframeNodeOwner) {//TODO:Avatar中没该节点,但动画文件有,不会保存_keyframeNodeOwnerMap在中,移除会出BUG,例如动画节点下的SkinnedMeshRender有动画帧，但Avatar中忽略了
				keyframeNodeOwner.referenceCount--;
				if (keyframeNodeOwner.referenceCount === 0) {
					delete _keyframeNodeOwnerMap[fullPath];
					_keyframeNodeOwners.splice(_keyframeNodeOwners.indexOf(keyframeNodeOwner), 1);
				}
				nodeOwners[node._indexInList] = null;
			}
		}
		
		/**
		 * @private
		 */
		private function _getOwnersByClip(clipStateInfo:AnimatorState):void {
			var frameNodes:KeyframeNodeList = clipStateInfo._clip._nodes;
			var frameNodesCount:int = frameNodes.count;
			var nodeOwners:Vector.<KeyframeNodeOwner> = clipStateInfo._nodeOwners;
			nodeOwners.length = frameNodesCount;
			for (var i:int = 0; i < frameNodesCount; i++) {
				var node:KeyframeNode = frameNodes.getNodeByIndex(i);
				var property:* = _avatar ? _avatarNodeMap[_avatar._rootNode.name] : owner;//如果有avatar需使用克隆节点
				for (var j:int = 0, m:int = node.ownerPathCount; j < m; j++) {
					var ownPat:String = node.getOwnerPathByIndex(j);
					if (ownPat === "") {//TODO:直接不存
						break;
					} else {
						property = property.getChildByName(ownPat);
						if (!property)
							break;
					}
				}
				
				if (property) {
					var propertyOwner:String = node.propertyOwner;
					(propertyOwner) && (property = property[propertyOwner]);
					property && _addKeyframeNodeOwner(nodeOwners, node, property);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _getOwnersByClipAsync(clipStateInfo:AnimatorState):void {
			var clip:AnimationClip = clipStateInfo._clip;
			_getOwnersByClip(clipStateInfo);
		}
		
		/**
		 * @private
		 */
		private function _getAvatarOwnersAndInitDatasAsync():void {
			for (var i:int = 0, n:int = _controllerLayers.length; i < n; i++) {
				var clipStateInfos:Vector.<AnimatorState> = _controllerLayers[i]._states;
				for (var j:int = 0, m:int = clipStateInfos.length; j < m; j++)
					_getOwnersByClipAsync(clipStateInfos[j]);
			}
			
			_avatar._cloneDatasToAnimator(this);
			for (var k:String in _linkAvatarSpritesData) {
				var sprites:Array = _linkAvatarSpritesData[k];
				if (sprites) {
					for (var c:int = 0, p:int = sprites.length; c < p; c++)
						_isLinkSpriteToAnimationNode(sprites[c], k, true);//TODO:对应移除
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _eventScript(scripts:Vector.<Script3D>, clipState:AnimatorState, playState:AnimatorPlayState, from:Number, to:Number):void {
			var events:Vector.<AnimationEvent> = clipState._clip._events;
			var eventIndex:int = playState._playEventIndex;
			for (var n:int = events.length; eventIndex < n; eventIndex++) {//TODO:_playEventIndex问题
				var eve:AnimationEvent = events[eventIndex];
				var eventTime:Number = eve.time;
				if (from <= eventTime && eventTime < to) {
					for (var j:int = 0, m:int = scripts.length; j < m; j++) {
						var script:Script3D = scripts[j];
						var fun:Function = script[eve.eventName];
						(fun) && (fun.apply(script, eve.params));
					}
				} else {
					break;
				}
			}
			playState._playEventIndex = eventIndex;
		}
		
		/**
		 * @private
		 */
		private function _updatePlayer(animatorState:AnimatorState, playState:AnimatorPlayState, elapsedTime:Number, islooping:Boolean):void {
			var clipDuration:Number = animatorState._clip._duration * (animatorState.clipEnd - animatorState.clipStart);
			var lastElapsedTime:Number = playState._elapsedTime;
			var elapsedPlaybackTime:Number = lastElapsedTime + elapsedTime;
			playState._lastElapsedTime = lastElapsedTime;
			playState._elapsedTime = elapsedPlaybackTime;
			var normalizedTime:Number = elapsedPlaybackTime / clipDuration;//TODO:时候可以都统一为归一化时间
			playState._normalizedTime = normalizedTime;
			var playTime:Number = normalizedTime % 1.0;
			playState._normalizedPlayTime =playTime < 0?playTime+1.0:playTime;
			playState._duration = clipDuration;
			var scripts:Vector.<AnimatorStateScript> = animatorState._scripts;
			
			if ((!islooping && elapsedPlaybackTime >= clipDuration)) {
				playState._finish = true;
				playState._elapsedTime = clipDuration;
				playState._normalizedPlayTime = 1.0;
				
				if (scripts) {
					for (var i:int = 0, n:int = scripts.length; i < n; i++)
						scripts[i].onStateExit();
				}
				return;
			}
			
			if (clipDuration > 0) {
				if (elapsedPlaybackTime >= clipDuration) {
					do {
						elapsedPlaybackTime -= clipDuration;//TODO:大于1次循环后会一直掉
						playState._playEventIndex = 0;
					} while (elapsedPlaybackTime >= clipDuration)
				}
			} else {
				playState._resetPlayState(0.0);
			}
			
			if (scripts) {
				for (i = 0, n = scripts.length; i < n; i++)
					scripts[i].onStateUpdate();
			}
		}
		
		/**
		 * @private
		 */
		private function _updateEventScript(stateInfo:AnimatorState, playStateInfo:AnimatorPlayState, islooping:Boolean):void {
			var scripts:Vector.<Script3D> = (owner as Sprite3D)._scripts;
			if (scripts) {//TODO:play是否也换成此种计算
				var clipDuration:Number = stateInfo._clip._duration;
				var lastElapsedTime:Number = playStateInfo._lastElapsedTime;
				var elapsedTime:Number = playStateInfo._elapsedTime;
				var lastLoop:Number = Math.floor(lastElapsedTime / clipDuration);
				var loop:Number = Math.floor(elapsedTime / clipDuration);
				var lastTime:Number = lastElapsedTime % clipDuration;
				var time:Number = elapsedTime % clipDuration;
				var loopCount:int = loop - lastLoop;
				if (islooping) {
					if (loopCount > 0) {
						_eventScript(scripts, stateInfo, playStateInfo, lastTime, clipDuration);
						for (var i:int = 0, n:int = loopCount - 1; i < n; i++)
							_eventScript(scripts, stateInfo, playStateInfo, 0, clipDuration);
						_eventScript(scripts, stateInfo, playStateInfo, 0, time);
					} else {
						_eventScript(scripts, stateInfo, playStateInfo, lastTime, time);
					}
				} else {
					if (loopCount > 0)
						_eventScript(scripts, stateInfo, playStateInfo, lastTime, clipDuration);
					else
						_eventScript(scripts, stateInfo, playStateInfo, lastTime, time);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _updateClipDatas(animatorState:AnimatorState, addtive:Boolean, playStateInfo:AnimatorPlayState, scale:Number):void {
			var clip:AnimationClip = animatorState._clip;
			var clipDuration:Number = clip._duration;
			
			var curPlayTime:Number = animatorState.clipStart * clipDuration + playStateInfo._normalizedPlayTime * playStateInfo._duration;
			var currentFrameIndices:Int16Array = animatorState._currentFrameIndices;
			var frontPlay:Boolean = playStateInfo._elapsedTime > playStateInfo._lastElapsedTime;
			clip._evaluateClipDatasRealTime(clip._nodes, curPlayTime, currentFrameIndices, addtive,frontPlay);
		}
		
		/**
		 * @private
		 */
		private function _applyFloat(pro:*, proName:String, nodeOwner:KeyframeNodeOwner, additive:Boolean, weight:Number, isFirstLayer:Boolean, data:Number):void {
			if (nodeOwner.updateMark === _updateMark) {//一定非第一层
				if (additive) {
					pro[proName] += weight * (data);
				} else {
					var oriValue:Number = pro[proName];
					pro[proName] = oriValue + weight * (data - oriValue);
				}
			} else {
				if (isFirstLayer) {
					if (additive)
						pro[proName] = nodeOwner.defaultValue + data;
					else
						pro[proName] = data;
				} else {
					if (additive) {
						pro[proName] = nodeOwner.defaultValue + weight * (data);
					} else {
						var defValue:Number = nodeOwner.defaultValue;
						pro[proName] = defValue + weight * (data - defValue);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _applyPositionAndRotationEuler(nodeOwner:KeyframeNodeOwner, additive:Boolean, weight:Number, isFirstLayer:Boolean, data:Float32Array, out:Float32Array):void {
			if (nodeOwner.updateMark === _updateMark) {//一定非第一层
				if (additive) {
					out[0] += weight * data[0];
					out[1] += weight * data[1];
					out[2] += weight * data[2];
				} else {
					var oriX:Number = out[0];
					var oriY:Number = out[1];
					var oriZ:Number = out[2];
					out[0] = oriX + weight * (data[0] - oriX);
					out[1] = oriY + weight * (data[1] - oriY);
					out[2] = oriZ + weight * (data[2] - oriZ);
				}
			} else {
				if (isFirstLayer) {
					if (additive) {
						var defValue:Float32Array = nodeOwner.defaultValue;
						out[0] = defValue[0] + data[0];
						out[1] = defValue[1] + data[1];
						out[2] = defValue[2] + data[2];
					} else {
						out[0] = data[0];
						out[1] = data[1];
						out[2] = data[2];
					}
				} else {
					defValue = nodeOwner.defaultValue;
					if (additive) {
						out[0] = defValue[0] + weight * data[0];
						out[1] = defValue[1] + weight * data[1];
						out[2] = defValue[2] + weight * data[2];
					} else {
						var defX:Number = defValue[0];
						var defY:Number = defValue[1];
						var defZ:Number = defValue[2];
						out[0] = defX + weight * (data[0] - defX);
						out[1] = defY + weight * (data[1] - defY);
						out[2] = defZ + weight * (data[2] - defZ);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _applyRotation(nodeOwner:KeyframeNodeOwner, additive:Boolean, weight:Number, isFirstLayer:Boolean, clipRot:Float32Array, localRotationE:Float32Array):void {
			if (nodeOwner.updateMark === _updateMark) {//一定非第一层
				if (additive) {
					var tempQuat:Float32Array = _tempQuaternionArray1;
					Utils3D.quaternionWeight(clipRot, weight, tempQuat);
					Utils3D.quaterionNormalize(tempQuat, tempQuat);
					Utils3D.quaternionMultiply(localRotationE, tempQuat, localRotationE);
				} else {
					Quaternion._lerpArray(localRotationE, clipRot, weight, localRotationE);
				}
			} else {
				if (isFirstLayer) {
					if (additive) {
						var defaultRot:Float32Array = nodeOwner.defaultValue;
						Utils3D.quaternionMultiply(defaultRot, clipRot, localRotationE);
					} else {
						localRotationE[0] = clipRot[0];
						localRotationE[1] = clipRot[1];
						localRotationE[2] = clipRot[2];
						localRotationE[3] = clipRot[3];
					}
				} else {
					defaultRot = nodeOwner.defaultValue;
					if (additive) {
						tempQuat = _tempQuaternionArray1;
						Utils3D.quaternionWeight(clipRot, weight, tempQuat);
						Utils3D.quaterionNormalize(tempQuat, tempQuat);
						Utils3D.quaternionMultiply(defaultRot, tempQuat, localRotationE);
					} else {
						Quaternion._lerpArray(defaultRot, clipRot, weight, localRotationE);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _applyScale(nodeOwner:KeyframeNodeOwner, additive:Boolean, weight:Number, isFirstLayer:Boolean, clipSca:Float32Array, localScaleE:Float32Array):void {
			if (nodeOwner.updateMark === _updateMark) {//一定非第一层
				if (additive) {
					var scale:Float32Array = _tempVector3Array1;
					Utils3D.scaleWeight(clipSca, weight, scale);
					localScaleE[0] = localScaleE[0] * scale[0];
					localScaleE[1] = localScaleE[1] * scale[1];
					localScaleE[2] = localScaleE[2] * scale[2];
				} else {
					Utils3D.scaleBlend(localScaleE, clipSca, weight, localScaleE);
				}
			} else {
				if (isFirstLayer) {
					if (additive) {
						var defaultSca:Float32Array = nodeOwner.defaultValue;
						localScaleE[0] = defaultSca[0] * clipSca[0];
						localScaleE[1] = defaultSca[1] * clipSca[1];
						localScaleE[2] = defaultSca[2] * clipSca[2];
					} else {
						localScaleE[0] = clipSca[0];
						localScaleE[1] = clipSca[1];
						localScaleE[2] = clipSca[2];
					}
				} else {
					defaultSca = nodeOwner.defaultValue;
					if (additive) {
						scale = _tempVector3Array1;
						Utils3D.scaleWeight(clipSca, weight, scale);
						localScaleE[0] = defaultSca[0] * scale[0];
						localScaleE[1] = defaultSca[1] * scale[1];
						localScaleE[2] = defaultSca[2] * scale[2];
					} else {
						Utils3D.scaleBlend(defaultSca, clipSca, weight, localScaleE);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _applyCrossData(nodeOwner:KeyframeNodeOwner, additive:Boolean, weight:Number, isFirstLayer:Boolean, srcValue:*, desValue:*, crossWeight:Number):void {
			var pro:* = nodeOwner.propertyOwner;
			if (pro) {
				switch (nodeOwner.type) {
				case 0: //Float
					var proPat:Vector.<String> = nodeOwner.property;
					var m:int = proPat.length - 1;
					for (var j:int = 0; j < m; j++) {
						pro = pro[proPat[j]];
						if (!pro)//属性可能或被置空
							break;
					}
					
					var crossValue:Number = srcValue + crossWeight * (desValue - srcValue);
					_applyFloat(pro, proPat[m], nodeOwner, additive, weight, isFirstLayer, crossValue);
					break;
				case 1: //Position
					var localPos:Vector3 = pro.localPosition;
					var position:Float32Array = _tempVector3Array0;
					var srcX:Number = srcValue[0], srcY:Number = srcValue[1], srcZ:Number = srcValue[2];
					position[0] = srcX + crossWeight * (desValue[0] - srcX);
					position[1] = srcY + crossWeight * (desValue[1] - srcY);
					position[2] = srcZ + crossWeight * (desValue[2] - srcZ);
					_applyPositionAndRotationEuler(nodeOwner, additive, weight, isFirstLayer, position, localPos.elements);
					pro.localPosition = localPos;
					break;
				case 2: //Rotation
					var localRot:Quaternion = pro.localRotation;
					var rotation:Float32Array = _tempQuaternionArray0;
					Quaternion._lerpArray(srcValue, desValue, crossWeight, rotation);
					_applyRotation(nodeOwner, additive, weight, isFirstLayer, rotation, localRot.elements);
					pro.localRotation = localRot;
					break;
				case 3: //Scale
					var localSca:Vector3 = pro.localScale;
					var scale:Float32Array = _tempVector3Array0;
					Utils3D.scaleBlend(srcValue, desValue, crossWeight, scale);
					_applyScale(nodeOwner, additive, weight, isFirstLayer, scale, localSca.elements);
					pro.localScale = localSca;
					break;
				case 4: //RotationEuler
					var localEuler:Vector3 = pro.localRotationEuler;
					var rotationEuler:Float32Array = _tempVector3Array0;
					srcX = srcValue[0], srcY = srcValue[1], srcZ = srcValue[2];
					rotationEuler[0] = srcX + crossWeight * (desValue[0] - srcX);
					rotationEuler[1] = srcY + crossWeight * (desValue[1] - srcY);
					rotationEuler[2] = srcZ + crossWeight * (desValue[2] - srcZ);
					_applyPositionAndRotationEuler(nodeOwner, additive, weight, isFirstLayer, rotationEuler, localEuler.elements);
					pro.localRotationEuler = localEuler;
					break;
				}
				nodeOwner.updateMark = _updateMark;
			}
		}
		
		/**
		 * @private
		 */
		private function _setClipDatasToNode(stateInfo:AnimatorState, additive:Boolean, weight:Number, isFirstLayer:Boolean):void {
			var nodes:KeyframeNodeList = stateInfo._clip._nodes;
			var nodeOwners:Vector.<KeyframeNodeOwner> = stateInfo._nodeOwners;
			for (var i:int = 0, n:int = nodes.count; i < n; i++) {
				var nodeOwner:KeyframeNodeOwner = nodeOwners[i];
				if (nodeOwner) {//骨骼中没有该节点
					var pro:* = nodeOwner.propertyOwner;
					if (pro) {
						switch (nodeOwner.type) {
						case 0: //Float
							var proPat:Vector.<String> = nodeOwner.property;
							var m:int = proPat.length - 1;
							for (var j:int = 0; j < m; j++) {
								pro = pro[proPat[j]];
								if (!pro)//属性可能或被置空
									break;
							}
							_applyFloat(pro, proPat[m], nodeOwner, additive, weight, isFirstLayer, nodes.getNodeByIndex(i).data);
							break;
						case 1: //Position
							var localPos:Vector3 = pro.localPosition;
							_applyPositionAndRotationEuler(nodeOwner, additive, weight, isFirstLayer, nodes.getNodeByIndex(i).data, localPos.elements);
							pro.localPosition = localPos;
							break;
						case 2: //Rotation
							var localRot:Quaternion = pro.localRotation;
							_applyRotation(nodeOwner, additive, weight, isFirstLayer, nodes.getNodeByIndex(i).data, localRot.elements);
							pro.localRotation = localRot;
							break;
						case 3: //Scale
							var localSca:Vector3 = pro.localScale;
							_applyScale(nodeOwner, additive, weight, isFirstLayer, nodes.getNodeByIndex(i).data, localSca.elements);
							pro.localScale = localSca;
							break;
						case 4: //RotationEuler
							var localEuler:Vector3 = pro.localRotationEuler;
							_applyPositionAndRotationEuler(nodeOwner, additive, weight, isFirstLayer, nodes.getNodeByIndex(i).data, localEuler.elements);
							pro.localRotationEuler = localEuler;
							break;
						}
						nodeOwner.updateMark = _updateMark;
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _setCrossClipDatasToNode(controllerLayer:AnimatorControllerLayer, srcState:AnimatorState, destState:AnimatorState, crossWeight:Number, isFirstLayer:Boolean):void {
			//TODO:srcNodes、destNodes未使用
			var nodeOwners:Vector.<KeyframeNodeOwner> = controllerLayer._crossNodesOwners;
			var ownerCount:int = controllerLayer._crossNodesOwnersCount;
			var additive:Boolean = controllerLayer.blendingMode !== AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
			var weight:Number = controllerLayer.defaultWeight;
			
			var destDataIndices:Vector.<int> = controllerLayer._destCrossClipNodeIndices;
			var destNodes:KeyframeNodeList = destState._clip._nodes;
			var destNodeOwners:Vector.<KeyframeNodeOwner> = destState._nodeOwners;
			var srcDataIndices:Vector.<int> = controllerLayer._srcCrossClipNodeIndices;
			var srcNodeOwners:Vector.<KeyframeNodeOwner> = srcState._nodeOwners;
			var srcNodes:KeyframeNodeList = srcState._clip._nodes;
			
			for (var i:int = 0; i < ownerCount; i++) {
				var nodeOwner:KeyframeNodeOwner = nodeOwners[i];
				if (nodeOwner) {
					var srcIndex:int = srcDataIndices[i];
					var destIndex:int = destDataIndices[i];
					var srcValue:* = srcIndex !== -1 ? srcNodes.getNodeByIndex(srcIndex).data : destNodeOwners[destIndex].defaultValue;
					var desValue:* = destIndex !== -1 ? destNodes.getNodeByIndex(destIndex).data : srcNodeOwners[srcIndex].defaultValue;
					_applyCrossData(nodeOwner, additive, weight, isFirstLayer, srcValue, desValue, crossWeight);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _setFixedCrossClipDatasToNode(controllerLayer:AnimatorControllerLayer, destState:AnimatorState, crossWeight:Number, isFirstLayer:Boolean):void {
			var nodeOwners:Vector.<KeyframeNodeOwner> = controllerLayer._crossNodesOwners;
			var ownerCount:int = controllerLayer._crossNodesOwnersCount;
			var additive:Boolean = controllerLayer.blendingMode !== AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
			var weight:Number = controllerLayer.defaultWeight;
			var destDataIndices:Vector.<int> = controllerLayer._destCrossClipNodeIndices;
			var destNodes:KeyframeNodeList = destState._clip._nodes;
			
			for (var i:int = 0; i < ownerCount; i++) {
				var nodeOwner:KeyframeNodeOwner = nodeOwners[i];
				if (nodeOwner) {
					var destIndex:int = destDataIndices[i];
					var srcValue:* = nodeOwner.crossFixedValue;
					var desValue:* = destIndex !== -1 ? destNodes.getNodeByIndex(destIndex).data : nodeOwner.defaultValue;
					_applyCrossData(nodeOwner, additive, weight, isFirstLayer, srcValue, desValue, crossWeight);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _revertDefaultKeyframeNodes(clipStateInfo:AnimatorState):void {
			var nodeOwners:Vector.<KeyframeNodeOwner> = clipStateInfo._nodeOwners;
			for (var i:int = 0, n:int = nodeOwners.length; i < n; i++) {
				var nodeOwner:KeyframeNodeOwner = nodeOwners[i];
				if (nodeOwner) {
					var pro:* = nodeOwner.propertyOwner;
					if (pro) {
						switch (nodeOwner.type) {
						case 0: 
							var proPat:Vector.<String> = nodeOwner.property;
							var m:int = proPat.length - 1;
							for (var j:int = 0; j < m; j++) {
								pro = pro[proPat[j]];
								if (!pro)//属性可能或被置空
									break;
							}
							pro[proPat[m]] = nodeOwner.defaultValue;
							break;
						case 1: 
							var locPos:Vector3 = pro.localPosition;
							var locPosE:Float32Array = locPos.elements;
							var def:Float32Array = nodeOwner.defaultValue;
							locPosE[0] = def[0];
							locPosE[1] = def[1];
							locPosE[2] = def[2];
							pro.localPosition = locPos;
							break;
						case 2: 
							var locRot:Quaternion = pro.localRotation;
							var locRotE:Float32Array = locRot.elements;
							def = nodeOwner.defaultValue;
							locRotE[0] = def[0];
							locRotE[1] = def[1];
							locRotE[2] = def[2];
							locRotE[3] = def[3];
							pro.localRotation = locRot;
							break;
						case 3: 
							var locSca:Vector3 = pro.localScale;
							var locScaE:Float32Array = locSca.elements;
							def = nodeOwner.defaultValue;
							locScaE[0] = def[0];
							locScaE[1] = def[1];
							locScaE[2] = def[2];
							pro.localScale = locSca;
							break;
						case 4: 
							var locEul:Vector3 = pro.localRotationEuler;
							var locEulE:Float32Array = locEul.elements;
							def = nodeOwner.defaultValue;
							locEulE[0] = def[0];
							locEulE[1] = def[1];
							locEulE[2] = def[2];
							pro.localRotationEuler = locEul;
							break;
						default: 
							throw "Animator:unknown type.";
						}
						
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _removeClip(clipStateInfos:Vector.<AnimatorState>, statesMap:Object, index:int, state:AnimatorState):void {
			var clip:AnimationClip = state._clip;
			clip._removeReference();
			
			clipStateInfos.splice(index, 1);
			delete statesMap[state.name];
			
			var clipStateInfo:AnimatorState = clipStateInfos[index];
			var frameNodes:KeyframeNodeList = clip._nodes;
			var nodeOwners:Vector.<KeyframeNodeOwner> = clipStateInfo._nodeOwners;
			
			for (var i:int = 0, n:int = frameNodes.count; i < n; i++)
				_removeKeyframeNodeOwner(nodeOwners, frameNodes.getNodeByIndex(i));
		}
		
		/**
		 * @private
		 */
		private function _isLinkSpriteToAnimationNodeData(sprite:Sprite3D, nodeName:String, isLink:Boolean):void {
			var linkSprites:Array = _linkAvatarSpritesData[nodeName];//存储挂点数据
			if (isLink) {
				linkSprites || (_linkAvatarSpritesData[nodeName] = linkSprites = []);
				linkSprites.push(sprite);
			} else {
				linkSprites.splice(sprite, 1);
			}
		}
		
		/**
		 * @private
		 */
		private function _isLinkSpriteToAnimationNode(sprite:Sprite3D, nodeName:String, isLink:Boolean):void {
			if (_avatar) {
				var node:AnimationNode = _avatarNodeMap[nodeName];
				if (node) {
					if (isLink) {
						sprite._transform._dummy = node.transform;
						_linkAvatarSprites.push(sprite);
						
						var nodeTransform:AnimationTransform3D = node.transform;//nodeTransform为空时表示avatar中暂时无此节点
						var spriteTransform:Transform3D = sprite.transform;
						if (!spriteTransform.owner.isStatic && nodeTransform) {//Avatar跟节点始终为false,不会更新,Scene无transform
							//TODO:spriteTransform.owner.isStatic外部判断
							var spriteWorldMatrix:Matrix4x4 = spriteTransform.worldMatrix;
							var ownParTra:Transform3D = (owner as Sprite3D)._transform._parent;
							if (ownParTra) {
								Utils3D.matrix4x4MultiplyMFM(ownParTra.worldMatrix, nodeTransform.getWorldMatrix(), spriteWorldMatrix);//TODO:还可优化
							} else {
								var sprWorE:Float32Array = spriteWorldMatrix.elements;
								var nodWorE:Float32Array = nodeTransform.getWorldMatrix();
								for (var i:int = 0; i < 16; i++)
									sprWorE[i] = nodWorE[i];
							}
							spriteTransform.worldMatrix = spriteWorldMatrix;
						}
					} else {
						sprite._transform._dummy = null;
						_linkAvatarSprites.splice(_linkAvatarSprites.indexOf(sprite), 1);
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			var parent:Node = owner._parent;
			(owner as Sprite3D)._setHierarchyAnimator(this, parent ? (parent as Sprite3D)._hierarchyAnimator : null);//只有动画组件在加载或卸载时才重新组织数据
			(owner as Sprite3D)._changeAnimatorToLinkSprite3DNoAvatar(this, true, new <String>[]);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			var parent:Node = owner._parent;
			(owner as Sprite3D)._clearHierarchyAnimator(this, parent ? (parent as Sprite3D)._hierarchyAnimator : null);//只有动画组件在加载或卸载时才重新组织数据
			(owner as Sprite3D)._changeAnimatorToLinkSprite3DNoAvatar(this, false, new <String>[]);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onEnableInScene():void {
			(owner._scene as Scene3D)._animatorPool.add(this);
		
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDisableInScene():void {
			(owner._scene as Scene3D)._animatorPool.remove(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onEnable():void {
			for (var i:int = 0, n:int = _controllerLayers.length; i < n; i++) {
				if (_controllerLayers[i].playOnWake) {
					var defaultClip:AnimatorState = getDefaultState(i);
					(defaultClip) && (play(null, i, 0));
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _handleSpriteOwnersBySprite(isLink:Boolean, path:Vector.<String>, sprite:Sprite3D):void {
			for (var i:int = 0, n:int = _controllerLayers.length; i < n; i++) {
				var clipStateInfos:Vector.<AnimatorState> = _controllerLayers[i]._states;
				for (var j:int = 0, m:int = clipStateInfos.length; j < m; j++) {
					var clipStateInfo:AnimatorState = clipStateInfos[j];
					var clip:AnimationClip = clipStateInfo._clip;
					var nodePath:String = path.join("/");
					var ownersNodes:Vector.<KeyframeNode> = clip._nodesMap[nodePath];
					if (ownersNodes) {
						var nodeOwners:Vector.<KeyframeNodeOwner> = clipStateInfo._nodeOwners;
						for (var k:int = 0, p:int = ownersNodes.length; k < p; k++) {
							if (isLink)
								_addKeyframeNodeOwner(nodeOwners, ownersNodes[k], sprite);
							else
								_removeKeyframeNodeOwner(nodeOwners, ownersNodes[k]);
						}
					}
				}
			}
		}
		
		/**
		 *@private
		 */
		public function _updateAvatarNodesToSprite():void {
			for (var i:int = 0, n:int = _linkAvatarSprites.length; i < n; i++) {
				var sprite:Sprite3D = _linkAvatarSprites[i];
				var nodeTransform:AnimationTransform3D = sprite.transform._dummy;//nodeTransform为空时表示avatar中暂时无此节点
				var spriteTransform:Transform3D = sprite.transform;
				if (!spriteTransform.owner.isStatic && nodeTransform) {
					var spriteWorldMatrix:Matrix4x4 = spriteTransform.worldMatrix;
					var ownParTra:Transform3D = (owner as Sprite3D)._transform._parent;
					if (ownParTra) {
						Utils3D.matrix4x4MultiplyMFM(ownParTra.worldMatrix, nodeTransform.getWorldMatrix(), spriteWorldMatrix);
					} else {
						var sprWorE:Float32Array = spriteWorldMatrix.elements;
						var nodWorE:Float32Array = nodeTransform.getWorldMatrix();
						for (var j:int = 0; j < 16; j++)
							sprWorE[j] = nodWorE[j];
					}
					spriteTransform.worldMatrix = spriteWorldMatrix;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			var avatarData:Object = data.avatar;
			if (avatarData) {
				avatar = Loader.getRes(avatarData.path);
				var linkSprites:Object = avatarData.linkSprites;
				_linkSprites = linkSprites;
				_linkToSprites(linkSprites);
			}
			
			var clipPaths:Vector.<String> = data.clipPaths;
			var play:* = data.playOnWake;
			var layersData:Array = data.layers;
			for (var i:int = 0; i < layersData.length; i++) {
				var layerData:Object = layersData[i];
				var animatorLayer:AnimatorControllerLayer = new AnimatorControllerLayer(layerData.name);
				if (i === 0)
					animatorLayer.defaultWeight = 1.0;//TODO:
				else
					animatorLayer.defaultWeight = layerData.weight;
				
				var blendingModeData:* = layerData.blendingMode;
				(blendingModeData) && (animatorLayer.blendingMode = blendingModeData);
				addControllerLayer(animatorLayer);
				var states:Array = layerData.states;
				for (var j:int = 0, m:int = states.length; j < m; j++) {
					var state:Object = states[j];
					var clipPath:String = state.clipPath;
					if (clipPath) {
						var name:String = state.name;
						var motion:AnimationClip;
						motion = Loader.getRes(clipPath);
						if (motion) {//加载失败motion为空
							var animatorState:AnimatorState = new AnimatorState();
							animatorState.name = name;
							animatorState.clip = motion;
							motion._addReference();
							addState(animatorState, i);
							(j === 0) && (setDefaultClip(name, i));
						}
					}
				}
				(play !== undefined) && (animatorLayer.playOnWake = play);
				
			}
			var cullingModeData:* = data.cullingMode;
			(cullingModeData !== undefined) && (cullingMode = cullingModeData);
		}
		
		/**
		 * @private
		 */
		public function _update():void {
			if (_speed === 0)
				return;
			var needRender:Boolean;
			if (cullingMode === CULLINGMODE_CULLCOMPLETELY) {//所有渲染精灵不可见时
				needRender = false;
				for (var i:int = 0, n:int = _renderableSprites.length; i < n; i++) {
					if (_renderableSprites[i]._render._visible) {
						needRender = true;
						break;
					}
				}
			} else {
				needRender = true;
			}
			_updateMark++;
			var timer:Timer = (owner._scene as Scene3D).timer;
			var delta:Number = timer._delta / 1000.0;//Laya.timer.delta已结包含Laya.timer.scale
			var timerScale:Number = timer.scale;
			for (i = 0, n = _controllerLayers.length; i < n; i++) {
				var controllerLayer:AnimatorControllerLayer = _controllerLayers[i];
				var playStateInfo:AnimatorPlayState = controllerLayer._playStateInfo;
				var crossPlayStateInfo:AnimatorPlayState = controllerLayer._crossPlayStateInfo;
				addtive = controllerLayer.blendingMode !== AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
				switch (controllerLayer._playType) {
				case 0: 
					var animatorState:AnimatorState = controllerLayer._currentPlayState;
					var clip:AnimationClip = animatorState._clip;
					var speed:Number = _speed * animatorState.speed;
					var finish:Boolean = playStateInfo._finish;//提前取出finish,防止最后一帧跳过
					finish || _updatePlayer(animatorState, playStateInfo, delta * speed, clip.islooping);
					if (needRender) {
						var addtive:Boolean = controllerLayer.blendingMode !== AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
						_updateClipDatas(animatorState, addtive, playStateInfo, timerScale * speed);//clipDatas为逐动画文件,防止两个使用同一动画文件的Animator数据错乱,即使动画停止也要updateClipDatas
						_setClipDatasToNode(animatorState, addtive, controllerLayer.defaultWeight, i === 0);//多层动画混合时即使动画停止也要设置数据
						finish || _updateEventScript(animatorState, playStateInfo, clip.islooping);
					}
					break;
				case 1: 
					animatorState = controllerLayer._currentPlayState;
					clip = animatorState._clip;
					var crossClipState:AnimatorState = controllerLayer._crossPlayState;
					var crossClip:AnimationClip = crossClipState._clip;
					var crossDuratuion:Number = controllerLayer._crossDuration;
					var startPlayTime:Number = crossPlayStateInfo._startPlayTime;
					var crossClipDuration:Number = crossClip._duration - startPlayTime;
					var crossScale:Number = crossDuratuion > crossClipDuration ? crossClipDuration / crossDuratuion : 1.0;//如果过度时间大于过度动作时间,则减慢速度
					var crossSpeed:Number = _speed * crossClipState.speed;
					_updatePlayer(crossClipState, crossPlayStateInfo, delta * crossScale * crossSpeed, crossClip.islooping);
					var crossWeight:Number = ((crossPlayStateInfo._elapsedTime - startPlayTime) / crossScale) / crossDuratuion;
					if (crossWeight >= 1.0) {
						if (needRender) {
							_updateClipDatas(crossClipState, addtive, crossPlayStateInfo, timerScale * crossSpeed);
							_setClipDatasToNode(crossClipState, addtive, controllerLayer.defaultWeight, i === 0);
							
							controllerLayer._playType = 0;//完成融合,切换到正常播放状态
							controllerLayer._currentPlayState = crossClipState;
							crossPlayStateInfo._cloneTo(playStateInfo);
						}
					} else {
						if (!playStateInfo._finish) {
							speed = _speed * animatorState.speed;
							_updatePlayer(animatorState, playStateInfo, delta * speed, clip.islooping);
							if (needRender) {
								_updateClipDatas(animatorState, addtive, playStateInfo, timerScale * speed);
							}
						}
						if (needRender) {
							_updateClipDatas(crossClipState, addtive, crossPlayStateInfo, timerScale * crossScale * crossSpeed);
							_setCrossClipDatasToNode(controllerLayer, animatorState, crossClipState, crossWeight, i === 0);
						}
					}
					if (needRender) {
						_updateEventScript(animatorState, playStateInfo, false);
						_updateEventScript(crossClipState, crossPlayStateInfo, crossClip.islooping);
					}
					break;
				case 2: 
					crossClipState = controllerLayer._crossPlayState;
					crossClip = crossClipState._clip;
					crossDuratuion = controllerLayer._crossDuration;
					startPlayTime = crossPlayStateInfo._startPlayTime;
					crossClipDuration = crossClip._duration - startPlayTime;
					crossScale = crossDuratuion > crossClipDuration ? crossClipDuration / crossDuratuion : 1.0;//如果过度时间大于过度动作时间,则减慢速度
					crossSpeed = _speed * crossClipState.speed;
					_updatePlayer(crossClipState, crossPlayStateInfo, delta * crossScale * crossSpeed, crossClip.islooping);
					if (needRender) {
						crossWeight = ((crossPlayStateInfo._elapsedTime - startPlayTime) / crossScale) / crossDuratuion;
						if (crossWeight >= 1.0) {
							_updateClipDatas(crossClipState, addtive, crossPlayStateInfo, timerScale * crossSpeed);
							_setClipDatasToNode(crossClipState, addtive, 1.0, i === 0);
							controllerLayer._playType = 0;//完成融合,切换到正常播放状态
							controllerLayer._currentPlayState = crossClipState;
							crossPlayStateInfo._cloneTo(playStateInfo);
						} else {
							_updateClipDatas(crossClipState, addtive, crossPlayStateInfo, timerScale * crossScale * crossSpeed);
							_setFixedCrossClipDatasToNode(controllerLayer, crossClipState, crossWeight, i === 0);
						}
						_updateEventScript(crossClipState, crossPlayStateInfo, crossClip.islooping);
					}
					break;
				}
			}
			
			if (needRender) {
				if (_avatar) {
					Render.isConchApp && _updateAnimationNodeWorldMatix(_animationNodeLocalPositions, _animationNodeLocalRotations, _animationNodeLocalScales, _animationNodeWorldMatrixs, _animationNodeParentIndices);//[NATIVE]
					_updateAvatarNodesToSprite();
				}
			}
		}
		
		/**
		 * @private
		 */
		override public function _cloneTo(dest:Component):void {
			var animator:Animator = dest as Animator;
			animator.avatar = avatar;
			
			for (var i:int = 0, n:int = _controllerLayers.length; i < n; i++) {
				var controllLayer:AnimatorControllerLayer = _controllerLayers[i];
				animator.addControllerLayer(controllLayer.clone());
				var animatorStates:Vector.<AnimatorState> = controllLayer._states;
				for (var j:int = 0, m:int = animatorStates.length; j < m; j++) {
					var state:AnimatorState = animatorStates[j];
					animator.addState(state.clone(), i);
					(j == 0) && (animator.setDefaultClip(state.name, i));//TODO:
				}
			}
			animator._linkSprites = _linkSprites;//TODO:需要统一概念
			animator._linkToSprites(_linkSprites);
		}
		
		/**
		 * 获取默认动画状态。
		 * @param	layerIndex 层索引。
		 * @return 默认动画状态。
		 */
		public function getDefaultState(layerIndex:int = 0):AnimatorState {
			var controllerLayer:AnimatorControllerLayer = _controllerLayers[layerIndex];
			return controllerLayer._defaultState;
		}
		
		/**
		 * 设置默认动画片段。
		 * @param playName 默认动画片段名称。
		 */
		public function setDefaultClip(playName:String, layerIndex:int = 0):void {
			var controllerLayer:AnimatorControllerLayer = _controllerLayers[layerIndex];
			controllerLayer._defaultState = controllerLayer._statesMap[playName];
		}
		
		/**
		 * 添加动画状态。
		 * @param	state 动画状态。
		 * @param   layerIndex 层索引。
		 */
		public function addState(state:AnimatorState, layerIndex:int = 0):void {
			var stateName:String = state.name;
			var controllerLayer:AnimatorControllerLayer = _controllerLayers[layerIndex];
			var statesMap:Object = controllerLayer._statesMap;
			var states:Vector.<AnimatorState> = controllerLayer._states;
			if (statesMap[stateName]) {
				throw "Animator:this stat's name has exist.";
			} else {
				statesMap[stateName] = state;
				states.push(state);
				state._clip._addReference();
				
				if (_avatar) {
					_getOwnersByClipAsync(state);
				} else {
					_getOwnersByClipAsync(state);
				}
			}
		}
		
		/**
		 * 移除动画状态。
		 * @param	state 动画状态。
		 * @param   layerIndex 层索引。
		 */
		public function removeState(state:AnimatorState, layerIndex:int = 0):void {
			var controllerLayer:AnimatorControllerLayer = _controllerLayers[layerIndex];
			var clipStateInfos:Vector.<AnimatorState> = controllerLayer._states;
			var statesMap:Object = controllerLayer._statesMap;
			
			var index:int = -1;
			for (var i:int = 0, n:int = clipStateInfos.length; i < n; i++) {//TODO:是不是没移除
				if (clipStateInfos[i] === state) {
					index = i;
					break;
				}
			}
			if (index !== -1)
				_removeClip(clipStateInfos, statesMap, index, state);
		}
		
		/**
		 * 添加控制器层。
		 */
		public function addControllerLayer(controllderLayer:AnimatorControllerLayer):void {
			_controllerLayers.push(controllderLayer);
		}
		
		/**
		 * 获取控制器层。
		 */
		public function getControllerLayer(layerInex:int = 0):AnimatorControllerLayer {
			return _controllerLayers[layerInex];
		}
		
		/**
		 * 获取当前的播放状态。
		 *	@param   layerIndex 层索引。
		 * 	@return  动画播放状态。
		 */
		public function getCurrentAnimatorPlayState(layerInex:int = 0):AnimatorPlayState {
			return _controllerLayers[layerInex]._playStateInfo;
		}
		
		/**
		 * 播放动画。
		 * @param	name 如果为null则播放默认动画，否则按名字播放动画片段。
		 * @param	layerIndex 层索引。
		 * @param	normalizedTime 归一化的播放起始时间。
		 */
		public function play(name:String = null, layerIndex:int = 0, normalizedTime:Number = Number.NEGATIVE_INFINITY):void {
			var controllerLayer:AnimatorControllerLayer = _controllerLayers[layerIndex];
			var defaultState:AnimatorState = controllerLayer._defaultState;
			if (!name && !defaultState)
				throw new Error("Animator:must have  default clip value,please set clip property.");
			var curPlayState:AnimatorState = controllerLayer._currentPlayState;
			var playStateInfo:AnimatorPlayState = controllerLayer._playStateInfo;
			
			var animatorState:AnimatorState = name ? controllerLayer._statesMap[name] : defaultState;
			var clipDuration:Number = animatorState._clip._duration;
			if (curPlayState !== animatorState) {
				if (normalizedTime !== Number.NEGATIVE_INFINITY)
					playStateInfo._resetPlayState(clipDuration * normalizedTime);
				else
					playStateInfo._resetPlayState(0.0);
				(curPlayState !== null && curPlayState !== animatorState) && (_revertDefaultKeyframeNodes(curPlayState));
				controllerLayer._playType = 0;
				controllerLayer._currentPlayState = animatorState;
			} else {
				if (normalizedTime !== Number.NEGATIVE_INFINITY) {
					playStateInfo._resetPlayState(clipDuration * normalizedTime);
					controllerLayer._playType = 0;
				}
			}
			
			var scripts:Vector.<AnimatorStateScript> = animatorState._scripts;
			if (scripts) {
				for (var i:int = 0, n:int = scripts.length; i < n; i++)
					scripts[i].onStateEnter();
			}
		}
		
		/**
		 * 在当前动画状态和目标动画状态之间进行融合过渡播放。
		 * @param	name 目标动画状态。
		 * @param	transitionDuration 过渡时间,该值为当前动画状态的归一化时间，值在0.0~1.0之间。
		 * @param	layerIndex 层索引。
		 * @param	normalizedTime 归一化的播放起始时间。
		 */
		public function crossFade(name:String, transitionDuration:Number, layerIndex:int = 0, normalizedTime:Number = Number.NEGATIVE_INFINITY):void {
			var controllerLayer:AnimatorControllerLayer = _controllerLayers[layerIndex];
			var destAnimatorState:AnimatorState = controllerLayer._statesMap[name];
			if (destAnimatorState) {
				var playType:int = controllerLayer._playType;
				if (playType === -1) {
					play(name, layerIndex, normalizedTime);//如果未层调用过play则回滚到play方法
					return;
				}
				
				var crossPlayStateInfo:AnimatorPlayState = controllerLayer._crossPlayStateInfo;
				var crossNodeOwners:Vector.<KeyframeNodeOwner> = controllerLayer._crossNodesOwners;
				var crossNodeOwnerIndicesMap:Object = controllerLayer._crossNodesOwnersIndicesMap;
				
				var srcAnimatorState:AnimatorState = controllerLayer._currentPlayState;
				var destNodeOwners:Vector.<KeyframeNodeOwner> = destAnimatorState._nodeOwners;
				var destCrossClipNodeIndices:Vector.<int> = controllerLayer._destCrossClipNodeIndices;
				var destClip:AnimationClip = destAnimatorState._clip;
				var destNodes:KeyframeNodeList = destClip._nodes;
				var destNodesMap:Object = destClip._nodesDic;
				switch (playType) {
				case 0: 
					var srcNodeOwners:Vector.<KeyframeNodeOwner> = srcAnimatorState._nodeOwners;
					var scrCrossClipNodeIndices:Vector.<int> = controllerLayer._srcCrossClipNodeIndices;
					var srcClip:AnimationClip = srcAnimatorState._clip;
					var srcNodes:KeyframeNodeList = srcClip._nodes;
					var srcNodesMap:Object = srcClip._nodesDic;
					controllerLayer._playType = 1;
					
					var crossMark:int = ++controllerLayer._crossMark;
					var crossCount:int = controllerLayer._crossNodesOwnersCount = 0;
					
					for (var i:int = 0, n:int = srcNodes.count; i < n; i++) {
						var srcNode:KeyframeNode = srcNodes.getNodeByIndex(i);
						var srcIndex:int = srcNode._indexInList;
						var srcNodeOwner:KeyframeNodeOwner = srcNodeOwners[srcIndex];
						if (srcNodeOwner) {
							var srcFullPath:String = srcNode.fullPath;
							scrCrossClipNodeIndices[crossCount] = srcIndex;
							var destNode:KeyframeNode = destNodesMap[srcFullPath];
							if (destNode)
								destCrossClipNodeIndices[crossCount] = destNode._indexInList;
							else
								destCrossClipNodeIndices[crossCount] = -1;
							
							crossNodeOwnerIndicesMap[srcFullPath] = crossMark;
							crossNodeOwners[crossCount] = srcNodeOwner;
							crossCount++;
						}
					}
					
					for (i = 0, n = destNodes.count; i < n; i++) {
						destNode = destNodes.getNodeByIndex(i);
						var destIndex:int = destNode._indexInList;
						var destNodeOwner:KeyframeNodeOwner = destNodeOwners[destIndex];
						if (destNodeOwner) {
							var destFullPath:String = destNode.fullPath;
							if (!srcNodesMap[destFullPath]) {
								scrCrossClipNodeIndices[crossCount] = -1;
								destCrossClipNodeIndices[crossCount] = destIndex;
								
								crossNodeOwnerIndicesMap[destFullPath] = crossMark;
								crossNodeOwners[crossCount] = destNodeOwner;
								crossCount++;
							}
						}
					}
					break;
				case 1: 
				case 2: 
					controllerLayer._playType = 2;
					for (i = 0, n = crossNodeOwners.length; i < n; i++) {
						var nodeOwner:KeyframeNodeOwner = crossNodeOwners[i];
						nodeOwner.saveCrossFixedValue();
						destNode = destNodesMap[nodeOwner.fullPath];
						if (destNode)
							destCrossClipNodeIndices[i] = destNode._indexInList;
						else
							destCrossClipNodeIndices[i] = -1;
					}
					
					crossCount = controllerLayer._crossNodesOwnersCount;
					crossMark = controllerLayer._crossMark;
					for (i = 0, n = destNodes.count; i < n; i++) {
						destNode = destNodes.getNodeByIndex(i);
						destIndex = destNode._indexInList;
						destNodeOwner = destNodeOwners[destIndex];
						if (destNodeOwner) {
							destFullPath = destNode.fullPath;
							if (crossNodeOwnerIndicesMap[destFullPath] !== crossMark) {
								destCrossClipNodeIndices[crossCount] = destIndex;
								
								crossNodeOwnerIndicesMap[destFullPath] = crossMark;
								nodeOwner = destNodeOwners[destIndex];
								crossNodeOwners[crossCount] = nodeOwner;
								nodeOwner.saveCrossFixedValue();
								crossCount++;
							}
						}
					}
					break;
				default: 
				}
				controllerLayer._crossNodesOwnersCount = crossCount;
				controllerLayer._crossPlayState = destAnimatorState;
				controllerLayer._crossDuration = srcAnimatorState._clip._duration * transitionDuration;
				if (normalizedTime !== Number.NEGATIVE_INFINITY)
					crossPlayStateInfo._resetPlayState(destClip._duration * normalizedTime);
				else
					crossPlayStateInfo._resetPlayState(0.0);
			}
			
			var scripts:Vector.<AnimatorStateScript> = destAnimatorState._scripts;
			if (scripts) {
				for (i = 0, n = scripts.length; i < n; i++)
					scripts[i].onStateEnter();
			}
		}
		
		/**
		 * 关联精灵节点到Avatar节点,此Animator必须有Avatar文件。
		 * @param nodeName 关联节点的名字。
		 * @param sprite3D 精灵节点。
		 * @return 是否关联成功。
		 */
		public function linkSprite3DToAvatarNode(nodeName:String, sprite3D:Sprite3D):Boolean {//TODO:克隆挂点信息丢失问题
			if (sprite3D._hierarchyAnimator === this) {
				_isLinkSpriteToAnimationNodeData(sprite3D, nodeName, true);
				_isLinkSpriteToAnimationNode(sprite3D, nodeName, true);
				return true;
			} else {
				throw("Animator:sprite3D must belong to this Animator");
				return false;
			}
		}
		
		/**
		 * 解除精灵节点到Avatar节点的关联,此Animator必须有Avatar文件。
		 * @param sprite3D 精灵节点。
		 * @return 是否解除关联成功。
		 */
		public function unLinkSprite3DToAvatarNode(sprite3D:Sprite3D):Boolean {
			if (sprite3D._hierarchyAnimator === this) {
				var dummy:AnimationTransform3D = sprite3D.transform._dummy;
				if (dummy) {
					var nodeName:String = dummy._owner.name;
					_isLinkSpriteToAnimationNodeData(sprite3D, nodeName, false);
					_isLinkSpriteToAnimationNode(sprite3D, nodeName, false);
					return true;
				} else {
					return false;
				}
			} else {
				throw("Animator:sprite3D must belong to this Animator");
				return false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			for (var i:int = 0, n:int = _controllerLayers.length; i < n; i++) {
				var clipStateInfos:Vector.<AnimatorState> = _controllerLayers[i]._states;
				for (var j:int = 0, m:int = clipStateInfos.length; j < m; j++)
					clipStateInfos[j]._clip._removeReference();
			}
		}
		
		/**
		 *@private
		 * [NATIVE]
		 */
		public function _updateAnimationNodeWorldMatix(localPositions:Float32Array, localRotations:Float32Array, localScales:Float32Array, worldMatrixs:Float32Array, parentIndices:Int16Array):void {
			LayaGL.instance.updateAnimationNodeWorldMatix(localPositions, localRotations, localScales, parentIndices, worldMatrixs);
		}
	}

}