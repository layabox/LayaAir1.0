package laya.d3Extend.Cube 
{
	import laya.d3Extend.Cube.PlaneInfo;
	import laya.d3Extend.Cube.CompressPlane;
	import laya.d3Extend.Cube.CompressPlaneVector;
	import laya.d3Extend.Cube.CubeInfo;
	
	/**
	 * ...
	 * @author 
	 */
	public class CompressCube 
	{
		//用这个队列来管理所有CubeInfo
		private var _CubeInfoList:Vector.<CubeInfo> = new Vector.<CubeInfo>();
		
		public function CompressCube(CubeInfoList:Vector.<CubeInfo>) 
		{
			//_data = CubeInfoList;
			_CubeInfoList = CubeInfoList;
		}
		
		public function comPressByAxis():Vector.<CompressPlaneVector> {
			//先按照32*32*32分割一下
			var vecCubeSlice32:Vector.<Vector.<CubeInfo>> = new Vector.<Vector.<CubeInfo>>;
			for (var c in _CubeInfoList) {
				var cube:CubeInfo = _CubeInfoList[c];
				var key:String = _sliceXYZBy32(cube.x, cube.y, cube.z);
				if(vecCubeSlice32[key] == null){
					vecCubeSlice32[key] = new Vector.<CubeInfo>;
				}
				vecCubeSlice32[key].push(cube);	
			}
			var z1:CompressPlaneVector = new CompressPlaneVector;
			var y1:CompressPlaneVector = new CompressPlaneVector;
			var x1:CompressPlaneVector = new CompressPlaneVector;
			var z0:CompressPlaneVector = new CompressPlaneVector;
			var y0:CompressPlaneVector = new CompressPlaneVector;
			var x0:CompressPlaneVector = new CompressPlaneVector;
			
			for (var cube32 in vecCubeSlice32) {
				var vecCubeList32:Vector.<CubeInfo> = vecCubeSlice32[cube32];
				
				var CubeInfoListByZAxis:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
				var CubeInfoListByYAxis:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
			    var CubeInfoListByXAxis:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
				
				for (var cubeindex in vecCubeList32) {
				var cubeInfo:CubeInfo = _CubeInfoList[cubeindex] as CubeInfo;
				var x:int = cubeInfo.x;
				var y:int = cubeInfo.y;
				var z:int = cubeInfo.z;
				if (CubeInfoListByZAxis[z] == null) {
					var vecCubeZ:Vector.<CubeInfo> = new Vector.<CubeInfo>;
					CubeInfoListByZAxis[z] = vecCubeZ;
				}
				if (CubeInfoListByYAxis[y] == null) {
					var vecCubeY:Vector.<CubeInfo> = new Vector.<CubeInfo>;
					CubeInfoListByYAxis[y] = vecCubeY;
				}
				if (CubeInfoListByXAxis[x] == null) {
					var vecCubeX:Vector.<CubeInfo> = new Vector.<CubeInfo>;
					CubeInfoListByXAxis[x] = vecCubeX;
				}
				CubeInfoListByZAxis[z].push(cubeInfo);
				CubeInfoListByYAxis[y].push(cubeInfo);
				CubeInfoListByXAxis[x].push(cubeInfo);	
			}
			
			_combineByZAxis(CubeInfoListByZAxis, false, z1);
			_combineByYAxis(CubeInfoListByYAxis, false, y1);
			_combineByXAxis(CubeInfoListByXAxis, false, x1);
			_combineByZAxis(CubeInfoListByZAxis, true, z0);
			_combineByYAxis(CubeInfoListByYAxis, true, y0);
			_combineByXAxis(CubeInfoListByXAxis, true, x0);
				
		}
			//var CubeInfoListByZAxis:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
			//var CubeInfoListByYAxis:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
			//var CubeInfoListByXAxis:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
			////不需要sort sort会导致崩溃
			////CubeInfoList.sort();
			//for (cubeindex in _CubeInfoList) {
				//var cubeInfo:CubeInfo = _CubeInfoList[cubeindex] as CubeInfo;
				//var x:int = cubeInfo.x;
				//var y:int = cubeInfo.y;
				//var z:int = cubeInfo.z;
				//if (CubeInfoListByZAxis[z] == null) {
					//var vecCubeZ:Vector.<CubeInfo> = new Vector.<CubeInfo>;
					//CubeInfoListByZAxis[z] = vecCubeZ;
				//}
				//if (CubeInfoListByYAxis[y] == null) {
					//var vecCubeY:Vector.<CubeInfo> = new Vector.<CubeInfo>;
					//CubeInfoListByYAxis[y] = vecCubeY;
				//}
				//if (CubeInfoListByXAxis[x] == null) {
					//var vecCubeX:Vector.<CubeInfo> = new Vector.<CubeInfo>;
					//CubeInfoListByXAxis[x] = vecCubeX;
				//}
				//CubeInfoListByZAxis[z].push(cubeInfo);
				//CubeInfoListByYAxis[y].push(cubeInfo);
				//CubeInfoListByXAxis[x].push(cubeInfo);	
			//}
			////最终结果
			//var vecCompressPlaneVector:Vector.<CompressPlaneVector> = new Vector.<CompressPlaneVector>
			//var z1:CompressPlaneVector = _combineByZAxis(CubeInfoListByZAxis, false);
			//var y1:CompressPlaneVector = _combineByYAxis(CubeInfoListByYAxis, false);
			//var x1:CompressPlaneVector = _combineByXAxis(CubeInfoListByXAxis, false);
			//var z0:CompressPlaneVector = _combineByZAxis(CubeInfoListByZAxis, true);
			//var y0:CompressPlaneVector = _combineByYAxis(CubeInfoListByYAxis, true);
			//var x0:CompressPlaneVector = _combineByXAxis(CubeInfoListByXAxis, true);
			
			//最终结果
			var vecCompressPlaneVector:Vector.<CompressPlaneVector> = new Vector.<CompressPlaneVector>
			vecCompressPlaneVector.push(z1);
			vecCompressPlaneVector.push(z0);
			vecCompressPlaneVector.push(y1);
			vecCompressPlaneVector.push(y0);
			vecCompressPlaneVector.push(x1);
			vecCompressPlaneVector.push(x0);
			return vecCompressPlaneVector;
		}
		
		/**
		 * 
		 * @param	vec
		 * @param	orientation:frontVBIndex,up,leght为true,back,down,right为false.
		 */
		private function _combineByZAxis( vec:Vector.<Vector.<CubeInfo> > , orientation:Boolean, zResult:CompressPlaneVector) :void{
			
			//建立一个映射的map
			var keyMap:Vector.<String> = new Vector.<String>;
			//存储整理好的结果
			var zCompressPlaneVector:CompressPlaneVector = zResult;
			for (var vecZindex in vec) {
				//最终处理的Z值
				var lastZ:int = parseInt(vecZindex);
				if (orientation) {
					lastZ += 1;
				}
				//每一次沿着z轴取一个面
				var vecOneZ:Vector.<CubeInfo> = vec[vecZindex];
				vecOneZ.sort();
				var countOneZ:int = vecOneZ.length;
				var vecOneZbyY:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
				
				//将cube按照y分配到数组之中
				for (var i = 0; i < countOneZ; i++ ) {
					var cube:CubeInfo = vecOneZ[i];
					var cy:int = cube.y;
					//正面不可见,直接返回
					if (orientation) {
						zCompressPlaneVector.face = 0;
						if (cube.frontVBIndex == -1) {
							continue;
						}
					}
					else {
						zCompressPlaneVector.face = 1;
						if (cube.backVBIndex == -1) {
							continue;
						}
					}
						
					if (vecOneZbyY[cy] == null) {
						var vecCubeY:Vector.<CubeInfo> = new Vector.<CubeInfo>;
						vecOneZbyY[cy] = vecCubeY;
					}
					vecOneZbyY[cy].push(cube);
				}
				
				//合并一行(y)
				var planeByY:Vector.<Vector.<PlaneInfo> > = new Vector.<Vector.<PlaneInfo> >;
				var yCount:int = 0;
				for (var yIndex in vecOneZbyY) {
					var cubeOneLine:Vector.<CubeInfo> = vecOneZbyY[yIndex];
					//根据x值进行排序
					cubeOneLine.sort(_sortCubeByX);
					//存储一行之后合并之后的色块
					var planeLine:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
					var plane:PlaneInfo = new PlaneInfo(0, 0, 0, 0, 0);
					for (var cubeIndex in cubeOneLine) {
						var cubeX:CubeInfo = cubeOneLine[cubeIndex];
						var cx:int = cubeX.x;
						var cy:int = cubeX.y;
						var cColorIndex:int = cubeX.color;
						if (plane.width == 0) {//这个PlaneInfo是新的	
							plane.setValue(cx, cy, 1, 1, cColorIndex);	
							planeLine.push(plane);
						}
						else {
							if ((plane.p1 + plane.width) == cx && plane.colorIndex == cColorIndex) {
								//合并
								plane.addWidth(1);
							}
							else {
								//合并好的存储起来
								var planeCom:PlaneInfo = new PlaneInfo(plane.p1, plane.p2, plane.width, plane.height, plane.colorIndex);
								planeLine.push(planeCom);
								//重置plane
								plane.setValue(cx, cy, 1, 1, cColorIndex);	
							}
						}
					}
					planeByY[yCount++] = planeLine;
				}
				//planeByY.sort();
				//合并已经整理好的每一行
				var comLine:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;//存储合并后plane数组
				var planeLine:Vector.<PlaneInfo> = null;
				var planeNextLine:Vector.<PlaneInfo>;
				for (var lineYIndex in planeByY) {
					planeNextLine = planeByY[lineYIndex];
					if (planeLine == null) {
						planeLine = planeNextLine;
						//如果当前数组中只有一个PlaneInfo
						if (planeByY.length == 1) {
							for (var planeindex in planeLine) {
								var tmpPlane:PlaneInfo = planeLine[planeindex];
								zCompressPlaneVector.addPlaneInfo(lastZ, tmpPlane);
							}	
						}
						continue;
					}
					else {
						for (var planeIndex1 in planeLine) {
							var plane1:PlaneInfo = planeLine[planeIndex1];
							var p1x:int = plane1.p1;
							var p1y:int = plane1.p2;
							var p1w:int = plane1.width;
							var p1h:int = plane1.height;
							var p1c:int = plane1.colorIndex;
							
							for (var planeIndex2 in planeNextLine) {
								var plane2:PlaneInfo = planeNextLine[planeIndex2];
								var p2x:int = plane2.p1;
								var p2y:int = plane2.p2;
								var p2w:int = plane2.width;
								var p2h:int = plane2.height;
								var p2c:int = plane2.colorIndex;
								//如果第二行的当前块的坐标已经大于待比较的块的坐标，那么第二行之后的块就无需在和待比较的块进行比较
								if (p2x > p1x) {
									break;
								}
								//按照开始坐标，宽度，颜色进行比较
								if (p1x != p2x || ( p1y + 1) != p2y || p1w != p2w || p1c != p2c) {
									continue;
								}
								else {
									var keyPlane:String = p1x + "," + p1y;
									//上一行的已经加入到合并数组comLine之中
									if (plane1.isCover) {
										var keyPlane:String = p1x + "," + p1y;
										var keyCom:String = keyMap[keyPlane];
										comLine[keyCom].addHeight(1);
										plane2.isCover = true;
										//建立key值的映射
										var keyPlane2:String = p2x + "," + p2y;
										keyMap[keyPlane2] = keyCom;
										//后面的不会再和plane1匹配了
										break;
									}
									else {
										plane1.isCover = true;
										plane2.isCover = true;
										var newComPlane:PlaneInfo = new PlaneInfo(p1x, p1y, p2w, p1h + p2h, p2c);
										//将该合并的plane加入到comLine中
										comLine[keyPlane] = newComPlane;
										//建立key值的映射
										keyMap[keyPlane] = keyPlane;
										var keyPlane2:String = p2x + "," + p2y;
										keyMap[keyPlane2] = keyPlane;
										//后面的不会再和plane1匹配了
										break;
									}
								}
							}
							//如果转了一圈循环，自己没有被合并那就孤零零进入最终的结果吧
							if (!plane1.isCover) {
								zCompressPlaneVector.addPlaneInfo(lastZ,plane1);
							}
						}
						//如果转了一大圈planeNextLine的plane没有被选中则需要单独处理
						for (var planeNextIndex in planeNextLine) {
							var planeNext:PlaneInfo = planeNextLine[planeNextIndex]; 
							if (!planeNext.isCover) {
								zCompressPlaneVector.addPlaneInfo(lastZ,planeNext);
							}
						}
						planeLine = planeNextLine;
						
					}
					
				}
				//遍历合并的plane
				for (var comPlane in comLine) {
					var planeInfo:PlaneInfo = comLine[comPlane];
					//放置到最终结果中
					zCompressPlaneVector.addPlaneInfo(lastZ,planeInfo);
				}	
			}
			//return zCompressPlaneVector;

		}
		/**
		 * @param	vec
		 * @param	orientation:up为true,down为false.
		 */
		private function _combineByYAxis( vec:Vector.<Vector.<CubeInfo> > , orientation:Boolean, yResult:CompressPlaneVector):void {
			//建立一个映射的map
			var keyMap:Vector.<String> = new Vector.<String>;
			var yCompressPlaneVector:CompressPlaneVector = yResult;
			for (var vecYindex in vec) {
				var lastY:int = parseInt(vecYindex);
				if (orientation) {
					lastY += 1;
				}
				//每一次沿着Y轴取一个面
				var vecOneY:Vector.<CubeInfo> = vec[vecYindex];
				vecOneY.sort();
				
				//将cube按照X分配到数组之中
				var vecOneYbyX:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
				var countOneY:int = vecOneY.length;
				for (var i = 0; i < countOneY; i++ ) {
					var cube:CubeInfo = vecOneY[i];
					var cx:int = cube.x;
					//正面不可见,直接返回
					if (orientation) {
						yCompressPlaneVector.face = 2;
						if (cube.topVBIndex == -1) {
							continue;
						}
					}
					else {
						yCompressPlaneVector.face = 3;
						if (cube.downVBIndex == -1) {
							continue;
						}
					}
					if (vecOneYbyX[cx] == null) {
						var vecCubeX:Vector.<CubeInfo> = new Vector.<CubeInfo>;
						vecOneYbyX[cx] = vecCubeX;
					}
					vecOneYbyX[cx].push(cube);
				}
				
				//合并一行(y)
				var planeByX:Vector.<Vector.<PlaneInfo> > = new Vector.<Vector.<PlaneInfo> >;
				var xCount:int = 0;
				for (var xIndex in vecOneYbyX) {
					//取出一行
					var cubeOneLine:Vector.<CubeInfo> = vecOneYbyX[xIndex];
					//根据z值进行排序
					cubeOneLine.sort(_sortCubeByZ);
					//存储一行之后合并之后的色块
					var planeLine:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
					var plane:PlaneInfo = new PlaneInfo(0, 0, 0, 0, 0);
					for (var cubeIndex in cubeOneLine) {
						var cubeX:CubeInfo = cubeOneLine[cubeIndex];
						var x:int = cubeX.x;
						var z:int = cubeX.z;
						var cColorIndex:int = cubeX.color;
						if (plane.width == 0) {//这个PlaneInfo是新的	
							plane.setValue(x, z, 1, 1, cColorIndex);	
							planeLine.push(plane);
						}
						else {
							if ((plane.p2 + plane.width) == cubeX.z && plane.colorIndex == cColorIndex) {
								plane.addWidth(1);
							}
							else {
								//合并好的存储起来
								var planeCom:PlaneInfo = new PlaneInfo(plane.p1, plane.p2, plane.width, plane.height, plane.colorIndex);
								planeLine.push(planeCom);
								//重置plane
								plane.setValue(x, z, 1, 1, cColorIndex);	
							}
						}
					}	
					planeByX[xCount++] = planeLine;
				}
				
				//合并已经整理好的行
				var comLine:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
				var planeLine:Vector.<PlaneInfo> = null;
				var planeNextLine:Vector.<PlaneInfo>;
				for (var lineXIndex in planeByX) {
					planeNextLine = planeByX[lineXIndex];
					if (planeLine == null) {
						planeLine = planeNextLine;
						//如果当前数组中只有一个PlaneInfo
						if (planeByX.length == 1) {
							for (var planeindex in planeLine) {
								var tmpPlane:PlaneInfo = planeLine[planeindex];
								yCompressPlaneVector.addPlaneInfo(lastY, tmpPlane);
							}	
						}
						continue;
					}
					else {
						for (var planeIndeZ1 in planeLine) {
							var plane1:PlaneInfo = planeLine[planeIndeZ1];
							var p1x:int = plane1.p1;
							var p1z:int = plane1.p2;
							var p1w:int = plane1.width;
							var p1h:int = plane1.height;
							var p1c:int = plane1.colorIndex;
							
							for (var planeIndeZ2 in planeNextLine) {
								var plane2:PlaneInfo = planeNextLine[planeIndeZ2];
								var p2x:int = plane2.p1;
								var p2z:int = plane2.p2;
								var p2w:int = plane2.width;
								var p2h:int = plane2.height;
								var p2c:int = plane2.colorIndex;
								//如果第二行的当前块的坐标已经大于待比较的块的坐标，那么第二行之后的块就无需在和待比较的块进行比较
								if (p2z > p1z) {
									break;
								}
								if (p1z != p2z ||( p1x+1) != p2x || p1w != p2w || p1c != p2c) {
									continue;
								}
								else {
									var keyPlane:String = p1x + "," + p1z;
									//上一行的已经加入到合并数组comLine之中
									if (plane1.isCover) {
										var keyCom:String = keyMap[keyPlane];
										comLine[keyCom].addHeight(1);
										plane2.isCover = true;
										var keyPlane2:String = p2x + "," + p2z;
										keyMap[keyPlane2] = keyCom;
										//后面的不会再和plane1匹配了
										break;
									}
									else {
										plane1.isCover = true;
										plane2.isCover = true;
										var newComPlane:PlaneInfo = new PlaneInfo(p1x, p1z, p2w, p1h + p2h, p2c);
										//将该合并的plane加入到comLine中
										comLine[keyPlane] = newComPlane;
										//建立key值的映射
										keyMap[keyPlane] = keyPlane;
										var keyPlane2:String = p2x + "," + p2z;
										keyMap[keyPlane2] = keyPlane;
										//后面的不会再和plane1匹配了
										break;
									}
								}
							}
							//如果转了一圈循环，自己没有被合并那就孤零零进入最终的结果吧
							if (!plane1.isCover) {
								yCompressPlaneVector.addPlaneInfo(lastY,plane1);
							}	
						}
						//如果转了一大圈planeNextLine的plane没有被选中则需要单独处理
						for (var planeNextIndex in planeNextLine) {
							var planeNext:PlaneInfo = planeNextLine[planeNextIndex]; 
							if (!planeNext.isCover) {
								yCompressPlaneVector.addPlaneInfo(lastY,planeNext);
							}
						}
						planeLine = planeNextLine;	
					}
				}

				for (var comPlane in comLine) {
					//如果是背面y坐标需要减去1
					var planeInfo:PlaneInfo = comLine[comPlane];
					yCompressPlaneVector.addPlaneInfo(lastY,planeInfo);
				}	
			}
			//return yCompressPlaneVector;
		}
			
		/**
		 * @param	vec
		 * @param	orientation:left为true,right为false.
		 */	
		private function _combineByXAxis( vec:Vector.<Vector.<CubeInfo> > , orientation:Boolean, xResult:CompressPlaneVector):void {
			//建立一个映射的map
			var keyMap:Vector.<String> = new Vector.<String>;
			var xCompressPlaneVector:CompressPlaneVector = xResult;
			for (var vecXindex in vec) {
				var lastX:int = parseInt(vecXindex);
				if (!orientation) {
					lastX += 1;
				}
				//每一次沿着X轴取一个面
				var vecOneX:Vector.<CubeInfo> = vec[vecXindex];
				vecOneX.sort();
					
				//将cube按照Y分配到数组之中
				var vecOneXbyY:Vector.<Vector.<CubeInfo> > = new Vector.<Vector.<CubeInfo> >;
				var countOneX:int = vecOneX.length;
				for (var i = 0; i < countOneX; i++ ) {
					var cube:CubeInfo = vecOneX[i];
					var cy:int = cube.y;
					//正面不可见,直接返回
					if (orientation) {
						xCompressPlaneVector.face = 4;
						if (cube.rightVBIndex == -1) {
							continue;
						}
					}
					else {
						xCompressPlaneVector.face = 5;
						if (cube.leftVBIndex == -1) {
							continue;
						}
					}
					if (vecOneXbyY[cy] == null) {
						var vecCubeY:Vector.<CubeInfo> = new Vector.<CubeInfo>;
						vecOneXbyY[cy] = vecCubeY;
					}
					vecOneXbyY[cy].push(cube);
				}
				
				//合并一行(y)
				var planeByY:Vector.<Vector.<PlaneInfo> > = new Vector.<Vector.<PlaneInfo> >;
				var yCount:int = 0;
				for (var yIndex in vecOneXbyY) {
					var cubeOneLine:Vector.<CubeInfo> = vecOneXbyY[yIndex];
					//根据Z值进行排序
					cubeOneLine.sort(_sortCubeByZ);
					
					//存储一行之后合并之后的色块
					var planeLine:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
					var plane:PlaneInfo = new PlaneInfo(0, 0, 0, 0, 0);
					for (var cubeIndex in cubeOneLine) {
						var cubeX:CubeInfo = cubeOneLine[cubeIndex];
						var cy:int = cubeX.y;
						var cz:int = cubeX.z;
						var cColorIndex = cubeX.color;
						if (plane.width == 0) {//这个PlaneInfo是新的	
							plane.setValue(cy, cz, 1, 1, cColorIndex);	
							planeLine.push(plane);
						}
						else {
							if ((plane.p2 + plane.width) == cz && plane.colorIndex == cColorIndex) {
								plane.addWidth(1);	
							}
							else {
								//合并好的存储起来
								var planeCom:PlaneInfo = new PlaneInfo(plane.p1, plane.p2, plane.width, plane.height, plane.colorIndex);
								planeLine.push(planeCom);
								//重置plane
								plane.setValue(cy, cz, 1, 1, cColorIndex);	
							}
						}
					}
					
					planeByY[yCount++] = planeLine;
				}
				
				//合并已经整理好的行
				var comLine:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
				var planeLine:Vector.<PlaneInfo> = null;
				var planeNextLine:Vector.<PlaneInfo>;
				for (var lineYIndex in planeByY) {
					planeNextLine = planeByY[lineYIndex];
					if (planeLine == null) {
						planeLine = planeNextLine;
						//如果当前数组中只有一个PlaneInfo
						if (planeByY.length == 1) {
							for (var planeindez in planeLine) {
								var tmpPlane:PlaneInfo = planeLine[planeindez];
								xCompressPlaneVector.addPlaneInfo(lastX, tmpPlane);
							}	
						}
						continue;
					}
					else {
						for (var planeIndeZ1 in planeLine) {
							var plane1:PlaneInfo = planeLine[planeIndeZ1];
							var p1y:int = plane1.p1;
							var p1z:int = plane1.p2;
							var p1w:int = plane1.width;
							var p1h:int = plane1.height;
							var p1c:int = plane1.colorIndex;
							for (var planeIndeZ2 in planeNextLine) {
								var plane2:PlaneInfo = planeNextLine[planeIndeZ2];
								var p2y:int = plane2.p1;
								var p2z:int = plane2.p2;
								var p2w:int = plane2.width;
								var p2h:int = plane2.height;
								var p2c:int = plane2.colorIndex;
								if (p1z != p2z ||( p1y+1) != p2y || p1w != p2w || p1c != p2c) {
									continue;
								}
								else {
									var keyPlane:String = p1y + "," + p1z;
									//上一行的已经加入到合并数组comLine之中
									if (plane1.isCover) {
										var keyCom:String = keyMap[keyPlane];
										comLine[keyCom].addHeight(1);
										plane2.isCover = true;
										var keyPlane2:String = p2y + "," + p2z;
										keyMap[keyPlane2] = keyCom;
										//后面的不会再和plane1匹配
										break;
									}
									else {
										plane1.isCover = true;
										plane2.isCover = true;
										var newComPlane:PlaneInfo = new PlaneInfo(p1y, p1z, p2w, p1h + p2h, p2c);
										//将该合并的plane加入到comLine中
										comLine[keyPlane] = newComPlane;
										//建立key值的映射
										keyMap[keyPlane] = keyPlane;
										var keyPlane2:String = p2y + "," + p2z;
										keyMap[keyPlane2] = keyPlane;
										//后面的不会再和plane1匹配了
										break;
									}
								}
							}
							//如果转了一圈循环，自己没有被合并那就孤零零进入最终的结果吧
							if (!plane1.isCover) {
								xCompressPlaneVector.addPlaneInfo(lastX,plane1);
							}
						}
						//如果转了一大圈planeNextLine的plane没有被选中则需要单独处理
						for (var planeNextIndex in planeNextLine) {
							var planeNext:PlaneInfo = planeNextLine[planeNextIndex]; 
							if (!planeNext.isCover) {
								xCompressPlaneVector.addPlaneInfo(lastX,planeNext);
							}
						}
					}
					
				}
				for (var comPlane in comLine) {
					var planeInfo:PlaneInfo = comLine[comPlane];
					//如果是背面X坐标需要加1
					xCompressPlaneVector.addPlaneInfo(lastX,planeInfo);
				}	
			}
			//return xCompressPlaneVector; 
		}
		
		private function _sortCubeByX(c1:CubeInfo, c2:CubeInfo):Number {
			var i:int = 0;
			(c1.z > c2.z) && (i = 1);
			(c1.z < c2.z) && (i = -1);
			return i;
		}
		
		private function _sortCubeByY(c1:CubeInfo, c2:CubeInfo):Number {
			var i:int = 0;
			(c1.y > c2.y) && (i = 1);
			(c1.y < c2.y) && (i = -1);
			return i;
		}
		
		private function _sortCubeByZ(c1:CubeInfo, c2:CubeInfo):Number {
			var i:int = 0;
			(c1.z > c2.z) && (i = 1);
			(c1.z < c2.z) && (i = -1);
			return i;
		}
		
		private function _sliceXYZBy32(x:int, y:int, z:int):String {
			var resultx:int = 0;
			var resulty:int = 0;
			var resultz:int = 0;
			if (x < 0) {
				x = -x;
				resultx = x >> 5;
				resultx = -resultx;
			}
			else {
				resultx = x >> 5;
			}
			if (y < 0) {
				y = -y;
				resulty = y >> 5;
				resulty = -resulty;
			}
			else {
				resulty = y >> 5;
			}
			if (z < 0) {
				z = -z;
				resultz = z >> 5;
				resultz = -resultz;
			}
			else {
				resultz = z >> 5;
			}
			
			var result:String =resultx + "," + resulty + "," + resultz;
			return result;	
		}
		
	}

}