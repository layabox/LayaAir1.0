package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer;

	public class Fan extends BasePoly
	{
		public function Fan(x:Number, y:Number,r:Number,r0:Number,r1:Number,color:uint, borderWidth:int, borderColor:uint, round:uint=0)
		{
//			only odd number edges for fan; 
			super(x, y, r, r, 30, color, borderWidth, borderColor, round);
			this.r0=r0;
			this.r1=r1;
		}		
		
		override public function getData(ib:Buffer,vb:Buffer,start:int):void
		{
			//borderWidth=0;
			var indices:Array=[];
			var verts:Array=[];
			sector(verts,indices,start);
			
			if(fill)
			{
				(borderWidth>0)&&(borderColor!=-1)&&createFanLine(verts,indices,borderWidth,start+verts.length/5,null,null);
				ib.append(new Uint16Array(indices));
				vb.append(new Float32Array(verts));
			}
			else
			{
				var outV:Array=[];
				var outI:Array=[];
				(borderColor!=-1)&&(borderWidth>0)&&createFanLine(verts,indices,borderWidth,start,outV,outI);
				ib.append(new Uint16Array(outI));
				vb.append(new Float32Array(outV));
			}
			
			//(borderWidth>0)&&createFanLine(verts,indices,borderWidth,start+verts.length/5);
			
			
			//			下面方法用来测试边儿
			//			var outVertex:Array=[];
			//			var outIndex:Array=[];
			//			createLine(verts,indices,40,0,outVertex,outIndex);
			//			ib.append(new Uint16Array(outIndex));
			//			vb.append(new Float32Array(outVertex));
		}
			
	}
}