package worldMaker {
	public class HermitSpline {
		
		public function HermitSpline(){
		}
		

		/**
		 * 二维hermit插值。返回一个差值后的数组。
		 * 
		 * @param val 
		 * @param seg  分多少段。最少为2
		 * @param close 
		 */
		public static function inerp(val:Array, seg:Number, close:Boolean):Array{
			if(seg==0)
				return val;
			var ptnum:int = val.length/2;
			if(ptnum<2){
				throw 'hermit interp error';
			}
			var ret:Array = [];
			var dt:Number = 1.0/seg;
			//如果只有两个点，则只能用线性插值
			if(ptnum==2){
				ret.push(val[0],val[1]);//x0
				var t:Number = 0;
				for( i=0; i<seg-1; i++){
					t+= dt;
					dx = val[2]-val[0];
					dy = val[3]-val[1];

					ret.push(val[0]+dx*t, val[1]+dy*t);
				}
				ret.push(val[2],val[3]);//x1
			}
			//下面是曲线插值
			//先计算每个点的切线
			var vti:int=0;
			var vertT:Array = new Array(val.length);
			//第一个点
			var dx:Number=0,dy:Number=0;
			if(close){
				dx = val[2]-val[val.length-2];
				dy = val[3]-val[val.length-1];
				
			}else{
				dx = val[2]-val[0];
				dy = val[3]-val[1];
			}

				vertT[vti++] = dx;
				vertT[vti++] = dy;

			//中间的点
			for( var vi:int=1; vi<ptnum-1; vi++){
				var prei:int = (vi-1)*2;
				var nexi:int = (vi+1)*2;
				dx = val[nexi]-val[prei];
				dy = val[nexi+1] - val[prei+1];

					vertT[vti++] = dx;
					vertT[vti++] = dy;
			}

			//最后的点
			if(close){
				dx = val[0] - val[val.length-4];
				dy = val[1] - val[val.length-3];
			}else{
				//直线扩展。朝向是上一个点指向这个点
				dx = val[val.length-2] - val[val.length-4];
				dy = val[val.length-1] - val[val.length-3];
			}
				vertT[vti++] = dx;
				vertT[vti++] = dy;

			//插值
			var hermiti:hermit_interp = new hermit_interp(0,0,0,0,0,0,0,0);
			var num:int = ptnum-1; 
			if(close)num++;
			for(var i:int=0; i<num; i++){
				var p:int = i*2;
				//先加入本段的起点
				ret.push(val[p], val[p+1]);

				//再加入插值点。
				hermiti.x0 = val[p]; hermiti.y0=val[p+1]; hermiti.x1=val[(p+2)%val.length]; hermiti.y1=val[(p+3)%val.length];
				hermiti.tx0=vertT[p]; hermiti.ty0=vertT[p+1]; hermiti.tx1=vertT[(p+2)%val.length]; hermiti.ty1=vertT[(p+3)%val.length];

				t=dt;
				for( var ii:int=0; ii<seg-1; ii++){
					hermiti.getV(t);
					t+=dt;
					ret.push(hermiti.ox);
					ret.push(hermiti.oy);
				}
				//终点不加，因为在每段的开始的时候加入的。
			}
			//最后一个点
			if(!close){
				ret.push(val[val.length-2], val[val.length-1]);
			}
			return ret;
		}
		
	}
}

class hermit_interp{
    public var x0:Number=0;
    public var y0:Number=0;
    public var x1:Number=1;
    public var y1:Number=0;
    public var tx0:Number=1;
    public var ty0:Number=0;
    public var tx1:Number=1;
    public var ty1:Number=0;
    public var ox:Number=0;
    public var oy:Number=0;
    /**
     * 如果是三维的，可以分别用 xz,yz来计算
     * @param x0 
     * @param y0 
     * @param x1 
     * @param y1 
     * @param tx0  起点部分的tangent，不但有方向，还要有大小。
     * @param ty0 
     * @param tx1  终点部分的tangent，不但有方向，还要有大小。表示离开终点的方向和速度
     * @param ty1 
     */
    public function hermit_interp(x0:Number,y0:Number,x1:Number,y1:Number,tx0:Number,ty0:Number,tx1:Number,ty1:Number){
        this.x0=x0; this.y0=y0;
        this.x1=x1; this.y1=y1;
        
        this.tx0=tx0; this.ty0=ty0;
        this.tx1=tx1; this.ty1=ty1;
    }

    /**
     * 
     * @param t 0则在p0点，1则在p1点
     * 现在是xy都计算，如果引入时间维的话，是否可以减少计算量
     */
    public function getV(t:Number):void{
        var t2:Number = t*t;
        var t3:Number = t*t2;
        var h1:Number = 2.0*t3 - 3.0*t2 +1.0;
        var h2:Number = -2.0*t3 + 3.0*t2;
        var h3:Number = t3-2.0*t2+t;
        var h4:Number = t3-t2;
        //h1*P1+h2*P2 + h3*T1 + h4*T2
        this.ox = this.x0*h1 + this.x1*h2 + this.tx0*h3 + this.tx1*h4;
        this.oy = this.y0*h1 + this.y1*h2 + this.ty0*h3 + this.ty1*h4;
    }
}
