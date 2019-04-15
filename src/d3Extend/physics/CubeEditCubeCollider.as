package physics {
	import Cube.CubeMap;
	import laya.d3.math.Vector3;
	import laya.d3Extend.Cube.CubeInfo;
	import laya.d3Extend.worldMaker.CubeInfoArray;


	/**
	 * ...
	 * @author ...
	 */
	public class CubeEditCubeCollider extends CubePhysicsCompnent{
		//静不静态
		public var data:Object = {};
		public function CubeEditCubeCollider() {
		
		}
		
		  override public function onAwake():void {
			super.onAwake();
			this.type = CubePhysicsCompnent.TYPE_CUBESPRIT3D;
		  }


		public function dataAdd(x:int, y:int, z:int):void
		{
			var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			var o:* = data[key] || (data[key] = {});
			o[x % 32 + ((y % 32) << 8) + ((z % 32) << 16)] = true;
		}
		public function find(x:int, y:int, z:int):Boolean
		{
			var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			var o:*= data[key];
			if (o)
			{
				if (o[x % 32 + ((y % 32) << 8) + ((z % 32) << 16)])
				{
					return true;
				}
			}
			return false;
		}
		public function clear():void
		{
			for (var i:String in data)
			{
				data[i] = {};
			}
		}
		public function InitCubemap(cubemap:CubeMap,cubeMeshManager:CubeMeshManager):void
		{
			var vector:Vector3 = cubeMeshManager.transform.position;
			var cubeinfos:Vector.<CubeInfo>  = cubemap.returnAllCube();
			for (var i:int = 0, n:int = cubeinfos.length; i <n ; i++) {
				dataAdd(cubeinfos[i].x+vector.x, cubeinfos[i].y+vector.y, cubeinfos[i].z+vector.z);
			}
			
		}
		public function InitCubeInfoArray(cubeinfoArray:CubeInfoArray):void
		{
			var lenth:int = cubeinfoArray.PositionArray.length / 3;
			var PositionArray:Vector.<int> = cubeInfoArray.PositionArray;
			cubeInfoArray.currentColorindex = 0;
			cubeInfoArray.currentPosindex = 0;
			for (var i:int = 0; i < lenth; i++) {
				var x:int = PositionArray[cubeInfoArray.currentPosindex] + cubeInfoArray.dx+1600;
				var y:int = PositionArray[cubeInfoArray.currentPosindex + 1] + cubeInfoArray.dy+1600;
				var z:int = PositionArray[cubeInfoArray.currentPosindex + 2] + cubeInfoArray.dz+1600;
				var color:int = cubeInfoArray.colorArray[cubeInfoArray.currentColorindex];
				cubeInfoArray.currentPosindex += 3;
				cubeInfoArray.currentColorindex++;
				dataAdd(x, y, z);
			}
		}
		
		 /**
     * 碰撞检测
     */
    override public function isCollision(other:CubePhysicsCompnent):int {
        switch (other.type) {
            case 0:
                return (other as CubeBoxCollider).boxAndCube(this);
                break;
            case 1:
                return (other as CubeSphereCollider).sphereAndCube(this);
                break;
            case 2:
                return 999;
                break;
            default:
                return 999;
        }

    }
	

		
	}

}