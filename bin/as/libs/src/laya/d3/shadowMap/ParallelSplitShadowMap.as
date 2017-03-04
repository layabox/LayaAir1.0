package laya.d3.shadowMap 
{
	import laya.d3.core.light.LightSprite;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.core.Camera;
	import laya.d3.resource.RenderTexture;
	/**
	 * ...
	 * @author ...
	 */
	public class ParallelSplitShadowMap 
	{
		public static const MAX_PSSM_COUNT:int = 4;
		
		/**@private */
		private var _spiltDistance:Vector.<Number> = new Vector.<Number>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _currentPSSM:int = -1;
		/**@private */
		private var _numberOfPSSM:int = 3;
		/**@private */
		private var _maxDistance:Number = 200.0;
		/**@private */
		private var _ratioOfDistance:Number = 1.0 / _numberOfPSSM;
		/**@private */
		private var _globalParallelLightDir:Vector3 = new Vector3(0,-1,0);
		/**@private */
		private var _lightDirLength:Number = 1.0;
		/**@private */
		private var _samplerEmbeddedCount:int = 0;
		/**@private */
		private var _statesDirty:Boolean = true;
		/**@private */
		private var _involvedShadowMapRange:BoundBox = new BoundBox(new Vector3(), new Vector3());
		/**@private */
		private var _tempInvolvedShadowMapRange:BoundBox = new BoundBox(new Vector3(),new Vector3());
		/**@private */
		private var _lightCulling:BoundFrustum = new BoundFrustum(Matrix4x4.DEFAULT);
		/** @private */
		private var _renderTarget:Vector.<RenderTexture> = new Vector.<RenderTexture>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _shadowMapTextureSize:int = 1024;
		/**@private */
		public var _sceneCamera:Camera;
		/**@private */
		private var _lightCamera:Camera = new Camera();
		/**@private */
		private var _boundingSphere:Vector.<BoundSphere> = new Vector.<BoundSphere>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		public var _boundingBox:Vector.<BoundBox> = new Vector.<BoundBox>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _lightViewProjectionMatrix:Vector.<Matrix4x4> = new Vector.<Matrix4x4>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _frustumPos:Vector.<Vector3> = new Vector.<Vector3>((ParallelSplitShadowMap.MAX_PSSM_COUNT + 1)*4);
		/**@private */
		private var _uniformDistance:Vector.<Number> = new Vector.<Number>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _logDistance:Vector.<Number> = new Vector.<Number>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
		/**@private */
		private var _dimension:Vector.<Vector2> = new Vector.<Vector2>(ParallelSplitShadowMap.MAX_PSSM_COUNT + 1);
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
		private var _tempScaleMatrix44:Matrix4x4 = new Matrix4x4;
		
		
		public function ParallelSplitShadowMap() 
		{
			var i:int;
			for (i = 0; i < _spiltDistance.length; i++) {
				_spiltDistance[i] = 0.0;	
			}
			
			setInvolvedShadowMapRange(_maxDistance);
			
			for (i = 0; i < _dimension.length; i++) {
				_dimension[i] = new Vector2();	
			}
			
			for (i = 0; i < _frustumPos.length; i++) {
				_frustumPos[i] = new Vector3();	
			}
			
			for (i = 0; i < _lightViewProjectionMatrix.length; i++) {
				_lightViewProjectionMatrix[i] = new Matrix4x4();
			}
			
			for (i = 0; i < _boundingBox.length; i++) {
				_boundingBox[i] = new BoundBox(new Vector3(), new Vector3());
			}
			
			for (i = 0; i < _boundingSphere.length; i++) {
				_boundingSphere[i] = new BoundSphere(new Vector3(), 0.0);
			}
			
			var n:int = _numberOfPSSM +1;
			for (i = 0; i < n ; i++ ) {
				_renderTarget[i] = new RenderTexture(_shadowMapTextureSize,_shadowMapTextureSize);
			}
			
			Matrix4x4.createScaling(new Vector3(0.5, 0.5, 1.0), _tempScaleMatrix44);
			_tempScaleMatrix44.elements[12] = 0.5;
			_tempScaleMatrix44.elements[13] = 0.5;
		}
		public function setInfo(sceneCamera:Camera, maxDistance:Number, globalParallelDir:Vector3, shadowMapTextureSize:int, numberOfPSSM:int):void {
			if (numberOfPSSM > ParallelSplitShadowMap.MAX_PSSM_COUNT) {
				_numberOfPSSM = ParallelSplitShadowMap.MAX_PSSM_COUNT;
			}
			_sceneCamera = sceneCamera;
			_maxDistance = maxDistance;
			_numberOfPSSM = numberOfPSSM;
			_lightDirLength = Vector3.scalarLength(_globalParallelLightDir);
			Vector3.normalize(globalParallelDir,_globalParallelLightDir);
			_ratioOfDistance = 1.0 / _numberOfPSSM;
			for (var i:int = 0; i < _spiltDistance.length; i++) {
				_spiltDistance[i] = 0.0;	
			}
			_shadowMapTextureSize = shadowMapTextureSize;
			_statesDirty = true;
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
		public function setNumberOfFrumstum(value:int):void {
			if (_numberOfPSSM != value) {
				_numberOfPSSM = value;
				_ratioOfDistance = 1.0 / _numberOfPSSM;
				_statesDirty = true;
			}
		}
		public function getNumberOfFrumstum():int {
			return _numberOfPSSM;
		}
		public function setGlobalParallelLightDir(dir:Vector3):void {
			if (Vector3.equals(_globalParallelLightDir,dir)) {
				_globalParallelLightDir = dir;
				_lightDirLength = Vector3.scalarLength(_globalParallelLightDir);
			}
		}
		public function getGlobalParallelLightDir():Vector3 {
			return _globalParallelLightDir;
		}
		public function setCurrentPSSM(index:int):void {
			if (_currentPSSM != index) {
				_currentPSSM = index;	
			}
		}
		public function getCurrentPSSM():int {
			return _currentPSSM;
		}
		public function getLightCamera():Camera {
			return _lightCamera;
		}
		public function beginSampler(index:int):void {
			if (index < 0 || index > _numberOfPSSM){	
				throw new Error("Camera: beginSample invalid index");	
			}
			setCurrentPSSM(index);
			update();
			_samplerEmbeddedCount++;
		}
		public function endSampler():void {
			if (_samplerEmbeddedCount == 0) {
				return;
			} 
			_currentPSSM = -1;
			_samplerEmbeddedCount--;
		}
		
		public function recalculate():void {
			calcSplitDistance();
			calcBoundingBox();
			rebuildRenderTarget();
			setInvolvedShadowMapRange(_maxDistance);
			_statesDirty = false;	
		}
		public function update():void {
			if (_statesDirty) {
				recalculate();
			}
			calcSplitFrustum();
			calcLightViewProject();
		}
		public function calcSplitDistance():void {
			if (!_statesDirty) {
				return;
			}
			var near:Number = _sceneCamera.nearPlane;
			var far:Number = _maxDistance;
			
			var invNumberOfPSSM:Number = 1.0 / _numberOfPSSM;
			
			var i:int;
			for (i = 0; i <= _numberOfPSSM; i++) {
				_uniformDistance[i] = near + (far - near) * i * invNumberOfPSSM;
			}
			
			var farDivNear:Number = far / near;
			for (i = 0; i <= _numberOfPSSM; i++) {
				var n:Number = Math.pow(farDivNear, i * invNumberOfPSSM);
				_logDistance[i] = near * n;
			}
			
			for (i = 0; i <= _numberOfPSSM; i++) {
				_spiltDistance[i] = _uniformDistance[i] * _ratioOfDistance + _logDistance[i] * (1.0 - _ratioOfDistance);
			}
			//TODO 传参
		}
		public function calcBoundingBox():void {
			if (!_statesDirty) {
				return;
			}
			var fov:Number = 3.1416 * _sceneCamera.fieldOfView / 180.0;
			var aspect:Number = _sceneCamera.aspectRatio;
			
			var halfTanValue:Number = Math.tan(fov / 2.0);
			
			var height:Number;
			var width:Number;
			var distance:Number;
			
			var i:int;
			for (i = 0; i <= _numberOfPSSM; i++ ) {
				distance = _spiltDistance[i];
				height = distance * halfTanValue;
				width = height * aspect;
				
				var temp:Float32Array = _frustumPos[i * 4 + 0].elements;
				temp[0] = -width;// distance * 0.0 - height * 0.0 + width * -1.0
				temp[1] = -height;//distance * 0.0 - height * 1.0 + width * 0.0
				temp[2] = -distance;// distance * -1.0 - height * 0.0 + width * 0.0
				
				temp = _frustumPos[i * 4 + 1].elements;
				temp[0] = width;// distance * 0.0 - height * 0.0 - width * -1.0
				temp[1] = -height;// distance * 0.0 - height * 1.0 - width * 0.0
				temp[2] = -distance;//distance * -1.0 - height * 0.0 - width * 0.0
				
				temp = _frustumPos[i * 4 + 2].elements;
				temp[0] = -width;// distance * 0.0 + width * -1 + height * 0.0
				temp[1] = height;// distance * 0.0 + width * 0.0 + height * 1.0
				temp[2] = -distance;// distance * -1.0 + width * 0.0 + height * 0.0
				
				temp = _frustumPos[i * 4 + 3].elements;
				temp[0] = width;// distance * 0.0 - width * -1 + height * 0.0
				temp[1] = height;// distance * 0.0 - width * 0.0 + height * 1.0
				temp[2] = -distance;// distance * -1.0 - width * 0.0 + height * 0.0
				
				temp = _dimension[i].elements;
				temp[0] = width;
				temp[1] = height;
			}
			
			var d:Float32Array;
			var min:Float32Array;
			var max:Float32Array;
			var center:Float32Array;
			for (i = 1; i <= _numberOfPSSM; i++ ) {
				
				d = _dimension[i].elements;
				min = _boundingBox[i].min.elements;
				
				min[0] = -d[0];
				min[1] = -d[1];
				min[2] = -_spiltDistance[i];
				
				max = _boundingBox[i].max.elements;
				max[0] = d[0];
				max[1] = d[1];
				max[2] =-_spiltDistance[i - 1];
				
				center = _boundingSphere[i].center.elements;
				center[0] = (min[0] + max[0]) * 0.5;
				center[1] = (min[1] + max[1]) * 0.5;
				center[2] = (min[2] + max[2]) * 0.5;
			    _boundingSphere[i].radius = Math.sqrt(Math.pow(max[0] - min[0],2)+Math.pow(max[1] - min[1],2)+Math.pow(max[2] - min[2],2)) * 0.5;
			}
			
			min = _boundingBox[0].min.elements;
			d = _dimension[_numberOfPSSM].elements;
			min[0] = -d[0];
			min[1] = -d[1];
			min[2] = -_spiltDistance[_numberOfPSSM];
			
			max = _boundingBox[0].max.elements;
			max[0] = d[0];
			max[1] = d[1];
			max[2] = -_spiltDistance[0];
				
			center = _boundingSphere[0].center.elements;
			center[0] = (min[0] + max[0]) * 0.5;
			center[1] = (min[1] + max[1]) * 0.5;
			center[2] = (min[2] + max[2]) * 0.5;
			_boundingSphere[0].radius = Math.sqrt(Math.pow(max[0] - min[0],2)+Math.pow(max[1] - min[1],2)+Math.pow(max[2] - min[2],2)) * 0.5;
		}
		public function calcSplitFrustum():void {
			if (_currentPSSM > 0) {
				Matrix4x4.createPerspective(3.1416 * _sceneCamera.fieldOfView / 180.0,_sceneCamera.aspectRatio,_spiltDistance[_currentPSSM - 1],_spiltDistance[_currentPSSM],_tempMatrix44);
			}
			else {
				Matrix4x4.createPerspective(3.1416 * _sceneCamera.fieldOfView / 180.0,_sceneCamera.aspectRatio,_spiltDistance[0],_spiltDistance[_numberOfPSSM],_tempMatrix44);
			}
			Matrix4x4.multiply(_tempMatrix44, _sceneCamera.viewMatrix, _tempMatrix44);
			_splitFrustumCulling.matrix = _tempMatrix44; 
		}
		public function rebuildRenderTarget():void {
			
			var i:int;
			for (i = 0; i < _numberOfPSSM + 1; i++) {
				if (_renderTarget[i] == null || _renderTarget[i].width != _shadowMapTextureSize || _renderTarget[i].height != _shadowMapTextureSize) {
					if (_renderTarget[i] != null) {
						_renderTarget[i].dispose();
					}
					_renderTarget[i] = new RenderTexture(_shadowMapTextureSize, _shadowMapTextureSize);	
				}
			}
			
			for (i = _numberOfPSSM + 1; i < ParallelSplitShadowMap.MAX_PSSM_COUNT; i++ ) {
				if (_renderTarget[i] != null) {
						_renderTarget[i].dispose();
						_renderTarget[i] = null;
				}
			}
		}
		public function calcLightViewProject():void {
			var boundSphere:BoundSphere = _boundingSphere[_currentPSSM];
			var cameraMatViewInv:Matrix4x4 = _sceneCamera.transform.worldMatrix;
			var radius:Number = boundSphere.radius;
			boundSphere.center.cloneTo(_tempLookAt3);
			Vector3.transformV3ToV4(_tempLookAt3, cameraMatViewInv, _tempLookAt4);
			var lookAt3Element:Float32Array = _tempLookAt3.elements;
			var lookAt4Element:Float32Array = _tempLookAt4.elements;
			lookAt3Element[0] = lookAt4Element[0];
			lookAt3Element[1] = lookAt4Element[1];
			lookAt3Element[2] = lookAt4Element[2];
			var lightUpElement:Float32Array = _tempLightUp.elements;
			var sceneCameraDir:Float32Array = _sceneCamera.forward.elements;//
			lightUpElement[0] = sceneCameraDir[0];
			lightUpElement[1] = 1.0;
			lightUpElement[2] = sceneCameraDir[2];
			Vector3.normalize(_tempLightUp, _tempLightUp);
			Vector3.scale(_globalParallelLightDir, boundSphere.radius*2, _tempPos);
			Vector3.subtract(_tempLookAt3,_tempPos,_tempPos);
			_lightCamera.transform.lookAt(_tempPos, _tempLookAt3, _tempLightUp, false);
			var tempMaxElements:Float32Array = _tempMax.elements;
			var tempMinElements:Float32Array = _tempMin.elements;
			tempMaxElements[0] = tempMaxElements[1] = tempMaxElements[2] = -100000.0;
			tempMaxElements[3] = 1.0;
			tempMinElements[0] = tempMinElements[1] = tempMinElements[2] = 100000.0;
			tempMinElements[3] = 1.0;
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
			//现在tempValueElement变成了center
			Vector4.add(_tempMax,_tempMin,_tempValue);
			tempValueElement[0] *= 0.5;
			tempValueElement[1] *= 0.5;
			tempValueElement[2] *= 0.5;
			tempValueElement[3] = 1;
			Vector4.transformByM4x4(_tempValue, _lightCamera.transform.worldMatrix, _tempValue);
			var distance:Number = Math.abs(-_tempMax.z);
			var farPlane:Number = distance > _maxDistance ? distance : _maxDistance;
			//build light's view and project matrix
			Vector3.scale(_globalParallelLightDir, farPlane, _tempPos);
			var tempPosElement:Float32Array = _tempPos.elements;
			tempPosElement[0] = tempValueElement[0] - tempPosElement[0];
			tempPosElement[1] = tempValueElement[1] - tempPosElement[1];
			tempPosElement[2] = tempValueElement[2] - tempPosElement[2];
			_lightCamera.transform.lookAt(_tempPos,_tempLookAt3,_tempLightUp,false);
			Matrix4x4.createOrthogonal(tempMinElements[0]
								,tempMaxElements[0]
								,tempMinElements[1]
								,tempMaxElements[1]
								,1.0
								,(farPlane + 0.5 * (tempMaxElements[2] - tempMinElements[2]) ) * _lightDirLength
								,_lightCamera.projectionMatrix);
			//calc frustum
			Matrix4x4.multiply(_tempScaleMatrix44,_lightCamera.projectionViewMatrix,_lightViewProjectionMatrix[_currentPSSM]);
			_lightCulling.matrix = _lightCamera.projectionViewMatrix;
		}
		public function getLightFrustumCulling():BoundFrustum{
			return _lightCulling;
		}
		public function getSplitFrustumCulling():BoundFrustum{
			return _splitFrustumCulling;
		}
		public function getViewProjectMatrixOfGlobalLight(index:int):Matrix4x4{
			return _lightViewProjectionMatrix[index];
		}
		public function getSplitDistance(index:int):Number{
			return _spiltDistance[index];
		}
		public function setInvolvedShadowMapRange(distance:Number):void {
			var min:Float32Array = _involvedShadowMapRange.min.elements;
			min[0] = min[1] = min[2] = -distance;
			
			var max:Float32Array = _involvedShadowMapRange.max.elements;
			max[0] = max[1] = max[2] = distance;
		}
		public function getInvolvedShadowMapRangeWS():BoundBox {
			var min:Float32Array = _involvedShadowMapRange.min.elements;
			var max:Float32Array = _involvedShadowMapRange.max.elements;
			
			var retMax:Float32Array = _tempInvolvedShadowMapRange.max.elements;
			var retMin:Float32Array = _tempInvolvedShadowMapRange.min.elements;
			
			var pos:Float32Array = _sceneCamera.position.elements;
			
			retMax[0] += pos[0] - (max[0] + min[0]) * 0.5;
			retMax[1] += pos[1] - (max[1] + min[1]) * 0.5;
			retMax[2] += pos[2] - (max[2] + min[2]) * 0.5;
			
			return _tempInvolvedShadowMapRange;
		}
		public function setShadowMapTextureSize(size:int):void {
			if (size != _shadowMapTextureSize) {
				_shadowMapTextureSize = size;
				_statesDirty = true;
			}
		}
		public function getShadowMapTextureSize():int {
			return _shadowMapTextureSize;
		}
		public function beginRenderTarget(index:int):void {
			if (_renderTarget[index] != null) {
				_renderTarget[index].start();
			}
		}
		public function endRenderTarget(index:int):void {
			if (_renderTarget[index] != null) {
				_renderTarget[index].end();
			}
		}
	}
}