package laya.ani {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.maths.MathUtil;
	import laya.utils.Byte;
	
	/**
	 * @private
	 */
	public class KeyframesAniTemplet extends EventDispatcher// extends Resource
	{
		/**唯一标识ID计数器。*/
		private static var _uniqueIDCounter:int = 1;
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var interpolation:Array = /*[STATIC SAFE]*/ [_LinearInterpolation_0, _QuaternionInterpolation_1, _AngleInterpolation_2, _RadiansInterpolation_3, _Matrix4x4Interpolation_4, _NoInterpolation_5];
		
		//线性插值函数
		private static function _LinearInterpolation_0(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array):int {
			out[outOfs] = data[index] + dt * dData[index];
			return 1;
		}
		
		//四元素插值函数
		private static function _QuaternionInterpolation_1(bone:*, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array):int {
			var amount:Number = duration === 0 ? 0 : dt / duration;
			MathUtil.slerpQuaternionArray(data, index, nextData, index, amount, out, outOfs);//(dt/duration)为amount比例
			return 4;
		}
		
		//角度插值函数
		private static function _AngleInterpolation_2(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array):int {
			return 0;
		}
		
		//弧度插值函数
		private static function _RadiansInterpolation_3(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array):int {
			return 0;
		}
		
		//矩阵插值
		private static function _Matrix4x4Interpolation_4(bone:*, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array):int {
			for (var i:int = 0; i < 16; i++, index++)
				out[outOfs + i] = data[index] + dt * dData[index];
			return 16;
		}
		
		//无插值函数
		private static function _NoInterpolation_5(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array):int {
			out[outOfs] = data[index];
			return 1;
		}
		/**@private */
		public static var LAYA_ANIMATION_VISION:String = "LAYAANIMATION:1.0.1";
		protected var _anis:Vector.<AnimationContent> = new Vector.<AnimationContent>;
		protected var _aniMap:* = {};
		protected var _publicExtData:ArrayBuffer;//公共扩展数据
		protected var _useParent:Boolean;//是否采用对象树数据格式
		protected var unfixedCurrentFrameIndexes:Uint32Array;
		protected var unfixedCurrentTimes:Float32Array;
		protected var unfixedKeyframes:Vector.<KeyFramesContent>;
		protected var unfixedLastAniIndex:int = -1;
		protected var _loaded:Boolean = false;
		protected var _aniVersion:String;
		
		public var _animationDatasCache:Array = [];
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
		public function KeyframesAniTemplet() {
		}
		
		public function parse(data:ArrayBuffer, playbackRate:int):void {
			var i:int, j:int, k:int, n:int, l:int;
			var read:Byte = new Byte(data);
			
			_aniVersion = read.readUTFString();//LAYAANIMATION:1.0.0
			//if (head != KeyframesAniTemplet.LAYA_ANIMATION_VISION)
			//{
			//trace("[Error] Version " + _aniVersion + " The engine is inconsistent, update to the version " + KeyframesAniTemplet.LAYA_ANIMATION_VISION + " please.");
			//return;
			//}
			var aniClassName:String = read.readUTFString();//字符串(动画播放器类名，缺省为ANI)
			
			var strList:Array = read.readUTFString().split("\n");//字符串(\n分割 UTF8 )
			var aniCount:int = read.getUint8();//动画块数:Uint8
			
			var publicDataPos:int = read.getUint32();//公用数据POS	
			var publicExtDataPos:int = read.getUint32();//公用扩展数据POS
			
			var publicData:ArrayBuffer;//获取公用数据
			if (publicDataPos > 0)
				publicData = data.slice(publicDataPos, publicExtDataPos);
			var publicRead:Byte = new Byte(publicData);
			
			if (publicExtDataPos > 0)//获取公用扩展数据
				_publicExtData = data.slice(publicExtDataPos, data.byteLength);
			
			_useParent = !!read.getUint8();
			_anis.length = aniCount;
			
			for (i = 0; i < aniCount; i++) {
				var ani:AnimationContent = _anis[i] = /*[IF-FLASH]*/ new AnimationContent();
				//[IF-SCRIPT] {};//不要删除
				ani.nodes = new Vector.<AnimationNodeContent>;
				var name:String = ani.name = strList[read.getUint16()];//获得骨骼名字
				
				_aniMap[name] = i;//按名字可以取得动画索引
				ani.bone3DMap = {};
				ani.playTime = read.getFloat32();//本骨骼播放时间
				var boneCount:int = ani.nodes.length = read.getUint8();//得到本动画骨骼数目
				
				ani.totalKeyframesLength = 0;
				for (j = 0; j < boneCount; j++) {
					var node:AnimationNodeContent = ani.nodes[j] = /*[IF-FLASH]*/ new AnimationNodeContent();
					//[IF-SCRIPT] {};//不要删除
					node.childs = [];
					
					var nameIndex:int = read.getInt16();
					if (nameIndex >= 0) {
						node.name = strList[nameIndex];//骨骼名字
						ani.bone3DMap[node.name] = j;
					}
					
					node.keyFrame = new Vector.<KeyFramesContent>;
					node.parentIndex = read.getInt16();//父对象编号，相对本动画(INT16,-1表示没有)
					node.parentIndex == -1 ? node.parent = null : node.parent = ani.nodes[node.parentIndex]
					
					var isLerp:Boolean = !!read.getUint8();//该节点是否插值
					var keyframeParamsOffset:uint = read.getUint32();//相对于数据扩展区的偏移地址
					
					publicRead.pos = keyframeParamsOffset;//切换到数据区偏移地址
					var keyframeDataCount:int = node.keyframeWidth = publicRead.getUint16();//keyframe数据宽度:Uint8		
					ani.totalKeyframesLength += keyframeDataCount;
					//每个数据的插值方式:Uint8*keyframe数据宽度
					if (isLerp)//是否插值，不插值则略过
					{
						node.interpolationMethod = [];
						node.interpolationMethod.length = keyframeDataCount;
						for (k = 0; k < keyframeDataCount; k++)
							node.interpolationMethod[k] = interpolation[publicRead.getUint8()];
					}
					
					if (node.parent != null)
						node.parent.childs.push(node);
					
					var privateDataLen:int = read.getUint16();//"UINT16", [1],//私有数据长度
					if (privateDataLen > 0) {
						//"BYTE", [1],//私有数据
						node.extenData = data.slice(read.pos, read.pos + privateDataLen);
						read.pos += privateDataLen;
					}
					
					var keyframeCount:int = read.getUint16();
					node.keyFrame.length = keyframeCount;
					var startTime:Number = 0;
					for (k = 0, n = keyframeCount; k < n; k++) {
						var keyFrame:KeyFramesContent = node.keyFrame[k] = /*[IF-FLASH]*/ new KeyFramesContent();
						//[IF-SCRIPT] {};//不要删除
						keyFrame.duration = read.getFloat32();
						keyFrame.startTime = startTime;
						keyFrame.data = new Float32Array(keyframeDataCount);
						keyFrame.dData = new Float32Array(keyframeDataCount);
						keyFrame.nextData = new Float32Array(keyframeDataCount);
						for (l = 0; l < keyframeDataCount; l++) {
							keyFrame.data[l] = read.getFloat32();
							if (keyFrame.data[l] > -0.00000001 && keyFrame.data[l] < 0.00000001) keyFrame.data[l] = 0;
						}
						startTime += keyFrame.duration;
					}
					node.playTime = ani.playTime;//节点总时间可能比总时长大，次处修正
					_calculateKeyFrame(node, keyframeCount, keyframeDataCount);
					
					_calculateKeyFrameIndex(node, playbackRate);//计算全帧索引
				}
			}
			_loaded = true;
			this.event(Event.LOADED, this);
		}
		
		private function _calculateKeyFrame(node:AnimationNodeContent, keyframeCount:int, keyframeDataCount:int):void {
			var keyFrames:Vector.<KeyFramesContent> = node.keyFrame;
			keyFrames[keyframeCount] = keyFrames[0];
			for (var i:int = 0; i < keyframeCount; i++) {
				var keyFrame:KeyFramesContent = keyFrames[i];
				for (var j:int = 0; j < keyframeDataCount; j++) {
					keyFrame.dData[j] = (keyFrame.duration === 0) ? 0 : (keyFrames[i + 1].data[j] - keyFrame.data[j]) / keyFrame.duration;//末帧dData数据为0
					keyFrame.nextData[j] = keyFrames[i + 1].data[j];
				}
			}
			keyFrames.length--;
		}
		
		private function _calculateKeyFrameIndex(node:AnimationNodeContent, playbackRate:int):void {
			var frameInterval:Number = 1000 / playbackRate;
			node.frameCount = Math.floor(node.playTime / frameInterval);
			node.fullFrame = new Uint16Array(node.frameCount + 1);//本骨骼对应的全帧关键帧编号
			
			var lastFrameIndex:int = -1;
			
			for (var i:int = 0, n:int = node.keyFrame.length; i < n; i++) {
				var keyFrame:KeyFramesContent = node.keyFrame[i];
				var tm:Number = keyFrame.startTime;
				var endTm:Number = tm + keyFrame.duration + frameInterval;
				do {
					var frameIndex:int = Math.floor(tm / frameInterval + 0.5);
					
					for (var k:int = lastFrameIndex + 1; k < frameIndex; k++)
						node.fullFrame[k] = i;
					lastFrameIndex = frameIndex;
					
					node.fullFrame[frameIndex] = i;
					tm += frameInterval;
				} while (tm <= endTm);
			}
		}
		
		public function getAnimationCount():int {
			return _anis.length;
		}
		
		public function getAnimation(aniIndex:int):* {
			return _anis[aniIndex];
		}
		
		public function getAniDuration(aniIndex:int):Number {
			return _anis[aniIndex].playTime;
		}
		
		public function getNodes(aniIndex:int):* {
			return _anis[aniIndex].nodes;
		}
		
		public function getNodeIndexWithName(aniIndex:int, name:String):int {
			return _anis[aniIndex].bone3DMap[name];
		}
		
		public function getNodeCount(aniIndex:int):int {
			return _anis[aniIndex].nodes.length;
		}
		
		public function getTotalkeyframesLength(aniIndex:int):int {
			return _anis[aniIndex].totalKeyframesLength;
		}
		
		public function getPublicExtData():ArrayBuffer {
			return _publicExtData;
		}
		
		public function getAnimationDataWithCache(cacheDatas:Array, aniIndex:int, frameIndex:int):Float32Array {
			var cache:* = cacheDatas[aniIndex];
			return cache ? cache[frameIndex] : null;
		}
		
		public function setAnimationDataWithCache(cacheDatas:Array, aniIndex:int, frameIndex:Number, data:*):void {
			var cache:* = cacheDatas[aniIndex];
			cache || (cache = cacheDatas[aniIndex] = []);
			cache[frameIndex] = data;
		}
		
		public function getOriginalData(aniIndex:int, originalData:Float32Array, frameIndex:int, playCurTime:Number):void {
			var oneAni:AnimationContent = _anis[aniIndex];
			
			var nodes:Vector.<AnimationNodeContent> = oneAni.nodes;
			
			var j:int = 0;
			for (var i:int = 0, n:int = nodes.length, outOfs:int = 0; i < n; i++) {
				var node:AnimationNodeContent = nodes[i];
				
				var key:KeyFramesContent;
				key = node.keyFrame[node.fullFrame[frameIndex]];
				
				node.dataOffset = outOfs;
				
				var dt:Number = playCurTime - key.startTime;
				for (j = 0; j < node.keyframeWidth; ) {
					j += node.interpolationMethod[j](node, j, originalData, outOfs + j, key.data, dt, key.dData, key.duration, key.nextData);
				}
				outOfs += node.keyframeWidth;
			}
		}
		
		public function getNodesCurrentFrameIndex(aniIndex:int, playCurTime:Number):Uint32Array {
			var ani:AnimationContent = _anis[aniIndex];
			var nodes:Vector.<AnimationNodeContent> = ani.nodes;
			
			if (aniIndex !== unfixedLastAniIndex) {
				unfixedCurrentFrameIndexes = new Uint32Array(nodes.length);
				unfixedCurrentTimes = new Float32Array(nodes.length);
				unfixedLastAniIndex = aniIndex;
			}
			
			for (var i:int = 0, n:int = nodes.length, outOfs:int = 0; i < n; i++) {
				var node:AnimationNodeContent = nodes[i];
				//var playCurTime:Number = curTime % node.playTime;
				
				if (playCurTime < unfixedCurrentTimes[i])
					unfixedCurrentFrameIndexes[i] = 0;
				unfixedCurrentTimes[i] = playCurTime;
				
				while ((unfixedCurrentFrameIndexes[i] < node.keyFrame.length)) {
					if (node.keyFrame[unfixedCurrentFrameIndexes[i]].startTime > unfixedCurrentTimes[i])
						break;
					
					unfixedCurrentFrameIndexes[i]++;
				}
				unfixedCurrentFrameIndexes[i]--;
			}
			return unfixedCurrentFrameIndexes;
		}
		
		public function getOriginalDataUnfixedRate(aniIndex:int, originalData:Float32Array, playCurTime:Number):void {
			var oneAni:AnimationContent = _anis[aniIndex];
			
			var nodes:Vector.<AnimationNodeContent> = oneAni.nodes;
			
			if (aniIndex !== unfixedLastAniIndex) {
				unfixedCurrentFrameIndexes = new Uint32Array(nodes.length);
				unfixedCurrentTimes = new Float32Array(nodes.length);
				unfixedKeyframes = new Vector.<KeyFramesContent>(nodes.length);
				unfixedLastAniIndex = aniIndex;
			}
			
			var j:int = 0;
			for (var i:int = 0, n:int = nodes.length, outOfs:int = 0; i < n; i++) {
				var node:AnimationNodeContent = nodes[i];
				
				if (playCurTime < unfixedCurrentTimes[i])
					unfixedCurrentFrameIndexes[i] = 0;
				
				unfixedCurrentTimes[i] = playCurTime;
				
				while (unfixedCurrentFrameIndexes[i] < node.keyFrame.length) {
					if (node.keyFrame[unfixedCurrentFrameIndexes[i]].startTime > unfixedCurrentTimes[i])
						break;
					
					unfixedKeyframes[i] = node.keyFrame[unfixedCurrentFrameIndexes[i]];
					unfixedCurrentFrameIndexes[i]++;
				}
				
				var key:KeyFramesContent = unfixedKeyframes[i];
				node.dataOffset = outOfs;
				var dt:Number = playCurTime - key.startTime;
				for (j = 0; j < node.keyframeWidth; ) {
					j += node.interpolationMethod[j](node, j, originalData, outOfs + j, key.data, dt, key.dData, key.duration, key.nextData);
				}
				outOfs += node.keyframeWidth;
			}
		}
	
	}
}

/*[IF-FLASH-BEGIN]*/
//动画数据
class AnimationContent {
	public var nodes:Vector.<AnimationNodeContent>;
	public var name:String;
	public var playTime:Number;
	public var bone3DMap:*;
	public var totalKeyframesLength:int;
}

//节点数据
class AnimationNodeContent {
	public var name:String;
	public var parentIndex:int;
	public var parent:AnimationNodeContent;
	public var keyframeWidth:int;
	public var interpolationMethod:Array;
	public var childs:Array;
	public var keyFrame:Vector.<KeyFramesContent>;// = new Vector.<KeyFramesContent>;
	public var fullFrame:Uint16Array;
	public var playTime:Number;
	public var frameCount:int;
	public var extenData:ArrayBuffer;
	public var dataOffset:int;
}

//节点关键帧数据
class KeyFramesContent {
	public var startTime:Number;
	public var duration:Number;
	public var data:Float32Array;//= new Float32Array();
	public var dData:Float32Array;//= new Float32Array();
	public var nextData:Float32Array;//= new Float32Array();
}
/*[IF-FLASH-END]*/

