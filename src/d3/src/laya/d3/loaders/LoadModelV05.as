package laya.d3.loaders {
	import laya.d3.core.BufferState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.MeshRenderDynamicBatchManager;
	import laya.d3.graphics.SubMeshInstanceBatch;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.HalfFloatUtils;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.utils.Byte;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>LoadModelV05</code> 类用于模型加载。
	 */
	public class LoadModelV05 {
		
		/**@private */
		private static var _BLOCK:Object = {count: 0};
		/**@private */
		private static var _DATA:Object = {offset: 0, size: 0};
		
		/**@private */
		private static var _strings:Array = [];
		/**@private */
		private static var _readData:Byte;
		/**@private */
		private static var _version:String;
		/**@private */
		private static var _mesh:Mesh;
		/**@private */
		private static var _subMeshes:Vector.<SubMesh>;
		/**@private */
		private static var _bindPoseIndices:Vector.<int> = new Vector.<int>();
		
		/**
		 * @private
		 */
		public static function parse(readData:Byte, version:String, mesh:Mesh, subMeshes:Vector.<SubMesh>):void {
			_mesh = mesh;
			_subMeshes = subMeshes;
			_version = version;
			_readData = readData;
			READ_DATA();
			READ_BLOCK();
			READ_STRINGS();
			for (var i:int = 0, n:int = _BLOCK.count; i < n; i++) {
				_readData.pos = _BLOCK.blockStarts[i];
				var index:int = _readData.getUint16();
				var blockName:String = _strings[index];
				var fn:Function = LoadModelV05["READ_" + blockName];
				if (fn == null)
					throw new Error("model file err,no this function:" + index + " " + blockName);
				else
					fn.call();
			}
			_mesh._bindPoseIndices = new Uint16Array(_bindPoseIndices);
			_bindPoseIndices.length = 0;
			_strings.length = 0;
			_readData = null;
			_version = null;
			_mesh = null;
			_subMeshes = null;
		}
		
		/**
		 * @private
		 */
		private static function _readString():String {
			return _strings[_readData.getUint16()];
		}
		
		/**
		 * @private
		 */
		private static function READ_DATA():void {
			_DATA.offset = _readData.getUint32();
			_DATA.size = _readData.getUint32();
		}
		
		/**
		 * @private
		 */
		private static function READ_BLOCK():void {
			var count:uint = _BLOCK.count = _readData.getUint16();
			var blockStarts:Array = _BLOCK.blockStarts = [];
			var blockLengths:Array = _BLOCK.blockLengths = [];
			for (var i:int = 0; i < count; i++) {
				blockStarts.push(_readData.getUint32());
				blockLengths.push(_readData.getUint32());
			}
		}
		
		/**
		 * @private
		 */
		private static function READ_STRINGS():void {
			var offset:uint = _readData.getUint32();
			var count:uint = _readData.getUint16();
			var prePos:int = _readData.pos;
			_readData.pos = offset + _DATA.offset;
			
			for (var i:int = 0; i < count; i++)
				_strings[i] = _readData.readUTFString();
			
			_readData.pos = prePos;
		}
		
		/**
		 * @private
		 */
		private static function READ_MESH():Boolean {
			var i:int, n:int;
			var memorySize:int = 0;
			var name:String = _readString();
			var arrayBuffer:ArrayBuffer = _readData.__getBuffer();
			var vertexBufferCount:uint = _readData.getInt16();
			var offset:int = _DATA.offset;
			for (i = 0; i < vertexBufferCount; i++) {//TODO:始终为1
				var vbStart:uint = offset + _readData.getUint32();
				var vertexCount:uint = _readData.getUint32();
				var vertexFlag:String = _readString();
				var vertexDeclaration:VertexDeclaration = VertexMesh.getVertexDeclaration(vertexFlag, false);
				
				var vertexStride:int = vertexDeclaration.vertexStride;
				var vertexData:ArrayBuffer = new ArrayBuffer(vertexStride * vertexCount);
				var floatData:Float32Array = new Float32Array(vertexData);
				
				var subVertexFlags:Array = vertexFlag.split(",");
				var subVertexCount:int = subVertexFlags.length;
				
				switch (_version) {
				case "LAYAMODEL:05": 
					floatData = new Float32Array(arrayBuffer.slice(vbStart, vbStart + vertexCount * vertexStride));
					break;
				case "LAYAMODEL:COMPRESSION_05": 
					var lastPosition:int = _readData.pos;
					floatData = new Float32Array(vertexData);
					var uint8Data:Uint8Array = new Uint8Array(vertexData);
					_readData.pos = vbStart;
					
					for (var j:int = 0; j < vertexCount; j++) {
						var subOffset:int;
						var verOffset:int = j * vertexStride;
						for (var k:int = 0; k < subVertexCount; k++) {
							switch (subVertexFlags[k]) {
							case "POSITION": 
								subOffset = verOffset / 4;
								floatData[subOffset] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								floatData[subOffset + 1] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								floatData[subOffset + 2] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								verOffset += 12;
								break;
							case "NORMAL": 
								subOffset = verOffset / 4;
								floatData[subOffset] = _readData.getUint8() / 127.5 - 1;
								floatData[subOffset + 1] = _readData.getUint8() / 127.5 - 1;
								floatData[subOffset + 2] = _readData.getUint8() / 127.5 - 1;
								verOffset += 12;
								break;
							case "COLOR": 
								subOffset = verOffset / 4;
								floatData[subOffset] = _readData.getUint8() / 255;
								floatData[subOffset + 1] = _readData.getUint8() / 255;
								floatData[subOffset + 2] = _readData.getUint8() / 255;
								floatData[subOffset + 3] = _readData.getUint8() / 255;
								verOffset += 16;
								break;
							case "UV": 
								subOffset = verOffset / 4;
								floatData[subOffset] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								floatData[subOffset + 1] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								verOffset += 8;
								break;
							case "UV1": 
								subOffset = verOffset / 4;
								floatData[subOffset] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								floatData[subOffset + 1] = HalfFloatUtils.convertToNumber(_readData.getUint16());
								verOffset += 8;
								break;
							case "BLENDWEIGHT": 
								subOffset = verOffset / 4;
								floatData[subOffset] = _readData.getUint8() / 255;
								floatData[subOffset + 1] = _readData.getUint8() / 255;
								floatData[subOffset + 2] = _readData.getUint8() / 255;
								floatData[subOffset + 3] = _readData.getUint8() / 255;
								verOffset += 16;
								break;
							case "BLENDINDICES": 
								uint8Data[verOffset] = _readData.getUint8();
								uint8Data[verOffset + 1] = _readData.getUint8();
								uint8Data[verOffset + 2] = _readData.getUint8();
								uint8Data[verOffset + 3] = _readData.getUint8();
								verOffset += 4;
								break;
							case "TANGENT": 
								subOffset = verOffset / 4;
								floatData[subOffset] = _readData.getUint8() / 127.5 - 1;
								floatData[subOffset + 1] = _readData.getUint8() / 127.5 - 1;
								floatData[subOffset + 2] = _readData.getUint8() / 127.5 - 1;
								floatData[subOffset + 3] = _readData.getUint8() / 127.5 - 1;
								verOffset += 16;
								break;
							}
						}
					}
					_readData.pos = lastPosition;
					break;
				}
				
				var vertexBuffer:VertexBuffer3D = new VertexBuffer3D(vertexData.byteLength, WebGLContext.STATIC_DRAW, true);
				vertexBuffer.vertexDeclaration = vertexDeclaration;
				vertexBuffer.setData(floatData);
				_mesh._vertexBuffers.push(vertexBuffer);
				_mesh._vertexCount += vertexBuffer.vertexCount;
				memorySize += floatData.length * 4;
			}
			
			var ibStart:uint = offset + _readData.getUint32();
			var ibLength:uint = _readData.getUint32();
			var ibDatas:Uint16Array = new Uint16Array(arrayBuffer.slice(ibStart, ibStart + ibLength));
			var indexBuffer:IndexBuffer3D = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, ibLength / 2, WebGLContext.STATIC_DRAW, true);
			indexBuffer.setData(ibDatas);
			_mesh._indexBuffer = indexBuffer;
			
			_mesh._setBuffer(_mesh._vertexBuffers, indexBuffer);
			
			memorySize += indexBuffer.indexCount * 2;
			_mesh._setCPUMemory(memorySize);
			_mesh._setGPUMemory(memorySize);
			
			var boneNames:Vector.<String> = _mesh._boneNames = new Vector.<String>();
			var boneCount:uint = _readData.getUint16();
			boneNames.length = boneCount;
			for (i = 0; i < boneCount; i++)
				boneNames[i] = _strings[_readData.getUint16()];
			
			var bindPoseDataStart:uint = _readData.getUint32();
			var bindPoseDataLength:uint = _readData.getUint32();
			var bindPoseDatas:Float32Array = new Float32Array(arrayBuffer.slice(offset + bindPoseDataStart, offset + bindPoseDataStart + bindPoseDataLength));
			var bindPoseFloatCount:int = bindPoseDatas.length;
			var bindPoseCount:int = bindPoseFloatCount / 16;
			var bindPoseBuffer:ArrayBuffer = _mesh._inverseBindPosesBuffer = new ArrayBuffer(bindPoseFloatCount * 4);//TODO:[NATIVE]临时
			_mesh._inverseBindPoses = new Vector.<Matrix4x4>(bindPoseCount);
			for (i = 0; i < bindPoseFloatCount; i += 16) {
				var inverseGlobalBindPose:Matrix4x4 = new Matrix4x4(bindPoseDatas[i + 0], bindPoseDatas[i + 1], bindPoseDatas[i + 2], bindPoseDatas[i + 3], bindPoseDatas[i + 4], bindPoseDatas[i + 5], bindPoseDatas[i + 6], bindPoseDatas[i + 7], bindPoseDatas[i + 8], bindPoseDatas[i + 9], bindPoseDatas[i + 10], bindPoseDatas[i + 11], bindPoseDatas[i + 12], bindPoseDatas[i + 13], bindPoseDatas[i + 14], bindPoseDatas[i + 15], new Float32Array(bindPoseBuffer, i * 4, 16));
				_mesh._inverseBindPoses[i / 16] = inverseGlobalBindPose;
			}
			return true;
		}
		
		/**
		 * @private
		 */
		private static function READ_SUBMESH():Boolean {
			var arrayBuffer:ArrayBuffer = _readData.__getBuffer();
			var submesh:SubMesh = new SubMesh(_mesh);
			
			var vbIndex:int = _readData.getInt16();
			
			var ibStart:int = _readData.getUint32();
			var ibCount:int = _readData.getUint32();
			var indexBuffer:IndexBuffer3D = _mesh._indexBuffer;
			submesh._indexBuffer = indexBuffer;
			submesh._indexStart = ibStart;
			submesh._indexCount = ibCount;
			submesh._indices = new Uint16Array(indexBuffer.getData().buffer, ibStart * 2, ibCount);
			var vertexBuffer:VertexBuffer3D = _mesh._vertexBuffers[vbIndex];
			submesh._vertexBuffer = vertexBuffer;	
			
			var offset:int = _DATA.offset;
			var subIndexBufferStart:Vector.<int> = submesh._subIndexBufferStart;
			var subIndexBufferCount:Vector.<int> = submesh._subIndexBufferCount;
			var boneIndicesList:Vector.<Uint16Array> = submesh._boneIndicesList;
			var drawCount:int = _readData.getUint16();
			subIndexBufferStart.length = drawCount;
			subIndexBufferCount.length = drawCount;
			boneIndicesList.length = drawCount;
			
			var pathMarks:Vector.<Array> = _mesh._skinDataPathMarks;
			var bindPoseIndices:Vector.<int> = _bindPoseIndices;
			var subMeshIndex:int = _subMeshes.length;
			for (var i:int = 0; i < drawCount; i++) {
				subIndexBufferStart[i] = _readData.getUint32();
				subIndexBufferCount[i] = _readData.getUint32();
				var boneDicofs:int = _readData.getUint32();
				var boneDicCount:int = _readData.getUint32();
				var boneIndices:Uint16Array = boneIndicesList[i] = new Uint16Array(arrayBuffer.slice(offset + boneDicofs, offset + boneDicofs + boneDicCount));
				for (var j:int = 0, m:int = boneIndices.length; j < m; j++) {
					var index:int = boneIndices[j];
					var combineIndex:int = bindPoseIndices.indexOf(index);
					if (combineIndex === -1) {
						boneIndices[j] = bindPoseIndices.length;
						bindPoseIndices.push(index);
						pathMarks.push([subMeshIndex, i, j]);
					} else {
						boneIndices[j] = combineIndex;
					}
				}
			}
			_subMeshes.push(submesh);
			return true;
		}
	
	}

}