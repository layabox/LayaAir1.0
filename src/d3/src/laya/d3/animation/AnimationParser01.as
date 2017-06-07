package laya.d3.animation {
	import laya.utils.Byte;
	
	/**
	 * @private
	 */
	public class AnimationParser01 {
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
				var fn:Function = AnimationParser01["READ_" + blockName];
				if (fn == null)
					throw new Error("model file err,no this function:" + index + " " + blockName);
				else
					fn.call();
			}
		}
		
		public static function READ_ANIMATIONS():void {
			var i:int, j:int;
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
			var nodes:Vector.<AnimationNode> = clip._nodes = new Vector.<AnimationNode>;
			clip.name = _strings[reader.getUint16()];
			clip._duration = reader.getFloat32();
			clip._frameRate = reader.getInt16();
			var nodeCount:int = clip._nodes.length = reader.getInt16();
			for (i = 0; i < nodeCount; i++) {
				var node:AnimationNode = nodes[i] = new AnimationNode();
				
				var pathLength:int = reader.getUint16();
				var path:Vector.<String> = node.path = new Vector.<String>();
				path.length = pathLength;
				for (j = 0; j < pathLength; j++)
					path[i] = _strings[reader.getUint16()];
				
				node.componentType = _strings[reader.getUint16()];
				node.propertyName = _strings[reader.getUint16()];
				var dataLength:int = lengthTypes[reader.getUint8()];
				var keyFrames:Vector.<Keyframe> = node.keyFrames = new Vector.<Keyframe>();
				
				var keyframeCount:int = keyFrames.length = reader.getUint16();
				var lastKeyFrame:Keyframe = null;
				for (j = 0; j < keyframeCount; j++) {
					var keyFrame:Keyframe = keyFrames[j] = new Keyframe();
					var startTime:Number = keyFrame.startTime = startTimeTypes[reader.getUint16()];
					keyFrame.inTangent = reader.getFloat32();
					keyFrame.outTangent = reader.getFloat32();
					
					var offset:int = reader.pos;
					keyFrame.data = new Float32Array(buffer.slice(offset, offset + dataLength));
					reader.pos += dataLength;
					if (lastKeyFrame) {
						lastKeyFrame.next = keyFrame;
						lastKeyFrame.duration = startTime - lastKeyFrame.startTime;
					}
					lastKeyFrame = keyFrame;
				}
				keyFrame.next = keyFrame;
				keyFrame.duration = 0;
			}
		}
	}
}