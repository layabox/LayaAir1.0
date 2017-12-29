package
{
	import laya.d3.component.Script;
	import laya.d3.component.physics.Collider;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.math.Vector4;
	
	public class ColliderScript extends Script
	{
		private var _color:Vector4 = new Vector4(1, 0, 0, 1);
		private var _tempColor1:Vector4 = new Vector4(2.5, 2.5, 2.5, 1);
		private var _tempColor2:Vector4 = new Vector4(0.4, 0.4, 0.4, 1);
		public function ColliderScript()
		{
			super();
		}
		
		override public function onTriggerEnter(other:Collider):void
		{
			super.onTriggerEnter(other);
			var mat:* = (other._owner as MeshSprite3D).meshRender.material;
			Vector4.multiply(mat.albedoColor, _tempColor1, _color);
			mat.albedoColor = new Vector4(_color.x, _color.y, _color.z, _color.w);
		}
		
		override public function onTriggerExit(other:Collider):void
		{
			super.onTriggerExit(other);
			var mat:* = (other._owner as MeshSprite3D).meshRender.material;
			Vector4.multiply(mat.albedoColor, _tempColor2, _color);
			mat.albedoColor = new Vector4(_color.x, _color.y, _color.z, _color.w);
		}
		
		override public function onTriggerStay(other:Collider):void
		{
			super.onTriggerStay(other);
			//trace("onTriggerStay");
		}
	}
}