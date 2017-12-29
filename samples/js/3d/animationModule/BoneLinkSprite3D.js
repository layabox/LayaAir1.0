//初始化引擎
Laya3D.init(0, 0, true);

this.statue = 0;
this._dragonScale = new Laya.Vector3(1.5, 1.5, 1.5);
this._rotation = new Laya.Quaternion(-0.5, -0.5, 0.5, -0.5);
this._position = new Laya.Vector3(-0.2, 0.0, 0.0);
this._scale = new Laya.Vector3(0.75, 0.75, 0.75);

//适配模式
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

//开启统计信息
Laya.Stat.show();

//预加载所有资源
var resource = [
    { url: "../../res/threeDimen/skinModel/Mount/R_kl_H_001.lh", clas: Laya.Sprite3D, priority: 1 },
    { url: "../../res/threeDimen/skinModel/Mount/R_kl_S_009.lh", clas: Laya.Sprite3D, priority: 1 },
    { url: "../../res/threeDimen/skinModel/SiPangZi/PanZi.lh", clas: Laya.Sprite3D, priority: 1 }
];

Laya.loader.create(resource, Laya.Handler.create(this, onLoadFinish));

function onLoadFinish() {
    //初始化场景
    var scene = Laya.stage.addChild(new Laya.Scene());
    scene.ambientColor = new Laya.Vector3(1, 1, 1);

    //初始化相机
    var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
    camera.transform.translate(new Laya.Vector3(0, 3, 5));
    camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
    camera.addComponent(CameraMoveScript);

    //初始化角色精灵
    var role = scene.addChild(new Laya.Sprite3D());

    //初始化胖子
    var pangzi = role.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/SiPangZi/PanZi.lh"));
    //获取动画组件
    var animator = (pangzi.getChildAt(0)).getComponentByType(Laya.Animator);
    //获取动画片段
    var totalAnimationClip = animator.getClip("Take 001");
    //新增动画片段
    animator.addClip(totalAnimationClip, "hello", 296, 346);
    animator.addClip(totalAnimationClip, "ride", 3, 33);
    //播放动画
    animator.play("hello", 1);

    Laya.stage.on(Laya.Event.MOUSE_UP, this, function () {

        this.statue++;
        if (this.statue % 3 == 1) {

            animator.play("ride", 1);

            this.dragon1 = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Mount/R_kl_H_001.lh"));
            this.dragon1.transform.localScale = this._dragonScale;
            this.dragonAnimator1 = this.dragon1.getChildAt(0).getComponentByType(Laya.Animator);
            var totalAnimationClip1 = this.dragonAnimator1.getClip("Take 001");
            totalAnimationClip1.islooping = true;
            this.dragonAnimator1.addClip(totalAnimationClip1, "run", 50, 65);
            this.dragonAnimator1.play("run", 1);
            //骨骼关联节点
            this.dragonAnimator1.linkSprite3DToAvatarNode("point", role);

            pangzi.transform.localRotation = this._rotation;
            pangzi.transform.localPosition = this._position;
            pangzi.transform.localScale = this._scale;
        }
        else if (this.statue % 3 == 2) {

            animator.play("ride", 1);
            //骨骼取消关联节点
            this.dragonAnimator1.unLinkSprite3DToAvatarNode(role);
            this.dragon1.removeSelf();

            this.dragon2 = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Mount/R_kl_S_009.lh"));
            this.dragon2.transform.localScale = this._dragonScale;
            this.dragonAnimator2 = this.dragon2.getChildAt(0).getComponentByType(Laya.Animator);
            var totalAnimationClip2 = this.dragonAnimator2.getClip("Take 001");
            totalAnimationClip2.islooping = true;
            this.dragonAnimator2.addClip(totalAnimationClip2, "run", 50, 65);
            this.dragonAnimator2.play("run", 1);
            //骨骼关联节点
            this.dragonAnimator2.linkSprite3DToAvatarNode("point", role);

            pangzi.transform.localRotation = this._rotation;
            pangzi.transform.localPosition = this._position;
            pangzi.transform.localScale = this._scale;
        }
        else {

            animator.play("hello", 1);
            //骨骼取消关联节点
            this.dragonAnimator2.unLinkSprite3DToAvatarNode(role);
            this.dragon2.removeSelf();
        }
    });
}

