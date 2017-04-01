package laya.utils {
	import laya.renders.Render;
	import laya.utils.CacheManger;
	import laya.utils.Utils;
	
	/**
	 * @private
	 */
	public class VectorGraphManager {
		
		public static var instance:VectorGraphManager;
		
		public var useDic:Object = {};
		public var shapeDic:Object = {};
		public var shapeLineDic:Object = {};
		
		private var _id:uint = 0;
		private var _checkKey:Boolean = false;
		private var _freeIdArray:Array = [];
		
		public function VectorGraphManager() {
			if (Render.isWebGL) {
				CacheManger.regCacheByFunction(Utils.bind(this.startDispose, this), Utils.bind(this.getCacheList, this));
			}
		}
		
		public static function getInstance():VectorGraphManager {
			return instance ||= new VectorGraphManager();
		}
		
		/**
		 * 得到个空闲的ID
		 * @return
		 */
		public function getId():uint {
			//if (_freeIdArray.length > 0) {
				//return _freeIdArray.pop();
			//}
			return _id++;
		}
		
		/**
		 * 添加一个图形到列表中
		 * @param	id
		 * @param	shape
		 */
		public function addShape(id:int, shape:*):void {
			shapeDic[id] = shape;
			if (!useDic[id]) {
				useDic[id] = true;
			}
		}
		
		/**
		 * 添加一个线图形到列表中
		 * @param	id
		 * @param	Line
		 */
		public function addLine(id:int, Line:*):void {
			shapeLineDic[id] = Line;
			if (!shapeLineDic[id]) {
				shapeLineDic[id] = true;
			}
		}
		
		/**
		 * 检测一个对象是否在使用中
		 * @param	id
		 */
		public function getShape(id:int):void {
			if (_checkKey) {
				if (useDic[id] != null) {
					useDic[id] = true;
				}
			}
		}
		
		/**
		 * 删除一个图形对象
		 * @param	id
		 */
		public function deleteShape(id:int):void {
			if (shapeDic[id]) {
				shapeDic[id] = null;
				delete shapeDic[id];
			}
			if (shapeLineDic[id]) {
				shapeLineDic[id] = null;
				delete shapeLineDic[id];
			}
			if (useDic[id] != null) {
				delete useDic[id];
			}
			//_freeIdArray.push(id);
		}
		
		/**
		 * 得到缓存列表
		 * @return
		 */
		public function getCacheList():Array {
			var str:*;
			var list:Array = [];
			for (str in shapeDic) {
				list.push(shapeDic[str]);
			}
			for (str in shapeLineDic) {
				list.push(shapeLineDic[str]);
			}
			return list;
		}
		
		/**
		 * 开始清理状态，准备销毁
		 */
		public function startDispose(key:Boolean):void {
			var str:*;
			for (str in useDic) {
				useDic[str] = false;
			}
			_checkKey = true;
		}
		
		/**
		 * 确认销毁
		 */
		public function endDispose():void {
			if (_checkKey) {
				var str:*;
				for (str in useDic) {
					if (!useDic[str]) {
						deleteShape(str);
					}
				}
				_checkKey = false;
			}
		
		}
	
	}

}