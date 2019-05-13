package laya.d3.animation {
	import laya.d3.core.FloatKeyframe;
	import laya.d3.core.QuaternionKeyframe;
	import laya.d3.core.Vector3Keyframe;
	import laya.d3.math.HalfFloatUtils;
	import laya.d3.math.Native.ConchQuaternion;
	import laya.d3.math.Native.ConchVector3;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.renders.Render;
	import laya.utils.Byte;
	
	/**
	 * @private
	 */
	public class AnimationClipParser04 {
		/**@private */
		private static var _animationClip:AnimationClip;
		/**@private */
		private static var _reader:Byte;
		/**@private */
		private static var _strings:Array = [];
		/**@private */
		private static var _BLOCK:Object = {count: 0};
		/**@private */
		private static var _DATA:Object = {offset: 0, size: 0};
		/**@private */
		private static var _version:String;
		
		/**
		 * @private
		 */
		private static function READ_DATA():void {
			_DATA.offset = _reader.getUint32();
			_DATA.size = _reader.getUint32();
		}
		
		/**
		 * @private
		 */
		private static function READ_BLOCK():void {
			var count:uint = _BLOCK.count = _reader.getUint16();
			var blockStarts:Array = _BLOCK.blockStarts = [];
			var blockLengths:Array = _BLOCK.blockLengths = [];
			for (var i:int = 0; i < count; i++) {
				blockStarts.push(_reader.getUint32());
				blockLengths.push(_reader.getUint32());
			}
		}
		
		/**
		 * @private
		 */
		private static function READ_STRINGS():void {
			var offset:uint = _reader.getUint32();
			var count:uint = _reader.getUint16();
			var prePos:int = _reader.pos;
			_reader.pos = offset + _DATA.offset;
			
			for (var i:int = 0; i < count; i++)
				_strings[i] = _reader.readUTFString();
			_reader.pos = prePos;
		}
		
		/**
		 * @private
		 */
		public static function parse(clip:AnimationClip, reader:Byte, version:String):void {
			_animationClip = clip;
			_reader = reader;
			_version = version;
			READ_DATA();
			READ_BLOCK();
			READ_STRINGS();
			for (var i:int = 0, n:int = _BLOCK.count; i < n; i++) {
				var index:int = reader.getUint16();
				var blockName:String = _strings[index];
				var fn:Function = AnimationClipParser04["READ_" + blockName];
				if (fn == null)
					throw new Error("model file err,no this function:" + index + " " + blockName);
				else
					fn.call();
			}
			_version = null;
			_reader = null;
			_animationClip = null;
		}
		
		/**
		 * @private
		 */
		public static function READ_ANIMATIONS():void {
			var i:int, j:int;
			var node:KeyframeNode;
			var reader:Byte = _reader;
			var buffer:ArrayBuffer = reader.__getBuffer();
			
			var startTimeTypes:Vector.<int> = new Vector.<int>();
			var startTimeTypeCount:int = reader.getUint16();
			startTimeTypes.length = startTimeTypeCount;
			for (i = 0; i < startTimeTypeCount; i++)
				startTimeTypes[i] = reader.getFloat32();
			
			var clip:AnimationClip = _animationClip;
			clip.name = _strings[reader.getUint16()];
			var clipDur:Number = clip._duration = reader.getFloat32();
			clip.islooping = !!reader.getByte();
			clip._frameRate = reader.getInt16();
			var nodeCount:int = reader.getInt16();
			var nodes:KeyframeNodeList = clip._nodes;
			nodes.count = nodeCount;
			var nodesMap:Object = clip._nodesMap = {};
			var nodesDic:Object = clip._nodesDic = {};
			
			for (i = 0; i < nodeCount; i++) {
				node = new KeyframeNode();
				nodes.setNodeByIndex(i, node);
				node._indexInList = i;
				var type:uint = node.type = reader.getUint8();
				
				var pathLength:int = reader.getUint16();
				node._setOwnerPathCount(pathLength);
				for (j = 0; j < pathLength; j++)
					node._setOwnerPathByIndex(j, _strings[reader.getUint16()]);//TODO:如果只有根节点并且为空，是否可以和componentType一样优化。
				
				var nodePath:String = node._joinOwnerPath("/");
				var mapArray:Vector.<KeyframeNode> = nodesMap[nodePath];
				(mapArray) || (nodesMap[nodePath] = mapArray = new Vector.<KeyframeNode>());
				mapArray.push(node);
				
				node.propertyOwner = _strings[reader.getUint16()];
				
				var propertyLength:int = reader.getUint16();
				node._setPropertyCount(propertyLength);
				for (j = 0; j < propertyLength; j++)
					node._setPropertyByIndex(j, _strings[reader.getUint16()]);
				
				var fullPath:String = nodePath + "." + node.propertyOwner + "." + node._joinProperty(".");
				nodesDic[fullPath] = node;
				node.fullPath = fullPath;
				
				var keyframeCount:int = reader.getUint16();
				node._setKeyframeCount(keyframeCount);
				var startTime:Number;
				
				switch (type) {
				case 0: 
					break;
				case 1: 
				case 3: 
				case 4: 
					node.data = Render.supportWebGLPlusAnimation ? new ConchVector3 :new Vector3();
					break;
				case 2: 
					node.data = Render.supportWebGLPlusAnimation ? new ConchQuaternion :new Quaternion();
					break;
				default: 
					throw "AnimationClipParser04:unknown type.";
				}
				switch (_version) {
				case "LAYAANIMATION:04": 
					for (j = 0; j < keyframeCount; j++) {
						switch (type) {
						case 0: 
							var floatKeyframe:FloatKeyframe = new FloatKeyframe();
							node._setKeyframeByIndex(j, floatKeyframe);
							startTime = floatKeyframe.time = startTimeTypes[reader.getUint16()];
							floatKeyframe.inTangent = reader.getFloat32();
							floatKeyframe.outTangent = reader.getFloat32();
							floatKeyframe.value = reader.getFloat32();
							break;
						case 1: 
						case 3: 
						case 4: 
							var floatArrayKeyframe:Vector3Keyframe = new Vector3Keyframe();
							node._setKeyframeByIndex(j, floatArrayKeyframe);
							startTime = floatArrayKeyframe.time = startTimeTypes[reader.getUint16()];
							if (Render.supportWebGLPlusAnimation) {
								var data:Float32Array = (floatArrayKeyframe as Object).data = new Float32Array(3 * 3);
								for (var k:int = 0; k < 3; k++)
									data[k] = reader.getFloat32();
								for (k = 0; k < 3; k++)
									data[3 + k] = reader.getFloat32();
								for (k = 0; k < 3; k++)
									data[6 + k] = reader.getFloat32();
							}
							else {
								var inTangent:Vector3 = floatArrayKeyframe.inTangent;
								var outTangent:Vector3 = floatArrayKeyframe.outTangent;
								var value:Vector3 = floatArrayKeyframe.value;
								inTangent.x = reader.getFloat32();
								inTangent.y = reader.getFloat32();
								inTangent.z = reader.getFloat32();
								outTangent.x = reader.getFloat32();
								outTangent.y = reader.getFloat32();
								outTangent.z = reader.getFloat32();
								value.x = reader.getFloat32();
								value.y = reader.getFloat32();
								value.z = reader.getFloat32();
							}
							break;
						case 2: 
							var quaternionKeyframe:QuaternionKeyframe = new QuaternionKeyframe();
							node._setKeyframeByIndex(j, quaternionKeyframe);
							startTime = quaternionKeyframe.time = startTimeTypes[reader.getUint16()];
							if (Render.supportWebGLPlusAnimation) {
								data = (quaternionKeyframe as Object).data  = new Float32Array(3 * 4);
								for (k = 0; k < 4; k++)
									data[k] = reader.getFloat32();
								for (k = 0; k < 4; k++)
									data[4 + k] = reader.getFloat32();
								for (k = 0; k < 4; k++)
									data[8 + k] = reader.getFloat32();
							}
							else {
								var inTangentQua:Vector4 = quaternionKeyframe.inTangent;
								var outTangentQua:Vector4 = quaternionKeyframe.outTangent;
								var valueQua:Quaternion = quaternionKeyframe.value;
								inTangentQua.x = reader.getFloat32();
								inTangentQua.y = reader.getFloat32();
								inTangentQua.z = reader.getFloat32();
								inTangentQua.w = reader.getFloat32();
								outTangentQua.x = reader.getFloat32();
								outTangentQua.y = reader.getFloat32();
								outTangentQua.z = reader.getFloat32();
								outTangentQua.w = reader.getFloat32();
								valueQua.x = reader.getFloat32();
								valueQua.y = reader.getFloat32();
								valueQua.z = reader.getFloat32();
								valueQua.w = reader.getFloat32();
							}
							break;
						default: 
							throw "AnimationClipParser04:unknown type.";
						}
					}
					break;
				case "LAYAANIMATION:COMPRESSION_04": 
					for (j = 0; j < keyframeCount; j++) {
						switch (type) {
						case 0: 
							floatKeyframe = new FloatKeyframe();
							node._setKeyframeByIndex(j, floatKeyframe);
							startTime = floatKeyframe.time = startTimeTypes[reader.getUint16()];
							floatKeyframe.inTangent = HalfFloatUtils.convertToNumber(reader.getUint16());
							floatKeyframe.outTangent = HalfFloatUtils.convertToNumber(reader.getUint16());
							floatKeyframe.value = HalfFloatUtils.convertToNumber(reader.getUint16());
							break;
						case 1: 
						case 3: 
						case 4: 
							floatArrayKeyframe = new Vector3Keyframe();
							node._setKeyframeByIndex(j, floatArrayKeyframe);
							startTime = floatArrayKeyframe.time = startTimeTypes[reader.getUint16()];
							
							if (Render.supportWebGLPlusAnimation) {
								data = (floatArrayKeyframe as Object).data = new Float32Array(3 * 3);
								for (k = 0; k < 3; k++)
									data[k] = HalfFloatUtils.convertToNumber(reader.getUint16());
								for (k = 0; k < 3; k++)
									data[3 + k] = HalfFloatUtils.convertToNumber(reader.getUint16());
								for (k = 0; k < 3; k++)
									data[6 + k] = HalfFloatUtils.convertToNumber(reader.getUint16());
							}
							else {
								inTangent = floatArrayKeyframe.inTangent;
								outTangent = floatArrayKeyframe.outTangent;
								value = floatArrayKeyframe.value;
								inTangent.x = HalfFloatUtils.convertToNumber(reader.getUint16());
								inTangent.y = HalfFloatUtils.convertToNumber(reader.getUint16());
								inTangent.z = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangent.x = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangent.y = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangent.z = HalfFloatUtils.convertToNumber(reader.getUint16());
								value.x = HalfFloatUtils.convertToNumber(reader.getUint16());
								value.y = HalfFloatUtils.convertToNumber(reader.getUint16());
								value.z = HalfFloatUtils.convertToNumber(reader.getUint16());
							}
							break;
						case 2: 
							quaternionKeyframe = new QuaternionKeyframe();
							node._setKeyframeByIndex(j, quaternionKeyframe);
							startTime = quaternionKeyframe.time = startTimeTypes[reader.getUint16()];
							
							if (Render.supportWebGLPlusAnimation) {
								data = (quaternionKeyframe as Object).data  = new Float32Array(3 * 4);
								for (k = 0; k < 4; k++)
									data[k] = HalfFloatUtils.convertToNumber(reader.getUint16());
								for (k = 0; k < 4; k++)
									data[4 + k] = HalfFloatUtils.convertToNumber(reader.getUint16());
								for (k = 0; k < 4; k++)
									data[8 + k] = HalfFloatUtils.convertToNumber(reader.getUint16());
							}
							else {
								inTangentQua = quaternionKeyframe.inTangent;
								outTangentQua = quaternionKeyframe.outTangent;
								valueQua = quaternionKeyframe.value;
								inTangentQua.x = HalfFloatUtils.convertToNumber(reader.getUint16());
								inTangentQua.y = HalfFloatUtils.convertToNumber(reader.getUint16());
								inTangentQua.z = HalfFloatUtils.convertToNumber(reader.getUint16());
								inTangentQua.w = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangentQua.x = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangentQua.y = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangentQua.z = HalfFloatUtils.convertToNumber(reader.getUint16());
								outTangentQua.w = HalfFloatUtils.convertToNumber(reader.getUint16());
								valueQua.x = HalfFloatUtils.convertToNumber(reader.getUint16());
								valueQua.y = HalfFloatUtils.convertToNumber(reader.getUint16());
								valueQua.z = HalfFloatUtils.convertToNumber(reader.getUint16());
								valueQua.w = HalfFloatUtils.convertToNumber(reader.getUint16());
							}
							break;
						default: 
							throw "AnimationClipParser04:unknown type.";
						}
					}
					break;
				}
				
			}
			
			var eventCount:int = reader.getUint16();
			for (i = 0; i < eventCount; i++) {
				var event:AnimationEvent = new AnimationEvent();
				event.time =Math.min(clipDur,reader.getFloat32());//TODO:事件时间可能大于动画总时长
				event.eventName = _strings[reader.getUint16()];
				var params:Array;
				var paramCount:int = reader.getUint16();
				(paramCount > 0) && (event.params = params = []);
				
				for (j = 0; j < paramCount; j++) {
					var eventType:int = reader.getByte();
					switch (eventType) {
					case 0: 
						params.push(!!reader.getByte());
						break;
					case 1: 
						params.push(reader.getInt32());
						break;
					case 2: 
						params.push(reader.getFloat32());
						break;
					case 3: 
						params.push(_strings[reader.getUint16()]);
						break;
					default: 
						throw new Error("unknown type.");
					}
				}
				clip.addEvent(event);
			}
		}
	}
}