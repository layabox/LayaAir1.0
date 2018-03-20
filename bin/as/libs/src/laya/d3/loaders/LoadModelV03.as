package laya.d3.loaders {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPosition;
	import laya.d3.graphics.VertexPositionNTBTexture;
	import laya.d3.graphics.VertexPositionNTBTexture0Texture1Skin;
	import laya.d3.graphics.VertexPositionNormal;
	import laya.d3.graphics.VertexPositionNormalColor;
	import laya.d3.graphics.VertexPositionNormalColorSTangent;
	import laya.d3.graphics.VertexPositionNormalColorSkin;
	import laya.d3.graphics.VertexPositionNormalColorSkinSTangent;
	import laya.d3.graphics.VertexPositionNormalColorSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1STangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinSTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Tangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkin;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinSTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureTangent;
	import laya.d3.graphics.VertexPositionNormalSTangent;
	import laya.d3.graphics.VertexPositionNormalTangent;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1STangent;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinSTangent;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinTangent;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1Tangent;
	import laya.d3.graphics.VertexPositionNormalTextureSTangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkin;
	import laya.d3.graphics.VertexPositionNormalTextureSkinSTangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalTextureTangent;
	import laya.d3.graphics.VertexPositionTexture0;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.net.Loader;
	import laya.utils.Byte;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>LoadModel</code> 类用于模型加载。
	 */
	public class LoadModelV03 {
		/**@private */
		public static var _vertexDeclarationMap_Discard:Object = {//兼容代码
			"POSITION,NORMAL,COLOR,UV,UV1,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalColorTexture0Texture1SkinTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,UV1,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalColorTexture0Texture1Skin.vertexDeclaration, 
			"POSITION,NORMAL,TANGENT,BINORMAL,UV,UV1,BLENDWEIGHT,BLENDINDICES,": VertexPositionNTBTexture0Texture1Skin.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalTexture0Texture1SkinTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalTexture0Texture1Skin.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalColorTextureSkinTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalColorTextureSkin.vertexDeclaration, 
			"POSITION,NORMAL,UV,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalTextureSkinTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalTextureSkin.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalColorSkinTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalColorSkin.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,UV1,TANGENT": VertexPositionNormalColorTexture0Texture1Tangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,UV1": VertexPositionNormalColorTexture0Texture1.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1,TANGENT": VertexPositionNormalTexture0Texture1Tangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1": VertexPositionNormalTexture0Texture1.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,TANGENT": VertexPositionNormalColorTextureTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,TANGENT,BINORMAL": VertexPositionNTBTexture.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV": VertexPositionNormalColorTexture.vertexDeclaration, 
			"POSITION,NORMAL,UV,TANGENT": VertexPositionNormalTextureTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV": VertexPositionNormalTexture.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,TANGENT": VertexPositionNormalColorTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR": VertexPositionNormalColor.vertexDeclaration, 
			"POSITION,NORMAL,TANGENT": VertexPositionNormalTangent.vertexDeclaration, 
			"POSITION,NORMAL": VertexPositionNormal.vertexDeclaration, 
			"POSITION,UV": VertexPositionTexture0.vertexDeclaration, 
			"POSITION": VertexPosition.vertexDeclaration};
			
		/**@private */
		public static var _vertexDeclarationMap:Object = {
			"POSITION,NORMAL,COLOR,UV,UV1,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalColorTexture0Texture1SkinSTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,UV1,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalColorTexture0Texture1Skin.vertexDeclaration, 
			"POSITION,NORMAL,TANGENT,BINORMAL,UV,UV1,BLENDWEIGHT,BLENDINDICES,": VertexPositionNTBTexture0Texture1Skin.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalTexture0Texture1SkinSTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalTexture0Texture1Skin.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalColorTextureSkinSTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalColorTextureSkin.vertexDeclaration, 
			"POSITION,NORMAL,UV,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalTextureSkinSTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalTextureSkin.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,BLENDWEIGHT,BLENDINDICES,TANGENT": VertexPositionNormalColorSkinSTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,BLENDWEIGHT,BLENDINDICES": VertexPositionNormalColorSkin.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,UV1,TANGENT": VertexPositionNormalColorTexture0Texture1STangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,UV1": VertexPositionNormalColorTexture0Texture1.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1,TANGENT": VertexPositionNormalTexture0Texture1STangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,UV1": VertexPositionNormalTexture0Texture1.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV,TANGENT": VertexPositionNormalColorTextureSTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV,TANGENT,BINORMAL": VertexPositionNTBTexture.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,UV": VertexPositionNormalColorTexture.vertexDeclaration, 
			"POSITION,NORMAL,UV,TANGENT": VertexPositionNormalTextureSTangent.vertexDeclaration, 
			"POSITION,NORMAL,UV": VertexPositionNormalTexture.vertexDeclaration, 
			"POSITION,NORMAL,COLOR,TANGENT": VertexPositionNormalColorSTangent.vertexDeclaration, 
			"POSITION,NORMAL,COLOR": VertexPositionNormalColor.vertexDeclaration, 
			"POSITION,NORMAL,TANGENT": VertexPositionNormalSTangent.vertexDeclaration, 
			"POSITION,NORMAL": VertexPositionNormal.vertexDeclaration, 
			"POSITION,UV": VertexPositionTexture0.vertexDeclaration, 
			"POSITION": VertexPosition.vertexDeclaration};
			
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
		private static var _materialMap:Object;
		
		/**
		 * @private
		 */
		public static function parse(readData:Byte, version:String, mesh:Mesh, subMeshes:Vector.<SubMesh>, materialMap:Object):void {
			_mesh = mesh;
			_subMeshes = subMeshes;
			_materialMap = materialMap;
			_version = version;
			_readData = readData;
			READ_DATA();
			READ_BLOCK();
			READ_STRINGS();
			for (var i:int = 0, n:int = _BLOCK.count; i < n; i++) {
				_readData.pos = _BLOCK.blockStarts[i];
				var index:int = _readData.getUint16();
				var blockName:String = _strings[index];
				var fn:Function = LoadModelV03["READ_" + blockName];
				if (fn == null)
					throw new Error("model file err,no this function:" + index + " " + blockName);
				else
					fn.call();
			}
			
			_strings.length = 0;
			_readData = null;
			_version = null;
			_mesh = null;
			_subMeshes = null;
			_materialMap = null;
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
			var name:String = _readString();
			
			var arrayBuffer:ArrayBuffer = _readData.__getBuffer();
			var i:int, n:int;
			
			var vertexBufferCount:uint = _readData.getInt16();
			var offset:int = _DATA.offset;
			for (i = 0; i < vertexBufferCount; i++) {
				var vbStart:uint = offset + _readData.getUint32();
				var vbLength:uint = _readData.getUint32();
				var vbDatas:Float32Array = new Float32Array(arrayBuffer.slice(vbStart, vbStart + vbLength));
				var bufferAttribute:String = _readString();
				var vertexDeclaration:VertexDeclaration;
				switch(_version){
					case "LAYAMODEL:03":
						vertexDeclaration= _vertexDeclarationMap_Discard[bufferAttribute];
						break;
					case "LAYAMODEL:0301":
						vertexDeclaration= _vertexDeclarationMap[bufferAttribute];
						break;
					default:
						throw new Error("LoadModelV03: unknown version.");
				}
					
				if (!vertexDeclaration)
					throw new Error("LoadModelV03: unknown vertexDeclaration.");
				
				var vertexBuffer:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, (vbDatas.length * 4) / vertexDeclaration.vertexStride, WebGLContext.STATIC_DRAW, true);
				vertexBuffer.setData(vbDatas);
				_mesh._vertexBuffers.push(vertexBuffer);
			}
			
			var ibStart:uint = offset + _readData.getUint32();
			var ibLength:uint = _readData.getUint32();
			var ibDatas:Uint16Array = new Uint16Array(arrayBuffer.slice(ibStart, ibStart + ibLength));
			var indexBuffer:IndexBuffer3D = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, ibLength / 2, WebGLContext.STATIC_DRAW, true);
			indexBuffer.setData(ibDatas);
			_mesh._indexBuffer = indexBuffer;
			
			var boneNames:Vector.<String> = _mesh._boneNames = new Vector.<String>();
			var boneCount:uint = _readData.getUint16();
			boneNames.length = boneCount;
			for (i = 0; i < boneCount; i++)
				boneNames[i] = _strings[_readData.getUint16()];
			
			_readData.pos += 8;//TODO:优化
			
			var inverseGlobalBindPoseStart:uint = _readData.getUint32();
			var inverseGlobalBinPoseLength:uint = _readData.getUint32();
			var invGloBindPoseDatas:Float32Array = new Float32Array(arrayBuffer.slice(offset + inverseGlobalBindPoseStart, offset + inverseGlobalBindPoseStart + inverseGlobalBinPoseLength));
			_mesh._inverseBindPoses = new Vector.<Matrix4x4>();
			for (i = 0, n = invGloBindPoseDatas.length; i < n; i += 16) {
				var inverseGlobalBindPose:Matrix4x4 = new Matrix4x4(invGloBindPoseDatas[i + 0], invGloBindPoseDatas[i + 1], invGloBindPoseDatas[i + 2], invGloBindPoseDatas[i + 3], invGloBindPoseDatas[i + 4], invGloBindPoseDatas[i + 5], invGloBindPoseDatas[i + 6], invGloBindPoseDatas[i + 7], invGloBindPoseDatas[i + 8], invGloBindPoseDatas[i + 9], invGloBindPoseDatas[i + 10], invGloBindPoseDatas[i + 11], invGloBindPoseDatas[i + 12], invGloBindPoseDatas[i + 13], invGloBindPoseDatas[i + 14], invGloBindPoseDatas[i + 15]);
				_mesh._inverseBindPoses.push(inverseGlobalBindPose);
			}
			_mesh._skinnedDatas = new Float32Array(invGloBindPoseDatas.length*16);
			
			//trace("READ_MESH:" + name);
			return true;
		}
		
		/**
		 * @private
		 */
		private static function READ_SUBMESH():Boolean {
			var arrayBuffer:ArrayBuffer = _readData.__getBuffer();
			var submesh:SubMesh = new SubMesh(_mesh);
			
			var vbIndex:int = _readData.getInt16();
			var vbStart:int = _readData.getUint32();
			var vbLength:int = _readData.getUint32();
			submesh._vertexBuffer = _mesh._vertexBuffers[vbIndex];
			submesh._vertexStart = vbStart;
			submesh._vertexCount = vbLength;
			
			var ibStart:int = _readData.getUint32();
			var ibCount:int = _readData.getUint32();
			var indexBuffer:IndexBuffer3D = _mesh._indexBuffer;
			submesh._indexBuffer = indexBuffer;
			submesh._indexStart = ibStart;
			submesh._indexCount = ibCount;
			submesh._indices = new Uint16Array(indexBuffer.getData().buffer, ibStart * 2, ibCount);
			
			var offset:int = _DATA.offset;
			var subIndexBufferStart:Vector.<int> = submesh._subIndexBufferStart;
			var subIndexBufferCount:Vector.<int> = submesh._subIndexBufferCount;
			var boneIndicesList:Vector.<Uint8Array> = submesh._boneIndicesList;
			var drawCount:int = _readData.getUint16();
			subIndexBufferStart.length = drawCount;
			subIndexBufferCount.length = drawCount;
			boneIndicesList.length = drawCount;
			for (var i:int = 0; i < drawCount; i++) {
				subIndexBufferStart[i] = _readData.getUint32();
				subIndexBufferCount[i] = _readData.getUint32();
				var boneDicofs:int = _readData.getUint32();
				var boneDicsize:int = _readData.getUint32();
				boneIndicesList[i] = new Uint8Array(arrayBuffer.slice(offset + boneDicofs, offset + boneDicofs + boneDicsize));
			}
			
			
			_subMeshes.push(submesh);
			return true;
		}
	
	}

}