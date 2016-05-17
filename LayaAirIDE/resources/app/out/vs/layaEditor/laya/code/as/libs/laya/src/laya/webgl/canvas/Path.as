package laya.webgl.canvas 
{
	import laya.maths.Rectangle;
	import laya.webgl.shapes.LoopLine;
	import laya.webgl.utils.IndexBuffer;
	import laya.webgl.utils.VertexBuffer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.shader.d2.value.PrimitiveSV;
	import laya.webgl.shapes.BasePoly;
	import laya.webgl.shapes.Circle;
	import laya.webgl.shapes.Ellipse;
	import laya.webgl.shapes.Fan;
	import laya.webgl.shapes.IShape;
	import laya.webgl.shapes.Line;
	import laya.webgl.shapes.Polygon;
	import laya.webgl.shapes.Rect;
	
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
		
		private var geoStart:int=0;
		public function Path()
		{
			geomatrys=new Vector.<IShape>();
			var gl:WebGLContext=WebGL.mainContext;
			ib = IndexBuffer.create();
			vb = VertexBuffer.create();
		}
		
		public function clear():void
		{
			_rect = null;
		}
		
		public function rect2(x:Number,y:Number,w:Number,h:Number,color:uint,borderWidth:int=2,borderColor:uint=0):void
		{
			geomatrys.push(_curGeomatry=new Rect(x,y,w,h,color,borderWidth,borderColor)) ;
		}
		
		public function rect(x:Number, y:Number, width:Number, height:Number):void
		{
			_rect = new Rectangle(x, y, width, height);
			dirty=true;
		}
		
		public function strokeRect(x:Number,y:Number,width:Number,height:Number):void
		{
			_rect=new Rectangle(x,y,width,height);
		}
		
		public function circle(x:Number,y:Number,r:Number,edges:Number,color:uint,borderWidth:int,borderColor:*):void
		{
			var geo:BasePoly;
			geomatrys.push(_curGeomatry=geo=new Circle(x,y,r,edges,color,borderWidth,borderColor));
			if(borderColor==undefined)geo.borderWidth=0;
		}
		
		public function fan(x:Number,y:Number,r:Number,r0:Number,r1:Number,color:uint,borderWidth:int,borderColor:Number):void
		{
			var geo:BasePoly;
			geomatrys.push(_curGeomatry=geo=new Fan(x,y,r,r0,r1,color,borderWidth,borderColor));
		}
		
		public function ellipse(x:Number,y:Number,rw:Number,rh:Number,color:uint,borderWidth:int,borderColor:Number):void
		{
			geomatrys.push(_curGeomatry=new Ellipse(x,y,rw,rh,color,borderWidth,borderColor));
		}
		
		public function polygon(x:Number,y:Number,points:Array,color:uint,borderWidth:int,borderColor:*):void
		{
			var geo:BasePoly;
			geomatrys.push(_curGeomatry=geo=new Polygon(x,y,points,color,borderWidth,borderColor));
			if(!color)geo.fill=false; if(borderColor==undefined)geo.borderWidth=0;
		}
		
		public function loopLine(x:Number,y:Number,points:Array,width:Number,color:uint):void
		{
			var geo:LoopLine;
			geomatrys.push(_curGeomatry=geo=new LoopLine(x,y,points,width,color));
			geo.fill = false;
		}
		
		public function drawPath(x:Number,y:Number,points:Array,color:uint,borderWidth:int):void
		{
			geomatrys.push(_curGeomatry=new Line(x,y,points,color,borderWidth));
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
			this.count = (ib.length - si) / 2;
		}
		
		public function sector(x:Number,y:Number,rW:Number,rH:Number):void
		{
			
		}
		
		public function roundRect(x:Number,y:Number,w:Number,h:Number,rW:Number,rH:Number):void
		{
			
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