package laya.d3Extend.worldMaker {
	import laya.d3.core.Camera;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.physics.HitResult;
	import laya.display.Graphics;
	import laya.events.Event;
	import laya.events.Keyboard;
	
	/**
	 * 可以从通用sprite3d编辑器派生，额外提供simpleshapeFilter的编辑功能
	 * 先直接假设编辑的就是mesh
	 */
	public class SimpleShapeEditor {
		private static var tmpMat:Matrix4x4 = new Matrix4x4();	// 为了提高效率
		private static var tmpVec3:Vector3 = new Vector3();
		private static var tmpVec31:Vector3 = new Vector3();
		private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
		
		public var target:SimpleShapeSprite3D = null;	// 要编辑的对象
		private var editMode:Boolean = true;			// 编辑模式
		private var ctrl:Boolean = false;
		public var worldEditor:Editor_3dController;		// 提供一些通用方法。例如摄像机相关的 localToScreen
		private var mat_World:Matrix4x4 = null; 			// 对象本身的矩阵
		private var mat_InvWorld:Matrix4x4 = new Matrix4x4(); 	// 世界矩阵的逆
		private var mat_WVP:Matrix4x4 = new Matrix4x4();	// 选中对象之后，立即计算这个矩阵。
		
		public var camera:Camera = null;				// TODO 这里不允许有这个
		private var point:Vector2 = new Vector2();

		//2d data
		public var crossDataOnScr:Array = [];			// 原始数据投影到屏幕上的位置。
		public var crossDataOnScrZ:Array = [];			// 每个点对应的z值。
		public var crossCtrlOnScr:Array = [];
		public var crossCtrlOnScrZ:Array = [];
		
		public var profileLineDataOnScr:Array = [];		//
		public var profileLineDataOnScrZ:Array = [];
		public var profileCtrlOnScr:Array = [];
		public var profileCtrlOnScrZ:Array = [];
		
		private var pickResult:Pick2DResult = new Pick2DResult();
		private var pickEdgeResult:Pick2DEdgeResult = new Pick2DEdgeResult();
		
		private var interpNum:int = 0;
		
		// 本地空间的特殊平面。 注意值是用来索引的，所以不要乱改
		private static var LOCAL_YZ:int = 0;	//x轴是法线
		private static var LOCAL_XZ:int = 4;
		private static var LOCAL_XY:int = 8;
		
		// UNDO
		//private var UndoStack:Vector.<IUndo> = new Vector.<IUndo>();
		private static var UndoStackLen:int = 100;
		private var undoStack:Array = new Array(0);
		private var undoPos:int = 0;				// 当前undo可以开始的地方，通常是数组结尾，一旦undo了就离开了结尾，从 undoPos到结尾是可以redo的地方
		
		private var dataBeforeEdit:Object = { };	// 整体undo用
		private var dataChanged:Boolean = false; 	//编辑器是否对数据进行过修改。
		private var continueChangeSavedData:Array;	// 拖动前保存的cross或者profile数据
		private var dataChangedAfterStart:Boolean = false;		//按下鼠标后实际修改数据了
		private var curEditProp:String;				// 正在修改的属性
		// UNDO END
		
		public static function canEditObject():String {
			return "SimpleShapeSprite3D";
		}
		
		public function SimpleShapeEditor(obj:SimpleShapeSprite3D, cam:Camera) {
			target = obj;
			camera = cam;
			updateData();
		}
		
		public function  updateData():void {
			var mesh:SimpleShapeFilter = target._simpleShapeMesh;
			//计算转换矩阵
			var wmat:Matrix4x4 = mat_World = target._transform.worldMatrix;
			Matrix4x4.multiply( camera.viewMatrix, wmat, tmpMat);
			Matrix4x4.multiply( camera.projectionMatrix, tmpMat, mat_WVP);
			wmat.invert(mat_InvWorld);
			
			crossCtrlOnScr.length =crossDataOnScr.length = mesh.crossSectionData.length*2;
			crossCtrlOnScrZ.length = crossDataOnScrZ.length = crossDataOnScr.length ;
			
			profileCtrlOnScr.length = profileLineDataOnScr.length = mesh.profileLineData.length*2;
			profileLineDataOnScrZ.length = profileLineDataOnScrZ.length = profileLineDataOnScr.length;
		}
		
		/**
		 * 进入编辑模式，开始编辑mesh
		 */
		public function enterEditMode():void {
			
		}
		
		/**
		 * 持续性操作开始,下面可能是拖动数据，也可能会什么都不干（1 确实什么都不干 2 其他操作的前导 ）
		 * @param	propName
		 */
		/*public function undo_op_continueChange_start(propName:String):void {
			if (undoOp.opName != propName) {
				//记录原始值
				
			}
		}
		*/
		
		// 立即操作
		public function  undo_op_changeInterp(bef:int, after:int):void {
			undo_pushUndoData(
				{
					target:this.target._simpleShapeMesh,
					undo:function ():void {
						this.target.crossSectionInterpNum = bef;
						this.target.profileLineInterpNum = bef;
					},
					redo:function ():void {
						this.target.crossSectionInterpNum = after;
						this.target.profileLineInterpNum = after;
					}
				}			
			);
		}
		
		public function undo_op_changeStyle(bef:Boolean, after:Boolean):void {
			undo_pushUndoData(
				{
					target:this.target._simpleShapeMesh,
					undo:function ():void {
						this.target.polygonStyle = bef;
					},
					redo:function ():void {
						this.target.polygonStyle = after;
					}
				}			
			);
		}
		
		public function copyHandlePointArray(dt:Vector.<HandlePoint>):Vector.<HandlePoint> {
			var ret:Vector.<HandlePoint> = dt.concat();
			ret.forEach(function(v:HandlePoint, i:int):void { 
				ret[i] = new HandlePoint(v.x, v.y, v.ctrlx, v.ctrly);
			} );
			return ret;
		}
		
		public function undo_startCrossData():void {
			curEditProp = "crossSectionData";
			dataChangedAfterStart = false;
			continueChangeSavedData = copyHandlePointArray(target._simpleShapeMesh.crossSectionData) as Array;
		}
		
		public function undo_startProfileData():void {
			curEditProp = "profileLineData";
			dataChangedAfterStart = false;
			continueChangeSavedData = copyHandlePointArray(target._simpleShapeMesh.profileLineData) as Array;
		}
		
		public function undo_drage_changeData():void {
			dataChangedAfterStart = true;
		}
		
		public function undo_op_end():void {
			if (dataChangedAfterStart) {
				var newv:Array = null;
				switch(curEditProp) {
				case 	'crossSectionData':
					newv = copyHandlePointArray(target._simpleShapeMesh.crossSectionData) as Array;
					break;
				case 'profileLineData':
					newv = copyHandlePointArray(target._simpleShapeMesh.profileLineData) as Array;
					break;
				default:
					throw "err158";
					break;
				}
				
				undo_pushUndoData({
					target:this.target._simpleShapeMesh,
					oldv:this.continueChangeSavedData,
					newv:newv,
					prop:curEditProp,
					undo:function ():void {
						this.target[this.prop] = this.oldv;
					},
					redo:function ():void {
						this.target[this.prop] = this.newv;
					}
				});
			}
			curEditProp = "";
			dataChangedAfterStart = false;
		}

		/**
		 * 当前位置就是数据的最终位置？
		 * @param	undoObj
		 */
		public function undo_pushUndoData(undoObj:Object):void {
			if (undoPos < undoStack.length){
				undoStack[undoPos++] = undoObj;
				undoStack.length = undoPos;	//裁掉后面的数据
			}
			else {
				undoStack.push(undoObj);
			}
			
			if (undoStack.length > UndoStackLen) {
				undoStack.shift();
			}
			
			undoPos = undoStack.length;
		}

		public function undo():void {
			undoPos--;
			if (undoPos < 0) {
				undoPos = 0;
				return;
			}
			var ud:Object = undoStack[undoPos];
			ud && ud.undo.call(ud);
			target._simpleShapeMesh.onDataChanged();
			updateData();	// 更新二维数据
		}
		
		public function redo():void {
			if (undoPos >= undoStack.length)
				return;
			var ud:Object = undoStack[undoPos++];
			ud && ud.redo.call(ud);
			target._simpleShapeMesh.onDataChanged();
			updateData(); //更新二维数据
		}
				
		public function onSelect():void {
			var mesh:SimpleShapeFilter = target._simpleShapeMesh;
			dataBeforeEdit.crossSectionData = copyHandlePointArray(mesh.crossSectionData) as Array;
			dataBeforeEdit.profileLineData = copyHandlePointArray(mesh.profileLineData) as Array;
		}
		
		public function onUnselect():void {
			if (dataChanged) {
				//如果有变动，需要加undo
				//worldEditor.puashUndo(dataBeforeEdit)
				undoStack.length = 0;	//本地undo全部删除
				dataChanged = false;
			}
		}
		
		/**
		 * 把位置从本地空间转换到屏幕空间
		 * @param	position
		 * @param	out
		 */
		public function localToScreen(position:Vector3, out:Vector3):void {
			camera.viewport.project1(position, mat_WVP, out);
			var outE:Float32Array = out.elements;
			outE[0] = outE[0] / Laya.stage.clientScaleX;
			outE[1] = outE[1] / Laya.stage.clientScaleY;
		}		
		
		public function pick2DData(x:Number, y:Number, data:Array, dist:Number, result:Pick2DResult):Pick2DResult {
			var minid:int = -1;
			var miniDist:Number = dist;
			var pickOffX:Number = 0;
			var pickOffY:Number = 0;
			
			var dtnum:int = data.length / 2;
			for (var i:int = 0; i < dtnum; i++) {
				//TODO 用不用判断z是否>0
				var dx:Number = data[i*2] - x;
				var dy:Number = data[i*2+1] - y;
				var cdist:Number = Math.sqrt(dx * dx + dy * dy);
				if (miniDist > cdist) {
					miniDist = cdist;
					minid = i;
					pickOffX = dx;
					pickOffY = dy;
				}
			}
			if (minid >= 0) {
				result.miniPointID = minid;
				result.miniDist = miniDist;
				result.offX = pickOffX;
				result.offY = pickOffY;
				return result;
			}
			return null;
		}
		
		/**
		 * 点选算法。按照投影到屏幕上的二维点的距离来算，这样最自然。也方便以后转到gpu点选。
		 * 可能选中点，也可能选中边。如果都满足优先按照点来算
		 * @param	x
		 * @param	y
		 * @param	dist
		 * @return
		 */
		public function pick(x:Number, y:Number, dist:Number = 70):void {
			pickResult.miniObjID =-1;
			
			// 横截面
			if ( pick2DData(x, y, crossDataOnScr, dist, pickResult)) {
				pickResult.miniObjID = 0;
				dist = pickResult.miniDist;
				undo_startCrossData();
				console.log('pick ', pickResult.miniPointID);
			}
			// 横截面控制点
			if ( interpNum > 0) {
				var resultcc:Pick2DResult = new Pick2DResult();
				if (pick2DData(x, y, crossCtrlOnScr, dist, resultcc)) {
					pickResult = resultcc;
					pickResult.miniObjID = 2;
					dist = pickResult.miniDist;
					undo_startCrossData();
				}
			}
			
			//侧面
			var result1:Pick2DResult = new Pick2DResult();
			if ( pick2DData(x, y, profileLineDataOnScr, dist, result1)) {
				pickResult = result1;
				pickResult.miniObjID = 1;
				dist = result1.miniDist;
				undo_startProfileData();
			}
			
			//侧面控制点
			var resultpc:Pick2DResult = new Pick2DResult();
			if (pick2DData(x, y, profileCtrlOnScr, dist, resultpc)) {
				pickResult = resultpc;
				pickResult.miniObjID = 3;
				undo_startProfileData();
			}
		}
		
		/**
		 * 返回是否靠近某条边，以及对应的最近的边上的点。
		 * 只有投影点落在两个点之间的才算，所以如果相邻边形成锐角，在尖角外面会有一个无效区域
		 * @param	x
		 * @param	y
		 */
		public function pickEdge(x:Number, y:Number, data:Array, close:Boolean, dist:Number, result:Pick2DEdgeResult):Pick2DEdgeResult {
			result.PtIdx =-1;
			result.dist2 = dist * dist;
			var dtnum:int = data.length / 2;
			var end:int = dtnum - 1;
			if (close) end = dtnum;
			for (var i:int = 0; i < end; i++) {
				var st:int = i * 2;
				var p0x:Number = data[st];
				var p0y:Number = data[st + 1];
				var p1x:Number = data[(st + 2)%data.length];
				var p1y:Number = data[(st + 3)%data.length];
				var dx:Number = p1x - p0x;	//p0->p1
				var dy:Number = p1y - p0y;
				var p0px:Number = x - p0x;	//p0->p
				var p0py:Number = y - p0y;
				
				var d2:Number = dx * dx + dy * dy;
				if (d2 < 1e-6)	//边的长度太短
					continue;
					
				//normalize 一下边的方向矢量
				var elen:Number = Math.sqrt(d2);
				var ndx:Number = dx / elen;
				var ndy:Number = dy / elen;
				
				// p{x,y} 在边上的投影
				var dv:Number = ndx * p0px + ndy * p0py;
				if (dv<0||dv>elen) // 投影到线段外面了，忽略
					continue;
				var projx:Number = p0x + ndx * dv;	// 在线段上的投射点
				var projy:Number = p0y + ndy * dv;
				
				// 再看看到线段的距离是否合适
				var dx1:Number = projx - x;
				var dy1:Number = projy - y;
				d2 = dx1 * dx1 + dy1 * dy1;
				if ( d2< result.dist2) {
					result.dist2 = d2;
					result.PtIdx = i;
					result.projX = projx;
					result.projY = projy;
				}
			}
			return result.PtIdx >= 0?result:null;
		}		
		
		/**
		 * 摄像机改变了，需要重新计算控制点
		 */
		public function onCameraChange():void {
			if (!target)
				return;
				
			Matrix4x4.multiply( camera.viewMatrix, mat_World, tmpMat);
			Matrix4x4.multiply( camera.projectionMatrix, tmpMat, mat_WVP);
			
			var mesh:SimpleShapeFilter = target._simpleShapeMesh;
			// 转换到屏幕坐标
			var scrPos:Vector3  = new Vector3();
			var hdata:Vector.<HandlePoint>= mesh.crossSectionData;
			var hdatanum:int = hdata.length ;
			for (var hi:int = 0; hi < hdatanum; hi++) {
				tmpVec3.elements[0] = hdata[hi].x;
				tmpVec3.elements[1] = 0;				// 先放到水平面
				tmpVec3.elements[2] = hdata[hi].y;
				localToScreen(tmpVec3, scrPos);
				crossDataOnScr[hi * 2] = scrPos.x;
				crossDataOnScr[hi * 2 + 1] = scrPos.y;
				crossDataOnScrZ[hi] = scrPos.z;
				
				tmpVec3.elements[0] = hdata[hi].ctrlx;
				tmpVec3.elements[1] = 0;
				tmpVec3.elements[2] = hdata[hi].ctrly;
				localToScreen(tmpVec3, scrPos);
				crossCtrlOnScr[hi * 2] = scrPos.x;
				crossCtrlOnScr[hi * 2 + 1] = scrPos.y;
				crossCtrlOnScrZ[hi] = scrPos.z;
			}			
			
			var cdata:Vector.<HandlePoint> = mesh.profileLineData;
			var cdtNum:int = cdata.length;
			for (var ci:int = 0; ci < cdtNum; ci++) {
				tmpVec3.elements[0] = cdata[ci].x;
				tmpVec3.elements[1] = cdata[ci].y;
				tmpVec3.elements[2] = 0;		// 放到xy平面
				localToScreen(tmpVec3, scrPos);
				profileLineDataOnScr[ci * 2] = scrPos.x;
				profileLineDataOnScr[ci * 2 + 1] = scrPos.y;
				profileLineDataOnScrZ[ci] = scrPos.z;
				
				tmpVec3.elements[0] = cdata[ci].ctrlx;
				tmpVec3.elements[1] = cdata[ci].ctrly;
				tmpVec3.elements[2] = 0;
				localToScreen(tmpVec3, scrPos);
				profileCtrlOnScr[ci * 2] = scrPos.x;
				profileCtrlOnScr[ci * 2 + 1] = scrPos.y;
				profileCtrlOnScrZ[ci] = scrPos.z;
			}
		}		
		
		/**
		 * 平面用点法式，而不是现在的Plane类，因为需要一个点，且不想构造Plane
		 * @param	x
		 * @param	y
		 * @param	planePos
		 * @param	planeNormal
		 * @param	out
		 */
		public function scrToPlane(x:Number,  y:Number, planePos: Vector3, planeNormal:Vector3, out:Vector3):void {
			point.elements[0] = x;
			point.elements[1] = y;
			camera.viewportPointToRay(point, ray);
			var ro:Float32Array = ray.origin.elements;
			var rd:Float32Array = ray.direction.elements
			var ppos:Float32Array = planePos.elements;
			var pnor:Float32Array = planeNormal.elements; 
			//ray的起点到平面的距离
			var dx:Number =  ppos[0] - ro[0];
			var dy:Number =  ppos[1] - ro[1];
			var dz:Number =  ppos[2] - ro[2];
			var dist:Number = dx * pnor[0] + dy * pnor[1] + dz * pnor[2];
			var v:Number = rd[0] * pnor[0] + rd[1] * pnor[1] + rd[2] * pnor[2];
			var t:Number = dist / v;
			out.elements[0] = ro[0] + rd[0] * t;
			out.elements[1] = ro[1] + rd[1] * t;
			out.elements[2] = ro[2] + rd[2] * t;
		}		
		
		/**
		 * 把一个世界空间的坐标变成编辑对象本地空间的
		 * @param	wpos
		 * @param	lpos
		 */
		public function worldToLocal(wpos:Vector3, lpos:Vector3):void {
			Vector3.transformV3ToV3(wpos, mat_InvWorld, lpos);
		}
		
		public function deletePoint(objid:int, pointid:int):void {
			if (!target)
				return;
			var dt:Array;
			if (objid == 0) {
				undo_startCrossData();
				undo_drage_changeData();
				dt = target._simpleShapeMesh.crossSectionData as Array;
				dt.splice(pointid, 1);
				target._simpleShapeMesh.setCrossSection(dt);
				undo_op_end();
			}else if(objid==1) {
				undo_startProfileData();
				undo_drage_changeData();
				
				dt = target._simpleShapeMesh.profileLineData as Array;
				dt.splice(pointid, 1);
				target._simpleShapeMesh.setProfileLine(dt);
				undo_op_end();
			}else {
				console.log("不能删除这个点");
			}
			updateData();
			pickResult.miniObjID =-1;	// 撤销当前选择
		}
		
		public function addPoint(x:Number, y:Number):void {
			var dist:Number = 70;
			pickEdgeResult.ObjID =-1;
			if (pickEdge(x, y, crossDataOnScr, true, dist, pickEdgeResult)) {//有满足条件的
				pickEdgeResult.ObjID = 0;
				dist = Math.sqrt(pickEdgeResult.dist2);
			}
			
			var result1:Pick2DEdgeResult = new Pick2DEdgeResult();
			if ( pickEdge(x, y, profileLineDataOnScr, false, dist, result1)) {
				pickEdgeResult = result1;
				pickEdgeResult.ObjID = 1;
			}
			
			var dt:Array;
			var stid:int = 0;
			if (pickEdgeResult.ObjID == 0) {
				undo_startCrossData();
				undo_drage_changeData();
				dt = target._simpleShapeMesh.crossSectionData as Array;
				stid = pickEdgeResult.PtIdx + 1;	//在下一个点
				//新的点投影到三维中 TODO 如果改了平面这个也要改
				scrToLocalPlane(pickEdgeResult.projX, pickEdgeResult.projY, LOCAL_XZ, tmpVec3);
				var addx:Number = tmpVec3.elements[0];
				var addy:Number = tmpVec3.elements[2];
				var nx:Number = dt[stid%dt.length].x;
				var ny:Number = dt[stid%dt.length].y;
				dt.splice(stid, 0, new HandlePoint( addx, addy,(addx+nx)/2, (addy+ny)/2));
				target._simpleShapeMesh.onDataChanged();
				//选中点
				//pickResult.miniObjID = 0;
				//pickResult.miniPointID = pickEdgePtIdx + 1;
				updateData();//更新数据
				undo_op_end();
				
			}else if (pickEdgeResult.ObjID == 1) {
				undo_startProfileData();
				undo_drage_changeData();
				dt = target._simpleShapeMesh.profileLineData as Array;
				stid = pickEdgeResult.PtIdx + 1;
				scrToLocalPlane(pickEdgeResult.projX, pickEdgeResult.projY, LOCAL_XY, tmpVec3);
				addx = tmpVec3.elements[0];
				addy = tmpVec3.elements[1];
				nx = dt[stid].x;
				ny = dt[stid].y;
				dt.splice(stid, 0, new HandlePoint(addx,addy,(addx+nx)/2, (addy+ny)/2));
				target._simpleShapeMesh.onDataChanged();
				//选中点
				updateData();//更新数据
				undo_op_end();
			}
		}
		
		/**
		 * 编辑器一个完整的op结束了
		 */
		public function onEditorOpEnd():void {
			//添加到redo中
		}
		
		public function onMouseDown(e:Event):void {
			pick(e.stageX, e.stageY);			
		}
		
		public function onMouseUp(e:Event):void {
			pickResult.miniObjID = -1;
			pickResult.miniPointID =-1;
			undo_op_end();
		}
		
		/**
		 * 屏幕坐标转换到对象本地空间的坐标系平面。
		 * @param	x
		 * @param	y
		 * @param  planeid 只能是 LOCAL_XY， LOCAL_XZ， LOCAL_YZ 之一
		 * @param	out
		 */
		public function scrToLocalPlane(x:Number, y:Number, planeid:int, out:Vector3):void {
			if (planeid != LOCAL_XY && planeid != LOCAL_XZ && planeid != LOCAL_YZ) {
				console.error('planeid 不是指定值');
				return;
			}
			
			var planePos:Vector3 = Vec3Pool.getVec3();
			var planeNor:Vector3 = Vec3Pool.getVec3();
			var worldPos:Vector3 = Vec3Pool.getVec3();
			
			planePos.elements[0] = mat_World.elements[12];
			planePos.elements[1] = mat_World.elements[13];
			planePos.elements[2] = mat_World.elements[14];
			
			//xz平面，法线是y
			planeNor.elements[0] = mat_World.elements[planeid]; planeNor.elements[1] = mat_World.elements[planeid+1];planeNor.elements[2] = mat_World.elements[planeid+2];
			scrToPlane(x, y, planePos, planeNor, worldPos);
			worldToLocal(worldPos, out);
			
			Vec3Pool.discardVec3(planeNor);
			Vec3Pool.discardVec3(planePos);
			Vec3Pool.discardVec3(worldPos);
		}
		
		public function onMouseMov(e:Event):void {		
			// 如果当前正选中某个点，则拖动他
			var dt:Array;
			var lastx:Number = 0;
			var lasty:Number = 0;
			var mesh:SimpleShapeFilter = target._simpleShapeMesh;
			if (pickResult.miniObjID >= 0 && pickResult.miniPointID >= 0) {
				var mx:Number = e.stageX + pickResult.offX;
				var my:Number = e.stageY + pickResult.offY;
				var pointid:int = pickResult.miniPointID;
				
				switch (pickResult.miniObjID) {
				case 0:{// 横截面. 
					scrToLocalPlane(mx, my, LOCAL_XZ, tmpVec3);
					dt = mesh.crossSectionData as Array;
					lastx = dt[pointid].x;
					lasty = dt[pointid].y;
					dt[pointid ].x = tmpVec3.x;
					dt[pointid ].y = tmpVec3.z;
					//同时控制控制点
					dt[pointid].ctrlx += (tmpVec3.x - lastx);
					dt[pointid].ctrly += (tmpVec3.z - lasty);
					mesh.onDataChanged();
				}
					break;
				case 1: {// 侧面缩放. 法线是z
					scrToLocalPlane(mx, my, LOCAL_XY, tmpVec3);
					dt = mesh.profileLineData as Array;
					lastx = dt[pointid ].x;
					lasty = dt[pointid ].y;
					dt[pointid ].x = tmpVec3.x;
					dt[pointid ].y = tmpVec3.y;
					//同时控制控制点
					dt[pointid].ctrlx += (tmpVec3.x - lastx);
					dt[pointid].ctrly += (tmpVec3.y - lasty);
					mesh.onDataChanged();
				}	
					break;
				case 2: {	//横截面控制点
					scrToLocalPlane(mx, my, LOCAL_XZ, tmpVec3);
					dt = mesh.crossSectionData as Array;
					dt[pointid ].ctrlx = tmpVec3.x;
					dt[pointid ].ctrly = tmpVec3.z;
					mesh.onDataChanged();
				}
					break;
				case 3: {	//侧面控制点
					scrToLocalPlane(mx, my, LOCAL_XY, tmpVec3);
					dt = mesh.profileLineData as Array;
					dt[pointid].ctrlx = tmpVec3.x;
					dt[pointid].ctrly = tmpVec3.y;
					mesh.onDataChanged();
				}
					break;
					default:
				}
				undo_drage_changeData();
			}
		}
		
		public function onKeyDown(e:Event):void {
			var interpBase:int = 3;
			switch(e.keyCode) {
			case Keyboard.ESCAPE:
				break;
			case Keyboard.TAB:
				editMode = !editMode;
				break;
			case Keyboard.NUMBER_0:
			case Keyboard.NUMBER_1:
			case Keyboard.NUMBER_2:
			case Keyboard.NUMBER_3:
			case Keyboard.NUMBER_4:
			case Keyboard.NUMBER_5:
			case Keyboard.NUMBER_6:
			case Keyboard.NUMBER_7:
			case Keyboard.NUMBER_8:
			case Keyboard.NUMBER_9:
				if (ctrl) {
					e.stopPropagation();
					interpNum= interpBase * (e.keyCode-Keyboard.NUMBER_0);
					undo_op_changeInterp(target._simpleShapeMesh.profileLineInterpNum, interpNum);
					target._simpleShapeMesh.profileLineInterpNum = target._simpleShapeMesh.crossSectionInterpNum = interpNum;
				}
				break;
			case Keyboard.CONTROL:
				ctrl = true;
				break;
			case Keyboard.Z:
				ctrl && undo();
				break;
			case Keyboard.Y:
				ctrl && redo();
				break;
			case Keyboard.S: {
					var curstyle:Boolean = target._simpleShapeMesh.polygonStyle ;
					e.stopPropagation();
					target._simpleShapeMesh.polygonStyle = !curstyle;
					undo_op_changeStyle(curstyle , !curstyle );
				}
				break;
			}
		}
		
		public function onKeyUp(e:Event):void {
			switch(e.keyCode) {
			case Keyboard.CONTROL:
				ctrl = false;
				break;
			}
		}
		public function onDbClick(e:Event):void {
			//优先删除
			pick(e.stageX, e.stageY,20);	//删除的范围要小一些
			if (pickResult.miniObjID >= 0 && pickResult.miniPointID >= 0) {
				deletePoint(pickResult.miniObjID, pickResult.miniPointID);
			}else {
				//检查是否是选中边了
				addPoint(e.stageX, e.stageY);
			}
		}
		
		/**
		 * 需要提供的数据：
		 * 。可控点	（垂直于镜头的黑色小方块）
		 * 。连边（放在这里是否合适）（黑色。选中状态是土黄色渐变）
		 * 。移动限制。（亮黄色）
		 * 。如果是线限制的话，可以提供当前值（长度）
		 * 。
		 */
		public function renderVisualData(g: Graphics):void {
			if (!editMode)
				return;
			var mat_World:Matrix4x4 = target.transform.worldMatrix;
			g.alpha(0.5);
			//坐标轴
			var pos:Vector3 = new Vector3(mat_World.elements[12], mat_World.elements[13], mat_World.elements[14]);
			var scrPos:Vector3  = new Vector3();
			localToScreen(pos, scrPos);
			var orix:Number = scrPos.x;
			var oriy:Number = scrPos.y;
			var oriz:Number = scrPos.z;
			
			if (scrPos.z >0 ){
				pos.x += 1;
				localToScreen(pos, scrPos);
				if (scrPos.z > 0) {
					//g.drawLine(orix, oriy, scrPos.x, scrPos.y, 'red');
				}
				pos.x -= 1; pos.y += 1;
				localToScreen(pos, scrPos);
				if (scrPos.z > 0) {
					//g.drawLine(orix, oriy, scrPos.x, scrPos.y, 'green');
					//g.fillBorderText('y',scrPos.x, scrPos.y, '20px Arial', 'green','yellow');
				}
				
				
				pos.y -= 1; pos.z += 1;
				localToScreen(pos, scrPos);
				if ( scrPos.z > 0) {
					//g.drawLine(orix, oriy, scrPos.x, scrPos.y, 'blue');
				}
			}
			//侧面参考线
			pos.x = 0; pos.y = target._simpleShapeMesh.profileLineMiniY; pos.z = 0;
			localToScreen(pos, scrPos);
			var osx:Number = scrPos.x;
			var osy:Number = scrPos.y;
			var osz:Number = scrPos.z;
			pos.y = target._simpleShapeMesh.profileLineMaxY;
			localToScreen(pos, scrPos);
			if (osz > 0 && scrPos.z > 0) {
				g.drawLine(osx, osy, scrPos.x, scrPos.y, '#007700');
			}
			
			//横截面
			//var ck1:Number = fitForScrDrag( mat_World.elements[4], mat_World.elements[5], mat_World.elements[6]);//y axis
			//g.alpha(ck1);
			var interp:int = target._simpleShapeMesh.crossSectionInterpNum;
			var cx:Number;
			var cy:Number;
			var hdatanum:int = crossDataOnScr.length / 2;
			for (var hi:int = 0; hi < hdatanum; hi++) {
				var nex:int = (hi + 1) % hdatanum;
				var curz:Number = crossDataOnScrZ[hi];
				var nextz:Number = crossDataOnScrZ[nex];
				cx = crossDataOnScr[hi * 2];
				cy = crossDataOnScr[hi * 2 + 1]
				var nexx:Number = crossDataOnScr[nex * 2];
				var nexy:Number = crossDataOnScr[nex * 2 + 1];
				if ( curz > 0) {
					g.drawRect(cx - 4, cy - 4, 8, 8, '#ffff44');
					if (nextz > 0) {
						//两个都在前面
						g.drawLine(cx, cy, nexx, nexy, '#999900');
						
						//控制点
						if (interp > 0) {
							if (crossCtrlOnScrZ[hi] > 0) {
								var ctrlx:Number = crossCtrlOnScr[hi * 2];
								var ctrly:Number = crossCtrlOnScr[hi * 2 + 1];
								g.drawRect( ctrlx - 4, ctrly - 4, 8, 8, '#ff0000');
								g.drawLine(cx, cy, ctrlx,ctrly,'#880000');
							}
						}
					}else {
						//这种需要插值。先不做了。效果差不多
					}
				}else {
					if (nextz > 0) {
						// 需要插值先不做了
					}else {//两个点都在外面
						continue;
					}
				}
			}
			//g.drawLines(0, 0, crossDataOnScr, '#999900');
			//g.drawLine(crossDataOnScr[crossDataOnScr.length - 2], crossDataOnScr[crossDataOnScr.length - 1], crossDataOnScr[0], crossDataOnScr[1], '#999900'); // 最后一段
			
			//侧边
			//var ck2:Number = fitForScrDrag(mat_World.elements[8], mat_World.elements[9], mat_World.elements[10]);//z axis
			//g.alpha(ck2);
			
			var cdtNum:int = profileLineDataOnScr.length / 2;
			for (var ci:int = 0; ci < cdtNum; ci++) {
				var cz:Number = profileLineDataOnScrZ[ci];
				cx = profileLineDataOnScr[ci * 2];
				cy = profileLineDataOnScr[ci * 2 + 1];
				if(cz>0){
					g.drawRect(cx - 4, cy - 4, 8, 8, '#44ffff');
				}
				if (ci < cdtNum - 1) {
					var nz:Number = profileLineDataOnScrZ[ci + 1];
					if (cz > 0 && nz > 0) {
						g.drawLine(cx, cy, profileLineDataOnScr[ci * 2 + 2], profileLineDataOnScr[ci * 2 + 3], '#009999');
						
						//控制点
						if (interp > 0) {
							if (profileCtrlOnScrZ[ci] > 0) {
								ctrlx = profileCtrlOnScr[ci * 2];
								ctrly = profileCtrlOnScr[ci * 2 + 1];
								g.drawRect( ctrlx - 4, ctrly - 4, 8, 8, '#ff0000');
								g.drawLine(cx, cy, ctrlx,ctrly,'#880000');
							}
						}
					}
				}
				
				if (interp > 0) {
					
				}
			}
			//g.drawLines(0, 0, profileLineDataOnScr, '#009999');				
		}		
	}
}	