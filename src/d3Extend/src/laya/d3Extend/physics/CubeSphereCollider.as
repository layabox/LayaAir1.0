package laya.d3Extend.physics {
	import laya.d3.math.Vector3;
	import laya.d3Extend.Cube.CubeInfo;
	import laya.d3Extend.Cube.CubeMap;
	import laya.d3Extend.worldMaker.CubeInfoArray;
	/**
	 * ...
	 * @author ...
	 */
	public class CubeSphereCollider extends CubePhysicsCompnent{
		
		/** @private 包围球中点*/
		private var _center:Vector3 = new Vector3();
		/** @private 包围球半径*/
		private var _radius :int;
		/** @private 世界中心点的位置*/
		public var worldCenter:Vector3 = new Vector3();
		/** @private 缩放*/
		public var worldradius:int;
		/** @private 用来算在cubemap中的值，是一个cubeArray*/
		private var _cubemapArray:CubeInfoArray = new CubeInfoArray();
		
		
		public function CubeSphereCollider(center:Vector3, radius:int) {
			_sprite3D = owner as Sprite3D;
			_localmatrix4x4 = _sprite3D.transform.localMatrix;
			_worldMatrix4x4 = _sprite3D.transform.worldMatrix;
			_center = center;
			_radius = radius;
			
			
		}
		
		
		/**
		 * 判断是否碰撞
		 */
		override public function isCollision(other:CubePhysicsCompnent):Boolean {
			switch(other._type)
			{
				case 0:
					sphereAndBox();
					break;
				case 1:
					sphereAndShpere();
					break;
				case 2:
					sphereAndCube();
					break;
				default:
					false;
					
			}	
		}
		
		//计算最长距离
		private var _vector3:Vector3 = new Vector3();
		/**
		 * 计算球和球
		 */
		public function sphereAndShpere(other:CubeSphereCollider):Boolean
		{
			//计算两个中心点的距离
			var length = Vector3.distance(worldCenter, other.worldCenter);
			if (length > worldradius + other.worldradius)
			{
				return false;
			}
			else
			{
				return true;
			}
			
		}
		
		/**
		 * 计算球和Box
		 */
		public function sphereAndBox(other:CubeBoxCollider):Boolean
		{
			other.boxAndSphere(this);
		}
		
		/**
		 * 计算球和建筑Cube
		 */
		public function sphereAndCube(other:CubeEditCubeCollider):Boolean
		{
			_cubemapArray.PositionArray.length = 0;
			var arrayint:Vector.<int> = _cubemapArray.PositionArray;
			var cubemap:CubeMap = other.cubeMap;
			//根据中心点和半径来确定一个球网
			var minx:int = Math.ceil(worldCenter.x - worldradius);
			var maxx:int = Math.ceil(worldCenter.x + worldradius);
			var miny:int = Math.ceil(worldCenter.y - worldradius);
			var maxy:int = Math.ceil(worldCenter.y + worldradius);
			var minz:int = Math.ceil(worldCenter.z - worldradius);
			var maxz:int = Math.ceil(worldCenter.z + worldradius);
			var ix:int;
			var iy:int;
			var iz:int;
			for (var i:int = minx; i < maxx; i++) {
				ix = Math.abs(i - worldCenter.x);
				for (var j:int = miny; j <maxy ; j++) {
					iy = Math.abs(j - worldCenter.x);
					for (var k:int = minz; k < maxz; k++) {
						iz = Math.abs(k -worldCenter.z );
						if ( Math.sqrt((ix + 0.5) * (ix + 0.5) + (iy + 0.5) * (iy + 0.5) + (iz + 0.5) * (iz + 0.5)) < worldradius)
						{
							arrayint.push(i+1600, j+1600, k+1600);
						}
					}
				}
				
			}
			var length:int = arrayint.length;
			for (var l:int = 0; l <length; l+=3) {
				var cubeinfo:CubeInfo = cubemap.find(arrayint[l],arrayint[l+1],arrayint[l+2]);
				if (cubeinfo && cubeinfo.subCube) {
					return true;
			} 
			
			return false;
			
		}
		
		/**
		 * 计算世界坐标中的半径
		 */
		public function updataMatriex():void
		{
			var vec:Vector3 = _sprite3D.transform.scale;
			var maxscale = Math.max(vec.x, vec.y, vec.z);
			worldradius = _radius*maxscale;
			Vector3.transformV3ToV3(_center, _worldMatrix4x4, worldCenter);
		}
		public function resetCollision(center:Vector3, radius:int)
		{
			_center = center;
			_radius = radius;
			calworldradius();
		}
		
	}

}