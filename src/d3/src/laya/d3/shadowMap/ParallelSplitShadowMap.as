package laya.d3.shadowMap {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.RenderTexture2D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParallelSplitShadowMap {
		/**@private */
		public static const MAX_PSSM_COUNT:int = 3;
		
		/**@private */
		public static var _tempVector30:Vector3 = new Vector3();
		
		/**@private */
		private var lastNearPlane:Number;
		/**@private */
		private var lastFieldOfView:Number;
		/**@private */
		private var lastAspectRatio:Number;
		
		/**@private */
		private var _spiltDistance:Vector.<Number> = new Vector.<Number>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _currentPSSM:int = -1;
		/**@private */
		private var _shadowMapCount:int = 3;
		/**@private */
		private var _maxDistance:Number = 200.0;
		/**@private */
		private var _ratioOfDistance:Number = 1.0 / _shadowMapCount;
		/**@private */
		private var _globalParallelLightDir:Vector3 = new Vector3(0, -1, 0);
		/**@private */
		private var _statesDirty:Boolean = true;
		/**@private */
		public var cameras:Vector.<Camera>;
		/**@private */
		private var _shadowMapTextureSize:int = 1024;
		/**@private */
		private var _scene:Scene3D = null;
		/**@private */
		private var _boundingSphere:Vector.<BoundSphere> = new Vector.<BoundSphere>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		public var _boundingBox:Vector.<BoundBox> = new Vector.<BoundBox>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _frustumPos:Vector.<Vector3> = new Vector.<Vector3>((ParallelSplitShadowMap.MAX_PSSM_COUNT + 1) * 4);
		/**@private */
		private var _uniformDistance:Vector.<Number> = new Vector.<Number>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _logDistance:Vector.<Number> = new Vector.<Number>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _dimension:Vector.<Vector2> = new Vector.<Vector2>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/** @private */
		private var _PCFType:int = 0;
		/** @private */
		private var _tempLookAt3:Vector3 = new Vector3();
		/** @private */
		private var _tempLookAt4:Vector4 = new Vector4();
		/** @private */
		private var _tempValue:Vector4 = new Vector4();
		/** @private */
		private var _tempPos:Vector3 = new Vector3();
		/** @private */
		private var _tempLightUp:Vector3 = new Vector3();
		/** @private */
		private var _tempMin:Vector4 = new Vector4();
		/** @private */
		private var _tempMax:Vector4 = new Vector4();
		/** @private */
		private var _tempMatrix44:Matrix4x4 = new Matrix4x4;
		/**@private */
		private var _splitFrustumCulling:BoundFrustum = new BoundFrustum(Matrix4x4.DEFAULT);
		/** @private */
		private var _tempScaleMatrix44:Matrix4x4 = new Matrix4x4();
		/** @private */
		private var _shadowPCFOffset:Vector2 = new Vector2(1.0 / 1024.0, 1.0 / 1024.0);
		/** @private */
		private var _shaderValueDistance:Vector4 = new Vector4();
		/** @private */
		private var _shaderValueLightVP:Float32Array = null;
		/** @private */
		private var _shaderValueVPs:Vector.<Float32Array>;
		
		public function ParallelSplitShadowMap() {
			cameras = new Vector.<Camera>();
			_shaderValueVPs = new Vector.<Float32Array>();
			var i:int;
			for (i = 0; i < _spiltDistance.length; i++) {
				_spiltDistance[i] = 0.0;
			}
			
			for (i = 0; i < _dimension.length; i++) {
				_dimension[i] = new Vector2();
			}
			
			for (i = 0; i < _frustumPos.length; i++) {
				_frustumPos[i] = new Vector3();
			}
			
			for (i = 0; i < _boundingBox.length; i++) {
				_boundingBox[i] = new BoundBox(new Vector3(), new Vector3());
			}
			
			for (i = 0; i < _boundingSphere.length; i++) {
				_boundingSphere[i] = new BoundSphere(new Vector3(), 0.0);
			}
			
			Matrix4x4.createScaling(new Vector3(0.5, 0.5, 1.0), _tempScaleMatrix44);
			_tempScaleMatrix44.elements[12] = 0.5;
			_tempScaleMatrix44.elements[13] = 0.5;
		}
		
		public function setInfo(scene:Scene3D, maxDistance:Number, globalParallelDir:Vector3, shadowMapTextureSize:int, numberOfPSSM:int, PCFType:int):void {
			if (numberOfPSSM > ParallelSplitShadowMap.MAX_PSSM_COUNT) {
				_shadowMapCount = ParallelSplitShadowMap.MAX_PSSM_COUNT;
			}
			_scene = scene;
			_maxDistance = maxDistance;
			shadowMapCount = numberOfPSSM;
			_globalParallelLightDir = globalParallelDir;
			_ratioOfDistance = 1.0 / _shadowMapCount;
			for (var i:int = 0; i < _spiltDistance.length; i++) {
				_spiltDistance[i] = 0.0;
			}
			_shadowMapTextureSize = shadowMapTextureSize;
			_shadowPCFOffset.x = 1.0 / _shadowMapTextureSize;
			_shadowPCFOffset.y = 1.0 / _shadowMapTextureSize;
			setPCFType(PCFType);
			_statesDirty = true;
		}
		
		public function setPCFType(PCFtype:int):void {
			_PCFType = PCFtype;
			var defineData:DefineDatas = _scene._defineDatas;
			switch (_PCFType) {
			case 0: 
				defineData.add(Scene3D.SHADERDEFINE_SHADOW_PCF_NO);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF1);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF2);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF3);
				break;
			case 1: 
				defineData.add(Scene3D.SHADERDEFINE_SHADOW_PCF1);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF_NO);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF2);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF3);
				break;
			case 2: 
				defineData.add(Scene3D.SHADERDEFINE_SHADOW_PCF2);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF_NO);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF1);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF3);
				break;
			case 3: 
				defineData.add(Scene3D.SHADERDEFINE_SHADOW_PCF3);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF_NO);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF1);
				defineData.remove(Scene3D.SHADERDEFINE_SHADOW_PCF2);
				break;
			}
		}
		
		public function getPCFType():int {
			return _PCFType;
		}
		
		public function setFarDistance(value:Number):void {
			if (_maxDistance != value) {
				_maxDistance = value;
				_statesDirty = true;
			}
		}
		
		public function getFarDistance():Number {
			return _maxDistance;
		}
		
		public function set shadowMapCount(value:int):void {
			value = value > 0 ? value : 1;
			value = value <= MAX_PSSM_COUNT ? value : MAX_PSSM_COUNT;
			if (_shadowMapCount != value) {
				_shadowMapCount = value;
				_ratioOfDistance = 1.0 / _shadowMapCount;
				_statesDirty = true;
				
				_shaderValueLightVP = new Float32Array(value * 16);
				_shaderValueVPs.length = value;
				for (var i:int = 0; i < value; i++) 
					_shaderValueVPs[i] = new Float32Array(_shaderValueLightVP.buffer, i * 64);
			}
		}
		
		public function get shadowMapCount():int {
			return _shadowMapCount;
		}
		
		/**
		 * @private
		 */
		private function _beginSampler(index:int, sceneCamera:BaseCamera):void {
			if (index < 0 || index > _shadowMapCount) //TODO:
				throw new Error("ParallelSplitShadowMap: beginSample invalid index");
			
			_currentPSSM = index;
			_update(sceneCamera);
		}
		
		/**
		 * @private
		 */
		public function endSampler(sceneCamera:BaseCamera):void {
			_currentPSSM = -1;
		}
		
		/**
		 * @private
		 */
		public function _calcAllLightCameraInfo(sceneCamera:BaseCamera):void {
			if (_shadowMapCount === 1) {
				_beginSampler(0, sceneCamera);
				endSampler(sceneCamera);
			} else {
				for (var i:int = 0, n:int = _shadowMapCount + 1; i < n; i++) {
					_beginSampler(i, sceneCamera);
					endSampler(sceneCamera);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _recalculate(nearPlane:Number, fieldOfView:Number, aspectRatio:Number):void {
			_calcSplitDistance(nearPlane);
			_calcBoundingBox(fieldOfView, aspectRatio);
			_rebuildRenderInfo();
		}
		
		/**
		 * @private
		 */
		private function _update(sceneCamera:BaseCamera):void {
			var nearPlane:Number = sceneCamera.nearPlane;
			var fieldOfView:Number = sceneCamera.fieldOfView;
			var aspectRatio:Number = (sceneCamera as Camera).aspectRatio;
			if (_statesDirty || lastNearPlane !== nearPlane || lastFieldOfView !== fieldOfView || lastAspectRatio !== aspectRatio) {//TODO:同一场景多摄像机频繁切换仍会重新计算,将包围矩阵存到摄像机自身可解决
				_recalculate(nearPlane, fieldOfView, aspectRatio);
				_uploadShaderValue();
				_statesDirty = false;
				lastNearPlane = nearPlane;
				lastFieldOfView = fieldOfView;
				lastAspectRatio = aspectRatio;
			}
			//calcSplitFrustum(sceneCamera);
			_calcLightViewProject(sceneCamera);
		}
		
		/**
		 * @private
		 */
		private function _uploadShaderValue():void {
			var defDatas:DefineDatas = _scene._defineDatas;
			switch (_shadowMapCount) {
			case 1: 
				defDatas.add(Scene3D.SHADERDEFINE_SHADOW_PSSM1);
				defDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM2);
				defDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM3);
				break;
			case 2: 
				defDatas.add(Scene3D.SHADERDEFINE_SHADOW_PSSM2);
				defDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM1);
				defDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM3);
				break;
			case 3: 
				defDatas.add(Scene3D.SHADERDEFINE_SHADOW_PSSM3);
				defDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM1);
				defDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM2);
				break;
			}
			
			var sceneSV:ShaderData = _scene._shaderValues;
			sceneSV.setVector(Scene3D.SHADOWDISTANCE, _shaderValueDistance);
			sceneSV.setBuffer(Scene3D.SHADOWLIGHTVIEWPROJECT, _shaderValueLightVP);
			sceneSV.setVector2(Scene3D.SHADOWMAPPCFOFFSET, _shadowPCFOffset);
			switch (_shadowMapCount) {
			case 3: 
				sceneSV.setTexture(Scene3D.SHADOWMAPTEXTURE1, cameras[1].renderTarget);
				sceneSV.setTexture(Scene3D.SHADOWMAPTEXTURE2, cameras[2].renderTarget)
				sceneSV.setTexture(Scene3D.SHADOWMAPTEXTURE3, cameras[3].renderTarget);
				break;
			case 2: 
				sceneSV.setTexture(Scene3D.SHADOWMAPTEXTURE1, cameras[1].renderTarget);
				sceneSV.setTexture(Scene3D.SHADOWMAPTEXTURE2, cameras[2].renderTarget);
				break;
			case 1: 
				sceneSV.setTexture(Scene3D.SHADOWMAPTEXTURE1, cameras[1].renderTarget);
				break;
			}
		}
		
		/**
		 * @private
		 */
		private function _calcSplitDistance(nearPlane:Number):void {
			var far:Number = _maxDistance;
			var invNumberOfPSSM:Number = 1.0 / _shadowMapCount;
			var i:int;
			for (i = 0; i <= _shadowMapCount; i++) {
				_uniformDistance[i] = nearPlane + (far - nearPlane) * i * invNumberOfPSSM;
			}
			
			var farDivNear:Number = far / nearPlane;
			for (i = 0; i <= _shadowMapCount; i++) {
				var n:Number = Math.pow(farDivNear, i * invNumberOfPSSM);
				_logDistance[i] = nearPlane * n;
			}
			
			for (i = 0; i <= _shadowMapCount; i++) {
				_spiltDistance[i] = _uniformDistance[i] * _ratioOfDistance + _logDistance[i] * (1.0 - _ratioOfDistance);
			}
			_shaderValueDistance.x = _spiltDistance[1];
			_shaderValueDistance.y = _spiltDistance[2];
			_shaderValueDistance.z = _spiltDistance[3];
			_shaderValueDistance.w = 0.0; //_spiltDistance[4]为undefine 微信小游戏
		}
		
		/**
		 * @private
		 */
		public function _calcBoundingBox(fieldOfView:Number, aspectRatio:Number):void {
			var fov:Number = 3.1415926 * fieldOfView / 180.0;
			
			var halfTanValue:Number = Math.tan(fov / 2.0);
			
			var height:Number;
			var width:Number;
			var distance:Number;
			
			var i:int;
			for (i = 0; i <= _shadowMapCount; i++) {
				distance = _spiltDistance[i];
				height = distance * halfTanValue;
				width = height * aspectRatio;
				
				var temp:* = _frustumPos[i * 4 + 0];
				temp.x = -width;// distance * 0.0 - height * 0.0 + width * -1.0
				temp.y = -height;//distance * 0.0 - height * 1.0 + width * 0.0
				temp.z = -distance;// distance * -1.0 - height * 0.0 + width * 0.0
				
				temp = _frustumPos[i * 4 + 1];
				temp.x = width;// distance * 0.0 - height * 0.0 - width * -1.0
				temp.y = -height;// distance * 0.0 - height * 1.0 - width * 0.0
				temp.z = -distance;//distance * -1.0 - height * 0.0 - width * 0.0
				
				temp = _frustumPos[i * 4 + 2];
				temp.x = -width;// distance * 0.0 + width * -1 + height * 0.0
				temp.y = height;// distance * 0.0 + width * 0.0 + height * 1.0
				temp.z = -distance;// distance * -1.0 + width * 0.0 + height * 0.0
				
				temp = _frustumPos[i * 4 + 3];
				temp.x = width;// distance * 0.0 - width * -1 + height * 0.0
				temp.y = height;// distance * 0.0 - width * 0.0 + height * 1.0
				temp.z = -distance;// distance * -1.0 - width * 0.0 + height * 0.0
				
				temp = _dimension[i];
				temp.x = width;
				temp.y = height;
			}
			
			var d:Vector2;
			var min:Vector3;
			var max:Vector3;
			var center:Vector3;
			for (i = 1; i <= _shadowMapCount; i++) {
				
				d = _dimension[i];
				min = _boundingBox[i].min;
				
				min.x = -d.x;
				min.y = -d.y;
				min.z = -_spiltDistance[i];
				
				max = _boundingBox[i].max;
				max.x = d.x;
				max.y = d.y;
				max.z = -_spiltDistance[i - 1];
				
				center = _boundingSphere[i].center;
				center.x = (min.x + max.x) * 0.5;
				center.y = (min.y + max.y) * 0.5;
				center.z = (min.z + max.z) * 0.5;
				_boundingSphere[i].radius = Math.sqrt(Math.pow(max.x - min.x, 2) + Math.pow(max.y - min.y, 2) + Math.pow(max.z - min.z, 2)) * 0.5;
			}
			
			min = _boundingBox[0].min;
			d = _dimension[_shadowMapCount];
			min.x = -d.x;
			min.y = -d.y;
			min.z = -_spiltDistance[_shadowMapCount];
			
			max = _boundingBox[0].max;
			max.x = d.x;
			max.y = d.y;
			max.z = -_spiltDistance[0];
			
			center = _boundingSphere[0].center;
			center.x = (min.x + max.x) * 0.5;
			center.y = (min.y + max.y) * 0.5;
			center.z = (min.z + max.z) * 0.5;
			_boundingSphere[0].radius = Math.sqrt(Math.pow(max.x - min.x, 2) + Math.pow(max.y - min.y, 2) + Math.pow(max.z - min.z, 2)) * 0.5;
		}
		
		public function calcSplitFrustum(sceneCamera:BaseCamera):void {
			if (_currentPSSM > 0) {
				Matrix4x4.createPerspective(3.1416 * sceneCamera.fieldOfView / 180.0, (sceneCamera as Camera).aspectRatio, _spiltDistance[_currentPSSM - 1], _spiltDistance[_currentPSSM], _tempMatrix44);
			} else {
				Matrix4x4.createPerspective(3.1416 * sceneCamera.fieldOfView / 180.0, (sceneCamera as Camera).aspectRatio, _spiltDistance[0], _spiltDistance[_shadowMapCount], _tempMatrix44);
			}
			Matrix4x4.multiply(_tempMatrix44, (sceneCamera as Camera).viewMatrix, _tempMatrix44);
			_splitFrustumCulling.matrix = _tempMatrix44;
		}
		
		/**
		 * @private
		 */
		private function _rebuildRenderInfo():void {
			var nNum:int = _shadowMapCount + 1;
			var i:int;
			cameras.length = nNum;
			for (i = 0; i < nNum; i++) {
				if (!cameras[i]) {
					var camera:Camera = new Camera();
					camera.name = "lightCamera" + i;
					camera.clearColor = new Vector4(1.0, 1.0, 1.0, 1.0);
					cameras[i] = camera;
				}
				
				var shadowMap:RenderTexture = cameras[i].renderTarget;
				if (shadowMap == null || shadowMap.width != _shadowMapTextureSize || shadowMap.height != _shadowMapTextureSize) {
					(shadowMap) && (shadowMap.destroy());
					shadowMap = new RenderTexture(_shadowMapTextureSize, _shadowMapTextureSize, BaseTexture.FORMAT_R8G8B8A8, BaseTexture.FORMAT_DEPTH_16);
					shadowMap.filterMode = BaseTexture.FILTERMODE_POINT;
					cameras[i].renderTarget = shadowMap;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _calcLightViewProject(sceneCamera:BaseCamera):void {
			var boundSphere:BoundSphere = _boundingSphere[_currentPSSM];
			var cameraMatViewInv:Matrix4x4 = sceneCamera.transform.worldMatrix;
			var radius:Number = boundSphere.radius;
			boundSphere.center.cloneTo(_tempLookAt3);
			Vector3.transformV3ToV4(_tempLookAt3, cameraMatViewInv, _tempLookAt4);
			var lookAt3Element:Vector3 = _tempLookAt3;
			var lookAt4Element:Vector4 = _tempLookAt4;
			lookAt3Element.x = lookAt4Element.x;
			lookAt3Element.y = lookAt4Element.y;
			lookAt3Element.z = lookAt4Element.z;
			var lightUpElement:Vector3 = _tempLightUp;
			sceneCamera.transform.worldMatrix.getForward(_tempVector30);
			var sceneCameraDir:Vector3 = _tempVector30;
			lightUpElement.x = sceneCameraDir.x;
			lightUpElement.y = 1.0;
			lightUpElement.z = sceneCameraDir.z;
			Vector3.normalize(_tempLightUp, _tempLightUp);
			Vector3.scale(_globalParallelLightDir, boundSphere.radius * 4, _tempPos);
			Vector3.subtract(_tempLookAt3, _tempPos, _tempPos);
			var curLightCamera:Camera = cameras[_currentPSSM];
			curLightCamera.transform.position = _tempPos;
			curLightCamera.transform.lookAt(_tempLookAt3, _tempLightUp, false);
			var tempMax:Vector4 = _tempMax;
			var tempMin:Vector4 = _tempMin;
			tempMax.x = tempMax.y = tempMax.z = -100000.0;
			tempMax.w = 1.0;
			tempMin.x = tempMin.y = tempMin.z = 100000.0;
			tempMin.w = 1.0;
			/*
			   var offSet:int; var offSet1:int; var offSet2:int;
			   if (_currentPSSM == 0) {
			   offSet1 = 0;
			   offSet2 = _numberOfPSSM * 3;
			   }
			   else {
			   offSet1 = (_currentPSSM - 1) * 4;
			   offSet2 = offSet1;
			   }
			   //Convert  matrix : from view space->world space->light view space
			   Matrix4x4.multiply(_lightCamera.viewMatrix, cameraMatViewInv, _tempMatrix44);
			   var tempValueElement:Float32Array = _tempValue.elements;
			   for (var i:int= 0; i < 8 ; i++ ) {
			   offSet = (i < 4) ? offSet1 : offSet2;
			   var frustumPosElements:Float32Array = _frustumPos[offSet + i].elements;
			   tempValueElement[0] = frustumPosElements[0];
			   tempValueElement[1] = frustumPosElements[1];
			   tempValueElement[2] = frustumPosElements[2];
			   tempValueElement[3] = 1.0;
			   Vector4.transformByM4x4(_tempValue, _tempMatrix44, _tempValue);
			   tempMinElements[0] = (tempValueElement[0] < tempMinElements[0]) ? tempValueElement[0] : tempMinElements[0];
			   tempMinElements[1] = (tempValueElement[1] < tempMinElements[1]) ? tempValueElement[1] : tempMinElements[1];
			   tempMinElements[2] = (tempValueElement[2] < tempMinElements[2]) ? tempValueElement[2] : tempMinElements[2];
			   tempMaxElements[0] = (tempValueElement[0] > tempMaxElements[0]) ? tempValueElement[0] : tempMaxElements[0];
			   tempMaxElements[1] = (tempValueElement[1] > tempMaxElements[1]) ? tempValueElement[1] : tempMaxElements[1];
			   tempMaxElements[2] = (tempValueElement[2] > tempMaxElements[2]) ? tempValueElement[2] : tempMaxElements[2];
			   }
			 */
			Matrix4x4.multiply(curLightCamera.viewMatrix, cameraMatViewInv, _tempMatrix44);
			var tempValueElement:Vector4 = _tempValue;
			var corners:Vector.<Vector3> = new Vector.<Vector3>();
			corners.length = 8;
			_boundingBox[_currentPSSM].getCorners(corners);
			for (var i:int = 0; i < 8; i++) {
				var frustumPosElements:Vector3 = corners[i];
				tempValueElement.x = frustumPosElements.x;
				tempValueElement.y = frustumPosElements.y;
				tempValueElement.z = frustumPosElements.z;
				tempValueElement.w = 1.0;
				Vector4.transformByM4x4(_tempValue, _tempMatrix44, _tempValue);
				tempMin.x = (tempValueElement.x < tempMin.x) ? tempValueElement.x : tempMin.x;
				tempMin.y = (tempValueElement.y < tempMin.y) ? tempValueElement.y : tempMin.y;
				tempMin.z = (tempValueElement.z < tempMin.z) ? tempValueElement.z : tempMin.z;
				tempMax.x = (tempValueElement.x > tempMax.x) ? tempValueElement.x : tempMax.x;
				tempMax.y = (tempValueElement.y > tempMax.y) ? tempValueElement.y : tempMax.y;
				tempMax.z = (tempValueElement.z > tempMax.z) ? tempValueElement.z : tempMax.z;
			}
			//现在tempValueElement变成了center
			Vector4.add(_tempMax, _tempMin, _tempValue);
			tempValueElement.x *= 0.5;
			tempValueElement.y *= 0.5;
			tempValueElement.z *= 0.5;
			tempValueElement.w = 1;
			Vector4.transformByM4x4(_tempValue, curLightCamera.transform.worldMatrix, _tempValue);
			var distance:Number = Math.abs(-_tempMax.z);
			var farPlane:Number = distance > _maxDistance ? distance : _maxDistance;
			//build light's view and project matrix
			Vector3.scale(_globalParallelLightDir, farPlane, _tempPos);
			var tempPosElement:Vector3 = _tempPos;
			tempPosElement.x = tempValueElement.x - tempPosElement.x;
			tempPosElement.y = tempValueElement.y - tempPosElement.y;
			tempPosElement.z = tempValueElement.z - tempPosElement.z;
			curLightCamera.transform.position = _tempPos;
			curLightCamera.transform.lookAt(_tempLookAt3, _tempLightUp, false);
			Matrix4x4.createOrthoOffCenter(tempMin.x, tempMax.x, tempMin.y, tempMax.y, 1.0, farPlane + 0.5 * (tempMax.z - tempMin.z), curLightCamera.projectionMatrix);
			
			//calc frustum
			var projectView:Matrix4x4 = curLightCamera.projectionViewMatrix;
			multiplyMatrixOutFloat32Array(_tempScaleMatrix44, projectView, _shaderValueVPs[_currentPSSM]);
			_scene._shaderValues.setBuffer(Scene3D.SHADOWLIGHTVIEWPROJECT, _shaderValueLightVP);
		}
		
		/**
		 * 计算两个矩阵的乘法
		 * @param	left left矩阵
		 * @param	right  right矩阵
		 * @param	out  输出矩阵
		 */
		public static function multiplyMatrixOutFloat32Array(left:Matrix4x4, right:Matrix4x4, out:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, a:Float32Array, b:Float32Array, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			a = left.elements;
			b = right.elements;
			for (i = 0; i < 4; i++) {
				ai0 = a[i];
				ai1 = a[i + 4];
				ai2 = a[i + 8];
				ai3 = a[i + 12];
				out[i] = ai0 * b[0] + ai1 * b[1] + ai2 * b[2] + ai3 * b[3];
				out[i + 4] = ai0 * b[4] + ai1 * b[5] + ai2 * b[6] + ai3 * b[7];
				out[i + 8] = ai0 * b[8] + ai1 * b[9] + ai2 * b[10] + ai3 * b[11];
				out[i + 12] = ai0 * b[12] + ai1 * b[13] + ai2 * b[14] + ai3 * b[15];
			}
		}
		
		public function setShadowMapTextureSize(size:int):void {
			if (size !== _shadowMapTextureSize) {
				_shadowMapTextureSize = size;
				_shadowPCFOffset.x = 1 / _shadowMapTextureSize;
				_shadowPCFOffset.y = 1 / _shadowMapTextureSize;
				_statesDirty = true;
			}
		}
		
		public function disposeAllRenderTarget():void {
			for (var i:int = 0, n:int = _shadowMapCount + 1; i < n; i++) {
				if (cameras[i].renderTarget) {
					cameras[i].renderTarget.destroy();
					cameras[i].renderTarget = null;
				}
			}
		}
	}
}