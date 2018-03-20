package laya.d3.utils {
	import laya.d3.component.Script;
	import laya.d3.component.physics.Collider;
	import laya.d3.core.Layer;
	import laya.d3.math.ContainmentType;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>CollsionManager</code> 类用于碰撞管理器。
	 */
	public class CollisionManager extends EventDispatcher {
		/**
		 *@private
		 */
		private static function _onTrigger(rigidCol:Collider, receiveCol:Collider, rigidScripts:Vector.<Script>, receiveScripts:Vector.<Script>, bothRigid:Boolean):void {
			var i:int, n:int;
			var rigidID:int = rigidCol.id;
			var receiveID:int = receiveCol.id;
			if (!rigidCol._ignoreCollisonMap[receiveID]) {
				var colMan:CollisionManager = Physics.collisionManager;
				var needTest:*/*Boolean*/ = rigidCol._runtimeCollisonTestMap[receiveID];
				if (needTest != null) {
					if (needTest) {
						if (rigidCol._collisonTo(receiveCol)) {
							if (rigidCol._runtimeCollisonMap[receiveID]) {
								for (i = 0, n = rigidScripts.length; i < n; i++)
									rigidScripts[i].onTriggerStay(receiveCol);
								for (i = 0, n = receiveScripts.length; i < n; i++)
									receiveScripts[i].onTriggerStay(rigidCol);
								colMan.event(Event.TRIGGER_STAY, [rigidCol, receiveCol]);
							} else {
								rigidCol._runtimeCollisonMap[receiveID] = receiveCol;
								rigidCol._runtimeCollisonTestMap[receiveID] = false;
								receiveCol._runtimeCollisonMap[rigidID] = rigidCol;
								if (bothRigid)
									receiveCol._runtimeCollisonTestMap[rigidID] = false;
								for (i = 0, n = rigidScripts.length; i < n; i++)
									rigidScripts[i].onTriggerEnter(receiveCol);
								for (i = 0, n = receiveScripts.length; i < n; i++)
									receiveScripts[i].onTriggerEnter(rigidCol);
								colMan.event(Event.TRIGGER_ENTER, [rigidCol, receiveCol]);
							}
						} else {
							var rigidMap:Object = rigidCol._runtimeCollisonMap;
							if (rigidMap[receiveID]) {
								delete rigidMap[receiveID];
								delete rigidCol._runtimeCollisonTestMap[receiveID];
								delete receiveCol._runtimeCollisonMap[rigidID];
								if (bothRigid)
									delete receiveCol._runtimeCollisonTestMap[rigidID];
								
								for (i = 0, n = rigidScripts.length; i < n; i++)
									rigidScripts[i].onTriggerExit(receiveCol);
								for (i = 0, n = receiveScripts.length; i < n; i++)
									receiveScripts[i].onTriggerExit(rigidCol);
								colMan.event(Event.TRIGGER_EXIT, [rigidCol, receiveCol]);
							}
						}
					} else {
						for (i = 0, n = rigidScripts.length; i < n; i++)
							rigidScripts[i].onTriggerStay(receiveCol);
						for (i = 0, n = receiveScripts.length; i < n; i++)
							receiveScripts[i].onTriggerStay(rigidCol);
						colMan.event(Event.TRIGGER_STAY, [rigidCol, receiveCol]);
					}
				} else {
					if (rigidCol._collisonTo(receiveCol)) {
						rigidCol._runtimeCollisonMap[receiveID] = receiveCol;
						rigidCol._runtimeCollisonTestMap[receiveID] = false;
						receiveCol._runtimeCollisonMap[rigidID] = rigidCol;
						if (bothRigid)
							receiveCol._runtimeCollisonTestMap[rigidID] = false;
						
						for (i = 0, n = rigidScripts.length; i < n; i++)
							rigidScripts[i].onTriggerEnter(receiveCol);
						for (i = 0, n = receiveScripts.length; i < n; i++)
							receiveScripts[i].onTriggerEnter(rigidCol);
						colMan.event(Event.TRIGGER_ENTER, [rigidCol, receiveCol]);
					}
				}
			}
		}
		
		/**
		 *@private
		 */
		public static function _triggerCollision():void {
			var colList:Vector.<int> = Layer._collsionTestList;
			var colCount:int = colList.length;
			var colMat:Array = Physics._layerCollsionMatrix;
			for (var i:int = 0; i < colCount; i++) {
				var row:int = colList[i];
				var rowLayer:Layer = Layer.getLayerByNumber(row);
				var rowColliders:Vector.<Collider> = rowLayer._colliders;
				var rowRigOffset:int = rowLayer._nonRigidbodyOffset;
				for (var j:int = colCount - 1; j >= i; j--) {
					var col:int = colList[j];
					var test:Boolean = colMat[row][(Layer.maxCount - 1) - col];
					if (test) {
						var k:int, c:int, x:int, z:int;
						var rowCol:Collider, colCol:Collider, rowScripts:Vector.<Script>;
						var colLayer:Layer = Layer.getLayerByNumber(col);
						var colColliders:Vector.<Collider> = colLayer._colliders;
						var colRigOffset:int = colLayer._nonRigidbodyOffset;
						if (rowLayer !== colLayer) {
							for (k = 0; k < rowRigOffset; k++) {
								rowCol = rowColliders[k];
								if (rowCol.enable) {
									rowScripts = rowCol.owner._scripts;
									for (x = 0, z = colRigOffset; x < z; x++) {
										colCol = colColliders[x];
										(colCol.enable) && (_onTrigger(rowCol, colCol, rowScripts, colCol.owner._scripts, true));//rigidbody is rowCol、colCol
									}
									for (x = colRigOffset, z = colColliders.length; x < z; x++) {
										colCol = colColliders[x];
										(colCol.enable) && (_onTrigger(rowCol, colCol, rowScripts, colCol.owner._scripts, false));//rigidbody is rowCol
									}
								}
							}
							for (k = rowRigOffset, c = rowColliders.length; k < c; k++) {
								rowCol = rowColliders[k];
								if (rowCol.enable) {
									rowScripts = rowCol.owner._scripts;
									for (x = 0, z = colLayer._nonRigidbodyOffset; x < z; x++) {
										colCol = colColliders[x];
										(colCol.enable) && (_onTrigger(colCol, rowCol, rowScripts, colCol.owner._scripts, false));//rigidbody is colCol 
									}
								}
							}
							
						} else {
							for (k = 0; k < rowRigOffset; k++) {
								rowCol = rowColliders[k];
								if (rowCol.enable) {
									rowScripts = rowCol.owner._scripts;
									for (x = k + 1, z = rowRigOffset; x < z; x++) {
										colCol = colColliders[x];
										(colCol.enable) && (_onTrigger(rowCol, colCol, rowScripts, colCol.owner._scripts, true));//rigidbody is rowCol、colCol
										
									}
									for (x = rowRigOffset, z = rowColliders.length; x < z; x++) {
										colCol = colColliders[x];
										(colCol.enable) && (_onTrigger(rowCol, colCol, rowScripts, colCol.owner._scripts, false));//rigidbody is rowCol
									}
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * 创建一个新的 <code>CollsionManager</code> 实例。
		 */
		public function CollisionManager() {
		}
	
	}

}