package vox {
	/**
	 * 包含若干条光线的球
	 */
	public class VoxelLightSphere {
		
		public var rays:Vector.<VoxelLightRay>=new Vector.<VoxelLightRay>();	// 这是一个n条光线的数组。
		public var rayNum:int = 0;
		public var raysContrib:Array = new Array(6); 	//采样线对各个面的贡献
		
		public function VoxelLightSphere(rayNum:int, radius:int):void {
			raysContrib.fill(0);
			this.rayNum = rayNum;
			var rayends:Array = pointsOnSphere(rayNum, radius);
			var ri:int=0, x:Number, y:Number, z:Number;
			for ( var i = 0; i < rayNum; i++) {
				x = rayends[ri++];
				y = rayends[ri++];
				z = rayends[ri++];
				var ray:VoxelLightRay = VoxelLightRay.creatLightLine(x | 0, y | 0, z | 0);
				rays.push( ray );
				for (var fi:int = 0; fi < 6; fi++) {
					raysContrib[fi] += ray.faceLight[fi];
				}
			}
		}
		
		/**
		 * http://www.softimageblog.com/archives/115
		 * 返回球上均匀分布的点
		 * @param	num		采样点的个数
		 * @param	radius
		 * @return  返回一个包含xyz的数组
		 */
		public function pointsOnSphere(num:uint, radius:Number=1.0 ) :Array{
			var pts:Array, inc:Number, off:Number, i:uint, y:Number, r:Number, phi:Number;
			pts = new Array( num*3 );
			inc = Math.PI * ( 3 - Math.sqrt( 5 ) );
			off = 2 / num;
			i	= num;
			for ( i = 0; i < num; i++){
				y = i*off - 1 + ( off / 2 );
				r = Math.sqrt( 1 - y*y );
				phi = i * inc;
				pts[i * 3] = Math.cos( phi ) * r * radius;
				pts[i * 3 + 1] = y * radius;
				pts[i * 3 + 2] = Math.sin( phi ) * r * radius ;
			}
			return pts;
		}		
	}
}	