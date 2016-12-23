package laya.ani {
	import laya.ani.math.BezierLerp;
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.resource.Resource;
	import laya.utils.Byte;
	
	/**
	 * <code>AnimationTemplet</code> 类用于动画模板资源。
	 */
	public class AnimationTemplet extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var interpolation:Array = /*[STATIC SAFE]*/ [_LinearInterpolation_0, _QuaternionInterpolation_1, _AngleInterpolation_2, _RadiansInterpolation_3, _Matrix4x4Interpolation_4, _NoInterpolation_5, _BezierInterpolation_6, _BezierInterpolation_7];
		
		//线性插值函数
		private static function _LinearInterpolation_0(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			out[outOfs] = data[index] + dt * dData[index];
			return 1;
		}
		
		//四元素插值函数
		private static function _QuaternionInterpolation_1(bone:*, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			var amount:Number = duration === 0 ? 0 : dt / duration;
			MathUtil.slerpQuaternionArray(data, index, nextData, index, amount, out, outOfs);//(dt/duration)为amount比例
			return 4;
		}
		
		//角度插值函数
		private static function _AngleInterpolation_2(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			return 0;
		}
		
		//弧度插值函数
		private static function _RadiansInterpolation_3(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			return 0;
		}
		
		//矩阵插值
		private static function _Matrix4x4Interpolation_4(bone:*, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			for (var i:int = 0; i < 16; i++, index++)
				out[outOfs + i] = data[index] + dt * dData[index];
			return 16;
		}
		
		//无插值函数
		private static function _NoInterpolation_5(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			out[outOfs] = data[index];
			return 1;
		}
		
		//贝塞尔插值函数
		private static function _BezierInterpolation_6(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			out[outOfs] = data[index] + (nextData[index] - data[index]) * BezierLerp.getBezierRate(dt / duration, interData[0], interData[1], interData[2], interData[3]);
			return 5;
		}
		
		//贝塞尔插值函数带偏移
		private static function _BezierInterpolation_7(bone:AnimationNodeContent, index:int, out:Float32Array, outOfs:int, data:Float32Array, dt:Number, dData:Float32Array, duration:Number, nextData:Float32Array, interData:Array = null):int {
			//interData=[x0,y0,x1,y1,start,d,offTime,allTime]
			out[outOfs] = interData[4] + interData[5] * BezierLerp.getBezierRate((dt*0.001+interData[6]) / interData[7], interData[0], interData[1], interData[2], interData[3]);
			return 9;
		}
		/**@private */
		public static var LAYA_ANIMATION_VISION:String = "LAYAANIMATION:1.6.0";
		
		/**
		 * 加载动画模板。
		 * @param url 动画模板地址。
		 */
		public static function load(url:String):AnimationTemplet {
			return Laya.loader.create(url, null, null, AnimationTemplet);
		}
		
		protected var _anis:Vector.<AnimationContent> = new Vector.<AnimationContent>;
		protected var _aniMap:* = {};
		protected var _publicExtData:ArrayBuffer;//公共扩展数据
		protected var _useParent:Boolean;//是否采用对象树数据格式
		protected var unfixedCurrentFrameIndexes:Uint32Array;
		protected var unfixedCurrentTimes:Float32Array;
		protected var unfixedKeyframes:Vector.<KeyFramesContent>;
		protected var unfixedLastAniIndex:int = -1;
		protected var aniClassName:String;
		
		protected var _aniVersion:String;
		
		public var _animationDatasCache:*;
		
		public function AnimationTemplet() {
		}
		
		public function _endLoaded():void {
			_loaded = true;
			event(Event.LOADED, this);
		}
		
		public function parse(data:ArrayBuffer):void {
			var i:int, j:int, k:int, n:int, l:int, m:int, o:int;
			var read:Byte = new Byte(data);
			
			_aniVersion = read.readUTFString();
			//if (head != KeyframesAniTemplet.LAYA_ANIMATION_VISION)
			//{
			//trace("[Error] Version " + _aniVersion + " The engine is inconsistent, update to the version " + KeyframesAniTemplet.LAYA_ANIMATION_VISION + " please.");
			//return;
			//}
			var aniClassName:String = read.readUTFString();//字符串(动画播放器类名，缺省为ANI)
			this.aniClassName = aniClassName;
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
					
					node.lerpType = read.getUint8();//该节点插值类型:0为不插值，1为逐节点插值，2为私有插值
					
					var keyframeParamsOffset:uint = read.getUint32();//相对于数据扩展区的偏移地址
					publicRead.pos = keyframeParamsOffset;//切换到数据区偏移地址
					
					var keyframeDataCount:int = node.keyframeWidth = publicRead.getUint16();//keyframe数据宽度:Uint8		
					ani.totalKeyframesLength += keyframeDataCount;
					//每个数据的插值方式:Uint8*keyframe数据宽度
					if (node.lerpType === 0||node.lerpType === 1)//是否逐节点插值
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
						
						if (node.lerpType === 2)//是否逐帧插值
						{
							keyFrame.interpolationData = [];
							var interDataLength:int = read.getUint8();//插值数据长度
							var lerpType:int;
							lerpType = read.getFloat32();
							switch (lerpType) {
								case 254: //全线性插值
									keyFrame.interpolationData.length = keyframeDataCount;
									for (o = 0; o < keyframeDataCount; o++)
										keyFrame.interpolationData[o] = 0;
									break;
								case 255: //全不插值
									keyFrame.interpolationData.length = keyframeDataCount;
									for (o = 0; o < keyframeDataCount; o++)
										keyFrame.interpolationData[o] = 5;
									break;
								default: 
									keyFrame.interpolationData.push(lerpType);
									for (m = 1; m < interDataLength; m++)
									{
										keyFrame.interpolationData.push(read.getFloat32());
									}
								}
							//for (m = 0; m < interDataLength; m++) {
								//var lerpData:int = read.getFloat32();//插值数据
								//switch (lerpData) {
								//case 254: //全线性插值
									//keyFrame.interpolationData.length = keyframeDataCount;
									//for (o = 0; o < keyframeDataCount; o++)
										//keyFrame.interpolationData[o] = 0;
									//break;
								//case 255: //全不插值
									//
									//keyFrame.interpolationData.length = keyframeDataCount;
									//for (o = 0; o < keyframeDataCount; o++)
										//keyFrame.interpolationData[o] = 5;
									//break;
								//default: 
									//keyFrame.interpolationData.push(lerpData);
								//}
							//}
							
						}
						
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
					
				}
			}
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
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*):void {
			parse(data as ArrayBuffer);
			_endLoaded();
		}
		
		public function getAnimationCount():int {
			return _anis.length;
		}
		
		public function getAnimation(aniIndex:int):* {
			return _anis[aniIndex];
		}
		
		public function getAniDuration(aniIndex:int):int {
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
		
		public function getAnimationDataWithCache(key:*, cacheDatas:*, aniIndex:int, frameIndex:int):Float32Array {
			var aniDatas:Object = cacheDatas[aniIndex];
			if (!aniDatas) {
				return null;
			} else {
				var keyDatas:Array = aniDatas[key];
				if (!keyDatas)
					return null;
				else {
					return keyDatas[frameIndex];
				}
			}
		}
		
		public function setAnimationDataWithCache(key:*, cacheDatas:Array, aniIndex:int, frameIndex:Number, data:*):void {
			var aniDatas:Object = (cacheDatas[aniIndex]) || (cacheDatas[aniIndex] = {});
			var aniDatasCache:Array = (aniDatas[key]) || (aniDatas[key] = []);
			aniDatasCache[frameIndex] = data;
		}
		
		public function getOriginalData(aniIndex:int, originalData:Float32Array, nodesFrameIndices:Array, frameIndex:int, playCurTime:Number):void {
			var oneAni:AnimationContent = _anis[aniIndex];
			
			var nodes:Vector.<AnimationNodeContent> = oneAni.nodes;
			
			var j:int = 0;
			for (var i:int = 0, n:int = nodes.length, outOfs:int = 0; i < n; i++) {
				var node:AnimationNodeContent = nodes[i];
				
				var key:KeyFramesContent;
				key = node.keyFrame[nodesFrameIndices[i][frameIndex]];
				
				node.dataOffset = outOfs;
				
				var dt:Number = playCurTime - key.startTime;
				switch (node.lerpType) {
				case 0: 
				case 1: 
					for (j = 0; j < node.keyframeWidth; )
						j += node.interpolationMethod[j](node, j, originalData, outOfs + j, key.data, dt, key.dData, key.duration, key.nextData);
					break;
				case 2: 
					var interpolationData:Array = key.interpolationData;
					var interDataLen:int = interpolationData.length;
					var dataIndex:int=0;
					for (j = 0; j < interDataLen; )
					{
						var type:int = interpolationData[j];
						switch(type)
						{
							case 6:
								j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData, interpolationData.slice(j + 1, j + 5));
							break;
							case 7:
								j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData, interpolationData.slice(j + 1, j + 9));
							break;
						default:
							j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData);
								
						}
					    //if (type === 6)
						   //j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData, interpolationData.slice(j+1, j + 5));
					    //else
						//j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData);
						dataIndex++;
					}		
					break;
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
				switch (node.lerpType) {
				case 0: 
				case 1: 
					for (j = 0; j < node.keyframeWidth; )
						j += node.interpolationMethod[j](node, j, originalData, outOfs + j, key.data, dt, key.dData, key.duration, key.nextData);
					break;
				case 2: 
					var interpolationData:Array = key.interpolationData;
					var interDataLen:int = interpolationData.length;
					var dataIndex:int=0;
					for (j = 0; j < interDataLen; )
					{
						var type:int = interpolationData[j];
						switch(type)
						{
							case 6:
								j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData, interpolationData.slice(j + 1, j + 5));
							break;
							case 7:
								j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData, interpolationData.slice(j + 1, j + 9));
							break;
						default:
							j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData);
								
						}
					    //if (type === 6)
						    //j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData, interpolationData.slice(j+1, j + 5));
					    //else
						    //j += interpolation[type](node, dataIndex, originalData, outOfs + dataIndex, key.data, dt, key.dData, key.duration, key.nextData);
						dataIndex++;
					}
					break;
				}
				
				outOfs += node.keyframeWidth;
			}
		}
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
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
	public var lerpType:int;
	public var interpolationMethod:Array;
	public var childs:Array;
	public var keyFrame:Vector.<KeyFramesContent>;// = new Vector.<KeyFramesContent>;
	public var playTime:Number;
	public var extenData:ArrayBuffer;
	public var dataOffset:int;
}

//节点关键帧数据
class KeyFramesContent {
	public var startTime:Number;
	public var duration:Number;
	public var interpolationData:Array;//私有插值方式 [type0(插值类型),Data0(插值数据,可为空)，type1(插值类型),Data1(插值数据,可为空)] 注意：254全线性插值，255全不插值
	public var data:Float32Array;//= new Float32Array();
	public var dData:Float32Array;//= new Float32Array();
	public var nextData:Float32Array;//= new Float32Array();
}
/*[IF-FLASH-END]*/

