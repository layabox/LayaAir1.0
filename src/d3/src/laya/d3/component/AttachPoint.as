package laya.d3.component {
	import laya.ani.AnimationPlayer;
	import laya.ani.AnimationState;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * <code>AttachPoint</code> 类用于创建挂点组件。
	 */
	public class AttachPoint extends Component3D {
		/** @private */
		protected var _attachSkeleton:SkinAnimations;
		/** @private */
		protected var _data:Float32Array;
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
		override public function _load(owner:Sprite3D):void {
			super._load(owner);
			_attachSkeleton = owner.getComponentByType(SkinAnimations) as SkinAnimations;
		}
		
		/**
		 * @private
		 * 更新挂点组件。
		 * @param	state 渲染状态。
		 */
		public override function _update(state:RenderState):void {
			if (!_attachSkeleton || _attachSkeleton.player.state !== AnimationState.playing || !_attachSkeleton.curBonesDatas)
				return;
				
			var player:AnimationPlayer = _attachSkeleton.player;			
			matrixs.length = attachBones.length;
			for (var i:int; i < attachBones.length; i++) {
				
				var index:int = _attachSkeleton.templet.getNodeIndexWithName(player.currentAnimationClipIndex, attachBones[i]);
				_data = _attachSkeleton.curBonesDatas.subarray(index * 16, (index + 1) * 16);
				var matrix:Matrix4x4 = matrixs[i];
				
				matrix || (matrix = matrixs[i] = new Matrix4x4());
				matrix.copyFromArray(_data);
				Matrix4x4.multiply(owner.transform.worldMatrix, matrix, matrix);
			}
		}
	}
}