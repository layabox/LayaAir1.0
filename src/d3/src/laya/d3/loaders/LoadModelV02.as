package laya.d3.loaders {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionNTBTexture;
	import laya.d3.graphics.VertexPositionNormalColor;
	import laya.d3.graphics.VertexPositionNormalColorSkin;
	import laya.d3.graphics.VertexPositionNormalColorSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Tangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkin;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureTangent;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinTangent;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1Tangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkin;
	import laya.d3.graphics.VertexPositionNormalTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalTextureTangent;
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
	public class LoadModelV02 {
		/**@private */
		private static var _attrReg:RegExp =/*[STATIC SAFE]*/ new RegExp("(\\w+)|([:,;])", "g");//切割字符串正则
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
		private static var _materials:Vector.<BaseMaterial>;
		/**@private */
		private static var _subMeshes:Vector.<SubMesh>;
		/**@private */
		private static var _materialMap:Object;
		
		/**
		 * @private
		 */
		public static function parse(readData:Byte, version:String, mesh:Mesh, materials:Vector.<BaseMaterial>, subMeshes:Vector.<SubMesh>, materialMap:Object):void {
			_mesh = mesh;
			_materials = materials;
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
				var fn:Function = LoadModelV02["READ_" + blockName];
				if (fn == null)
					throw new Error("model file err,no this function:" + index + " " + blockName);
				else
					fn.call();
			}
			
			_strings.length = 0;
			_readData = null;
			_version = null;
			_mesh = null;
			_materials = null;
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
		private static function READ_MATERIAL():Boolean {
			var i:int, n:int;
			var clasName:String = _readString();//TODO:
			var shaderName:String = _readString();
			var url:String = _readString();
			if (url !== "")
				_materials.push(Loader.getRes(_materialMap[url]));
			return true;
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
				var shaderAttributes:Array = bufferAttribute.match(_attrReg);
				var vertexDeclaration:VertexDeclaration = _getVertexDeclaration(shaderAttributes);
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
			
			var bindPoseStart:uint = _readData.getUint32();
			var binPoseLength:uint = _readData.getUint32();
			var bindPoseDatas:Float32Array = new Float32Array(arrayBuffer.slice(offset + bindPoseStart, offset + bindPoseStart + binPoseLength));
			
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
				submesh._boneIndicesList[i] = new Uint8Array(arrayBuffer.slice(offset + boneDicofs, offset + boneDicofs + boneDicsize));
			}
			
			_subMeshes.push(submesh);
			return true;
		}
		
		/**
		 * @private
		 */
		private static function _getVertexDeclaration(shaderAttributes:Array):VertexDeclaration {
			var position:Boolean, normal:Boolean, color:Boolean, texcoord0:Boolean, texcoord1:Boolean, tangent:Boolean, blendWeight:Boolean, blendIndex:Boolean;
			var binormal:Boolean = false;
			for (var i:int = 0; i < shaderAttributes.length; i++) {
				switch (shaderAttributes[i]) {
				case "POSITION": 
					position = true;
					break;
				case "NORMAL": 
					normal = true;
					break;
				case "COLOR": 
					color = true;
					break;
				case "UV": 
					texcoord0 = true;
					break;
				case "UV1": 
					texcoord1 = true;
					break;
				case "BLENDWEIGHT": 
					blendWeight = true;
					break;
				case "BLENDINDICES": 
					blendIndex = true;
					break;
				case "TANGENT": 
					tangent = true;
					break;
				case "BINORMAL": 
					binormal = true;
					break;
				}
			}
			var vertexDeclaration:VertexDeclaration;
			
			if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex && tangent)
				vertexDeclaration = VertexPositionNormalColorTexture0Texture1SkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex && tangent)
				vertexDeclaration = VertexPositionNormalTexture0Texture1SkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && blendWeight && blendIndex && tangent)
				vertexDeclaration = VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorTextureSkin.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex && tangent)
				vertexDeclaration = VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalTextureSkin.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex && tangent)
				vertexDeclaration = VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorSkin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1 && tangent)
				vertexDeclaration = VertexPositionNormalColorTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1)
				vertexDeclaration = VertexPositionNormalColorTexture0Texture1.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && tangent)
				vertexDeclaration = VertexPositionNormalTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1)
				vertexDeclaration = VertexPositionNormalTexture0Texture1.vertexDeclaration;
			else if (position && normal && color && texcoord0 && tangent)
				vertexDeclaration = VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && tangent && binormal)
				vertexDeclaration = VertexPositionNTBTexture.vertexDeclaration;
			else if (position && normal && color && texcoord0)
				vertexDeclaration = VertexPositionNormalColorTexture.vertexDeclaration;
			else if (position && normal && texcoord0 && tangent)
				vertexDeclaration = VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord0)
				vertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			else if (position && normal && color && tangent)
				vertexDeclaration = VertexPositionNormalColorTangent.vertexDeclaration;
			else if (position && normal && color)
				vertexDeclaration = VertexPositionNormalColor.vertexDeclaration;
			
			return vertexDeclaration;
		}
	
	}

}