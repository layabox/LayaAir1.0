package laya.d3.core.material {
    import laya.d3.core.render.RenderQueue;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.BaseTexture;
    import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
    
    /**
     * ...
     * @author ...
     */
    public class ExtendTerrainMaterial extends BaseMaterial {
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
        public static const DIFFUSETEXTURE5:int = 5;
		
        public static const DIFFUSESCALEOFFSET1:int = 6;
        public static const DIFFUSESCALEOFFSET2:int = 7;
        public static const DIFFUSESCALEOFFSET3:int = 8;
        public static const DIFFUSESCALEOFFSET4:int = 9;
        public static const DIFFUSESCALEOFFSET5:int = 10;
		
        public static const MATERIALAMBIENT:int = 11;
        public static const MATERIALDIFFUSE:int = 12;
        public static const MATERIALSPECULAR:int = 13;
        public static const MATERIALALBEDO:int = 14;
		
        /**地形细节宏定义。*/
        public static var SHADERDEFINE_DETAIL_NUM1:int;
        public static var SHADERDEFINE_DETAIL_NUM2:int;
        public static var SHADERDEFINE_DETAIL_NUM3:int;
        public static var SHADERDEFINE_DETAIL_NUM4:int;
        public static var SHADERDEFINE_DETAIL_NUM5:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DETAIL_NUM1 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM1");
            SHADERDEFINE_DETAIL_NUM2 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM2");
            SHADERDEFINE_DETAIL_NUM3 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM3");
            SHADERDEFINE_DETAIL_NUM4 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM4");
            SHADERDEFINE_DETAIL_NUM5 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM5");
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
         * 设置第一层贴图。
         * @param value 第一层贴图。
         */
        public function set diffuseTexture1(value:BaseTexture):void {
            _setTexture(DIFFUSETEXTURE1, value);
            _setDetailNum(1);
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
            _setDetailNum(2);
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
            _setDetailNum(3);
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
            _setDetailNum(4);
        }
        
        /**
         * 获取第五层贴图。
         * @return 第五层贴图。
         */
        public function get diffuseTexture5():BaseTexture {
            return _getTexture(DIFFUSETEXTURE5);
        }
        
        /**
         * 设置第五层贴图。
         * @param value 第五层贴图。
         */
        public function set diffuseTexture5(value:BaseTexture):void {
            _setTexture(DIFFUSETEXTURE5, value);
            _setDetailNum(5);
        }
        
        private function _setDetailNum(value:int):void {
            switch (value) {
            case 1: 
                _addShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
                break;
            case 2: 
                _addShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
                break;
            case 3: 
                _addShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
                break;
            case 4: 
                _addShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
                break;
            case 5: 
                _addShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
                _removeShaderDefine(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
                break;
            }
        }
        
        public function set diffuseScaleOffset1(scaleOffset1:Vector4):void {
            _setColor(DIFFUSESCALEOFFSET1, scaleOffset1);
        }
        
        public function set diffuseScaleOffset2(scaleOffset2:Vector4):void {
            _setColor(DIFFUSESCALEOFFSET2, scaleOffset2);
        }
        
        public function set diffuseScaleOffset3(scaleOffset3:Vector4):void {
            _setColor(DIFFUSESCALEOFFSET3, scaleOffset3);
        }
        
        public function set diffuseScaleOffset4(scaleOffset4:Vector4):void {
            _setColor(DIFFUSESCALEOFFSET4, scaleOffset4);
        }
        
        public function set diffuseScaleOffset5(scaleOffset5:Vector4):void {
            _setColor(DIFFUSESCALEOFFSET5, scaleOffset5);
        }
		
		/**
         * 获取反射率颜色。
         * @return 反射率颜色。
         */ 
		public function get albedo():Vector4 {
			return _getColor(MATERIALALBEDO);
		}
		
		/**
         * 设置反射率颜色。
         * @param value 反射率颜色。
         */
		public function set albedo(value:Vector4):void {
			_setColor(MATERIALALBEDO, value);
		}
		
		/**
         * 获取环境光颜色。
         * @return 环境光颜色。
         */ 
		public function get ambientColor():Vector3 {
			return _getColor(MATERIALAMBIENT);
		}
		
		/**
         * 设置环境光颜色。
         * @param value 环境光颜色
         */
		public function set ambientColor(value:Vector3):void {
			_setColor(MATERIALAMBIENT, value);
		}
		
		 /**
         * 获取漫反射颜色。
         * @return 漫反射颜色。
         */
		public function get diffuseColor():Vector3 {
			return _getColor(MATERIALDIFFUSE);
		}
		
		/**
         * 设置漫反射颜色。
         * @param value 漫反射颜色。
         */
		public function set diffuseColor(value:Vector3):void {
			_setColor(MATERIALDIFFUSE, value);
		}
		
		/**
         * 获取高光颜色。
         * @return 高光颜色。
         */
		public function get specularColor():Vector4 {
			return _getColor(MATERIALSPECULAR);
		}
		
		/**
         * 设置高光颜色。
         * @param value 高光颜色。
         */
		public function set specularColor(value:Vector4):void {
			_setColor(MATERIALSPECULAR, value);
		}
		
		/**
         * 设置禁受光照影响。
         */
		public function disableLight():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				depthTest = DEPTHTEST_LESS;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				depthTest = DEPTHTEST_LEQUAL;
				break;
			default: 
				throw new Error("ExtendTerrainMaterial:renderMode value error.");
			}
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
		}
        
        public function ExtendTerrainMaterial() {
        
			super();
			setShaderName("ExtendTerrain");
			renderMode = RENDERMODE_OPAQUE;
        }
    
    }

}