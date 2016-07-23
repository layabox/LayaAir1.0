package laya.d3.graphics {
	import laya.d3.core.material.Material;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * <code>StaticBatchManager</code> 类用于创建静态批处理管理员。
	 */
	public class StaticBatchManager {
		private static var maxVertexDeclaration:int = 1000;//需在顶点定义类中加异常判断警告
		private static var maxMaterialCount:int = Math.floor(2147483647 / 1000);//需在材质中加异常判断警告
		
		private var _keys:Vector.<int>;
		private var _useFPS:Vector.<int>;
		private var _staticBatchs:Vector.<StaticBatch>;
		
		public function StaticBatchManager() {
			_keys = new Vector.<int>();
			_useFPS = new Vector.<int>();
			_staticBatchs = new Vector.<StaticBatch>();
		}
		
		public function getStaticBatchQneue(_vertexDeclaration:VertexDeclaration, material:Material):StaticBatch {
			var staticBatch:StaticBatch;
			var key:int = material.id * VertexDeclaration._maxVertexDeclarationBit + _vertexDeclaration.id;
			
			if (_keys.indexOf(key) === -1) {
				_keys.push(key);
				_useFPS.push(Stat.loopCount);
				
				staticBatch = new StaticBatch(_vertexDeclaration, material);
				_staticBatchs.push(staticBatch);
			} else {
				var index:int = _keys.indexOf(key);
				_useFPS[index] = Stat.loopCount;
				
				staticBatch = _staticBatchs[index];
			}
			
			return staticBatch;
		}
		
		/** @private 通常应在所有getStaticBatchQneue函数相关操作结束后执行,不必逐帧执行。*/
		public function _garbageCollection():void {
			for (var i:int = 0; i < _keys.length; i++) {
				if (_useFPS[i] < Stat.loopCount) {
					_keys.splice(i, 1);
					_useFPS.splice(i, 1);
					_staticBatchs.splice(i, 1);
					i--;
				}
			}
		}
		
		/**重置*/
		public function _reset():void {
			for (var i:int = 0; i < _keys.length; i++) {
				_staticBatchs[i]._reset();
			}
		}
		
		/**刷新*/
		public function _finsh():void {
			for (var i:int = 0; i < _keys.length; i++) {
				_staticBatchs[i]._finsh();
			}
		}
		
		public function dispose():void {
			_keys.length = 0;
			_useFPS.length = 0;
			_staticBatchs.length = 0;
		}
	
	}

}