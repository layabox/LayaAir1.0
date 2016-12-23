package laya.d3.utils {
	import laya.d3.core.MeshRender;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
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
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.graphics.VertexPositionNormalColorSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Tangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureTangent;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinTangent;
	import laya.d3.graphics.VertexPositionNormalTexture0Texture1Tangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalTextureTangent;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
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
		
		/** @private */
		private static function _getTexturePath(path:String):String {
			var extenIndex:int = path.length - 4;
			if (path.indexOf(".dds") == extenIndex || path.indexOf(".tga") == extenIndex || path.indexOf(".exr") == extenIndex || path.indexOf(".DDS") == extenIndex || path.indexOf(".TGA") == extenIndex || path.indexOf(".EXR") == extenIndex)
				path = path.substr(0, extenIndex) + ".png";
			
			return path = URL.formatURL(path);
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
		
		/** @private */
		private static function _applyMeshMaterials(meshSprite3D:MeshSprite3D, mesh:Mesh):void {//对应Mesh内部
			var meshRender:MeshRender = meshSprite3D.meshRender;
			var shaderMaterials:Vector.<BaseMaterial> = meshRender.sharedMaterials;
			var meshMaterials:Vector.<BaseMaterial> = mesh.materials;
			for (var i:int = 0, n:int = meshMaterials.length; i < n; i++)
				(shaderMaterials[i]) || (shaderMaterials[i] = meshMaterials[i]);
			
			meshRender.sharedMaterials = shaderMaterials;
		}
		
		public static function _loadParticle(settting:Object, particle:ShuriKenParticle3D, innerResouMap:Object = null):void {
			const anglelToRad:Number = Math.PI / 180.0;
			var i:int, n:int;
			//Material
			var material:ShurikenParticleMaterial = new ShurikenParticleMaterial();
			material.diffuseTexture = innerResouMap ? Loader.getRes(innerResouMap[settting.texturePath]) : Texture2D.load(settting.texturePath);
			
			material.renderMode = BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE;
			
			particle.particleRender.sharedMaterial = material;
			//particleSystem
			var particleSystem:ShurikenParticleSystem = particle.particleSystem;
			particleSystem.isPerformanceMode = settting.isPerformanceMode;
			
			particleSystem.duration = settting.duration;
			particleSystem.looping = settting.looping;
			particleSystem.prewarm = settting.prewarm;
			
			particleSystem.startDelayType = settting.startDelayType;
			particleSystem.startDelay = settting.startDelay;
			particleSystem.startDelayMin = settting.startDelayMin;
			particleSystem.startDelayMax = settting.startDelayMax;
			
			particleSystem.startLifetimeType = settting.startLifetimeType;
			particleSystem.startLifetimeConstant = settting.startLifetimeConstant;
			particleSystem.startLifeTimeGradient = _initStartLife(settting.startLifetimeGradient);
			particleSystem.startLifetimeConstantMin = settting.startLifetimeConstantMin;
			particleSystem.startLifetimeConstantMax = settting.startLifetimeConstantMax;
			particleSystem.startLifeTimeGradientMin = _initStartLife(settting.startLifetimeGradientMin);
			particleSystem.startLifeTimeGradientMax = _initStartLife(settting.startLifetimeGradientMax);
			
			particleSystem.startSpeedType = settting.startSpeedType;
			particleSystem.startSpeedConstant = settting.startSpeedConstant;
			particleSystem.startSpeedConstantMin = settting.startSpeedConstantMin;
			particleSystem.startSpeedConstantMax = settting.startSpeedConstantMax;
			
			particleSystem.threeDStartSize = settting.threeDStartSize;
			particleSystem.startSizeType = settting.startSizeType;
			particleSystem.startSizeConstant = settting.startSizeConstant;
			var startSizeConstantSeparateArray:Array = settting.startSizeConstantSeparate;
			var startSizeConstantSeparateElement:Float32Array = particleSystem.startSizeConstantSeparate.elements;
			startSizeConstantSeparateElement[0] = startSizeConstantSeparateArray[0];
			startSizeConstantSeparateElement[1] = startSizeConstantSeparateArray[1];
			startSizeConstantSeparateElement[2] = startSizeConstantSeparateArray[2];
			particleSystem.startSizeConstantMin = settting.startSizeConstantMin;
			particleSystem.startSizeConstantMax = settting.startSizeConstantMax;
			var startSizeConstantMinSeparateArray:Array = settting.startSizeConstantMinSeparate;
			var startSizeConstantMinSeparateElement:Float32Array = particleSystem.startSizeConstantMinSeparate.elements;
			startSizeConstantMinSeparateElement[0] = startSizeConstantMinSeparateArray[0];
			startSizeConstantMinSeparateElement[1] = startSizeConstantMinSeparateArray[1];
			startSizeConstantMinSeparateElement[2] = startSizeConstantMinSeparateArray[2];
			var startSizeConstantMaxSeparateArray:Array = settting.startSizeConstantMaxSeparate;
			var startSizeConstantMaxSeparateElement:Float32Array = particleSystem.startSizeConstantMaxSeparate.elements;
			startSizeConstantMaxSeparateElement[0] = startSizeConstantMaxSeparateArray[0];
			startSizeConstantMaxSeparateElement[1] = startSizeConstantMaxSeparateArray[1];
			startSizeConstantMaxSeparateElement[2] = startSizeConstantMaxSeparateArray[2];
			
			particleSystem.threeDStartRotation = settting.threeDStartRotation;
			particleSystem.startRotationType = settting.startRotationType;
			particleSystem.startRotationConstant = settting.startRotationConstant * anglelToRad;
			var startRotationConstantSeparateArray:Array = settting.startRotationConstantSeparate;
			var startRotationConstantSeparateElement:Float32Array = particleSystem.startRotationConstantSeparate.elements;
			startRotationConstantSeparateElement[0] = startRotationConstantSeparateArray[0] * anglelToRad;
			startRotationConstantSeparateElement[1] = startRotationConstantSeparateArray[1] * anglelToRad;
			startRotationConstantSeparateElement[2] = startRotationConstantSeparateArray[2] * anglelToRad;
			particleSystem.startRotationConstantMin = settting.startRotationConstantMin * anglelToRad;
			particleSystem.startRotationConstantMax = settting.startRotationConstantMax * anglelToRad;
			var startRotationConstantMinSeparateArray:Array = settting.startRotationConstantMinSeparate;
			var startRotationConstantMinSeparateElement:Float32Array = particleSystem.startRotationConstantMinSeparate.elements;
			startRotationConstantMinSeparateElement[0] = startRotationConstantMinSeparateArray[0] * anglelToRad;
			startRotationConstantMinSeparateElement[1] = startRotationConstantMinSeparateArray[1] * anglelToRad;
			startRotationConstantMinSeparateElement[2] = startRotationConstantMinSeparateArray[2] * anglelToRad;
			var startRotationConstantMaxSeparateArray:Array = settting.startRotationConstantMaxSeparate;
			var startRotationConstantMaxSeparateElement:Float32Array = particleSystem.startRotationConstantMaxSeparate.elements;
			startRotationConstantMaxSeparateElement[0] = startRotationConstantMaxSeparateArray[0] * anglelToRad;
			startRotationConstantMaxSeparateElement[1] = startRotationConstantMaxSeparateArray[1] * anglelToRad;
			startRotationConstantMaxSeparateElement[2] = startRotationConstantMaxSeparateArray[2] * anglelToRad;
			
			particleSystem.randomizeRotationDirection = settting.randomizeRotationDirection;
			
			particleSystem.startColorType = settting.startColorType;
			var startColorConstantArray:Array = settting.startColorConstant;
			var startColorConstantElement:Float32Array = particleSystem.startColorConstant.elements;
			startColorConstantElement[0] = startColorConstantArray[0];
			startColorConstantElement[1] = startColorConstantArray[1];
			startColorConstantElement[2] = startColorConstantArray[2];
			startColorConstantElement[3] = startColorConstantArray[3];
			var startColorConstantMinArray:Array = settting.startColorConstantMin;
			var startColorConstantMinElement:Float32Array = particleSystem.startColorConstantMin.elements;
			startColorConstantMinElement[0] = startColorConstantMinArray[0];
			startColorConstantMinElement[1] = startColorConstantMinArray[1];
			startColorConstantMinElement[2] = startColorConstantMinArray[2];
			startColorConstantMinElement[3] = startColorConstantMinArray[3];
			var startColorConstantMaxArray:Array = settting.startColorConstantMax;
			var startColorConstantMaxElement:Float32Array = particleSystem.startColorConstantMax.elements;
			startColorConstantMaxElement[0] = startColorConstantMaxArray[0];
			startColorConstantMaxElement[1] = startColorConstantMaxArray[1];
			startColorConstantMaxElement[2] = startColorConstantMaxArray[2];
			startColorConstantMaxElement[3] = startColorConstantMaxArray[3];
			
			var gravityArray:Array = settting.gravity;
			var gravityE:Float32Array = particleSystem.gravity.elements;
			gravityE[0] = gravityArray[0];
			gravityE[1] = gravityArray[1];
			gravityE[2] = gravityArray[2];
			
			particleSystem.gravityModifier = settting.gravityModifier;
			
			particleSystem.simulationSpace = settting.simulationSpace;
			
			particleSystem.scaleMode = settting.scaleMode;
			
			particleSystem.playOnAwake = settting.playOnAwake;
			particleSystem.maxParticles = settting.maxParticles;
			
			//Emission
			var emissionData:Object = settting.emission;
			var emission:Emission = new Emission();
			emission.emissionRate = emissionData.emissionRate;
			var burstsData:Array = emissionData.bursts;
			if (burstsData)
				for (i = 0, n = burstsData.length; i < n; i++) {
					var brust:Object = burstsData[i];
					emission.addBurst(new Burst(brust.time, brust.min, brust.max));
				}
			emission.enbale = emissionData.enable;
			particleSystem.emission = emission;
			
			//Shape
			var shapeData:Object = settting.shape;
			var shape:BaseShape;
			switch (shapeData.shapeType) {
			case 0: 
				var sphereShape:SphereShape;
				shape = sphereShape = new SphereShape();
				sphereShape.radius = shapeData.sphereRadius;
				sphereShape.emitFromShell = shapeData.sphereEmitFromShell;
				sphereShape.randomDirection = shapeData.sphereRandomDirection;
				break;
			case 1: 
				var hemiSphereShape:HemisphereShape;
				shape = hemiSphereShape = new HemisphereShape();
				hemiSphereShape.radius = shapeData.hemiSphereRadius;
				hemiSphereShape.emitFromShell = shapeData.hemiSphereEmitFromShell;
				hemiSphereShape.randomDirection = shapeData.hemiSphereRandomDirection;
				break;
			case 2: 
				var coneShape:ConeShape;
				shape = coneShape = new ConeShape();
				coneShape.angle = shapeData.coneAngle * anglelToRad;
				coneShape.radius = shapeData.coneRadius;
				coneShape.length = shapeData.coneLength;
				coneShape.emitType = shapeData.coneEmitType;
				coneShape.randomDirection = shapeData.coneRandomDirection;
				break;
			case 3: 
				var boxShape:BoxShape;
				shape = boxShape = new BoxShape();
				boxShape.x = shapeData.boxX;
				boxShape.y = shapeData.boxY;
				boxShape.z = shapeData.boxZ;
				boxShape.randomDirection = shapeData.boxRandomDirection;
				break;
			case 7: 
				var circleShape:CircleShape;
				shape = circleShape = new CircleShape();
				circleShape.radius = shapeData.circleRadius;
				circleShape.arc = shapeData.circleArc * anglelToRad;
				circleShape.emitFromEdge = shapeData.circleEmitFromEdge;
				circleShape.randomDirection = shapeData.circleRandomDirection;
				break;
			}
			shape.enable = shapeData.enable;
			particleSystem.shape = shape;
			
			//VelocityOverLifetime
			var velocityOverLifetimeData:Object = settting.velocityOverLifetime;
			if (velocityOverLifetimeData) {
				var velocityData:Object = velocityOverLifetimeData.velocity;
				var velocity:GradientVelocity;
				switch (velocityData.type) {
				case 0: 
					var constantData:Array = velocityData.constant;
					velocity = GradientVelocity.createByConstant(new Vector3(constantData[0], constantData[1], constantData[2]));
					break;
				case 1: 
					velocity = GradientVelocity.createByGradient(_initParticleVelocity(velocityData.gradientX), _initParticleVelocity(velocityData.gradientY), _initParticleVelocity(velocityData.gradientZ));
					break;
				case 2: 
					var constantMinData:Array = velocityData.constantMin;
					var constantMaxData:Array = velocityData.constantMax;
					velocity = GradientVelocity.createByRandomTwoConstant(new Vector3(constantMinData[0], constantMinData[1], constantMinData[2]), new Vector3(constantMaxData[0], constantMaxData[1], constantMaxData[2]));
					break;
				case 3: 
					velocity = GradientVelocity.createByRandomTwoGradient(_initParticleVelocity(velocityData.gradientXMin), _initParticleVelocity(velocityData.gradientXMax), _initParticleVelocity(velocityData.gradientYMin), _initParticleVelocity(velocityData.gradientYMax), _initParticleVelocity(velocityData.gradientZMin), _initParticleVelocity(velocityData.gradientZMax));
					break;
				}
				var velocityOverLifetime:VelocityOverLifetime = new VelocityOverLifetime(velocity);
				velocityOverLifetime.space = velocityOverLifetimeData.space;
				velocityOverLifetime.enbale = velocityOverLifetimeData.enable;
				particleSystem.velocityOverLifetime = velocityOverLifetime;
			}
			
			//ColorOverLifetime
			var colorOverLifetimeData:Object = settting.colorOverLifetime;
			if (colorOverLifetimeData) {
				var colorData:Object = colorOverLifetimeData.color;
				var color:GradientColor;
				switch (colorData.type) {
				case 0: 
					var constColorData:Array = colorData.constant;
					color = GradientColor.createByConstant(new Vector4(constColorData[0], constColorData[1], constColorData[2], constColorData[3]));
					break;
				case 1: 
					color = GradientColor.createByGradient(_initParticleColor(colorData.gradient));
					break;
				case 2: 
					var minConstColorData:Array = colorData.constantMin;
					var maxConstColorData:Array = colorData.constantMax;
					color = GradientColor.createByRandomTwoConstant(new Vector4(minConstColorData[0], minConstColorData[1], minConstColorData[2], minConstColorData[3]), new Vector4(maxConstColorData[0], maxConstColorData[1], maxConstColorData[2], maxConstColorData[3]));
					break;
				case 3: 
					color = GradientColor.createByRandomTwoGradient(_initParticleColor(colorData.gradientMin), _initParticleColor(colorData.gradientMax));
					break;
				}
				var colorOverLifetime:ColorOverLifetime = new ColorOverLifetime(color);
				colorOverLifetime.enbale = colorOverLifetimeData.enable;
				particleSystem.colorOverLifetime = colorOverLifetime;
			}
			
			//SizeOverLifetime
			var sizeOverLifetimeData:Object = settting.sizeOverLifetime;
			if (sizeOverLifetimeData) {
				var sizeData:Object = sizeOverLifetimeData.size;
				var size:GradientSize;
				switch (sizeData.type) {
				case 0: 
					if (sizeData.separateAxes) {
						size = GradientSize.createByGradientSeparate(_initParticleSize(sizeData.gradientX), _initParticleSize(sizeData.gradientY), _initParticleSize(sizeData.gradientZ));
					} else {
						size = GradientSize.createByGradient(_initParticleSize(sizeData.gradient));
					}
					break;
				case 1: 
					if (sizeData.separateAxes) {
						var constantMinSeparateData:Array = sizeData.constantMinSeparate;
						var constantMaxSeparateData:Array = sizeData.constantMaxSeparate;
						size = GradientSize.createByRandomTwoConstantSeparate(new Vector3(constantMinSeparateData[0], constantMinSeparateData[1], constantMinSeparateData[2]), new Vector3(constantMaxSeparateData[0], constantMaxSeparateData[1], constantMaxSeparateData[2]));
					} else {
						size = GradientSize.createByRandomTwoConstant(sizeData.constantMin, sizeData.constantMax);
					}
					break;
				case 2: 
					if (sizeData.separateAxes) {
						size = GradientSize.createByRandomTwoGradientSeparate(_initParticleSize(sizeData.gradientXMin), _initParticleSize(sizeData.gradientYMin), _initParticleSize(sizeData.gradientZMin), _initParticleSize(sizeData.gradientXMax), _initParticleSize(sizeData.gradientYMax), _initParticleSize(sizeData.gradientZMax));
					} else {
						size = GradientSize.createByRandomTwoGradient(_initParticleSize(sizeData.gradientMin), _initParticleSize(sizeData.gradientMax));
					}
					break;
				}
				var sizeOverLifetime:SizeOverLifetime = new SizeOverLifetime(size);
				sizeOverLifetime.enbale = sizeOverLifetimeData.enable;
				particleSystem.sizeOverLifetime = sizeOverLifetime;
			}
			
			//RotationOverLifetime
			var rotationOverLifetimeData:Object = settting.rotationOverLifetime;
			if (rotationOverLifetimeData) {
				var angularVelocityData:Object = rotationOverLifetimeData.angularVelocity;
				var angularVelocity:GradientAngularVelocity;
				switch (angularVelocityData.type) {
				case 0: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByConstant(angularVelocityData.constant * anglelToRad);
					}
					break;
				case 1: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByGradient(_initParticleRotation(angularVelocityData.gradient));
					}
					break;
				case 2: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByRandomTwoConstant(angularVelocityData.constantMin * anglelToRad, angularVelocityData.constantMax * anglelToRad);
					}
					break;
				case 3: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByRandomTwoGradient(_initParticleRotation(angularVelocityData.gradientMin), _initParticleRotation(angularVelocityData.gradientMax));
					}
					break;
				}
				var rotationOverLifetime:RotationOverLifetime = new RotationOverLifetime(angularVelocity);
				rotationOverLifetime.enbale = rotationOverLifetimeData.enable;
				particleSystem.rotationOverLifetime = rotationOverLifetime;
			}
			
			//TextureSheetAnimation
			var textureSheetAnimationData:Object = settting.textureSheetAnimation;
			if (textureSheetAnimationData) {
				var frameData:Object = textureSheetAnimationData.frame;
				var frameOverTime:FrameOverTime;
				switch (frameData.type) {
				case 0: 
					frameOverTime = FrameOverTime.createByConstant(frameData.constant);
					break;
				case 1: 
					frameOverTime = FrameOverTime.createByOverTime(_initParticleFrame(frameData.overTime));
					break;
				case 2: 
					frameOverTime = FrameOverTime.createByRandomTwoConstant(frameData.constantMin, frameData.constantMax);
					break;
				case 3: 
					frameOverTime = FrameOverTime.createByRandomTwoOverTime(_initParticleFrame(frameData.overTimeMin), _initParticleFrame(frameData.overTimeMax));
					break;
				}
				var startFrameData:Object = textureSheetAnimationData.startFrame;
				var startFrame:StartFrame;
				switch (startFrameData.type) {
				case 0: 
					startFrame = StartFrame.createByConstant(startFrameData.constant);
					break;
				case 1: 
					startFrame = StartFrame.createByRandomTwoConstant(startFrameData.constantMin, startFrameData.constantMax);
					break;
				}
				var textureSheetAnimation:TextureSheetAnimation = new TextureSheetAnimation(frameOverTime, startFrame);
				textureSheetAnimation.enbale = textureSheetAnimationData.enable;
				var tilesData:Array = textureSheetAnimationData.tiles;
				textureSheetAnimation.tiles = new Vector2(tilesData[0], tilesData[1]);
				textureSheetAnimation.type = textureSheetAnimationData.type;
				textureSheetAnimation.randomRow = textureSheetAnimationData.randomRow;
				textureSheetAnimation.cycles = textureSheetAnimationData.cycles;
				particleSystem.textureSheetAnimation = textureSheetAnimation;
			}
			
			//Render
			var particleRender:ShurikenParticleRender = particle.particleRender;
			particleRender.renderMode = settting.renderMode;
			particleRender.stretchedBillboardCameraSpeedScale = settting.stretchedBillboardCameraSpeedScale;
			particleRender.stretchedBillboardSpeedScale = settting.stretchedBillboardSpeedScale;
			particleRender.stretchedBillboardLengthScale = settting.stretchedBillboardLengthScale;
			
			(particleSystem.playOnAwake) && (emission.play());
		}
		
		/** @private */
		public static function _parseHierarchyProp(innerResouMap:Object, node:Sprite3D, json:Object):void {
			var customProps:Object = json.customProps;
			var transValue:Array = customProps.translate;
			var loccalPosition:Vector3 = node.transform.localPosition;
			var loccalPositionElments:Float32Array = loccalPosition.elements;
			loccalPositionElments[0] = transValue[0];
			loccalPositionElments[1] = transValue[1];
			loccalPositionElments[2] = transValue[2];
			node.transform.localPosition = loccalPosition;
			var rotValue:Array = customProps.rotation;
			var localRotation:Quaternion = node.transform.localRotation;
			var localRotationElement:Float32Array = localRotation.elements;
			localRotationElement[0] = rotValue[0];
			localRotationElement[1] = rotValue[1];
			localRotationElement[2] = rotValue[2];
			localRotationElement[3] = rotValue[3];
			node.transform.localRotation = localRotation;
			var scaleValue:Array = customProps.scale;
			var localScale:Vector3 = node.transform.localScale;
			var localSceleElement:Float32Array = localScale.elements;
			localSceleElement[0] = scaleValue[0];
			localSceleElement[1] = scaleValue[1];
			localSceleElement[2] = scaleValue[2];
			node.transform.localScale = localScale;
			switch (json.type) {
			case "Sprite3D": 
				break;
			case "MeshSprite3D": 
				var mesh:Mesh = Loader.getRes(innerResouMap[json.instanceParams.loadPath]);
				var meshSprite3D:MeshSprite3D = (node as MeshSprite3D);
				meshSprite3D.meshFilter.sharedMesh = mesh;
				
				if (mesh.loaded)
					meshSprite3D.meshRender.sharedMaterials = mesh.materials;
				else
					mesh.once(Event.LOADED, meshSprite3D, meshSprite3D._applyMeshMaterials);
				break;
			case "ShuriKenParticle3D": 
				var shuriKenParticle3D:ShuriKenParticle3D = (node as ShuriKenParticle3D);
				_loadParticle(customProps, shuriKenParticle3D, innerResouMap);
				break;
			}
		}
		
		/** @private */
		public static function _parseHierarchyNode(json:Object):Sprite3D {
			switch (json.type) {
			case "Sprite3D": 
				return new Sprite3D();
				break;
			case "MeshSprite3D": 
				return new MeshSprite3D();
				break;
			case "ShuriKenParticle3D": 
				return new ShuriKenParticle3D();
				break;
			default: 
				throw new Error("Utils3D:unidentified class type in (.lh) file.");
			}
		}
		
		private static function _initStartLife(gradientData:Object):GradientDataNumber {
			var gradient:GradientDataNumber = new GradientDataNumber();
			var startLifetimesData:Array = gradientData.startLifetimes;
			for (var i:int = 0, n:int = startLifetimesData.length; i < n; i++) {
				var valueData:Object = startLifetimesData[i];
				gradient.add(valueData.key, valueData.value);
			}
			return gradient
		}
		
		private static function _initParticleVelocity(gradientData:Object):GradientDataNumber {
			var gradient:GradientDataNumber = new GradientDataNumber();
			var velocitysData:Array = gradientData.velocitys;
			for (var i:int = 0, n:int = velocitysData.length; i < n; i++) {
				var valueData:Object = velocitysData[i];
				gradient.add(valueData.key, valueData.value);
			}
			return gradient;
		}
		
		private static function _initParticleColor(gradientColorData:Object):GradientDataColor {
			var gradientColor:GradientDataColor = new GradientDataColor();
			var alphasData:Array = gradientColorData.alphas;
			var i:int, n:int;
			for (i = 0, n = alphasData.length; i < n; i++) {
				var alphaData:Object = alphasData[i];
				gradientColor.addAlpha(alphaData.key, alphaData.value);
			}
			var rgbsData:Array = gradientColorData.rgbs;
			for (i = 0, n = rgbsData.length; i < n; i++) {
				var rgbData:Object = rgbsData[i];
				var rgbValue:Array = rgbData.value;
				gradientColor.addRGB(rgbData.key, new Vector3(rgbValue[0], rgbValue[1], rgbValue[2]));
			}
			return gradientColor;
		}
		
		private static function _initParticleSize(gradientSizeData:Object):GradientDataNumber {
			var gradientSize:GradientDataNumber = new GradientDataNumber();
			var sizesData:Array = gradientSizeData.sizes;
			for (var i:int = 0, n:int = sizesData.length; i < n; i++) {
				var valueData:Object = sizesData[i];
				gradientSize.add(valueData.key, valueData.value);
			}
			return gradientSize;
		}
		
		private static function _initParticleRotation(gradientData:Object):GradientDataNumber {
			var gradient:GradientDataNumber = new GradientDataNumber();
			var angularVelocitysData:Array = gradientData.angularVelocitys;
			for (var i:int = 0, n:int = angularVelocitysData.length; i < n; i++) {
				var valueData:Object = angularVelocitysData[i];
				gradient.add(valueData.key, valueData.value / 180.0 * Math.PI);
			}
			return gradient;
		}
		
		private static function _initParticleFrame(overTimeFramesData:Object):GradientDataInt {
			var overTimeFrame:GradientDataInt = new GradientDataInt();
			var framesData:Array = overTimeFramesData.frames;
			for (var i:int = 0, n:int = framesData.length; i < n; i++) {
				var frameData:Object = framesData[i];
				overTimeFrame.add(frameData.key, frameData.value);
			}
			return overTimeFrame;
		}
		
		/** @private */
		public static function _parseMaterial(textureMap:Object, material:StandardMaterial, json:Object):void {
			var customProps:Object = json.customProps;
			var ambientColorValue:Array = customProps.ambientColor;
			material.ambientColor = new Vector3(ambientColorValue[0], ambientColorValue[1], ambientColorValue[2]);
			var diffuseColorValue:Array = customProps.diffuseColor;
			material.diffuseColor = new Vector3(diffuseColorValue[0], diffuseColorValue[1], diffuseColorValue[2]);
			var specularColorValue:Array = customProps.specularColor;
			material.specularColor = new Vector4(specularColorValue[0], specularColorValue[1], specularColorValue[2], specularColorValue[3]);
			var reflectColorValue:Array = customProps.reflectColor;
			material.reflectColor = new Vector3(reflectColorValue[0], reflectColorValue[1], reflectColorValue[2]);
			
			var diffuseTexture:String = customProps.diffuseTexture.texture2D;
			(diffuseTexture) && (material.diffuseTexture = Loader.getRes(textureMap[diffuseTexture]));
			
			var normalTexture:String = customProps.normalTexture.texture2D;
			(normalTexture) && (material.normalTexture = Loader.getRes(textureMap[normalTexture]));
			
			var specularTexture:String = customProps.specularTexture.texture2D;
			(specularTexture) && (material.specularTexture = Loader.getRes(textureMap[specularTexture]));
			
			var emissiveTexture:String = customProps.emissiveTexture.texture2D;
			(emissiveTexture) && (material.emissiveTexture = Loader.getRes(textureMap[emissiveTexture]));
			
			var ambientTexture:String = customProps.ambientTexture.texture2D;
			(ambientTexture) && (material.ambientTexture = Loader.getRes(textureMap[ambientTexture]));
			
			var reflectTexture:String = customProps.reflectTexture.texture2D;
			(reflectTexture) && (material.reflectTexture = Loader.getRes(textureMap[reflectTexture]));
		}
		
		/** @private */
		public static function _computeBoneAndAnimationDatas(bones:*, curData:Float32Array, exData:Float32Array, outBonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var offset:int = 0;
			var matOffset:int = 0;
			
			var len:int = exData.length / 2;
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
			
			for (i = 0; i < len; i += 16) {//将绝对矩阵乘以反置矩阵................................................
				Utils3D.mulMatrixByArrayFast(outBonesDatas, i, exData, len + i, outAnimationDatas, i);
			}
		}
		
		/** @private */
		public static function _computeAnimationDatas(exData:Float32Array, bonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
			var len:int = exData.length / 2;
			for (var i:int = 0; i < len; i += 16) {//将绝对矩阵乘以反置矩阵................................................
				Utils3D.mulMatrixByArrayFast(bonesDatas, i, exData, len + i, outAnimationDatas, i);
			}
		}
		
		/** @private */
		public static function _computeBoneAndAnimationDatasByBindPoseMatrxix(bones:*, curData:Float32Array, inverGlobalBindPose:Vector.<Matrix4x4>, outBonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
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
		public static function _computeAnimationDatasByArrayAndMatrixFast(inverGlobalBindPose:Vector.<Matrix4x4>, bonesDatas:Float32Array, outAnimationDatas:Float32Array):void {
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
		 * @private
		 */
		public function testTangent(renderElement:RenderElement, vertexBuffer:VertexBuffer3D, indeBuffer:IndexBuffer3D, bufferUsage:Object):VertexBuffer3D {
			var vertexDeclaration:VertexDeclaration = vertexBuffer.vertexDeclaration;
			var material:StandardMaterial = renderElement._material as StandardMaterial;//TODO待调整
			if (material.normalTexture && !vertexDeclaration.getVertexElementByUsage(VertexElementUsage.TANGENT0)) {
				var vertexDatas:Float32Array = vertexBuffer.getData();
				var newVertexDatas:Float32Array = Utils3D.generateTangent(vertexDatas, vertexDeclaration.vertexStride / 4, vertexDeclaration.getVertexElementByUsage(VertexElementUsage.POSITION0).offset / 4, vertexDeclaration.getVertexElementByUsage(VertexElementUsage.TEXTURECOORDINATE0).offset / 4, indeBuffer.getData());
				vertexDeclaration = Utils3D.getVertexTangentDeclaration(vertexDeclaration.getVertexElements());
				
				var newVB:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, WebGLContext.STATIC_DRAW);
				newVB.setData(newVertexDatas);
				vertexBuffer.dispose();
				
				bufferUsage[VertexElementUsage.TANGENT0] = newVB;
				return newVB;
			}
			return vertexBuffer;
		}
		
		/** @private */
		public static function generateTangent(vertexDatas:Float32Array, vertexStride:int, positionOffset:int, uvOffset:int, indices:Uint16Array/*还有UNIT8类型*/):Float32Array {
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
			var position:Boolean, normal:Boolean, color:Boolean, texcoord0:Boolean, texcoord1:Boolean, blendWeight:Boolean, blendIndex:Boolean;
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
				}
			}
			var vertexDeclaration:VertexDeclaration;
			
			if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorTexture0Texture1SkinTangent.vertexDeclaration;
			if (position && normal && color && texcoord0 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalTexture0Texture1SkinTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
				vertexDeclaration = VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1)
				vertexDeclaration = VertexPositionNormalColorTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && color && texcoord0)
				vertexDeclaration = VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1)
				vertexDeclaration = VertexPositionNormalTexture0Texture1Tangent.vertexDeclaration;
			else if (position && normal && texcoord0)
				vertexDeclaration = VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && color)
				vertexDeclaration = VertexPositionNormalColorTangent.vertexDeclaration;
			
			return vertexDeclaration;
		}
		
		/**
		 * 根据四元数旋转三维向量。
		 * @param	source 源三维向量。
		 * @param	rotation 旋转四元数。
		 * @param	out 输出三维向量。
		 */
		public static function transformVector3ArrayByQuat(sourceArray:Float32Array, sourceOffset:int, rotation:Quaternion, outArray:Float32Array, outOffset:int):void {
			var re:Float32Array = rotation.elements;
			
			var x:Number = sourceArray[sourceOffset], y:Number = sourceArray[sourceOffset + 1], z:Number = sourceArray[sourceOffset + 2], qx:Number = re[0], qy:Number = re[1], qz:Number = re[2], qw:Number = re[3],
			
			ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			
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
		 * 转换3D投影坐标系统到2D屏幕坐标系统，以像素为单位,通常用于正交投影下的3D坐标（（0，0）在屏幕中心）到2D屏幕坐标（（0，0）在屏幕左上角）的转换。
		 * @param	source 源坐标。
		 * @param	out 输出坐标。
		 */
		public static function convert3DCoordTo2DScreenCoord(source:Vector3, out:Vector3):void {
			var se:Array = source.elements;
			var oe:Array = out.elements;
			oe[0] = -RenderState.clientWidth / 2 + se[0];
			oe[1] = RenderState.clientHeight / 2 - se[1];
			oe[2] = se[2];
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
	}

}