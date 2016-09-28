package laya.webgl.canvas {
	import laya.maths.Rectangle;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shapes.BasePoly;
	import laya.webgl.shapes.IShape;
	import laya.webgl.shapes.Line;
	import laya.webgl.shapes.LoopLine;
	import laya.webgl.shapes.Polygon;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class Path {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _rect:Rectangle;
		
		public var ib:IndexBuffer2D;
		public var vb:VertexBuffer2D;
		public var dirty:Boolean = false;
		public var geomatrys:Vector.<IShape>;
		public var _curGeomatry:IShape;
		
		public var offset:int = 0;
		public var count:int = 0;
		
		private var geoStart:int = 0;
		
		public var tempArray:Array = [];
		
		public var closePath:Boolean = false;
		
		public function Path() {
			geomatrys = new Vector.<IShape>();
			var gl:WebGLContext = WebGL.mainContext;
			ib = IndexBuffer2D.create(WebGLContext.DYNAMIC_DRAW);
			vb = VertexBuffer2D.create(5);
		}
		
		public function addPoint(pointX:Number, pointY:Number):void {
			tempArray.push(pointX, pointY);
		}
		
		public function getEndPointX():Number {
			return tempArray[tempArray.length - 2];
		}
		
		public function getEndPointY():Number {
			return tempArray[tempArray.length - 1];
		}
		
		public function polygon(x:Number, y:Number, points:Array, color:uint, borderWidth:int, borderColor:*):IShape {
			var geo:BasePoly;
			geomatrys.push(_curGeomatry = geo = new Polygon(x, y, points, color, borderWidth, borderColor));
			if (!color) geo.fill = false;
			if (borderColor == undefined) geo.borderWidth = 0;
			return geo;
		}
		
		public function setGeomtry(shape:IShape):void {
			geomatrys.push(_curGeomatry = shape);
		}
		
		public function drawLine(x:Number, y:Number, points:Array, width:Number, color:uint):IShape {
			var geo:BasePoly;
			if (closePath) {
				geomatrys.push(_curGeomatry = geo = new LoopLine(x, y, points, width, color));
			} else {
				geomatrys.push(_curGeomatry = geo = new Line(x, y, points, width, color));
			}
			geo.fill = false;
			return geo;
		}
		
		public function update():void {
			var si:int = ib.byteLength;
			var len:int = geomatrys.length;
			this.offset = si;
			for (var i:int = geoStart; i < len; i++) {
				geomatrys[i].getData(ib, vb, vb.byteLength / 20);
			}
			geoStart = len;//记录下一次 该从哪个位置开始计算几何图形的数据
			this.count = (ib.byteLength - si) / CONST3D2D.BYTES_PIDX;
		}
		
		public function reset():void {
			this.vb.clear();
			this.ib.clear();
			offset = count = geoStart = 0;
			geomatrys.length = 0;
		}
	
	}

}