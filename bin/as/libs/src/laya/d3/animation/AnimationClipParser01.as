package laya.d3.animation {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.utils.Byte;
	
	/**
	 * @private
	 */
	public class AnimationClipParser01 {
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
		public static function parse(clip:AnimationClip, reader:Byte):void {
			_animationClip = clip;
			_reader = reader;
			var arrayBuffer:ArrayBuffer = reader.__getBuffer();
			READ_DATA();
			READ_BLOCK();
			READ_STRINGS();
			for (var i:int = 0, n:int = _BLOCK.count; i < n; i++) {
				var index:int = reader.getUint16();
				var blockName:String = _strings[index];
				var fn:Function = AnimationClipParser01["READ_" + blockName];
				if (fn == null)
					throw new Error("model file err,no this function:" + index + " " + blockName);
				else
					fn.call();
			}
		}
		
		/**
		 * @private
		 */
		public static function READ_ANIMATIONS():void {
			var i:int, j:int;
			var node:KeyframeNode;
			var reader:Byte = _reader;
			var buffer:ArrayBuffer = reader.__getBuffer();
			var lengthTypes:Vector.<int> = new Vector.<int>();
			var lenghthTypeCount:int = reader.getUint8();
			lengthTypes.length = lenghthTypeCount;
			for (i = 0; i < lenghthTypeCount; i++)
				lengthTypes[i] = reader.getUint16();
			
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
			var nodes:Vector.<KeyframeNode> = clip._nodes = new Vector.<KeyframeNode>;
			nodes.length = nodeCount;
			var publicDatas:Vector.<Float32Array> = clip._publicClipDatas = new Vector.<Float32Array>();
			publicDatas.length = nodeCount;
			var nodesMap:Object = clip._nodesMap = {};
			var cachePropertyToNodeIndex:int = 0, unCachePropertyToNodeIndex:int = 0;
			for (i = 0; i < nodeCount; i++) {
				node = nodes[i] = new KeyframeNode();
				var pathLength:int = reader.getUint16();
				var path:Vector.<String> = node.path = new Vector.<String>();
				path.length = pathLength;
				for (j = 0; j < pathLength; j++)
					path[j] = _strings[reader.getUint16()];//TODO:如果只有根节点并且为空，是否可以和componentType一样优化。
				var nodePath:String = path.join("/");
				var mapArray:Vector.<KeyframeNode> = nodesMap[nodePath];
				(mapArray) || (nodesMap[nodePath] = mapArray = new Vector.<KeyframeNode>());
				mapArray.push(node);
				var componentTypeStrIndex:int = reader.getInt16();
				(componentTypeStrIndex !== -1) && (node.componentType = _strings[componentTypeStrIndex]);
				
				var propertyNameID:* = AnimationNode._propertyIndexDic[_strings[reader.getUint16()]];
				if (propertyNameID != null) {
					var isTransformProperty:Boolean = propertyNameID < 4;
					var cacheProperty:Boolean = !isTransformProperty || (isTransformProperty && path[0] === "");
					node._cacheProperty = cacheProperty;
					if (cacheProperty)
						cachePropertyToNodeIndex++;
					else
						unCachePropertyToNodeIndex++;
					node.propertyNameID = propertyNameID;
				} else {
					throw new Error("AnimationClipParser01:unknown property name.");
				}
				
				var dataLength:int = lengthTypes[reader.getUint8()];
				node.keyFrameWidth = dataLength / 4;
				var keyFrames:Vector.<Keyframe> = node.keyFrames = new Vector.<Keyframe>();
				
				var keyframeCount:int = keyFrames.length = reader.getUint16();
				var lastKeyFrame:Keyframe = null;
				var startTime:Number;
				for (j = 0; j < keyframeCount; j++) {
					var keyFrame:Keyframe = keyFrames[j] = new Keyframe();
					startTime = keyFrame.startTime = startTimeTypes[reader.getUint16()];
					
					var offset:int = reader.pos;
					keyFrame.inTangent = new Float32Array(buffer.slice(offset, offset + dataLength));
					reader.pos += dataLength;
					
					offset = reader.pos;
					keyFrame.outTangent = new Float32Array(buffer.slice(offset, offset + dataLength));
					reader.pos += dataLength;
					
					offset = reader.pos;
					keyFrame.data = new Float32Array(buffer.slice(offset, offset + dataLength));
					reader.pos += dataLength;
					
					if (lastKeyFrame) {
						lastKeyFrame.next = keyFrame;
						lastKeyFrame.duration = startTime - lastKeyFrame.startTime;
					}
					lastKeyFrame = keyFrame;
				}
				keyFrame.next = null;
				keyFrame.duration = clipDur - startTime;
			}
			
			var nodeToCachePropertyMap:Int32Array = clip._nodeToCachePropertyMap = new Int32Array(nodeCount);
			var cachePropertyToNodeMap:Int32Array = clip._cachePropertyMap = new Int32Array(cachePropertyToNodeIndex);
			var unCachePropertyToNodeMap:Int32Array = clip._unCachePropertyMap = new Int32Array(unCachePropertyToNodeIndex);
			cachePropertyToNodeIndex = unCachePropertyToNodeIndex = 0;
			for (i = 0; i < nodeCount; i++) {
				node = nodes[i];
				if (node._cacheProperty) {
					nodeToCachePropertyMap[i] = cachePropertyToNodeIndex;
					cachePropertyToNodeMap[cachePropertyToNodeIndex++] = i;
				} else {
					unCachePropertyToNodeMap[unCachePropertyToNodeIndex++] = i;
				}
			}
		}
	}
}