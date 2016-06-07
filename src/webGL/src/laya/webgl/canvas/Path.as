package laya.webgl.canvas 
{
	import laya.maths.Rectangle;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shapes.BasePoly;
	import laya.webgl.shapes.Ellipse;
	import laya.webgl.shapes.IShape;
	import laya.webgl.shapes.Line;
	import laya.webgl.shapes.LoopLine;
	import laya.webgl.shapes.Polygon;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.IndexBuffer;
	import laya.webgl.utils.VertexBuffer;
	import laya.webgl.utils.VertexDeclaration;
	
	/**
	 * ...
	 * @author laya
	 */
	public class Path 
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var _x:Number=0;
		public var _y:Number=0;
		public var _rect:Rectangle;
		
		public var ib:IndexBuffer;
		public var vb:VertexBuffer;
		public var dirty:Boolean=false;
		public var geomatrys:Vector.<IShape>;
		public var _curGeomatry:IShape;
		
		public var offset:int=0;
		public var count:int=0;
		
		private var geoStart:int = 0;
		
		public var tempArray:Array = [];
		
		public var closePath:Boolean = false;
		
		public function Path()
		{
			geomatrys=new Vector.<IShape>();
			var gl:WebGLContext=WebGL.mainContext;
			ib = IndexBuffer.create(WebGLContext.DYNAMIC_DRAW);
			vb = VertexBuffer.create(new VertexDeclaration(5));
		}
		
		public function addPoint(pointX:Number, pointY:Number):void
		{
			tempArray.push(pointX, pointY);	
		}
		
		public function getEndPointX():Number {
			return tempArray[tempArray.length - 2];
		}
		
		public function getEndPointY():Number {
			return tempArray[tempArray.length - 1];
		}
		
		public function polygon(x:Number,y:Number,points:Array,color:uint,borderWidth:int,borderColor:*):void
		{
			var geo:BasePoly;
			geomatrys.push(_curGeomatry=geo=new Polygon(x,y,points,color,borderWidth,borderColor));
			if(!color)geo.fill=false; if(borderColor==undefined)geo.borderWidth=0;
		}
		
		public function drawLine(x:Number,y:Number,points:Array,width:Number,color:uint):void
		{
			var geo:BasePoly;
			if (closePath)
			{
				geomatrys.push(_curGeomatry=geo=new LoopLine(x,y,points,width,color));
			}else {
				geomatrys.push(_curGeomatry=geo=new Line(x,y,points,width,color));
			}
			geo.fill = false;
		}
		
		
		public function update():void
		{
			var si:int=ib.length;
			var len:int=geomatrys.length;
			this.offset = si;
			for(var i:int=geoStart;i<len;i++)
			{
				geomatrys[i].getData(ib,vb,vb.length/(5*4));
			}
			geoStart=len;//记录下一次 该从哪个位置开始计算几何图形的数据
			this.count = (ib.length - si) / CONST3D2D.BYTES_PIDX;
		}
		
		public function reset():void
		{
			this.vb.clear();
			this.ib.clear();
			offset = count =geoStart=0;
			geomatrys.length = 0;
		}
		
		
	}
	
}