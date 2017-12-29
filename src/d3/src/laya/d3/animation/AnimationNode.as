package laya.d3.animation {
	import laya.d3.component.Animator;
	import laya.d3.core.Avatar;
	import laya.d3.core.IClone;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshRender;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.utils.Utils3D;
	
	/**
	 * <code>BoneNode</code> 类用于实现骨骼节点。
	 */
	public class AnimationNode implements IClone {
		/**@private */
		private static var _propertyIDCounter:int = 0;
		/**@private */
		public static var _propertyIndexDic:Object = {};
		/**@private */
		public static var _propertySetFuncs:Array = [];
		/**@private */
		public static var _propertyGetFuncs:Array = [];
		
		/**
		 *@private
		 */
		public static function __init__():void {
			registerAnimationNodeProperty("localPosition", _getLocalPosition, _setLocalPosition);
			registerAnimationNodeProperty("localRotation", _getLocalRotation, _setLocalRotation);
			registerAnimationNodeProperty("localScale", _getLocalScale, _setLocalScale);
			registerAnimationNodeProperty("localRotationEuler", _getLocalRotationEuler, _setLocalRotationEuler);
			registerAnimationNodeProperty("particleRender.sharedMaterial.tintColor", _getParticleRenderSharedMaterialTintColor, _setParticleRenderSharedMaterialTintColor);
			registerAnimationNodeProperty("meshRender.sharedMaterial.tilingOffset", _getMeshRenderSharedMaterialTilingOffset, _setMeshRenderSharedMaterialTilingOffset);
			registerAnimationNodeProperty("meshRender.sharedMaterial.albedoColor", _getMeshRenderSharedMaterialAlbedo, _setMeshRenderSharedMaterialAlbedo);
			registerAnimationNodeProperty("skinnedMeshRender.sharedMaterial.tilingOffset", _getSkinnedMeshRenderSharedMaterialTilingOffset, _setSkinnedMeshRenderSharedMaterialTilingOffset);
			registerAnimationNodeProperty("skinnedMeshRender.sharedMaterial.albedoColor", _getSkinnedMeshRenderSharedMaterialAlbedo, _setSkinnedMeshRenderSharedMaterialAlbedo);
			
			registerAnimationNodeProperty("meshRender.sharedMaterial.albedo", _getMeshRenderSharedMaterialAlbedo, _setMeshRenderSharedMaterialAlbedo);
			registerAnimationNodeProperty("skinnedMeshRender.sharedMaterial.albedo", _getSkinnedMeshRenderSharedMaterialAlbedo, _setSkinnedMeshRenderSharedMaterialAlbedo);
		}
		
		/**
		 *注册Animator动画。
		 */
		public static function registerAnimationNodeProperty(propertyName:String, getFunc:Function, setFunc:Function):void {
			if (_propertyIndexDic[propertyName]) {
				throw new Error("AnimationNode: this propertyName has registered.");
			} else {
				_propertyIndexDic[propertyName] = _propertyIDCounter;
				_propertyGetFuncs[_propertyIDCounter] = getFunc;
				_propertySetFuncs[_propertyIDCounter] = setFunc;
				_propertyIDCounter++;
			}
		}
		
		/**@private */
		private var _childs:Vector.<AnimationNode>;
		
		/**@private */
		public var _parent:AnimationNode;
		/**@private */
		public var _transform:AnimationTransform3D;
		
		/**节点名称。 */
		public var name:String;
		
		/**
		 * 获取变换。
		 * @return 变换。
		 */
		public function transform():AnimationTransform3D {
			return _transform;
		}
		
		/**
		 * @private
		 */
		private static function _getLocalPosition(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			if (animationNode)
				return animationNode._transform.localPosition.elements;
			else
				return sprite3D._transform.localPosition.elements;
		}
		
		/**
		 * @private
		 */
		private static function _setLocalPosition(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var localPosition:Vector3;
			if (animationNode) {
				var transform:AnimationTransform3D = animationNode._transform;
				localPosition = transform._localPosition;
				localPosition.elements = value;
				transform._setLocalPosition(localPosition);
			} else {
				var spriteTransform:Transform3D = sprite3D._transform;
				localPosition = spriteTransform.localPosition;
				localPosition.elements = value;
				spriteTransform.localPosition = localPosition;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getLocalRotation(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			if (animationNode)
				return animationNode._transform.localRotation.elements;
			else
				return sprite3D._transform.localRotation.elements;
		}
		
		/**
		 * @private
		 */
		private static function _setLocalRotation(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var localRotation:Quaternion;
			if (animationNode) {
				var transform:AnimationTransform3D = animationNode._transform;
				localRotation = transform._localRotation;
				localRotation.elements = value;
				transform._setLocalRotation(localRotation);
			} else {
				var spriteTransform:Transform3D = sprite3D._transform;
				localRotation = spriteTransform.localRotation;
				localRotation.elements = value;
				spriteTransform.localRotation = localRotation;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getLocalScale(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			if (animationNode)
				return animationNode._transform.localScale.elements;
			else
				return sprite3D._transform.localScale.elements;
		}
		
		/**
		 * @private
		 */
		private static function _setLocalScale(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var localScale:Vector3;
			if (animationNode) {
				var transform:AnimationTransform3D = animationNode._transform;
				localScale = transform._localScale;
				localScale.elements = value;
				transform._setLocalScale(localScale);
			} else {
				var spriteTransform:Transform3D = sprite3D._transform;
				localScale = spriteTransform.localScale;
				localScale.elements = value;
				spriteTransform.localScale = localScale;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getLocalRotationEuler(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			if (animationNode)
				return animationNode._transform.localRotationEuler.elements;
			else
				return sprite3D._transform.localRotationEuler.elements;
		}
		
		/**
		 * @private
		 */
		private static function _setLocalRotationEuler(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var localRotationEuler:Vector3;
			if (animationNode) {
				var transform:AnimationTransform3D = animationNode._transform;
				localRotationEuler = transform._localRotationEuler;
				localRotationEuler.elements = value;
				transform._setLocalRotationEuler(localRotationEuler);
			} else {
				var spriteTransform:Transform3D = sprite3D._transform;
				localRotationEuler = spriteTransform.localRotationEuler;
				localRotationEuler.elements = value;
				spriteTransform.localRotationEuler = localRotationEuler;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getMeshRenderSharedMaterialTilingOffset(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			var material:*;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;//以下类似处理均为防止AnimationNode无关联实体节点
				if (entity) {
					material = (entity.owner as MeshSprite3D).meshRender.sharedMaterial;
					return material.tilingOffset.elements;
				} else
					return null;
			} else {
				material = (sprite3D as MeshSprite3D).meshRender.sharedMaterial;
				return material.tilingOffset.elements;
			}
		}
		
		/**
		 * @private
		 */
		private static function _setMeshRenderSharedMaterialTilingOffset(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var material:*, tilingOffset:Vector4;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as MeshSprite3D).meshRender.material;
					tilingOffset = material.tilingOffset;
					tilingOffset.elements = value;
					material.tilingOffset = tilingOffset;
				}
			} else {
				material = (sprite3D as MeshSprite3D).meshRender.material;
				tilingOffset = material.tilingOffset;
				tilingOffset.elements = value;
				material.tilingOffset = tilingOffset;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getMeshRenderSharedMaterialAlbedo(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			var material:*;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as MeshSprite3D).meshRender.sharedMaterial;
					return material.albedoColor.elements;
				} else
					return null;
			} else {
				material = (sprite3D as MeshSprite3D).meshRender.sharedMaterial;
				return material.albedoColor.elements;
			}
		}
		
		/**
		 * @private
		 */
		private static function _setMeshRenderSharedMaterialAlbedo(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var material:*, albedo:Vector4;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as MeshSprite3D).meshRender.material;
					albedo = material.albedoColor;
					albedo.elements = value;
					material.albedoColor = albedo;
				}
			} else {
				material = (sprite3D as MeshSprite3D).meshRender.material;
				albedo = material.albedoColor;
				albedo.elements = value;
				material.albedoColor = albedo;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getSkinnedMeshRenderSharedMaterialTilingOffset(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			var material:*;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as SkinnedMeshSprite3D).skinnedMeshRender.sharedMaterial;
					return material.tilingOffset.elements;
				} else
					return null;
			} else {
				material = (sprite3D as SkinnedMeshSprite3D).skinnedMeshRender.sharedMaterial;
				return material.tilingOffset.elements;
			}
		}
		
		/**
		 * @private
		 */
		private static function _setSkinnedMeshRenderSharedMaterialTilingOffset(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var material:*, tilingOffset:Vector4;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as SkinnedMeshSprite3D).skinnedMeshRender.material;
					tilingOffset = material.tilingOffset;
					tilingOffset.elements = value;
					material.tilingOffset = tilingOffset;
				}
			} else {
				material = (sprite3D as SkinnedMeshSprite3D).skinnedMeshRender.material;
				tilingOffset = material.tilingOffset;
				tilingOffset.elements = value;
				material.tilingOffset = tilingOffset;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getSkinnedMeshRenderSharedMaterialAlbedo(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			var material:*;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as SkinnedMeshSprite3D).skinnedMeshRender.sharedMaterial;
					return material.albedoColor.elements;
				} else {
					return null;
				}
			} else {
				material = (sprite3D as SkinnedMeshSprite3D).skinnedMeshRender.sharedMaterial;
				return material.albedoColor.elements;
			}
		}
		
		/**
		 * @private
		 */
		private static function _setSkinnedMeshRenderSharedMaterialAlbedo(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var material:*, albedo:Vector4;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as SkinnedMeshSprite3D).skinnedMeshRender.material;
					albedo = material.albedoColor;
					albedo.elements = value;
					material.albedoColor = albedo;
				}
			} else {
				material = (sprite3D as SkinnedMeshSprite3D).skinnedMeshRender.material;
				albedo = material.albedoColor;
				albedo.elements = value;
				material.albedoColor = albedo;
			}
		}
		
		/**
		 * @private
		 */
		private static function _getParticleRenderSharedMaterialTintColor(animationNode:AnimationNode, sprite3D:Sprite3D):Float32Array {
			var material:*;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as ShuriKenParticle3D).particleRender.sharedMaterial;
					return material.tintColor.elements;
				} else
					return null;
			} else {
				material = (sprite3D as ShuriKenParticle3D).particleRender.sharedMaterial;
				return material.tintColor.elements;
			}
		}
		
		/**
		 * @private
		 */
		private static function _setParticleRenderSharedMaterialTintColor(animationNode:AnimationNode, sprite3D:Sprite3D, value:Float32Array):void {
			var material:*, tintColor:Vector4;
			if (animationNode) {
				var entity:Transform3D = animationNode._transform._entity;
				if (entity) {
					material = (entity.owner as ShuriKenParticle3D).particleRender.material;
					tintColor = material.tintColor;
					tintColor.elements = value;
					material.tintColor = tintColor;
				}
			} else {
				material = (sprite3D as ShuriKenParticle3D).particleRender.material;
				tintColor = material.tintColor;
				tintColor.elements = value;
				material.tintColor = tintColor;
			}
		}
		
		/**
		 * 创建一个新的 <code>BoneNode</code> 实例。
		 */
		public function AnimationNode() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_childs = new Vector.<AnimationNode>();
			_transform = new AnimationTransform3D(this);
		}
		
		/**
		 * 添加子节点。
		 * @param	child  子节点。
		 */
		public function addChild(child:AnimationNode):void {
			child._parent = this;
			child._transform.parent = _transform;
			_childs.push(child);
		}
		
		/**
		 * 移除子节点。
		 * @param	child 子节点。
		 */
		public function removeChild(child:AnimationNode):void {
			var index:int = _childs.indexOf(child);
			(index !== -1) && (_childs.splice(index, 1));
		}
		
		/**
		 * 根据名字获取子节点。
		 * @param	name 名字。
		 */
		public function getChildByName(name:String):AnimationNode {
			for (var i:int = 0, n:int = _childs.length; i < n; i++) {
				var child:AnimationNode = _childs[i];
				if (child.name === name)
					return child;
			}
			return null;
		}
		
		/**
		 * 根据索引获取子节点。
		 * @param	index 索引。
		 */
		public function getChildByIndex(index:int):AnimationNode {
			return _childs[index];
		}
		
		/**
		 * 获取子节点的个数。
		 */
		public function getChildCount():int {
			return _childs.length;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destAnimationNode:AnimationNode = destObject as AnimationNode;
			destAnimationNode.name = name;
			var destTransform:AnimationTransform3D = destAnimationNode._transform;
			
			var destLocalPosition:Vector3 = destTransform.localPosition;
			_transform.localPosition.cloneTo(destLocalPosition);
			destTransform.localPosition = destLocalPosition;
			
			var destLocalRotation:Quaternion = destTransform.localRotation;
			_transform.localRotation.cloneTo(destLocalRotation);
			destTransform.localRotation = destLocalRotation;
			
			var destLocalScale:Vector3 = destTransform.localScale;
			_transform.localScale.cloneTo(destLocalScale);
			destTransform.localScale = destLocalScale;
			
			for (var i:int = 0, n:int = _childs.length; i < n; i++) {
				var destChild:AnimationNode = _childs[i].clone();
				destAnimationNode.addChild(destChild);
			}
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:AnimationNode = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	
	}

}