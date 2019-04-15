package physics {
import laya.d3.core.RenderableSprite3D;
import laya.d3.core.scene.BoundsOctree;
import laya.d3.core.scene.BoundsOctreeNode;
import laya.d3.core.scene.IOctreeObject;
import laya.d3.math.BoundBox;
import laya.d3.math.BoundSphere;
import laya.d3.math.Vector3;
import laya.d3Extend.physics.triggerEventDistributedModule.D_manager.TriggerManager;
import laya.d3Extend.physics.triggerEventDistributedModule.E_function.cell.GlobalOnlyValueCell;
import laya.components.Script;
import laya.d3.core.MeshSprite3D;
import laya.d3.core.SkinnedMeshSprite3D;
import laya.d3.resource.models.Mesh;
import laya.display.Node;
import laya.d3.component.Script3D;
import laya.d3.core.Sprite3D;
import laya.d3.math.Matrix4x4;
import sprite3dModule.Sprite3DClone;
//import laya.maker.plugin.extend.Script3DExtend;

/**
 * ...
 * @author ...
 */
public class CubePhysicsCompnent extends Script implements IOctreeObject{
    /**
     * 该物体是否时静态
     */
    public var isStatic:Boolean;
    /** @private 长方体类型碰撞器*/
    public static var TYPE_BOX:int = 0;
    /** @private 球类型碰撞器*/
    public static var TYPE_SPHERE:int = 1;
    /** @private 盒子类型*/
    public static var TYPE_CUBESPRIT3D:int = 2;

	
	//使用此物理时先给碰撞盒位置
	//更新包围盒
	/** @private 碰撞范围的中心*/
	public static var centerSprite:Vector3 = new Vector3(0, 0, 0);
	/** @private 碰撞范围*/
	public static var extents:Vector3 = new Vector3(8, 8, 8);
	/** @private 主动碰撞盒*/
	public static var boundBox:BoundBox = new BoundBox();
	/** @private 八叉树*/
	public static var _octree:BoundsOctree = new BoundsOctree(64, new Vector3(0, 0, 0), 4, 1.25);
	
	/**
     * 该组件的唯一ID
     */
    public var onlyID:int;
    /** @private 被挂脚本的精灵*/
    protected var _sprite3D:Sprite3D;

    /** @private 是否是主动检测物体*/
    private var isRigebody:Boolean = false;
    /** @private 类型包围盒*/
    public var type:int;

    /** @private 物体模型的模型矩阵*/
    protected var _localmatrix4x4:Matrix4x4;
    /** @private 物体模型的世界矩阵*/
    protected var _worldMatrix4x4:Matrix4x4;


	/**@private 碰撞盒*/
	public var _boundBox:BoundBox = new BoundBox(new Vector3(0,0,0),new Vector3(0,0,0));
	/**@private 碰撞球*/
	public var _boundSpheres:BoundSphere = new BoundSphere(new Vector3(0,0,0),0);
	
	/**@private 临时变量*/
	private static var _tempVectormax:Vector3 = new Vector3(0, 0, 0);
	private static var _tempVectormin:Vector3 = new Vector3(0, 0, 0);
	/**@private 八叉树节点*/
	public var _octreeNode:BoundsOctreeNode;
	/** @private */
	public var _indexInOctreeMotionList:int = -1;	
	
    /**
     * 构造函数 准备好数据
     */
    public function CubePhysicsCompnent() {
		
    }

    /**
     * 静态函数
     * @param 两个需要检测的碰撞物体
     */
    public function isCollision(other:CubePhysicsCompnent):int {
		return 0;
    }
	
	
	/**
     * 静态函数
     * @param 更新物理包围盒
     */
	public static function updataBoundBox():void
	{
		boundBox.setCenterAndExtent(centerSprite, extents);
	}
	
	
	/**
     * 静态函数
     * @param 查找所有Mesh
     */
	public static function findAllMesh(sprite:Node,Mesharray:Vector.<Mesh>,renderspriteArray:Vector.<RenderableSprite3D>):void
	{
		var tempMesh:Mesh;
		var childsprite:Node;
		if (!Mesharray) Mesharray= new Vector.<Mesh>();
		
		if (sprite is Sprite3D)
		{
			if (sprite is MeshSprite3D)
			{
				tempMesh = (sprite as MeshSprite3D).meshFilter.sharedMesh;
				if (tempMesh) Mesharray.push(tempMesh);
				renderspriteArray.push(sprite);
				if ((sprite).numChildren != 0)
				{
					for (var i:int = 0; i < sprite.numChildren; i++) {
						childsprite = (sprite).getChildAt(i);
						findAllMesh(childsprite, Mesharray,renderspriteArray);
					}
				}
			}
			else if (sprite is SkinnedMeshSprite3D)
			{
				tempMesh = (sprite as SkinnedMeshSprite3D).meshFilter.sharedMesh;
				if (tempMesh) Mesharray.push(tempMesh);
				renderspriteArray.push(sprite);
				if ((sprite).numChildren != 0)
				{
					for (var j:int = 0; j < sprite.numChildren; j++) {
						childsprite = sprite.getChildAt(j);
						findAllMesh(childsprite, Mesharray,renderspriteArray);
					}
				}
			}
			else
			{
				if ((sprite).numChildren != 0)
				{
					for (var k:int = 0; k < sprite.numChildren; k++) {
						childsprite = sprite.getChildAt(k);
						findAllMesh(childsprite, Mesharray,renderspriteArray);
					}
				}
			}
		}
	}
	
	/**
	* @private
	*/
	public function _getOctreeNode():BoundsOctreeNode {//[实现IOctreeObject接口]
		return _octreeNode;
	}
	/**
	 * @private
	 */
	public function _setOctreeNode(value:BoundsOctreeNode):void {//[实现IOctreeObject接口]
		_octreeNode = value;
	}
	
	/**
	 * @private
	 */
	public function _getIndexInMotionList():int {//[实现IOctreeObject接口]
		return _indexInOctreeMotionList;
	}
	
	/**
	 * @private
	 */
	public function _setIndexInMotionList(value:int):void {//[实现IOctreeObject接口]
		_indexInOctreeMotionList = value;
	}
	
	/**
	 * 获取包围球,只读,不允许修改其值。
	 * @return 包围球。
	 */
	public function get boundingSphere():BoundSphere {
		return _boundSpheres;
	}
	
	
	/**
	 * 获取包围盒,只读,不允许修改其值。
	 * @return 包围盒。
	 */
	public function get boundingBox():BoundBox {
		
		return _boundBox;
	}
	
	/**
     * 静态函数 根据八叉树来检测是否检测物理碰撞
     * @param 两个需要检测的碰撞物体
	 * 返回true
     */
	public static function isBoundsCollision(Physics1:CubePhysicsCompnent,Physics2:CubePhysicsCompnent):Boolean
	{
		if (!Physics1._octreeNode.isCollidingWithBoundBox(boundBox))
		 return false;
		else if (!Physics2._octreeNode.isCollidingWithBoundBox(boundBox))
		return false;
		else
		 return true;
		
	}

	override public function onAwake():void
	{
		super .onAwake();
        onlyID = GlobalOnlyValueCell.getOnlyID();
	}

    override public function onEnable():void {
        super.onEnable();
        if (isStatic) {
            TriggerManager.instance.addStatic(this);
        }
        else {
         //   TriggerManager.instance.addDY(this);
        }
    }

    override public function onDisable():void {
        super.onDisable();
        if (isStatic) {
            TriggerManager.instance.removeStatic(this);
        }
        else {
            TriggerManager.instance.removeDY(this);
        }
    }

    override public function onDestroy():void {
        if (isStatic) {
            TriggerManager.instance.removeStatic(this);
        }
        else {
            TriggerManager.instance.removeDY(this);
        }
        super.onDestroy();
    }
	
}


}