package Cube {

	import laya.d3.core.GeometryElement;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.loaders.MeshReader;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3Extend.Cube.CubeInfo;
	import laya.d3Extend.FileSaver;
	import laya.d3Extend.worldMaker.CubeInfoArray;
	import laya.utils.Browser;
	import laya.utils.Byte;

	/**
	 * <code>CubeGeometry</code> 类用于实现方块几何体。
	 */
	public class CubeGeometry extends GeometryElement {
		/**@private */
		private static var _type:int = _typeCounter++;
			
		
		/**@private */
		public static const CUBEINDEX:int = 9;
		/**@private */
		public static const HLAFMAXSIZE:int = 1600;
		
		/**@private 方块8个点局部坐标*/
		public static var POINTS:Array =/*[STATIC SAFE]*/ [1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0];
		
		/**@private 需要每帧处理的盒子数组 */
		private var _modifyCubes:Array = [];
		
		/**小方块Map [只读]*/
		public var cubeMap:CubeMap = new CubeMap();
		/**大方块Map [只读]*/
		public var subBoxMap:Object = {};
		/**每帧处理的个数 */
		public static const updateCubeCount:int = 1000;
		/**是否允许每帧更新数据 */
		public var enableUpdate:Boolean = true;
		
		public var cubeSprite3D:CubeSprite3D;
		
		public var IsRender:Boolean = true;
		
	
		
		
		public function CubeGeometry(cubeGeometry:CubeSprite3D) {
			cubeSprite3D = cubeGeometry;
		}
		
		/**
		 * @private
		 * @private
		 */
		public function addCube(x:int, y:int, z:int, color:int, isUpdataAO:Boolean = false):int {
			
			x += HLAFMAXSIZE;
			y += HLAFMAXSIZE;
			z += HLAFMAXSIZE;
			
			var mainCube:CubeInfo = cubeMap.find(x, y, z);
			if (mainCube && mainCube.subCube) {
				trace("CubeGeometry: this cube has exits.");
				return mainCube.color;
			}
			var POINTS:Array = CubeGeometry.POINTS;
			for (var i:int = 0; i < 24; i += 3) {
				var pX:int = x + POINTS[i];
				var pY:int = y + POINTS[i + 1];
				var pZ:int = z + POINTS[i + 2];
				var cube:CubeInfo = cubeMap.find(pX, pY, pZ);
				
				if (!cube) {
					cube = CubeInfo.create(pX, pY, pZ);
					cubeMap.add(pX, pY, pZ, cube);
				}
				cube.point |= 1 << (i / 3);
				if (i === CUBEINDEX) {
					cube.x = pX;
					cube.y = pY;
					cube.z = pZ;
					cube.color = color;
					
					var keybox:int = SubCubeGeometry.getKey(pX, pY, pZ);
					var subBox:SubCubeGeometry = subBoxMap[keybox];
					if (!subBox) {
						subBox = subBoxMap[keybox] = SubCubeGeometry.create(this);
					}
					cube.subCube = cube.updateCube = subBox;
					
					switch (cube.modifyFlag) {
					case CubeInfo.MODIFYE_NONE: 
						cube.modifyIndex = _modifyCubes.length;
						cube.modifyFlag = CubeInfo.MODIFYE_ADD;
						subBox.cubeCount++;
						_modifyCubes.push(cube);
						break;
					case CubeInfo.MODIFYE_REMOVE: //已有移除指令修改为添加指令,变更为更新指令
						cube.modifyFlag = CubeInfo.MODIFYE_UPDATE;
						subBox.cubeCount++;
						break;
					case CubeInfo.MODIFYE_ADD://已有添加指令,重复操作,无需变更 
					case CubeInfo.MODIFYE_UPDATE://已有更新指令,无效操作,无需变更 
					case CubeInfo.MODIFYE_UPDATEAO://已有更新AO指令无需操作无需变更
					case CubeInfo.MODIFYE_UPDATEPROPERTY:
						break;
						
					}
				}
			}
			isUpdataAO && calOneCubeAO(x, y, z);
			cubeSprite3D.CubeNums++;
			//更新AO
			return -1
		}
		
		/**
		 * @private
		 */
		public function removeCube(x:int, y:int, z:int, isUpdataAO:Boolean = false):int {
			x += HLAFMAXSIZE;
			y += HLAFMAXSIZE;
			z += HLAFMAXSIZE;
			
			var mainCube:CubeInfo = cubeMap.find(x, y, z);
			if (!mainCube || !mainCube.subCube) {
				trace("CubeGeometry: this cube not exits.");
				return -1;
			}
			var oldcolor:int = mainCube.color;
			var POINTS:Array = CubeGeometry.POINTS;
			for (var i:int = 0; i < 24; i += 3) {
				var pX:int = x + POINTS[i];
				var pY:int = y + POINTS[i + 1];
				var pZ:int = z + POINTS[i + 2];
				
				var cube:CubeInfo = cubeMap.find(pX, pY, pZ);
				cube.point &= ~(1 << (i / 3));
				
				if (i === CUBEINDEX) {
					var keybox:int = SubCubeGeometry.getKey(pX, pY, pZ);
					var subBox:SubCubeGeometry = subBoxMap[keybox];
					
					cube.subCube = null;
					
					switch (cube.modifyFlag) {
					case CubeInfo.MODIFYE_NONE: 
						cube.modifyIndex = _modifyCubes.length;
						cube.modifyFlag = CubeInfo.MODIFYE_REMOVE;
						subBox.cubeCount--;
						_modifyCubes.push(cube);
						break;
					case CubeInfo.MODIFYE_ADD://已有添加指令,再移除,变更为空指令并从修改队列中移除
						cube.modifyFlag = CubeInfo.MODIFYE_NONE;
						subBox.cubeCount--;
						
						var lengh:int = _modifyCubes.length - 1;
						var modifyIndex:int = cube.modifyIndex;
						if (modifyIndex !== lengh) {
							var end:CubeInfo = _modifyCubes[lengh];
							_modifyCubes[modifyIndex] = end;
							end.modifyIndex = modifyIndex;
						}
						_modifyCubes.length--;
						break;
					case CubeInfo.MODIFYE_UPDATE://已有更新指令，变更为删除指令
					case CubeInfo.MODIFYE_UPDATEAO://已有更新AO指令，变更为删除指令
					case CubeInfo.MODIFYE_UPDATEPROPERTY:
						cube.modifyFlag = CubeInfo.MODIFYE_REMOVE;
						subBox.cubeCount--;
						break;
					case CubeInfo.MODIFYE_REMOVE: //重复移除不做任何操作
						break;
					case CubeInfo.MODIFYE_UPDATEAO: 
					}
					
					//TODO:有问题
					//if (subBox.cubeCount === 0) {//无可渲染点时直接回收
						//SubCubeGeometry.recover(subBox);
						//delete subBoxMap[keybox];
					//}
					
				}
			}
			if (isUpdataAO) {
				
				calOneCubeAO(x, y, z);
			}
			cubeSprite3D.CubeNums--;
			return oldcolor;
		}
		
		/**
		 * @private
		 */
		public function updateColor(x:int, y:int, z:int, color:int):int {
			x += HLAFMAXSIZE;
			y += HLAFMAXSIZE;
			z += HLAFMAXSIZE;
			var cube:CubeInfo = cubeMap.find(x, y, z);
			if (!cube || !cube.subCube) {
				trace("CubeGeometry: this cube not exits.");
				return -1;
			}
			var oldcolor:int = cube.color;
			cube.color = color;
			switch (cube.modifyFlag) {
			case CubeInfo.MODIFYE_NONE: 
			case CubeInfo.MODIFYE_UPDATEPROPERTY:
			case CubeInfo.MODIFYE_UPDATEAO://已有更新指令，变更为更换颜色
				cube.modifyIndex = _modifyCubes.length;
				_modifyCubes.push(cube);
				cube.modifyFlag = CubeInfo.MODIFYE_UPDATE;
				break;
			case CubeInfo.MODIFYE_ADD://已有添加指令,无需操作
			case CubeInfo.MODIFYE_REMOVE://已有删除指令,无需操作
			case CubeInfo.MODIFYE_UPDATE://已有更新指令,无需操作
				break;
			}
			return oldcolor;
		}
		
		/**
		 * @private
		 */
		public function updateAO(cube:CubeInfo):void {
			switch (cube.modifyFlag) {
			case CubeInfo.MODIFYE_NONE: 
				cube.modifyIndex = _modifyCubes.length;
				_modifyCubes.push(cube);
				cube.modifyFlag = CubeInfo.MODIFYE_UPDATEAO;
				break;
			case CubeInfo.MODIFYE_ADD://已有添加指令,无需操作
			case CubeInfo.MODIFYE_REMOVE://已有删除指令,无需操作
			case CubeInfo.MODIFYE_UPDATE://已有更新指令,无需操作
				break;
			}
		}
		
		/**
		 * @private 
		 */
		public function updataProperty(x:int, y:int, z:int, Property:int):int{
			x += HLAFMAXSIZE;
			y += HLAFMAXSIZE;
			z += HLAFMAXSIZE;
			var cube:CubeInfo = cubeMap.find(x, y, z);
			if (!cube || !cube.subCube) {
				trace("CubeGeometry: this cube not exits.");
				return -1;
			}
			var oldcolor:int = cube.color;
			cube.color = (oldcolor & 0x00ffffff) + (Property << 24);
			switch (cube.modifyFlag) {
				case CubeInfo.MODIFYE_NONE: 
				case CubeInfo.MODIFYE_UPDATEPROPERTY:
					cube.modifyIndex = _modifyCubes.length;
					_modifyCubes.push(cube);
					cube.modifyFlag = CubeInfo.MODIFYE_UPDATEPROPERTY;
					break;
				case CubeInfo.MODIFYE_UPDATEAO://已有更新指令，变更为更换颜色
				case CubeInfo.MODIFYE_ADD://已有添加指令,无需操作
				case CubeInfo.MODIFYE_REMOVE://已有删除指令,无需操作
				case CubeInfo.MODIFYE_UPDATE://已有更新指令,无需操作
					break;
			}
			return oldcolor;
			
		}
		
		private function calOneCubeAO(x:int, y:int, z:int):void {
			var _x:int = x + 1;
			var _y:int = y + 1;
			var _z:int = z + 1;
			var x_:int = x - 1;
			var y_:int = y - 1;
			var z_:int = z - 1;
			var cube:CubeInfo;
			cube = cubeMap.find(x, _y, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(5) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[1];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[1];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, y, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(5) != -1 || cube.getVBPointbyFaceIndex(3) != -1) {
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[1] + CubeInfo.PanduanWei[2];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[1] + CubeInfo.PanduanWei[2];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, y, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(5) != -1) {
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[2] + CubeInfo.PanduanWei[3];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x, y_, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(5) != -1 || cube.getVBPointbyFaceIndex(2) != -1) {
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[1] + CubeInfo.PanduanWei[2];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[2] + CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, y_, z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(2) != -1 || cube.getVBPointbyFaceIndex(3) != -1) {
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[2] + CubeInfo.PanduanWei[3];
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[1];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, y, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(3) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[1] + CubeInfo.PanduanWei[2];
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, _y, z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(3) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[2] + CubeInfo.PanduanWei[3];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[3] + CubeInfo.PanduanWei[0];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x, _y, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[2] + CubeInfo.PanduanWei[3];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[2] + CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, _y, z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[1] + CubeInfo.PanduanWei[2];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[1] + CubeInfo.PanduanWei[2];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, y, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(1) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[3] + CubeInfo.PanduanWei[0];
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[1];
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, y_, z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(2) != -1) {
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[3] + CubeInfo.PanduanWei[0];
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[1];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x, y_, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(2) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[0] + CubeInfo.PanduanWei[1];
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[3] + CubeInfo.PanduanWei[0];
					
					updateAO(cube);
				}
			}
			
			cube = cubeMap.find(_x, _y, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(3) != -1 || cube.getVBPointbyFaceIndex(4) != -1 || cube.getVBPointbyFaceIndex(5) != -1) {
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[2];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[0];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[1];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, _y, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(3) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[2];
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[3];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, y_, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(2) != -1 || cube.getVBPointbyFaceIndex(3) != -1 || cube.getVBPointbyFaceIndex(5) != -1) {
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[2];
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[1];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[2];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(_x, y_, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(3) != -1 || cube.getVBPointbyFaceIndex(2) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[1];
					cube.frontFaceAO[3] |= CubeInfo.PanduanWei[0];
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, _y, _z);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(5) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[2];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[0];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[1];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, _y, z_);
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(4) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[3];
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[1];
					cube.frontFaceAO[4] |= CubeInfo.PanduanWei[2];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, y_, _z)
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(2) != -1 || cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(5) != -1) {
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[1];
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[3];
					cube.frontFaceAO[5] |= CubeInfo.PanduanWei[3];
					
					updateAO(cube);
				}
			}
			cube = cubeMap.find(x_, y_, z_)
			if (cube != null && cube.subCube != null) {
				if (cube.getVBPointbyFaceIndex(0) != -1 || cube.getVBPointbyFaceIndex(1) != -1 || cube.getVBPointbyFaceIndex(2) != -1) {
					cube.frontFaceAO[0] |= CubeInfo.PanduanWei[0];
					cube.frontFaceAO[1] |= CubeInfo.PanduanWei[0];
					cube.frontFaceAO[2] |= CubeInfo.PanduanWei[0];
					
					updateAO(cube);
				}
			}
		
		}
		//
		public function findCube(x:int, y:int, z:int):int {
			if ((x + HLAFMAXSIZE < 0) || (y + HLAFMAXSIZE < 0) || (z + HLAFMAXSIZE < 0)) {
				return -1;
			}
			var cubeinfo:CubeInfo = cubeMap.find(x + HLAFMAXSIZE, y + HLAFMAXSIZE, z + HLAFMAXSIZE);
			if (cubeinfo && cubeinfo.subCube) {
				return cubeinfo.color;
			} else {
				return -1;
			}
		}
		
		public function findCubeToCubeInfo(x:int, y:int, z:int):CubeInfo
		{
			if ((x + HLAFMAXSIZE < 0) || (y + HLAFMAXSIZE < 0) || (z + HLAFMAXSIZE < 0))
			{
				return null;
			}
			var cubeinfo:CubeInfo = cubeMap.find(x + HLAFMAXSIZE, y + HLAFMAXSIZE, z + HLAFMAXSIZE);
			if (cubeinfo && cubeinfo.subCube) 
			{
				return cubeinfo;
			} 
			else 
			{
				return null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return _type;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _prepareRender(state:RenderContext3D):Boolean {
			if (!IsRender)
			{
				return false;
			}
			
			if (_modifyCubes.length == 0 || !enableUpdate)
				return true;
			var end:int = Math.max(_modifyCubes.length - updateCubeCount, 0);
			  
			//var tm:Number = Browser.now();
			//end = 0;
			for (var i:int = _modifyCubes.length - 1; i >= end; i--)
				_modifyCubes[i].update();
			_modifyCubes.length = end;
			
			//trace("---------------------delay:" + (Browser.now() - tm));
			
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			for (var key:String in subBoxMap) {
				var subCube:SubCubeGeometry = subBoxMap[key] as SubCubeGeometry;
				subCube.updateBuffer();
				(cubeSprite3D.enableRender)&&(subCube.render(state));
			}
		}
		
		/**
		 * @private
		 */
		public function clear():void {
			_modifyCubes.length = 0;
			var cubMapData:Object = cubeMap.data;
			for (var key:String in cubMapData) {
				var subData:Array = cubMapData[key];
				for (var subkey:String in subData)
					CubeInfo.recover(subData[subkey]);
				subData.save = null;
			}
			//debugger;
			//cubMapData.save = null;
			for (key in subBoxMap) {
				var subCube:SubCubeGeometry = subBoxMap[key];
				//subCube.clear();
				//SubCubeGeometry.recover(subCube);
				subCube.destroy();
			}
			cubeMap.clear();
			subBoxMap = {};
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			clear();
		}
		
		
		//导出经过优化的lm
		 public function ExportCubeMeshLm():void
		 {

			 var object:Object = new Object();
			 var ss:Uint8Array = new Uint8Array( compressData().buffer);
			FileSaver.saveBlob(FileSaver.createBlob([ss],{}), "CubeModel.lm");
			
			
			 
		 }
		
		 
		 
		 	
		public static var shareMaterial:BlinnPhongMaterial;
		public static function initStaticBlin():void
		{
			shareMaterial = new BlinnPhongMaterial();
			shareMaterial.enableVertexColor = true;
			shareMaterial.albedoColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			shareMaterial.specularColor = new Vector4(0.2, 0.2, 0.2, 1);
		}
		 
		 public function lmToMeshSprite3D(byte:Byte):MeshSprite3D
		 {
			var subeMeshs:Vector.<SubMesh> = new Vector.<SubMesh>();
			var mesh:Mesh = new Mesh();
			MeshReader.read(byte.buffer, mesh, subeMeshs);
			var sprite:MeshSprite3D = new MeshSprite3D(mesh);
			sprite.meshRenderer.material = shareMaterial;
			return sprite;
		 }
		 
		 
		 
		/**
		 * @private 
		 * 类用来组织所有的VBIB并且将同色面合并
		 */
		public function compressData():Byte
		{
			 var byteArray:Byte = new Byte();
			
			//顶点位置
			var surfaceVertexPosArray:Vector.<Number> = new Vector.<Number>();
			//法线
			var surfaceVertexNolArray:Vector.<Number> = new Vector.<Number>();
			//颜色
			var surfaceVertexColArray:Vector.<Number> = new Vector.<Number>();
			//索引
			var surfaceVertexIndArray:Vector.<int> = new Vector.<int>();
			//获得所有的CubeInfo
			var allCubeInfo:Vector.<CubeInfo> = cubeMap.returnAllCube();
			//遍历所有的Cubeinfo进行合并面
		
			var cubeLength:int = allCubeInfo.length;
			for (var i:int = 0; i < cubeLength; i++) 
			{
				calOneCubeSurface(allCubeInfo[i], surfaceVertexPosArray, surfaceVertexNolArray, surfaceVertexColArray);
			}
			//組織Ib
			var maxFaceNums = surfaceVertexPosArray.length / 12;
			surfaceVertexIndArray.length = maxFaceNums * 6;
			for (var i:int = 0; i < maxFaceNums; i++) {
				var indexOffset:int = i * 6;
				var pointOffset:int = i * 4;
				surfaceVertexIndArray[indexOffset] = pointOffset;
				surfaceVertexIndArray[indexOffset + 1] = 2 + pointOffset;
				surfaceVertexIndArray[indexOffset + 2] = 1 + pointOffset;
				surfaceVertexIndArray[indexOffset + 3] = pointOffset;
				surfaceVertexIndArray[indexOffset + 4] = 3 + pointOffset;
				surfaceVertexIndArray[indexOffset + 5] = 2 + pointOffset;
			}
			
			 var stringDatas:Vector.<String> = new Vector.<String>();
			 stringDatas.push("MESH");
			 stringDatas.push("SUBMESH");
			 //版本号
			 var LmVersion:String = "LAYAMODEL:0400";
			 //顶点描述数据
			 var vbDeclaration:String = "POSITION,NORMAL,COLOR"
			 //VB大小
			 var everyVBSize:int = 12 + 12 + 16;
			  //版本号
			 byteArray.writeUTFString(LmVersion);
			
			 byteArray.pos = 0;
			 console.log(byteArray.readUTFString());
			 var verionsize:int = byteArray.pos;
			 
			 //标记数据信息区
			 var ContentAreaPostion_Start:int = byteArray.pos;//预留数据区偏移地址
			 byteArray.writeUint32(0);
			 byteArray.writeUint32(0);
			 //内容段落信息区
			 var BlockAreaPosition_Start:int = byteArray.pos;//预留段落偏移地址
			 byteArray.writeUint16(2);
			 for (var i:int = 0; i < 2; i++ )
			 {
				byteArray.writeUint32(0);//Uint32 blockStart
				byteArray.writeUint32(0);//Uint32 blockLength
			 }
			 //字符区
			 var StringAreaPosition_Start:int = byteArray.pos;
			 byteArray.writeUint32(0);//Uint32 offset
			 byteArray.writeUint16(0);//count
			 //网格区
			 var MeshAreaPosition_Start:int = byteArray.pos;
			 byteArray.writeUint16(0);//解析函数名字索引
			 stringDatas.push("CubeMesh");
			 byteArray.writeUint16(2);//网格名字索引
			 
			  //vb
			 byteArray.writeUint16(1);//vb数量
			 var VBMeshAreaPosition_Start:int = byteArray.pos;
			 byteArray.writeUint32(0);//vbStart
			 byteArray.writeUint32(0);//vbLength
			 stringDatas.push(vbDeclaration);
			 byteArray.writeUint16(3);
			
			 //ib
			 var IBMeshAreaPosition_Start:int = byteArray.pos;
			 byteArray.writeUint32(0);//ibStart
			 byteArray.writeUint32(0);//ibLength
			 
			 //Bone
			 var BoneAreaPosition_Start:int = byteArray.pos;
			 byteArray.writeUint16(0);//boneCount
			 byteArray.writeUint32(0);//bindPosStart
			 byteArray.writeUint32(0);//bindPosLength
			 byteArray.writeUint32(0);//inverseGlobalBindPoseStart
			 byteArray.writeUint32(0);//inverseGlobalBindPoseLength
			 
			 var MeshAreaPosition_End:int = byteArray.pos;
			 var MeshAreaSize:int = MeshAreaPosition_End - MeshAreaPosition_Start;
			 
			 //子网格区
			 var subMeshAreaPosition_Start:int = byteArray.pos;
			 byteArray.writeUint16(1);//解析函数名字字符索引
			 byteArray.writeUint16(0);//vbIndex
			 byteArray.writeUint32(0);//vbStart
			 byteArray.writeUint32(0);//vbLength
			 
			 byteArray.writeUint32(0);//ibStart
			 byteArray.writeUint32(0);//ibLength
			 
			 byteArray.writeUint16(1);//drawCount
			 
			 byteArray.writeUint32(0);//subIbStart
			 byteArray.writeUint32(0);//subibLength
			 
			 byteArray.writeUint32(0);//boneDicStart
			 byteArray.writeUint32(0);//boneDicLength
			 
			 var subMeshAreaPosition_End:int = byteArray.pos;
			 
			 var subMeshAreaSize:int = subMeshAreaPosition_End - subMeshAreaPosition_Start;
			 
			 //字符数据区
			 var StringDatasAreaPosition_Start:int = byteArray.pos;
			 for (var i:int = 0; i < stringDatas.length; i++)
			 {
				byteArray.writeUTFString(stringDatas[i]);
			 }
			 var StringDatasAreaPosition_End:int = byteArray.pos;
			 var StringDatasAreaSize:int = StringDatasAreaPosition_End - StringDatasAreaPosition_Start;
			 
			 //内容数据区
			 //VB
			 var VBContentDatasAreaPosition_Start:int = byteArray.pos;
			 var VertexCount:int = surfaceVertexPosArray.length / 3;//顶点数量
			 var posIndex:int = 0;
			 var NorIndex:int = 0;
			 var colIndex:int = 0;
			 for (var j:int = 0; j < VertexCount; j++) 
			 {
				 //顶点数据
					byteArray.writeFloat32(surfaceVertexPosArray[posIndex]);
					posIndex++;
					byteArray.writeFloat32(surfaceVertexPosArray[posIndex]);
					posIndex++;
					byteArray.writeFloat32(surfaceVertexPosArray[posIndex]);
					posIndex++;
					byteArray.writeFloat32(surfaceVertexNolArray[NorIndex]);
					NorIndex++;
					byteArray.writeFloat32(surfaceVertexNolArray[NorIndex]);
					NorIndex++;
					byteArray.writeFloat32(surfaceVertexNolArray[NorIndex]);
					NorIndex++;
					byteArray.writeFloat32(surfaceVertexColArray[colIndex]);
					colIndex++;
					byteArray.writeFloat32(surfaceVertexColArray[colIndex]);
					colIndex++;
					byteArray.writeFloat32(surfaceVertexColArray[colIndex]);
					colIndex++;
					byteArray.writeFloat32(surfaceVertexColArray[colIndex]);
					colIndex++;
			 }
			 var VBContentDatasAreaPosition_End:int = byteArray.pos;
			 var VBContentDatasAreaSize:int = VBContentDatasAreaPosition_End - VBContentDatasAreaPosition_Start;
			 
		     //ib
		     var IBContentDatasAreaPosition_Start:int = byteArray.pos;
		     var vertexIndexArrayLength:int = surfaceVertexIndArray.length;
		     for (var j:int = 0; j < vertexIndexArrayLength; j++)
		     {
			        byteArray.writeUint16(surfaceVertexIndArray[j]);
			 }
			 var IBContentDatasAreaPosition_End:int = byteArray.pos;
			 var IBContentDatasAreaSize:int = IBContentDatasAreaPosition_End - IBContentDatasAreaPosition_Start;
			 
			   //倒推子网格区
			  var vbstart:int = 0;
			  var vblength:int = 0;
			  var ibstart:int = 0;
			  var iblength:int = 0;
			  var _ibstart = 0;
			  
			  byteArray.pos = subMeshAreaPosition_Start + 4;
			  vbstart = 0;
			  vblength = VBContentDatasAreaSize / everyVBSize;
			  ibstart = 0;
			  iblength = IBContentDatasAreaSize / 2;
			  
			  byteArray.writeUint32(vbstart);
			  byteArray.writeUint32(vblength);
			  byteArray.writeUint32(ibstart);
			  byteArray.writeUint32(iblength);
			  
			  byteArray.pos += 2;
			  
			  byteArray.writeUint32(ibstart);
			  byteArray.writeUint32(iblength);
			  
			  //倒推网格区
			  byteArray.pos = VBMeshAreaPosition_Start;
			  byteArray.writeUint32(VBContentDatasAreaPosition_Start - StringDatasAreaPosition_Start);
			  byteArray.writeUint32(VBContentDatasAreaSize);
			  
			  byteArray.pos = IBMeshAreaPosition_Start;
			  byteArray.writeUint32(IBContentDatasAreaPosition_Start - StringDatasAreaPosition_Start);
			  byteArray.writeUint32(IBContentDatasAreaSize);
			  
			  //倒推字符区
			  byteArray.pos = StringAreaPosition_Start;
			  byteArray.writeUint32(0);
			  byteArray.writeUint16(stringDatas.length);
			  StringDatasAreaPosition_End = byteArray.pos;
			  
			  //倒推段落区
			  byteArray.pos = BlockAreaPosition_Start + 2;
			  byteArray.writeUint32(MeshAreaPosition_Start);
			  byteArray.writeUint32(MeshAreaSize);
			  
			  byteArray.writeUint32(subMeshAreaPosition_Start);
			  byteArray.writeUint32(subMeshAreaSize);
			  
			  
			  //倒推标记内容数据信息区
			  byteArray.pos = ContentAreaPostion_Start;
			  byteArray.writeUint32(StringDatasAreaPosition_Start);
			  byteArray.writeUint32(StringDatasAreaPosition_Start + StringDatasAreaSize
			  + VBContentDatasAreaSize + IBContentDatasAreaSize + subMeshAreaSize);
			  
			
			  return byteArray;
			  
		}
		
		/**
		 * @private
		 * 此类用来查找一个盒子的面
		 */
		public function calOneCubeSurface(cubeinfo:CubeInfo,posArray:Vector.<Number>,nolArray:Vector.<Number>,colArray:Vector.<Number>):void
		{

			var subcubeGeometry:SubCubeGeometry = cubeinfo.subCube;
			var vertexArray:Float32Array;
			var offset:int;
			var r:Number = (cubeinfo.color & 0xff)/255;
			//前面
			if (cubeinfo.frontVBIndex !=-1)
			{
				//添加法线
				nolArray.push(0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0);
				//判断是否有AO
				calOneFaceColor(subcubeGeometry, cubeinfo.frontVBIndex, cubeinfo, colArray, posArray,0);
			}
			//右面
			if (cubeinfo.rightVBIndex !=-1)
			{
				nolArray.push(1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
				calOneFaceColor(subcubeGeometry, cubeinfo.rightVBIndex, cubeinfo, colArray, posArray,1);
			}
			//上面
			if (cubeinfo.topVBIndex !=-1)
			{
				nolArray.push(0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0);
				calOneFaceColor(subcubeGeometry, cubeinfo.topVBIndex, cubeinfo, colArray, posArray,2);
			}
			//左面
			if (cubeinfo.leftVBIndex !=-1)
			{
				nolArray.push( -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
				calOneFaceColor(subcubeGeometry, cubeinfo.leftVBIndex, cubeinfo, colArray, posArray,3);
			}
			//下面
			if (cubeinfo.downVBIndex !=-1)
			{
				nolArray.push(0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0);
				calOneFaceColor(subcubeGeometry, cubeinfo.downVBIndex, cubeinfo, colArray, posArray,4);
			}
			//后面
			if (cubeinfo.backVBIndex !=-1)
			{
				nolArray.push(0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0);
				calOneFaceColor(subcubeGeometry, cubeinfo.backVBIndex, cubeinfo, colArray, posArray,5);
			}
			
		}
		public function PanDuanFloatXiangDeng(x1:Number, x2:Number):Boolean
		{
			if (Math.abs(x1 - x2) < 0.00001)
			{
				return true
			}
			else
			{
				return false;
			}
			
		}
		//判斷一個面是否有AO,沒有AO返回true
		public function existAo(cubeinfo:CubeInfo, VBIndex:int):Boolean
		{
			if (VBIndex ==-1)
			{
				return false;
			}
			var subcubeGeometry:SubCubeGeometry = cubeinfo.subCube;
				var r:Number = (cubeinfo.color & 0xff)/255;
			var g:Number = ((cubeinfo.color & 0xff00) >> 8) / 255;
			var b:Number = ((cubeinfo.color & 0xff0000) >> 16) / 255;
			
			var vertexArray:Float32Array;
			var offset:int;
			vertexArray = subcubeGeometry._vertices[VBIndex >> 24];
			offset = VBIndex & 0x00ffffff;
			if (PanDuanFloatXiangDeng(vertexArray[offset + 6],r) && PanDuanFloatXiangDeng(vertexArray[offset + 16],r) && PanDuanFloatXiangDeng(vertexArray[offset + 26],r )&& PanDuanFloatXiangDeng(vertexArray[offset + 36],r))
			{
				if(PanDuanFloatXiangDeng(vertexArray[offset + 7],g) && PanDuanFloatXiangDeng(vertexArray[offset + 17], g) && PanDuanFloatXiangDeng(vertexArray[offset + 27], g) && PanDuanFloatXiangDeng(vertexArray[offset + 37],g))
				{
					if (PanDuanFloatXiangDeng(vertexArray[offset + 8],b) && PanDuanFloatXiangDeng(vertexArray[offset + 18], b)&& PanDuanFloatXiangDeng(vertexArray[offset + 28],b)&& PanDuanFloatXiangDeng(vertexArray[offset + 38],b))
					{
						return true;
					}
				}
			}
			return false;
		}
		/**
		 *@private
		 * 此类用来合并一个面
		 */
		public function calOneFaceSurface(cubeinfo:CubeInfo, faceIndex:int,vertexArray:Vector.<Number>):Boolean
		{
			var x:int = cubeinfo.x - 1600;
			var y:int = cubeinfo.y - 1600;
			var z:int = cubeinfo.z - 1600;
			var color:int = cubeinfo.color;
			var othercubeinfo:CubeInfo;
			
			switch(faceIndex)
			{
				case 0:
					//front
					//先左后右，再上下
					var left:int = x;
					var right:int = x;
					var up:int = y;
					var down:int = y;
					//左
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(left-1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.frontVBIndex))
						{
							left -= 1;
							othercubeinfo.frontVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//右
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(right + 1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.frontVBIndex))
						{
							right += 1;
							othercubeinfo.frontVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//上
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, up + 1, z);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.frontVBIndex)))
							{
								yipai = false;
								break;
							}
							
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, up + 1, z);
								othercubeinfo.frontVBIndex = -1;
							}
							up += 1;
						}
						else
						{
							break;
						}
					}
					//下
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, down - 1, z);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.frontVBIndex)))
							{
								yipai = false;
								break;
							}
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, down - 1, z);
								othercubeinfo.frontVBIndex = -1;
							}
							down -= 1;
						}
						else
						{
							break;
						}
					}
					vertexArray.push(right + 1, up + 1, z + 1, left, up + 1, z + 1, left, down, z + 1, right + 1, down, z + 1);
					break;
				case 1:
					
					//right
					var front:int = z;
					var back:int = z;
					var up:int = y;
					var down:int = y;
					//后
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(x, y, back-1);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.rightVBIndex))
						{
							back -= 1;
							othercubeinfo.rightVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//前
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(x, y, front+1);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.rightVBIndex))
						{
							front += 1;
							othercubeinfo.rightVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//上
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = back; i <=front; i++) {
							othercubeinfo = findCubeToCubeInfo(x, up + 1, i);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.rightVBIndex)))
							{
								yipai = false;
								break;
							}
							
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = back; i <=front; i++) {
								othercubeinfo = findCubeToCubeInfo(x, up + 1, i);
								othercubeinfo.rightVBIndex = -1;
							}
							up += 1;
						}
						else
						{
							break;
						}
					}
					//下
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = back; i <=front; i++) {
							othercubeinfo = findCubeToCubeInfo(x, down - 1, i);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.rightVBIndex)))
							{
								yipai = false;
								break;
							}
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = back; i <=front; i++) {
								othercubeinfo = findCubeToCubeInfo(x, down - 1, i);
								othercubeinfo.rightVBIndex = -1;
							}
							down -= 1;
						}
						else
						{
							break;
						}
					}
					vertexArray.push(x + 1, up + 1, front+1,   x+1, down,front+1,   x+1,down,back, x+1,up+1,back);
					break;
				case 2:
					//up
					var front:int = z;
					var back:int = z;
					var left:int = x;
					var right:int = x;	
					//左
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(left-1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.topVBIndex))
						{
							left -= 1;
							othercubeinfo.topVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//右
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(right + 1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.topVBIndex))
						{
							right += 1;
							othercubeinfo.topVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//前
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, y,front+1 );
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.topVBIndex)))
							{
								yipai = false;
								break;
							}
							
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, y,front+1);
								othercubeinfo.topVBIndex = -1;
							}
							front += 1;
						}
						else
						{
							break;
						}
					}
					//后
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, y ,back-1);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.topVBIndex)))
							{
								yipai = false;
								break;
							}
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, y, back-1);
								othercubeinfo.topVBIndex = -1;
							}
							back -= 1;
						}
						else
						{
							break;
						}
					}
					vertexArray.push(right+1,y+1,front+1, right+1, y+1,back,   left,y+1,back,  left,y+1,front+1);
					break;
				case 3:
					//left
					var front:int = z;
					var back:int = z;
					var up:int = y;
					var down:int = y;
					//后
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(x, y, back-1);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.leftVBIndex))
						{
							back -= 1;
							othercubeinfo.leftVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//前
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(x, y, front+1);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.leftVBIndex))
						{
							front += 1;
							othercubeinfo.leftVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//上
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = back; i <=front; i++) {
							othercubeinfo = findCubeToCubeInfo(x, up + 1, i);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.leftVBIndex)))
							{
								yipai = false;
								break;
							}
							
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = back; i <=front; i++) {
								othercubeinfo = findCubeToCubeInfo(x, up + 1, i);
								othercubeinfo.leftVBIndex = -1;
							}
							up += 1;
						}
						else
						{
							break;
						}
					}
					//下
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = back; i <=front; i++) {
							othercubeinfo = findCubeToCubeInfo(x, down - 1, i);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.leftVBIndex)))
							{
								yipai = false;
								break;
							}
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = back; i <=front; i++) {
								othercubeinfo = findCubeToCubeInfo(x, down - 1, i);
								othercubeinfo.leftVBIndex = -1;
							}
							down -= 1;
						}
						else
						{
							break;
						}
					}
					vertexArray.push(x, up + 1, front+1,   x, up+1,back,   x,down,back,  x,down,front+1);
					break;
				case 4:
					//down
					var front:int = z;
					var back:int = z;
					var left:int = x;
					var right:int = x;	
					//左
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(left-1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.downVBIndex))
						{
							left -= 1;
							othercubeinfo.downVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//右
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(right + 1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.downVBIndex))
						{
							right += 1;
							othercubeinfo.downVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//前
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, y,front+1 );
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.downVBIndex)))
							{
								yipai = false;
								break;
							}
							
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, y,front+1);
								othercubeinfo.downVBIndex = -1;
							}
							front += 1;
						}
						else
						{
							break;
						}
					}
					//后
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, y ,back-1);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.downVBIndex)))
							{
								yipai = false;
								break;
							}
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, y, back-1);
								othercubeinfo.downVBIndex = -1;
							}
							back -= 1;
						}
						else
						{
							break;
						}
					}
					vertexArray.push(left,y,back, right+1,y,back,   right+1,y,front+1,  left,y,front+1);
					break;
				case 5:
					//back
					var left:int = x;
					var right:int = x;
					var up:int = y;
					var down:int = y;
					//左
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(left-1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.backVBIndex))
						{
							left -= 1;
							othercubeinfo.backVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//右
					while (true)
					{
						othercubeinfo = findCubeToCubeInfo(right + 1, y, z);
						if (othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.backVBIndex))
						{
							right += 1;
							othercubeinfo.backVBIndex = -1;
						}
						else
						{
							break;
						}
					}
					//上
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, up + 1, z);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.backVBIndex)))
							{
								yipai = false;
								break;
							}
							
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, up + 1, z);
								othercubeinfo.backVBIndex = -1;
							}
							up += 1;
						}
						else
						{
							break;
						}
					}
					//下
					while (true)
					{
						var yipai:Boolean = true;
						for (var i:int = left; i <=right; i++) {
							othercubeinfo = findCubeToCubeInfo(i, down - 1, z);
							if (!(othercubeinfo&&othercubeinfo.color==color&&existAo(othercubeinfo,othercubeinfo.backVBIndex)))
							{
								yipai = false;
								break;
							}
						}
						//如果這一排能合
						if (yipai)
						{
							for (var i:int = left; i <=right; i++) {
								othercubeinfo = findCubeToCubeInfo(i, down - 1, z);
								othercubeinfo.backVBIndex = -1;
							}
							down -= 1;
						}
						else
						{
							break;
						}
					}
					vertexArray.push(right+1,down,z,left,down,z,left,up+1,z,right+1,up+1,z);
					break;
			}
			
			
		}
		/**
		 * @private
		 * 此类用来计算一个面的Color
		 */
		public function calOneFaceColor(subcubeGeometry:SubCubeGeometry,VBIndex:int,cubeinfo:CubeInfo,colArray:Vector.<Number>,vertexArray:Vector.<Number>,faceIndex:int):void
		{
			
			var vertexArrayss:Float32Array;
			var offset:int;
			vertexArrayss = subcubeGeometry._vertices[VBIndex >> 24];
			offset = VBIndex & 0x00ffffff;
			
			if (existAo(cubeinfo,VBIndex))
			{
					//没有AO
					var r:Number = (cubeinfo.color & 0xff)/255;
					var g:Number = ((cubeinfo.color & 0xff00) >> 8) / 255;
					var b:Number = ((cubeinfo.color & 0xff0000) >> 16) / 255;
					colArray.push(r, g, b, 1.0, r, g, b, 1.0, r, g, b, 1.0, r, g, b, 1.0);
					calOneFaceSurface(cubeinfo,faceIndex,vertexArray);
			}
			else
			{
					//有AO
					colArray.push(vertexArrayss[offset + 6], vertexArrayss[offset + 7] , vertexArrayss[offset + 8] , 1.0,
							vertexArrayss[offset + 16], vertexArrayss[offset + 17], vertexArrayss[offset + 18], 1.0,
							vertexArrayss[offset + 26], vertexArrayss[offset + 27], vertexArrayss[offset + 28], 1.0,
							vertexArrayss[offset + 36], vertexArrayss[offset + 37], vertexArrayss[offset + 38], 1.0);
					vertexArray.push(vertexArrayss[offset], vertexArrayss[offset + 1] , vertexArrayss[offset + 2],
							vertexArrayss[offset + 10], vertexArrayss[offset + 11], vertexArrayss[offset + 12],
							vertexArrayss[offset + 20], vertexArrayss[offset + 21], vertexArrayss[offset + 22],
							vertexArrayss[offset + 30], vertexArrayss[offset + 31], vertexArrayss[offset + 32]);
							
			}
		}
		
		
	}
	
	
	 ////存储lm文件
		 //public function saveLmfile():Byte
		 //{
	//
			 ////创建二位数组
			 //var byteArray:Byte = new Byte();
			//
			 ////将数据先传入
			 ////顶点位置
			 //var VertexPosArray:Vector.<Number> = _cubeMeshFilter.surfaceVertexPosList;
			 ////法线
			 //var VertexNolArray:Vector.<Number> = _cubeMeshFilter.surfaceVertexNorList;
			 ////颜色
			 //var VertexColArray:Vector.<Number> = _cubeMeshFilter.surfaceVertexColorList;
			 ////索引
			 //var VertexIndxArray:Vector.<int> = cubeMeshFilter.surfaceVertexIndexList;
			 //
			 //var stringDatas:Vector.<String> = new Vector.<String>();
			 //stringDatas.push("MESH");
			 //stringDatas.push("SUBMESH");
			 ////版本号
			 //var LmVersion:String = "LAYAMODEL:0400";
			 ////顶点描述数据
			 //var vbDeclaration:String = "POSITION,NORMAL,COLOR"
			 ////VB大小
			 //var everyVBSize:int = 12 + 12 + 16;
			 //
			 ////版本号
			 //byteArray.writeUTFString(LmVersion);
			 //byteArray.pos = 0;
			 //console.log(byteArray.readUTFString());
			 //var verionsize:int = byteArray.pos;
			 //
			 ////标记数据信息区
			 //var ContentAreaPostion_Start:int = byteArray.pos;//预留数据区偏移地址
			 //byteArray.writeUint32(0);
			 //byteArray.writeUint32(0);
			 //
			 ////内容段落信息区
			 //var BlockAreaPosition_Start:int = byteArray.pos;//预留段落偏移地址
			 //byteArray.writeUint16(2);
			 //for (var i:int = 0; i < 2; i++ )
			 //{
				//byteArray.writeUint32(0);//Uint32 blockStart
				//byteArray.writeUint32(0);//Uint32 blockLength
			 //}
			 //
			 ////字符区
			 //var StringAreaPosition_Start:int = byteArray.pos;
			 //byteArray.writeUint32(0);//Uint32 offset
			 //byteArray.writeUint16(0);//count
			 //
			 ////网格区
			 //var MeshAreaPosition_Start:int = byteArray.pos;
			 //byteArray.writeUint16(0);//解析函数名字索引
			 //stringDatas.push("CubeMesh");
			 //byteArray.writeUint16(2);//网格名字索引
			 //
			 ////vb
			 //byteArray.writeUint16(1);//vb数量
			 //var VBMeshAreaPosition_Start:int = byteArray.pos;
			 //byteArray.writeUint32(0);//vbStart
			 //byteArray.writeUint32(0);//vbLength
			 //stringDatas.push(vbDeclaration);
			 //byteArray.writeUint16(3);
			 //
			 ////ib
			 //var IBMeshAreaPosition_Start:int = byteArray.pos;
			 //byteArray.writeUint32(0);//ibStart
			 //byteArray.writeUint32(0);//ibLength
			 //
			 ////Bone
			 //var BoneAreaPosition_Start:int = byteArray.pos;
			 //byteArray.writeUint16(0);//boneCount
			 //byteArray.writeUint32(0);//bindPosStart
			 //byteArray.writeUint32(0);//bindPosLength
			 //byteArray.writeUint32(0);//inverseGlobalBindPoseStart
			 //byteArray.writeUint32(0);//inverseGlobalBindPoseLength
			 //
			 //var MeshAreaPosition_End:int = byteArray.pos;
			 //var MeshAreaSize:int = MeshAreaPosition_End - MeshAreaPosition_Start;
			 //
			 ////子网格区
			 //var subMeshAreaPosition_Start:int = byteArray.pos;
			 //byteArray.writeUint16(1);//解析函数名字字符索引
			 //byteArray.writeUint16(0);//vbIndex
			 //byteArray.writeUint32(0);//vbStart
			 //byteArray.writeUint32(0);//vbLength
			 //
			 //byteArray.writeUint32(0);//ibStart
			 //byteArray.writeUint32(0);//ibLength
			 //
			 //byteArray.writeUint16(1);//drawCount
			 //
			 //byteArray.writeUint32(0);//subIbStart
			 //byteArray.writeUint32(0);//subibLength
			 //
			 //byteArray.writeUint32(0);//boneDicStart
			 //byteArray.writeUint32(0);//boneDicLength
			 //
			 //var subMeshAreaPosition_End:int = byteArray.pos;
			 //
			 //var subMeshAreaSize:int = subMeshAreaPosition_End - subMeshAreaPosition_Start;
			 //
			 ////字符数据区
			 //var StringDatasAreaPosition_Start:int = byteArray.pos;
			 //for (var i:int = 0; i < stringDatas.length; i++)
			 //{
				//byteArray.writeUTFString(stringDatas[i]);
			 //}
			 //var StringDatasAreaPosition_End:int = byteArray.pos;
			 //var StringDatasAreaSize:int = StringDatasAreaPosition_End - StringDatasAreaPosition_Start;
			 //
			 ////内容数据区
			 ////VB
			 //var VBContentDatasAreaPosition_Start:int = byteArray.pos;
			 //var VertexCount:int = VertexPosArray.length / 3;//顶点数量
			 //var posIndex:int = 0;
			 //var NorIndex:int = 0;
			 //var colIndex:int = 0;
			 //for (var j:int = 0; j < VertexCount; j++) 
			 //{
				 ////顶点数据
					//byteArray.writeFloat32(VertexPosArray[posIndex]);
					//posIndex++;
					//byteArray.writeFloat32(VertexPosArray[posIndex]);
					//posIndex++;
					//byteArray.writeFloat32(VertexPosArray[posIndex]);
					//posIndex++;
					//byteArray.writeFloat32(VertexNolArray[NorIndex]);
					//NorIndex++;
					//byteArray.writeFloat32(VertexNolArray[NorIndex]);
					//NorIndex++;
					//byteArray.writeFloat32(VertexNolArray[NorIndex]);
					//NorIndex++;
					//byteArray.writeFloat32(VertexColArray[colIndex]);
					//colIndex++;
					//byteArray.writeFloat32(VertexColArray[colIndex]);
					//colIndex++;
					//byteArray.writeFloat32(VertexColArray[colIndex]);
					//colIndex++;
					//byteArray.writeFloat32(VertexColArray[colIndex]);
					//colIndex++;
			 //}
			  //var VBContentDatasAreaPosition_End:int = byteArray.pos;
			  //var VBContentDatasAreaSize:int = VBContentDatasAreaPosition_End - VBContentDatasAreaPosition_Start;
			  //
			  ////ib
			  //var IBContentDatasAreaPosition_Start:int = byteArray.pos;
			  //var vertexIndexArrayLength:int = VertexIndxArray.length;
			  //for (var j:int = 0; j < vertexIndexArrayLength; j++)
			  //{
				//byteArray.writeUint16(VertexIndxArray[j]);
			  //}
			  //var IBContentDatasAreaPosition_End:int = byteArray.pos;
			  //var IBContentDatasAreaSize:int = IBContentDatasAreaPosition_End - IBContentDatasAreaPosition_Start;
			  //
			  ////倒推子网格区
			  //var vbstart:int = 0;
			  //var vblength:int = 0;
			  //var ibstart:int = 0;
			  //var iblength:int = 0;
			  //var _ibstart = 0;
			  //
			  //byteArray.pos = subMeshAreaPosition_Start + 4;
			  //vbstart = 0;
			  //vblength = VBContentDatasAreaSize / everyVBSize;
			  //ibstart = 0;
			  //iblength = IBContentDatasAreaSize / 2;
			  //
			  //byteArray.writeUint32(vbstart);
			  //byteArray.writeUint32(vblength);
			  //byteArray.writeUint32(ibstart);
			  //byteArray.writeUint32(iblength);
			  //
			  //byteArray.pos += 2;
			  //
			  //byteArray.writeUint32(ibstart);
			  //byteArray.writeUint32(iblength);
			  //
			  ////倒推网格区
			  //byteArray.pos = VBMeshAreaPosition_Start;
			  //byteArray.writeUint32(VBContentDatasAreaPosition_Start - StringDatasAreaPosition_Start);
			  //byteArray.writeUint32(VBContentDatasAreaSize);
			  //
			  //byteArray.pos = IBMeshAreaPosition_Start;
			  //byteArray.writeUint32(IBContentDatasAreaPosition_Start - StringDatasAreaPosition_Start);
			  //byteArray.writeUint32(IBContentDatasAreaSize);
			  //
			  ////倒推字符区
			  //byteArray.pos = StringAreaPosition_Start;
			  //byteArray.writeUint32(0);
			  //byteArray.writeUint16(stringDatas.length);
			  //StringDatasAreaPosition_End = byteArray.pos;
			  //
			  ////倒推段落区
			  //byteArray.pos = BlockAreaPosition_Start + 2;
			  //byteArray.writeUint32(MeshAreaPosition_Start);
			  //byteArray.writeUint32(MeshAreaSize);
			  //
			  //byteArray.writeUint32(subMeshAreaPosition_Start);
			  //byteArray.writeUint32(subMeshAreaSize);
			  //
			  //
			  ////倒推标记内容数据信息区
			  //byteArray.pos = ContentAreaPostion_Start;
			  //byteArray.writeUint32(StringDatasAreaPosition_Start);
			  //byteArray.writeUint32(StringDatasAreaPosition_Start + StringDatasAreaSize
			  //+ VBContentDatasAreaSize + IBContentDatasAreaSize + subMeshAreaSize);
			  //
			//
			  //return byteArray;
		 //}
}
