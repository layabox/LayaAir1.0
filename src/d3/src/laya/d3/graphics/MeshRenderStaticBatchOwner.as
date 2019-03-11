package laya.d3.graphics {
	import laya.d3.core.GeometryElement;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	
	/**
	 * 创建一个 <code>MeshRenderStaticBatchOwner</code> 实例。
	 */
	public class MeshRenderStaticBatchOwner {
		/** @private */
		public var _owner:Sprite3D;
		/** @private */
		public var _batches:Vector.<SubMeshStaticBatch>;
		/**@private */
		private var _cacheBatchOwner:Vector.<Vector.<MeshRenderer>>;
		
		/**
		 * 创建一个 <code>MeshRenderStaticBatchOwner</code> 实例。
		 */
		public function MeshRenderStaticBatchOwner(owner:Sprite3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_owner = owner;
			_batches = new Vector.<SubMeshStaticBatch>();
			_cacheBatchOwner = new Vector.<Vector.<MeshRenderer>>();
		}
		
		/**
		 * @private
		 */
		public function _getBatchRender(context:RenderContext3D, lightMapIndex:int, receiveShadow:Boolean):BaseRender {
			var lightRenders:Vector.<MeshRenderer> = _cacheBatchOwner[lightMapIndex];
			(lightRenders) || (lightRenders = _cacheBatchOwner[lightMapIndex] = new Vector.<MeshRenderer>(2));
			var render:MeshRenderer = lightRenders[receiveShadow ? 1 : 0];
			if (!render) {
				render = new MeshRenderer(null);
				render.lightmapIndex = lightMapIndex;
				render.receiveShadow = receiveShadow;
				lightRenders[receiveShadow ? 1 : 0] = render;
				render._defineDatas.add(MeshSprite3D.SHADERDEFINE_UV1);
			}
			return render;
		}
	
	}

}