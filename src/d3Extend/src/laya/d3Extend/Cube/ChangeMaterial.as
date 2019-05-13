package Cube {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.material.UnlitMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.math.Color;
	/**
	 * ...
	 * @author ...
	 */
	public class ChangeMaterial {
		
		/**@private 根据材质ID来记录本身Alpha值*/
		private static var _materialAlpha:Object = {};
		/**@private */
		private static var _blinn:BlinnPhongMaterial;
		/**@private */
		private	static var _unlin:UnlitMaterial;
		/**@private */
		private static var _shunri:ShurikenParticleMaterial;
		
		
		/**
		 *转换模型为透明材质 
		 * @param 传入的材质
		 * @param Index  0表示变透明,1表示返回原来的值
		 */
		public static function changedToTransform(material:BaseMaterial,Index:int):void
		{
			
				if (material is BlinnPhongMaterial)
				{
					_blinn = material as BlinnPhongMaterial;
					if(!_materialAlpha[_blinn.id])
					_materialAlpha[_blinn.id] = _blinn.albedoColorA;
					_blinn.albedoColorA = 0.3;
					_blinn.renderMode = BlinnPhongMaterial.RENDERMODE_TRANSPARENT;
					
				}else if(material is UnlitMaterial)
				{
					_unlin = material as UnlitMaterial;
					if(!_materialAlpha[_unlin.id])
					_materialAlpha[_unlin.id] = _blinn.albedoColorA;
					_unlin.albedoColorA = 0.3;
					_unlin.renderMode = UnlitMaterial.RENDERMODE_TRANSPARENT;
				}
				else if (material is ShurikenParticleMaterial)
				{
					
					_shunri = material as ShurikenParticleMaterial;
					if(!_materialAlpha[_shunri.id])
					_materialAlpha[_shunri.id] = _shunri.colorA;
					_shunri.colorA = 0.1;
				}
				else
				{
					console.log("material is not standart");
				}	
		}
		/**
		 *转换为不透明的材质 
		 * @param material 修改材质
		 */
		public static function changedToOPAQUE(material:BaseMaterial):void
		{
				
				if (material is BlinnPhongMaterial)
				{
					_blinn = material as BlinnPhongMaterial;
					if(_materialAlpha[_blinn.id]==1)
						_blinn.renderMode = BlinnPhongMaterial.RENDERMODE_OPAQUE;
					else
						_blinn.albedoColorA = _materialAlpha[_blinn.id];
				}else if(material is UnlitMaterial)
				{
					_unlin = material as UnlitMaterial;
					if(_materialAlpha[_unlin.id]==1)
						_unlin.renderMode = UnlitMaterial.RENDERMODE_OPAQUE;
					else
						_unlin.albedoColorA = _materialAlpha[_unlin.id];
				}
				else if (material is ShurikenParticleMaterial)
				{
					_shunri = material as ShurikenParticleMaterial;
					_shunri.colorA = _materialAlpha[_shunri.id];
					
				}
				else
				{
					console.log("material is not standart");
				}	
		}
		
		/**
		 *转换材质 
		 *@param material 修改材质
		 */
		public static function changedMaterial(sprite:Sprite3D):void
		{
			var childnums:int = sprite.numChildren;
			var material:BaseMaterial;
			var meshsprite:MeshSprite3D;
			var particle:ShuriKenParticle3D;
			
		
			if (sprite is MeshSprite3D)
			{
				meshsprite = sprite;
				material = meshsprite.meshRenderer.material;
				changedToTransform(material);	
			}
			else if(sprite is ShuriKenParticle3D)
			{
				particle = sprite;
				material = particle.particleRenderer.material;
				changedToTransform(material);
			}
			if (childnums > 0)
			{
				for (var i:int = 0; i < childnums; i++) {
					changedMaterial(sprite.getChildAt(i));
					
				}
			}
			
		}
		
		/**
		 *转换材质颜色
		 * @param material 修改材质 color 修改材质的颜色
		 */
		public static function changeMaterialColor(sprite:MeshSprite3D, color:Color):void
		{
			
				var material:BaseMaterial = sprite.meshRenderer.material;
				
				if (material is BlinnPhongMaterial)
				{
					_blinn = material as BlinnPhongMaterial;
					_blinn.albedoColor = color;

				}else if(material is UnlitMaterial)
				{
					_unlin = material as UnlitMaterial;	
					_unlin.albedoColor = color;
				}
				else
				{
					console.log("material is not standart");
				}	
		}
		
		
	}

}