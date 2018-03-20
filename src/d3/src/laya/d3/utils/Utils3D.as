package laya.d3.utils {
	import laya.d3.component.Animator;
	import laya.d3.core.Camera;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.MeshRender;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshRender;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.particleShuriKen.ShurikenParticleRender;
	import laya.d3.core.particleShuriKen.ShurikenParticleSystem;
	import laya.d3.core.particleShuriKen.module.Burst;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.Emission;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataColor;
	import laya.d3.core.particleShuriKen.module.GradientDataInt;
	import laya.d3.core.particleShuriKen.module.GradientDataNumber;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.GradientVelocity;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.StartFrame;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.core.particleShuriKen.module.shape.BoxShape;
	import laya.d3.core.particleShuriKen.module.shape.CircleShape;
	import laya.d3.core.particleShuriKen.module.shape.ConeShape;
	import laya.d3.core.particleShuriKen.module.shape.HemisphereShape;
	import laya.d3.core.particleShuriKen.module.shape.SphereShape;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.trail.TrailSprite3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.graphics.VertexPositionTexture0;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.d3.terrain.Terrain;
	import laya.display.Node;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.webgl.WebGLContext;
	
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
		
		/**
		 *通过数平移、旋转、缩放值计算到结果矩阵数组,骨骼动画专用。
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
		private static function _rotationTransformScaleSkinAnimation(tx:Number, ty:Number, tz:Number, qx:Number, qy:Number, qz:Number, qw:Number, sx:Number, sy:Number, sz:Number, outArray:Float32Array, outOffset:int):void {
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
		 * @private
		 */
		public static function _createNodeByJson(rootNode:ComponentNode, nodeData:Object, node:*, innerResouMap:Object):* {
			if (!node) {
				switch (nodeData.type) {
				case "Sprite3D": 
					node = new Sprite3D();
					break;
				case "MeshSprite3D": 
					node = new MeshSprite3D();
					break;
				case "SkinnedMeshSprite3D": 
					node = new SkinnedMeshSprite3D();
					break;
				case "ShuriKenParticle3D": 
					node = new ShuriKenParticle3D();
					break;
				case "TrailSprite3D":
					node = new TrailSprite3D();
					break;
				case "Terrain": 
					node = new Terrain();
					break;
				case "Camera": 
					node = new Camera();
					break;
				case "DirectionLight": 
					node = new DirectionLight();
					break;
				default: 
					throw new Error("Utils3D:unidentified class type in (.lh) file.");
				}
			}
			var props:Object = nodeData.props;
			if (props)
				for (var key:String in props)
					node[key] = props[key];
			
			var customProps:Object = nodeData.customProps;
			if (customProps) {
				if (node is Sprite3D) {
					node._parseBaseCustomProps(customProps);
					node._parseCustomProps(rootNode, innerResouMap, customProps, nodeData);//json为兼容参数，日后移除
					node._parseCustomComponent(rootNode, innerResouMap, nodeData.components);
				} else {
					node._parseCustomProps(rootNode, innerResouMap, customProps, nodeData);//json为兼容参数，日后移除
				}
			}
			
			var childData:Array = nodeData.child;
			if (childData) {
				for (var i:int = 0, n:int = childData.length; i < n; i++) {
					var child:* = _createNodeByJson(rootNode, childData[i], null, innerResouMap)
					node.addChild(child);
				}
			}
			return node;
		}
		
		/** @private */
		public static function _computeBoneAndAnimationDatasByBindPoseMatrxix(bones:*, curData:Float32Array, inverGlobalBindPose:Vector.<Matrix4x4>, outBonesDatas:Float32Array, outAnimationDatas:Float32Array, boneIndexToMesh:Vector.<int>):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var offset:int = 0;
			var matOffset:int = 0;
			
			var i:int;
			var parentOffset:int;
			var boneLength:int = bones.length;
			for (i = 0; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++) {
				//将旋转平移缩放合成矩阵...........................................
				Utils3D._rotationTransformScaleSkinAnimation(curData[offset + 0], curData[offset + 1], curData[offset + 2], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 7], curData[offset + 8], curData[offset + 9], outBonesDatas, matOffset);
				
				if (i != 0) {
					parentOffset = bones[i].parentIndex * 16;
					Utils3D.mulMatrixByArray(outBonesDatas, parentOffset, outBonesDatas, matOffset, outBonesDatas, matOffset);
				}
			}
			
			var n:int = inverGlobalBindPose.length;
			for (i = 0; i < n; i++)//将绝对矩阵乘以反置矩阵................................................
			{
				Utils3D.mulMatrixByArrayAndMatrixFast(outBonesDatas, boneIndexToMesh[i] * 16, inverGlobalBindPose[i], outAnimationDatas, i * 16);//TODO:-1处理
			}
		}
		
		/** @private */
		public static function _computeAnimationDatasByArrayAndMatrixFast(inverGlobalBindPose:Vector.<Matrix4x4>, bonesDatas:Float32Array, outAnimationDatas:Float32Array, boneIndexToMesh:Vector.<int>):void {
			for (var i:int = 0, n:int = inverGlobalBindPose.length; i < n; i++)//将绝对矩阵乘以反置矩阵
				Utils3D.mulMatrixByArrayAndMatrixFast(bonesDatas, boneIndexToMesh[i] * 16, inverGlobalBindPose[i], outAnimationDatas, i * 16);//TODO:-1处理
		}
		
		/** @private */
		public static function _computeBoneAndAnimationDatasByBindPoseMatrxixOld(bones:*, curData:Float32Array, inverGlobalBindPose:Vector.<Matrix4x4>, outBonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var offset:int = 0;
			var matOffset:int = 0;
			
			var i:int;
			var parentOffset:int;
			var boneLength:int = bones.length;
			for (i = 0; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++) {
				//将旋转平移缩放合成矩阵...........................................
				Utils3D._rotationTransformScaleSkinAnimation(curData[offset + 7], curData[offset + 8], curData[offset + 9], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 0], curData[offset + 1], curData[offset + 2], outBonesDatas, matOffset);
				
				if (i != 0) {
					parentOffset = bones[i].parentIndex * 16;
					Utils3D.mulMatrixByArray(outBonesDatas, parentOffset, outBonesDatas, matOffset, outBonesDatas, matOffset);
				}
			}
			
			var n:int = inverGlobalBindPose.length;
			for (i = 0; i < n; i++)//将绝对矩阵乘以反置矩阵................................................
			{
				var arrayOffset:Number = i * 16;
				Utils3D.mulMatrixByArrayAndMatrixFast(outBonesDatas, arrayOffset, inverGlobalBindPose[i], outAnimationDatas, arrayOffset);
			}
		}
		
		/** @private */
		public static function _computeAnimationDatasByArrayAndMatrixFastOld(inverGlobalBindPose:Vector.<Matrix4x4>, bonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			var n:int = inverGlobalBindPose.length;
			for (var i:int = 0; i < n; i++)//将绝对矩阵乘以反置矩阵................................................
			{
				var arrayOffset:Number = i * 16;
				Utils3D.mulMatrixByArrayAndMatrixFast(bonesDatas, arrayOffset, inverGlobalBindPose[i], outAnimationDatas, arrayOffset);
			}
		}
		
		/** @private */
		public static function _computeRootAnimationData(bones:*, curData:Float32Array, animationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			for (var i:int = 0, offset:int = 0, matOffset:int = 0, boneLength:int = bones.length; i < boneLength; offset += bones[i].keyframeWidth, matOffset += 16, i++)
				Utils3D.createAffineTransformationArray(curData[offset + 0], curData[offset + 1], curData[offset + 2], curData[offset + 3], curData[offset + 4], curData[offset + 5], curData[offset + 6], curData[offset + 7], curData[offset + 8], curData[offset + 9], animationDatas, matOffset);
		}
		
		/**
		 * 根据四元数旋转三维向量。
		 * @param	source 源三维向量。
		 * @param	rotation 旋转四元数。
		 * @param	out 输出三维向量。
		 */
		public static function transformVector3ArrayByQuat(sourceArray:Float32Array, sourceOffset:int, rotation:Quaternion, outArray:Float32Array, outOffset:int):void {
			var re:Float32Array = rotation.elements;
			var x:Number = sourceArray[sourceOffset], y:Number = sourceArray[sourceOffset + 1], z:Number = sourceArray[sourceOffset + 2], qx:Number = re[0], qy:Number = re[1], qz:Number = re[2], qw:Number = re[3], ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			outArray[outOffset] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
			outArray[outOffset + 1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
			outArray[outOffset + 2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;
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
		 *通过数组数据计算矩阵乘法,rightArray和outArray不能为同一数组引用。
		 * @param leftArray left矩阵数组。
		 * @param leftOffset left矩阵数组的偏移。
		 * @param rightMatrix right矩阵。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function mulMatrixByArrayAndMatrixFast(leftArray:Float32Array, leftOffset:int, rightMatrix:Matrix4x4, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			var rightMatrixE:Float32Array = rightMatrix.elements;
			var m11:Number = rightMatrixE[0], m12:Number = rightMatrixE[1], m13:Number = rightMatrixE[2], m14:Number = rightMatrixE[3];
			var m21:Number = rightMatrixE[4], m22:Number = rightMatrixE[5], m23:Number = rightMatrixE[6], m24:Number = rightMatrixE[7];
			var m31:Number = rightMatrixE[8], m32:Number = rightMatrixE[9], m33:Number = rightMatrixE[10], m34:Number = rightMatrixE[11];
			var m41:Number = rightMatrixE[12], m42:Number = rightMatrixE[13], m43:Number = rightMatrixE[14], m44:Number = rightMatrixE[15];
			var ai0LeftOffset:Number = leftOffset;
			var ai1LeftOffset:Number = leftOffset + 4;
			var ai2LeftOffset:Number = leftOffset + 8;
			var ai3LeftOffset:Number = leftOffset + 12;
			var ai0OutOffset:Number = outOffset;
			var ai1OutOffset:Number = outOffset + 4;
			var ai2OutOffset:Number = outOffset + 8;
			var ai3OutOffset:Number = outOffset + 12;
			
			for (i = 0; i < 4; i++) {
				ai0 = leftArray[ai0LeftOffset + i];
				ai1 = leftArray[ai1LeftOffset + i];
				ai2 = leftArray[ai2LeftOffset + i];
				ai3 = leftArray[ai3LeftOffset + i];
				outArray[ai0OutOffset + i] = ai0 * m11 + ai1 * m12 + ai2 * m13 + ai3 * m14;
				outArray[ai1OutOffset + i] = ai0 * m21 + ai1 * m22 + ai2 * m23 + ai3 * m24;
				outArray[ai2OutOffset + i] = ai0 * m31 + ai1 * m32 + ai2 * m33 + ai3 * m34;
				outArray[ai3OutOffset + i] = ai0 * m41 + ai1 * m42 + ai2 * m43 + ai3 * m44;
			}
		}
		
		/**
		 *通过数平移、旋转、缩放值计算到结果矩阵数组。
		 * @param tX left矩阵数组。
		 * @param tY left矩阵数组的偏移。
		 * @param tZ right矩阵数组。
		 * @param qX right矩阵数组的偏移。
		 * @param qY 输出矩阵数组。
		 * @param qZ 输出矩阵数组的偏移。
		 * @param qW 输出矩阵数组的偏移。
		 * @param sX 输出矩阵数组的偏移。
		 * @param sY 输出矩阵数组的偏移。
		 * @param sZ 输出矩阵数组的偏移。
		 * @param outArray 结果矩阵数组。
		 * @param outOffset 结果矩阵数组的偏移。
		 */
		public static function createAffineTransformationArray(tX:Number, tY:Number, tZ:Number, rX:Number, rY:Number, rZ:Number, rW:Number, sX:Number, sY:Number, sZ:Number, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x2:Number = rX + rX, y2:Number = rY + rY, z2:Number = rZ + rZ;
			var xx:Number = rX * x2, xy:Number = rX * y2, xz:Number = rX * z2, yy:Number = rY * y2, yz:Number = rY * z2, zz:Number = rZ * z2;
			var wx:Number = rW * x2, wy:Number = rW * y2, wz:Number = rW * z2;
			
			outArray[outOffset + 0] = (1 - (yy + zz)) * sX;
			outArray[outOffset + 1] = (xy + wz) * sX;
			outArray[outOffset + 2] = (xz - wy) * sX;
			outArray[outOffset + 3] = 0;
			outArray[outOffset + 4] = (xy - wz) * sY;
			outArray[outOffset + 5] = (1 - (xx + zz)) * sY;
			outArray[outOffset + 6] = (yz + wx) * sY;
			outArray[outOffset + 7] = 0;
			outArray[outOffset + 8] = (xz + wy) * sZ;
			outArray[outOffset + 9] = (yz - wx) * sZ;
			outArray[outOffset + 10] = (1 - (xx + yy)) * sZ;
			outArray[outOffset + 11] = 0;
			outArray[outOffset + 12] = tX;
			outArray[outOffset + 13] = tY;
			outArray[outOffset + 14] = tZ;
			outArray[outOffset + 15] = 1;
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
		
		/**
		 * @private
		 */
		public static function transformLightingMapTexcoordByUV0Array(source:Float32Array, sourceOffset:int, lightingMapScaleOffset:Vector4, result:Float32Array, resultOffset:int):void {
			var lightingMapScaleOffsetE:Float32Array = lightingMapScaleOffset.elements;
			result[resultOffset + 0] = source[sourceOffset + 0] * lightingMapScaleOffsetE[0] + lightingMapScaleOffsetE[2];
			result[resultOffset + 1] = (source[sourceOffset + 1] - 1.0) * lightingMapScaleOffsetE[1] + lightingMapScaleOffsetE[3];
		}
		
		/**
		 * @private
		 */
		public static function transformLightingMapTexcoordByUV1Array(source:Float32Array, sourceOffset:int, lightingMapScaleOffset:Vector4, result:Float32Array, resultOffset:int):void {
			var lightingMapScaleOffsetE:Float32Array = lightingMapScaleOffset.elements;
			result[resultOffset + 0] = source[sourceOffset + 0] * lightingMapScaleOffsetE[0] + lightingMapScaleOffsetE[2];
			result[resultOffset + 1] = 1.0 + source[sourceOffset + 1] * lightingMapScaleOffsetE[1] + lightingMapScaleOffsetE[3];
		}
		
		/**
		 * 获取URL版本字符。
		 * @param	url
		 * @return
		 */
		public static function getURLVerion(url:String):String {
			var index:int = url.indexOf("?");
			return index >= 0 ? url.substr(index) : null;
		}
		
		/**
		 * @private
		 */
		public static function _quaternionCreateFromYawPitchRollArray(yaw:Number, pitch:Number, roll:Number, out:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var halfRoll:Number = roll * 0.5;
			var halfPitch:Number = pitch * 0.5;
			var halfYaw:Number = yaw * 0.5;
			
			var sinRoll:Number = Math.sin(halfRoll);
			var cosRoll:Number = Math.cos(halfRoll);
			var sinPitch:Number = Math.sin(halfPitch);
			var cosPitch:Number = Math.cos(halfPitch);
			var sinYaw:Number = Math.sin(halfYaw);
			var cosYaw:Number = Math.cos(halfYaw);
			
			out[0] = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
			out[1] = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
			out[2] = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
			out[3] = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
		}
		
		/**
		 * @private
		 */
		public static function _createAffineTransformationArray(trans:Float32Array, rot:Float32Array, scale:Float32Array, outE:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x:Number = rot[0], y:Number = rot[1], z:Number = rot[2], w:Number = rot[3], x2:Number = x + x, y2:Number = y + y, z2:Number = z + z;
			var xx:Number = x * x2, xy:Number = x * y2, xz:Number = x * z2, yy:Number = y * y2, yz:Number = y * z2, zz:Number = z * z2;
			var wx:Number = w * x2, wy:Number = w * y2, wz:Number = w * z2, sx:Number = scale[0], sy:Number = scale[1], sz:Number = scale[2];
			
			outE[0] = (1 - (yy + zz)) * sx;
			outE[1] = (xy + wz) * sx;
			outE[2] = (xz - wy) * sx;
			outE[3] = 0;
			outE[4] = (xy - wz) * sy;
			outE[5] = (1 - (xx + zz)) * sy;
			outE[6] = (yz + wx) * sy;
			outE[7] = 0;
			outE[8] = (xz + wy) * sz;
			outE[9] = (yz - wx) * sz;
			outE[10] = (1 - (xx + yy)) * sz;
			outE[11] = 0;
			outE[12] = trans[0];
			outE[13] = trans[1];
			outE[14] = trans[2];
			outE[15] = 1;
		}
		
		/**
		 * @private
		 */
		public static function _mulMatrixArray(leftMatrixE:Float32Array, rightMatrix:Matrix4x4, outArray:Float32Array, outOffset:int):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			var rightMatrixE:Float32Array = rightMatrix.elements;
			//var leftMatrixE:Float32Array = leftMatrix.elements;
			var m11:Number = rightMatrixE[0], m12:Number = rightMatrixE[1], m13:Number = rightMatrixE[2], m14:Number = rightMatrixE[3];
			var m21:Number = rightMatrixE[4], m22:Number = rightMatrixE[5], m23:Number = rightMatrixE[6], m24:Number = rightMatrixE[7];
			var m31:Number = rightMatrixE[8], m32:Number = rightMatrixE[9], m33:Number = rightMatrixE[10], m34:Number = rightMatrixE[11];
			var m41:Number = rightMatrixE[12], m42:Number = rightMatrixE[13], m43:Number = rightMatrixE[14], m44:Number = rightMatrixE[15];
			
			var ai0OutOffset:Number = outOffset;
			var ai1OutOffset:Number = outOffset + 4;
			var ai2OutOffset:Number = outOffset + 8;
			var ai3OutOffset:Number = outOffset + 12;
			
			for (i = 0; i < 4; i++) {
				ai0 = leftMatrixE[i];
				ai1 = leftMatrixE[i + 4];
				ai2 = leftMatrixE[i + 8];
				ai3 = leftMatrixE[i + 12];
				outArray[ai0OutOffset + i] = ai0 * m11 + ai1 * m12 + ai2 * m13 + ai3 * m14;
				outArray[ai1OutOffset + i] = ai0 * m21 + ai1 * m22 + ai2 * m23 + ai3 * m24;
				outArray[ai2OutOffset + i] = ai0 * m31 + ai1 * m32 + ai2 * m33 + ai3 * m34;
				outArray[ai3OutOffset + i] = ai0 * m41 + ai1 * m42 + ai2 * m43 + ai3 * m44;
			}
		}
		
		public static function getYawPitchRoll(quaternion:Float32Array, out:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			transformQuat(Vector3.ForwardRH, quaternion, Quaternion.TEMPVector31/*forwarldRH*/);
			
			transformQuat(Vector3.Up, quaternion, Quaternion.TEMPVector32/*up*/);
			var upe:Float32Array = Quaternion.TEMPVector32.elements;
			
			angleTo(Vector3.ZERO, Quaternion.TEMPVector31, Quaternion.TEMPVector33/*angle*/);
			var anglee:Float32Array = Quaternion.TEMPVector33.elements;
			
			if (anglee[0] == Math.PI / 2) {
				anglee[1] = arcTanAngle(upe[2], upe[0]);
				anglee[2] = 0;
			} else if (anglee[0] == -Math.PI / 2) {
				anglee[1] = arcTanAngle(-upe[2], -upe[0]);
				anglee[2] = 0;
			} else {
				Matrix4x4.createRotationY(-anglee[1], Quaternion.TEMPMatrix0);
				Matrix4x4.createRotationX(-anglee[0], Quaternion.TEMPMatrix1);
				
				Vector3.transformCoordinate(Quaternion.TEMPVector32, Quaternion.TEMPMatrix0, Quaternion.TEMPVector32);
				Vector3.transformCoordinate(Quaternion.TEMPVector32, Quaternion.TEMPMatrix1, Quaternion.TEMPVector32);
				anglee[2] = arcTanAngle(upe[1], -upe[0]);
			}
			
			// Special cases.
			if (anglee[1] <= -Math.PI)
				anglee[1] = Math.PI;
			if (anglee[2] <= -Math.PI)
				anglee[2] = Math.PI;
			
			if (anglee[1] >= Math.PI && anglee[2] >= Math.PI) {
				anglee[1] = 0;
				anglee[2] = 0;
				anglee[0] = Math.PI - anglee[0];
			}
			
			out[0] = anglee[1];
			out[1] = anglee[0];
			out[2] = anglee[2];
		}
		
		private static function arcTanAngle(x:Number, y:Number):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (x == 0) {
				if (y == 1)
					return Math.PI / 2;
				return -Math.PI / 2;
			}
			if (x > 0)
				return Math.atan(y / x);
			if (x < 0) {
				if (y > 0)
					return Math.atan(y / x) + Math.PI;
				return Math.atan(y / x) - Math.PI;
			}
			return 0;
		}
		
		private static function angleTo(from:Vector3, location:Vector3, angle:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Vector3.subtract(location, from, Quaternion.TEMPVector30);
			Vector3.normalize(Quaternion.TEMPVector30, Quaternion.TEMPVector30);
			
			angle.elements[0] = Math.asin(Quaternion.TEMPVector30.y);
			angle.elements[1] = arcTanAngle(-Quaternion.TEMPVector30.z, -Quaternion.TEMPVector30.x);
		}
		
		public static function transformQuat(source:Vector3, rotation:Float32Array, out:Vector3):void {
			var destination:Float32Array = out.elements;
			var se:Float32Array = source.elements;
			var re:Float32Array = rotation;
			
			var x:Number = se[0], y:Number = se[1], z:Number = se[2], qx:Number = re[0], qy:Number = re[1], qz:Number = re[2], qw:Number = re[3],
			
			ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			
			destination[0] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
			destination[1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
			destination[2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;
		}
		
		/**
		 * @private
		 */
		public static function quaterionNormalize(f:Float32Array, e:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x:Number = f[0], y:Number = f[1], z:Number = f[2], w:Number = f[3];
			var len:Number = x * x + y * y + z * z + w * w;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				e[0] = x * len;
				e[1] = y * len;
				e[2] = z * len;
				e[3] = w * len;
			}
		}
		
		public static function matrix4x4MultiplyFFF(a:Float32Array, b:Float32Array, e:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			if (e === b) {
				b = new Float32Array(16);
				for (i = 0; i < 16; ++i) {
					b[i] = e[i];
				}
			}
			
			for (i = 0; i < 4; i++) {
				ai0 = a[i];
				ai1 = a[i + 4];
				ai2 = a[i + 8];
				ai3 = a[i + 12];
				e[i] = ai0 * b[0] + ai1 * b[1] + ai2 * b[2] + ai3 * b[3];
				e[i + 4] = ai0 * b[4] + ai1 * b[5] + ai2 * b[6] + ai3 * b[7];
				e[i + 8] = ai0 * b[8] + ai1 * b[9] + ai2 * b[10] + ai3 * b[11];
				e[i + 12] = ai0 * b[12] + ai1 * b[13] + ai2 * b[14] + ai3 * b[15];
			}
		}
		
		public static function matrix4x4MultiplyMFM(left:Matrix4x4, right:Float32Array, out:Matrix4x4):void {
			matrix4x4MultiplyFFF(left.elements,right,out.elements);
		}
	}

}