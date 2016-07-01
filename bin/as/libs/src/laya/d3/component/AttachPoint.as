package laya.d3.component
{
	import laya.ani.KeyframesAniTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * <code>AttachPoint</code> 类用于创建挂点组件。
	 */
	public class AttachPoint extends Component3D
	{
		/** @private */
		protected var _attachSkeleton:SkinAnimations;
		/** @private */
		protected var _data:Float32Array;
		/** @private */
		protected var _extenData:Float32Array;
		/**挂点骨骼的名称。*/
		public var attachBone:String;
		/**挂点骨骼的变换矩阵。*/
		public var matrix:Matrix4x4;
		
			
		/**
		 * 创建一个新的 <code>AttachPoint</code> 实例。
		 */
		public function AttachPoint()
		{
		
		}
		
		/**
		 * @private
		 * 初始化载入挂点组件。
		 * @param	owner 所属精灵对象。
		 */
		override public function _load(owner:Sprite3D):void
		{
			super._load(owner);
			_attachSkeleton = owner.getComponentByType(SkinAnimations) as SkinAnimations;
		}
		
		/**
		 * @private
		 * 更新挂点组件。
		 * @param	state 渲染状态。
		 */
		public override function _update(state:RenderState):void
		{
			if (_attachSkeleton&&_attachSkeleton._templet.loaded&&attachBone)
			{
				var skeletonTemplet:KeyframesAniTemplet = _attachSkeleton._templet;
				var index:int = skeletonTemplet.getNodeIndexWithName.call(skeletonTemplet, _attachSkeleton.player.currentAnimationClipIndex, attachBone);
				_data = _attachSkeleton.curBonesDatas.subarray(index * 16, (index + 1) * 16);
				matrix || (matrix = new Matrix4x4());
				matrix.copyFromArray(_data);
				
				super._update(state);
			}
		}
	}
}