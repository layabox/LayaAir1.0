package laya.d3.shader {
	import laya.d3.core.IClone;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.layagl.LayaGL;
	import laya.resource.Resource;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * @private
	 */
	public class ShaderData implements IClone {
		/**@private */
		private var _ownerResource:Resource;
		
		/**@private */
		private var _data:*;
		
		/**@private [NATIVE]*/
		private var _int32Data:Int32Array;
		/**@private [NATIVE]*/
		private var _float32Data:Float32Array;
		/**@private [NATIVE]*/
		public var _nativeArray:Array;
		/**@private [NATIVE]*/
		public var _frameCount:int;
		/**@private [NATIVE]*/
		public static var _SET_RUNTIME_VALUE_MODE_REFERENCE_:Boolean = true;
		/**@private [NATIVE]*/
		public var _runtimeCopyValues:Array = [];
		
		/**
		 * @private
		 */
		public function ShaderData(ownerResource:Resource) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_ownerResource = ownerResource;
			_initData();
		}
		
		public function getData():Array
		{
			return _data;
		}
		
		/**
		 * @private
		 */
		public function _initData():void {
			_data = new Object();
		}
		
		/**
		 * 获取布尔。
		 * @param	index shader索引。
		 * @return  布尔。
		 */
		public function getBool(index:int):Boolean {
			return _data[index];
		}
		
		/**
		 * 设置布尔。
		 * @param	index shader索引。
		 * @param	value 布尔。
		 */
		public function setBool(index:int, value:Boolean):void {
			_data[index] = value;
		}
		
		/**
		 * 获取整形。
		 * @param	index shader索引。
		 * @return  整形。
		 */
		public function getInt(index:int):int {
			return _data[index];
		}
		
		/**
		 * 设置整型。
		 * @param	index shader索引。
		 * @param	value 整形。
		 */
		public function setInt(index:int, value:int):void {
			_data[index] = value;
		}
		
		/**
		 * 获取浮点。
		 * @param	index shader索引。
		 * @return  浮点。
		 */
		public function getNumber(index:int):Number {
			return _data[index];
		}
		
		/**
		 * 设置浮点。
		 * @param	index shader索引。
		 * @param	value 浮点。
		 */
		public function setNumber(index:int, value:Number):void {
			_data[index] = value;
		}
		
		/**
		 * 获取Vector2向量。
		 * @param	index shader索引。
		 * @return Vector2向量。
		 */
		public function getVector2(index:int):Vector2 {
			return _data[index];
		}
		
		/**
		 * 设置Vector2向量。
		 * @param	index shader索引。
		 * @param	value Vector2向量。
		 */
		public function setVector2(index:int, value:Vector2):void {
			_data[index] = value;
		}
		
		/**
		 * 获取Vector3向量。
		 * @param	index shader索引。
		 * @return Vector3向量。
		 */
		public function getVector3(index:int):Vector3 {
			return _data[index];
		}
		
		/**
		 * 设置Vector3向量。
		 * @param	index shader索引。
		 * @param	value Vector3向量。
		 */
		public function setVector3(index:int, value:Vector3):void {
			_data[index] = value;
		}
		
		/**
		 * 获取颜色。
		 * @param	index shader索引。
		 * @return 颜色向量。
		 */
		public function getVector(index:int):Vector4 {
			return _data[index];
		}
		
		/**
		 * 设置向量。
		 * @param	index shader索引。
		 * @param	value 向量。
		 */
		public function setVector(index:int, value:Vector4):void {
			_data[index] = value;
		}
		
		/**
		 * 获取四元数。
		 * @param	index shader索引。
		 * @return 四元。
		 */
		public function getQuaternion(index:int):Quaternion {
			return _data[index];
		}
		
		/**
		 * 设置四元数。
		 * @param	index shader索引。
		 * @param	value 四元数。
		 */
		public function setQuaternion(index:int, value:Quaternion):void {
			_data[index] = value;
		}
		
		/**
		 * 获取矩阵。
		 * @param	index shader索引。
		 * @return  矩阵。
		 */
		public function getMatrix4x4(index:int):Matrix4x4 {
			return _data[index];
		}
		
		/**
		 * 设置矩阵。
		 * @param	index shader索引。
		 * @param	value  矩阵。
		 */
		public function setMatrix4x4(index:int, value:Matrix4x4):void {
			_data[index] = value;
		}
		
		/**
		 * 获取Buffer。
		 * @param	index shader索引。
		 * @return
		 */
		public function getBuffer(shaderIndex:int):Float32Array {
			return _data[shaderIndex];
		}
		
		/**
		 * 设置Buffer。
		 * @param	index shader索引。
		 * @param	value  buffer数据。
		 */
		public function setBuffer(index:int, value:Float32Array):void {
			_data[index] = value;
		}
		
		/**
		 * 设置纹理。
		 * @param	index shader索引。
		 * @param	value 纹理。
		 */
		public function setTexture(index:int, value:BaseTexture):void {
			var lastValue:BaseTexture = _data[index];
			_data[index] = value;
			if (_ownerResource && _ownerResource.referenceCount > 0) {
				(lastValue) && (lastValue._removeReference());
				(value) && (value._addReference());
			}
		}
		
		/**
		 * 获取纹理。
		 * @param	index shader索引。
		 * @return  纹理。
		 */
		public function getTexture(index:int):BaseTexture {
			return _data[index];
		}
		
		/**
		 * 设置Attribute。
		 * @param	index shader索引。
		 * @param	value 纹理。
		 */
		public function setAttribute(index:int, value:Int32Array):void {
			_data[index] = value;
		}
		
		/**
		 * 获取Attribute。
		 * @param	index shader索引。
		 * @return  纹理。
		 */
		public function getAttribute(index:int):Array {
			return _data[index];
		}
		
		/**
		 * 获取长度。
		 * @return 长度。
		 */
		public function getLength():int {
			return _data.length;
		}
		
		/**
		 * 设置长度。
		 * @param 长度。
		 */
		public function setLength(value:int):void {
			_data.length = value;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:ShaderData = destObject as ShaderData;
			var destData:Array = dest._data;
			for (var k:String in _data) {//TODO:需要优化,杜绝is判断，慢
				var value:* = _data[k];
				if (value!=null) {
					if (value is Number) {
						destData[k] = value;
					} else if (value is int) {
						destData[k] = value;
					} else if (value is Boolean) {
						destData[k] = value;
					} else if (value is Vector2) {
						var v2:Vector2 = (destData[k]) || (destData[k] = new Vector2());
						(value as Vector2).cloneTo(v2);
						destData[k] = v2;
					} else if (value is Vector3) {
						var v3:Vector3 = (destData[k]) || (destData[k] = new Vector3());
						(value as Vector3).cloneTo(v3);
						destData[k] = v3;
					} else if (value is Vector4) {
						var v4:Vector4 = (destData[k]) || (destData[k] = new Vector4());
						(value as Vector4).cloneTo(v4);
						destData[k] = v4;
					} else if (value is Matrix4x4) {
						var mat:Matrix4x4 = (destData[k]) || (destData[k] = new Matrix4x4());
						(value as Matrix4x4).cloneTo(mat);
						destData[k] = mat;
					} else if (value is BaseTexture) {
						destData[k] = value;
					}
				}
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneToForNative(destObject:*):void {
			var dest:ShaderData = destObject as ShaderData;
			
			var diffSize:int = _int32Data.length - dest._int32Data.length;
			if (diffSize > 0)
			{
				dest.needRenewArrayBufferForNative(_int32Data.length);
			}
			
			dest._int32Data.set(_int32Data, 0);
			var destData:Array = dest._nativeArray;
			var dataCount:int = _nativeArray.length;
			destData.length = dataCount;//TODO:runtime
			for (var i:int = 0; i < dataCount; i++) {//TODO:需要优化,杜绝is判断，慢
				var value:* = _nativeArray[i];
				if (value) {
					if (value is Number) {
						destData[i] = value;
						dest.setNumber(i, value);
					} else if (value is int) {
						destData[i] = value;
						dest.setInt(i, value);
					} else if (value is Boolean) {
						destData[i] = value;
						dest.setBool(i, value);
					} else if (value is Vector2) {
						var v2:Vector2 = (destData[i]) || (destData[i] = new Vector2());
						(value as Vector2).cloneTo(v2);
						destData[i] = v2;
						dest.setVector2(i, v2);
					} else if (value is Vector3) {
						var v3:Vector3 = (destData[i]) || (destData[i] = new Vector3());
						(value as Vector3).cloneTo(v3);
						destData[i] = v3;
						dest.setVector3(i, v3);
					} else if (value is Vector4) {
						var v4:Vector4 = (destData[i]) || (destData[i] = new Vector4());
						(value as Vector4).cloneTo(v4);
						destData[i] = v4;
						dest.setVector(i, v4);
					} else if (value is Matrix4x4) {
						var mat:Matrix4x4 = (destData[i]) || (destData[i] = new Matrix4x4());
						(value as Matrix4x4).cloneTo(mat);
						destData[i] = mat;
						dest.setMatrix4x4(i, mat);
					} else if (value is BaseTexture) {
						destData[i] = value;
						dest.setTexture(i, value);
					}
				}
			}
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:ShaderData = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
		
		/**
		 * @private [NATIVE]
		 */
		public function _initDataForNative():void {
			var length:int = 8;//默认分配8个
			if (!length) {
				alert("ShaderData _initDataForNative error length=0");
			}
			_frameCount = -1;
			_runtimeCopyValues.length = 0;
			_nativeArray = [];
			_data = new ArrayBuffer(length * 4);
			_int32Data = new Int32Array(_data);
			_float32Data = new Float32Array(_data);
			LayaGL.createArrayBufferRef(this._data, LayaGL.ARRAY_BUFFER_TYPE_DATA, true);
		}
		
		public function needRenewArrayBufferForNative(index:int):void {
			if (index >= this._int32Data.length) {
				var nByteLen:int = (index + 1) * 4;
				var pre:Int32Array = this._int32Data;
				var preConchRef:* = this._data["conchRef"];
				var prePtrID:int = this._data["_ptrID"];
				this._data = new ArrayBuffer(nByteLen);
				this._int32Data = new Int32Array(this._data);
				this._float32Data = new Float32Array(this._data);
				this._data["conchRef"] = preConchRef;
				this._data["_ptrID"] = prePtrID;
				pre && this._int32Data.set(pre, 0);
				__JS__("conch.updateArrayBufferRef(this._data['_ptrID'], preConchRef.isSyncToRender(), this._data)");
			}
		}
		
		public function getDataForNative():Array
		{
			return _nativeArray;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getIntForNative(index:int):int {
			return _int32Data[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setIntForNative(index:int, value:int):void {
			needRenewArrayBufferForNative(index);
			_int32Data[index] = value;
			_nativeArray[index] = value;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getBoolForNative(index:int):Boolean {
			return _int32Data[index] == 1;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setBoolForNative(index:int, value:Boolean):void {
			needRenewArrayBufferForNative(index);
			_int32Data[index] = value;
			_nativeArray[index] = value;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getNumberForNative(index:int):Number {
			return _float32Data[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setNumberForNative(index:int, value:Number):void {
			needRenewArrayBufferForNative(index);
			_float32Data[index] = value;
			_nativeArray[index] = value;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getMatrix4x4ForNative(index:int):Matrix4x4 {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setMatrix4x4ForNative(index:int, value:Matrix4x4):void {
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			var nPtrID:int = setReferenceForNative(value.elements);
			_int32Data[index] = nPtrID;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getVectorForNative(index:int):* {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setVectorForNative(index:int, value:*):void {
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			if (!value.elements)
			{
				value.forNativeElement();
			}
			var nPtrID:int = setReferenceForNative(value.elements);
			_int32Data[index] = nPtrID;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getVector2ForNative(index:int):* {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setVector2ForNative(index:int, value:*):void {
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			if (!value.elements)
			{
				value.forNativeElement();
			}
			var nPtrID:int = setReferenceForNative(value.elements);
			_int32Data[index] = nPtrID;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getVector3ForNative(index:int):* {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setVector3ForNative(index:int, value:*):void {
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			if (!value.elements)
			{
				value.forNativeElement();
			}
			var nPtrID:int = setReferenceForNative(value.elements);
			_int32Data[index] = nPtrID;
		}
		/**
		 *@private [NATIVE]
		 */
		public function getQuaternionForNative(index:int):Quaternion {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setQuaternionForNative(index:int, value:*):void {
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			if (!value.elements)
			{
				value.forNativeElement();
			}
			var nPtrID:int = setReferenceForNative(value.elements);
			_int32Data[index] = nPtrID;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getBufferForNative(shaderIndex:int):Float32Array {
			return _nativeArray[shaderIndex];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setBufferForNative(index:int, value:Float32Array):void {
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			var nPtrID:int = setReferenceForNative(value);
			_int32Data[index] = nPtrID;
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getAttributeForNative(index:int):Array {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setAttributeForNative(index:int, value:Int32Array):void {
			_nativeArray[index] = value;//保存引用
			if (!value["_ptrID"]) {
				LayaGL.createArrayBufferRef(value, LayaGL.ARRAY_BUFFER_TYPE_DATA, true);
			}
			LayaGL.syncBufferToRenderThread(value);
			_int32Data[index] = value["_ptrID"];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function getTextureForNative(index:int):BaseTexture {
			return _nativeArray[index];
		}
		
		/**
		 *@private [NATIVE]
		 */
		public function setTextureForNative(index:int, value:BaseTexture):void {
			if (!value) return;
			if (!value._getSource())
			{
				Laya.systemTimer.callLater(this, setTextureForNative, [index, value]);
				return;
			}
			needRenewArrayBufferForNative(index);
			_nativeArray[index] = value;//保存引用
			var lastValue:BaseTexture = _nativeArray[index];
			_int32Data[index] = value._getSource().id;
			if (_ownerResource && _ownerResource.referenceCount > 0) {
				(lastValue) && (lastValue._removeReference());
				(value) && (value._addReference());
			}
		}
		
		public function setReferenceForNative(value:*):int {
			//清空保存的数据
			clearRuntimeCopyArray();
			var nRefID:int = 0;
			var nPtrID:int = 0;
			if (_SET_RUNTIME_VALUE_MODE_REFERENCE_) {
				LayaGL.createArrayBufferRefs(value, LayaGL.ARRAY_BUFFER_TYPE_DATA, true, LayaGL.ARRAY_BUFFER_REF_REFERENCE);
				nRefID = 0;
				nPtrID = value.getPtrID(nRefID);
			} else {
				LayaGL.createArrayBufferRefs(value, LayaGL.ARRAY_BUFFER_TYPE_DATA, true, LayaGL.ARRAY_BUFFER_REF_COPY);
				nRefID = value.getRefNum() - 1;
				nPtrID = value.getPtrID(nRefID);
				//TODO 应该只用到value
				_runtimeCopyValues.push({"obj": value, "refID": nRefID, "ptrID": nPtrID});
			}
			LayaGL.syncBufferToRenderThread(value, nRefID);
			return nPtrID;
		}
		
		public static function setRuntimeValueMode(bReference:Boolean):void {
			_SET_RUNTIME_VALUE_MODE_REFERENCE_ = bReference;
		}
		
		public function clearRuntimeCopyArray():void {
			var currentFrame:int = LayaGL.getFrameCount();
			if (_frameCount != currentFrame) {
				_frameCount = currentFrame;
				for (var i:int = 0, n:int = _runtimeCopyValues.length; i < n; i++) {
					var obj:* = _runtimeCopyValues[i];
					obj.obj.clearRefNum();
				}
				_runtimeCopyValues.length = 0;
			}
		}
	}
}