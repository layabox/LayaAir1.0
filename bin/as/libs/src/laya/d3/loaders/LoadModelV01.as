package laya.d3.loaders {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexPositionNTBTexture;
	import laya.d3.graphics.VertexPositionNTBTextureSkin;
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
	public class LoadModelV01 {
		/**@private */
		private static var _attrReg:RegExp =/*[STATIC SAFE]*/ new RegExp("(\\w+)|([:,;])", "g");//切割字符串正则
		
		/**@private */
		private var _version:String;
		/**@private */
		private var _strings:Array = ['BLOCK', 'DATA', "STRINGS"];//字符串数组
		/**@private */
		private var _materials:Vector.<BaseMaterial>;
		/**@private */
		private var _subMeshes:Vector.<SubMesh>;
		/**@private */
		private var _materialMap:Object;
		/**@private */
		private var _readData:Byte;
		/**@private */
		private var _mesh:Mesh;
		/**@private */
		private var _BLOCK:Object = {count: 0};
		/**@private */
		private var _DATA:Object = {offset: 0, size: 0};
		/**@private */
		private var _STRINGS:Object = {offset: 0, size: 0};
		/**@private */
		private var _shaderAttributes:Array;
		
		public function get mesh():Mesh {
			return _mesh;
		}
		
		/**
		 * 创建一个 <code>LoadModel</code> 实例。
		 */
		public function LoadModelV01(readData:Byte, version:String, mesh:Mesh, materials:Vector.<BaseMaterial>, subMeshes:Vector.<SubMesh>, materialMap:Object) {
			_mesh = mesh;
			_materials = materials;
			_subMeshes = subMeshes;
			_materialMap = materialMap;
			_version = version;
			_onLoaded(readData);
		}
		
		/**
		 * @private
		 */
		private function _onLoaded(readData:Byte):Mesh {
			_readData = readData;
			READ_BLOCK();
			
			for (var i:int = 0; i < _BLOCK.count; i++) {
				var index:int = _readData.getUint16();
				var blockName:String = _strings[index];
				var fn:Function = this["READ_" + blockName];
				if (fn == null) throw new Error("model file err,no this function:" + index + " " + blockName);
				//trace("--------------call:" + "READ_" + blockName);
				if (!fn.call(this)) break;
			}
			return _mesh;
		}
		
		public function onError():void {
		}
		
		/**
		 * @private
		 */
		private function _readString():String {
			return _strings[_readData.getUint16()];
		}
		
		public function READ_BLOCK():Boolean {
			var n:int = _readData.getUint16();
			_BLOCK.count = _readData.getUint16();
			return true;
		}
		
		public function READ_DATA():Boolean {
			_DATA.offset = _readData.getUint32();
			_DATA.size = _readData.getUint32();
			return true;
		}
		
		public function READ_STRINGS():Boolean {
			_STRINGS.offset = _readData.getUint16();
			_STRINGS.size = _readData.getUint16();
			var ofs:int = _readData.pos;
			_readData.pos = _STRINGS.offset + _DATA.offset;
			
			for (var i:int = 0; i < _STRINGS.size; i++) {
				_strings[i] = _readData.readUTFString();
					//trace("string:" + i + "  " + _strings[i]);
			}
			_readData.pos = ofs;
			return true;
		}
		
		public function READ_MATERIAL():Boolean {
			var i:int, n:int;
			var index:int = _readData.getUint16();
			
			var shaderName:String = _readString();
			var url:String = _readString();
			if (url !== "null")
				_materials[index] = Loader.getRes(_materialMap[url]);
			else
				_materials[index] = new BaseMaterial();
			//trace("MATERIAL:" + index + " " + materialPath);
			return true;
		}
		
		public function READ_MESH():Boolean {
			var name:String = _readString();
			
			switch (_version) {
			case "LAYAMODEL:01": 
				trace("Warning: The (.lm) file is converted by old fbxTools,please reConverted it use  lastest fbxTools version,later we will remove the  support of old version (.lm) support.");
				break;
			case "LAYASKINANI:01": 
			case "LAYAMODEL:02": 
				var arrayBuffer:ArrayBuffer = _readData.__getBuffer();
				var i:int, n:int;
				var bindPoseStart:uint = _readData.getUint32();
				var binPoseLength:uint = _readData.getUint32();
				var bindPoseDatas:Float32Array = new Float32Array(arrayBuffer.slice(bindPoseStart + _DATA.offset, bindPoseStart + _DATA.offset + binPoseLength));
				var inverseGlobalBindPoseStart:uint = _readData.getUint32();
				var inverseGlobalBinPoseLength:uint = _readData.getUint32();
				var invGloBindPoseDatas:Float32Array = new Float32Array(arrayBuffer.slice(inverseGlobalBindPoseStart + _DATA.offset, inverseGlobalBindPoseStart + _DATA.offset + inverseGlobalBinPoseLength));
				mesh._inverseBindPoses = new Vector.<Matrix4x4>();
				for (i = 0, n = invGloBindPoseDatas.length; i < n; i += 16) {
					var inverseGlobalBindPose:Matrix4x4 = new Matrix4x4(invGloBindPoseDatas[i + 0], invGloBindPoseDatas[i + 1], invGloBindPoseDatas[i + 2], invGloBindPoseDatas[i + 3], invGloBindPoseDatas[i + 4], invGloBindPoseDatas[i + 5], invGloBindPoseDatas[i + 6], invGloBindPoseDatas[i + 7], invGloBindPoseDatas[i + 8], invGloBindPoseDatas[i + 9], invGloBindPoseDatas[i + 10], invGloBindPoseDatas[i + 11], invGloBindPoseDatas[i + 12], invGloBindPoseDatas[i + 13], invGloBindPoseDatas[i + 14], invGloBindPoseDatas[i + 15]);
					mesh._inverseBindPoses.push(inverseGlobalBindPose);
				}
				break;
			default: 
				throw new Error("LoadModel:unknown version.");
			}
			
			//trace("READ_MESH:" + name);
			return true;
		}
		
		public function READ_SUBMESH():Boolean {
			var className:String = _readString();
			var material:int = _readData.getUint8();//TODO:可取消
			
			var bufferAttribute:String = _readString();
			_shaderAttributes = bufferAttribute.match(_attrReg);
			
			var ibofs:int = _readData.getUint32();
			var ibsize:int = _readData.getUint32();
			var vbIndicesofs:int = _readData.getUint32();
			var vbIndicessize:int = _readData.getUint32();
			var vbofs:int = _readData.getUint32();
			var vbsize:int = _readData.getUint32();
			var boneDicofs:int = _readData.getUint32();
			var boneDicsize:int = _readData.getUint32();
			var arrayBuffer:ArrayBuffer = _readData.__getBuffer();
			//trace("SUBMESH:ibofs=" + ibofs + "  ibsize=" + ibsize + "  vbofs=" + vbofs + " vbsize=" + vbsize + "  boneDicofs=" + boneDicofs + " boneDicsize=" + boneDicsize + " " + bufferAttribute);
			var submesh:SubMesh = new SubMesh(_mesh);
			var vertexDeclaration:VertexDeclaration = _getVertexDeclaration();
			
			var vb:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, vbsize / vertexDeclaration.vertexStride, WebGLContext.STATIC_DRAW, true);
			var vbStart:int = vbofs + _DATA.offset;
			
			var vbArrayBuffer:ArrayBuffer = arrayBuffer.slice(vbStart, vbStart + vbsize);
			
			vb.setData(new Float32Array(vbArrayBuffer));
			submesh._vertexBuffer = vb;
			
			var vertexElements:Array = vb.vertexDeclaration.getVertexElements();
			for (var i:int = 0; i < vertexElements.length; i++)
				submesh._bufferUsage[(vertexElements[i] as VertexElement).elementUsage] = vb;
			
			var ib:IndexBuffer3D = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, ibsize / 2, WebGLContext.STATIC_DRAW, true);
			var ibStart:int = ibofs + _DATA.offset;
			var ibArrayBuffer:ArrayBuffer = arrayBuffer.slice(ibStart, ibStart + ibsize);
			ib.setData(new Uint16Array(ibArrayBuffer));
			submesh._indexBuffer = ib;
			
			var boneDicArrayBuffer:ArrayBuffer = arrayBuffer.slice(boneDicofs + _DATA.offset, boneDicofs + _DATA.offset + boneDicsize);
			submesh._boneIndicesList[0] = new Uint8Array(boneDicArrayBuffer);//兼容性代码
			
			_subMeshes.push(submesh);
			
			return true;
		}
		
		public function READ_DATAAREA():Boolean {
			return false;
		}
		
		private function _getVertexDeclaration():VertexDeclaration {
			var position:Boolean, normal:Boolean, color:Boolean, texcoord0:Boolean, texcoord1:Boolean, tangent:Boolean, blendWeight:Boolean, blendIndex:Boolean;
			var binormal:Boolean = false;
			for (var i:int = 0; i < _shaderAttributes.length; i += 8) {
				switch (_shaderAttributes[i]) {
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
			else if (position && normal && tangent && binormal && texcoord0 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNTBTextureSkin.vertexDeclaration;
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