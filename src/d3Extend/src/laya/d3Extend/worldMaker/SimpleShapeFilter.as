package worldMaker {
	import laya.ani.math.BezierLerp;
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.Vertex.VertexPositionNormal;
	import laya.d3.graphics.Vertex.VertexPositionNormalColor;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	import laya.d3Extend.VertexColor;
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 */
	public class SimpleShapeFilter extends GeometryElement {
		/**@private */
		private static var _type:int = _typeCounter++;
		
		public var boundSphere:BoundSphere = new BoundSphere(new Vector3(6, 6, 6), 10.392);
		public var indexNum:int = 0;
		public var vertexNum:int = 0;
		public var crossSectionData:Vector.<HandlePoint> =new Vector.<HandlePoint>();
		//public var crossSectionSplineCtrl:Array=[];	// 二次贝塞尔曲线的控制点。有几个点就有几个控制点，不管是否是封闭的
		private var _crossSecInterpNum:int = 0;		//横截面的插值次数
		public var profileLineData:Vector.<HandlePoint> = new Vector.<HandlePoint>();
		//public var profileLineDataSplineCtrl:Array = [];
		private var _profilelineInterfNum:int = 0;	//侧面的插值次数
		private var _color:uint= 0xffffff;			//bgr
		private var _polygonStyle:Boolean = true;
		private var needReExport:Boolean = true;	//是否需要重新导出
		private var leMesh:LE_Mesh = new LE_Mesh();
		private var _bEditMode:Boolean = false;		//编辑器模式下，会有一个缺省外观，并且修改参数会立即导出
		private var _bbx:Array = [0, 0, 0, 0, 0, 0];
		private var exported:Boolean = false;
		
		public var profileLineMiniY:Number = 0;
		public var profileLineMaxY:Number = 0;
		
		public var _splineType:String = 'bezier2interp';	//这个要保存到文件中，防止由于算法不一致导致的效果不一致
		protected var bufferState:BufferState;
		
		public function SimpleShapeFilter(bEditMode:Boolean = false ) {
			_bEditMode = bEditMode;
			//setCrossSection( [ -0.5, -0.5, -0.5, 0.5,0.5, 0.5, 0.5, -0.5]);	// 这个必须是顺时针
			setCrossSection([-0.309, 0.951, 0.154, 0.4755, 0.809, 0.587, 0.5, 0, 0.809, -0.587, 0.154, -0.475, -0.309, -0.951, -0.404, -0.293, -1, 0, -0.404, 0.293]);// 这个必须是顺时针
			setProfileLine([0.01, 0.1, 1, 0 ,0.01, 0.3]);	// 这个必须是从下往上的顺序
			if(bEditMode){
				rebuildMesh();
				reExportMeshData();
			}
		}
		
		
		/**
		 * 二次贝塞尔曲线
		 * @param	sx	起点
		 * @param	sy
		 * @param	ex	终点
		 * @param	ey
		 * @param	cx	控制点
		 * @param	cy
		 * @param	interpNum 	插值次数
		 * @return 返回插值后的数组
		 */
		public function bezier2(sx:Number, sy:Number, ex:Number, ey:Number, cx:Number, cy:Number,interpNum:int):Array {
			var ret:Array = new Array(interpNum*2);
			// 起始点到控制点的x和y每次的增量
			var changeX1:Number = (cx - sx) / interpNum;
			var changeY1:Number = (cy - sy) / interpNum;
			// 控制点到结束点的x和y每次的增量
			var changeX2:Number = (ex - cx) / interpNum;
			var changeY2:Number = (ey - cy) / interpNum;
	 
			for(var i:int = 0; i < interpNum; i++) {
				// 计算两个动点的坐标
				var qx1:Number = sx + changeX1 * i;
				var qy1:Number = sy + changeY1 * i;
				var qx2:Number = cx + changeX2 * i;
				var qy2:Number = cy + changeY2 * i;
				// 计算得到此时的一个贝塞尔曲线上的点坐标
				var bx:Number  = qx1 + (qx2 - qx1) * i / interpNum;
				var by:Number  = qy1 + (qy2 - qy1) * i / interpNum;
				ret[i * 2] = bx;
				ret[i * 2 + 1] = by;
			}
			return ret;
		}
			
		/**
		 * 三次贝塞尔曲线
		 */
		public function PointOnCubicBezier():void {
			
		}
			
		/**
		 * 把一个折线用贝塞尔插值。
		 * @param	data
		 * @param	interpNum  每一段插成多少段
		 * @param	close 	是否是闭合
		 * @return
		 */
		public function bezier2interp(data:Vector.<HandlePoint>,  interpNum:int, close:Boolean):Array {
			if (data.length < 2 )
				return [];
			var i:int = 0;
			var ret:Array = [];
			var ptnum:int = data.length;
			if ( interpNum == 0) {
				for (i = 0; i < ptnum; i++) {
					ret.push(data[i].x, data[i].y);
				}
				return ret;//线性只能原样
			}
			var ci:int = 0;
			for (i = 0; i < ptnum - 1; i++) {
				ret = ret.concat( bezier2(data[i].x, data[i].y, data[i+1].x, data[i+1].y, data[i].ctrlx, data[i].ctrly, interpNum));
			}
			
			//如果有close要把最后一段画上
			if (close) {
				var last:HandlePoint = data[data.length - 1];
				ret = ret.concat(bezier2(last.x, last.y, data[0].x, data[0].y, last.ctrlx, last.ctrly, interpNum));
			}
			return ret;
		}
		
		/**
		 * 根据数据重新生成渲染模型
		 */
		public function rebuildMesh():void {
			var interpFun:* = this[_splineType];
			leMesh.createFromCrossSection_taperPath(
				//HermitSpline.inerp(crossSectionData,_crossSecInterpNum,true),
				interpFun.call(this,crossSectionData,_crossSecInterpNum,true),
				true,
				//HermitSpline.inerp(profileLineData,_profilelineInterfNum,false), 
				interpFun.call(this,profileLineData,_profilelineInterfNum,false), 
				null);
		}
		
		/**
		 * @private
		 * @return  是否需要渲染。
		 */
		override public function _prepareRender(state:RenderContext3D):Boolean {
			if (!exported) {
				rebuildMesh();
				reExportMeshData();
			}
			return true;
		}		
		
		private function updateBBX(x:Number,y:Number,z:Number):void {
			if (_bbx[0] > x)_bbx[0] = x;
			if (_bbx[1] > y)_bbx[1] = y;
			if (_bbx[2] > z)_bbx[2] = z;
			if (_bbx[3] < x)_bbx[3] = x;
			if (_bbx[4] < y)_bbx[4] = y;
			if (_bbx[5] < z)_bbx[5] = z;
		}
		
		private function getBBXCenter(vout:Vector3):void {
			vout.x = (_bbx[0] + _bbx[3]) / 2;
			vout.y = (_bbx[1] + _bbx[4]) / 2;
			vout.z = (_bbx[2] + _bbx[5]) / 2;
		}
		
		//包围盒的对角线
		private function getBBXSize():Number {
			var dx:Number = _bbx[3] - _bbx[0];
			var dy:Number = _bbx[4] - _bbx[1];
			var dz:Number = _bbx[5] - _bbx[2];
			return Math.sqrt(dx * dx + dy * dy + dz * dz);
		}
		
		/**
		 * 重新导出模型
		 */
		public function reExportMeshData():void {
			//导出数据
			var expmesh:IRenderableMesh = this.leMesh.fastExportRenderableMesh( polygonStyle?1:0);
			
			//构造VB，IB
			//vertex buffer
			var vertnum:int = this.vertexNum =  expmesh.pos.length / 3;
			var vd:VertexDeclaration = /*VertexPositionNormalColor.vertexDeclaration*/VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR");
			var Buffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(1);
			var vb:VertexBuffer3D = new VertexBuffer3D(vd.vertexStride * vertnum*4, WebGLContext.DYNAMIC_DRAW, true);
			var vbbuf:Float32Array = new Float32Array(vd.vertexStride * vertnum);
			var vi:int = 0;
			var pi:int = 0;
			var ni:int = 0;
			var ci:int = 0;
			var cr:Number = (_color&0xff)/255.0;
			var cg:Number = ((_color>>>8)&0xff)/255.0;
			var cb:Number = ((_color>>>16)&0xff)/255.0;
			var ca:Number = 1.0;
			var cx:Number = 0; 
			var cy:Number = 0;
			var cz:Number = 0;
			for ( var i:int = 0; i < vertnum; i++) {
				//pos
				cx = expmesh.pos[pi++];
				cy = expmesh.pos[pi++];
				cz = expmesh.pos[pi++];
				vbbuf[vi++] = cx; vbbuf[vi++] = cy; vbbuf[vi++] = cz;
				updateBBX(cx, cy, cz);
				//normal
				vbbuf[vi++] = expmesh.normal[ni++];vbbuf[vi++] = expmesh.normal[ni++];vbbuf[vi++] = expmesh.normal[ni++];
				//color
				//vbbuf[vi++] = expmesh.color[ci++];vbbuf[vi++] = expmesh.color[ci++];vbbuf[vi++] = expmesh.color[ci++];vbbuf[vi++] = expmesh.color[ci++];
				vbbuf[vi++] = cr;vbbuf[vi++] = cg; vbbuf[vi++] = cb; vbbuf[vi++] = ca;
			}
			vb.setData(vbbuf);
			vb.vertexDeclaration = vd;
			Buffers[0] = vb;
			
			//包围球
			getBBXCenter( boundSphere.center);
			boundSphere.radius = getBBXSize()/2;
			
			//index buffer 
			this.indexNum = expmesh.index.length;
			var ib:IndexBuffer3D = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, expmesh.index.length, WebGLContext.DYNAMIC_DRAW);
			ib.setData(expmesh.index);
			
			bufferState = new BufferState();
			bufferState.bind();
			bufferState.applyVertexBuffers(Buffers);
			bufferState.applyIndexBuffer(ib);
			bufferState.unBind();
			
			//_applyBufferState(bufferState);
			exported = true;
		}
		
		/**
		 * 设置模型的横截面
		 * @param	data
		 */
		public function setCrossSection(data:Array):void {
			if (!data || data.length<=0) return;
			if ( typeof(data[0]) == 'number') {
				//如果设置的是数字，则要计算初始控制点
				var i:int = 0;
				var cx:Number = 0, cy:Number = 0, nx:Number = 0, ny:Number = 0;
				//如果没有控制点就先计算
				//HermitSpline
				var ptnum:int = data.length / 2 ;
				crossSectionData.length = ptnum;
				for (i = 0; i < ptnum; i++) {
					cx = data[i * 2];
					cy = data[i * 2 + 1];
					nx = data[(i * 2 + 2) % data.length];
					ny = data[(i * 2 + 3) % data.length];
					crossSectionData[i] = new HandlePoint(cx, cy, (cx + nx) / 2, (cy + ny) / 2);
				}
			}else {
				//否则就是自带控制点
				crossSectionData = data as Vector.<HandlePoint>;
			}
			onDataChanged();
		}
		
		public function onDataChanged():void {
			if (_bEditMode) {
				rebuildMesh();
				reExportMeshData();
			}else {
				exported = false;
			}
			if(profileLineData && profileLineData.length){
				profileLineMiniY = profileLineData[0].y;
				profileLineMaxY = profileLineMiniY + 1;
				for (var i:int = 1; i < profileLineData.length; i++) {
					var cy:Number =  profileLineData[i].y;
					if (cy < profileLineMiniY) profileLineMiniY = cy;
					if (cy > profileLineMaxY) profileLineMaxY = cy;
				}
			}
		}
		
		/**
		 * 仅供读写文件用
		 */
		public function set splineType(type:String):void {
			_splineType = type;
		}
		
		public function get splineType():String {
			return _splineType;
		}
		
		/**
		 * 设置侧面线，
		 * @param	data 是一个数组，x表示缩放，y表示高度
		 */
		public function setProfileLine(data:Array):void {
			if (!data || data.length<=0) return;
			if ( typeof(data[0]) == 'number') {
				//如果设置的是数字，则要计算初始控制点
				var i:int = 0;
				var cx:Number = 0, cy:Number = 0, nx:Number = 0, ny:Number = 0;
				//如果没有控制点就先计算
				//HermitSpline
				var ptnum:int = data.length / 2 ;
				profileLineData.length = ptnum;
				for (i = 0; i < ptnum; i++) {
					cx = data[i * 2];
					cy = data[i * 2 + 1];
					nx = data[(i * 2 + 2) % data.length];
					ny = data[(i * 2 + 3) % data.length];
					profileLineData[i] = new HandlePoint(cx, cy, (cx + nx) / 2, (cy + ny) / 2);
				}
				
			}else {
				profileLineData = data as Vector.<HandlePoint>;
			}
			if(_bEditMode){
				rebuildMesh();
				reExportMeshData();
			}else {
				exported = false;	
			}
		}
		
		public function get crossSectionInterpNum():int {
			return _crossSecInterpNum;
		}
		public function set crossSectionInterpNum(i:int):void {
			if(this._crossSecInterpNum!=i){
				this._crossSecInterpNum = i;
				if(_bEditMode){
					rebuildMesh();
					reExportMeshData();
				}else {
					exported = false;
				}
			}
		}
		
		public function get profileLineInterpNum():int {
			return _profilelineInterfNum;
		}
		
		public function set profileLineInterpNum(i:int):void {
			if (this._profilelineInterfNum != i) {
				_profilelineInterfNum = i;
				if(_bEditMode){
					rebuildMesh();
					reExportMeshData();
				}else {
					exported = false;
				}
			}
		}
		/**
		 * 是否为多边形风格
		 * @param	b
		 */
		public function set polygonStyle(b:Boolean):void {
			if(b!=_polygonStyle){
				_polygonStyle = b;
				if(_bEditMode){
					reExportMeshData();
				}else {
					exported = false;
				}
			}
		}
		
		public function get polygonStyle():Boolean{
			return _polygonStyle;
		}
		
		/**
		 * color 格式是 0xbbggrr
		 */
		public function set color(color:uint):void {
			if (_color != color) {
				_color = color;
				if (_bEditMode) {
					reExportMeshData();
				}else {
					exported = false;
				}
			}
		}
		public function get color():uint {
			return _color;
		}
		
		public function set roughness(r:Number):void {
			
		}
		
		public function get roughness():Number {
			return 1;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return _type;
		}
		
		//
		override public function _render(state:RenderContext3D):void {
			var gl:WebGLContext = LayaGL.instance;
			bufferState.bind();
			gl.drawElements(WebGLContext.TRIANGLES, indexNum, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.renderBatches += 1;
			Stat.trianglesFaces += indexNum/3;
		}
		
		public function _destroy():void {
			//_bufferState.destroy();
			//TODO 郭磊这里应该怎么处理啊
		}		
	}
}

