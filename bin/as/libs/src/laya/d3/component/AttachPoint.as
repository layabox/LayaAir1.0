package laya.d3.component {
	import laya.ani.AnimationPlayer;
	import laya.ani.AnimationState;
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.events.Event;
	
	/**完成挂点更新时调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * <code>AttachPoint</code> 类用于创建挂点组件。
	 */
	public class AttachPoint extends Component3D {
		/** @private */
		protected var _attachSkeleton:SkinAnimations;
		/** @private */
		protected var _extenData:Float32Array;
		/**挂点骨骼的名称。*/
		public var attachBones:Vector.<String>;
		/**挂点骨骼的变换矩阵。*/
		public var matrixs:Vector.<Matrix4x4>;
		
		/**
		 * 创建一个新的 <code>AttachPoint</code> 实例。
		 */
		public function AttachPoint() {
			attachBones = new Vector.<String>();
			matrixs = new Vector.<Matrix4x4>();
		}
		
		/**
		 * @private
		 * 初始化载入挂点组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:ComponentNode):void {
			super._load(owner);
			_attachSkeleton = (owner as Sprite3D).getComponentByType(SkinAnimations) as SkinAnimations;
		}
		
		/**
		 * @private
		 * 更新挂点组件。
		 * @param	state 渲染状态。
		 */
		public override function _update(state:RenderState):void {
			if (!_attachSkeleton||_attachSkeleton.destroyed || _attachSkeleton.player.state === AnimationState.stopped || !_attachSkeleton.curBonesDatas)
				return;
			
			var player:AnimationPlayer = _attachSkeleton.player;
			var templet:AnimationTemplet = _attachSkeleton.templet;
			matrixs.length = attachBones.length;
			var boneDatas:Float32Array = _attachSkeleton.curBonesDatas;
			var worldMatrix:Matrix4x4 = (owner as Sprite3D).transform.worldMatrix;
			for (var i:int, n:int = attachBones.length; i < n; i++) {
				var startIndex:int = templet.getNodeIndexWithName(player.currentAnimationClipIndex, attachBones[i]) * 16;
				var matrix:Matrix4x4 = matrixs[i];
				matrix || (matrix = matrixs[i] = new Matrix4x4());
				var matrixE:Float32Array = matrix.elements;
				for (var j:int = 0; j < 16; j++)
					matrixE[j] = boneDatas[startIndex + j];
				Matrix4x4.multiply(worldMatrix, matrix, matrix);
			}
			event(Event.COMPLETE);
		}
	}
}