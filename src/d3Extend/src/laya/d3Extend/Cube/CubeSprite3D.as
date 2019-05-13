package Cube {
	
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.RenderState;
	import laya.d3.core.pixelLine.PixelLineMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3Extend.worldMaker.CubeInfoArray;
	import laya.webgl.resource.Texture2D;
	/**
	 * <code>CubeSprite3D</code> 类用于实现方块精灵。
	 */
	public class CubeSprite3D extends RenderableSprite3D {
		public static const MAXCUBES:int = 300000;
		
		/** @private */
		public var _cubeGeometry:CubeGeometry
		public var Layer:int = 0;
		/** @private */
		public var _enableEditer:Boolean;
		
		//public static const MAXCUBESIZE:int = 1600;
		
		public var UpdataCube:Vector.<CubeInfoArray> = new Vector.<CubeInfoArray>();
		
		public var CubeNums:int = 0;
		/**是否可以渲染。 */
		public var enableRender:Boolean = true;
		
		/**
		 * 获取是否可编辑。
		 * @return 是否可编辑。
		 */
		public function get enableEditer():Boolean {
			return _enableEditer;
		}
		
		/**
		 * 创建一个 <code>CubeSprite3D</code> 实例。
		 * @param cubeSprite3D 源方块精灵,如果为空,则内部会自动创建几何体信息并可编辑,不为空则使用参数的几何体并不可编辑
		 * @param name 名字
		 */
		public function CubeSprite3D(cubeSprite3D:CubeSprite3D = null, name:String = null) {
			super(name);
			selectCube = CubeInfo.create(0, 0, 0);
			if (cubeSprite3D) {
				if (cubeSprite3D.enableEditer) {
					throw "CubeSprite3D: cubeSprite3D must be can't editer.";
				} else {
					_cubeGeometry = cubeSprite3D._cubeGeometry;
					_enableEditer = false;
				}
			} else {
				_cubeGeometry = new CubeGeometry(this);
				_enableEditer = true;
			}
			var render:CubeRender = new CubeRender(this);
			_render = render;
			var renderObjects:Vector.<RenderElement> = render._renderElements;
			var renderElement:RenderElement = new RenderElement();
			//miner
			//	var material:BlinnPhongMaterial = new BlinnPhongMaterial();
			
			var material:CubeMaterial = new CubeMaterial();
			
			//material.enableVertexColor = true;
			material.modEnableVertexColor = true;
			material.enableVertexColor = true;
			
			material.albedoColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			material.specularColor = new Vector4(0.2, 0.2, 0.2, 1);
			renderElement.setTransform(_transform);
			renderElement.setGeometry(_cubeGeometry);
			renderElement.render = render;
			renderElement.material = material;
			renderObjects.push(renderElement);
			_render._defineDatas.add(MeshSprite3D.SHADERDEFINE_COLOR);
			_render.sharedMaterial = material;
			//12.10
			
			this.addChild(cubeMeshSpriteLines);
			cubeMeshSpriteLinesFill = cubeMeshSpriteLines._geometryFilter;
			
			var pm:PixelLineMaterial = new PixelLineMaterial();
			pm.renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE + 1;
			pm.getRenderState(0).depthTest = RenderState.DEPTHTEST_LEQUAL;
			cubeMeshSpriteLines.pixelLineRenderer.material = pm;
			this.addComponent(Asynchronousloading);
		}
		
		/**
		 * 添加方块。
		 * @param	x X坐标
		 * @param	y Y坐标
		 * @param	z Z坐标
		 * @param	color 颜色
		 */
		public function AddCube(x:int, y:int, z:int, color:int, layer:int = 0, isSetData:Boolean = false):int {
			
			if (y <= -CubeGeometry.HLAFMAXSIZE || y >= CubeGeometry.HLAFMAXSIZE) {
				return -1;
			}
	
			//else if(enableEditer)
			return _cubeGeometry.addCube(x, y, z, color, isSetData);
			//else 
			//return -1
		
		}
		
		/**
		 * 删除方块。
		 * @param	x X坐标
		 * @param	y Y坐标
		 * @param	z Z坐标
		 * @param	color 颜色
		 */
		public function RemoveCube(x:int, y:int, z:int, isSetData:Boolean = false):int {
			//if (_enableEditer)
			return (CubeNums == 1) ? -1 : _cubeGeometry.removeCube(x, y, z, isSetData);
			//else
			//return -1;
		}
		
		/**
		 * 更新方块颜色。
		 * @param	x X坐标
		 * @param	y Y坐标
		 * @param	z Z坐标
		 * @param	color 颜色
		 */
		public function UpdataColor(x:int, y:int, z:int, color:int):int {
			if (_enableEditer)
				return _cubeGeometry.updateColor(x, y, z, color);
			else
				return -1;
		}
		
		/**
		 * 更新方块的alpha属性
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public function UpdataProperty(x:int, y:int, z:int, Property:int):int {
			if (_enableEditer)
				return _cubeGeometry.updataProperty(x, y, z, Property);
			else
				return -1;
		}
		
		/**
		 * 删掉没有面的函数
		 */
		public function deletNoFaceCube():void {
			var cubemap:CubeMap = _cubeGeometry.cubeMap;
			var cubeinfos:Vector.<CubeInfo> = cubemap.returnAllCube();
			for (var i:int = 0; i < cubeinfos.length; i++) {
				RemoveCube(cubeinfos[i].x - 1600, cubeinfos[i].y - 1600, cubeinfos[i].z - 1600);
			}
		}
		
		public function UpdataAo(x:int, y:int, z:int):void {
			if (_enableEditer)
				_cubeGeometry.updateAO(x, y, z);
		}
		
		/**
		 * 寻找方块
		 * @param	x X坐标
		 * @param	y Y坐标
		 * @param	z Z坐标
		 * @return	color 颜色
		 */
		public function FindCube(x:int, y:int, z:int):int {
			//if (_enableEditer)
			return _cubeGeometry.findCube(x, y, z); //(x<0 || x>=CubeMap.SIZE || y<0 || y>=CubeMap.SIZE)?null:_cubeGeometry.findCube(x, y, z);
			//else
			//return -1;
		}
		
		/**
		 * 清除所有方块。
		 */
		public function RemoveAllCube():void {
			if (_enableEditer) {
				_cubeGeometry.clear();
				UpdataCube && (UpdataCube.length = 0);
				CubeNums = 0;
			}
		}
		
		/**
		 * 清理编辑信息,清除后不可恢复编辑。
		 */
		public function clearEditerInfo():void {
			if (_enableEditer) {
				UpdataCube = null;
				_enableEditer = false;
					//_cubeGeometry._clearEditerInfo();
			}
		}
		
		//________________________________________________________________________________
		/**
		 * 加载本地文件
		 * @param   文件地址
		 */
		
		private var voxfile:VoxFileData;
		
		public function loadFileData(url:String):void {
			RemoveAllCube();
			if (url.indexOf(".vox") != -1 || url.indexOf(".lm") != -1) {
				voxfile = voxfile || new VoxFileData();
				voxfile.LoadVoxFile(url, Handler.create(this, function(cubeArray:CubeInfoArray):void {
					
					cubeArray.Layar = this.layer;
					AddCubes(cubeArray);
					
					this.event(Event.COMPLETE);
				}));
			} else if (url.indexOf(".lvox") != -1 || url.indexOf(".lh") != -1) {
				lVoxFile.LoadlVoxFile(url, Handler.create(this, function(cubeArray:CubeInfoArray):void {
					//var cubeArray:CubeInfoArray = VectorCubeRevertCubeInfoArray(cubeinfoss);
					cubeArray.Layar = this.layer;
					AddCubes(cubeArray);
					this.event(Event.COMPLETE);
				}))
			}
		}
		private var _src:String;
		
		public function set src(str:String):void {
			_src = str;
			loadFileData(str);
		}
		
		override public function _parse(data:Object):void {
			super._parse(data);
			if (data.src) {
				src = data.src;
			}
		}
		
		public function get src():String {
			return _src;
		}
		public var isReady:Boolean = true;
		
		//通过ArrayBuffer初始化
		public function loadByArrayBuffer(arrayBuffer:ArrayBuffer):void {
			isReady = false;
			var cubeInfo:CubeInfoArray = lVoxFile.LoadlVoxFilebyArray(arrayBuffer);
			if (cubeInfo) {
				this.AddCubeByArray(cubeInfo);
			}
		}
		
		//_______________________________________________________________________
		
		public function VectorCubeRevertCubeInfoArray(cubearray:Vector.<CubeInfo>):CubeInfoArray {
			var cubeInfoarray:CubeInfoArray = new CubeInfoArray();
			var length:int = cubearray.length;
			for (var i:int = 0; i < length; i++) {
				cubeInfoarray.PositionArray.push(cubearray[i].x);
				cubeInfoarray.PositionArray.push(cubearray[i].y);
				cubeInfoarray.PositionArray.push(cubearray[i].z);
				cubeInfoarray.colorArray.push(cubearray[i]._color);
			}
			return cubeInfoarray;
		}
		
		public function AddCubeByArray(cubeInfoArray:CubeInfoArray):void {
			
			cubeInfoArray.currentPosindex = 0;
			cubeInfoArray.currentColorindex = 0;
			this.Layer = cubeInfoArray.Layar;
			cubeInfoArray.operation = CubeInfoArray.Add;
			UpdataCube.push(cubeInfoArray);
			
			_cubeGeometry.IsRender = false;
			
			var cubeAoArray:CubeInfoArray = CubeInfoArray.create();
			cubeAoArray.PositionArray.length = 0;
			
			cubeAoArray.PositionArray = cubeInfoArray.PositionArray.slice();
		
		}
		
		public var returnArrayValues:Vector.<int> = new Vector.<int>();
		
		/**
		 * 批量增加Cube
		 */
		public function AddCubes(cubeInfoArray:CubeInfoArray, isUpdataAo:Boolean = true):Vector.<int> {
			
			var lenth:int = cubeInfoArray.PositionArray.length / 3;
			var PositionArray:Vector.<int> = cubeInfoArray.PositionArray;
			cubeInfoArray.currentColorindex = 0;
			cubeInfoArray.currentPosindex = 0;
			returnArrayValues.length = lenth;
			for (var i:int = 0; i < lenth; i++) {
				var x:int = PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dx;
				var y:int = PositionArray[cubeInfoArray.currentPosindex + 1] + cubeInfoArray.dy;
				var z:int = PositionArray[cubeInfoArray.currentPosindex + 2] + cubeInfoArray.dz;
				var color:int = cubeInfoArray.colorArray[cubeInfoArray.currentColorindex];
				cubeInfoArray.currentPosindex += 3;
				cubeInfoArray.currentColorindex++;
				returnArrayValues[i] = AddCube(x, y, z, color, cubeInfoArray.Layar, isUpdataAo);
			}
			return returnArrayValues;
		}
		
		/**
		 * 批量减少Cube
		 */
		public function RemoveCubes(cubeInfoArray:CubeInfoArray, CalAo:Boolean = true):Vector.<int> {
			returnArrayValues.length = 0;
			var lenth:int = cubeInfoArray.PositionArray.length / 3;
			cubeInfoArray.currentPosindex = 0;
			for (var i:int = 0; i < lenth; i++) {
				var x:int = cubeInfoArray.PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dx;
				cubeInfoArray.currentPosindex++;
				var y:int = cubeInfoArray.PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dy;
				cubeInfoArray.currentPosindex++;
				var z:int = cubeInfoArray.PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dz;
				cubeInfoArray.currentPosindex++;
				if (FindCube(x, y, z) != -1) {
					returnArrayValues.push(RemoveCube(x, y, z, CalAo));
				} else {
					returnArrayValues.push(-1);
				}
			}
			
			return returnArrayValues;
		}
		
		/**
		 * 批量更换颜色
		 */
		public function UpdateColors(cubeInfoArray:CubeInfoArray, color:int):Vector.<int> {
			returnArrayValues.length = 0;
			var len:int = cubeInfoArray.colorArray.length;
			var posarr:Vector.<int> = cubeInfoArray.PositionArray;
			for (var i:int = 0; i < len; i++) {
				var tempArr:int = UpdataColor(posarr[i * 3] + cubeInfoArray.dx, posarr[i * 3 + 1] + cubeInfoArray.dy, posarr[i * 3 + 2] + cubeInfoArray.dz, color == -1 ? cubeInfoArray.colorArray[i] : color, false);
				returnArrayValues.push(tempArr);
			}
			
			return returnArrayValues;
		}
		
		/**
		 * 批量修改AO
		 */
		public function CalCubeAos(cubeInfoArray:CubeInfoArray):void {
			var lenth:int = cubeInfoArray.PositionArray.length / 3;
			cubeInfoArray.currentPosindex = 0;
			for (var i:int = 0; i < lenth; i++) {
				var x:int = cubeInfoArray.PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dx;
				cubeInfoArray.currentPosindex++;
				var y:int = cubeInfoArray.PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dy;
				cubeInfoArray.currentPosindex++;
				var z:int = cubeInfoArray.PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dz;
				cubeInfoArray.currentPosindex++;
				
				UpdataAo(x, y, z);
				
			}
		}
		
		//画线
		public var cubeMeshSpriteLines:PixelLineSprite3D = new PixelLineSprite3D(100);
		public var cubeMeshSpriteLinesFill:PixelLineFilter;
		private var StarPoint:Vector3 = new Vector3(0, 0, 0);
		private var EndPoint:Vector3 = new Vector3(0, 0, 0);
		protected var lineCount:int;
		public var selectCube:CubeInfo;
		public var selectCubeMap:CubeMap = new CubeMap();
		
		//画一个面的线
		public function drawLineFace(index:int, x:int, y:int, z:int, isSetData:Boolean):void {
			switch (index) {
			case 0: 
				selectCube.selectArrayIndex.push(lineCount);
				drawoneLine(lineCount++, x + 1, y + 1, z + 1, x, y + 1, z + 1, isSetData);
				drawoneLine(lineCount++, x, y + 1, z + 1, x, y, z + 1, isSetData);
				drawoneLine(lineCount++, x, y, z + 1, x + 1, y, z + 1, isSetData);
				drawoneLine(lineCount++, x + 1, y, z + 1, x + 1, y + 1, z + 1, isSetData);
				break;
			case 1: 
				selectCube.selectArrayIndex.push(lineCount);
				drawoneLine(lineCount++, x + 1, y + 1, z + 1, x + 1, y, z + 1, isSetData);
				drawoneLine(lineCount++, x + 1, y, z + 1, x + 1, y, z, isSetData);
				drawoneLine(lineCount++, x + 1, y, z, x + 1, y + 1, z, isSetData);
				drawoneLine(lineCount++, x + 1, y + 1, z, x + 1, y + 1, z + 1, isSetData);
				
				break;
			case 2: 
				selectCube.selectArrayIndex.push(lineCount);
				drawoneLine(lineCount++, x + 1, y + 1, z + 1, x + 1, y + 1, z, isSetData);
				drawoneLine(lineCount++, x + 1, y + 1, z, x, y + 1, z, isSetData);
				drawoneLine(lineCount++, x, y + 1, z, x, y + 1, z + 1, isSetData);
				drawoneLine(lineCount++, x, y + 1, z + 1, x + 1, y + 1, z + 1, isSetData);
				
				break;
			case 3: 
				selectCube.selectArrayIndex.push(lineCount);
				drawoneLine(lineCount++, x, y + 1, z + 1, x, y + 1, z, isSetData);
				drawoneLine(lineCount++, x, y + 1, z, x, y, z, isSetData);
				drawoneLine(lineCount++, x, y, z, x, y, z + 1, isSetData);
				drawoneLine(lineCount++, x, y, z + 1, x, y + 1, z + 1, isSetData);
				
				break;
			case 4: 
				selectCube.selectArrayIndex.push(lineCount);
				drawoneLine(lineCount++, x, y, z, x + 1, y, z, isSetData);
				drawoneLine(lineCount++, x + 1, y, z, x + 1, y, z + 1, isSetData);
				drawoneLine(lineCount++, x + 1, y, z + 1, x, y, z + 1, isSetData);
				drawoneLine(lineCount++, x, y, z + 1, x, y, z, isSetData);
				
				break;
			case 5: 
				selectCube.selectArrayIndex.push(lineCount);
				drawoneLine(lineCount++, x + 1, y, z, x, y, z, isSetData);
				drawoneLine(lineCount++, x, y, z, x, y + 1, z, isSetData);
				drawoneLine(lineCount++, x, y + 1, z, x + 1, y + 1, z, isSetData);
				drawoneLine(lineCount++, x + 1, y + 1, z, x + 1, y, z, isSetData);
				break;
			}
		}
		var cubeMeshSpriteKey:int;
		
		//选择Cube
		public function SelectCube(x:int, y:int, z:int, isSetData:Boolean = true, IsFanXuan:Boolean = false):int {
			
			selectCube = _cubeGeometry.findCubeToCubeInfo(x, y, z);
			if (!selectCube || !selectCube.subCube) {
				console.warn("this SelectCube is not exist");
				return 0;
			}
			//判断是否已经选中
			if (IsFanXuan) {
				if ((selectCubeMap.find(x + CubeGeometry.HLAFMAXSIZE, y + CubeGeometry.HLAFMAXSIZE, z + CubeGeometry.HLAFMAXSIZE) as CubeInfo) != null) {
					
					selectCubeMap.remove(x + CubeGeometry.HLAFMAXSIZE, y + CubeGeometry.HLAFMAXSIZE, z + CubeGeometry.HLAFMAXSIZE);
					CancelSelect(selectCube, isSetData);
					return 1;
					
				}
				return 0;
			}
			
			if ((selectCubeMap.find(x + CubeGeometry.HLAFMAXSIZE, y + CubeGeometry.HLAFMAXSIZE, z + CubeGeometry.HLAFMAXSIZE) as CubeInfo) == null) {	//选中
				selectCubeMap.add(x + CubeGeometry.HLAFMAXSIZE, y + CubeGeometry.HLAFMAXSIZE, z + CubeGeometry.HLAFMAXSIZE, selectCube);
				selectCube.ClearSelectArray();
				for (var j:int = 0; j < 6; j++) {
					
					if ((x + CubeGeometry.HLAFMAXSIZE + 1 < 0) || (y + CubeGeometry.HLAFMAXSIZE + 1 < 0) || (z + CubeGeometry.HLAFMAXSIZE + 1 < 0)) {
						return -1;
					}
					var otherCube:CubeInfo = _cubeGeometry.cubeMap.find(x + CubeGeometry.HLAFMAXSIZE + 1, y + CubeGeometry.HLAFMAXSIZE + 1, z + CubeGeometry.HLAFMAXSIZE + 1);
					switch (j) {
					case 0: 
						if (otherCube.calDirectCubeExit(6) != -1) continue;
						break;
					case 1: 
						if (otherCube.calDirectCubeExit(5) != -1) continue;
						break;
					case 2: 
						if (otherCube.calDirectCubeExit(0) != -1) continue;
						break;
					case 3: 
						if (selectCube.calDirectCubeExit(2) != -1) continue;
						break;
					case 4: 
						if (selectCube.calDirectCubeExit(7) != -1) continue;
						break;
					case 5: 
						if (selectCube.calDirectCubeExit(1) != -1) continue;
						break;
					}
					drawLineFace(j, x, y, z, isSetData);
					
				}
				return 1;
			}
			return 0;
		
		}
		
		public function SelectCubes(cubeInfoarray:CubeInfoArray, isFanXuan:Boolean = false):Vector.<int> {
			var length:int = cubeInfoarray.colorArray.length;
			returnArrayValues.length = length;
			cubeInfoarray.currentPosindex = 0;
			for (var i:int = 0; i < length; i++) {
				var x:int = cubeInfoarray.PositionArray[i * 3] + cubeInfoarray.dx;
				var y:int = cubeInfoarray.PositionArray[i * 3 + 1] + cubeInfoarray.dy;
				var z:int = cubeInfoarray.PositionArray[i * 3 + 2] + cubeInfoarray.dz;
				returnArrayValues[i] = SelectCube(x, y, z, false, isFanXuan);
			}
			cubeMeshSpriteLinesFill._vertexBuffer.setData(cubeMeshSpriteLinesFill._vertices, 0, 0, lineCount * 14);
			return returnArrayValues;
		}
		
		//画一条线
		public function drawoneLine(LineIndex:int, startx:int, starty:int, startz:int, endx:int, endy:int, endz:int, IssetData:Boolean):void {
			var offset:int = LineIndex * 14;
			
			var vertices:Float32Array = cubeMeshSpriteLinesFill._vertices;
			vertices[offset + 0] = startx;
			vertices[offset + 1] = starty;
			vertices[offset + 2] = startz;
			
			vertices[offset + 3] = 1;
			vertices[offset + 4] = 1;
			vertices[offset + 5] = 1;
			vertices[offset + 6] = 1;
			
			vertices[offset + 7] = endx;
			vertices[offset + 8] = endy;
			vertices[offset + 9] = endz;
			
			vertices[offset + 10] = 1;
			vertices[offset + 11] = 1;
			vertices[offset + 12] = 1;
			vertices[offset + 13] = 1;
			cubeMeshSpriteLinesFill._lineCount += 1;
			if (cubeMeshSpriteLinesFill._lineCount == cubeMeshSpriteLinesFill._maxLineCount)
				cubeMeshSpriteLines.maxLineCount += 20000;
			if (IssetData)
				cubeMeshSpriteLinesFill._vertexBuffer.setData(vertices, offset, offset, 14);
		}
		
		public function CancelSelect(cubeInfoCan:CubeInfo, IsSetData:Boolean):void {
			var FaceNum:int = cubeInfoCan.selectArrayIndex.length;
			var arrayInt:Vector.<int> = cubeInfoCan.selectArrayIndex;
			for (var i:int = 0; i < FaceNum; i++) {
				
				CancelDrawOneFace(arrayInt[i], IsSetData);
			}
		}
		
		public function CancelDrawOneFace(LineIndex:int, IssetData:Boolean):void {
			for (var i:int = 0; i < 4; i++) {
				CancelDrawOneLine(LineIndex + i, IssetData);
			}
		}
		
		public function CancelDrawOneLine(LineIndex:int, IssetData:Boolean):void {
			var offset:int = LineIndex * 14;
			
			var vertices:Float32Array = cubeMeshSpriteLinesFill._vertices;
			vertices[offset + 0] = 0;
			vertices[offset + 1] = 0;
			vertices[offset + 2] = 0;
			
			vertices[offset + 3] = 1;
			vertices[offset + 4] = 1;
			vertices[offset + 5] = 1;
			vertices[offset + 6] = 1;
			
			vertices[offset + 7] = 0;
			vertices[offset + 8] = 0;
			vertices[offset + 9] = 0;
			
			vertices[offset + 10] = 1;
			vertices[offset + 11] = 1;
			vertices[offset + 12] = 1;
			vertices[offset + 13] = 1;
			
			if (IssetData)
				cubeMeshSpriteLinesFill._vertexBuffer.setData(vertices, offset, offset, 14);
		}
		
		public function LineClear():void {
			cubeMeshSpriteLines.clear();
			selectCubeMap.clear();
			lineCount = 0;
		}
		
		public function SelectAllCube():void {
			var vec:Vector.<CubeInfo> = _cubeGeometry.cubeMap.returnCubeInfo();
			var length:int = vec.length;
			var cubeinfo:CubeInfo;
			for (var i:int = 0; i < length; i++) {
				cubeinfo = vec[i];
				SelectCube(cubeinfo.x - CubeGeometry.HLAFMAXSIZE, cubeinfo.y - CubeGeometry.HLAFMAXSIZE, cubeinfo.z - CubeGeometry.HLAFMAXSIZE, false, false);
			}
			cubeMeshSpriteLinesFill._vertexBuffer.setData(cubeMeshSpriteLinesFill._vertices, 0, 0, lineCount * 14);
		}
		
		/**
		 * @inheritDoc
		 * @param	destroyChild
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_cubeGeometry.destroy();
			CubeInfo.recover(selectCube);
		}
		
		public function cubeTrans(isTran:Boolean = true):void {
			
			var maa:BaseMaterial = _render.sharedMaterial;
			if (isTran) {
				(maa as CubeMaterial).renderMode = CubeMaterial.RENDERMODE_TRANSPARENT;
				(maa as CubeMaterial).albedoColorA = 0.5;
			} else {
				(maa as CubeMaterial).renderMode = CubeMaterial.RENDERMODE_OPAQUE;
				(maa as CubeMaterial).albedoColorA = 1.0;
			}
		}
	
	}

}

import laya.d3.component.Script3D;
import laya.d3.core.Sprite3D;
import laya.d3.core.material.BaseMaterial;
import laya.d3.core.pixelLine.PixelLineMaterial;
import laya.d3.core.pixelLine.PixelLineSprite3D;
import laya.d3.math.Color;
import laya.d3.math.Vector4;

import laya.d3Extend.worldMaker.CubeInfoArray;
import laya.utils.Stat;

class Asynchronousloading extends Script3D {
	private var _pixelline:PixelLineSprite3D;
	private var _pixelMaterial:PixelLineMaterial;
	private var _linecolor:Vector4 = new Vector4(1, 1, 1, 1);
	private var _tim:Number = 0;
	
	private var cubeSprite3D:CubeSprite3D;
	private var color:int;
	private var cubeinfoarray:CubeInfoArray;
	var x:int;
	var y:int;
	var z:int;
	
	override public function onStart():void {
		cubeSprite3D = owner as CubeSprite3D;
		_pixelline = cubeSprite3D.cubeMeshSpriteLines;
		
		_pixelMaterial = _pixelline._render.material as PixelLineMaterial;
	}
	
	override public function onUpdate():void {
		AddCubeYiBu();
		if (_pixelline.lineCount > 0) {
			if (Stat.loopCount % 2 == 0) {
				changeLineColor();
			}
		}
	}
	
	public function AddCubeYiBu():void {
		if (cubeSprite3D.UpdataCube.length != 0) {
			cubeinfoarray = cubeSprite3D.UpdataCube[0];
			var currentPosIndex:int = cubeinfoarray.currentPosindex;
			if ((cubeinfoarray.PositionArray.length - currentPosIndex - 1) / 3 < CubeGeometry.updateCubeCount) {
				//1增加 2减少
				var length:int = (cubeinfoarray.PositionArray.length - (currentPosIndex + 1)) / 3;
				for (var i:int = 0; i < length; i++) {
					x = cubeinfoarray.PositionArray[currentPosIndex++] + cubeinfoarray.dx;
					y = cubeinfoarray.PositionArray[currentPosIndex++] + cubeinfoarray.dy;
					z = cubeinfoarray.PositionArray[currentPosIndex++] + cubeinfoarray.dz;
					
					color = cubeinfoarray.colorArray[cubeinfoarray.currentColorindex++];
					cubeSprite3D.AddCube(x, y, z, color, cubeinfoarray.Layar, false);
					
				}
				cubeinfoarray.currentColorindex = cubeinfoarray.currentPosindex = 0;
				cubeSprite3D.UpdataCube.shift();
				cubeSprite3D._cubeGeometry.IsRender = true;
				if (cubeSprite3D.UpdataCube.length == 0) {
					cubeSprite3D.isReady = true;
				}
				
				
				
			} else {
				for (var i:int = 0; i < CubeGeometry.updateCubeCount; i++) {
					x = cubeinfoarray.PositionArray[currentPosIndex++] + cubeinfoarray.dx;
					y = cubeinfoarray.PositionArray[currentPosIndex++] + cubeinfoarray.dy;
					z = cubeinfoarray.PositionArray[currentPosIndex++] + cubeinfoarray.dz;
					
					color = cubeinfoarray.colorArray[cubeinfoarray.currentColorindex++];
					cubeSprite3D.AddCube(x, y, z, color, cubeinfoarray.Layar, false);
				}
				cubeinfoarray.currentPosindex += CubeGeometry.updateCubeCount * 3;
				
			}
		}
	
	}
	
	public function changeLineColor():void {
		_tim += 0.05;
		_linecolor.y = Math.abs(Math.cos(_tim));
		_linecolor.z = Math.abs(Math.cos(_tim));
		_pixelMaterial.color = _linecolor;
	
	}

}

