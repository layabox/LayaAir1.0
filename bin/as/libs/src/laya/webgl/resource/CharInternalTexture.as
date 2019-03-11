package laya.webgl.resource {
	/**
	 * 由于drawTextureM需要一个Texture对象，又不想真的弄一个，所以，做个假的，只封装必须成员
	 */
	public class CharInternalTexture{
		public var _par:CharPageTexture;
		public var _loaded:Boolean = true;				//drawTextureM的条件
		public var bitmap:*= { };						//samekey的判断用的
		public function CharInternalTexture(par:CharPageTexture) {
			bitmap.id = par.id;
			_par = par;
		}
		public function _getSource():*{	
			return this._par._source;		//renderSubmit的时候只用了 getSource
		}
	};	 	
}