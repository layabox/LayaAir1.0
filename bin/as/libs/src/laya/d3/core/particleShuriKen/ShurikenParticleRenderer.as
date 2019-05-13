package laya.d3.core.particleShuriKen {
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	import laya.d3.utils.Physics3DUtils;
	import laya.renders.Render;
	
	/**
	 * <code>ShurikenParticleRender</code> 类用于创建3D粒子渲染器。
	 */
	public class ShurikenParticleRenderer extends BaseRender {
		/** @private */
		private var _finalGravity:Vector3 = new Vector3();
		
		/** @private */
		private var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		
		/**@private */
		private var _defaultBoundBox:BoundBox;
		
		///**排序模式,无。*/
		//public const SORTINGMODE_NONE:int = 0;
		///**排序模式,通过摄像机距离排序,暂不支持。*/
		//public const SORTINGMODE_BYDISTANCE:int = 1;
		///**排序模式,年长的在前绘制,暂不支持。*/
		//public const SORTINGMODE_OLDESTINFRONT:int = 2;
		///**排序模式,年轻的在前绘制,暂不支持*/
		//public const SORTINGMODE_YOUNGESTINFRONT:int = 3;
		
		/**@private */
		private var _renderMode:int;
		/**@private */
		private var _mesh:Mesh;
		
		/**拉伸广告牌模式摄像机速度缩放,暂不支持。*/
		public var stretchedBillboardCameraSpeedScale:Number;
		/**拉伸广告牌模式速度缩放。*/
		public var stretchedBillboardSpeedScale:Number;
		/**拉伸广告牌模式长度缩放。*/
		public var stretchedBillboardLengthScale:Number;
		
		///**排序模式。*/
		//public var sortingMode:int;
		
		/**
		 * 获取渲染模式。
		 * @return 渲染模式。
		 */
		public function get renderMode():int {
			return _renderMode;
		}
		
		/**
		 * 获取网格渲染模式所使用的Mesh,rendderMode为4时生效。
		 * @return 网格模式所使用Mesh。
		 */
		public function get mesh():Mesh {
			return _mesh
		}
		
		/**
		 * 设置网格渲染模式所使用的Mesh,rendderMode为4时生效。
		 * @param value 网格模式所使用Mesh。
		 */
		public function set mesh(value:Mesh):void {
			if (_mesh !== value) {
				(_mesh) && (_mesh._removeReference());
				_mesh = value;
				(value) && (value._addReference());
				(_owner as ShuriKenParticle3D).particleSystem._initBufferDatas();
			}
		}
		
		/**
		 * 设置渲染模式,0为BILLBOARD、1为STRETCHEDBILLBOARD、2为HORIZONTALBILLBOARD、3为VERTICALBILLBOARD、4为MESH。
		 * @param value 渲染模式。
		 */
		public function set renderMode(value:int):void {
			if (_renderMode !== value) {
				var defineDatas:DefineDatas = _defineDatas;
				switch (_renderMode) {
				case 0: 
					defineDatas.remove(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_BILLBOARD);
					break;
				case 1: 
					defineDatas.remove(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_STRETCHEDBILLBOARD);
					break;
				case 2: 
					defineDatas.remove(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_HORIZONTALBILLBOARD);
					break;
				case 3: 
					defineDatas.remove(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_VERTICALBILLBOARD);
					break;
				case 4: 
					defineDatas.remove(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_MESH);
					break;
				}
				_renderMode = value;
				switch (value) {
				case 0: 
					defineDatas.add(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_BILLBOARD);
					break;
				case 1: 
					defineDatas.add(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_STRETCHEDBILLBOARD);
					break;
				case 2: 
					defineDatas.add(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_HORIZONTALBILLBOARD);
					break;
				case 3: 
					defineDatas.add(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_VERTICALBILLBOARD);
					break;
				case 4: 
					defineDatas.add(ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_MESH);
					break;
				default: 
					throw new Error("ShurikenParticleRender: unknown renderMode Value.");
				}
				(_owner as ShuriKenParticle3D).particleSystem._initBufferDatas();
			}
		}
		
		/**
		 * 创建一个 <code>ShurikenParticleRender</code> 实例。
		 */
		public function ShurikenParticleRenderer(owner:ShuriKenParticle3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(owner);
			_defaultBoundBox = new BoundBox(new Vector3(), new Vector3());
			_renderMode = -1;
			stretchedBillboardCameraSpeedScale = 0.0;
			stretchedBillboardSpeedScale = 0.0;
			stretchedBillboardLengthScale = 1.0;
			//sortingMode = SORTINGMODE_NONE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingBox():void {//TODO:日后需要计算包围盒的更新
			//var particleSystem:ShurikenParticleSystem = (_owner as ShuriKenParticle3D).particleSystem;
			//particleSystem._generateBoundingBox();
			//var rotation:Quaternion = _owner.transform.rotation;
			//var corners:Vector.<Vector3> = particleSystem._boundingBoxCorners;
			//for (var i:int = 0; i < 8; i++)
			//	Vector3.transformQuat(corners[i], rotation, _tempBoudingBoxCorners[i]);
			//BoundBox.createfromPoints(_tempBoudingBoxCorners, _boundingBox);
			
			var min:Vector3 = _boundingBox.min;
			min.x = -Number.MAX_VALUE;
			min.y = -Number.MAX_VALUE;
			min.z = -Number.MAX_VALUE;
			var max:Vector3 = _boundingBox.min;
			max.x = Number.MAX_VALUE;
			max.y = Number.MAX_VALUE;
			max.z = Number.MAX_VALUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _calculateBoundingSphere():void {
			var oriBoundSphere:BoundSphere = (_owner as ShuriKenParticle3D).particleSystem._boundingSphere;
			var maxScale:Number;
			var transform:Transform3D = _owner.transform;
			var scaleE:Vector3 = transform.scale;
			var scaleX:Number = Math.abs(scaleE.x);
			var scaleY:Number = Math.abs(scaleE.y);
			var scaleZ:Number = Math.abs(scaleE.z);
			
			if (scaleX >= scaleY && scaleX >= scaleZ)
				maxScale = scaleX;
			else
				maxScale = scaleY >= scaleZ ? scaleY : scaleZ;
			
			Vector3.transformCoordinate(oriBoundSphere.center, transform.worldMatrix, _boundingSphere.center);
			_boundingSphere.radius = oriBoundSphere.radius * maxScale;
			
			if (Render.supportWebGLPlusCulling) {//[NATIVE]
				var center:Vector3 = _boundingSphere.center;
				var buffer:Float32Array = FrustumCulling._cullingBuffer;
				buffer[_cullingBufferIndex + 1] = center.x;
				buffer[_cullingBufferIndex + 2] = center.y;
				buffer[_cullingBufferIndex + 3] = center.z;
				buffer[_cullingBufferIndex + 4] = _boundingSphere.radius;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _needRender(boundFrustum:BoundFrustum):Boolean {
			if (boundFrustum) {
				if (boundFrustum.containsBoundSphere(boundingSphere) !== ContainmentType.Disjoint) {
					if ((_owner as ShuriKenParticle3D).particleSystem.isAlive)
						return true;
					else
						return false;
				} else {
					return false;
				}
			} else {
				return true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _renderUpdate(context:RenderContext3D, transfrom:Transform3D):void {
			var particleSystem:ShurikenParticleSystem = (_owner as ShuriKenParticle3D).particleSystem;
			var sv:ShaderData = _shaderValues;
			var transform:Transform3D = _owner.transform;
			switch (particleSystem.simulationSpace) {
			case 0: //World
				break;
			case 1: //Local
				sv.setVector3(ShuriKenParticle3D.WORLDPOSITION, transform.position);
				sv.setQuaternion(ShuriKenParticle3D.WORLDROTATION, transform.rotation);
				break;
			default: 
				throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
			}
			
			switch (particleSystem.scaleMode) {
			case 0: 
				var scale:Vector3 = transform.scale;
				sv.setVector3(ShuriKenParticle3D.POSITIONSCALE, scale);
				sv.setVector3(ShuriKenParticle3D.SIZESCALE, scale);
				break;
			case 1: 
				var localScale:Vector3 = transform.localScale;
				sv.setVector3(ShuriKenParticle3D.POSITIONSCALE, localScale);
				sv.setVector3(ShuriKenParticle3D.SIZESCALE, localScale);
				break;
			case 2: 
				sv.setVector3(ShuriKenParticle3D.POSITIONSCALE, transform.scale);
				sv.setVector3(ShuriKenParticle3D.SIZESCALE, Vector3._ONE);
				break;
			}
			
			Vector3.scale(Physics3DUtils.gravity, particleSystem.gravityModifier, _finalGravity);
			sv.setVector3(ShuriKenParticle3D.GRAVITY, _finalGravity);
			sv.setInt(ShuriKenParticle3D.SIMULATIONSPACE, particleSystem.simulationSpace);
			sv.setBool(ShuriKenParticle3D.THREEDSTARTROTATION, particleSystem.threeDStartRotation);
			sv.setInt(ShuriKenParticle3D.SCALINGMODE, particleSystem.scaleMode);
			sv.setNumber(ShuriKenParticle3D.STRETCHEDBILLBOARDLENGTHSCALE, stretchedBillboardLengthScale);
			sv.setNumber(ShuriKenParticle3D.STRETCHEDBILLBOARDSPEEDSCALE, stretchedBillboardSpeedScale);
			sv.setNumber(ShuriKenParticle3D.CURRENTTIME, particleSystem._currentTime);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get boundingBox():BoundBox {
			if (!(_owner as ShuriKenParticle3D).particleSystem.isAlive) {
				return _defaultBoundBox;
			} else {
				if (_boundingBoxNeedChange) {
					_calculateBoundingBox();
					_boundingBoxNeedChange = false;
				}
				return _boundingBox;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _destroy():void {
			super._destroy();
			(_mesh) && (_mesh._removeReference(), _mesh = null);
		}
	
	}

}