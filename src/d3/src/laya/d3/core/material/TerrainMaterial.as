package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TerrainMaterial extends BaseMaterial {
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		
		/**渲染状态_透明混合。*/
		public static const SPLATALPHATEXTURE:int = 0;
		public static const DIFFUSETEXTURE1:int = 1;
		public static const DIFFUSETEXTURE2:int = 2;
		public static const DIFFUSETEXTURE3:int = 3;
		public static const DIFFUSETEXTURE4:int = 4;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:TerrainMaterial = new TerrainMaterial();
		
		/**
		 * 加载闪光材质。
		 * @param url 闪光材质地址。
		 */
		public static function load(url:String):TerrainMaterial {
			return Laya.loader.create(url, null, null, TerrainMaterial);
		}
		
		/**@private 渲染模式。*/
		private var _renderMode:int;
		
		/**
		 * 获取渲染状态。
		 * @return 渲染状态。
		 */
		public function get renderMode():int {
			return _renderMode;
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			_renderMode = value;
			switch (value) {
			case RENDERMODE_OPAQUE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("TerrainMaterial:renderMode value error.");
			}
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
		}
		
		/**
		 * 获取第一层贴图。
		 * @return 第一层贴图。
		 */
		public function get diffuseTexture1():BaseTexture {
			return _getTexture(DIFFUSETEXTURE1);
		}
		
		/**
		 * 设置第一层贴图。
		 * @param value 第一层贴图。
		 */
		public function set diffuseTexture1(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE1, value);
		}
		/**
		 * 获取第二层贴图。
		 * @return 第二层贴图。
		 */
		public function get diffuseTexture2():BaseTexture {
			return _getTexture(DIFFUSETEXTURE2);
		}
		
		/**
		 * 设置第二层贴图。
		 * @param value 第二层贴图。
		 */
		public function set diffuseTexture2(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE2, value);
		}
		/**
		 * 获取第三层贴图。
		 * @return 第三层贴图。
		 */
		public function get diffuseTexture3():BaseTexture {
			return _getTexture(DIFFUSETEXTURE3);
		}
		
		/**
		 * 设置第三层贴图。
		 * @param value 第三层贴图。
		 */
		public function set diffuseTexture3(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE3, value);
		}
		/**
		 * 获取第四层贴图。
		 * @return 第四层贴图。
		 */
		public function get diffuseTexture4():BaseTexture {
			return _getTexture(DIFFUSETEXTURE4);
		}
		
		/**
		 * 设置第四层贴图。
		 * @param value 第四层贴图。
		 */
		public function set diffuseTexture4(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE4, value);
		}
		
		/**
		 * 获取splatAlpha贴图。
		 * @return splatAlpha贴图。
		 */
		public function get splatAlphaTexture():BaseTexture {
			return _getTexture(SPLATALPHATEXTURE);
		}
		
		/**
		 * 设置splatAlpha贴图。
		 * @param value splatAlpha贴图。
		 */
		public function set splatAlphaTexture(value:BaseTexture):void {
			_setTexture(SPLATALPHATEXTURE, value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		public function TerrainMaterial() {
			super();
			setShaderName("Terrain");
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setMaterialShaderParams(state:RenderState):void {
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var dest:TerrainMaterial = destObject as TerrainMaterial;
			dest._renderMode = _renderMode;
		}
	
	}

}