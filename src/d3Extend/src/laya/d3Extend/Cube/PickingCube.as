package Cube 
{
	import laya.d3Extend.Cube.CubeInfo;
	/**
	 * 定义选取的cube的合并操作
	 * @author dddd
	 */
	public class PickingCube 
	{
		/**这个队列来标记Cube已经被选中*/
		public var _cubeInfoIsPick:Vector.<Boolean> = new Vector.<Boolean>();
		/**映射map:cubeIndex->palneIndex*/
		private var _cubeGetPlane:Vector.<String> = new Vector.<String>;
		/**存储合并的plane*/
		private var _comPlane:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
		/**新pick的cube*/
		private var _cube:CubeInfo;
		/**常用量*/
		private static const _maxVertexCount = 1600;
		private static const _sqrtMaxVertexCount:int = _maxVertexCount * _maxVertexCount;
		
		public function PickingCube() {
			
		}
		
		/**
		 * 合并新选取的cube(如果需要合并的话)
		 */
		public function mergePickideCube(newCube:CubeInfo):void {
			_cube = newCube;
			var cube:CubeInfo = newCube;
			var cx:int = cube.x;
			var cy:int = cube.y;
			var cz:int = cube.z;
			var cc:int = cube.color;
			
			var sqrtMaxVertexCountCX:int = _sqrtMaxVertexCount * cx;
			var maxVertexCountCY:int = _maxVertexCount * cy;
			var zMaxVertexCountCY:int  = z + maxVertexCountCY
			var indexCube:int = cz + maxVertexCountCY + sqrtMaxVertexCountCX;
			if (_cubeInfoIsPick[indexCube] == true) {
				return;
			}
			_cubeInfoIsPick[indexCube] = true;
			
			
			//立方体周围的六个立方体的索引
			var indexCube0:int = zMaxVertexCountCY + 1 + sqrtMaxVertexCountCX; //0 front
			var indexCube1:int = zMaxVertexCountCY - 1 + sqrtMaxVertexCountCX; //1 back
			var indexCube2:int = zMaxVertexCountCY + sqrtMaxVertexCountCX - _sqrtMaxVertexCount; //2 left
			var indexCube3:int = zMaxVertexCountCY + sqrtMaxVertexCountCX - _sqrtMaxVertexCount; //3 right
			var indexCube4:int = zMaxVertexCountCY + _maxVertexCount + sqrtMaxVertexCountCX; //4 up
			var indexCube5:int = zMaxVertexCountCY - _maxVertexCount + sqrtMaxVertexCountCX; //5 down
			
			//可见性测试放在_comSixPlane调用之前，避免函数调用开销
			//front面可见
			if (cube.front != -1) {
				var plane:PlaneInfo = new PlaneInfo(cx, cy, 1, 1, cc);
				var planeKey:int = plane.getIndex();
				//left立方体是否被选中,不需要判断是否存在，选中必存在
				if (_cubeInfoIsPick[indexCube2] == true) {
					var cubeLeft:CubeInfo = CubeInfoList[indexCube2];
					if (cubeLeft.frontVBIndex != -1) {
						//标记是否被合并
						var isCom:Boolean = false;
						//查看当前的cube是否被合并了2018112更改逻辑 单个cube也构成planeinfo
						var planeLeft:PlaneInfo = _comPlane[_cubeGetPlane[indexCube2]];
						var planeLeftHeight:int = planeLeft.height;
						if (planeLeftHeight == 1) {
							planeLeft.addWidth(1);
							_cubeGetPlane[indexCube2] = planeLeft.getIndex();	
							plane = planeLeft;
							isCom = true;
						}
						else {
							var newPlaneKey:int = plane.getIndex();
							_comPlane[newPlaneKey] = plane;
							_cubeGetPlane[indexCube] = newPlaneKey;	
						}
						//如果右边的存在
						if (_cubeInfoIsPick[indexCube3] == true) {	
							var cubeRight:CubeInfo = CubeInfoList[indexCube3];
							if (cubeRight.frontVBIndex != -1) {
								if (_cubeGetPlane[indexCube3] != null) {
									var planeRight:PlaneInfo = _comPlane[_cubeGetPlane[indexCube3]];
									var planeRightHeight:int = planeRight.height;	
									var planeLeftKey:String = plane.getIndex();
									//可以和右边合并
								    if (planeRightHeight == 1) { 
										plane.addWidth(planeRight.width);
										//遍历被合并的plane更改其中所有的cube的planeKey;
										for (var i:int = (cx + 1); i < (plane.width + cx + 1) ; i++ ) {
											var cubeKey:int = i * _sqrtMaxVertexCount + cy * _maxVertexCount + cz;
											_cubeGetPlane[cubeKey] = plane.getIndex();
										}
										//移除被合并的右边的plane
										_comPlane.removeAt(_comPlane.indexOf(planeRight));
									}
								}
							}	
						}
					//合并上下plane，如果有的话
					_comPlaneUpDown(plane,indexCube4, indexCube5, cz); 
				}
			}
			//right被选中
			else if (_cubeInfoIsPick[indexCube3] == true) {
				var cubeRight:CubeInfo = CubeInfoList[indexCube3];
				if (cubeRight.frontVBIndex != -1) {
					var planeRight:PlaneInfo = _cubeGetPlane[indexCube3];
					if (planeRight.height == 1) {
						//右边的plane合并到plane
						plane.width += planeRight.width;
						for (var i = cx; i < (cx + plane.width); i++) {
							var cubeKey:String = i * _sqrtMaxVertexCount + cy * _maxVertexCount + cz;
							_cubeGetPlane[cubeKey] = planeKey;
						}
					}	
				}
				//向上向下合并
				_comPlaneUpDown(plane,indexCube4, indexCube5, cz); 
			}
			else {	
				_comPlane[planeKey] = plane;
				_cubeGetPlane[indexCube] = planeKey;	
			}
			////down被选中
			//else if (_cubeInfoIsPick[indexCube5] == true) {
				//var cubeDown:CubeInfo = CubeInfoList[indexCube5];
				//if (cubeDown.front == true) {
					//var cubeDownKey:String = indexCube5;
					////查看当前的cube是否被合并了2018112更改逻辑 单个cube也构成planeinfo
					//var plane:PlaneInfo = new PlaneInfo;
					//var planeDown:PlaneInfo = _comPlane[cubeGetPlane[cubeDownKey]];
					//var planeDownWidth:int = planeDown.width;
					//if (planeDownWidth == 1) {
						//planeDown.addHeight(1);
						//cubeGetPlane[indexCube] = planeDown.getIndex();	
						//plane = planeDown;
					//}
					////无法合并到下边
					//else {
						//var planeNew:PlaneInfo = new PlaneInfo(cx, cy, 1, 1, cc);
						//var newPlaneKey:String = cubeDownKey;
						//_comPlane[newPlaneKey] = planeNew;
						//cubeGetPlane[cubeLeftKey] = newPlaneKey;	
						//plane = planeNew;
					//}
					////如果上边的存在
					//if (_cubeInfoIsPick[indexCube4] == true) {	
						//var cubeUp:CubeInfo = CubeInfoList[indexCube4];
						//if (cubeUp.front == true) {
							//if (cubeGetPlane[cubeUp.getKey] != null) {
								//var planeUp:PlaneInfo = _comPlane[cubeGetPlane[cubeUp.getKey]];
								//var planeUpHeight:int = planeUp.height;	
								//if (planeUpHeight == 1) {
									//plane.addHeight(planeUpHeight);
								//}
								////遍历被合并的plane更改其中所有的cube的planeKey;
								//for (var i:int = (cx + 1); i < (plane.width + cx + 1) ; i++ ) {
									//var cubeKey:String = i + "," + cy + "," + cz;
									//cubeGetPlane[cubeKey] = plane.getKey;
								//}
								////移除被合并的上边的plane
								//_comPlane.removeAt(_comPlane.indexOf(planeUp));
							//}
						//}	
					//}
				//}
			//}
			//else if (_cubeInfoIsPick[indexCube4] == true) {
				//var planeNew:PlaneInfo = new PlaneInfo(cx, cy, 1, 1, cc);
				//var newPlaneKey:String = planeNew.getKey;
				//_comPlane[newPlaneKey] = planeNew;
				//cubeGetPlane[cubeKey] = newPlaneKey;	
				//var cubeUp:CubeInfo = CubeInfoList[indexCube4];
				//if (cubeUp.front == true) {
					//if (cubeGetPlane[cubeUp.getKey] != null) {
						//var planeUp:PlaneInfo = _comPlane[cubeGetPlane[cubeUp.getKey]];
						//var planeUpHeight:int = planeUp.height;	
						//if (planeUpHeight == 1) {
							//planeNew.addHeight(planeUp.height);
						//}
						////遍历被合并的plane更改其中所有的cube的planeKey;
						//for (var i:int = (cx + 1); i < (planeNew.width + cx + 1) ; i++ ) {
							//var cubeKey:String = i + "," + cy + "," + cz;
							//cubeGetPlane[cubeKey] = newPlaneKey;
						//}
					//}
				//}	
			//}
			
		}

	}
	/**
	 * 
	 * @param	upIndex 拍成二维的上下左右
	 * @param	downIndex
	 * @param	leftIndex
	 * @param	rightIndex
	 * @param	ore 该二维面的朝向front back up down left right(012345)
	 */
	private function _comSixPlane(upIndex:int, downIndex:int, leftIndex:int, rightIndex:int, ore:int ):void {
		var cx:int = _cube.x;
		var cy:int = _cube.y;
		var cz:int = _cube.z;
		var cc:int = _cube.color;
		var p1:int = 0;
		var p2:int = 0;
		var p3:int = 0;
		switch(ore) {
			case 0:{
				p1 = cx;
				p2 = cy;
				p3 = cz + 1;
				break;
			}
			case 1:{
				p1 = cx;
				p2 = cy;
				p3 = cz;
				break;
			}
			case 2:{
				p1 = cz;
				p2 = cx;
				p3 = cy;
				break;
			}
			case 3:{
				p1 = cz;
				p2 = cx;
				p3 = cy + 1;
				break;
			}
			case 4:{
				p1 = cz;
				p2 = cy;
				p3 = cx;
				break;
			}
			case 5:{
				p1 = cz;
				p2 = cy;
				p3 = cx + 1;
				break;
			}
		}
			//plane 的分量需要根据ore进行控制   第三个 分量也需要 控制
			var plane:PlaneInfo = new PlaneInfo(p1, p2, 1, 1, cc);
			var planeKey:int = plane.getIndex();
			//left立方体是否被选中,不需要判断是否存在，选中必存在
			if (_cubeInfoIsPick[leftIndex] == true) {
				var cubeLeft:CubeInfo = CubeInfoList[leftIndex];
				if (_isVisable(cubeLeft, ore)) {
					//标记是否被合并
					var isCom:Boolean = false;
					//查看当前的cube是否被合并了2018112更改逻辑 单个cube也构成planeinfo
					var planeLeft:PlaneInfo = _comPlane[_cubeGetPlane[leftIndex]];
					var planeLeftHeight:int = planeLeft.height;
					if (planeLeftHeight == 1) {
						planeLeft.addWidth(1);
						_cubeGetPlane[leftIndex] = planeLeft.getIndex();	
						plane = planeLeft;
						isCom = true;
						}
					else {
						var newPlaneKey:int = plane.getIndex();
						_comPlane[newPlaneKey] = plane;
						_cubeGetPlane[indexCube] = newPlaneKey;	
						}
					//如果右边的存在
					if (_cubeInfoIsPick[rightIndex] == true) {	
						var cubeRight:CubeInfo = CubeInfoList[rightIndex];
						if (_isVisable(cubeRight, ore)) {
							if (_cubeGetPlane[rightIndex] != null) {
								var planeRight:PlaneInfo = _comPlane[_cubeGetPlane[rightIndex]];
								var planeRightHeight:int = planeRight.height;	
								var planeLeftKey:String = planeKey;
								//可以和右边合并
								if (planeRightHeight == 1) { 
									plane.addWidth(planeRight.width);
									//遍历被合并的plane更改其中所有的cube的planeKey;
									for (var i:int = (p1 + 1); i < (plane.width + p1) ; i++ ) {
										var cubeIndex:int = _getCubeIndex(i, p2, p3, ore);//i * sqrtMaxVertexCount + cy * _maxVertexCount + cz;
										_cubeGetPlane[cubeIndex] = planeKey;
									}
									//移除被合并的右边的plane
									_comPlane.removeAt(_comPlane.indexOf(planeRight));
								}
							}
						}	
					}
					//合并上下plane，如果有的话
					_comPlaneUpDown(plane,upIndex, downIndex, p3, ore); 
				}
			}
			//right被选中
			else if (_cubeInfoIsPick[rightIndex] == true) {
				var cubeRight:CubeInfo = CubeInfoList[rightIndex];
				if (_isVisable(cubeRight, ore)) {
					var planeRight:PlaneInfo = _cubeGetPlane[rightIndex];
					if (planeRight.height == 1) {
						//右边的plane合并到plane
						plane.width += planeRight.width;
						for (var i = p1; i < (p1 + plane.width); i++) {
							//var cubeKey:String = i * sqrtMaxVertexCount + cy * _maxVertexCount + cz;
							var cubeIndex:int = _getCubeIndex(i, p2, p3, ore);
							_cubeGetPlane[cubeIndex] = planeKey;
						}
					}	
				}
				//向上向下合并
				_comPlaneUpDown(plane,upIndex, downIndex, p3); 
			}
			else {	
				_comPlane[planeKey] = plane;
				_cubeGetPlane[indexCube] = planeKey;	
			}	
	}
	/**
	 * 判断立方体的面的可见性
	 * @param	cube
	 * @param	ore
	 * @return 
	 */
	private function _isVisable(cube:CubeInfo, ore:int):Boolean {
		var cube:CubeInfo = cube;
		var isVisable:Boolean = true;
		switch(ore) {
			case 0:{
					if (cube.frontVBIndex == -1) {
						isVisable = false;	
					}
					break;
				}
			case 1:{
					if (cube.backVBIndex == -1) {
						isVisable = false;	
					}
					break;
				}
			case 2: {
					if (cube.topVBIndex == -1) {
						isVisable = false;
					}
					break;
				}
			case 3: {
					if (cube.downVBIndex == -1) {
						isVisable = false;
					}
					break;
				}
			case 4: {
					if (cube.leftVBIndex == -1) {
						isVisable = false;
					}
					break;
				}
			case 5: {
					if (cube.rightVBIndex == -1) {
						isVisable = false;
					}
					break;
				}
		}
		return isVisable;
	}	
	
	private function _getCubeIndex(p1:int, p2:int, p3:int, ore:int):int {
		var index:int = 0;
		switch(ore) {
			case 0: {
					index = p1 * _sqrtMaxVertexCount + p2 * _maxVertexCount + p3-1;
					break;
				}
			case 1:{
					index = p1 * _sqrtMaxVertexCount + p2 * _maxVertexCount + p3;
					break;
				}
			case 2: {
					index = p2 * _sqrtMaxVertexCount + (p3-1) * _maxVertexCount + p1;
					break;
				}
			case 3: {
					index = p2 * _sqrtMaxVertexCount + p3 * _maxVertexCount + p1;
					break;
				}
			case 4: {
					index = p3 * _sqrtMaxVertexCount + p2 * _maxVertexCount + p1;
					break;
				}
			case 5: {
					index = (p3-1) * _sqrtMaxVertexCount + p2 * _maxVertexCount + p1;
					break;
				}
		}
		return index;
	}	
	
	
		
	
	private function _comPlaneUpDown(plane:PlaneInfo, upIndex:int, downIndex:int, p3:int, ore:int):void {	
		var isUpCanCom:Boolean = false;
		var isDownCanCom:Boolean = false;
		
		var planeKey:int = plane.getIndex();
		var planeUpKey:int = _cubeGetPlane[upIndex];
		var planeUp:PlaneInfo = _comPlane[planeUpKey];
		var planeDownKey:int = _cubeGetPlane[downIndex];
		var planeDown:PlaneInfo = _comPlane[planeDownKey];
		
		if (planeUp != null && planeUp.width == plane.width) {
			isUpCanCom = true;	
		}
		if (planeDown != null && planeDown.width == plane.width) {
			isDownCanCom = true;	
		}
		if (isUpCanCom) {
			plane.height += planeUp.height;
			//更新upPlane中所有的cube的planeKey;
			var upStartX:int = planeUp.p1;
			var upStartY:int = planeUp.p2;
			for (var y:int = upStartY; y < (upStartY + planeUp.height); y++ ) {
				for (var x:int = upStartX; x < (upStartX + planeUp.width); x++ ) {
					var cubeIndex:int = _getCubeIndex(x, y, p3, ore);
					_cubeGetPlane[cubeIndex] = planeKey;
				}
			}
			//移除当前upPlane
			_comPlane.removeAt(_comPlane.indexOf(planeUp));
		}
							
		//向下合并
		if (isDownCanCom) {
			planeDown.height += plane.height;
			//更新plane中所有的cube的planeKey;
			var planeStartX:int = plane.p1;
			var planeStartY:int = plane.p2;
			for (var y:int = planeStartY; y < (planeStartY + plane.height); y++ ) {
				for (var x:int = planeStartX; x < (planeStartX + plane.width); x++ ) {
					var cubeIndex:int = _getCubeIndex(x, y, p3, ore);
					_cubeGetPlane[cubeIndex] = planeDownKey;
				}
			}
			//移除当前plane
			_comPlane.removeAt(_comPlane.indexOf(plane));
		}	
		
	}
	
	}

}