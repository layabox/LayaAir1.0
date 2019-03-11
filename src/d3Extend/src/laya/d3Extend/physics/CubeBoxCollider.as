package laya.d3Extend.physics {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3Extend.Cube.CubeMap;
	import laya.d3Extend.worldMaker.CubeInfoArray;
	/**
	 * ...
	 * @author ...
	 */
	public class CubeBoxCollider extends CubePhysicsCompnent {
		
		//这些描述包围盒的数据都是物体模型坐标
		/** @private 长*/
		private var _length:int;
		/** @private 宽*/
		private var _width:int;
		/** @private 高*/
		private var _height:int;
		/** @private 后下左角*/
		private var _minPoint:Vector3 = new Vector3();
		/** @private 前上右角*/
		private var _maxPoint:Vector3 = new Vector3();
		/** @private 前上右角*/
		private var _centerPoint:Vector3 = new Vector3();
		/** @private 模型OBB包围盒点*/
		public var OBBPointList:Vector.<Vector3> = new Vector.<Vector3>();
		/** @private 世界OBB包围盒点*/
		public var OBBWorldPointList:Vector.<Vector3> = new Vector.<Vector3>();
		/** @private 来一个用来优化的最长距离世界坐标中*/
		public var maxlength:int;
		/** @private 盒世界坐标的中心点*/
		public var centerPoint:Vector3 = new Vector3();
		/** @private 用来算在cubemap中的值，是一个cubeArray*/
		private var _cubemapArray:CubeInfoArray = new CubeInfoArray();
		/**@private 计算一个面的值需要两个vector来记录斜率  还要两个点来记录值*/
		private var _xieLv1:Vector3 = new Vector3();
		private var _xielv2:Vector3 = new Vector3();
		private var _jilu1:Vector3 = new Vector3();
		private var _jilu2:Vector3 = new Vector3();
		
		
		/**
		 * 获得本身的Sprite3D 和模型矩阵
		 */
		public function CubeBoxCollider(centerpoint:Vector3,length:int,width:int,height:int) {
			_sprite3D = owner as Sprite3D;
			_localmatrix4x4 = _sprite3D.transform.localMatrix;
			_worldMatrix4x4 = _sprite3D.transform.worldMatrix;
			OBBPointList.length = 8;
			_length = length;
			_width = width;
			_height = height;
			_centerPoint = minPoint;
			calOBB();
		}
		
		
		
		
		/**
		 * 碰撞检测
		 */
		public function isCollision(other:CubePhysicsCompnent):Boolean {
			switch(other.type)
			{
				case 0:
					return boxAndBox(other);
					break;
				case 1:
					return boxAndShpere(other);
					break;
				case 2:
					return boxAndCube(other);
					break;
				default:
					return false;
			}
		}
		
		
	
		/**
		 * 计算OBB包围盒
		 */
		public function calOBB():void{
			_minPoint.x = _centerPoint.x - _length / 2;
			_minPoint.y = _centerPoint.y - _height / 2;
			_minPoint.z = _centerPoint.z - _width / 2;
			_maxPoint.x = _minPoint.x + _length;
			_maxPoint.y = _minPoint.y + _height;
			_maxPoint.z = _minPoint.z + _width;
			OBBPointList[0] = _minPoint;
			OBBPointList[1].setValue(_maxPoint.x, _minPoint.y, _minPoint.z);
			OBBPointList[2].setValue(_maxPoint.x, _maxPoint.y, _minPoint.z);
			OBBPointList[3].setValue(_minPoint.x, _maxPoint.y, _minPoint.z);
			OBBPointList[4].setValue(_minPoint.x, _minPoint.y, _maxPoint.z);
			OBBPointList[5].setValue(_maxPoint.x, _minPoint.y, _maxPoint.z);
			OBBPointList[6] = _maxPoint;
			OBBPointList[7].setValue(_minPoint.x, _maxPoint.y, _maxPoint.z);
			calmaxLength();
		}
		
		/**
		 * 移动后更新矩阵，计算世界OBB包围盒的点
		 */
		public function updataMatriex():void
		{
			
			for (var i:int = 0; i < 8; i++) {
				Vector3.transformV3ToV3(OBBPointList[i],_worldMatrix4x4,OBBWorldPointList[i]);
			}
		}
		
		/**
		 * 重新确定包围盒
		 */
		public function resetOBB(centerPoint:Vector3, length:int, width:int, height:int):void
		{
			_centerPoint = centerPoint;
			_length = length;
			_width = width;
			_height = height;
			calOBB();
		}
		
		/**
		 * 计算盒和球
		 */
		public function boxAndSphere(other:CubeSphereCollider):Boolean
		{
			var distance:int = Vector3.distance(other.worldCenter, centerPoint);
			if (distance > (other.worldradius + maxlength))
			{
				return false;
			}
			//检测球盒
			Vector3.transformV3ToV3(other.worldCenter, _localmatrix4x4, _vector3);
			var vec:Vector3 = _sprite3D.transform.scale;
			var thisradius:int = other.worldradius / Math.max(vec.x, vec.y, vec.z);
			//判断是否在xy平面合格
			if (_vector3.x > (_minPoint.x-thisradius) && _vector3.x < (_maxPoint.x+thisradius) && _vector3.y > (_minPoint.y-thisradius) && _vector3.y < (_maxPoint.y+thisradius))
			{
				//看长度
				var xylen:int = Math.sqrt((_length / 2) * (_length / 2) + (_height / 2) * (_height / 2)) + thisradius;
				var lx:int = Math.abs(_vector3.x - _centerPoint.x);
				var ly:int = Math.abs(_vector3.y - _centerPoint.y);
				var currentlen:int = Math.sqrt(lx * lx + ly * ly);
				if (currentlen <= xylen)
				{
					if (_vector3.z > (_minPoint.z - thisradius) && _vector3.z < (_maxPoint.z + thisradius))
					{
						var yzlen:int = Math.sqrt((_width / 2) * (_width / 2) + (_height / 2) * (_height / 2)) + thisradius;
						var lz:int = Math.abs(_vector3.z - _centerPoint.z);
						var currentlen2:int = Math.sqrt(ly * ly + lz * lz);
						if (currentlen2 <= yzlen)
						{
							return true;
						}	
					}
					
				}
			}
				
			return false;
			
		}
		
		/**
		 * 计算盒和盒
		 */
		public function boxAndBox(other:CubeBoxCollider):Boolean
		{
			var distance:int = Vector3.distance(other.centerPoint, centerPoint);
			if (distance > (other.maxlength + maxlength))
			{
				return false;
			}
			var otherOBBWorldPointList:Vector.<Vector3> = other.OBBWorldPointList;
			for (var i:int = 0; i < 8; i++) {
				Vector3.transformV3ToV3(otherOBBWorldPointList[0], _localmatrix4x4, _vector3);
				if (pointContion(_vector3))
				{
					return true
				}
			}
			return false;
		}
		/**
		 * 判断点是否在盒子里
		 * 
		 */
		public function pointContion(point:Vector3):Boolean
		{
			if (point.x > _maxPoint.x && point.x < _minPoint.x) return false;
			if (point.y > _maxPoint.y && point.y < _minPoint.y) return false;
			if (point.z > _maxPoint.z && point.z < _minPoint.z) return false;
			return true;
		}
		
		/**
		 * 计算盒和建筑Cube
		 */
		public function boxAndCube(other:CubeEditCubeCollider):Boolean
		{
			var cubemap:CubeMap = other.cubemap;
			//根据三个点来确定一个网，然后确定六个面的网，
			calUpdataCubeMap();
			
			var arrayint:Vector.<int> = _cubemapArray.PositionArray;
			var length:int = arrayint.length;
			for (var l:int = 0; l <length; l+=3) {
				var cubeinfo:CubeInfo = cubemap.find(arrayint[l],arrayint[l+1],arrayint[l+2]);
				if (cubeinfo && cubeinfo.subCube) {
					return true;
			} 
			
			return false;

			
		}
		
		//计算最长距离
		private var _vector3:Vector3 = new Vector3();
		/**
		 * 计算最长距离
		 */
		public function calmaxLength():void
		{			
			maxlength =Vector3.distance(OBBWorldPointList[6], OBBWorldPointList[0], _vector3);
			Vector3.transformV3ToV3( _centerPoint, _worldMatrix4x4, centerPoint);
		}
		
		/**
		 * 根据八个点来计算Cubemap里面的值
		 * 
		 */
		public function calUpdataCubeMap():void
		{
			_cubemapArray.PositionArray.length = 0;
			calOneFaceCubeMap(OBBWorldPointList[7], OBBWorldPointList[4], OBBWorldPointList[5]);
			calOneFaceCubeMap(OBBWorldPointList[3], OBBWorldPointList[7], OBBWorldPointList[6]);
			calOneFaceCubeMap(OBBWorldPointList[6], OBBWorldPointList[5], OBBWorldPointList[1]);
			calOneFaceCubeMap(OBBWorldPointList[3], OBBWorldPointList[0], OBBWorldPointList[4]);
			calOneFaceCubeMap(OBBWorldPointList[2], OBBWorldPointList[1], OBBWorldPointList[0]);
			calOneFaceCubeMap(OBBWorldPointList[0], OBBWorldPointList[4], OBBWorldPointList[5]);
			
		}
		/**
		 * 根据三个点来计算一个面的粗笨值
		 */
		public function calOneFaceCubeMap(point1:Vector3,point2:Vector3,point3:Vector3):void
		{
			Vector3.subtract(point1, point2, _xieLv1);
			Vector3.subtract(point2, point3, _xielv2);
			var xie1:int = Math.ceil(Math.max(_xieLv1.x, _xieLv1.y, _xieLv1.z));
			var xie2:int = Math.ceil(Math.max(_xielv2.x, _xielv2.y, _xielv2.z));
			point2.cloneTo(_jilu1);
			point3.cloneTo(_jilu2);
			_xieLv1.setValue(_xieLv1.x / xie1, _xieLv1.y / xie1, _xieLv1.z / xie1);
			_xielv2.setValue(_xielv2.x / xie2, _xielv2.x / xie2, _xielv2.z / xie2);
			for (var i:int = 0; i < xie1; i++) {
				_jilu1.setValue(Math.floor(_jilu1.x + i * _xieLv1.x),Math.floor( _jilu1.y + i * _xieLv1.y),Math.floor( _jilu1.z + i * _xieLv1.z));				
				for (var j:int = 0; j < xie2 ; j++) {
					_cubemapArray.PositionArray.push((_jilu1.x+j*_xielv2.x),(_jilu1.y+j*_xielv2.y),(_jilu1.z+_xielv2.z*j));
				}
			}	
		}
	}

}