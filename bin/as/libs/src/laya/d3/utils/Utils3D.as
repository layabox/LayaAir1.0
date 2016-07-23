package laya.d3.utils {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexPositionNormalColorSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureTangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalTextureTangent;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.net.URL;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>Utils3D</code> 类用于创建3D工具。
	 */
	public class Utils3D {
		/** @private */
		private static const _typeToFunO:Object = {"INT16": "writeInt16", "SHORT": "writeInt16", "UINT16": "writeUint16", "UINT32": "writeUint32", "FLOAT32": "writeFloat32", "INT": "writeInt32", "UINT": "writeUint32", "BYTE": "writeByte", "STRING": "writeUTFString"};
		
		/** @private */
		private static var _tempVector3_0:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_1:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_2:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_3:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_4:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_5:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		/** @private */
		private static var _tempVector3_6:Vector3 = /*[STATIC SAFE]*/ new Vector3();
		
		/** @private */
		private static var _tempArray4_0:Float32Array = /*[STATIC SAFE]*/ new Float32Array(4);
		/** @private */
		private static var _tempArray16_0:Float32Array = /*[STATIC SAFE]*/ new Float32Array(16);
		/** @private */
		private static var _tempArray16_1:Float32Array = /*[STATIC SAFE]*/ new Float32Array(16);
		/** @private */
		private static var _tempArray16_2:Float32Array = /*[STATIC SAFE]*/ new Float32Array(16);
		/** @private */
		private static var _tempArray16_3:Float32Array =  /*[STATIC SAFE]*/ new Float32Array(16);
		
		/** @private */
		private static function _getTexturePath(path:String):String {
			var extenIndex:int = path.length - 4;
			if (path.indexOf(".dds") == extenIndex || path.indexOf(".tga") == extenIndex || path.indexOf(".exr") == extenIndex || path.indexOf(".DDS") == extenIndex || path.indexOf(".TGA") == extenIndex || path.indexOf(".EXR") == extenIndex)
				path = path.substr(0, extenIndex) + ".png";
			
			return path = URL.formatURL(path);
		}
		
		/** @private */
		public static function GenerateTangent(vertexDatas:Float32Array, vertexStride:int, positionOffset:int, uvOffset:int, indices:Uint16Array/*还有UNIT8类型*/):Float32Array {
			const tangentElementCount:int = 3;
			var newVertexStride:int = vertexStride + tangentElementCount;
			var tangentVertexDatas:Float32Array = new Float32Array(newVertexStride * (vertexDatas.length / vertexStride));
			
			for (var i:int = 0; i < indices.length; i += 3) {
				var index1:uint = indices[i + 0];
				var index2:uint = indices[i + 1];
				var index3:uint = indices[i + 2];
				
				var position1Offset:int = vertexStride * index1 + positionOffset;
				var position1:Vector3 = _tempVector3_0;
				position1.x = vertexDatas[position1Offset + 0];
				position1.y = vertexDatas[position1Offset + 1];
				position1.z = vertexDatas[position1Offset + 2];
				
				var position2Offset:int = vertexStride * index2 + positionOffset;
				var position2:Vector3 = _tempVector3_1;
				position2.x = vertexDatas[position2Offset + 0];
				position2.y = vertexDatas[position2Offset + 1];
				position2.z = vertexDatas[position2Offset + 2];
				
				var position3Offset:int = vertexStride * index3 + positionOffset;
				var position3:Vector3 = _tempVector3_2;
				position3.x = vertexDatas[position3Offset + 0];
				position3.y = vertexDatas[position3Offset + 1];
				position3.z = vertexDatas[position3Offset + 2];
				
				var uv1Offset:int = vertexStride * index1 + uvOffset;
				var UV1X:Number = vertexDatas[uv1Offset + 0];
				var UV1Y:Number = vertexDatas[uv1Offset + 1];
				
				var uv2Offset:int = vertexStride * index2 + uvOffset;
				var UV2X:Number = vertexDatas[uv2Offset + 0];
				var UV2Y:Number = vertexDatas[uv2Offset + 1];
				
				var uv3Offset:int = vertexStride * index3 + uvOffset;
				var UV3X:Number = vertexDatas[uv3Offset + 0];
				var UV3Y:Number = vertexDatas[uv3Offset + 1];
				
				var lengthP2ToP1:Vector3 = _tempVector3_3;
				Vector3.subtract(position2, position1, lengthP2ToP1);
				var lengthP3ToP1:Vector3 = _tempVector3_4;
				Vector3.subtract(position3, position1, lengthP3ToP1);
				
				Vector3.scale(lengthP2ToP1, UV3Y - UV1Y, lengthP2ToP1);
				Vector3.scale(lengthP3ToP1, UV2Y - UV1Y, lengthP3ToP1);
				
				var tangent:Vector3 = _tempVector3_5;
				Vector3.subtract(lengthP2ToP1, lengthP3ToP1, tangent);
				
				Vector3.scale(tangent, 1.0 / ((UV2X - UV1X) * (UV3Y - UV1Y) - (UV2Y - UV1Y) * (UV3X - UV1X)), tangent);
				
				var j:int;
				for (j = 0; j < vertexStride; j++)
					tangentVertexDatas[newVertexStride * index1 + j] = vertexDatas[vertexStride * index1 + j];
				for (j = 0; j < tangentElementCount; j++)
					tangentVertexDatas[newVertexStride * index1 + vertexStride + j] = +tangent.elements[j];
				
				for (j = 0; j < vertexStride; j++)
					tangentVertexDatas[newVertexStride * index2 + j] = vertexDatas[vertexStride * index2 + j];
				for (j = 0; j < tangentElementCount; j++)
					tangentVertexDatas[newVertexStride * index2 + vertexStride + j] = +tangent.elements[j];
				
				for (j = 0; j < vertexStride; j++)
					tangentVertexDatas[newVertexStride * index3 + j] = vertexDatas[vertexStride * index3 + j];
				for (j = 0; j < tangentElementCount; j++)
					tangentVertexDatas[newVertexStride * index3 + vertexStride + j] = +tangent.elements[j];
				
					//tangent = ((UV3.Y - UV1.Y) * (position2 - position1) - (UV2.Y - UV1.Y) * (position3 - position1))/ ((UV2.X - UV1.X) * (UV3.Y - UV1.Y) - (UV2.Y - UV1.Y) * (UV3.X - UV1.X));
			}
			
			for (i = 0; i < tangentVertexDatas.length; i += newVertexStride) {
				var tangentStartIndex:int = newVertexStride * i + vertexStride;
				var t:Vector3 = _tempVector3_6;
				t.x = tangentVertexDatas[tangentStartIndex + 0];
				t.y = tangentVertexDatas[tangentStartIndex + 1];
				t.z = tangentVertexDatas[tangentStartIndex + 2];
				
				Vector3.normalize(t, t);
				tangentVertexDatas[tangentStartIndex + 0] = t.x;
				tangentVertexDatas[tangentStartIndex + 1] = t.y;
				tangentVertexDatas[tangentStartIndex + 2] = t.z;
			}
			
			return tangentVertexDatas;
		}
		
		public static function getVertexTangentDeclaration(vertexElements:Array):VertexDeclaration {
			var position:Boolean, normal:Boolean, color:Boolean, texcoord:Boolean, blendWeight:Boolean, blendIndex:Boolean;
			for (var i:int = 0; i < vertexElements.length; i++) {
				switch ((vertexElements[i] as VertexElement).elementUsage) {
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
					texcoord = true;
					break;
				case "BLENDWEIGHT": 
					blendWeight = true;
					break;
				case "BLENDINDICES": 
					blendIndex = true;
					break;
				}
			}
			var vertexDeclaration:VertexDeclaration;
			
			if (position && normal && color && texcoord && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord)
				vertexDeclaration = VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord)
				vertexDeclaration = VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && color)
				vertexDeclaration = VertexPositionNormalColorTangent.vertexDeclaration;
			
			return vertexDeclaration;
		}
		
		/** @private */
		public static function _parseHierarchyProp(node:Sprite3D, prop:String, value:Array):void {
			switch (prop) {
			case "translate": 
				node.transform.localPosition = new Vector3(value[0], value[1], value[2]);
				break;
			case "rotation": 
				node.transform.localRotation = new Quaternion(value[0], value[1], value[2], value[3]);
				break;
			case "scale": 
				node.transform.localScale = new Vector3(value[0], value[1], value[2]);
				break;
			}
		}
		
		/** @private */
		public static function _parseHierarchyNode(instanceParams:Object):Sprite3D {
			if (instanceParams)
				return new MeshSprite3D(Mesh.load(instanceParams.loadPath));
			else
				return new Sprite3D();
		}
		
		/** @private */
		public static function _parseMaterial(material:Material, prop:String, value:Array):void {
			switch (prop) {
			case "ambientColor": 
				material.ambientColor = new Vector3(value[0], value[1], value[2]);
				break;
			case "diffuseColor": 
				material.diffuseColor = new Vector3(value[0], value[1], value[2]);
				break;
			case "specularColor": 
				material.specularColor = new Vector4(value[0], value[1], value[2], value[3]);
				break;
			case "reflectColor": 
				material.reflectColor = new Vector3(value[0], value[1], value[2]);
				break;
			
			case "diffuseTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture):void {
					(tex.bitmap as WebGLImage).enableMerageInAtlas = false;
					(tex.bitmap as WebGLImage).mipmap = true;
					(tex.bitmap as WebGLImage).repeat = true;
					material.diffuseTexture = tex;
				})));
				break;
			case "normalTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture):void {
					(tex.bitmap as WebGLImage).enableMerageInAtlas = false;
					(tex.bitmap as WebGLImage).mipmap = true;
					(tex.bitmap as WebGLImage).repeat = true;
					material.normalTexture = tex;
				})));
				break;
			case "specularTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture):void {
					(tex.bitmap as WebGLImage).enableMerageInAtlas = false;
					(tex.bitmap as WebGLImage).mipmap = true;
					(tex.bitmap as WebGLImage).repeat = true;
					material.specularTexture = tex;
				})));
				break;
			case "emissiveTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture):void {
					(tex.bitmap as WebGLImage).enableMerageInAtlas = false;
					(tex.bitmap as WebGLImage).mipmap = true;
					(tex.bitmap as WebGLImage).repeat = true;
					material.emissiveTexture = tex;
				})));
				break;
			case "ambientTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture):void {
					(tex.bitmap as WebGLImage).enableMerageInAtlas = false;
					(tex.bitmap as WebGLImage).mipmap = true;
					(tex.bitmap as WebGLImage).repeat = true;
					material.ambientTexture = tex;
				})));
				break;
			case "reflectTexture": 
				(value.texture2D) && (Laya.loader.load(_getTexturePath(value.texture2D), Handler.create(null, function(tex:Texture):void {
					(tex.bitmap as WebGLImage).enableMerageInAtlas = false;
					(tex.bitmap as WebGLImage).mipmap = true;
					(tex.bitmap as WebGLImage).repeat = true;
					material.reflectTexture = tex;
				})));
				break;
			}
		}
		
		/** @private */
		public static function _computeSkinAnimationData(bones:*, curData:Float32Array, exData:Float32Array, bonesDatas:Float32Array, animationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var offset:int = 0;
			var matOffset:int = 0;
			
			var len:int = exData.length / 2;
			var i:int;
			var parentOffset:int;
			var boneLength:int = bones.length;
			
			for (i = 0; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++) {
				//将旋转平移缩放合成矩阵...........................................
				Utils3D.rotationTransformScale(curData[offset + 7], curData[offset + 8], curData[offset + 9], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 0], curData[offset + 1], curData[offset + 2], bonesDatas, matOffset);
				
				if (i != 0) {
					parentOffset = bones[i].parentIndex * 16;
					Utils3D.mulMatrixByArray(bonesDatas, parentOffset, bonesDatas, matOffset, bonesDatas, matOffset);
				}
			}
			
			for (i = 0; i < len; i += 16) {
				//将绝对矩阵乘以反置矩阵................................................
				Utils3D.mulMatrixByArrayFast(bonesDatas, i, exData, len + i, animationDatas, i);
			}
		}
		
		/**
		 *通过数组数据计算矩阵乘法。
		 * @param leftArray left矩阵数组。
		 * @param leftOffset left矩阵数组的偏移。
		 * @param rightArray right矩阵数组。
		 * @param rightOffset right矩阵数组的偏移。
		 * @param outArray 输出矩阵数组。
		 * @param outOffset 输出矩阵数组的偏移。
		 */
		public static function mulMatrixByArray(leftArray:Float32Array, leftOffset:int, rightArray:Float32Array, rightOffset:int, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			
			if (outArray === rightArray) {
				rightArray = _tempArray16_3;
				for (i = 0; i < 16; ++i) {
					rightArray[i] = outArray[outOffset + i];
				}
				rightOffset = 0;
			}
			
			for (i = 0; i < 4; i++) {
				ai0 = leftArray[leftOffset + i];
				ai1 = leftArray[leftOffset + i + 4];
				ai2 = leftArray[leftOffset + i + 8];
				ai3 = leftArray[leftOffset + i + 12];
				outArray[outOffset + i] = ai0 * rightArray[rightOffset + 0] + ai1 * rightArray[rightOffset + 1] + ai2 * rightArray[rightOffset + 2] + ai3 * rightArray[rightOffset + 3];
				outArray[outOffset + i + 4] = ai0 * rightArray[rightOffset + 4] + ai1 * rightArray[rightOffset + 5] + ai2 * rightArray[rightOffset + 6] + ai3 * rightArray[rightOffset + 7];
				outArray[outOffset + i + 8] = ai0 * rightArray[rightOffset + 8] + ai1 * rightArray[rightOffset + 9] + ai2 * rightArray[rightOffset + 10] + ai3 * rightArray[rightOffset + 11];
				outArray[outOffset + i + 12] = ai0 * rightArray[rightOffset + 12] + ai1 * rightArray[rightOffset + 13] + ai2 * rightArray[rightOffset + 14] + ai3 * rightArray[rightOffset + 15];
			}
		}
		
		/**
		 *通过数组数据计算矩阵乘法,rightArray和outArray不能为同一数组引用。
		 * @param leftArray left矩阵数组。
		 * @param leftOffset left矩阵数组的偏移。
		 * @param rightArray right矩阵数组。
		 * @param rightOffset right矩阵数组的偏移。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function mulMatrixByArrayFast(leftArray:Float32Array, leftOffset:int, rightArray:Float32Array, rightOffset:int, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			for (i = 0; i < 4; i++) {
				ai0 = leftArray[leftOffset + i];
				ai1 = leftArray[leftOffset + i + 4];
				ai2 = leftArray[leftOffset + i + 8];
				ai3 = leftArray[leftOffset + i + 12];
				outArray[outOffset + i] = ai0 * rightArray[rightOffset + 0] + ai1 * rightArray[rightOffset + 1] + ai2 * rightArray[rightOffset + 2] + ai3 * rightArray[rightOffset + 3];
				outArray[outOffset + i + 4] = ai0 * rightArray[rightOffset + 4] + ai1 * rightArray[rightOffset + 5] + ai2 * rightArray[rightOffset + 6] + ai3 * rightArray[rightOffset + 7];
				outArray[outOffset + i + 8] = ai0 * rightArray[rightOffset + 8] + ai1 * rightArray[rightOffset + 9] + ai2 * rightArray[rightOffset + 10] + ai3 * rightArray[rightOffset + 11];
				outArray[outOffset + i + 12] = ai0 * rightArray[rightOffset + 12] + ai1 * rightArray[rightOffset + 13] + ai2 * rightArray[rightOffset + 14] + ai3 * rightArray[rightOffset + 15];
			}
		}
		
		/**
		 *通过数平移、旋转、缩放值计算到结果矩阵数组。
		 * @param tx left矩阵数组。
		 * @param ty left矩阵数组的偏移。
		 * @param tz right矩阵数组。
		 * @param qx right矩阵数组的偏移。
		 * @param qy 输出矩阵数组。
		 * @param qz 输出矩阵数组的偏移。
		 * @param qw 输出矩阵数组的偏移。
		 * @param sx 输出矩阵数组的偏移。
		 * @param sy 输出矩阵数组的偏移。
		 * @param sz 输出矩阵数组的偏移。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function rotationTransformScale(tx:Number, ty:Number, tz:Number, qx:Number, qy:Number, qz:Number, qw:Number, sx:Number, sy:Number, sz:Number, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var re:Float32Array = _tempArray16_0;
			var se:Float32Array = _tempArray16_1;
			var tse:Float32Array = _tempArray16_2;
			
			//平移
			
			//旋转
			var x2:Number = qx + qx;
			var y2:Number = qy + qy;
			var z2:Number = qz + qz;
			
			var xx:Number = qx * x2;
			var yx:Number = qy * x2;
			var yy:Number = qy * y2;
			var zx:Number = qz * x2;
			var zy:Number = qz * y2;
			var zz:Number = qz * z2;
			var wx:Number = qw * x2;
			var wy:Number = qw * y2;
			var wz:Number = qw * z2;
			
			//re[3] = re[7] = re[11] = re[12] = re[13] = re[14] = 0;
			re[15] = 1;
			re[0] = 1 - yy - zz;
			re[1] = yx + wz;
			re[2] = zx - wy;
			
			re[4] = yx - wz;
			re[5] = 1 - xx - zz;
			re[6] = zy + wx;
			
			re[8] = zx + wy;
			re[9] = zy - wx;
			re[10] = 1 - xx - yy;
			
			//缩放
			//se[4] = se[8] = se[12] = se[1] = se[9] = se[13] = se[2] = se[6] = se[14] = se[3] = se[7] = se[11] = 0;
			se[15] = 1;
			se[0] = sx;
			se[5] = sy;
			se[10] = sz;
			
			var i:int, a:Float32Array, b:Float32Array, e:Float32Array, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			
			//mul(rMat, tMat, tsMat)......................................
			for (i = 0; i < 4; i++) {
				ai0 = re[i];
				ai1 = re[i + 4];
				ai2 = re[i + 8];
				ai3 = re[i + 12];
				tse[i] = ai0;
				tse[i + 4] = ai1;
				tse[i + 8] = ai2;
				tse[i + 12] = ai0 * tx + ai1 * ty + ai2 * tz + ai3;
			}
			
			//mul(tsMat, sMat, out)..............................................
			for (i = 0; i < 4; i++) {
				ai0 = tse[i];
				ai1 = tse[i + 4];
				ai2 = tse[i + 8];
				ai3 = tse[i + 12];
				outArray[i + outOffset] = ai0 * se[0] + ai1 * se[1] + ai2 * se[2] + ai3 * se[3];
				outArray[i + outOffset + 4] = ai0 * se[4] + ai1 * se[5] + ai2 * se[6] + ai3 * se[7];
				outArray[i + outOffset + 8] = ai0 * se[8] + ai1 * se[9] + ai2 * se[10] + ai3 * se[11];
				outArray[i + outOffset + 12] = ai0 * se[12] + ai1 * se[13] + ai2 * se[14] + ai3 * se[15];
			}
		}
		
		/**
		 * 通过矩阵转换一个三维向量数组到另外一个归一化的三维向量数组。
		 * @param	source 源三维向量所在数组。
		 * @param	sourceOffset 源三维向量数组偏移。
		 * @param	transform  变换矩阵。
		 * @param	result 输出三维向量所在数组。
		 * @param	resultOffset 输出三维向量数组偏移。
		 */
		public static function transformVector3ArrayToVector3ArrayCoordinate(source:Float32Array, sourceOffset:int, transform:Matrix4x4, result:Float32Array, resultOffset:int):void {
			var vectorElem:Float32Array = _tempArray4_0;
			
			//var coordinateElem:Float32Array = coordinate.elements;
			var coordinateX:Number = source[sourceOffset + 0];
			var coordinateY:Number = source[sourceOffset + 1];
			var coordinateZ:Number = source[sourceOffset + 2];
			
			var transformElem:Float32Array = transform.elements;
			
			vectorElem[0] = (coordinateX * transformElem[0]) + (coordinateY * transformElem[4]) + (coordinateZ * transformElem[8]) + transformElem[12];
			vectorElem[1] = (coordinateX * transformElem[1]) + (coordinateY * transformElem[5]) + (coordinateZ * transformElem[9]) + transformElem[13];
			vectorElem[2] = (coordinateX * transformElem[2]) + (coordinateY * transformElem[6]) + (coordinateZ * transformElem[10]) + transformElem[14];
			vectorElem[3] = 1.0 / ((coordinateX * transformElem[3]) + (coordinateY * transformElem[7]) + (coordinateZ * transformElem[11]) + transformElem[15]);
			
			//var resultElem:Float32Array = result.elements;
			result[resultOffset + 0] = vectorElem[0] * vectorElem[3];
			result[resultOffset + 1] = vectorElem[1] * vectorElem[3];
			result[resultOffset + 2] = vectorElem[2] * vectorElem[3];
		}
	
	}

}