package laya.d3.component {
	import laya.d3.animation.AnimationClip;
	import laya.d3.core.IClone;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>AnimatorControllerLayer</code> 类用于创建动画控制器层。
	 */
	public class AnimatorControllerLayer implements IClone {
		/**@private */
		public static var BLENDINGMODE_OVERRIDE:int = 0;
		/**@private */
		public static var BLENDINGMODE_ADDTIVE:int = 1;
		
		/**@private 0:常规播放、1:动态融合播放、2:固定融合播放*/
		public var _playType:int;
		/**@private */
		public var _crossDuration:Number;
		/**@private */
		public var _crossPlayState:AnimatorState;
		/**@private */
		public var _crossMark:int;
		/**@private */
		public var _crossNodesOwnersCount:int;
		/**@private */
		public var _crossNodesOwners:Vector.<KeyframeNodeOwner>;
		/**@private */
		public var _crossNodesOwnersIndicesMap:Object;
		/**@private */
		public var _srcCrossClipNodeIndices:Vector.<int>;
		/**@private */
		public var _destCrossClipNodeIndices:Vector.<int>;
		
		/**@private */
		public var _defaultState:AnimatorState;
		/**@private */
		public var _currentPlayState:AnimatorState;
		/**@private */
		public var _statesMap:Object = {};
		/**@private */
		public var _states:Vector.<AnimatorState>;
		/**@private */
		public var _playStateInfo:AnimatorPlayState;
		/**@private */
		public var _crossPlayStateInfo:AnimatorPlayState;
		
		/** 层的名称。*/
		public var name:String;
		/** 名称。*/
		public var blendingMode:int;
		/** 权重。*/
		public var defaultWeight:int;
		/**	激活时是否自动播放*/
		public var playOnWake:Boolean = true;
		
		/**
		 * 创建一个 <code>AnimatorControllerLayer</code> 实例。
		 */
		public function AnimatorControllerLayer(name:String) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_playType = -1;
			_crossMark = 0;
			_crossDuration = -1;
			_crossNodesOwnersIndicesMap = {};
			_crossNodesOwnersCount = 0;
			_crossNodesOwners = new Vector.<KeyframeNodeOwner>();
			_defaultState = null;
			_currentPlayState = null;
			_states = new Vector.<AnimatorState>();
			_playStateInfo = new AnimatorPlayState();
			_crossPlayStateInfo = new AnimatorPlayState();
			_srcCrossClipNodeIndices = new Vector.<int>();
			_destCrossClipNodeIndices = new Vector.<int>();
			
			this.name = name;
			defaultWeight = 1.0;
			blendingMode = AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
		}
		
		/**
		 * @private
		 */
		public function getAnimatorState(name:String):AnimatorState {
			var state:AnimatorState = _statesMap[name];
			return state ? state : null;
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			_statesMap = null;
			_states = null;
			_playStateInfo = null;
			_crossPlayStateInfo = null;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:AnimatorControllerLayer = destObject as AnimatorControllerLayer;
			dest.name = name;
			dest.blendingMode = blendingMode;
			dest.defaultWeight = defaultWeight;
			dest.playOnWake = playOnWake;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:AnimatorControllerLayer = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	}

}