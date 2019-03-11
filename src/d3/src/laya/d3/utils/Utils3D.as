package laya.d3.utils {
	import laya.components.Component;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.light.SpotLight;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.core.trail.TrailSprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.TextureGenerator;
	import laya.d3.terrain.Terrain;
	import laya.display.Node;
	import laya.layagl.LayaGL;
	import laya.utils.Browser;
	import laya.utils.ClassUtils;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.Texture2D;
	
	/**
	 * <code>Utils3D</code> 类用于创建3D工具。
	 */
	public class Utils3D {
		/** @private */
		private static var _tempVector3_0:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector3_1:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector3_2:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector3_3:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector3_4:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector3_5:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector3_6:Vector3 = new Vector3();
		
		/** @private */
		private static var _tempVector3Array0:Float32Array = /*[STATIC SAFE]*/ new Float32Array(3);
		/** @private */
		private static var _tempVector3Array1:Float32Array = /*[STATIC SAFE]*/ new Float32Array(3);
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
		 * @private
		 */
		public static function _convertToLayaVec3(bVector:*, out:Vector3, inverseX:Boolean):void {
			var outE:Float32Array = out.elements;
			outE[0] = inverseX ? -bVector.x() : bVector.x();
			outE[1] = bVector.y();
			outE[2] = bVector.z();
		}
		
		/**
		 * @private
		 */
		public static function _convertToBulletVec3(lVector:Vector3, out:*, inverseX:Boolean):void {
			var lVectorE:Float32Array = lVector.elements;
			out.setValue(inverseX ? -lVectorE[0] : lVectorE[0], lVectorE[1], lVectorE[2]);
		}
		
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
		public static var _compIdToNode:Object = new Object();
		
		/**
		 * @private
		 */
		public static function _createSceneByJsonForMaker(nodeData:Object, outBatchSprites:Vector.<RenderableSprite3D>, initTool:* = null):Scene3D {
			var scene3d:Scene3D = _createNodeByJsonForMaker(nodeData, outBatchSprites, initTool) as Scene3D;
			_addComponentByJsonForMaker(nodeData, outBatchSprites, initTool);
			return scene3d;
		}
		
		/**
		 * @private
		 */
		public static function _createNodeByJsonForMaker(nodeData:Object, outBatchSprites:Vector.<RenderableSprite3D>, initTool:* = null):Node {
			var node:Node;
			switch (nodeData.type) {
			case "Scene3D": 
				node = new Scene3D();
				break;
			case "Sprite3D": 
				node = new Sprite3D();
				break;
			case "MeshSprite3D": 
				node = new MeshSprite3D();
				(outBatchSprites) && (outBatchSprites.push(node));
				break;
			case "SkinnedMeshSprite3D": 
				node = new SkinnedMeshSprite3D();
				break;
			case "ShuriKenParticle3D": 
				node = new ShuriKenParticle3D();
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
			case "PointLight": 
				node = new PointLight();
				break;
			case "SpotLight": 
				node = new SpotLight();
				break;
			case "TrailSprite3D": 
				node = new TrailSprite3D();
				break;
			default: 
				var clas:* = ClassUtils.getClass(nodeData.props.runtime);
				node = new clas();
				break;
			}
			
			var childData:Array = nodeData.child;
			if (childData) {
				for (var i:int = 0, n:int = childData.length; i < n; i++) {
					var child:* = _createNodeByJsonForMaker(childData[i], outBatchSprites, initTool);
					node.addChild(child);
				}
			}
			
			var compId:int = nodeData.compId;
			
			(node as Object).compId = compId;
			node._parse(nodeData.props);
			
			if (initTool) {
				initTool._idMap[compId] = node;
			}
			_compIdToNode[compId] = node;
			
			var componentsData:Array = nodeData.components;
			if (componentsData) {
				for (var j:int = 0, m:int = componentsData.length; j < m; j++) {
					var data:Object = componentsData[j];
					clas = Browser.window.Laya[data.type];//兼容
					if (!clas) {//兼容
						clas = Browser.window;
						var clasPaths:Array = data.type.split('.');
						clasPaths.forEach(function(cls:*):void {
							clas = clas[cls];
						});
					}
					if (typeof(clas) == 'function') {
						var comp:Component = new clas();
						if (initTool) {
							initTool._idMap[data.compId] = comp;
							trace(data.compId);
						}
					} else {
						console.warn("Utils3D:Unkown component type.");
					}
				}
			}
			
			return node;
		}
		
		/**
		 * @private
		 */
		public static function _addComponentByJsonForMaker(nodeData:Object, outBatchSprites:Vector.<RenderableSprite3D>, initTool:* = null):void {
			
			var compId:int = nodeData.compId;
			var node:Node = _compIdToNode[compId];
			var childData:Array = nodeData.child;
			if (childData) {
				for (var i:int = 0, n:int = childData.length; i < n; i++) {
					var child:* = _addComponentByJsonForMaker(childData[i], outBatchSprites, initTool);
				}
			}
			
			var componentsData:Array = nodeData.components;
			if (componentsData) {
				for (var j:int = 0, m:int = componentsData.length; j < m; j++) {
					var data:Object = componentsData[j];
					clas = Browser.window.Laya[data.type];//兼容
					if (!clas) {//兼容
						var clasPaths:Array = data.type.split('.');
						var clas:* = Browser.window;
						clasPaths.forEach(function(cls:*):void {
							clas = clas[cls];
						});
					}
					if (typeof(clas) == 'function') {
						var component:Component = initTool._idMap[data.compId];
						node.addComponentIntance(component);
						component._parse(data);
					} else {
						console.warn("Utils3D:Unkown component type.");
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		public static function _createNodeByJson(nodeData:Object, outBatchSprites:Vector.<RenderableSprite3D>):Node {
			var node:Node;
			switch (nodeData.type) {
			case "Scene3D": 
				node = new Scene3D();
				break;
			case "Sprite3D": 
				node = new Sprite3D();
				break;
			case "MeshSprite3D": 
				node = new MeshSprite3D();
				(outBatchSprites) && (outBatchSprites.push(node));
				break;
			case "SkinnedMeshSprite3D": 
				node = new SkinnedMeshSprite3D();
				break;
			case "ShuriKenParticle3D": 
				node = new ShuriKenParticle3D();
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
			case "PointLight": 
				node = new PointLight();
				break;
			case "SpotLight": 
				node = new SpotLight();
				break;
			case "TrailSprite3D": 
				node = new TrailSprite3D();
				break;
			default: 
				throw new Error("Utils3D:unidentified class type in (.lh) file.");
			}
			
			var childData:Array = nodeData.child;
			if (childData) {
				for (var i:int = 0, n:int = childData.length; i < n; i++) {
					var child:* = _createNodeByJson(childData[i], outBatchSprites)
					node.addChild(child);
				}
			}
			
			var componentsData:Array = nodeData.components;
			if (componentsData) {
				for (var j:int = 0, m:int = componentsData.length; j < m; j++) {
					var data:Object = componentsData[j];
					clas = Browser.window.Laya[data.type];//兼容
					if (!clas) {//兼容
						var clasPaths:Array = data.type.split('.');
						var clas:* = Browser.window;
						clasPaths.forEach(function(cls:*):void {
							clas = clas[cls];
						});
					}
					if (typeof(clas) == 'function') {
						var component:Component = node.addComponent(clas);
						component._parse(data);
					} else {
						console.warn("Unkown component type.");
					}
				}
			}
			node._parse(nodeData.props);
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
			var coordinateX:Number = source[sourceOffset + 0];
			var coordinateY:Number = source[sourceOffset + 1];
			var coordinateZ:Number = source[sourceOffset + 2];
			
			var transformElem:Float32Array = transform.elements;
			var w:Number = ((coordinateX * transformElem[3]) + (coordinateY * transformElem[7]) + (coordinateZ * transformElem[11]) + transformElem[15]);
			result[resultOffset] = (coordinateX * transformElem[0]) + (coordinateY * transformElem[4]) + (coordinateZ * transformElem[8]) + transformElem[12] / w;
			result[resultOffset + 1] = (coordinateX * transformElem[1]) + (coordinateY * transformElem[5]) + (coordinateZ * transformElem[9]) + transformElem[13] / w;
			result[resultOffset + 2] = (coordinateX * transformElem[2]) + (coordinateY * transformElem[6]) + (coordinateZ * transformElem[10]) + transformElem[14] / w;
		}
		
		/**
		 * @private
		 */
		public static function transformLightingMapTexcoordArray(source:Float32Array, sourceOffset:int, lightingMapScaleOffset:Vector4, result:Float32Array, resultOffset:int):void {
			var lightingMapScaleOffsetE:Float32Array = lightingMapScaleOffset.elements;
			result[resultOffset + 0] = source[sourceOffset + 0] * lightingMapScaleOffsetE[0] + lightingMapScaleOffsetE[2];
			result[resultOffset + 1] = 1.0 - ((1.0 - source[sourceOffset + 1]) * lightingMapScaleOffsetE[1] + lightingMapScaleOffsetE[3]);
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
		
		public static function quaterionSlerp(left:Float32Array, right:Float32Array, t:Number, out:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var ax:Number = left[0], ay:Number = left[1], az:Number = left[2], aw:Number = left[3], bx:Number = right[0], by:Number = right[1], bz:Number = right[2], bw:Number = right[3];
			
			var omega:Number, cosom:Number, sinom:Number, scale0:Number, scale1:Number;
			
			// calc cosine 
			cosom = ax * bx + ay * by + az * bz + aw * bw;
			// adjust signs (if necessary) 
			if (cosom < 0.0) {
				cosom = -cosom;
				bx = -bx;
				by = -by;
				bz = -bz;
				bw = -bw;
			}
			// calculate coefficients 
			if ((1.0 - cosom) > 0.000001) {
				// standard case (slerp) 
				omega = Math.acos(cosom);
				sinom = Math.sin(omega);
				scale0 = Math.sin((1.0 - t) * omega) / sinom;
				scale1 = Math.sin(t * omega) / sinom;
			} else {
				// "from" and "to" quaternions are very close  
				//  ... so we can do a linear interpolation 
				scale0 = 1.0 - t;
				scale1 = t;
			}
			// calculate final values 
			out[0] = scale0 * ax + scale1 * bx;
			out[1] = scale0 * ay + scale1 * by;
			out[2] = scale0 * az + scale1 * bz;
			out[3] = scale0 * aw + scale1 * bw;
		}
		
		public static function quaternionMultiply(le:Float32Array, re:Float32Array, oe:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var lx:Number = le[0];
			var ly:Number = le[1];
			var lz:Number = le[2];
			var lw:Number = le[3];
			var rx:Number = re[0];
			var ry:Number = re[1];
			var rz:Number = re[2];
			var rw:Number = re[3];
			var a:Number = (ly * rz - lz * ry);
			var b:Number = (lz * rx - lx * rz);
			var c:Number = (lx * ry - ly * rx);
			var d:Number = (lx * rx + ly * ry + lz * rz);
			oe[0] = (lx * rw + rx * lw) + a;
			oe[1] = (ly * rw + ry * lw) + b;
			oe[2] = (lz * rw + rz * lw) + c;
			oe[3] = lw * rw - d;
		}
		
		public static function quaternionWeight(f:Float32Array, weight:Number, e:Float32Array):void {
			e[0] = f[0] * weight;
			e[1] = f[1] * weight;
			e[2] = f[2] * weight;
			e[3] = f[3];
		}
		
		public static function quaternionInvert(f:Float32Array, e:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			
			var a0:Number = f[0], a1:Number = f[1], a2:Number = f[2], a3:Number = f[3];
			var dot:Number = a0 * a0 + a1 * a1 + a2 * a2 + a3 * a3;
			var invDot:Number = dot ? 1.0 / dot : 0;
			
			// TODO: Would be faster to return [0,0,0,0] immediately if dot == 0
			e[0] = -a0 * invDot;
			e[1] = -a1 * invDot;
			e[2] = -a2 * invDot;
			e[3] = a3 * invDot;
		}
		
		/**
		 * @private
		 */
		public static function quaternionConjugate(value:Float32Array, offset:int, result:Float32Array):void {
			result[0] = -value[offset];
			result[1] = -value[offset + 1];
			result[2] = -value[offset + 2];
			result[3] = value[offset + 3];
		}
		
		/**
		 * @private
		 */
		public static function scaleWeight(s:Float32Array, w:Number, out:Float32Array):void {
			var sX:Number = s[0], sY:Number = s[1], sZ:Number = s[2];
			out[0] = sX > 0 ? Math.pow(Math.abs(sX), w) : -Math.pow(Math.abs(sX), w);
			out[1] = sY > 0 ? Math.pow(Math.abs(sY), w) : -Math.pow(Math.abs(sY), w);
			out[2] = sZ > 0 ? Math.pow(Math.abs(sZ), w) : -Math.pow(Math.abs(sZ), w);
		}
		
		/**
		 * @private
		 */
		public static function scaleBlend(sa:Float32Array, sb:Float32Array, w:Number, out:Float32Array):void {
			var saw:Float32Array = _tempVector3Array0;
			var sbw:Float32Array = _tempVector3Array1;
			scaleWeight(sa, 1.0 - w, saw);
			scaleWeight(sb, w, sbw);
			var sng:Float32Array = w > 0.5 ? sb : sa;
			out[0] = sng[0] > 0 ? Math.abs(saw[0] * sbw[0]) : -Math.abs(saw[0] * sbw[0]);
			out[1] = sng[1] > 0 ? Math.abs(saw[1] * sbw[1]) : -Math.abs(saw[1] * sbw[1]);
			out[2] = sng[2] > 0 ? Math.abs(saw[2] * sbw[2]) : -Math.abs(saw[2] * sbw[2]);
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
			
			var b0:Number = b[0], b1:Number = b[1], b2:Number = b[2], b3:Number = b[3];
			var b4:Number = b[4], b5:Number = b[5], b6:Number = b[6], b7:Number = b[7];
			var b8:Number = b[8], b9:Number = b[9], b10:Number = b[10], b11:Number = b[11];
			var b12:Number = b[12], b13:Number = b[13], b14:Number = b[14], b15:Number = b[15];
			
			for (i = 0; i < 4; i++) {
				ai0 = a[i];
				ai1 = a[i + 4];
				ai2 = a[i + 8];
				ai3 = a[i + 12];
				e[i] = ai0 * b0 + ai1 * b1 + ai2 * b2 + ai3 * b3;
				e[i + 4] = ai0 * b4 + ai1 * b5 + ai2 * b6 + ai3 * b7;
				e[i + 8] = ai0 * b8 + ai1 * b9 + ai2 * b10 + ai3 * b11;
				e[i + 12] = ai0 * b12 + ai1 * b13 + ai2 * b14 + ai3 * b15;
			}
		}
		
		public static function matrix4x4MultiplyFFFForNative(a:Float32Array, b:Float32Array, e:Float32Array):void {
			LayaGL.instance.matrix4x4Multiply(a, b, e);
		}
		
		public static function matrix4x4MultiplyMFM(left:Matrix4x4, right:Float32Array, out:Matrix4x4):void {
			matrix4x4MultiplyFFF(left.elements, right, out.elements);
		}
		
		/**
		 * @private
		 */
		
		public static function _buildTexture2D(width:int, height:int, format:int, colorFunc:Function, mipmaps:Boolean = false):Texture2D {
			var texture:Texture2D = new Texture2D(width, height, format, mipmaps, true);
			texture.anisoLevel = 1;
			texture.filterMode = BaseTexture.FILTERMODE_POINT;
			TextureGenerator._generateTexture2D(texture, width, height, colorFunc);
			return texture;
		}
	}

}