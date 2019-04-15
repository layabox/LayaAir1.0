package laya.d3.core {
	import laya.d3.component.Animator;
	import laya.d3.component.Script3D;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.shader.Shader3D;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.ICreateResource;
	import laya.utils.Handler;
	
	/**
	 * <code>Sprite3D</code> 类用于实现3D精灵。
	 */
	public class Sprite3D extends Node implements ICreateResource, IClone {
		/**
		 *@private
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):Sprite3D {
			var json:Object = data.data;
			var outBatchSprits:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>();
			var sprite:Sprite3D = Utils3D._createNodeByJson(json, outBatchSprits) as Sprite3D;
			StaticBatchManager.combine(sprite, outBatchSprits);
			return sprite;
		}
		
		/**@private 着色器变量名，世界矩阵。*/
		public static var WORLDMATRIX:int = Shader3D.propertyNameToID("u_WorldMat");
		/**@private 着色器变量名，世界视图投影矩阵。*/
		public static var MVPMATRIX:int = Shader3D.propertyNameToID("u_MvpMatrix");
		;
		
		/**@private */
		protected static var _uniqueIDCounter:int = 0;
		
		/**
		 * @private
		 */
		public static function __init__():void {
		}
		
		/**
		 * 创建精灵的克隆实例。
		 * @param	original  原始精灵。
		 * @param   parent    父节点。
		 * @param   worldPositionStays 是否保持自身世界变换。
		 * @param	position  世界位置,worldPositionStays为false时生效。
		 * @param	rotation  世界旋转,worldPositionStays为false时生效。
		 * @return  克隆实例。
		 */
		public static function instantiate(original:Sprite3D, parent:Node = null, worldPositionStays:Boolean = true, position:Vector3 = null, rotation:Quaternion = null):Sprite3D {
			var destSprite3D:Sprite3D = original.clone();
			(parent) && (parent.addChild(destSprite3D));
			var transform:Transform3D = destSprite3D.transform;
			if (worldPositionStays) {
				var worldMatrix:Matrix4x4 = transform.worldMatrix;
				original.transform.worldMatrix.cloneTo(worldMatrix);
				transform.worldMatrix = worldMatrix;
			} else {
				(position) && (transform.position = position);
				(rotation) && (transform.rotation = rotation);
			}
			return destSprite3D;
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 * @param complete 完成回掉。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.HIERARCHY);
		}
		
		/** @private */
		private var _id:int;
		
		/**@private */
		private var _url:String;
		
		/** @private */
		public var _isStatic:Boolean;
		/** @private */
		public var _layer:int;
		/** @private */
		public var _scripts:Vector.<Script3D>;
		/**@private */
		public var _transform:Transform3D;
		/** @private */
		public var _hierarchyAnimator:Animator;
		/** @private */
		public var _needProcessCollisions:Boolean = false;
		/** @private */
		public var _needProcessTriggers:Boolean = false;
		
		/**
		 * 获取唯一标识ID。
		 *   @return	唯一标识ID。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取蒙版。
		 * @return	蒙版。
		 */
		public function get layer():int {
			return _layer;
		}
		
		/**
		 * 设置蒙版。
		 * @param	value 蒙版。
		 */
		public function set layer(value:int):void {
			if (_layer !== value) {
				if (value >= 0 && value <= 30) {
					_layer = value;
				} else {
					throw new Error("Layer value must be 0-30.");
				}
			}
		}
		
		/**
		 * 获取资源的URL地址。
		 * @return URL地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 获取是否为静态。
		 * @return 是否为静态。
		 */
		public function get isStatic():Boolean {
			return _isStatic;
		}
		
		/**
		 * 获取精灵变换。
		 * @return 精灵变换。
		 */
		public function get transform():Transform3D {
			return _transform;
		}
		
		/**
		 * 创建一个 <code>Sprite3D</code> 实例。
		 * @param name 精灵名称。
		 * @param isStatic 是否为静态。
		 */
		public function Sprite3D(name:String = null, isStatic:Boolean = false) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_id = ++_uniqueIDCounter;
			_transform = new Transform3D(this);
			_isStatic = isStatic;
			layer = 0;
			this.name = name ? name : "New Sprite3D";
		}
		
		/**
		 * @private
		 */
		public function _setCreateURL(url:String):void {
			_url = URL.formatURL(url);//perfab根节点会设置URL
		}
		
		/**
		 * @private
		 */
		private function _changeAnimatorsToLinkSprite3D(sprite3D:Sprite3D, isLink:Boolean, path:Vector.<String>):void {
			var animator:Animator = getComponent(Animator) as Animator;
			if (animator) {
				if (!animator.avatar)
					sprite3D._changeAnimatorToLinkSprite3DNoAvatar(animator, isLink, path);
			}
			
			if (_parent && _parent is Sprite3D) {
				path.unshift(_parent.name);
				var p:Sprite3D = _parent as Sprite3D;
				(p._hierarchyAnimator) && (p._changeAnimatorsToLinkSprite3D(sprite3D, isLink, path));
			}
		}
		
		/**
		 * @private
		 */
		public function _setHierarchyAnimator(animator:Animator, parentAnimator:Animator):void {
			_changeHierarchyAnimator(animator);
			_changeAnimatorAvatar(animator.avatar);
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:Sprite3D = _children[i];
				(child._hierarchyAnimator == parentAnimator) && (child._setHierarchyAnimator(animator, parentAnimator));
			}
		}
		
		/**
		 * @private
		 */
		public function _clearHierarchyAnimator(animator:Animator, parentAnimator:Animator):void {
			_changeHierarchyAnimator(parentAnimator);
			_changeAnimatorAvatar(parentAnimator ? parentAnimator.avatar : null);
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:Sprite3D = _children[i];
				(child._hierarchyAnimator == animator) && (child._clearHierarchyAnimator(animator, parentAnimator));
			}
		}
		
		/**
		 * @private
		 */
		public function _changeHierarchyAnimatorAvatar(animator:Animator, avatar:Avatar):void {
			_changeAnimatorAvatar(avatar);
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:Sprite3D = _children[i];
				(child._hierarchyAnimator == animator) && (child._changeHierarchyAnimatorAvatar(animator, avatar));
			}
		}
		
		/**
		 * @private
		 */
		public function _changeAnimatorToLinkSprite3DNoAvatar(animator:Animator, isLink:Boolean, path:Vector.<String>):void {
			animator._handleSpriteOwnersBySprite(isLink, path, this);
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:Sprite3D = _children[i];
				var index:int = path.length;
				path.push(child.name);
				child._changeAnimatorToLinkSprite3DNoAvatar(animator, isLink, path);
				path.splice(index, 1);
			}
		}
		
		/**
		 * @private
		 */
		protected function _changeHierarchyAnimator(animator:Animator):void {
			_hierarchyAnimator = animator;
		}
		
		/**
		 * @private
		 */
		protected function _changeAnimatorAvatar(avatar:Avatar):void {
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onAdded():void {
			if (_parent is Sprite3D) {
				var parent3D:Sprite3D = _parent as Sprite3D;
				transform._setParent(parent3D.transform);
				if (parent3D._hierarchyAnimator) {
					(!_hierarchyAnimator) && (_setHierarchyAnimator(parent3D._hierarchyAnimator, null));//执行条件为sprite3D._hierarchyAnimator==parentAnimator,只有一种情况sprite3D._hierarchyAnimator=null成立,且_hierarchyAnimator不为空有意义
					parent3D._changeAnimatorsToLinkSprite3D(this, true, new <String>[name]);//TODO:是否获取默认值函数移到active事件函数内，U3D修改active会重新获取默认值
				}
			}
			super._onAdded();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onRemoved():void {
			super._onRemoved();
			
			if (_parent is Sprite3D) {
				var parent3D:Sprite3D = _parent as Sprite3D;
				transform._setParent(null);
				if (parent3D._hierarchyAnimator) {
					(_hierarchyAnimator == parent3D._hierarchyAnimator) && (_clearHierarchyAnimator(parent3D._hierarchyAnimator, null));//_hierarchyAnimator不为空有意义
					parent3D._changeAnimatorsToLinkSprite3D(this, false, new <String>[name]);//TODO:是否获取默认值函数移到active事件函数内，U3D修改active会重新获取默认值
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			(data.isStatic !== undefined) && (_isStatic = data.isStatic);
			(data.active !== undefined) && (active = data.active);
			(data.name != undefined) && (name = data.name);
			
			if (data.position !== undefined) {
				var loccalPosition:Vector3 = transform.localPosition;
				loccalPosition.fromArray(data.position);
				transform.localPosition = loccalPosition;
			}
			
			if (data.rotationEuler !== undefined) {
				var localRotationEuler:Vector3 = transform.localRotationEuler;
				localRotationEuler.fromArray(data.rotationEuler);
				transform.localRotationEuler = localRotationEuler;
			}
			if (data.rotation !== undefined) {
				var localRotation:Quaternion = transform.localRotation;
				localRotation.fromArray(data.rotation);
				transform.localRotation = localRotation;
			}
			
			if (data.scale !== undefined) {
				var localScale:Vector3 = transform.localScale;
				localScale.fromArray(data.scale);
				transform.localScale = localScale;
			}
			
			(data.layer != undefined) && (layer = data.layer);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			if (destroyed)
				throw new Error("Sprite3D: Can't be cloned if the Sprite3D has destroyed.");
			
			var destSprite3D:Sprite3D = destObject as Sprite3D;
			
			for (var i:int = 0, n:int = _children.length; i < n; i++)
				destSprite3D.addChild(_children[i].clone());
			
			destSprite3D.name = name/* + "(clone)"*/;//TODO:克隆后不能播放刚体动画，找不到名字
			destSprite3D.destroyed = destroyed;
			
			destSprite3D.active = active;
			
			var destLocalPosition:Vector3 = destSprite3D.transform.localPosition;
			transform.localPosition.cloneTo(destLocalPosition);
			destSprite3D.transform.localPosition = destLocalPosition;
			
			var destLocalRotation:Quaternion = destSprite3D.transform.localRotation;
			transform.localRotation.cloneTo(destLocalRotation);
			destSprite3D.transform.localRotation = destLocalRotation;
			
			var destLocalScale:Vector3 = destSprite3D.transform.localScale;
			transform.localScale.cloneTo(destLocalScale);
			destSprite3D.transform.localScale = destLocalScale;
			
			destSprite3D._isStatic = _isStatic;
			destSprite3D.layer = layer;
			super._cloneTo(destSprite3D);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destSprite3D:Sprite3D = __JS__("new this.constructor()");
			cloneTo(destSprite3D);
			return destSprite3D;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			
			super.destroy(destroyChild);
			_transform = null;
			_scripts = null;
			_url && Loader.clearRes(_url);
		}
	}
}