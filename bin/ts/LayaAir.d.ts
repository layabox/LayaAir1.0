declare module laya.ani {
    /**
     * ...
     * @author ...
     */
    class AnimationContent {
        nodes: Array<any>;
        name: string;
        playTime: number;
        bone3DMap: any;
        totalKeyframeDatasLength: number;
    }
}
declare module laya.ani {
    /**
     * ...
     * @author ...
     */
    class AnimationNodeContent {
        name: string;
        parentIndex: number;
        parent: AnimationNodeContent;
        keyframeWidth: number;
        lerpType: number;
        interpolationMethod: Array<any>;
        childs: Array<any>;
        keyFrame: Array<any>;
        playTime: number;
        extenData: ArrayBuffer;
        dataOffset: number;
    }
}
declare module laya.ani {
    /**
     * @private
     */
    class AnimationParser01 {
        /**
         * @private
         */
        static parse(templet: AnimationTemplet, reader: laya.utils.Byte): void;
    }
}
declare module laya.ani {
    /**
     * @private
     */
    class AnimationParser02 {
        private static _templet;
        private static _reader;
        private static _strings;
        private static _BLOCK;
        private static _DATA;
        /**
         * @private
         */
        static parse(templet: AnimationTemplet, reader: laya.utils.Byte): void;
        static READ_ANIMATIONS(): void;
    }
}
declare module laya.ani {
    /**
     * <code>AnimationPlayer</code> 类用于动画播放器。
     */
    class AnimationPlayer extends laya.events.EventDispatcher implements laya.resource.IDestroy {
        _fullFrames: Array<any>;
        /**是否缓存*/
        isCache: boolean;
        /** 播放速率*/
        playbackRate: number;
        /** 停止时是否归零*/
        returnToZeroStopped: boolean;
        /**
         * 获取动画数据模板
         * @param	value 动画数据模板
         */
        /**
         * 设置动画数据模板,注意：修改此值会有计算开销。
         * @param	value 动画数据模板
         */
        templet: AnimationTemplet;
        /**
         * 动画播放的起始时间位置。
         * @return	 起始时间位置。
         */
        playStart: number;
        /**
         * 动画播放的结束时间位置。
         * @return	 结束时间位置。
         */
        playEnd: number;
        /**
         * 获取动画播放一次的总时间
         * @return	 动画播放一次的总时间
         */
        playDuration: number;
        /**
         * 获取动画播放的总总时间
         * @return	 动画播放的总时间
         */
        overallDuration: number;
        /**
         * 获取当前动画索引
         * @return	value 当前动画索引
         */
        currentAnimationClipIndex: number;
        /**
         * 获取当前帧数
         * @return	 当前帧数
         */
        currentKeyframeIndex: number;
        /**
         *  获取当前精确时间，不包括重播时间
         * @return	value 当前时间
         */
        currentPlayTime: number;
        /**
         *  获取当前帧时间，不包括重播时间
         * @return	value 当前时间
         */
        currentFrameTime: number;
        /**
         *  获取缓存播放速率。*
         * @return	 缓存播放速率。
         */
        /**
         *  设置缓存播放速率,默认值为1.0,注意：修改此值会有计算开销。*
         * @return	value 缓存播放速率。
         */
        cachePlayRate: number;
        /**
         *  获取默认帧率*
         * @return	value 默认帧率
         */
        /**
         *  设置默认帧率,每秒60帧,注意：修改此值会有计算开销。*
         * @return	value 缓存帧率
         */
        cacheFrameRate: number;
        /**
         * 设置当前播放位置
         * @param	value 当前时间
         */
        currentTime: number;
        /**
         * 获取当前是否暂停
         * @return	是否暂停
         */
        /**
         * 设置是否暂停
         * @param	value 是否暂停
         */
        paused: boolean;
        /**
         * 获取缓存帧率间隔时间
         * @return	缓存帧率间隔时间
         */
        cacheFrameRateInterval: number;
        /**
         * 获取当前播放状态
         * @return	当前播放状态
         */
        state: number;
        /**
         * 获取是否已销毁。
         * @return 是否已销毁。
         */
        destroyed: boolean;
        /**
         * 创建一个 <code>AnimationPlayer</code> 实例。
         */
        constructor();
        /**
         * @private
         */
        _onTempletLoadedComputeFullKeyframeIndices(cachePlayRate: number, cacheFrameRate: number, templet: AnimationTemplet): void;
        /**
         * @private
         */
        _update(elapsedTime: number): void;
        /**
         * @private
         */
        _destroy(): void;
        /**
         * 播放动画。
         * @param	index 动画索引。
         * @param	playbackRate 播放速率。
         * @param	duration 播放时长（0为1次,Number.MAX_VALUE为循环播放）。
         * @param	playStart 播放的起始时间位置。
         * @param	playEnd 播放的结束时间位置。（0为动画一次循环的最长结束时间位置）。
         */
        play(index?: number, playbackRate?: number, overallDuration?: number, playStart?: number, playEnd?: number): void;
        /**
         * 播放动画。
         * @param	index 动画索引。
         * @param	playbackRate 播放速率。
         * @param	duration 播放时长（0为1次,Number.MAX_VALUE为循环播放）。
         * @param	playStartFrame 播放的原始起始帧率位置。
         * @param	playEndFrame 播放的原始结束帧率位置。（0为动画一次循环的最长结束时间位置）。
         */
        playByFrame(index?: number, playbackRate?: number, overallDuration?: number, playStartFrame?: number, playEndFrame?: number, fpsIn3DBuilder?: number): void;
        /**
         * 停止播放当前动画
         * @param	immediate 是否立即停止
         */
        stop(immediate?: boolean): void;
    }
}
declare module laya.ani {
    /**
     * @private
     */
    class AnimationState {
        static stopped: number;
        static paused: number;
        static playing: number;
        constructor();
    }
}
declare module laya.ani {
    /**
     * <code>AnimationTemplet</code> 类用于动画模板资源。
     */
    class AnimationTemplet extends laya.resource.Resource {
        static interpolation: Array<any>;
        /**
         * 加载动画模板。
         * @param url 动画模板地址。
         */
        static load(url: string): AnimationTemplet;
        _aniVersion: string;
        _anis: Array<any>;
        _aniMap: any;
        _publicExtData: ArrayBuffer;
        _useParent: boolean;
        protected unfixedCurrentFrameIndexes: Uint32Array;
        protected unfixedCurrentTimes: Float32Array;
        protected unfixedKeyframes: Array<any>;
        protected unfixedLastAniIndex: number;
        _aniClassName: string;
        _animationDatasCache: any;
        constructor();
        /**
         * @private
         */
        parse(data: ArrayBuffer): void;
        /**
         * @private
         */
        _endLoaded(): void;
        /**
         * @private
         */
        _calculateKeyFrame(node: AnimationNodeContent, keyframeCount: number, keyframeDataCount: number): void;
        /**
         * @inheritDoc
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        getAnimationCount(): number;
        getAnimation(aniIndex: number): any;
        getAniDuration(aniIndex: number): number;
        getNodes(aniIndex: number): any;
        getNodeIndexWithName(aniIndex: number, name: string): number;
        getNodeCount(aniIndex: number): number;
        getTotalkeyframesLength(aniIndex: number): number;
        getPublicExtData(): ArrayBuffer;
        getAnimationDataWithCache(key: any, cacheDatas: any, aniIndex: number, frameIndex: number): Float32Array;
        setAnimationDataWithCache(key: any, cacheDatas: Array<any>, aniIndex: number, frameIndex: number, data: any): void;
        getOriginalData(aniIndex: number, originalData: Float32Array, nodesFrameIndices: Array<any>, frameIndex: number, playCurTime: number): void;
        getNodesCurrentFrameIndex(aniIndex: number, playCurTime: number): Uint32Array;
        getOriginalDataUnfixedRate(aniIndex: number, originalData: Float32Array, playCurTime: number): void;
        dispose(): void;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class Bone {
        static ShowBones: any;
        name: string;
        root: Bone;
        parentBone: Bone;
        length: number;
        transform: Transform;
        resultTransform: Transform;
        resultMatrix: laya.maths.Matrix;
        inheritScale: boolean;
        inheritRotation: boolean;
        rotation: number;
        resultRotation: number;
        d: number;
        constructor();
        setTempMatrix(matrix: laya.maths.Matrix): void;
        update(pMatrix?: laya.maths.Matrix): void;
        updateChild(): void;
        setRotation(rd: number): void;
        updateDraw(x: number, y: number): void;
        addChild(bone: Bone): void;
        findBone(boneName: string): Bone;
        localToWorld(local: Array<any>): void;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class BoneSlot {
        /** 插槽名称 */
        name: string;
        /** 插槽绑定的骨骼名称 */
        parent: string;
        /** 插糟显示数据数据的名称 */
        attachmentName: string;
        /** 原始数据的索引 */
        srcDisplayIndex: number;
        /** 判断对象是否是原对象 */
        type: string;
        /** 模板的指针 */
        templet: Templet;
        /** 当前插槽对应的数据 */
        currSlotData: SlotData;
        /** 当前插槽显示的纹理 */
        currTexture: laya.resource.Texture;
        /** 显示对象对应的数据 */
        currDisplayData: SkinSlotDisplayData;
        /** 显示皮肤的索引 */
        displayIndex: number;
        deformData: Array<any>;
        /**
         * 设置要显示的插槽数据
         * @param	slotData
         * @param	disIndex
         * @param	freshIndex 是否重置纹理
         */
        showSlotData(slotData: SlotData, freshIndex?: boolean): void;
        /**
         * 通过名字显示指定对象
         * @param	name
         */
        showDisplayByName(name: string): void;
        /**
         * 替换贴图名
         * @param	tarName 要替换的贴图名
         * @param	newName 替换后的贴图名
         */
        replaceDisplayByName(tarName: string, newName: string): void;
        /**
         * 替换贴图索引
         * @param	tarIndex 要替换的索引
         * @param	newIndex 替换后的索引
         */
        replaceDisplayByIndex(tarIndex: number, newIndex: number): void;
        /**
         * 指定显示对象
         * @param	index
         */
        showDisplayByIndex(index: number): void;
        /**
         * 替换皮肤
         * @param	_texture
         */
        replaceSkin(_texture: laya.resource.Texture): void;
        /**
         * 保存父矩阵的索引
         * @param	parentMatrix
         */
        setParentMatrix(parentMatrix: laya.maths.Matrix): void;
        private static _tempMatrix;
        /**
         * 把纹理画到Graphics上
         * @param	graphics
         * @param	noUseSave
         */
        draw(graphics: laya.ani.GraphicsAni, boneMatrixArray: Array<any>, noUseSave?: boolean, alpha?: number): void;
        /**
         * 画骨骼的起始点，方便调试
         * @param	graphics
         */
        drawBonePoint(graphics: laya.display.Graphics): void;
        /**
         * 得到插糟的矩阵
         * @return
         */
        getMatrix(): laya.maths.Matrix;
        /**
         * 用原始数据拷贝出一个
         * @return
         */
        copy(): BoneSlot;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class DeformAniData {
        skinName: string;
        deformSlotDataList: Array<any>;
        constructor();
    }
}
declare module laya.ani.bone {
    /**
     * ...
     * @author
     */
    class DeformSlotData {
        deformSlotDisplayList: Array<any>;
        constructor();
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class DeformSlotDisplayData {
        boneSlot: BoneSlot;
        slotIndex: number;
        attachment: string;
        timeList: Array<any>;
        vectices: Array<any>;
        tweenKeyList: Array<any>;
        deformData: Array<any>;
        frameIndex: number;
        constructor();
        apply(time: number, boneSlot: BoneSlot, alpha?: number): void;
    }
}
declare module laya.ani.bone {
    /**
     * ...
     * @author
     */
    class DrawOrderData {
        time: number;
        drawOrder: Array<any>;
        constructor();
    }
}
declare module laya.ani.bone {
    class EventData {
        name: string;
        intValue: number;
        floatValue: number;
        stringValue: string;
        time: number;
        constructor();
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class IkConstraint {
        name: string;
        mix: number;
        bendDirection: number;
        isSpine: boolean;
        static radDeg: number;
        static degRad: number;
        private static _tempMatrix;
        constructor(data: IkConstraintData, bones: Array<any>);
        apply(): void;
        updatePos(x: number, y: number): void;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class IkConstraintData {
        name: string;
        targetBoneName: string;
        boneNames: Array<any>;
        bendDirection: number;
        mix: number;
        isSpine: boolean;
        targetBoneIndex: number;
        boneIndexs: Array<any>;
        constructor();
    }
}
declare module laya.ani.bone {
    /**
     * @private
     * 路径作用器
     * 1，生成根据骨骼计算控制点
     * 2，根据控制点生成路径，并计算路径上的节点
     * 3，根据节点，重新调整骨骼位置
     */
    class PathConstraint {
        target: BoneSlot;
        data: PathConstraintData;
        bones: Array<any>;
        position: number;
        spacing: number;
        rotateMix: number;
        translateMix: number;
        constructor(data: PathConstraintData, bones: Array<any>);
        /**
         * 计算骨骼在路径上的节点
         * @param	boneSlot
         * @param	boneMatrixArray
         * @param	graphics
         */
        apply(boneList: Array<any>, graphics: laya.display.Graphics): void;
        /**
         * 计算顶点的世界坐标
         * @param	boneSlot
         * @param	boneList
         * @param	start
         * @param	count
         * @param	worldVertices
         * @param	offset
         */
        computeWorldVertices2(boneSlot: BoneSlot, boneList: Array<any>, start: number, count: number, worldVertices: Array<any>, offset: number): void;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class PathConstraintData {
        name: string;
        bones: Array<any>;
        target: string;
        positionMode: string;
        spacingMode: string;
        rotateMode: string;
        offsetRotation: number;
        position: number;
        spacing: number;
        rotateMix: number;
        translateMix: number;
        constructor();
    }
}
declare module laya.ani.bone {
    /**
     * 骨骼动画由Templet,AnimationPlayer,Skeleton三部分组成
     */
    class Skeleton extends laya.display.Sprite {
        protected _templet: laya.ani.bone.Templet;
        protected _player: laya.ani.AnimationPlayer;
        protected _curOriginalData: Float32Array;
        protected _aniClipIndex: number;
        protected _clipIndex: number;
        protected _boneList: Array<any>;
        protected _aniSectionDic: any;
        /**
         * 创建一个Skeleton对象
         * 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改					（内存开销小，计算开销小，不支持换装）
         * 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）
         * 2,使用动态方式，去实时去画										（内存开销小，计算开销大，支持换装,不建议使用）
         * @param	templet	骨骼动画模板
         * @param	aniMode	动画模式，0:不支持换装,1,2支持换装
         */
        constructor(templet?: laya.ani.bone.Templet, aniMode?: number);
        /**
         * 初始化动画
         * 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改					（内存开销小，计算开销小，不支持换装）
         * 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）
         * 2,使用动态方式，去实时去画										（内存开销小，计算开销大，支持换装,不建议使用）
         * @param	templet		模板
         * @param	aniMode		动画模式，0:不支持换装,1,2支持换装
         */
        init(templet: laya.ani.bone.Templet, aniMode?: number): void;
        /**
         * 得到资源的URL
         */
        /**
         * 设置动画路径
         */
        url: string;
        /**
         * 通过加载直接创建动画
         * @param	path		要加载的动画文件路径
         * @param	complete	加载完成的回调函数
         * @param	aniMode		 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改（内存开销小，计算开销小，不支持换装） 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）2,使用动态方式，去实时去画（内存开销小，计算开销大，支持换装,不建议使用）
         */
        load(path: string, complete?: laya.utils.Handler, aniMode?: number): void;
        protected _createGraphics(_clipIndex?: number): void;
        /**
         * 得到当前动画的数量
         * @return
         */
        getAnimNum(): number;
        /**
         * 得到指定动画的名字
         * @param	index	动画的索引
         */
        getAniNameByIndex(index: number): string;
        /**
         * 通过名字得到插槽的引用
         * @param	name	动画的名字
         * @return
         */
        getSlotByName(name: string): laya.ani.bone.BoneSlot;
        /**
         * 通过名字显示一套皮肤
         * @param	name	皮肤的名字
         * @param	freshSlotIndex	是否将插槽纹理重置到初始化状态
         */
        showSkinByName(name: string, freshSlotIndex?: boolean): void;
        /**
         * 通过索引显示一套皮肤
         * @param	skinIndex	皮肤索引
         * @param	freshSlotIndex	是否将插槽纹理重置到初始化状态
         */
        showSkinByIndex(skinIndex: number, freshSlotIndex?: boolean): void;
        /**
         * 设置某插槽的皮肤
         * @param	slotName	插槽名称
         * @param	index	插糟皮肤的索引
         */
        showSlotSkinByIndex(slotName: string, index: number): void;
        /**
         * 设置某插槽的皮肤
         * @param	slotName	插槽名称
         * @param	name	皮肤名称
         */
        showSlotSkinByName(slotName: string, name: string): void;
        /**
         * 替换插槽贴图名
         * @param	slotName 插槽名称
         * @param	oldName 要替换的贴图名
         * @param	newName 替换后的贴图名
         */
        replaceSlotSkinName(slotName: string, oldName: string, newName: string): void;
        /**
         * 替换插槽的贴图索引
         * @param	slotName 插槽名称
         * @param	oldIndex 要替换的索引
         * @param	newIndex 替换后的索引
         */
        replaceSlotSkinByIndex(slotName: string, oldIndex: number, newIndex: number): void;
        /**
         * 设置自定义皮肤
         * @param	name		插糟的名字
         * @param	texture		自定义的纹理
         */
        setSlotSkin(slotName: string, texture: laya.resource.Texture): void;
        /**
         * 播放动画
         * @param	nameOrIndex	动画名字或者索引
         * @param	loop		是否循环播放
         * @param	force		false,如果要播的动画跟上一个相同就不生效,true,强制生效
         * @param	start		起始时间
         * @param	end			结束时间
         * @param	freshSkin	是否刷新皮肤数据
         */
        play(nameOrIndex: any, loop: boolean, force?: boolean, start?: number, end?: number, freshSkin?: boolean): void;
        /**
         * 停止动画
         */
        stop(): void;
        /**
         * 设置动画播放速率
         * @param	value	1为标准速率
         */
        playbackRate(value: number): void;
        /**
         * 暂停动画的播放
         */
        paused(): void;
        /**
         * 恢复动画的播放
         */
        resume(): void;
        /**
         * 销毁当前动画
         */
        destroy(destroyChild?: boolean): void;
        /**
         * @private
         * 得到帧索引
         */
        /**
         * @private
         * 设置帧索引
         */
        index: number;
        /**
         * 得到总帧数据
         */
        total: number;
        /**
         * 得到播放器的引用
         */
        player: laya.ani.AnimationPlayer;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class SkinData {
        name: string;
        slotArr: Array<any>;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class SkinSlotDisplayData {
        name: string;
        attachmentName: string;
        type: number;
        transform: Transform;
        width: number;
        height: number;
        texture: laya.resource.Texture;
        bones: Array<any>;
        uvs: Array<any>;
        weights: Array<any>;
        triangles: Array<any>;
        vertices: Array<any>;
        lengths: Array<any>;
        verLen: number;
        createTexture(currTexture: laya.resource.Texture): laya.resource.Texture;
        destory(): void;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class SlotData {
        name: string;
        displayArr: Array<any>;
        getDisplayByName(name: string): number;
    }
}
declare module laya.ani.bone {
    /**
     * 动画模板类
     */
    class Templet extends laya.ani.AnimationTemplet {
        static LAYA_ANIMATION_VISION: string;
        static TEMPLET_DICTIONARY: any;
        /** 存放原始骨骼信息 */
        srcBoneMatrixArr: Array<any>;
        /** IK数据 */
        ikArr: Array<any>;
        /** transform数据 */
        tfArr: Array<any>;
        /** path数据 */
        pathArr: Array<any>;
        /** 存放插槽数据的字典 */
        boneSlotDic: any;
        /** 绑定插槽数据的字典 */
        bindBoneBoneSlotDic: any;
        /** 存放插糟数据的数组 */
        boneSlotArray: Array<any>;
        /** 皮肤数据 */
        skinDataArray: Array<any>;
        /** 皮肤的字典数据 */
        skinDic: any;
        /** 存放纹理数据 */
        subTextureDic: any;
        /** 是否解析失败 */
        isParseFail: boolean;
        /** 反转矩阵，有些骨骼动画要反转才能显示 */
        yReverseMatrix: laya.maths.Matrix;
        /** 渲染顺序动画数据 */
        drawOrderAniArr: Array<any>;
        /** 事件动画数据 */
        eventAniArr: Array<any>;
        attachmentNames: Array<any>;
        /** 顶点动画数据 */
        deformAniArr: Array<any>;
        /** 实际显示对象列表，用于销毁用 */
        skinSlotDisplayDataArr: Array<any>;
        aniSectionDic: any;
        tMatrixDataLen: number;
        mRootBone: Bone;
        mBoneArr: Array<any>;
        loadAni(url: string): void;
        /**
         * 解析骨骼动画数据
         * @param	texture			骨骼动画用到的纹理
         * @param	skeletonData	骨骼动画信息及纹理分块信息
         * @param	playbackRate	缓冲的帧率数据（会根据帧率去分帧）
         */
        parseData(texture: laya.resource.Texture, skeletonData: ArrayBuffer, playbackRate?: number): void;
        /**
         * 创建动画
         * 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改					（内存开销小，计算开销小，不支持换装）
         * 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存	（内存开销大，计算开销小，支持换装）
         * 2,使用动态方式，去实时去画										（内存开销小，计算开销大，支持换装,不建议使用）
         * @param	aniMode 0	动画模式，0:不支持换装,1,2支持换装
         * @return
         */
        buildArmature(aniMode?: number): Skeleton;
        /**
         * @private
         * 解析动画
         * @param	data			解析的二进制数据
         * @param	playbackRate	帧率
         */
        parse(data: ArrayBuffer): void;
        /**
         * 得到指定的纹理
         * @param	name	纹理的名字
         * @return
         */
        getTexture(name: string): laya.resource.Texture;
        /**
         * @private
         * 显示指定的皮肤
         * @param	boneSlotDic	插糟字典的引用
         * @param	skinIndex	皮肤的索引
         * @param	freshDisplayIndex	是否重置插槽纹理
         */
        showSkinByIndex(boneSlotDic: any, skinIndex: number, freshDisplayIndex?: boolean): boolean;
        /**
         * 通过皮肤名字得到皮肤索引
         * @param	skinName 皮肤名称
         * @return
         */
        getSkinIndexByName(skinName: string): number;
        /**
         * @private
         * 得到缓冲数据
         * @param	aniIndex	动画索引
         * @param	frameIndex	帧索引
         * @return
         */
        getGrahicsDataWithCache(aniIndex: number, frameIndex: number): laya.display.Graphics;
        /**
         * @private
         * 保存缓冲grahpics
         * @param	aniIndex	动画索引
         * @param	frameIndex	帧索引
         * @param	graphics	要保存的数据
         */
        setGrahicsDataWithCache(aniIndex: number, frameIndex: number, graphics: laya.display.Graphics): void;
        /**
         * 释放纹理
         */
        destroy(): void;
        /**
         * 通过索引得动画名称
         * @param	index
         * @return
         */
        getAniNameByIndex(index: number): string;
        rate: number;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class TfConstraint {
        target: Bone;
        rotateMix: number;
        translateMix: number;
        scaleMix: number;
        shearMix: number;
        constructor(data: TfConstraintData, bones: Array<any>);
        apply(): void;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class TfConstraintData {
        name: string;
        boneIndexs: Array<any>;
        targetIndex: number;
        rotateMix: number;
        translateMix: number;
        scaleMix: number;
        shearMix: number;
        offsetRotation: number;
        offsetX: number;
        offsetY: number;
        offsetScaleX: number;
        offsetScaleY: number;
        offsetShearY: number;
    }
}
declare module laya.ani.bone {
    /**
     * @private
     */
    class Transform {
        skX: number;
        skY: number;
        scX: number;
        scY: number;
        x: number;
        y: number;
        skewX: number;
        skewY: number;
        initData(data: any): void;
        getMatrix(): laya.maths.Matrix;
        skew(m: laya.maths.Matrix, x: number, y: number): laya.maths.Matrix;
    }
}
declare module laya.ani.bone {
    /**
     * 用于UV转换的工具类
     * @private
     */
    class UVTools {
        constructor();
        /**
         * 将相对于大图图集的小UV转换成相对某个大图的UV
         * @param	bigUV 某个大图的UV
         * @param	smallUV 大图图集中的UV
         * @return 相对于某个大图的UV
         */
        static getRelativeUV(bigUV: Array<any>, smallUV: Array<any>, rst?: Array<any>): Array<any>;
        /**
         * 将相对于某个大图的UV转换成相对于大图图集的UV
         * @param	bigUV 某个大图的UV
         * @param	smallUV 相对于某个大图的UV
         * @return 相对于大图图集的UV
         */
        static getAbsoluteUV(bigUV: Array<any>, smallUV: Array<any>, rst?: Array<any>): Array<any>;
    }
}
declare module laya.ani {
    class GraphicsAni extends laya.display.Graphics {
        constructor();
        /**
         * @private
         * 画自定义蒙皮动画
         * @param	skin
         */
        drawSkin(skin: any): void;
    }
}
declare module laya.ani {
    /**
     * ...
     * @author ...
     */
    class KeyFramesContent {
        startTime: number;
        duration: number;
        interpolationData: Array<any>;
        data: Float32Array;
        dData: Float32Array;
        nextData: Float32Array;
    }
}
declare module laya.ani.math {
    /**
     * ...
     * @author ww
     */
    class BezierLerp {
        constructor();
        private static _bezierResultCache;
        private static _bezierPointsCache;
        static getBezierRate(t: number, px0: number, py0: number, px1: number, py1: number): number;
    }
}
declare module laya.ani.swf {
    /**
     * <p> <code>MovieClip</code> 用于播放经过工具处理后的 swf 动画。</p>
     */
    class MovieClip extends laya.display.Sprite {
        protected static _ValueList: Array<any>;
        protected _start: number;
        protected _Pos: number;
        protected _data: laya.utils.Byte;
        protected _curIndex: number;
        protected _preIndex: number;
        protected _playIndex: number;
        protected _playing: boolean;
        protected _ended: boolean;
        protected _count: number;
        _ids: any;
        protected _loadedImage: any;
        _idOfSprite: Array<any>;
        _parentMovieClip: MovieClip;
        _movieClipList: Array<any>;
        protected _labels: any;
        /**资源根目录。*/
        basePath: string;
        /** 播放间隔(单位：毫秒)。*/
        interval: number;
        /**是否循环播放 */
        loop: boolean;
        /**
         * 创建一个 <code>MovieClip</code> 实例。
         * @param parentMovieClip 父MovieClip,自己创建时不需要传该参数
         */
        constructor(parentMovieClip?: MovieClip);
        /**
         * <p>销毁此对象。以及销毁引用的Texture</p>
         * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
        _setDisplay(value: boolean): void;
        updates(): void;
        /**当前播放索引。*/
        index: number;
        /**
         * 增加一个标签到index帧上，播放到此index后会派发label事件
         * @param	label	标签名称
         * @param	index	索引位置
         */
        addLabel(label: string, index: number): void;
        /**
         * 删除某个标签
         * @param	label 标签名字，如果label为空，则删除所有Label
         */
        removeLabel(label: string): void;
        /**
         * 帧总数。
         */
        count: number;
        /**
         * 是否在播放中
         */
        playing: boolean;
        /**
         * 停止播放动画。
         */
        stop(): void;
        /**
         * 跳到某帧并停止播放动画。
         * @param frame 要跳到的帧
         */
        gotoAndStop(index: number): void;
        /**
         * 播放动画。
         * @param	index 帧索引。
         */
        play(index?: number, loop?: boolean): void;
        _setData(data: laya.utils.Byte, start: number): void;
        /**
         * 资源地址。
         */
        url: string;
        /**
         * 加载资源。
         * @param	url swf 资源地址。
         * @param   atlas  是否使用图集资源
         * @param   atlasPath  图集路径，默认使用与swf同名的图集
         */
        load(url: string, atlas?: boolean, atlasPath?: string): void;
        /**
         * 从开始索引播放到结束索引，结束之后出发complete回调
         * @param	start	开始索引
         * @param	end		结束索引
         * @param	complete	结束回调
         */
        playTo(start: number, end: number, complete?: laya.utils.Handler): void;
    }
}
declare module laya.d3.component.animation {
    /**
     * <code>CameraAnimations</code> 类用于创建摄像机动画组件。
     */
    class CameraAnimations extends KeyframeAnimations {
        protected _cacheAnimationDatas: Array<any>;
        /**变换模式。*/
        localMode: boolean;
        /**叠加模式。*/
        addMode: boolean;
        /**
         * 创建一个新的 <code>CameraAnimations</code> 实例。
         */
        constructor();
        /**
         * @private
         * 初始化载入摄像机动画组件。
         * @param	owner 所属精灵对象。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 更新摄像机动画组件。
         * @param	state 渲染状态。
         */
        _update(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.component.animation {
    /**
     * <code>KeyframeAnimation</code> 类用于帧动画组件的父类。
     */
    class KeyframeAnimations extends laya.d3.component.Component3D {
        protected _player: laya.ani.AnimationPlayer;
        protected _templet: laya.ani.AnimationTemplet;
        /**
         * 设置url地址。
         * @param value 地址。
         */
        url: string;
        /**
         * 获取动画模板。
         * @return value 动画模板。
         */
        /**
         * 设置动画模板。
         * @param value 设置动画模板。
         */
        templet: laya.ani.AnimationTemplet;
        /**
         * 获取动画播放器。
         * @return 动画播放器。
         */
        player: laya.ani.AnimationPlayer;
        /**
         * 获取播放器帧数。
         * @return 播放器帧数。
         */
        currentFrameIndex: number;
        /**
         * 获取播放器的动画索引。
         * @return 动画索引。
         */
        currentAnimationClipIndex: number;
        /**
         * 获取播放器当前动画的节点数量。
         * @return 节点数量。
         */
        nodeCount: number;
        /**
         * 创建一个新的 <code>KeyframeAnimation</code> 实例。
         */
        constructor();
        /**
         * @private
         * 载入组件时执行
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 卸载组件时执行
         */
        _unload(owner: laya.d3.core.Sprite3D): void;
    }
}
declare module laya.d3.component.animation {
    /**
     * <code>RigidAnimations</code> 类用于创建变换动画组件。
     */
    class RigidAnimations extends KeyframeAnimations {
        /**
         * 设置url地址。
         * @param value 地址。
         */
        url: string;
        templet: laya.ani.AnimationTemplet;
        /**
         * 创建一个新的 <code>RigidAnimations</code> 实例。
         */
        constructor();
        /**
         * @private
         * 初始化载入摄像机动画组件。
         * @param	owner 所属精灵对象。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 更新摄像机动画组件。
         * @param	state 渲染状态。
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 卸载组件时执行。
         */
        _unload(owner: laya.d3.core.Sprite3D): void;
    }
}
declare module laya.d3.component.animation {
    /**
     * <code>SkinAnimations</code> 类用于创建蒙皮动画组件。
     */
    class SkinAnimations extends KeyframeAnimations {
        static BONES: number;
        static SHADERDEFINE_BONE: number;
        protected static _splitAnimationDatas(indices: Uint8Array, bonesData: Float32Array, subAnimationDatas: Float32Array): void;
        protected _tempCurAnimationData: Array<any>;
        protected _tempCurBonesData: Float32Array;
        protected _curOriginalData: Float32Array;
        protected _extenData: Float32Array;
        protected _lastFrameIndex: number;
        protected _curMeshAnimationData: Float32Array;
        protected _curBonesDatas: Float32Array;
        protected _curAnimationDatas: Array<any>;
        protected _ownerMesh: laya.d3.core.MeshSprite3D;
        protected _boneIndexToMeshList: Array<any>;
        protected _oldVersion: boolean;
        /**
         * 获取骨骼数据。
         * @return 骨骼数据。
         */
        curBonesDatas: Float32Array;
        templet: laya.ani.AnimationTemplet;
        /**
         * 创建一个新的 <code>SkinAnimations</code> 实例。
         */
        constructor();
        /**
         * @private
         * 初始化载入蒙皮动画组件。
         * @param	owner 所属精灵对象。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 更新蒙皮动画组件。
         * @param	state 渲染状态参数。
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 在渲染前更新蒙皮动画组件渲染参数。
         * @param	state 渲染状态参数。
         */
        _preRenderUpdate(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 卸载组件时执行
         */
        _unload(owner: laya.d3.core.Sprite3D): void;
    }
}
declare module laya.d3.component.animation {
    /**
     * <code>UVAnimations</code> 类用于创建UV动画组件。
     */
    class UVAnimations extends KeyframeAnimations {
        /**
         * 创建一个新的 <code>UVAnimations</code> 实例。
         */
        constructor();
        /**
         * @private
         * 初始化载入UV动画组件。
         * @param	owner 所属精灵对象。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 更新UV动画组件。
         * @param	state 渲染状态参数。
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         *在渲染前更新UV动画组件渲染参数。
         * @param	state 渲染状态参数。
         */
        _preRenderUpdate(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.component {
    /**
     * <code>AttachPoint</code> 类用于创建挂点组件。
     */
    class AttachPoint extends Component3D {
        protected _attachSkeleton: laya.d3.component.animation.SkinAnimations;
        protected _extenData: Float32Array;
        /**挂点骨骼的名称。*/
        attachBones: Array<any>;
        /**挂点骨骼的变换矩阵。*/
        matrixs: Array<any>;
        /**
         * 创建一个新的 <code>AttachPoint</code> 实例。
         */
        constructor();
        /**
         * @private
         * 初始化载入挂点组件。
         * @param	owner 所属精灵对象。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 更新挂点组件。
         * @param	state 渲染状态。
         */
        _update(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.component {
    /**
     * <code>Component3D</code> 类用于创建组件的父类。
     */
    class Component3D extends laya.events.EventDispatcher implements laya.d3.core.render.IUpdate, laya.resource.IDestroy {
        private static _isSingleton;
        protected static _uniqueIDCounter: number;
        protected _id: number;
        protected _cachedOwnerLayerMask: number;
        protected _cachedOwnerActiveInHierarchy: boolean;
        protected _enable: boolean;
        protected _owner: laya.d3.core.Sprite3D;
        /**是否已执行start函数。*/
        started: boolean;
        /**
         * 获取唯一标识ID。
         * @return 唯一标识ID。
         */
        id: number;
        /**
         * 获取所属Sprite3D节点。
         * @return 所属Sprite3D节点。
         */
        owner: laya.d3.core.Sprite3D;
        /**
         * 获取是否启用。
         * @return 是否启动。
         */
        /**
         * 设置是否启用。
         * @param value 是否启动
         */
        enable: boolean;
        /**
         * 获取是否为单实例组件。
         * @return  是否为单实例组件。
         */
        isSingleton: boolean;
        /**
         * 获取是否已销毁。
         * @return 是否已销毁。
         */
        destroyed: boolean;
        /**
         * 创建一个新的 <code>Component3D</code> 实例。
         */
        constructor();
        protected _onLayerChanged(layer: laya.d3.core.Layer): void;
        protected _onActiveHierarchyChanged(active: boolean): void;
        /**
         * @private
         * 初始化组件。
         * @param	owner 所属Sprite3D节点。
         */
        _initialize(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 销毁组件。
         */
        _destroy(): void;
        /**
         * @private
         * 载入组件时执行,可重写此函数。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * @private
         * 在任意第一次更新时执行,可重写此函数。
         */
        _start(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 更新组件,可重写此函数。
         * @param	state 渲染状态参数。
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 更新的最后阶段执行,可重写此函数。
         * @param state 渲染状态参数。
         */
        _lateUpdate(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 渲染前设置组件相关参数,可重写此函数。
         * @param	state 渲染状态参数。
         */
        _preRenderUpdate(state: laya.d3.core.render.RenderState): void;
        /**
         *  @private
         * 渲染的最后阶段执行,可重写此函数。
         * @param	state 渲染状态参数。
         */
        _postRenderUpdate(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 卸载组件时执行,可重写此函数。
         */
        _unload(owner: laya.d3.core.Sprite3D): void;
    }
}
declare module laya.d3.component {
    /**
     * <code>PathFinding</code> 类用于创建寻路。
     */
    class PathFind extends Component3D {
        _setting: any;
        /**寻路网格。*/
        grid: any;
        /**
         * 获取寻路设置。
         * @return 寻路设置。
         */
        /**
         * 设置寻路设置。
         * @param value 寻路设置。
         */
        setting: any;
        /**
         * 创建一个新的 <code>PathFinding</code> 实例。
         */
        constructor();
        /**
         * @private
         * 初始化载入蒙皮动画组件。
         * @param	owner 所属精灵对象。
         */
        _load(owner: laya.d3.core.Sprite3D): void;
        /**
         * 寻找路径。
         * @param	startX 开始X。
         * @param	startZ 开始Z。
         * @param	endX 结束X。
         * @param	endZ 结束Z。
         * @return  路径。
         */
        findPath(startX: number, startZ: number, endX: number, endZ: number): Array<any>;
    }
}
declare module laya.d3.component.physics {
    /**
     * <code>BoxCollider</code> 类用于创建盒子碰撞器。
     */
    class BoxCollider extends Collider {
        private static _deviationV3;
        private static _obbCenterV3;
        /** 中心点 */
        center: laya.d3.math.Vector3;
        /**
         * 获取盒子碰撞器长宽高的一半。
         * @return 长宽高的一半。
         */
        /**
         * 设置盒子碰撞器长宽高的一半。
         * @param 长宽高的一半。
         */
        size: laya.d3.math.Vector3;
        /**
         * 获取包围盒子。
         * @return 包围球。
         */
        boundBox: laya.d3.math.OrientedBoundBox;
        /**
         * 创建一个 <code>BoxCollider</code> 实例。
         */
        constructor();
        /**
         * @inheritDoc
         */
        _initialize(owner: laya.d3.core.Sprite3D): void;
        /**
         * 在场景中投下可与盒体碰撞器碰撞的一条光线,获取发生碰撞的盒体碰撞器信息。
         * @param  ray        射线
         * @param  outHitInfo 与该射线发生碰撞盒体碰撞器的碰撞信息
         * @param  distance   射线长度,默认为最大值
         */
        raycast(ray: laya.d3.math.Ray, hitInfo: laya.d3.utils.RaycastHit, maxDistance?: number): boolean;
    }
}
declare module laya.d3.component.physics {
    /**
     * <code>Collider</code> 类用于创建碰撞器的父类，抽象类，不允许实例。
     */
    class Collider extends laya.d3.component.Component3D {
        protected _needUpdate: boolean;
        /**
         * @inheritDoc
         */
        isSingleton: boolean;
        constructor();
        raycast(ray: laya.d3.math.Ray, hitInfo: laya.d3.utils.RaycastHit, maxDistance?: number): boolean;
    }
}
declare module laya.d3.component.physics {
    /**
     * <code>MeshCollider</code> 类用于创建网格碰撞器。
     */
    class MeshCollider extends Collider {
        private static _tempRay0;
        private static _tempVector30;
        private static _tempMatrix4x40;
        private static _tempRaycastHit;
        _transformBoundSphere: laya.d3.math.BoundSphere;
        /**
         * 获取碰撞器网格。
         * @return 碰撞其网格。
         */
        /**
         * 设置碰撞器网格。
         * @param value 碰撞其网格。
         */
        mesh: laya.d3.resource.models.BaseMesh;
        /**
         * 创建一个 <code>SphereCollider</code> 实例。
         */
        constructor();
        /**
         * @inheritDoc
         */
        _initialize(owner: laya.d3.core.Sprite3D): void;
        /**
         * 在场景中投下可与网格碰撞器碰撞的一条光线,获取发生碰撞的网格碰撞器信息。
         * @param  ray        射线
         * @param  outHitInfo 与该射线发生碰撞网格碰撞器的碰撞信息
         * @param  distance   射线长度,默认为最大值
         */
        raycast(ray: laya.d3.math.Ray, hitInfo: laya.d3.utils.RaycastHit, maxDistance?: number): boolean;
    }
}
declare module laya.d3.component.physics {
    /**
     * <code>SphereCollider</code> 类用于创建球碰撞器。
     */
    class SphereCollider extends Collider {
        /**
         * 获取中心点。
         * @return 中心点。
         */
        /**
         * 设置中心点。
         * @param value 中心点。
         */
        center: laya.d3.math.Vector3;
        /**
         * 获取半径。
         * @return 半径。
         */
        /**
         * 设置半径。
         * @param value 半径。
         */
        radius: number;
        /**
         * 获取包围球。
         * @return 包围球。
         */
        boundSphere: laya.d3.math.BoundSphere;
        /**
         * 创建一个 <code>SphereCollider</code> 实例。
         */
        constructor();
        /**
         * @inheritDoc
         */
        _initialize(owner: laya.d3.core.Sprite3D): void;
        /**
         * 在场景中投下可与球体碰撞器碰撞的一条光线,获取发生碰撞的球体碰撞器信息。
         * @param  ray        射线
         * @param  outHitInfo 与该射线发生碰撞球体碰撞器的碰撞信息
         * @param  distance   射线长度,默认为最大值
         */
        raycast(ray: laya.d3.math.Ray, hitInfo: laya.d3.utils.RaycastHit, maxDistance?: number): boolean;
    }
}
declare module laya.d3.component {
    /**
     * <code>Script</code> 类用于创建脚本的父类。
     */
    class Script extends Component3D {
        /**
         * @inheritDoc
         */
        isSingleton: boolean;
        /**
         * 创建一个新的 <code>Script</code> 实例。
         */
        constructor();
    }
}
declare module laya.d3.core {
    /**
     * <code>BaseCamera</code> 类用于创建摄像机的父类。
     */
    class BaseCamera extends laya.d3.core.Sprite3D {
        static CAMERAPOS: number;
        static VIEWMATRIX: number;
        static PROJECTMATRIX: number;
        static VPMATRIX: number;
        static VPMATRIX_NO_TRANSLATE: number;
        static CAMERADIRECTION: number;
        static CAMERAUP: number;
        static ENVIRONMENTDIFFUSE: number;
        static ENVIRONMENTSPECULAR: number;
        static SIMLODINFO: number;
        static DIFFUSEIRRADMATR: number;
        static DIFFUSEIRRADMATG: number;
        static DIFFUSEIRRADMATB: number;
        static HDREXPOSURE: number;
        /**渲染模式,延迟光照渲染，暂未开放。*/
        static RENDERINGTYPE_DEFERREDLIGHTING: string;
        /**渲染模式,前向渲染。*/
        static RENDERINGTYPE_FORWARDRENDERING: string;
        /**清除标记，固定颜色。*/
        static CLEARFLAG_SOLIDCOLOR: number;
        /**清除标记，天空。*/
        static CLEARFLAG_SKY: number;
        /**清除标记，仅深度。*/
        static CLEARFLAG_DEPTHONLY: number;
        /**清除标记，不清除。*/
        static CLEARFLAG_NONE: number;
        protected _tempVector3: laya.d3.math.Vector3;
        protected _useUserProjectionMatrix: boolean;
        protected _viewportExpressedInClipSpace: boolean;
        /**清楚标记。*/
        clearFlag: number;
        /**摄像机的清除颜色。*/
        clearColor: laya.d3.math.Vector4;
        /** 可视遮罩图层。 */
        cullingMask: number;
        /** 渲染时是否用遮挡剔除。 */
        useOcclusionCulling: boolean;
        /**获取天空。*/
        /**设置天空。*/
        sky: laya.d3.resource.models.Sky;
        /**获取位置。*/
        position: laya.d3.math.Vector3;
        /**
         * 获取上向量。
         * @return 上向量。
         */
        up: laya.d3.math.Vector3;
        /**
         * 获取前向量。
         * @return 前向量。
         */
        forward: laya.d3.math.Vector3;
        /**
         * 获取右向量。
         * @return 右向量。
         */
        right: laya.d3.math.Vector3;
        /**
         * 获取渲染场景的渲染目标。
         * @return 渲染场景的渲染目标。
         */
        /**
         * 设置渲染场景的渲染目标。
         * @param value 渲染场景的渲染目标。
         */
        renderTarget: laya.d3.resource.RenderTexture;
        /**
         * 获取渲染目标的尺寸
         * @return 渲染目标的尺寸。
         */
        /**
         * 设置渲染目标的尺寸
         * @param value 渲染目标的尺寸。
         */
        renderTargetSize: laya.d3.utils.Size;
        /**
         * 获取视野。
         * @return 视野。
         */
        /**
         * 设置视野。
         * @param value 视野。
         */
        fieldOfView: number;
        /**
         * 获取近裁面。
         * @return 近裁面。
         */
        /**
         * 设置近裁面。
         * @param value 近裁面。
         */
        nearPlane: number;
        /**
         * 获取远裁面。
         * @return 远裁面。
         */
        /**
         * 设置远裁面。
         * @param value 远裁面。
         */
        farPlane: number;
        /**
         * 获取是否正交投影矩阵。
         * @return 是否正交投影矩阵。
         */
        /**
         * 设置是否正交投影矩阵。
         * @param 是否正交投影矩阵。
         */
        orthographicProjection: boolean;
        /**
         * 获取正交投影垂直矩阵尺寸。
         * @return 正交投影垂直矩阵尺寸。
         */
        /**
         * 设置正交投影垂直矩阵尺寸。
         * @param 正交投影垂直矩阵尺寸。
         */
        orthographicVerticalSize: number;
        renderingOrder: number;
        /**
         * 创建一个 <code>BaseCamera</code> 实例。
         * @param	fieldOfView 视野。
         * @param	nearPlane 近裁面。
         * @param	farPlane 远裁面。
         */
        constructor(nearPlane?: number, farPlane?: number);
        createConchModel(): any;
        /**
         * 通过RenderingOrder属性对摄像机机型排序。
         */
        _sortCamerasByRenderingOrder(): void;
        protected _calculateProjectionMatrix(): void;
        /**
         * @private
         */
        _prepareCameraToRender(): void;
        /**
         * @private
         */
        _prepareCameraViewProject(viewMatrix: laya.d3.math.Matrix4x4, projectMatrix: laya.d3.math.Matrix4x4): void;
        /**
         * 增加可视图层。
         * @param layer 图层。
         */
        addLayer(layer: laya.d3.core.Layer): void;
        /**
         * 移除可视图层。
         * @param layer 图层。
         */
        removeLayer(layer: laya.d3.core.Layer): void;
        /**
         * 增加所有图层。
         */
        addAllLayers(): void;
        /**
         * 移除所有图层。
         */
        removeAllLayers(): void;
        ResetProjectionMatrix(): void;
        destroy(destroyChild?: boolean): void;
        /**
         * 向前移动。
         * @param distance 移动距离。
         */
        moveForward(distance: number): void;
        /**
         * 向右移动。
         * @param distance 移动距离。
         */
        moveRight(distance: number): void;
        /**
         * 向上移动。
         * @param distance 移动距离。
         */
        moveVertical(distance: number): void;
        protected _addSelfRenderObjects(): void;
        protected _clearSelfRenderObjects(): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>Camera</code> 类用于创建摄像机。
     */
    class Camera extends BaseCamera {
        private static _tempVector20;
        /**
         * 获取横纵比。
         * @return 横纵比。
         */
        /**
         * 设置横纵比。
         * @param value 横纵比。
         */
        aspectRatio: number;
        /**
         * 获取屏幕空间的视口。
         * @return 屏幕空间的视口。
         */
        /**
         * 设置屏幕空间的视口。
         * @param 屏幕空间的视口。
         */
        viewport: laya.d3.math.Viewport;
        /**
         * 获取裁剪空间的视口。
         * @return 裁剪空间的视口。
         */
        /**
         * 设置裁剪空间的视口。
         * @return 裁剪空间的视口。
         */
        normalizedViewport: laya.d3.math.Viewport;
        needViewport: boolean;
        /**
         * 获取视图矩阵。
         * @return 视图矩阵。
         */
        viewMatrix: laya.d3.math.Matrix4x4;
        /**获取投影矩阵。*/
        /**设置投影矩阵。*/
        projectionMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取视图投影矩阵。
         * @return 视图投影矩阵。
         */
        projectionViewMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取摄像机视锥。
         */
        boundFrustum: laya.d3.math.BoundFrustum;
        /**
         * 创建一个 <code>Camera</code> 实例。
         * @param	aspectRatio 横纵比。
         * @param	nearPlane 近裁面。
         * @param	farPlane 远裁面。
         */
        constructor(aspectRatio?: number, nearPlane?: number, farPlane?: number);
        protected _calculateProjectionMatrix(): void;
        /**
         * @inheritDoc
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * 计算从屏幕空间生成的射线。
         * @param	point 屏幕空间的位置位置。
         * @return  out  输出射线。
         */
        viewportPointToRay(point: laya.d3.math.Vector2, out: laya.d3.math.Ray): void;
        /**
         * 计算从裁切空间生成的射线。
         * @param	point 裁切空间的位置。。
         * @return  out  输出射线。
         */
        normalizedViewportPointToRay(point: laya.d3.math.Vector2, out: laya.d3.math.Ray): void;
        /**
         * 计算从世界空间准换三维坐标到屏幕空间。
         * @param	position 世界空间的位置。
         * @return  out  输出位置。
         */
        worldToViewportPoint(position: laya.d3.math.Vector3, out: laya.d3.math.Vector3): void;
        /**
         * 计算从世界空间准换三维坐标到裁切空间。
         * @param	position 世界空间的位置。
         * @return  out  输出位置。
         */
        worldToNormalizedViewportPoint(position: laya.d3.math.Vector3, out: laya.d3.math.Vector3): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>GeometryFilter</code> 类用于创建集合体过滤器,抽象类不允许实例。
     */
    class GeometryFilter extends laya.events.EventDispatcher implements laya.resource.IDestroy {
        _isAsyncLoaded: boolean;
        /**
         * @private
         */
        _originalBoundingSphere: laya.d3.math.BoundSphere;
        /**
         * @private
         */
        _originalBoundingBox: laya.d3.math.BoundBox;
        /**
         * @private
         */
        _originalBoundingBoxCorners: Array<any>;
        /**
         * 获取是否已销毁。
         * @return 是否已销毁。
         */
        destroyed: boolean;
        /**
         * 创建一个 <code>GeometryFilter</code> 实例。
         */
        constructor();
        /**
         * @private
         */
        _destroy(): void;
    }
}
declare module laya.d3.core.glitter {
    /**
     * <code>Glitter</code> 类用于创建闪光。
     */
    class Glitter extends laya.d3.core.RenderableSprite3D {
        /**
         * 获取闪光模板。
         * @return  闪光模板。
         */
        templet: laya.d3.resource.tempelet.GlitterTemplet;
        /**
         * 获取刀光渲染器。
         * @return  刀光渲染器。
         */
        glitterRender: laya.d3.core.GlitterRender;
        /**
         * 创建一个 <code>Glitter</code> 实例。
         *  @param	settings 配置信息。
         */
        constructor();
        protected _clearSelfRenderObjects(): void;
        protected _addSelfRenderObjects(): void;
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         */
        _renderUpdate(projectionView: laya.d3.math.Matrix4x4): void;
        /**
         * 通过位置添加刀光。
         * @param position0 位置0。
         * @param position1 位置1。
         */
        addGlitterByPositions(position0: laya.d3.math.Vector3, position1: laya.d3.math.Vector3): void;
        /**
         * 通过位置和速度添加刀光。
         * @param position0 位置0。
         * @param velocity0 速度0。
         * @param position1 位置1。
         * @param velocity1 速度1。
         */
        addGlitterByPositionsVelocitys(position0: laya.d3.math.Vector3, velocity0: laya.d3.math.Vector3, position1: laya.d3.math.Vector3, velocity1: laya.d3.math.Vector3): void;
        cloneTo(destObject: any): void;
        /**
         * <p>销毁此对象。</p>
         * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.core.glitter {
    /**
     * <code>SplineCurvePosition</code> 类用于通过顶点创建闪光插值。
     */
    class SplineCurvePosition extends SplineCurvePositionVelocity {
        /**
         * 创建一个 <code>SplineCurvePosition</code> 实例。
         */
        constructor();
        /**
         * 初始化插值所需信息。
         * @param	lastPosition0 顶点0的上次位置。
         * @param	position0 顶点0的位置。
         * @param	lastPosition1 顶点1的上次位置。
         * @param	position1 顶点1的位置。
         */
        Init(lastPosition0: laya.d3.math.Vector3, position0: laya.d3.math.Vector3, lastPosition1: laya.d3.math.Vector3, position1: laya.d3.math.Vector3): void;
    }
}
declare module laya.d3.core.glitter {
    /**
     * <code>SplineCurvePositionVelocity</code> 类用于通过顶点和速度创建闪光插值。
     */
    class SplineCurvePositionVelocity {
        protected _tempVector30: laya.d3.math.Vector3;
        protected _tempVector31: laya.d3.math.Vector3;
        protected _tempVector32: laya.d3.math.Vector3;
        protected _a: laya.d3.math.Vector3;
        protected _b: laya.d3.math.Vector3;
        protected _c: laya.d3.math.Vector3;
        protected _d: laya.d3.math.Vector3;
        /**
         * 创建一个 <code>SplineCurvePositionVelocity</code> 实例。
         */
        constructor();
        /**
         * 初始化插值所需信息。
         * @param	position0 顶点0的位置。
         * @param	velocity0 顶点0的速度。
         * @param	position1 顶点1的位置。
         * @param	velocity1 顶点1的速度。
         */
        Init(position0: laya.d3.math.Vector3, velocity0: laya.d3.math.Vector3, position1: laya.d3.math.Vector3, velocity1: laya.d3.math.Vector3): void;
        /**
         * 初始化插值所需信息。
         * @param	t 插值比例
         * @param	out 输出结果
         */
        Slerp(t: number, out: laya.d3.math.Vector3): void;
    }
}
declare module laya.d3.core {
    /**
     * ...
     * @author ...
     */
    class GlitterRender extends laya.d3.core.render.BaseRender {
        constructor(owner: laya.d3.core.glitter.Glitter);
        protected _calculateBoundingBox(): void;
        protected _calculateBoundingSphere(): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>HeightMap</code> 类用于实现高度图数据。
     */
    class HeightMap {
        private static _tempRay;
        /**
         * 从网格精灵生成高度图。
         * @param meshSprite 网格精灵。
         * @param width	高度图宽度。
         * @param height 高度图高度。
         * @param outCellSize 输出 单元尺寸。
         */
        static creatFromMesh(mesh: laya.d3.resource.models.Mesh, width: number, height: number, outCellSize: laya.d3.math.Vector2): HeightMap;
        /**
         * 从图片生成高度图。
         * @param image 图片。
         * @param maxHeight 最小高度。
         * @param maxHeight 最大高度。
         */
        static createFromImage(texture: laya.d3.resource.Texture2D, minHeight: number, maxHeight: number): HeightMap;
        /**
         * 获取宽度。
         * @return value 宽度。
         */
        width: number;
        /**
         * 获取高度。
         * @return value 高度。
         */
        height: number;
        /**
         * 最大高度。
         * @return value 最大高度。
         */
        maxHeight: number;
        /**
         * 最大高度。
         * @return value 最大高度。
         */
        minHeight: number;
        /**
         * 创建一个 <code>HeightMap</code> 实例。
         * @param width 宽度。
         * @param height 高度。
         * @param minHeight 最大高度。
         * @param maxHeight 最大高度。
         */
        constructor(width: number, height: number, minHeight: number, maxHeight: number);
        /**
         * 获取高度。
         * @param row 列数。
         * @param col 行数。
         * @return 高度。
         */
        getHeight(row: number, col: number): number;
    }
}
declare module laya.d3.core {
    /**
     * @private
     * <code>IClone</code> 资源克隆接口。
     */
    interface IClone {
    }
}
declare module laya.d3.core {
    /**
     * <code>Layer</code> 类用于实现遮罩层。
     */
    class Layer {
        protected static _uniqueIDCounter: number;
        protected static _layerList: Array<any>;
        protected static _activeLayers: number;
        protected static _visibleLayers: number;
        /**当前相机遮罩。*/
        static _currentCameraCullingMask: number;
        /**当前创建精灵所属遮罩层。*/
        static currentCreationLayer: Layer;
        /**
         *获取Layer激活层。
         * @return 激活层。
         */
        /**
         * 设置Layer激活层。
         * @param value 激活层。
         */
        static activeLayers: number;
        /**
         *获取Layer显示层。
         * @return 显示层。
         */
        /**
         *设置Layer显示层。
         * @param value 显示层。
         */
        static visibleLayers: number;
        /**
         * @private
         */
        static __init__(): void;
        /**
         *通过编号获取蒙版。
         * @param number 编号。
         * @return 蒙版。
         */
        static getLayerByNumber(number: number): Layer;
        /**
         *通过蒙版值获取蒙版。
         * @param mask 编号。
         * @return 蒙版。
         */
        static getLayerByMask(mask: number): Layer;
        /**
         *通过蒙版值获取蒙版。
         * @param name 名字。
         * @return 蒙版。
         */
        static getLayerByName(name: string): Layer;
        /**
         *通过蒙版值获取蒙版是否激活。
         * @param mask 蒙版值。
         * @return 是否激活。
         */
        static isActive(mask: number): boolean;
        /**
         *通过蒙版值获取蒙版是否显示。
         * @param mask 蒙版值。
         * @return 是否显示。
         */
        static isVisible(mask: number): boolean;
        _colliders: Array<any>;
        /**名字。*/
        name: string;
        /**
         *获取编号。
         * @return 编号。
         */
        number: number;
        /**
         *获取蒙版值。
         * @return 蒙版值。
         */
        mask: number;
        /**
         *获取是否激活。
         * @return 是否激活。
         */
        /**
         *设置是否激活。
         * @param value 是否激活。
         */
        active: boolean;
        /**
         *获取是否显示。
         * @return 是否显示。
         */
        /**
         *设置是否显示。
         * @param value 是否显示。
         */
        visible: boolean;
        /**
         * 创建一个 <code>Layer</code> 实例。
         */
        constructor();
    }
}
declare module laya.d3.core.light {
    /**
     * <code>DirectionLight</code> 类用于创建平行光。
     */
    class DirectionLight extends LightSprite {
        /**
         * 获取平行光的方向。
         * @return 平行光的方向。
         */
        /**
         * 设置平行光的方向。
         * @param value 平行光的方向。
         */
        direction: laya.d3.math.Vector3;
        /**
         * @inheritDoc
         */
        lightType: number;
        /**
         * @inheritDoc
         */
        shadow: boolean;
        /**
         * 创建一个 <code>DirectionLight</code> 实例。
         */
        constructor();
        protected _addSelfRenderObjects(): void;
        protected _clearSelfRenderObjects(): void;
        /**
         * 更新平行光相关渲染状态参数。
         * @param state 渲染状态参数。
         */
        updateToWorldState(state: laya.d3.core.render.RenderState): boolean;
    }
}
declare module laya.d3.core.light {
    /**
     * <code>LightSprite</code> 类用于创建灯光的父类。
     */
    class LightSprite extends laya.d3.core.Sprite3D {
        /** 定义平行光类型的标记。*/
        static TYPE_DIRECTIONLIGHT: number;
        /** 定义点光类型的标记。*/
        static TYPE_POINTLIGHT: number;
        /** 定义聚光类型的标记。*/
        static TYPE_SPOTLIGHT: number;
        protected _diffuseColor: laya.d3.math.Vector3;
        protected _ambientColor: laya.d3.math.Vector3;
        protected _specularColor: laya.d3.math.Vector3;
        protected _reflectColor: laya.d3.math.Vector3;
        protected _shadow: boolean;
        protected _shadowFarPlane: number;
        protected _shadowMapSize: number;
        protected _shadowMapCount: number;
        protected _shadowMapPCFType: number;
        protected _parallelSplitShadowMap: laya.d3.shadowMap.ParallelSplitShadowMap;
        /**
         * 获取灯光的漫反射颜色。
         * @return 灯光的漫反射颜色。
         */
        /**
         * 设置灯光的漫反射颜色。
         * @param value 灯光的漫反射颜色。
         */
        diffuseColor: laya.d3.math.Vector3;
        /**
         * 获取灯光的环境光颜色。
         * @return 灯光的环境光颜色。
         */
        /**
         * 设置灯光的环境光颜色。
         * @param value 灯光的环境光颜色。
         */
        ambientColor: laya.d3.math.Vector3;
        /**
         * 获取灯光的高光颜色。
         * @return 灯光的高光颜色。
         */
        /**
         * 设置灯光的高光颜色。
         * @param value 灯光的高光颜色。
         */
        specularColor: laya.d3.math.Vector3;
        /**
         * 获取灯光的反射颜色。
         * @return 灯光的反射颜色。
         */
        /**
         * 设置灯光的反射颜色。
         * @param value 灯光的反射颜色。
         */
        reflectColor: laya.d3.math.Vector3;
        /**
         * 获取是否产生阴影。
         * @return 是否产生阴影。
         */
        /**
         * 设置是否产生阴影。
         * @param value 是否产生阴影。
         */
        shadow: boolean;
        /**
         * 获取阴影最远范围。
         * @return 阴影最远范围。
         */
        /**
         * 设置阴影最远范围。
         * @param value 阴影最远范围。
         */
        shadowDistance: number;
        /**
         * 获取阴影贴图尺寸。
         * @return 阴影贴图尺寸。
         */
        /**
         * 设置阴影贴图尺寸。
         * @param value 阴影贴图尺寸。
         */
        shadowResolution: number;
        /**
         * 获取阴影分段数。
         * @return 阴影分段数。
         */
        /**
         * 设置阴影分段数。
         * @param value 阴影分段数。
         */
        shadowPSSMCount: number;
        /**
         * 获取阴影PCF类型。
         * @return PCF类型。
         */
        /**
         * 设置阴影PCF类型。
         * @param value PCF类型。
         */
        shadowPCFType: number;
        /**
         * 获取灯光的类型。
         * @return 灯光的类型。
         */
        lightType: number;
        /**
         * 创建一个 <code>LightSprite</code> 实例。
         */
        constructor();
        protected _addSelfRenderObjects(): void;
        protected _clearSelfRenderObjects(): void;
        /**
         * 更新灯光相关渲染状态参数。
         * @param state 渲染状态参数。
         */
        updateToWorldState(state: laya.d3.core.render.RenderState): boolean;
    }
}
declare module laya.d3.core.light {
    /**
     * <code>PointLight</code> 类用于创建点光。
     */
    class PointLight extends LightSprite {
        /**
         * 创建一个 <code>PointLight</code> 实例。
         */
        constructor();
        /**
         * 获取点光的范围。
         * @return 点光的范围。
         */
        /**
         * 设置点光的范围。
         * @param  value 点光的范围。
         */
        range: number;
        /**
         * 获取点光的衰减。
         * @return 点光的衰减。
         */
        /**
         * 设置点光的衰减。
         * @param value 点光的衰减。
         */
        attenuation: laya.d3.math.Vector3;
        /**
         * 获取点光的类型。
         * @return 点光的类型。
         */
        lightType: number;
        protected _clearSelfRenderObjects(): void;
        /**
         * 更新点光相关渲染状态参数。
         * @param state 渲染状态参数。
         */
        updateToWorldState(state: laya.d3.core.render.RenderState): boolean;
    }
}
declare module laya.d3.core.light {
    /**
     * <code>SpotLight</code> 类用于创建聚光。
     */
    class SpotLight extends LightSprite {
        /**
         * 创建一个 <code>SpotLight</code> 实例。
         */
        constructor();
        /**
         * 获取平行光的方向。
         * @return 平行光的方向。
         */
        /**
         * 设置平行光的方向。
         * @param value 平行光的方向。
         */
        direction: laya.d3.math.Vector3;
        /**
         * 获取聚光的衰减。
         * @return 聚光的衰减。
         */
        /**
         * 设置聚光的衰减。
         * @param value 聚光的衰减。
         */
        attenuation: laya.d3.math.Vector3;
        /**
         * 获取聚光的聚光值。
         * @return 聚光的聚光值。
         */
        /**
         * 设置聚光的聚光值。
         * @param value 聚光的聚光值。
         */
        spot: number;
        /**
         * 获取聚光的范围。
         * @return 聚光的范围值。
         */
        /**
         * 设置聚光的范围。
         * @param value 聚光的范围值。
         */
        range: number;
        /**
         * 获取聚光的类型。
         * @return 聚光的类型。
         */
        lightType: number;
        protected _clearSelfRenderObjects(): void;
        /**
         * 更新聚光相关渲染状态参数。
         * @param state 渲染状态参数。
         */
        updateToWorldState(state: laya.d3.core.render.RenderState): boolean;
    }
}
declare module laya.d3.core.material {
    /**
     * <code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
     */
    class BaseMaterial extends laya.resource.Resource implements laya.d3.core.IClone {
        /**剔除枚举_不剔除。*/
        static CULL_NONE: number;
        /**剔除枚举_剔除正面。*/
        static CULL_FRONT: number;
        /**剔除枚举_剔除背面。*/
        static CULL_BACK: number;
        /**混合枚举_禁用。*/
        static BLEND_DISABLE: number;
        /**混合枚举_启用_RGB和Alpha统一混合。*/
        static BLEND_ENABLE_ALL: number;
        /**混合枚举_启用_RGB和Alpha单独混合。*/
        static BLEND_ENABLE_SEPERATE: number;
        /**混合参数枚举_零,例：RGB(0,0,0),Alpha:(1)。*/
        static BLENDPARAM_ZERO: number;
        /**混合参数枚举_一,例：RGB(1,1,1),Alpha:(1)。*/
        static BLENDPARAM_ONE: number;
        /**混合参数枚举_源颜色,例：RGB(Rs,Gs,Bs)，Alpha(As)。*/
        static BLENDPARAM_SRC_COLOR: number;
        /**混合参数枚举_一减源颜色,例：RGB(1-Rs,1-Gs,1-Bs)，Alpha(1-As)。*/
        static BLENDPARAM_ONE_MINUS_SRC_COLOR: number;
        /**混合参数枚举_目标颜色,例：RGB(Rd,Gd,Bd),Alpha(Ad)。*/
        static BLENDPARAM_DST_COLOR: number;
        /**混合参数枚举_一减目标颜色,例：RGB(1-Rd,1-Gd,1-Bd)，Alpha(1-Ad)。*/
        static BLENDPARAM_ONE_MINUS_DST_COLOR: number;
        /**混合参数枚举_源透明,例:RGB(As,As,As),Alpha(1-As)。*/
        static BLENDPARAM_SRC_ALPHA: number;
        /**混合参数枚举_一减源阿尔法,例:RGB(1-As,1-As,1-As),Alpha(1-As)。*/
        static BLENDPARAM_ONE_MINUS_SRC_ALPHA: number;
        /**混合参数枚举_目标阿尔法，例：RGB(Ad,Ad,Ad),Alpha(Ad)。*/
        static BLENDPARAM_DST_ALPHA: number;
        /**混合参数枚举_一减目标阿尔法,例：RGB(1-Ad,1-Ad,1-Ad),Alpha(Ad)。*/
        static BLENDPARAM_ONE_MINUS_DST_ALPHA: number;
        /**混合参数枚举_常量颜色,例:RGB(Rc,Gc,Bc),Alpha(Ac)。*/
        static BLENDPARAM_CONSTANT_COLOR: number;
        /**混合参数枚举_一减常量颜色,例：RGB(1-Rc,1-Gc,1-Bc),Alpha(1-Ac)。*/
        static BLENDPARAM_ONE_MINUS_CONSTANT_COLOR: number;
        /**混合参数枚举_常量阿尔法,例：RGB(Ac,Ac,Ac)，Alpha(Ac)。*/
        static BLENDPARAM_CONSTANT_ALPHA: number;
        /**混合参数枚举_一减常量阿尔法,例：RGB(1-Ac,1-Ac,1-Ac)，Alpha(1-Ac)。*/
        static BLENDPARAM_ONE_MINUS_CONSTANT_ALPHA: number;
        /**混合参数枚举_阿尔法饱和，例：RGB(min(As,1 - Ad),min(As,1 - Ad),min(As,1 - Ad)),Alpha(1)。*/
        static BLENDPARAM_SRC_ALPHA_SATURATE: number;
        /**混合方程枚举_加法,例：source + destination*/
        static BLENDEQUATION_ADD: number;
        /**混合方程枚举_减法，例：source - destination*/
        static BLENDEQUATION_SUBTRACT: number;
        /**混合方程枚举_反序减法，例：destination - source*/
        static BLENDEQUATION_REVERSE_SUBTRACT: number;
        /**深度测试函数枚举_从不通过。*/
        static DEPTHFUNC_NEVER: number;
        /**深度测试函数枚举_小于时通过。*/
        static DEPTHFUNC_LESS: number;
        /**深度测试函数枚举_等于时通过。*/
        static DEPTHFUNC_EQUAL: number;
        /**深度测试函数枚举_小于等于时通过。*/
        static DEPTHFUNC_LEQUAL: number;
        /**深度测试函数枚举_大于时通过。*/
        static DEPTHFUNC_GREATER: number;
        /**深度测试函数枚举_不等于时通过。*/
        static DEPTHFUNC_NOTEQUAL: number;
        /**深度测试函数枚举_大于等于时通过。*/
        static DEPTHFUNC_GEQUAL: number;
        /**深度测试函数枚举_总是通过。*/
        static DEPTHFUNC_ALWAYS: number;
        /**宏定义_透明测试。*/
        static SHADERDEFINE_ALPHATEST: number;
        /**Shader变量_透明测试值。*/
        static ALPHATESTVALUE: number;
        _shaderValues: laya.d3.shader.ValusArray;
        protected _renderQueue: number;
        protected _shaderCompile: laya.d3.shader.ShaderCompile3D;
        _isInstance: boolean;
        /**渲染剔除。*/
        cull: number;
        /**透明混合。*/
        blend: number;
        /**源混合参数,在blend为BLEND_ENABLE_ALL时生效。*/
        srcBlend: number;
        /**目标混合参数,在blend为BLEND_ENABLE_ALL时生效。*/
        dstBlend: number;
        /**RGB源混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
        srcBlendRGB: number;
        /**RGB目标混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
        dstBlendRGB: number;
        /**Alpha源混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
        srcBlendAlpha: number;
        /**Alpha目标混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
        dstBlendAlpha: number;
        /**混合常量颜色。*/
        blendConstColor: laya.d3.math.Vector4;
        /**混合方程。*/
        blendEquation: number;
        /**RGB混合方程。*/
        blendEquationRGB: number;
        /**Alpha混合方程。*/
        blendEquationAlpha: number;
        /**是否深度测试。*/
        depthTest: boolean;
        /**深度测试函数。*/
        depthFunc: number;
        /**是否深度写入。*/
        depthWrite: boolean;
        _conchMaterial: any;
        /**
         * 获取所属渲染队列。
         * @return 渲染队列。
         */
        renderQueue: number;
        /**
         * 获取透明测试模式裁剪值。
         * @return 透明测试模式裁剪值。
         */
        /**
         * 设置透明测试模式裁剪值。
         * @param value 透明测试模式裁剪值。
         */
        alphaTestValue: number;
        /**
         * 获取是否透明裁剪。
         * @return 是否透明裁剪。
         */
        /**
         * 设置是否透明裁剪。
         * @param value 是否透明裁剪。
         */
        alphaTest: boolean;
        /**
         * 创建一个 <code>BaseMaterial</code> 实例。
         */
        constructor();
        /**
         * @private
         */
        _getShader(sceneDefineValue: number, vertexDefineValue: number, spriteDefineValue: number): laya.d3.shader.Shader3D;
        /**
         * 增加Shader宏定义。
         * @param value 宏定义。
         */
        _addShaderDefine(value: number): void;
        /**
         * 移除Shader宏定义。
         * @param value 宏定义。
         */
        _removeShaderDefine(value: number): void;
        protected _addDisablePublicShaderDefine(value: number): void;
        protected _removeDisablePublicShaderDefine(value: number): void;
        protected _setBuffer(shaderIndex: number, buffer: Float32Array): void;
        protected _getBuffer(shaderIndex: number): any;
        protected _setMatrix4x4(shaderIndex: number, matrix4x4: laya.d3.math.Matrix4x4): void;
        protected _getMatrix4x4(shaderIndex: number): any;
        protected _setInt(shaderIndex: number, i: number): void;
        protected _getInt(shaderIndex: number): any;
        protected _setNumber(shaderIndex: number, number: number): void;
        protected _getNumber(shaderIndex: number): any;
        protected _setBool(shaderIndex: number, b: boolean): void;
        protected _getBool(shaderIndex: boolean): any;
        protected _setVector2(shaderIndex: number, vector2: laya.d3.math.Vector2): void;
        protected _getVector2(shaderIndex: number): any;
        protected _setColor(shaderIndex: number, color: any): void;
        protected _getColor(shaderIndex: number): any;
        protected _setTexture(shaderIndex: number, texture: laya.d3.resource.BaseTexture): void;
        protected _getTexture(shaderIndex: number): laya.d3.resource.BaseTexture;
        /**
         * 上传材质。
         * @param state 相关渲染状态。
         * @param bufferUsageShader Buffer相关绑定。
         * @param shader 着色器。
         * @return  是否成功。
         */
        _upload(): void;
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        /**
         * 设置渲染相关状态。
         */
        _setRenderStateBlendDepth(): void;
        /**
         * 设置渲染相关状态。
         */
        _setRenderStateFrontFace(isTarget: boolean, transform: laya.d3.core.Transform3D): void;
        /**
         * 设置使用Shader名字。
         * @param name 名称。
         */
        setShaderName(name: string): void;
        /**
         * @inheritDoc
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        /**
         * @inheritDoc
         */
        dispose(): void;
    }
}
declare module laya.d3.core.material {
    /**
     * ...
     * @author ...
     */
    class GlitterMaterial extends BaseMaterial {
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_不透明_双面。*/
        static RENDERMODE_OPAQUEDOUBLEFACE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        /**渲染状态_透明混合_双面。*/
        static RENDERMODE_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_加色法混合。*/
        static RENDERMODE_ADDTIVE: number;
        /**渲染状态_加色法混合_双面。*/
        static RENDERMODE_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_只读深度_透明混合。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENT: number;
        /**渲染状态_只读深度_透明混合_双面。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_只读深度_加色法混合。*/
        static RENDERMODE_DEPTHREAD_ADDTIVE: number;
        /**渲染状态_只读深度_加色法混合_双面。*/
        static RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_无深度_透明混合。*/
        static RENDERMODE_NONDEPTH_TRANSPARENT: number;
        /**渲染状态_无深度_透明混合_双面。*/
        static RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_无深度_加色法混合。*/
        static RENDERMODE_NONDEPTH_ADDTIVE: number;
        /**渲染状态_无深度_加色法混合_双面。*/
        static RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: number;
        static DIFFUSETEXTURE: number;
        static ALBEDO: number;
        static CURRENTTIME: number;
        static UNICOLOR: number;
        static DURATION: number;
        /** 默认材质，禁止修改*/
        static defaultMaterial: GlitterMaterial;
        /**
         * 加载闪光材质。
         * @param url 闪光材质地址。
         */
        static load(url: string): GlitterMaterial;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        /**
         * 设置渲染模式。
         * @return 渲染模式。
         */
        renderMode: number;
        /**
         * 获取漫反射贴图。
         * @return 漫反射贴图。
         */
        /**
         * 设置漫反射贴图。
         * @param value 漫反射贴图。
         */
        diffuseTexture: laya.d3.resource.BaseTexture;
        /**
         * @inheritDoc
         */
        setShaderName(name: string): void;
        constructor();
        /**
         * @inheritDoc
         */
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        /**
         * @inheritDoc
         */
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.material {
    /**
     * ...
     * @author ...
     */
    class ParticleMaterial extends BaseMaterial {
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_不透明_双面。*/
        static RENDERMODE_OPAQUEDOUBLEFACE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        /**渲染状态_透明混合_双面。*/
        static RENDERMODE_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_加色法混合。*/
        static RENDERMODE_ADDTIVE: number;
        /**渲染状态_加色法混合_双面。*/
        static RENDERMODE_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_只读深度_透明混合。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENT: number;
        /**渲染状态_只读深度_透明混合_双面。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_只读深度_加色法混合。*/
        static RENDERMODE_DEPTHREAD_ADDTIVE: number;
        /**渲染状态_只读深度_加色法混合_双面。*/
        static RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_无深度_透明混合。*/
        static RENDERMODE_NONDEPTH_TRANSPARENT: number;
        /**渲染状态_无深度_透明混合_双面。*/
        static RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_无深度_加色法混合。*/
        static RENDERMODE_NONDEPTH_ADDTIVE: number;
        /**渲染状态_无深度_加色法混合_双面。*/
        static RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: number;
        static SHADERDEFINE_PARTICLE3D: number;
        static VIEWPORTSCALE: number;
        static CURRENTTIME: number;
        static DURATION: number;
        static GRAVITY: number;
        static ENDVELOCITY: number;
        static DIFFUSETEXTURE: number;
        /** 默认材质，禁止修改*/
        static defaultMaterial: ParticleMaterial;
        /**
         * 加载粒子材质。
         * @param url 粒子材质地址。
         */
        static load(url: string): ParticleMaterial;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        /**
         * 设置渲染模式。
         * @return 渲染模式。
         */
        renderMode: number;
        /**
         * 获取漫反射贴图。
         * @return 漫反射贴图。
         */
        /**
         * 设置漫反射贴图。
         * @param value 漫反射贴图。
         */
        diffuseTexture: laya.d3.resource.BaseTexture;
        constructor();
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.material {
    class PBRMaterial extends BaseMaterial {
        static DIFFUSETEXTURE: number;
        static NORMALTEXTURE: number;
        static PBRINFOTEXTURE: number;
        static PBRLUTTEXTURE: number;
        static UVANIAGE: number;
        static MATERIALROUGHNESS: number;
        static MATERIALMETALESS: number;
        static UVMATRIX: number;
        static UVAGE: number;
        static AOOBJPOS: number;
        static HSNOISETEXTURE: number;
        static SHADERDEFINE_FIX_ROUGHNESS: number;
        static SHADERDEFINE_FIX_METALESS: number;
        static SHADERDEFINE_HAS_TANGENT: number;
        static SHADERDEFINE_TEST_CLIPZ: number;
        static SHADERDEFINE_HAS_PBRINFO: number;
        static SHADERDEFINE_USE_GROUNDTRUTH: number;
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_不透明_双面。*/
        static RENDERMODE_OPAQUEDOUBLEFACE: number;
        /**渲染状态_透明测试。*/
        static RENDERMODE_CUTOUT: number;
        /**渲染状态_透明测试_双面。*/
        static RENDERMODE_CUTOUTDOUBLEFACE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        static pbrlutTex: laya.d3.resource.DataTexture2D;
        static HammersleyNoiseTex: laya.d3.resource.DataTexture2D;
        protected _transformUV: laya.d3.core.TransformUV;
        /** 默认材质，禁止修改*/
        static defaultMaterial: PBRMaterial;
        /**
         * 加载标准材质。
         * @param url 标准材质地址。
         */
        static load(url: string): PBRMaterial;
        /**
         * 获取粗糙度的值，0为特别光滑，1为特别粗糙。
         * @return 粗糙度的值。
         */
        /**
         * 设置粗糙度的值，0为特别光滑，1为特别粗糙。
         * @param value 粗糙度。
         */
        roughness: number;
        metaless: number;
        has_tangent: boolean;
        use_groundtruth: boolean;
        /**
         * 获取漫反射贴图。
         * @return 漫反射贴图。
         */
        /**
         * 设置漫反射贴图。
         * @param value 漫反射贴图。
         */
        diffuseTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取PBRLUT贴图。
         * @return PBRLUT贴图。
         */
        /**
         * 设置PBRLUT贴图。
         * @param value PBRLUT贴图。
         */
        pbrlutTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取法线贴图。
         * @return 法线贴图。
         */
        /**
         * 设置法线贴图。
         * @param value 法线贴图。
         */
        normalTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取pbr信息贴图。
         * @return pbr信息贴图。
         */
        /**
         * 设置pbr信息贴图。
         * @param value pbr信息贴图。
         */
        pbrInfoTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取UV变换。
         * @return  UV变换。
         */
        /**
         * 设置UV变换。
         * @param value UV变换。
         */
        transformUV: laya.d3.core.TransformUV;
        constructor();
        /**
         * 禁用灯光。
         */
        disableLight(): void;
        /**
         * 禁用雾化。
         */
        disableFog(): void;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        renderMode: number;
        testClipZ: boolean;
        /**
         * @private
         */
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * vdc算法产生的序列。这个比random要均匀一些。
         */
        radicalInverse_VdC(bits: number): number;
        /**
         *
         */
        createHammersleyTex(w: number, h: number): Uint8Array;
    }
}
declare module laya.d3.core.material {
    /**
     * ...
     * @author ...
     */
    class StandardMaterial extends BaseMaterial {
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_不透明_双面。*/
        static RENDERMODE_OPAQUEDOUBLEFACE: number;
        /**渲染状态_透明测试。*/
        static RENDERMODE_CUTOUT: number;
        /**渲染状态_透明测试_双面。*/
        static RENDERMODE_CUTOUTDOUBLEFACE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        /**渲染状态_透明混合_双面。*/
        static RENDERMODE_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_加色法混合。*/
        static RENDERMODE_ADDTIVE: number;
        /**渲染状态_加色法混合_双面。*/
        static RENDERMODE_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_只读深度_透明混合。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENT: number;
        /**渲染状态_只读深度_透明混合_双面。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_只读深度_加色法混合。*/
        static RENDERMODE_DEPTHREAD_ADDTIVE: number;
        /**渲染状态_只读深度_加色法混合_双面。*/
        static RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_无深度_透明混合。*/
        static RENDERMODE_NONDEPTH_TRANSPARENT: number;
        /**渲染状态_无深度_透明混合_双面。*/
        static RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_无深度_加色法混合。*/
        static RENDERMODE_NONDEPTH_ADDTIVE: number;
        /**渲染状态_无深度_加色法混合_双面。*/
        static RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: number;
        static SHADERDEFINE_DIFFUSEMAP: number;
        static SHADERDEFINE_NORMALMAP: number;
        static SHADERDEFINE_SPECULARMAP: number;
        static SHADERDEFINE_EMISSIVEMAP: number;
        static SHADERDEFINE_AMBIENTMAP: number;
        static SHADERDEFINE_REFLECTMAP: number;
        static SHADERDEFINE_UVTRANSFORM: number;
        static DIFFUSETEXTURE: number;
        static NORMALTEXTURE: number;
        static SPECULARTEXTURE: number;
        static EMISSIVETEXTURE: number;
        static AMBIENTTEXTURE: number;
        static REFLECTTEXTURE: number;
        static ALBEDO: number;
        static UVANIAGE: number;
        static MATERIALAMBIENT: number;
        static MATERIALDIFFUSE: number;
        static MATERIALSPECULAR: number;
        static MATERIALREFLECT: number;
        static UVMATRIX: number;
        static UVAGE: number;
        /** 默认材质，禁止修改*/
        static defaultMaterial: StandardMaterial;
        /**
         * 加载标准材质。
         * @param url 标准材质地址。
         */
        static load(url: string): StandardMaterial;
        protected _transformUV: laya.d3.core.TransformUV;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        /**
         * 设置渲染模式。
         * @return 渲染模式。
         */
        renderMode: number;
        /**
         * 设置环境光颜色。
         * @param value 环境光颜色。
         */
        ambientColor: laya.d3.math.Vector3;
        /**
         * 设置漫反射光颜色。
         * @param value 漫反射光颜色。
         */
        diffuseColor: laya.d3.math.Vector3;
        /**
         * 设置高光颜色。
         * @param value 高光颜色。
         */
        specularColor: laya.d3.math.Vector4;
        /**
         * 设置反射颜色。
         * @param value 反射颜色。
         */
        reflectColor: laya.d3.math.Vector3;
        /**
         * 设置反射率。
         * @param value 反射率。
         */
        albedo: laya.d3.math.Vector4;
        /**
         * 获取漫反射贴图。
         * @return 漫反射贴图。
         */
        /**
         * 设置漫反射贴图。
         * @param value 漫反射贴图。
         */
        diffuseTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取法线贴图。
         * @return 法线贴图。
         */
        /**
         * 设置法线贴图。
         * @param value 法线贴图。
         */
        normalTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取高光贴图。
         * @return 高光贴图。
         */
        /**
         * 设置高光贴图。
         * @param value  高光贴图。
         */
        specularTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取放射贴图。
         * @return 放射贴图。
         */
        /**
         * 设置放射贴图。
         * @param value 放射贴图。
         */
        emissiveTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取环境贴图。
         * @return 环境贴图。
         */
        /**
         * 设置环境贴图。
         * @param  value 环境贴图。
         */
        ambientTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取反射贴图。
         * @return 反射贴图。
         */
        /**
         * 设置反射贴图。
         * @param value 反射贴图。
         */
        reflectTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取UV变换。
         * @return  UV变换。
         */
        /**
         * 设置UV变换。
         * @param value UV变换。
         */
        transformUV: laya.d3.core.TransformUV;
        constructor();
        /**
         * @private
         */
        static _parseStandardMaterial(textureMap: any, material: StandardMaterial, json: any): void;
        /**
         * 禁用灯光。
         */
        disableLight(): void;
        /**
         * 禁用雾化。
         */
        disableFog(): void;
        /**
         * @inheritDoc
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * @private
         */
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        /**
         * @inheritDoc
         */
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.material {
    /**
     * ...
     * @author ...
     */
    class TerrainMaterial extends BaseMaterial {
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        /**渲染状态_透明混合。*/
        static SPLATALPHATEXTURE: number;
        static NORMALTEXTURE: number;
        static DIFFUSETEXTURE1: number;
        static DIFFUSETEXTURE2: number;
        static DIFFUSETEXTURE3: number;
        static DIFFUSETEXTURE4: number;
        static DIFFUSESCALE1: number;
        static DIFFUSESCALE2: number;
        static DIFFUSESCALE3: number;
        static DIFFUSESCALE4: number;
        static MATERIALAMBIENT: number;
        static MATERIALDIFFUSE: number;
        static MATERIALSPECULAR: number;
        /**地形细节宏定义。*/
        static SHADERDEFINE_DETAIL_NUM1: number;
        static SHADERDEFINE_DETAIL_NUM2: number;
        static SHADERDEFINE_DETAIL_NUM3: number;
        static SHADERDEFINE_DETAIL_NUM4: number;
        /** 默认材质，禁止修改*/
        static defaultMaterial: TerrainMaterial;
        /**
         * 加载闪光材质。
         * @param url 闪光材质地址。
         */
        static load(url: string): TerrainMaterial;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        /**
         * 设置渲染模式。
         * @return 渲染模式。
         */
        renderMode: number;
        setDiffuseScale1(x: number, y: number): void;
        setDiffuseScale2(x: number, y: number): void;
        setDiffuseScale3(x: number, y: number): void;
        setDiffuseScale4(x: number, y: number): void;
        setDetailNum(value: number): void;
        ambientColor: laya.d3.math.Vector3;
        diffuseColor: laya.d3.math.Vector3;
        specularColor: laya.d3.math.Vector4;
        /**
         * 获取第一层贴图。
         * @return 第一层贴图。
         */
        /**
         * 设置第一层贴图。
         * @param value 第一层贴图。
         */
        diffuseTexture1: laya.d3.resource.BaseTexture;
        /**
         * 获取第二层贴图。
         * @return 第二层贴图。
         */
        /**
         * 设置第二层贴图。
         * @param value 第二层贴图。
         */
        diffuseTexture2: laya.d3.resource.BaseTexture;
        /**
         * 获取第三层贴图。
         * @return 第三层贴图。
         */
        /**
         * 设置第三层贴图。
         * @param value 第三层贴图。
         */
        diffuseTexture3: laya.d3.resource.BaseTexture;
        /**
         * 获取第四层贴图。
         * @return 第四层贴图。
         */
        /**
         * 设置第四层贴图。
         * @param value 第四层贴图。
         */
        diffuseTexture4: laya.d3.resource.BaseTexture;
        /**
         * 获取splatAlpha贴图。
         * @return splatAlpha贴图。
         */
        /**
         * 设置splatAlpha贴图。
         * @param value splatAlpha贴图。
         */
        splatAlphaTexture: laya.d3.resource.BaseTexture;
        normalTexture: laya.d3.resource.BaseTexture;
        /**
         * @inheritDoc
         */
        setShaderName(name: string): void;
        constructor();
        /**
         * @inheritDoc
         */
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        /**
         * @inheritDoc
         */
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.material {
    class WaterMaterial extends BaseMaterial {
        static DIFFUSETEXTURE: number;
        static NORMALTEXTURE: number;
        static UNDERWATERTEXTURE: number;
        static VERTEXDISPTEXTURE: number;
        static UVANIAGE: number;
        static UVMATRIX: number;
        static UVAGE: number;
        static CURTM: number;
        static DETAILTEXTURE: number;
        static DEEPCOLORTEXTURE: number;
        static SKYTEXTURE: number;
        static WAVEINFO: number;
        static WAVEINFOD: number;
        static WAVEMAINDIR: number;
        static SCRSIZE: number;
        static WATERINFO: number;
        static FOAMTEXTURE: number;
        static GEOWAVE_UV_SCALE: number;
        static SEA_COLOR: number;
        static SHADERDEFINE_SHOW_NORMAL: number;
        static SHADERDEFINE_CUBE_ENV: number;
        static SHADERDEFINE_HDR_ENV: number;
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_不透明_双面。*/
        static RENDERMODE_OPAQUEDOUBLEFACE: number;
        /**渲染状态_透明测试。*/
        static RENDERMODE_CUTOUT: number;
        /**渲染状态_透明测试_双面。*/
        static RENDERMODE_CUTOUTDOUBLEFACE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        /** 默认材质，禁止修改*/
        static defaultMaterial: WaterMaterial;
        /**
         * 加载标准材质。
         * @param url 标准材质地址。
         */
        static load(url: string): WaterMaterial;
        /**
         * 获取漫反射贴图。
         * @return 漫反射贴图。
         */
        /**
         * 设置漫反射贴图。
         * @param value 漫反射贴图。
         */
        diffuseTexture: laya.d3.resource.BaseTexture;
        /**
         * 获取法线贴图。
         * @return 法线贴图。
         */
        /**
         * 设置法线贴图。
         * @param value 法线贴图。
         */
        normalTexture: laya.d3.resource.BaseTexture;
        underWaterTexture: laya.d3.resource.BaseTexture;
        skyTexture: laya.d3.resource.BaseTexture;
        waterInfoTexture: laya.d3.resource.BaseTexture;
        foamTexture: laya.d3.resource.BaseTexture;
        /**
         * 对定点进行变换的纹理。现在不用
         */
        vertexDispTexture: laya.d3.resource.BaseTexture;
        detailTexture: laya.d3.resource.BaseTexture;
        deepColorTexture: laya.d3.resource.BaseTexture;
        currentTm: number;
        waveInfo: Float32Array;
        waveInfoD: Float32Array;
        waveMainDir: number;
        geoWaveUVScale: number;
        scrsize: Float32Array;
        seaColor: Float32Array;
        constructor();
        /**
         * 禁用雾化。
         */
        disableFog(): void;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        renderMode: number;
        /**
         * @private
         */
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>MeshFilter</code> 类用于创建网格过滤器。
     */
    class MeshFilter extends GeometryFilter {
        /**
         * 获取共享网格。
         * @return 共享网格。
         */
        /**
         * 设置共享网格。
         * @return  value 共享网格。
         */
        sharedMesh: laya.d3.resource.models.BaseMesh;
        /**
         * @inheritDoc
         */
        _isAsyncLoaded: boolean;
        /**
         * @inheritDoc
         */
        _originalBoundingSphere: laya.d3.math.BoundSphere;
        /**
         * @inheritDoc
         */
        _originalBoundingBox: laya.d3.math.BoundBox;
        /**
         * @inheritDoc
         */
        _originalBoundingBoxCorners: Array<any>;
        /**
         * 创建一个新的 <code>MeshFilter</code> 实例。
         * @param owner 所属网格精灵。
         */
        constructor(owner: MeshSprite3D);
        /**
         * @inheritDoc
         */
        _destroy(): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>MeshRender</code> 类用于网格渲染器。
     */
    class MeshRender extends laya.d3.core.render.BaseRender {
        /** 光照贴图的索引。*/
        lightmapIndex: number;
        /**
         * 获取光照贴图的缩放和偏移。
         * @return  光照贴图的缩放和偏移。
         */
        /**
         * 设置光照贴图的缩放和偏移。
         * @param  光照贴图的缩放和偏移。
         */
        lightmapScaleOffset: laya.d3.math.Vector4;
        /**
         * 创建一个新的 <code>MeshRender</code> 实例。
         */
        constructor(owner: MeshSprite3D);
        protected _calculateBoundingSphere(): void;
        protected _calculateBoundingBox(): void;
        /**
         * @private
         */
        _destroy(): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>MeshSprite3D</code> 类用于创建网格。
     */
    class MeshSprite3D extends RenderableSprite3D {
        static LIGHTMAPSCALEOFFSET: number;
        /**
         * 加载网格模板,注意:不缓存。
         * @param url 模板地址。
         */
        static load(url: string): MeshSprite3D;
        /**
         * 获取网格过滤器。
         * @return  网格过滤器。
         */
        meshFilter: MeshFilter;
        /**
         * 获取网格渲染器。
         * @return  网格渲染器。
         */
        meshRender: MeshRender;
        /**
         * 创建一个 <code>MeshSprite3D</code> 实例。
         * @param mesh 网格,同时会加载网格所用默认材质。
         * @param name 名字。
         */
        constructor(mesh?: laya.d3.resource.models.BaseMesh, name?: string);
        /**
         * @private
         */
        createConchModel(): any;
        protected _clearSelfRenderObjects(): void;
        protected _addSelfRenderObjects(): void;
        /**
         * @private
         */
        _applyMeshMaterials(mesh: laya.d3.resource.models.Mesh): void;
        /**
         * @private
         */
        _renderUpdate(projectionView: laya.d3.math.Matrix4x4): void;
        cloneTo(destObject: any): void;
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>TerrainMeshSprite3D</code> 类用于创建网格。
     */
    class MeshTerrainSprite3D extends MeshSprite3D {
        private static _tempVector3;
        private static _tempMatrix4x4;
        /**
         * 从网格创建一个TerrainMeshSprite3D实例和其高度图属性。
         * @param mesh 网格。
         * @param heightMapWidth 高度图宽度。
         * @param heightMapHeight 高度图高度。
         * @param name 名字。
         */
        static createFromMesh(mesh: laya.d3.resource.models.Mesh, heightMapWidth: number, heightMapHeight: number, name?: string): MeshTerrainSprite3D;
        /**
         * 从网格创建一个TerrainMeshSprite3D实例、图片读取高度图属性。
         * @param mesh 网格。
         * @param image 高度图。
         * @param name 名字。
         */
        static createFromMeshAndHeightMap(mesh: laya.d3.resource.models.Mesh, texture: laya.d3.resource.Texture2D, minHeight: number, maxHeight: number, name?: string): MeshTerrainSprite3D;
        /**
         * 获取地形X轴最小位置。
         * @return  地形X轴最小位置。
         */
        minX: number;
        /**
         * 获取地形Z轴最小位置。
         * @return  地形X轴最小位置。
         */
        minZ: number;
        /**
         * 获取地形X轴长度。
         * @return  地形X轴长度。
         */
        width: number;
        /**
         * 获取地形Z轴长度。
         * @return  地形Z轴长度。
         */
        depth: number;
        /**
         * 创建一个 <code>TerrainMeshSprite3D</code> 实例。
         * @param mesh 网格。
         * @param heightMap 高度图。
         * @param name 名字。
         */
        constructor(mesh: laya.d3.resource.models.Mesh, heightMap: HeightMap, name?: string);
        /**
         * @private
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * 获取地形高度。
         * @param x X轴坐标。
         * @param z Z轴坐标。
         */
        getHeight(x: number, z: number): number;
    }
}
declare module laya.d3.core.particle {
    /**
     * <code>EmitterBox</code> 类用于盒发射器。
     */
    class EmitterBox extends laya.particle.emitter.EmitterBase {
        protected _settings: laya.particle.ParticleSetting;
        protected _particle3D: Particle3D;
        protected _resultPosition: laya.d3.math.Vector3;
        protected _resultVelocity: laya.d3.math.Vector3;
        /**发射器中心位置。*/
        centerPosition: laya.d3.math.Vector3;
        /**发射器尺寸。*/
        size: laya.d3.math.Vector3;
        /**发射器速度。*/
        velocity: laya.d3.math.Vector3;
        /**发射器速度随机值。*/
        velocityAddVariance: laya.d3.math.Vector3;
        /**
         * 创建一个 <code>EmitterBox</code> 实例。
         * @param particle3D 粒子。
         */
        constructor(particle3D: Particle3D);
        protected _randomPositionOnBox(): laya.d3.math.Vector3;
        protected _randomVelocityOnBox(): laya.d3.math.Vector3;
        /**
         * 盒发射器发射函数。
         */
        emit(): void;
        /**
         * 更新盒粒子发射器。
         * @param state 渲染相关状态参数。
         */
        update(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.core.particle {
    /**
     * <code>EmitterPoint</code> 类用于点发射器。
     */
    class EmitterPoint extends laya.particle.emitter.EmitterBase {
        protected _settings: laya.particle.ParticleSetting;
        protected _particle3D: Particle3D;
        protected _resultPosition: laya.d3.math.Vector3;
        protected _resultVelocity: laya.d3.math.Vector3;
        /**发射器位置。*/
        position: laya.d3.math.Vector3;
        /**发射器位置随机值。*/
        positionVariance: laya.d3.math.Vector3;
        /**发射器速度。*/
        velocity: laya.d3.math.Vector3;
        /**发射器速度随机值。*/
        velocityAddVariance: laya.d3.math.Vector3;
        /**
         * 创建一个 <code>EmitterPoint</code> 实例。
         * @param particle3D 粒子。
         */
        constructor(particle3D: Particle3D);
        protected _randomPositionOnPoint(): laya.d3.math.Vector3;
        protected _randomVelocityOnPoint(): laya.d3.math.Vector3;
        /**
         * 点发射器发射函数。
         */
        emit(): void;
        /**
         * 更新点粒子发射器。
         * @param state 渲染相关状态参数。
         */
        update(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.core.particle {
    /**
     * <code>EmitterRing</code> 类用于环发射器。
     */
    class EmitterRing extends laya.particle.emitter.EmitterBase {
        protected _settings: laya.particle.ParticleSetting;
        protected _particle3D: Particle3D;
        protected _resultPosition: laya.d3.math.Vector3;
        protected _resultVelocity: laya.d3.math.Vector3;
        protected _direction: laya.d3.math.Vector3;
        /**发射器中心位置。*/
        centerPosition: laya.d3.math.Vector3;
        /**发射器半径。*/
        radius: number;
        /**发射器速度。*/
        velocity: number;
        /**发射器速度随机值。*/
        velocityAddVariance: number;
        /**发射器up向量，0代表X轴,1代表Y轴,2代表Z轴。*/
        up: number;
        /**
         * 创建一个 <code>EmitterRing</code> 实例。
         * @param particle3D 粒子。
         */
        constructor(particle3D: Particle3D);
        protected _randomPointOnRing(): laya.d3.math.Vector3;
        protected _randomVelocityOnRing(): laya.d3.math.Vector3;
        /**
         * 环发射器发射函数。
         */
        emit(): void;
        /**
         * 更新环粒子发射器。
         * @param state 渲染相关状态参数。
         */
        update(elapsedTime: number): void;
    }
}
declare module laya.d3.core.particle {
    /**
     * <code>EmitterSphere</code> 类用于球发射器。
     */
    class EmitterSphere extends laya.particle.emitter.EmitterBase {
        protected _settings: laya.particle.ParticleSetting;
        protected _particle3D: Particle3D;
        protected _reultPosition: laya.d3.math.Vector3;
        protected _resultVelocity: laya.d3.math.Vector3;
        protected _direction: laya.d3.math.Vector3;
        /**发射器中心位置。*/
        centerPosition: laya.d3.math.Vector3;
        /**发射器半径。*/
        radius: number;
        /**发射器速度。*/
        velocity: number;
        /**发射器速度随机值。*/
        velocityAddVariance: number;
        /**
         * 创建一个 <code>EmitterSphere</code> 实例。
         * @param particle3D 粒子。
         */
        constructor(particle3D: Particle3D);
        protected _randomPositionOnSphere(): laya.d3.math.Vector3;
        protected _randomVelocityOnSphere(): laya.d3.math.Vector3;
        /**
         * 球发射器发射函数。
         */
        emit(): void;
        /**
         * 更新球粒子发射器。
         * @param state 渲染相关状态参数。
         */
        update(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.core.particle {
    /**
     * <code>Particle3D</code> 3D粒子。
     */
    class Particle3D extends laya.d3.core.RenderableSprite3D {
        /**
         * 获取粒子模板。
         * @return  粒子模板。
         */
        templet: laya.d3.resource.tempelet.ParticleTemplet3D;
        /**
         * 获取粒子渲染器。
         * @return  粒子渲染器。
         */
        particleRender: laya.d3.core.ParticleRender;
        /**
         * 创建一个 <code>Particle3D</code> 实例。
         * @param settings value 粒子配置。
         */
        constructor(setting: laya.particle.ParticleSetting);
        protected _clearSelfRenderObjects(): void;
        protected _addSelfRenderObjects(): void;
        /**
         * @private
         */
        _renderUpdate(projectionView: laya.d3.math.Matrix4x4): void;
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * 添加粒子。
         * @param position 粒子位置。
         *  @param velocity 粒子速度。
         */
        addParticle(position: laya.d3.math.Vector3, velocity: laya.d3.math.Vector3): void;
        cloneTo(destObject: any): void;
        /**
         * <p>销毁此对象。</p>
         * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.core {
    /**
     * ...
     * @author ...
     */
    class ParticleRender extends laya.d3.core.render.BaseRender {
        constructor(owner: laya.d3.core.particle.Particle3D);
        protected _calculateBoundingBox(): void;
        protected _calculateBoundingSphere(): void;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>Burst</code> 类用于粒子的爆裂描述。
     */
    class Burst implements laya.d3.core.IClone {
        /**
         * 获取爆裂时间,单位为秒。
         * @return 爆裂时间,单位为秒。
         */
        time: number;
        /**
         * 获取爆裂的最小数量。
         * @return 爆裂的最小数量。
         */
        minCount: number;
        /**
         * 获取爆裂的最大数量。
         * @return 爆裂的最大数量。
         */
        maxCount: number;
        /**
         * 创建一个 <code>Burst</code> 实例。
         * @param time 爆裂时间,单位为秒。
         * @param minCount 爆裂的最小数量。
         * @param time 爆裂的最大数量。
         */
        constructor(time: number, minCount: number, maxCount: number);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>ColorOverLifetime</code> 类用于粒子的生命周期颜色。
     */
    class ColorOverLifetime {
        /**是否启用。*/
        enbale: boolean;
        /**
         *获取颜色。
         */
        color: GradientColor;
        /**
         * 创建一个 <code>ColorOverLifetime</code> 实例。
         */
        constructor(color: GradientColor);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>Emission</code> 类用于粒子发射器。
     */
    class Emission implements laya.d3.core.IClone, laya.resource.IDestroy {
        _minEmissionTime: number;
        _particleSystem: laya.d3.core.particleShuriKen.ShurikenParticleSystem;
        _shape: laya.d3.core.particleShuriKen.module.shape.BaseShape;
        _bursts: Array<any>;
        /**是否启用。*/
        enbale: boolean;
        /**
         * 获取粒子发射速率。
         * @return 粒子发射速率 (个/秒)。
         */
        /**
         * 设置粒子发射速率。
         * @param emissionRate 粒子发射速率 (个/秒)。
         */
        emissionRate: number;
        /**
         * 获取是否已销毁。
         * @return 是否已销毁。
         */
        destroyed: boolean;
        /**
         * 创建一个 <code>Emission</code> 实例。
         */
        constructor();
        /**
         * @private
         */
        _destroy(): void;
        /**
         * 获取粒子爆裂个数。
         * @return 粒子爆裂个数。
         */
        getBurstsCount(): number;
        /**
         * 通过索引获取粒子爆裂。
         * @param index 爆裂索引。
         * @return 粒子爆裂。
         */
        getBurstByIndex(index: number): Burst;
        /**
         * 增加粒子爆裂。
         * @param burst 爆裂。
         */
        addBurst(burst: Burst): void;
        /**
         * 移除粒子爆裂。
         * @param burst 爆裂。
         */
        removeBurst(burst: Burst): void;
        /**
         * 通过索引移除粒子爆裂。
         * @param index 爆裂索引。
         */
        removeBurstByIndex(index: number): void;
        /**
         * 清空粒子爆裂。
         */
        clearBurst(): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>FrameOverTime</code> 类用于创建时间帧。
     */
    class FrameOverTime implements laya.d3.core.IClone {
        /**
         * 通过固定帧创建一个 <code>FrameOverTime</code> 实例。
         * @param	constant 固定帧。
         * @return 时间帧。
         */
        static createByConstant(constant: number): FrameOverTime;
        /**
         * 通过时间帧创建一个 <code>FrameOverTime</code> 实例。
         * @param	overTime 时间帧。
         * @return 时间帧。
         */
        static createByOverTime(overTime: GradientDataInt): FrameOverTime;
        /**
         * 通过随机双固定帧创建一个 <code>FrameOverTime</code> 实例。
         * @param	constantMin 最小固定帧。
         * @param	constantMax 最大固定帧。
         * @return 时间帧。
         */
        static createByRandomTwoConstant(constantMin: number, constantMax: number): FrameOverTime;
        /**
         * 通过随机双时间帧创建一个 <code>FrameOverTime</code> 实例。
         * @param	gradientFrameMin 最小时间帧。
         * @param	gradientFrameMax 最大时间帧。
         * @return 时间帧。
         */
        static createByRandomTwoOverTime(gradientFrameMin: GradientDataInt, gradientFrameMax: GradientDataInt): FrameOverTime;
        /**
         *生命周期旋转类型,0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
         */
        type: number;
        /**
         * 固定帧。
         */
        constant: number;
        /**
         * 时间帧。
         */
        frameOverTimeData: GradientDataInt;
        /**
         * 最小固定帧。
         */
        constantMin: number;
        /**
         * 最大固定帧。
         */
        constantMax: number;
        /**
         * 最小时间帧。
         */
        frameOverTimeDataMin: GradientDataInt;
        /**
         * 最大时间帧。
         */
        frameOverTimeDataMax: GradientDataInt;
        /**
         * 创建一个 <code>FrameOverTime,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor();
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientRotation</code> 类用于创建渐变角速度。
     */
    class GradientAngularVelocity implements laya.d3.core.IClone {
        /**
         * 通过固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	constant 固定角速度。
         * @return 渐变角速度。
         */
        static createByConstant(constant: number): GradientAngularVelocity;
        /**
         * 通过分轴固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	separateConstant 分轴固定角速度。
         * @return 渐变角速度。
         */
        static createByConstantSeparate(separateConstant: laya.d3.math.Vector3): GradientAngularVelocity;
        /**
         * 通过渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	gradient 渐变角速度。
         * @return 渐变角速度。
         */
        static createByGradient(gradient: GradientDataNumber): GradientAngularVelocity;
        /**
         * 通过分轴渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	gradientX X轴渐变角速度。
         * @param	gradientY Y轴渐变角速度。
         * @param	gradientZ Z轴渐变角速度。
         * @return  渐变角速度。
         */
        static createByGradientSeparate(gradientX: GradientDataNumber, gradientY: GradientDataNumber, gradientZ: GradientDataNumber): GradientAngularVelocity;
        /**
         * 通过随机双固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	constantMin 最小固定角速度。
         * @param	constantMax 最大固定角速度。
         * @return 渐变角速度。
         */
        static createByRandomTwoConstant(constantMin: number, constantMax: number): GradientAngularVelocity;
        /**
         * 通过随机分轴双固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	separateConstantMin  最小分轴固定角速度。
         * @param	separateConstantMax  最大分轴固定角速度。
         * @return  渐变角速度。
         */
        static createByRandomTwoConstantSeparate(separateConstantMin: laya.d3.math.Vector3, separateConstantMax: laya.d3.math.Vector3): GradientAngularVelocity;
        /**
         * 通过随机双渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	gradientMin 最小渐变角速度。
         * @param	gradientMax 最大渐变角速度。
         * @return  渐变角速度。
         */
        static createByRandomTwoGradient(gradientMin: GradientDataNumber, gradientMax: GradientDataNumber): GradientAngularVelocity;
        /**
         * 通过分轴随机双渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
         * @param	gradientXMin  最小X轴渐变角速度。
         * @param	gradientXMax  最大X轴渐变角速度。
         * @param	gradientYMin  最小Y轴渐变角速度。
         * @param	gradientYMax  最大Y轴渐变角速度。
         * @param	gradientZMin  最小Z轴渐变角速度。
         * @param	gradientZMax  最大Z轴渐变角速度。
         * @return  渐变角速度。
         */
        static createByRandomTwoGradientSeparate(gradientXMin: GradientDataNumber, gradientXMax: GradientDataNumber, gradientYMin: GradientDataNumber, gradientYMax: GradientDataNumber, gradientZMin: GradientDataNumber, gradientZMax: GradientDataNumber): GradientAngularVelocity;
        /**
         *生命周期角速度类型,0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
         */
        type: number;
        /**
         *是否分轴。
         */
        separateAxes: boolean;
        /**
         * 固定角速度。
         */
        constant: number;
        /**
         * 分轴固定角速度。
         */
        constantSeparate: laya.d3.math.Vector3;
        /**
         * 渐变角速度。
         */
        gradient: GradientDataNumber;
        /**
         * 渐变角角速度X。
         */
        gradientX: GradientDataNumber;
        /**
         * 渐变角速度Y。
         */
        gradientY: GradientDataNumber;
        /**
         *渐变角速度Z。
         */
        gradientZ: GradientDataNumber;
        /**
         * 最小随机双固定角速度。
         */
        constantMin: number;
        /**
         * 最大随机双固定角速度。
         */
        constantMax: number;
        /**
         * 最小分轴随机双固定角速度。
         */
        constantMinSeparate: laya.d3.math.Vector3;
        /**
         * 最大分轴随机双固定角速度。
         */
        constantMaxSeparate: laya.d3.math.Vector3;
        /**
         *最小渐变角速度。
         */
        gradientMin: GradientDataNumber;
        /**
         * 最大渐变角速度。
         */
        gradientMax: GradientDataNumber;
        /**
         * 最小渐变角速度X。
         */
        gradientXMin: GradientDataNumber;
        /**
         * 最大渐变角速度X。
         */
        gradientXMax: GradientDataNumber;
        /**
         * 最小渐变角速度Y。
         */
        gradientYMin: GradientDataNumber;
        /**
         *最大渐变角速度Y。
         */
        gradientYMax: GradientDataNumber;
        /**
         * 最小渐变角速度Z。
         */
        gradientZMin: GradientDataNumber;
        /**
         * 最大渐变角速度Z。
         */
        gradientZMax: GradientDataNumber;
        /**
         * 创建一个 <code>GradientAngularVelocity,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor();
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientColor</code> 类用于创建渐变颜色。
     */
    class GradientColor implements laya.d3.core.IClone {
        /**
         * 通过固定颜色创建一个 <code>GradientColor</code> 实例。
         * @param constant 固定颜色。
         */
        static createByConstant(constant: laya.d3.math.Vector4): GradientColor;
        /**
         * 通过渐变颜色创建一个 <code>GradientColor</code> 实例。
         * @param gradient 渐变色。
         */
        static createByGradient(gradient: GradientDataColor): GradientColor;
        /**
         * 通过随机双固定颜色创建一个 <code>GradientColor</code> 实例。
         * @param minConstant 最小固定颜色。
         * @param maxConstant 最大固定颜色。
         */
        static createByRandomTwoConstant(minConstant: laya.d3.math.Vector4, maxConstant: laya.d3.math.Vector4): GradientColor;
        /**
         * 通过随机双渐变颜色创建一个 <code>GradientColor</code> 实例。
         * @param minGradient 最小渐变颜色。
         * @param maxGradient 最大渐变颜色。
         */
        static createByRandomTwoGradient(minGradient: GradientDataColor, maxGradient: GradientDataColor): GradientColor;
        /**
         *生命周期颜色类型,0为固定颜色模式,1渐变模式,2为随机双固定颜色模式,3随机双渐变模式。
         */
        type: number;
        /**
         * 固定颜色。
         */
        constant: laya.d3.math.Vector4;
        /**
         * 最小固定颜色。
         */
        constantMin: laya.d3.math.Vector4;
        /**
         * 最大固定颜色。
         */
        constantMax: laya.d3.math.Vector4;
        /**
         * 渐变颜色。
         */
        gradient: GradientDataColor;
        /**
         * 最小渐变颜色。
         */
        gradientMin: GradientDataColor;
        /**
         * 最大渐变颜色。
         */
        gradientMax: GradientDataColor;
        /**
         * 创建一个 <code>GradientColor,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor();
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientDataColor</code> 类用于创建颜色渐变。
     */
    class GradientDataColor implements laya.d3.core.IClone {
        _alphaElements: Float32Array;
        _rgbElements: Float32Array;
        /**渐变Alpha数量。*/
        alphaGradientCount: number;
        /**渐变RGB数量。*/
        rgbGradientCount: number;
        /**
         * 创建一个 <code>GradientDataColor</code> 实例。
         */
        constructor();
        /**
         * 增加Alpha渐变。
         * @param	key 生命周期，范围为0到1。
         * @param	value rgb值。
         */
        addAlpha(key: number, value: number): void;
        /**
         * 增加RGB渐变。
         * @param	key 生命周期，范围为0到1。
         * @param	value RGB值。
         */
        addRGB(key: number, value: laya.d3.math.Vector3): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientDataInt</code> 类用于创建整形渐变。
     */
    class GradientDataInt implements laya.d3.core.IClone {
        _elements: Float32Array;
        /**整形渐变数量。*/
        gradientCount: number;
        /**
         * 创建一个 <code>GradientDataInt</code> 实例。
         */
        constructor();
        /**
         * 增加整形渐变。
         * @param	key 生命周期，范围为0到1。
         * @param	value 整形值。
         */
        add(key: number, value: number): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientDataNumber</code> 类用于创建浮点渐变。
     */
    class GradientDataNumber implements laya.d3.core.IClone {
        _elements: Float32Array;
        /**渐变浮点数量。*/
        gradientCount: number;
        /**
         * 创建一个 <code>GradientDataNumber</code> 实例。
         */
        constructor();
        /**
         * 增加浮点渐变。
         * @param	key 生命周期，范围为0到1。
         * @param	value 浮点值。
         */
        add(key: number, value: number): void;
        /**
         * 通过索引获取键。
         * @param	index 索引。
         * @return	value 键。
         */
        getKeyByIndex(index: number): number;
        /**
         * 通过索引获取值。
         * @param	index 索引。
         * @return	value 值。
         */
        getValueByIndex(index: number): number;
        /**
         * 获取平均值。
         */
        getAverageValue(): number;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientDataVector2</code> 类用于创建二维向量渐变。
     */
    class GradientDataVector2 implements laya.d3.core.IClone {
        _elements: Float32Array;
        /**二维向量渐变数量。*/
        gradientCount: number;
        /**
         * 创建一个 <code>GradientDataVector2</code> 实例。
         */
        constructor();
        /**
         * 增加二维向量渐变。
         * @param	key 生命周期，范围为0到1。
         * @param	value 二维向量值。
         */
        add(key: number, value: laya.d3.math.Vector2): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientSize</code> 类用于创建渐变尺寸。
     */
    class GradientSize implements laya.d3.core.IClone {
        /**
         * 通过渐变尺寸创建一个 <code>GradientSize</code> 实例。
         * @param	gradient 渐变尺寸。
         * @return  渐变尺寸。
         */
        static createByGradient(gradient: GradientDataNumber): GradientSize;
        /**
         * 通过分轴渐变尺寸创建一个 <code>GradientSize</code> 实例。
         * @param	gradientX 渐变尺寸X。
         * @param	gradientY 渐变尺寸Y。
         * @param	gradientZ 渐变尺寸Z。
         * @return  渐变尺寸。
         */
        static createByGradientSeparate(gradientX: GradientDataNumber, gradientY: GradientDataNumber, gradientZ: GradientDataNumber): GradientSize;
        /**
         * 通过随机双固定尺寸创建一个 <code>GradientSize</code> 实例。
         * @param	constantMin 最小固定尺寸。
         * @param	constantMax 最大固定尺寸。
         * @return 渐变尺寸。
         */
        static createByRandomTwoConstant(constantMin: number, constantMax: number): GradientSize;
        /**
         * 通过分轴随机双固定尺寸创建一个 <code>GradientSize</code> 实例。
         * @param	constantMinSeparate 分轴最小固定尺寸.
         * @param	constantMaxSeparate 分轴最大固定尺寸。
         * @return   渐变尺寸。
         */
        static createByRandomTwoConstantSeparate(constantMinSeparate: laya.d3.math.Vector3, constantMaxSeparate: laya.d3.math.Vector3): GradientSize;
        /**
         * 通过随机双渐变尺寸创建一个 <code>GradientSize</code> 实例。
         * @param	gradientMin 最小渐变尺寸。
         * @param	gradientMax 最大渐变尺寸。
         * @return 渐变尺寸。
         */
        static createByRandomTwoGradient(gradientMin: GradientDataNumber, gradientMax: GradientDataNumber): GradientSize;
        /**
         * 通过分轴随机双渐变尺寸创建一个 <code>GradientSize</code> 实例。
         * @param	gradientXMin X轴最小渐变尺寸。
         * @param	gradientXMax X轴最大渐变尺寸。
         * @param	gradientYMin Y轴最小渐变尺寸。
         * @param	gradientYMax Y轴最大渐变尺寸。
         * @param	gradientZMin Z轴最小渐变尺寸。
         * @param	gradientZMax Z轴最大渐变尺寸。
         * @return  渐变尺寸。
         */
        static createByRandomTwoGradientSeparate(gradientXMin: GradientDataNumber, gradientXMax: GradientDataNumber, gradientYMin: GradientDataNumber, gradientYMax: GradientDataNumber, gradientZMin: GradientDataNumber, gradientZMax: GradientDataNumber): GradientSize;
        /**
         *生命周期尺寸类型，0曲线模式，1随机双常量模式，2随机双曲线模式。
         */
        type: number;
        /**
         *是否分轴。
         */
        separateAxes: boolean;
        /**
         * 渐变尺寸。
         */
        gradient: GradientDataNumber;
        /**
         * 渐变尺寸X。
         */
        gradientX: GradientDataNumber;
        /**
         * 渐变尺寸Y。
         */
        gradientY: GradientDataNumber;
        /**
         *渐变尺寸Z。
         */
        gradientZ: GradientDataNumber;
        /**
         *最小随机双固定尺寸。
         */
        constantMin: number;
        /**
         * 最大随机双固定尺寸。
         */
        constantMax: number;
        /**
         * 最小分轴随机双固定尺寸。
         */
        constantMinSeparate: laya.d3.math.Vector3;
        /**
         *  最小分轴随机双固定尺寸。
         */
        constantMaxSeparate: laya.d3.math.Vector3;
        /**
         *渐变最小尺寸。
         */
        gradientMin: GradientDataNumber;
        /**
         * 渐变最大尺寸。
         */
        gradientMax: GradientDataNumber;
        /**
         * 渐变最小尺寸X。
         */
        gradientXMin: GradientDataNumber;
        /**
         * 渐变最大尺寸X。
         */
        gradientXMax: GradientDataNumber;
        /**
         * 渐变最小尺寸Y。
         */
        gradientYMin: GradientDataNumber;
        /**
         *渐变最大尺寸Y。
         */
        gradientYMax: GradientDataNumber;
        /**
         * 渐变最小尺寸Z。
         */
        gradientZMin: GradientDataNumber;
        /**
         * 渐变最大尺寸Z。
         */
        gradientZMax: GradientDataNumber;
        /**
         * 创建一个 <code>GradientSize,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor();
        /**
         * 获取最大尺寸。
         */
        getMaxSizeInGradient(): number;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>GradientVelocity</code> 类用于创建渐变速度。
     */
    class GradientVelocity implements laya.d3.core.IClone {
        /**
         * 通过固定速度创建一个 <code>GradientVelocity</code> 实例。
         * @param	constant 固定速度。
         * @return 渐变速度。
         */
        static createByConstant(constant: laya.d3.math.Vector3): GradientVelocity;
        /**
         * 通过渐变速度创建一个 <code>GradientVelocity</code> 实例。
         * @param	gradientX 渐变速度X。
         * @param	gradientY 渐变速度Y。
         * @param	gradientZ 渐变速度Z。
         * @return  渐变速度。
         */
        static createByGradient(gradientX: GradientDataNumber, gradientY: GradientDataNumber, gradientZ: GradientDataNumber): GradientVelocity;
        /**
         * 通过随机双固定速度创建一个 <code>GradientVelocity</code> 实例。
         * @param	constantMin 最小固定角速度。
         * @param	constantMax 最大固定角速度。
         * @return 渐变速度。
         */
        static createByRandomTwoConstant(constantMin: laya.d3.math.Vector3, constantMax: laya.d3.math.Vector3): GradientVelocity;
        /**
         * 通过随机双渐变速度创建一个 <code>GradientVelocity</code> 实例。
         * @param	gradientXMin X轴最小渐变速度。
         * @param	gradientXMax X轴最大渐变速度。
         * @param	gradientYMin Y轴最小渐变速度。
         * @param	gradientYMax Y轴最大渐变速度。
         * @param	gradientZMin Z轴最小渐变速度。
         * @param	gradientZMax Z轴最大渐变速度。
         * @return  渐变速度。
         */
        static createByRandomTwoGradient(gradientXMin: GradientDataNumber, gradientXMax: GradientDataNumber, gradientYMin: GradientDataNumber, gradientYMax: GradientDataNumber, gradientZMin: GradientDataNumber, gradientZMax: GradientDataNumber): GradientVelocity;
        /**
         *生命周期速度类型，0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
         */
        type: number;
        /**固定速度。*/
        constant: laya.d3.math.Vector3;
        /**
         * 渐变速度X。
         */
        gradientX: GradientDataNumber;
        /**
         * 渐变速度Y。
         */
        gradientY: GradientDataNumber;
        /**
         *渐变速度Z。
         */
        gradientZ: GradientDataNumber;
        /**最小固定速度。*/
        constantMin: laya.d3.math.Vector3;
        /**最大固定速度。*/
        constantMax: laya.d3.math.Vector3;
        /**
         * 渐变最小速度X。
         */
        gradientXMin: GradientDataNumber;
        /**
         * 渐变最大速度X。
         */
        gradientXMax: GradientDataNumber;
        /**
         * 渐变最小速度Y。
         */
        gradientYMin: GradientDataNumber;
        /**
         *渐变最大速度Y。
         */
        gradientYMax: GradientDataNumber;
        /**
         * 渐变最小速度Z。
         */
        gradientZMin: GradientDataNumber;
        /**
         * 渐变最大速度Z。
         */
        gradientZMax: GradientDataNumber;
        /**
         * 创建一个 <code>GradientVelocity,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor();
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>RotationOverLifetime</code> 类用于粒子的生命周期旋转。
     */
    class RotationOverLifetime implements laya.d3.core.IClone {
        /**是否启用*/
        enbale: boolean;
        /**
         *获取角速度。
         */
        angularVelocity: GradientAngularVelocity;
        /**
         * 创建一个 <code>RotationOverLifetime,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor(angularVelocity: GradientAngularVelocity);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * <code>BaseShape</code> 类用于粒子形状。
     */
    class BaseShape implements laya.d3.core.IClone {
        /**是否启用。*/
        enable: boolean;
        /**随机方向。*/
        randomDirection: boolean;
        /**
         * 创建一个 <code>BaseShape</code> 实例。
         */
        constructor();
        protected _getShapeBoundBox(boundBox: laya.d3.math.BoundBox): void;
        protected _getSpeedBoundBox(boundBox: laya.d3.math.BoundBox): void;
        /**
         * 用于生成粒子初始位置和方向。
         * @param	position 粒子位置。
         * @param	direction 粒子方向。
         */
        generatePositionAndDirection(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3, rand?: laya.d3.math.Rand, randomSeeds?: Uint32Array): void;
        /**
         * @private
         */
        _calculateProceduralBounds(boundBox: laya.d3.math.BoundBox, emitterPosScale: laya.d3.math.Vector3, minMaxBounds: laya.d3.math.Vector2): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * <code>BoxShape</code> 类用于创建球形粒子形状。
     */
    class BoxShape extends BaseShape {
        /**发射器X轴长度。*/
        x: number;
        /**发射器Y轴长度。*/
        y: number;
        /**发射器Z轴长度。*/
        z: number;
        /**
         * 创建一个 <code>BoxShape</code> 实例。
         */
        constructor();
        protected _getShapeBoundBox(boundBox: laya.d3.math.BoundBox): void;
        protected _getSpeedBoundBox(boundBox: laya.d3.math.BoundBox): void;
        /**
         *  用于生成粒子初始位置和方向。
         * @param	position 粒子位置。
         * @param	direction 粒子方向。
         */
        generatePositionAndDirection(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3, rand?: laya.d3.math.Rand, randomSeeds?: Uint32Array): void;
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * <code>CircleShape</code> 类用于创建环形粒子形状。
     */
    class CircleShape extends BaseShape {
        protected static _tempPositionPoint: laya.d3.math.Vector2;
        /**发射器半径。*/
        radius: number;
        /**环形弧度。*/
        arc: number;
        /**从边缘发射。*/
        emitFromEdge: boolean;
        /**
         * 创建一个 <code>CircleShape</code> 实例。
         */
        constructor();
        protected _getShapeBoundBox(boundBox: laya.d3.math.BoundBox): void;
        protected _getSpeedBoundBox(boundBox: laya.d3.math.BoundBox): void;
        /**
         *  用于生成粒子初始位置和方向。
         * @param	position 粒子位置。
         * @param	direction 粒子方向。
         */
        generatePositionAndDirection(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3, rand?: laya.d3.math.Rand, randomSeeds?: Uint32Array): void;
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * <code>ConeShape</code> 类用于创建锥形粒子形状。
     */
    class ConeShape extends BaseShape {
        protected static _tempPositionPoint: laya.d3.math.Vector2;
        protected static _tempDirectionPoint: laya.d3.math.Vector2;
        /**发射角度。*/
        angle: number;
        /**发射器半径。*/
        radius: number;
        /**椎体长度。*/
        length: number;
        /**发射类型,0为Base,1为BaseShell,2为Volume,3为VolumeShell。*/
        emitType: number;
        /**
         * 创建一个 <code>ConeShape</code> 实例。
         */
        constructor();
        protected _getShapeBoundBox(boundBox: laya.d3.math.BoundBox): void;
        protected _getSpeedBoundBox(boundBox: laya.d3.math.BoundBox): void;
        /**
         *  用于生成粒子初始位置和方向。
         * @param	position 粒子位置。
         * @param	direction 粒子方向。
         */
        generatePositionAndDirection(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3, rand?: laya.d3.math.Rand, randomSeeds?: Uint32Array): void;
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * <code>HemisphereShape</code> 类用于创建半球形粒子形状。
     */
    class HemisphereShape extends BaseShape {
        /**发射器半径。*/
        radius: number;
        /**从外壳发射。*/
        emitFromShell: boolean;
        /**
         * 创建一个 <code>HemisphereShape</code> 实例。
         */
        constructor();
        protected _getShapeBoundBox(boundBox: laya.d3.math.BoundBox): void;
        protected _getSpeedBoundBox(boundBox: laya.d3.math.BoundBox): void;
        /**
         *  用于生成粒子初始位置和方向。
         * @param	position 粒子位置。
         * @param	direction 粒子方向。
         */
        generatePositionAndDirection(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3, rand?: laya.d3.math.Rand, randomSeeds?: Uint32Array): void;
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * ...
     * @author ...
     */
    class ShapeUtils {
        static _randomPointUnitArcCircle(arc: number, out: laya.d3.math.Vector2, rand?: laya.d3.math.Rand): void;
        static _randomPointInsideUnitArcCircle(arc: number, out: laya.d3.math.Vector2, rand?: laya.d3.math.Rand): void;
        static _randomPointUnitCircle(out: laya.d3.math.Vector2, rand?: laya.d3.math.Rand): void;
        static _randomPointInsideUnitCircle(out: laya.d3.math.Vector2, rand?: laya.d3.math.Rand): void;
        static _randomPointUnitSphere(out: laya.d3.math.Vector3, rand?: laya.d3.math.Rand): void;
        static _randomPointInsideUnitSphere(out: laya.d3.math.Vector3, rand?: laya.d3.math.Rand): void;
        static _randomPointInsideHalfUnitBox(out: laya.d3.math.Vector3, rand?: laya.d3.math.Rand): void;
        constructor();
    }
}
declare module laya.d3.core.particleShuriKen.module.shape {
    /**
     * <code>SphereShape</code> 类用于创建球形粒子形状。
     */
    class SphereShape extends BaseShape {
        /**发射器半径。*/
        radius: number;
        /**从外壳发射。*/
        emitFromShell: boolean;
        /**
         * 创建一个 <code>SphereShape</code> 实例。
         */
        constructor();
        protected _getShapeBoundBox(boundBox: laya.d3.math.BoundBox): void;
        protected _getSpeedBoundBox(boundBox: laya.d3.math.BoundBox): void;
        /**
         *  用于生成粒子初始位置和方向。
         * @param	position 粒子位置。
         * @param	direction 粒子方向。
         */
        generatePositionAndDirection(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3, rand?: laya.d3.math.Rand, randomSeeds?: Uint32Array): void;
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>SizeOverLifetime</code> 类用于粒子的生命周期尺寸。
     */
    class SizeOverLifetime implements laya.d3.core.IClone {
        /**是否启用*/
        enbale: boolean;
        /**
         *获取尺寸。
         */
        size: GradientSize;
        /**
         * 创建一个 <code>SizeOverLifetime</code> 实例。
         */
        constructor(size: GradientSize);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>StartFrame</code> 类用于创建开始帧。
     */
    class StartFrame implements laya.d3.core.IClone {
        /**
         * 通过随机常量旋转创建一个 <code>StartFrame</code> 实例。
         * @param	constant  固定帧。
         * @return 开始帧。
         */
        static createByConstant(constant: number): StartFrame;
        /**
         *  通过随机双常量旋转创建一个 <code>StartFrame</code> 实例。
         * @param	constantMin 最小固定帧。
         * @param	constantMax 最大固定帧。
         * @return 开始帧。
         */
        static createByRandomTwoConstant(constantMin: number, constantMax: number): StartFrame;
        /**
         *开始帧类型,0常量模式，1随机双常量模式。
         */
        type: number;
        /**
         * 固定帧。
         */
        constant: number;
        /**
         * 最小固定帧。
         */
        constantMin: number;
        /**
         * 最大固定帧。
         */
        constantMax: number;
        /**
         * 创建一个 <code>StartFrame,不允许new，请使用静态创建函数。</code> 实例。
         */
        constructor();
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>TextureSheetAnimation</code> 类用于创建粒子帧动画。
     */
    class TextureSheetAnimation implements laya.d3.core.IClone {
        /**纹理平铺。*/
        tiles: laya.d3.math.Vector2;
        /**类型,0为whole sheet、1为singal row。*/
        type: number;
        /**是否随机行，type为1时有效。*/
        randomRow: boolean;
        /**循环次数。*/
        cycles: number;
        /**UV通道类型,0为Noting,1为Everything,待补充,暂不支持。*/
        enableUVChannels: number;
        /**是否启用*/
        enbale: boolean;
        /**获取时间帧率。*/
        frame: FrameOverTime;
        /**获取开始帧率。*/
        startFrame: StartFrame;
        /**
         * 创建一个 <code>TextureSheetAnimation</code> 实例。
         * @param frame 动画帧。
         * @param  startFrame 开始帧。
         */
        constructor(frame: FrameOverTime, startFrame: StartFrame);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen.module {
    /**
     * <code>VelocityOverLifetime</code> 类用于粒子的生命周期速度。
     */
    class VelocityOverLifetime implements laya.d3.core.IClone {
        /**是否启用*/
        enbale: boolean;
        /**速度空间,0为local,1为world。*/
        space: number;
        /**
         *获取尺寸。
         */
        velocity: GradientVelocity;
        /**
         * 创建一个 <code>VelocityOverLifetime</code> 实例。
         */
        constructor(velocity: GradientVelocity);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core.particleShuriKen {
    /**
     * <code>ShuriKenParticle3D</code> 3D粒子。
     */
    class ShuriKenParticle3D extends laya.d3.core.RenderableSprite3D {
        static SHADERDEFINE_SPHERHBILLBOARD: number;
        static SHADERDEFINE_STRETCHEDBILLBOARD: number;
        static SHADERDEFINE_HORIZONTALBILLBOARD: number;
        static SHADERDEFINE_VERTICALBILLBOARD: number;
        static SHADERDEFINE_RANDOMCOLOROVERLIFETIME: number;
        static SHADERDEFINE_COLOROVERLIFETIME: number;
        static SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT: number;
        static SHADERDEFINE_VELOCITYOVERLIFETIMECURVE: number;
        static SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT: number;
        static SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE: number;
        static SHADERDEFINE_TEXTURESHEETANIMATIONCURVE: number;
        static SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE: number;
        static SHADERDEFINE_ROTATIONOVERLIFETIME: number;
        static SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE: number;
        static SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT: number;
        static SHADERDEFINE_ROTATIONOVERLIFETIMECURVE: number;
        static SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS: number;
        static SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES: number;
        static SHADERDEFINE_SIZEOVERLIFETIMECURVE: number;
        static SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE: number;
        static SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES: number;
        static SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE: number;
        static WORLDPOSITION: number;
        static WORLDROTATIONMATRIX: number;
        static POSITIONSCALE: number;
        static SIZESCALE: number;
        static VOLVELOCITYCONST: number;
        static VOLVELOCITYGRADIENTX: number;
        static VOLVELOCITYGRADIENTY: number;
        static VOLVELOCITYGRADIENTZ: number;
        static VOLVELOCITYCONSTMAX: number;
        static VOLVELOCITYGRADIENTXMAX: number;
        static VOLVELOCITYGRADIENTYMAX: number;
        static VOLVELOCITYGRADIENTZMAX: number;
        static VOLSPACETYPE: number;
        static COLOROVERLIFEGRADIENTALPHAS: number;
        static COLOROVERLIFEGRADIENTCOLORS: number;
        static MAXCOLOROVERLIFEGRADIENTALPHAS: number;
        static MAXCOLOROVERLIFEGRADIENTCOLORS: number;
        static SOLSIZEGRADIENT: number;
        static SOLSIZEGRADIENTX: number;
        static SOLSIZEGRADIENTY: number;
        static SOLSizeGradientZ: number;
        static SOLSizeGradientMax: number;
        static SOLSIZEGRADIENTXMAX: number;
        static SOLSIZEGRADIENTYMAX: number;
        static SOLSizeGradientZMAX: number;
        static ROLANGULARVELOCITYCONST: number;
        static ROLANGULARVELOCITYCONSTSEPRARATE: number;
        static ROLANGULARVELOCITYGRADIENT: number;
        static ROLANGULARVELOCITYGRADIENTX: number;
        static ROLANGULARVELOCITYGRADIENTY: number;
        static ROLANGULARVELOCITYGRADIENTZ: number;
        static ROLANGULARVELOCITYCONSTMAX: number;
        static ROLANGULARVELOCITYCONSTMAXSEPRARATE: number;
        static ROLANGULARVELOCITYGRADIENTMAX: number;
        static ROLANGULARVELOCITYGRADIENTXMAX: number;
        static ROLANGULARVELOCITYGRADIENTYMAX: number;
        static ROLANGULARVELOCITYGRADIENTZMAX: number;
        static TEXTURESHEETANIMATIONCYCLES: number;
        static TEXTURESHEETANIMATIONSUBUVLENGTH: number;
        static TEXTURESHEETANIMATIONGRADIENTUVS: number;
        static TEXTURESHEETANIMATIONGRADIENTMAXUVS: number;
        /**
         * 获取粒子系统。
         * @return  粒子系统。
         */
        particleSystem: ShurikenParticleSystem;
        /**
         * 获取粒子渲染器。
         * @return  粒子渲染器。
         */
        particleRender: laya.d3.core.particleShuriKen.ShurikenParticleRender;
        /**
         * 创建一个 <code>Particle3D</code> 实例。
         * @param settings value 粒子配置。
         */
        constructor(material?: laya.d3.core.particleShuriKen.ShurikenParticleMaterial);
        protected _clearSelfRenderObjects(): void;
        protected _addSelfRenderObjects(): void;
        /**
         * @inheritDoc
         */
        _renderUpdate(projectionView: laya.d3.math.Matrix4x4): void;
        /**
         * @private
         */
        cloneTo(destObject: any): void;
        /**
         * <p>销毁此对象。</p>
         * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.core.particleShuriKen {
    /**
     *  @private
     */
    class ShurikenParticleData {
        private static _tempRotationMatrix;
        private static _tempStartColor;
        private static _tempStartSize;
        private static _tempStartRotation0;
        private static _tempStartRotation1;
        private static _tempStartRotation2;
        private static _tempStartUVInfo;
        private static _tempSimulationWorldPostion;
        startLifeTime: number;
        position: Float32Array;
        direction: Float32Array;
        startColor: Float32Array;
        startSize: Float32Array;
        startRotation0: Float32Array;
        startRotation1: Float32Array;
        startRotation2: Float32Array;
        time: number;
        startSpeed: number;
        startUVInfo: Float32Array;
        simulationWorldPostion: Float32Array;
        constructor();
        static create(particleSystem: ShurikenParticleSystem, particleRender: ShurikenParticleRender, position: Float32Array, direction: Float32Array, time: number, transform: laya.d3.core.Transform3D): ShurikenParticleData;
    }
}
declare module laya.d3.core.particleShuriKen {
    /**
     * ...
     * @author ...
     */
    class ShurikenParticleMaterial extends laya.d3.core.material.BaseMaterial {
        /**渲染状态_不透明。*/
        static RENDERMODE_OPAQUE: number;
        /**渲染状态_不透明_双面。*/
        static RENDERMODE_OPAQUEDOUBLEFACE: number;
        /**渲染状态_透明混合。*/
        static RENDERMODE_TRANSPARENT: number;
        /**渲染状态_透明混合_双面。*/
        static RENDERMODE_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_加色法混合。*/
        static RENDERMODE_ADDTIVE: number;
        /**渲染状态_加色法混合_双面。*/
        static RENDERMODE_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_只读深度_透明混合。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENT: number;
        /**渲染状态_只读深度_透明混合_双面。*/
        static RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_只读深度_加色法混合。*/
        static RENDERMODE_DEPTHREAD_ADDTIVE: number;
        /**渲染状态_只读深度_加色法混合_双面。*/
        static RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: number;
        /**渲染状态_无深度_透明混合。*/
        static RENDERMODE_NONDEPTH_TRANSPARENT: number;
        /**渲染状态_无深度_透明混合_双面。*/
        static RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: number;
        /**渲染状态_无深度_加色法混合。*/
        static RENDERMODE_NONDEPTH_ADDTIVE: number;
        /**渲染状态_无深度_加色法混合_双面。*/
        static RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: number;
        static SHADERDEFINE_DIFFUSEMAP: number;
        static THREEDSTARTROTATION: number;
        static SCALINGMODE: number;
        static CURRENTTIME: number;
        static GRAVITY: number;
        static DIFFUSETEXTURE: number;
        static STRETCHEDBILLBOARDLENGTHSCALE: number;
        static STRETCHEDBILLBOARDSPEEDSCALE: number;
        static SIMULATIONSPACE: number;
        static TINTCOLOR: number;
        private static _tempGravity;
        /** 默认材质，禁止修改*/
        static defaultMaterial: ShurikenParticleMaterial;
        /**
         * 加载手里剑粒子材质。
         * @param url 手里剑粒子材质地址。
         */
        static load(url: string): ShurikenParticleMaterial;
        /**
         * 获取渲染状态。
         * @return 渲染状态。
         */
        /**
         * 设置渲染模式。
         * @return 渲染模式。
         */
        renderMode: number;
        /**
         * 获取颜色。
         * @return  颜色。
         */
        /**
         * 设置颜色。
         * @param value 颜色。
         */
        tintColor: laya.d3.math.Vector4;
        /**
         * 获取漫反射贴图。
         * @return 漫反射贴图。
         */
        /**
         * 设置漫反射贴图。
         * @param value 漫反射贴图。
         */
        diffuseTexture: laya.d3.resource.BaseTexture;
        constructor();
        /**
         * @private
         */
        static _parseShurikenParticleMaterial(textureMap: any, material: ShurikenParticleMaterial, json: any): void;
        /**
         * @inheritDoc
         */
        _setMaterialShaderParams(state: laya.d3.core.render.RenderState): void;
        /**
         *@private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * @inheritDoc
         */
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.core.particleShuriKen {
    /**
     * <code>ShurikenParticleRender</code> 类用于创建3D粒子渲染器。
     */
    class ShurikenParticleRender extends laya.d3.core.render.BaseRender {
        /**拉伸广告牌模式摄像机速度缩放,暂不支持*/
        stretchedBillboardCameraSpeedScale: number;
        /**拉伸广告牌模式速度缩放*/
        stretchedBillboardSpeedScale: number;
        /**拉伸广告牌模式长度缩放*/
        stretchedBillboardLengthScale: number;
        /**
         * 获取渲染模式。
         * @return 渲染模式。
         */
        /**
         * 设置渲染模式。
         * @param value 渲染模式。
         */
        renderMode: number;
        /**
         * 创建一个 <code>ShurikenParticleRender</code> 实例。
         */
        constructor(owner: laya.d3.core.particleShuriKen.ShuriKenParticle3D);
        protected _calculateBoundingBox(): void;
        protected _calculateBoundingSphere(): void;
        /**
         * @inheritDoc
         */
        boundingBox: laya.d3.math.BoundBox;
    }
}
declare module laya.d3.core.particleShuriKen {
    /**
     * <code>ShurikenParticleSystem</code> 类用于创建3D粒子数据模板。
     */
    class ShurikenParticleSystem extends laya.d3.core.GeometryFilter implements laya.d3.core.render.IRenderable, IClone {
        static _maxElapsedTime: number;
        static _RANDOMOFFSET: Uint32Array;
        private static _tempVector30;
        private static _tempVector31;
        private static _tempVector32;
        private static _tempVector33;
        private static _tempVector34;
        private static _tempVector35;
        private static _tempVector36;
        private static _tempVector37;
        private static _tempVector38;
        private static _tempVector39;
        private static _tempPosition;
        private static _tempDirection;
        protected _boundingSphere: laya.d3.math.BoundSphere;
        protected _boundingBox: laya.d3.math.BoundBox;
        _boundingBoxCorners: Array<any>;
        _startUpdateLoopCount: number;
        _rand: laya.d3.math.Rand;
        _randomSeeds: Uint32Array;
        /**粒子运行的总时长，单位为秒。*/
        duration: number;
        /**是否循环。*/
        looping: boolean;
        /**是否预热。暂不支持*/
        prewarm: boolean;
        /**开始延迟类型，0为常量模式,1为随机随机双常量模式，不能和prewarm一起使用。*/
        startDelayType: number;
        /**开始播放延迟，不能和prewarm一起使用。*/
        startDelay: number;
        /**开始播放最小延迟，不能和prewarm一起使用。*/
        startDelayMin: number;
        /**开始播放最大延迟，不能和prewarm一起使用。*/
        startDelayMax: number;
        /**开始生命周期模式,0为固定时间，1为渐变时间，2为两个固定之间的随机插值,3为两个渐变时间的随机插值。*/
        startLifetimeType: number;
        /**开始生命周期，0模式,单位为秒。*/
        startLifetimeConstant: number;
        /**开始渐变生命周期，1模式,单位为秒。*/
        startLifeTimeGradient: laya.d3.core.particleShuriKen.module.GradientDataNumber;
        /**最小开始生命周期，2模式,单位为秒。*/
        startLifetimeConstantMin: number;
        /**最大开始生命周期，2模式,单位为秒。*/
        startLifetimeConstantMax: number;
        /**开始渐变最小生命周期，3模式,单位为秒。*/
        startLifeTimeGradientMin: laya.d3.core.particleShuriKen.module.GradientDataNumber;
        /**开始渐变最大生命周期，3模式,单位为秒。*/
        startLifeTimeGradientMax: laya.d3.core.particleShuriKen.module.GradientDataNumber;
        /**开始速度模式，0为恒定速度，2为两个恒定速度的随机插值。缺少1、3模式*/
        startSpeedType: number;
        /**开始速度,0模式。*/
        startSpeedConstant: number;
        /**最小开始速度,1模式。*/
        startSpeedConstantMin: number;
        /**最大开始速度,1模式。*/
        startSpeedConstantMax: number;
        /**3D开始尺寸，暂不支持*/
        threeDStartSize: boolean;
        /**开始尺寸模式,0为恒定尺寸，2为两个恒定尺寸的随机插值。缺少1、3模式和对应的二种3D模式*/
        startSizeType: number;
        /**开始尺寸，0模式。*/
        startSizeConstant: number;
        /**开始三维尺寸，0模式。*/
        startSizeConstantSeparate: laya.d3.math.Vector3;
        /**最小开始尺寸，2模式。*/
        startSizeConstantMin: number;
        /**最大开始尺寸，2模式。*/
        startSizeConstantMax: number;
        /**最小三维开始尺寸，2模式。*/
        startSizeConstantMinSeparate: laya.d3.math.Vector3;
        /**最大三维开始尺寸，2模式。*/
        startSizeConstantMaxSeparate: laya.d3.math.Vector3;
        /**3D开始旋转，暂不支持*/
        threeDStartRotation: boolean;
        /**开始旋转模式,0为恒定尺寸，2为两个恒定旋转的随机插值,缺少2种模式,和对应的四种3D模式。*/
        startRotationType: number;
        /**开始旋转，0模式。*/
        startRotationConstant: number;
        /**开始三维旋转，0模式。*/
        startRotationConstantSeparate: laya.d3.math.Vector3;
        /**最小开始旋转，1模式。*/
        startRotationConstantMin: number;
        /**最大开始旋转，1模式。*/
        startRotationConstantMax: number;
        /**最小开始三维旋转，1模式。*/
        startRotationConstantMinSeparate: laya.d3.math.Vector3;
        /**最大开始三维旋转，1模式。*/
        startRotationConstantMaxSeparate: laya.d3.math.Vector3;
        /**随机旋转方向，范围为0.0到1.0*/
        randomizeRotationDirection: number;
        /**开始颜色模式，0为恒定颜色，2为两个恒定颜色的随机插值,缺少2种模式。*/
        startColorType: number;
        /**开始颜色，0模式。*/
        startColorConstant: laya.d3.math.Vector4;
        /**最小开始颜色，1模式。*/
        startColorConstantMin: laya.d3.math.Vector4;
        /**最大开始颜色，1模式。*/
        startColorConstantMax: laya.d3.math.Vector4;
        /**重力。*/
        gravity: laya.d3.math.Vector3;
        /**重力敏感度。*/
        gravityModifier: number;
        /**模拟器空间,0为World,1为Local。暂不支持*/
        simulationSpace: number;
        /**缩放模式，0为Hiercachy,1为Local,2为World。暂不支持1,2*/
        scaleMode: number;
        /**是否自动开始。*/
        playOnAwake: boolean;
        /**随机种子,注:play()前设置有效。*/
        randomSeed: Uint32Array;
        /**是否使用随机种子。 */
        autoRandomSeed: boolean;
        /**是否为性能模式,性能模式下会延迟粒子释放。*/
        isPerformanceMode: boolean;
        /**当前粒子时间。*/
        currentTime: number;
        /**获取最大粒子数。*/
        /**设置最大粒子数,注意:谨慎修改此属性，有性能损耗。*/
        maxParticles: number;
        /**
         * 获取发射器。
         */
        /**
         * 设置发射器。
         */
        emission: laya.d3.core.particleShuriKen.module.Emission;
        /**
         * 粒子存活个数。
         */
        aliveParticleCount: number;
        /**
         * 获取一次循环内的累计时间。
         * @return 一次循环内的累计时间。
         */
        emissionTime: number;
        /**
         * 获取形状。
         */
        /**
         * 设置形状。
         */
        shape: laya.d3.core.particleShuriKen.module.shape.BaseShape;
        /**
         * 是否存活。
         */
        isAlive: boolean;
        /**是否正在播放。*/
        isPlaying: boolean;
        /**是否已暂停。*/
        isPaused: boolean;
        /**
         * 获取播放的累计时间。
         * @return 播放的累计时间。
         */
        playbackTime: number;
        /**
         * 获取生命周期速度,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @return 生命周期速度.
         */
        /**
         * 设置生命周期速度,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @param value 生命周期速度.
         */
        velocityOverLifetime: laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
        /**
         * 获取生命周期颜色,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @return 生命周期颜色
         */
        /**
         * 设置生命周期颜色,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @param value 生命周期颜色
         */
        colorOverLifetime: laya.d3.core.particleShuriKen.module.ColorOverLifetime;
        /**
         * 获取生命周期尺寸,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @return 生命周期尺寸
         */
        /**
         * 设置生命周期尺寸,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @param value 生命周期尺寸
         */
        sizeOverLifetime: laya.d3.core.particleShuriKen.module.SizeOverLifetime;
        /**
         * 获取生命周期旋转,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @return 生命周期旋转。
         */
        /**
         * 设置生命周期旋转,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @param value 生命周期旋转。
         */
        rotationOverLifetime: laya.d3.core.particleShuriKen.module.RotationOverLifetime;
        /**
         * 获取生命周期纹理动画,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @return 生命周期纹理动画。
         */
        /**
         * 设置生命周期纹理动画,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
         * @param value 生命周期纹理动画。
         */
        textureSheetAnimation: laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
        indexOfHost: number;
        _vertexBufferCount: number;
        triangleCount: number;
        _getVertexBuffer(index?: number): laya.d3.graphics.VertexBuffer3D;
        _getIndexBuffer(): laya.d3.graphics.IndexBuffer3D;
        /**
         * @inheritDoc
         */
        _originalBoundingSphere: laya.d3.math.BoundSphere;
        /**
         * @inheritDoc
         */
        _originalBoundingBox: laya.d3.math.BoundBox;
        /**
         * @inheritDoc
         */
        _originalBoundingBoxCorners: Array<any>;
        constructor(owner: ShuriKenParticle3D);
        /**
         * @private
         */
        _generateBoundingSphere(): void;
        /**
         * @private
         */
        _generateBoundingBox(): void;
        /**
         * @private
         */
        _destroy(): void;
        /**
         * 发射一个粒子。
         */
        emit(): boolean;
        addParticle(position: laya.d3.math.Vector3, direction: laya.d3.math.Vector3): boolean;
        addNewParticlesToVertexBuffer(): void;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        _render(state: laya.d3.core.render.RenderState): void;
        /**
         * 开始发射粒子。
         */
        play(): void;
        /**
         * 暂停发射粒子。
         */
        pause(): void;
        /**
         * 停止发射粒子。
         */
        stop(): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.core {
    /**
     * @private
     * <code>PhasorSpriter3D</code> 类用于创建矢量笔刷。
     */
    class PhasorSpriter3D {
        protected _shaderCompile: laya.d3.shader.ShaderCompile3D;
        constructor();
        line(startX: number, startY: number, startZ: number, startR: number, startG: number, startB: number, startA: number, endX: number, endY: number, endZ: number, endR: number, endG: number, endB: number, endA: number): PhasorSpriter3D;
        circle(radius: number, numberOfPoints: number, r: number, g: number, b: number, a: number): PhasorSpriter3D;
        plane(positionX: number, positionY: number, positionZ: number, width: number, height: number, r: number, g: number, b: number, a: number): PhasorSpriter3D;
        box(positionX: number, positionY: number, positionZ: number, width: number, height: number, depth: number, r: number, g: number, b: number, a: number): PhasorSpriter3D;
        cone(radius: number, length: number, Slices: number, r: number, g: number, b: number, a: number): PhasorSpriter3D;
        boundingBoxLine(minX: number, minY: number, minZ: number, maxX: number, maxY: number, maxZ: number, r: number, g: number, b: number, a: number): PhasorSpriter3D;
        begin(primitive: number, state: laya.d3.core.render.RenderState): PhasorSpriter3D;
        end(): PhasorSpriter3D;
        protected _getShader(state: laya.d3.core.render.RenderState): laya.d3.shader.Shader3D;
    }
}
declare module laya.d3.core.render {
    /**
     * <code>Render</code> 类用于渲染器的父类，抽象类不允许示例。
     */
    class BaseRender extends laya.events.EventDispatcher implements laya.resource.IDestroy {
        static _tempBoudingBoxCorners: Array<any>;
        protected _boundingSphere: laya.d3.math.BoundSphere;
        protected _boundingBox: laya.d3.math.BoundBox;
        protected _boundingBoxCenter: laya.d3.math.Vector3;
        protected _boundingSphereNeedChange: boolean;
        protected _boundingBoxNeedChange: boolean;
        protected _boundingBoxCenterNeedChange: boolean;
        protected _octreeNodeNeedChange: boolean;
        _materials: Array<any>;
        _owner: laya.d3.core.Sprite3D;
        _renderElements: Array<any>;
        _distanceForSort: number;
        _treeNode: laya.d3.core.scene.ITreeNode;
        /**排序矫正值。*/
        sortingFudge: number;
        /** 是否产生阴影。 */
        castShadow: boolean;
        /**
         * 获取是否可用。
         * @return 是否可用。
         */
        /**
         * 设置是否可用。
         * @param value 是否可用。
         */
        enable: boolean;
        /**
         * 返回第一个实例材质,第一次使用会拷贝实例对象。
         * @return 第一个实例材质。
         */
        /**
         * 设置第一个实例材质。
         * @param value 第一个实例材质。
         */
        material: laya.d3.core.material.BaseMaterial;
        /**
         * 获取潜拷贝实例材质列表,第一次使用会拷贝实例对象。
         * @return 浅拷贝实例材质列表。
         */
        /**
         * 设置实例材质列表。
         * @param value 实例材质列表。
         */
        materials: Array<any>;
        /**
         * 返回第一个材质。
         * @return 第一个材质。
         */
        /**
         * 设置第一个材质。
         * @param value 第一个材质。
         */
        sharedMaterial: laya.d3.core.material.BaseMaterial;
        /**
         * 获取浅拷贝材质列表。
         * @return 浅拷贝材质列表。
         */
        /**
         * 设置材质列表。
         * @param value 材质列表。
         */
        sharedMaterials: Array<any>;
        /**
         * 获取包围球,不允许修改其值。
         * @return 包围球。
         */
        boundingSphere: laya.d3.math.BoundSphere;
        /**
         * 获取包围盒,不允许修改其值。
         * @return 包围盒。
         */
        boundingBox: laya.d3.math.BoundBox;
        /**
         * 获取包围盒中心,不允许修改其值。
         * @return 包围盒中心。
         */
        boundingBoxCenter: laya.d3.math.Vector3;
        /**
         * 获得是否接收阴影属性
         */
        /**
         * 设置是否接收阴影属性
         */
        receiveShadow: boolean;
        /**
         * 获取是否已销毁。
         * @return 是否已销毁。
         */
        destroyed: boolean;
        /**
         * 创建一个新的 <code>BaseRender</code> 实例。
         */
        constructor(owner: laya.d3.core.Sprite3D);
        protected _calculateBoundingSphere(): void;
        protected _calculateBoundingBox(): void;
        /**
         * @private
         */
        _updateOctreeNode(): void;
        /**
         * @private
         */
        _destroy(): void;
    }
}
declare module laya.d3.core.render {
    /**
     * <code>IRender</code> 接口用于实现3D对象的渲染相关功能。
     */
    interface IRenderable {
    }
}
declare module laya.d3.core.render {
    /**
     * <code>IUpdate</code> 接口用于实现3D对象的更新相关功能。
     */
    interface IUpdate {
    }
}
declare module laya.d3.core.render {
    /**
     * @private
     * <code>RenderElement</code> 类用于实现渲染物体。
     */
    class RenderElement {
        private static _tempVector30;
        private static _tempVector31;
        private static _tempQuaternion0;
        private static _tempMatrix4x40;
        private static _tempMatrix4x41;
        _type: number;
        _mainSortID: number;
        _render: BaseRender;
        _sprite3D: laya.d3.core.Sprite3D;
        _material: laya.d3.core.material.BaseMaterial;
        _staticBatch: laya.d3.graphics.StaticBatch;
        _batchIndexStart: number;
        _batchIndexEnd: number;
        _canDynamicBatch: boolean;
        /**当前ShaderValue。*/
        _shaderValue: laya.d3.shader.ValusArray;
        _onPreRenderFunction: Function;
        _conchSubmesh: any;
        renderObj: IRenderable;
        /**
         * 创建一个 <code>RenderElement</code> 实例。
         */
        constructor();
        /**
         * @private
         */
        getStaticBatchBakedVertexs(index: number): Float32Array;
        /**
         * @private
         */
        getDynamicBatchBakedVertexs(index: number): Float32Array;
        /**
         * @private
         */
        getBakedIndices(): any;
    }
}
declare module laya.d3.core.render {
    /**
     * @private
     * <code>RenderQuene</code> 类用于实现渲染队列。
     */
    class RenderQueue {
        private static _uniqueIDCounter;
        /** 定义非透明渲染队列标记。*/
        static OPAQUE: number;
        /** 透明混合渲染队列标记。*/
        static TRANSPARENT: number;
        private static _cameraPosition;
        /**
         * 获取唯一标识ID(通常用于优化或识别)。
         */
        id: number;
        /**
         * 创建一个 <code>RenderQuene</code> 实例。
         * @param renderConfig 渲染配置。
         */
        constructor(scene: laya.d3.core.scene.BaseScene);
        protected _preRenderUpdateComponents(sprite3D: laya.d3.core.Sprite3D, state: RenderState): void;
        protected _postRenderUpdateComponents(sprite3D: laya.d3.core.Sprite3D, state: RenderState): void;
        /**
         * @private
         */
        _sortAlpha(cameraPos: laya.d3.math.Vector3): void;
        /**
         * @private
         */
        _sortOpaque(cameraPos: laya.d3.math.Vector3): void;
        /**
         * @private
         * 准备渲染队列。
         * @param	state 渲染状态。
         */
        _preRender(state: RenderState): void;
        /**
         * @private
         * 渲染队列。
         * @param	state 渲染状态。
         */
        _render(state: RenderState, isTarget: boolean): void;
        staticBatch: laya.d3.graphics.StaticBatch;
        /**
         * @private
         * 渲染队列。
         * @param	state 渲染状态。
         */
        _renderShadow(state: RenderState, isOnePSSM: boolean): void;
        /**
         * 清空队列中的渲染物体。
         */
        _clearRenderElements(): void;
        /**
         * 添加渲染物体。
         * @param renderObj 渲染物体。
         */
        _addRenderElement(renderElement: RenderElement): void;
        /**
         * 添加静态批处理。
         * @param renderObj 静态批处理。
         */
        _addStaticBatch(staticBatch: laya.d3.graphics.StaticBatch): void;
        /**
         * 添加动态批处理。
         * @param renderObj 动态批处理。
         */
        _addDynamicBatchElement(dynamicBatchElement: RenderElement): void;
    }
}
declare module laya.d3.core.render {
    /**
     * <code>RenderState</code> 类用于实现渲染状态。
     */
    class RenderState {
        /**渲染区宽度。*/
        static clientWidth: number;
        /**渲染区高度。*/
        static clientHeight: number;
        _staticBatch: laya.d3.graphics.StaticBatch;
        _batchIndexStart: number;
        _batchIndexEnd: number;
        _viewMatrix: laya.d3.math.Matrix4x4;
        _projectionMatrix: laya.d3.math.Matrix4x4;
        _projectionViewMatrix: laya.d3.math.Matrix4x4;
        _viewport: laya.d3.math.Viewport;
        _boundFrustum: laya.d3.math.BoundFrustum;
        _shader: laya.d3.shader.Shader3D;
        /**距上一帧间隔时间。*/
        elapsedTime: number;
        /**当前场景。*/
        scene: laya.d3.core.scene.BaseScene;
        /**当前渲染3D精灵。*/
        owner: laya.d3.core.Sprite3D;
        /**当前渲染物体。*/
        renderElement: RenderElement;
        /**当前摄像机。*/
        camera: laya.d3.core.BaseCamera;
        cameraBoundingFrustum: laya.d3.math.BoundFrustum;
        /**
         * 创建一个 <code>RenderState</code> 实例。
         */
        constructor();
    }
}
declare module laya.d3.core {
    /**
     * <code>RenderableSprite3D</code> 类用于可渲染3D精灵的父类，抽象类不允许实例。
     */
    class RenderableSprite3D extends Sprite3D {
        private static _tempBoundBoxCorners;
        static SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV: number;
        _render: laya.d3.core.render.BaseRender;
        _geometryFilter: GeometryFilter;
        /**
         * 创建一个 <code>RenderableSprite3D</code> 实例。
         */
        constructor(name?: string);
        protected _renderRenderableBoundBox(): void;
        /**
         * @inheritDoc
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * @inheritDoc
         */
        _updateConch(state: laya.d3.core.render.RenderState): void;
        /**
         * @inheritDoc
         */
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.core.scene {
    /**
     * <code>BaseScene</code> 类用于实现场景的父类。
     */
    class BaseScene extends laya.display.Sprite implements laya.webgl.submit.ISubmit {
        static FOGCOLOR: number;
        static FOGSTART: number;
        static FOGRANGE: number;
        static LIGHTDIRECTION: number;
        static LIGHTDIRDIFFUSE: number;
        static LIGHTDIRAMBIENT: number;
        static LIGHTDIRSPECULAR: number;
        static POINTLIGHTPOS: number;
        static POINTLIGHTRANGE: number;
        static POINTLIGHTATTENUATION: number;
        static POINTLIGHTDIFFUSE: number;
        static POINTLIGHTAMBIENT: number;
        static POINTLIGHTSPECULAR: number;
        static SPOTLIGHTPOS: number;
        static SPOTLIGHTDIRECTION: number;
        static SPOTLIGHTSPOT: number;
        static SPOTLIGHTRANGE: number;
        static SPOTLIGHTATTENUATION: number;
        static SPOTLIGHTDIFFUSE: number;
        static SPOTLIGHTAMBIENT: number;
        static SPOTLIGHTSPECULAR: number;
        static SHADOWDISTANCE: number;
        static SHADOWLIGHTVIEWPROJECT: number;
        static SHADOWMAPPCFOFFSET: number;
        static SHADOWMAPTEXTURE1: number;
        static SHADOWMAPTEXTURE2: number;
        static SHADOWMAPTEXTURE3: number;
        protected _invertYProjectionMatrix: laya.d3.math.Matrix4x4;
        protected _invertYProjectionViewMatrix: laya.d3.math.Matrix4x4;
        protected _invertYScaleMatrix: laya.d3.math.Matrix4x4;
        protected _renderState: laya.d3.core.render.RenderState;
        protected _lights: Array<any>;
        protected _enableLightCount: number;
        protected _renderTargetTexture: laya.d3.resource.RenderTexture;
        protected _customRenderQueneIndex: number;
        protected _lastCurrentTime: number;
        protected _enableFog: boolean;
        protected _enableDepthFog: boolean;
        protected _fogStart: number;
        protected _fogRange: number;
        protected _fogColor: laya.d3.math.Vector3;
        _shaderValues: laya.d3.shader.ValusArray;
        _shaderDefineValue: number;
        _frustumCullingObjects: Array<any>;
        _staticBatchManager: laya.d3.graphics.StaticBatchManager;
        _dynamicBatchManager: laya.d3.graphics.DynamicBatchManager;
        _quenes: Array<any>;
        _cameraPool: Array<any>;
        /** 是否启用灯光。*/
        enableLight: boolean;
        /** 四/八叉树的根节点。*/
        treeRoot: ITreeNode;
        /** 四/八叉树的尺寸。*/
        treeSize: laya.d3.math.Vector3;
        /** 四/八叉树的层数。*/
        treeLevel: number;
        parallelSplitShadowMaps: Array<any>;
        /**
         * 获取是否允许雾化。
         * @return 是否允许雾化。
         */
        /**
         * 设置是否允许雾化。
         * @param value 是否允许雾化。
         */
        enableFog: boolean;
        enableDepthFog: boolean;
        /**
         * 获取雾化颜色。
         * @return 雾化颜色。
         */
        /**
         * 设置雾化颜色。
         * @param value 雾化颜色。
         */
        fogColor: laya.d3.math.Vector3;
        /**
         * 获取雾化起始位置。
         * @return 雾化起始位置。
         */
        /**
         * 设置雾化起始位置。
         * @param value 雾化起始位置。
         */
        fogStart: number;
        /**
         * 获取雾化范围。
         * @return 雾化范围。
         */
        /**
         * 设置雾化范围。
         * @param value 雾化范围。
         */
        fogRange: number;
        /**
         * 获取当前场景。
         * @return 当前场景。
         */
        scene: BaseScene;
        /**
         * 创建一个 <code>BaseScene</code> 实例。
         */
        constructor();
        /**
         * 初始化八叉树。
         * @param	width 八叉树宽度。
         * @param	height 八叉树高度。
         * @param	depth 八叉树深度。
         * @param	center 八叉树中心点
         * @param	level 八叉树层级。
         */
        initOctree(width: number, height: number, depth: number, center: laya.d3.math.Vector3, level?: number): void;
        protected _prepareUpdateToRenderState(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState): void;
        protected _prepareSceneToRender(state: laya.d3.core.render.RenderState): void;
        protected _updateChilds(state: laya.d3.core.render.RenderState): void;
        protected _updateChildsConch(state: laya.d3.core.render.RenderState): void;
        protected _preRenderScene(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState): void;
        protected _clear(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState): void;
        protected _renderScene(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState): void;
        protected _set3DRenderConfig(gl: laya.webgl.WebGLContext): void;
        protected _set2DRenderConfig(gl: laya.webgl.WebGLContext): void;
        /**
         * @private
         */
        _addLight(light: laya.d3.core.light.LightSprite): void;
        /**
         * @private
         */
        _removeLight(light: laya.d3.core.light.LightSprite): void;
        /**
         * @private
         */
        _updateScene(): void;
        /**
         * @private
         */
        _updateSceneConch(): void;
        protected _preRenderShadow(state: laya.d3.core.render.RenderState, lightFrustum: Array<any>, shdowQueues: Array<any>, lightViewProjectMatrix: laya.d3.math.Matrix4x4, nPSSMNum: number): void;
        protected _renderShadowMap(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState, sceneCamera: laya.d3.core.BaseCamera): void;
        /**
         * @private
         */
        addTreeNode(renderObj: laya.d3.core.render.BaseRender): void;
        /**
         * @private
         */
        removeTreeNode(renderObj: laya.d3.core.render.BaseRender): void;
        /**
         * @inheritDoc
         */
        addChildAt(node: laya.display.Node, index: number): laya.display.Node;
        /**
         * @inheritDoc
         */
        addChild(node: laya.display.Node): laya.display.Node;
        /**
         * @inheritDoc
         */
        removeChildAt(index: number): laya.display.Node;
        /**
         * @inheritDoc
         */
        removeChildren(beginIndex?: number, endIndex?: number): laya.display.Node;
        /**
         * @inheritDoc
         */
        addFrustumCullingObject(renderObject: laya.d3.core.render.BaseRender): void;
        /**
         * @private
         */
        removeFrustumCullingObject(renderObject: laya.d3.core.render.BaseRender): void;
        /**
         * 获得某个渲染队列。
         * @param index 渲染队列索引。
         * @return 渲染队列。
         */
        getRenderQueue(index: number): laya.d3.core.render.RenderQueue;
        /**
         * 添加渲染队列。
         * @param renderConfig 渲染队列配置文件。
         */
        addRenderQuene(): void;
        /**
         * 更新前处理,可重写此函数。
         * @param state 渲染相关状态。
         */
        beforeUpdate(state: laya.d3.core.render.RenderState): void;
        /**
         * 更新后处理,可重写此函数。
         * @param state 渲染相关状态。
         */
        lateUpdate(state: laya.d3.core.render.RenderState): void;
        /**
         * 渲染前处理,可重写此函数。
         * @param state 渲染相关状态。
         */
        beforeRender(state: laya.d3.core.render.RenderState): void;
        /**
         * 渲染后处理,可重写此函数。
         * @param state 渲染相关状态。
         */
        lateRender(state: laya.d3.core.render.RenderState): void;
        /**
         * 增加shader宏定义。
         * @param	define shader宏定义。
         */
        addShaderDefine(define: number): void;
        /**
         * 移除shader宏定义。
         * @param	define shader宏定义。
         */
        removeShaderDefine(define: number): void;
        /**
         * @inheritDoc
         */
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        protected _renderCamera(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState, baseCamera: laya.d3.core.BaseCamera): void;
        /**
         * @private
         */
        renderSubmit(): number;
        protected _renderDebug(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         */
        getRenderType(): number;
        /**
         * @private
         */
        releaseRender(): void;
        /**
         * @private
         */
        createConchModel(): any;
    }
}
declare module laya.d3.core.scene {
    /**
     * ...
     * @author lv
     */
    interface ITreeNode {
    }
}
declare module laya.d3.core.scene {
    class OctreeNode implements ITreeNode {
        /**是否开启四/八叉树调试模式。 */
        static debugMode: boolean;
        private static relax;
        private static tempVector0;
        private static tempSize;
        private static tempCenter;
        private static _octreeSplit;
        _children: Array<any>;
        init(center: laya.d3.math.Vector3, treeSize: laya.d3.math.Vector3): void;
        addTreeNode(render: laya.d3.core.render.BaseRender): void;
        exactBox: laya.d3.math.BoundBox;
        relaxBox: laya.d3.math.BoundBox;
        constructor(scene: BaseScene, currentDepth: number);
        addChild(index: number): OctreeNode;
        addObject(object: laya.d3.core.render.BaseRender): void;
        removeObject(object: laya.d3.core.render.BaseRender): boolean;
        clearObject(): void;
        addNodeUp(render: laya.d3.core.render.BaseRender, depth: number): void;
        addNodeDown(render: laya.d3.core.render.BaseRender, depth: number): void;
        inChildIndex(objectCenter: laya.d3.math.Vector3): number;
        updateObject(render: laya.d3.core.render.BaseRender): void;
        cullingObjects(boundFrustum: laya.d3.math.BoundFrustum, testVisible: boolean, flags: number, cameraPosition: laya.d3.math.Vector3, projectionView: laya.d3.math.Matrix4x4): void;
        staticBatch: laya.d3.graphics.StaticBatch;
        /**
         * @private
         */
        cullingShadowObjects(lightBoundFrustum: Array<any>, splitShadowQueues: Array<any>, testVisible: boolean, flags: number, scene: BaseScene): void;
        /**
         * @private
         */
        cullingShadowObjectsOnePSSM(lightBoundFrustum: laya.d3.math.BoundFrustum, splitShadowQueues: Array<any>, lightViewProjectMatrix: laya.d3.math.Matrix4x4, testVisible: boolean, flags: number, scene: BaseScene): void;
        renderBoudingBox(linePhasor: laya.d3.core.PhasorSpriter3D): void;
        buildAllChild(depth: number): void;
    }
}
declare module laya.d3.core.scene {
    /**
     * <code>Scene</code> 类用于实现普通场景。
     */
    class Scene extends BaseScene {
        /**
         * 创建一个 <code>Scene</code> 实例。
         */
        constructor();
        protected _renderCamera(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState, baseCamera: laya.d3.core.BaseCamera): void;
    }
}
declare module laya.d3.core.scene {
    /**
     * <code>VRScene</code> 类用于实现VR场景。
     */
    class VRScene extends BaseScene {
        /**
         * 创建一个 <code>VRScene</code> 实例。
         */
        constructor();
        protected _renderCamera(gl: laya.webgl.WebGLContext, state: laya.d3.core.render.RenderState, baseCamera: laya.d3.core.BaseCamera): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>Sprite3D</code> 类用于实现3D精灵。
     */
    class Sprite3D extends laya.display.Node implements laya.d3.core.render.IUpdate, laya.resource.ICreateResource, IClone {
        /**着色器变量名，世界矩阵。*/
        static WORLDMATRIX: number;
        /**着色器变量名，世界视图投影矩阵。*/
        static MVPMATRIX: number;
        protected static _uniqueIDCounter: number;
        protected static _nameNumberCounter: number;
        /**
         * 创建精灵的克隆实例。
         * @param	original  原始精灵。
         * @param	position  世界位置。
         * @param	rotation  世界旋转。
         * @param   parent    父节点。
         * @param   worldPositionStays 是否保持自身世界变换,注意:在position，rotation均为空时有效。
         * @return  克隆实例。
         */
        static instantiate(original: Sprite3D, position?: laya.d3.math.Vector3, rotation?: laya.d3.math.Quaternion, parent?: laya.display.Node, worldPositionStays?: boolean): Sprite3D;
        /**
         * 加载网格模板,注意:不缓存。
         * @param url 模板地址。
         */
        static load(url: string): Sprite3D;
        _projectionViewWorldUpdateLoopCount: number;
        _projectionViewWorldUpdateCamera: BaseCamera;
        protected _active: boolean;
        protected _activeInHierarchy: boolean;
        protected _layer: Layer;
        _shaderDefineValue: number;
        _shaderValues: laya.d3.shader.ValusArray;
        _colliders: Array<any>;
        /**矩阵变换相关。*/
        transform: Transform3D;
        /**是否静态,静态包含一系列的特殊处理*/
        isStatic: boolean;
        /**
         * 获取唯一标识ID。
         *   @return	唯一标识ID。
         */
        id: number;
        /**
         * 获取自身是否激活。
         *   @return	自身是否激活。
         */
        /**
         * 设置是否激活。
         * @param	value 是否激活。
         */
        active: boolean;
        /**
         * 获取在层级中是否激活。
         *   @return	在层级中是否激活。
         */
        activeInHierarchy: boolean;
        /**
         * 获取蒙版。
         * @return	蒙版。
         */
        /**
         * 设置蒙版。
         * @param	value 蒙版。
         */
        layer: Layer;
        /**
         * 获得所属场景。
         * @return	场景。
         */
        scene: laya.d3.core.scene.BaseScene;
        /**
         * 获得组件的数量。
         * @return	组件数量。
         */
        componentsCount: number;
        /**
         * 获取资源的URL地址。
         * @return URL地址。
         */
        /**
         * 色湖之资源的URL地址。
         * @param value URL地址。
         */
        url: string;
        /**
         * 获取是否属于场景。
         * @return  是否属于场景。
         */
        belongScene: boolean;
        /**
         * 创建一个 <code>Sprite3D</code> 实例。
         */
        constructor(name?: string);
        /**
         * @private
         */
        _setBelongScene(): void;
        /**
         * @private
         */
        _setUnBelongScene(): void;
        /**
         * @private
         */
        _inActiveHierarchy(): void;
        /**
         * @private
         */
        _activeHierarchy(): void;
        /**
         * @private
         */
        createConchModel(): any;
        /**
         * 增加Shader宏定义。
         * @param value 宏定义。
         */
        _addShaderDefine(value: number): void;
        /**
         * 移除Shader宏定义。
         * @param value 宏定义。
         */
        _removeShaderDefine(value: number): void;
        protected _clearSelfRenderObjects(): void;
        protected _addSelfRenderObjects(): void;
        protected _updateComponents(state: laya.d3.core.render.RenderState): void;
        protected _lateUpdateComponents(state: laya.d3.core.render.RenderState): void;
        protected _updateChilds(state: laya.d3.core.render.RenderState): void;
        protected _updateChildsConch(state: laya.d3.core.render.RenderState): void;
        /**
         * 排序函数。
         * @param	state 渲染相关状态。
         */
        _getSortID(renderElement: laya.d3.core.render.IRenderable, material: laya.d3.core.material.BaseMaterial): number;
        /**
         * @private
         */
        _renderUpdate(projectionView: laya.d3.math.Matrix4x4): void;
        /**
         * 更新
         * @param	state 渲染相关状态
         */
        _update(state: laya.d3.core.render.RenderState): void;
        /**
         * 更新
         * @param	state 渲染相关状态
         */
        _updateConch(state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         */
        _setShaderValueMatrix4x4(shaderName: number, matrix4x4: laya.d3.math.Matrix4x4): void;
        /**
         * 设置颜色。
         * @param	shaderIndex shader索引。
         * @param	color 颜色向量。
         */
        _setShaderValueColor(shaderIndex: number, color: any): void;
        /**
         * 设置Buffer。
         * @param	shaderIndex shader索引。
         * @param	buffer  buffer数据。
         */
        _setShaderValueBuffer(shaderIndex: number, buffer: Float32Array): void;
        /**
         * 设置整型。
         * @param	shaderIndex shader索引。
         * @param	i 整形。
         */
        _setShaderValueInt(shaderIndex: number, i: number): void;
        /**
         * 设置布尔。
         * @param	shaderIndex shader索引。
         * @param	b 布尔。
         */
        _setShaderValueBool(shaderIndex: number, b: boolean): void;
        /**
         * 设置浮点。
         * @param	shaderIndex shader索引。
         * @param	i 浮点。
         */
        _setShaderValueNumber(shaderIndex: number, number: number): void;
        /**
         * 设置二维向量。
         * @param	shaderIndex shader索引。
         * @param	vector2 二维向量。
         */
        _setShaderValueVector2(shaderIndex: number, vector2: laya.d3.math.Vector2): void;
        /**
         * 获取投影视图世界矩阵。
         * @param	projectionViewMatrix 投影视图矩阵。
         * @return  投影视图世界矩阵。
         */
        getProjectionViewWorldMatrix(projectionViewMatrix: laya.d3.math.Matrix4x4): laya.d3.math.Matrix4x4;
        /**
         * 加载层级文件，并作为该节点的子节点。
         * @param	url
         */
        loadHierarchy(url: string): void;
        /**
         * @inheritDoc
         */
        addChildAt(node: laya.display.Node, index: number): laya.display.Node;
        /**
         * @inheritDoc
         */
        addChild(node: laya.display.Node): laya.display.Node;
        /**
         * @inheritDoc
         */
        removeChildAt(index: number): laya.display.Node;
        /**
         * @inheritDoc
         */
        removeChildren(beginIndex?: number, endIndex?: number): laya.display.Node;
        /**
         * 添加指定类型组件。
         * @param	type 组件类型。
         * @return	组件。
         */
        addComponent(type: any): laya.d3.component.Component3D;
        /**
         * 通过指定类型和类型索引获得组件。
         * @param	type 组件类型。
         * @param	typeIndex 类型索引。
         * @return 组件。
         */
        getComponentByType(type: any, typeIndex?: number): laya.d3.component.Component3D;
        /**
         * 通过指定类型获得所有组件。
         * @param	type 组件类型。
         * @param	components 组件输出队列。
         */
        getComponentsByType(type: any, components: Array<any>): void;
        /**
         * 通过指定索引获得组件。
         * @param	index 索引。
         * @return 组件。
         */
        getComponentByIndex(index: number): laya.d3.component.Component3D;
        /**
         * 通过指定类型和类型索引移除组件。
         * @param	type 组件类型。
         * @param	typeIndex 类型索引。
         */
        removeComponentByType(type: any, typeIndex?: number): void;
        /**
         * 通过指定类型移除所有组件。
         * @param	type 组件类型。
         */
        removeComponentsByType(type: any): void;
        /**
         * 移除全部组件。
         */
        removeAllComponent(): void;
        /**
         *@private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        /**
         * @inheritDoc
         */
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>Transform3D</code> 类用于实现3D变换。
     */
    class Transform3D extends laya.events.EventDispatcher {
        private static _tempVector30;
        private static _tempVector31;
        private static _tempVector32;
        private static _tempVector33;
        private static _tempQuaternion0;
        private static _tempMatrix0;
        protected _localPosition: laya.d3.math.Vector3;
        protected _localRotation: laya.d3.math.Quaternion;
        protected _localScale: laya.d3.math.Vector3;
        protected _localMatrix: laya.d3.math.Matrix4x4;
        protected _position: laya.d3.math.Vector3;
        protected _rotation: laya.d3.math.Quaternion;
        protected _scale: laya.d3.math.Vector3;
        protected _worldMatrix: laya.d3.math.Matrix4x4;
        protected _owner: Sprite3D;
        protected _forward: laya.d3.math.Vector3;
        protected _up: laya.d3.math.Vector3;
        protected _right: laya.d3.math.Vector3;
        protected _preWorldTransformModifyID: number;
        protected _localUpdate: boolean;
        protected _worldUpdate: boolean;
        protected _positionUpdate: boolean;
        protected _rotationUpdate: boolean;
        protected _scaleUpdate: boolean;
        protected _parent: Transform3D;
        /** 变换中心点,注意:该中心点不受变换的影响。*/
        pivot: laya.d3.math.Vector3;
        /**
         * @private
         */
        _isFrontFaceInvert: boolean;
        /**
         * 获取世界矩阵是否需要更新。
         * @return	世界矩阵是否需要更新。
         */
        worldNeedUpdate: boolean;
        /**
         * 获取局部矩阵。
         * @return	局部矩阵。
         */
        /**
         * 设置局部矩阵。
         * @param value	局部矩阵。
         */
        localMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取世界矩阵。
         * @return	世界矩阵。
         */
        /**
         * 设置世界矩阵。
         * @param	value 世界矩阵。
         */
        worldMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取局部位置。
         * @return	局部位置。
         */
        /**
         * 设置局部位置。
         * @param value	局部位置。
         */
        localPosition: laya.d3.math.Vector3;
        /**
         * 获取局部旋转。
         * @return	局部旋转。
         */
        /**
         * 设置局部旋转。
         * @param value	局部旋转。
         */
        localRotation: laya.d3.math.Quaternion;
        /**
         * 获取局部缩放。
         * @return	局部缩放。
         */
        /**
         * 设置局部缩放。
         * @param	value 局部缩放。
         */
        localScale: laya.d3.math.Vector3;
        /**
         * 设置局部空间的旋转角度。
         * @param	value 欧拉角的旋转值，顺序为x、y、z。
         */
        localRotationEuler: laya.d3.math.Vector3;
        /**
         * 获取世界位置。
         * @return	世界位置。
         */
        /**
         * 设置世界位置。
         * @param	value 世界位置。
         */
        position: laya.d3.math.Vector3;
        /**
         * 获取世界旋转。
         * @return	世界旋转。
         */
        /**
         * 设置世界旋转。
         * @param value	世界旋转。
         */
        rotation: laya.d3.math.Quaternion;
        /**
         * 获取世界缩放。
         * @return	世界缩放。
         */
        scale: laya.d3.math.Vector3;
        /**
         * 设置局部空间的旋转角度。
         * @param	欧拉角的旋转值，顺序为x、y、z。
         */
        rotationEuler: laya.d3.math.Vector3;
        /**
         * 获取向前方向。
         * @return	向前方向。
         */
        forward: laya.d3.math.Vector3;
        /**
         * 获取向上方向。
         * @return	向上方向。
         */
        up: laya.d3.math.Vector3;
        /**
         * 获取向右方向。
         * @return	向右方向。
         */
        right: laya.d3.math.Vector3;
        /**
         * 设置父3D变换。
         * @param	value 父3D变换。
         */
        parent: Transform3D;
        /**
         * 创建一个 <code>Transform3D</code> 实例。
         * @param owner 所属精灵。
         */
        constructor(owner: Sprite3D);
        protected _updateLocalMatrix(): void;
        protected _onLocalTransform(): void;
        protected _onWorldPositionRotationTransform(): void;
        protected _onWorldPositionScaleTransform(): void;
        protected _onWorldPositionTransform(): void;
        protected _onWorldRotationTransform(): void;
        protected _onWorldScaleTransform(): void;
        /**
         * @private
         */
        _onWorldTransform(): void;
        /**
         * 平移变换。
         * @param 	translation 移动距离。
         * @param 	isLocal 是否局部空间。
         */
        translate(translation: laya.d3.math.Vector3, isLocal?: boolean): void;
        /**
         * 旋转变换。
         * @param 	rotations 旋转幅度。
         * @param 	isLocal 是否局部空间。
         * @param 	isRadian 是否弧度制。
         */
        rotate(rotation: laya.d3.math.Vector3, isLocal?: boolean, isRadian?: boolean): void;
        /**
         * 观察目标位置。
         * @param	target 观察目标。
         * @param	up 向上向量。
         * @param	isLocal 是否局部空间。
         */
        lookAt(target: laya.d3.math.Vector3, up: laya.d3.math.Vector3, isLocal?: boolean): void;
    }
}
declare module laya.d3.core {
    /**
     * <code>TransformUV</code> 类用于实现UV变换。
     */
    class TransformUV extends laya.events.EventDispatcher implements IClone {
        protected static _tempOffsetV3: laya.d3.math.Vector3;
        protected static _tempRotationQua: laya.d3.math.Quaternion;
        protected static _tempTitlingV3: laya.d3.math.Vector3;
        protected _matrix: laya.d3.math.Matrix4x4;
        protected _offset: laya.d3.math.Vector2;
        protected _rotation: number;
        protected _tiling: laya.d3.math.Vector2;
        protected _matNeedUpdte: boolean;
        /**
         *获取变换矩阵。
         * @return 变换矩阵。
         */
        matrix: laya.d3.math.Matrix4x4;
        /**
         *获取偏移。
         * @return 偏移。
         */
        /**
         *设置偏移。
         * @param value 偏移。
         */
        offset: laya.d3.math.Vector2;
        /**
         *获取旋转。
         * @return 旋转。
         */
        /**
         *设置旋转。
         * @param value 旋转。
         */
        rotation: number;
        /**
         *获取平铺次数。
         * @return 平铺次数。
         */
        /**
         *设置平铺次数。
         * @param value 平铺次数。
         */
        tiling: laya.d3.math.Vector2;
        /**
         * 创建一个 <code>TransformUV</code> 实例。
         */
        constructor();
        protected _updateMatrix(): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.core {
    /**
     * <code>Camera</code> 类用于创建VR摄像机。
     */
    class VRCamera extends BaseCamera {
        /**
         * 获取左横纵比。
         * @return 左横纵比。
         */
        leftAspectRatio: number;
        /**
         * 获取右横纵比。
         * @return 右横纵比。
         */
        rightAspectRatio: number;
        /**
         * 设置横纵比。
         * @param value 横纵比。
         */
        aspectRatio: number;
        /**
         * 获取屏幕空间的左视口。
         * @return 屏幕空间的左视口。
         */
        leftViewport: laya.d3.math.Viewport;
        /**
         * 获取屏幕空间的右视口。
         * @return 屏幕空间的右视口。
         */
        rightViewport: laya.d3.math.Viewport;
        /**
         * 设置屏幕空间的视口。
         * @param 屏幕空间的视口。
         */
        viewport: laya.d3.math.Viewport;
        /**
         * 获取裁剪空间的左视口。
         * @return 裁剪空间的左视口。
         */
        leftNormalizedViewport: laya.d3.math.Viewport;
        /**
         * 获取裁剪空间的右视口。
         * @return 裁剪空间的右视口。
         */
        rightNormalizedViewport: laya.d3.math.Viewport;
        /**
         * 设置裁剪空间的视口。
         * @return 裁剪空间的视口。
         */
        normalizedViewport: laya.d3.math.Viewport;
        needLeftViewport: boolean;
        needRightViewport: boolean;
        /**
         * 获取左视图矩阵。
         * @return 左视图矩阵。
         */
        leftViewMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取右视图矩阵。
         * @return 右视图矩阵。
         */
        rightViewMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取左投影矩阵。
         * @return 左投影矩阵。
         */
        leftProjectionMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取右投影矩阵。
         * @return 右投影矩阵。
         */
        rightProjectionMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取左投影视图矩阵。
         * @return 左投影视图矩阵。
         */
        leftProjectionViewMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取右投影视图矩阵。
         * @return 右投影视图矩阵。
         */
        rightProjectionViewMatrix: laya.d3.math.Matrix4x4;
        /**
         * 获取摄像机左视锥。
         */
        leftBoundFrustum: laya.d3.math.BoundFrustum;
        /**
         * 获取摄像机右视锥。
         */
        rightBoundFrustum: laya.d3.math.BoundFrustum;
        /**
         * 创建一个 <code>VRCamera</code> 实例。
         * @param	leftViewport 左视口。
         * @param	rightViewport 右视口。
         * @param	pupilDistande 瞳距。
         * @param	fieldOfView 视野。
         * @param	leftAspectRatio 左横纵比。
         * @param	rightAspectRatio 右横纵比。
         * @param	nearPlane 近裁面。
         * @param	farPlane 远裁面。
         */
        constructor(pupilDistande?: number, leftAspectRatio?: number, rightAspectRatio?: number, nearPlane?: number, farPlane?: number);
        protected _calculateProjectionMatrix(): void;
    }
}
declare module laya.d3.graphics {
    /**
     * @private
     * <code>DynamicBatch</code> 类用于动态批处理。
     */
    class DynamicBatch implements laya.d3.core.render.IRenderable {
        static maxVertexCount: number;
        static maxIndexCount: number;
        static maxCombineTriangleCount: number;
        _vertexDeclaration: VertexDeclaration;
        indexOfHost: number;
        _vertexBufferCount: number;
        triangleCount: number;
        combineRenderElementsCount: number;
        _getVertexBuffer(index?: number): VertexBuffer3D;
        _getIndexBuffer(): IndexBuffer3D;
        constructor(vertexDeclaration: VertexDeclaration);
        _addCombineRenderObjTest(renderElement: laya.d3.core.render.RenderElement): boolean;
        _addCombineRenderObj(renderElement: laya.d3.core.render.RenderElement): void;
        _addCombineMaterial(material: laya.d3.core.material.BaseMaterial): void;
        _addMaterialToRenderElementOffset(offset: number): void;
        _clearRenderElements(): void;
        _addToRenderQueue(scene: laya.d3.core.scene.BaseScene, view: laya.d3.math.Matrix4x4, projection: laya.d3.math.Matrix4x4, projectionView: laya.d3.math.Matrix4x4): void;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        _render(state: laya.d3.core.render.RenderState): void;
        /**NATIVE*/
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.graphics {
    /**
     * @private
     * <code>DynamicBatchManager</code> 类用于管理动态批处理。
     */
    class DynamicBatchManager {
        constructor();
        getDynamicBatch(_vertexDeclaration: VertexDeclaration, number: number): DynamicBatch;
        /**需手动调用*/
        _garbageCollection(): void;
        _addPrepareRenderElement(renderElement: laya.d3.core.render.RenderElement): void;
        _finishCombineDynamicBatch(scene: laya.d3.core.scene.BaseScene): void;
        _clearRenderElements(): void;
        _addToRenderQueue(scene: laya.d3.core.scene.BaseScene, view: laya.d3.math.Matrix4x4, projection: laya.d3.math.Matrix4x4, projectionView: laya.d3.math.Matrix4x4): void;
        dispose(): void;
    }
}
declare module laya.d3.graphics {
    /**
     * ...
     * @author ...
     */
    class FrustumCulling {
        constructor();
        /**
         * @private
         */
        static renderShadowObjectCulling(scene: laya.d3.core.scene.BaseScene, lightFrustum: Array<any>, shadowQueues: Array<any>, lightViewProjectMatrix: laya.d3.math.Matrix4x4, nPSSMNum: number): void;
        /**
         * @private
         */
        static renderShadowObjectCullingOctree(scene: laya.d3.core.scene.BaseScene, lightFrustum: Array<any>, quenesResult: Array<any>, lightViewProjectMatrix: laya.d3.math.Matrix4x4, nPSSMNum: number): void;
        static renderObjectCulling(boundFrustum: laya.d3.math.BoundFrustum, scene: laya.d3.core.scene.BaseScene, camera: laya.d3.core.BaseCamera, view: laya.d3.math.Matrix4x4, projection: laya.d3.math.Matrix4x4, projectionView: laya.d3.math.Matrix4x4): void;
        static renderObjectCullingOctree(boundFrustum: laya.d3.math.BoundFrustum, scene: laya.d3.core.scene.BaseScene, camera: laya.d3.core.BaseCamera, view: laya.d3.math.Matrix4x4, projection: laya.d3.math.Matrix4x4, projectionView: laya.d3.math.Matrix4x4): void;
        static renderObjectCullingNoBoundFrustum(scene: laya.d3.core.scene.BaseScene, camera: laya.d3.core.BaseCamera, view: laya.d3.math.Matrix4x4, projection: laya.d3.math.Matrix4x4, projectionView: laya.d3.math.Matrix4x4): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>IndexBuffer3D</code> 类用于创建索引缓冲。
     */
    class IndexBuffer3D extends laya.webgl.utils.Buffer {
        /** 8位ubyte无符号索引类型。*/
        static INDEXTYPE_UBYTE: string;
        /** 16位ushort无符号索引类型。*/
        static INDEXTYPE_USHORT: string;
        /**
         * 创建IndexBuffer3D。
         * @param	indexType 索引类型。
         * @param	indexCount 索引个数。
         * @param	bufferUsage IndexBuffer3D用途类型。
         * @param	canRead 是否可读。
         * @return	    索引缓冲。
         */
        static create: Function;
        /**
         * 获取索引类型。
         *   @return	索引类型。
         */
        indexType: string;
        /**
         * 获取索引类型字节数量。
         *   @return	索引类型字节数量。
         */
        indexTypeByteCount: number;
        /**
         * 获取索引个数。
         *   @return	索引个数。
         */
        indexCount: number;
        /**
         * 获取是否可读。
         *   @return	是否可读。
         */
        canRead: boolean;
        /**
         * 创建一个 <code>IndexBuffer3D,不建议开发者使用并用IndexBuffer3D.create()代替</code> 实例。
         * @param	indexType 索引类型。
         * @param	indexCount 索引个数。
         * @param	bufferUsage IndexBuffer3D用途类型。
         * @param	canRead 是否可读。
         */
        constructor(indexType: string, indexCount: number, bufferUsage?: number, canRead?: boolean);
        /**
         * 设置数据。
         * @param	data 索引数据。
         * @param	bufferOffset 索引缓冲中的偏移。
         * @param	dataStartIndex 索引数据的偏移。
         * @param	dataCount 索引数据的数量。
         */
        setData(data: any, bufferOffset?: number, dataStartIndex?: number, dataCount?: number): void;
        /**
         * 获取索引数据。
         *   @return	索引数据。
         */
        getData(): Uint16Array;
        /** 彻底销毁索引缓冲。*/
        dispose(): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>IVertex</code> 接口用于实现创建顶点声明。
     */
    interface IVertex {
    }
}
declare module laya.d3.graphics {
    /**
     * @private
     * <code>StaticBatch</code> 类用于静态批处理。
     */
    class StaticBatch implements laya.d3.core.render.IRenderable {
        static maxVertexCount: number;
        /**
         * 合并节点为静态批处理。
         * @param staticBatchRoot 静态批处理根节点。
         */
        static combine(staticBatchRoot: laya.d3.core.Sprite3D): void;
        _rootSprite: laya.d3.core.Sprite3D;
        _vertexDeclaration: VertexDeclaration;
        _material: laya.d3.core.material.BaseMaterial;
        _shaderValues: laya.d3.shader.ValusArray;
        _owner: laya.d3.core.Sprite3D;
        _vertexBufferCount: number;
        indexOfHost: number;
        triangleCount: number;
        constructor(rootSprite: laya.d3.core.Sprite3D, vertexDeclaration: VertexDeclaration, material: laya.d3.core.material.BaseMaterial);
        _getVertexBuffer(index?: number): VertexBuffer3D;
        _getIndexBuffer(): IndexBuffer3D;
        _addCombineRenderObjTest(renderElement: laya.d3.core.render.RenderElement): boolean;
        _addCombineRenderObj(renderElement: laya.d3.core.render.RenderElement): void;
        _deleteCombineRenderObj(renderElement: laya.d3.core.render.RenderElement): void;
        _finshCombine(): void;
        _clearRenderElements(): void;
        _addRenderElement(renderElement: laya.d3.core.render.RenderElement): void;
        _getRenderElement(mergeElements: Array<any>): void;
        _addToRenderQueue(scene: laya.d3.core.scene.BaseScene): void;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        _render(state: laya.d3.core.render.RenderState): void;
        /**NATIVE*/
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.graphics {
    /**
     * @private
     * <code>StaticBatchManager</code> 类用于管理静态批处理。
     */
    class StaticBatchManager {
        constructor();
        getStaticBatch(rootSprite: laya.d3.core.Sprite3D, _vertexDeclaration: VertexDeclaration, material: laya.d3.core.material.BaseMaterial, number: number): StaticBatch;
        _garbageCollection(): void;
        _addPrepareRenderElement(renderElement: laya.d3.core.render.RenderElement): void;
        _finishCombineStaticBatch(rootSprite: laya.d3.core.Sprite3D): void;
        _clearRenderElements(): void;
        _addToRenderQueue(scene: laya.d3.core.scene.BaseScene, view: laya.d3.math.Matrix4x4, projection: laya.d3.math.Matrix4x4, projectionView: laya.d3.math.Matrix4x4): void;
        dispose(): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexBuffer3D</code> 类用于创建顶点缓冲。
     */
    class VertexBuffer3D extends laya.webgl.utils.Buffer {
        /**
         * 创建VertexBuffer3D。
         * @param	vertexDeclaration 顶点声明。
         * @param	vertexCount 顶点个数。
         * @param	bufferUsage VertexBuffer3D用途类型。
         * @param	canRead 是否可读。
         * @return	    顶点缓冲。
         */
        static create: Function;
        /**
         * 获取顶点结构声明。
         *   @return	顶点结构声明。
         */
        vertexDeclaration: VertexDeclaration;
        /**
         * 获取顶点个数。
         *   @return	顶点个数。
         */
        vertexCount: number;
        /**
         * 获取是否可读。
         *   @return	是否可读。
         */
        canRead: boolean;
        /**
         * 创建一个 <code>VertexBuffer3D,不建议开发者使用并用VertexBuffer3D.create()代替</code> 实例。
         * @param	vertexDeclaration 顶点声明。
         * @param	vertexCount 顶点个数。
         * @param	bufferUsage VertexBuffer3D用途类型。
         * @param	canRead 是否可读。
         */
        constructor(vertexDeclaration: VertexDeclaration, vertexCount: number, bufferUsage: number, canRead?: boolean);
        /**
         * 和索引缓冲一起绑定。
         * @param	ib 索引缓冲。
         */
        bindWithIndexBuffer(ib: IndexBuffer3D): void;
        /**
         * 设置数据。
         * @param	data 顶点数据。
         * @param	bufferOffset 顶点缓冲中的偏移。
         * @param	dataStartIndex 顶点数据的偏移。
         * @param	dataCount 顶点数据的数量。
         */
        setData(data: Float32Array, bufferOffset?: number, dataStartIndex?: number, dataCount?: number): void;
        /**
         * 获取顶点数据。
         *   @return	顶点数据。
         */
        getData(): Float32Array;
        protected detoryResource(): void;
        /** 彻底销毁顶点缓冲。*/
        dispose(): void;
    }
}
declare module laya.d3.graphics {
    /**
     * ...
     * @author ...
     */
    class VertexDeclaration {
        static _maxVertexDeclarationBit: number;
        static maxVertexDeclaration: number;
        private static _uniqueIDCounter;
        static getVertexStride(vertexElements: Array<any>): number;
        _conchVertexDeclaration: any;
        /**
         * 获取唯一标识ID(通常用于优化或识别)。
         * @return 唯一标识ID
         */
        id: number;
        vertexStride: number;
        shaderValues: laya.d3.shader.ValusArray;
        shaderDefineValue: number;
        /**
         * 增加Shader宏定义。
         * @param value 宏定义。
         */
        _addShaderDefine(value: number): void;
        protected _removeShaderDefine(value: number): void;
        constructor(vertexStride: number, vertexElements: Array<any>);
        getVertexElements(): Array<any>;
        getVertexElementByUsage(usage: number): VertexElement;
        unBinding(): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexElement</code> 类用于创建顶点结构分配。
     */
    class VertexElement {
        offset: number;
        elementFormat: string;
        elementUsage: number;
        VertexElement(offset: number, elementFormat: string, elementUsage: number): any;
    }
}
declare module laya.d3.graphics {
    /**
     * ...
     * @author ...
     */
    class VertexElementFormat {
        static Single: string;
        static Vector2: string;
        static Vector3: string;
        static Vector4: string;
        static Color: string;
        static Byte4: string;
        static Short2: string;
        static Short4: string;
        static NormalizedShort2: string;
        static NormalizedShort4: string;
        static HalfVector2: string;
        static HalfVector4: string;
    }
}
declare module laya.d3.graphics {
    /**
     * ...
     * @author ...
     */
    class VertexElementUsage {
        static POSITION0: number;
        static COLOR0: number;
        static TEXTURECOORDINATE0: number;
        static NORMAL0: number;
        static BINORMAL0: number;
        static TANGENT0: number;
        static BLENDINDICES0: number;
        static BLENDWEIGHT0: number;
        static DEPTH0: number;
        static FOG0: number;
        static POINTSIZE0: number;
        static SAMPLE0: number;
        static TESSELLATEFACTOR0: number;
        static COLOR1: number;
        static NEXTTEXTURECOORDINATE0: number;
        static TEXTURECOORDINATE1: number;
        static NEXTTEXTURECOORDINATE1: number;
        static CORNERTEXTURECOORDINATE0: number;
        static VELOCITY0: number;
        static STARTCOLOR0: number;
        static STARTSIZE: number;
        static AGEADDSCALE0: number;
        static STARTROTATION0: number;
        static STARTROTATION1: number;
        static STARTROTATION2: number;
        static ENDCOLOR0: number;
        static STARTLIFETIME: number;
        static TIME0: number;
        static POSITIONSTARTLIFETIME: number;
        static DIRECTIONTIME: number;
        static SIZEROTATION0: number;
        static RADIUS0: number;
        static RADIAN0: number;
        static STARTSPEED: number;
        static RANDOM0: number;
        static RANDOM1: number;
        static SIMULATIONWORLDPOSTION: number;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
     */
    class VertexGlitter implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        time: number;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2, time: number);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
     */
    class VertexParticle implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        cornerTextureCoordinate: laya.d3.math.Vector4;
        position: laya.d3.math.Vector3;
        velocity: laya.d3.math.Vector3;
        startColor: laya.d3.math.Vector4;
        endColor: laya.d3.math.Vector4;
        sizeRotation: laya.d3.math.Vector3;
        radius: laya.d3.math.Vector2;
        radian: laya.d3.math.Vector4;
        ageAddScale: number;
        time: number;
        vertexDeclaration: VertexDeclaration;
        constructor(cornerTextureCoordinate: laya.d3.math.Vector4, position: laya.d3.math.Vector3, velocity: laya.d3.math.Vector3, startColor: laya.d3.math.Vector4, endColor: laya.d3.math.Vector4, sizeRotation: laya.d3.math.Vector3, radius: laya.d3.math.Vector2, radian: laya.d3.math.Vector4, ageAddScale: number, time: number);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
     */
    class VertexParticleShuriken implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        cornerTextureCoordinate: laya.d3.math.Vector4;
        position: laya.d3.math.Vector3;
        velocity: laya.d3.math.Vector3;
        startColor: laya.d3.math.Vector4;
        startSize: laya.d3.math.Vector3;
        startRotation0: laya.d3.math.Vector3;
        startRotation1: laya.d3.math.Vector3;
        startRotation2: laya.d3.math.Vector3;
        startLifeTime: number;
        time: number;
        startSpeed: number;
        random0: laya.d3.math.Vector4;
        random1: laya.d3.math.Vector4;
        simulationWorldPostion: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        constructor(cornerTextureCoordinate: laya.d3.math.Vector4, position: laya.d3.math.Vector3, velocity: laya.d3.math.Vector3, startColor: laya.d3.math.Vector4, startSize: laya.d3.math.Vector3, startRotation0: laya.d3.math.Vector3, startRotation1: laya.d3.math.Vector3, startRotation2: laya.d3.math.Vector3, ageAddScale: number, time: number, startSpeed: number, randoms0: laya.d3.math.Vector4, randoms1: laya.d3.math.Vector4, simulationWorldPostion: laya.d3.math.Vector3);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColor</code> 类用于创建位置、法线、颜色顶点结构。
     */
    class VertexPositionNormalColor implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorSkin</code> 类用于创建位置、法线、颜色、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalColorSkin implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorSkin</code> 类用于创建位置、法线、颜色、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalColorSkinTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        tangent: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, tangent: laya.d3.math.Vector4, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTangent</code> 类用于创建位置、法线、颜色、切线顶点结构。
     */
    class VertexPositionNormalColorTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        tangent: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, tangent: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
     */
    class VertexPositionNormalColorTexture implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate: laya.d3.math.Vector2);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
     */
    class VertexPositionNormalColorTexture0Texture1 implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalColorTexture0Texture1Skin implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalColorTexture0Texture1SkinTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        VertexPositionNormalColorTexture0SkinTangent(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTextureTangent</code> 类用于创建位置、法线、颜色、纹理、切线顶点结构。
     */
    class VertexPositionNormalColorTexture0Texture1Tangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        VertexPositionNormalColorTexture0Tangent(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalColorTextureSkin implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate: laya.d3.math.Vector2, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalColorTextureSkinTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTextureTangent</code> 类用于创建位置、法线、颜色、纹理、切线顶点结构。
     */
    class VertexPositionNormalColorTextureTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        color: laya.d3.math.Vector4;
        textureCoordinate: laya.d3.math.Vector2;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, color: laya.d3.math.Vector4, textureCoordinate: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
     */
    class VertexPositionNormalTexture implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
     */
    class VertexPositionNormalTexture0Texture1 implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalTexture0Texture1Skin implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalTexture0Texture1SkinTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        VertexPositionNormalTexture0SkinTangent(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTextureTangent</code> 类用于创建位置、法线、纹理、切线顶点结构。
     */
    class VertexPositionNormalTexture0Texture1Tangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate0: laya.d3.math.Vector2;
        textureCoordinate1: laya.d3.math.Vector2;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        VertexPositionNormalTexture0Tangent(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate0: laya.d3.math.Vector2, textureCoordinate1: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3): void;
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalTextureSkin implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
     */
    class VertexPositionNormalTextureSkinTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        blendIndex: laya.d3.math.Vector4;
        blendWeight: laya.d3.math.Vector4;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3, blendIndex: laya.d3.math.Vector4, blendWeight: laya.d3.math.Vector4);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTextureTangent</code> 类用于创建位置、法线、纹理、切线顶点结构。
     */
    class VertexPositionNormalTextureTangent implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        tangent: laya.d3.math.Vector3;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2, tangent: laya.d3.math.Vector3);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
     */
    class VertexPositionNTBTexture implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
     */
    class VertexPositionNTBTextureSkin implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoordinate: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoordinate: laya.d3.math.Vector2);
    }
}
declare module laya.d3.graphics {
    /**
     * <code>VertexPositionTerrain</code> 类用于创建位置、法线、纹理1、纹理2顶点结构。
     */
    class VertexPositionTerrain implements IVertex {
        static vertexDeclaration: VertexDeclaration;
        position: laya.d3.math.Vector3;
        normal: laya.d3.math.Vector3;
        textureCoord0: laya.d3.math.Vector2;
        textureCoord1: laya.d3.math.Vector2;
        vertexDeclaration: VertexDeclaration;
        constructor(position: laya.d3.math.Vector3, normal: laya.d3.math.Vector3, textureCoord0: laya.d3.math.Vector2, textureCoord1: laya.d3.math.Vector2);
    }
}
declare module laya.d3.loaders {
    /**
     * @private
     * <code>LoadModel</code> 类用于模型加载。
     */
    class LoadModelV01 {
        private static _attrReg;
        mesh: laya.d3.resource.models.Mesh;
        /**
         * 创建一个 <code>LoadModel</code> 实例。
         */
        constructor(readData: laya.utils.Byte, version: string, mesh: laya.d3.resource.models.Mesh, materials: Array<any>, materialMap: any);
        onError(): void;
        READ_BLOCK(): boolean;
        READ_DATA(): boolean;
        READ_STRINGS(): boolean;
        READ_MATERIAL(): boolean;
        READ_MESH(): boolean;
        READ_SUBMESH(): boolean;
        READ_DATAAREA(): boolean;
    }
}
declare module laya.d3.loaders {
    /**
     * @private
     * <code>LoadModel</code> 类用于模型加载。
     */
    class LoadModelV02 {
        private static _attrReg;
        private static _BLOCK;
        private static _DATA;
        private static _strings;
        private static _readData;
        private static _version;
        private static _mesh;
        private static _materials;
        private static _materialMap;
        /**
         * @private
         */
        static parse(readData: laya.utils.Byte, version: string, mesh: laya.d3.resource.models.Mesh, materials: Array<any>, materialMap: any): void;
    }
}
declare module laya.d3.loaders {
    /**
     * ...
     * @author ...
     */
    class MeshReader {
        constructor();
        static read(data: ArrayBuffer, mesh: laya.d3.resource.models.Mesh, materials: Array<any>, materialMap: any): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>BoundBox</code> 类用于创建包围盒。
     */
    class BoundBox implements laya.d3.core.IClone {
        /**最小顶点。*/
        min: Vector3;
        /**最大顶点。*/
        max: Vector3;
        /**
         * 创建一个 <code>BoundBox</code> 实例。
         * @param	min 包围盒的最小顶点。
         * @param	max 包围盒的最大顶点。
         */
        constructor(min: Vector3, max: Vector3);
        /**
         * 获取包围盒的8个角顶点。
         * @param	corners 返回顶点的输出队列。
         */
        getCorners(corners: Array<any>): void;
        toDefault(): void;
        /**
         * 从顶点生成包围盒。
         * @param	points 所需顶点队列。
         * @param	out 生成的包围盒。
         */
        static createfromPoints(points: Array<any>, out: BoundBox): void;
        /**
         * 合并两个包围盒。
         * @param	box1 包围盒1。
         * @param	box2 包围盒2。
         * @param	out 生成的包围盒。
         */
        static merge(box1: BoundBox, box2: BoundBox, out: BoundBox): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.math {
    /**
     * <code>BoundFrustum</code> 类用于创建锥截体。
     */
    class BoundFrustum {
        private static _tempV30;
        private static _tempV31;
        private static _tempV32;
        private static _tempV33;
        private static _tempV34;
        private static _tempV35;
        private static _tempV36;
        private static _tempV37;
        /**
         * 创建一个 <code>BoundFrustum</code> 实例。
         * @param	matrix 锥截体的描述4x4矩阵。
         */
        constructor(matrix: Matrix4x4);
        /**
         * 获取描述矩阵。
         * @return  描述矩阵。
         */
        /**
         * 设置描述矩阵。
         * @param matrix 描述矩阵。
         */
        matrix: Matrix4x4;
        /**
         * 获取近平面。
         * @return  近平面。
         */
        near: Plane;
        /**
         * 获取远平面。
         * @return  远平面。
         */
        far: Plane;
        /**
         * 获取左平面。
         * @return  左平面。
         */
        left: Plane;
        /**
         * 获取右平面。
         * @return  右平面。
         */
        right: Plane;
        /**
         * 获取顶平面。
         * @return  顶平面。
         */
        top: Plane;
        /**
         * 获取底平面。
         * @return  底平面。
         */
        bottom: Plane;
        /**
         * 判断是否与其他锥截体相等。
         * @param	other 锥截体。
         */
        equalsBoundFrustum(other: BoundFrustum): boolean;
        /**
         * 判断是否与其他对象相等。
         * @param	obj 对象。
         */
        equalsObj(obj: any): boolean;
        /**
         * 获取锥截体的任意一平面。
         * 0:近平面
         * 1:远平面
         * 2:左平面
         * 3:右平面
         * 4:顶平面
         * 5:底平面
         * @param	index 索引。
         */
        getPlane(index: number): Plane;
        /**
         * 锥截体的8个顶点。
         * @param  corners  返回顶点的输出队列。
         */
        getCorners(corners: Array<any>): void;
        /**
         * 与点的位置关系。返回-1,包涵;0,相交;1,不相交
         * @param  point  点。
         */
        containsPoint(point: Vector3): number;
        /**
         * 与包围盒的位置关系。返回-1,包涵;0,相交;1,不相交
         * @param  box  包围盒。
         */
        containsBoundBox(box: BoundBox): number;
        /**
         * 与包围球的位置关系。返回-1,包涵;0,相交;1,不相交
         * @param  sphere  包围球。
         */
        containsBoundSphere(sphere: BoundSphere): number;
    }
}
declare module laya.d3.math {
    /**
     * <code>BoundSphere</code> 类用于创建包围球。
     */
    class BoundSphere implements laya.d3.core.IClone {
        private static _tempVector3;
        /**包围球的中心。*/
        center: Vector3;
        /**包围球的半径。*/
        radius: number;
        /**
         * 创建一个 <code>BoundSphere</code> 实例。
         * @param	center 包围球的中心。
         * @param	radius 包围球的半径。
         */
        constructor(center: Vector3, radius: number);
        toDefault(): void;
        /**
         * 从顶点的子队列生成包围球。
         * @param	points 顶点的队列。
         * @param	start 顶点子队列的起始偏移。
         * @param	count 顶点子队列的顶点数。
         * @param	result 生成的包围球。
         */
        static createFromSubPoints(points: Array<any>, start: number, count: number, out: BoundSphere): void;
        /**
         * 从顶点队列生成包围球。
         * @param	points 顶点的队列。
         * @param	result 生成的包围球。
         */
        static createfromPoints(points: Array<any>, out: BoundSphere): void;
        /**
         * 判断射线是否与碰撞球交叉，并返回交叉距离。
         * @param	ray 射线。
         * @return 距离交叉点的距离，-1表示不交叉。
         */
        intersectsRayDistance(ray: Ray): number;
        /**
         * 判断射线是否与碰撞球交叉，并返回交叉点。
         * @param	ray  射线。
         * @param	point 交叉点。
         * @return  距离交叉点的距离，-1表示不交叉。
         */
        intersectsRayPoint(ray: Ray, point: Vector3): number;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.math {
    /**
     * <code>Collision</code> 类用于检测碰撞。
     */
    class Collision {
        private static _tempV30;
        private static _tempV31;
        private static _tempV32;
        private static _tempV33;
        private static _tempV34;
        private static _tempV35;
        private static _tempV36;
        /**
         * 创建一个 <code>Collision</code> 实例。
         */
        constructor();
        /**
         * 空间中点到平面的距离
         * @param	plane 平面
         * @param	point 点
         */
        static distancePlaneToPoint(plane: Plane, point: Vector3): number;
        /**
         * 空间中点到包围盒的距离
         * @param	box 包围盒
         * @param	point 点
         */
        static distanceBoxToPoint(box: BoundBox, point: Vector3): number;
        /**
         * 空间中包围盒到包围盒的距离
         * @param	box1 包围盒1
         * @param	box2 包围盒2
         */
        static distanceBoxToBox(box1: BoundBox, box2: BoundBox): number;
        /**
         * 空间中点到包围球的距离
         * @param	sphere 包围球
         * @param	point  点
         */
        static distanceSphereToPoint(sphere: BoundSphere, point: Vector3): number;
        /**
         * 空间中包围球到包围球的距离
         * @param	sphere1 包围球1
         * @param	sphere2 包围球2
         */
        static distanceSphereToSphere(sphere1: BoundSphere, sphere2: BoundSphere): number;
        /**
         * 空间中射线和三角面是否相交,输出距离
         * @param	ray 射线
         * @param	vertex1 三角面顶点1
         * @param	vertex2	三角面顶点2
         * @param	vertex3 三角面顶点3
         * @param	out 点和三角面的距离
         * @return  是否相交
         */
        static intersectsRayAndTriangleRD(ray: Ray, vertex1: Vector3, vertex2: Vector3, vertex3: Vector3, out: number): boolean;
        /**
         * 空间中射线和三角面是否相交,输出相交点
         * @param	ray 射线
         * @param	vertex1 三角面顶点1
         * @param	vertex2	三角面顶点2
         * @param	vertex3 三角面顶点3
         * @param	out 相交点
         * @return  是否相交
         */
        static intersectsRayAndTriangleRP(ray: Ray, vertex1: Vector3, vertex2: Vector3, vertex3: Vector3, out: Vector3): boolean;
        /**
         * 空间中射线和点是否相交
         * @param	sphere1 包围球1
         * @param	sphere2 包围球2
         */
        static intersectsRayAndPoint(ray: Ray, point: Vector3): boolean;
        /**
         * 空间中射线和射线是否相交
         * @param	ray1 射线1
         * @param	ray2 射线2
         * @param	out 相交点
         */
        static intersectsRayAndRay(ray1: Ray, ray2: Ray, out: Vector3): boolean;
        /**
         * 空间中平面和三角面是否相交
         * @param	plane 平面
         * @param	vertex1 三角面顶点1
         * @param	vertex2 三角面顶点2
         * @param	vertex3 三角面顶点3
         * @return  返回空间位置关系
         */
        static intersectsPlaneAndTriangle(plane: Plane, vertex1: Vector3, vertex2: Vector3, vertex3: Vector3): number;
        /**
         * 空间中射线和平面是否相交
         * @param	ray   射线
         * @param	plane 平面
         * @param	out 相交距离,如果为0,不相交
         */
        static intersectsRayAndPlaneRD(ray: Ray, plane: Plane, out: number): boolean;
        /**
         * 空间中射线和平面是否相交
         * @param	ray   射线
         * @param	plane 平面
         * @param	out 相交点
         */
        static intersectsRayAndPlaneRP(ray: Ray, plane: Plane, out: Vector3): boolean;
        /**
         * 空间中射线和包围盒是否相交
         * @param	ray 射线
         * @param	box	包围盒
         * @param	out 相交距离,如果为0,不相交
         */
        static intersectsRayAndBoxRD(ray: Ray, box: BoundBox): number;
        /**
         * 空间中射线和包围盒是否相交
         * @param	ray 射线
         * @param	box	包围盒
         * @param	out 相交点
         */
        static intersectsRayAndBoxRP(ray: Ray, box: BoundBox, out: Vector3): number;
        /**
         * 空间中射线和包围球是否相交
         * @param	ray    射线
         * @param	sphere 包围球
         * @return	相交距离,-1表示不相交
         */
        static intersectsRayAndSphereRD(ray: Ray, sphere: BoundSphere): number;
        /**
         * 空间中射线和包围球是否相交
         * @param	ray    射线
         * @param	sphere 包围球
         * @param	out    相交点
         * @return  相交距离,-1表示不相交
         */
        static intersectsRayAndSphereRP(ray: Ray, sphere: BoundSphere, out: Vector3): number;
        /**
         * 空间中包围球和三角面是否相交
         * @param	sphere 包围球
         * @param	vertex1 三角面顶点1
         * @param	vertex2 三角面顶点2
         * @param	vertex3 三角面顶点3
         * @return  返回是否相交
         */
        static intersectsSphereAndTriangle(sphere: BoundSphere, vertex1: Vector3, vertex2: Vector3, vertex3: Vector3): boolean;
        /**
         * 空间中点和平面是否相交
         * @param	plane  平面
         * @param	point  点
         * @return  碰撞状态
         */
        static intersectsPlaneAndPoint(plane: Plane, point: Vector3): number;
        /**
         * 空间中平面和平面是否相交
         * @param	plane1 平面1
         * @param	plane2 平面2
         * @return  是否相交
         */
        static intersectsPlaneAndPlane(plane1: Plane, plane2: Plane): boolean;
        /**
         * 空间中平面和平面是否相交
         * @param	plane1 平面1
         * @param	plane2 平面2
         * @param	line   相交线
         * @return  是否相交
         */
        static intersectsPlaneAndPlaneRL(plane1: Plane, plane2: Plane, line: Ray): boolean;
        /**
         * 空间中平面和包围盒是否相交
         * @param	plane 平面
         * @param   box  包围盒
         * @return  碰撞状态
         */
        static intersectsPlaneAndBox(plane: Plane, box: BoundBox): number;
        /**
         * 空间中平面和包围球是否相交
         * @param	plane 平面
         * @param   sphere 包围球
         * @return  碰撞状态
         */
        static intersectsPlaneAndSphere(plane: Plane, sphere: BoundSphere): number;
        /**
         * 空间中包围盒和包围盒是否相交
         * @param	box1 包围盒1
         * @param   box2 包围盒2
         * @return  是否相交
         */
        static intersectsBoxAndBox(box1: BoundBox, box2: BoundBox): boolean;
        /**
         * 空间中包围盒和包围球是否相交
         * @param	box 包围盒
         * @param   sphere 包围球
         * @return  是否相交
         */
        static intersectsBoxAndSphere(box: BoundBox, sphere: BoundSphere): boolean;
        /**
         * 空间中包围球和包围球是否相交
         * @param	sphere1 包围球1
         * @param   sphere2 包围球2
         * @return  是否相交
         */
        static intersectsSphereAndSphere(sphere1: BoundSphere, sphere2: BoundSphere): boolean;
        /**
         * 空间中包围盒是否包含另一个点
         * @param	box 包围盒
         * @param   point 点
         * @return  位置关系:0 不想交,1 包含, 2 相交
         */
        static boxContainsPoint(box: BoundBox, point: Vector3): number;
        /**
         * 空间中包围盒是否包含另一个包围盒
         * @param	box1 包围盒1
         * @param   box2 包围盒2
         * @return  位置关系:0 不想交,1 包含, 2 相交
         */
        static boxContainsBox(box1: BoundBox, box2: BoundBox): number;
        /**
         * 空间中包围盒是否包含另一个包围球
         * @param	box 包围盒
         * @param   sphere 包围球
         * @return  位置关系:0 不想交,1 包含, 2 相交
         */
        static boxContainsSphere(box: BoundBox, sphere: BoundSphere): number;
        /**
         * 空间中包围球是否包含另一个点
         * @param	sphere 包围球
         * @param   point 点
         * @return  位置关系:0 不想交,1 包含, 2 相交
         */
        static sphereContainsPoint(sphere: BoundSphere, point: Vector3): number;
        /**
         * 空间中包围球是否包含另一个三角面
         * @param	sphere
         * @param	vertex1 三角面顶点1
         * @param	vertex2 三角面顶点2
         * @param	vertex3 三角面顶点3
         * @return  返回空间位置关系
         */
        static sphereContainsTriangle(sphere: BoundSphere, vertex1: Vector3, vertex2: Vector3, vertex3: Vector3): number;
        /**
         * 空间中包围球是否包含另一包围盒
         * @param	sphere 包围球
         * @param   box 包围盒
         * @return  位置关系:0 不想交,1 包含, 2 相交
         */
        static sphereContainsBox(sphere: BoundSphere, box: BoundBox): number;
        /**
         * 空间中包围球是否包含另一包围球
         * @param	sphere1 包围球
         * @param   sphere2 包围球
         * @return  位置关系:0 不想交,1 包含, 2 相交
         */
        static sphereContainsSphere(sphere1: BoundSphere, sphere2: BoundSphere): number;
        /**
         * 空间中点与三角面的最近点
         * @param	point 点
         * @param	vertex1 三角面顶点1
         * @param	vertex2	三角面顶点2
         * @param	vertex3 三角面顶点3
         * @param	out 最近点
         */
        static closestPointPointTriangle(point: Vector3, vertex1: Vector3, vertex2: Vector3, vertex3: Vector3, out: Vector3): void;
        /**
         * 空间中平面与一点的最近点
         * @param	plane 平面
         * @param	point 点
         * @param	out 最近点
         */
        static closestPointPlanePoint(plane: Plane, point: Vector3, out: Vector3): void;
        /**
         * 空间中包围盒与一点的最近点
         * @param	box 包围盒
         * @param	point 点
         * @param	out 最近点
         */
        static closestPointBoxPoint(box: BoundBox, point: Vector3, out: Vector3): void;
        /**
         * 空间中包围球与一点的最近点
         * @param	sphere 包围球
         * @param	point 点
         * @param	out 最近点
         */
        static closestPointSpherePoint(sphere: BoundSphere, point: Vector3, out: Vector3): void;
        /**
         * 空间中包围球与包围球的最近点
         * @param	sphere1 包围球1
         * @param	sphere2 包围球2
         * @param	out 最近点
         */
        static closestPointSphereSphere(sphere1: BoundSphere, sphere2: BoundSphere, out: Vector3): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>ContainmentType</code> 类用于定义空间物体位置关系。
     */
    class ContainmentType {
        static Disjoint: number;
        static Contains: number;
        static Intersects: number;
    }
}
declare module laya.d3.math {
    /**
     * <code>MathUtils</code> 类用于创建数学工具。
     */
    class MathUtils3D {
        /**单精度浮点(float)零的容差*/
        static zeroTolerance: number;
        /**浮点数默认最大值*/
        static MaxValue: number;
        /**浮点数默认最小值*/
        static MinValue: number;
        /**
         * 创建一个 <code>MathUtils</code> 实例。
         */
        constructor();
        /**
         * 是否在容差的范围内近似于0
         * @param  判断值
         * @return  是否近似于0
         */
        static isZero(v: number): boolean;
        /**
         * 两个值是否在容差的范围内近似相等Sqr Magnitude
         * @param  判断值
         * @return  是否近似于0
         */
        static nearEqual(n1: number, n2: number): boolean;
        static fastInvSqrt(value: number): number;
    }
}
declare module laya.d3.math {
    /**
     * <code>Matrix3x3</code> 类用于创建3x3矩阵。
     */
    class Matrix3x3 implements laya.d3.core.IClone {
        /**默认矩阵,禁止修改*/
        static DEFAULT: Matrix3x3;
        private static _tempV30;
        private static _tempV31;
        private static _tempV32;
        /**
         * 根据指定平移生成3x3矩阵
         * @param	tra 平移
         * @param	out 输出矩阵
         */
        static createFromTranslation(trans: Vector2, out: Matrix3x3): void;
        /**
         * 根据指定旋转生成3x3矩阵
         * @param	rad  旋转值
         * @param	out 输出矩阵
         */
        static createFromRotation(rad: number, out: Matrix3x3): void;
        /**
         * 根据制定缩放生成3x3矩阵
         * @param	scale 缩放值
         * @param	out 输出矩阵
         */
        static createFromScaling(scale: Vector2, out: Matrix3x3): void;
        /**
         * 从4x4矩阵转换为一个3x3的矩阵（原则为upper-left,忽略第四行四列）
         * @param	sou 4x4源矩阵
         * @param	out 3x3输出矩阵
         */
        static createFromMatrix4x4(sou: Matrix4x4, out: Matrix3x3): void;
        /**
         *  两个3x3矩阵的相乘
         * @param	left 左矩阵
         * @param	right  右矩阵
         * @param	out  输出矩阵
         */
        static multiply(left: Matrix3x3, right: Matrix3x3, out: Matrix3x3): void;
        /**矩阵元素数组*/
        elements: Float32Array;
        /**
         * 创建一个 <code>Matrix3x3</code> 实例。
         */
        constructor();
        /**
         * 计算3x3矩阵的行列式
         * @return    矩阵的行列式
         */
        determinant(): number;
        /**
         * 通过一个二维向量转换3x3矩阵
         * @param	tra 转换向量
         * @param	out 输出矩阵
         */
        translate(trans: Vector2, out: Matrix3x3): void;
        /**
         * 根据指定角度旋转3x3矩阵
         * @param	rad 旋转角度
         * @param	out 输出矩阵
         */
        rotate(rad: number, out: Matrix3x3): void;
        /**
         *根据制定缩放3x3矩阵
         * @param	scale 缩放值
         * @param	out 输出矩阵
         */
        scale(scale: Vector2, out: Matrix3x3): void;
        /**
         * 计算3x3矩阵的逆矩阵
         * @param	out 输出的逆矩阵
         */
        invert(out: Matrix3x3): void;
        /**
         * 计算3x3矩阵的转置矩阵
         * @param 	out 输出矩阵
         */
        transpose(out: Matrix3x3): void;
        /** 设置已有的矩阵为单位矩阵*/
        identity(): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        /**
         * 计算观察3x3矩阵
         * @param	eye    观察者位置
         * @param	target 目标位置
         * @param	up     上向量
         * @param	out    输出3x3矩阵
         */
        static lookAt(eye: Vector3, target: Vector3, up: Vector3, out: Matrix3x3): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>Matrix4x4</code> 类用于创建4x4矩阵。
     */
    class Matrix4x4 implements laya.d3.core.IClone {
        private static _tempMatrix4x4;
        private static _tempVector0;
        private static _tempVector1;
        private static _tempVector2;
        private static _tempQuaternion;
        /**默认矩阵,禁止修改*/
        static DEFAULT: Matrix4x4;
        /**
         * 绕X轴旋转
         * @param	rad  旋转角度
         * @param	out 输出矩阵
         */
        static createRotationX(rad: number, out: Matrix4x4): void;
        /**
         *
         * 绕Y轴旋转
         * @param	rad  旋转角度
         * @param	out 输出矩阵
         */
        static createRotationY(rad: number, out: Matrix4x4): void;
        /**
         * 绕Z轴旋转
         * @param	rad  旋转角度
         * @param	out 输出矩阵
         */
        static createRotationZ(rad: number, out: Matrix4x4): void;
        /**
         * 通过yaw pitch roll旋转创建旋转矩阵。
         * @param	yaw
         * @param	pitch
         * @param	roll
         * @param	result
         */
        static createRotationYawPitchRoll(yaw: number, pitch: number, roll: number, result: Matrix4x4): void;
        /**
         * 通过四元数创建旋转矩阵。
         * @param	rotation 旋转四元数。
         * @param	result 输出旋转矩阵
         */
        static createRotationQuaternion(rotation: Quaternion, result: Matrix4x4): void;
        /**
         * 根据平移计算输出矩阵
         * @param	trans  平移向量
         * @param	out 输出矩阵
         */
        static createTranslate(trans: Vector3, out: Matrix4x4): void;
        /**
         * 根据缩放计算输出矩阵
         * @param	scale  缩放值
         * @param	out 输出矩阵
         */
        static createScaling(scale: Vector3, out: Matrix4x4): void;
        /**
         * 计算两个矩阵的乘法
         * @param	left left矩阵
         * @param	right  right矩阵
         * @param	out  输出矩阵
         */
        static multiply(left: Matrix4x4, right: Matrix4x4, out: Matrix4x4): void;
        /**
         * 从四元数计算旋转矩阵
         * @param	rotation 四元数
         * @param	out 输出矩阵
         */
        static createFromQuaternion(rotation: Quaternion, out: Matrix4x4): void;
        /**
         * 计算仿射矩阵
         * @param	trans 平移
         * @param	rot 旋转
         * @param	scale 缩放
         * @param	out 输出矩阵
         */
        static createAffineTransformation(trans: Vector3, rot: Quaternion, scale: Vector3, out: Matrix4x4): void;
        /**
         *  计算观察矩阵
         * @param	eye 视点位置
         * @param	center 视点目标
         * @param	up 向上向量
         * @param	out 输出矩阵
         */
        static createLookAt(eye: Vector3, target: Vector3, up: Vector3, out: Matrix4x4): void;
        /**
         * 计算透视投影矩阵。
         * @param	fov  视角。
         * @param	aspect 横纵比。
         * @param	near 近裁面。
         * @param	far 远裁面。
         * @param	out 输出矩阵。
         */
        static createPerspective(fov: number, aspect: number, near: number, far: number, out: Matrix4x4): void;
        /**
         * 计算正交投影矩阵。
         * @param	left 视椎左边界。
         * @param	right 视椎右边界。
         * @param	bottom 视椎底边界。
         * @param	top 视椎顶边界。
         * @param	near 视椎近边界。
         * @param	far 视椎远边界。
         * @param	out 输出矩阵。
         */
        static createOrthogonal(left: number, right: number, bottom: number, top: number, near: number, far: number, out: Matrix4x4): void;
        /**矩阵元素数组*/
        elements: Float32Array;
        /**
         * 创建一个 <code>Matrix4x4</code> 实例。
         * @param	4x4矩阵的各元素
         */
        constructor(m11?: number, m12?: number, m13?: number, m14?: number, m21?: number, m22?: number, m23?: number, m24?: number, m31?: number, m32?: number, m33?: number, m34?: number, m41?: number, m42?: number, m43?: number, m44?: number);
        getElementByRowColumn(row: number, column: number): number;
        setElementByRowColumn(row: number, column: number, value: number): void;
        /**
         * 判断两个4x4矩阵的值是否相等。
         * @param	other 4x4矩阵
         */
        equalsOtherMatrix(other: Matrix4x4): boolean;
        /**
         * 分解矩阵为平移向量、旋转四元数、缩放向量。
         * @param	translation 平移向量。
         * @param	rotation 旋转四元数。
         * @param	scale 缩放向量。
         * @return 是否分解成功。
         */
        decomposeTransRotScale(translation: Vector3, rotation: Quaternion, scale: Vector3): boolean;
        /**
         * 分解矩阵为平移向量、旋转矩阵、缩放向量。
         * @param	translation 平移向量。
         * @param	rotationMatrix 旋转矩阵。
         * @param	scale 缩放向量。
         * @return 是否分解成功。
         */
        decomposeTransRotMatScale(translation: Vector3, rotationMatrix: Matrix4x4, scale: Vector3): boolean;
        /**归一化矩阵 */
        normalize(): void;
        /**计算矩阵的转置矩阵*/
        transpose(): Matrix4x4;
        /**
         * 计算一个矩阵的逆矩阵
         * @param	out 输出矩阵
         */
        invert(out: Matrix4x4): void;
        /**设置矩阵为单位矩阵*/
        identity(): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        static translation(v3: Vector3, out: Matrix4x4): void;
        /**
         * 获取平移向量。
         * @param	out 平移向量。
         */
        getTranslationVector(out: Vector3): void;
        /**
         * 设置平移向量。
         * @param	translate 平移向量。
         */
        setTranslationVector(translate: Vector3): void;
        /**
         * 获取前向量。
         * @param	out 前向量。
         */
        getForward(out: Vector3): void;
        /**
         * 设置前向量。
         * @param	forward 前向量。
         */
        setForward(forward: Vector3): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>OrientedBoundBox</code> 类用于创建OBB包围盒。
     */
    class OrientedBoundBox {
        /**每个轴长度的一半*/
        extents: Vector3;
        /**这个矩阵表示包围盒的位置和缩放,它的平移向量表示该包围盒的中心*/
        transformation: Matrix4x4;
        private static _tempV30;
        private static _tempV31;
        private static _tempV32;
        private static _tempV33;
        private static _tempV34;
        private static _tempV35;
        private static _tempV36;
        private static _tempM0;
        private static _tempM1;
        private static _corners;
        private static _rows1;
        private static _rows2;
        private static _ray;
        private static _boxBound1;
        private static _boxBound2;
        private static _boxBound3;
        /**
         * 创建一个 <code>OrientedBoundBox</code> 实例。
         * @param	extents 每个轴长度的一半
         * @param	transformation  包围盒的位置和缩放,
         */
        constructor(extents: Vector3, transformation: Matrix4x4);
        /**
         * 根据AABB包围盒创建一个 <code>OrientedBoundBox</code> 实例。
         * @param	box AABB包围盒。
         */
        static createByBoundBox(box: BoundBox, out: OrientedBoundBox): void;
        /**
         * 根据包围盒的最大最小两顶点创建一个 <code>OrientedBoundBox</code> 实例。
         * @param	min 包围盒的最小顶点。
         * @param	max 包围盒的最大顶点。
         */
        static createByMinAndMaxVertex(min: Vector3, max: Vector3): OrientedBoundBox;
        /**
         * 获取OBB包围盒的8个顶点。
         * @param	corners 返回顶点的输出队列。
         */
        getCorners(corners: Array<any>): void;
        /**
         * 变换该包围盒的矩阵信息。
         * @param	mat 矩阵
         */
        transform(mat: Matrix4x4): void;
        /**
         * 缩放该包围盒
         * @param	scaling 各轴的缩放比。
         */
        scale(scaling: Vector3): void;
        /**
         * 平移该包围盒。
         * @param	translation 平移参数
         */
        translate(translation: Vector3): void;
        /**
         * 该包围盒的尺寸。
         * @param	out 输出
         */
        Size(out: Vector3): void;
        /**
         * 该包围盒需要考虑的尺寸
         * @param	out 输出
         */
        getSize(out: Vector3): void;
        /**
         * 该包围盒需要考虑尺寸的平方
         * @param	out 输出
         */
        getSizeSquared(out: Vector3): void;
        /**
         * 该包围盒的几何中心
         */
        getCenter(center: Vector3): void;
        /**
         * 该包围盒是否包含空间中一点
         * @param	point 点
         * @return  返回位置关系
         */
        containsPoint(point: Vector3): number;
        /**
         * 该包围盒是否包含空间中多点
         * @param	point 点
         * @return  返回位置关系
         */
        containsPoints(points: Array<any>): number;
        /**
         * 该包围盒是否包含空间中一包围球
         * @param	sphere 包围球
         * @param	ignoreScale 是否考虑该包围盒的缩放
         * @return  返回位置关系
         */
        containsSphere(sphere: BoundSphere, ignoreScale?: boolean): number;
        /**
         * 该包围盒是否包含空间中另一OBB包围盒
         * @param	obb OBB包围盒
         * @return  返回位置关系
         */
        containsOrientedBoundBox(obb: OrientedBoundBox): number;
        /**
         * 该包围盒是否包含空间中一条线
         * @param	point1 点1
         * @param	point2 点2
         * @return  返回位置关系
         */
        containsLine(point1: Vector3, point2: Vector3): number;
        /**
         * 该包围盒是否包含空间中另一OBB包围盒
         * @param	box 包围盒
         * @return  返回位置关系
         */
        containsBoundBox(box: BoundBox): number;
        /**
         * 该包围盒是否与空间中另一射线相交
         * @param	ray
         * @param	out
         * @return
         */
        intersectsRay(ray: Ray, out: Vector3): number;
        /**
         * 计算Obb包围盒变换到另一Obb包围盒的矩阵
         * @param	a Obb包围盒
         * @param	b Obb包围盒
         * @param	noMatrixScaleApplied 是否考虑缩放
         * @param	out 输出变换矩阵
         */
        static getObbtoObbMatrix4x4(a: OrientedBoundBox, b: OrientedBoundBox, noMatrixScaleApplied: boolean, out: Matrix4x4): void;
        /**
         * 把一个Obb类型的包围盒b合入另一Obb型包围盒a
         * @param	a obb包围盒
         * @param	b obb包围盒
         * @param	noMatrixScaleApplied 是否考虑缩放
         */
        static merge(a: OrientedBoundBox, b: OrientedBoundBox, noMatrixScaleApplied: boolean): void;
        /**
         * 判断两个包围盒是否相等
         * @param	obb obb包围盒
         * @return  Boolean
         */
        equals(obb: OrientedBoundBox): boolean;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>Plane</code> 类用于创建平面。
     */
    class Plane {
        private static _TEMPVec3;
        /**平面的向量*/
        normal: Vector3;
        /**平面到坐标系原点的距离*/
        distance: number;
        /**平面与其他几何体相交类型*/
        static PlaneIntersectionType_Back: number;
        static PlaneIntersectionType_Front: number;
        static PlaneIntersectionType_Intersecting: number;
        /**
         * 创建一个 <code>Plane</code> 实例。
         * @param	normal 平面的向量
         * @param	d  平面到原点的距离
         */
        constructor(normal: Vector3, d?: number);
        /**
         * 创建一个 <code>Plane</code> 实例。
         * @param	point1 第一点
         * @param	point2 第二点
         * @param	point3 第三点
         */
        static createPlaneBy3P(point1: Vector3, point2: Vector3, point3: Vector3): Plane;
        /**
         * 更改平面法线向量的系数，使之成单位长度。
         */
        normalize(): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>Quaternion</code> 类用于创建四元数。
     */
    class Quaternion implements laya.d3.core.IClone {
        private static TEMPVector30;
        private static TEMPVector31;
        private static TEMPVector32;
        private static TEMPVector33;
        private static TEMPMatrix0;
        private static TEMPMatrix1;
        private static _tempMatrix3x3;
        /**默认矩阵,禁止修改*/
        static DEFAULT: Quaternion;
        /**
         *  从欧拉角基元四元数（顺序为Yaw、Pitch、Roll）
         * @param	yaw yaw值
         * @param	pitch pitch值
         * @param	roll roll值
         * @param	out 输出四元数
         */
        static createFromYawPitchRoll(yaw: number, pitch: number, roll: number, out: Quaternion): void;
        /**
         * 计算两个四元数相乘
         * @param	left left四元数
         * @param	right  right四元数
         * @param	out 输出四元数
         */
        static multiply(left: Quaternion, right: Quaternion, out: Quaternion): void;
        /**
         * 从指定的轴和角度计算四元数
         * @param	axis  轴
         * @param	rad  角度
         * @param	out  输出四元数
         */
        static createFromAxisAngle(axis: Vector3, rad: number, out: Quaternion): void;
        /**
         * 根据3x3矩阵计算四元数
         * @param	sou 源矩阵
         * @param	out 输出四元数
         */
        static createFromMatrix3x3(sou: Matrix3x3, out: Quaternion): void;
        /**
         *  从旋转矩阵计算四元数
         * @param	mat 旋转矩阵
         * @param	out  输出四元数
         */
        static createFromMatrix4x4(mat: Matrix4x4, out: Quaternion): void;
        /**
         * 球面插值
         * @param	left left四元数
         * @param	right  right四元数
         * @param	a 插值比例
         * @param	out 输出四元数
         * @return   输出Float32Array
         */
        static slerp(left: Quaternion, right: Quaternion, t: number, out: Quaternion): Float32Array;
        /**
         * 计算两个四元数的线性插值
         * @param	left left四元数
         * @param	right right四元数b
         * @param	t 插值比例
         * @param	out 输出四元数
         */
        static lerp(left: Quaternion, right: Quaternion, t: number, out: Quaternion): void;
        /**
         * 计算两个四元数的和
         * @param	left  left四元数
         * @param	right right 四元数
         * @param	out 输出四元数
         */
        static add(left: Quaternion, right: Quaternion, out: Quaternion): void;
        /**
         * 计算两个四元数的点积
         * @param	left left四元数
         * @param	right right四元数
         * @return  点积
         */
        static dot(left: Quaternion, right: Quaternion): number;
        /**四元数元素数组*/
        elements: Float32Array;
        /**
         * 获取四元数的x值
         */
        x: number;
        /**
         * 获取四元数的y值
         */
        y: number;
        /**
         * 获取四元数的z值
         */
        z: number;
        /**
         * 获取四元数的w值
         */
        w: number;
        /**
         * 创建一个 <code>Quaternion</code> 实例。
         * @param	x 四元数的x值
         * @param	y 四元数的y值
         * @param	z 四元数的z值
         * @param	w 四元数的w值
         */
        constructor(x?: number, y?: number, z?: number, w?: number);
        /**
         * 根据缩放值缩放四元数
         * @param	scale 缩放值
         * @param	out 输出四元数
         */
        scaling(scaling: number, out: Quaternion): void;
        /**
         * 归一化四元数
         * @param	out 输出四元数
         */
        normalize(out: Quaternion): void;
        /**
         * 计算四元数的长度
         * @return  长度
         */
        length(): number;
        /**
         * 根据绕X轴的角度旋转四元数
         * @param	rad 角度
         * @param	out 输出四元数
         */
        rotateX(rad: number, out: Quaternion): void;
        /**
         * 根据绕Y轴的制定角度旋转四元数
         * @param	rad 角度
         * @param	out 输出四元数
         */
        rotateY(rad: number, out: Quaternion): void;
        /**
         * 根据绕Z轴的制定角度旋转四元数
         * @param	rad 角度
         * @param	out 输出四元数
         */
        rotateZ(rad: number, out: Quaternion): void;
        /**
         * 分解四元数到欧拉角（顺序为Yaw、Pitch、Roll），参考自http://xboxforums.create.msdn.com/forums/p/4574/23988.aspx#23988,问题绕X轴翻转超过±90度时有，会产生瞬间反转
         * @param	quaternion 源四元数
         * @param	out 欧拉角值
         */
        getYawPitchRoll(out: Vector3): void;
        /**
         * 求四元数的逆
         * @param	out  输出四元数
         */
        invert(out: Quaternion): void;
        /**
         *设置四元数为单位算数
         * @param out  输出四元数
         */
        identity(): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        equals(b: Quaternion): boolean;
        /**
         * 计算旋转观察四元数
         * @param	forward 方向
         * @param	up     上向量
         * @param	out    输出四元数
         */
        static rotationLookAt(forward: Vector3, up: Vector3, out: Quaternion): void;
        /**
         * 计算观察四元数
         * @param	eye    观察者位置
         * @param	target 目标位置
         * @param	up     上向量
         * @param	out    输出四元数
         */
        static lookAt(eye: Vector3, target: Vector3, up: Vector3, out: Quaternion): void;
        /**
         * 计算长度的平方。
         * @return 长度的平方。
         */
        lengthSquared(): number;
        /**
         * 计算四元数的逆四元数。
         * @param	value 四元数。
         * @param	out 逆四元数。
         */
        static invert(value: Quaternion, out: Quaternion): void;
        /**
         * 通过一个3x3矩阵创建一个四元数
         * @param	matrix3x3  3x3矩阵
         * @param	out        四元数
         */
        static rotationMatrix(matrix3x3: Matrix3x3, out: Quaternion): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>Rand</code> 类用于通过32位无符号整型随机种子创建随机数。
     */
    class Rand {
        /**
         * 通过无符号32位整形，获取32位浮点随机数。
         * @param 无符号32位整形随机数。
         * @return 32位浮点随机数。
         */
        static getFloatFromInt(v: number): number;
        /**
         * 通过无符号32位整形，获取无符号8位字节随机数。
         * @param 无符号32位整形随机数。
         * @return 无符号8位字节随机数。
         */
        static getByteFromInt(v: number): number;
        /**获取随机种子。*/
        seeds: Uint32Array;
        /**
         * 获取随机种子。
         * @return 随机种子。
         */
        /**
         * 设置随机种子。
         * @param	seed 随机种子。
         */
        seed: number;
        /**
         * 创建一个 <code>Rand</code> 实例。
         * @param	seed  32位无符号整型随机种子。
         */
        constructor(seed: number);
        /**
         * 获取无符号32位整形随机数。
         * @return 无符号32位整形随机数。
         */
        getUint(): number;
        /**
         * 获取0到1之间的浮点随机数。
         * @return 0到1之间的浮点随机数。
         */
        getFloat(): number;
        /**
         * 获取-1到1之间的浮点随机数。
         * @return -1到1之间的浮点随机数。
         */
        getSignedFloat(): number;
    }
}
declare module laya.d3.math {
    /**
     * <code>Rand</code> 类用于通过128位整型种子创建随机数,算法来自:https://github.com/AndreasMadsen/xorshift。
     */
    class RandX {
        private static _CONVERTION_BUFFER;
        /**基于时间种子的随机数。*/
        static defaultRand: RandX;
        /**
         * 创建一个 <code>Rand</code> 实例。
         * @param	seed  随机种子。
         */
        constructor(seed: Array<any>);
        /**
         * 通过2x32位的数组，返回64位的随机数。
         * @return 64位的随机数。
         */
        randomint(): Array<any>;
        /**
         * 返回[0,1)之间的随机数。
         * @return
         */
        random(): number;
    }
}
declare module laya.d3.math {
    /**
     * <code>Ray</code> 类用于创建射线。
     */
    class Ray {
        /**原点*/
        origin: Vector3;
        /**方向*/
        direction: Vector3;
        /**
         * 创建一个 <code>Ray</code> 实例。
         * @param	origin 射线的起点
         * @param	direction  射线的方向
         */
        constructor(origin: Vector3, direction: Vector3);
    }
}
declare module laya.d3.math {
    /**
     * <code>Vector2</code> 类用于创建二维向量。
     */
    class Vector2 implements laya.d3.core.IClone {
        /**零向量,禁止修改*/
        static ZERO: Vector2;
        /**一向量,禁止修改*/
        static ONE: Vector2;
        /**二维向量元素数组*/
        elements: any;
        /**
         * 获取X轴坐标。
         * @return	X轴坐标。
         */
        /**
         * 设置X轴坐标。
         * @param value X轴坐标。
         */
        x: number;
        /**
         * 获取Y轴坐标。
         * @return Y轴坐标。
         */
        /**
         * 设置Y轴坐标。
         * @param value Y轴坐标。
         */
        y: number;
        /**
         * 创建一个 <code>Vector2</code> 实例。
         * @param	x  X轴坐标。
         * @param	y  Y轴坐标。
         */
        constructor(x?: number, y?: number);
        /**
         * 缩放二维向量。
         * @param	a 源二维向量。
         * @param	b 缩放值。
         * @param	out 输出二维向量。
         */
        static scale(a: Vector2, b: number, out: Vector2): void;
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
    }
}
declare module laya.d3.math {
    /**
     * <code>Vector3</code> 类用于创建三维向量。
     */
    class Vector3 implements laya.d3.core.IClone {
        /**零向量，禁止修改*/
        static ZERO: Vector3;
        /**一向量，禁止修改*/
        static ONE: Vector3;
        /**X轴单位向量，禁止修改*/
        static NegativeUnitX: Vector3;
        /**X轴单位向量，禁止修改*/
        static UnitX: Vector3;
        /**Y轴单位向量，禁止修改*/
        static UnitY: Vector3;
        /**Z轴单位向量，禁止修改*/
        static UnitZ: Vector3;
        /**右手坐标系统前向量，禁止修改*/
        static ForwardRH: Vector3;
        /**左手坐标系统前向量,禁止修改*/
        static ForwardLH: Vector3;
        /**上向量,禁止修改*/
        static Up: Vector3;
        private static TEMPVec4;
        /**
         * 两个三维向量距离的平方。
         * @param	value1 向量1。
         * @param	value2 向量2。
         * @return	距离的平方。
         */
        static distanceSquared(value1: Vector3, value2: Vector3): number;
        /**
         * 两个三维向量距离。
         * @param	value1 向量1。
         * @param	value2 向量2。
         * @return	距离。
         */
        static distance(value1: Vector3, value2: Vector3): number;
        /**
         * 分别取两个三维向量x、y、z的最小值计算新的三维向量。
         * @param	a。
         * @param	b。
         * @param	out。
         */
        static min(a: Vector3, b: Vector3, out: Vector3): void;
        /**
         * 分别取两个三维向量x、y、z的最大值计算新的三维向量。
         * @param	a a三维向量。
         * @param	b b三维向量。
         * @param	out 结果三维向量。
         */
        static max(a: Vector3, b: Vector3, out: Vector3): void;
        /**
         * 根据四元数旋转三维向量。
         * @param	source 源三维向量。
         * @param	rotation 旋转四元数。
         * @param	out 输出三维向量。
         */
        static transformQuat(source: Vector3, rotation: Quaternion, out: Vector3): void;
        /**
         * 计算标量长度。
         * @param	a 源三维向量。
         * @return 标量长度。
         */
        static scalarLength(a: Vector3): number;
        /**
         * 计算标量长度。
         * @param	a 源三维向量。
         * @return 标量长度的平方。
         */
        static scalarLengthSquared(a: Vector3): number;
        /**
         * 归一化三维向量。
         * @param	s 源三维向量。
         * @param	out 输出三维向量。
         */
        static normalize(s: Vector3, out: Vector3): void;
        /**
         * 计算两个三维向量的乘积。
         * @param	a left三维向量。
         * @param	b right三维向量。
         * @param	out 输出三维向量。
         */
        static multiply(a: Vector3, b: Vector3, out: Vector3): void;
        /**
         * 缩放三维向量。
         * @param	a 源三维向量。
         * @param	b 缩放值。
         * @param	out 输出三维向量。
         */
        static scale(a: Vector3, b: number, out: Vector3): void;
        /**
         * 插值三维向量。
         * @param	a left向量。
         * @param	b right向量。
         * @param	t 插值比例。
         * @param	out 输出向量。
         */
        static lerp(a: Vector3, b: Vector3, t: number, out: Vector3): void;
        /**
         * 通过矩阵转换一个三维向量到另外一个三维向量。
         * @param	vector 源三维向量。
         * @param	transform  变换矩阵。
         * @param	result 输出三维向量。
         */
        static transformV3ToV3(vector: Vector3, transform: Matrix4x4, result: Vector3): void;
        /**
         * 通过矩阵转换一个三维向量到另外一个四维向量。
         * @param	vector 源三维向量。
         * @param	transform  变换矩阵。
         * @param	result 输出四维向量。
         */
        static transformV3ToV4(vector: Vector3, transform: Matrix4x4, result: Vector4): void;
        /**
         * 通过法线矩阵转换一个法线三维向量到另外一个三维向量。
         * @param	normal 源法线三维向量。
         * @param	transform  法线变换矩阵。
         * @param	result 输出法线三维向量。
         */
        static TransformNormal(normal: Vector3, transform: Matrix4x4, result: Vector3): void;
        /**
         * 通过矩阵转换一个三维向量到另外一个归一化的三维向量。
         * @param	vector 源三维向量。
         * @param	transform  变换矩阵。
         * @param	result 输出三维向量。
         */
        static transformCoordinate(coordinate: Vector3, transform: Matrix4x4, result: Vector3): void;
        /**
         * 求一个指定范围的向量
         * @param	value clamp向量
         * @param	min  最小
         * @param	max  最大
         * @param   out 输出向量
         */
        static Clamp(value: Vector3, min: Vector3, max: Vector3, out: Vector3): void;
        /**
         * 求两个三维向量的和。
         * @param	a left三维向量。
         * @param	b right三维向量。
         * @param	out 输出向量。
         */
        static add(a: Vector3, b: Vector3, out: Vector3): void;
        /**
         * 求两个三维向量的差。
         * @param	a  left三维向量。
         * @param	b  right三维向量。
         * @param	o out 输出向量。
         */
        static subtract(a: Vector3, b: Vector3, o: Vector3): void;
        /**
         * 求两个三维向量的叉乘。
         * @param	a left向量。
         * @param	b right向量。
         * @param	o 输出向量。
         */
        static cross(a: Vector3, b: Vector3, o: Vector3): void;
        /**
         * 求两个三维向量的点积。
         * @param	a left向量。
         * @param	b right向量。
         * @return   点积。
         */
        static dot(a: Vector3, b: Vector3): number;
        /**
         * 判断两个三维向量是否相等。
         * @param	a 三维向量。
         * @param	b 三维向量。
         * @return  是否相等。
         */
        static equals(a: Vector3, b: Vector3): boolean;
        /**三维向量元素数组*/
        elements: Float32Array;
        /**
         * 获取X轴坐标。
         * @return	X轴坐标。
         */
        /**
         * 设置X轴坐标。
         * @param	value  X轴坐标。
         */
        x: number;
        /**
         * 获取Y轴坐标。
         * @return	Y轴坐标。
         */
        /**
         * 设置Y轴坐标。
         * @param	value  Y轴坐标。
         */
        y: number;
        /**
         * 获取Z轴坐标。
         * @return	Z轴坐标。
         */
        /**
         * 设置Z轴坐标。
         * @param	value  Z轴坐标。
         */
        z: number;
        /**
         * 创建一个 <code>Vector3</code> 实例。
         * @param	x  X轴坐标。
         * @param	y  Y轴坐标。
         * @param	z  Z轴坐标。
         */
        constructor(x?: number, y?: number, z?: number);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        toDefault(): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>Vector4</code> 类用于创建四维向量。
     */
    class Vector4 implements laya.d3.core.IClone {
        /**零向量，禁止修改*/
        static ZERO: Vector4;
        static ONE: Vector4;
        static UnitX: Vector4;
        static UnitY: Vector4;
        static UnitZ: Vector4;
        static UnitW: Vector4;
        /**四维向量元素数组*/
        elements: any;
        /**
         * 获取X轴坐标。
         * @return  X轴坐标。
         */
        /**
         * 设置X轴坐标。
         * @param value X轴坐标。
         */
        x: number;
        /**
         * 获取Y轴坐标。
         * @return	Y轴坐标。
         */
        /**
         * 设置Y轴坐标。
         * @param	value  Y轴坐标。
         */
        y: number;
        /**
         * 获取Z轴坐标。
         * @return	 Z轴坐标。
         */
        /**
         * 设置Z轴坐标。
         * @param	value  Z轴坐标。
         */
        z: number;
        /**
         * 获取W轴坐标。
         * @return	W轴坐标。
         */
        /**
         * 设置W轴坐标。
         * @param value	W轴坐标。
         */
        w: number;
        /**
         * 创建一个 <code>Vector4</code> 实例。
         * @param	x  X轴坐标。
         * @param	y  Y轴坐标。
         * @param	z  Z轴坐标。
         * @param	w  W轴坐标。
         */
        constructor(x?: number, y?: number, z?: number, w?: number);
        /**
         * 克隆。
         * @param	destObject 克隆源。
         */
        cloneTo(destObject: any): void;
        /**
         * 克隆。
         * @return	 克隆副本。
         */
        clone(): any;
        /**
         * 插值四维向量。
         * @param	a left向量。
         * @param	b right向量。
         * @param	t 插值比例。
         * @param	out 输出向量。
         */
        static lerp(a: Vector4, b: Vector4, t: number, out: Vector4): void;
        /**
         * 通过4x4矩阵把一个四维向量转换为另一个四维向量
         * @param	vector4 带转换四维向量。
         * @param	M4x4    4x4矩阵。
         * @param	out     转换后四维向量。
         */
        static transformByM4x4(vector4: Vector4, m4x4: Matrix4x4, out: Vector4): void;
        /**
         * 判断两个四维向量是否相等。
         * @param	a 四维向量。
         * @param	b 四维向量。
         * @return  是否相等。
         */
        static equals(a: Vector4, b: Vector4): boolean;
        /**
         * 求四维向量的长度。
         * @return  长度。
         */
        length(): number;
        /**
         * 求四维向量长度的平方。
         * @return  长度的平方。
         */
        lengthSquared(): number;
        /**
         * 归一化四维向量。
         * @param	s   源四维向量。
         * @param	out 输出四维向量。
         */
        static normalize(s: Vector4, out: Vector4): void;
        /**
         * 求两个四维向量的和。
         * @param	a   四维向量。
         * @param	b   四维向量。
         * @param	out 输出向量。
         */
        static add(a: Vector4, b: Vector4, out: Vector4): void;
        /**
         * 求两个四维向量的差。
         * @param	a   四维向量。
         * @param	b   四维向量。
         * @param	out 输出向量。
         */
        static subtract(a: Vector4, b: Vector4, out: Vector4): void;
        /**
         * 计算两个四维向量的乘积。
         * @param	a   四维向量。
         * @param	b   四维向量。
         * @param	out 输出向量。
         */
        static multiply(a: Vector4, b: Vector4, out: Vector4): void;
        /**
         * 缩放四维向量。
         * @param	a   源四维向量。
         * @param	b   缩放值。
         * @param	out 输出四维向量。
         */
        static scale(a: Vector4, b: number, out: Vector4): void;
        /**
         * 求一个指定范围的四维向量
         * @param	value clamp向量
         * @param	min   最小
         * @param	max   最大
         * @param   out   输出向量
         */
        static Clamp(value: Vector4, min: Vector4, max: Vector4, out: Vector4): void;
        /**
         * 两个四维向量距离的平方。
         * @param	value1 向量1。
         * @param	value2 向量2。
         * @return	距离的平方。
         */
        static distanceSquared(value1: Vector4, value2: Vector4): number;
        /**
         * 两个四维向量距离。
         * @param	value1 向量1。
         * @param	value2 向量2。
         * @return	距离。
         */
        static distance(value1: Vector4, value2: Vector4): number;
        /**
         * 求两个四维向量的点积。
         * @param	a 向量。
         * @param	b 向量。
         * @return  点积。
         */
        static dot(a: Vector4, b: Vector4): number;
        /**
         * 分别取两个四维向量x、y、z的最小值计算新的四维向量。
         * @param	a   四维向量。
         * @param	b   四维向量。
         * @param	out 结果三维向量。
         */
        static min(a: Vector4, b: Vector4, out: Vector4): void;
        /**
         * 分别取两个四维向量x、y、z的最大值计算新的四维向量。
         * @param	a   四维向量。
         * @param	b   四维向量。
         * @param	out 结果三维向量。
         */
        static max(a: Vector4, b: Vector4, out: Vector4): void;
    }
}
declare module laya.d3.math {
    /**
     * <code>Viewport</code> 类用于创建视口。
     */
    class Viewport {
        private static _tempMatrix4x4;
        /**X轴坐标*/
        x: number;
        /**Y轴坐标*/
        y: number;
        /**宽度*/
        width: number;
        /**高度*/
        height: number;
        /**最小深度*/
        minDepth: number;
        /**最大深度*/
        maxDepth: number;
        /**
         * 创建一个 <code>Viewport</code> 实例。
         * @param	x x坐标。
         * @param	y y坐标。
         * @param	width 宽度。
         * @param	height 高度。
         */
        constructor(x: number, y: number, width: number, height: number);
        /**
         * 变换一个三维向量。
         * @param	source 源三维向量。
         * @param	matrix 变换矩阵。
         * @param	vector 输出三维向量。
         */
        project(source: Vector3, matrix: Matrix4x4, out: Vector3): void;
        /**
         * 反变换一个三维向量。
         * @param	source 源三维向量。
         * @param	matrix 变换矩阵。
         * @param	vector 输出三维向量。
         */
        unprojectFromMat(source: Vector3, matrix: Matrix4x4, out: Vector3): void;
        /**
         * 反变换一个三维向量。
         * @param	source 源三维向量。
         * @param	projection  透视投影矩阵。
         * @param	view 视图矩阵。
         * @param	world 世界矩阵,可设置为null。
         * @param   out 输出向量。
         */
        unprojectFromWVP(source: Vector3, projection: Matrix4x4, view: Matrix4x4, world: Matrix4x4, out: Vector3): void;
    }
}
declare module laya.d3.resource {
    /**
     * <code>BaseTexture</code> 纹理的父类，抽象类，不允许实例。
     */
    class BaseTexture extends laya.resource.Resource {
        /**灰色纯色纹理。*/
        static grayTexture: SolidColorTexture2D;
        protected _width: number;
        protected _height: number;
        protected _size: laya.d3.utils.Size;
        protected _repeat: boolean;
        protected _mipmap: boolean;
        protected _minFifter: number;
        protected _magFifter: number;
        protected _source: any;
        _conchTexture: any;
        /**
         * 获取宽度。
         */
        width: number;
        /**
         * 获取高度。
         */
        height: number;
        /**
         * 获取尺寸。
         */
        size: laya.d3.utils.Size;
        /**
         * 是否使用重复模式纹理寻址
         */
        /**
         * 是否使用重复模式纹理寻址
         */
        repeat: boolean;
        /**
         * 是否使用mipLevel
         */
        /**
         * 是否使用mipLevel
         */
        mipmap: boolean;
        /**
         * 缩小过滤器
         */
        /**
         * 缩小过滤器
         */
        minFifter: number;
        /**
         * 放大过滤器
         */
        /**
         * 放大过滤器
         */
        magFifter: number;
        /**
         * 获取纹理资源。
         */
        source: any;
        /**
         * 获取纹理资源。
         */
        defaulteTexture: BaseTexture;
        /**
         * 创建一个 <code>BaseTexture</code> 实例。
         */
        constructor();
        dispose(): void;
    }
}
declare module laya.d3.resource {
    class DataTexture2D extends BaseTexture {
        simLodInfo: Float32Array;
        static simLodRect: Uint32Array;
        static create(data: ArrayBuffer, w: number, h: number, magfilter?: number, minfilter?: number, mipmap?: boolean): DataTexture2D;
        /**
         * 加载Texture2D。
         * @param url Texture2D地址。
         */
        static load(url: string, w?: number, h?: number, magfilter?: number, minfilter?: number): DataTexture2D;
        /**
         * 获取文件路径全名。
         */
        src: string;
        /**
         * 创建一个 <code>Texture2D</code> 实例。
         */
        constructor();
        protected recreateResource(): void;
        /**
         *@private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * 返回图片像素。
         * @return 图片像素。
         */
        getPixels(): Uint8Array;
        protected detoryResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>BaseMesh</code> 类用于创建网格,抽象类,不允许实例。
     */
    class BaseMesh extends laya.resource.Resource {
        protected _subMeshCount: number;
        protected _boundingBox: laya.d3.math.BoundBox;
        protected _boundingSphere: laya.d3.math.BoundSphere;
        protected _boundingBoxCorners: Array<any>;
        /**
         * 获取SubMesh的个数。
         * @return SubMesh的个数。
         */
        subMeshCount: number;
        /**
         * 获取AABB包围盒,禁止修改其数据。
         * @return AABB包围盒。
         */
        boundingBox: laya.d3.math.BoundBox;
        /**
         * 获取包围球,禁止修改其数据。
         * @return 包围球。
         */
        boundingSphere: laya.d3.math.BoundSphere;
        /**
         * 获取包围球顶点,禁止修改其数据。
         * @return 包围球。
         */
        boundingBoxCorners: Array<any>;
        /**
         * 获取网格顶点,请重载此方法。
         * @return 网格顶点。
         */
        positions: Array<any>;
        /**
         * 创建一个 <code>BaseMesh</code> 实例。
         */
        constructor();
        protected _generateBoundingObject(): void;
        /**
         * 获取渲染单元数量,请重载此方法。
         * @return 渲染单元数量。
         */
        getRenderElementsCount(): number;
        /**
         * 获取渲染单元,请重载此方法。
         * @param	index 索引。
         * @return 渲染单元。
         */
        getRenderElement(index: number): laya.d3.core.render.IRenderable;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>Sphere</code> 类用于创建方体。
     */
    class BoxMesh extends PrimitiveMesh {
        /**
         * 返回长度
         * @return 长
         */
        /**
         * 设置长度（改变此属性会重新生成顶点和索引）
         * @param  value 长度
         */
        long: number;
        /**
         * 返回宽度
         * @return 宽
         */
        /**
         * 设置宽度（改变此属性会重新生成顶点和索引）
         * @param  value 宽度
         */
        width: number;
        /**
         * 返回高度
         * @return 高
         */
        /**
         * 设置高度（改变此属性会重新生成顶点和索引）
         * @param  value 高度
         */
        height: number;
        /**
         * 创建一个方体模型
         * @param radius 半径
         * @param stacks 水平层数
         * @param slices 垂直层数
         */
        constructor(long?: number, width?: number, height?: number);
        protected recreateResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>CapsuleMesh</code> 类用于创建胶囊体。
     */
    class CapsuleMesh extends PrimitiveMesh {
        /**
         * 返回半径
         * @return 半径
         */
        /**
         * 设置半径（改变此属性会重新生成顶点和索引）
         * @param  value 半径
         */
        radius: number;
        /**
         * 返回高度
         * @return 高度
         */
        /**
         * 设置高度（改变此属性会重新生成顶点和索引）
         * @param  value 高度
         */
        height: number;
        /**
         * 获取高度分段
         * @return 高度分段
         */
        /**
         * 设置高度分段（改变此属性会重新生成顶点和索引）
         * @param  value高度分段
         */
        stacks: number;
        /**
         * 获取宽度分段
         * @return 宽度分段
         */
        /**
         * 设置宽度分段（改变此属性会重新生成顶点和索引）
         * @param  value 宽度分段
         */
        slices: number;
        /**
         * 创建一个胶囊体模型
         * @param radius 半径
         * @param height 高度
         * @param stacks 水平层数,一般设为垂直层数的一半
         * @param slices 垂直层数
         */
        constructor(radius?: number, height?: number, stacks?: number, slices?: number);
        protected recreateResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>CylinderMesh</code> 类用于创建圆柱体。
     */
    class CylinderMesh extends PrimitiveMesh {
        /**
         * 返回半径
         * @return 半径
         */
        /**
         * 设置半径（改变此属性会重新生成顶点和索引）
         * @param  value 半径
         */
        radius: number;
        /**
         * 返回高度
         * @return 高度
         */
        /**
         * 设置高度（改变此属性会重新生成顶点和索引）
         * @param  value 高度
         */
        height: number;
        /**
         * 获取宽度分段
         * @return 宽度分段
         */
        /**
         * 设置宽度分段（改变此属性会重新生成顶点和索引）
         * @param  value 宽度分段
         */
        slices: number;
        /**
         * 创建一个圆柱体模型
         * @param radius 半径
         * @param height 高度
         * @param slices 垂直层数
         */
        constructor(radius?: number, height?: number, slices?: number);
        protected recreateResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>Mesh</code> 类用于创建文件网格数据模板。
     */
    class Mesh extends BaseMesh {
        /**
         * 加载网格模板。
         * @param url 模板地址。
         */
        static load(url: string): Mesh;
        _vertexBuffers: Array<any>;
        _indexBuffer: laya.d3.graphics.IndexBuffer3D;
        _boneNames: Array<any>;
        _bindPoses: Array<any>;
        _inverseBindPoses: Array<any>;
        /**
         * 获取网格顶点
         * @return 网格顶点。
         */
        positions: Array<any>;
        /**
         * 获取材质队列的浅拷贝。
         * @return  材质队列的浅拷贝。
         */
        materials: Array<any>;
        /**
         * 获取网格的默认绑定动作矩阵。
         * @return  网格的默认绑定动作矩阵。
         */
        bindPoses: Array<any>;
        /**
         * 获取网格的全局默认绑定动作逆矩阵。
         * @return  网格的全局默认绑定动作逆矩阵。
         */
        InverseAbsoluteBindPoses: Array<any>;
        /**
         * 创建一个 <code>Mesh</code> 实例,禁止使用。
         * @param url 文件地址。
         */
        constructor();
        /**
         * 添加子网格（开发者禁止修改）。
         * @param subMesh 子网格。
         */
        _add(subMesh: SubMesh): void;
        /**
         * 移除子网格（开发者禁止修改）。
         * @param subMesh 子网格。
         * @return  是否成功。
         */
        _remove(subMesh: SubMesh): boolean;
        /**
         *@private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * 获得子网格。
         * @param index 子网格索引。
         * @return  子网格。
         */
        getSubMesh(index: number): SubMesh;
        /**
         * 获得子网格数量。
         * @return  子网格数量。
         */
        getSubMeshCount(): number;
        getRenderElementsCount(): number;
        getRenderElement(index: number): laya.d3.core.render.IRenderable;
        /**
         * <p>彻底清理资源。</p>
         * <p><b>注意：</b>会强制解锁清理。</p>
         */
        dispose(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>QuadMesh</code> 类用于创建平面。
     */
    class PlaneMesh extends PrimitiveMesh {
        /**
         * 返回长度
         * @return 长
         */
        /**
         * 设置长度（改变此属性会重新生成顶点和索引）
         * @param  value 长度
         */
        long: number;
        /**
         * 返回宽度
         * @return 宽
         */
        /**
         * 设置宽度（改变此属性会重新生成顶点和索引）
         * @param  value 宽度
         */
        width: number;
        /**
         * 获取长度分段
         * @return 长度分段
         */
        /**
         * 设置长度分段（改变此属性会重新生成顶点和索引）
         * @param  value长度分段
         */
        stacks: number;
        /**
         * 获取宽度分段
         * @return 宽度分段
         */
        /**
         * 设置宽度分段（改变此属性会重新生成顶点和索引）
         * @param  value 宽度分段
         */
        slices: number;
        /**
         * 创建一个平面模型
         * @param long  长
         * @param width 宽
         */
        constructor(long?: number, width?: number, stacks?: number, slices?: number);
        protected recreateResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * @private
     * <code>PrimitiveMesh</code> 类用于创建基本网格的父类。
     */
    class PrimitiveMesh extends BaseMesh implements laya.d3.core.render.IRenderable {
        protected _numberVertices: number;
        protected _numberIndices: number;
        protected _vertexBuffer: laya.d3.graphics.VertexBuffer3D;
        protected _indexBuffer: laya.d3.graphics.IndexBuffer3D;
        _indexOfHost: number;
        indexOfHost: number;
        _vertexBufferCount: number;
        triangleCount: number;
        _getVertexBuffer(index?: number): laya.d3.graphics.VertexBuffer3D;
        _getIndexBuffer(): laya.d3.graphics.IndexBuffer3D;
        /**
         * 获取网格顶点
         * @return 网格顶点。
         */
        positions: Array<any>;
        constructor();
        getRenderElement(index: number): laya.d3.core.render.IRenderable;
        getRenderElementsCount(): number;
        protected detoryResource(): void;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        _render(state: laya.d3.core.render.RenderState): void;
        /**NATIVE*/
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>QuadMesh</code> 类用于创建四边形。
     */
    class QuadMesh extends PrimitiveMesh {
        /**
         * 返回长度
         * @return 长
         */
        /**
         * 设置长度（改变此属性会重新生成顶点和索引）
         * @param  value 长度
         */
        long: number;
        /**
         * 返回宽度
         * @return 宽
         */
        /**
         * 设置宽度（改变此属性会重新生成顶点和索引）
         * @param  value 宽度
         */
        width: number;
        /**
         * 创建一个四边形模型
         * @param long  长
         * @param width 宽
         */
        constructor(long?: number, width?: number);
        protected recreateResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>Sky</code> 类用于创建天空的父类，抽象类不允许实例。
     */
    class Sky extends laya.resource.Resource {
        static MVPMATRIX: number;
        static INTENSITY: number;
        static ALPHABLENDING: number;
        static DIFFUSETEXTURE: number;
        protected __ownerCamera: laya.d3.core.BaseCamera;
        protected _alphaBlending: number;
        protected _colorIntensity: number;
        protected _vertexBuffer: laya.d3.graphics.VertexBuffer3D;
        protected _indexBuffer: laya.d3.graphics.IndexBuffer3D;
        protected _sharderNameID: number;
        protected _shader: laya.d3.shader.Shader3D;
        protected _shaderValue: laya.d3.shader.ValusArray;
        protected _shaderCompile: laya.d3.shader.ShaderCompile3D;
        protected _environmentDiffuse: laya.d3.resource.BaseTexture;
        protected _environmentSpecular: laya.d3.resource.BaseTexture;
        _conchSky: any;
        /**
         * @private
         */
        _ownerCamera: laya.d3.core.BaseCamera;
        /**
         * 获取透明混合度。
         * @return 透明混合度。
         */
        /**
         * 设置透明混合度。
         * @param value 透明混合度。
         */
        alphaBlending: number;
        /**
         * 获取颜色强度。
         * @return 颜色强度。
         */
        /**
         * 设置颜色强度。
         * @param value 颜色强度。
         */
        colorIntensity: number;
        /**
         * 获取环境漫反射贴图。
         * @return 环境漫反射贴图。
         */
        /**
         * 设置环境漫反射贴图。
         * @param value 环境漫反射贴图。
         */
        environmentDiffuse: laya.d3.resource.BaseTexture;
        /**
         * 获取环境高光贴图。
         * @return 环境高光贴图。
         */
        /**
         * 设置环境高光贴图。
         * @param value 环境高光贴图。
         */
        environmentSpecular: laya.d3.resource.BaseTexture;
        envDiffuseSHRed: Float32Array;
        envDiffuseSHGreen: Float32Array;
        envDiffuseSHBlue: Float32Array;
        /**
         *
         * 创建一个 <code>Sky</code> 实例。
         */
        constructor();
        /**
         * @private
         */
        _render(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>Sky</code> 类用于创建天空盒。
     */
    class SkyBox extends Sky {
        private static _tempMatrix4x40;
        private static _tempMatrix4x41;
        private static _nameNumber;
        /**
         * 获取天空立方体纹理。
         * @return 天空立方体纹理。
         */
        /**
         * 设置天空立方体纹理。
         * @param value 天空立方体纹理。
         */
        textureCube: laya.d3.resource.TextureCube;
        /**
         * 创建一个 <code>SkyBox</code> 实例。
         */
        constructor();
        protected _getShader(state: laya.d3.core.render.RenderState): laya.d3.shader.Shader3D;
        protected recreateResource(): void;
        protected loadShaderParams(): void;
        _render(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>Sky</code> 类用于创建天空盒。
     */
    class SkyDome extends Sky {
        private static _tempMatrix4x40;
        private static _tempMatrix4x41;
        private static _nameNumber;
        /**
         * 获取天空立方体纹理。
         * @return 天空立方体纹理。
         */
        /**
         * 设置天空立方体纹理。
         * @param value 天空立方体纹理。
         */
        texture: laya.d3.resource.Texture2D;
        /**
         * 创建一个 <code>SkyBox</code> 实例。
         */
        constructor();
        protected _getShader(state: laya.d3.core.render.RenderState): laya.d3.shader.Shader3D;
        protected recreateResource(): void;
        protected loadShaderParams(): void;
        _render(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>Sphere</code> 类用于创建球体。
     */
    class SphereMesh extends PrimitiveMesh {
        /**
         * 返回半径
         * @return 半径
         */
        /**
         * 设置半径（改变此属性会重新生成顶点和索引）
         * @param  value 半径
         */
        radius: number;
        /**
         * 获取宽度分段
         * @return 宽度分段
         */
        /**
         * 设置宽度分段（改变此属性会重新生成顶点和索引）
         * @param  value 宽度分段
         */
        slices: number;
        /**
         * 获取高度分段
         * @return 高度分段
         */
        /**
         * 设置高度分段（改变此属性会重新生成顶点和索引）
         * @param  value高度分段
         */
        stacks: number;
        /**
         * 创建一个球体模型
         * @param radius 半径
         * @param stacks 水平层数
         * @param slices 垂直层数
         */
        constructor(radius?: number, stacks?: number, slices?: number);
        protected recreateResource(): void;
    }
}
declare module laya.d3.resource.models {
    /**
     * <code>SubMesh</code> 类用于创建子网格数据模板。
     */
    class SubMesh implements laya.d3.core.render.IRenderable, laya.resource.IDispose {
        _boneIndicesList: Array<any>;
        _subIndexBufferStart: Array<any>;
        _subIndexBufferCount: Array<any>;
        _skinAnimationDatas: Array<any>;
        _bufferUsage: any;
        _indexInMesh: number;
        _vertexBuffer: laya.d3.graphics.VertexBuffer3D;
        _vertexBufferStart: number;
        __vertexBufferCount: number;
        _indexBuffer: laya.d3.graphics.IndexBuffer3D;
        _indexBufferStart: number;
        _indexBufferCount: number;
        /**
         * @private
         */
        _vertexBufferCount: number;
        /**
         * @private
         */
        indexOfHost: number;
        /**
         * @private
         */
        triangleCount: number;
        /**
         * 创建一个 <code>SubMesh</code> 实例。
         * @param	mesh  网格数据模板。
         */
        constructor(mesh: laya.d3.resource.models.Mesh);
        /**
         * @private
         */
        _getVertexBuffer(index?: number): laya.d3.graphics.VertexBuffer3D;
        /**
         * @private
         */
        _getIndexBuffer(): laya.d3.graphics.IndexBuffer3D;
        /**
         * @private
         */
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        /**NATIVE*/
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
        /**
         * @private
         * 渲染。
         * @param	state 渲染状态。
         */
        _render(state: laya.d3.core.render.RenderState): void;
        /**
         * <p>彻底清理资源。</p>
         * <p><b>注意：</b>会强制解锁清理。</p>
         */
        dispose(): void;
    }
}
declare module laya.d3.resource {
    /**
     * <code>RenderTarget</code> 类用于创建渲染目标。
     */
    class RenderTexture extends BaseTexture {
        private static _currentRenderTarget;
        /**
         * 获取表面格式。
         *@return 表面格式。
         */
        surfaceFormat: number;
        /**
         * 获取表面类型。
         *@return 表面类型。
         */
        surfaceType: number;
        /**
         * 获取深度格式。
         *@return 深度格式。
         */
        depthStencilFormat: number;
        frameBuffer: any;
        depthStencilBuffer: any;
        /**
         * 获取RenderTarget数据源,如果alreadyResolved等于false，则返回null。
         * @return RenderTarget数据源。
         */
        source: any;
        /**
         * 创建一个 <code>RenderTarget</code> 实例。
         * @param	width  宽度。
         * @param	height  高度。
         * @param	mipMap  是否生成mipMap。
         * @param	surfaceFormat  表面格式。
         *   @param	surfaceType  表面类型。
         *   @param	depthFormat  深度格式。
         */
        constructor(width: number, height: number, surfaceFormat?: number, surfaceType?: number, depthStencilFormat?: number, mipMap?: boolean, repeat?: boolean, minFifter?: number, magFifter?: number);
        protected recreateResource(): void;
        /**
         * 开始绑定。
         */
        start(): void;
        /**
         * 结束绑定。
         */
        end(): void;
        /**
         * 获得像素数据。
         * @param x X像素坐标。
         * @param y Y像素坐标。
         * @param width 宽度。
         * @param height 高度。
         * @return 像素数据。
         */
        getData(x: number, y: number, width: number, height: number): Uint8Array;
        protected detoryResource(): void;
    }
}
declare module laya.d3.resource {
    /**
     * <code>SolidColorTexture2D</code> 二维纯色纹理。
     */
    class SolidColorTexture2D extends BaseTexture {
        /**洋红色纯色纹理。*/
        static magentaTexture: SolidColorTexture2D;
        /**灰色纯色纹理。*/
        static grayTexture: SolidColorTexture2D;
        source: any;
        /**
         * 创建一个 <code>SolidColorTexture2D</code> 实例。
         */
        constructor(color: laya.d3.math.Vector4);
        protected recreateResource(): void;
        protected detoryResource(): void;
    }
}
declare module laya.d3.resource {
    class SolidColorTextureCube extends BaseTexture {
        /**洋红色纯色纹理。*/
        /**灰色纯色纹理。*/
        constructor(color: laya.d3.math.Vector4);
        protected recreateResource(): void;
        protected detoryResource(): void;
    }
}
declare module laya.d3.resource.tempelet {
    /**
     * @private
     * <code>GlitterTemplet</code> 类用于创建闪光数据模板。
     */
    class GlitterTemplet extends laya.d3.core.GeometryFilter implements laya.d3.core.render.IRenderable {
        _albedo: laya.d3.math.Vector4;
        _currentTime: number;
        /** 声明周期。 */
        lifeTime: number;
        /** 最小分段距离。 */
        minSegmentDistance: number;
        /** 最小插值距离。 */
        minInterpDistance: number;
        /** 最大插值数量。 */
        maxSlerpCount: number;
        /** 颜色。 */
        color: laya.d3.math.Vector4;
        /** 最大段数。 */
        _maxSegments: number;
        /**获取最大分段数。*/
        /**设置最大分段数,注意:谨慎修改此属性，有性能损耗。*/
        maxSegments: number;
        indexOfHost: number;
        _vertexBufferCount: number;
        triangleCount: number;
        _getVertexBuffer(index?: number): laya.d3.graphics.VertexBuffer3D;
        _getIndexBuffer(): laya.d3.graphics.IndexBuffer3D;
        /**
         * @inheritDoc
         */
        _originalBoundingSphere: laya.d3.math.BoundSphere;
        /**
         * @inheritDoc
         */
        _originalBoundingBox: laya.d3.math.BoundBox;
        constructor(owner: laya.d3.core.glitter.Glitter);
        _onActiveHierarchyChanged(active: boolean): void;
        /**
         * @private
         * 更新闪光。
         * @param	elapsedTime 间隔时间
         */
        _update(elapsedTime: number): void;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        /**
         * @private
         * 渲染闪光。
         * @param	state 相关渲染状态
         */
        _render(state: laya.d3.core.render.RenderState): void;
        /**
         * 通过位置添加刀光。
         * @param position0 位置0。
         * @param position1 位置1。
         */
        addVertexPosition(position0: laya.d3.math.Vector3, position1: laya.d3.math.Vector3): void;
        /**
         * 通过位置和速度添加刀光。
         * @param position0 位置0。
         * @param velocity0 速度0。
         * @param position1 位置1。
         * @param velocity1 速度1。
         */
        addVertexPositionVelocity(position0: laya.d3.math.Vector3, velocity0: laya.d3.math.Vector3, position1: laya.d3.math.Vector3, velocity1: laya.d3.math.Vector3): void;
        _destroy(): void;
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.resource.tempelet {
    /**
     * @private
     * <code>ParticleTemplet3D</code> 类用于创建3D粒子数据模板。
     */
    class ParticleTemplet3D extends laya.particle.ParticleTemplateWebGL implements laya.d3.core.render.IRenderable {
        indexOfHost: number;
        _vertexBufferCount: number;
        triangleCount: number;
        _getVertexBuffer(index?: number): laya.d3.graphics.VertexBuffer3D;
        _getIndexBuffer(): laya.d3.graphics.IndexBuffer3D;
        constructor(owner: laya.d3.core.particle.Particle3D, setting: laya.particle.ParticleSetting);
        addParticle(position: laya.d3.math.Vector3, velocity: laya.d3.math.Vector3): void;
        protected loadContent(): void;
        addNewParticlesToVertexBuffer(): void;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        _render(state: laya.d3.core.render.RenderState): void;
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.resource {
    /**
     * <code>Texture2D</code> 二维纹理。
     */
    class Texture2D extends BaseTexture {
        /**
         * 加载Texture2D。
         * @param url Texture2D地址。
         */
        static load(url: string): Texture2D;
        /**
         * 获取文件路径全名。
         */
        src: string;
        /**
         * 创建一个 <code>Texture2D</code> 实例。
         */
        constructor(canRead?: boolean);
        protected recreateResource(): void;
        /**
         *@private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * 返回图片像素。
         * @return 图片像素。
         */
        getPixels(): Uint8Array;
        protected detoryResource(): void;
    }
}
declare module laya.d3.resource {
    class TextureCube extends BaseTexture {
        /**灰色纯色纹理。*/
        /**
         * 加载TextureCube。
         * @param url TextureCube地址。
         */
        static load(url: string): TextureCube;
        protected _srcs: string;
        protected _recreateLock: boolean;
        protected _needReleaseAgain: boolean;
        /**
         * 文件路径全名。
         */
        srcs: string;
        /**
         * @inheritDoc
         */
        defaulteTexture: BaseTexture;
        constructor();
        protected recreateResource(): void;
        /**
         * @private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        protected detoryResource(): void;
    }
}
declare module laya.d3.shader {
    class Shader3D extends laya.webgl.shader.BaseShader {
        /**shader变量提交周期，逐渲染单元。*/
        static PERIOD_RENDERELEMENT: number;
        /**shader变量提交周期，逐材质。*/
        static PERIOD_MATERIAL: number;
        /**shader变量提交周期，逐精灵和相机，注：因为精灵包含MVP矩阵，为复合属性，所以摄像机发生变化时也应提交。*/
        static PERIOD_SPRITE: number;
        /**shader变量提交周期，逐相机。*/
        static PERIOD_CAMERA: number;
        /**shader变量提交周期，逐场景。*/
        static PERIOD_SCENE: number;
        private static _TEXTURES;
        static _includeFiles: any;
        private static _count;
        protected static shaderParamsMap: any;
        static nameKey: laya.utils.StringKey;
        static create(vs: string, ps: string, attributeMap: any, sceneUniformMap: any, cameraUniformMap: any, spriteUniformMap: any, materialUniformMap: any, renderElementUniformMap: any): Shader3D;
        static addInclude(fileName: string, txt: string): void;
        _vshader: any;
        _pshader: any;
        _program: any;
        _attributeParams: Array<any>;
        _uniformParams: Array<any>;
        _attributeParamsMap: Array<any>;
        _sceneUniformParamsMap: Array<any>;
        _cameraUniformParamsMap: Array<any>;
        _spriteUniformParamsMap: Array<any>;
        _materialUniformParamsMap: Array<any>;
        _renderElementUniformParamsMap: Array<any>;
        _id: number;
        _uploadLoopCount: number;
        _uploadRenderElement: laya.d3.core.render.RenderElement;
        _uploadMaterial: laya.d3.core.material.BaseMaterial;
        _uploadSprite3D: laya.d3.core.Sprite3D;
        _uploadCamera: laya.d3.core.BaseCamera;
        _uploadScene: laya.d3.core.scene.BaseScene;
        _uploadVertexBuffer: laya.d3.graphics.VertexBuffer3D;
        /**
         * 根据vs和ps信息生成shader对象
         * @param	vs
         * @param	ps
         * @param	name:
         * @param	nameMap 帮助里要详细解释为什么需要nameMap
         */
        constructor(vs: string, ps: string, attributeMap: any, sceneUniformMap: any, cameraUniformMap: any, spriteUniformMap: any, materialUniformMap: any, renderElementUniformMap: any);
        protected recreateResource(): void;
        protected detoryResource(): void;
        uploadTexture2D(value: any): void;
        bind(): boolean;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadAttributes(attributeShaderValue: Array<any>, _bufferUsage: any): void;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadSceneUniforms(shaderValue: Array<any>): void;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadCameraUniforms(shaderValue: Array<any>): void;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadSpriteUniforms(shaderValue: Array<any>): void;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadMaterialUniforms(shaderValue: Array<any>): void;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadRenderElementUniforms(shaderValue: Array<any>): void;
        protected _preGetParams(vs: string, ps: string): any;
        dispose(): void;
    }
}
declare module laya.d3.shader {
    class ShaderCompile3D {
        /**是否开启调试模式。 */
        static debugMode: boolean;
        static SHADERDEFINE_FSHIGHPRECISION: number;
        static SHADERDEFINE_VR: number;
        static SHADERDEFINE_FOG: number;
        static SHADERDEFINE_DIRECTIONLIGHT: number;
        static SHADERDEFINE_POINTLIGHT: number;
        static SHADERDEFINE_SPOTLIGHT: number;
        static SHADERDEFINE_UV0: number;
        static SHADERDEFINE_COLOR: number;
        static SHADERDEFINE_UV1: number;
        static SAHDERDEFINE_DEPTHFOG: number;
        private static DEFINEREG;
        private static INCLUDE;
        private static _globalInt2name;
        static _preCompileShader: any;
        static IFDEF_NO: number;
        static IFDEF_YES: number;
        static IFDEF_ELSE: number;
        /**
         * @private
         */
        static __init__(): void;
        /**
         * 添加预编译shader文件，主要是处理宏定义
         * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
         * @param	vs
         * @param	ps
         */
        static add(nameID: number, vs: string, ps: string, attributeMap: any, uniformMap: any): ShaderCompile3D;
        /**
         * 获取ShaderCompile3D。
         * @param	name
         * @return ShaderCompile3D。
         */
        static get(name: string): ShaderCompile3D;
        sharders: Array<any>;
        _materialInt2name: Array<any>;
        _spriteInt2name: Array<any>;
        _conchShader: any;
        constructor(name: number, vs: string, ps: string, attributeMap: any, uniformMap: any, includeFiles: any);
        /**
         * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
         * @param	name
         * @param	vs
         * @param	ps
         * @param	define 宏定义，格式:
         * @return
         */
        withCompile(nameID: number, publicDefine: number, spriteDefine: number, materialDefine: number): Shader3D;
        createShader(publicDefine: any, spriteDefine: any, materialDefine: any): Shader3D;
        /**
         * 通过宏定义预编译shader。
         * @param	spriteIntToNameDic 精灵宏定义数组。
         * @param	publicDefine 公共宏定义值。
         * @param	spriteDefine 精灵宏定义值。
         * @param	materialDefine 材质宏定义值。
         */
        precompileShaderWithShaderDefine(publicDefine: number, spriteDefine: number, materialDefine: number): void;
        /**
         * 注册材质宏定义。
         * @param	name 宏定义名称。
         * @return
         */
        registerMaterialDefine(name: string): number;
        /**
         * 注册精灵宏定义。
         * @param	name 宏定义名称。
         * @return
         */
        registerSpriteDefine(name: string): number;
        definesToNameDic(value: number, int2Name: Array<any>): any;
    }
    class ShaderScriptBlock {
        type: number;
        condition: Function;
        text: string;
        childs: Array<any>;
        parent: ShaderScriptBlock;
        ShaderScriptBlock(type: number, condition: string, text: string, parent: ShaderScriptBlock): any;
        toscript(def: any, out: Array<any>): Array<any>;
    }
}
declare module laya.d3.shader {
    /**
     * @private
     * <code>Shader3D</code> 主要用数组的方式保存shader变量定义，后期合并ShaderValue不使用for in，性能较高。
     */
    class ValusArray {
        constructor();
        setValue(name: number, value: any): void;
        data: Array<any>;
    }
}
declare module laya.d3.shadowMap {
    /**
     * ...
     * @author ...
     */
    class ParallelSplitShadowMap {
        static SHADERDEFINE_RECEIVE_SHADOW: number;
        static SHADERDEFINE_CAST_SHADOW: number;
        static SHADERDEFINE_SHADOW_PSSM1: number;
        static SHADERDEFINE_SHADOW_PSSM2: number;
        static SHADERDEFINE_SHADOW_PSSM3: number;
        static SHADERDEFINE_SHADOW_PCF_NO: number;
        static SHADERDEFINE_SHADOW_PCF1: number;
        static SHADERDEFINE_SHADOW_PCF2: number;
        static SHADERDEFINE_SHADOW_PCF3: number;
        static MAX_PSSM_COUNT: number;
        _lightCulling: Array<any>;
        _renderTarget: Array<any>;
        _lightVPMatrix: Array<any>;
        _shadowQuenes: Array<any>;
        _boundingBox: Array<any>;
        constructor();
        setInfo(scene: laya.d3.core.scene.BaseScene, maxDistance: number, globalParallelDir: laya.d3.math.Vector3, shadowMapTextureSize: number, numberOfPSSM: number, PCFType: number): void;
        setPCFType(PCFtype: number): void;
        getPCFType(): number;
        setFarDistance(value: number): void;
        getFarDistance(): number;
        PSSMNum: number;
        _setGlobalParallelLightDir(dir: laya.d3.math.Vector3): void;
        getGlobalParallelLightDir(): laya.d3.math.Vector3;
        getCurrentPSSM(): number;
        getLightCamera(index: number): laya.d3.core.Camera;
        /**
         * @private
         */
        endSampler(sceneCamera: laya.d3.core.BaseCamera): void;
        /**
         * @private
         */
        _calcAllLightCameraInfo(sceneCamera: laya.d3.core.BaseCamera): void;
        /**
         * @private
         */
        _calcBoundingBox(fieldOfView: number, aspectRatio: number): void;
        calcSplitFrustum(sceneCamera: laya.d3.core.BaseCamera): void;
        /**
         * 计算两个矩阵的乘法
         * @param	left left矩阵
         * @param	right  right矩阵
         * @param	out  输出矩阵
         */
        static multiplyMatrixOutFloat32Array(left: laya.d3.math.Matrix4x4, right: laya.d3.math.Matrix4x4, out: Float32Array): void;
        getLightFrustumCulling(currentPSSM: number): laya.d3.math.BoundFrustum;
        getSplitFrustumCulling(): laya.d3.math.BoundFrustum;
        getSplitDistance(index: number): number;
        setShadowMapTextureSize(size: number): void;
        getShadowMapTextureSize(): number;
        beginRenderTarget(index: number): void;
        endRenderTarget(index: number): void;
        getRenderTarget(index: number): laya.d3.resource.RenderTexture;
        disposeAllRenderTarget(): void;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>Terrain</code> 类用于创建地块。
     */
    class Terrain extends laya.d3.core.Sprite3D {
        static RENDER_LINE_MODEL: boolean;
        static LOD_TOLERANCE_VALUE: number;
        static LOD_DISTANCE_FACTOR: number;
        _terrainRes: TerrainRes;
        /**
         * 加载网格模板,注意:不缓存。
         * @param url 模板地址。
         */
        static load(url: string): Terrain;
        /**
         * 创建一个 <code>MeshSprite3D</code> 实例。
         * @param mesh 网格,同时会加载网格所用默认材质。
         * @param name 名字。
         */
        constructor(terrainRes: TerrainRes);
        buildTerrain(terrainRes: TerrainRes): void;
        /**
         * 获取地形X轴长度。
         * @return  地形X轴长度。
         */
        width(): number;
        /**
     * 获取地形Z轴长度。
     * @return  地形Z轴长度。
     */
        depth(): number;
        /**
         * 获取地形高度。
         * @param x X轴坐标。
         * @param z Z轴坐标。
         */
        getHeightXZ(x: number, z: number): number;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>TerrainChunk</code> 类用于创建地块。
     */
    class TerrainChunk extends laya.d3.core.RenderableSprite3D {
        /**
         * 加载网格模板,注意:不缓存。
         * @param url 模板地址。
         */
        static load(url: string): TerrainChunk;
        /**
         * 获取地形过滤器。
         * @return  地形过滤器。
         */
        terrainFilter: TerrainFilter;
        /**
         * 获取地形渲染器。
         * @return  地形渲染器。
         */
        terrainRender: TerrainRender;
        /**
         * 创建一个 <code>MeshSprite3D</code> 实例。
         * @param mesh 网格,同时会加载网格所用默认材质。
         * @param name 名字。
         */
        constructor(chunkOffsetX: number, chunkOffsetZ: number, girdSize: number, terrainHeightData: Float32Array, heightDataWidth: number, heightDataHeight: number, name?: string);
        /**
         * @private
         */
        createConchModel(): any;
        protected _clearSelfRenderObjects(): void;
        protected _addSelfRenderObjects(): void;
        /**
         * @private
         */
        _applyMeshMaterials(mesh: laya.d3.resource.models.Mesh): void;
        /**
         * @private
         */
        _renderUpdate(projectionView: laya.d3.math.Matrix4x4): void;
        cloneTo(destObject: any): void;
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>TerrainFilter</code> 类用于创建TerrainFilter过滤器。
     */
    class TerrainFilter extends laya.d3.core.GeometryFilter implements laya.d3.core.render.IRenderable {
        static _TEMP_ARRAY_BUFFER: Uint32Array;
        _owner: TerrainChunk;
        _indexOfHost: number;
        _gridSize: number;
        memorySize: number;
        protected _numberVertices: number;
        protected _maxNumberIndices: number;
        protected _currentNumberIndices: number;
        protected _numberTriangle: number;
        protected _vertexBuffer: laya.d3.graphics.VertexBuffer3D;
        protected _indexBuffer: laya.d3.graphics.IndexBuffer3D;
        protected _boundingSphere: laya.d3.math.BoundSphere;
        protected _boundingBox: laya.d3.math.BoundBox;
        protected _indexArrayBuffer: Uint16Array;
        _boundingBoxCorners: Array<any>;
        /**
         * 创建一个新的 <code>MeshFilter</code> 实例。
         * @param owner 所属网格精灵。
         */
        constructor(owner: TerrainChunk, chunkOffsetX: number, chunkOffsetZ: number, gridSize: number, terrainHeightData: Float32Array, heightDataWidth: number, heightDataHeight: number);
        /**
         * @inheritDoc
         */
        _originalBoundingSphere: laya.d3.math.BoundSphere;
        /**
         * @inheritDoc
         */
        _originalBoundingBox: laya.d3.math.BoundBox;
        /**
         * @inheritDoc
         */
        _destroy(): void;
        protected recreateResource(): void;
        protected assembleIndexInit(): void;
        protected isNeedAssemble(camera: laya.d3.core.Camera, cameraPostion: laya.d3.math.Vector3): number;
        protected assembleIndex(camera: laya.d3.core.Camera, cameraPostion: laya.d3.math.Vector3): boolean;
        calcOriginalBoudingBoxAndSphere(): void;
        calcLeafBoudingBox(worldMatrix: laya.d3.math.Matrix4x4): void;
        calcLeafBoudingSphere(worldMatrix: laya.d3.math.Matrix4x4, maxScale: number): void;
        _vertexBufferCount: number;
        indexOfHost: number;
        triangleCount: number;
        _getVertexBuffer(index?: number): laya.d3.graphics.VertexBuffer3D;
        _getIndexBuffer(): laya.d3.graphics.IndexBuffer3D;
        _beforeRender(state: laya.d3.core.render.RenderState): boolean;
        _render(state: laya.d3.core.render.RenderState): void;
        _renderRuntime(conchGraphics3D: any, renderElement: laya.d3.core.render.RenderElement, state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>TerrainHeightData</code> 类用于描述地形高度信息。
     */
    class TerrainHeightData extends laya.resource.Resource {
        _terrainHeightData: Float32Array;
        _width: number;
        _height: number;
        _bitType: number;
        _value: number;
        /**
         * 加载地形高度模板,注意:不缓存。
         * @param url 模板地址。
         * @param width 高度图的宽。
         * @param height 高度图的高。
         */
        static load(url: string, widht: number, height: number, bitType: number, value: number): TerrainHeightData;
        /**
         * 创建一个 <code>TerrainHeightData</code> 实例。
         */
        constructor();
        /**
         * 异步回调
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>TerrainLeaf</code> Terrain的叶子节点
     */
    class TerrainLeaf {
        static CHUNK_GRID_NUM: number;
        static LEAF_GRID_NUM: number;
        static LEAF_PLANE_VERTEXT_COUNT: number;
        static LEAF_SKIRT_VERTEXT_COUNT: number;
        static LEAF_VERTEXT_COUNT: number;
        static LEAF_PLANE_MAX_INDEX_COUNT: number;
        static LEAF_SKIRT_MAX_INDEX_COUNT: number;
        static LEAF_MAX_INDEX_COUNT: number;
        private static _maxLODLevel;
        private static _planeLODIndex;
        private static _skirtLODIndex;
        private static _bInit;
        _boundingSphere: laya.d3.math.BoundSphere;
        _boundingBox: laya.d3.math.BoundBox;
        _sizeOfY: laya.d3.math.Vector2;
        _currentLODLevel: number;
        static __init__(): void;
        static getPlaneLODIndex(leafIndex: number, LODLevel: number): Uint16Array;
        static getSkirtLODIndex(leafIndex: number, LODLevel: number): Uint16Array;
        static getHeightFromTerrainHeightData(x: number, z: number, terrainHeightData: Float32Array, heighDataWidth: number, heightDataHeight: number): number;
        /**
         * 创建一个新的 <code>TerrainLeaf</code> 实例。
         * @param owner 地形的叶子。
         */
        constructor();
        calcVertextNorml(x: number, z: number, terrainHeightData: Float32Array, heighDataWidth: number, heightDataHeight: number, normal: laya.d3.math.Vector3): void;
        calcVertextNormlUV(x: number, z: number, terrainWidth: number, terrainHeight: number, normal: laya.d3.math.Vector3): void;
        calcOriginalBoudingBoxAndSphere(): void;
        calcLeafBoudingBox(worldMatrix: laya.d3.math.Matrix4x4): void;
        calcLeafBoudingSphere(worldMatrix: laya.d3.math.Matrix4x4, maxScale: number): void;
        calcLODErrors(terrainHeightData: Float32Array, heighDataWidth: number, heightDataHeight: number): void;
        determineLod(eyePos: laya.d3.math.Vector3, perspectiveFactor: number, tolerance: number, tolerAndPerspectiveChanged: boolean): number;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>MeshRender</code> 类用于网格渲染器。
     */
    class TerrainRender extends laya.d3.core.render.BaseRender {
        /**
         * 创建一个新的 <code>MeshRender</code> 实例。
         */
        constructor(owner: TerrainChunk);
        protected _calculateBoundingSphere(): void;
        protected _calculateBoundingBox(): void;
        /**
         * @private
         */
        _destroy(): void;
    }
}
declare module laya.d3.terrain {
    /**
     * <code>TerrainRes</code> 类用于描述地形信息。
     */
    class TerrainRes extends laya.resource.Resource {
        _version: number;
        _gridSize: number;
        _chunkNumX: number;
        _chunkNumZ: number;
        _heightDataX: number;
        _heightDataZ: number;
        _heightDataBitType: number;
        _heightDataValue: number;
        _heightDataUrl: string;
        _detailTextureInfos: Array<any>;
        _chunkInfos: Array<any>;
        _heightData: TerrainHeightData;
        /**
         * 加载地形模板,注意:不缓存。
         * @param url 模板地址。
         */
        static load(url: string): TerrainRes;
        /**
         * 创建一个 <code>TerrainHeightData</code> 实例。
         */
        constructor();
        parseData(data: any, path: string): boolean;
        onLoadTerrainComplete(heightData: TerrainHeightData): void;
        /**
         * 异步回调
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
    }
}
declare module laya.d3.terrain.unit {
    /**
     * <code>DetailTextureInfo</code> 类用于描述地形细节纹理。
     */
    class ChunkInfo {
        alphaMap: Array<any>;
        detailID: Array<any>;
        normalMap: string;
        constructor();
    }
}
declare module laya.d3.terrain.unit {
    /**
     * <code>DetailTextureInfo</code> 类用于描述地形细节纹理。
     */
    class DetailTextureInfo {
        diffuseTexture: string;
        normalTexture: string;
        scale: laya.d3.math.Vector2;
        offset: laya.d3.math.Vector2;
        constructor();
    }
}
declare module laya.d3.utils {
    /**
     * <code>Physics</code> 类用于简单物理检测。
     */
    class Physics {
        private static _outHitAllInfo;
        private static _outHitInfo;
        constructor();
        /**
         * 在场景中投下可与所有碰撞器碰撞的一条光线,获取发生碰撞的第一个碰撞器。
         * @param  ray        射线
         * @param  outHitInfo 与该射线发生碰撞的第一个碰撞器的碰撞信息
         * @param  distance   射线长度,默认为最大值
         * @param  layer      选定制定层内的碰撞器,其他层内碰撞器忽略
         */
        static rayCast(ray: laya.d3.math.Ray, outHitInfo: RaycastHit, distance?: number, layer?: number): void;
        /**
         * 在场景中投下可与所有碰撞器碰撞的一条光线,获取发生碰撞的所有碰撞器。
         * @param  ray        射线
         * @param  outHitAllInfo 与该射线发生碰撞的所有碰撞器的碰撞信息
         * @param  distance   射线长度,默认为最大值
         * @param  layer      选定制定层内的碰撞器,其他层内碰撞器忽略
         */
        static rayCastAll(ray: laya.d3.math.Ray, outHitAllInfo: Array<any>, distance?: number, layer?: number): void;
    }
}
declare module laya.d3.utils {
    /**
     * <code>Picker</code> 类用于创建拾取。
     */
    class Picker {
        private static _tempVector30;
        private static _tempVector31;
        private static _tempVector32;
        private static _tempVector33;
        private static _tempVector34;
        private static _tempVector35;
        private static _tempVector36;
        private static _tempVector37;
        /**
         * 创建一个 <code>Picker</code> 实例。
         */
        constructor();
        /**
         * 计算鼠标生成的射线。
         * @param	point 鼠标位置。
         * @param	viewPort 视口。
         * @param	projectionMatrix 透视投影矩阵。
         * @param	viewMatrix 视图矩阵。
         * @param	world 世界偏移矩阵。
         * @return  out  输出射线。
         */
        static calculateCursorRay(point: laya.d3.math.Vector2, viewPort: laya.d3.math.Viewport, projectionMatrix: laya.d3.math.Matrix4x4, viewMatrix: laya.d3.math.Matrix4x4, world: laya.d3.math.Matrix4x4, out: laya.d3.math.Ray): void;
        /**
         * 计算射线和三角形碰撞并返回碰撞三角形和碰撞距离。
         * @param	ray 射线。
         * @param	positions 顶点数据。
         * @param	indices 索引数据。
         * @param	outVertex0 输出三角形顶点0。
         * @param	outVertex1 输出三角形顶点1。
         * @param	outVertex2 输出三角形顶点2。
         * @return   射线距离三角形的距离，返回Number.NaN则不相交。
         */
        static rayIntersectsPositionsAndIndices(ray: laya.d3.math.Ray, vertexDatas: Float32Array, vertexDeclaration: laya.d3.graphics.VertexDeclaration, indices: Uint16Array, outHitInfo: RaycastHit): boolean;
        /**
         * 计算射线和三角形碰撞并返回碰撞距离。
         * @param	ray 射线。
         * @param	vertex1 顶点1。
         * @param	vertex2 顶点2。
         * @param	vertex3 顶点3。
         * @return   射线距离三角形的距离，返回Number.NaN则不相交。
         */
        static rayIntersectsTriangle(ray: laya.d3.math.Ray, vertex1: laya.d3.math.Vector3, vertex2: laya.d3.math.Vector3, vertex3: laya.d3.math.Vector3): number;
    }
}
declare module laya.d3.utils {
    /**
     * ...
     * @author ...
     */
    class RaycastHit {
        distance: number;
        trianglePositions: Array<any>;
        triangleNormals: Array<any>;
        position: laya.d3.math.Vector3;
        sprite3D: laya.d3.core.Sprite3D;
        constructor();
        cloneTo(dec: RaycastHit): void;
    }
}
declare module laya.d3.utils {
    class Size {
        static fullScreen: Size;
        width: number;
        height: number;
        constructor(width: number, height: number);
    }
}
declare module laya.d3.utils {
    /**
     * <code>Utils3D</code> 类用于创建3D工具。
     */
    class Utils3D {
        private static _tempVector3_0;
        private static _tempVector3_1;
        private static _tempVector3_2;
        private static _tempVector3_3;
        private static _tempVector3_4;
        private static _tempVector3_5;
        private static _tempVector3_6;
        private static _tempArray4_0;
        private static _tempArray16_0;
        private static _tempArray16_1;
        private static _tempArray16_2;
        private static _tempArray16_3;
        static _loadParticle(settting: any, particle: laya.d3.core.particleShuriKen.ShuriKenParticle3D, innerResouMap?: any): void;
        static _parseHierarchyProp(innerResouMap: any, node: laya.d3.core.Sprite3D, json: any): void;
        static _parseHierarchyNode(json: any): laya.d3.core.Sprite3D;
        static _computeBoneAndAnimationDatas(bones: any, curData: Float32Array, exData: Float32Array, outBonesDatas: Float32Array, outAnimationDatas: Float32Array): void;
        static _computeAnimationDatas(exData: Float32Array, bonesDatas: Float32Array, outAnimationDatas: Float32Array): void;
        static _computeBoneAndAnimationDatasByBindPoseMatrxix(bones: any, curData: Float32Array, inverGlobalBindPose: Array<any>, outBonesDatas: Float32Array, outAnimationDatas: Float32Array, boneIndexToMesh: Array<any>): void;
        static _computeAnimationDatasByArrayAndMatrixFast(inverGlobalBindPose: Array<any>, bonesDatas: Float32Array, outAnimationDatas: Float32Array, boneIndexToMesh: Array<any>): void;
        static _computeBoneAndAnimationDatasByBindPoseMatrxixOld(bones: any, curData: Float32Array, inverGlobalBindPose: Array<any>, outBonesDatas: Float32Array, outAnimationDatas: Float32Array): void;
        static _computeAnimationDatasByArrayAndMatrixFastOld(inverGlobalBindPose: Array<any>, bonesDatas: Float32Array, outAnimationDatas: Float32Array): void;
        static _computeRootAnimationData(bones: any, curData: Float32Array, animationDatas: Float32Array): void;
        /**
         * @private
         */
        testTangent(renderElement: laya.d3.core.render.RenderElement, vertexBuffer: laya.d3.graphics.VertexBuffer3D, indeBuffer: laya.d3.graphics.IndexBuffer3D, bufferUsage: any): laya.d3.graphics.VertexBuffer3D;
        static generateTangent(vertexDatas: Float32Array, vertexStride: number, positionOffset: number, uvOffset: number, indices: Uint16Array): Float32Array;
        static getVertexTangentDeclaration(vertexElements: Array<any>): laya.d3.graphics.VertexDeclaration;
        /**
         * 根据四元数旋转三维向量。
         * @param	source 源三维向量。
         * @param	rotation 旋转四元数。
         * @param	out 输出三维向量。
         */
        static transformVector3ArrayByQuat(sourceArray: Float32Array, sourceOffset: number, rotation: laya.d3.math.Quaternion, outArray: Float32Array, outOffset: number): void;
        /**
         *通过数组数据计算矩阵乘法。
         * @param leftArray left矩阵数组。
         * @param leftOffset left矩阵数组的偏移。
         * @param rightArray right矩阵数组。
         * @param rightOffset right矩阵数组的偏移。
         * @param outArray 输出矩阵数组。
         * @param outOffset 输出矩阵数组的偏移。
         */
        static mulMatrixByArray(leftArray: Float32Array, leftOffset: number, rightArray: Float32Array, rightOffset: number, outArray: Float32Array, outOffset: number): void;
        /**
         *通过数组数据计算矩阵乘法,rightArray和outArray不能为同一数组引用。
         * @param leftArray left矩阵数组。
         * @param leftOffset left矩阵数组的偏移。
         * @param rightArray right矩阵数组。
         * @param rightOffset right矩阵数组的偏移。
         * @param outArray 结果矩阵数组。
         * @param outOffset 结果矩阵数组的偏移。
         */
        static mulMatrixByArrayFast(leftArray: Float32Array, leftOffset: number, rightArray: Float32Array, rightOffset: number, outArray: Float32Array, outOffset: number): void;
        /**
         *通过数组数据计算矩阵乘法,rightArray和outArray不能为同一数组引用。
         * @param leftArray left矩阵数组。
         * @param leftOffset left矩阵数组的偏移。
         * @param rightMatrix right矩阵。
         * @param outArray 结果矩阵数组。
         * @param outOffset 结果矩阵数组的偏移。
         */
        static mulMatrixByArrayAndMatrixFast(leftArray: Float32Array, leftOffset: number, rightMatrix: laya.d3.math.Matrix4x4, outArray: Float32Array, outOffset: number): void;
        /**
         *通过数平移、旋转、缩放值计算到结果矩阵数组。
         * @param tX left矩阵数组。
         * @param tY left矩阵数组的偏移。
         * @param tZ right矩阵数组。
         * @param qX right矩阵数组的偏移。
         * @param qY 输出矩阵数组。
         * @param qZ 输出矩阵数组的偏移。
         * @param qW 输出矩阵数组的偏移。
         * @param sX 输出矩阵数组的偏移。
         * @param sY 输出矩阵数组的偏移。
         * @param sZ 输出矩阵数组的偏移。
         * @param outArray 结果矩阵数组。
         * @param outOffset 结果矩阵数组的偏移。
         */
        static createAffineTransformationArray(tX: number, tY: number, tZ: number, rX: number, rY: number, rZ: number, rW: number, sX: number, sY: number, sZ: number, outArray: Float32Array, outOffset: number): void;
        /**
         * 通过矩阵转换一个三维向量数组到另外一个归一化的三维向量数组。
         * @param	source 源三维向量所在数组。
         * @param	sourceOffset 源三维向量数组偏移。
         * @param	transform  变换矩阵。
         * @param	result 输出三维向量所在数组。
         * @param	resultOffset 输出三维向量数组偏移。
         */
        static transformVector3ArrayToVector3ArrayCoordinate(source: Float32Array, sourceOffset: number, transform: laya.d3.math.Matrix4x4, result: Float32Array, resultOffset: number): void;
        /**
         * @private
         */
        static transformLightingMapTexcoordByUV0Array(source: Float32Array, sourceOffset: number, lightingMapScaleOffset: laya.d3.math.Vector4, result: Float32Array, resultOffset: number): void;
        /**
         * @private
         */
        static transformLightingMapTexcoordByUV1Array(source: Float32Array, sourceOffset: number, lightingMapScaleOffset: laya.d3.math.Vector4, result: Float32Array, resultOffset: number): void;
        /**
         * 转换3D投影坐标系统到2D屏幕坐标系统，以像素为单位,通常用于正交投影下的3D坐标（（0，0）在屏幕中心）到2D屏幕坐标（（0，0）在屏幕左上角）的转换。
         * @param	source 源坐标。
         * @param	out 输出坐标。
         */
        static convert3DCoordTo2DScreenCoord(source: laya.d3.math.Vector3, out: laya.d3.math.Vector3): void;
        /**
         * 获取URL版本字符。
         * @param	url
         * @return
         */
        static getURLVerion(url: string): string;
    }
}
declare module laya.d3.water {
    /**
     * ...
     * @author ...
     */
    class WaterDetailMaterial extends laya.d3.core.material.BaseMaterial {
        static WAVEINFO: number;
        static WAVEINFOD: number;
        static WAVEMAINDIR: number;
        static TEXWAVE_UV_SCALE: number;
        constructor();
        static init(): void;
        currentTm: number;
        waveInfo: Float32Array;
        waveInfoD: Float32Array;
        texWaveUVScale: number;
    }
}
declare module laya.d3.water {
    /**
     * ...
     * @author ...
     */
    class WaterRender extends laya.d3.core.render.BaseRender {
        constructor(owner: laya.d3.core.Sprite3D);
        protected _calculateBoundingSphere(): void;
        protected _calculateBoundingBox(): void;
        _destroy(): void;
    }
}
declare module laya.d3.water {
    /**
     * ...
     * @author ...
     */
    class WaterSprite extends laya.d3.core.MeshSprite3D {
        mtl: laya.d3.core.material.WaterMaterial;
        detailMtl: WaterDetailMaterial;
        mesh: laya.d3.resource.models.Mesh;
        private static _waveInfoEleNum;
        static detailTexWidth: number;
        static detailTexHeight: number;
        private static deg2rad;
        private static _2pi;
        _scene: laya.d3.core.scene.Scene;
        constructor(mesh?: laya.d3.resource.models.BaseMesh, name?: string);
        src: string;
        onMeshLoaded(): void;
        stop(): void;
        addRefractObj(obj: laya.d3.core.RenderableSprite3D): void;
        /**
         * 渲染之前，生成必要的数据。
         * @param	state
         */
        onPreRender(state: laya.d3.core.render.RenderState): any;
        _update(state: laya.d3.core.render.RenderState): void;
    }
}
declare module laya.device.geolocation {
    /**
     * 使用前可用<code>supported</code>查看浏览器支持。
     */
    class Geolocation {
        private static navigator;
        private static position;
        /**
         * 由于权限被拒绝造成的地理信息获取失败。
         */
        static PERMISSION_DENIED: number;
        /**
         * 由于内部位置源返回了内部错误导致地理信息获取失败。
         */
        static POSITION_UNAVAILABLE: number;
        /**
         * 信息获取所用时长超出<code>timeout</code>所设置时长。
         */
        static TIMEOUT: number;
        /**
         * 是否支持。
         */
        static supported: boolean;
        /**
         * 如果<code>enableHighAccuracy</code>为true，并且设备能够提供一个更精确的位置，则会获取最佳可能的结果。
         * 请注意,这可能会导致较慢的响应时间或增加电量消耗（如使用GPS）。
         * 另一方面，如果设置为false，将会得到更快速的响应和更少的电量消耗。
         * 默认值为false。
         */
        static enableHighAccuracy: boolean;
        static timeout: number;
        /**
         * 表示可被返回的缓存位置信息的最大时限。
         * 如果设置为0，意味着设备不使用缓存位置，并且尝试获取实时位置。
         * 如果设置为Infinity，设备必须返回缓存位置而无论其时限。
         */
        static maximumAge: number;
        constructor();
        /**
         * 获取设备当前位置。
         * @param	onSuccess	带有唯一<code>Position</code>参数的回调处理器。
         * @param	onError		可选的。带有错误信息的回调处理器。错误代码为Geolocation.PERMISSION_DENIED、Geolocation.POSITION_UNAVAILABLE和Geolocation.TIMEOUT之一。
         */
        static getCurrentPosition(onSuccess: laya.utils.Handler, onError?: laya.utils.Handler): void;
        /**
         * 监视设备当前位置。回调处理器在设备位置改变时被执行。
         * @param	onSuccess	带有唯一<code>Position</code>参数的回调处理器。
         * @param	onError		可选的。带有错误信息的回调处理器。错误代码为Geolocation.PERMISSION_DENIED、Geolocation.POSITION_UNAVAILABLE和Geolocation.TIMEOUT之一。
         */
        static watchPosition(onSuccess: laya.utils.Handler, onError: laya.utils.Handler): number;
        /**
         * 移除<code>watchPosition</code>安装的指定处理器。
         * @param	id
         */
        static clearWatch(id: number): void;
    }
}
declare module laya.device.geolocation {
    class GeolocationInfo {
        setPosition(pos: any): void;
        latitude: number;
        longitude: number;
        altitude: number;
        accuracy: number;
        altitudeAccuracy: number;
        heading: number;
        speed: number;
        timestamp: number;
    }
}
declare module laya.device.media {
    /**
     * @private
     */
    class HtmlVideo extends laya.resource.Bitmap {
        protected video: any;
        constructor();
        static create: Function;
        setSource(url: string, extension: number): void;
        getVideo(): any;
    }
}
declare module laya.device.media {
    /**
     * Media用于捕捉摄像头和麦克风。可以捕捉任意之一，或者同时捕捉两者。<code>getCamera</code>前可以使用<code>supported()</code>检查当前浏览器是否支持。
     * <b>NOTE:</b>
     * <p>目前Media在移动平台只支持Android，不支持IOS。只可在FireFox完整地使用，Chrome测试时无法捕捉视频。</p>
     */
    class Media {
        constructor();
        /**
         * 检查浏览器兼容性。
         */
        static supported(): boolean;
        /**
         * 获取用户媒体。
         * @param	options	简单的可选项可以使<code>
         * @param	onSuccess 获取成功的处理器，唯一参数返回媒体的Blob地址，可以将其传给Video。
         * @param	onError	获取失败的处理器，唯一参数是Error。
         */
        static getMedia(options: any, onSuccess: laya.utils.Handler, onError: laya.utils.Handler): void;
    }
}
declare module laya.device.media {
    /**
     * <code>Video</code>将视频显示到Canvas上。<code>Video</code>可能不会在所有浏览器有效。
     * <p>关于Video支持的所有事件参见：<i>http://www.w3school.com.cn/tags/html_ref_audio_video_dom.asp</i>。</p>
     * <p>
     * <b>注意：</b><br/>
     * 在PC端可以在任何时机调用<code>play()</code>因此，可以在程序开始运行时就使Video开始播放。但是在移动端，只有在用户第一次触碰屏幕后才可以调用play()，所以移动端不可能在程序开始运行时就自动开始播放Video。
     * </p>
     *
     * <p>MDN Video链接： <i>https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video</i></p>
     */
    class Video extends laya.display.Sprite {
        static MP4: number;
        static OGG: number;
        static CAMERA: number;
        static WEBM: number;
        /** 表示最有可能支持。 */
        static SUPPORT_PROBABLY: string;
        /** 表示可能支持。*/
        static SUPPORT_MAYBY: string;
        /** 表示不支持。 */
        static SUPPORT_NO: string;
        constructor(width?: number, height?: number);
        /**
         * 设置播放源。
         * @param url	播放源路径。
         */
        load(url: string): void;
        /**
         * 开始播放视频。
         */
        play(): void;
        /**
         * 暂停视频播放。
         */
        pause(): void;
        /**
         * 重新加载视频。
         */
        reload(): void;
        /**
         * 检测是否支持播放指定格式视频。
         * @param type	参数为Video.MP4 / Video.OGG / Video.WEBM之一。
         * @return
         */
        canPlayType(type: number): string;
        /**
         * buffered 属性返回 TimeRanges(JS)对象。TimeRanges 对象表示用户的音视频缓冲范围。缓冲范围指的是已缓冲音视频的时间范围。如果用户在音视频中跳跃播放，会得到多个缓冲范围。
         * <p>buffered.length返回缓冲范围个数。如获取第一个缓冲范围则是buffered.start(0)和buffered.end(0)。以秒计。</p>
         * @return
         */
        buffered: any;
        /**
         * 获取当前播放源路径。
         */
        currentSrc: string;
        /**
         * 设置和获取当前播放头位置。
         */
        currentTime: number;
        /**
         * 设置和获取当前音量。
         */
        volume: number;
        /**
         * 表示视频元素的就绪状态：
         * <ul>
         * <li>0 = HAVE_NOTHING - 没有关于音频/视频是否就绪的信息</li>
         * <li>1 = HAVE_METADATA - 关于音频/视频就绪的元数据</li>
         * <li>2 = HAVE_CURRENT_DATA - 关于当前播放位置的数据是可用的，但没有足够的数据来播放下一帧/毫秒</li>
         * <li>3 = HAVE_FUTURE_DATA - 当前及至少下一帧的数据是可用的</li>
         * <li>4 = HAVE_ENOUGH_DATA - 可用数据足以开始播放</li>
         * </ul>
         */
        readyState: any;
        /**
         * 获取视频源尺寸。ready事件触发后可用。
         */
        videoWidth: number;
        videoHeight: number;
        /**
         * 获取视频长度（秒）。ready事件触发后可用。
         */
        duration: number;
        /**
         * 返回音频/视频的播放是否已结束
         */
        ended: boolean;
        /**
         * 返回表示音频/视频错误状态的 MediaError（JS）对象。
         */
        error: boolean;
        /**
         * 设置或返回音频/视频是否应在结束时重新播放。
         */
        loop: boolean;
        /**
         * playbackRate 属性设置或返回音频/视频的当前播放速度。如：
         * <ul>
         * <li>1.0 正常速度</li>
         * <li>0.5 半速（更慢）</li>
         * <li>2.0 倍速（更快）</li>
         * <li>-1.0 向后，正常速度</li>
         * <li>-0.5 向后，半速</li>
         * </ul>
         * <p>只有 Google Chrome 和 Safari 支持 playbackRate 属性。</p>
         */
        playbackRate: number;
        /**
         * 获取和设置静音状态。
         */
        muted: boolean;
        /**
         * 返回视频是否暂停
         */
        paused: boolean;
        /**
         * preload 属性设置或返回是否在页面加载后立即加载视频。可赋值如下：
         * <ul>
         * <li>auto	指示一旦页面加载，则开始加载视频。</li>
         * <li>metadata	指示当页面加载后仅加载音频/视频的元数据。</li>
         * <li>none	指示页面加载后不应加载音频/视频。</li>
         * </ul>
         * @return
         *
         */
        preload: string;
        /**
         * 参见 <i>http://www.w3school.com.cn/tags/av_prop_seekable.asp</i>。
         * @return
         *
         */
        seekable: any;
        /**
         * seeking 属性返回用户目前是否在音频/视频中寻址。
         * 寻址中（Seeking）指的是用户在音频/视频中移动/跳跃到新的位置。
         */
        seeking: boolean;
        height: number;
        size(width: number, height: number): laya.display.Sprite;
        width: number;
        /**
         * 销毁内部事件绑定。
         */
        destroy(detroyChildren?: boolean): void;
    }
}
declare module laya.device.media {
    /**
     * @private
     */
    class WebGLVideo extends laya.device.media.HtmlVideo {
        constructor();
        updateTexture(): void;
    }
}
declare module laya.device.motion {
    /**
     * 加速度x/y/z的单位均为m/s²。
     * 在硬件（陀螺仪）不支持的情况下，alpha、beta和gamma值为null。
     *
     * @author Survivor
     */
    class AccelerationInfo {
        /**
         * x轴上的加速度值。
         */
        x: number;
        /**
         * y轴上的加速度值。
         */
        y: number;
        /**
         * z轴上的加速度值。
         */
        z: number;
        constructor();
    }
}
declare module laya.device.motion {
    /**
     * Accelerator.instance获取唯一的Accelerator引用，请勿调用构造函数。
     *
     * <p>
     * listen()的回调处理器接受四个参数：
     * <ol>
     * <li><b>acceleration</b>: 表示用户给予设备的加速度。</li>
     * <li><b>accelerationIncludingGravity</b>: 设备受到的总加速度（包含重力）。</li>
     * <li><b>rotationRate</b>: 设备的自转速率。</li>
     * <li><b>interval</b>: 加速度获取的时间间隔（毫秒）。</li>
     * </ol>
     * </p>
     * <p>
     * <b>NOTE</b><br/>
     * 如，rotationRate的alpha在apple和moz文档中都是z轴旋转角度，但是实测是x轴旋转角度。为了使各属性表示的值与文档所述相同，实际值与其他属性进行了对调。
     * 其中：
     * <ul>
     * <li>alpha使用gamma值。</li>
     * <li>beta使用alpha值。</li>
     * <li>gamma使用beta。</li>
     * </ul>
     * 目前孰是孰非尚未可知，以此为注。
     * </p>
     */
    class Accelerator extends laya.events.EventDispatcher {
        private static _instance;
        static instance: Accelerator;
        private static acceleration;
        private static accelerationIncludingGravity;
        private static rotationRate;
        private static onChrome;
        constructor(singleton: number);
        /**
         * 侦听加速器运动。
         * @param observer	回调函数接受4个参数，见类说明。
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        /**
         * 取消侦听加速器。
         * @param	handle	侦听加速器所用处理器。
         */
        off(type: string, caller: any, listener: Function, onceOnly?: boolean): laya.events.EventDispatcher;
        private static transformedAcceleration;
        /**
         * 把加速度值转换为视觉上正确的加速度值。依赖于Browser.window.orientation，可能在部分低端机无效。
         * @param	acceleration
         * @return
         */
        static getTransformedAcceleration(acceleration: AccelerationInfo): AccelerationInfo;
    }
}
declare module laya.device.motion {
    /**
     * 使用Gyroscope.instance获取唯一的Gyroscope引用，请勿调用构造函数。
     *
     * <p>
     * listen()的回调处理器接受两个参数：
     * <code>function onOrientationChange(absolute:Boolean, info:RotationInfo):void</code>
     * <ol>
     * <li><b>absolute</b>: 指示设备是否可以提供绝对方位数据（指向地球坐标系），或者设备决定的任意坐标系。关于坐标系参见<i>https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Orientation_and_motion_data_explained</i>。</li>
     * <li><b>info</b>: <code>RotationInfo</code>类型参数，保存设备的旋转值。</li>
     * </ol>
     * </p>
     *
     * <p>
     * 浏览器兼容性参见：<i>http://caniuse.com/#search=deviceorientation</i>
     * </p>
     */
    class Gyroscope extends laya.events.EventDispatcher {
        private static info;
        private static _instance;
        static instance: Gyroscope;
        constructor(singleton: number);
        /**
         * 监视陀螺仪运动。
         * @param	observer	回调函数接受一个Boolean类型的<code>absolute</code>和<code>GyroscopeInfo</code>类型参数。
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        /**
         * 取消指定处理器对陀螺仪的监视。
         * @param	observer
         */
        off(type: string, caller: any, listener: Function, onceOnly?: boolean): laya.events.EventDispatcher;
    }
}
declare module laya.device.motion {
    /**
     * 保存旋转信息的类。请勿修改本类的属性。
     * @author Survivor
     */
    class RotationInfo {
        /**
         * <p>
         * 指示设备是否可以提供绝对方位数据（指向地球坐标系），或者设备决定的任意坐标系。
         * 关于坐标系参见<i>https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Orientation_and_motion_data_explained</i>。
         * </p>
         * 需要注意的是，IOS环境下，该值始终为false。即使如此，你依旧可以从<code>alpha</code>中取得正确的值。
         */
        absolute: boolean;
        /**
         * Z轴旋转角度，其值范围从0至360。
         * 若<code>absolute</code>为true或者在IOS中，alpha值是从北方到当前设备方向的角度值。
         */
        alpha: number;
        /**
         * X轴旋转角度, 其值范围从-180至180。代表设备从前至后的运动。
         */
        beta: number;
        /**
         * Y轴旋转角度，其值范围从-90至90。代表设备从左至右的运动。
         */
        gamma: number;
        /**
         * 罗盘数据的精确度（角度）。仅IOS可用。
         */
        compassAccuracy: number;
        constructor();
    }
}
declare module laya.device {
    /**
     * Shake只能在支持此操作的设备上有效。
     *
     * @author Survivor
     */
    class Shake extends laya.events.EventDispatcher {
        constructor();
        private static _instance;
        static instance: Shake;
        /**
         * 开始响应设备摇晃。
         * @param	throushold	响应的瞬时速度阈值，轻度摇晃的值约在5~10间。
         * @param	timeout		设备摇晃的响应间隔时间。
         * @param	callback	在设备摇晃触发时调用的处理器。
         */
        start(throushold: number, interval: number): void;
        /**
         * 停止响应设备摇晃。
         */
        stop(): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Animation</code> 是Graphics动画类（不断切换Graphics来实现动画），实现了基于Graphics的动画创建，播放控制接口。</p>
     * <p> <code>Animation</code> 可以加载一组图片集合或图集文件或IDE设计好的动画进行播放。</p>
     * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
     * <listing version="3.0">
     * package
     * {
     * 	import laya.display.Animation;
     * 	import laya.net.Loader;
     * 	import laya.utils.Handler;
     * 	public class Animation_Example
     * 	{
     * 		public function Animation_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			init();//初始化
     * 		}
     * 		private function init():void
     * 		{
     * 			var animation:Animation = new Animation();//创建一个 Animation 类的实例对象 animation 。
     * 			animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
     * 			animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     * 			animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     * 			animation.interval = 50;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
     * 			animation.play();//播放动画。
     * 			Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
     * 		}
     * 	}
     * }
     * </listing>
     * <listing version="3.0">
     * Animation_Example();
     * function Animation_Example(){
     *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *     init();//初始化
     * }
     * function init()
     * {
     *     var animation = new Laya.Animation();//创建一个 Animation 类的实例对象 animation 。
     *     animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
     *     animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *     animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *     animation.interval = 50;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
     *     animation.play();//播放动画。
     *     Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * import Animation = laya.display.Animation;
     * class Animation_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.init();
     *     }
     *     private init(): void {
     *         var animation:Animation = new Laya.Animation();//创建一个 Animation 类的实例对象 animation 。
     *         animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
     *         animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *         animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *         animation.interval = 50;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
     *         animation.play();//播放动画。
     *         Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
     *     }
     * }
     * new Animation_Example();
     * </listing>
     */
    class Animation extends AnimationPlayerBase {
        /**全局缓存动画缓存池，存储了全局Graphics动画数据。使用缓存可以播放指定动画，比如播放"hero_run"动画：ani.play(0,true,"hero_run"); */
        static framesMap: any;
        protected _frames: Array<any>;
        protected _url: string;
        /**
         * 创建一个新的 <code>Animation</code> 实例。
         */
        constructor();
        /** @inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**
         * 播放动画。可以指定name属性，播放缓存中某个动画。
         * @param	start 开始播放的动画索引或label。
         * @param	loop 是否循环播放。
         * @param	name 如果name为空(可选)，则播放当前动画，如果不为空，则播放全局缓存动画（如果有）
         */
        play(start?: any, loop?: boolean, name?: string): void;
        protected _setFramesFromCache(name: string): boolean;
        protected _frameLoop(): void;
        protected _displayToIndex(value: number): void;
        /**动画帧信息，里面存储的是Graphics数组，Animation本身就是不断切换Graphics来实现动画效果。*/
        frames: Array<any>;
        /**动画数据源，可以是图集，图片集合，IDE动画
         * 比如：图集："xx/a1.json" 图片集合："a1.png,a2.png,a3.png" IDE动画"xx/a1.ani"
         */
        source: string;
        /**是否自动播放，默认为false，如果设置为true，则动画被添加到舞台后，就会自动播放*/
        autoPlay: boolean;
        /**清理。方便对象复用。*/
        clear(): void;
        /**
         * 加载图片集合作为动画。
         * @param	urls	图片地址集合。如：[url1,url2,url3,...]。
         * @param	cacheName 缓存的动画模板名称。此模板为全局模板，缓存后，可以使用play(start,loop,name)接口进行播放，无需重复创建动画模板（相同动画能节省创建动画模板开销），设置为空则不缓存。
         * @return 	返回动画本身。
         */
        loadImages(urls: Array<any>, cacheName?: string): Animation;
        /**
         * 加载一个图集作为动画。
         * @param	url 	图集地址。
         * @param	loaded	加载完毕回调。
         * @param	cacheName 缓存的动画模板名称。此模板为全局模板，缓存后，可以使用play(start,loop,name)接口进行播放，无需重复创建动画模板（相同动画能节省创建动画模板开销），设置为空则不缓存。
         * @return 	返回动画本身。
         */
        loadAtlas(url: string, loaded?: laya.utils.Handler, cacheName?: string): Animation;
        /**
         * 加载由IDE制作的动画。播放的帧率则按照IDE设计的帧率。加载后，默认会根据 "url+动画名称" 缓存为动画模板。
         * 【注意】加载解析IDE动画之前，请确保动画使用的图片被预加载，否则会导致动画创建失败。
         * @param	url 	动画地址。
         * @param	loaded	加载完毕回调。
         * @return 	返回动画本身。
         */
        loadAnimation(url: string, loaded?: laya.utils.Handler): Animation;
        protected _parseGraphicAnimation(animationData: any): any;
        /**
         * 创建动画模板，相同地址的动画可共享播放模板，而不必每次都创建一份新的，从而节省创建Graphics集合的开销
         * createFrames如果url是图集则需要预加载图集，而loadAtlas方法则不需要
         * @param	url 图集路径(已经加载过的)或者url数组(可以异步加载)
         * @param	name 全局动画名称，如果name不为空，则缓存动画模板，否则不缓存
         * @return	Graphics动画模板
         */
        static createFrames(url: any, name: string): Array<any>;
        /**
         * 清除动画缓存数据
         * @param key 动画名称或路径
         */
        static clearCache(key: string): void;
    }
}
declare module laya.display {
    /**
     * 动画播放基类
     */
    class AnimationPlayerBase extends Sprite {
        /**是否循环播放*/
        loop: boolean;
        /**播放类型：0为正序播放，1为倒序播放，2为pingpong播放*/
        wrapMode: number;
        protected _interval: number;
        protected _index: number;
        protected _count: number;
        protected _isPlaying: boolean;
        protected _labels: any;
        protected _isReverse: boolean;
        protected _frameRateChanged: boolean;
        protected _actionName: string;
        constructor();
        /**
         * 播放动画。
         * @param	start 开始播放的动画索引或label。
         * @param	loop 是否循环。
         * @param	name 如果name为空(可选)，则播放当前动画，如果不为空，则播放全局缓存动画（如果有）
         */
        play(start?: any, loop?: boolean, name?: string): void;
        /** 播放间隔(单位：毫秒)，默认为50毫秒，可以通过Config.animationInterval修改默认时间间隔。*/
        interval: number;
        protected _getFrameByLabel(label: string): number;
        protected _frameLoop(): void;
        _setControlNode(node: Sprite): void;
        _setDisplay(value: boolean): void;
        protected _checkResumePlaying(): void;
        /**
         * 停止播放。
         */
        stop(): void;
        /**
         * 是否在播放中
         */
        isPlaying: boolean;
        /**
         * 增加一个标签到index帧上，播放到此index后会派发label事件
         * @param	label	标签名称
         * @param	index	索引位置
         */
        addLabel(label: string, index: number): void;
        /**
         * 删除某个标签
         * @param	label 标签名字，如果label为空，则删除所有Label
         */
        removeLabel(label: string): void;
        /**
         * 切换到某帧并停止
         * @param	position 帧索引或label
         */
        gotoAndStop(position: any): void;
        /**当前播放索引。*/
        index: number;
        protected _displayToIndex(value: number): void;
        /**动画长度。*/
        count: number;
        /**清理。方便对象复用。*/
        clear(): void;
    }
}
declare module laya.display {
    /**
     * <code>BitmapFont</code> 是位图字体类，用于定义位图字体信息。
     */
    class BitmapFont {
        /**当前位图字体字号。*/
        fontSize: number;
        /**表示是否根据实际使用的字体大小缩放位图字体大小。*/
        autoScaleSize: boolean;
        /**字符间距（以像素为单位）。*/
        letterSpacing: number;
        /**
         * 通过指定位图字体文件路径，加载位图字体文件。
         * @param	path		位图字体文件的路径。
         * @param	complete	加载完成的回调，通知上层字体文件已经完成加载并解析。
         */
        loadFont(path: string, complete: laya.utils.Handler): void;
        /**
         * 解析字体文件。
         * @param	xml			字体文件XML。
         * @param	texture		字体的纹理。
         */
        parseFont(xml: any, texture: laya.resource.Texture): void;
        /**
         * 获取指定字符的字体纹理对象。
         * @param	char 字符。
         * @return 指定的字体纹理对象。
         */
        getCharTexture(char: string): laya.resource.Texture;
        /**
         * 销毁位图字体，调用Text.unregisterBitmapFont 时，默认会销毁。
         */
        destroy(): void;
        /**
         * 设置空格的宽（如果字体库有空格，这里就可以不用设置了）。
         * @param	spaceWidth 宽度，单位为像素。
         */
        setSpaceWidth(spaceWidth: number): void;
        /**
         * 获取指定字符的宽度。
         * @param	char 字符。
         * @return  宽度。
         */
        getCharWidth(char: string): number;
        /**
         * 获取指定文本内容的宽度。
         * @param	text 文本内容。
         * @return  宽度。
         */
        getTextWidth(text: string): number;
        /**
         * 获取最大字符宽度。
         */
        getMaxWidth(): number;
        /**
         * 获取最大字符高度。
         */
        getMaxHeight(): number;
        /**
         * @private
         * 将指定的文本绘制到指定的显示对象上。
         */
        drawText(text: string, sprite: Sprite, drawX: number, drawY: number, align: string, width: number): void;
    }
}
declare module laya.display.css {
    /**
     * @private
     * <code>CSSStyle</code> 类是元素CSS样式定义类。
     */
    class CSSStyle extends laya.display.css.Style {
        static EMPTY: CSSStyle;
        private static _CSSTOVALUE;
        private static _parseCSSRegExp;
        private static _aligndef;
        private static _valigndef;
        /**
         * 样式表信息。
         */
        static styleSheets: any;
        /**水平居中对齐方式。 */
        static ALIGN_CENTER: number;
        /**水平居右对齐方式。 */
        static ALIGN_RIGHT: number;
        /**垂直居中对齐方式。 */
        static VALIGN_MIDDLE: number;
        /**垂直居底部对齐方式。 */
        static VALIGN_BOTTOM: number;
        private static _PADDING;
        private static _RECT;
        private static _SPACING;
        private static _ALIGNS;
        /**添加布局。 */
        static ADDLAYOUTED: number;
        /**
         * 是否显示为块级元素。
         */
        block: boolean;
        /**行高。 */
        lineHeight: number;
        /**
         * 创建一个新的 <code>CSSStyle</code> 类实例。
         * @param	ower 当前 CSSStyle 对象的拥有者。
         */
        constructor(ower: laya.display.Sprite);
        /**@inheritDoc	 */
        destroy(): void;
        /**
         * 复制传入的 CSSStyle 属性值。
         * @param	src 待复制的 CSSStyle 对象。
         */
        inherit(src: CSSStyle): void;
        _widthAuto(): boolean;
        /**@inheritDoc	 */
        widthed(sprite: any): boolean;
        /**
         * @private
         */
        _calculation(type: string, value: string): boolean;
        /**
         * 宽度。
         */
        width: any;
        /**
         * 高度。
         */
        height: any;
        /**
         * 是否已设置高度。
         * @param	sprite 显示对象 Sprite。
         * @return 一个Boolean 表示是否已设置高度。
         */
        heighted(sprite: any): boolean;
        /**
         * 设置宽高。
         * @param	w 宽度。
         * @param	h 高度。
         */
        size(w: number, h: number): void;
        /**
         * 表示左边距。
         */
        left: any;
        /**
         * 表示上边距。
         */
        top: any;
        /**
         * 边距信息。
         */
        padding: Array<any>;
        /**
         * 是否是行元素。
         */
        lineElement: boolean;
        /**
         * 水平对齐方式。
         */
        align: string;
        _getAlign(): number;
        /**
         * 垂直对齐方式。
         */
        valign: string;
        _getValign(): number;
        /**
         * 浮动方向。
         */
        cssFloat: string;
        _getCssFloat(): number;
        /**
         * 设置如何处理元素内的空白。
         */
        whiteSpace: string;
        /**
         * 表示是否换行。
         */
        wordWrap: boolean;
        /**
         * 表示是否加粗。
         */
        bold: boolean;
        /**
         * <p>指定文本字段是否是密码文本字段。</p>
         * 如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。
         */
        password: boolean;
        /**
         * 字体信息。
         */
        font: string;
        /**
         * 文本的粗细。
         */
        weight: string;
        /**
         * 间距。
         */
        letterSpacing: number;
        /**
         * 字体大小。
         */
        fontSize: number;
        /**
         * 行间距。
         */
        leading: number;
        /**
         * 表示是否为斜体。
         */
        italic: boolean;
        /**
         * 字体系列。
         */
        fontFamily: string;
        /**
         * 字体粗细。
         */
        fontWeight: string;
        /**
         * 添加到文本的修饰。
         */
        textDecoration: string;
        /**
         * 字体颜色。
         */
        color: string;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         * @default 0
         */
        stroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * @default "#000000";
         */
        strokeColor: string;
        /**
         * 边框属性，比如border="5px solid red"
         */
        border: string;
        /**
         * 边框的颜色。
         */
        borderColor: string;
        /**
         * 背景颜色。
         */
        backgroundColor: string;
        background: string;
        /**@inheritDoc	 */
        render(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**@inheritDoc	 */
        getCSSStyle(): CSSStyle;
        /**
         * 设置 CSS 样式字符串。
         * @param	text CSS样式字符串。
         */
        cssText(text: string): void;
        /**
         * 根据传入的属性名、属性值列表，设置此对象的属性值。
         * @param	attrs 属性名与属性值列表。
         */
        attrs(attrs: Array<any>): void;
        /**
         * 元素的定位类型。
         */
        position: string;
        /**@inheritDoc	 */
        absolute: boolean;
        /**
         * 规定元素应该生成的框的类型。
         */
        display: string;
        /**@inheritDoc	 */
        setTransform(value: any): void;
        /**@inheritDoc	 */
        paddingLeft: number;
        /**@inheritDoc	 */
        paddingTop: number;
        /**
         * 定义 X 轴、Y 轴移动转换。
         * @param	x X 轴平移量。
         * @param	y Y 轴平移量。
         */
        translate(x: number, y: number): void;
        /**
         * 定义 缩放转换。
         * @param	x X 轴缩放值。
         * @param	y Y 轴缩放值。
         */
        scale(x: number, y: number): void;
        _enableLayout(): boolean;
        /**
         * 通过传入的分割符，分割解析CSS样式字符串，返回样式列表。
         * @param	text CSS样式字符串。
         * @param	clipWord 分割符；
         * @return 样式列表。
         */
        static parseOneCSS(text: string, clipWord: string): Array<any>;
        /**
         * 解析 CSS 样式文本。
         * @param	text CSS 样式文本。
         * @param	uri URL对象。
         * @internal 此处需要再详细点注释。
         */
        static parseCSS(text: string, uri: laya.net.URL): void;
    }
}
declare module laya.display.css {
    /**
     * @private
     * <code>Font</code> 类是字体显示定义类。
     */
    class Font {
        /**
         * 一个默认字体 <code>Font</code> 对象。
         */
        static EMPTY: Font;
        /**
         * 默认的颜色。
         */
        static defaultColor: string;
        /**
         * 默认字体大小。
         */
        static defaultSize: number;
        /**
         * 默认字体名称系列。
         */
        static defaultFamily: string;
        /**
         * 默认字体属性。
         */
        static defaultFont: string;
        static _STROKE: Array<any>;
        static __init__(): void;
        /**
         * 字体名称系列。
         */
        family: string;
        /**
         * 描边宽度（以像素为单位）列表。
         */
        stroke: Array<any>;
        /**
         * 首行缩进 （以像素为单位）。
         */
        indent: number;
        /**
         * 字体大小。
         */
        size: number;
        /**
         * 创建一个新的 <code>Font</code> 类实例。
         * @param	src 将此 Font 的成员属性值复制给当前 Font 对象。
         */
        constructor(src: Font);
        /**
         * 字体样式字符串。
         */
        set(value: string): void;
        /**
         * 表示颜色字符串。
         */
        color: string;
        /**
         * 表示是否为斜体。
         */
        italic: boolean;
        /**
         * 表示是否为粗体。
         */
        bold: boolean;
        /**
         * 表示是否为密码格式。
         */
        password: boolean;
        /**
         * 返回字体样式字符串。
         * @return 字体样式字符串。
         */
        toString(): string;
        /**
         * 文本的粗细。
         */
        weight: string;
        /**
         * 规定添加到文本的修饰。
         */
        decoration: string;
        /**
         * 将当前的属性值复制到传入的 <code>Font</code> 对象。
         * @param	dec  一个 Font 对象。
         */
        copyTo(dec: Font): void;
    }
}
declare module laya.display.css {
    /**
     * @private
     * <code>Style</code> 类是元素样式定义类。
     */
    class Style {
        /** 一个默认样式 <code>Style</code> 对象。*/
        static EMPTY: laya.display.css.Style;
        protected static _TF_EMPTY: TransformInfo;
        _tf: TransformInfo;
        /**透明度。*/
        alpha: number;
        /**表示是否显示。*/
        visible: boolean;
        /**表示滚动区域。*/
        scrollRect: laya.maths.Rectangle;
        /**混合模式。*/
        blendMode: string;
        _type: number;
        static __init__(): void;
        /**元素应用的 2D 或 3D 转换的值。该属性允许我们对元素进行旋转、缩放、移动或倾斜。*/
        transform: any;
        getTransform(): any;
        setTransform(value: any): void;
        /**定义转换，只是用 X 轴的值。*/
        translateX: number;
        setTranslateX(value: number): void;
        /**定义转换，只是用 Y 轴的值。*/
        translateY: number;
        setTranslateY(value: number): void;
        /**X 轴缩放值。*/
        scaleX: number;
        setScaleX(value: number): void;
        setScale(x: number, y: number): void;
        /**Y 轴缩放值。*/
        scaleY: number;
        setScaleY(value: number): void;
        /**定义旋转角度。*/
        rotate: number;
        setRotate(value: number): void;
        /**定义沿着 X 轴的 2D 倾斜转换。*/
        skewX: number;
        setSkewX(value: number): void;
        /**定义沿着 Y 轴的 2D 倾斜转换。*/
        skewY: number;
        setSkewY(value: number): void;
        /**表示元素是否显示为块级元素。*/
        block: boolean;
        /**表示元素的左内边距。*/
        paddingLeft: number;
        /**表示元素的上内边距。*/
        paddingTop: number;
        /**是否为绝对定位。*/
        absolute: boolean;
        /**销毁此对象。*/
        destroy(): void;
        render(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        getCSSStyle(): laya.display.css.CSSStyle;
        _enableLayout(): boolean;
    }
}
declare module laya.display.css {
    /**
     * @private
     */
    class TransformInfo {
        translateX: number;
        translateY: number;
        scaleX: number;
        scaleY: number;
        rotate: number;
        skewX: number;
        skewY: number;
    }
}
declare module laya.display {
    /**
     * 关键帧动画播放类
     *
     */
    class FrameAnimation extends AnimationPlayerBase {
        constructor();
        private static _sortIndexFun;
        /**
         * @private
         * id对象表
         */
        _targetDic: any;
        /**
         *  @private
         *  动画数据
         */
        _animationData: any;
        /**
         * @private
         * 初始化动画数据
         * @param targetDic 对象表
         * @param animationData 动画数据
         *
         */
        _setUp(targetDic: any, animationData: any): void;
        /**@inheritDoc */
        clear(): void;
        protected _displayToIndex(value: number): void;
        protected _displayNodeToFrame(node: any, frame: number, targetDic?: any): void;
        protected _calculateNodeKeyFrames(node: any): void;
    }
}
declare module laya.display {
    /**
     * @private
     */
    class GraphicAnimation extends FrameAnimation {
        constructor();
        animationList: Array<any>;
        animationDic: any;
        protected _nodeList: Array<any>;
        protected _nodeDefaultProps: any;
        protected _gList: Array<any>;
        protected _nodeIDAniDic: any;
        protected static _temParam: Array<any>;
        private static _I;
        private static _rootMatrix;
        protected _createFrameGraphic(frame: number): any;
        protected _nodeGDic: any;
        protected _updateNodeGraphic(node: any, frame: number, parentTransfrom: laya.maths.Matrix, g: Graphics, alpha?: number): void;
        protected _updateNoChilds(tNodeG: GraphicNode, g: Graphics): void;
        protected _updateNodeGraphic2(node: any, frame: number, g: Graphics): void;
        protected _calculateNodeKeyFrames(node: any): void;
        protected getNodeDataByID(nodeID: number): any;
        protected _getParams(obj: any, params: Array<any>, frame: number, obj2: any): Array<any>;
        protected _getNodeGraphicData(nodeID: number, frame: number, rst: GraphicNode): GraphicNode;
        private static _tempMt;
        protected _getTextureByUrl(url: string): any;
        /**
         * @private
         */
        setAniData(uiView: any): void;
        protected _clear(): void;
        static parseAnimationData(aniData: any): any;
    }
    class GraphicNode {
        skin: string;
        transform: laya.maths.Matrix;
        resultTransform: laya.maths.Matrix;
        width: number;
        height: number;
        alpha: number;
    }
}
declare module laya.display {
    /**
     * <code>Graphics</code> 类用于创建绘图显示对象。Graphics可以同时绘制多个位图或者矢量图，还可以结合save，restore，transform，scale，rotate，translate，alpha等指令对绘图效果进行变化。
     * Graphics以命令流方式存储，可以通过cmds属性访问所有命令流。Graphics是比Sprite更轻量级的对象，合理使用能提高应用性能(比如把大量的节点绘图改为一个节点的Graphics命令集合，能减少大量节点创建消耗)。
     * @see laya.display.Sprite#graphics
     */
    class Graphics {
        private static _tempMatrix;
        private static _initMatrix;
        private static _tempPoints;
        private static _tempMatrixArrays;
        private static _tempCmds;
        _sp: Sprite;
        _one: Array<any>;
        _render: Function;
        static __init__(): void;
        /**
         * 创建一个新的 <code>Graphics</code> 类实例。
         */
        constructor();
        /**
         * <p>销毁此对象。</p>
         */
        destroy(): void;
        /**
         * <p>清空绘制命令。</p>
         */
        clear(): void;
        /**
         * @private
         * 重绘此对象。
         */
        _repaint(): void;
        _isOnlyOne(): boolean;
        /**
         * @private
         * 命令流。存储了所有绘制命令。
         */
        cmds: Array<any>;
        /**
         * 获取位置及宽高信息矩阵(比较耗，尽量少用)。
         * @param realSize 使用图片的真实大小，默认为false
         * @return 位置与宽高组成的 一个 Rectangle 对象。
         */
        getBounds(realSize?: boolean): laya.maths.Rectangle;
        /**
         * @private
         * @param realSize 使用图片的真实大小，默认为false
         * 获取端点列表。
         */
        getBoundPoints(realSize?: boolean): Array<any>;
        /**
         * 绘制纹理。
         * @param	tex 纹理。
         * @param	x X 轴偏移量。
         * @param	y Y 轴偏移量。
         * @param	width 宽度。
         * @param	height 高度。
         * @param	m 矩阵信息。
         */
        drawTexture(tex: laya.resource.Texture, x?: number, y?: number, width?: number, height?: number, m?: laya.maths.Matrix, alpha?: number): void;
        /**
         * @private 清理贴图并替换为最新的
         * @param	tex
         */
        cleanByTexture(tex: laya.resource.Texture, x: number, y: number, width?: number, height?: number): void;
        /**
         * 批量绘制同样纹理。
         * @param	tex 纹理。
         * @param	pos 绘制次数和坐标。
         */
        drawTextures(tex: laya.resource.Texture, pos: Array<any>): void;
        /**
         * 用texture填充
         * @param	tex 纹理。
         * @param	x X 轴偏移量。
         * @param	y Y 轴偏移量。
         * @param	width 宽度。
         * @param	height 高度。
         * @param 	type 填充类型 repeat|repeat-x|repeat-y|no-repeat
         * @param	offset 贴图纹理偏移
         *
         */
        fillTexture(tex: laya.resource.Texture, x: number, y: number, width?: number, height?: number, type?: string, offset?: laya.maths.Point): void;
        /**
         * @private
         * 保存到命令流。
         */
        _saveToCmd(fun: Function, args: Array<any>): Array<any>;
        /**
         * 设置剪裁区域，超出剪裁区域的坐标不显示。
         * @param	x X 轴偏移量。
         * @param	y Y 轴偏移量。
         * @param	width 宽度。
         * @param	height 高度。
         */
        clipRect(x: number, y: number, width: number, height: number): void;
        /**
         * 在画布上绘制文本。
         * @param	text 在画布上输出的文本。
         * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
         * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
         * @param	font 定义字号和字体，比如"20px Arial"。
         * @param	color 定义文本颜色，比如"#ff0000"。
         * @param	textAlign 文本对齐方式，可选值："left"，"center"，"right"。
         */
        fillText(text: string, x: number, y: number, font: string, color: string, textAlign: string): void;
        /**
         * 在画布上绘制“被填充且镶边的”文本。
         * @param	text 在画布上输出的文本。
         * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
         * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
         * @param	font 定义字体和字号，比如"20px Arial"。
         * @param	fillColor 定义文本颜色，比如"#ff0000"。
         * @param	borderColor 定义镶边文本颜色。
         * @param	lineWidth 镶边线条宽度。
         * @param	textAlign 文本对齐方式，可选值："left"，"center"，"right"。
         */
        fillBorderText(text: any, x: number, y: number, font: string, fillColor: string, borderColor: string, lineWidth: number, textAlign: string): void;
        /**
         * 在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
         * @param	text 在画布上输出的文本。
         * @param	x 开始绘制文本的 x 坐标位置（相对于画布）。
         * @param	y 开始绘制文本的 y 坐标位置（相对于画布）。
         * @param	font 定义字体和字号，比如"20px Arial"。
         * @param	color 定义文本颜色，比如"#ff0000"。
         * @param	lineWidth 线条宽度。
         * @param	textAlign 文本对齐方式，可选值："left"，"center"，"right"。
         */
        strokeText(text: any, x: number, y: number, font: string, color: string, lineWidth: number, textAlign: string): void;
        /**
         * 设置透明度。
         * @param	value 透明度。
         */
        alpha(value: number): void;
        /**
         * 替换绘图的当前转换矩阵。
         * @param	mat 矩阵。
         * @param	pivotX 水平方向轴心点坐标。
         * @param	pivotY 垂直方向轴心点坐标。
         */
        transform(matrix: laya.maths.Matrix, pivotX?: number, pivotY?: number): void;
        /**
         * 旋转当前绘图。(推荐使用transform，性能更高)
         * @param	angle 旋转角度，以弧度计。
         * @param	pivotX 水平方向轴心点坐标。
         * @param	pivotY 垂直方向轴心点坐标。
         */
        rotate(angle: number, pivotX?: number, pivotY?: number): void;
        /**
         * 缩放当前绘图至更大或更小。(推荐使用transform，性能更高)
         * @param	scaleX 水平方向缩放值。
         * @param	scaleY 垂直方向缩放值。
         * @param	pivotX 水平方向轴心点坐标。
         * @param	pivotY 垂直方向轴心点坐标。
         */
        scale(scaleX: number, scaleY: number, pivotX?: number, pivotY?: number): void;
        /**
         * 重新映射画布上的 (0,0) 位置。
         * @param	x 添加到水平坐标（x）上的值。
         * @param	y 添加到垂直坐标（y）上的值。
         */
        translate(x: number, y: number): void;
        /**
         * 保存当前环境的状态。
         */
        save(): void;
        /**
         * 返回之前保存过的路径状态和属性。
         */
        restore(): void;
        /**
         * @private
         * 替换文本内容。
         * @param	text 文本内容。
         * @return 替换成功则值为true，否则值为flase。
         */
        replaceText(text: string): boolean;
        /**
         * @private
         * 替换文本颜色。
         * @param	color 颜色。
         */
        replaceTextColor(color: string): void;
        /**
         * 加载并显示一个图片。
         * @param	url 图片地址。
         * @param	x 显示图片的x位置。
         * @param	y 显示图片的y位置。
         * @param	width 显示图片的宽度，设置为0表示使用图片默认宽度。
         * @param	height 显示图片的高度，设置为0表示使用图片默认高度。
         * @param	complete 加载完成回调。
         */
        loadImage(url: string, x?: number, y?: number, width?: number, height?: number, complete?: Function): void;
        /**
         * @private
         */
        _renderEmpty(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         */
        _renderAll(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         */
        _renderOne(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         */
        _renderOneImg(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 绘制一条线。
         * @param	fromX X 轴开始位置。
         * @param	fromY Y 轴开始位置。
         * @param	toX	X 轴结束位置。
         * @param	toY	Y 轴结束位置。
         * @param	lineColor 颜色。
         * @param	lineWidth 线条宽度。
         */
        drawLine(fromX: number, fromY: number, toX: number, toY: number, lineColor: string, lineWidth?: number): void;
        /**
         * 绘制一系列线段。
         * @param	x 开始绘制的 X 轴位置。
         * @param	y 开始绘制的 Y 轴位置。
         * @param	points 线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
         * @param	lineColor 线段颜色，或者填充绘图的渐变对象。
         * @param	lineWidth 线段宽度。
         */
        drawLines(x: number, y: number, points: Array<any>, lineColor: any, lineWidth?: number): void;
        /**
         * 绘制一系列曲线。
         * @param	x 开始绘制的 X 轴位置。
         * @param	y 开始绘制的 Y 轴位置。
         * @param	points 线段的点集合，格式[startx,starty,ctrx,ctry,startx,starty...]。
         * @param	lineColor 线段颜色，或者填充绘图的渐变对象。
         * @param	lineWidth 线段宽度。
         */
        drawCurves(x: number, y: number, points: Array<any>, lineColor: any, lineWidth?: number): void;
        /**
         * 绘制矩形。
         * @param	x 开始绘制的 X 轴位置。
         * @param	y 开始绘制的 Y 轴位置。
         * @param	width 矩形宽度。
         * @param	height 矩形高度。
         * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param	lineWidth 边框宽度。
         */
        drawRect(x: number, y: number, width: number, height: number, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制圆形。
         * @param	x 圆点X 轴位置。
         * @param	y 圆点Y 轴位置。
         * @param	radius 半径。
         * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param	lineWidth 边框宽度。
         */
        drawCircle(x: number, y: number, radius: number, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制扇形。
         * @param	x 开始绘制的 X 轴位置。
         * @param	y 开始绘制的 Y 轴位置。
         * @param	radius 扇形半径。
         * @param	startAngle 开始角度。
         * @param	endAngle 结束角度。
         * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param	lineWidth 边框宽度。
         */
        drawPie(x: number, y: number, radius: number, startAngle: number, endAngle: number, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制多边形。
         * @param	x 开始绘制的 X 轴位置。
         * @param	y 开始绘制的 Y 轴位置。
         * @param	points 多边形的点集合。
         * @param	fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param	lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param	lineWidth 边框宽度。
         */
        drawPoly(x: number, y: number, points: Array<any>, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制路径。
         * @param	x 开始绘制的 X 轴位置。
         * @param	y 开始绘制的 Y 轴位置。
         * @param	paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y,x,y,x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
         * @param	brush 刷子定义，支持以下设置
         * @param	pen 画笔定义，支持以下设置
         */
        drawPath(x: number, y: number, paths: Array<any>, brush?: any, pen?: any): void;
    }
}
declare module laya.display {
    /**
     * @private
     *  <code>ILayout</code> 类是显示对象的布局接口。
     */
    interface ILayout {
    }
}
declare module laya.display {
    /**
     * <p><code>Input</code> 类用于创建显示对象以显示和输入文本。</p>
     */
    class Input extends Text {
        /** 常规文本域。*/
        /** password 类型用于密码域输入。*/
        /** email 类型用于应该包含 e-mail 地址的输入域。*/
        static TYPE_EMAIL: string;
        /** url 类型用于应该包含 URL 地址的输入域。*/
        static TYPE_URL: string;
        /** number 类型用于应该包含数值的输入域。*/
        static TYPE_NUMBER: string;
        /**
         * range 类型用于应该包含一定范围内数字值的输入域。
         * range 类型显示为滑动条。
         * 您还能够设定对所接受的数字的限定：
         */
        static TYPE_RANGE: string;
        /**  选取日、月、年。*/
        static TYPE_DATE: string;
        /** month - 选取月、年。*/
        static TYPE_MONTH: string;
        /** week - 选取周和年。*/
        static TYPE_WEEK: string;
        /** time - 选取时间（小时和分钟）。*/
        static TYPE_TIME: string;
        /** datetime - 选取时间、日、月、年（UTC 时间）。*/
        static TYPE_DATE_TIME: string;
        /** datetime-local - 选取时间、日、月、年（本地时间）。*/
        static TYPE_DATE_TIME_LOCAL: string;
        /**
         * search 类型用于搜索域，比如站点搜索或 Google 搜索。
         * search 域显示为常规的文本域。
         */
        static TYPE_SEARCH: string;
        protected static input: any;
        protected static area: any;
        protected static inputElement: any;
        protected static inputContainer: any;
        protected static confirmButton: any;
        protected static promptStyleDOM: any;
        protected _focus: boolean;
        protected _multiline: boolean;
        protected _editable: boolean;
        protected _restrictPattern: any;
        protected _maxChars: number;
        static IOS_IFRAME: boolean;
        /**表示是否处于输入状态。*/
        static isInputting: boolean;
        /**创建一个新的 <code>Input</code> 类实例。*/
        constructor();
        static __init__(): void;
        /**
         * 设置光标位置和选取字符。
         * @param	startIndex	光标起始位置。
         * @param	endIndex	光标结束位置。
         */
        setSelection(startIndex: number, endIndex: number): void;
        /**表示是否是多行输入框。*/
        multiline: boolean;
        /**
         * 获取对输入框的引用实例。
         */
        nativeInput: any;
        /**@inheritDoc*/
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        /**选中所有文本。*/
        select(): void;
        /**
         * 表示焦点是否在显示对象上。
         */
        focus: boolean;
        /**@inheritDoc */
        text: string;
        changeText(text: string): void;
        /**@inheritDoc */
        color: string;
        /**限制输入的字符。*/
        restrict: string;
        /**
         * 是否可编辑。
         */
        editable: boolean;
        /**
         * 字符数量限制，默认为10000。
         * 设置字符数量限制时，小于等于0的值将会限制字符数量为10000。
         */
        maxChars: number;
        /**
         * 设置输入提示符。
         */
        prompt: string;
        /**
         * 设置输入提示符颜色。
         */
        promptColor: string;
        /**
         * 输入框类型为Input静态常量之一。
         * 平台兼容性参见http://www.w3school.com.cn/html5/html_5_form_input_types.asp。
         */
        type: string;
        /**原生输入框 X 轴调整值，用来调整输入框坐标。
         * 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementXAdjuster已弃用。*/
        inputElementXAdjuster: number;
        inputElementYAdjuster: number;
        asPassword: boolean;
    }
}
declare module laya.display {
    /**
     * <code>Node</code> 类用于创建节点对象，节点是最基本的元素。
     */
    class Node extends laya.events.EventDispatcher {
        static NOTICE_DISPLAY: number;
        static MOUSEENABLE: number;
        _childs: Array<any>;
        protected _displayedInStage: boolean;
        protected _parent: Node;
        _$P: any;
        conchModel: any;
        /**节点名称。*/
        name: string;
        /**是否已经销毁。对象销毁后不能再使用。*/
        destroyed: boolean;
        /**时间控制器，默认为Laya.timer。*/
        timer: laya.utils.Timer;
        /**
         * <code>Node</code> 类用于创建节点对象，节点是最基本的元素。
         */
        constructor();
        _setBit(type: number, value: boolean): void;
        _getBit(type: number): boolean;
        _setUpNoticeChain(): void;
        _setUpNoticeType(type: number): void;
        /**
         * 增加事件侦听器，以使侦听器能够接收事件通知。
         * 如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	args 事件侦听函数的回调参数。
         * @return 此 EventDispatcher 对象。
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        /**
         * 增加事件侦听器，以使侦听器能够接收事件通知，此侦听事件响应一次后则自动移除侦听。
         * 如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	args 事件侦听函数的回调参数。
         * @return 此 EventDispatcher 对象。
         */
        once(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        createConchModel(): any;
        /**
         * <p>销毁此对象。destroy对象默认会把自己从父节点移除，并且清理自身引用关系，等待js自动垃圾回收机制回收。destroy后不能再使用。</p>
         * destroy时会移除自身的事情监听，自身的timer监听，移除子对象及从父节点移除自己。
         * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
        /**
         * 销毁所有子对象，不销毁自己本身。
         */
        destroyChildren(): void;
        /**
         * 添加子节点。
         * @param	node 节点对象
         * @return	返回添加的节点
         */
        addChild(node: Node): Node;
        /**
         * 批量增加子节点
         * @param	...args 无数子节点。
         */
        addChildren(...args: any[]): void;
        /**
         * 添加子节点到指定的索引位置。
         * @param	node 节点对象。
         * @param	index 索引位置。
         * @return	返回添加的节点。
         */
        addChildAt(node: Node, index: number): Node;
        /**
         * 根据子节点对象，获取子节点的索引位置。
         * @param	node 子节点。
         * @return	子节点所在的索引位置。
         */
        getChildIndex(node: Node): number;
        /**
         * 根据子节点的名字，获取子节点对象。
         * @param	name 子节点的名字。
         * @return	节点对象。
         */
        getChildByName(name: string): Node;
        _get$P(key: string): any;
        _set$P(key: string, value: any): any;
        /**
         * 根据子节点的索引位置，获取子节点对象。
         * @param	index 索引位置
         * @return	子节点
         */
        getChildAt(index: number): Node;
        /**
         * 设置子节点的索引位置。
         * @param	node 子节点。
         * @param	index 新的索引。
         * @return	返回子节点本身。
         */
        setChildIndex(node: Node, index: number): Node;
        protected _childChanged(child?: Node): void;
        /**
         * 删除子节点。
         * @param	node 子节点
         * @return	被删除的节点
         */
        removeChild(node: Node): Node;
        /**
         * 从父容器删除自己，如已经被删除不会抛出异常。
         * @return 当前节点（ Node ）对象。
         */
        removeSelf(): Node;
        /**
         * 根据子节点名字删除对应的子节点对象，如果找不到不会抛出异常。
         * @param	name 对象名字。
         * @return 查找到的节点（ Node ）对象。
         */
        removeChildByName(name: string): Node;
        /**
         * 根据子节点索引位置，删除对应的子节点对象。
         * @param	index 节点索引位置。
         * @return	被删除的节点。
         */
        removeChildAt(index: number): Node;
        /**
         * 删除指定索引区间的所有子对象。
         * @param	beginIndex 开始索引。
         * @param	endIndex 结束索引。
         * @return 当前节点对象。
         */
        removeChildren(beginIndex?: number, endIndex?: number): Node;
        /**
         * 替换子节点。
         * @internal 将传入的新节点对象替换到已有子节点索引位置处。
         * @param	newNode 新节点。
         * @param	oldNode 老节点。
         * @return	返回新节点。
         */
        replaceChild(newNode: Node, oldNode: Node): Node;
        /**
         * 子对象数量。
         */
        numChildren: number;
        /**父节点。*/
        parent: Node;
        /**表示是否在显示列表中显示。*/
        displayedInStage: boolean;
        _setDisplay(value: boolean): void;
        /**
         * 当前容器是否包含 <code>node</code> 节点。
         * @param	node  某一个节点 <code>Node</code>。
         * @return	一个布尔值表示是否包含<code>node</code>节点。
         */
        contains(node: Node): boolean;
        /**
         * 定时重复执行某函数。功能同Laya.timer.timerLoop()。
         * @param	delay	间隔时间(单位毫秒)。
         * @param	caller	执行域(this)。
         * @param	method	结束时的回调方法。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为true。
         */
        timerLoop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行某函数一次。功能同Laya.timer.timerOnce()。
         * @param	delay	延迟时间(单位毫秒)。
         * @param	caller	执行域(this)。
         * @param	method	结束时的回调方法。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为true。
         */
        timerOnce(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时重复执行某函数(基于帧率)。功能同Laya.timer.frameLoop()。
         * @param	delay	间隔几帧(单位为帧)。
         * @param	caller	执行域(this)。
         * @param	method	结束时的回调方法。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为true。
         */
        frameLoop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行一次某函数(基于帧率)。功能同Laya.timer.frameOnce()。
         * @param	delay	延迟几帧(单位为帧)。
         * @param	caller	执行域(this)
         * @param	method	结束时的回调方法
         * @param	args	回调参数
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为true
         */
        frameOnce(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 清理定时器。功能同Laya.timer.clearTimer()。
         * @param	caller 执行域(this)。
         * @param	method 结束时的回调方法。
         */
        clearTimer(caller: any, method: Function): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Sprite</code> 类是基本显示对象节点，通过graphics可以绘制图片或者矢量图，支持旋转，缩放，位移等操作。Sprite同时也是容器类，用来添加多个子节点。</p>
     * LayaAir引擎API设计精简巧妙。核心显示类只有一个Sprite。Sprite针对不同的情况做了渲染优化，所以保证一个类实现丰富功能的同时，又达到高性能。
     * Sprite默认没有宽高，可以手动设置宽高，或者通过getbounds函数获取，还可以设置autoSize=true，然后再获取宽高。Sprite的宽高只是用来做碰撞使用，并不影响显示大小，如果更改显示大小，需要使用scaleX，scaleY。
     * Sprite默认不接受鼠标事件，即mouseEnabled=false，但是只要对其监听任意鼠标事件，会自动打开自己以及所有父对象的mouseEnabled=true。所以一般也无需手动设置mouseEnabled。
     *
     * @example 以下示例代码，创建了一个 <code>Sprite</code> 实例。
     * <listing version="3.0">
     * package
     * {
     * 	import laya.display.Sprite;
     * 	import laya.events.Event;
     *
     * 	public class Sprite_Example
     * 	{
     * 		private var sprite:Sprite;
     * 		private var shape:Sprite
     * 		public function Sprite_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			onInit();
     * 		}
     * 		private function onInit():void
     * 		{
     * 			sprite = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
     * 			sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
     * 			sprite.x = 200;//设置 sprite 对象相对于父容器的水平方向坐标值。
     * 			sprite.y = 200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
     * 			sprite.pivotX = 0;//设置 sprite 对象的水平方法轴心点坐标。
     * 			sprite.pivotY = 0;//设置 sprite 对象的垂直方法轴心点坐标。
     * 			Laya.stage.addChild(sprite);//将此 sprite 对象添加到显示列表。
     * 			sprite.on(Event.CLICK, this, onClickSprite);//给 sprite 对象添加点击事件侦听。
    
     * 			shape = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
     * 			shape.graphics.drawRect(0, 0, 100, 100, "#ccff00", "#ff0000", 2);//绘制一个有边框的填充矩形。
     * 			shape.x = 400;//设置 shape 对象相对于父容器的水平方向坐标值。
     * 			shape.y = 200;//设置 shape 对象相对于父容器的垂直方向坐标值。
     * 			shape.width = 100;//设置 shape 对象的宽度。
     * 			shape.height = 100;//设置 shape 对象的高度。
     * 			shape.pivotX = 50;//设置 shape 对象的水平方法轴心点坐标。
     * 			shape.pivotY = 50;//设置 shape 对象的垂直方法轴心点坐标。
     * 			Laya.stage.addChild(shape);//将此 shape 对象添加到显示列表。
     * 			shape.on(Event.CLICK, this, onClickShape);//给 shape 对象添加点击事件侦听。
     * 		}
     * 		private function onClickSprite():void
     * 		{
     * 			trace("点击 sprite 对象。");
     * 			sprite.rotation += 5;//旋转 sprite 对象。
     * 		}
     * 		private function onClickShape():void
     * 		{
     * 			trace("点击 shape 对象。");
     * 			shape.rotation += 5;//旋转 shape 对象。
     * 		}
     * 	}
     * }
     * </listing>
     * <listing version="3.0">
     * var sprite;
     * var shape;
     * Sprite_Example();
     * function Sprite_Example()
     * {
     *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *     onInit();
     * }
     * function onInit()
     * {
     *     sprite = new laya.display.Sprite();//创建一个 Sprite 类的实例对象 sprite 。
     *     sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
     *     sprite.x = 200;//设置 sprite 对象相对于父容器的水平方向坐标值。
     *     sprite.y = 200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
     *     sprite.pivotX = 0;//设置 sprite 对象的水平方法轴心点坐标。
     *     sprite.pivotY = 0;//设置 sprite 对象的垂直方法轴心点坐标。
     *     Laya.stage.addChild(sprite);//将此 sprite 对象添加到显示列表。
     *     sprite.on(Event.CLICK, this, onClickSprite);//给 sprite 对象添加点击事件侦听。
    
     *     shape = new laya.display.Sprite();//创建一个 Sprite 类的实例对象 sprite 。
     *     shape.graphics.drawRect(0, 0, 100, 100, "#ccff00", "#ff0000", 2);//绘制一个有边框的填充矩形。
     *     shape.x = 400;//设置 shape 对象相对于父容器的水平方向坐标值。
     *     shape.y = 200;//设置 shape 对象相对于父容器的垂直方向坐标值。
     *     shape.width = 100;//设置 shape 对象的宽度。
     *     shape.height = 100;//设置 shape 对象的高度。
     *     shape.pivotX = 50;//设置 shape 对象的水平方法轴心点坐标。
     *     shape.pivotY = 50;//设置 shape 对象的垂直方法轴心点坐标。
     *     Laya.stage.addChild(shape);//将此 shape 对象添加到显示列表。
     *     shape.on(laya.events.Event.CLICK, this, onClickShape);//给 shape 对象添加点击事件侦听。
     * }
     * function onClickSprite()
     * {
     *     console.log("点击 sprite 对象。");
     *     sprite.rotation += 5;//旋转 sprite 对象。
     * }
     * function onClickShape()
     * {
     *     console.log("点击 shape 对象。");
     *     shape.rotation += 5;//旋转 shape 对象。
     * }
     * </listing>
     * <listing version="3.0">
     * import Sprite = laya.display.Sprite;
     * class Sprite_Example {
     *     private sprite: Sprite;
     *     private shape: Sprite
     *     public Sprite_Example() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.onInit();
     *     }
     *     private onInit(): void {
     *         this.sprite = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
     *         this.sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
     *         this.sprite.x = 200;//设置 sprite 对象相对于父容器的水平方向坐标值。
     *         this.sprite.y = 200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
     *         this.sprite.pivotX = 0;//设置 sprite 对象的水平方法轴心点坐标。
     *         this.sprite.pivotY = 0;//设置 sprite 对象的垂直方法轴心点坐标。
     *         Laya.stage.addChild(this.sprite);//将此 sprite 对象添加到显示列表。
     *         this.sprite.on(laya.events.Event.CLICK, this, this.onClickSprite);//给 sprite 对象添加点击事件侦听。
    
     *         this.shape = new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
     *         this.shape.graphics.drawRect(0, 0, 100, 100, "#ccff00", "#ff0000", 2);//绘制一个有边框的填充矩形。
     *         this.shape.x = 400;//设置 shape 对象相对于父容器的水平方向坐标值。
     *         this.shape.y = 200;//设置 shape 对象相对于父容器的垂直方向坐标值。
     *         this.shape.width = 100;//设置 shape 对象的宽度。
     *         this.shape.height = 100;//设置 shape 对象的高度。
     *         this.shape.pivotX = 50;//设置 shape 对象的水平方法轴心点坐标。
     *         this.shape.pivotY = 50;//设置 shape 对象的垂直方法轴心点坐标。
     *         Laya.stage.addChild(this.shape);//将此 shape 对象添加到显示列表。
     *         this.shape.on(laya.events.Event.CLICK, this, this.onClickShape);//给 shape 对象添加点击事件侦听。
     *     }
     *     private onClickSprite(): void {
     *         console.log("点击 sprite 对象。");
     *         this.sprite.rotation += 5;//旋转 sprite 对象。
     *     }
     *     private onClickShape(): void {
     *         console.log("点击 shape 对象。");
     *         this.shape.rotation += 5;//旋转 shape 对象。
     *     }
     * }
     * </listing>
     */
    class Sprite extends Node implements ILayout {
        private static CustomList;
        protected _transform: laya.maths.Matrix;
        protected _tfChanged: boolean;
        protected _x: number;
        protected _y: number;
        _width: number;
        _height: number;
        protected _repaint: number;
        protected _mouseEnableState: number;
        _zOrder: number;
        _style: laya.display.css.Style;
        _graphics: Graphics;
        _renderType: number;
        /**指定当mouseEnabled=true时，是否可穿透。默认值为false，如果设置为true，则点击空白区域可以穿透过去，只针对自身有效。*/
        mouseThrough: boolean;
        /**
         * 指定是否自动计算宽高数据。默认值为 false 。
         * Sprite宽高默认为0，并且不会随着绘制内容的变化而变化，如果想根据绘制内容获取宽高，可以设置本属性为true，或者通过getBounds方法获取。设置为true，对性能有一定影响。
         */
        autoSize: boolean;
        /**
         * 指定鼠标碰撞检测是否优先检测自己。默认为false
         * 鼠标碰撞检测是优先检测子对象，然后冒泡到父对象，如果hitTestPrior=true
         * 鼠标碰撞优先检测本对象，本对象被击中后，才进一步检测子对象。
         * 对于已知大小的容器（特别是根容器），设置此值为true，能减少节点碰撞，提高性能。默认为false。UI的View组建默认为true。
         */
        hitTestPrior: boolean;
        /**视口大小，视口外的子对象，将不被渲染(如果想实现裁剪效果，请使用srollRect)，合理使用能提高渲染性能。比如由一个个小图片拼成的地图块，viewport外面的小图片将不渲染
         * srollRect和viewport的区别：
         * 1.srollRect自带裁剪效果，viewport只影响子对象渲染是否渲染，不具有裁剪效果（性能更高）。
         * 2.设置rect的x,y属性均能实现区域滚动效果，但scrollRect会保持0,0点位置不变。
         */
        viewport: laya.maths.Rectangle;
        private static RUNTIMEVERION;
        createConchModel(): any;
        /**
         * <p>指定是否对使用了 scrollRect 的显示对象进行优化处理。默认为false(不优化)。</p>
         * <p>当值为ture时：将对此对象使用了scrollRect 设定的显示区域以外的显示内容不进行渲染，以提高性能(如果子对象有旋转缩放或者中心点偏移，则显示筛选会不精确)。</p>
         */
        optimizeScrollRect: boolean;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**根据zOrder进行重新排序。*/
        updateZOrder(): void;
        /**
         * 指定显示对象是否缓存为静态图像。功能同cacheAs的normal模式。
         */
        cacheAsBitmap: boolean;
        /**
         * 设置是否开启自定义渲染，只有开启自定义渲染，才能使用customRender函数渲染。
         */
        customRenderEnable: boolean;
        /**
         * <p>指定显示对象是否缓存为静态图像，cacheAs时，子对象发生变化，会自动重新缓存，同时也可以手动调用reCache方法更新缓存。</p>
         * 建议把不经常变化的“复杂内容”缓存为静态图像，能极大提高渲染性能。cacheAs有"none"，"normal"和"bitmap"三个值可选。
         * <li>默认为"none"，不做任何缓存。</li>
         * <li>当值为"normal"时，canvas模式下进行画布缓存，webgl模式下进行命令缓存。</li>
         * <li>当值为"bitmap"时，canvas模式下进行依然是画布缓存，webgl模式下使用renderTarget缓存。</li>
         * webgl下renderTarget缓存模式有最大2048大小限制，会额外增加内存开销，不断重绘时开销比较大，但是会减少drawcall，渲染性能最高。
         * webgl下命令缓存模式只会减少节点遍历及命令组织，不会减少drawcall，性能中等。
         */
        cacheAs: string;
        /**设置cacheAs为非空时此值才有效，staticCache=true时，子对象变化时不会自动更新缓存，只能通过调用reCache方法手动刷新。*/
        staticCache: boolean;
        /**在设置cacheAs的情况下，调用此方法会重新刷新缓存。*/
        reCache(): void;
        /**表示显示对象相对于父容器的水平方向坐标值。*/
        x: number;
        /**表示显示对象相对于父容器的垂直方向坐标值。*/
        y: number;
        /**
         * 表示显示对象的宽度，以像素为单位。
         * 宽度默认为0，可以手动设置，或者通过getbounds获取实际宽度。设置此宽度只用来做鼠标碰撞使用，改变后并不影响显示对象大小。
         */
        width: number;
        /**
         * 表示显示对象的高度，以像素为单位。
         * 高度默认为0，可以手动设置，或者通过getbounds获取实际宽度。设置此高度只用来做鼠标碰撞使用，改变后并不影响显示对象大小。
         */
        height: number;
        /**
         * 设置bounds大小，如果有设置，则不再通过getBounds计算，合理使用能提高性能。
         * @param	bound bounds矩形区域
         */
        setBounds(bound: laya.maths.Rectangle): void;
        /**
         * 获取本对象在父容器坐标系的矩形显示区域。
         * <p><b>注意：</b>计算量较大，尽量少用。</p>
         * @return 矩形区域。
         */
        getBounds(): laya.maths.Rectangle;
        /**
         * 获取本对象在自己坐标系的矩形显示区域。
         * <p><b>注意：</b>计算量较大，尽量少用。</p>
         * @return 矩形区域。
         */
        getSelfBounds(): laya.maths.Rectangle;
        /**
         * @private
         * 获取本对象在父容器坐标系的显示区域多边形顶点列表。
         * 当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
         * @param ifRotate 之前的对象链中是否有旋转。
         * @return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
         */
        _boundPointsToParent(ifRotate?: boolean): Array<any>;
        /**
         * 返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域，不包括子对象。
         * @param realSize 使用图片的真实大小，默认为false
         * @return 一个 Rectangle 对象，表示获取到的显示区域。
         */
        getGraphicBounds(realSize?: boolean): laya.maths.Rectangle;
        /**
         * @private
         * 获取自己坐标系的显示区域多边形顶点列表
         * @param ifRotate 当前的显示对象链是否由旋转
         * @return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
         */
        _getBoundPointsM(ifRotate?: boolean): Array<any>;
        /**
         * @private
         * 获取样式。
         * @return  样式 Style 。
         */
        getStyle(): laya.display.css.Style;
        /**
         * @private
         * 设置样式。
         * @param	value 样式。
         */
        setStyle(value: laya.display.css.Style): void;
        /**X轴缩放值，默认值为1。设置为负数，可以实现水平反转效果，比如scaleX=-1。*/
        scaleX: number;
        /**Y轴缩放值，默认值为1。设置为负数，可以实现垂直反转效果，比如scaleX=-1。*/
        scaleY: number;
        /**旋转角度，默认值为0。以角度为单位。*/
        rotation: number;
        /**水平倾斜角度，默认值为0。以角度为单位。*/
        skewX: number;
        /**垂直倾斜角度，默认值为0。以角度为单位。*/
        skewY: number;
        protected _adjustTransform(): laya.maths.Matrix;
        /**
         * 对象的矩阵信息。通过设置矩阵可以实现节点旋转，缩放，位移效果。
         * 矩阵更多信息请参考 <code>Matrix</code>
         */
        transform: laya.maths.Matrix;
        /**X轴 轴心点的位置，单位为像素，默认为0。轴心点会影响对象位置，缩放中心，旋转中心。*/
        pivotX: number;
        /**Y轴 轴心点的位置，单位为像素，默认为0。轴心点会影响对象位置，缩放中心，旋转中心。*/
        pivotY: number;
        /**透明度，值为0-1，默认值为1，表示不透明。更改alpha值会影响drawcall。*/
        alpha: number;
        /**表示是否可见，默认为true。如果设置不可见，节点将不被渲染。*/
        visible: boolean;
        /**指定要使用的混合模式。目前只支持"lighter"。*/
        blendMode: string;
        /**绘图对象。封装了绘制位图和矢量图的接口，Sprite所有的绘图操作都通过Graphics来实现的。*/
        graphics: Graphics;
        /**显示对象的滚动矩形范围，具有裁剪效果(如果只想限制子对象渲染区域，请使用viewport)，设置optimizeScrollRect=true，可以优化裁剪区域外的内容不进行渲染。
         * srollRect和viewport的区别：
         * 1.srollRect自带裁剪效果，viewport只影响子对象渲染是否渲染，不具有裁剪效果（性能更高）。
         * 2.设置rect的x,y属性均能实现区域滚动效果，但scrollRect会保持0,0点位置不变。
         * */
        scrollRect: laya.maths.Rectangle;
        /**
         * 设置坐标位置。相当于分别设置x和y属性。
         * @param	x X 轴坐标。
         * @param	y Y 轴坐标。
         * @param 	speedMode 是否极速模式，正常是调用this.x=value进行赋值，极速模式直接调用内部函数处理，如果未重写x,y属性，建议设置为急速模式性能更高。
         * @return	返回对象本身。
         */
        pos(x: number, y: number, speedMode?: boolean): Sprite;
        /**
         * 设置轴心点。相当于分别设置pivotX和pivotY属性。
         * @param	x X轴心点。
         * @param	y Y轴心点。
         * @return	返回对象本身。
         */
        pivot(x: number, y: number): Sprite;
        /**
         * 设置宽高。相当于分别设置width和height属性。
         * @param	width 宽度值。
         * @param	hegiht 高度值。
         * @return	返回对象本身。
         */
        size(width: number, height: number): Sprite;
        /**
         * 设置缩放。相当于分别设置scaleX和scaleY属性。
         * @param	scaleX X轴缩放比例。
         * @param	scaleY Y轴缩放比例。
         * @param 	speedMode 是否极速模式，正常是调用this.scaleX=value进行赋值，极速模式直接调用内部函数处理，如果未重写scaleX,scaleY属性，建议设置为急速模式性能更高。
         * @return	返回对象本身。
         */
        scale(scaleX: number, scaleY: number, speedMode?: boolean): Sprite;
        /**
         * 设置倾斜角度。相当于分别设置skewX和skewY属性。
         * @param	skewX 水平倾斜角度。
         * @param	skewY 垂直倾斜角度。
         * @return	返回对象本身
         */
        skew(skewX: number, skewY: number): Sprite;
        /**
         * 更新、呈现显示对象。由系统调用。
         * @param	context 渲染的上下文引用。
         * @param	x X轴坐标。
         * @param	y Y轴坐标。
         */
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 绘制 当前<code>Sprite</code> 到 <code>Canvas</code> 上，并返回一个HtmlCanvas
         * 绘制的结果可以当作图片源，再次绘制到其他Sprite里面，示例：
         *
         * var htmlCanvas:HTMLCanvas = sprite.drawToCanvas(100, 100, 0, 0);//把精灵绘制到canvas上面
         * var texture:Texture = new Texture(htmlCanvas);//使用htmlCanvas创建Texture
         * var sp:Sprite = new Sprite().pos(0, 200);//创建精灵并把它放倒200位置
         * sp.graphics.drawTexture(texture);//把截图绘制到精灵上
         * Laya.stage.addChild(sp);//把精灵显示到舞台
         *
         * 也可以获取原始图片数据，分享到网上，从而实现截图效果，示例：
         *
         * var htmlCanvas:HTMLCanvas = sprite.drawToCanvas(100, 100, 0, 0);//把精灵绘制到canvas上面
         * var canvas:* = htmlCanvas.getCanvas();//获取原生的canvas对象
         * trace(canvas.toDataURL("image/png"));//打印图片base64信息，可以发给服务器或者保存为图片
         *
         * @param	canvasWidth 画布宽度。
         * @param	canvasHeight 画布高度。
         * @param	x 绘制的 X 轴偏移量。
         * @param	y 绘制的 Y 轴偏移量。
         * @return  HTMLCanvas 对象。
         */
        drawToCanvas(canvasWidth: number, canvasHeight: number, offsetX: number, offsetY: number): laya.resource.HTMLCanvas;
        /**
         * 自定义更新、呈现显示对象。一般用来扩展渲染模式，请合理使用，可能会导致在加速器上无法渲染。
         * <p><b>注意</b>不要在此函数内增加或删除树节点，否则会对树节点遍历造成影响。</p>
         * @param	context  渲染的上下文引用。
         * @param	x X轴坐标。
         * @param	y Y轴坐标。
         */
        customRender(context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         * 应用滤镜。
         */
        _applyFilters(): void;
        /**滤镜集合。可以设置多个滤镜组合。*/
        filters: Array<any>;
        /**
         * @private
         * 查看当前原件中是否包含发光滤镜。
         * @return 一个 Boolean 值，表示当前原件中是否包含发光滤镜。
         */
        _isHaveGlowFilter(): boolean;
        /**
         * 把本地坐标转换为相对stage的全局坐标。
         * @param	point 本地坐标点。
         * @param	createNewPoint 是否创建一个新的Point对象作为返回值，默认为false，使用输入的point对象返回，减少对象创建开销。
         * @return  转换后的坐标的点。
         */
        localToGlobal(point: laya.maths.Point, createNewPoint?: boolean): laya.maths.Point;
        /**
         * 把stage的全局坐标转换为本地坐标。
         * @param	point 全局坐标点。
         * @param	createNewPoint 是否创建一个新的Point对象作为返回值，默认为false，使用输入的point对象返回，减少对象创建开销。
         * @return 转换后的坐标的点。
         */
        globalToLocal(point: laya.maths.Point, createNewPoint?: boolean): laya.maths.Point;
        /**
         * 将本地坐标系坐标转转换到父容器坐标系。
         * @param point 本地坐标点。
         * @return  转换后的点。
         */
        toParentPoint(point: laya.maths.Point): laya.maths.Point;
        /**
         * 将父容器坐标系坐标转换到本地坐标系。
         * @param point 父容器坐标点。
         * @return  转换后的点。
         */
        fromParentPoint(point: laya.maths.Point): laya.maths.Point;
        /**
         * 增加事件侦听器，以使侦听器能够接收事件通知。
         * 如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	args 事件侦听函数的回调参数。
         * @return 此 EventDispatcher 对象。
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        /**
         * 增加事件侦听器，以使侦听器能够接收事件通知，此侦听事件响应一次后则自动移除侦听。
         * 如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	args 事件侦听函数的回调参数。
         * @return 此 EventDispatcher 对象。
         */
        once(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        parent: Node;
        /**
         * 加载并显示一个图片。功能等同于graphics.loadImage方法。支持异步加载。
         * 注意：多次调用loadImage绘制不同的图片，会同时显示。
         * @param	url	图片地址。
         * @param	x 显示图片的x位置
         * @param	y 显示图片的y位置
         * @param	width 显示图片的宽度，设置为0表示使用图片默认宽度
         * @param	height 显示图片的高度，设置为0表示使用图片默认高度
         * @param	complete 加载完成回调
         * @return	返回精灵对象本身
         */
        loadImage(url: string, x?: number, y?: number, width?: number, height?: number, complete?: laya.utils.Handler): Sprite;
        /**
         * 根据图片地址创建一个新的 <code>Sprite</code> 对象用于加载并显示此图片。
         * @param	url 图片地址。
         * @return	返回新的 <code>Sprite</code> 对象。
         */
        static fromImage(url: string): Sprite;
        /**cacheAs后，设置自己和父对象缓存失效。*/
        repaint(): void;
        /**
         * @private
         * 获取是否重新缓存。
         * @return 如果重新缓存值为 true，否则值为 false。
         */
        _needRepaint(): boolean;
        protected _childChanged(child?: Node): void;
        /**cacheAs时，设置所有父对象缓存失效。 */
        parentRepaint(): void;
        /**对舞台 <code>stage</code> 的引用。*/
        stage: Stage;
        /**可以设置一个Rectangle区域作为点击区域，或者设置一个<code>HitArea</code>实例作为点击区域，HitArea内可以设置可点击和不可点击区域。
         * 如果不设置hitArea，则根据宽高形成的区域进行碰撞。
         */
        hitArea: any;
        /**遮罩，可以设置一个对象(支持位图和矢量图)，根据对象形状进行遮罩显示。
         *【注意】遮罩对象坐标系是相对遮罩对象本身的，和Flash机制不同*/
        mask: Sprite;
        /**
         * 是否接受鼠标事件。
         * 默认为false，如果监听鼠标事件，则会自动设置本对象及父节点的属性 mouseEnable 的值都为 true（如果父节点手动设置为false，则不会更改）。
         * */
        mouseEnabled: boolean;
        /**
         * 开始拖动此对象。
         * @param	area 拖动区域，此区域为当前对象注册点活动区域（不包括对象宽高），可选。
         * @param	hasInertia 鼠标松开后，是否还惯性滑动，默认为false，可选。
         * @param	elasticDistance 橡皮筋效果的距离值，0为无橡皮筋效果，默认为0，可选。
         * @param	elasticBackTime 橡皮筋回弹时间，单位为毫秒，默认为300毫秒，可选。
         * @param	data 拖动事件携带的数据，可选。
         * @param	disableMouseEvent 禁用其他对象的鼠标检测，默认为false，设置为true能提高性能。
         * @param	ratio 惯性阻尼系数，影响惯性力度和时长。
         */
        startDrag(area?: laya.maths.Rectangle, hasInertia?: boolean, elasticDistance?: number, elasticBackTime?: number, data?: any, disableMouseEvent?: boolean, ratio?: number): void;
        /**停止拖动此对象。*/
        stopDrag(): void;
        _setDisplay(value: boolean): void;
        /**
         * 检测某个点是否在此对象内。
         * @param	x 全局x坐标。
         * @param	y 全局y坐标。
         * @return  表示是否在对象内。
         */
        hitTestPoint(x: number, y: number): boolean;
        /**获得相对于本对象上的鼠标坐标信息。*/
        getMousePoint(): laya.maths.Point;
        /**
         * 获得相对于stage的全局X轴缩放值（会叠加父亲节点的缩放值）。
         */
        globalScaleX: number;
        /**
         * 获得相对于stage的全局Y轴缩放值（会叠加父亲节点的缩放值）。
         */
        globalScaleY: number;
        /**
         * 返回鼠标在此对象坐标系上的 X 轴坐标信息。
         */
        mouseX: number;
        /**
         * 返回鼠标在此对象坐标系上的 Y 轴坐标信息。
         */
        mouseY: number;
        /**z排序，更改此值，则会按照值的大小对同一容器的所有对象重新排序。值越大，越靠上。默认为0，则根据添加顺序排序。*/
        zOrder: number;
        /**设置一个Texture实例，并显示此图片（如果之前有其他绘制，则会被清除掉）。等同于graphics.clear();graphics.drawTexture()*/
        texture: laya.resource.Texture;
        _getWords(): Array<any>;
        _addChildsToLayout(out: Array<any>): boolean;
        _addToLayout(out: Array<any>): void;
        _isChar(): boolean;
        _getCSSStyle(): laya.display.css.CSSStyle;
        /**
         * @private
         * 设置指定属性名的属性值。
         * @param	name 属性名。
         * @param	value 属性值。
         */
        _setAttributes(name: string, value: string): void;
        /**
         * @private
         */
        _layoutLater(): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Stage</code> 是舞台类，显示列表的根节点，所有显示对象都在舞台上显示。通过 Laya.stage 单例访问。</p>
     * Stage提供几种适配模式，不同的适配模式会产生不同的画布大小，画布越大，渲染压力越大，所以要选择合适的适配方案。
     * Stage提供不同的帧率模式，帧率越高，渲染压力越大，越费电，合理使用帧率甚至动态更改帧率有利于改进手机耗电。
     */
    class Stage extends Sprite {
        /**应用保持设计宽高不变，不缩放不变型，stage的宽高等于设计宽高。*/
        static SCALE_NOSCALE: string;
        /**应用根据屏幕大小铺满全屏，非等比缩放会变型，stage的宽高等于设计宽高。*/
        static SCALE_EXACTFIT: string;
        /**应用显示全部内容，按照最小比率缩放，等比缩放不变型，一边可能会留空白，stage的宽高等于设计宽高。*/
        static SCALE_SHOWALL: string;
        /**应用按照最大比率缩放显示，宽或高方向会显示一部分，等比缩放不变型，stage的宽高等于设计宽高。*/
        static SCALE_NOBORDER: string;
        /**应用保持设计宽高不变，不缩放不变型，stage的宽高等于屏幕宽高。*/
        static SCALE_FULL: string;
        /**应用保持设计宽度不变，高度根据屏幕比缩放，stage的宽度等于设计高度，高度根据屏幕比率大小而变化*/
        static SCALE_FIXED_WIDTH: string;
        /**应用保持设计高度不变，宽度根据屏幕比缩放，stage的高度等于设计宽度，宽度根据屏幕比率大小而变化*/
        static SCALE_FIXED_HEIGHT: string;
        /**画布水平居左对齐。*/
        static ALIGN_LEFT: string;
        /**画布水平居右对齐。*/
        static ALIGN_RIGHT: string;
        /**画布水平居中对齐。*/
        static ALIGN_CENTER: string;
        /**画布垂直居上对齐。*/
        static ALIGN_TOP: string;
        /**画布垂直居中对齐。*/
        static ALIGN_MIDDLE: string;
        /**画布垂直居下对齐。*/
        static ALIGN_BOTTOM: string;
        /**不更改屏幕。*/
        static SCREEN_NONE: string;
        /**自动横屏。*/
        static SCREEN_HORIZONTAL: string;
        /**自动竖屏。*/
        static SCREEN_VERTICAL: string;
        /**全速模式，以60的帧率运行。*/
        static FRAME_FAST: string;
        /**慢速模式，以30的帧率运行。*/
        static FRAME_SLOW: string;
        /**自动模式，以30的帧率运行，但鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗。*/
        static FRAME_MOUSE: string;
        /**休眠模式，以1的帧率运行*/
        static FRAME_SLEEP: string;
        /**当前焦点对象，此对象会影响当前键盘事件的派发主体。*/
        focus: Node;
        offset: laya.maths.Point;
        /**帧率类型，支持三种模式：fast-60帧(默认)，slow-30帧，mouse-30帧（鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗），sleep-1帧。*/
        frameRate: string;
        /**设计宽度（初始化时设置的宽度Laya.init(width,height)）*/
        designWidth: number;
        /**设计高度（初始化时设置的高度Laya.init(width,height)）*/
        designHeight: number;
        /**画布是否发生翻转。*/
        canvasRotation: boolean;
        /**画布的旋转角度。*/
        canvasDegree: number;
        /**设置是否渲染，设置为false，可以停止渲染，画面会停留到最后一次渲染上，减少cpu消耗，此设置不影响时钟
         * 比如非激活状态，可以设置renderingEnabled=true以节省消耗。*/
        renderingEnabled: boolean;
        /**是否启用屏幕适配，可以适配后，在某个时候关闭屏幕适配，防止某些操作导致的屏幕以外改变*/
        screenAdaptationEnabled: boolean;
        _canvasTransform: laya.maths.Matrix;
        _scenes: Array<any>;
        _wgColor: Array<any>;
        /**场景类，引擎中只有一个stage实例，此实例可以通过Laya.stage访问。*/
        constructor();
        width: number;
        height: number;
        transform: laya.maths.Matrix;
        desginWidth: number;
        desginHeight: number;
        /**
         * 舞台是否获得焦点。
         */
        isFocused: boolean;
        /**
         * 舞台是否处于可见状态(是否进入后台)。
         */
        isVisibility: boolean;
        protected _resetCanvas(): void;
        /**
         * 设置屏幕大小，场景会根据屏幕大小进行适配。可以动态调用此方法，来更改游戏显示的大小。
         * @param	screenWidth		屏幕宽度。
         * @param	screenHeight	屏幕高度。
         */
        setScreenSize(screenWidth: number, screenHeight: number): void;
        /**
         * <p>缩放模式。</p>
         * <p><ul>取值范围：
         * <li>"noscale" ：不缩放；</li>
         * <li>"exactfit" ：全屏不等比缩放；</li>
         * <li>"showall" ：最小比例缩放；</li>
         * <li>"noborder" ：最大比例缩放；</li>
         * <li>"full" ：不缩放，stage的宽高等于屏幕宽高；</li>
         * <li>"fixedwidth" ：宽度不变，高度根据屏幕比缩放；</li>
         * <li>"fixedheight" ：高度不变，宽度根据屏幕比缩放；</li>
         * </ul></p>
         * 默认值为 "noscale"。
         */
        scaleMode: string;
        /**
         * 水平对齐方式。
         * <p><ul>取值范围：
         * <li>"left" ：居左对齐；</li>
         * <li>"center" ：居中对齐；</li>
         * <li>"right" ：居右对齐；</li>
         * </ul></p>
         * 默认值为"left"。
         */
        alignH: string;
        /**
         * 垂直对齐方式。
         * <p><ul>取值范围：
         * <li>"top" ：居顶部对齐；</li>
         * <li>"middle" ：居中对齐；</li>
         * <li>"bottom" ：居底部对齐；</li>
         * </ul></p>
         * 默认值为"top"。
         */
        alignV: string;
        /**舞台的背景颜色，默认为黑色，null为透明。*/
        bgColor: string;
        /**鼠标在 Stage 上的 X 轴坐标。*/
        mouseX: number;
        /**鼠标在 Stage 上的 Y 轴坐标。*/
        mouseY: number;
        /**@inheritDoc */
        getMousePoint(): laya.maths.Point;
        /**当前视窗由缩放模式导致的 X 轴缩放系数。*/
        clientScaleX: number;
        /**当前视窗由缩放模式导致的 Y 轴缩放系数。*/
        clientScaleY: number;
        /**
         * 场景布局类型。
         * <p><ul>取值范围：
         * <li>"none" ：不更改屏幕</li>
         * <li>"horizontal" ：自动横屏</li>
         * <li>"vertical" ：自动竖屏</li>
         * </ul></p>
         */
        screenMode: string;
        /**@inheritDoc */
        repaint(): void;
        /**@inheritDoc */
        parentRepaint(): void;
        _loop(): boolean;
        /**获得距当前帧开始后，过了多少时间，单位为毫秒
         * 可以用来判断函数内时间消耗，通过合理控制每帧函数处理消耗时长，避免一帧做事情太多，对复杂计算分帧处理，能有效降低帧率波动。*/
        getTimeFromFrameStart(): number;
        visible: boolean;
        /**@inheritDoc */
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        /**是否开启全屏，用户点击后进入全屏。
         * 兼容性提示：部分浏览器不允许点击进入全屏，比如Iphone等*/
        fullScreenEnabled: boolean;
        /**退出全屏模式*/
        exitFullscreen(): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
     * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
     * <listing version="3.0">
     * package
     * {
     * 	import laya.display.Text;
     * 	public class Text_Example
     * 	{
     * 		public function Text_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			onInit();
     * 		}
     * 		private function onInit():void
     * 		{
     * 			var text:Text = new Text();//创建一个 Text 类的实例对象 text 。
     * 			text.text = "这个是一个 Text 文本示例。";
     * 			text.color = "#008fff";//设置 text 的文本颜色。
     * 			text.font = "Arial";//设置 text 的文本字体。
     * 			text.bold = true;//设置 text 的文本显示为粗体。
     * 			text.fontSize = 30;//设置 text 的字体大小。
     * 			text.wordWrap = true;//设置 text 的文本自动换行。
     * 			text.x = 100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
     * 			text.y = 100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
     * 			text.width = 300;//设置 text 的宽度。
     * 			text.height = 200;//设置 text 的高度。
     * 			text.italic = true;//设置 text 的文本显示为斜体。
     * 			text.borderColor = "#fff000";//设置 text 的文本边框颜色。
     * 			Laya.stage.addChild(text);//将 text 添加到显示列表。
     * 		}
     * 	}
     * }
     * </listing>
     * <listing version="3.0">
     * Text_Example();
     * function Text_Example()
     * {
     *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *     onInit();
     * }
     * function onInit()
     * {
     *     var text = new laya.display.Text();//创建一个 Text 类的实例对象 text 。
     *     text.text = "这个是一个 Text 文本示例。";
     *     text.color = "#008fff";//设置 text 的文本颜色。
     *     text.font = "Arial";//设置 text 的文本字体。
     *     text.bold = true;//设置 text 的文本显示为粗体。
     *     text.fontSize = 30;//设置 text 的字体大小。
     *     text.wordWrap = true;//设置 text 的文本自动换行。
     *     text.x = 100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
     *     text.y = 100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
     *     text.width = 300;//设置 text 的宽度。
     *     text.height = 200;//设置 text 的高度。
     *     text.italic = true;//设置 text 的文本显示为斜体。
     *     text.borderColor = "#fff000";//设置 text 的文本边框颜色。
     *     Laya.stage.addChild(text);//将 text 添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * class Text_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.onInit();
     *     }
     *     private onInit(): void {
     *         var text: laya.display.Text = new laya.display.Text();//创建一个 Text 类的实例对象 text 。
     *         text.text = "这个是一个 Text 文本示例。";
     *         text.color = "#008fff";//设置 text 的文本颜色。
     *         text.font = "Arial";//设置 text 的文本字体。
     *         text.bold = true;//设置 text 的文本显示为粗体。
     *         text.fontSize = 30;//设置 text 的字体大小。
     *         text.wordWrap = true;//设置 text 的文本自动换行。
     *         text.x = 100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
     *         text.y = 100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
     *         text.width = 300;//设置 text 的宽度。
     *         text.height = 200;//设置 text 的高度。
     *         text.italic = true;//设置 text 的文本显示为斜体。
     *         text.borderColor = "#fff000";//设置 text 的文本边框颜色。
     *         Laya.stage.addChild(text);//将 text 添加到显示列表。
     *     }
     * }
     * </listing>
     */
    class Text extends Sprite {
        static _testWord: string;
        /**语言包*/
        static langPacks: any;
        /**visible不进行任何裁切。*/
        static VISIBLE: string;
        /**scroll 不显示文本域外的字符像素，并且支持 scroll 接口。*/
        static SCROLL: string;
        /**hidden 不显示超出文本域的字符。*/
        static HIDDEN: string;
        private static _bitmapFonts;
        protected _text: string;
        protected _isChanged: boolean;
        protected _textWidth: number;
        protected _textHeight: number;
        protected _lines: Array<any>;
        protected _lineWidths: Array<any>;
        protected _startX: number;
        protected _startY: number;
        protected _lastVisibleLineIndex: number;
        protected _words: Array<any>;
        protected _charSize: any;
        /**overflow 指定文本超出文本域后的行为。其值为"hidden"、"visible"和"scroll"之一。
         * 性能从高至低为：hidden > visible > scroll*/
        overflow: string;
        /**
         * 是否显示下划线。
         */
        underline: boolean;
        /**
         * 创建一个新的 <code>Text</code> 实例。
         */
        constructor();
        /**
         * 注册位图字体。
         * @param	name		位图字体的名称。
         * @param	bitmapFont	位图字体文件。
         */
        static registerBitmapFont(name: string, bitmapFont: BitmapFont): void;
        /**
         * 移除注册的位图字体文件。
         * @param	name		位图字体的名称。
         * @param	destroy		是否销毁当前字体文件。
         */
        static unregisterBitmapFont(name: string, destroy?: boolean): void;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**
         * @private
         * @inheritDoc
         */
        _getBoundPointsM(ifRotate?: boolean): Array<any>;
        /**
         * @inheritDoc
         */
        getGraphicBounds(realSize?: boolean): laya.maths.Rectangle;
        /**
         * @inheritDoc
         */
        width: number;
        /**
         * @private
         * @inheritDoc
         */
        _getCSSStyle(): laya.display.css.CSSStyle;
        /**
         * @inheritDoc
         */
        height: number;
        /**
         * 表示文本的宽度，以像素为单位。
         */
        textWidth: number;
        /**
         * 表示文本的高度，以像素为单位。
         */
        textHeight: number;
        /** 当前文本的内容字符串。*/
        text: string;
        /**
         * <p>根据指定的文本，从语言包中取当前语言的文本内容。并对此文本中的
         * <p>例如：
         * <li>（1）text 的值为“我的名字”，先取到这个文本对应的当前语言版本里的值“My name”，将“My name”设置为当前文本的内容。</li>
         * <li>（2）text 的值为“恭喜你赢得
         * 			则先取到这个文本对应的当前语言版本里的值“Congratulations on your winning
         * 			然后将文本里的
         * 			将替换处理后的文本“Congratulations on your winning 100 diamonds, 200 experience.”设置为当前文本的内容。
         * </li>
         * </p>
         * @param	text 文本内容。
         * @param	...args 文本替换参数。
         */
        lang(text: string, arg1?: any, arg2?: any, arg3?: any, arg4?: any, arg5?: any, arg6?: any, arg7?: any, arg8?: any, arg9?: any, arg10?: any): void;
        /**
         * 文本的字体名称，以字符串形式表示。
         * <p>默认值为："Arial"，可以通过Font.defaultFont设置默认字体。</p>
         * @see laya.display.css.Font#defaultFamily
         */
        font: string;
        /**
         * 指定文本的字体大小（以像素为单位）。
         * <p>默认为20像素，可以通过 <code>Text.defaultSize</code> 设置默认大小。</p>
         */
        fontSize: number;
        /**
         * 指定文本是否为粗体字。
         * <p>默认值为 false，这意味着不使用粗体字。如果值为 true，则文本为粗体字。</p>
         */
        bold: boolean;
        /**
         * 表示文本的颜色值。可以通过 <code>Text.defaultColor</code> 设置默认颜色。
         * <p>默认值为黑色。</p>
         */
        color: string;
        /**
         * 表示使用此文本格式的文本是否为斜体。
         * <p>默认值为 false，这意味着不使用斜体。如果值为 true，则文本为斜体。</p>
         */
        italic: boolean;
        /**
         * 表示文本的水平显示方式。
         * <p><b>取值：</b>
         * <li>"left"： 居左对齐显示。</li>
         * <li>"center"： 居中对齐显示。</li>
         * <li>"right"： 居右对齐显示。</li>
         * </p>
         */
        align: string;
        /**
         * 表示文本的垂直显示方式。
         * <p><b>取值：</b>
         * <li>"top"： 居顶部对齐显示。</li>
         * <li>"middle"： 居中对齐显示。</li>
         * <li>"bottom"： 居底部对齐显示。</li>
         * </p>
         */
        valign: string;
        /**
         * 表示文本是否自动换行，默认为false。
         * <p>若值为true，则自动换行；否则不自动换行。</p>
         */
        wordWrap: boolean;
        /**
         * 垂直行间距（以像素为单位）。
         */
        leading: number;
        /**
         * 边距信息。
         * <p>数据格式：[上边距，右边距，下边距，左边距]（边距以像素为单位）。</p>
         */
        padding: Array<any>;
        /**
         * 文本背景颜色，以字符串表示。
         */
        bgColor: string;
        /**
         * 文本边框背景颜色，以字符串表示。
         */
        borderColor: string;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         */
        stroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * 默认值为 "#000000"（黑色）;
         */
        strokeColor: string;
        protected isChanged: boolean;
        protected renderText(begin: number, visibleLineCount: number): void;
        /**
         * <p>排版文本。</p>
         * <p>进行宽高计算，渲染、重绘文本。</p>
         */
        typeset(): void;
        /**
         * 快速更改显示文本。不进行排版计算，效率较高。
         * <p>如果只更改文字内容，不更改文字样式，建议使用此接口，能提高效率。</p>
         * @param text 文本内容。
         */
        changeText(text: string): void;
        protected parseLines(text: string): void;
        protected parseLine(line: string, wordWrapWidth: number): void;
        /**
         * 返回字符的位置信息。
         * @param	charIndex 索引位置。
         * @param	out 输出的Point引用。
         * @return	返回Point位置信息。
         */
        getCharPoint(charIndex: number, out?: laya.maths.Point): laya.maths.Point;
        /**
         * 获取横向滚动量。
         */
        /**
         * 设置横向滚动量。
         * <p>即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。</p>
         */
        scrollX: number;
        /**
         * 获取纵向滚动量。
         */
        /**
         * 设置纵向滚动量（px)。即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。
         */
        scrollY: number;
        /**
         * 获取横向可滚动最大值。
         */
        maxScrollX: number;
        /**
         * 获取纵向可滚动最大值。
         */
        maxScrollY: number;
        lines: Array<any>;
        underlineColor: string;
    }
}
declare module laya.events {
    /**
     * <code>Event</code> 是事件类型的集合。
     */
    class Event {
        /** 一个空的 Event 对象。用于事件派发中转使用。*/
        static EMPTY: Event;
        /** 定义 mousedown 事件对象的 type 属性值。*/
        static MOUSE_DOWN: string;
        /** 定义 mouseup 事件对象的 type 属性值。*/
        static MOUSE_UP: string;
        /** 定义 click 事件对象的 type 属性值。*/
        static CLICK: string;
        /** 定义 rightmousedown 事件对象的 type 属性值。*/
        static RIGHT_MOUSE_DOWN: string;
        /** 定义 rightmouseup 事件对象的 type 属性值。*/
        static RIGHT_MOUSE_UP: string;
        /** 定义 rightclick 事件对象的 type 属性值。*/
        static RIGHT_CLICK: string;
        /** 定义 mousemove 事件对象的 type 属性值。*/
        static MOUSE_MOVE: string;
        /** 定义 mouseover 事件对象的 type 属性值。*/
        static MOUSE_OVER: string;
        /** 定义 mouseout 事件对象的 type 属性值。*/
        static MOUSE_OUT: string;
        /** 定义 mousewheel 事件对象的 type 属性值。*/
        static MOUSE_WHEEL: string;
        /** 定义 mouseover 事件对象的 type 属性值。*/
        static ROLL_OVER: string;
        /** 定义 mouseout 事件对象的 type 属性值。*/
        static ROLL_OUT: string;
        /** 定义 doubleclick 事件对象的 type 属性值。*/
        static DOUBLE_CLICK: string;
        /** 定义 change 事件对象的 type 属性值。*/
        static CHANGE: string;
        /** 定义 changed 事件对象的 type 属性值。*/
        static CHANGED: string;
        /** 定义 resize 事件对象的 type 属性值。*/
        static RESIZE: string;
        /** 定义 added 事件对象的 type 属性值。*/
        static ADDED: string;
        /** 定义 removed 事件对象的 type 属性值。*/
        static REMOVED: string;
        /** 定义 display 事件对象的 type 属性值。*/
        static DISPLAY: string;
        /** 定义 undisplay 事件对象的 type 属性值。*/
        static UNDISPLAY: string;
        /** 定义 error 事件对象的 type 属性值。*/
        static ERROR: string;
        /** 定义 complete 事件对象的 type 属性值。*/
        static COMPLETE: string;
        /** 定义 loaded 事件对象的 type 属性值。*/
        static LOADED: string;
        /** 定义 progress 事件对象的 type 属性值。*/
        static PROGRESS: string;
        /** 定义 input 事件对象的 type 属性值。*/
        static INPUT: string;
        /** 定义 render 事件对象的 type 属性值。*/
        static RENDER: string;
        /** 定义 open 事件对象的 type 属性值。*/
        static OPEN: string;
        /** 定义 message 事件对象的 type 属性值。*/
        static MESSAGE: string;
        /** 定义 close 事件对象的 type 属性值。*/
        static CLOSE: string;
        /** 定义 keydown 事件对象的 type 属性值。*/
        static KEY_DOWN: string;
        /** 定义 keypress 事件对象的 type 属性值。*/
        static KEY_PRESS: string;
        /** 定义 keyup 事件对象的 type 属性值。*/
        static KEY_UP: string;
        /** 定义 frame 事件对象的 type 属性值。*/
        static FRAME: string;
        /** 定义 dragstart 事件对象的 type 属性值。*/
        static DRAG_START: string;
        /** 定义 dragmove 事件对象的 type 属性值。*/
        static DRAG_MOVE: string;
        /** 定义 dragend 事件对象的 type 属性值。*/
        static DRAG_END: string;
        /** 定义 enter 事件对象的 type 属性值。*/
        static ENTER: string;
        /** 定义 select 事件对象的 type 属性值。*/
        static SELECT: string;
        /** 定义 blur 事件对象的 type 属性值。*/
        static BLUR: string;
        /** 定义 focus 事件对象的 type 属性值。*/
        static FOCUS: string;
        /** 定义 visibilitychange 事件对象的 type 属性值。*/
        static VISIBILITY_CHANGE: string;
        /** 定义 focuschange 事件对象的 type 属性值。*/
        static FOCUS_CHANGE: string;
        /** 定义 played 事件对象的 type 属性值。*/
        static PLAYED: string;
        /** 定义 paused 事件对象的 type 属性值。*/
        static PAUSED: string;
        /** 定义 stopped 事件对象的 type 属性值。*/
        static STOPPED: string;
        /** 定义 start 事件对象的 type 属性值。*/
        static START: string;
        /** 定义 end 事件对象的 type 属性值。*/
        static END: string;
        /** 定义 enablechanged 事件对象的 type 属性值。*/
        static ENABLE_CHANGED: string;
        /** 定义 activeinhierarchychanged 事件对象的 type 属性值。*/
        static ACTIVE_IN_HIERARCHY_CHANGED: string;
        /** 定义 componentadded 事件对象的 type 属性值。*/
        static COMPONENT_ADDED: string;
        /** 定义 componentremoved 事件对象的 type 属性值。*/
        static COMPONENT_REMOVED: string;
        /** 定义 layerchanged 事件对象的 type 属性值。*/
        static LAYER_CHANGED: string;
        /** 定义 hierarchyloaded 事件对象的 type 属性值。*/
        static HIERARCHY_LOADED: string;
        /** 定义 recovering 事件对象的 type 属性值。*/
        static RECOVERING: string;
        /** 定义 recovered 事件对象的 type 属性值。*/
        static RECOVERED: string;
        /** 定义 released 事件对象的 type 属性值。*/
        static RELEASED: string;
        /** 定义 link 事件对象的 type 属性值。*/
        static LINK: string;
        /** 定义 label 事件对象的 type 属性值。*/
        static LABEL: string;
        /**浏览器全屏更改时触发*/
        static FULL_SCREEN_CHANGE: string;
        /**显卡设备丢失时触发*/
        static DEVICE_LOST: string;
        /**模型更换时触发*/
        static MESH_CHANGED: string;
        /**材质更换时触发*/
        static MATERIAL_CHANGED: string;
        /**渲染队列更换时触发*/
        static RENDERQUEUE_CHANGED: string;
        /**世界矩阵更新时触发。*/
        static WORLDMATRIX_NEEDCHANGE: string;
        /**更换动作时触发。*/
        static ANIMATION_CHANGED: string;
        /** 事件类型。*/
        type: string;
        /** 原生浏览器事件。*/
        nativeEvent: any;
        /** 事件目标触发对象。*/
        target: laya.display.Sprite;
        /** 事件当前冒泡对象。*/
        currentTarget: laya.display.Sprite;
        _stoped: boolean;
        /** 分配给触摸点的唯一标识号（作为 int）。*/
        touchId: number;
        /**键盘值*/
        keyCode: number;
        /**滚轮滑动增量*/
        delta: number;
        /**
         * 设置事件数据。
         * @param	type 事件类型。
         * @param	currentTarget 事件目标触发对象。
         * @param	target 事件当前冒泡对象。
         * @return 返回当前 Event 对象。
         */
        setTo(type: string, currentTarget: laya.display.Sprite, target: laya.display.Sprite): Event;
        /**
         * 防止对事件流中当前节点的后续节点中的所有事件侦听器进行处理。
         */
        stopPropagation(): void;
        /**
         * 触摸点列表。
         */
        touches: Array<any>;
        /**
         * 表示 Alt 键是处于活动状态 (true) 还是非活动状态 (false)。
         */
        altKey: boolean;
        /**
         * 表示 Ctrl 键是处于活动状态 (true) 还是非活动状态 (false)。
         */
        ctrlKey: boolean;
        /**
         * 表示 Shift 键是处于活动状态 (true) 还是非活动状态 (false)。
         */
        shiftKey: boolean;
        /**
         * 包含按下或释放的键的字符代码值。字符代码值为英文键盘值。
         */
        charCode: boolean;
        /**
         * 表示键在键盘上的位置。这对于区分在键盘上多次出现的键非常有用。<br>
         * 例如，您可以根据此属性的值来区分左 Shift 键和右 Shift 键：左 Shift 键的值为 KeyLocation.LEFT，右 Shift 键的值为 KeyLocation.RIGHT。另一个示例是区分标准键盘 (KeyLocation.STANDARD) 与数字键盘 (KeyLocation.NUM_PAD) 上按下的数字键。
         */
        keyLocation: number;
        /**鼠标在 Stage 上的 X 轴坐标*/
        stageX: number;
        /**鼠标在 Stage 上的 Y 轴坐标*/
        stageY: number;
    }
}
declare module laya.events {
    /**
     * <code>EventDispatcher</code> 类是可调度事件的所有类的基类。
     */
    class EventDispatcher {
        static MOUSE_EVENTS: any;
        /**
         * 检查 EventDispatcher 对象是否为特定事件类型注册了任何侦听器。
         * @param	type 事件的类型。
         * @return 如果指定类型的侦听器已注册，则值为 true；否则，值为 false。
         */
        hasListener(type: string): boolean;
        /**
         * 派发事件。
         * @param	type 事件类型。
         * @param	data 回调数据。
         * 				<b>注意：</b>如果是需要传递多个参数 p1,p2,p3,...可以使用数组结构如：[p1,p2,p3,...] ；如果需要回调单个参数 p 是一个数组，则需要使用结构如：[p]，其他的单个参数 p ，可以直接传入参数 p。
         * @return 此事件类型是否有侦听者，如果有侦听者则值为 true，否则值为 false。
         */
        event(type: string, data?: any): boolean;
        /**
         * 使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	args 事件侦听函数的回调参数。
         * @return 此 EventDispatcher 对象。
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): EventDispatcher;
        /**
         * 使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	args 事件侦听函数的回调参数。
         * @return 此 EventDispatcher 对象。
         */
        once(type: string, caller: any, listener: Function, args?: Array<any>): EventDispatcher;
        _createListener(type: string, caller: any, listener: Function, args: Array<any>, once: boolean, offBefore?: boolean): EventDispatcher;
        /**
         * 从 EventDispatcher 对象中删除侦听器。
         * @param	type 事件的类型。
         * @param	caller 事件侦听函数的执行域。
         * @param	listener 事件侦听函数。
         * @param	onceOnly 如果值为 true ,则只移除通过 once 方法添加的侦听器。
         * @return 此 EventDispatcher 对象。
         */
        off(type: string, caller: any, listener: Function, onceOnly?: boolean): EventDispatcher;
        /**
         * 从 EventDispatcher 对象中删除指定事件类型的所有侦听器。
         * @param	type 事件类型，如果值为 null，则移除本对象所有类型的侦听器。
         * @return 此 EventDispatcher 对象。
         */
        offAll(type?: string): EventDispatcher;
        /**
         * 检测指定事件类型是否是鼠标事件。
         * @param	type 事件的类型。
         * @return	如果是鼠标事件，则值为 true;否则，值为 false。
         */
        isMouseEvent(type: string): boolean;
    }
    class EventHandler extends laya.utils.Handler {
        EventHandler(caller: any, method: Function, args: Array<any>, once: boolean): any;
        recover(): void;
        /**
         * 从对象池内创建一个Handler，默认会执行一次回收，如果不需要自动回收，设置once参数为false 。
         * @param	caller 执行域(this)
         * @param	method 回调方法
         * @param	args 携带的参数
         * @param	once 是否只执行一次，如果为true，回调后执行recover()进行回收，默认为true
         * @return  返回创建的handler实例
         */
        static create(caller: any, method: Function, args?: Array<any>, once?: boolean): laya.utils.Handler;
    }
}
declare module laya.events {
    /**
     * <code>Keyboard</code> 类的属性是一些常数，这些常数表示控制游戏时最常用的键。
     */
    class Keyboard {
        /** 与 0 的键控代码值(48)关联的常数。*/
        static NUMBER_0: number;
        /** 与 1 的键控代码值(49)关联的常数。*/
        static NUMBER_1: number;
        /** 与 2 的键控代码值(50)关联的常数。*/
        static NUMBER_2: number;
        /** 与 3 的键控代码值(51)关联的常数。*/
        static NUMBER_3: number;
        /** 与 4 的键控代码值(52)关联的常数。*/
        static NUMBER_4: number;
        /** 与 5 的键控代码值(53)关联的常数。*/
        static NUMBER_5: number;
        /** 与 6 的键控代码值(54)关联的常数。*/
        static NUMBER_6: number;
        /** 与 7 的键控代码值(55)关联的常数。*/
        static NUMBER_7: number;
        /** 与 8 的键控代码值(56)关联的常数。*/
        static NUMBER_8: number;
        /** 与 9 的键控代码值(57)关联的常数。*/
        static NUMBER_9: number;
        /** 与 A 键的键控代码值(65)关联的常数。*/
        static A: number;
        /** 与 B 键的键控代码值(66)关联的常数。*/
        static B: number;
        /** 与 C 键的键控代码值(67)关联的常数。*/
        static C: number;
        /** 与 D 键的键控代码值(68)关联的常数。*/
        static D: number;
        /** 与 E 键的键控代码值(69)关联的常数。*/
        static E: number;
        /** 与 F 键的键控代码值(70)关联的常数。*/
        static F: number;
        /** 与 G 键的键控代码值(71)关联的常数。*/
        static G: number;
        /** 与 H 键的键控代码值(72)关联的常数。*/
        static H: number;
        /** 与 I 键的键控代码值(73)关联的常数。*/
        static I: number;
        /** 与 J 键的键控代码值(74)关联的常数。*/
        static J: number;
        /** 与 K 键的键控代码值(75)关联的常数。*/
        static K: number;
        /** 与 L 键的键控代码值(76)关联的常数。*/
        static L: number;
        /** 与 M 键的键控代码值(77)关联的常数。*/
        static M: number;
        /** 与 N 键的键控代码值(78)关联的常数。*/
        static N: number;
        /** 与 O 键的键控代码值(79)关联的常数。*/
        static O: number;
        /** 与 P 键的键控代码值(80)关联的常数。*/
        static P: number;
        /** 与 Q 键的键控代码值(81)关联的常数。*/
        static Q: number;
        /** 与 R 键的键控代码值(82)关联的常数。*/
        static R: number;
        /** 与 S 键的键控代码值(83)关联的常数。*/
        static S: number;
        /** 与 T 键的键控代码值(84)关联的常数。*/
        static T: number;
        /** 与 U 键的键控代码值(85)关联的常数。*/
        static U: number;
        /** 与 V 键的键控代码值(86)关联的常数。*/
        static V: number;
        /** 与 W 键的键控代码值(87)关联的常数。*/
        static W: number;
        /** 与 X 键的键控代码值(88)关联的常数。*/
        static X: number;
        /** 与 Y 键的键控代码值(89)关联的常数。*/
        static Y: number;
        /** 与 Z 键的键控代码值(90)关联的常数。*/
        static Z: number;
        /** 与 F1 的键控代码值(112)关联的常数。*/
        static F1: number;
        /** 与 F2 的键控代码值(113)关联的常数。*/
        static F2: number;
        /** 与 F3 的键控代码值(114)关联的常数。*/
        static F3: number;
        /** 与 F4 的键控代码值(115)关联的常数。*/
        static F4: number;
        /** 与 F5 的键控代码值(116)关联的常数。*/
        static F5: number;
        /** 与 F6 的键控代码值(117)关联的常数。*/
        static F6: number;
        /** 与 F7 的键控代码值(118)关联的常数。*/
        static F7: number;
        /** 与 F8 的键控代码值(119)关联的常数。*/
        static F8: number;
        /** 与 F9 的键控代码值(120)关联的常数。*/
        static F9: number;
        /** 与 F10 的键控代码值(121)关联的常数。*/
        static F10: number;
        /** 与 F11 的键控代码值(122)关联的常数。*/
        static F11: number;
        /** 与 F12 的键控代码值(123)关联的常数。*/
        static F12: number;
        /** 与 F13 的键控代码值(124)关联的常数。*/
        static F13: number;
        /** 与 F14 的键控代码值(125)关联的常数。*/
        static F14: number;
        /** 与 F15 的键控代码值(126)关联的常数。*/
        static F15: number;
        /** 与数字键盘的伪键控代码(21)关联的常数。*/
        static NUMPAD: number;
        /** 与数字键盘上的数字 0 的键控代码值(96)关联的常数。*/
        static NUMPAD_0: number;
        /** 与数字键盘上的数字 1 的键控代码值(97)关联的常数。*/
        static NUMPAD_1: number;
        /** 与数字键盘上的数字 2 的键控代码值(98)关联的常数。*/
        static NUMPAD_2: number;
        /** 与数字键盘上的数字 3 的键控代码值(99)关联的常数。*/
        static NUMPAD_3: number;
        /** 与数字键盘上的数字 4 的键控代码值(100)关联的常数。*/
        static NUMPAD_4: number;
        /** 与数字键盘上的数字 5 的键控代码值(101)关联的常数。*/
        static NUMPAD_5: number;
        /** 与数字键盘上的数字 6 的键控代码值(102)关联的常数。*/
        static NUMPAD_6: number;
        /** 与数字键盘上的数字 7 的键控代码值(103)关联的常数。*/
        static NUMPAD_7: number;
        /** 与数字键盘上的数字 8 的键控代码值(104)关联的常数。*/
        static NUMPAD_8: number;
        /** 与数字键盘上的数字 9 的键控代码值(105)关联的常数。*/
        static NUMPAD_9: number;
        /** 与数字键盘上的加号(+)的键控代码值(107)关联的常数。*/
        static NUMPAD_ADD: number;
        /** 与数字键盘上的小数点(.)的键控代码值(110)关联的常数。*/
        static NUMPAD_DECIMAL: number;
        /** 与数字键盘上的除号(/)的键控代码值(111)关联的常数。*/
        static NUMPAD_DIVIDE: number;
        /** 与数字键盘上的 Enter 的键控代码值(108)关联的常数。*/
        static NUMPAD_ENTER: number;
        /** 与数字键盘上的乘号(*)的键控代码值(106)关联的常数。*/
        static NUMPAD_MULTIPLY: number;
        /** 与数字键盘上的减号(-)的键控代码值(109)关联的常数。*/
        static NUMPAD_SUBTRACT: number;
        /** 与 ; 键的键控代码值(186)关联的常数。*/
        static SEMICOLON: number;
        /** 与=键的键控代码值(187)关联的常数。*/
        static EQUAL: number;
        /** 与 F15 的键控代码值(188)关联的常数。*/
        static COMMA: number;
        /** 与 - 键的键控代码值(189)关联的常数。*/
        static MINUS: number;
        /** 与 . 键的键控代码值(190)关联的常数。*/
        static PERIOD: number;
        /** 与 / 键的键控代码值(191)关联的常数。*/
        static SLASH: number;
        /** 与 ` 键的键控代码值(192)关联的常数。*/
        static BACKQUOTE: number;
        /** 与 [ 键的键控代码值(219)关联的常数。*/
        static LEFTBRACKET: number;
        /** 与 \ 键的键控代码值(220)关联的常数。*/
        static BACKSLASH: number;
        /** 与 ] 键的键控代码值(221)关联的常数。*/
        static RIGHTBRACKET: number;
        /** 与 ' 键的键控代码值(222)关联的常数。*/
        static QUOTE: number;
        /** 与 Alternate(Option)键的键控代码值(18)关联的常数。*/
        static ALTERNATE: number;
        /** 与 Backspace 的键控代码值(8)关联的常数。*/
        static BACKSPACE: number;
        /** 与 Caps Lock 的键控代码值(20)关联的常数。*/
        static CAPS_LOCK: number;
        /** 与 Mac 命令键(15)关联的常数。*/
        static COMMAND: number;
        /** 与 Ctrl 的键控代码值(17)关联的常数。*/
        static CONTROL: number;
        /** 与 Delete 的键控代码值(46)关联的常数。*/
        static DELETE: number;
        /** 与 Enter 的键控代码值(13)关联的常数。*/
        static ENTER: number;
        /** 与 Esc 的键控代码值(27)关联的常数。*/
        static ESCAPE: number;
        /** 与 Page Up 的键控代码值(33)关联的常数。*/
        static PAGE_UP: number;
        /** 与 Page Down 的键控代码值(34)关联的常数。*/
        static PAGE_DOWN: number;
        /** 与 End 的键控代码值(35)关联的常数。*/
        static END: number;
        /** 与 Home 的键控代码值(36)关联的常数。*/
        static HOME: number;
        /** 与向左箭头键的键控代码值(37)关联的常数。*/
        static LEFT: number;
        /** 与向上箭头键的键控代码值(38)关联的常数。*/
        static UP: number;
        /** 与向右箭头键的键控代码值(39)关联的常数。*/
        static RIGHT: number;
        /** 与向下箭头键的键控代码值(40)关联的常数。*/
        static DOWN: number;
        /** 与 Shift 的键控代码值(16)关联的常数。*/
        static SHIFT: number;
        /** 与空格键的键控代码值(32)关联的常数。*/
        static SPACE: number;
        /** 与 Tab 的键控代码值(9)关联的常数。*/
        static TAB: number;
        /** 与 Insert 的键控代码值(45)关联的常数。*/
        static INSERT: number;
    }
}
declare module laya.events {
    /**
     * <p><code>KeyBoardManager</code> 是键盘事件管理类。</p>
     * <p>该类从浏览器中接收键盘事件，并派发该事件。
     * 派发事件时若 Stage.focus 为空则只从 Stage 上派发该事件，否则将从 Stage.focus 对象开始一直冒泡派发该事件。
     * 所以在 Laya.stage 上监听键盘事件一定能够收到，如果在其他地方监听，则必须处在Stage.focus的冒泡链上才能收到该事件。</p>
     * <p>用户可以通过代码 Laya.stage.focus=someNode 的方式来设置focus对象。</p>
     * <p>用户可统一的根据事件对象中 e.keyCode 来判断按键类型，该属性兼容了不同浏览器的实现。</p>
     */
    class KeyBoardManager {
        private static _pressKeys;
        /**是否开启键盘事件，默认为true*/
        static enabled: boolean;
        static _event: Event;
        static __init__(): void;
        /**
         * 返回指定键是否被按下。
         * @param	key 键值。
         * @return 是否被按下。
         */
        static hasKeyDown(key: number): boolean;
    }
}
declare module laya.events {
    /**
     * <p><code>KeyLocation</code> 类包含表示在键盘或类似键盘的输入设备上按键位置的常量。</p>
     * <p><code>KeyLocation</code> 常数用在键盘事件对象的 <code>keyLocation </code>属性中。</p>
     */
    class KeyLocation {
        /**
         * 表示激活的键不区分位于左侧还是右侧，也不区分是否位于数字键盘（或者是使用对应于数字键盘的虚拟键激活的）。
         */
        static STANDARD: number;
        /**
         * 表示激活的键在左侧键位置（此键有多个可能的位置）。
         */
        static LEFT: number;
        /**
         * 表示激活的键在右侧键位置（此键有多个可能的位置）。
         */
        static RIGHT: number;
        /**
         * <p>表示激活的键位于数字键盘或者是使用对应于数字键盘的虚拟键激活的。</p>
         * <p>注意：此属性只在flash模式下有效。</p>
         * */
        static NUM_PAD: number;
    }
}
declare module laya.events {
    /**
     * <code>MouseManager</code> 是鼠标、触摸交互管理器。
     */
    class MouseManager {
        /**
         * MouseManager 单例引用。
         */
        static instance: MouseManager;
        /**是否开启鼠标检测，默认为true*/
        static enabled: boolean;
        /** canvas 上的鼠标X坐标。*/
        mouseX: number;
        /** canvas 上的鼠标Y坐标。*/
        mouseY: number;
        /** 是否禁用除 stage 以外的鼠标事件检测。*/
        disableMouseEvent: boolean;
        /** 鼠标按下的时间。单位为毫秒。*/
        mouseDownTime: number;
        /** 鼠标移动精度。*/
        mouseMoveAccuracy: number;
        private static _isTouchRespond;
        _event: Event;
        /**
         * @private
         * 初始化。
         */
        __init__(stage: laya.display.Stage, canvas: any): void;
        /**
         * 执行事件处理。
         */
        runEvent(): void;
    }
}
declare module laya.filters {
    /**
     * 模糊滤镜
     */
    class BlurFilter extends Filter {
        /**模糊滤镜的强度(值越大，越不清晰 */
        strength: number;
        /**
         * 模糊滤镜
         * @param	strength	模糊滤镜的强度值
         */
        constructor(strength?: number);
        /**
         * @private
         * 当前滤镜对应的操作器
         */
        action: IFilterAction;
        /**
         * @private
         * 当前滤镜的类型
         */
        type: number;
        /**
         * @private 通知微端
         */
        callNative(sp: laya.display.Sprite): void;
    }
}
declare module laya.filters {
    /**
     * <p><code>ColorFilter</code> 是颜色滤镜。</p>
     */
    class ColorFilter extends Filter implements IFilter {
        private static _DEFAULT;
        private static _GRAY;
        _mat: Float32Array;
        _alpha: Float32Array;
        /**
         * 创建一个 <code>ColorFilter</code> 实例。
         * @param	mat 4 x 5 矩阵。
         */
        constructor(mat?: Array<any>);
        type: number;
        action: IFilterAction;
        static DEFAULT: ColorFilter;
        static GRAY: ColorFilter;
        /**
         * @private 通知微端
         */
        callNative(sp: laya.display.Sprite): void;
    }
}
declare module laya.filters {
    /**
     * <code>ColorFilterAction</code> 是一个颜色滤镜应用类。
     */
    class ColorFilterAction implements IFilterAction {
        data: ColorFilter;
        /**
         * 创建一个 <code>ColorFilterAction</code> 实例。
         */
        constructor();
        /**
         * 给指定的对象应用颜色滤镜。
         * @param	srcCanvas 需要应用画布对象。
         * @return 应用了滤镜后的画布对象。
         */
        apply(srcCanvas: any): any;
    }
}
declare module laya.filters {
    /**
     * <code>Filter</code> 是滤镜基类。
     */
    class Filter implements IFilter {
        static BLUR: number;
        static COLOR: number;
        static GLOW: number;
        static _filterStart: Function;
        static _filterEnd: Function;
        static _EndTarget: Function;
        static _recycleScope: Function;
        static _filter: Function;
        static _useSrc: Function;
        static _endSrc: Function;
        static _useOut: Function;
        static _endOut: Function;
        _action: any;
        /**
         * 创建一个 <code>Filter</code> 实例。
         * */
        constructor();
        type: number;
        action: IFilterAction;
        callNative(sp: laya.display.Sprite): void;
    }
}
declare module laya.filters {
    /**
     * 默认的FILTER,什么都不做
     * @private
     */
    class FilterAction implements IFilterAction {
        data: any;
        apply(data: any): any;
    }
}
declare module laya.filters {
    /**
     *  发光滤镜(也可以当成阴影滤使用）
     */
    class GlowFilter extends Filter {
        /**
         * 创建发光滤镜
         * @param	color	滤镜的颜色
         * @param	blur	边缘模糊的大小
         * @param	offX	X轴方向的偏移
         * @param	offY	Y轴方向的偏移
         */
        constructor(color: string, blur?: number, offX?: number, offY?: number);
        /**
         * @private
         * 滤镜类型
         */
        type: number;
        action: IFilterAction;
        offY: number;
        offX: number;
        getColor(): Array<any>;
        blur: number;
        /**
         * @private 通知微端
         */
        callNative(sp: laya.display.Sprite): void;
    }
}
declare module laya.filters {
    /**
     * 滤镜接口。
     */
    interface IFilter {
    }
}
declare module laya.filters {
    /**
     * <code>IFilterAction</code> 是滤镜动画接口。
     */
    interface IFilterAction {
    }
}
declare module laya.filters {
    interface IFilterActionGL extends IFilterAction {
    }
}
declare module laya.filters.webgl {
    /**
     * @private
     */
    class BlurFilterActionGL extends FilterActionGL {
        data: laya.filters.BlurFilter;
        constructor();
        typeMix: number;
        setValueMix(shader: laya.webgl.shader.d2.value.Value2D): void;
        apply3d(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): any;
        setValue(shader: any): void;
    }
}
declare module laya.filters.webgl {
    class ColorFilterActionGL extends FilterActionGL implements laya.filters.IFilterActionGL {
        data: laya.filters.ColorFilter;
        constructor();
        setValue(shader: any): void;
        apply3d(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): any;
    }
}
declare module laya.filters.webgl {
    class FilterActionGL implements laya.filters.IFilterActionGL {
        constructor();
        typeMix: number;
        setValue(shader: any): void;
        setValueMix(shader: laya.webgl.shader.d2.value.Value2D): void;
        apply3d(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): any;
        apply(srcCanvas: any): any;
    }
}
declare module laya.filters.webgl {
    /**
     * @private
     */
    class GlowFilterActionGL extends FilterActionGL implements laya.filters.IFilterActionGL {
        data: laya.filters.GlowFilter;
        constructor();
        typeMix: number;
        setValueMix(shader: laya.webgl.shader.d2.value.Value2D): void;
        static tmpTarget(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        static startOut(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        static recycleTarget(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        apply3d(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): any;
        setSpriteWH(sprite: laya.display.Sprite): void;
        setValue(shader: any): void;
    }
}
declare module laya.filters {
    /**
     * @private
     */
    class WebGLFilter {
        private static isInit;
        static enable(): void;
    }
}
declare module laya.html.dom {
    /**
     * @private
     */
    class HTMLBrElement extends HTMLElement {
        constructor();
    }
}
declare module laya.html.dom {
    /**
     * DIV标签
     */
    class HTMLDivElement extends HTMLElement {
        /** 实际内容的高 */
        contextHeight: number;
        /** 实际内容的宽 */
        contextWidth: number;
        constructor();
        /**
         * 设置标签内容
         */
        innerHTML: string;
        /**
         * 追加内容，解析并对显示对象排版
         * @param	text
         */
        appendHTML(text: string): void;
        /**
         * @private
         * @param	out
         * @return
         */
        _addChildsToLayout(out: Array<any>): boolean;
        /**
         * @private
         * @param	out
         */
        _addToLayout(out: Array<any>): void;
        /**
         * @private
         * 对显示内容进行排版
         */
        layout(): void;
        /**
         * 获取对象的高
         */
        height: number;
        /**
         * 获取对象的宽
         */
        width: number;
    }
}
declare module laya.html.dom {
    /**
     * @private
     */
    class HTMLDocument extends HTMLElement {
        static document: HTMLDocument;
        all: Array<any>;
        styleSheets: any;
        constructor();
        getElementById(id: string): HTMLElement;
        setElementById(id: string, e: HTMLElement): void;
    }
}
declare module laya.html.dom {
    /**
     * @private
     */
    class HTMLElement extends laya.display.Sprite {
        private static _EMPTYTEXT;
        URI: laya.net.URL;
        constructor();
        /**
         * @private
         */
        layaoutCallNative(): void;
        id: string;
        text: string;
        innerTEXT: string;
        parent: laya.display.Node;
        appendChild(c: HTMLElement): HTMLElement;
        style: laya.display.css.CSSStyle;
        _getWords(): Array<any>;
        showLinkSprite(): void;
        _layoutLater(): void;
        onClick: string;
        _setAttributes(name: string, value: string): void;
        href: string;
        formatURL(url: string): string;
        color: string;
        className: string;
        static fillWords(ele: HTMLElement, words: Array<any>, x: number, y: number, font: string, color: string): void;
    }
}
declare module laya.html.dom {
    /**
     * iframe标签类，目前用于加载外并解析数据
     */
    class HTMLIframeElement extends HTMLDivElement {
        constructor();
        /**
         * 加载html文件，并解析数据
         * @param	url
         */
        href: string;
    }
}
declare module laya.html.dom {
    /**
     * @private
     */
    class HTMLImageElement extends HTMLElement {
        constructor();
        src: string;
        _addToLayout(out: Array<any>): void;
        render(context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.html.dom {
    /**
     * @private
     */
    class HTMLLinkElement extends HTMLElement {
        type: string;
        static _cuttingStyle: RegExp;
        constructor();
        _onload(data: string): void;
        href: string;
    }
}
declare module laya.html.dom {
    /**
     * @private
     */
    class HTMLStyleElement extends HTMLElement {
        constructor();
        /**
         * 解析样式
         */
        text: string;
    }
}
declare module laya.html.utils {
    /**
     * @private
     */
    class HTMLParse {
        private static char255;
        private static spacePattern;
        private static char255AndOneSpacePattern;
        /**
         * 解析HTML
         * @param	ower
         * @param	xmlString
         * @param	url
         */
        static parse(ower: laya.html.dom.HTMLDivElement, xmlString: string, url: laya.net.URL): void;
    }
}
declare module laya.html.utils {
    /**
     * @private
     * HTML的布局类
     * 对HTML的显示对象进行排版
     */
    class Layout {
        private static _will;
        private static DIV_ELEMENT_PADDING;
        static later(element: laya.display.Sprite): void;
        static layout(element: laya.display.Sprite): Array<any>;
        static _multiLineLayout(element: laya.display.Sprite): Array<any>;
    }
}
declare module laya.html.utils {
    /**
     * @private
     */
    class LayoutLine {
        elements: Array<any>;
        x: number;
        y: number;
        w: number;
        h: number;
        wordStartIndex: number;
        minTextHeight: number;
        mWidth: number;
        constructor();
        /**
         * 底对齐（默认）
         * @param	left
         * @param	width
         * @param	dy
         * @param	align		水平
         * @param	valign		垂直
         * @param	lineHeight	行高
         */
        updatePos(left: number, width: number, lineNum: number, dy: number, align: number, valign: number, lineHeight: number): void;
    }
}
declare module laya.map {
    /**
     * 地图的每层都会分块渲染处理
     * 本类就是地图的块数据
     * @author ...
     */
    class GridSprite extends laya.display.Sprite {
        /**相对于地图X轴的坐标*/
        relativeX: number;
        /**相对于地图Y轴的坐标*/
        relativeY: number;
        /**是否用于对象层的独立物件*/
        isAloneObject: boolean;
        /**当前GRID中是否有动画*/
        isHaveAnimation: boolean;
        /**当前GRID包含的动画*/
        aniSpriteArray: Array<any>;
        /**当前GRID包含多少个TILE(包含动画)*/
        drawImageNum: number;
        /**
         * 传入必要的参数，用于裁剪，跟确认此对象类型
         * @param	map	把地图的引用传进来，参与一些裁剪计算
         * @param	objectKey true:表示当前GridSprite是个活动对象，可以控制，false:地图层的组成块
         */
        initData(map: TiledMap, objectKey?: boolean): void;
        /**
         * 把一个动画对象绑定到当前GridSprite
         * @param	sprite 动画的显示对象
         */
        addAniSprite(sprite: TileAniSprite): void;
        /**
         * 显示当前GridSprite，并把上面的动画全部显示
         */
        show(): void;
        /**
         * 隐藏当前GridSprite，并把上面绑定的动画全部移除
         */
        hide(): void;
        /**
         * 刷新坐标，当我们自己控制一个GridSprite移动时，需要调用此函数，手动刷新
         */
        updatePos(): void;
        /**
         * 重置当前对象的所有属性
         */
        clearAll(): void;
    }
}
declare module laya.map {
    /**
     * 地图支持多层渲染（例如，地表层，植被层，建筑层等）
     * 本类就是层级类
     * @author ...
     */
    class MapLayer extends laya.display.Sprite {
        /**当前Layer的名称*/
        layerName: string;
        /**
         * 解析LAYER数据，以及初始化一些数据
         * @param	layerData 地图数据中，layer数据的引用
         * @param	map 地图的引用
         */
        init(layerData: any, map: TiledMap): void;
        /**
         * 通过名字获取控制对象，如果找不到返回为null
         * @param	objName 所要获取对象的名字
         * @return
         */
        getObjectByName(objName: string): laya.map.GridSprite;
        /**
         * 得到地图层的自定义属性
         * @param	name
         * @return
         */
        getLayerProperties(name: string): any;
        /**
         * 得到指定格子的数据
         * @param	tileX 格子坐标X
         * @param	tileY 格子坐标Y
         * @return
         */
        getTileData(tileX: number, tileY: number): number;
        /**
         * 通过地图坐标得到屏幕坐标
         * @param	tileX 格子坐标X
         * @param	tileY 格子坐标Y
         * @param	screenPos 把计算好的屏幕坐标数据，放到此对象中
         */
        getScreenPositionByTilePos(tileX: number, tileY: number, screenPos?: laya.maths.Point): void;
        /**
         * 通过屏幕坐标来获取选中格子的数据
         * @param	screenX 屏幕坐标x
         * @param	screenY 屏幕坐标y
         * @return
         */
        getTileDataByScreenPos(screenX: number, screenY: number): number;
        /**
         * 通过屏幕坐标来获取选中格子的索引
         * @param	screenX 屏幕坐标x
         * @param	screenY 屏幕坐标y
         * @param	result 把计算好的格子坐标，放到此对象中
         * @return
         */
        getTilePositionByScreenPos(screenX: number, screenY: number, result?: laya.maths.Point): boolean;
        /**
         * 得到一个GridSprite
         * @param	gridX 当前Grid的X轴索引
         * @param	gridY 当前Grid的Y轴索引
         * @return  一个GridSprite对象
         */
        getDrawSprite(gridX: number, gridY: number): laya.map.GridSprite;
        /**
         * 更新此层中块的坐标
         * 手动刷新的目的是，保持层级的宽和高保持最小，加快渲染
         */
        updateGridPos(): void;
        /**
         * @private
         * 把tile画到指定的显示对象上
         * @param	gridSprite 被指定显示的目标
         * @param	tileX 格子的X轴坐标
         * @param	tileY 格子的Y轴坐标
         * @return
         */
        drawTileTexture(gridSprite: laya.map.GridSprite, tileX: number, tileY: number): boolean;
        /**
         * @private
         * 清理当前对象
         */
        clearAll(): void;
    }
}
declare module laya.map {
    /**
     * TildMap的动画显示对象（一个动画（TileTexSet），可以绑定多个动画显示对象（TileAniSprite））
     * @author ...
     */
    class TileAniSprite extends laya.display.Sprite {
        /**
         * 确定当前显示对象的名称以及属于哪个动画
         * @param	aniName	当前动画显示对象的名字，名字唯一
         * @param	tileTextureSet 当前显示对象属于哪个动画（一个动画，可以绑定多个同类显示对象）
         */
        setTileTextureSet(aniName: string, tileTextureSet: TileTexSet): void;
        /**
         * 把当前动画加入到对应的动画刷新列表中
         */
        show(): void;
        /**
         * 把当前动画从对应的动画刷新列表中移除
         */
        hide(): void;
        /**
         * 清理
         */
        clearAll(): void;
    }
}
declare module laya.map {
    /**
     * tiledMap是整个地图的核心
     * 地图以层级来划分地图（例如：地表层，植被层，建筑层）
     * 每层又以分块（GridSprite)来处理显示对象，只显示在视口区域的区
     * 每块又包括N*N个格子（tile)
     * 格子类型又分为动画格子跟图片格子两种
     * @author ...
     */
    class TiledMap {
        /**四边形地图*/
        static ORIENTATION_ORTHOGONAL: string;
        /**菱形地图*/
        static ORIENTATION_ISOMETRIC: string;
        /**45度交错地图*/
        static ORIENTATION_STAGGERED: string;
        /**六边形地图*/
        static ORIENTATION_HEXAGONAL: string;
        /**地图格子从左上角开始渲染*/
        static RENDERORDER_RIGHTDOWN: string;
        /**地图格子从左下角开始渲染*/
        static RENDERORDER_RIGHTUP: string;
        /**地图格子从右上角开始渲染*/
        static RENDERORDER_LEFTDOWN: string;
        /**地图格子右下角开始渲染*/
        static RENDERORDER_LEFTUP: string;
        constructor();
        /**
         * 创建地图
         * @param	mapName 		JSON文件名字
         * @param	viewRect 		视口区域
         * @param	completeHandler 地图创建完成的回调函数
         * @param	viewRectPadding 视口扩充区域，把视口区域上、下、左、右扩充一下，防止视口移动时的穿帮
         * @param	gridSize 		grid大小
         * @param	enableLinear 	是否开启线性取样（为false时，可以解决地图黑线的问题，但画质会锐化）
         * @param	limitRange		把地图限制在显示区域
         */
        createMap(mapName: string, viewRect: laya.maths.Rectangle, completeHandler: laya.utils.Handler, viewRectPadding?: laya.maths.Rectangle, gridSize?: laya.maths.Point, enableLinear?: boolean, limitRange?: boolean): void;
        /**
         * 得到一块指定的地图纹理
         * @param	index 纹理的索引值，默认从1开始
         * @return
         */
        getTexture(index: number): TileTexSet;
        /**
         * 得到地图的自定义属性
         * @param	name		属性名称
         * @return
         */
        getMapProperties(name: string): any;
        /**
         * 得到tile自定义属性
         * @param	index		地图块索引
         * @param	id			具体的TileSetID
         * @param	name		属性名称
         * @return
         */
        getTileProperties(index: number, id: number, name: string): any;
        /**
         * 通过纹理索引，生成一个可控制物件
         * @param	index 纹理的索引值，默认从1开始
         * @return
         */
        getSprite(index: number, width: number, height: number): laya.map.GridSprite;
        /**
         * 设置视口的缩放中心点（例如：scaleX= scaleY= 0.5,就是以视口中心缩放）
         * @param	scaleX
         * @param	scaleY
         */
        setViewPortPivotByScale(scaleX: number, scaleY: number): void;
        /**
         * 得到当前地图的缩放
         */
        /**
         * 设置地图缩放
         * @param	scale
         */
        scale: number;
        /**
         * 移动视口
         * @param	moveX 视口的坐标x
         * @param	moveY 视口的坐标y
         */
        moveViewPort(moveX: number, moveY: number): void;
        /**
         * 改变视口大小
         * @param	moveX	视口的坐标x
         * @param	moveY	视口的坐标y
         * @param	width	视口的宽
         * @param	height	视口的高
         */
        changeViewPort(moveX: number, moveY: number, width: number, height: number): void;
        /**
         * 在锚点的基础上计算，通过宽和高，重新计算视口
         * @param	width		新视口宽
         * @param	height		新视口高
         * @param	rect		返回的结果
         * @return
         */
        changeViewPortBySize(width: number, height: number, rect?: laya.maths.Rectangle): laya.maths.Rectangle;
        /**
         * 得到对象层上的某一个物品
         * @param	layerName   层的名称
         * @param	objectName	所找物品的名称
         * @return
         */
        getLayerObject(layerName: string, objectName: string): laya.map.GridSprite;
        /**
         * 销毁地图
         */
        destroy(): void;
        /**
         * 格子的宽度
         */
        tileWidth: number;
        /**
         * 格子的高度
         */
        tileHeight: number;
        /**
         * 地图的宽度
         */
        width: number;
        /**
         * 地图的高度
         */
        height: number;
        /**
         * 地图横向的格子数
         */
        numColumnsTile: number;
        /**
         * 地图竖向的格子数
         */
        numRowsTile: number;
        /**
         * @private
         * 视口x坐标
         */
        viewPortX: number;
        /**
         * @private
         * 视口的y坐标
         */
        viewPortY: number;
        /**
         * @private
         * 视口的宽度
         */
        viewPortWidth: number;
        /**
         * @private
         * 视口的高度
         */
        viewPortHeight: number;
        /**
         * 地图的x坐标
         */
        x: number;
        /**
         * 地图的y坐标
         */
        y: number;
        /**
         * 块的宽度
         */
        gridWidth: number;
        /**
         * 块的高度
         */
        gridHeight: number;
        /**
         * 地图的横向块数
         */
        numColumnsGrid: number;
        /**
         * 地图的坚向块数
         */
        numRowsGrid: number;
        /**
         * 当前地图类型
         */
        orientation: string;
        /**
         * tile渲染顺序
         */
        renderOrder: string;
        /**
         * 整个地图的显示容器
         * @return 地图的显示容器
         */
        mapSprite(): laya.display.Sprite;
        /**
         * 得到指定的MapLayer
         * @param layerName 要找的层名称
         * @return
         */
        getLayerByName(layerName: string): laya.map.MapLayer;
        /**
         * 通过索引得MapLayer
         * @param	index 要找的层索引
         * @return
         */
        getLayerByIndex(index: number): laya.map.MapLayer;
    }
    class GRect {
        left: number;
        top: number;
        right: number;
        bottom: number;
        clearAll(): void;
    }
    class TileMapAniData {
        mAniIdArray: Array<any>;
        mDurationTimeArray: Array<any>;
        mTileTexSetArr: Array<any>;
    }
    class TileSet {
        firstgid: number;
        image: string;
        imageheight: number;
        imagewidth: number;
        margin: number;
        name: number;
        properties: any;
        spacing: number;
        tileheight: number;
        tilewidth: number;
        titleoffsetX: number;
        titleoffsetY: number;
        tileproperties: any;
        init(data: any): void;
    }
}
declare module laya.map {
    /**
     * 此类是子纹理类，也包括同类动画的管理
     * TiledMap会把纹理分割成无数子纹理，也可以把其中的某块子纹理替换成一个动画序列
     * 本类的实现就是如果发现子纹理被替换成一个动画序列，animationKey会被设为true
     * 即animationKey为true,就使用TileAniSprite来做显示，把动画序列根据时间画到TileAniSprite上
     * @author ...
     */
    class TileTexSet {
        /**唯一标识*/
        gid: number;
        /**子纹理的引用*/
        texture: laya.resource.Texture;
        /**纹理显示时的坐标偏移X*/
        offX: number;
        /**纹理显示时的坐标偏移Y*/
        offY: number;
        /**当前要播放动画的纹理序列*/
        textureArray: Array<any>;
        /** 当前动画每帧的时间间隔*/
        durationTimeArray: Array<any>;
        /** 动画播放的总时间 */
        animationTotalTime: number;
        /**true表示当前纹理，是一组动画，false表示当前只有一个纹理*/
        isAnimation: boolean;
        /**
         * 加入一个动画显示对象到此动画中
         * @param	aniName	//显示对象的名字
         * @param	sprite	//显示对象
         */
        addAniSprite(aniName: string, sprite: laya.map.TileAniSprite): void;
        /**
         * 移除不需要更新的SPRITE
         * @param	_name
         */
        removeAniSprite(_name: string): void;
        /**
         * 显示当前动画的使用情况
         */
        showDebugInfo(): string;
        /**
         * 清理
         */
        clearAll(): void;
    }
}
declare module laya.maths {
    /**
     * @private
     */
    class Arith {
        static formatR(r: number): number;
        static isPOT(w: number, h: number): boolean;
        static setMatToArray(mat: Matrix, array: any): void;
    }
}
declare module laya.maths {
    /**
     * @private
     * 计算贝塞尔曲线的工具类。
     */
    class Bezier {
        /**
         * 工具类单例
         */
        static I: Bezier;
        /**
         * 计算二次贝塞尔点。
         * @param t
         * @param rst
         *
         */
        getPoint2(t: number, rst: Array<any>): void;
        /**
         * 计算三次贝塞尔点
         * @param t
         * @param rst
         *
         */
        getPoint3(t: number, rst: Array<any>): void;
        /**
         * 计算贝塞尔点序列
         * @param count
         * @param rst
         *
         */
        insertPoints(count: number, rst: Array<any>): void;
        /**
         * 获取贝塞尔曲线上的点。
         * @param pList 控制点[x0,y0,x1,y1...]
         * @param inSertCount 每次曲线的插值数量
         * @return
         *
         */
        getBezierPoints(pList: Array<any>, inSertCount?: number, count?: number): Array<any>;
    }
}
declare module laya.maths {
    /**
     * @private
     * 凸包算法。
     */
    class GrahamScan {
        private static _mPointList;
        private static _tempPointList;
        private static _temPList;
        private static _temArr;
        static multiply(p1: Point, p2: Point, p0: Point): number;
        /**
         * 计算两个点的距离。
         * @param	p1
         * @param	p2
         * @return
         */
        static dis(p1: Point, p2: Point): number;
        /**
         * 将数组 src 从索引0位置 依次取 cout 个项添加至 tst 数组的尾部。
         * @param	rst 原始数组，用于添加新的子元素。
         * @param	src 用于取子元素的数组。
         * @param	count 需要取得子元素个数。
         * @return 添加完子元素的 rst 对象。
         */
        static getFrom(rst: Array<any>, src: Array<any>, count: number): Array<any>;
        /**
         * 将数组 src 从末尾索引位置往头部索引位置方向 依次取 cout 个项添加至 tst 数组的尾部。
         * @param	rst 原始数组，用于添加新的子元素。
         * @param	src 用于取子元素的数组。
         * @param	count 需要取得子元素个数。
         * @return 添加完子元素的 rst 对象。
         */
        static getFromR(rst: Array<any>, src: Array<any>, count: number): Array<any>;
        /**
         *  [x,y...]列表 转 Point列表
         * @param pList Point列表
         * @return [x,y...]列表
         */
        static pListToPointList(pList: Array<any>, tempUse?: boolean): Array<any>;
        /**
         * Point列表转[x,y...]列表
         * @param pointList Point列表
         * @return [x,y...]列表
         */
        static pointListToPlist(pointList: Array<any>): Array<any>;
        /**
         *  寻找包括所有点的最小多边形顶点集合
         * @param pList 形如[x0,y0,x1,y1...]的点列表
         * @return  最小多边形顶点集合
         */
        static scanPList(pList: Array<any>): Array<any>;
        /**
         * 寻找包括所有点的最小多边形顶点集合
         * @param PointSet Point列表
         * @return 最小多边形顶点集合
         */
        static scan(PointSet: Array<any>): Array<any>;
    }
}
declare module laya.maths {
    /**
     * @private
     * <code>MathUtil</code> 是一个数据处理工具类。
     */
    class MathUtil {
        static subtractVector3(l: Float32Array, r: Float32Array, o: Float32Array): void;
        static lerp(left: number, right: number, amount: number): number;
        static scaleVector3(f: Float32Array, b: number, e: Float32Array): void;
        static lerpVector3(l: Float32Array, r: Float32Array, t: number, o: Float32Array): void;
        static lerpVector4(l: Float32Array, r: Float32Array, t: number, o: Float32Array): void;
        static slerpQuaternionArray(a: Float32Array, Offset1: number, b: Float32Array, Offset2: number, t: number, out: Float32Array, Offset3: number): Float32Array;
        /**
         * 获取指定的两个点组成的线段的弧度值。
         * @param	x0 点一的 X 轴坐标值。
         * @param	y0 点一的 Y 轴坐标值。
         * @param	x1 点二的 X 轴坐标值。
         * @param	y1 点二的 Y 轴坐标值。
         * @return 弧度值。
         */
        static getRotation(x0: number, y0: number, x1: number, y1: number): number;
        /**
         * 一个用来确定数组元素排序顺序的比较函数。
         * @param	a 待比较数字。
         * @param	b 待比较数字。
         * @return 如果a等于b 则值为0；如果b>a则值为1；如果b<则值为-1。
         */
        static sortBigFirst(a: number, b: number): number;
        /**
         * 一个用来确定数组元素排序顺序的比较函数。
         * @param	a 待比较数字。
         * @param	b 待比较数字。
         * @return 如果a等于b 则值为0；如果b>a则值为-1；如果b<则值为1。
         */
        static sortSmallFirst(a: number, b: number): number;
        /**
         * 将指定的元素转为数字进行比较。
         * @param	a 待比较元素。
         * @param	b 待比较元素。
         * @return b、a转化成数字的差值 (b-a)。
         */
        static sortNumBigFirst(a: any, b: any): number;
        /**
         * 将指定的元素转为数字进行比较。
         * @param	a 待比较元素。
         * @param	b 待比较元素。
         * @return a、b转化成数字的差值 (a-b)。
         */
        static sortNumSmallFirst(a: any, b: any): number;
        /**
         * 返回根据对象指定的属性进行排序的比较函数。
         * @param	key 排序要依据的元素属性名。
         * @param	bigFirst 如果值为true，则按照由大到小的顺序进行排序，否则按照由小到大的顺序进行排序。
         * @param	forceNum 如果值为true，则将排序的元素转为数字进行比较。
         * @return 排序函数。
         */
        static sortByKey(key: string, bigFirst?: boolean, forceNum?: boolean): Function;
    }
}
declare module laya.maths {
    /**
     * <code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。
     */
    class Matrix {
        static EMPTY: Matrix;
        /** 用于中转使用的 <code>Matrix</code> 对象。*/
        static TEMP: Matrix;
        static _cache: any;
        /**缩放或旋转图像时影响像素沿 x 轴定位的值。*/
        a: number;
        /**旋转或倾斜图像时影响像素沿 y 轴定位的值。*/
        b: number;
        /**旋转或倾斜图像时影响像素沿 x 轴定位的值。*/
        c: number;
        /**缩放或旋转图像时影响像素沿 y 轴定位的值。*/
        d: number;
        /**沿 x 轴平移每个点的距离。*/
        tx: number;
        /**沿 y 轴平移每个点的距离。*/
        ty: number;
        inPool: boolean;
        bTransform: boolean;
        /**
         * 使用指定参数创建新的 <code>Matrix</code> 对象。
         * @param	a 缩放或旋转图像时影响像素沿 x 轴定位的值。
         * @param	b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
         * @param	c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
         * @param	d 缩放或旋转图像时影响像素沿 y 轴定位的值。
         * @param	tx 沿 x 轴平移每个点的距离。
         * @param	ty 沿 y 轴平移每个点的距离。
         */
        constructor(a?: number, b?: number, c?: number, d?: number, tx?: number, ty?: number);
        /**
         * 为每个矩阵属性设置一个值。
         * @return 返回当前矩形。
         */
        identity(): Matrix;
        /**@private*/
        _checkTransform(): boolean;
        /**
         * 设置沿 x 、y 轴平移每个点的距离。
         * @param	x 沿 x 轴平移每个点的距离。
         * @param	y 沿 y 轴平移每个点的距离。
         * @return	返回对象本身
         */
        setTranslate(x: number, y: number): Matrix;
        /**
         * 沿 x 和 y 轴平移矩阵，由 x 和 y 参数指定。
         * @param	x 沿 x 轴向右移动的量（以像素为单位）。
         * @param	y 沿 y 轴向下移动的量（以像素为单位）。
         * @return 返回此矩形。
         */
        translate(x: number, y: number): Matrix;
        /**
         * 对矩阵应用缩放转换。
         * @param	x 用于沿 x 轴缩放对象的乘数。
         * @param	y 用于沿 y 轴缩放对象的乘数。
         */
        scale(x: number, y: number): void;
        /**
         * 对 Matrix 对象应用旋转转换。
         * @param	angle 以弧度为单位的旋转角度。
         */
        rotate(angle: number): void;
        /**
         * 对 Matrix 对象应用倾斜转换。
         * @param	x 沿着 X 轴的 2D 倾斜弧度。
         * @param	y 沿着 Y 轴的 2D 倾斜弧度。
         * @return 当前 Matrix 对象。
         */
        skew(x: number, y: number): Matrix;
        /**
         * 对指定的点应用当前矩阵的逆转化并返回此点。
         * @param	out 待转化的点 Point 对象。
         * @return	返回out
         */
        invertTransformPoint(out: Point): Point;
        /**
         * 将 Matrix 对象表示的几何转换应用于指定点。
         * @param	out 用来设定输出结果的点。
         * @return	返回out
         */
        transformPoint(out: Point): Point;
        /**
         * 将 Matrix 对象表示的几何转换应用于指定点忽略tx ty。
         * @param	out 用来设定输出结果的点。
         * @return	返回out
         */
        transformPointN(out: Point): Point;
        /**
         * @private
         * 将 Matrix 对象表示的几何转换应用于指定点。
         * @param	data 点集合。
         * @param	out 存储应用转化的点的列表。
         * @return	返回out数组
         */
        transformPointArray(data: Array<any>, out: Array<any>): Array<any>;
        /**
         * @private
         * 将 Matrix 对象表示的几何缩放转换应用于指定点。
         * @param	data 点集合。
         * @param	out 存储应用转化的点的列表。
         * @return	返回out数组
         */
        transformPointArrayScale(data: Array<any>, out: Array<any>): Array<any>;
        /**
         * 获取 X 轴缩放值。
         * @return  X 轴缩放值。
         */
        getScaleX(): number;
        /**
         * 获取 Y 轴缩放值。
         * @return Y 轴缩放值。
         */
        getScaleY(): number;
        /**
         * 执行原始矩阵的逆转换。
         * @return 当前矩阵对象。
         */
        invert(): Matrix;
        /**
         *  将 Matrix 的成员设置为指定值。
         * @param	a 缩放或旋转图像时影响像素沿 x 轴定位的值。
         * @param	b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
         * @param	c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
         * @param	d 缩放或旋转图像时影响像素沿 y 轴定位的值。
         * @param	tx 沿 x 轴平移每个点的距离。
         * @param	ty 沿 y 轴平移每个点的距离。
         * @return 当前矩阵对象。
         */
        setTo(a: number, b: number, c: number, d: number, tx: number, ty: number): Matrix;
        /**
         * 将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
         * @param	matrix 要连接到源矩阵的矩阵。
         * @return 当前矩阵。
         */
        concat(matrix: Matrix): Matrix;
        /**
         * 将指定的两个矩阵相乘后的结果赋值给指定的输出对象。
         * @param	m1 矩阵一。
         * @param	m2 矩阵二。
         * @param	out 输出对象。
         * @return 结果输出对象 out。
         */
        static mul(m1: Matrix, m2: Matrix, out: Matrix): Matrix;
        /**
     * 将指定的两个矩阵相乘后的结果赋值给指定的输出数组长度为16。
     * @param	m1 矩阵一。
     * @param	m2 矩阵二。
     * @param	out 输出对象Array。
     * @return 结果输出对象 out。
     */
        static mul16(m1: Matrix, m2: Matrix, out: Array<any>): Array<any>;
        /**
         * 对矩阵应用缩放转换。反向相乘
         * @param	x 用于沿 x 轴缩放对象的乘数。
         * @param	y 用于沿 y 轴缩放对象的乘数。
         */
        scaleEx(x: number, y: number): void;
        /**
         * 对 Matrix 对象应用旋转转换。反向相乘
         * @param	angle 以弧度为单位的旋转角度。
         */
        rotateEx(angle: number): void;
        static mulPre(m1: Matrix, ba: number, bb: number, bc: number, bd: number, btx: number, bty: number, out: Matrix): Matrix;
        static mulPos(m1: Matrix, aa: number, ab: number, ac: number, ad: number, atx: number, aty: number, out: Matrix): Matrix;
        static preMul(parent: Matrix, self: Matrix, out: Matrix): Matrix;
        static preMulXY(parent: Matrix, x: number, y: number, out: Matrix): Matrix;
        /**
         * 返回一个新的 Matrix 对象，它是此矩阵的克隆，带有与所含对象完全相同的副本。
         * @return 一个 Matrix 对象。
         */
        clone(): Matrix;
        /**
         * 将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
         * @param	dec 要复制当前矩阵数据的 Matrix 对象。
         * @return 已复制当前矩阵数据的 Matrix 对象。
         */
        copyTo(dec: Matrix): Matrix;
        /**
         * 返回列出该 Matrix 对象属性的文本值。
         * @return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
         */
        toString(): string;
        /**
         * 销毁此对象。
         */
        destroy(): void;
        /**
         * 从对象池中创建一个 <code>Matrix</code> 对象。
         * @return <code>Matrix</code> 对象。
         */
        static create(): Matrix;
    }
}
declare module laya.maths {
    /**
     * <code>Point</code> 对象表示二维坐标系统中的某个位置，其中 x 表示水平轴，y 表示垂直轴。
     */
    class Point {
        /**临时使用的公用对象。*/
        static TEMP: Point;
        static EMPTY: Point;
        /**该点的水平坐标。*/
        x: number;
        /**该点的垂直坐标。*/
        y: number;
        /**
         * 根据指定坐标，创建一个新的 <code>Point</code> 对象。
         * @param	x 水平坐标。
         * @param	y 垂直坐标。
         */
        constructor(x?: number, y?: number);
        /**
         * 将 <code>Point</code> 的成员设置为指定值。
         * @param	x 水平坐标。
         * @param	y 垂直坐标。
         * @return 当前 Point 对象。
         */
        setTo(x: number, y: number): Point;
        /**
         * 计算当前点和目标x，y点的距离
         * @param	x 水平坐标。
         * @param	y 垂直坐标。
         * @return	返回之间的距离
         */
        distance(x: number, y: number): number;
        /**返回包含 x 和 y 坐标的值的字符串。*/
        toString(): string;
        /**
         * 标准化向量
         */
        normalize(): void;
    }
}
declare module laya.maths {
    /**
     * <code>Rectangle</code> 对象是按其位置（由它左上角的点 (x, y) 确定）以及宽度和高度定义的区域。
     */
    class Rectangle {
        static EMPTY: Rectangle;
        /**全局临时的矩形区域，此对象用于全局复用，以减少对象创建*/
        static TEMP: Rectangle;
        private static _temB;
        private static _temA;
        /** 矩形左上角的 X 轴坐标。*/
        x: number;
        /** 矩形左上角的 Y 轴坐标。*/
        y: number;
        /** 矩形的宽度。*/
        width: number;
        /** 矩形的高度。*/
        height: number;
        /**
         * 创建一个 <code>Rectangle</code> 对象。
         * @param	x 矩形左上角的 X 轴坐标。
         * @param	y 矩形左上角的 Y 轴坐标。
         * @param	width 矩形的宽度。
         * @param	height 矩形的高度。
         */
        constructor(x?: number, y?: number, width?: number, height?: number);
        /** 此矩形的右边距。 x 和 width 属性的和。*/
        right: number;
        /** 此矩形的底边距。y 和 height 属性的和。*/
        bottom: number;
        /**
         * 将 Rectangle 的属性设置为指定值。
         * @param	x	x 矩形左上角的 X 轴坐标。
         * @param	y	x 矩形左上角的 Y 轴坐标。
         * @param	width	矩形的宽度。
         * @param	height	矩形的高。
         * @return	返回属性值修改后的矩形对象本身。
         */
        setTo(x: number, y: number, width: number, height: number): Rectangle;
        /**
         * 复制 source 对象的属性值到此矩形对象中。
         * @param	sourceRect	源 Rectangle 对象。
         * @return	返回属性值修改后的矩形对象本身。
         */
        copyFrom(source: Rectangle): Rectangle;
        /**
         * 检测此矩形对象是否包含指定的点。
         * @param	x	点的 X 轴坐标值（水平位置）。
         * @param	y	点的 Y 轴坐标值（垂直位置）。
         * @return	如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
         */
        contains(x: number, y: number): boolean;
        /**
         * 检测传入的矩形对象是否与此对象相交。
         * @param	rect Rectangle 对象。
         * @return	如果传入的矩形对象与此对象相交，则返回 true 值，否则返回 false。
         */
        intersects(rect: Rectangle): boolean;
        /**
         * 获取此对象与传入的矩形对象的相交区域。并将相交区域赋值给传入的输出矩形对象。
         * @param	rect 待比较的矩形区域。
         * @param	out	待输出的矩形区域。如果为空则创建一个新的。建议：尽量复用对象，减少对象创建消耗。
         * @return	返回相交的矩形区域对象。
         */
        intersection(rect: Rectangle, out?: Rectangle): Rectangle;
        /**
         * 矩形联合，通过填充两个矩形之间的水平和垂直空间，将这两个矩形组合在一起以创建一个新的 Rectangle 对象。
         * @param	目标矩形对象。
         * @param	out	待输出结果的矩形对象。如果为空则创建一个新的。建议：尽量复用对象，减少对象创建消耗。
         * @return	两个矩形后联合的 Rectangle 对象 out 。
         */
        union(source: Rectangle, out?: Rectangle): Rectangle;
        /**
         * 返回一个 Rectangle 对象，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
         * @param	out	待输出的矩形对象。如果为空则创建一个新的。建议：尽量复用对象，减少对象创建消耗。
         * @return	Rectangle 对象 out ，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
         */
        clone(out?: Rectangle): Rectangle;
        /**
         * 当前 Rectangle 对象的水平位置 x 和垂直位置 y 以及高度 width 和宽度 height 以逗号连接成的字符串。
         */
        toString(): string;
        /**
         * 检测传入的 Rectangle 对象的属性是否与当前 Rectangle 对象的属性 x、y、width、height 属性值都相等。
         * @param	rect 待比较的 Rectangle 对象。
         * @return	如果判断的属性都相等，则返回 true ,否则返回 false。
         */
        equals(rect: Rectangle): boolean;
        /**
         * 在当前矩形区域中加一个点。
         * @param x	点的 X 坐标。
         * @param y	点的 Y 坐标。
         * @return 返回此 Rectangle 对象。
         */
        addPoint(x: number, y: number): Rectangle;
        /**
         * @private
         * 返回代表当前矩形的顶点数据。
         * @return 顶点数据。
         */
        _getBoundPoints(): Array<any>;
        /**
         * @private
         * 返回矩形的顶点数据。
         */
        static _getBoundPointS(x: number, y: number, width: number, height: number): Array<any>;
        /**
         * @private
         * 返回包含所有点的最小矩形。
         * @param pointList 点列表。
         * @return 包含所有点的最小矩形矩形对象。
         */
        static _getWrapRec(pointList: Array<any>, rst?: Rectangle): Rectangle;
        /**确定此 Rectangle 对象是否为空。*/
        isEmpty(): boolean;
    }
}
declare module laya.media.h5audio {
    /**
     * @private
     * 使用Audio标签播放声音
     */
    class AudioSound extends laya.events.EventDispatcher {
        private static _audioCache;
        /**
         * 声音URL
         */
        url: string;
        /**
         * 播放用的audio标签
         */
        audio: any;
        /**
         * 是否已加载完成
         */
        loaded: boolean;
        /**
         * 释放声音
         *
         */
        dispose(): void;
        /**
         * 加载声音
         * @param url
         *
         */
        load(url: string): void;
        /**
         * 播放声音
         * @param startTime 起始时间
         * @param loops 循环次数
         * @return
         *
         */
        play(startTime?: number, loops?: number): laya.media.SoundChannel;
        /**
         * 获取总时间。
         */
        duration: number;
    }
}
declare module laya.media.h5audio {
    /**
     * @private
     * audio标签播放声音的音轨控制
     */
    class AudioSoundChannel extends laya.media.SoundChannel {
        constructor(audio: any);
        /**
         * 播放
         */
        play(): void;
        /**
         * 当前播放到的位置
         * @return
         *
         */
        position: number;
        /**
         * 获取总时间。
         */
        duration: number;
        /**
         * 停止播放
         *
         */
        stop(): void;
        /**
         * 获取音量
         * @return
         *
         */
        /**
         * 设置音量
         * @param v
         *
         */
        volume: number;
    }
}
declare module laya.media {
    /**
     * <code>Sound</code> 类是用来播放控制声音的类。
     */
    class Sound extends laya.events.EventDispatcher {
        /**
         * 加载声音。
         * @param url 地址。
         *
         */
        load(url: string): void;
        /**
         * 播放声音。
         * @param startTime 开始时间,单位秒
         * @param loops 循环次数,0表示一直循环
         * @return 声道 SoundChannel 对象。
         *
         */
        play(startTime?: number, loops?: number): SoundChannel;
        /**
         * 获取总时间。
         */
        duration: number;
        /**
         * 释放声音资源。
         *
         */
        dispose(): void;
    }
}
declare module laya.media {
    /**
     * <code>SoundChannel</code> 用来控制程序中的声音。
     */
    class SoundChannel extends laya.events.EventDispatcher {
        /**
         * 声音地址。
         */
        url: string;
        /**
         * 循环次数。
         */
        loops: number;
        /**
         * 开始时间。
         */
        startTime: number;
        /**
         * 表示声音是否已暂停。
         */
        isStopped: boolean;
        /**
         * 播放完成处理器。
         */
        completeHandler: laya.utils.Handler;
        /**
         * 音量。
         */
        volume: number;
        /**
         * 获取当前播放时间。
         */
        position: number;
        /**
         * 获取总时间。
         */
        duration: number;
        /**
         * 播放。
         */
        play(): void;
        /**
         * 停止。
         */
        stop(): void;
        protected __runComplete(handler: laya.utils.Handler): void;
    }
}
declare module laya.media {
    /**
     * <code>SoundManager</code> 是一个声音管理类。
     */
    class SoundManager {
        /** 背景音乐音量。*/
        static musicVolume: number;
        /** 音效音量。*/
        static soundVolume: number;
        /** 声音播放速率。*/
        static playbackRate: number;
        private static _muted;
        private static _soundMuted;
        private static _musicMuted;
        private static _tMusic;
        private static _musicChannel;
        private static _channels;
        private static _autoStopMusic;
        private static _blurPaused;
        private static _musicLoops;
        private static _musicPosition;
        private static _musicCompleteHandler;
        static _soundClass: any;
        /**
         * 添加播放的声音实例。
         * @param channel <code>SoundChannel</code> 对象。
         */
        static addChannel(channel: SoundChannel): void;
        /**
         * 移除播放的声音实例。
         * @param channel <code>SoundChannel</code> 对象。
         */
        static removeChannel(channel: SoundChannel): void;
        /**
         * 表示是否失去焦点后自动停止背景音乐。
         * @return
         */
        /**
         * 设置是否失去焦点后自动停止背景音乐。
         * @param v Boolean 值。
         *
         */
        static autoStopMusic: boolean;
        /**
         * 表示是否静音。
         */
        static muted: boolean;
        /** 表示是否使音效静音。*/
        static soundMuted: boolean;
        /** 表示是否使背景音乐静音。*/
        static musicMuted: boolean;
        /**
         * 播放音效。
         * @param url 声音文件地址。
         * @param loops 循环次数,0表示无限循环。
         * @param complete 声音播放完成回调  Handler对象。
         * @param soundClass 使用哪个声音类进行播放，null表示自动选择。
         * @param startTime  声音播放起始时间。
         * @return SoundChannel对象。
         */
        static playSound(url: string, loops?: number, complete?: laya.utils.Handler, soundClass?: any, startTime?: number): SoundChannel;
        /**
         * 释放声音资源。
         * @param url 声音文件地址。
         */
        static destroySound(url: string): void;
        /**
         * 播放背景音乐。
         * @param url 声音文件地址。
         * @param loops 循环次数,0表示无限循环。
         * @param complete  声音播放完成回调。
         * @param startTime  声音播放起始时间。
         * @return audio对象。
         */
        static playMusic(url: string, loops?: number, complete?: laya.utils.Handler, startTime?: number): SoundChannel;
        /**
         * 停止声音播放。
         * @param url  声音文件地址。
         */
        static stopSound(url: string): void;
        /**
         * 停止所有声音播放。
         */
        static stopAll(): void;
        /**
         * 停止所有音效,不包括背景音乐。
         */
        static stopAllSound(): void;
        /**
         * 停止背景音乐播放。
         * @param url  声音文件地址。
         */
        static stopMusic(): void;
        /**
         * 设置声音音量
         * @param volume 音量 标准值为1
         * @param url  声音文件地址。为null(默认值)时对所有音效起作用，不为空时仅对对于声音生效
         */
        static setSoundVolume(volume: number, url?: string): void;
        /**
         * 设置背景音乐音量。
         * @param volume 音量，标准值为1。
         */
        static setMusicVolume(volume: number): void;
    }
}
declare module laya.media {
    class SoundNode extends laya.display.Sprite {
        url: string;
        constructor();
        /**
         * 播放
         * @param loops 循环次数
         * @param complete 完成回调
         *
         */
        play(loops?: number, complete?: laya.utils.Handler): void;
        /**
         * 停止播放
         *
         */
        stop(): void;
        /**
         * 设置触发播放的事件
         * @param events
         *
         */
        playEvent: string;
        /**
         * 设置控制播放的对象
         * @param tar
         *
         */
        target: laya.display.Sprite;
        /**
         * 设置触发停止的事件
         * @param events
         *
         */
        stopEvent: string;
    }
}
declare module laya.media.webaudio {
    /**
     * @private
     * web audio api方式播放声音
     */
    class WebAudioSound extends laya.events.EventDispatcher {
        static window: any;
        private static _dataCache;
        /**
         * 是否支持web audio api
         */
        static webAudioEnabled: boolean;
        /**
         * 播放设备
         */
        static ctx: any;
        /**
         * 当前要解码的声音文件列表
         */
        static buffs: Array<any>;
        /**
         * 是否在解码中
         */
        static isDecoding: boolean;
        /**
         * 用于播放解锁声音以及解决Ios9版本的内存释放
         */
        static _miniBuffer: any;
        /**
         * 事件派发器，用于处理加载解码完成事件的广播
         */
        static e: laya.events.EventDispatcher;
        private static _unlocked;
        /**
         * 当前解码的声音信息
         */
        static tInfo: any;
        private static __loadingSound;
        /**
         * 声音URL
         */
        url: string;
        /**
         * 是否已加载完成
         */
        loaded: boolean;
        /**
         * 声音文件数据
         */
        data: ArrayBuffer;
        /**
         * 声音原始文件数据
         */
        audioBuffer: any;
        /**
         * 解码声音文件
         *
         */
        static decode(): void;
        static initWebAudio(): void;
        /**
         * 加载声音
         * @param url
         *
         */
        load(url: string): void;
        /**
         * 播放声音
         * @param startTime 起始时间
         * @param loops 循环次数
         * @return
         *
         */
        play(startTime?: number, loops?: number, channel?: laya.media.SoundChannel): laya.media.SoundChannel;
        duration: number;
        dispose(): void;
    }
}
declare module laya.media.webaudio {
    /**
     * @private
     * web audio api方式播放声音的音轨控制
     */
    class WebAudioSoundChannel extends laya.media.SoundChannel {
        /**
         * 声音原始文件数据
         */
        audioBuffer: any;
        private static _tryCleanFailed;
        constructor();
        /**
         * 播放声音
         */
        play(): void;
        /**
         * 获取当前播放位置
         */
        position: number;
        duration: number;
        /**
         * 停止播放
         */
        stop(): void;
        /**
         * 获取音量
         */
        /**
         * 设置音量
         */
        volume: number;
    }
}
declare module laya.net {
    /**
     * <code>HttpRequest</code> 通过 HTTP 协议传送或接收 XML 及其他数据。
     */
    class HttpRequest extends laya.events.EventDispatcher {
        protected _http: any;
        protected _responseType: string;
        protected _data: any;
        /**
         * 发送请求。
         * @param	url 请求的地址。
         * @param	data 发送的数据，可选。
         * @param	method 发送数据方式，值为“get”或“post”，默认为 “get”方式。
         * @param	responseType 返回消息类型，可设置为"text"，"json"，"xml","arraybuffer"。
         * @param	headers 头信息，key value数组，比如["Content-Type", "application/json"]。
         */
        send(url: string, data?: any, method?: string, responseType?: string, headers?: Array<any>): void;
        protected _onProgress(e: any): void;
        protected _onAbort(e: any): void;
        protected _onError(e: any): void;
        protected _onLoad(e: any): void;
        protected error(message: string): void;
        protected complete(): void;
        protected clear(): void;
        /** 请求的地址。*/
        url: string;
        /** 返回的数据。*/
        data: any;
        /**原生XMLHttpRequest引用*/
        http: any;
    }
}
declare module laya.net {
    /**
     * <code>Loader</code> 类可用来加载文本、JSON、XML、二进制、图像等资源。
     */
    class Loader extends laya.events.EventDispatcher {
        /** 文本类型，加载完成后返回文本。*/
        static TEXT: string;
        /** JSON 类型，加载完成后返回json数据。*/
        static JSON: string;
        /** XML 类型，加载完成后返回domXML。*/
        static XML: string;
        /** 二进制类型，加载完成后返回arraybuffer二进制数据。*/
        static BUFFER: string;
        /** 纹理类型，加载完成后返回Texture。*/
        static IMAGE: string;
        /** 声音类型，加载完成后返回sound。*/
        static SOUND: string;
        /** 图集类型，加载完成后返回图集json信息(并创建图集内小图Texture)。*/
        static ATLAS: string;
        /** 位图字体类型，加载完成后返回BitmapFont。*/
        static FONT: string;
        /** 文件后缀和类型对应表。*/
        static typeMap: any;
        /**资源解析函数对应表，用来扩展更多类型的资源加载解析*/
        static parserMap: any;
        /** 已加载的资源池。*/
        static loadedMap: any;
        /** 资源分组。*/
        static groupMap: any;
        /** 每帧回调最大超时时间，如果超时，则下帧再处理。*/
        static maxTimeOut: number;
        protected static _loaders: Array<any>;
        protected static _isWorking: boolean;
        protected static _startIndex: number;
        _data: any;
        protected _url: string;
        protected _type: string;
        protected _cache: boolean;
        protected _http: HttpRequest;
        /**
         * 加载资源。
         * @param	url 地址
         * @param	type 类型，如果为null，则根据文件后缀，自动分析类型。
         * @param	cache 是否缓存数据。
         * @param	group 分组。
         * @param	ignoreCache 是否忽略缓存，强制重新加载
         */
        load(url: string, type?: string, cache?: boolean, group?: string, ignoreCache?: boolean): void;
        protected getTypeFromUrl(url: string): string;
        protected _loadImage(url: string): void;
        protected _loadSound(url: string): void;
        protected onProgress(value: number): void;
        protected onError(message: string): void;
        protected onLoaded(data?: any): void;
        protected complete(data: any): void;
        /**
         * 结束加载，处理是否缓存及派发完成事件 <code>Event.COMPLETE</code> 。
         * @param	content 加载后的数据
         */
        endLoad(content?: any): void;
        /** 加载地址。*/
        url: string;
        /**加载类型。*/
        type: string;
        /**是否缓存。*/
        cache: boolean;
        /**返回的数据。*/
        data: any;
        /**
         * 清理指定资源地址的缓存。
         * @param	url 资源地址。
         * @param	forceDispose 是否强制销毁，有些资源是采用引用计数方式销毁，如果forceDispose=true，则忽略引用计数，直接销毁，比如Texture，默认为false
         */
        static clearRes(url: string, forceDispose?: boolean): void;
        /**
         * 获取指定资源地址的资源。
         * @param	url 资源地址。
         * @return	返回资源。
         */
        static getRes(url: string): any;
        /**
         * 获取指定资源地址的图集地址列表。
         * @param	url 图集地址。
         * @return	返回地址集合。
         */
        static getAtlas(url: string): Array<any>;
        /**
         * 缓存资源。
         * @param	url 资源地址。
         * @param	data 要缓存的内容。
         */
        static cacheRes(url: string, data: any): void;
        /**
         * 设置资源分组。
         * @param url 资源地址。
         * @param group 分组名
         */
        static setGroup(url: string, group: string): void;
        /**
         * 根据分组清理资源
         * @param group 分组名
         */
        static clearResByGroup(group: string): void;
    }
}
declare module laya.net {
    /**
     * <p> <code>LoaderManager</code> 类用于用于批量加载资源、数据。</p>
     * <p>批量加载器，单例，可以通过Laya.loader访问，注意大小写。</p>
     * 多线程：默认5个线程，可以通过maxLoader属性修改线程数量
     * 多优先级：默认5个优先级，0最快，4最慢，默认为1
     * 重复过滤：自动过滤重复加载以及已经加载过的地址，防止重复加载
     * 错误重试：资源加载失败后，会重试加载（按照最低优先级），retryNum设定加载失败后重试次数，retryDelay设定加载重试的时间间隔
     * 如果单个地址加载方式，加载重试后仍然失败，则调用complete回调，并返回null。如果多地址加载方式，重试后仍然失败，则调用complete回调，返回为success=false
     * 全部队列加载完成，会派发complete事件，如果队列中任意一个加载失败，会派发error事件
     */
    class LoaderManager extends laya.events.EventDispatcher {
        private static _resMap;
        static createMap: any;
        /** 加载出错后的重试次数，默认重试一次*/
        retryNum: number;
        /** 延迟时间多久再进行错误重试，默认立即重试*/
        retryDelay: number;
        /** 最大下载线程，默认为5个*/
        maxLoader: number;
        /**
         * 创建一个新的 <code>LoaderManager</code> 实例。
         */
        constructor();
        /**
         * 根据clas定义创建一个资源空壳，随后进行异步加载，资源加载完成后，会调用资源类的onAsynLoaded方法回调真正的数据,套嵌资源的子资源会保留资源路径"?"后的部分
         * @param	url 资源地址或者数组，比如[
         * @param	progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
         * @param	clas 资源类名，比如Texture
         * @param	type 资源类型，比如：Loader.IMAGE
         * @param	priority 优先级，默认5个优先级，0最快，4最慢，默认为1
         * @param	cache 是否缓存
         * @return	返回资源对象
         */
        create(url: any, complete?: laya.utils.Handler, progress?: laya.utils.Handler, clas?: any, params?: Array<any>, priority?: number, cache?: boolean): any;
        /**
         * 加载资源。
         * @param	url 单个资源地址，或者资源地址数组(简单数组：["a.png","b.png"]，复杂数组[
         * @param	complete 结束回调，如果加载失败，则返回 null 。
         * @param	progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
         * @param	type 资源类型。比如：Loader.IMAGE
         * @param	priority 优先级，0-4，5个优先级，0优先级最高，默认为1。
         * @param	cache 是否缓存加载结果。
         * @param	group 分组，方便对资源进行管理。
         * @param	ignoreCache 是否忽略缓存，强制重新加载
         * @return 此 LoaderManager 对象。
         */
        load(url: any, complete?: laya.utils.Handler, progress?: laya.utils.Handler, type?: string, priority?: number, cache?: boolean, group?: string, ignoreCache?: boolean): LoaderManager;
        /**
         * 清理指定资源地址缓存。
         * @param	url 资源地址。
         * @param	forceDispose 是否强制销毁，有些资源是采用引用计数方式销毁，如果forceDispose=true，则忽略引用计数，直接销毁，比如Texture，默认为false
         */
        clearRes(url: string, forceDispose?: boolean): void;
        /**
         * 获取指定资源地址的资源。
         * @param	url 资源地址。
         * @return	返回资源。
         */
        getRes(url: string): any;
        /**
         * 缓存资源。
         * @param	url 资源地址。
         * @param	data 要缓存的内容。
         */
        cacheRes(url: string, data: any): void;
        /**
         * 设置资源分组。
         * @param url 资源地址。
         * @param group 分组名
         */
        setGroup(url: string, group: string): void;
        /**
         * 根据分组清理资源
         * @param group 分组名
         */
        clearResByGroup(group: string): void;
        /**
         * @private
         * 缓存资源。
         * @param	url 资源地址。
         * @param	data 要缓存的内容。
         */
        static cacheRes(url: string, data: any): void;
        /** 清理当前未完成的加载，所有未加载的内容全部停止加载。*/
        clearUnLoaded(): void;
        /**
         * 根据地址集合清理掉未加载的内容
         * @param	urls 资源地址集合
         */
        cancelLoadByUrls(urls: Array<any>): void;
        /**
         * 根据地址清理掉未加载的内容
         * @param	url 资源地址
         */
        cancelLoadByUrl(url: string): void;
    }
    class ResInfo extends laya.events.EventDispatcher {
        url: string;
        type: string;
        cache: boolean;
        group: string;
        ignoreCache: boolean;
    }
}
declare module laya.net {
    /**
     * <p> <code>LocalStorage</code> 类用于没有时间限制的数据存储。</p>
     */
    class LocalStorage {
        static _baseClass: any;
        /**
         *  数据列表。
         */
        static items: any;
        /**
         * 表示是否支持  <code>LocalStorage</code>。
         */
        static support: boolean;
        static __init__(): void;
        /**
         * 存储指定键名和键值，字符串类型。
         * @param key 键名。
         * @param value 键值。
         */
        static setItem(key: string, value: string): void;
        /**
         * 获取指定键名的值。
         * @param key 键名。
         * @return 字符串型值。
         */
        static getItem(key: string): string;
        /**
         * 存储指定键名和它的 <code>Object</code> 类型值。
         * @param key 键名。
         * @param value 键值。是 <code>Object</code> 类型，此致会被转化为 JSON 字符串存储。
         */
        static setJSON(key: string, value: any): void;
        /**
         * 获取指定键名的 <code>Object</code> 类型值。
         * @param key 键名。
         * @return <code>Object</code> 类型值
         */
        static getJSON(key: string): any;
        /**
         * 删除指定键名的信息。
         * @param key 键名。
         */
        static removeItem(key: string): void;
        /**
         * 清除本地存储信息。
         */
        static clear(): void;
    }
    class Storage {
        /**
         *  数据列表。
         */
        static items: any;
        /**
         * 表示是否支持  <code>LocalStorage</code>。
         */
        static support: boolean;
        static init(): void;
        /**
         * 存储指定键名和键值，字符串类型。
         * @param key 键名。
         * @param value 键值。
         */
        static setItem(key: string, value: string): void;
        /**
         * 获取指定键名的值。
         * @param key 键名。
         * @return 字符串型值。
         */
        static getItem(key: string): string;
        /**
         * 存储指定键名和它的 <code>Object</code> 类型值。
         * @param key 键名。
         * @param value 键值。是 <code>Object</code> 类型，此致会被转化为 JSON 字符串存储。
         */
        static setJSON(key: string, value: any): void;
        /**
         * 获取指定键名的 <code>Object</code> 类型值。
         * @param key 键名。
         * @return <code>Object</code> 类型值
         */
        static getJSON(key: string): any;
        /**
         * 删除指定键名的信息。
         * @param key 键名。
         */
        static removeItem(key: string): void;
        /**
         * 清除本地存储信息。
         */
        static clear(): void;
    }
}
declare module laya.net {
    /**
     * 资源版本的生成由layacmd或IDE完成，使用ResourceVersion简化使用过程。
     * 调用enable启用资源版本管理。
     */
    class ResourceVersion {
        static manifest: any;
        /**
         * 启用资源版本管理。
         * <p>
         * 由于只有发布版本需要资源管理。因此没有资源管理文件时，可以设置manifestFile为null或者不存在的路径。
         * </p>
         * @param	manifestFile	清单（json）文件的路径
         * @param   callback		清单（json）文件加载完成后执行
         */
        static enable(manifestFile: string, callback: laya.utils.Handler): void;
        /**
         * 为加载路径添加版本前缀
         * @param	originURL	源路径
         * @return				格式化后的新路径
         */
        static addVersionPrefix(originURL: string): string;
    }
}
declare module laya.net {
    /**
     * <code>Socket</code> 是一种双向通信协议，在建立连接后，服务器和 Browser/Client Agent 都能主动的向对方发送或接收数据。
     */
    class Socket extends laya.events.EventDispatcher {
        /**
         * 表示多字节数字的最低有效字节位于字节序列的最前面。
         */
        static LITTLE_ENDIAN: string;
        /**
         * 表示多字节数字的最高有效字节位于字节序列的最前面。
         */
        static BIG_ENDIAN: string;
        _endian: string;
        protected _socket: any;
        /**
         * 表示建立连接时需等待的毫秒数。
         */
        timeout: number;
        /**
         * 在写入或读取对象时，控制所使用的 AMF 的版本。
         */
        objectEncoding: number;
        /**
         * 不使用socket提供的 input封装
         */
        disableInput: boolean;
        /**
         * 用的子协议，字符串或数组
         */
        protocols: any;
        /**
         * 表示服务端发来的数据。
         */
        input: any;
        /**
         * 表示需要发送至服务端的缓冲区中的数据。
         */
        output: any;
        /**
         * 表示此 Socket 对象目前是否已连接。
         */
        connected: boolean;
        /**
         * 表示数据的字节顺序。
         */
        endian: string;
        /**
         * <p>创建一个新的 <code>Socket</code> 实例。</p>
         * 创建 websocket ,如果host port有效直接连接。		 *
         * @param host 服务器地址。
         * @param port 服务器端口。
         * @param byteClass 用来接收和发送数据的Byte类，默认使用Byte类，也可传入Byte类的子类。
         *
         */
        constructor(host?: string, port?: number, byteClass?: any);
        /**
         * 连接到指定的主机和端口。
         * @param host 服务器地址。
         * @param port 服务器端口。
         */
        connect(host: string, port: number): void;
        /**
         * 连接到指定的url
         * @param url 连接目标
         */
        connectByUrl(url: string): void;
        /**
         * 关闭连接。
         */
        close(): void;
        protected _onOpen(e: any): void;
        protected _onMessage(msg: any): void;
        protected _onClose(e: any): void;
        protected _onError(e: any): void;
        /**
         * 发送数据到服务器。
         * @param	data 需要发送的数据，可以是String或者ArrayBuffer。
         */
        send(data: any): void;
        /**
         * 发送缓冲区中的数据到服务器。
         */
        flush(): void;
    }
}
declare module laya.net {
    /**
     * <p> <code>URL</code> 类用于定义地址信息。</p>
     */
    class URL {
        /**版本号。*/
        static version: any;
        /**创建一个新的 <code>URL</code> 实例。*/
        constructor(url: string);
        /**格式化后的地址。*/
        url: string;
        /**地址的路径。*/
        path: string;
        /**基础路径。*/
        static basePath: string;
        /**根路径。*/
        static rootPath: string;
        /** 自定义url格式化。例如： customFormat=function(url:string,basePath:string):string
        public static var customFormat:Function = function(url:String):String
            var newUrl:String = version[url];
            if (!Render.isConchApp && newUrl) url += "?v=" + newUrl;
            return url;
        }
        /**
         * 格式化指定的地址并	返回。
         * @param	url 地址。
         * @param	base 路径。
         * @return 格式化处理后的地址。
         */
        static formatURL(url: string, base?: string): string;
        /**
         * @private
         * 获取指定 URL 的路径。
         * <p><b>注意：</b>末尾有斜杠（/）。</p>
         * @param	url 地址。
         * @return  url 的路径。
         */
        static getPath(url: string): string;
        /**
         * 获取指定 URL 的文件名。
         * @param	url 地址。
         * @return url 的文件名。
         */
        static getFileName(url: string): string;
    }
}
declare module laya.net {
    /**
     * @private
     * Worker Image加载器
     */
    class WorkerLoader extends laya.events.EventDispatcher {
        /**
         * 图片加载完成事件
         */
        static IMAGE_LOADED: string;
        /**
         * 图片加载失败事件
         */
        static IMAGE_ERR: string;
        /**
         * 图片加载过程中的信息
         */
        static IMAGE_MSG: string;
        /**
         * 实例
         */
        static I: WorkerLoader;
        private static _preLoadFun;
        private static _enable;
        /**
         * worker.js的路径
         */
        static workerPath: string;
        /**
         * 尝试使用Work加载Image
         * @return 是否启动成功
         */
        static __init__(): boolean;
        /**
         * 是否支持worker
         * @return 是否支持worker
         */
        static workerSupported(): boolean;
        /**
         * 是否启用。
         */
        static enable: boolean;
        /**
         * 使用的Worker对象。
         */
        worker: Worker;
        constructor();
        /**
         * 加载图片
         * @param	url 图片地址
         */
        loadImage(url: string): void;
        protected _loadImage(url: string): void;
    }
}
declare module laya.particle.emitter {
    /**
     *
     * @private
     */
    class Emitter2D extends EmitterBase {
        setting: laya.particle.ParticleSetting;
        constructor(_template: laya.particle.ParticleTemplateBase);
        template: laya.particle.ParticleTemplateBase;
        emit(): void;
        getRandom(value: number): number;
        webGLEmit(): void;
        canvasEmit(): void;
    }
}
declare module laya.particle.emitter {
    /**
     * <code>EmitterBase</code> 类是粒子发射器类
     */
    class EmitterBase {
        protected _frameTime: number;
        protected _emissionRate: number;
        protected _emissionTime: number;
        /**
         * 发射粒子最小时间间隔
         */
        minEmissionTime: number;
        _particleTemplate: laya.particle.ParticleTemplateBase;
        /**
         * 设置粒子粒子模板
         * @param particleTemplate 粒子模板
         *
         */
        particleTemplate: laya.particle.ParticleTemplateBase;
        /**
         * 获取粒子发射速率
         * @return 发射速率  粒子发射速率 (个/秒)
         */
        /**
         * 设置粒子发射速率
         * @param emissionRate 粒子发射速率 (个/秒)
         */
        emissionRate: number;
        /**
         * 开始发射粒子
         * @param duration 发射持续的时间
         */
        start(duration?: number): void;
        /**
         * 停止发射粒子
         * @param clearParticles 是否清理当前的粒子
         */
        stop(): void;
        /**
         * 清理当前的活跃粒子
         * @param clearTexture 是否清理贴图数据,若清除贴图数据将无法再播放
         */
        clear(): void;
        /**
         * 发射一个粒子
         *
         */
        emit(): void;
        /**
         * 时钟前进
         * @param passedTime 前进时间
         *
         */
        advanceTime(passedTime?: number): void;
    }
}
declare module laya.particle {
    /**
     * <code>Particle2D</code> 类是2D粒子播放类
     *
     */
    class Particle2D extends laya.display.Sprite {
        /**是否自动播放*/
        autoPlay: boolean;
        /**
         * 创建一个新的 <code>Particle2D</code> 类实例。
         * @param setting 粒子配置数据
         */
        constructor(setting: ParticleSetting);
        /**
         * 设置 粒子文件地址
         * @param path 粒子文件地址
         */
        url: string;
        /**
         * 加载粒子文件
         * @param url 粒子文件地址
         */
        load(url: string): void;
        /**
         * 设置粒子配置数据
         * @param settings 粒子配置数据
         */
        setParticleSetting(setting: ParticleSetting): void;
        /**
         * 获取粒子发射器
         */
        emitter: laya.particle.emitter.EmitterBase;
        /**
         * 播放
         */
        play(): void;
        /**
         * 停止
         */
        stop(): void;
        /**
         * 时钟前进
         * @param passedTime 时钟前进时间
         */
        advanceTime(passedTime?: number): void;
        customRender(context: laya.renders.RenderContext, x: number, y: number): void;
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.particle {
    /**
     *  @private
     */
    class ParticleData {
        private static _tempVelocity;
        private static _tempStartColor;
        private static _tempEndColor;
        private static _tempSizeRotation;
        private static _tempRadius;
        private static _tempRadian;
        position: Float32Array;
        velocity: Float32Array;
        startColor: Float32Array;
        endColor: Float32Array;
        sizeRotation: Float32Array;
        radius: Float32Array;
        radian: Float32Array;
        durationAddScale: number;
        time: number;
        constructor();
        static Create(settings: ParticleSetting, position: Float32Array, velocity: Float32Array, time: number): ParticleData;
    }
}
declare module laya.particle {
    /**
     *  @private
     */
    class ParticleEmitter {
        constructor(templet: ParticleTemplateBase, particlesPerSecond: number, initialPosition: Float32Array);
        update(elapsedTime: number, newPosition: Float32Array): void;
    }
}
declare module laya.particle {
    /**
     * <code>ParticleSettings</code> 类是粒子配置数据类
     */
    class ParticleSetting {
        /**贴图*/
        textureName: string;
        /**贴图个数,默认为1可不设置*/
        textureCount: number;
        /**由于循环队列判断算法，最大饱和粒子数为maxPartices-1*/
        maxPartices: number;
        /**粒子持续时间(单位:秒）*/
        duration: number;
        /**如果大于0，某些粒子的持续时间会小于其他粒子,并具有随机性(单位:无）*/
        ageAddScale: number;
        /**粒子受发射器速度的敏感度（需在自定义发射器中编码设置）*/
        emitterVelocitySensitivity: number;
        /**最小开始尺寸（单位：2D像素、3D坐标）*/
        minStartSize: number;
        /**最大开始尺寸（单位：2D像素、3D坐标）*/
        maxStartSize: number;
        /**最小结束尺寸（单位：2D像素、3D坐标）*/
        minEndSize: number;
        /**最大结束尺寸（单位：2D像素、3D坐标）*/
        maxEndSize: number;
        /**最小水平速度（单位：2D像素、3D坐标）*/
        minHorizontalVelocity: number;
        /**最大水平速度（单位：2D像素、3D坐标）*/
        maxHorizontalVelocity: number;
        /**最小垂直速度（单位：2D像素、3D坐标）*/
        minVerticalVelocity: number;
        /**最大垂直速度（单位：2D像素、3D坐标）*/
        maxVerticalVelocity: number;
        /**等于1时粒子从出生到消亡保持一致的速度，等于0时粒子消亡时速度为0，大于1时粒子会保持加速（单位：无）*/
        endVelocity: number;
        /**（单位：2D像素、3D坐标）*/
        gravity: Float32Array;
        /**最小旋转速度（单位：2D弧度/秒、3D弧度/秒）*/
        minRotateSpeed: number;
        /**最大旋转速度（单位：2D弧度/秒、3D弧度/秒）*/
        maxRotateSpeed: number;
        /**最小开始半径（单位：2D像素、3D坐标）*/
        minStartRadius: number;
        /**最大开始半径（单位：2D像素、3D坐标）*/
        maxStartRadius: number;
        /**最小结束半径（单位：2D像素、3D坐标）*/
        minEndRadius: number;
        /**最大结束半径（单位：2D像素、3D坐标）*/
        maxEndRadius: number;
        /**最小水平开始弧度（单位：2D弧度、3D弧度）*/
        minHorizontalStartRadian: number;
        /**最大水平开始弧度（单位：2D弧度、3D弧度）*/
        maxHorizontalStartRadian: number;
        /**最小垂直开始弧度（单位：2D弧度、3D弧度）*/
        minVerticalStartRadian: number;
        /**最大垂直开始弧度（单位：2D弧度、3D弧度）*/
        maxVerticalStartRadian: number;
        /**是否使用结束弧度,false为结束时与起始弧度保持一致,true为根据minHorizontalEndRadian、maxHorizontalEndRadian、minVerticalEndRadian、maxVerticalEndRadian计算结束弧度。*/
        useEndRadian: boolean;
        /**最小水平结束弧度（单位：2D弧度、3D弧度）*/
        minHorizontalEndRadian: number;
        /**最大水平结束弧度（单位：2D弧度、3D弧度）*/
        maxHorizontalEndRadian: number;
        /**最小垂直结束弧度（单位：2D弧度、3D弧度）*/
        minVerticalEndRadian: number;
        /**最大垂直结束弧度（单位：2D弧度、3D弧度）*/
        maxVerticalEndRadian: number;
        /**最小开始颜色*/
        minStartColor: Float32Array;
        /**最大开始颜色*/
        maxStartColor: Float32Array;
        /**最小结束颜色*/
        minEndColor: Float32Array;
        /**最大结束颜色*/
        maxEndColor: Float32Array;
        /**false代表RGBA整体插值，true代表RGBA逐分量插值*/
        colorComponentInter: boolean;
        /**false代表使用参数颜色数据，true代表使用原图颜色数据*/
        disableColor: boolean;
        /**混合模式，待调整，引擎中暂无BlendState抽象*/
        blendState: number;
        /**发射器类型,"point","box","sphere","ring"*/
        emitterType: string;
        /**发射器发射速率*/
        emissionRate: number;
        /**点发射器位置*/
        pointEmitterPosition: Float32Array;
        /**点发射器位置随机值*/
        pointEmitterPositionVariance: Float32Array;
        /**点发射器速度*/
        pointEmitterVelocity: Float32Array;
        /**点发射器速度随机值*/
        pointEmitterVelocityAddVariance: Float32Array;
        /**盒发射器中心位置*/
        boxEmitterCenterPosition: Float32Array;
        /**盒发射器尺寸*/
        boxEmitterSize: Float32Array;
        /**盒发射器速度*/
        boxEmitterVelocity: Float32Array;
        /**盒发射器速度随机值*/
        boxEmitterVelocityAddVariance: Float32Array;
        /**球发射器中心位置*/
        sphereEmitterCenterPosition: Float32Array;
        /**球发射器半径*/
        sphereEmitterRadius: number;
        /**球发射器速度*/
        sphereEmitterVelocity: number;
        /**球发射器速度随机值*/
        sphereEmitterVelocityAddVariance: number;
        /**环发射器中心位置*/
        ringEmitterCenterPosition: Float32Array;
        /**环发射器半径*/
        ringEmitterRadius: number;
        /**环发射器速度*/
        ringEmitterVelocity: number;
        /**环发射器速度随机值*/
        ringEmitterVelocityAddVariance: number;
        /**环发射器up向量，0代表X轴,1代表Y轴,2代表Z轴*/
        ringEmitterUp: number;
        /**发射器位置随机值,2D使用*/
        positionVariance: Float32Array;
        /**
         * 创建一个新的 <code>ParticleSettings</code> 类实例。
         *
         */
        constructor();
        private static _defaultSetting;
        static checkSetting(setting: any): void;
    }
}
declare module laya.particle {
    /**
     *  @private
     */
    class ParticleTemplate2D extends ParticleTemplateWebGL implements laya.webgl.submit.ISubmit {
        static activeBlendType: number;
        x: number;
        y: number;
        protected _blendFn: Function;
        sv: laya.particle.shader.value.ParticleShaderValue;
        constructor(parSetting: ParticleSetting);
        getRenderType(): number;
        releaseRender(): void;
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
        protected loadContent(): void;
        addNewParticlesToVertexBuffer(): void;
        renderSubmit(): number;
        blend(): void;
        dispose(): void;
    }
}
declare module laya.particle {
    /**
     *
     * <code>ParticleTemplateBase</code> 类是粒子模板基类
     *
     */
    class ParticleTemplateBase {
        /**
         * 粒子配置数据
         */
        settings: ParticleSetting;
        protected texture: laya.resource.Texture;
        /**
         * 创建一个新的 <code>ParticleTemplateBase</code> 类实例。
         *
         */
        constructor();
        /**
         * 添加一个粒子
         * @param position 粒子位置
         * @param velocity 粒子速度
         *
         */
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
    }
}
declare module laya.particle {
    /**
     *  @private
     */
    class ParticleTemplateCanvas extends ParticleTemplateBase {
        /**
         * 贴图列表
         */
        textureList: Array<any>;
        /**
         * 粒子列表
         */
        particleList: Array<any>;
        /**
         * 贴图中心偏移x
         */
        pX: number;
        /**
         * 贴图中心偏移y
         */
        pY: number;
        /**
         * 当前活跃的粒子
         */
        activeParticles: Array<any>;
        /**
         * 粒子pool
         */
        deadParticles: Array<any>;
        /**
         * 粒子播放进度列表
         */
        iList: Array<any>;
        protected _maxNumParticles: number;
        /**
         * 纹理的宽度
         */
        textureWidth: number;
        /**
         * 宽度倒数
         */
        dTextureWidth: number;
        /**
         * 是否支持颜色变化
         */
        colorChange: boolean;
        /**
         * 采样步长
         */
        step: number;
        constructor(particleSetting: ParticleSetting);
        clear(clearTexture?: boolean): void;
        /**
         * 设置纹理
         * @param texture
         *
         */
        setTexture(texture: any): void;
        static changeTexture(texture: any, rst: Array<any>, settings?: ParticleSetting): Array<any>;
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
        advanceTime(passedTime?: number): void;
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        noColorRender(context: laya.renders.RenderContext, x: number, y: number): void;
        canvasRender(context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.particle {
    /**
     *  @private
     */
    class ParticleTemplateWebGL extends ParticleTemplateBase {
        protected _vertices: Float32Array;
        protected _vertexBuffer: laya.webgl.utils.Buffer;
        protected _indexBuffer: laya.webgl.utils.Buffer;
        protected _floatCountPerVertex: number;
        protected _firstActiveElement: number;
        protected _firstNewElement: number;
        protected _firstFreeElement: number;
        protected _firstRetiredElement: number;
        _currentTime: number;
        protected _drawCounter: number;
        constructor(parSetting: ParticleSetting);
        protected initialize(): void;
        protected loadContent(): void;
        update(elapsedTime: number): void;
        addNewParticlesToVertexBuffer(): void;
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
    }
}
declare module laya.particle.particleUtils {
    /**
     *  @private
     */
    class CanvasShader {
        u_Duration: number;
        u_EndVelocity: number;
        u_Gravity: Float32Array;
        a_Position: Float32Array;
        a_Velocity: Float32Array;
        a_StartColor: Float32Array;
        a_EndColor: Float32Array;
        a_SizeRotation: Float32Array;
        a_Radius: Float32Array;
        a_Radian: Float32Array;
        a_AgeAddScale: number;
        _color: Float32Array;
        gl_Position: Float32Array;
        v_Color: Float32Array;
        oSize: number;
        _position: Float32Array;
        constructor();
        getLen(position: Float32Array): number;
        ComputeParticlePosition(position: Float32Array, velocity: Float32Array, age: number, normalizedAge: number): Float32Array;
        ComputeParticleSize(startSize: number, endSize: number, normalizedAge: number): number;
        ComputeParticleRotation(rot: number, age: number): number;
        ComputeParticleColor(startColor: Float32Array, endColor: Float32Array, normalizedAge: number): Float32Array;
        clamp(value: number, min: number, max: number): number;
        getData(age: number): Array<any>;
    }
}
declare module laya.particle.particleUtils {
    /**
     *
     *  @private
     *
     * @created  2015-8-25 下午3:41:07
     */
    class CMDParticle {
        constructor();
        /**
         * 最大帧
         */
        maxIndex: number;
        /**
         * 帧命令数组
         */
        cmds: Array<any>;
        /**
         * 粒子id
         */
        id: number;
        setCmds(cmds: Array<any>): void;
    }
}
declare module laya.particle.particleUtils {
    class PicTool {
        static getCanvasPic(img: any, color: number): any;
        static getRGBPic(img: any): Array<any>;
    }
}
declare module laya.particle.shader {
    /**
     *  @private
     */
    class ParticleShader extends laya.webgl.shader.Shader {
        static vs: string;
        static ps: string;
        constructor();
    }
}
declare module laya.particle.shader.value {
    /**
     *  @private
     */
    class ParticleShaderValue extends laya.webgl.shader.d2.value.Value2D {
        private static pShader;
        a_CornerTextureCoordinate: Array<any>;
        a_Position: Array<any>;
        a_Velocity: Array<any>;
        a_StartColor: Array<any>;
        a_EndColor: Array<any>;
        a_SizeRotation: Array<any>;
        a_Radius: Array<any>;
        a_Radian: Array<any>;
        a_AgeAddScale: Array<any>;
        a_Time: Array<any>;
        u_CurrentTime: number;
        u_Duration: number;
        u_Gravity: Float32Array;
        u_EndVelocity: number;
        u_texture: any;
        constructor();
        upload(): void;
    }
}
declare module laya.renders {
    /**
     * @private
     * <code>Render</code> 是渲染管理类。它是一个单例，可以使用 Laya.render 访问。
     */
    class Render {
        static _context: RenderContext;
        static _mainCanvas: laya.resource.HTMLCanvas;
        static WebGL: any;
        /**是否是Flash模式*/
        static isFlash: boolean;
        /**加速器模式下设置是否是节点模式 如果是否就是非节点模式 默认为canvas模式 如果设置了isConchWebGL则是webGL模式*/
        static isConchNode: boolean;
        /**是否是加速器 只读*/
        static isConchApp: boolean;
        /**加速器模式下设置是否是节点模式 如果是否就是非节点模式 默认为canvas模式 如果设置了isConchWebGL则是webGL模式*/
        static isConchWebGL: boolean;
        /**是否是WebGL模式*/
        static isWebGL: boolean;
        /** 表示是否是 3D 模式。*/
        static is3DMode: boolean;
        static optimizeTextureMemory: Function;
        /**
         * 初始化引擎。
         * @param	width 游戏窗口宽度。
         * @param	height	游戏窗口高度。
         */
        constructor(width: number, height: number);
        /** 目前使用的渲染器。*/
        static context: RenderContext;
        /** 渲染使用的原生画布引用。 */
        static canvas: any;
    }
}
declare module laya.renders {
    /**
     * @private
     * 渲染环境
     */
    class RenderContext {
        /**Math.PI*2的结果缓存 */
        static PI2: number;
        /**全局x坐标 */
        x: number;
        /**全局y坐标 */
        y: number;
        /**当前使用的画布 */
        canvas: laya.resource.HTMLCanvas;
        /**当前使用的画布上下文 */
        ctx: any;
        /**销毁当前渲染环境*/
        destroy(): void;
        constructor(width: number, height: number, canvas?: laya.resource.HTMLCanvas);
        drawTexture(tex: laya.resource.Texture, x: number, y: number, width: number, height: number): void;
        _drawTexture: Function;
        _drawTextures(x: number, y: number, args: Array<any>): void;
        _fillTexture: Function;
        drawTextureWithTransform(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, m: laya.maths.Matrix, alpha: number): void;
        _drawTextureWithTransform: Function;
        fillQuadrangle(tex: any, x: number, y: number, point4: Array<any>, m: laya.maths.Matrix): void;
        _fillQuadrangle: Function;
        drawCanvas(canvas: laya.resource.HTMLCanvas, x: number, y: number, width: number, height: number): void;
        drawRect(x: number, y: number, width: number, height: number, color: string, lineWidth?: number): void;
        _drawRect: Function;
        _drawPie: Function;
        clipRect(x: number, y: number, width: number, height: number): void;
        _clipRect: Function;
        fillRect(x: number, y: number, width: number, height: number, fillStyle: any): void;
        _fillRect: Function;
        drawCircle(x: number, y: number, radius: number, color: string, lineWidth?: number): void;
        _drawCircle: Function;
        fillCircle(x: number, y: number, radius: number, color: string): void;
        _fillCircle: Function;
        setShader(shader: any): void;
        _setShader: Function;
        drawLine(fromX: number, fromY: number, toX: number, toY: number, color: string, lineWidth?: number): void;
        _drawLine: Function;
        _drawLines: Function;
        _drawLinesWebGL: Function;
        _drawCurves: Function;
        _draw: Function;
        clear(): void;
        transformByMatrix(value: laya.maths.Matrix): void;
        _transformByMatrix: Function;
        setTransform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        _setTransform: Function;
        setTransformByMatrix(value: laya.maths.Matrix): void;
        _setTransformByMatrix: Function;
        save(): void;
        _save: Function;
        restore(): void;
        _restore: Function;
        translate(x: number, y: number): void;
        _translate: Function;
        transform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        _transform: Function;
        rotate(angle: number): void;
        _rotate: Function;
        scale(scaleX: number, scaleY: number): void;
        _scale: Function;
        alpha(value: number): void;
        _alpha: Function;
        setAlpha(value: number): void;
        _setAlpha: Function;
        fillWords(words: Array<any>, x: number, y: number, font: string, color: string): void;
        fillBorderWords(words: Array<any>, x: number, y: number, font: string, fillColor: string, borderColor: string, lineWidth: number): void;
        fillText(text: string, x: number, y: number, font: string, color: string, textAlign: string): void;
        _fillText: Function;
        strokeText(text: string, x: number, y: number, font: string, color: string, lineWidth: number, textAlign: string): void;
        _strokeText: Function;
        _fillBorderText: Function;
        blendMode(type: string): void;
        _blendMode: Function;
        flush(): void;
        addRenderObject(o: any): void;
        beginClip(x: number, y: number, w: number, h: number): void;
        _beginClip: Function;
        endClip(): void;
        _setIBVB: Function;
        fillTrangles(x: number, y: number, args: Array<any>): void;
        _fillTrangles: Function;
        _drawPath: Function;
        drawPoly: Function;
        _drawPoly: Function;
        _drawSkin: Function;
        _drawParticle: Function;
    }
}
declare module laya.renders {
    /**
     * @private
     * 精灵渲染器
     */
    class RenderSprite {
        static IMAGE: number;
        static ALPHA: number;
        static TRANSFORM: number;
        static BLEND: number;
        static CANVAS: number;
        static FILTERS: number;
        static MASK: number;
        static CLIP: number;
        static STYLE: number;
        static GRAPHICS: number;
        static CUSTOM: number;
        static CHILDS: number;
        static INIT: number;
        static renders: Array<any>;
        protected static NORENDER: RenderSprite;
        _next: RenderSprite;
        _fun: Function;
        static __init__(): void;
        constructor(type: number, next: RenderSprite);
        protected onCreate(type: number): void;
        _style(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _no(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _custom(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _clip(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _blend(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _mask(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _graphics(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _image(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _image2(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _alpha(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _transform(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _childs(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _canvas(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
    }
}
declare module laya.resource {
    /**
     * @private
     * <code>Bitmap</code> 是图片资源类。
     */
    class Bitmap extends Resource {
        protected _source: any;
        protected _w: number;
        protected _h: number;
        useNum: number;
        /***
         * 宽度。
         */
        width: number;
        /***
         * 高度。
         */
        height: number;
        /***
         * HTML Image 或 HTML Canvas 或 WebGL Texture 。
         */
        source: any;
        /**
         * 创建一个 <code>Bitmap</code> 实例。
         */
        constructor();
        /**
         * 彻底清理资源。
         */
        dispose(): void;
    }
}
declare module laya.resource {
    /**
     * @private
     * Context扩展类
     */
    class Context {
        private static _default;
        _canvas: HTMLCanvas;
        _repaint: boolean;
        static __init__(to?: any): void;
        setIsMainContext(): void;
        font: string;
        textBaseline: string;
        fillStyle: any;
        translate(x: number, y: number): void;
        scale(scaleX: number, scaleY: number): void;
        drawImage(...args: any[]): void;
        getImageData(...args: any[]): any;
        measureText(text: string): any;
        setTransform(...args: any[]): void;
        beginPath(): void;
        strokeStyle: any;
        globalCompositeOperation: string;
        rect(x: number, y: number, width: number, height: number): void;
        stroke(): void;
        transform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        save(): void;
        restore(): void;
        clip(): void;
        arcTo(x1: number, y1: number, x2: number, y2: number, r: number): void;
        quadraticCurveTo(cpx: number, cpy: number, x: number, y: number): void;
        lineJoin: string;
        lineCap: string;
        miterLimit: string;
        globalAlpha: number;
        clearRect(x: number, y: number, width: number, height: number): void;
        drawTextures(tex: Texture, pos: Array<any>, tx: number, ty: number): void;
        drawCanvas(canvas: HTMLCanvas, x: number, y: number, width: number, height: number): void;
        fillRect(x: number, y: number, width: number, height: number, style: any): void;
        fillText(text: any, x: number, y: number, font: string, color: string, textAlign: string): void;
        fillBorderText(text: any, x: number, y: number, font: string, fillColor: string, borderColor: string, lineWidth: number, textAlign: string): void;
        strokeText(text: any, x: number, y: number, font: string, color: string, lineWidth: number, textAlign: string): void;
        transformByMatrix(value: laya.maths.Matrix): void;
        setTransformByMatrix(value: laya.maths.Matrix): void;
        clipRect(x: number, y: number, width: number, height: number): void;
        drawTexture(tex: Texture, x: number, y: number, width: number, height: number, tx: number, ty: number): void;
        drawTextureWithTransform(tex: Texture, x: number, y: number, width: number, height: number, m: laya.maths.Matrix, tx: number, ty: number, alpha: number): void;
        drawTexture2(x: number, y: number, pivotX: number, pivotY: number, m: laya.maths.Matrix, alpha: number, blendMode: string, args2: Array<any>): void;
        fillTexture(texture: Texture, x: number, y: number, width: number, height: number, type: string, offset: laya.maths.Point, other: any): void;
        flush(): number;
        fillWords(words: Array<any>, x: number, y: number, font: string, color: string): void;
        fillBorderWords(words: Array<any>, x: number, y: number, font: string, color: string, borderColor: string, lineWidth: number): void;
        destroy(): void;
        clear(): void;
        drawCurves(x: number, y: number, args: Array<any>): void;
    }
}
declare module laya.resource {
    /**
     * @private
     * <code>FileBitmap</code> 是图片文件资源类。
     */
    class FileBitmap extends Bitmap {
        protected _src: string;
        /**
         * 文件路径全名。
         */
        src: string;
        protected _onload: Function;
        protected _onerror: Function;
        /**
         * 载入完成处理函数。
         */
        onload: Function;
        /**
         * 错误处理函数。
         */
        onerror: Function;
    }
}
declare module laya.resource {
    /**
     * <code>HTMLCanvas</code> 是 Html Canvas 的代理类，封装了 Canvas 的属性和方法。。请不要直接使用 new HTMLCanvas！
     */
    class HTMLCanvas extends Bitmap {
        /**
         * 根据指定的类型，创建一个 <code>HTMLCanvas</code> 实例。
         * @param	type 类型。2D、3D。
         */
        static create: Function;
        /** 2D 模式。*/
        static TYPE2D: string;
        /** 3D 模式。*/
        static TYPE3D: string;
        /** 自动模式。*/
        static TYPEAUTO: string;
        static _createContext: Function;
        /**
         * 根据指定的类型，创建一个 <code>HTMLCanvas</code> 实例。请不要直接使用 new HTMLCanvas！
         * @param	type 类型。2D、3D。
         */
        constructor(type: string);
        /**
         * 清空画布内容。
         */
        clear(): void;
        /**
         * 销毁。
         */
        destroy(): void;
        /**
         * 释放。
         */
        release(): void;
        /**
         * Canvas 渲染上下文。
         */
        context: Context;
        /**
         * @private
         * 设置 Canvas 渲染上下文。
         * @param	context Canvas 渲染上下文。
         */
        _setContext(context: Context): void;
        /**
         * 获取 Canvas 渲染上下文。
         * @param	contextID 上下文ID.
         * @param	other
         * @return  Canvas 渲染上下文 Context 对象。
         */
        getContext: Function;
        /**
         * 获取内存大小。
         * @return 内存大小。
         */
        getMemSize(): number;
        return: any;
        asBitmap: boolean;
        /**
         * 设置宽高。
         * @param	w 宽度。
         * @param	h 高度。
         */
        size(w: number, h: number): void;
        getCanvas(): any;
    }
}
declare module laya.resource {
    /**
     * <code>HTMLImage</code> 用于创建 HTML Image 元素。
     * @private
     */
    class HTMLImage extends FileBitmap {
        /**
         * 创建一个 <code>HTMLImage</code> 实例。请不要直接使用 new HTMLImage
         */
        static create: Function;
        protected _recreateLock: boolean;
        protected _needReleaseAgain: boolean;
        /**
         * @inheritDoc
         */
        onload: Function;
        /**
         * @inheritDoc
         */
        onerror: Function;
        /**
         * 创建一个 <code>HTMLImage</code> 实例。请不要直接使用 new HTMLImage
         */
        constructor(src: string, def?: any);
        protected _init_(src: string, def: any): void;
        protected recreateResource(): void;
        protected detoryResource(): void;
        protected onresize(): void;
    }
}
declare module laya.resource {
    /**
     * @private
     */
    class HTMLSubImage extends Bitmap {
        static create: Function;
        constructor(canvas: any, offsetX: number, offsetY: number, width: number, height: number, atlasImage: any, src: string, allowMerageInAtlas: boolean);
    }
}
declare module laya.resource {
    /**
     * @private
     * <code>ICreateResource</code> 对象创建接口。
     */
    interface ICreateResource {
    }
}
declare module laya.resource {
    /**
     * @private
     * <code>IDestroy</code> 是对象销毁的接口。
     */
    interface IDestroy {
    }
}
declare module laya.resource {
    /**
     * @private
     * <code>IDispose</code> 是资源销毁的接口。
     */
    interface IDispose {
    }
}
declare module laya.resource {
    /**
     * <code>Resource</code> 资源存取类。
     */
    class Resource extends laya.events.EventDispatcher implements ICreateResource, IDispose {
        private static _uniqueIDCounter;
        private static _loadedResources;
        private static _isLoadedResourcesSorted;
        /**
         * 通过索引返回本类型已载入资源。
         * @param index 索引。
         * @return 资源 <code>Resource</code> 对象。
         */
        static getLoadedResourceByIndex(index: number): Resource;
        /**
         * 本类型已载入资源个数。
         */
        static getLoadedResourcesCount(): number;
        /**
         * 本类型排序后的已载入资源。
         */
        static sortedLoadedResourcesByName: Array<any>;
        protected _loaded: boolean;
        _resourceManager: ResourceManager;
        /**是否加锁，true为不能使用自动释放机制。*/
        lock: boolean;
        /**
         * 获取唯一标识ID(通常用于优化或识别)。
         */
        id: number;
        /**
         * 获取名字。
         */
        /**
         * 设置名字
         */
        name: string;
        /**
         * 资源管理员。
         */
        resourceManager: ResourceManager;
        /**
         * 距离上次使用帧率。
         */
        lastUseFrameCount: number;
        /**
         * 占用内存尺寸。
         */
        memorySize: number;
        /**
         * 是否已释放。
         */
        released: boolean;
        /**
         * 是否已处理。
         */
        disposed: boolean;
        loaded: boolean;
        /**
         * 获取资源的URL地址。
         * @return URL地址。
         */
        /**
         * 色湖之资源的URL地址。
         * @param value URL地址。
         */
        url: string;
        /**
         * 创建一个 <code>Resource</code> 实例。
         */
        constructor();
        protected recreateResource(): void;
        protected detoryResource(): void;
        /**
         * 激活资源，使用资源前应先调用此函数激活。
         * @param force 是否强制创建。
         */
        activeResource(force?: boolean): void;
        /**
         * 释放资源。
         * @param force 是否强制释放。
         * @return 是否成功释放。
         */
        releaseResource(force?: boolean): boolean;
        /**
         * 设置唯一名字,如果名字重复则自动加上“-copy”。
         * @param newName 名字。
         */
        setUniqueName(newName: string): void;
        /**
         *@private
         */
        onAsynLoaded(url: string, data: any, params: Array<any>): void;
        /**
         * <p>彻底处理资源，处理后不能恢复。</p>
         * <p><b>注意：</b>会强制解锁清理。</p>
         */
        dispose(): void;
        protected startCreate(): void;
        protected completeCreate(): void;
    }
}
declare module laya.resource {
    /**
     * <code>ResourceManager</code> 是资源管理类。它用于资源的载入、获取、销毁。
     */
    class ResourceManager implements IDispose {
        private static _uniqueIDCounter;
        private static _systemResourceManager;
        private static _isResourceManagersSorted;
        private static _resourceManagers;
        /** 当前资源管理器。*/
        static currentResourceManager: ResourceManager;
        /**
         * 系统资源管理器。
         */
        static systemResourceManager: ResourceManager;
        /**
         * @private
         * 资源管理类初始化。
         */
        static __init__(): void;
        /**
         * 获取指定索引的资源管理器。
         * @param index 索引。
         * @return 资源管理器。
         */
        static getLoadedResourceManagerByIndex(index: number): ResourceManager;
        /**
         * 获取资源管理器总个数。
         *  @return  资源管理器总个数。
         */
        static getLoadedResourceManagersCount(): number;
        /**
         * 排序后的资源管理器列表。
         */
        static sortedResourceManagersByName: Array<any>;
        /**
         * 重新强制创建资源管理员以及所拥有资源（显卡丢失时处理）。
         */
        static recreateContentManagers(force?: boolean): void;
        /**释放资源管理员所拥有资源（显卡丢失时处理）。*/
        static releaseContentManagers(force?: boolean): void;
        /** 是否启用自动释放机制。*/
        autoRelease: boolean;
        /**自动释放机制的内存触发上限,以字节为单位。*/
        autoReleaseMaxSize: number;
        /**
         * 唯一标识 ID 。
         */
        id: number;
        /**
         * 名字。
         */
        name: string;
        /**
         * 此管理器所管理资源的累计内存，以字节为单位。
         */
        memorySize: number;
        /**
         * 创建一个 <code>ResourceManager</code> 实例。
         */
        constructor();
        /**
         * 获取指定索引的资源 Resource 对象。
         * @param 索引。
         * @return 资源 Resource 对象。
         */
        getResourceByIndex(index: number): Resource;
        /**
         * 获取此管理器所管理的资源个数。
         * @return 资源个数。
         */
        getResourcesLength(): number;
        /**
         * 添加指定资源。
         * @param	resource 需要添加的资源 Resource 对象。
         * @return 是否添加成功。
         */
        addResource(resource: Resource): boolean;
        /**
         * 移除指定资源。
         * @param	resource 需要移除的资源 Resource 对象
         * @return 是否移除成功。
         */
        removeResource(resource: Resource): boolean;
        /**
         * 卸载此资源管理器载入的资源。
         */
        unload(): void;
        /**
         * 设置唯一名字。
         * @param newName 名字，如果名字重复则自动加上“-copy”。
         */
        setUniqueName(newName: string): void;
        /** 释放资源。*/
        dispose(): void;
        /**
         * 增加内存。
         * @param add 需要增加的内存大小。
         */
        addSize(add: number): void;
    }
}
declare module laya.resource {
    /**
     * <code>Texture</code> 是一个纹理处理类。
     */
    class Texture extends laya.events.EventDispatcher {
        /**默认 UV 信息。*/
        static DEF_UV: Array<any>;
        static INV_UV: Array<any>;
        private static _rect1;
        private static _rect2;
        /** 图片或者canvas 。*/
        bitmap: any;
        /** UV信息。*/
        uv: Array<any>;
        /**沿 X 轴偏移量。*/
        offsetX: number;
        /**沿 Y 轴偏移量。*/
        offsetY: number;
        /**原始宽度（包括被裁剪的透明区域）。*/
        sourceWidth: number;
        /**原始高度（包括被裁剪的透明区域）。*/
        sourceHeight: number;
        protected _loaded: boolean;
        protected _w: number;
        protected _h: number;
        $_GID: number;
        /**图片地址*/
        url: string;
        _uvID: number;
        /**
         * 创建一个 <code>Texture</code> 实例。
         * @param	bitmap 位图资源。
         * @param	uv UV 数据信息。
         */
        constructor(bitmap?: Bitmap, uv?: Array<any>);
        /**
         * 设置此对象的位图资源、UV数据信息。
         * @param	bitmap 位图资源
         * @param	uv UV数据信息
         */
        setTo(bitmap?: Bitmap, uv?: Array<any>): void;
        /**
         * 平移 UV。
         * @param offsetX 沿 X 轴偏移量。
         * @param offsetY 沿 Y 轴偏移量。
         * @param uv 需要平移操作的的 UV。
         * @return 平移后的UV。
         */
        static moveUV(offsetX: number, offsetY: number, uv: Array<any>): Array<any>;
        /**
         *  根据指定资源和坐标、宽高、偏移量等创建 <code>Texture</code> 对象。
         * @param	source 绘图资源 img 或者 Texture 对象。
         * @param	x 起始绝对坐标 x 。
         * @param	y 起始绝对坐标 y 。
         * @param	width 宽绝对值。
         * @param	height 高绝对值。
         * @param	offsetX X 轴偏移量（可选）。
         * @param	offsetY Y 轴偏移量（可选）。
         * @param	sourceWidth 原始宽度，包括被裁剪的透明区域（可选）。
         * @param	sourceHeight 原始高度，包括被裁剪的透明区域（可选）。
         * @return  <code>Texture</code> 对象。
         */
        static create(source: any, x: number, y: number, width: number, height: number, offsetX?: number, offsetY?: number, sourceWidth?: number, sourceHeight?: number): Texture;
        /**
         * 截取Texture的一部分区域，生成新的Texture，如果两个区域没有相交，则返回null
         * @param	texture 目标Texture
         * @param	x 相对于目标Texture的x位置
         * @param	y 相对于目标Texture的y位置
         * @param	width 截取的宽度
         * @param	height 截取的高度
         * @return	返回一个新的Texture
         */
        static createFromTexture(texture: Texture, x: number, y: number, width: number, height: number): Texture;
        /**
         * 表示是否加载成功，只能表示初次载入成功（通常包含下载和载入）,并不能完全表示资源是否可立即使用（资源管理机制释放影响等）。
         */
        loaded: boolean;
        /**
         * 表示资源是否已释放。
         */
        released: boolean;
        active(): void;
        /** 激活并获取资源。*/
        source: any;
        /**
         * 销毁纹理（分直接销毁，跟计数销毁两种）
         * @param	forceDispose	true为强制销毁主纹理，false是通过计数销毁纹理
         */
        destroy(forceDispose?: boolean): void;
        /** 实际宽度。*/
        width: number;
        /** 实际高度。*/
        height: number;
        /**
         * 获取当前纹理是否启用了线性采样
         */
        /**
         * 设置线性采样的状态（目前只能第一次绘制前设置false生效,来关闭线性采样）
         */
        isLinearSampling: boolean;
        /**
         * 获取当前纹理是否启用了纹理平铺
         */
        /**
         * 通过外部设置是否启用纹理平铺(后面要改成在着色器里计算)
         */
        repeat: boolean;
        /**
         * 加载指定地址的图片。
         * @param	url 图片地址。
         */
        load(url: string): void;
        addTextureToAtlas(e?: any): void;
        /**
         * 获取Texture上的某个区域的像素点
         * @param	x
         * @param	y
         * @param	width
         * @param	height
         * @return  返回像素点集合
         */
        getPixels(x: number, y: number, width: number, height: number): Array<any>;
        onAsynLoaded(url: string, bitmap: Bitmap): void;
    }
}
declare module laya.runtime {
    /**
     * @private
     */
    interface IConchNode {
    }
}
declare module laya.runtime {
    /**
     * ...
     * @author hugao
     */
    interface IConchRenderObject {
    }
}
declare module laya.runtime {
    /**
     * ...
     * @author hugao
     */
    interface ICPlatformClass {
    }
}
declare module laya.runtime {
    /**
     * @private
     */
    interface IMarket {
    }
}
declare module laya.runtime {
    /**
     * ...
     * @author hugao
     */
    interface IPlatform {
    }
}
declare module laya.runtime {
    /**
     * ...
     * @author hugao
     */
    interface IPlatformClass extends IPlatform {
    }
}
declare module laya.system {
    /**
     * @private
     */
    class System {
        /**
         * 替换指定名称的定义。用来动态更改类的定义。
         * @param	name 属性名。
         * @param	classObj 属性值。
         */
        static changeDefinition(name: string, classObj: any): void;
        /**
         * @private
         * 初始化。
         */
        static __init__(): void;
    }
}
declare module laya.ui {
    /**
     * 异步Dialog的生命周期:show或者popup > onCreate(如果没有创建过) > onOpen > onClose > onDestroy(如果销毁)
     * onCreate在页面未创建时执行一次，再次打开页面不会再执行，适合写一些只执行一次的逻辑，比如资源加载，节点事件监听
     * onOpen在页面每次打开都会执行，适合做一些每次都需要处理的事情，比如消息请求，根据数据初始化页面
     * onClose在每次关闭的时候调用，适合关闭时停止动画，网络消息监听等逻辑
     * onDestroy在页面被销毁的时候调用，适合置空引用对象
     */
    class AsynDialog extends Dialog {
        protected _uiView: any;
        /**打开时是否关闭其他页面*/
        isCloseOther: boolean;
        protected createView(uiView: any): void;
        protected _open(modal: boolean, closeOther: boolean): void;
        /**
         * 在页面未创建时执行一次，再次打开页面不会再执行，适合写一些只执行一次的逻辑，比如资源加载，节点事件监听
         */
        onCreated(): void;
        /**根据节点数据创建UI*/
        createUI(): void;
        /**
         * 在页面每次打开都会执行，适合做一些每次都需要处理的事情，比如消息请求，根据数据初始化页面
         */
        onOpen(): void;
        close(type?: string): void;
        /**
         * 在每次关闭的时候调用，适合关闭时停止动画，网络消息监听等逻辑
         */
        onClose(): void;
        destroy(destroyChild?: boolean): void;
        /**
         * 在页面被销毁的时候调用，适合置空引用对象
         */
        onDestroy(): void;
    }
}
declare module laya.ui {
    /**
     * <code>AutoBitmap</code> 类是用于表示位图图像或绘制图形的显示对象。
     * <p>封装了位置，宽高及九宫格的处理，供UI组件使用。</p>
     */
    class AutoBitmap extends laya.display.Graphics {
        private static cmdCaches;
        private static cacheCount;
        private static textureCache;
        autoCacheCmd: boolean;
        _offset: Array<any>;
        /**@inheritDoc */
        destroy(): void;
        /**
         * 当前实例的有效缩放网格数据。
         * <p>如果设置为null,则在应用任何缩放转换时，将正常缩放整个显示对象。</p>
         * <p>数据格式：[上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)]。
         * <ul><li>例如：[4,4,4,4,1]</li></ul></p>
         * <p> <code>sizeGrid</code> 的值如下所示：
         * <ol>
         * <li>上边距</li>
         * <li>右边距</li>
         * <li>下边距</li>
         * <li>左边距</li>
         * <li>是否重复填充(值为0：不重复填充，1：重复填充)</li>
         * </ol></p>
         * <p>当定义 <code>sizeGrid</code> 属性时，该显示对象被分割到以 <code>sizeGrid</code> 数据中的"上边距,右边距,下边距,左边距" 组成的矩形为基础的具有九个区域的网格中，该矩形定义网格的中心区域。网格的其它八个区域如下所示：
         * <ul>
         * <li>矩形上方的区域</li>
         * <li>矩形外的右上角</li>
         * <li>矩形左侧的区域</li>
         * <li>矩形右侧的区域</li>
         * <li>矩形外的左下角</li>
         * <li>矩形下方的区域</li>
         * <li>矩形外的右下角</li>
         * <li>矩形外的左上角</li>
         * </ul>
         * 同时也支持3宫格，比如0,4,0,4,1为水平3宫格，4,0,4,0,1为垂直3宫格，3宫格性能比9宫格高。
         * </p>
         */
        sizeGrid: Array<any>;
        /**
         * 表示显示对象的宽度，以像素为单位。
         */
        width: number;
        /**
         * 表示显示对象的高度，以像素为单位。
         */
        height: number;
        /**
         * 对象的纹理资源。
         * @see laya.resource.Texture
         */
        source: laya.resource.Texture;
        protected _setChanged(): void;
        /**
         *  清理命令缓存。
         */
        static clearCache(): void;
        static setCache(key: string, value: any): void;
        static getCache(key: string): any;
    }
}
declare module laya.ui {
    /**
     * <code>Box</code> 类是一个控件容器类。
     */
    class Box extends Component implements IBox {
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**
     * <code>Button</code> 组件用来表示常用的多态按钮。 <code>Button</code> 组件可显示文本标签、图标或同时显示两者。	 *
     * <p>可以是单态，两态和三态，默认三态(up,over,down)。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Button</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Button;
     *		import laya.utils.Handler;
     *		public class Button_Example
     *		{
     *			public function Button_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/button.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				trace("资源加载完成！");
     *				var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
     *				button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
     *				button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
     *				button.clickHandler = new Handler(this, onClickButton,[button]);//设置 button 的点击事件处理器。
     *				Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
     *			}
     *			private function onClickButton(button:Button):void
     *			{
     *				trace("按钮button被点击了！");
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
     * function loadComplete()
     * {
     *     console.log("资源加载完成！");
     *     var button = new laya.ui.Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
     *     button.x =100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
     *     button.y =100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
     *     button.clickHandler = laya.utils.Handler.create(this,onClickButton,[button],false);//设置 button 的点击事件处理函数。
     *     Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
     * }
     * function onClickButton(button)
     * {
     *     console.log("按钮被点击了。",button);
     * }
     * </listing>
     * <listing version="3.0">
     * import Button=laya.ui.Button;
     * import Handler=laya.utils.Handler;
     * class Button_Example{
     *     constructor()
     *     {
     *         Laya.init(640, 800);
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ui/button.png", laya.utils.Handler.create(this,this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete()
     *     {
     *         var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
     *         button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
     *         button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
     *         button.clickHandler = new Handler(this, this.onClickButton,[button]);//设置 button 的点击事件处理器。
     *         Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
     *     }
     *     private onClickButton(button:Button):void
     *     {
     *         console.log("按钮button被点击了！")
     *     }
     * }
     * </listing>
     */
    class Button extends Component implements ISelect {
        protected static stateMap: any;
        /**
         * 指定按钮按下时是否是切换按钮的显示状态。
         *
         * @example 以下示例代码，创建了一个 <code>Button</code> 实例，并设置为切换按钮。
         * <listing version="3.0">
         * package
         *	{
         *		import laya.ui.Button;
         *		import laya.utils.Handler;
         *		public class Button_toggle
         *		{
         *			public function Button_toggle()
         *			{
         *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
         *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
         *				Laya.loader.load("resource/ui/button.png", Handler.create(this,onLoadComplete));
         *			}
         *			private function onLoadComplete():void
         *			{
         *				trace("资源加载完成！");
         *				var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 实例对象 button ,传入它的皮肤skin和标签label。
         *				button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
         *				button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
         *				button.toggle = true;//设置 button 对象为切换按钮。
         *				button.clickHandler = new Handler(this, onClickButton,[button]);//设置 button 的点击事件处理器。
         *				Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
         *	 		}
         *			private function onClickButton(button:Button):void
         *			{
         *				trace("button.selected = "+ button.selected);
         *			}
         *		}
         *	}
         * </listing>
         * <listing version="3.0">
         * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
         * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
         * Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
         * function loadComplete()
         * {
         *     console.log("资源加载完成！");
         *     var button = new laya.ui.Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
         *     button.x =100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
         *     button.y =100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
         *     button.toggle = true;//设置 button 对象为切换按钮。
         *     button.clickHandler = laya.utils.Handler.create(this,onClickButton,[button],false);//设置 button 的点击事件处理器。
         *     Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
         * }
         * function onClickButton(button)
         * {
         *     console.log("button.selected = ",button.selected);
         * }
         * </listing>
         * <listing version="3.0">
         * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
         * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
         * Laya.loader.load("button.png", null,null, null, null, null);//加载资源
         * function loadComplete() {
         *     console.log("资源加载完成！");
         *     var button:laya.ui.Button = new laya.ui.Button("button.png", "label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
         *     button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
         *     button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
         *     button.toggle = true;//设置 button 对象为切换按钮。
         *     button.clickHandler = laya.utils.Handler.create(this, onClickButton, [button], false);//设置 button 的点击事件处理器。
         *     Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
         * }
         * function onClickButton(button) {
         *     console.log("button.selected = ", button.selected);
         * }
         * </listing>
         */
        toggle: boolean;
        protected _bitmap: laya.ui.AutoBitmap;
        protected _text: laya.display.Text;
        protected _labelColors: Array<any>;
        protected _strokeColors: Array<any>;
        protected _state: number;
        protected _selected: boolean;
        protected _skin: string;
        protected _autoSize: boolean;
        protected _stateNum: number;
        protected _sources: Array<any>;
        protected _clickHandler: laya.utils.Handler;
        protected _stateChanged: boolean;
        /**
         * 创建一个新的 <code>Button</code> 类实例。
         * @param skin 皮肤资源地址。
         * @param label 按钮的文本内容。
         */
        constructor(skin?: string, label?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected createText(): void;
        protected initialize(): void;
        protected onMouse(e: laya.events.Event): void;
        /**
         * <p>对象的皮肤资源地址。</p>
         * 支持单态，两态和三态，用 <code>stateNum</code> 属性设置
         * <p>对象的皮肤地址，以字符串表示。</p>
         * @see #stateNum
         */
        skin: string;
        /**
         * <p>指定对象的状态值，以数字表示。</p>
         * <p>默认值为3。此值决定皮肤资源图片的切割方式。</p>
         * <p><b>取值：</b>
         * <li>1：单态。图片不做切割，按钮的皮肤状态只有一种。</li>
         * <li>2：两态。图片将以竖直方向被等比切割为2部分，从上向下，依次为
         * 弹起状态皮肤、
         * 按下和经过及选中状态皮肤。</li>
         * <li>3：三态。图片将以竖直方向被等比切割为2部分，从上向下，依次为
         * 弹起状态皮肤、
         * 经过状态皮肤、
         * 按下和选中状态皮肤</li>
         * </p>
         */
        stateNum: number;
        protected changeClips(): void;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * 按钮的文本内容。
         */
        label: string;
        /**
         * 表示按钮的选中状态。
         * <p>如果值为true，表示该对象处于选中状态。否则该对象处于未选中状态。</p>
         */
        selected: boolean;
        protected state: number;
        protected changeState(): void;
        /**
         * 表示按钮各个状态下的文本颜色。
         * <p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
         */
        labelColors: string;
        /**
         * 表示按钮各个状态下的描边颜色。
         * <p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
         */
        strokeColors: string;
        /**
         * 表示按钮文本标签的边距。
         * <p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
         */
        labelPadding: string;
        /**
         * 表示按钮文本标签的字体大小。
         * @see laya.display.Text.fontSize()
         */
        labelSize: number;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         * @see laya.display.Text.stroke()
         */
        labelStroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * 默认值为 "#000000"（黑色）;
         * @see laya.display.Text.strokeColor()
         */
        labelStrokeColor: string;
        /**
         * 表示按钮文本标签是否为粗体字。
         * @see laya.display.Text.bold()
         */
        labelBold: boolean;
        /**
         * 表示按钮文本标签的字体名称，以字符串形式表示。
         * @see laya.display.Text.font()
         */
        labelFont: string;
        /**标签对齐模式，默认为居中对齐。*/
        labelAlign: string;
        /**
         * 对象的点击事件处理器函数（无默认参数）。
         */
        clickHandler: laya.utils.Handler;
        /**
         * 按钮文本标签 <code>Text</code> 控件。
         */
        text: laya.display.Text;
        /**
         * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         */
        sizeGrid: string;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**@inheritDoc */
        dataSource: any;
        /**图标x,y偏移，格式：100,100*/
        iconOffset: string;
        protected _setStateChanged(): void;
    }
}
declare module laya.ui {
    /**
     * <code>CheckBox</code> 组件显示一个小方框，该方框内可以有选中标记。
     * <code>CheckBox</code> 组件还可以显示可选的文本标签，默认该标签位于 CheckBox 右侧。
     * <p><code>CheckBox</code> 使用 <code>dataSource</code>赋值时的的默认属性是：<code>selected</code>。</p>
     *
     * @example 以下示例代码，创建了一个 <code>CheckBox</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.CheckBox;
     *		import laya.utils.Handler;
     *		public class CheckBox_Example
     *		{
     *			public function CheckBox_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     * 				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/check.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				trace("资源加载完成！");
     *				var checkBox:CheckBox = new CheckBox("resource/ui/check.png", "这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
     *				checkBox.x = 100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
     *				checkBox.y = 100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
     *				checkBox.clickHandler = new Handler(this, onClick, [checkBox]);//设置 checkBox 的点击事件处理器。
     *				Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
     *			}
     *			private function onClick(checkBox:CheckBox):void
     *			{
     *				trace("输出选中状态: checkBox.selected = " + checkBox.selected);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * Laya.loader.load("resource/ui/check.png",laya.utils.Handler.create(this,loadComplete));//加载资源
     * function loadComplete()
     * {
     *     console.log("资源加载完成！");
     *     var checkBox:laya.ui.CheckBox= new laya.ui.CheckBox("resource/ui/check.png", "这个是一个CheckBox组件。");//创建一个 CheckBox 类的类的实例对象 checkBox ,传入它的皮肤skin和标签label。
     *     checkBox.x =100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
     *     checkBox.y =100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
     *     checkBox.clickHandler = new laya.utils.Handler(this,this.onClick,[checkBox],false);//设置 checkBox 的点击事件处理器。
     *     Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
     * }
     * function onClick(checkBox)
     * {
     *     console.log("checkBox.selected = ",checkBox.selected);
     * }
     * </listing>
     * <listing version="3.0">
     * import CheckBox= laya.ui.CheckBox;
     * import Handler=laya.utils.Handler;
     * class CheckBox_Example{
     *     constructor()
     *     {
     *         Laya.init(640, 800);
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ui/check.png", Handler.create(this,this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete()
     *     {
     *         var checkBox:CheckBox = new CheckBox("resource/ui/check.png", "这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
     *         checkBox.x = 100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
     *         checkBox.y = 100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
     *         checkBox.clickHandler = new Handler(this, this.onClick,[checkBox]);//设置 checkBox 的点击事件处理器。
     *         Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
     *     }
     *     private onClick(checkBox:CheckBox):void
     *     {
     *         console.log("输出选中状态: checkBox.selected = " + checkBox.selected);
     *     }
     * }
     * </listing>
     */
    class CheckBox extends laya.ui.Button {
        /**
         * 创建一个新的 <code>CheckBox</code> 组件实例。
         * @param skin 皮肤资源地址。
         * @param label 文本标签的内容。
         */
        constructor(skin?: string, label?: string);
        protected preinitialize(): void;
        protected initialize(): void;
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**
     * <p> <code>Clip</code> 类是位图切片动画。</p>
     * <p> <code>Clip</code> 可将一张图片，按横向分割数量 <code>clipX</code> 、竖向分割数量 <code>clipY</code> ，
     * 或横向分割每个切片的宽度 <code>clipWidth</code> 、竖向分割每个切片的高度 <code>clipHeight</code> ，
     * 从左向右，从上到下，分割组合为一个切片动画。</p>
     * Image和Clip组件是唯一支持异步加载的两个组件，比如clip.skin = "abc/xxx.png"，其他UI组件均不支持异步加载。
     *
     * @example 以下示例代码，创建了一个 <code>Clip</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Clip;
     *		public class Clip_Example
     *		{
     *			private var clip:Clip;
     *			public function Clip_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				onInit();
     *			}
     *			private function onInit():void
     *			{
     *				clip = new Clip("resource/ui/clip_num.png", 10, 1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
     *				clip.autoPlay = true;//设置 clip 动画自动播放。
     *				clip.interval = 100;//设置 clip 动画的播放时间间隔。
     *				clip.x = 100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
     *				clip.y = 100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
     *				clip.on(Event.CLICK, this, onClick);//给 clip 添加点击事件函数侦听。
     *				Laya.stage.addChild(clip);//将此 clip 对象添加到显示列表。
     *			}
     *			private function onClick():void
     *			{
     *				trace("clip 的点击事件侦听处理函数。clip.total="+ clip.total);
     *				if (clip.isPlaying == true)
     *				{
     *					clip.stop();//停止动画。
     *				}else {
     *					clip.play();//播放动画。
     *				}
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var clip;
     * Laya.loader.load("resource/ui/clip_num.png",laya.utils.Handler.create(this,loadComplete));//加载资源
     * function loadComplete() {
     *     console.log("资源加载完成！");
     *     clip = new laya.ui.Clip("resource/ui/clip_num.png",10,1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
     *     clip.autoPlay = true;//设置 clip 动画自动播放。
     *     clip.interval = 100;//设置 clip 动画的播放时间间隔。
     *     clip.x =100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
     *     clip.y =100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
     *     clip.on(Event.CLICK,this,onClick);//给 clip 添加点击事件函数侦听。
     *     Laya.stage.addChild(clip);//将此 clip 对象添加到显示列表。
     * }
     * function onClick()
     * {
     *     console.log("clip 的点击事件侦听处理函数。");
     *     if(clip.isPlaying == true)
     *     {
     *         clip.stop();
     *     }else {
     *         clip.play();
     *     }
     * }
     * </listing>
     * <listing version="3.0">
     * import Clip = laya.ui.Clip;
     * import Handler = laya.utils.Handler;
     * class Clip_Example {
     *     private clip: Clip;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.onInit();
     *     }
     *     private onInit(): void {
     *         this.clip = new Clip("resource/ui/clip_num.png", 10, 1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
     *         this.clip.autoPlay = true;//设置 clip 动画自动播放。
     *         this.clip.interval = 100;//设置 clip 动画的播放时间间隔。
     *         this.clip.x = 100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
     *         this.clip.y = 100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
     *         this.clip.on(laya.events.Event.CLICK, this, this.onClick);//给 clip 添加点击事件函数侦听。
     *         Laya.stage.addChild(this.clip);//将此 clip 对象添加到显示列表。
     *     }
     *     private onClick(): void {
     *         console.log("clip 的点击事件侦听处理函数。clip.total=" + this.clip.total);
     *         if (this.clip.isPlaying == true) {
     *             this.clip.stop();//停止动画。
     *         } else {
     *             this.clip.play();//播放动画。
     *         }
     *     }
     * }
     *
     * </listing>
     */
    class Clip extends Component {
        protected _sources: Array<any>;
        protected _bitmap: AutoBitmap;
        protected _skin: string;
        protected _clipX: number;
        protected _clipY: number;
        protected _clipWidth: number;
        protected _clipHeight: number;
        protected _autoPlay: boolean;
        protected _interval: number;
        protected _complete: laya.utils.Handler;
        protected _isPlaying: boolean;
        protected _index: number;
        protected _clipChanged: boolean;
        protected _group: string;
        /**
         * 创建一个新的 <code>Clip</code> 示例。
         * @param url 资源类库名或者地址
         * @param clipX x方向分割个数
         * @param clipY y方向分割个数
         */
        constructor(url?: string, clipX?: number, clipY?: number);
        /**@inheritDoc */
        destroy(clearFromCache?: boolean): void;
        /**
         * 销毁对象并释放加载的皮肤资源。
         */
        dispose(): void;
        protected createChildren(): void;
        protected _onDisplay(e?: laya.events.Event): void;
        /**
         * @copy laya.ui.Image#skin
         */
        skin: string;
        /**X轴（横向）切片数量。*/
        clipX: number;
        /**Y轴(竖向)切片数量。*/
        clipY: number;
        /**
         * 横向分割时每个切片的宽度，与 <code>clipX</code> 同时设置时优先级高于 <code>clipX</code> 。
         */
        clipWidth: number;
        /**
         * 竖向分割时每个切片的高度，与 <code>clipY</code> 同时设置时优先级高于 <code>clipY</code> 。
         */
        clipHeight: number;
        protected changeClip(): void;
        protected loadComplete(url: string, img: laya.resource.Texture): void;
        /**
         * 源数据。
         */
        sources: Array<any>;
        /**
         * 资源分组。
         */
        group: string;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         */
        sizeGrid: string;
        /**
         * 当前帧索引。
         */
        index: number;
        /**
         * 切片动画的总帧数。
         */
        total: number;
        /**
         * 表示是否自动播放动画，若自动播放值为true,否则值为false;
         * <p>可控制切片动画的播放、停止。</p>
         */
        autoPlay: boolean;
        /**
         * 表示动画播放间隔时间(以毫秒为单位)。
         */
        interval: number;
        /**
         * 表示动画的当前播放状态。
         * 如果动画正在播放中，则为true，否则为flash。
         */
        isPlaying: boolean;
        /**
         * 播放动画。
         */
        play(): void;
        protected _loop(): void;
        /**
         * 停止动画。
         */
        stop(): void;
        /**@inheritDoc */
        dataSource: any;
        /**
         * <code>AutoBitmap</code> 位图实例。
         */
        bitmap: AutoBitmap;
        protected _setClipChanged(): void;
    }
}
declare module laya.ui {
    /**
     * <code>ColorPicker</code> 组件将显示包含多个颜色样本的列表，用户可以从中选择颜色。
     *
     * @example 以下示例代码，创建了一个 <code>ColorPicker</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.ColorPicker;
     *		import laya.utils.Handler;
     *		public class ColorPicker_Example
     *		{
     *			public function ColorPicker_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/color.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				trace("资源加载完成！");
     *				var colorPicket:ColorPicker = new ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
     *				colorPicket.skin = "resource/ui/color.png";//设置 colorPicket 的皮肤。
     *				colorPicket.x = 100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
     *				colorPicket.y = 100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
     *				colorPicket.changeHandler = new Handler(this, onChangeColor,[colorPicket]);//设置 colorPicket 的颜色改变回调函数。
     *				Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
     *			}
     *			private function onChangeColor(colorPicket:ColorPicker):void
     *			{
     *				trace("当前选择的颜色： " + colorPicket.selectedColor);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * Laya.loader.load("resource/ui/color.png",laya.utils.Handler.create(this,loadComplete));//加载资源
     * function loadComplete()
     * {
     *     console.log("资源加载完成！");
     *     var colorPicket = new laya.ui.ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
     *     colorPicket.skin = "resource/ui/color.png";//设置 colorPicket 的皮肤。
     *     colorPicket.x = 100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
     *     colorPicket.y = 100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
     *     colorPicket.changeHandler = laya.utils.Handler.create(this, onChangeColor,[colorPicket],false);//设置 colorPicket 的颜色改变回调函数。
     *     Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
     * }
     * function onChangeColor(colorPicket)
     * {
     *     console.log("当前选择的颜色： " + colorPicket.selectedColor);
     * }
     * </listing>
     * <listing version="3.0">
     * import ColorPicker = laya.ui.ColorPicker;
     * import Handler = laya.utils.Handler;
     * class ColorPicker_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ui/color.png", Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         console.log("资源加载完成！");
     *         var colorPicket: ColorPicker = new ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
     *         colorPicket.skin = "resource/ui/color.png";//设置 colorPicket 的皮肤。
     *         colorPicket.x = 100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
     *         colorPicket.y = 100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
     *         colorPicket.changeHandler = new Handler(this, this.onChangeColor, [colorPicket]);//设置 colorPicket 的颜色改变回调函数。
     *         Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
     *     }
     *     private onChangeColor(colorPicket: ColorPicker): void {
     *         console.log("当前选择的颜色： " + colorPicket.selectedColor);
     *     }
     * }
     * </listing>
     */
    class ColorPicker extends Component {
        /**
         * 当颜色发生改变时执行的函数处理器。
         * 默认返回参数color：颜色值字符串。
         */
        changeHandler: laya.utils.Handler;
        protected _gridSize: number;
        protected _bgColor: string;
        protected _borderColor: string;
        protected _inputColor: string;
        protected _inputBgColor: string;
        protected _colorPanel: Box;
        protected _colorTiles: laya.display.Sprite;
        protected _colorBlock: laya.display.Sprite;
        protected _colorInput: laya.display.Input;
        protected _colorButton: Button;
        protected _colors: Array<any>;
        protected _selectedColor: string;
        protected _panelChanged: boolean;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected initialize(): void;
        protected changePanel(): void;
        /**
         * 打开颜色样本列表面板。
         */
        open(): void;
        /**
         * 关闭颜色样本列表面板。
         */
        close(): void;
        protected getColorByMouse(): string;
        /**
         * 表示选择的颜色值。
         */
        selectedColor: string;
        /**
         * @copy laya.ui.Button#skin
         */
        skin: string;
        /**
         * 表示颜色样本列表面板的背景颜色值。
         */
        bgColor: string;
        /**
         * 表示颜色样本列表面板的边框颜色值。
         */
        borderColor: string;
        /**
         * 表示颜色样本列表面板选择或输入的颜色值。
         */
        inputColor: string;
        /**
         * 表示颜色输入框的背景颜色值。
         */
        inputBgColor: string;
        protected _setPanelChanged(): void;
    }
}
declare module laya.ui {
    /**
     * <code>ComboBox</code> 组件包含一个下拉列表，用户可以从该列表中选择单个值。
     *
     * @example 以下示例代码，创建了一个 <code>ComboBox</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.ComboBox;
     *		import laya.utils.Handler;
     *		public class ComboBox_Example
     *		{
     *			public function ComboBox_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/button.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				trace("资源加载完成！");
     *				var comboBox:ComboBox = new ComboBox("resource/ui/button.png", "item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
     *				comboBox.x = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *				comboBox.y = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *				comboBox.selectHandler = new Handler(this, onSelect);//设置 comboBox 选择项改变时执行的处理器。
     *				Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
     *			}
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选中的项对象索引： ",index);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高。
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
     * function loadComplete() {
     *     console.log("资源加载完成！");
     *     var comboBox = new laya.ui.ComboBox("resource/ui/button.png", "item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
     *     comboBox.x = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *     comboBox.y = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *     comboBox.selectHandler = new laya.utils.Handler(this, onSelect);//设置 comboBox 选择项改变时执行的处理器。
     *     Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
     * }
     * function onSelect(index)
     * {
     *     console.log("当前选中的项对象索引： ",index);
     * }
     * </listing>
     * <listing version="3.0">
     * import ComboBox = laya.ui.ComboBox;
     * import Handler = laya.utils.Handler;
     * class ComboBox_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ui/button.png", Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         console.log("资源加载完成！");
     *         var comboBox: ComboBox = new ComboBox("resource/ui/button.png", "item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
     *         comboBox.x = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *         comboBox.y = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *         comboBox.selectHandler = new Handler(this, this.onSelect);//设置 comboBox 选择项改变时执行的处理器。
     *         Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
     *     }
     *     private onSelect(index: number): void {
     *         console.log("当前选中的项对象索引： ", index);
     *     }
     * }
     *
     * </listing>
     */
    class ComboBox extends Component {
        protected _visibleNum: number;
        protected _button: Button;
        protected _list: List;
        protected _isOpen: boolean;
        protected _scrollBar: VScrollBar;
        protected _itemColors: Array<any>;
        protected _itemSize: number;
        protected _labels: Array<any>;
        protected _selectedIndex: number;
        protected _selectHandler: laya.utils.Handler;
        protected _itemHeight: number;
        protected _listHeight: number;
        protected _listChanged: boolean;
        protected _itemChanged: boolean;
        protected _scrollBarSkin: string;
        /**
         * 渲染项，用来显示下拉列表展示对象
         */
        itemRender: any;
        /**
         * 创建一个新的 <code>ComboBox</code> 组件实例。
         * @param skin 皮肤资源地址。
         * @param labels 下拉列表的标签集字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
         */
        constructor(skin?: string, labels?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        /**
         * @copy laya.ui.Button#skin
         */
        skin: string;
        protected measureWidth: number;
        protected measureHeight: number;
        protected changeList(): void;
        protected onlistItemMouse(e: laya.events.Event, index: number): void;
        protected changeOpen(): void;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * 标签集合字符串。
         */
        labels: string;
        protected changeItem(): void;
        /**
         * 表示选择的下拉列表项的索引。
         */
        selectedIndex: number;
        /**
         * 改变下拉列表的选择项时执行的处理器(默认返回参数index:int)。
         */
        selectHandler: laya.utils.Handler;
        /**
         * 表示选择的下拉列表项的的标签。
         */
        selectedLabel: string;
        /**
         * 获取或设置没有滚动条的下拉列表中可显示的最大行数。
         */
        visibleNum: number;
        /**
         * 下拉列表项颜色。
         * <p><b>格式：</b>"悬停或被选中时背景颜色,悬停或被选中时标签颜色,标签颜色,边框颜色,背景颜色"</p>
         */
        itemColors: string;
        /**
         * 下拉列表项标签的字体大小。
         */
        itemSize: number;
        /**
         * 表示下拉列表的打开状态。
         */
        isOpen: boolean;
        protected removeList(e: laya.events.Event): void;
        /**
         * 滚动条皮肤。
         */
        scrollBarSkin: string;
        /**
         * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         */
        sizeGrid: string;
        /**
         * 获取对 <code>ComboBox</code> 组件所包含的 <code>VScrollBar</code> 滚动条组件的引用。
         */
        scrollBar: VScrollBar;
        /**
         * 获取对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的引用。
         */
        button: Button;
        /**
         * 获取对 <code>ComboBox</code> 组件所包含的 <code>List</code> 列表组件的引用。
         */
        list: List;
        /**@inheritDoc */
        dataSource: any;
        /**
         * 获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的文本标签颜色。
         * <p><b>格式：</b>upColor,overColor,downColor,disableColor</p>
         */
        labelColors: string;
        /**
         * 获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的文本边距。
         * <p><b>格式：</b>上边距,右边距,下边距,左边距</p>
         */
        labelPadding: string;
        /**
         * 获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的标签字体大小。
         */
        labelSize: number;
        /**
         * 表示按钮文本标签是否为粗体字。
         * @see laya.display.Text#bold
         */
        labelBold: boolean;
        /**
         * 表示按钮文本标签的字体名称，以字符串形式表示。
         * @see laya.display.Text#font
         */
        labelFont: string;
        /**
         * 表示按钮的状态值。
         * @see laya.ui.Button#stateNum
         */
        stateNum: number;
    }
}
declare module laya.ui {
    /**
     * <code>Component</code> 是ui控件类的基类。
     * <p>生命周期：preinitialize > createChildren > initialize > 组件构造函数</p>
     */
    class Component extends laya.display.Sprite implements IComponent {
        protected _layout: LayoutStyle;
        protected _dataSource: any;
        protected _toolTip: any;
        protected _tag: any;
        protected _disabled: boolean;
        protected _gray: boolean;
        /**
         * <p>创建一个新的 <code>Component</code> 实例。</p>
         */
        constructor();
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected preinitialize(): void;
        protected createChildren(): void;
        protected initialize(): void;
        /**
         * <p>延迟运行指定的函数。</p>
         * <p>在控件被显示在屏幕之前调用，一般用于延迟计算数据。</p>
         * @param method 要执行的函数的名称。例如，functionName。
         * @param args 传递给 <code>method</code> 函数的可选参数列表。
         *
         * @see #runCallLater()
         */
        callLater(method: Function, args?: Array<any>): void;
        /**
         * <p>如果有需要延迟调用的函数（通过 <code>callLater</code> 函数设置），则立即执行延迟调用函数。</p>
         * @param method 要执行的函数名称。例如，functionName。
         * @see #callLater()
         */
        runCallLater(method: Function): void;
        /**
         * <p>表示显示对象的宽度，以像素为单位。</p>
         * <p><b>注：</b>当值为0时，宽度为自适应大小。</p>
         */
        width: number;
        /**
         * <p>对象的显示宽度（以像素为单位）。</p>
         */
        displayWidth: number;
        protected measureWidth: number;
        protected commitMeasure(): void;
        /**
         * <p>表示显示对象的高度，以像素为单位。</p>
         * <p><b>注：</b>当值为0时，高度为自适应大小。</p>
         * @return
         */
        height: number;
        /**
         * <p>对象的显示高度（以像素为单位）。</p>
         */
        displayHeight: number;
        protected measureHeight: number;
        /**@inheritDoc */
        scaleX: number;
        /**@inheritDoc */
        scaleY: number;
        protected changeSize(): void;
        /**
         * <p>数据赋值，通过对UI赋值来控制UI显示逻辑。</p>
         * <p>简单赋值会更改组件的默认属性，使用大括号可以指定组件的任意属性进行赋值。</p>
         * @example 以下示例中， <code>label1、checkbox1</code> 分别为示例的name属性值。
           <listing version="3.0">
           //默认属性赋值
           dataSource =
           //任意属性赋值
           dataSource =
           </listing>
         * @return
         */
        dataSource: any;
        /**
         * <p>从组件顶边到其内容区域顶边之间的垂直距离（以像素为单位）。</p>
         */
        top: number;
        /**
         * <p>从组件底边到其内容区域底边之间的垂直距离（以像素为单位）。</p>
         */
        bottom: number;
        /**
         * <p>从组件左边到其内容区域左边之间的水平距离（以像素为单位）。</p>
         */
        left: number;
        /**
         * <p>从组件右边到其内容区域右边之间的水平距离（以像素为单位）。</p>
         */
        right: number;
        /**
         * <p>在父容器中，此对象的水平方向中轴线与父容器的水平方向中心线的距离（以像素为单位）。</p>
         */
        centerX: number;
        /**
         * <p>在父容器中，此对象的垂直方向中轴线与父容器的垂直方向中心线的距离（以像素为单位）。</p>
         */
        centerY: number;
        /**X轴锚点，值为0-1*/
        anchorX: number;
        /**Y轴锚点，值为0-1*/
        anchorY: number;
        /**
         * <p>对象的标签。</p>
         * @internal 冗余字段，可以用来储存数据。
         */
        tag: any;
        protected onCompResize(): void;
        protected resetLayoutX(): void;
        protected resetLayoutY(): void;
        /**
         * <p>鼠标悬停提示。</p>
         * <p>可以赋值为文本 <code>String</code> 或函数 <code>Handler</code> ，用来实现自定义样式的鼠标提示和参数携带等。</p>
         * @example 以下例子展示了三种鼠标提示：
           <listing version="3.0">
           private var _testTips:TestTipsUI = new TestTipsUI();
           private function testTips():void {
           //简单鼠标提示
           btn2.toolTip = "这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
           //自定义的鼠标提示
           btn1.toolTip = showTips1;
           //带参数的自定义鼠标提示
           clip.toolTip = new Handler(this,showTips2, ["clip"]);
           }
           private function showTips1():void {
           _testTips.label.text = "这里是按钮[" + btn1.label + "]";
           tip.addChild(_testTips);
           }
           private function showTips2(name:String):void {
           _testTips.label.text = "这里是" + name;
           tip.addChild(_testTips);
           }
           </listing>
         */
        toolTip: any;
        /**
         * XML 数据。
         */
        comXml: any;
        /** 是否变灰。*/
        gray: boolean;
        /** 是否禁用页面，设置为true后，会变灰并且禁用鼠标。*/
        disabled: boolean;
    }
}
declare module laya.ui {
    /**
     * <code>Dialog</code> 组件是一个弹出对话框，实现对话框弹出，拖动，模式窗口功能。
     * 可以通过UIConfig设置弹出框背景透明度，模式窗口点击边缘是否关闭等
     * 通过设置zOrder属性，可以更改弹出的层次
     * 通过设置manager.popupEffect和manager.closeEffect可以设置弹出效果和关闭效果
     *
     * @example 以下示例代码，创建了一个 <code>Dialog</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Dialog;
     *		import laya.utils.Handler;
     *		public class Dialog_Example
     *		{
     *			private var dialog:Dialog_Instance;
     *			public function Dialog_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/btn_close.png", Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				dialog = new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
     *				dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
     *				dialog.show();//显示 dialog。
     *				dialog.closeHandler = new Handler(this, onClose);//设置 dialog 的关闭函数处理器。
     *			}
     *			private function onClose(name:String):void
     *			{
     *				if (name == Dialog.CLOSE)
     *				{
     *					trace("通过点击 name 为" + name +"的组件，关闭了dialog。");
     *				}
     *			}
     *		}
     *	}
     *	import laya.ui.Button;
     *	import laya.ui.Dialog;
     *	import laya.ui.Image;
     *	class Dialog_Instance extends Dialog
     *	{
     *		function Dialog_Instance():void
     *		{
     *			var bg:Image = new Image("resource/ui/bg.png");
     *			bg.sizeGrid = "40,10,5,10";
     *			bg.width = 150;
     *			bg.height = 250;
     *			addChild(bg);
     *			var image:Image = new Image("resource/ui/image.png");
     *			addChild(image);
     *			var button:Button = new Button("resource/ui/btn_close.png");
     *			button.name = Dialog.CLOSE;//设置button的name属性值。
     *			button.x = 0;
     *			button.y = 0;
     *			addChild(button);
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var dialog;
     * Laya.loader.load("resource/ui/btn_close.png", laya.utils.Handler.create(this, loadComplete));//加载资源
     * (function (_super) {//新建一个类Dialog_Instance继承自laya.ui.Dialog。
     *     function Dialog_Instance() {
     *         Dialog_Instance.__super.call(this);//初始化父类
     *         var bg = new laya.ui.Image("resource/ui/bg.png");//新建一个 Image 类的实例 bg 。
     *         bg.sizeGrid = "10,40,10,5";//设置 bg 的网格信息。
     *         bg.width = 150;//设置 bg 的宽度。
     *         bg.height = 250;//设置 bg 的高度。
     *         this.addChild(bg);//将 bg 添加到显示列表。
     *         var image = new laya.ui.Image("resource/ui/image.png");//新建一个 Image 类的实例 image 。
     *         this.addChild(image);//将 image 添加到显示列表。
     *         var button = new laya.ui.Button("resource/ui/btn_close.png");//新建一个 Button 类的实例 bg 。
     *         button.name = laya.ui.Dialog.CLOSE;//设置 button 的 name 属性值。
     *         button.x = 0;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
     *         button.y = 0;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
     *         this.addChild(button);//将 button 添加到显示列表。
     *     };
     *     Laya.class(Dialog_Instance,"mypackage.dialogExample.Dialog_Instance",_super);//注册类Dialog_Instance。
     * })(laya.ui.Dialog);
     * function loadComplete() {
     *     console.log("资源加载完成！");
     *     dialog = new mypackage.dialogExample.Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
     *     dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
     *     dialog.show();//显示 dialog。
     *     dialog.closeHandler = new laya.utils.Handler(this, onClose);//设置 dialog 的关闭函数处理器。
     * }
     * function onClose(name) {
     *     if (name == laya.ui.Dialog.CLOSE) {
     *         console.log("通过点击 name 为" + name + "的组件，关闭了dialog。");
     *     }
     * }
     * </listing>
     * <listing version="3.0">
     * import Dialog = laya.ui.Dialog;
     * import Handler = laya.utils.Handler;
     * class Dialog_Example {
     *     private dialog: Dialog_Instance;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ui/btn_close.png", Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         this.dialog = new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
     *         this.dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
     *         this.dialog.show();//显示 dialog。
     *         this.dialog.closeHandler = new Handler(this, this.onClose);//设置 dialog 的关闭函数处理器。
     *     }
     *     private onClose(name: string): void {
     *         if (name == Dialog.CLOSE) {
     *             console.log("通过点击 name 为" + name + "的组件，关闭了dialog。");
     *         }
     *     }
     * }
     * import Button = laya.ui.Button;
     * class Dialog_Instance extends Dialog {
     *     Dialog_Instance(): void {
     *         var bg: laya.ui.Image = new laya.ui.Image("resource/ui/bg.png");
     *         bg.sizeGrid = "40,10,5,10";
     *         bg.width = 150;
     *         bg.height = 250;
     *         this.addChild(bg);
     *         var image: laya.ui.Image = new laya.ui.Image("resource/ui/image.png");
     *         this.addChild(image);
     *         var button: Button = new Button("resource/ui/btn_close.png");
     *         button.name = Dialog.CLOSE;//设置button的name属性值。
     *         button.x = 0;
     *         button.y = 0;
     *         this.addChild(button);
     *     }
     * }
     * </listing>
     */
    class Dialog extends View {
        /**对话框内的某个按钮命名为close，点击此按钮则会关闭*/
        static CLOSE: string;
        /**对话框内的某个按钮命名为cancel，点击此按钮则会关闭*/
        static CANCEL: string;
        /**对话框内的某个按钮命名为sure，点击此按钮则会关闭*/
        static SURE: string;
        /**对话框内的某个按钮命名为no，点击此按钮则会关闭*/
        static NO: string;
        /**对话框内的某个按钮命名为ok，点击此按钮则会关闭*/
        static OK: string;
        /**对话框内的某个按钮命名为yes，点击此按钮则会关闭*/
        static YES: string;
        private static _manager;
        /**对话框管理容器，所有的对话框都在该容器内，并且受管理器管，可以自定义自己的管理器，来更改窗口管理的流程。
         * 任意对话框打开和关闭，都会触发管理类的open和close事件*/
        static manager: DialogManager;
        /**
         * 一个布尔值，指定对话框是否居中弹。
         * <p>如果值为true，则居中弹出，否则，则根据对象坐标显示，默认为true。</p>
         */
        popupCenter: boolean;
        /**
         * 对话框被关闭时会触发的回调函数处理器。
         * <p>回调函数参数为用户点击的按钮名字name:String。</p>
         */
        closeHandler: laya.utils.Handler;
        /**组名称*/
        group: string;
        /**是否是模式窗口*/
        isModal: boolean;
        protected _dragArea: laya.maths.Rectangle;
        protected initialize(): void;
        protected _dealDragArea(): void;
        protected _onClick(e: laya.events.Event): void;
        /**
         * 显示对话框（以非模式窗口方式显示）。
         * @param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
         */
        show(closeOther?: boolean): void;
        /**
         * 显示对话框（以模式窗口方式显示）。
         * @param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
         */
        popup(closeOther?: boolean): void;
        protected _open(modal: boolean, closeOther: boolean): void;
        /**打开完成后，调用此方法（如果有弹出动画，则在动画完成后执行）*/
        onOpened(): void;
        /**
         * 关闭对话框。
         * @param type 如果是点击默认关闭按钮触发，则传入关闭按钮的名字(name)，否则为null。
         */
        close(type?: string): void;
        /**关闭完成后，调用此方法（如果有关闭动画，则在动画完成后执行）
         * @param type 如果是点击默认关闭按钮触发，则传入关闭按钮的名字(name)，否则为null。
         */
        onClosed(type?: string): void;
        /**
         * 用来指定对话框的拖拽区域。默认值为"0,0,0,0"。
         * <p><b>格式：</b>构成一个矩形所需的 x,y,width,heith 值，用逗号连接为字符串。
         * 例如："0,0,100,200"。
         * </p>
         *
         * @see #includeExamplesSummary 请参考示例
         * @return
         */
        dragArea: string;
        /**
         * 弹出框的显示状态；如果弹框处于显示中，则为true，否则为false;
         */
        isPopup: boolean;
        zOrder: number;
        /**
         * 设置锁定界面，在界面未准备好前显示锁定界面，准备完毕后则移除锁定层，如果为空则什么都不显示
         * @param	view 锁定界面内容
         */
        static setLockView(view: Component): void;
        /**
         * 锁定所有层，显示加载条信息，防止下面内容被点击
         */
        static lock(value: boolean): void;
        /**关闭所有对话框。*/
        static closeAll(): void;
        /**
         * 根据组获取对话框集合
         * @param	group 组名称
         * @return	对话框数组
         */
        static getDialogsByGroup(group: string): Array<any>;
        /**
         * 根据组关闭所有弹出框
         * @param	group 需要关闭的组名称
         */
        static closeByGround(group: string): Array<any>;
    }
}
declare module laya.ui {
    /**
     * <code>DialogManager</code> 对话框管理容器，所有的对话框都在该容器内，并且受管理器管理。
     * 任意对话框打开和关闭，都会出发管理类的open和close事件
     * 可以通过UIConfig设置弹出框背景透明度，模式窗口点击边缘是否关闭，点击窗口是否切换层次等
     * 通过设置对话框的zOrder属性，可以更改弹出的层次
     */
    class DialogManager extends laya.display.Sprite {
        /**遮罩层*/
        maskLayer: laya.display.Sprite;
        /**锁屏层*/
        lockLayer: laya.display.Sprite;
        /**弹出对话框效果，可以设置一个效果代替默认的弹出效果，如果不想有任何效果，可以赋值为null*/
        popupEffect: Function;
        /**关闭对话框效果，可以设置一个效果代替默认的关闭效果，如果不想有任何效果，可以赋值为null*/
        closeEffect: Function;
        /**
         * 创建一个新的 <code>DialogManager</code> 类实例。
         */
        constructor();
        /**设置锁定界面，如果为空则什么都不显示*/
        setLockView(value: laya.ui.Component): void;
        /**
         * 显示对话框(非模式窗口类型)。
         * @param dialog 需要显示的对象框 <code>Dialog</code> 实例。
         * @param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
         */
        open(dialog: laya.ui.Dialog, closeOther?: boolean): void;
        /**
         * 执行打开对话框。
         * @param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
         * @param type	关闭的类型，默认为空
         */
        doOpen(dialog: laya.ui.Dialog): void;
        /**
         * 锁定所有层，显示加载条信息，防止双击
         */
        lock(value: boolean): void;
        /**
         * 关闭对话框。
         * @param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
         * @param type	关闭的类型，默认为空
         */
        close(dialog: laya.ui.Dialog, type?: string): void;
        /**
         * 执行关闭对话框。
         * @param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
         * @param type	关闭的类型，默认为空
         */
        doClose(dialog: laya.ui.Dialog, type?: string): void;
        /**
         * 关闭所有的对话框。
         */
        closeAll(): void;
        /**
         * 根据组获取所有对话框
         * @param	group 组名称
         * @return	对话框数组
         */
        getDialogsByGroup(group: string): Array<any>;
        /**
         * 根据组关闭所有弹出框
         * @param	group 需要关闭的组名称
         */
        closeByGround(group: string): Array<any>;
        _checkMask(): void;
    }
}
declare module laya.ui {
    /**
     * 动效类
     * @author ww
     */
    class EffectAnimation extends laya.display.FrameAnimation {
        /**
         * 动效开始事件
         */
        static EffectAnimationBegin: string;
        constructor();
        /**
         *  控制对象
         * @return
         *
         */
        /**
         * 控制对象
         * @param v
         *
         */
        target: any;
        /**
         * 设置开始播放的事件
         * @param event
         *
         */
        playEvent: string;
        /**
         * 设置提供数据的类
         * @param classStr 类路径
         *
         */
        effectClass: string;
        protected _displayToIndex(value: number): void;
        protected _displayNodeToFrame(node: any, frame: number, targetDic?: any): void;
        protected _calculateNodeKeyFrames(node: any): void;
    }
}
declare module laya.ui {
    /**
     *
     * 简单易用的位图字体类
     *
     */
    class FontClip extends laya.ui.Clip {
        protected _valueArr: Array<any>;
        protected _direction: string;
        protected _spaceX: number;
        protected _spaceY: number;
        /**
         * @param url 位图字体图片url
         * @param clipX 位图字体横向切片数量
         * @param clipY 位图字体竖向切片数量
         */
        constructor(url?: string, clipX?: number, clipY?: number);
        protected createChildren(): void;
        /**
         * 设置位图字体内容
         * @param value
         */
        sheet: string;
        /**
         * 设置问题字体的显示内容
         * @param value
         */
        value: string;
        /**资源加载完成*/
        sources: Array<any>;
        /**
         * 布局方向。
         * <p>默认值为"horizontal"。</p>
         * <p><b>取值：</b>
         * <li>"horizontal"：表示水平布局。</li>
         * <li>"vertical"：表示垂直布局。</li>
         * </p>
         */
        direction: string;
        /**X方向间隙*/
        spaceX: number;
        /**Y方向间隙*/
        spaceY: number;
        protected changeValue(): void;
        dispose(): void;
    }
}
declare module laya.ui {
    /**
     * 关键帧动画播放类
     *
     */
    class FrameClip extends laya.display.FrameAnimation {
        /**
         * 创建一个 <code>FrameClip</code> 实例。
         */
        constructor();
    }
}
declare module laya.ui {
    /**
     * <code>VBox</code> 是一个垂直布局容器类。
     */
    class HBox extends LayoutBox {
        /**
         * 无对齐。
         */
        static NONE: string;
        /**
         * 居顶部对齐。
         */
        static TOP: string;
        /**
         * 居中对齐。
         */
        static MIDDLE: string;
        /**
         * 居底部对齐。
         */
        static BOTTOM: string;
        protected sortItem(items: Array<any>): void;
        protected changeItems(): void;
    }
}
declare module laya.ui {
    /**
     * 使用 <code>HScrollBar</code> （水平 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
     * @example 以下示例代码，创建了一个 <code>HScrollBar</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.HScrollBar;
     *		import laya.utils.Handler;
     *		public class HScrollBar_Example
     *		{
     *			private var hScrollBar:HScrollBar;
     *			public function HScrollBar_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/hscroll.png", "resource/ui/hscroll$bar.png", "resource/ui/hscroll$down.png", "resource/ui/hscroll$up.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				hScrollBar = new HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
     *				hScrollBar.skin = "resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
     *				hScrollBar.x = 100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
     *				hScrollBar.y = 100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
     *				hScrollBar.changeHandler = new Handler(this, onChange);//设置 hScrollBar 的滚动变化处理器。
     *				Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
     *			}
     *			private function onChange(value:Number):void
     *			{
     *				trace("滚动条的位置： value=" + value);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var hScrollBar;
     * var res  = ["resource/ui/hscroll.png", "resource/ui/hscroll$bar.png", "resource/ui/hscroll$down.png", "resource/ui/hscroll$up.png"];
     * Laya.loader.load(res,laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     * function onLoadComplete() {
     *     console.log("资源加载完成！");
     *     hScrollBar = new laya.ui.HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
     *     hScrollBar.skin = "resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
     *     hScrollBar.x = 100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
     *     hScrollBar.y = 100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
     *     hScrollBar.changeHandler = new laya.utils.Handler(this, onChange);//设置 hScrollBar 的滚动变化处理器。
     *     Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
     * }
     * function onChange(value)
     * {
     *     console.log("滚动条的位置： value=" + value);
     * }
     * </listing>
     * <listing version="3.0">
     * import HScrollBar = laya.ui.HScrollBar;
     * import Handler = laya.utils.Handler;
     * class HScrollBar_Example {
     *     private hScrollBar: HScrollBar;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/hscroll.png", "resource/ui/hscroll$bar.png", "resource/ui/hscroll$down.png", "resource/ui/hscroll$up.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         this.hScrollBar = new HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
     *         this.hScrollBar.skin = "resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
     *         this.hScrollBar.x = 100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
     *         this.hScrollBar.y = 100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
     *         this.hScrollBar.changeHandler = new Handler(this, this.onChange);//设置 hScrollBar 的滚动变化处理器。
     *         Laya.stage.addChild(this.hScrollBar);//将此 hScrollBar 对象添加到显示列表。
     *     }
     *     private onChange(value: number): void {
     *         console.log("滚动条的位置： value=" + value);
     *     }
     * }
     * </listing>
     */
    class HScrollBar extends ScrollBar {
        protected initialize(): void;
    }
}
declare module laya.ui {
    /**
     * 使用 <code>HSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
     * <p> <code>HSlider</code> 控件采用水平方向。滑块轨道从左向右扩展，而标签位于轨道的顶部或底部。</p>
     *
     * @example 以下示例代码，创建了一个 <code>HSlider</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.HSlider;
     *		import laya.utils.Handler;
     *		public class HSlider_Example
     *		{
     *			private var hSlider:HSlider;
     *			public function HSlider_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/hslider.png", "resource/ui/hslider$bar.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				hSlider = new HSlider();//创建一个 HSlider 类的实例对象 hSlider 。
     *				hSlider.skin = "resource/ui/hslider.png";//设置 hSlider 的皮肤。
     *				hSlider.min = 0;//设置 hSlider 最低位置值。
     *				hSlider.max = 10;//设置 hSlider 最高位置值。
     *				hSlider.value = 2;//设置 hSlider 当前位置值。
     *				hSlider.tick = 1;//设置 hSlider 刻度值。
     *				hSlider.x = 100;//设置 hSlider 对象的属性 x 的值，用于控制 hSlider 对象的显示位置。
     *				hSlider.y = 100;//设置 hSlider 对象的属性 y 的值，用于控制 hSlider 对象的显示位置。
     *				hSlider.changeHandler = new Handler(this, onChange);//设置 hSlider 位置变化处理器。
     *				Laya.stage.addChild(hSlider);//把 hSlider 添加到显示列表。
     *			}
     *			private function onChange(value:Number):void
     *			{
     *				trace("滑块的位置： value=" + value);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800, "canvas");//设置游戏画布宽高、渲染模式
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var hSlider;
     * var res = ["resource/ui/hslider.png", "resource/ui/hslider$bar.png"];
     * Laya.loader.load(res, laya.utils.Handler.create(this, onLoadComplete));
     * function onLoadComplete() {
     *     console.log("资源加载完成！");
     *     hSlider = new laya.ui.HSlider();//创建一个 HSlider 类的实例对象 hSlider 。
     *     hSlider.skin = "resource/ui/hslider.png";//设置 hSlider 的皮肤。
     *     hSlider.min = 0;//设置 hSlider 最低位置值。
     *     hSlider.max = 10;//设置 hSlider 最高位置值。
     *     hSlider.value = 2;//设置 hSlider 当前位置值。
     *     hSlider.tick = 1;//设置 hSlider 刻度值。
     *     hSlider.x = 100;//设置 hSlider 对象的属性 x 的值，用于控制 hSlider 对象的显示位置。
     *     hSlider.y = 100;//设置 hSlider 对象的属性 y 的值，用于控制 hSlider 对象的显示位置。
     *     hSlider.changeHandler = new laya.utils.Handler(this, onChange);//设置 hSlider 位置变化处理器。
     *     Laya.stage.addChild(hSlider);//把 hSlider 添加到显示列表。
     * }
     * function onChange(value)
     * {
     *     console.log("滑块的位置： value=" + value);
     * }
     * </listing>
     * <listing version="3.0">
     * import Handler = laya.utils.Handler;
     * import HSlider = laya.ui.HSlider;
     * class HSlider_Example {
     *     private hSlider: HSlider;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/hslider.png", "resource/ui/hslider$bar.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         this.hSlider = new HSlider();//创建一个 HSlider 类的实例对象 hSlider 。
     *         this.hSlider.skin = "resource/ui/hslider.png";//设置 hSlider 的皮肤。
     *         this.hSlider.min = 0;//设置 hSlider 最低位置值。
     *         this.hSlider.max = 10;//设置 hSlider 最高位置值。
     *         this.hSlider.value = 2;//设置 hSlider 当前位置值。
     *         this.hSlider.tick = 1;//设置 hSlider 刻度值。
     *         this.hSlider.x = 100;//设置 hSlider 对象的属性 x 的值，用于控制 hSlider 对象的显示位置。
     *         this.hSlider.y = 100;//设置 hSlider 对象的属性 y 的值，用于控制 hSlider 对象的显示位置。
     *         this.hSlider.changeHandler = new Handler(this, this.onChange);//设置 hSlider 位置变化处理器。
     *         Laya.stage.addChild(this.hSlider);//把 hSlider 添加到显示列表。
     *     }
     *     private onChange(value: number): void {
     *         console.log("滑块的位置： value=" + value);
     *     }
     * }
     * </listing>
     *
     * @see laya.ui.Slider
     */
    class HSlider extends Slider {
        /**
         * 创建一个 <code>HSlider</code> 类实例。
         * @param skin 皮肤。
         */
        constructor(skin?: string);
    }
}
declare module laya.ui {
    /**容器接口，实现了编辑器容器类型。*/
    interface IBox extends IComponent {
    }
}
declare module laya.ui {
    /**组件接口，实现了编辑器组件类型。*/
    interface IComponent {
    }
}
declare module laya.ui {
    /**
     * Item接口。
     */
    interface IItem {
    }
}
declare module laya.ui {
    /**
     * <code>Image</code> 类是用于表示位图图像或绘制图形的显示对象。
     * Image和Clip组件是唯一支持异步加载的两个组件，比如img.skin = "abc/xxx.png"，其他UI组件均不支持异步加载。
     *
     * @example 以下示例代码，创建了一个新的 <code>Image</code> 实例，设置了它的皮肤、位置信息，并添加到舞台上。
     * <listing version="3.0">
     *	package
     *	 {
     *		import laya.ui.Image;
     *		public class Image_Example
     *		{
     *			public function Image_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				onInit();
     *			}
     *			private function onInit():void
     *	 		{
     *				var bg:Image = new Image("resource/ui/bg.png");//创建一个 Image 类的实例对象 bg ,并传入它的皮肤。
     *				bg.x = 100;//设置 bg 对象的属性 x 的值，用于控制 bg 对象的显示位置。
     *				bg.y = 100;//设置 bg 对象的属性 y 的值，用于控制 bg 对象的显示位置。
     *				bg.sizeGrid = "40,10,5,10";//设置 bg 对象的网格信息。
     *				bg.width = 150;//设置 bg 对象的宽度。
     *				bg.height = 250;//设置 bg 对象的高度。
     *				Laya.stage.addChild(bg);//将此 bg 对象添加到显示列表。
     *				var image:Image = new Image("resource/ui/image.png");//创建一个 Image 类的实例对象 image ,并传入它的皮肤。
     *				image.x = 100;//设置 image 对象的属性 x 的值，用于控制 image 对象的显示位置。
     *				image.y = 100;//设置 image 对象的属性 y 的值，用于控制 image 对象的显示位置。
     *				Laya.stage.addChild(image);//将此 image 对象添加到显示列表。
     *			}
     *		}
     *	 }
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * onInit();
     * function onInit() {
     *     var bg = new laya.ui.Image("resource/ui/bg.png");//创建一个 Image 类的实例对象 bg ,并传入它的皮肤。
     *     bg.x = 100;//设置 bg 对象的属性 x 的值，用于控制 bg 对象的显示位置。
     *     bg.y = 100;//设置 bg 对象的属性 y 的值，用于控制 bg 对象的显示位置。
     *     bg.sizeGrid = "40,10,5,10";//设置 bg 对象的网格信息。
     *     bg.width = 150;//设置 bg 对象的宽度。
     *     bg.height = 250;//设置 bg 对象的高度。
     *     Laya.stage.addChild(bg);//将此 bg 对象添加到显示列表。
     *     var image = new laya.ui.Image("resource/ui/image.png");//创建一个 Image 类的实例对象 image ,并传入它的皮肤。
     *     image.x = 100;//设置 image 对象的属性 x 的值，用于控制 image 对象的显示位置。
     *     image.y = 100;//设置 image 对象的属性 y 的值，用于控制 image 对象的显示位置。
     *     Laya.stage.addChild(image);//将此 image 对象添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * class Image_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.onInit();
     *     }
     *     private onInit(): void {
     *         var bg: laya.ui.Image = new laya.ui.Image("resource/ui/bg.png");//创建一个 Image 类的实例对象 bg ,并传入它的皮肤。
     *         bg.x = 100;//设置 bg 对象的属性 x 的值，用于控制 bg 对象的显示位置。
     *         bg.y = 100;//设置 bg 对象的属性 y 的值，用于控制 bg 对象的显示位置。
     *         bg.sizeGrid = "40,10,5,10";//设置 bg 对象的网格信息。
     *         bg.width = 150;//设置 bg 对象的宽度。
     *         bg.height = 250;//设置 bg 对象的高度。
     *         Laya.stage.addChild(bg);//将此 bg 对象添加到显示列表。
     *         var image: laya.ui.Image = new laya.ui.Image("resource/ui/image.png");//创建一个 Image 类的实例对象 image ,并传入它的皮肤。
     *         image.x = 100;//设置 image 对象的属性 x 的值，用于控制 image 对象的显示位置。
     *         image.y = 100;//设置 image 对象的属性 y 的值，用于控制 image 对象的显示位置。
     *         Laya.stage.addChild(image);//将此 image 对象添加到显示列表。
     *     }
     * }
     * </listing>
     * @see laya.ui.AutoBitmap
     */
    class Image extends laya.ui.Component {
        _bitmap: laya.ui.AutoBitmap;
        protected _skin: string;
        protected _group: string;
        /**
         * 创建一个 <code>Image</code> 实例。
         * @param skin 皮肤资源地址。
         */
        constructor(skin?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**
         * 销毁对象并释放加载的皮肤资源。
         */
        dispose(): void;
        protected createChildren(): void;
        /**
         * <p>对象的皮肤地址，以字符串表示。</p>
         * <p>如果资源未加载，则先加载资源，加载完成后应用于此对象。</p>
         * <b>注意：</b>资源加载完成后，会自动缓存至资源库中。
         */
        skin: string;
        /**
         * @copy laya.ui.AutoBitmap#source
         */
        source: laya.resource.Texture;
        /**
         * 资源分组。
         */
        group: string;
        protected setSource(url: string, img?: any): void;
        protected measureWidth: number;
        protected measureHeight: number;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"。</li></ul></p>
         * @see laya.ui.AutoBitmap#sizeGrid
         */
        sizeGrid: string;
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**
     * <code>IRender</code> 接口，实现设置项的渲染类型。
     */
    interface IRender {
    }
}
declare module laya.ui {
    /**
     * <code>ISelect</code> 接口，实现对象的 <code>selected</code> 属性和 <code>clickHandler</code> 选择回调函数处理器。
     */
    interface ISelect {
    }
}
declare module laya.ui {
    /**
     * <p> <code>Label</code> 类用于创建显示对象以显示文本。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Label</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Label;
     *		public class Label_Example
     *		{
     *			public function Label_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				onInit();
     *			}
     *			private function onInit():void
     *			{
     *				var label:Label = new Label();//创建一个 Label 类的实例对象 label 。
     *				label.font = "Arial";//设置 label 的字体。
     *				label.bold = true;//设置 label 显示为粗体。
     *				label.leading = 4;//设置 label 的行间距。
     *				label.wordWrap = true;//设置 label 自动换行。
     *				label.padding = "10,10,10,10";//设置 label 的边距。
     *				label.color = "#ff00ff";//设置 label 的颜色。
     *				label.text = "Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
     *				label.x = 100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
     *				label.y = 100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
     *				label.width = 300;//设置 label 的宽度。
     *				label.height = 200;//设置 label 的高度。
     *				Laya.stage.addChild(label);//将 label 添加到显示列表。
     *				var passwordLabel:Label = new Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
     *				passwordLabel.asPassword = true;//设置 passwordLabel 的显示反式为密码显示。
     *				passwordLabel.x = 100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
     *				passwordLabel.y = 350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
     *				passwordLabel.width = 300;//设置 passwordLabel 的宽度。
     *				passwordLabel.color = "#000000";//设置 passwordLabel 的文本颜色。
     *				passwordLabel.bgColor = "#ccffff";//设置 passwordLabel 的背景颜色。
     *				passwordLabel.fontSize = 20;//设置 passwordLabel 的文本字体大小。
     *				Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * onInit();
     * function onInit(){
     *     var label = new laya.ui.Label();//创建一个 Label 类的实例对象 label 。
     *     label.font = "Arial";//设置 label 的字体。
     *     label.bold = true;//设置 label 显示为粗体。
     *     label.leading = 4;//设置 label 的行间距。
     *     label.wordWrap = true;//设置 label 自动换行。
     *     label.padding = "10,10,10,10";//设置 label 的边距。
     *     label.color = "#ff00ff";//设置 label 的颜色。
     *     label.text = "Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
     *     label.x = 100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
     *     label.y = 100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
     *     label.width = 300;//设置 label 的宽度。
     *     label.height = 200;//设置 label 的高度。
     *     Laya.stage.addChild(label);//将 label 添加到显示列表。
     *     var passwordLabel = new laya.ui.Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
     *     passwordLabel.asPassword = true;//设置 passwordLabel 的显示反式为密码显示。
     *     passwordLabel.x = 100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
     *     passwordLabel.y = 350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
     *     passwordLabel.width = 300;//设置 passwordLabel 的宽度。
     *     passwordLabel.color = "#000000";//设置 passwordLabel 的文本颜色。
     *     passwordLabel.bgColor = "#ccffff";//设置 passwordLabel 的背景颜色。
     *     passwordLabel.fontSize = 20;//设置 passwordLabel 的文本字体大小。
     *     Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * import Label = laya.ui.Label;
     * class Label_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.onInit();
     *     }
     *     private onInit(): void {
     *         var label: Label = new Label();//创建一个 Label 类的实例对象 label 。
     *         label.font = "Arial";//设置 label 的字体。
     *         label.bold = true;//设置 label 显示为粗体。
     *         label.leading = 4;//设置 label 的行间距。
     *         label.wordWrap = true;//设置 label 自动换行。
     *         label.padding = "10,10,10,10";//设置 label 的边距。
     *         label.color = "#ff00ff";//设置 label 的颜色。
     *         label.text = "Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
     *         label.x = 100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
     *         label.y = 100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
     *         label.width = 300;//设置 label 的宽度。
     *         label.height = 200;//设置 label 的高度。
     *         Laya.stage.addChild(label);//将 label 添加到显示列表。
     *         var passwordLabel: Label = new Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
     *         passwordLabel.asPassword = true;//设置 passwordLabel 的显示反式为密码显示。
     *         passwordLabel.x = 100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
     *         passwordLabel.y = 350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
     *         passwordLabel.width = 300;//设置 passwordLabel 的宽度。
     *         passwordLabel.color = "#000000";//设置 passwordLabel 的文本颜色。
     *         passwordLabel.bgColor = "#ccffff";//设置 passwordLabel 的背景颜色。
     *         passwordLabel.fontSize = 20;//设置 passwordLabel 的文本字体大小。
     *         Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
     *     }
     * }
     * </listing>
     * @see laya.display.Text
     */
    class Label extends laya.ui.Component {
        private static _textReg;
        protected _tf: laya.display.Text;
        /**
         * 创建一个新的 <code>Label</code> 实例。
         * @param text 文本内容字符串。
         */
        constructor(text?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        /**
         * 当前文本内容字符串。
         * @see laya.display.Text.text
         */
        text: string;
        /**@copy laya.display.Text#changeText()
         **/
        changeText(text: string): void;
        /**
         * @copy laya.display.Text#wordWrap
         */
        /**
         * @copy laya.display.Text#wordWrap
         */
        wordWrap: boolean;
        /**
         * @copy laya.display.Text#color
         */
        color: string;
        /**
         * @copy laya.display.Text#font
         */
        font: string;
        /**
         * @copy laya.display.Text#align
         */
        align: string;
        /**
         * @copy laya.display.Text#valign
         */
        valign: string;
        /**
         * @copy laya.display.Text#bold
         */
        bold: boolean;
        /**
         * @copy laya.display.Text#italic
         */
        italic: boolean;
        /**
         * @copy laya.display.Text#leading
         */
        leading: number;
        /**
         * @copy laya.display.Text#fontSize
         */
        fontSize: number;
        /**
         * <p>边距信息</p>
         * <p>"上边距，右边距，下边距 , 左边距（边距以像素为单位）"</p>
         * @see laya.display.Text.padding
         */
        padding: string;
        /**
         * @copy laya.display.Text#bgColor
         */
        bgColor: string;
        /**
         * @copy laya.display.Text#borderColor
         */
        borderColor: string;
        /**
         * @copy laya.display.Text#stroke
         */
        stroke: number;
        /**
         * @copy laya.display.Text#strokeColor
         */
        strokeColor: string;
        /**
         * 文本控件实体 <code>Text</code> 实例。
         */
        textField: laya.display.Text;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * @inheritDoc
         */
        /**
         * @inheritDoc
         */
        width: number;
        /**
         * @inheritDoc
         */
        /**
         * @inheritDoc
         */
        height: number;
        /**@inheritDoc */
        dataSource: any;
        /**
         * @copy laya.display.Text#overflow
         */
        /**
         * @copy laya.display.Text#overflow
         */
        overflow: string;
        /**
         * @copy laya.display.Text#underline
         */
        /**
         * @copy laya.display.Text#underline
         */
        underline: boolean;
        /**
         * @copy laya.display.Text#underlineColor
         */
        /**
         * @copy laya.display.Text#underlineColor
         */
        underlineColor: string;
    }
}
declare module laya.ui {
    /**
     * <code>LayoutBox</code> 是一个布局容器类。
     */
    class LayoutBox extends Box {
        protected _space: number;
        protected _align: string;
        protected _itemChanged: boolean;
        /** @inheritDoc	*/
        addChild(child: laya.display.Node): laya.display.Node;
        /** @inheritDoc	*/
        addChildAt(child: laya.display.Node, index: number): laya.display.Node;
        /** @inheritDoc	*/
        removeChild(child: laya.display.Node): laya.display.Node;
        /** @inheritDoc	*/
        removeChildAt(index: number): laya.display.Node;
        /** 刷新。*/
        refresh(): void;
        protected changeItems(): void;
        /** 子对象的间隔。*/
        space: number;
        /** 子对象对齐方式。*/
        align: string;
        protected sortItem(items: Array<any>): void;
        protected _setItemChanged(): void;
    }
}
declare module laya.ui {
    /**
     * <code>LayoutStyle</code> 是一个布局样式类。
     */
    class LayoutStyle {
        /**一个已初始化的 <code>LayoutStyle</code> 实例。*/
        static EMPTY: LayoutStyle;
        /**表示距顶边的距离（以像素为单位）。*/
        top: number;
        /**表示距底边的距离（以像素为单位）。*/
        bottom: number;
        /**表示距左边的距离（以像素为单位）。*/
        left: number;
        /**表示距右边的距离（以像素为单位）。*/
        right: number;
        /**表示距水平方向中心轴的距离（以像素为单位）。*/
        centerX: number;
        /**表示距垂直方向中心轴的距离（以像素为单位）。*/
        centerY: number;
        /**X锚点，值为0-1。*/
        anchorX: number;
        /**Y锚点，值为0-1。*/
        anchorY: number;
        /**一个布尔值，表示是否有效。*/
        enable: boolean;
    }
}
declare module laya.ui {
    /**
     * <code>List</code> 控件可显示项目列表。默认为垂直方向列表。可通过UI编辑器自定义列表。
     *
     * @example 以下示例代码，创建了一个 <code>List</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.List;
     *		import laya.utils.Handler;
     *		public class List_Example
     *		{
     *			public function List_Example()
     *			{
     *				Laya.init(640, 800, "false");//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, onLoadComplete));
     *			}
     *			private function onLoadComplete():void
     *			{
     *				var arr:Array = [];//创建一个数组，用于存贮列表的数据信息。
     *				for (var i:int = 0; i &lt; 20; i++)
     *				{
     *					arr.push({label: "item" + i});
     *				}
     *				var list:List = new List();//创建一个 List 类的实例对象 list 。
     *				list.itemRender = Item;//设置 list 的单元格渲染器。
     *				list.repeatX = 1;//设置 list 的水平方向单元格数量。
     *				list.repeatY = 10;//设置 list 的垂直方向单元格数量。
     *				list.vScrollBarSkin = "resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
     *				list.array = arr;//设置 list 的列表数据源。
     *				list.pos(100, 100);//设置 list 的位置。
     *				list.selectEnable = true;//设置 list 可选。
     *				list.selectHandler = new Handler(this, onSelect);//设置 list 改变选择项执行的处理器。
     *				Laya.stage.addChild(list);//将 list 添加到显示列表。
     *			}
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选择的项目索引： index= ", index);
     *			}
     *		}
     *	}
     *	import laya.ui.Box;
     *	import laya.ui.Label;
     *	class Item extends Box
     *	{
     *		public function Item()
     *		{
     *			graphics.drawRect(0, 0, 100, 20,null, "#ff0000");
     *			var label:Label = new Label();
     *			label.text = "100000";
     *			label.name = "label";//设置 label 的name属性值。
     *			label.size(100, 20);
     *			addChild(label);
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * (function (_super){
     *     function Item(){
     *         Item.__super.call(this);//初始化父类
     *         this.graphics.drawRect(0, 0, 100, 20, "#ff0000");
     *         var label = new laya.ui.Label();//创建一个 Label 类的实例对象 label 。
     *         label.text = "100000";//设置 label 的文本内容。
     *         label.name = "label";//设置 label 的name属性值。
     *         label.size(100, 20);//设置 label 的宽度、高度。
     *         this.addChild(label);//将 label 添加到显示列表。
     *     };
     *     Laya.class(Item,"mypackage.listExample.Item",_super);//注册类 Item 。
     * })(laya.ui.Box);
    
     * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * var res = ["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"];
     * Laya.loader.load(res, new laya.utils.Handler(this, onLoadComplete));//加载资源。
    
     * function onLoadComplete() {
     *     var arr = [];//创建一个数组，用于存贮列表的数据信息。
     *     for (var i = 0; i &lt; 20; i++) {
     *         arr.push({label: "item" + i});
     *     }
    
     *     var list = new laya.ui.List();//创建一个 List 类的实例对象 list 。
     *     list.itemRender = mypackage.listExample.Item;//设置 list 的单元格渲染器。
     *     list.repeatX = 1;//设置 list 的水平方向单元格数量。
     *     list.repeatY = 10;//设置 list 的垂直方向单元格数量。
     *     list.vScrollBarSkin = "resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
     *     list.array = arr;//设置 list 的列表数据源。
     *     list.pos(100, 100);//设置 list 的位置。
     *     list.selectEnable = true;//设置 list 可选。
     *     list.selectHandler = new laya.utils.Handler(this, onSelect);//设置 list 改变选择项执行的处理器。
     *     Laya.stage.addChild(list);//将 list 添加到显示列表。
     * }
    
     * function onSelect(index)
     * {
     *     console.log("当前选择的项目索引： index= ", index);
     * }
     *
     * </listing>
     * <listing version="3.0">
     * import List = laya.ui.List;
     * import Handler = laya.utils.Handler;
     * public class List_Example {
     *     public List_Example() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, this.onLoadComplete));
     *     }
     *     private onLoadComplete(): void {
     *         var arr= [];//创建一个数组，用于存贮列表的数据信息。
     *         for (var i: number = 0; i &lt; 20; i++)
     *         {
     *             arr.push({ label: "item" + i });
     *         }
     *         var list: List = new List();//创建一个 List 类的实例对象 list 。
     *         list.itemRender = Item;//设置 list 的单元格渲染器。
     *         list.repeatX = 1;//设置 list 的水平方向单元格数量。
     *         list.repeatY = 10;//设置 list 的垂直方向单元格数量。
     *         list.vScrollBarSkin = "resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
     *         list.array = arr;//设置 list 的列表数据源。
     *         list.pos(100, 100);//设置 list 的位置。
     *         list.selectEnable = true;//设置 list 可选。
     *         list.selectHandler = new Handler(this, this.onSelect);//设置 list 改变选择项执行的处理器。
     *         Laya.stage.addChild(list);//将 list 添加到显示列表。
     *     }
     *     private onSelect(index: number): void {
     *         console.log("当前选择的项目索引： index= ", index);
     *     }
     * }
     * import Box = laya.ui.Box;
     * import Label = laya.ui.Label;
     * class Item extends Box {
     *     constructor() {
     *         this.graphics.drawRect(0, 0, 100, 20, null, "#ff0000");
     *         var label: Label = new Label();
     *         label.text = "100000";
     *         label.name = "label";//设置 label 的name属性值。
     *         label.size(100, 20);
     *         this.addChild(label);
     *     }
     * }
     * </listing>
     */
    class List extends Box implements IRender, IItem {
        /**改变 <code>List</code> 的选择项时执行的处理器，(默认返回参数： 项索引（index:number）)。*/
        selectHandler: laya.utils.Handler;
        /**单元格渲染处理器(默认返回参数cell:Box,index:number)。*/
        renderHandler: laya.utils.Handler;
        /**单元格鼠标事件处理器(默认返回参数e:Event,index:number)。*/
        mouseHandler: laya.utils.Handler;
        /**指定是否可以选择，若值为true则可以选择，否则不可以选择。 @default false*/
        selectEnable: boolean;
        /**最大分页数。*/
        totalPage: number;
        protected _content: Box;
        protected _scrollBar: ScrollBar;
        protected _itemRender: any;
        protected _repeatX: number;
        protected _repeatY: number;
        protected _repeatX2: number;
        protected _repeatY2: number;
        protected _spaceX: number;
        protected _spaceY: number;
        protected _cells: Array<any>;
        protected _array: Array<any>;
        protected _startIndex: number;
        protected _selectedIndex: number;
        protected _page: number;
        protected _isVertical: boolean;
        protected _cellSize: number;
        protected _cellOffset: number;
        protected _isMoved: boolean;
        /**是否缓存内容，如果数据源较少，并且list内无动画，设置此属性为true能大大提高性能 */
        cacheContent: boolean;
        protected _createdLine: number;
        protected _cellChanged: boolean;
        protected _offset: laya.maths.Point;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        /**@inheritDoc */
        cacheAs: string;
        /**
         * 获取对 <code>List</code> 组件所包含的内容容器 <code>Box</code> 组件的引用。
         */
        content: Box;
        /**
         * 垂直方向滚动条皮肤。
         */
        vScrollBarSkin: string;
        /**
         * 水平方向滚动条皮肤。
         */
        hScrollBarSkin: string;
        /**
         * 获取对 <code>List</code> 组件所包含的滚动条 <code>ScrollBar</code> 组件的引用。
         */
        scrollBar: ScrollBar;
        /**
         * 单元格渲染器。
         * <p><b>取值：</b>
         * <ol>
         * <li>单元格类对象。</li>
         * <li> UI 的 JSON 描述。</li>
         * </ol></p>
         */
        itemRender: any;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * 水平方向显示的单元格数量。
         */
        repeatX: number;
        /**
         * 垂直方向显示的单元格数量。
         */
        repeatY: number;
        /**
         * 水平方向显示的单元格之间的间距（以像素为单位）。
         */
        spaceX: number;
        /**
         * 垂直方向显示的单元格之间的间距（以像素为单位）。
         */
        spaceY: number;
        protected changeCells(): void;
        protected createItem(): Box;
        protected addCell(cell: Box): void;
        /**
         * 初始化单元格信息。
         */
        initItems(): void;
        /**
         * 设置可视区域大小。
         * <p>以（0，0，width参数，height参数）组成的矩形区域为可视区域。</p>
         * @param width 可视区域宽度。
         * @param height 可视区域高度。
         */
        setContentSize(width: number, height: number): void;
        protected onCellMouse(e: laya.events.Event): void;
        protected changeCellState(cell: Box, visable: boolean, index: number): void;
        protected changeSize(): void;
        protected onScrollBarChange(e?: laya.events.Event): void;
        /**
         * 表示当前选择的项索引。
         */
        selectedIndex: number;
        protected changeSelectStatus(): void;
        /**
         * 当前选中的单元格数据源。
         */
        selectedItem: any;
        /**
         * 获取或设置当前选择的单元格对象。
         */
        selection: Box;
        /**
         * 当前显示的单元格列表的开始索引。
         */
        startIndex: number;
        protected renderItems(from?: number, to?: number): void;
        protected renderItem(cell: Box, index: number): void;
        /**
         * 列表数据源。
         */
        array: Array<any>;
        /**
         * 列表的当前页码。
         */
        page: number;
        /**
         * 列表的数据总个数。
         */
        length: number;
        /**@inheritDoc */
        dataSource: any;
        /**
         * 单元格集合。
         */
        cells: Array<any>;
        /**
         * 刷新列表数据源。
         */
        refresh(): void;
        /**
         * 获取单元格数据源。
         * @param index 单元格索引。
         */
        getItem(index: number): any;
        /**
         * 修改单元格数据源。
         * @param index 单元格索引。
         * @param source 单元格数据源。
         */
        changeItem(index: number, source: any): void;
        /**
         * 设置单元格数据源。
         * @param index 单元格索引。
         * @param source 单元格数据源。
         */
        setItem(index: number, source: any): void;
        /**
         * 添加单元格数据源。
         * @param souce 数据源。
         */
        addItem(souce: any): void;
        /**
         * 添加单元格数据源到对应的数据索引处。
         * @param souce 单元格数据源。
         * @param index 索引。
         */
        addItemAt(souce: any, index: number): void;
        /**
         * 通过数据源索引删除单元格数据源。
         * @param index 需要删除的数据源索引值。
         */
        deleteItem(index: number): void;
        /**
         * 通过可视单元格索引，获取单元格。
         * @param index 可视单元格索引。
         * @return 单元格对象。
         */
        getCell(index: number): Box;
        /**
         * <p>滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
         * @param index 单元格在数据列表中的索引。
         */
        scrollTo(index: number): void;
        /**
         * <p>缓动滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
         * @param index 单元格在数据列表中的索引。
         * @param time	缓动时间。
         * @param complete	缓动结束回掉
         */
        tweenTo(index: number, time?: number, complete?: laya.utils.Handler): void;
        protected _setCellChanged(): void;
        protected commitMeasure(): void;
    }
}
declare module laya.ui {
    /**
     * <code>Panel</code> 是一个面板容器类。
     */
    class Panel extends Box {
        protected _content: Box;
        protected _vScrollBar: VScrollBar;
        protected _hScrollBar: HScrollBar;
        protected _scrollChanged: boolean;
        /**
         * 创建一个新的 <code>Panel</code> 类实例。
         * <p>在 <code>Panel</code> 构造函数中设置属性width、height的值都为100。</p>
         */
        constructor();
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**@inheritDoc */
        destroyChildren(): void;
        protected createChildren(): void;
        /**@inheritDoc */
        addChild(child: laya.display.Node): laya.display.Node;
        /**@inheritDoc */
        addChildAt(child: laya.display.Node, index: number): laya.display.Node;
        /**@inheritDoc */
        removeChild(child: laya.display.Node): laya.display.Node;
        /**@inheritDoc */
        removeChildAt(index: number): laya.display.Node;
        /**@inheritDoc */
        removeChildren(beginIndex?: number, endIndex?: number): laya.display.Node;
        /**@inheritDoc */
        getChildAt(index: number): laya.display.Node;
        /**@inheritDoc */
        getChildByName(name: string): laya.display.Node;
        /**@inheritDoc */
        getChildIndex(child: laya.display.Node): number;
        /**@inheritDoc */
        numChildren: number;
        protected changeSize(): void;
        /**
         * @private
         * 获取内容宽度（以像素为单位）。
         */
        contentWidth: number;
        /**
         * @private
         * 获取内容高度（以像素为单位）。
         */
        contentHeight: number;
        /**
         * @inheritDoc
         */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * 垂直方向滚动条皮肤。
         */
        vScrollBarSkin: string;
        /**
         * 水平方向滚动条皮肤。
         */
        hScrollBarSkin: string;
        /**
         * 垂直方向滚动条对象。
         */
        vScrollBar: ScrollBar;
        /**
         * 水平方向滚动条对象。
         */
        hScrollBar: ScrollBar;
        /**
         * 获取内容容器对象。
         */
        content: laya.display.Sprite;
        protected onScrollBarChange(scrollBar: ScrollBar): void;
        /**
         * <p>滚动内容容器至设定的垂直、水平方向滚动条位置。</p>
         * @param x 水平方向滚动条属性value值。滚动条位置数字。
         * @param y 垂直方向滚动条属性value值。滚动条位置数字。
         */
        scrollTo(x?: number, y?: number): void;
        /**
         * 刷新滚动内容。
         */
        refresh(): void;
        /**@inheritDoc */
        cacheAs: string;
        protected _setScrollChanged(): void;
    }
}
declare module laya.ui {
    /**
     * <code>ProgressBar</code> 组件显示内容的加载进度。
     * @example 以下示例代码，创建了一个新的 <code>ProgressBar</code> 实例，设置了它的皮肤、位置、宽高、网格等信息，并添加到舞台上。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.ProgressBar;
     *		import laya.utils.Handler;
     *		public class ProgressBar_Example
     *		{
     *			private var progressBar:ProgressBar;
     *			public function ProgressBar_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/progress.png", "resource/ui/progress$bar.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				progressBar = new ProgressBar("resource/ui/progress.png");//创建一个 ProgressBar 类的实例对象 progressBar 。
     *				progressBar.x = 100;//设置 progressBar 对象的属性 x 的值，用于控制 progressBar 对象的显示位置。
     *				progressBar.y = 100;//设置 progressBar 对象的属性 y 的值，用于控制 progressBar 对象的显示位置。
     *				progressBar.value = 0.3;//设置 progressBar 的进度值。
     *				progressBar.width = 200;//设置 progressBar 的宽度。
     *				progressBar.height = 50;//设置 progressBar 的高度。
     *				progressBar.sizeGrid = "5,10,5,10";//设置 progressBar 的网格信息。
     *				progressBar.changeHandler = new Handler(this, onChange);//设置 progressBar 的value值改变时执行的处理器。
     *				Laya.stage.addChild(progressBar);//将 progressBar 添加到显示列表。
     *				Laya.timer.once(3000, this, changeValue);//设定 3000ms（毫秒）后，执行函数changeValue。
     *			}
     *			private function changeValue():void
     *			{
     *				trace("改变进度条的进度值。");
     *				progressBar.value = 0.6;
     *			}
     *			private function onChange(value:Number):void
     *			{
     *				trace("进度发生改变： value=" ,value);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var res = ["resource/ui/progress.png", "resource/ui/progress$bar.png"];
     * Laya.loader.load(res, laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     * function onLoadComplete()
     * {
     *     progressBar = new laya.ui.ProgressBar("resource/ui/progress.png");//创建一个 ProgressBar 类的实例对象 progressBar 。
     *     progressBar.x = 100;//设置 progressBar 对象的属性 x 的值，用于控制 progressBar 对象的显示位置。
     *     progressBar.y = 100;//设置 progressBar 对象的属性 y 的值，用于控制 progressBar 对象的显示位置。
     *     progressBar.value = 0.3;//设置 progressBar 的进度值。
     *     progressBar.width = 200;//设置 progressBar 的宽度。
     *     progressBar.height = 50;//设置 progressBar 的高度。
     *     progressBar.sizeGrid = "10,5,10,5";//设置 progressBar 的网格信息。
     *     progressBar.changeHandler = new laya.utils.Handler(this, onChange);//设置 progressBar 的value值改变时执行的处理器。
     *     Laya.stage.addChild(progressBar);//将 progressBar 添加到显示列表。
     *     Laya.timer.once(3000, this, changeValue);//设定 3000ms（毫秒）后，执行函数changeValue。
     * }
     * function changeValue()
     * {
     *     console.log("改变进度条的进度值。");
     *     progressBar.value = 0.6;
     * }
     * function onChange(value)
     * {
     *     console.log("进度发生改变： value=" ,value);
     * }
     * </listing>
     * <listing version="3.0">
     * import ProgressBar = laya.ui.ProgressBar;
     * import Handler = laya.utils.Handler;
     * class ProgressBar_Example {
     *     private progressBar: ProgressBar;
     *     public ProgressBar_Example() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/progress.png", "resource/ui/progress$bar.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         this.progressBar = new ProgressBar("resource/ui/progress.png");//创建一个 ProgressBar 类的实例对象 progressBar 。
     *         this.progressBar.x = 100;//设置 progressBar 对象的属性 x 的值，用于控制 progressBar 对象的显示位置。
     *         this.progressBar.y = 100;//设置 progressBar 对象的属性 y 的值，用于控制 progressBar 对象的显示位置。
     *         this.progressBar.value = 0.3;//设置 progressBar 的进度值。
     *         this.progressBar.width = 200;//设置 progressBar 的宽度。
     *         this.progressBar.height = 50;//设置 progressBar 的高度。
     *         this.progressBar.sizeGrid = "5,10,5,10";//设置 progressBar 的网格信息。
     *         this.progressBar.changeHandler = new Handler(this, this.onChange);//设置 progressBar 的value值改变时执行的处理器。
     *         Laya.stage.addChild(this.progressBar);//将 progressBar 添加到显示列表。
     *         Laya.timer.once(3000, this, this.changeValue);//设定 3000ms（毫秒）后，执行函数changeValue。
     *     }
     *     private changeValue(): void {
     *         console.log("改变进度条的进度值。");
     *         this.progressBar.value = 0.6;
     *     }
     *     private onChange(value: number): void {
     *         console.log("进度发生改变： value=", value);
     *     }
     * }
     * </listing>
     */
    class ProgressBar extends laya.ui.Component {
        /**
         * 当 <code>ProgressBar</code> 实例的 <code>value</code> 属性发生变化时的函数处理器。
         * <p>默认返回参数<code>value</code> 属性（进度值）。</p>
         */
        changeHandler: laya.utils.Handler;
        protected _bg: laya.ui.Image;
        protected _bar: laya.ui.Image;
        protected _skin: string;
        protected _value: number;
        /**
         * 创建一个新的 <code>ProgressBar</code> 类实例。
         * @param skin 皮肤地址。
         */
        constructor(skin?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        /**
         * @copy laya.ui.Image#skin
         */
        skin: string;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * 当前的进度量。
         * <p><b>取值：</b>介于0和1之间。</p>
         */
        value: number;
        protected changeValue(): void;
        /**
         * 获取进度条对象。
         */
        bar: laya.ui.Image;
        /**
         * 获取背景条对象。
         */
        bg: laya.ui.Image;
        /**
         * <p>当前 <code>ProgressBar</code> 实例的进度条背景位图（ <code>Image</code> 实例）的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         */
        sizeGrid: string;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**
     * <code>Radio</code> 控件使用户可在一组互相排斥的选择中做出一种选择。
     * 用户一次只能选择 <code>Radio</code> 组中的一个成员。选择未选中的组成员将取消选择该组中当前所选的 <code>Radio</code> 控件。
     * @see laya.ui.RadioGroup
     */
    class Radio extends laya.ui.Button {
        protected _value: any;
        /**
         * 创建一个新的 <code>Radio</code> 类实例。
         * @param skin 皮肤。
         * @param label 标签。
         */
        constructor(skin?: string, label?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected preinitialize(): void;
        protected initialize(): void;
        protected onClick(e: laya.events.Event): void;
        /**
         * 获取或设置 <code>Radio</code> 关联的可选用户定义值。
         */
        value: any;
    }
}
declare module laya.ui {
    /**
     * <code>RadioGroup</code> 控件定义一组 <code>Radio</code> 控件，这些控件相互排斥；
     * 因此，用户每次只能选择一个 <code>Radio</code> 控件。
     *
     * @example 以下示例代码，创建了一个 <code>RadioGroup</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Radio;
     *		import laya.ui.RadioGroup;
     *		import laya.utils.Handler;
     *		public class RadioGroup_Example
     *		{
     *			public function RadioGroup_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/radio.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				var radioGroup:RadioGroup = new RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
     *				radioGroup.pos(100, 100);//设置 radioGroup 的位置信息。
     *				radioGroup.labels = "item0,item1,item2";//设置 radioGroup 的标签集。
     *				radioGroup.skin = "resource/ui/radio.png";//设置 radioGroup 的皮肤。
     *				radioGroup.space = 10;//设置 radioGroup 的项间隔距离。
     *				radioGroup.selectHandler = new Handler(this, onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
     *				Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
     *			}
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选择的单选按钮索引: index= ", index);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * Laya.loader.load(["resource/ui/radio.png"], laya.utils.Handler.create(this, onLoadComplete));
     * function onLoadComplete() {
     *     var radioGroup= new laya.ui.RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
     *     radioGroup.pos(100, 100);//设置 radioGroup 的位置信息。
     *     radioGroup.labels = "item0,item1,item2";//设置 radioGroup 的标签集。
     *     radioGroup.skin = "resource/ui/radio.png";//设置 radioGroup 的皮肤。
     *     radioGroup.space = 10;//设置 radioGroup 的项间隔距离。
     *     radioGroup.selectHandler = new laya.utils.Handler(this, onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
     *     Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
     * }
     * function onSelect(index) {
     *     console.log("当前选择的单选按钮索引: index= ", index);
     * }
     * </listing>
     * <listing version="3.0">
     * import Radio = laya.ui.Radio;
     * import RadioGroup = laya.ui.RadioGroup;
     * import Handler = laya.utils.Handler;
     * class RadioGroup_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/radio.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         var radioGroup: RadioGroup = new RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
     *         radioGroup.pos(100, 100);//设置 radioGroup 的位置信息。
     *         radioGroup.labels = "item0,item1,item2";//设置 radioGroup 的标签集。
     *         radioGroup.skin = "resource/ui/radio.png";//设置 radioGroup 的皮肤。
     *         radioGroup.space = 10;//设置 radioGroup 的项间隔距离。
     *         radioGroup.selectHandler = new Handler(this, this.onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
     *         Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
     *     }
     *     private onSelect(index: number): void {
     *         console.log("当前选择的单选按钮索引: index= ", index);
     *     }
     * }
     * </listing>
     */
    class RadioGroup extends UIGroup {
        protected createItem(skin: string, label: string): laya.display.Sprite;
    }
}
declare module laya.ui {
    /**
     * <code>ScrollBar</code> 组件是一个滚动条组件。
     * <p>当数据太多以至于显示区域无法容纳时，最终用户可以使用 <code>ScrollBar</code> 组件控制所显示的数据部分。</p>
     * <p> 滚动条由四部分组成：两个箭头按钮、一个轨道和一个滑块。 </p>	 *
     *
     * @see laya.ui.VScrollBar
     * @see laya.ui.HScrollBar
     */
    class ScrollBar extends Component {
        /**滚动衰减系数*/
        rollRatio: number;
        /**滚动变化时回调，回传value参数。*/
        changeHandler: laya.utils.Handler;
        /**是否缩放滑动条，默认值为true。 */
        scaleBar: boolean;
        /**一个布尔值，指定是否自动隐藏滚动条(无需滚动时)，默认值为false。*/
        autoHide: boolean;
        /**橡皮筋效果极限距离，0为没有橡皮筋效果。*/
        elasticDistance: number;
        /**橡皮筋回弹时间，单位为毫秒。*/
        elasticBackTime: number;
        /**上按钮 */
        upButton: Button;
        /**下按钮 */
        downButton: Button;
        /**滑条 */
        slider: Slider;
        protected _showButtons: boolean;
        protected _scrollSize: number;
        protected _skin: string;
        protected _thumbPercent: number;
        protected _target: laya.display.Sprite;
        protected _lastPoint: laya.maths.Point;
        protected _lastOffset: number;
        protected _checkElastic: boolean;
        protected _isElastic: boolean;
        protected _value: number;
        protected _hide: boolean;
        protected _clickOnly: boolean;
        protected _offsets: Array<any>;
        protected _touchScrollEnable: boolean;
        protected _mouseWheelEnable: boolean;
        /**
         * 创建一个新的 <code>ScrollBar</code> 实例。
         * @param skin 皮肤资源地址。
         */
        constructor(skin?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected initialize(): void;
        protected onSliderChange(): void;
        protected onButtonMouseDown(e: laya.events.Event): void;
        protected startLoop(isUp: boolean): void;
        protected slide(isUp: boolean): void;
        protected onStageMouseUp(e: laya.events.Event): void;
        /**
         * @copy laya.ui.Image#skin
         */
        skin: string;
        protected changeScrollBar(): void;
        protected changeSize(): void;
        protected resetButtonPosition(): void;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * 设置滚动条信息。
         * @param min 滚动条最小位置值。
         * @param max 滚动条最大位置值。
         * @param value 滚动条当前位置值。
         */
        setScroll(min: number, max: number, value: number): void;
        /**
         * 获取或设置表示最高滚动位置的数字。
         */
        max: number;
        /**
         * 获取或设置表示最低滚动位置的数字。
         */
        min: number;
        /**
         * 获取或设置表示当前滚动位置的数字。
         */
        value: number;
        /**
         * 一个布尔值，指示滚动条是否为垂直滚动。如果值为true，则为垂直滚动，否则为水平滚动。
         * <p>默认值为：true。</p>
         */
        isVertical: boolean;
        /**
         * <p>当前实例的 <code>Slider</code> 实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         */
        sizeGrid: string;
        /**获取或设置一个值，该值表示按下滚动条轨道时页面滚动的增量。 */
        scrollSize: number;
        /**@inheritDoc */
        dataSource: any;
        /**获取或设置一个值，该值表示滑条长度比例，值为：（0-1）。 */
        thumbPercent: number;
        /**
         * 设置滚动对象。
         * @see laya.ui.TouchScroll#target
         */
        target: laya.display.Sprite;
        /**是否隐藏滚动条，不显示滚动条，但是可以正常滚动，默认为false。*/
        hide: boolean;
        /**一个布尔值，指定是否显示向上、向下按钮，默认值为true。*/
        showButtons: boolean;
        /**一个布尔值，指定是否开启触摸，默认值为true。*/
        touchScrollEnable: boolean;
        /** 一个布尔值，指定是否滑轮滚动，默认值为true。*/
        mouseWheelEnable: boolean;
        protected onTargetMouseWheel(e: laya.events.Event): void;
        protected onTargetMouseDown(e: laya.events.Event): void;
        protected loop(): void;
        protected onStageMouseUp2(e: laya.events.Event): void;
        protected tweenMove(): void;
        /**
         * 停止滑动。
         */
        stopScroll(): void;
        /**
         * 滚动的刻度值，滑动数值为tick的整数倍。默认值为1。
         */
        tick: number;
    }
}
declare module laya.ui {
    /**
     * 使用 <code>Slider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
     * <p>滑块的当前值由滑块端点（对应于滑块的最小值和最大值）之间滑块的相对位置确定。</p>
     * <p>滑块允许最小值和最大值之间特定间隔内的值。滑块还可以使用数据提示显示其当前值。</p>
     *
     * @see laya.ui.HSlider
     * @see laya.ui.VSlider
     */
    class Slider extends Component {
        static label: Label;
        /**
         * 数据变化处理器。
         * <p>默认回调参数为滑块位置属性 <code>value</code>属性值：Number 。</p>
         */
        changeHandler: laya.utils.Handler;
        /**
         * 一个布尔值，指示是否为垂直滚动。如果值为true，则为垂直方向，否则为水平方向。
         * <p>默认值为：true。</p>
         * @default true
         */
        isVertical: boolean;
        /**
         * 一个布尔值，指示是否显示标签。
         * @default true
         */
        showLabel: boolean;
        protected _allowClickBack: boolean;
        protected _max: number;
        protected _min: number;
        protected _tick: number;
        protected _value: number;
        protected _skin: string;
        protected _bg: Image;
        protected _bar: Button;
        protected _tx: number;
        protected _ty: number;
        protected _maxMove: number;
        protected _globalSacle: laya.maths.Point;
        /**
         * 创建一个新的 <code>Slider</code> 类示例。
         * @param skin 皮肤。
         */
        constructor(skin?: string);
        /**
         *@inheritDoc
         */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected initialize(): void;
        protected onBarMouseDown(e: laya.events.Event): void;
        protected showValueText(): void;
        protected hideValueText(): void;
        protected sendChangeEvent(type?: string): void;
        /**
         * @copy laya.ui.Image#skin
         * @return
         */
        skin: string;
        protected setBarPoint(): void;
        protected measureWidth: number;
        protected measureHeight: number;
        protected changeSize(): void;
        /**
         * <p>当前实例的背景图（ <code>Image</code> ）和滑块按钮（ <code>Button</code> ）实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         * @return
         */
        sizeGrid: string;
        /**
         * 设置滑动条的信息。
         * @param min 滑块的最小值。
         * @param max 滑块的最小值。
         * @param value 滑块的当前值。
         */
        setSlider(min: number, max: number, value: number): void;
        /**
         * 滑动的刻度值，滑动数值为tick的整数倍。默认值为1。
         */
        tick: number;
        protected changeValue(): void;
        /**
         * 获取或设置表示最高位置的数字。 默认值为100。
         */
        max: number;
        /**
         * 获取或设置表示最低位置的数字。 默认值为0。
         */
        min: number;
        /**
         * 获取或设置表示当前滑块位置的数字。
         */
        value: number;
        /**
         * 一个布尔值，指定是否允许通过点击滑动条改变 <code>Slider</code> 的 <code>value</code> 属性值。
         */
        allowClickBack: boolean;
        protected onBgMouseDown(e: laya.events.Event): void;
        /**@inheritDoc */
        dataSource: any;
        /**
         * 表示滑块按钮的引用。
         */
        bar: Button;
    }
}
declare module laya.ui {
    /**
     * <code>Styles</code> 定义了组件常用的样式属性。
     */
    class Styles {
        /**
         * 默认九宫格信息。
         * @see laya.ui.AutoBitmap#sizeGrid
         */
        static defaultSizeGrid: Array<any>;
        /**
         * 标签颜色。
         */
        static labelColor: string;
        /**
         * 标签的边距。
         * <p><b>格式：</b>[上边距，右边距，下边距，左边距]。</p>
         */
        static labelPadding: Array<any>;
        /**
         * 标签的边距。
         * <p><b>格式：</b>[上边距，右边距，下边距，左边距]。</p>
         */
        static inputLabelPadding: Array<any>;
        /**
         * 按钮皮肤的状态数，支持1,2,3三种状态值。
         */
        static buttonStateNum: number;
        /**
         * 按钮标签颜色。
         * <p><b>格式：</b>[upColor,overColor,downColor,disableColor]。</p>
         */
        static buttonLabelColors: Array<any>;
        /**
         * 下拉框项颜色。
         * <p><b>格式：</b>[overBgColor,overLabelColor,outLabelColor,borderColor,bgColor]。</p>
         */
        static comboBoxItemColors: Array<any>;
        /**
         * 滚动条的最小值。
         */
        static scrollBarMinNum: number;
        /**
         * 长按按钮，等待时间，使其可激活连续滚动。
         */
        static scrollBarDelayTime: number;
    }
}
declare module laya.ui {
    /**
     * <code>Tab</code> 组件用来定义选项卡按钮组。	 *
     * @internal <p>属性：<code>selectedIndex</code> 的默认值为-1。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Tab</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Tab;
     *		import laya.utils.Handler;
     *		public class Tab_Example
     *		{
     *			public function Tab_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/tab.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				var tab:Tab = new Tab();//创建一个 Tab 类的实例对象 tab 。
     *				tab.skin = "resource/ui/tab.png";//设置 tab 的皮肤。
     *				tab.labels = "item0,item1,item2";//设置 tab 的标签集。
     *				tab.x = 100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
     *				tab.y = 100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
     *				tab.selectHandler = new Handler(this, onSelect);//设置 tab 的选择项发生改变时执行的处理器。
     *				Laya.stage.addChild(tab);//将 tab 添到显示列表。
     *			}
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选择的表情页索引: index= ", index);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * Laya.loader.load(["resource/ui/tab.png"], laya.utils.Handler.create(this, onLoadComplete));
     * function onLoadComplete() {
     *     var tab = new laya.ui.Tab();//创建一个 Tab 类的实例对象 tab 。
     *     tab.skin = "resource/ui/tab.png";//设置 tab 的皮肤。
     *     tab.labels = "item0,item1,item2";//设置 tab 的标签集。
     *     tab.x = 100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
     *     tab.y = 100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
     *     tab.selectHandler = new laya.utils.Handler(this, onSelect);//设置 tab 的选择项发生改变时执行的处理器。
     *     Laya.stage.addChild(tab);//将 tab 添到显示列表。
     * }
     * function onSelect(index) {
     *     console.log("当前选择的标签页索引: index= ", index);
     * }
     * </listing>
     * <listing version="3.0">
     * import Tab = laya.ui.Tab;
     * import Handler = laya.utils.Handler;
     * class Tab_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/tab.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         var tab: Tab = new Tab();//创建一个 Tab 类的实例对象 tab 。
     *         tab.skin = "resource/ui/tab.png";//设置 tab 的皮肤。
     *         tab.labels = "item0,item1,item2";//设置 tab 的标签集。
     *         tab.x = 100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
     *         tab.y = 100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
     *         tab.selectHandler = new Handler(this, this.onSelect);//设置 tab 的选择项发生改变时执行的处理器。
     *         Laya.stage.addChild(tab);//将 tab 添到显示列表。
     *     }
     *     private onSelect(index: number): void {
     *         console.log("当前选择的表情页索引: index= ", index);
     *     }
     * }
     * </listing>
     */
    class Tab extends laya.ui.UIGroup {
        protected createItem(skin: string, label: string): laya.display.Sprite;
    }
}
declare module laya.ui {
    /**
     * <code>TextArea</code> 类用于创建显示对象以显示和输入文本。
     * @example 以下示例代码，创建了一个 <code>TextArea</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.TextArea;
     *		import laya.utils.Handler;
     *		public class TextArea_Example
     *		{
     *			public function TextArea_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/input.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				var textArea:TextArea = new TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
     *				textArea.skin = "resource/ui/input.png";//设置 textArea 的皮肤。
     *				textArea.sizeGrid = "4,4,4,4";//设置 textArea 的网格信息。
     *				textArea.color = "#008fff";//设置 textArea 的文本颜色。
     *				textArea.font = "Arial";//设置 textArea 的字体。
     *				textArea.bold = true;//设置 textArea 的文本显示为粗体。
     *				textArea.fontSize = 20;//设置 textArea 的文本字体大小。
     *				textArea.wordWrap = true;//设置 textArea 的文本自动换行。
     *				textArea.x = 100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
     *				textArea.y = 100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
     *				textArea.width = 300;//设置 textArea 的宽度。
     *				textArea.height = 200;//设置 textArea 的高度。
     *				Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * Laya.loader.load(["resource/ui/input.png"], laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     * function onLoadComplete() {
     *     var textArea = new laya.ui.TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
     *     textArea.skin = "resource/ui/input.png";//设置 textArea 的皮肤。
     *     textArea.sizeGrid = "4,4,4,4";//设置 textArea 的网格信息。
     *     textArea.color = "#008fff";//设置 textArea 的文本颜色。
     *     textArea.font = "Arial";//设置 textArea 的字体。
     *     textArea.bold = true;//设置 textArea 的文本显示为粗体。
     *     textArea.fontSize = 20;//设置 textArea 的文本字体大小。
     *     textArea.wordWrap = true;//设置 textArea 的文本自动换行。
     *     textArea.x = 100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
     *     textArea.y = 100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
     *     textArea.width = 300;//设置 textArea 的宽度。
     *     textArea.height = 200;//设置 textArea 的高度。
     *     Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * import TextArea = laya.ui.TextArea;
     * import Handler = laya.utils.Handler;
     * class TextArea_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/input.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
    
     *     private onLoadComplete(): void {
     *         var textArea: TextArea = new TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
     *         textArea.skin = "resource/ui/input.png";//设置 textArea 的皮肤。
     *         textArea.sizeGrid = "4,4,4,4";//设置 textArea 的网格信息。
     *         textArea.color = "#008fff";//设置 textArea 的文本颜色。
     *         textArea.font = "Arial";//设置 textArea 的字体。
     *         textArea.bold = true;//设置 textArea 的文本显示为粗体。
     *         textArea.fontSize = 20;//设置 textArea 的文本字体大小。
     *         textArea.wordWrap = true;//设置 textArea 的文本自动换行。
     *         textArea.x = 100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
     *         textArea.y = 100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
     *         textArea.width = 300;//设置 textArea 的宽度。
     *         textArea.height = 200;//设置 textArea 的高度。
     *         Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
     *     }
     * }
     * </listing>
     */
    class TextArea extends TextInput {
        protected _vScrollBar: VScrollBar;
        protected _hScrollBar: HScrollBar;
        /**
         * <p>创建一个新的 <code>TextArea</code> 示例。</p>
         * @param text 文本内容字符串。
         */
        constructor(text?: string);
        destroy(destroyChild?: boolean): void;
        protected initialize(): void;
        width: number;
        height: number;
        /**垂直滚动条皮肤*/
        vScrollBarSkin: string;
        /**水平滚动条皮肤*/
        hScrollBarSkin: string;
        protected onVBarChanged(e: laya.events.Event): void;
        protected onHBarChanged(e: laya.events.Event): void;
        /**垂直滚动条实体*/
        vScrollBar: VScrollBar;
        /**水平滚动条实体*/
        hScrollBar: HScrollBar;
        /**垂直滚动最大值*/
        maxScrollY: number;
        /**垂直滚动值*/
        scrollY: number;
        /**水平滚动最大值*/
        maxScrollX: number;
        /**水平滚动值*/
        scrollX: number;
        /**滚动到某个位置*/
        scrollTo(y: number): void;
    }
}
declare module laya.ui {
    /**
     * <code>TextInput</code> 类用于创建显示对象以显示和输入文本。
     *
     * @example 以下示例代码，创建了一个 <code>TextInput</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.display.Stage;
     *		import laya.ui.TextInput;
     *		import laya.utils.Handler;
     *		public class TextInput_Example
     *		{
     *			public function TextInput_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/input.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				var textInput:TextInput = new TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
     *				textInput.skin = "resource/ui/input.png";//设置 textInput 的皮肤。
     *				textInput.sizeGrid = "4,4,4,4";//设置 textInput 的网格信息。
     *				textInput.color = "#008fff";//设置 textInput 的文本颜色。
     *				textInput.font = "Arial";//设置 textInput 的文本字体。
     *				textInput.bold = true;//设置 textInput 的文本显示为粗体。
     *				textInput.fontSize = 30;//设置 textInput 的字体大小。
     *				textInput.wordWrap = true;//设置 textInput 的文本自动换行。
     *				textInput.x = 100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
     *				textInput.y = 100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
     *				textInput.width = 300;//设置 textInput 的宽度。
     *				textInput.height = 200;//设置 textInput 的高度。
     *				Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * Laya.loader.load(["resource/ui/input.png"], laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     * function onLoadComplete() {
     *     var textInput = new laya.ui.TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
     *     textInput.skin = "resource/ui/input.png";//设置 textInput 的皮肤。
     *     textInput.sizeGrid = "4,4,4,4";//设置 textInput 的网格信息。
     *     textInput.color = "#008fff";//设置 textInput 的文本颜色。
     *     textInput.font = "Arial";//设置 textInput 的文本字体。
     *     textInput.bold = true;//设置 textInput 的文本显示为粗体。
     *     textInput.fontSize = 30;//设置 textInput 的字体大小。
     *     textInput.wordWrap = true;//设置 textInput 的文本自动换行。
     *     textInput.x = 100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
     *     textInput.y = 100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
     *     textInput.width = 300;//设置 textInput 的宽度。
     *     textInput.height = 200;//设置 textInput 的高度。
     *     Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * import Stage = laya.display.Stage;
     * import TextInput = laya.ui.TextInput;
     * import Handler = laya.utils.Handler;
     * class TextInput_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/input.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         var textInput: TextInput = new TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
     *         textInput.skin = "resource/ui/input.png";//设置 textInput 的皮肤。
     *         textInput.sizeGrid = "4,4,4,4";//设置 textInput 的网格信息。
     *         textInput.color = "#008fff";//设置 textInput 的文本颜色。
     *         textInput.font = "Arial";//设置 textInput 的文本字体。
     *         textInput.bold = true;//设置 textInput 的文本显示为粗体。
     *         textInput.fontSize = 30;//设置 textInput 的字体大小。
     *         textInput.wordWrap = true;//设置 textInput 的文本自动换行。
     *         textInput.x = 100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
     *         textInput.y = 100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
     *         textInput.width = 300;//设置 textInput 的宽度。
     *         textInput.height = 200;//设置 textInput 的高度。
     *         Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
     *     }
     * }
     * </listing>
     */
    class TextInput extends Label {
        protected _bg: laya.ui.AutoBitmap;
        protected _skin: string;
        /**
         * 创建一个新的 <code>TextInput</code> 类实例。
         * @param text 文本内容。
         */
        constructor(text?: string);
        protected preinitialize(): void;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected initialize(): void;
        /**
         * 表示此对象包含的文本背景 <code>AutoBitmap</code> 组件实例。
         */
        bg: laya.ui.AutoBitmap;
        /**
         * @copy laya.ui.Image#skin
         */
        skin: string;
        /**
         * <p>当前实例的背景图（ <code>AutoBitmap</code> ）实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         */
        sizeGrid: string;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * <p>指示当前是否是文本域。</p>
         * 值为true表示当前是文本域，否则不是文本域。
         */
        multiline: boolean;
        /**
         * 设置可编辑状态。
         */
        editable: boolean;
        /**
         * 设置原生input输入框的x坐标偏移。
         */
        inputElementXAdjuster: number;
        /**
         * 设置原生input输入框的y坐标偏移。
         */
        inputElementYAdjuster: number;
        /**选中输入框内的文本。*/
        select(): void;
        /**限制输入的字符。*/
        restrict: string;
        /**
         * @copy laya.display.Input#prompt
         */
        prompt: string;
        /**
         * @copy laya.display.Input#promptColor
         */
        promptColor: string;
        /**
         * @copy laya.display.Input#maxChars
         */
        maxChars: number;
        /**
         * @copy laya.display.Input#focus
         */
        focus: boolean;
        /**
         * @copy laya.display.Input#type
         */
        type: string;
        /**
         * @copy laya.display.Input#asPassword
         */
        asPassword: boolean;
        setSelection(startIndex: number, endIndex: number): void;
    }
}
declare module laya.ui {
    /**鼠标提示管理类*/
    class TipManager extends laya.ui.Component {
        static offsetX: number;
        static offsetY: number;
        static tipTextColor: string;
        static tipBackColor: string;
        static tipDelay: number;
        constructor();
        /**关闭所有鼠标提示*/
        closeAll(): void;
        /**
         * 显示显示对象类型的tip
         */
        showDislayTip(tip: laya.display.Sprite): void;
        /**默认鼠标提示函数*/
        defaultTipHandler: Function;
    }
}
declare module laya.ui {
    /**
     * <code>Tree</code> 控件使用户可以查看排列为可扩展树的层次结构数据。
     *
     * @example 以下示例代码，创建了一个 <code>Tree</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.Tree;
     *		import laya.utils.Browser;
     *		import laya.utils.Handler;
    
     *		public class Tree_Example
     *		{
    
     *			public function Tree_Example()
     *			{
     *				Laya.init(640, 800);
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder.png", "resource/ui/clip_tree_arrow.png"], Handler.create(this, onLoadComplete));
     *			}
    
     *			private function onLoadComplete():void
     *			{
     *				var xmlString:String;//创建一个xml字符串，用于存储树结构数据。
     *				xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
     *				var domParser:* = new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
     *				var xml:* = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
    
     *				var tree:Tree = new Tree();//创建一个 Tree 类的实例对象 tree 。
     *				tree.scrollBarSkin = "resource/ui/vscroll.png";//设置 tree 的皮肤。
     *				tree.itemRender = Item;//设置 tree 的项渲染器。
     *				tree.xml = xml;//设置 tree 的树结构数据。
     *				tree.x = 100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
     *				tree.y = 100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
     *				tree.width = 200;//设置 tree 的宽度。
     *				tree.height = 100;//设置 tree 的高度。
     *				Laya.stage.addChild(tree);//将 tree 添加到显示列表。
     *			}
     *		}
     *	}
    
     * import laya.ui.Box;
     * import laya.ui.Clip;
     * import laya.ui.Label;
     *	class Item extends Box
     *	{
     *		public function Item()
     *		{
     *			this.name = "render";
     *			this.right = 0;
     *			this.left = 0;
    
     *			var selectBox:Clip = new Clip("resource/ui/clip_selectBox.png", 1, 2);
     *			selectBox.name = "selectBox";
     *			selectBox.height = 24;
     *			selectBox.x = 13;
     *			selectBox.y = 0;
     *			selectBox.left = 12;
     *			addChild(selectBox);
    
     *			var folder:Clip = new Clip("resource/ui/clip_tree_folder.png", 1, 3);
     *			folder.name = "folder";
     *			folder.x = 14;
     *			folder.y = 4;
     *			addChild(folder);
    
     *			var label:Label = new Label("treeItem");
     *			label.name = "label";
     *			label.color = "#ffff00";
     *			label.width = 150;
     *			label.height = 22;
     *			label.x = 33;
     *			label.y = 1;
     *			label.left = 33;
     *			label.right = 0;
     *			addChild(label);
    
     *			var arrow:Clip = new Clip("resource/ui/clip_tree_arrow.png", 1, 2);
     *			arrow.name = "arrow";
     *			arrow.x = 0;
     *			arrow.y = 5;
     *			addChild(arrow);
     *		}
     *	 }
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var res = ["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder.png", "resource/ui/clip_tree_arrow.png"];
     * Laya.loader.load(res, new laya.utils.Handler(this, onLoadComplete));
     * function onLoadComplete() {
     *     var xmlString;//创建一个xml字符串，用于存储树结构数据。
     *     xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
     *     var domParser = new laya.utils.Browser.window.DOMParser();//创建一个DOMParser实例domParser。
     *     var xml = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
    
     *     var tree = new laya.ui.Tree();//创建一个 Tree 类的实例对象 tree 。
     *     tree.scrollBarSkin = "resource/ui/vscroll.png";//设置 tree 的皮肤。
     *     tree.itemRender = mypackage.treeExample.Item;//设置 tree 的项渲染器。
     *     tree.xml = xml;//设置 tree 的树结构数据。
     *     tree.x = 100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
     *     tree.y = 100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
     *     tree.width = 200;//设置 tree 的宽度。
     *     tree.height = 100;//设置 tree 的高度。
     *     Laya.stage.addChild(tree);//将 tree 添加到显示列表。
     * }
     * (function (_super) {
     *     function Item() {
     *         Item.__super.call(this);//初始化父类。
     *         this.right = 0;
     *         this.left = 0;
    
     *         var selectBox = new laya.ui.Clip("resource/ui/clip_selectBox.png", 1, 2);
     *         selectBox.name = "selectBox";//设置 selectBox 的name 为“selectBox”时，将被识别为树结构的项的背景。2帧：悬停时背景、选中时背景。
     *         selectBox.height = 24;
     *         selectBox.x = 13;
     *         selectBox.y = 0;
     *         selectBox.left = 12;
     *         this.addChild(selectBox);//需要使用this.访问父类的属性或方法。
    
     *         var folder = new laya.ui.Clip("resource/ui/clip_tree_folder.png", 1, 3);
     *         folder.name = "folder";//设置 folder 的name 为“folder”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
     *         folder.x = 14;
     *         folder.y = 4;
     *         this.addChild(folder);
    
     *         var label = new laya.ui.Label("treeItem");
     *         label.name = "label";//设置 label 的name 为“label”时，此值将用于树结构数据赋值。
     *         label.color = "#ffff00";
     *         label.width = 150;
     *         label.height = 22;
     *         label.x = 33;
     *         label.y = 1;
     *         label.left = 33;
     *         label.right = 0;
     *         this.addChild(label);
    
     *         var arrow = new laya.ui.Clip("resource/ui/clip_tree_arrow.png", 1, 2);
     *         arrow.name = "arrow";//设置 arrow 的name 为“arrow”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
     *         arrow.x = 0;
     *         arrow.y = 5;
     *         this.addChild(arrow);
     *     };
     *     Laya.class(Item,"mypackage.treeExample.Item",_super);//注册类 Item 。
     * })(laya.ui.Box);
     * </listing>
     * <listing version="3.0">
     * import Tree = laya.ui.Tree;
     * import Browser = laya.utils.Browser;
     * import Handler = laya.utils.Handler;
     * class Tree_Example {
    
     *     constructor() {
     *         Laya.init(640, 800);
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder * . * png", "resource/ui/clip_tree_arrow.png"], Handler.create(this, this.onLoadComplete));
     *     }
     *     private onLoadComplete(): void {
     *         var xmlString: String;//创建一个xml字符串，用于存储树结构数据。
     *         xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc  * label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
     *         var domParser: any = new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
     *         var xml: any = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
    
     *         var tree: Tree = new Tree();//创建一个 Tree 类的实例对象 tree 。
     *         tree.scrollBarSkin = "resource/ui/vscroll.png";//设置 tree 的皮肤。
     *         tree.itemRender = Item;//设置 tree 的项渲染器。
     *         tree.xml = xml;//设置 tree 的树结构数据。
     *         tree.x = 100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
     *         tree.y = 100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
     *         tree.width = 200;//设置 tree 的宽度。
     *         tree.height = 100;//设置 tree 的高度。
     *         Laya.stage.addChild(tree);//将 tree 添加到显示列表。
     *     }
     * }
     * import Box = laya.ui.Box;
     * import Clip = laya.ui.Clip;
     * import Label = laya.ui.Label;
     * class Item extends Box {
     *     constructor() {
     *         super();
     *         this.name = "render";
     *         this.right = 0;
     *         this.left = 0;
     *         var selectBox: Clip = new Clip("resource/ui/clip_selectBox.png", 1, 2);
     *         selectBox.name = "selectBox";
     *         selectBox.height = 24;
     *         selectBox.x = 13;
     *         selectBox.y = 0;
     *         selectBox.left = 12;
     *         this.addChild(selectBox);
    
     *         var folder: Clip = new Clip("resource/ui/clip_tree_folder.png", 1, 3);
     *         folder.name = "folder";
     *         folder.x = 14;
     *         folder.y = 4;
     *         this.addChild(folder);
    
     *         var label: Label = new Label("treeItem");
     *         label.name = "label";
     *         label.color = "#ffff00";
     *         label.width = 150;
     *         label.height = 22;
     *         label.x = 33;
     *         label.y = 1;
     *         label.left = 33;
     *         label.right = 0;
     *         this.addChild(label);
    
     *         var arrow: Clip = new Clip("resource/ui/clip_tree_arrow.png", 1, 2);
     *         arrow.name = "arrow";
     *         arrow.x = 0;
     *         arrow.y = 5;
     *         this.addChild(arrow);
     *     }
     * }
     * </listing>
     */
    class Tree extends Box implements IRender {
        protected _list: List;
        protected _source: Array<any>;
        protected _renderHandler: laya.utils.Handler;
        protected _spaceLeft: number;
        protected _spaceBottom: number;
        protected _keepStatus: boolean;
        /**
         * 创建一个新的 <code>Tree</code> 类实例。
         * <p>在 <code>Tree</code> 构造函数中设置属性width、height的值都为200。</p>
         */
        constructor();
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected onListChange(e?: laya.events.Event): void;
        /**
         * 数据源发生变化后，是否保持之前打开状态，默认为true。
         * <p><b>取值：</b>
         * <li>true：保持之前打开状态。</li>
         * <li>false：不保持之前打开状态。</li>
         * </p>
         */
        keepStatus: boolean;
        /**
         * 列表数据源，只包含当前可视节点数据。
         */
        array: Array<any>;
        /**
         * 数据源，全部节点数据。
         */
        source: Array<any>;
        /**
         * 此对象包含的<code>List</code>实例对象。
         */
        list: List;
        /**
         * 此对象包含的<code>List</code>实例的单元格渲染器。
         * <p><b>取值：</b>
         * <ol>
         * <li>单元格类对象。</li>
         * <li> UI 的 JSON 描述。</li>
         * </ol></p>
         */
        itemRender: any;
        /**
         * 滚动条皮肤。
         */
        scrollBarSkin: string;
        /**滚动条*/
        scrollBar: ScrollBar;
        /**
         * 单元格鼠标事件处理器。
         * <p>默认返回参数（e:Event,index:int）。</p>
         */
        mouseHandler: laya.utils.Handler;
        /**
         * <code>Tree</code> 实例的渲染处理器。
         */
        renderHandler: laya.utils.Handler;
        /**
         * 左侧缩进距离（以像素为单位）。
         */
        spaceLeft: number;
        /**
         * 每一项之间的间隔距离（以像素为单位）。
         */
        spaceBottom: number;
        /**
         * 表示当前选择的项索引。
         */
        selectedIndex: number;
        /**
         * 当前选中的项对象的数据源。
         */
        selectedItem: any;
        /**
         * @inheritDoc
         */
        width: number;
        /**@inheritDoc */
        height: number;
        protected getArray(): Array<any>;
        protected getDepth(item: any, num?: number): number;
        protected getParentOpenStatus(item: any): boolean;
        protected renderItem(cell: Box, index: number): void;
        /**
         * 设置指定项索引的项对象的打开状态。
         * @param index 项索引。
         * @param isOpen 是否处于打开状态。
         */
        setItemState(index: number, isOpen: boolean): void;
        /**
         * 刷新项列表。
         */
        fresh(): void;
        /**@inheritDoc */
        dataSource: any;
        /**
         *  xml结构的数据源。
         */
        xml: any;
        protected parseXml(xml: any, source: Array<any>, nodeParent: any, isRoot: boolean): void;
        protected parseOpenStatus(oldSource: Array<any>, newSource: Array<any>): void;
        protected isSameParent(item1: any, item2: any): boolean;
        /**
         * 表示选择的树节点项的<code>path</code>属性值。
         */
        selectedPath: string;
        /**
         * 更新项列表，显示指定键名的数据项。
         * @param	key 键名。
         */
        filter(key: string): void;
    }
}
declare module laya.ui {
    /**
     * <code>UIEvent</code> 类用来定义UI组件类的事件类型。
     */
    class UIEvent extends laya.events.Event {
        /**
         * 显示提示信息。
         */
        static SHOW_TIP: string;
        /**
         * 隐藏提示信息。
         */
        static HIDE_TIP: string;
    }
}
declare module laya.ui {
    /**
     * <code>Group</code> 是一个可以自动布局的项集合控件。
     * <p> <code>Group</code> 的默认项对象为 <code>Button</code> 类实例。
     * <code>Group</code> 是 <code>Tab</code> 和 <code>RadioGroup</code> 的基类。</p>
     */
    class UIGroup extends Box implements IItem {
        /**
         * 改变 <code>Group</code> 的选择项时执行的处理器，(默认返回参数： 项索引（index:int）)。
         */
        selectHandler: laya.utils.Handler;
        protected _items: Array<any>;
        protected _selectedIndex: number;
        protected _skin: string;
        protected _direction: string;
        protected _space: number;
        protected _labels: string;
        protected _labelColors: string;
        protected _labelStrokeColor: string;
        protected _strokeColors: string;
        protected _labelStroke: number;
        protected _labelSize: number;
        protected _labelBold: boolean;
        protected _labelPadding: string;
        protected _labelAlign: string;
        protected _stateNum: number;
        protected _labelChanged: boolean;
        /**
         * 创建一个新的 <code>Group</code> 类实例。
         * @param labels 标签集字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
         * @param skin 皮肤。
         */
        constructor(labels?: string, skin?: string);
        protected preinitialize(): void;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**
         * 添加一个项对象，返回此项对象的索引id。
         *
         * @param item 需要添加的项对象。
         * @param autoLayOut 是否自动布局，如果为true，会根据 <code>direction</code> 和 <code>space</code> 属性计算item的位置。
         * @return
         */
        addItem(item: ISelect, autoLayOut?: boolean): number;
        /**
         * 删除一个项对象。
         * @param item 需要删除的项对象。
         * @param autoLayOut 是否自动布局，如果为true，会根据 <code>direction</code> 和 <code>space</code> 属性计算item的位置。
         */
        delItem(item: ISelect, autoLayOut?: boolean): void;
        /**
         * 初始化项对象们。
         */
        initItems(): void;
        protected itemClick(index: number): void;
        /**
         * 表示当前选择的项索引。默认值为-1。
         */
        selectedIndex: number;
        protected setSelect(index: number, selected: boolean): void;
        /**
         * @copy laya.ui.Image#skin
         */
        skin: string;
        /**
         * 标签集合字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
         */
        labels: string;
        protected createItem(skin: string, label: string): laya.display.Sprite;
        /**
         * @copy laya.ui.Button#labelColors()
         */
        labelColors: string;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         * @see laya.display.Text.stroke()
         */
        labelStroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * 默认值为 "#000000"（黑色）;
         * @see laya.display.Text.strokeColor()
         */
        labelStrokeColor: string;
        /**
         * <p>表示各个状态下的描边颜色。</p>
         * @see laya.display.Text.strokeColor()
         */
        strokeColors: string;
        /**
         * 表示按钮文本标签的字体大小。
         */
        labelSize: number;
        /**
         * 表示按钮文本标签的字体大小。
         */
        stateNum: number;
        /**
         * 表示按钮文本标签是否为粗体字。
         */
        labelBold: boolean;
        /**
         * 表示按钮文本标签的边距。
         * <p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
         */
        labelPadding: string;
        /**
         * 布局方向。
         * <p>默认值为"horizontal"。</p>
         * <p><b>取值：</b>
         * <li>"horizontal"：表示水平布局。</li>
         * <li>"vertical"：表示垂直布局。</li>
         * </p>
         */
        direction: string;
        /**
         * 项对象们之间的间隔（以像素为单位）。
         */
        space: number;
        protected changeLabels(): void;
        protected commitMeasure(): void;
        /**
         * 项对象们的存放数组。
         */
        items: Array<any>;
        /**
         * 获取或设置当前选择的项对象。
         */
        selection: ISelect;
        /**@inheritDoc */
        dataSource: any;
        protected _setLabelChanged(): void;
    }
}
declare module laya.ui {
    /**
     * <code>UIUtils</code> 是文本工具集。
     */
    class UIUtils {
        /**
         * 用字符串填充数组，并返回数组副本。
         * @param	arr 源数组对象。
         * @param	str 用逗号连接的字符串。如"p1,p2,p3,p4"。
         * @param	type 如果值不为null，则填充的是新增值得类型。
         * @return 填充后的数组。
         */
        static fillArray(arr: Array<any>, str: string, type?: any): Array<any>;
        /**
         * 转换uint类型颜色值为字符型颜色值。
         * @param color uint颜色值。
         * @return 字符型颜色值。
         */
        static toColor(color: number): string;
        /**
         * 给指定的目标显示对象添加或移除灰度滤镜。
         * @param	traget 目标显示对象。
         * @param	isGray 如果值true，则添加灰度滤镜，否则移除灰度滤镜。
         */
        static gray(traget: laya.display.Sprite, isGray?: boolean): void;
        /**
         * 给指定的目标显示对象添加滤镜。
         * @param	target 目标显示对象。
         * @param	filter 滤镜对象。
         */
        static addFilter(target: laya.display.Sprite, filter: laya.filters.IFilter): void;
        /**
         * 移除目标显示对象的指定类型滤镜。
         * @param	target 目标显示对象。
         * @param	filterType 滤镜类型。
         */
        static clearFilter(target: laya.display.Sprite, filterType: any): void;
    }
}
declare module laya.ui {
    /**
     * <code>VBox</code> 是一个垂直布局容器类。
     */
    class VBox extends LayoutBox {
        /**
         * 无对齐。
         */
        static NONE: string;
        /**
         * 左对齐。
         */
        static LEFT: string;
        /**
         * 居中对齐。
         */
        static CENTER: string;
        /**
         * 右对齐。
         */
        static RIGHT: string;
        protected changeItems(): void;
    }
}
declare module laya.ui {
    /**
     * <code>View</code> 是一个视图类。
     * @internal <p><code>View</code></p>
     */
    class View extends laya.ui.Box {
        /**存储UI配置数据(用于加载模式)。*/
        static uiMap: any;
        /**UI类映射。*/
        static uiClassMap: any;
        protected static viewClassMap: any;
        _idMap: any;
        _aniList: Array<any>;
        protected createView(uiView: any): void;
        protected loadUI(path: string): void;
        /**
         * 根据UI数据实例化组件。
         * @param uiView UI数据。
         * @param comp 组件本体，如果为空，会新创建一个。
         * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
         * @return 一个 Component 对象。
         */
        static createComp(uiView: any, comp?: any, view?: View): any;
        protected static getCompInstance(json: any): any;
        /**
         * 注册组件类映射。
         * <p>用于扩展组件及修改组件对应关系。</p>
         * @param key 组件类的关键字。
         * @param compClass 组件类对象。
         */
        static regComponent(key: string, compClass: any): void;
        /**
         * 注册UI视图类的逻辑处理类。
         * @internal 注册runtime解析。
         * @param key UI视图类的关键字。
         * @param compClass UI视图类对应的逻辑处理类。
         */
        static regViewRuntime(key: string, compClass: any): void;
        /**
         * <p>销毁此对象。</p>
         * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
    }
}
declare module laya.ui {
    /**
     * <code>ViewStack</code> 类用于视图堆栈类，用于视图的显示等设置处理。
     */
    class ViewStack extends laya.ui.Box implements IItem {
        protected _items: Array<any>;
        protected _setIndexHandler: laya.utils.Handler;
        protected _selectedIndex: number;
        /**
         * 批量设置视图对象。
         * @param views 视图对象数组。
         */
        setItems(views: Array<any>): void;
        /**
         * 添加视图。
         * @internal 添加视图对象，并设置此视图对象的<code>name</code> 属性。
         * @param view 需要添加的视图对象。
         */
        addItem(view: laya.display.Node): void;
        /**
         * 初始化视图对象集合。
         */
        initItems(): void;
        /**
         * 表示当前视图索引。
         */
        selectedIndex: number;
        protected setSelect(index: number, selected: boolean): void;
        /**
         * 获取或设置当前选择的项对象。
         */
        selection: laya.display.Node;
        /**
         *  索引设置处理器。
         * <p>默认回调参数：index:int</p>
         */
        setIndexHandler: laya.utils.Handler;
        protected setIndex(index: number): void;
        /**
         * 视图集合数组。
         */
        items: Array<any>;
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**
     *
     * 使用 <code>VScrollBar</code> （垂直 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
     *
     * @example 以下示例代码，创建了一个 <code>VScrollBar</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.vScrollBar;
     *		import laya.ui.VScrollBar;
     *		import laya.utils.Handler;
     *		public class VScrollBar_Example
     *		{
     *			private var vScrollBar:VScrollBar;
     *			public function VScrollBar_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, onLoadComplete));
     *			}
     *			private function onLoadComplete():void
     *			{
     *				vScrollBar = new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
     *				vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
     *				vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
     *				vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
     *				vScrollBar.changeHandler = new Handler(this, onChange);//设置 vScrollBar 的滚动变化处理器。
     *				Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
     *			}
     *			private function onChange(value:Number):void
     *			{
     *				trace("滚动条的位置： value=" + value);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var vScrollBar;
     * var res = ["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"];
     * Laya.loader.load(res, laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     * function onLoadComplete() {
     *     vScrollBar = new laya.ui.VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
     *     vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
     *     vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
     *     vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
     *     vScrollBar.changeHandler = new laya.utils.Handler(this, onChange);//设置 vScrollBar 的滚动变化处理器。
     *     Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
     * }
     * function onChange(value) {
     *     console.log("滚动条的位置： value=" + value);
     * }
     * </listing>
     * <listing version="3.0">
     * import VScrollBar = laya.ui.VScrollBar;
     * import Handler = laya.utils.Handler;
     * class VScrollBar_Example {
     *     private vScrollBar: VScrollBar;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, this.onLoadComplete));
     *     }
     *     private onLoadComplete(): void {
     *         this.vScrollBar = new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
     *         this.vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
     *         this.vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
     *         this.vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
     *         this.vScrollBar.changeHandler = new Handler(this, this.onChange);//设置 vScrollBar 的滚动变化处理器。
     *         Laya.stage.addChild(this.vScrollBar);//将此 vScrollBar 对象添加到显示列表。
     *     }
     *     private onChange(value: number): void {
     *         console.log("滚动条的位置： value=" + value);
     *     }
     * }
     * </listing>
     */
    class VScrollBar extends ScrollBar {
    }
}
declare module laya.ui {
    /**
     * 使用 <code>VSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
     * <p> <code>VSlider</code> 控件采用垂直方向。滑块轨道从下往上扩展，而标签位于轨道的左右两侧。</p>
     *
     * @example 以下示例代码，创建了一个 <code>VSlider</code> 实例。
     * <listing version="3.0">
     * package
     *	{
     *		import laya.ui.HSlider;
     *		import laya.ui.VSlider;
     *		import laya.utils.Handler;
     *		public class VSlider_Example
     *		{
     *			private var vSlider:VSlider;
     *			public function VSlider_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *			private function onLoadComplete():void
     *			{
     *				vSlider = new VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
     *				vSlider.skin = "resource/ui/vslider.png";//设置 vSlider 的皮肤。
     *				vSlider.min = 0;//设置 vSlider 最低位置值。
     *				vSlider.max = 10;//设置 vSlider 最高位置值。
     *				vSlider.value = 2;//设置 vSlider 当前位置值。
     *				vSlider.tick = 1;//设置 vSlider 刻度值。
     *				vSlider.x = 100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
     *				vSlider.y = 100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
     *				vSlider.changeHandler = new Handler(this, onChange);//设置 vSlider 位置变化处理器。
     *				Laya.stage.addChild(vSlider);//把 vSlider 添加到显示列表。
     *			}
     *			private function onChange(value:Number):void
     *			{
     *				trace("滑块的位置： value=" + value);
     *			}
     *		}
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var vSlider;
     * Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     * function onLoadComplete() {
     *     vSlider = new laya.ui.VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
     *     vSlider.skin = "resource/ui/vslider.png";//设置 vSlider 的皮肤。
     *     vSlider.min = 0;//设置 vSlider 最低位置值。
     *     vSlider.max = 10;//设置 vSlider 最高位置值。
     *     vSlider.value = 2;//设置 vSlider 当前位置值。
     *     vSlider.tick = 1;//设置 vSlider 刻度值。
     *     vSlider.x = 100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
     *     vSlider.y = 100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
     *     vSlider.changeHandler = new laya.utils.Handler(this, onChange);//设置 vSlider 位置变化处理器。
     *     Laya.stage.addChild(vSlider);//把 vSlider 添加到显示列表。
     * }
     * function onChange(value) {
     *     console.log("滑块的位置： value=" + value);
     * }
     * </listing>
     * <listing version="3.0">
     * import HSlider = laya.ui.HSlider;
     * import VSlider = laya.ui.VSlider;
     * import Handler = laya.utils.Handler;
     * class VSlider_Example {
     *     private vSlider: VSlider;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *     private onLoadComplete(): void {
     *         this.vSlider = new VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
     *         this.vSlider.skin = "resource/ui/vslider.png";//设置 vSlider 的皮肤。
     *         this.vSlider.min = 0;//设置 vSlider 最低位置值。
     *         this.vSlider.max = 10;//设置 vSlider 最高位置值。
     *         this.vSlider.value = 2;//设置 vSlider 当前位置值。
     *         this.vSlider.tick = 1;//设置 vSlider 刻度值。
     *         this.vSlider.x = 100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
     *         this.vSlider.y = 100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
     *         this.vSlider.changeHandler = new Handler(this, this.onChange);//设置 vSlider 位置变化处理器。
     *         Laya.stage.addChild(this.vSlider);//把 vSlider 添加到显示列表。
     *     }
     *     private onChange(value: number): void {
     *         console.log("滑块的位置： value=" + value);
     *     }
     * }
     * </listing>
     * @see laya.ui.Slider
     */
    class VSlider extends Slider {
    }
}
declare module laya.utils {
    /**
     * <code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
     */
    class Browser {
        private static _window;
        private static _document;
        private static _container;
        /** 浏览器代理信息。*/
        static userAgent: string;
        private static u;
        /** 表示是否在 ios 设备。*/
        static onIOS: boolean;
        /** 表示是否在移动设备。*/
        static onMobile: boolean;
        /** 表示是否在 iphone设备。*/
        static onIPhone: boolean;
        /** 表示是否在 ipad 设备。*/
        static onIPad: boolean;
        /** 表示是否在 andriod设备。*/
        static onAndriod: boolean;
        /** 表示是否在 Windows Phone 设备。*/
        static onWP: boolean;
        /** 表示是否在 QQ 浏览器。*/
        static onQQBrowser: boolean;
        /** 表示是否在移动端 QQ 或 QQ 浏览器。*/
        static onMQQBrowser: boolean;
        /** 表示是否在移动端 Safari。*/
        static onSafari: boolean;
        /** 微信内*/
        static onWeiXin: boolean;
        /** 表示是否在 PC 端。*/
        static onPC: boolean;
        /** 表示是否是 HTTP 协议。*/
        static httpProtocol: boolean;
        static webAudioEnabled: boolean;
        static soundType: string;
        static enableTouch: boolean;
        /** 全局画布实例（非主画布）。*/
        static canvas: laya.resource.HTMLCanvas;
        /** 全局画布上绘图的环境（非主画布）。 */
        static context: laya.resource.Context;
        static __init__(): void;
        /**
         * 创建浏览器原生节点。
         * @param	type 节点类型。
         * @return	创建的节点对象的引用。
         */
        static createElement(type: string): any;
        /**
         * 返回对拥有指定 id 的第一个对象的引用。
         * @param	type 节点id。
         * @return	节点对象。
         */
        static getElementById(type: string): any;
        /**
         * 移除浏览器原生节点对象。
         * @param	type 节点对象。
         */
        static removeElement(ele: any): void;
        /**
         * 获取浏览器当前时间戳，单位为毫秒。
         */
        static now(): number;
        /** 浏览器可视宽度。*/
        static clientWidth: number;
        /** 浏览器可视高度。*/
        static clientHeight: number;
        /** 浏览器物理宽度，。*/
        static width: number;
        /** 浏览器物理高度。*/
        static height: number;
        /** 设备像素比。*/
        static pixelRatio: number;
        /**画布容器，用来盛放画布的容器。方便对画布进行控制*/
        static container: any;
        /** 浏览器原生 window 对象的引用。*/
        static window: any;
        /** 浏览器原生 document 对象的引用。*/
        static document: any;
    }
}
declare module laya.utils {
    /**
     *
     * <code>Byte</code> 类提供用于优化读取、写入以及处理二进制数据的方法和属性。
     */
    class Byte {
        /**
         * 表示多字节数字的最高有效字节位于字节序列的最前面。
         */
        static BIG_ENDIAN: string;
        /**
         * 表示多字节数字的最低有效字节位于字节序列的最前面。
         */
        static LITTLE_ENDIAN: string;
        protected _xd_: boolean;
        protected _d_: any;
        protected _u8d_: any;
        protected _pos_: number;
        protected _length: number;
        private static _sysEndian;
        /**
         * 获取系统的字节存储顺序。
         * @return 字节存储顺序。
         */
        static getSystemEndian(): string;
        /**
         * 创建一个 <code>Byte</code> 类的实例。
         * @param	data 用于指定元素的数目、类型化数组、ArrayBuffer。
         */
        constructor(data?: any);
        /**
         * 获取此对象的 ArrayBuffer数据,数据只包含有效数据部分 。
         */
        buffer: ArrayBuffer;
        /**
         * 字节顺序。
         */
        endian: string;
        /**
         * 字节长度。
         */
        length: number;
        /**
         * 读取字符型值。
         * @return
         */
        getString(): string;
        /**
         * 从指定的位置读取指定长度的数据用于创建一个 Float32Array 对象并返回此对象。
         * @param	start 开始位置。
         * @param	len 需要读取的字节长度。
         * @return  读出的 Float32Array 对象。
         */
        getFloat32Array(start: number, len: number): any;
        /**
         * 从指定的位置读取指定长度的数据用于创建一个 Uint8Array 对象并返回此对象。
         * @param	start 开始位置。
         * @param	len 需要读取的字节长度。
         * @return  读出的 Uint8Array 对象。
         */
        getUint8Array(start: number, len: number): Uint8Array;
        /**
         * 从指定的位置读取指定长度的数据用于创建一个 Int16Array 对象并返回此对象。
         * @param	start 开始位置。
         * @param	len 需要读取的字节长度。
         * @return  读出的 Uint8Array 对象。
         */
        getInt16Array(start: number, len: number): any;
        /**
         * 在指定字节偏移量位置处读取 Float32 值。
         * @return Float32 值。
         */
        getFloat32(): number;
        getFloat64(): number;
        /**
         * 在当前字节偏移量位置处写入 Float32 值。
         * @param	value 需要写入的 Float32 值。
         */
        writeFloat32(value: number): void;
        writeFloat64(value: number): void;
        /**
         * 在当前字节偏移量位置处读取 Int32 值。
         * @return Int32 值。
         */
        getInt32(): number;
        /**
         * 在当前字节偏移量位置处读取 Uint32 值。
         * @return Uint32 值。
         */
        getUint32(): number;
        /**
         * 在当前字节偏移量位置处写入 Int32 值。
         * @param	value 需要写入的 Int32 值。
         */
        writeInt32(value: number): void;
        /**
         * 在当前字节偏移量位置处写入 Uint32 值。
         * @param	value 需要写入的 Uint32 值。
         */
        writeUint32(value: number): void;
        /**
         * 在当前字节偏移量位置处读取 Int16 值。
         * @return Int16 值。
         */
        getInt16(): number;
        /**
         * 在当前字节偏移量位置处读取 Uint16 值。
         * @return Uint16 值。
         */
        getUint16(): number;
        /**
         * 在当前字节偏移量位置处写入 Uint16 值。
         * @param	value 需要写入的Uint16 值。
         */
        writeUint16(value: number): void;
        /**
         * 在当前字节偏移量位置处写入 Int16 值。
         * @param	value 需要写入的 Int16 值。
         */
        writeInt16(value: number): void;
        /**
         * 在当前字节偏移量位置处读取 Uint8 值。
         * @return Uint8 值。
         */
        getUint8(): number;
        /**
         * 在当前字节偏移量位置处写入 Uint8 值。
         * @param	value 需要写入的 Uint8 值。
         */
        writeUint8(value: number): void;
        /**
         * @private
         * 在指定位置处读取 Uint8 值。
         * @param	pos 字节读取位置。
         * @return Uint8 值。
         */
        _getUInt8(pos: number): number;
        /**
         * @private
         * 在指定位置处读取 Uint16 值。
         * @param	pos 字节读取位置。
         * @return Uint16 值。
         */
        _getUint16(pos: number): number;
        /**
         * @private
         * 使用 getFloat32() 读取6个值，用于创建并返回一个 Matrix 对象。
         * @return  Matrix 对象。
         */
        _getMatrix(): laya.maths.Matrix;
        /**
         * 字符串读取。
         * @param	len
         * @return
         */
        getCustomString(len: number): string;
        /**
         * 当前读取到的位置。
         */
        pos: number;
        /**
         * 可从字节流的当前位置到末尾读取的数据的字节数。
         */
        bytesAvailable: number;
        /**
         * 清除数据。
         */
        clear(): void;
        /**
         * @private
         * 获取此对象的 ArrayBuffer 引用。
         * @return
         */
        __getBuffer(): ArrayBuffer;
        /**
         * 写入字符串，该方法写的字符串要使用 readUTFBytes 方法读取。
         * @param value 要写入的字符串。
         */
        writeUTFBytes(value: string): void;
        /**
         * 将 UTF-8 字符串写入字节流。
         * @param	value 要写入的字符串值。
         */
        writeUTFString(value: string): void;
        /**
         * @private
         * 读取 UTF-8 字符串。
         * @return 读出的字符串。
         */
        readUTFString(): string;
        /**
         * 读取 UTF-8 字符串。
         * @return 读出的字符串。
         */
        getUTFString(): string;
        /**
         * @private
         * 读字符串，必须是 writeUTFBytes 方法写入的字符串。
         * @param len 要读的buffer长度,默认将读取缓冲区全部数据。
         * @return 读取的字符串。
         */
        readUTFBytes(len?: number): string;
        /**
         * 读字符串，必须是 writeUTFBytes 方法写入的字符串。
         * @param len 要读的buffer长度,默认将读取缓冲区全部数据。
         * @return 读取的字符串。
         */
        getUTFBytes(len?: number): string;
        /**
         * 在字节流中写入一个字节。
         * @param	value
         */
        writeByte(value: number): void;
        /**
         * @private
         * 在字节流中读一个字节。
         */
        readByte(): number;
        /**
         * 在字节流中读一个字节。
         */
        getByte(): number;
        /**
         * 指定该字节流的长度。
         * @param	lengthToEnsure 指定的长度。
         */
        ensureWrite(lengthToEnsure: number): void;
        /**
         * 写入指定的 Arraybuffer 对象。
         * @param	arraybuffer 需要写入的 Arraybuffer 对象。
         * @param	offset 偏移量（以字节为单位）
         * @param	length 长度（以字节为单位）
         */
        writeArrayBuffer(arraybuffer: any, offset?: number, length?: number): void;
    }
}
declare module laya.utils {
    /**
     * 对象缓存统一管理类
     */
    class CacheManger {
        /**
         * 单次清理检测允许执行的时间，单位ms
         */
        static loopTimeLimit: number;
        private static _cacheList;
        private static _index;
        constructor();
        /**
         * 注册cache管理函数
         * @param disposeFunction 释放函数 fun(force:Boolean)
         * @param getCacheListFunction 获取cache列表函数fun():Array
         *
         */
        static regCacheByFunction(disposeFunction: Function, getCacheListFunction: Function): void;
        /**
         * 移除cache管理函数
         * @param disposeFunction 释放函数 fun(force:Boolean)
         * @param getCacheListFunction 获取cache列表函数fun():Array
         *
         */
        static unRegCacheByFunction(disposeFunction: Function, getCacheListFunction: Function): void;
        /**
         * 强制清理所有管理器
         *
         */
        static forceDispose(): void;
        /**
         * 开始检测循环
         * @param waitTime 检测间隔时间
         *
         */
        static beginCheck(waitTime?: number): void;
        /**
         * 停止检测循环
         *
         */
        static stopCheck(): void;
    }
}
declare module laya.utils {
    /**
     * <code>ClassUtils</code> 是一个类工具类。
     */
    class ClassUtils {
        private static _temParam;
        static _classMap: any;
        /**
         * 注册 Class 映射。
         * @param	className 映射的名字，或者类名简写。
         * @param	classDef 类的全名或者类的引用，全名比如:"laya.display.Sprite"。
         */
        static regClass(className: string, classDef: any): void;
        /**
         * 返回注册 Class 映射。
         * @param	className 映射的名字。
         */
        static getRegClass(className: string): any;
        /**
         * 根据名字返回类对象。
         * @param	className 类名。
         * @return
         */
        static getClass: Function;
        /**
         * 根据名称创建 Class 实例。
         * @param	className 类名。
         * @return	返回类的实例。
         */
        static getInstance(className: string): any;
        /**
         * 根据指定的 json 数据创建节点对象。
         * 比如:
         *
         * 	"type":"Sprite",
         * 	"props":
         * 		"x":100,
         * 		"y":50,
         * 		"name":"item1",
         * 		"scale":[2,2]
         * 	},
         * 	"customProps":
         * 		"x":100,
         * 		"y":50,
         * 		"name":"item1",
         * 		"scale":[2,2]
         * 	},
         * 	"child":[
         *
         * 			"type":"Text",
         * 			"props":
         * 				"text":"this is a test",
         * 				"var":"label",
         * 				"rumtime":""
         * 			}
         * 		}
         * 	]
         * }
         * @param	json json字符串或者Object对象。
         * @param	node node节点，如果为空，则新创建一个。
         * @param	root 根节点，用来设置var定义。
         * @return	生成的节点。
         */
        static createByJson(json: any, node?: any, root?: laya.display.Node, customHandler?: Handler, instanceHandler?: Handler): any;
        /**
         * 将graphic对象添加到Sprite上
         * @param graphicO graphic对象描述
         * @param sprite
         *
         */
        static addGraphicsToSprite(graphicO: any, sprite: laya.display.Sprite): void;
        /**
         * 将graphic绘图指令添加到sprite上
         * @param graphicO 绘图指令描述
         * @param sprite
         *
         */
        static addGraphicToSprite(graphicO: any, sprite: laya.display.Sprite, isChild?: boolean): void;
        /**
         * @private
         */
        static isDrawType(type: string): boolean;
        private static _tM;
        private static _alpha;
        /**
         * @private
         */
        static _getPointListByStr(str: string): Array<any>;
    }
}
declare module laya.utils {
    /**
     * <code>Color</code> 是一个颜色值处理类。
     */
    class Color {
        static _SAVE: any;
        static _SAVE_SIZE: number;
        private static _COLOR_MAP;
        private static _DEFAULT;
        private static _COLODID;
        _color: Array<any>;
        /** 字符串型颜色值。*/
        strColor: string;
        /** uint 型颜色值。*/
        numColor: number;
        _drawStyle: any;
        /**
         * 根据指定的属性值，创建一个 <code>Color</code> 类的实例。
         * @param	str 颜色值。
         */
        constructor(str: any);
        static _initDefault(): any;
        static _initSaveMap(): void;
        /**
         * 根据指定的属性值，创建并返回一个 <code>Color</code> 类的实例。
         * @param	str 颜色值。
         * @return 一个 <code>Color</code> 类的实例。
         */
        static create(str: any): Color;
    }
}
declare module laya.utils {
    /**
     * <code>Dictionary</code> 是一个字典型的数据存取类。
     */
    class Dictionary {
        /**
         * 获取所有的子元素列表。
         */
        values: Array<any>;
        /**
         * 获取所有的子元素键名列表。
         */
        keys: Array<any>;
        /**
         * 给指定的键名设置值。
         * @param	key 键名。
         * @param	value 值。
         */
        set(key: any, value: any): void;
        /**
         * 获取指定对象的键名索引。
         * @param	key 键名对象。
         * @return 键名索引。
         */
        indexOf(key: any): number;
        /**
         * 返回指定键名的值。
         * @param	key 键名对象。
         * @return 指定键名的值。
         */
        get(key: any): any;
        /**
         * 移除指定键名的值。
         * @param	key 键名对象。
         * @return 是否成功移除。
         */
        remove(key: any): boolean;
        /**
         * 清除此对象的键名列表和键值列表。
         */
        clear(): void;
    }
}
declare module laya.utils {
    /**
     * <code>Dragging</code> 类是触摸滑动控件。
     */
    class Dragging {
        /** 被拖动的对象。*/
        target: laya.display.Sprite;
        /** 缓动衰减系数。*/
        ratio: number;
        /** 单帧最大偏移量。*/
        maxOffset: number;
        /** 滑动范围。*/
        area: laya.maths.Rectangle;
        /** 表示拖动是否有惯性。*/
        hasInertia: boolean;
        /** 橡皮筋最大值。*/
        elasticDistance: number;
        /** 橡皮筋回弹时间，单位为毫秒。*/
        elasticBackTime: number;
        /** 事件携带数据。*/
        data: any;
        /**
         * 开始拖拽。
         * @param	target 待拖拽的 <code>Sprite</code> 对象。
         * @param	area 滑动范围。
         * @param	hasInertia 拖动是否有惯性。
         * @param	elasticDistance 橡皮筋最大值。
         * @param	elasticBackTime 橡皮筋回弹时间，单位为毫秒。
         * @param	data 事件携带数据。
         * @param	disableMouseEvent 鼠标事件是否有效。
         * @param	ratio 惯性阻尼系数
         */
        start(target: laya.display.Sprite, area: laya.maths.Rectangle, hasInertia: boolean, elasticDistance: number, elasticBackTime: number, data: any, disableMouseEvent: boolean, ratio?: number): void;
        /**
         * 停止拖拽。
         */
        stop(): void;
    }
}
declare module laya.utils {
    /**
     * <code>Ease</code> 类定义了缓动函数，以便实现 <code>Tween</code> 动画的缓动效果。
     */
    class Ease {
        /**
         * 定义无加速持续运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static linearNone(t: number, b: number, c: number, d: number): number;
        /**
         * 定义无加速持续运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static linearIn(t: number, b: number, c: number, d: number): number;
        /**
         * 定义无加速持续运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static linearInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 定义无加速持续运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static linearOut(t: number, b: number, c: number, d: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * 它的运动是类似一个球落向地板又弹起后，几次逐渐减小的回弹运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static bounceIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * 它的运动是类似一个球落向地板又弹起后，几次逐渐减小的回弹运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static bounceInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * 它的运动是类似一个球落向地板又弹起后，几次逐渐减小的回弹运动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static bounceOut(t: number, b: number, c: number, d: number): number;
        /**
         * 开始时往后运动，然后反向朝目标移动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @param	s 指定过冲量，此处数值越大，过冲越大。
         * @return 指定时间的插补属性的值。
         */
        static backIn(t: number, b: number, c: number, d: number, s?: number): number;
        /**
         * 开始运动时是向后跟踪，再倒转方向并朝目标移动，稍微过冲目标，然后再次倒转方向，回来朝目标移动。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @param	s 指定过冲量，此处数值越大，过冲越大。
         * @return 指定时间的插补属性的值。
         */
        static backInOut(t: number, b: number, c: number, d: number, s?: number): number;
        /**
         * 开始运动时是朝目标移动，稍微过冲，再倒转方向回来朝着目标。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @param	s 指定过冲量，此处数值越大，过冲越大。
         * @return 指定时间的插补属性的值。
         */
        static backOut(t: number, b: number, c: number, d: number, s?: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * 其中的运动由按照指数方式衰减的正弦波来定义。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @param	a 指定正弦波的幅度。
         * @param	p 指定正弦波的周期。
         * @return 指定时间的插补属性的值。
         */
        static elasticIn(t: number, b: number, c: number, d: number, a?: number, p?: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * 其中的运动由按照指数方式衰减的正弦波来定义。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @param	a 指定正弦波的幅度。
         * @param	p 指定正弦波的周期。
         * @return 指定时间的插补属性的值。
         */
        static elasticInOut(t: number, b: number, c: number, d: number, a?: number, p?: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * 其中的运动由按照指数方式衰减的正弦波来定义。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @param	a 指定正弦波的幅度。
         * @param	p 指定正弦波的周期。
         * @return 指定时间的插补属性的值。
         */
        static elasticOut(t: number, b: number, c: number, d: number, a?: number, p?: number): number;
        /**
         * 以零速率开始运动，然后在执行时加快运动速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static strongIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static strongInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static strongOut(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * Sine 缓动方程中的运动加速度小于 Quad 方程中的运动加速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static sineInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以零速率开始运动，然后在执行时加快运动速度。
         * Sine 缓动方程中的运动加速度小于 Quad 方程中的运动加速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static sineIn(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * Sine 缓动方程中的运动加速度小于 Quad 方程中的运动加速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static sineOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以零速率开始运动，然后在执行时加快运动速度。
         * Quint 缓动方程的运动加速大于 Quart 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quintIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * Quint 缓动方程的运动加速大于 Quart 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quintInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * Quint 缓动方程的运动加速大于 Quart 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quintOut(t: number, b: number, c: number, d: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * Quart 缓动方程的运动加速大于 Cubic 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quartIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * Quart 缓动方程的运动加速大于 Cubic 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quartInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * Quart 缓动方程的运动加速大于 Cubic 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quartOut(t: number, b: number, c: number, d: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * Cubic 缓动方程的运动加速大于 Quad 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static cubicIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * Cubic 缓动方程的运动加速大于 Quad 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static cubicInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * Cubic 缓动方程的运动加速大于 Quad 缓动方程。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static cubicOut(t: number, b: number, c: number, d: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * Quad 缓动方程中的运动加速度等于 100% 缓动的时间轴补间的运动加速度，并且显著小于 Cubic 缓动方程中的运动加速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quadIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * Quad 缓动方程中的运动加速度等于 100% 缓动的时间轴补间的运动加速度，并且显著小于 Cubic 缓动方程中的运动加速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quadInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * Quad 缓动方程中的运动加速度等于 100% 缓动的时间轴补间的运动加速度，并且显著小于 Cubic 缓动方程中的运动加速度。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static quadOut(t: number, b: number, c: number, d: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * 其中每个时间间隔是剩余距离减去一个固定比例部分。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static expoIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * 其中每个时间间隔是剩余距离减去一个固定比例部分。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static expoInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * 其中每个时间间隔是剩余距离减去一个固定比例部分。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static expoOut(t: number, b: number, c: number, d: number): number;
        /**
         * 方法以零速率开始运动，然后在执行时加快运动速度。
         * 缓动方程的运动加速会产生突然的速率变化。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static circIn(t: number, b: number, c: number, d: number): number;
        /**
         * 开始运动时速率为零，先对运动进行加速，再减速直到速率为零。
         * 缓动方程的运动加速会产生突然的速率变化。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static circInOut(t: number, b: number, c: number, d: number): number;
        /**
         * 以较快速度开始运动，然后在执行时减慢运动速度，直至速率为零。
         * 缓动方程的运动加速会产生突然的速率变化。
         * @param	t 指定当前时间，介于 0 和持续时间之间（包括二者）。
         * @param	b 指定动画属性的初始值。
         * @param	c 指定动画属性的更改总计。
         * @param	d 指定运动的持续时间。
         * @return 指定时间的插补属性的值。
         */
        static circOut(t: number, b: number, c: number, d: number): number;
    }
}
declare module laya.utils {
    /**
     * <p><code>Handler</code> 是事件处理器类。</p>
     * <p>推荐使用 Handler.create() 方法从对象池创建，减少对象创建消耗。</p>
     * <p><b>注意：</b>由于鼠标事件也用本对象池，不正确的回收及调用，可能会影响鼠标事件的执行。</p>
     */
    class Handler {
        private static _pool;
        private static _gid;
        /** 执行域(this)。*/
        caller: any;
        /** 处理方法。*/
        method: Function;
        /** 参数。*/
        args: Array<any>;
        /** 表示是否只执行一次。如果为true，回调后执行recover()进行回收，回收后会被再利用，默认为false 。*/
        once: boolean;
        protected _id: number;
        /**
         * 根据指定的属性值，创建一个 <code>Handler</code> 类的实例。
         * @param	caller 执行域。
         * @param	method 处理函数。
         * @param	args 函数参数。
         * @param	once 是否只执行一次。
         */
        constructor(caller?: any, method?: Function, args?: Array<any>, once?: boolean);
        /**
         * 设置此对象的指定属性值。
         * @param	caller 执行域(this)。
         * @param	method 回调方法。
         * @param	args 携带的参数。
         * @param	once 是否只执行一次，如果为true，执行后执行recover()进行回收。
         * @return  返回 handler 本身。
         */
        setTo(caller: any, method: Function, args: Array<any>, once: boolean): Handler;
        /**
         * 执行处理器。
         */
        run(): any;
        /**
         * 执行处理器，携带额外数据。
         * @param	data 附加的回调数据，可以是单数据或者Array(作为多参)。
         */
        runWith(data: any): any;
        /**
         * 清理对象引用。
         */
        clear(): Handler;
        /**
         * 清理并回收到 Handler 对象池内。
         */
        recover(): void;
        /**
         * 从对象池内创建一个Handler，默认会执行一次并立即回收，如果不需要自动回收，设置once参数为false。
         * @param	caller 执行域(this)。
         * @param	method 回调方法。
         * @param	args 携带的参数。
         * @param	once 是否只执行一次，如果为true，回调后执行recover()进行回收，默认为true。
         * @return  返回创建的handler实例。
         */
        static create(caller: any, method: Function, args?: Array<any>, once?: boolean): Handler;
    }
}
declare module laya.utils {
    /**
     * 鼠标点击区域，可以设置绘制一系列矢量图作为点击区域和非点击区域（目前只支持圆形，矩形，多边形）
     */
    class HitArea {
        private static _cmds;
        private static _rec;
        private static _ptPoint;
        /**
         * 是否包含某个点
         * @param x x坐标
         * @param y y坐标
         * @return 是否点击到
         */
        isHit(x: number, y: number): boolean;
        /**
         * 检测对象是否包含指定的点。
         * @param	x	点的 X 轴坐标值（水平位置）。
         * @param	y	点的 Y 轴坐标值（垂直位置）。
         * @return	如果包含指定的点，则值为 true；否则为 false。
         */
        contains(x: number, y: number): boolean;
        /**
         * @private
         * 是否击中Graphic
         */
        static isHitGraphic(x: number, y: number, graphic: laya.display.Graphics): boolean;
        /**
         *  @private
         * 是否击中绘图指令
         */
        static isHitCmd(x: number, y: number, cmd: Array<any>): boolean;
        /**
         * @private
         * 坐标是否在多边形内
         */
        static ptInPolygon(x: number, y: number, areaPoints: Array<any>): boolean;
        /**
         * 可点击区域，可以设置绘制一系列矢量图作为点击区域（目前只支持圆形，矩形，多边形）
         */
        hit: laya.display.Graphics;
        /**
         * 不可点击区域，可以设置绘制一系列矢量图作为非点击区域（目前只支持圆形，矩形，多边形）
         */
        unHit: laya.display.Graphics;
    }
}
declare module laya.utils {
    /**
     * <code>HTMLChar</code> 是一个 HTML 字符类。
     */
    class HTMLChar implements laya.display.ILayout {
        private static _isWordRegExp;
        /** 表示是否是正常单词(英文|.|数字)。*/
        isWord: boolean;
        /** 字符。*/
        char: string;
        /** 字符数量。*/
        charNum: number;
        /** CSS 样式。*/
        style: laya.display.css.CSSStyle;
        /**
         * 根据指定的字符、宽高、样式，创建一个 <code>HTMLChar</code> 类的实例。
         * @param	char 字符。
         * @param	w 宽度。
         * @param	h 高度。
         * @param	style CSS 样式。
         */
        constructor(char: string, w: number, h: number, style: laya.display.css.CSSStyle);
        /**
         * 设置与此对象绑定的显示对象 <code>Sprite</code> 。
         * @param	sprite 显示对象 <code>Sprite</code> 。
         */
        setSprite(sprite: laya.display.Sprite): void;
        /**
         * 获取与此对象绑定的显示对象 <code>Sprite</code>。
         * @return
         */
        getSprite(): laya.display.Sprite;
        /**
         * 此对象存储的 X 轴坐标值。
         * 当设置此值时，如果此对象有绑定的 Sprite 对象，则改变 Sprite 对象的属性 x 的值。
         */
        x: number;
        /**
         * 此对象存储的 Y 轴坐标值。
         * 当设置此值时，如果此对象有绑定的 Sprite 对象，则改变 Sprite 对象的属性 y 的值。
         */
        y: number;
        /**
         * 宽度。
         */
        width: number;
        /**
         * 高度。
         */
        height: number;
        _isChar(): boolean;
        _getCSSStyle(): laya.display.css.CSSStyle;
    }
}
declare module laya.utils {
    /**
     * <code>Log</code> 类用于在界面内显示日志记录信息。
     */
    class Log {
        private static _logdiv;
        private static _count;
        /**最大打印数量，超过这个数量，则自动清理一次*/
        static maxCount: number;
        /**
         * 激活Log系统，使用方法Laya.init(800,600,Laya.Log);
         */
        static enable(): void;
        /**隐藏/显示日志面板*/
        static toggle(): void;
        /**
         * 增加日志内容。
         * @param	value 需要增加的日志内容。
         */
        static print(value: string): void;
        /**
         * 清理日志
         */
        static clear(): void;
    }
}
declare module laya.utils {
    /**
     * <code>Mouse</code> 类用于控制鼠标光标。
     */
    class Mouse {
        private static _style;
        private static _preCursor;
        constructor();
        /**
         * 设置鼠标样式
         * @param cursorStr
         * 例如auto move no-drop col-resize
         * all-scroll pointer not-allowed row-resize
         * crosshair progress e-resize ne-resize
         * default text n-resize nw-resize
         * help vertical-text s-resize se-resize
         * inherit wait w-resize sw-resize
         *
         */
        static cursor: string;
        /**
         * 隐藏鼠标
         *
         */
        static hide(): void;
        /**
         * 显示鼠标
         *
         */
        static show(): void;
    }
}
declare module laya.utils {
    /**
     * <code>Pool</code> 是对象池类，用于对象的存贮、重复使用。
     */
    class Pool {
        private static _poolDic;
        /**
         * 根据对象类型标识字符，获取对象池。
         * @param sign 对象类型标识字符。
         * @return 对象池。
         */
        static getPoolBySign(sign: string): Array<any>;
        /**
         * 清除对象池的对象。
         * @param sign 对象类型标识字符。
         */
        static clearBySign(sign: string): void;
        /**
         * 将对象放到对应类型标识的对象池中。
         * @param sign 对象类型标识字符。
         * @param item 对象。
         */
        static recover(sign: string, item: any): void;
        /**
         * 根据传入的对象类型标识字符，获取对象池中此类型标识的一个对象实例。
         * 当对象池中无此类型标识的对象时，则根据传入的类型，创建一个新的对象返回。
         * @param sign 对象类型标识字符。
         * @param cls 用于创建该类型对象的类。
         * @return 此类型标识的一个对象。
         */
        static getItemByClass(sign: string, cls: any): any;
        /**
         * 根据传入的对象类型标识字符，获取对象池中此类型标识的一个对象实例。
         * 当对象池中无此类型标识的对象时，则使用传入的创建此类型对象的函数，新建一个对象返回。
         * @param sign 对象类型标识字符。
         * @param createFun 用于创建该类型对象的方法。
         * @return 此类型标识的一个对象。
         */
        static getItemByCreateFun(sign: string, createFun: Function): any;
        /**
         * 根据传入的对象类型标识字符，获取对象池中已存储的此类型的一个对象，如果对象池中无此类型的对象，则返回 null 。
         * @param sign 对象类型标识字符。
         * @return 对象池中此类型的一个对象，如果对象池中无此类型的对象，则返回 null 。
         */
        static getItem(sign: string): any;
    }
}
declare module laya.utils {
    /**
     * 基于个数的对象缓存管理器
     */
    class PoolCache {
        /**
         * 对象在Pool中的标识
         */
        sign: string;
        /**
         * 允许缓存的最大数量
         */
        maxCount: number;
        /**
         * 获取缓存的对象列表
         * @return
         *
         */
        getCacheList(): Array<any>;
        /**
         * 尝试清理缓存
         * @param force 是否强制清理
         *
         */
        tryDispose(force: boolean): void;
        /**
         * 添加对象缓存管理
         * @param sign 对象在Pool中的标识
         * @param maxCount 允许缓存的最大数量
         *
         */
        static addPoolCacheManager(sign: string, maxCount?: number): void;
    }
}
declare module laya.utils {
    /**
     * @private
     */
    class RunDriver {
        /**
         * 滤镜动作集。
         */
        static FILTER_ACTIONS: Array<any>;
        private static pixelRatio;
        private static _charSizeTestDiv;
        static now: Function;
        static getWindow: Function;
        static getPixelRatio: Function;
        static getIncludeStr: Function;
        static createShaderCondition: Function;
        private static hanzi;
        private static fontMap;
        static measureText: Function;
        /**
         * @private
         */
        static getWebGLContext: Function;
        /**
         * 开始函数。
         */
        static beginFlush: Function;
        static endFinish: Function;
        /**
         * 添加至图集的处理函数。
         */
        static addToAtlas: Function;
        static flashFlushImage: Function;
        /**
         * 绘制到画布。
         */
        static drawToCanvas: Function;
        /**
         * 创建2D例子模型的处理函数。
         */
        static createParticleTemplate2D: Function;
        /**
         * 用于创建 WebGL 纹理。
         */
        static createGLTextur: Function;
        /**
         * 用于创建 WebGLContext2D 对象。
         */
        static createWebGLContext2D: Function;
        /**
         * 用于改变 WebGL宽高信息。
         */
        static changeWebGLSize: Function;
        /**
         * 用于创建 RenderSprite 对象。
         */
        static createRenderSprite: Function;
        /**
         * 用于创建滤镜动作。
         */
        static createFilterAction: Function;
        /**
         * 用于创建 Graphics 对象。
         */
        static createGraphics: Function;
        static clear: Function;
        /**
         * 清空纹理函数。
         */
        static clearAtlas: Function;
        static addTextureToAtlas: Function;
        static getTexturePixels: Function;
        static skinAniSprite: Function;
    }
}
declare module laya.utils {
    /**
     * <code>Stat</code> 用于显示帧率统计信息。
     */
    class Stat {
        /** 每秒帧数。*/
        static FPS: number;
        /**主舞台 <code>Stage</code> 渲染次数计数。 */
        static loopCount: number;
        /** 着色器请求次数。*/
        static shaderCall: number;
        /** 描绘次数。*/
        static drawCall: number;
        /** 三角形面数。*/
        static trianglesFaces: number;
        /** 精灵<code>Sprite</code> 的数量。*/
        static spriteCount: number;
        /** 八叉树节点检测次数。*/
        static treeNodeCollision: number;
        /** 八叉树精灵碰撞检测次数。*/
        static treeSpriteCollision: number;
        /** 画布 canvas 使用标准渲染的次数。*/
        static canvasNormal: number;
        /** 画布 canvas 使用位图渲染的次数。*/
        static canvasBitmap: number;
        /** 画布 canvas 缓冲区重绘次数。*/
        static canvasReCache: number;
        /** 表示当前使用的是否为慢渲染模式。*/
        static renderSlow: boolean;
        /** 资源管理器所管理资源的累计内存,以字节为单位。*/
        static currentMemorySize: number;
        private static _fpsStr;
        private static _canvasStr;
        private static _canvas;
        private static _ctx;
        private static _timer;
        private static _count;
        private static _width;
        private static _height;
        private static _view;
        private static _fontSize;
        private static _first;
        private static _vx;
        /**
         * 显示帧频信息。
         * @param	x X轴显示位置。
         * @param	y Y轴显示位置。
         */
        static show(x?: number, y?: number): void;
        /**激活帧率统计*/
        static enable(): void;
        /**
         * 隐藏帧频信息。
         */
        static hide(): void;
        /**
         * @private
         * 清除帧频计算相关的数据。
         */
        static clear(): void;
        /**
         * 点击帧频显示区域的处理函数。
         */
        static onclick: Function;
        /**
         * @private
         * 帧频计算循环处理函数。
         */
        static loop(): void;
    }
}
declare module laya.utils {
    /**
     * <code>StringKey</code> 类用于存取字符串对应的数字。
     */
    class StringKey {
        /**
         * 添加一个字符。
         * @param	str 字符，将作为key 存储相应生成的数字。
         * @return 此字符对应的数字。
         */
        add(str: string): number;
        /**
         * 获取指定字符对应的ID。
         * @param	str 字符。
         * @return 此字符对应的ID。
         */
        getID(str: string): number;
        /**
         * 根据指定ID获取对应字符。
         * @param  id ID。
         * @return 此id对应的字符。
         */
        getName(id: number): string;
    }
}
declare module laya.utils {
    /**
     * <code>TimeLine</code> 是一个用来创建时间轴动画的类。
     */
    class TimeLine extends laya.events.EventDispatcher {
        /** 缩放动画播放的速度。*/
        scale: number;
        /**
         * 控制一个对象，从当前点移动到目标点。
         * @param	target		要控制的对象。
         * @param	props		要控制对象的属性。
         * @param	duration	对象TWEEN的时间。
         * @param	ease		缓动类型
         * @param	offset		相对于上一个对象，偏移多长时间（单位：毫秒）。
         */
        static to(target: any, props: any, duration: number, ease?: Function, offset?: number): TimeLine;
        /**
         * 从 props 属性，缓动到当前状态。
         * @param	target		target 目标对象(即将更改属性值的对象)
         * @param	props		要控制对象的属性
         * @param	duration	对象TWEEN的时间
         * @param	ease		缓动类型
         * @param	offset		相对于上一个对象，偏移多长时间（单位：毫秒）
         */
        static from(target: any, props: any, duration: number, ease?: Function, offset?: number): TimeLine;
        /**
         * 控制一个对象，从当前点移动到目标点。
         * @param	target		要控制的对象。
         * @param	props		要控制对象的属性。
         * @param	duration	对象TWEEN的时间。
         * @param	ease		缓动类型
         * @param	offset		相对于上一个对象，偏移多长时间（单位：毫秒）。
         */
        to(target: any, props: any, duration: number, ease?: Function, offset?: number): TimeLine;
        /**
         * 从 props 属性，缓动到当前状态。
         * @param	target		target 目标对象(即将更改属性值的对象)
         * @param	props		要控制对象的属性
         * @param	duration	对象TWEEN的时间
         * @param	ease		缓动类型
         * @param	offset		相对于上一个对象，偏移多长时间（单位：毫秒）
         */
        from(target: any, props: any, duration: number, ease?: Function, offset?: number): TimeLine;
        /**
         * 在时间队列中加入一个标签。
         * @param	label	标签名称。
         * @param	offset	标签相对于上个动画的偏移时间(单位：毫秒)。
         */
        addLabel(label: string, offset: number): TimeLine;
        /**
         * 移除指定的标签
         * @param	label
         */
        removeLabel(label: string): void;
        /**
         * 动画从整个动画的某一时间开始。
         * @param	time(单位：毫秒)。
         */
        gotoTime(time: number): void;
        /**
         * 从指定的标签开始播。
         * @param	Label 标签名。
         */
        gotoLabel(Label: string): void;
        /**
         * 暂停整个动画。
         */
        pause(): void;
        /**
         * 恢复暂停动画的播放。
         */
        resume(): void;
        /**
         * 播放动画。
         * @param	timeOrLabel 开启播放的时间点或标签名。
         * @param	loop 是否循环播放。
         */
        play(timeOrLabel?: any, loop?: boolean): void;
        /**
         * @private
         * 得到帧索引
         */
        /**
         * @private
         * 设置帧索引
         */
        index: number;
        /**
         * 得到总帧数据
         */
        total: number;
        /**
         * 重置所有对象，复用对象的时候使用。
         */
        reset(): void;
        /**
         * 彻底销毁此对象。
         */
        destroy(): void;
    }
    class tweenData {
        type: number;
        isTo: boolean;
        startTime: number;
        endTime: number;
        target: any;
        duration: number;
        ease: Function;
        data: any;
    }
}
declare module laya.utils {
    /**
     * <code>Timer</code> 是时钟管理类。它是一个单例，可以通过 Laya.timer 访问。
     */
    class Timer {
        private static _pool;
        /** 时针缩放。*/
        scale: number;
        /** 当前时间。*/
        currTimer: number;
        /** 当前的帧数。*/
        currFrame: number;
        /**
         *两帧之间的时间间隔,单位毫秒。
         */
        delta: number;
        /**
         * 创建 <code>Timer</code> 类的一个实例。
         */
        constructor();
        /**
         * @private
         * 帧循环处理函数。
         */
        _update(): void;
        _create(useFrame: boolean, repeat: boolean, delay: number, caller: any, method: Function, args: Array<any>, coverBefore: boolean): void;
        /**
         * 定时执行一次。
         * @param	delay	延迟时间(单位为毫秒)。
         * @param	caller	执行域(this)。
         * @param	method	定时器回调函数。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
         */
        once(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时重复执行。
         * @param	delay	间隔时间(单位毫秒)。
         * @param	caller	执行域(this)。
         * @param	method	定时器回调函数。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
         */
        loop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行一次(基于帧率)。
         * @param	delay	延迟几帧(单位为帧)。
         * @param	caller	执行域(this)。
         * @param	method	定时器回调函数。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
         */
        frameOnce(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时重复执行(基于帧率)。
         * @param	delay	间隔几帧(单位为帧)。
         * @param	caller	执行域(this)。
         * @param	method	定时器回调函数。
         * @param	args	回调参数。
         * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
         */
        frameLoop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /** 返回统计信息。*/
        toString(): string;
        /**
         * 清理定时器。
         * @param	caller 执行域(this)。
         * @param	method 定时器回调函数。
         */
        clear(caller: any, method: Function): void;
        /**
         * 清理对象身上的所有定时器。
         * @param	caller 执行域(this)。
         */
        clearAll(caller: any): void;
        /**
         * 延迟执行。
         * @param	caller 执行域(this)。
         * @param	method 定时器回调函数。
         * @param	args 回调参数。
         */
        callLater(caller: any, method: Function, args?: Array<any>): void;
        /**
         * 立即执行 callLater 。
         * @param	caller 执行域(this)。
         * @param	method 定时器回调函数。
         */
        runCallLater(caller: any, method: Function): void;
        /**
         * 立即提前执行定时器，执行之后从队列中删除
         * @param	caller 执行域(this)。
         * @param	method 定时器回调函数。
         */
        runTimer(caller: any, method: Function): void;
    }
    class TimerHandler {
        key: number;
        repeat: boolean;
        delay: number;
        userFrame: boolean;
        exeTime: number;
        caller: any;
        method: Function;
        args: Array<any>;
        clear(): void;
        run(withClear: boolean): void;
    }
}
declare module laya.utils {
    /**
     * <code>Tween</code>  是一个缓动类。使用实现目标对象属性的渐变。
     */
    class Tween {
        gid: number;
        /**更新回调，缓动数值发生变化时，回调变化的值*/
        update: Handler;
        /**
         * 缓动对象的props属性到目标值。
         * @param	target 目标对象(即将更改属性值的对象)。
         * @param	props 变化的属性列表，比如
         * @param	duration 花费的时间，单位毫秒。
         * @param	ease 缓动类型，默认为匀速运动。
         * @param	complete 结束回调函数。
         * @param	delay 延迟执行时间。
         * @param	coverBefore 是否覆盖之前的缓动。
         * @param	autoRecover 是否自动回收，默认为true，缓动结束之后自动回收到对象池。
         * @return	返回Tween对象。
         */
        static to(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean, autoRecover?: boolean): Tween;
        /**
         * 从props属性，缓动到当前状态。
         * @param	target 目标对象(即将更改属性值的对象)。
         * @param	props 变化的属性列表，比如
         * @param	duration 花费的时间，单位毫秒。
         * @param	ease 缓动类型，默认为匀速运动。
         * @param	complete 结束回调函数。
         * @param	delay 延迟执行时间。
         * @param	coverBefore 是否覆盖之前的缓动。
         * @param	autoRecover 是否自动回收，默认为true，缓动结束之后自动回收到对象池。
         * @return	返回Tween对象。
         */
        static from(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean, autoRecover?: boolean): Tween;
        /**
         * 缓动对象的props属性到目标值。
         * @param	target 目标对象(即将更改属性值的对象)。
         * @param	props 变化的属性列表，比如
         * @param	duration 花费的时间，单位毫秒。
         * @param	ease 缓动类型，默认为匀速运动。
         * @param	complete 结束回调函数。
         * @param	delay 延迟执行时间。
         * @param	coverBefore 是否覆盖之前的缓动。
         * @return	返回Tween对象。
         */
        to(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean): Tween;
        /**
         * 从props属性，缓动到当前状态。
         * @param	target 目标对象(即将更改属性值的对象)。
         * @param	props 变化的属性列表，比如
         * @param	duration 花费的时间，单位毫秒。
         * @param	ease 缓动类型，默认为匀速运动。
         * @param	complete 结束回调函数。
         * @param	delay 延迟执行时间。
         * @param	coverBefore 是否覆盖之前的缓动。
         * @return	返回Tween对象。
         */
        from(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean): Tween;
        _create(target: any, props: any, duration: number, ease: Function, complete: Handler, delay: number, coverBefore: boolean, isTo: boolean, usePool: boolean, runNow: boolean): Tween;
        _updateEase(time: number): void;
        /**设置当前执行比例**/
        progress: number;
        /**
         * 立即结束缓动并到终点。
         */
        complete(): void;
        /**
         * 暂停缓动，可以通过resume或restart重新开始。
         */
        pause(): void;
        /**
         * 设置开始时间。
         * @param	startTime 开始时间。
         */
        setStartTime(startTime: number): void;
        /**
         * 清理指定目标对象上的所有缓动。
         * @param	target 目标对象。
         */
        static clearAll(target: any): void;
        /**
         * 清理某个缓动。
         * @param	tween 缓动对象。
         */
        static clear(tween: Tween): void;
        static clearTween(target: any): void;
        /**
         * 停止并清理当前缓动。
         */
        clear(): void;
        /**
         * @private
         */
        _clear(): void;
        /** 回收到对象池。*/
        recover(): void;
        /**
         * 重新开始暂停的缓动。
         */
        restart(): void;
        /**
         * 恢复暂停的缓动。
         */
        resume(): void;
    }
}
declare module laya.utils {
    /**
     * <code>Utils</code> 是工具类。
     */
    class Utils {
        private static _gid;
        private static _pi;
        private static _pi2;
        protected static _extReg: RegExp;
        /**
         * 角度转弧度。
         * @param	angle 角度值。
         * @return	返回弧度值。
         */
        static toRadian(angle: number): number;
        /**
         * 弧度转换为角度。
         * @param	radian 弧度值。
         * @return	返回角度值。
         */
        static toAngle(radian: number): number;
        /**
         * 将传入的 uint 类型颜色值转换为字符串型颜色值。
         * @param color 颜色值。
         * @return 字符串型颜色值。
         */
        static toHexColor(color: number): string;
        /**获取一个全局唯一ID。*/
        static getGID(): number;
        /**
         * 将字符串解析成 XML 对象。
         * @param value 需要解析的字符串。
         * @return js原生的XML对象。
         */
        static parseXMLFromString: Function;
        /**
         * @private
         * <p>连接数组。和array的concat相比，此方法不创建新对象</p>
         * <b>注意：</b>若 参数 a 不为空，则会改变参数 source 的值为连接后的数组。
         * @param	source 待连接的数组目标对象。
         * @param	array 待连接的数组对象。
         * @return 连接后的数组。
         */
        static concatArray(source: Array<any>, array: Array<any>): Array<any>;
        /**
         * @private
         * 清空数组对象。
         * @param	array 数组。
         * @return	清空后的 array 对象。
         */
        static clearArray(array: Array<any>): Array<any>;
        /**
         * @private
         * 清空source数组，复制array数组的值。
         * @param	source 需要赋值的数组。
         * @param	array 新的数组值。
         * @return 	复制后的数据 source 。
         */
        static copyArray(source: Array<any>, array: Array<any>): Array<any>;
        /**
         * @private
         * 根据传入的显示对象 <code>Sprite</code> 和此显示对象上的 两个点，返回此对象上的两个点在舞台坐标系上组成的最小的矩形区域对象。
         * @param	sprite 显示对象 <code>Sprite</code>。
         * @param	x0	点一的 X 轴坐标点。
         * @param	y0	点一的 Y 轴坐标点。
         * @param	x1	点二的 X 轴坐标点。
         * @param	y1	点二的 Y 轴坐标点。
         * @return 两个点在舞台坐标系组成的矩形对象 <code>Rectangle</code>。
         */
        static getGlobalRecByPoints(sprite: laya.display.Sprite, x0: number, y0: number, x1: number, y1: number): laya.maths.Rectangle;
        /**
         * 计算传入的显示对象 <code>Sprite</code> 的全局坐标系的坐标和缩放值，返回 <code>Rectangle</code> 对象存放计算出的坐标X值、Y值、ScaleX值、ScaleY值。
         * @param	sprite <code>Sprite</code> 对象。
         * @return  矩形对象 <code>Rectangle</code>
         */
        static getGlobalPosAndScale(sprite: laya.display.Sprite): laya.maths.Rectangle;
        /**
         * 给传入的函数绑定作用域，返回绑定后的函数。
         * @param	fun 函数对象。
         * @param	scope 函数作用域。
         * @return 绑定后的函数。
         */
        static bind(fun: Function, scope: any): Function;
        /**
         * 测量文本在指定样式下的宽度、高度信息。
         * @param	txt 文本内容。
         * @param	font 文本字体样式。
         * @return 文本的宽高信息对象。如：
         */
        static measureText(txt: string, font: string): any;
        /**
         * @private
         * 对传入的数组列表，根据子项的属性 Z 值进行重新排序。返回是否已重新排序的 Boolean 值。
         * @param	array 子对象数组。
         * @return	Boolean 值，表示是否已重新排序。
         */
        static updateOrder(array: Array<any>): boolean;
        /**
         * @private
         * 批量移动点坐标。
         * @param points 坐标列表。
         * @param x x轴偏移量。
         * @param y y轴偏移量。
         */
        static transPointList(points: Array<any>, x: number, y: number): void;
        /**
         * 解析一个字符串，并返回一个整数。和JS原生的parseInt不同：如果str为空或者非数字，原生返回NaN，这里返回0
         * @param	str 要被解析的字符串
         * @param	radix 表示要解析的数字的基数。该值介于 2 ~ 36 之间。如果它以 “0x” 或 “0X” 开头，将以 16 为基数。如果该参数小于 2 或者大于 36，则 parseInt() 将返回 NaN。
         * @return	返回解析后的数字
         */
        static parseInt(str: string, radix?: number): number;
        static getFileExtension(path: string): string;
    }
}
declare module laya.utils {
    /**
     * @private
     */
    class VectorGraphManager {
        static instance: VectorGraphManager;
        useDic: any;
        shapeDic: any;
        shapeLineDic: any;
        constructor();
        static getInstance(): VectorGraphManager;
        /**
         * 得到个空闲的ID
         * @return
         */
        getId(): number;
        /**
         * 添加一个图形到列表中
         * @param	id
         * @param	shape
         */
        addShape(id: number, shape: any): void;
        /**
         * 添加一个线图形到列表中
         * @param	id
         * @param	Line
         */
        addLine(id: number, Line: any): void;
        /**
         * 检测一个对象是否在使用中
         * @param	id
         */
        getShape(id: number): void;
        /**
         * 删除一个图形对象
         * @param	id
         */
        deleteShape(id: number): void;
        /**
         * 得到缓存列表
         * @return
         */
        getCacheList(): Array<any>;
        /**
         * 开始清理状态，准备销毁
         */
        startDispose(key: boolean): void;
        /**
         * 确认销毁
         */
        endDispose(): void;
    }
}
declare module laya.utils {
    /**
     * @private
     */
    class WordText {
        id: number;
        save: Array<any>;
        toUpperCase: string;
        changed: boolean;
        setText(txt: string): void;
        toString(): string;
        length: number;
        charCodeAt(i: number): number;
        charAt(i: number): string;
    }
}
declare module laya.webgl.atlas {
    class Atlaser extends AtlasGrid {
        texture: AtlasWebGLCanvas;
        inAtlasWebGLImagesKey: Array<any>;
        InAtlasWebGLImagesOffsetValue: Array<any>;
        constructor(gridNumX: number, gridNumY: number, width: number, height: number, atlasID: number);
        /**
         *
         * @param	inAtlasRes
         * @return  是否已经存在队列中
         */
        addToAtlasTexture(mergeAtlasBitmap: laya.webgl.resource.IMergeAtlasBitmap, offsetX: number, offsetY: number): void;
        addToAtlas(texture: laya.resource.Texture, offsetX: number, offsetY: number): void;
        clear(): void;
        dispose(): void;
    }
}
declare module laya.webgl.atlas {
    class AtlasGrid {
        _atlasID: number;
        constructor(width?: number, height?: number, atlasID?: number);
        getAltasID(): number;
        setAltasID(atlasID: number): void;
        addTex(type: number, width: number, height: number): MergeFillInfo;
    }
    class TexRowInfo {
        spaceCount: number;
    }
    class TexMergeTexSize {
        width: number;
        height: number;
    }
}
declare module laya.webgl.atlas {
    class AtlasResourceManager {
        private static _enabled;
        private static _atlasLimitWidth;
        private static _atlasLimitHeight;
        static gridSize: number;
        static atlasTextureWidth: number;
        static atlasTextureHeight: number;
        static maxTextureCount: number;
        static _atlasRestore: number;
        static BOARDER_TYPE_NO: number;
        static BOARDER_TYPE_RIGHT: number;
        static BOARDER_TYPE_LEFT: number;
        static BOARDER_TYPE_BOTTOM: number;
        static BOARDER_TYPE_TOP: number;
        static BOARDER_TYPE_ALL: number;
        private static _sid_;
        private static _Instance;
        static instance: AtlasResourceManager;
        static enabled: boolean;
        static atlasLimitWidth: number;
        static atlasLimitHeight: number;
        static _enable(): void;
        static _disable(): void;
        static __init__(): void;
        constructor(width: number, height: number, gridSize: number, maxTexNum: number);
        setAtlasParam(width: number, height: number, gridSize: number, maxTexNum: number): boolean;
        pushData(texture: laya.resource.Texture): boolean;
        addToAtlas(tex: laya.resource.Texture): void;
        /**
         * 回收大图合集,不建议手动调用
         * @return
         */
        garbageCollection(): boolean;
        freeAll(): void;
        getAtlaserCount(): number;
        getAtlaserByIndex(index: number): Atlaser;
    }
}
declare module laya.webgl.atlas {
    class AtlasWebGLCanvas extends laya.resource.Bitmap {
        /***
         * 设置图片宽度
         * @param value 图片宽度
         */
        width: number;
        /***
         * 设置图片高度
         * @param value 图片高度
         */
        height: number;
        constructor();
        /**兼容Stage3D使用*/
        _flashCacheImage: laya.webgl.resource.WebGLImage;
        _flashCacheImageNeedFlush: boolean;
        protected recreateResource(): void;
        protected detoryResource(): void;
        /**采样image到WebGLTexture的一部分*/
        texSubImage2D(xoffset: number, yoffset: number, bitmap: any): void;
        /**采样image到WebGLTexture的一部分*/
        texSubImage2DPixel(xoffset: number, yoffset: number, width: number, height: number, pixel: any): void;
    }
}
declare module laya.webgl.atlas {
    class MergeFillInfo {
        x: number;
        y: number;
        ret: boolean;
        constructor();
    }
}
declare module laya.webgl.canvas {
    class BlendMode {
        static activeBlendFunction: Function;
        static NAMES: Array<any>;
        static TOINT: any;
        static NORMAL: string;
        static ADD: string;
        static MULTIPLY: string;
        static SCREEN: string;
        static LIGHT: string;
        static OVERLAY: string;
        static DESTINATIONOUT: string;
        static fns: Array<any>;
        static targetFns: Array<any>;
        static _init_(gl: laya.webgl.WebGLContext): void;
        static BlendNormal(gl: laya.webgl.WebGLContext): void;
        static BlendAdd(gl: laya.webgl.WebGLContext): void;
        static BlendMultiply(gl: laya.webgl.WebGLContext): void;
        static BlendScreen(gl: laya.webgl.WebGLContext): void;
        static BlendOverlay(gl: laya.webgl.WebGLContext): void;
        static BlendLight(gl: laya.webgl.WebGLContext): void;
        static BlendNormalTarget(gl: laya.webgl.WebGLContext): void;
        static BlendAddTarget(gl: laya.webgl.WebGLContext): void;
        static BlendMultiplyTarget(gl: laya.webgl.WebGLContext): void;
        static BlendScreenTarget(gl: laya.webgl.WebGLContext): void;
        static BlendOverlayTarget(gl: laya.webgl.WebGLContext): void;
        static BlendLightTarget(gl: laya.webgl.WebGLContext): void;
        static BlendMask(gl: laya.webgl.WebGLContext): void;
        static BlendDestinationOut(gl: laya.webgl.WebGLContext): void;
    }
}
declare module laya.webgl.canvas {
    class DrawStyle {
        static DEFAULT: DrawStyle;
        _color: laya.utils.Color;
        static create(value: any): DrawStyle;
        constructor(value: any);
        setValue(value: any): void;
        reset(): void;
        equal(value: any): boolean;
        toColorStr(): string;
    }
}
declare module laya.webgl.canvas {
    class Path {
        _x: number;
        _y: number;
        _rect: laya.maths.Rectangle;
        ib: laya.webgl.utils.IndexBuffer2D;
        vb: laya.webgl.utils.VertexBuffer2D;
        dirty: boolean;
        geomatrys: Array<any>;
        _curGeomatry: laya.webgl.shapes.IShape;
        offset: number;
        count: number;
        tempArray: Array<any>;
        closePath: boolean;
        constructor();
        addPoint(pointX: number, pointY: number): void;
        getEndPointX(): number;
        getEndPointY(): number;
        polygon(x: number, y: number, points: Array<any>, color: number, borderWidth: number, borderColor: any): laya.webgl.shapes.IShape;
        setGeomtry(shape: laya.webgl.shapes.IShape): void;
        drawLine(x: number, y: number, points: Array<any>, width: number, color: number): laya.webgl.shapes.IShape;
        update(): void;
        reset(): void;
    }
}
declare module laya.webgl.canvas.save {
    interface ISaveData {
    }
}
declare module laya.webgl.canvas.save {
    class SaveBase implements ISaveData {
        static TYPE_ALPHA: number;
        static TYPE_FILESTYLE: number;
        static TYPE_FONT: number;
        static TYPE_LINEWIDTH: number;
        static TYPE_STROKESTYLE: number;
        static TYPE_MARK: number;
        static TYPE_TRANSFORM: number;
        static TYPE_TRANSLATE: number;
        static TYPE_ENABLEMERGE: number;
        static TYPE_TEXTBASELINE: number;
        static TYPE_TEXTALIGN: number;
        static TYPE_GLOBALCOMPOSITEOPERATION: number;
        static TYPE_CLIPRECT: number;
        static TYPE_IBVB: number;
        static TYPE_SHADER: number;
        static TYPE_FILTERS: number;
        static TYPE_FILTERS_TYPE: number;
        private static _cache;
        private static _namemap;
        static _createArray(): Array<any>;
        static _init(): any;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D, type: number, dataObj: any, newSubmit: boolean): void;
    }
}
declare module laya.webgl.canvas.save {
    class SaveClipRect implements ISaveData {
        private static _cache;
        _clipSaveRect: laya.maths.Rectangle;
        _clipRect: laya.maths.Rectangle;
        _submitScissor: laya.webgl.submit.SubmitScissor;
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D, submitScissor: laya.webgl.submit.SubmitScissor): void;
    }
}
declare module laya.webgl.canvas.save {
    class SaveMark implements ISaveData {
        private static _no;
        _saveuse: number;
        _preSaveMark: SaveMark;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static Create(context: laya.webgl.canvas.WebGLContext2D): SaveMark;
    }
}
declare module laya.webgl.canvas.save {
    class SaveTransform implements ISaveData {
        private static _no;
        _savematrix: laya.maths.Matrix;
        _matrix: laya.maths.Matrix;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D): void;
    }
}
declare module laya.webgl.canvas.save {
    class SaveTranslate implements ISaveData {
        private static _no;
        _x: number;
        _y: number;
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D): void;
    }
}
declare module laya.webgl.canvas {
    class WebGLContext2D extends laya.resource.Context {
        static _SUBMITVBSIZE: number;
        static _MAXSIZE: number;
        static _RECTVBSIZE: number;
        static MAXCLIPRECT: laya.maths.Rectangle;
        static _COUNT: number;
        static _tmpMatrix: laya.maths.Matrix;
        private static _fontTemp;
        private static _drawStyleTemp;
        static __init__(): void;
        _x: number;
        _y: number;
        _id: number;
        _submits: any;
        _curSubmit: any;
        _ib: laya.webgl.utils.IndexBuffer2D;
        _vb: laya.webgl.utils.VertexBuffer2D;
        _clipRect: laya.maths.Rectangle;
        _curMat: laya.maths.Matrix;
        _nBlendType: number;
        _save: any;
        _targets: laya.webgl.resource.RenderTargetMAX;
        _renderKey: number;
        _saveMark: laya.webgl.canvas.save.SaveMark;
        _shader2D: laya.webgl.shader.d2.Shader2D;
        /**所cacheAs精灵*/
        sprite: laya.display.Sprite;
        constructor(c: laya.resource.HTMLCanvas);
        setIsMainContext(): void;
        clearBG(r: number, g: number, b: number, a: number): void;
        _getSubmits(): Array<any>;
        destroy(): void;
        clear(): void;
        size(w: number, h: number): void;
        asBitmap: boolean;
        _getTransformMatrix(): laya.maths.Matrix;
        fillStyle: any;
        globalAlpha: number;
        textAlign: string;
        textBaseline: string;
        globalCompositeOperation: string;
        strokeStyle: any;
        translate(x: number, y: number): void;
        lineWidth: number;
        save(): void;
        restore(): void;
        font: string;
        fillWords(words: Array<any>, x: number, y: number, fontStr: string, color: string): void;
        fillText(txt: any, x: number, y: number, fontStr: string, color: string, textAlign: string): void;
        strokeText(txt: any, x: number, y: number, fontStr: string, color: string, lineWidth: number, textAlign: string): void;
        fillBorderText(txt: any, x: number, y: number, fontStr: string, fillColor: string, borderColor: string, lineWidth: number, textAlign: string): void;
        fillBorderWords(words: Array<any>, x: number, y: number, font: string, color: string, borderColor: string, lineWidth: number): void;
        fillRect(x: number, y: number, width: number, height: number, fillStyle: any): void;
        fillTexture(texture: laya.resource.Texture, x: number, y: number, width: number, height: number, type: string, offset: laya.maths.Point, other: any): void;
        setShader(shader: laya.webgl.shader.Shader): void;
        setFilters(value: Array<any>): void;
        drawTexture(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, tx: number, ty: number): void;
        addTextureVb(invb: Array<any>, x: number, y: number): void;
        willDrawTexture(tex: laya.resource.Texture, alpha: number): number;
        drawTextures(tex: laya.resource.Texture, pos: Array<any>, tx: number, ty: number): void;
        _drawText(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, m: laya.maths.Matrix, tx: number, ty: number, dx: number, dy: number): void;
        drawTextureWithTransform(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, transform: laya.maths.Matrix, tx: number, ty: number, alpha: number): void;
        fillQuadrangle(tex: laya.resource.Texture, x: number, y: number, point4: Array<any>, m: laya.maths.Matrix): void;
        drawTexture2(x: number, y: number, pivotX: number, pivotY: number, transform: laya.maths.Matrix, alpha: number, blendMode: string, args: Array<any>): void;
        drawCanvas(canvas: laya.resource.HTMLCanvas, x: number, y: number, width: number, height: number): void;
        drawTarget(scope: any, x: number, y: number, width: number, height: number, m: laya.maths.Matrix, proName: string, shaderValue: laya.webgl.shader.d2.value.Value2D, uv?: Array<any>, blend?: number): void;
        transform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        setTransformByMatrix(value: laya.maths.Matrix): void;
        transformByMatrix(value: laya.maths.Matrix): void;
        rotate(angle: number): void;
        scale(scaleX: number, scaleY: number): void;
        clipRect(x: number, y: number, width: number, height: number): void;
        setIBVB(x: number, y: number, ib: laya.webgl.utils.IndexBuffer2D, vb: laya.webgl.utils.VertexBuffer2D, numElement: number, mat: laya.maths.Matrix, shader: laya.webgl.shader.Shader, shaderValues: laya.webgl.shader.d2.value.Value2D, startIndex?: number, offset?: number, type?: number): void;
        addRenderObject(o: laya.webgl.submit.ISubmit): void;
        fillTrangles(tex: laya.resource.Texture, x: number, y: number, points: Array<any>, m: laya.maths.Matrix): void;
        submitElement(start: number, end: number): void;
        finish(): void;
        flush(): number;
        setPathId(id: number): void;
        movePath(x: number, y: number): void;
        beginPath(): void;
        closePath(): void;
        fill(isConvexPolygon?: boolean): void;
        stroke(): void;
        line(fromX: number, fromY: number, toX: number, toY: number, lineWidth: number, mat: laya.maths.Matrix): void;
        moveTo(x: number, y: number, b?: boolean): void;
        lineTo(x: number, y: number, b?: boolean): void;
        drawCurves(x: number, y: number, args: Array<any>): void;
        arcTo(x1: number, y1: number, x2: number, y2: number, r: number): void;
        arc(cx: number, cy: number, r: number, startAngle: number, endAngle: number, counterclockwise?: boolean, b?: boolean): void;
        quadraticCurveTo(cpx: number, cpy: number, x: number, y: number): void;
        rect(x: number, y: number, width: number, height: number): void;
        strokeRect(x: number, y: number, width: number, height: number, parameterLineWidth: number): void;
        clip(): void;
        /**
         * 画多边形(用)
         * @param	x
         * @param	y
         * @param	points
         */
        drawPoly(x: number, y: number, points: Array<any>, color: number, lineWidth: number, boderColor: number, isConvexPolygon?: boolean): void;
        /*******************************************end矢量绘制***************************************************/
        drawParticle(x: number, y: number, pt: any): void;
    }
    class ContextParams {
        static DEFAULT: ContextParams;
        lineWidth: number;
        path: any;
        textAlign: string;
        textBaseline: string;
        font: laya.webgl.text.FontInContext;
        clear(): void;
        make(): ContextParams;
    }
}
declare module laya.webgl.display {
    class GraphicsGL extends laya.display.Graphics {
        constructor();
        setShader(shader: laya.webgl.shader.Shader): void;
        setIBVB(x: number, y: number, ib: laya.webgl.utils.Buffer2D, vb: laya.webgl.utils.Buffer2D, numElement: number, shader: laya.webgl.shader.Shader): void;
        drawParticle(x: number, y: number, ps: any): void;
    }
}
declare module laya.webgl.resource {
    interface IMergeAtlasBitmap {
    }
}
declare module laya.webgl.resource {
    class RenderTarget2D extends laya.resource.Texture implements laya.resource.IDispose {
        static TYPE2D: number;
        static TYPE3D: number;
        private static POOL;
        _destroy: boolean;
        surfaceFormat: number;
        surfaceType: number;
        depthStencilFormat: number;
        mipMap: boolean;
        minFifter: number;
        magFifter: number;
        /**返回RenderTarget的Texture*/
        source: any;
        /**
         * @param width
         * @param height
         * @param mimMap
         * @param surfaceFormat RGB ,R,RGBA......
         * @param surfaceType    WebGLContext.UNSIGNED_BYTE  数据类型
         * @param depthFormat WebGLContext.DEPTH_COMPONENT16 数据类型等
         * **/
        constructor(width: number, height: number, surfaceFormat?: number, surfaceType?: number, depthStencilFormat?: number, mipMap?: boolean, repeat?: boolean, minFifter?: number, magFifter?: number);
        getType(): number;
        getTexture(): laya.resource.Texture;
        size(w: number, h: number): void;
        release(): void;
        recycle(): void;
        start(): RenderTarget2D;
        clear(r?: number, g?: number, b?: number, a?: number): void;
        end(): void;
        getData(x: number, y: number, width: number, height: number): Uint8Array;
        /**彻底清理资源,注意会强制解锁清理*/
        destroy(foreDiposeTexture?: boolean): void;
        dispose(): void;
    }
}
declare module laya.webgl.resource {
    class RenderTargetMAX {
        target: RenderTarget2D;
        repaint: boolean;
        _width: number;
        _height: number;
        constructor();
        setSP(sp: laya.display.Sprite): void;
        size(w: number, h: number): void;
        flush(context: laya.webgl.canvas.WebGLContext2D): void;
        drawTo(context: laya.webgl.canvas.WebGLContext2D, x: number, y: number, width: number, height: number): void;
        destroy(): void;
    }
}
declare module laya.webgl.resource {
    class WebGLCanvas extends laya.resource.Bitmap {
        static _createContext: Function;
        /**HTML Canvas*/
        _canvas: any;
        iscpuSource: boolean;
        getCanvas(): any;
        clear(): void;
        destroy(): void;
        context: laya.resource.Context;
        _setContext(context: laya.resource.Context): void;
        getContext(contextID: string, other?: any): laya.resource.Context;
        size(w: number, h: number): void;
        asBitmap: boolean;
        protected recreateResource(): void;
        protected detoryResource(): void;
        texSubImage2D(webglCanvas: WebGLCanvas, xoffset: number, yoffset: number): void;
    }
}
declare module laya.webgl.resource {
    class WebGLCharImage extends laya.resource.Bitmap implements IMergeAtlasBitmap {
        /**HTML Canvas，绘制字符载体,非私有数据载体*/
        canvas: any;
        /**********************************************************************************/
        cw: number;
        ch: number;
        xs: number;
        ys: number;
        char: string;
        fillColor: string;
        borderColor: string;
        borderSize: number;
        font: string;
        fontSize: number;
        texture: laya.resource.Texture;
        lineWidth: number;
        UV: Array<any>;
        isSpace: boolean;
        /**
         * 创建单个文字
         * @param	content
         * @param	drawValue
         * @return
         */
        static createOneChar(content: string, drawValue: any): WebGLCharImage;
        active(): void;
        atlasSource: any;
        /**
         * 是否创建私有Source
         * @return 是否创建
         */
        allowMerageInAtlas: boolean;
        /**
         * 是否创建私有Source
         * @return 是否创建
         */
        /**
         * 是否创建私有Source,通常禁止修改
         * @param value 是否创建
         */
        enableMerageInAtlas: boolean;
        /**
         * WebGLCharImage依赖于外部canvas,自身并无私有数据载体
         * @param	canvas
         * @param	char
         */
        constructor(content: string, drawValue: any);
        protected recreateResource(): void;
        clearAtlasSource(): void;
    }
}
declare module laya.webgl.resource {
    class WebGLImage extends laya.resource.HTMLImage implements IMergeAtlasBitmap {
        /**是否使用重复模式纹理寻址*/
        repeat: boolean;
        /**是否使用mipLevel*/
        mipmap: boolean;
        /**缩小过滤器*/
        minFifter: number;
        /**放大过滤器*/
        magFifter: number;
        /**
         * 返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
         * @param HTML Image
         */
        image: any;
        atlasSource: any;
        /**
         * 是否创建私有Source
         * @return 是否创建
         */
        allowMerageInAtlas: boolean;
        /**
         * 是否创建私有Source
         * @return 是否创建
         */
        /**
         * 是否创建私有Source,通常禁止修改
         * @param value 是否创建
         */
        enableMerageInAtlas: boolean;
        /***
         * 设置onload函数
         * @param value onload函数
         */
        onload: Function;
        /***
         * 设置onerror函数
         * @param value onerror函数
         */
        onerror: Function;
        constructor(src: string, def: any);
        protected _init_(src: string, def: any): void;
        protected recreateResource(): void;
        protected detoryResource(): void;
        protected onresize(): void;
        clearAtlasSource(): void;
    }
}
declare module laya.webgl.resource {
    class WebGLRenderTarget extends laya.resource.Bitmap {
        frameBuffer: any;
        depthStencilBuffer: any;
        constructor(width: number, height: number, surfaceFormat?: number, surfaceType?: number, depthStencilFormat?: number, mipMap?: boolean, repeat?: boolean, minFifter?: number, magFifter?: number);
        protected recreateResource(): void;
        protected detoryResource(): void;
    }
}
declare module laya.webgl.resource {
    class WebGLSubImage extends laya.resource.Bitmap implements IMergeAtlasBitmap {
        /**HTML Canvas，绘制子图载体,非私有数据载体*/
        canvas: any;
        /**是否使用重复模式纹理寻址*/
        repeat: boolean;
        /**是否使用mipLevel*/
        mipmap: boolean;
        /**缩小过滤器*/
        minFifter: number;
        /**放大过滤器*/
        magFifter: number;
        atlasImage: any;
        offsetX: number;
        offsetY: number;
        src: string;
        atlasSource: any;
        /**
         * 是否创建私有Source
         * @return 是否创建
         */
        allowMerageInAtlas: boolean;
        /**
         * 是否创建私有Source
         * @return 是否创建
         */
        /**
         * 是否创建私有Source,通常禁止修改
         * @param value 是否创建
         */
        enableMerageInAtlas: boolean;
        constructor(canvas: any, offsetX: number, offsetY: number, width: number, height: number, atlasImage: any, src: string);
        protected recreateResource(): void;
        protected detoryResource(): void;
        clearAtlasSource(): void;
        dispose(): void;
    }
}
declare module laya.webgl.shader {
    /**
     * ...
     * @author ...
     */
    class BaseShader extends laya.resource.Resource {
        static activeShader: BaseShader;
        static bindShader: BaseShader;
        constructor();
    }
}
declare module laya.webgl.shader.d2 {
    class Shader2D {
        ALPHA: number;
        glTexture: laya.resource.Bitmap;
        shader: laya.webgl.shader.Shader;
        filters: Array<any>;
        defines: ShaderDefines2D;
        shaderType: number;
        colorAdd: Array<any>;
        strokeStyle: laya.webgl.canvas.DrawStyle;
        fillStyle: laya.webgl.canvas.DrawStyle;
        static __init__(): void;
    }
}
declare module laya.webgl.shader.d2 {
    class Shader2X extends laya.webgl.shader.Shader {
        _params2dQuick1: Array<any>;
        _params2dQuick2: Array<any>;
        _shaderValueWidth: number;
        _shaderValueHeight: number;
        constructor(vs: string, ps: string, saveName?: any, nameMap?: any);
        upload2dQuick1(shaderValue: laya.webgl.shader.ShaderValue): void;
        _make2dQuick1(): Array<any>;
        protected detoryResource(): void;
        upload2dQuick2(shaderValue: laya.webgl.shader.ShaderValue): void;
        _make2dQuick2(): Array<any>;
        static create(vs: string, ps: string, saveName?: any, nameMap?: any): laya.webgl.shader.Shader;
    }
}
declare module laya.webgl.shader.d2 {
    class ShaderDefines2D extends laya.webgl.shader.ShaderDefines {
        static TEXTURE2D: number;
        static COLOR2D: number;
        static PRIMITIVE: number;
        static FILTERGLOW: number;
        static FILTERBLUR: number;
        static FILTERCOLOR: number;
        static COLORADD: number;
        static WORLDMAT: number;
        static FILLTEXTURE: number;
        static SKINMESH: number;
        static SHADERDEFINE_FSHIGHPRECISION: number;
        private static __name2int;
        private static __int2name;
        private static __int2nameMap;
        static __init__(): void;
        constructor();
        static reg(name: string, value: number): void;
        static toText(value: number, int2name: Array<any>, int2nameMap: any): any;
        static toInt(names: string): number;
    }
}
declare module laya.webgl.shader.d2.skinAnishader {
    /**
     * 这里销毁的问题，后面待确认
     */
    class SkinMesh {
        transform: laya.maths.Matrix;
        private static _tempVS;
        private static _tempIB;
        private static _defaultPS;
        private static _tVSLen;
        constructor();
        init(texture: laya.resource.Texture, vs: Array<any>, ps: Array<any>): void;
        init2(texture: laya.resource.Texture, vs: Array<any>, ps: Array<any>, verticles: Array<any>, uvs: Array<any>): void;
        getData2(vb: laya.webgl.utils.VertexBuffer2D, ib: laya.webgl.utils.IndexBuffer2D, start: number): void;
        getData(vb: laya.webgl.utils.VertexBuffer2D, ib: laya.webgl.utils.IndexBuffer2D, start: number): void;
        render(context: any, x: number, y: number): void;
    }
}
declare module laya.webgl.shader.d2.skinAnishader {
    class SkinMeshBuffer {
        ib: laya.webgl.utils.IndexBuffer2D;
        vb: laya.webgl.utils.VertexBuffer2D;
        static instance: SkinMeshBuffer;
        constructor();
        static getInstance(): SkinMeshBuffer;
        addSkinMesh(skinMesh: SkinMesh): void;
        reset(): void;
    }
}
declare module laya.webgl.shader.d2.skinAnishader {
    class SkinSV extends laya.webgl.shader.d2.value.Value2D {
        texcoord: any;
        offsetX: number;
        offsetY: number;
        constructor(type: any);
    }
}
declare module laya.webgl.shader.d2.value {
    class Color2dSV extends Value2D {
        constructor(args: any);
        setValue(value: laya.webgl.shader.d2.Shader2D): void;
    }
}
declare module laya.webgl.shader.d2.value {
    class FillTextureSV extends laya.webgl.shader.d2.value.Value2D {
        u_texRange: Array<any>;
        u_offset: Array<any>;
        texcoord: Array<any>;
        u_colorMatrix: Array<any>;
        strength: number;
        colorMat: Array<any>;
        colorAlpha: Array<any>;
        u_TexRange: Array<any>;
        constructor(type: any);
        setValue(vo: laya.webgl.shader.d2.Shader2D): void;
        clear(): void;
    }
}
declare module laya.webgl.shader.d2.value {
    class GlowSV extends TextureSV {
        u_blurX: boolean;
        u_color: Array<any>;
        u_offset: Array<any>;
        u_strength: number;
        u_texW: number;
        u_texH: number;
        constructor(args: any);
        setValue(vo: laya.webgl.shader.d2.Shader2D): void;
        clear(): void;
    }
}
declare module laya.webgl.shader.d2.value {
    class PrimitiveSV extends Value2D {
        a_color: Array<any>;
        u_pos: Array<any>;
        constructor(args: any);
    }
}
declare module laya.webgl.shader.d2.value {
    class TextSV extends TextureSV {
        static pool: Array<any>;
        private static _length;
        constructor(args: any);
        release(): void;
        clear(): void;
        static create(): TextSV;
    }
}
declare module laya.webgl.shader.d2.value {
    class TextureSV extends Value2D {
        texcoord: Array<any>;
        u_colorMatrix: Array<any>;
        strength: number;
        blurInfo: Array<any>;
        colorMat: Array<any>;
        colorAlpha: Array<any>;
        constructor(subID?: number);
        setValue(vo: laya.webgl.shader.d2.Shader2D): void;
        clear(): void;
    }
}
declare module laya.webgl.shader.d2.value {
    class Value2D extends laya.webgl.shader.ShaderValue {
        static _POSITION: Array<any>;
        static _TEXCOORD: Array<any>;
        protected static _cache: Array<any>;
        protected static _typeClass: any;
        static TEMPMAT4_ARRAY: Array<any>;
        static __init__(): void;
        defines: laya.webgl.shader.d2.ShaderDefines2D;
        position: Array<any>;
        size: Array<any>;
        alpha: number;
        mmat: Array<any>;
        ALPHA: number;
        shader: laya.webgl.shader.Shader;
        mainID: number;
        subID: number;
        filters: Array<any>;
        textureHost: laya.resource.Texture;
        texture: any;
        fillStyle: laya.webgl.canvas.DrawStyle;
        color: Array<any>;
        strokeStyle: laya.webgl.canvas.DrawStyle;
        colorAdd: Array<any>;
        glTexture: laya.resource.Bitmap;
        mul_mmat: Array<any>;
        u_mmat2: Array<any>;
        constructor(mainID: number, subID: number);
        setValue(value: laya.webgl.shader.d2.Shader2D): void;
        refresh(): laya.webgl.shader.ShaderValue;
        upload(): void;
        setFilters(value: Array<any>): void;
        clear(): void;
        release(): void;
        static create(mainType: number, subType: number): Value2D;
    }
}
declare module laya.webgl.shader {
    class Shader extends BaseShader {
        private static _TEXTURES;
        private static _includeFiles;
        private static _count;
        static _preCompileShader: any;
        protected static shaderParamsMap: any;
        static SHADERNAME2ID: number;
        static nameKey: laya.utils.StringKey;
        static sharders: Array<any>;
        static getShader(name: any): Shader;
        static create(vs: string, ps: string, saveName?: any, nameMap?: any): Shader;
        /**
         * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
         * @param	name
         * @param	vs
         * @param	ps
         * @param	define 宏定义，格式:
         * @return
         */
        static withCompile(nameID: number, define: any, shaderName: any, createShader: Function): Shader;
        /**
         * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
         * @param	name
         * @param	vs
         * @param	ps
         * @param	define 宏定义，格式:
         * @return
         */
        static withCompile2D(nameID: number, mainID: number, define: any, shaderName: any, createShader: Function): Shader;
        static addInclude(fileName: string, txt: string): void;
        /**
         * 预编译shader文件，主要是处理宏定义
         * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
         * @param	vs
         * @param	ps
         */
        static preCompile(nameID: number, vs: string, ps: string, nameMap: any): void;
        /**
         * 预编译shader文件，主要是处理宏定义
         * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
         * @param	vs
         * @param	ps
         */
        static preCompile2D(nameID: number, mainID: number, vs: string, ps: string, nameMap: any): void;
        tag: any;
        _vshader: any;
        _pshader: any;
        _program: any;
        _params: Array<any>;
        _paramsMap: any;
        _offset: number;
        _id: number;
        /**
         * 根据vs和ps信息生成shader对象
         * @param	vs
         * @param	ps
         * @param	name:
         * @param	nameMap 帮助里要详细解释为什么需要nameMap
         */
        constructor(vs: string, ps: string, saveName?: any, nameMap?: any);
        protected recreateResource(): void;
        protected detoryResource(): void;
        /**
         * 根据变量名字获得
         * @param	name
         * @return
         */
        getUniform(name: string): any;
        uploadOne(name: string, value: any): void;
        uploadTexture2D(value: any): void;
        /**
         * 提交shader到GPU
         * @param	shaderValue
         */
        upload(shaderValue: ShaderValue, params?: Array<any>): void;
        /**
         * 按数组的定义提交
         * @param	shaderValue 数组格式[name,value,...]
         */
        uploadArray(shaderValue: Array<any>, length: number, _bufferUsage: any): void;
        /**
         * 得到编译后的变量及相关预定义
         * @return
         */
        getParams(): Array<any>;
        protected _preGetParams(vs: string, ps: string): any;
        dispose(): void;
    }
}
declare module laya.webgl.shader {
    class ShaderDefines {
        _value: number;
        constructor(name2int: any, int2name: Array<any>, int2nameMap: Array<any>);
        add(value: any): number;
        addInt(value: number): number;
        remove(value: any): number;
        isDefine(def: number): boolean;
        getValue(): number;
        setValue(value: number): void;
        toNameDic(): any;
        static _reg(name: string, value: number, _name2int: any, _int2name: Array<any>): void;
        static _toText(value: number, _int2name: Array<any>, _int2nameMap: any): any;
        static _toInt(names: string, _name2int: any): number;
    }
}
declare module laya.webgl.shader {
    class ShaderValue {
        constructor();
    }
}
declare module laya.webgl.shapes {
    class BasePoly implements IShape {
        x: number;
        y: number;
        r: number;
        width: number;
        height: number;
        edges: number;
        r0: number;
        color: number;
        borderColor: number;
        borderWidth: number;
        round: number;
        fill: boolean;
        protected mUint16Array: Uint16Array;
        protected mFloat32Array: Float32Array;
        constructor(x: number, y: number, width: number, height: number, edges: number, color: number, borderWidth: number, borderColor: number, round?: number);
        getData(ib: laya.webgl.utils.Buffer2D, vb: laya.webgl.utils.Buffer2D, start: number): void;
        rebuild(points: Array<any>): void;
        setMatrix(mat: laya.maths.Matrix): void;
        needUpdate(mat: laya.maths.Matrix): boolean;
        protected sector(outVert: Array<any>, outIndex: Array<any>, start: number): void;
        protected createLine2(p: Array<any>, indices: Array<any>, lineWidth: number, len: number, outVertex: Array<any>, indexCount: number): Array<any>;
        createLoopLine(p: Array<any>, indices: Array<any>, lineWidth: number, len: number, outVertex?: Array<any>, outIndex?: Array<any>): Array<any>;
    }
}
declare module laya.webgl.shapes {
    class Ellipse extends BasePoly {
        constructor(x: number, y: number, width: number, height: number, color: number, borderWidth: number, borderColor: number);
    }
}
declare module laya.webgl.shapes {
    class GeometryData {
        lineWidth: number;
        lineColor: number;
        lineAlpha: number;
        fillColor: number;
        fillAlpha: number;
        shape: IShape;
        fill: boolean;
        constructor(lineWidth: number, lineColor: number, lineAlpha: number, fillColor: number, fillAlpha: number, fill: boolean, shape: IShape);
        clone(): GeometryData;
        getIndexData(): Uint16Array;
        getVertexData(): Float32Array;
        destroy(): void;
    }
}
declare module laya.webgl.shapes {
    interface IShape {
    }
}
declare module laya.webgl.shapes {
    class Line extends BasePoly {
        constructor(x: number, y: number, points: Array<any>, borderWidth: number, color: number);
        rebuild(points: Array<any>): void;
        getData(ib: laya.webgl.utils.Buffer2D, vb: laya.webgl.utils.Buffer2D, start: number): void;
    }
}
declare module laya.webgl.shapes {
    class LoopLine extends BasePoly {
        constructor(x: number, y: number, points: Array<any>, width: number, color: number);
        getData(ib: laya.webgl.utils.Buffer2D, vb: laya.webgl.utils.Buffer2D, start: number): void;
        createLoopLine(p: Array<any>, indices: Array<any>, lineWidth: number, len: number, outVertex?: Array<any>, outIndex?: Array<any>): Array<any>;
    }
}
declare module laya.webgl.shapes {
    class Polygon extends BasePoly {
        constructor(x: number, y: number, points: Array<any>, color: number, borderWidth: number, borderColor: number);
        rebuild(point: Array<any>): void;
        setMatrix(mat: laya.maths.Matrix): void;
        needUpdate(mat: laya.maths.Matrix): boolean;
        getData(ib: laya.webgl.utils.Buffer2D, vb: laya.webgl.utils.Buffer2D, start: number): void;
    }
}
declare module laya.webgl.shapes {
    class Vertex implements IShape {
        points: Float32Array;
        constructor(p: any);
        getData(ib: laya.webgl.utils.Buffer2D, vb: laya.webgl.utils.Buffer2D, start: number): void;
        needUpdate(mat: laya.maths.Matrix): boolean;
        rebuild(points: Array<any>): void;
        setMatrix(mat: laya.maths.Matrix): void;
    }
}
declare module laya.webgl.submit {
    interface ISubmit {
    }
}
declare module laya.webgl.submit {
    class Submit implements laya.webgl.submit.ISubmit {
        static TYPE_2D: number;
        static TYPE_CANVAS: number;
        static TYPE_CMDSETRT: number;
        static TYPE_CUSTOM: number;
        static TYPE_BLURRT: number;
        static TYPE_CMDDESTORYPRERT: number;
        static TYPE_DISABLESTENCIL: number;
        static TYPE_OTHERIBVB: number;
        static TYPE_PRIMITIVE: number;
        static TYPE_RT: number;
        static TYPE_BLUR_RT: number;
        static TYPE_TARGET: number;
        static TYPE_CHANGE_VALUE: number;
        static TYPE_SHAPE: number;
        static TYPE_TEXTURE: number;
        static TYPE_FILLTEXTURE: number;
        static RENDERBASE: Submit;
        private static _cache;
        protected _selfVb: laya.webgl.utils.VertexBuffer2D;
        protected _ib: laya.webgl.utils.IndexBuffer2D;
        protected _blendFn: Function;
        _renderType: number;
        _vb: laya.webgl.utils.VertexBuffer2D;
        _startIdx: number;
        _numEle: number;
        shaderValue: laya.webgl.shader.d2.value.Value2D;
        static __init__(): void;
        constructor(renderType?: number);
        releaseRender(): void;
        getRenderType(): number;
        renderSubmit(): number;
        static create(context: laya.webgl.canvas.WebGLContext2D, ib: laya.webgl.utils.IndexBuffer2D, vb: laya.webgl.utils.VertexBuffer2D, pos: number, sv: laya.webgl.shader.d2.value.Value2D): Submit;
        static createShape(ctx: laya.webgl.canvas.WebGLContext2D, ib: laya.webgl.utils.IndexBuffer2D, vb: laya.webgl.utils.VertexBuffer2D, numEle: number, offset: number, sv: laya.webgl.shader.d2.value.Value2D): Submit;
    }
}
declare module laya.webgl.submit {
    class SubmitCanvas extends Submit {
        _matrix: laya.maths.Matrix;
        _ctx_src: laya.webgl.canvas.WebGLContext2D;
        _matrix4: Array<any>;
        constructor();
        renderSubmit(): number;
        releaseRender(): void;
        getRenderType(): number;
    }
}
declare module laya.webgl.submit {
    class SubmitCMD implements laya.webgl.submit.ISubmit {
        static _cache: Array<any>;
        fun: Function;
        args: Array<any>;
        constructor();
        renderSubmit(): number;
        getRenderType(): number;
        releaseRender(): void;
        static create(args: Array<any>, fun: Function): SubmitCMD;
    }
}
declare module laya.webgl.submit {
    class SubmitCMDScope {
        private static POOL;
        constructor();
        getValue(name: string): any;
        addValue(name: string, value: any): any;
        setValue(name: string, value: any): any;
        clear(): void;
        recycle(): void;
        static create(): SubmitCMDScope;
    }
}
declare module laya.webgl.submit {
    class SubmitOtherIBVB implements laya.webgl.submit.ISubmit {
        private static _cache;
        private static tempMatrix4;
        static create(context: laya.webgl.canvas.WebGLContext2D, vb: laya.webgl.utils.VertexBuffer2D, ib: laya.webgl.utils.IndexBuffer2D, numElement: number, shader: laya.webgl.shader.Shader, shaderValue: laya.webgl.shader.d2.value.Value2D, startIndex: number, offset: number, type?: number): SubmitOtherIBVB;
        protected offset: number;
        protected _vb: laya.webgl.utils.VertexBuffer2D;
        protected _ib: laya.webgl.utils.IndexBuffer2D;
        protected _blendFn: Function;
        _mat: laya.maths.Matrix;
        _shader: laya.webgl.shader.Shader;
        _shaderValue: laya.webgl.shader.d2.value.Value2D;
        _numEle: number;
        startIndex: number;
        constructor();
        releaseRender(): void;
        getRenderType(): number;
        renderSubmit(): number;
    }
}
declare module laya.webgl.submit {
    class SubmitScissor implements laya.webgl.submit.ISubmit {
        static _cache: Array<any>;
        clipRect: laya.maths.Rectangle;
        screenRect: laya.maths.Rectangle;
        submitIndex: number;
        submitLength: number;
        context: laya.webgl.canvas.WebGLContext2D;
        constructor();
        renderSubmit(): number;
        getRenderType(): number;
        releaseRender(): void;
        static create(context: laya.webgl.canvas.WebGLContext2D): SubmitScissor;
    }
}
declare module laya.webgl.submit {
    class SubmitStencil implements laya.webgl.submit.ISubmit {
        static _cache: Array<any>;
        step: number;
        blendMode: string;
        constructor();
        renderSubmit(): number;
        getRenderType(): number;
        releaseRender(): void;
        static create(step: number): SubmitStencil;
    }
}
declare module laya.webgl.submit {
    class SubmitTarget implements laya.webgl.submit.ISubmit {
        protected _renderType: number;
        protected _vb: laya.webgl.utils.VertexBuffer2D;
        protected _ib: laya.webgl.utils.IndexBuffer2D;
        _startIdx: number;
        _numEle: number;
        shaderValue: laya.webgl.shader.d2.value.Value2D;
        blendType: number;
        proName: string;
        scope: SubmitCMDScope;
        constructor();
        static _cache: Array<any>;
        renderSubmit(): number;
        blend(): void;
        getRenderType(): number;
        releaseRender(): void;
        static create(context: laya.webgl.canvas.WebGLContext2D, ib: laya.webgl.utils.IndexBuffer2D, vb: laya.webgl.utils.VertexBuffer2D, pos: number, sv: laya.webgl.shader.d2.value.Value2D, proName: string): SubmitTarget;
    }
}
declare module laya.webgl.submit {
    class SubmitTexture extends Submit {
        protected _texs: Array<any>;
        protected _texsID: Array<any>;
        protected _vbPos: Array<any>;
        _preIsSameTextureShader: boolean;
        _isSameTexture: boolean;
        constructor(renderType?: number);
        releaseRender(): void;
        addTexture(tex: laya.resource.Texture, vbpos: number): void;
        checkTexture(): void;
        renderSubmit(): number;
        static create(context: laya.webgl.canvas.WebGLContext2D, ib: laya.webgl.utils.IndexBuffer2D, vb: laya.webgl.utils.VertexBuffer2D, pos: number, sv: laya.webgl.shader.d2.value.Value2D): SubmitTexture;
    }
}
declare module laya.webgl.text {
    /**
     * ...特殊的字符，如泰文，必须重新实现这个类
     */
    class CharSegment implements ICharSegment {
        constructor();
        textToSpit(str: string): void;
        getChar(i: number): string;
        getCharCode(i: number): number;
        length(): number;
    }
}
declare module laya.webgl.text {
    class DrawText {
        private static _charsTemp;
        private static _textCachesPool;
        private static _curPoolIndex;
        private static _charsCache;
        private static _textsCache;
        static _drawValue: CharValue;
        static d: Array<any>;
        private static _charSeg;
        static __init__(): void;
        /**
         * 项目层根据当前的语言特性，设置自己的分词器，如泰语需要特殊的处理
         * @param	charseg
         */
        static customCharSeg(charseg: ICharSegment): void;
        static getChar(char: string, id: number, drawValue: CharValue): laya.webgl.resource.WebGLCharImage;
        static drawText(ctx: laya.webgl.canvas.WebGLContext2D, txt: any, words: Array<any>, curMat: laya.maths.Matrix, font: FontInContext, textAlign: string, fillColor: string, borderColor: string, lineWidth: number, x: number, y: number): void;
    }
    class CharValue {
        private static _keymap;
        private static _keymapCount;
        txtID: number;
        font: any;
        fillColor: string;
        borderColor: string;
        lineWidth: number;
        scaleX: number;
        scaleY: number;
        value(font: any, fillColor: string, borderColor: string, lineWidth: number, scaleX: number, scaleY: number): CharValue;
        static clear(): void;
    }
}
declare module laya.webgl.text {
    class FontInContext {
        static EMPTY: FontInContext;
        private static _cache;
        static create(font: string): FontInContext;
        constructor(font?: string);
        setFont(value: string): void;
        size: number;
        getItalic(): number;
        hasType(name: string): number;
        removeType(name: string): void;
        copyTo(dec: FontInContext): FontInContext;
        toString(): string;
    }
}
declare module laya.webgl.text {
    interface ICharSegment {
    }
}
declare module laya.webgl.utils {
    class Buffer extends laya.resource.Resource {
        protected static _gl: laya.webgl.WebGLContext;
        protected static _bindActive: any;
        protected _glBuffer: any;
        protected _buffer: any;
        protected _bufferType: number;
        protected _bufferUsage: number;
        _byteLength: number;
        byteLength: number;
        bufferType: any;
        bufferUsage: number;
        constructor();
        _bind(): void;
        protected recreateResource(): void;
        protected detoryResource(): void;
        dispose(): void;
    }
}
declare module laya.webgl.utils {
    class Buffer2D extends Buffer {
        static FLOAT32: number;
        static SHORT: number;
        static __int__(gl: laya.webgl.WebGLContext): void;
        protected _maxsize: number;
        _upload: boolean;
        protected _uploadSize: number;
        bufferLength: number;
        byteLength: number;
        constructor();
        protected _bufferData(): void;
        protected _bufferSubData(offset?: number, dataStart?: number, dataLength?: number): void;
        protected _checkArrayUse(): void;
        _bind_upload(): boolean;
        _bind_subUpload(offset?: number, dataStart?: number, dataLength?: number): boolean;
        _resizeBuffer(nsz: number, copy: boolean): Buffer2D;
        append(data: any): void;
        appendEx(data: any, type: any): void;
        appendEx2(data: any, type: any, dataLen: number, perDataLen?: number): void;
        getBuffer(): ArrayBuffer;
        setNeedUpload(): void;
        getNeedUpload(): boolean;
        upload(): boolean;
        subUpload(offset?: number, dataStart?: number, dataLength?: number): boolean;
        protected detoryResource(): void;
        clear(): void;
    }
}
declare module laya.webgl.utils {
    class CONST3D2D {
        static BYTES_PE: number;
        static BYTES_PIDX: number;
        static defaultMatrix4: Array<any>;
        static defaultMinusYMatrix4: Array<any>;
        static uniformMatrix3: Array<any>;
        static _TMPARRAY: Array<any>;
        static _OFFSETX: number;
        static _OFFSETY: number;
    }
}
declare module laya.webgl.utils {
    class GlUtils {
        static make2DProjection(width: number, height: number, depth: number): any;
        private static _fillLineArray;
        /**
         *  初始化全局IB,IB索引如下:
         *   0___1
         *	 |\  |
         *	 | \ |
         *	 |__\|
         *	 3   2
         */
        static fillIBQuadrangle(buffer: IndexBuffer2D, count: number): boolean;
        static expandIBQuadrangle(buffer: IndexBuffer2D, count: number): void;
        static mathCeilPowerOfTwo(value: number): number;
        static fillQuadrangleImgVb(vb: VertexBuffer2D, x: number, y: number, point4: Array<any>, uv: Array<any>, m: laya.maths.Matrix, _x: number, _y: number): boolean;
        static fillTranglesVB(vb: VertexBuffer2D, x: number, y: number, points: Array<any>, m: laya.maths.Matrix, _x: number, _y: number): boolean;
        static copyPreImgVb(vb: VertexBuffer2D, dx: number, dy: number): void;
        static fillRectImgVb(vb: VertexBuffer2D, clip: laya.maths.Rectangle, x: number, y: number, width: number, height: number, uv: Array<any>, m: laya.maths.Matrix, _x: number, _y: number, dx: number, dy: number, round?: boolean): boolean;
        static fillLineVb(vb: VertexBuffer2D, clip: laya.maths.Rectangle, fx: number, fy: number, tx: number, ty: number, width: number, mat: laya.maths.Matrix): boolean;
    }
}
declare module laya.webgl.utils {
    class IndexBuffer2D extends Buffer2D {
        static QuadrangleIB: IndexBuffer2D;
        static create: Function;
        protected _uint8Array: Uint8Array;
        protected _uint16Array: Uint16Array;
        constructor(bufferUsage?: number);
        protected _checkArrayUse(): void;
        getUint8Array(): Uint8Array;
        getUint16Array(): Uint16Array;
    }
}
declare module laya.webgl.utils {
    class MatirxArray {
        /**
         * 4*4矩阵数组相乘。
         * o=a*b;
         * @param	a 4*4矩阵数组。
         * @param	b 4*4矩阵数组。
         * @param	o 4*4矩阵数组。
         */
        static ArrayMul(a: Array<any>, b: Array<any>, o: Array<any>): void;
        static copyArray(f: Array<any>, t: Array<any>): void;
    }
}
declare module laya.webgl.utils {
    class RenderSprite3D extends laya.renders.RenderSprite {
        static tempUV: Array<any>;
        constructor(type: number, next: laya.renders.RenderSprite);
        protected onCreate(type: number): void;
        static tmpTarget(scope: laya.webgl.submit.SubmitCMDScope, context: laya.renders.RenderContext): void;
        static endTmpTarget(scope: laya.webgl.submit.SubmitCMDScope): void;
        static recycleTarget(scope: laya.webgl.submit.SubmitCMDScope): void;
        _mask(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        _blend(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        _transform(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.webgl.utils {
    class RenderState2D {
        static _MAXSIZE: number;
        static EMPTYMAT4_ARRAY: Array<any>;
        static TEMPMAT4_ARRAY: Array<any>;
        static worldMatrix4: Array<any>;
        static worldMatrix: laya.maths.Matrix;
        static worldAlpha: number;
        static worldScissorTest: boolean;
        static worldFilters: Array<any>;
        static worldShaderDefines: laya.webgl.shader.d2.ShaderDefines2D;
        static worldClipRect: laya.maths.Rectangle;
        static curRenderTarget: laya.webgl.resource.RenderTarget2D;
        static width: number;
        static height: number;
        static getMatrArray(): Array<any>;
        static mat2MatArray(mat: laya.maths.Matrix, matArray: Array<any>): Array<any>;
        static restoreTempArray(): void;
        static clear(): void;
    }
}
declare module laya.webgl.utils {
    class ShaderCompile {
        static IFDEF_NO: number;
        static IFDEF_YES: number;
        static IFDEF_ELSE: number;
        constructor(name: number, vs: string, ps: string, nameMap: any, includeFiles: any);
        createShader(define: any, shaderName: any, createShader: Function): laya.webgl.shader.Shader;
    }
    class ShaderScriptBlock {
        type: number;
        condition: Function;
        text: string;
        childs: Array<any>;
        parent: ShaderScriptBlock;
        ShaderScriptBlock(type: number, condition: string, text: string, parent: ShaderScriptBlock): any;
        toscript(def: any, out: Array<any>): Array<any>;
    }
}
declare module laya.webgl.utils {
    class VertexBuffer2D extends Buffer2D {
        static create: Function;
        protected _floatArray32: Float32Array;
        vertexStride: number;
        constructor(vertexStride: number, bufferUsage: number);
        getFloat32Array(): any;
        bind(ibBuffer: IndexBuffer2D): void;
        insertData(data: Array<any>, pos: number): void;
        bind_upload(ibBuffer: IndexBuffer2D): void;
        protected _checkArrayUse(): void;
        protected detoryResource(): void;
    }
}
declare module laya.webgl {
    /**
     * @private
     */
    class WebGL {
        static mainCanvas: laya.resource.HTMLCanvas;
        static mainContext: WebGLContext;
        static antialias: boolean;
        static frameShaderHighPrecision: boolean;
        private static _bg_null;
        private static _isExperimentalWebgl;
        static enable(): boolean;
        static onStageResize(width: number, height: number): void;
        static isExperimentalWebgl(): boolean;
        /**只有微信或QQ且是experimental-webgl模式下起作用*/
        static addRenderFinish(): void;
        static removeRenderFinish(): void;
        static doNodeRepaint(sprite: laya.display.Sprite): void;
        static init(canvas: laya.resource.HTMLCanvas, width: number, height: number): void;
    }
}
declare module laya.webgl {
    class WebGLContext {
        static DEPTH_BUFFER_BIT: number;
        static STENCIL_BUFFER_BIT: number;
        static COLOR_BUFFER_BIT: number;
        static POINTS: number;
        static LINES: number;
        static LINE_LOOP: number;
        static LINE_STRIP: number;
        static TRIANGLES: number;
        static TRIANGLE_STRIP: number;
        static TRIANGLE_FAN: number;
        static ZERO: number;
        static ONE: number;
        static SRC_COLOR: number;
        static ONE_MINUS_SRC_COLOR: number;
        static SRC_ALPHA: number;
        static ONE_MINUS_SRC_ALPHA: number;
        static DST_ALPHA: number;
        static ONE_MINUS_DST_ALPHA: number;
        static DST_COLOR: number;
        static ONE_MINUS_DST_COLOR: number;
        static SRC_ALPHA_SATURATE: number;
        static FUNC_ADD: number;
        static BLEND_EQUATION: number;
        static BLEND_EQUATION_RGB: number;
        static BLEND_EQUATION_ALPHA: number;
        static FUNC_SUBTRACT: number;
        static FUNC_REVERSE_SUBTRACT: number;
        static BLEND_DST_RGB: number;
        static BLEND_SRC_RGB: number;
        static BLEND_DST_ALPHA: number;
        static BLEND_SRC_ALPHA: number;
        static CONSTANT_COLOR: number;
        static ONE_MINUS_CONSTANT_COLOR: number;
        static CONSTANT_ALPHA: number;
        static ONE_MINUS_CONSTANT_ALPHA: number;
        static BLEND_COLOR: number;
        static ARRAY_BUFFER: number;
        static ELEMENT_ARRAY_BUFFER: number;
        static ARRAY_BUFFER_BINDING: number;
        static ELEMENT_ARRAY_BUFFER_BINDING: number;
        static STREAM_DRAW: number;
        static STATIC_DRAW: number;
        static DYNAMIC_DRAW: number;
        static BUFFER_SIZE: number;
        static BUFFER_USAGE: number;
        static CURRENT_VERTEX_ATTRIB: number;
        static FRONT: number;
        static BACK: number;
        static CULL_FACE: number;
        static FRONT_AND_BACK: number;
        static BLEND: number;
        static DITHER: number;
        static STENCIL_TEST: number;
        static DEPTH_TEST: number;
        static SCISSOR_TEST: number;
        static POLYGON_OFFSET_FILL: number;
        static SAMPLE_ALPHA_TO_COVERAGE: number;
        static SAMPLE_COVERAGE: number;
        static NO_ERROR: number;
        static INVALID_ENUM: number;
        static INVALID_VALUE: number;
        static INVALID_OPERATION: number;
        static OUT_OF_MEMORY: number;
        static CW: number;
        static CCW: number;
        static LINE_WIDTH: number;
        static ALIASED_POINT_SIZE_RANGE: number;
        static ALIASED_LINE_WIDTH_RANGE: number;
        static CULL_FACE_MODE: number;
        static FRONT_FACE: number;
        static DEPTH_RANGE: number;
        static DEPTH_WRITEMASK: number;
        static DEPTH_CLEAR_VALUE: number;
        static DEPTH_FUNC: number;
        static STENCIL_CLEAR_VALUE: number;
        static STENCIL_FUNC: number;
        static STENCIL_FAIL: number;
        static STENCIL_PASS_DEPTH_FAIL: number;
        static STENCIL_PASS_DEPTH_PASS: number;
        static STENCIL_REF: number;
        static STENCIL_VALUE_MASK: number;
        static STENCIL_WRITEMASK: number;
        static STENCIL_BACK_FUNC: number;
        static STENCIL_BACK_FAIL: number;
        static STENCIL_BACK_PASS_DEPTH_FAIL: number;
        static STENCIL_BACK_PASS_DEPTH_PASS: number;
        static STENCIL_BACK_REF: number;
        static STENCIL_BACK_VALUE_MASK: number;
        static STENCIL_BACK_WRITEMASK: number;
        static VIEWPORT: number;
        static SCISSOR_BOX: number;
        static COLOR_CLEAR_VALUE: number;
        static COLOR_WRITEMASK: number;
        static UNPACK_ALIGNMENT: number;
        static PACK_ALIGNMENT: number;
        static MAX_TEXTURE_SIZE: number;
        static MAX_VIEWPORT_DIMS: number;
        static SUBPIXEL_BITS: number;
        static RED_BITS: number;
        static GREEN_BITS: number;
        static BLUE_BITS: number;
        static ALPHA_BITS: number;
        static DEPTH_BITS: number;
        static STENCIL_BITS: number;
        static POLYGON_OFFSET_UNITS: number;
        static POLYGON_OFFSET_FACTOR: number;
        static TEXTURE_BINDING_2D: number;
        static SAMPLE_BUFFERS: number;
        static SAMPLES: number;
        static SAMPLE_COVERAGE_VALUE: number;
        static SAMPLE_COVERAGE_INVERT: number;
        static NUM_COMPRESSED_TEXTURE_FORMATS: number;
        static COMPRESSED_TEXTURE_FORMATS: number;
        static DONT_CARE: number;
        static FASTEST: number;
        static NICEST: number;
        static GENERATE_MIPMAP_HINT: number;
        static BYTE: number;
        static UNSIGNED_BYTE: number;
        static SHORT: number;
        static UNSIGNED_SHORT: number;
        static INT: number;
        static UNSIGNED_INT: number;
        static FLOAT: number;
        static DEPTH_COMPONENT: number;
        static ALPHA: number;
        static RGB: number;
        static RGBA: number;
        static LUMINANCE: number;
        static LUMINANCE_ALPHA: number;
        static UNSIGNED_SHORT_4_4_4_4: number;
        static UNSIGNED_SHORT_5_5_5_1: number;
        static UNSIGNED_SHORT_5_6_5: number;
        static FRAGMENT_SHADER: number;
        static VERTEX_SHADER: number;
        static MAX_VERTEX_ATTRIBS: number;
        static MAX_VERTEX_UNIFORM_VECTORS: number;
        static MAX_VARYING_VECTORS: number;
        static MAX_COMBINED_TEXTURE_IMAGE_UNITS: number;
        static MAX_VERTEX_TEXTURE_IMAGE_UNITS: number;
        static MAX_TEXTURE_IMAGE_UNITS: number;
        static MAX_FRAGMENT_UNIFORM_VECTORS: number;
        static SHADER_TYPE: number;
        static DELETE_STATUS: number;
        static LINK_STATUS: number;
        static VALIDATE_STATUS: number;
        static ATTACHED_SHADERS: number;
        static ACTIVE_UNIFORMS: number;
        static ACTIVE_ATTRIBUTES: number;
        static SHADING_LANGUAGE_VERSION: number;
        static CURRENT_PROGRAM: number;
        static NEVER: number;
        static LESS: number;
        static EQUAL: number;
        static LEQUAL: number;
        static GREATER: number;
        static NOTEQUAL: number;
        static GEQUAL: number;
        static ALWAYS: number;
        static KEEP: number;
        static REPLACE: number;
        static INCR: number;
        static DECR: number;
        static INVERT: number;
        static INCR_WRAP: number;
        static DECR_WRAP: number;
        static VENDOR: number;
        static RENDERER: number;
        static VERSION: number;
        static NEAREST: number;
        static LINEAR: number;
        static NEAREST_MIPMAP_NEAREST: number;
        static LINEAR_MIPMAP_NEAREST: number;
        static NEAREST_MIPMAP_LINEAR: number;
        static LINEAR_MIPMAP_LINEAR: number;
        static TEXTURE_MAG_FILTER: number;
        static TEXTURE_MIN_FILTER: number;
        static TEXTURE_WRAP_S: number;
        static TEXTURE_WRAP_T: number;
        static TEXTURE_2D: number;
        static TEXTURE: number;
        static TEXTURE_CUBE_MAP: number;
        static TEXTURE_BINDING_CUBE_MAP: number;
        static TEXTURE_CUBE_MAP_POSITIVE_X: number;
        static TEXTURE_CUBE_MAP_NEGATIVE_X: number;
        static TEXTURE_CUBE_MAP_POSITIVE_Y: number;
        static TEXTURE_CUBE_MAP_NEGATIVE_Y: number;
        static TEXTURE_CUBE_MAP_POSITIVE_Z: number;
        static TEXTURE_CUBE_MAP_NEGATIVE_Z: number;
        static MAX_CUBE_MAP_TEXTURE_SIZE: number;
        static TEXTURE0: number;
        static TEXTURE1: number;
        static TEXTURE2: number;
        static TEXTURE3: number;
        static TEXTURE4: number;
        static TEXTURE5: number;
        static TEXTURE6: number;
        static TEXTURE7: number;
        static TEXTURE8: number;
        static TEXTURE9: number;
        static TEXTURE10: number;
        static TEXTURE11: number;
        static TEXTURE12: number;
        static TEXTURE13: number;
        static TEXTURE14: number;
        static TEXTURE15: number;
        static TEXTURE16: number;
        static TEXTURE17: number;
        static TEXTURE18: number;
        static TEXTURE19: number;
        static TEXTURE20: number;
        static TEXTURE21: number;
        static TEXTURE22: number;
        static TEXTURE23: number;
        static TEXTURE24: number;
        static TEXTURE25: number;
        static TEXTURE26: number;
        static TEXTURE27: number;
        static TEXTURE28: number;
        static TEXTURE29: number;
        static TEXTURE30: number;
        static TEXTURE31: number;
        static ACTIVE_TEXTURE: number;
        static REPEAT: number;
        static CLAMP_TO_EDGE: number;
        static MIRRORED_REPEAT: number;
        static FLOAT_VEC2: number;
        static FLOAT_VEC3: number;
        static FLOAT_VEC4: number;
        static INT_VEC2: number;
        static INT_VEC3: number;
        static INT_VEC4: number;
        static BOOL: number;
        static BOOL_VEC2: number;
        static BOOL_VEC3: number;
        static BOOL_VEC4: number;
        static FLOAT_MAT2: number;
        static FLOAT_MAT3: number;
        static FLOAT_MAT4: number;
        static SAMPLER_2D: number;
        static SAMPLER_CUBE: number;
        static VERTEX_ATTRIB_ARRAY_ENABLED: number;
        static VERTEX_ATTRIB_ARRAY_SIZE: number;
        static VERTEX_ATTRIB_ARRAY_STRIDE: number;
        static VERTEX_ATTRIB_ARRAY_TYPE: number;
        static VERTEX_ATTRIB_ARRAY_NORMALIZED: number;
        static VERTEX_ATTRIB_ARRAY_POINTER: number;
        static VERTEX_ATTRIB_ARRAY_BUFFER_BINDING: number;
        static COMPILE_STATUS: number;
        static LOW_FLOAT: number;
        static MEDIUM_FLOAT: number;
        static HIGH_FLOAT: number;
        static LOW_INT: number;
        static MEDIUM_INT: number;
        static HIGH_INT: number;
        static FRAMEBUFFER: number;
        static RENDERBUFFER: number;
        static RGBA4: number;
        static RGB5_A1: number;
        static RGB565: number;
        static DEPTH_COMPONENT16: number;
        static STENCIL_INDEX: number;
        static STENCIL_INDEX8: number;
        static DEPTH_STENCIL: number;
        static RENDERBUFFER_WIDTH: number;
        static RENDERBUFFER_HEIGHT: number;
        static RENDERBUFFER_INTERNAL_FORMAT: number;
        static RENDERBUFFER_RED_SIZE: number;
        static RENDERBUFFER_GREEN_SIZE: number;
        static RENDERBUFFER_BLUE_SIZE: number;
        static RENDERBUFFER_ALPHA_SIZE: number;
        static RENDERBUFFER_DEPTH_SIZE: number;
        static RENDERBUFFER_STENCIL_SIZE: number;
        static FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE: number;
        static FRAMEBUFFER_ATTACHMENT_OBJECT_NAME: number;
        static FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL: number;
        static FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE: number;
        static COLOR_ATTACHMENT0: number;
        static DEPTH_ATTACHMENT: number;
        static STENCIL_ATTACHMENT: number;
        static DEPTH_STENCIL_ATTACHMENT: number;
        static NONE: number;
        static FRAMEBUFFER_COMPLETE: number;
        static FRAMEBUFFER_INCOMPLETE_ATTACHMENT: number;
        static FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT: number;
        static FRAMEBUFFER_INCOMPLETE_DIMENSIONS: number;
        static FRAMEBUFFER_UNSUPPORTED: number;
        static FRAMEBUFFER_BINDING: number;
        static RENDERBUFFER_BINDING: number;
        static MAX_RENDERBUFFER_SIZE: number;
        static INVALID_FRAMEBUFFER_OPERATION: number;
        static UNPACK_FLIP_Y_WEBGL: number;
        static UNPACK_PREMULTIPLY_ALPHA_WEBGL: number;
        static CONTEXT_LOST_WEBGL: number;
        static UNPACK_COLORSPACE_CONVERSION_WEBGL: number;
        static BROWSER_DEFAULT_WEBGL: number;
        static _useProgram: any;
        static UseProgram(program: any): boolean;
        static _depthTest: boolean;
        static _depthMask: boolean;
        static _depthFunc: number;
        static _blend: boolean;
        static _sFactor: number;
        static _dFactor: number;
        static _cullFace: boolean;
        static _frontFace: number;
        static curBindTexTarget: any;
        static curBindTexValue: any;
        static setDepthTest(gl: WebGLContext, value: boolean): void;
        static setDepthMask(gl: WebGLContext, value: boolean): void;
        static setDepthFunc(gl: WebGLContext, value: number): void;
        static setBlend(gl: WebGLContext, value: boolean): void;
        static setBlendFunc(gl: WebGLContext, sFactor: number, dFactor: number): void;
        static setCullFace(gl: WebGLContext, value: boolean): void;
        static setFrontFace(gl: WebGLContext, value: number): void;
        static bindTexture(gl: WebGLContext, target: any, texture: any): void;
        alpha: number;
        depth: number;
        stencil: number;
        antialias: number;
        premultipliedAlpha: number;
        preserveDrawingBuffer: number;
        drawingBufferWidth: number;
        drawingBufferHeight: number;
        getAttachedShaders: any;
        uniform_float: any;
        getContextAttributes(): any;
        isContextLost(): void;
        getSupportedExtensions(): any;
        getExtension(name: string): any;
        activeTexture(texture: any): void;
        attachShader(program: any, shader: any): void;
        bindAttribLocation(program: any, index: number, name: string): void;
        bindBuffer(target: any, buffer: any): void;
        bindFramebuffer(target: any, framebuffer: any): void;
        bindRenderbuffer(target: any, renderbuffer: any): void;
        bindTexture(target: any, texture: any): void;
        useTexture(value: boolean): void;
        blendColor(red: any, green: any, blue: any, alpha: number): void;
        blendEquation(mode: any): void;
        blendEquationSeparate(modeRGB: any, modeAlpha: any): void;
        blendFunc(sfactor: any, dfactor: any): void;
        blendFuncSeparate(srcRGB: any, dstRGB: any, srcAlpha: any, dstAlpha: any): void;
        bufferData(target: any, size: any, usage: any): void;
        bufferSubData(target: any, offset: number, data: any): void;
        checkFramebufferStatus(target: any): any;
        clear(mask: number): void;
        clearColor(red: any, green: any, blue: any, alpha: number): void;
        clearDepth(depth: any): void;
        clearStencil(s: any): void;
        colorMask(red: boolean, green: boolean, blue: boolean, alpha: boolean): void;
        compileShader(shader: any): void;
        copyTexImage2D(target: any, level: any, internalformat: any, x: number, y: number, width: number, height: number, border: any): void;
        copyTexSubImage2D(target: any, level: any, xoffset: number, yoffset: number, x: number, y: number, width: number, height: number): void;
        createBuffer(): any;
        createFramebuffer(): any;
        createProgram(): any;
        createRenderbuffer(): any;
        createShader(type: any): any;
        createTexture(): any;
        cullFace(mode: any): void;
        deleteBuffer(buffer: any): void;
        deleteFramebuffer(framebuffer: any): void;
        deleteProgram(program: any): void;
        deleteRenderbuffer(renderbuffer: any): void;
        deleteShader(shader: any): void;
        deleteTexture(texture: any): void;
        depthFunc(func: any): void;
        depthMask(flag: any): void;
        depthRange(zNear: any, zFar: any): void;
        detachShader(program: any, shader: any): void;
        disable(cap: any): void;
        disableVertexAttribArray(index: number): void;
        drawArrays(mode: any, first: number, count: number): void;
        drawElements(mode: any, count: number, type: any, offset: number): void;
        enable(cap: any): void;
        enableVertexAttribArray(index: number): void;
        finish(): void;
        flush(): void;
        framebufferRenderbuffer(target: any, attachment: any, renderbuffertarget: any, renderbuffer: any): void;
        framebufferTexture2D(target: any, attachment: any, textarget: any, texture: any, level: any): void;
        frontFace(mode: any): any;
        generateMipmap(target: any): any;
        getActiveAttrib(program: any, index: number): any;
        getActiveUniform(program: any, index: number): any;
        getAttribLocation(program: any, name: string): any;
        getParameter(pname: any): any;
        getBufferParameter(target: any, pname: any): any;
        getError(): any;
        getFramebufferAttachmentParameter(target: any, attachment: any, pname: any): void;
        getProgramParameter(program: any, pname: any): number;
        getProgramInfoLog(program: any): any;
        getRenderbufferParameter(target: any, pname: any): any;
        getShaderPrecisionFormat(...arg: any[]): any;
        getShaderParameter(shader: any, pname: any): any;
        getShaderInfoLog(shader: any): any;
        getShaderSource(shader: any): any;
        getTexParameter(target: any, pname: any): void;
        getUniform(program: any, location: number): void;
        getUniformLocation(program: any, name: string): any;
        getVertexAttrib(index: number, pname: any): any;
        getVertexAttribOffset(index: number, pname: any): any;
        hint(target: any, mode: any): void;
        isBuffer(buffer: any): void;
        isEnabled(cap: any): void;
        isFramebuffer(framebuffer: any): void;
        isProgram(program: any): void;
        isRenderbuffer(renderbuffer: any): void;
        isShader(shader: any): void;
        isTexture(texture: any): void;
        lineWidth(width: number): void;
        linkProgram(program: any): void;
        pixelStorei(pname: any, param: any): void;
        polygonOffset(factor: any, units: any): void;
        readPixels(x: number, y: number, width: number, height: number, format: any, type: any, pixels: any): void;
        renderbufferStorage(target: any, internalformat: any, width: number, height: number): void;
        sampleCoverage(value: any, invert: any): void;
        scissor(x: number, y: number, width: number, height: number): void;
        shaderSource(shader: any, source: any): void;
        stencilFunc(func: number, ref: number, mask: number): void;
        stencilFuncSeparate(face: number, func: number, ref: number, mask: number): void;
        stencilMask(mask: any): void;
        stencilMaskSeparate(face: any, mask: any): void;
        stencilOp(fail: number, zfail: number, zpass: number): void;
        stencilOpSeparate(face: number, fail: number, zfail: number, zpass: number): void;
        texImage2D(...args: any[]): void;
        texParameterf(target: any, pname: any, param: any): void;
        texParameteri(target: any, pname: any, param: any): void;
        texSubImage2D(...args: any[]): void;
        uniform1f(location: any, x: number): void;
        uniform1fv(location: any, v: any): void;
        uniform1i(location: any, x: number): void;
        uniform1iv(location: any, v: any): void;
        uniform2f(location: any, x: number, y: number): void;
        uniform2fv(location: any, v: any): void;
        uniform2i(location: any, x: number, y: number): void;
        uniform2iv(location: any, v: any): void;
        uniform3f(location: any, x: number, y: number, z: number): void;
        uniform3fv(location: any, v: any): void;
        uniform3i(location: any, x: number, y: number, z: number): void;
        uniform3iv(location: any, v: any): void;
        uniform4f(location: any, x: number, y: number, z: number, w: number): void;
        uniform4fv(location: any, v: any): void;
        uniform4i(location: any, x: number, y: number, z: number, w: number): void;
        uniform4iv(location: any, v: any): void;
        uniformMatrix2fv(location: any, transpose: any, value: any): void;
        uniformMatrix3fv(location: any, transpose: any, value: any): void;
        uniformMatrix4fv(location: any, transpose: any, value: any): void;
        useProgram(program: any): void;
        validateProgram(program: any): void;
        vertexAttrib1f(indx: any, x: number): void;
        vertexAttrib1fv(indx: any, values: any): void;
        vertexAttrib2f(indx: any, x: number, y: number): void;
        vertexAttrib2fv(indx: any, values: any): void;
        vertexAttrib3f(indx: any, x: number, y: number, z: number): void;
        vertexAttrib3fv(indx: any, values: any): void;
        vertexAttrib4f(indx: any, x: number, y: number, z: number, w: number): void;
        vertexAttrib4fv(indx: any, values: any): void;
        vertexAttribPointer(indx: any, size: any, type: any, normalized: any, stride: any, offset: number): void;
        viewport(x: number, y: number, width: number, height: number): void;
        configureBackBuffer(width: number, height: number, antiAlias: number, enableDepthAndStencil?: boolean, wantsBestResolution?: boolean): void;
    }
}
declare module Laya {
    class AnimationContent extends laya.ani.AnimationContent {
    }
    class AnimationNodeContent extends laya.ani.AnimationNodeContent {
    }
    class AnimationParser01 extends laya.ani.AnimationParser01 {
    }
    class AnimationParser02 extends laya.ani.AnimationParser02 {
    }
    class AnimationPlayer extends laya.ani.AnimationPlayer {
    }
    class AnimationState extends laya.ani.AnimationState {
    }
    class AnimationTemplet extends laya.ani.AnimationTemplet {
    }
    class Bone extends laya.ani.bone.Bone {
    }
    class BoneSlot extends laya.ani.bone.BoneSlot {
    }
    class DeformAniData extends laya.ani.bone.DeformAniData {
    }
    class DeformSlotData extends laya.ani.bone.DeformSlotData {
    }
    class DeformSlotDisplayData extends laya.ani.bone.DeformSlotDisplayData {
    }
    class DrawOrderData extends laya.ani.bone.DrawOrderData {
    }
    class EventData extends laya.ani.bone.EventData {
    }
    class IkConstraint extends laya.ani.bone.IkConstraint {
    }
    class IkConstraintData extends laya.ani.bone.IkConstraintData {
    }
    class PathConstraint extends laya.ani.bone.PathConstraint {
    }
    class PathConstraintData extends laya.ani.bone.PathConstraintData {
    }
    class Skeleton extends laya.ani.bone.Skeleton {
    }
    class SkinData extends laya.ani.bone.SkinData {
    }
    class SkinSlotDisplayData extends laya.ani.bone.SkinSlotDisplayData {
    }
    class SlotData extends laya.ani.bone.SlotData {
    }
    class Templet extends laya.ani.bone.Templet {
    }
    class TfConstraint extends laya.ani.bone.TfConstraint {
    }
    class TfConstraintData extends laya.ani.bone.TfConstraintData {
    }
    class Transform extends laya.ani.bone.Transform {
    }
    class UVTools extends laya.ani.bone.UVTools {
    }
    class GraphicsAni extends laya.ani.GraphicsAni {
    }
    class KeyFramesContent extends laya.ani.KeyFramesContent {
    }
    class BezierLerp extends laya.ani.math.BezierLerp {
    }
    class MovieClip extends laya.ani.swf.MovieClip {
    }
    class CameraAnimations extends laya.d3.component.animation.CameraAnimations {
    }
    class KeyframeAnimations extends laya.d3.component.animation.KeyframeAnimations {
    }
    class RigidAnimations extends laya.d3.component.animation.RigidAnimations {
    }
    class SkinAnimations extends laya.d3.component.animation.SkinAnimations {
    }
    class UVAnimations extends laya.d3.component.animation.UVAnimations {
    }
    class AttachPoint extends laya.d3.component.AttachPoint {
    }
    class Component3D extends laya.d3.component.Component3D {
    }
    class PathFind extends laya.d3.component.PathFind {
    }
    class BoxCollider extends laya.d3.component.physics.BoxCollider {
    }
    class Collider extends laya.d3.component.physics.Collider {
    }
    class MeshCollider extends laya.d3.component.physics.MeshCollider {
    }
    class SphereCollider extends laya.d3.component.physics.SphereCollider {
    }
    class Script extends laya.d3.component.Script {
    }
    class BaseCamera extends laya.d3.core.BaseCamera {
    }
    class Camera extends laya.d3.core.Camera {
    }
    class GeometryFilter extends laya.d3.core.GeometryFilter {
    }
    class Glitter extends laya.d3.core.glitter.Glitter {
    }
    class SplineCurvePosition extends laya.d3.core.glitter.SplineCurvePosition {
    }
    class SplineCurvePositionVelocity extends laya.d3.core.glitter.SplineCurvePositionVelocity {
    }
    class GlitterRender extends laya.d3.core.GlitterRender {
    }
    class HeightMap extends laya.d3.core.HeightMap {
    }
    interface IClone extends laya.d3.core.IClone {
    }
    class Layer extends laya.d3.core.Layer {
    }
    class DirectionLight extends laya.d3.core.light.DirectionLight {
    }
    class LightSprite extends laya.d3.core.light.LightSprite {
    }
    class PointLight extends laya.d3.core.light.PointLight {
    }
    class SpotLight extends laya.d3.core.light.SpotLight {
    }
    class BaseMaterial extends laya.d3.core.material.BaseMaterial {
    }
    class GlitterMaterial extends laya.d3.core.material.GlitterMaterial {
    }
    class ParticleMaterial extends laya.d3.core.material.ParticleMaterial {
    }
    class PBRMaterial extends laya.d3.core.material.PBRMaterial {
    }
    class StandardMaterial extends laya.d3.core.material.StandardMaterial {
    }
    class TerrainMaterial extends laya.d3.core.material.TerrainMaterial {
    }
    class WaterMaterial extends laya.d3.core.material.WaterMaterial {
    }
    class MeshFilter extends laya.d3.core.MeshFilter {
    }
    class MeshRender extends laya.d3.core.MeshRender {
    }
    class MeshSprite3D extends laya.d3.core.MeshSprite3D {
    }
    class MeshTerrainSprite3D extends laya.d3.core.MeshTerrainSprite3D {
    }
    class EmitterBox extends laya.d3.core.particle.EmitterBox {
    }
    class EmitterPoint extends laya.d3.core.particle.EmitterPoint {
    }
    class EmitterRing extends laya.d3.core.particle.EmitterRing {
    }
    class EmitterSphere extends laya.d3.core.particle.EmitterSphere {
    }
    class Particle3D extends laya.d3.core.particle.Particle3D {
    }
    class ParticleRender extends laya.d3.core.ParticleRender {
    }
    class Burst extends laya.d3.core.particleShuriKen.module.Burst {
    }
    class ColorOverLifetime extends laya.d3.core.particleShuriKen.module.ColorOverLifetime {
    }
    class Emission extends laya.d3.core.particleShuriKen.module.Emission {
    }
    class FrameOverTime extends laya.d3.core.particleShuriKen.module.FrameOverTime {
    }
    class GradientAngularVelocity extends laya.d3.core.particleShuriKen.module.GradientAngularVelocity {
    }
    class GradientColor extends laya.d3.core.particleShuriKen.module.GradientColor {
    }
    class GradientDataColor extends laya.d3.core.particleShuriKen.module.GradientDataColor {
    }
    class GradientDataInt extends laya.d3.core.particleShuriKen.module.GradientDataInt {
    }
    class GradientDataNumber extends laya.d3.core.particleShuriKen.module.GradientDataNumber {
    }
    class GradientDataVector2 extends laya.d3.core.particleShuriKen.module.GradientDataVector2 {
    }
    class GradientSize extends laya.d3.core.particleShuriKen.module.GradientSize {
    }
    class GradientVelocity extends laya.d3.core.particleShuriKen.module.GradientVelocity {
    }
    class RotationOverLifetime extends laya.d3.core.particleShuriKen.module.RotationOverLifetime {
    }
    class BaseShape extends laya.d3.core.particleShuriKen.module.shape.BaseShape {
    }
    class BoxShape extends laya.d3.core.particleShuriKen.module.shape.BoxShape {
    }
    class CircleShape extends laya.d3.core.particleShuriKen.module.shape.CircleShape {
    }
    class ConeShape extends laya.d3.core.particleShuriKen.module.shape.ConeShape {
    }
    class HemisphereShape extends laya.d3.core.particleShuriKen.module.shape.HemisphereShape {
    }
    class ShapeUtils extends laya.d3.core.particleShuriKen.module.shape.ShapeUtils {
    }
    class SphereShape extends laya.d3.core.particleShuriKen.module.shape.SphereShape {
    }
    class SizeOverLifetime extends laya.d3.core.particleShuriKen.module.SizeOverLifetime {
    }
    class StartFrame extends laya.d3.core.particleShuriKen.module.StartFrame {
    }
    class TextureSheetAnimation extends laya.d3.core.particleShuriKen.module.TextureSheetAnimation {
    }
    class VelocityOverLifetime extends laya.d3.core.particleShuriKen.module.VelocityOverLifetime {
    }
    class ShuriKenParticle3D extends laya.d3.core.particleShuriKen.ShuriKenParticle3D {
    }
    class ShurikenParticleData extends laya.d3.core.particleShuriKen.ShurikenParticleData {
    }
    class ShurikenParticleMaterial extends laya.d3.core.particleShuriKen.ShurikenParticleMaterial {
    }
    class ShurikenParticleRender extends laya.d3.core.particleShuriKen.ShurikenParticleRender {
    }
    class ShurikenParticleSystem extends laya.d3.core.particleShuriKen.ShurikenParticleSystem {
    }
    class PhasorSpriter3D extends laya.d3.core.PhasorSpriter3D {
    }
    class BaseRender extends laya.d3.core.render.BaseRender {
    }
    interface IRenderable extends laya.d3.core.render.IRenderable {
    }
    interface IUpdate extends laya.d3.core.render.IUpdate {
    }
    class RenderElement extends laya.d3.core.render.RenderElement {
    }
    class RenderQueue extends laya.d3.core.render.RenderQueue {
    }
    class RenderState extends laya.d3.core.render.RenderState {
    }
    class RenderableSprite3D extends laya.d3.core.RenderableSprite3D {
    }
    class BaseScene extends laya.d3.core.scene.BaseScene {
    }
    interface ITreeNode extends laya.d3.core.scene.ITreeNode {
    }
    class OctreeNode extends laya.d3.core.scene.OctreeNode {
    }
    class Scene extends laya.d3.core.scene.Scene {
    }
    class VRScene extends laya.d3.core.scene.VRScene {
    }
    class Sprite3D extends laya.d3.core.Sprite3D {
    }
    class Transform3D extends laya.d3.core.Transform3D {
    }
    class TransformUV extends laya.d3.core.TransformUV {
    }
    class VRCamera extends laya.d3.core.VRCamera {
    }
    class DynamicBatch extends laya.d3.graphics.DynamicBatch {
    }
    class DynamicBatchManager extends laya.d3.graphics.DynamicBatchManager {
    }
    class FrustumCulling extends laya.d3.graphics.FrustumCulling {
    }
    class IndexBuffer3D extends laya.d3.graphics.IndexBuffer3D {
    }
    interface IVertex extends laya.d3.graphics.IVertex {
    }
    class StaticBatch extends laya.d3.graphics.StaticBatch {
    }
    class StaticBatchManager extends laya.d3.graphics.StaticBatchManager {
    }
    class VertexBuffer3D extends laya.d3.graphics.VertexBuffer3D {
    }
    class VertexDeclaration extends laya.d3.graphics.VertexDeclaration {
    }
    class VertexElement extends laya.d3.graphics.VertexElement {
    }
    class VertexElementFormat extends laya.d3.graphics.VertexElementFormat {
    }
    class VertexElementUsage extends laya.d3.graphics.VertexElementUsage {
    }
    class VertexGlitter extends laya.d3.graphics.VertexGlitter {
    }
    class VertexParticle extends laya.d3.graphics.VertexParticle {
    }
    class VertexParticleShuriken extends laya.d3.graphics.VertexParticleShuriken {
    }
    class VertexPositionNormalColor extends laya.d3.graphics.VertexPositionNormalColor {
    }
    class VertexPositionNormalColorSkin extends laya.d3.graphics.VertexPositionNormalColorSkin {
    }
    class VertexPositionNormalColorSkinTangent extends laya.d3.graphics.VertexPositionNormalColorSkinTangent {
    }
    class VertexPositionNormalColorTangent extends laya.d3.graphics.VertexPositionNormalColorTangent {
    }
    class VertexPositionNormalColorTexture extends laya.d3.graphics.VertexPositionNormalColorTexture {
    }
    class VertexPositionNormalColorTexture0Texture1 extends laya.d3.graphics.VertexPositionNormalColorTexture0Texture1 {
    }
    class VertexPositionNormalColorTexture0Texture1Skin extends laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin {
    }
    class VertexPositionNormalColorTexture0Texture1SkinTangent extends laya.d3.graphics.VertexPositionNormalColorTexture0Texture1SkinTangent {
    }
    class VertexPositionNormalColorTexture0Texture1Tangent extends laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Tangent {
    }
    class VertexPositionNormalColorTextureSkin extends laya.d3.graphics.VertexPositionNormalColorTextureSkin {
    }
    class VertexPositionNormalColorTextureSkinTangent extends laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent {
    }
    class VertexPositionNormalColorTextureTangent extends laya.d3.graphics.VertexPositionNormalColorTextureTangent {
    }
    class VertexPositionNormalTexture extends laya.d3.graphics.VertexPositionNormalTexture {
    }
    class VertexPositionNormalTexture0Texture1 extends laya.d3.graphics.VertexPositionNormalTexture0Texture1 {
    }
    class VertexPositionNormalTexture0Texture1Skin extends laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin {
    }
    class VertexPositionNormalTexture0Texture1SkinTangent extends laya.d3.graphics.VertexPositionNormalTexture0Texture1SkinTangent {
    }
    class VertexPositionNormalTexture0Texture1Tangent extends laya.d3.graphics.VertexPositionNormalTexture0Texture1Tangent {
    }
    class VertexPositionNormalTextureSkin extends laya.d3.graphics.VertexPositionNormalTextureSkin {
    }
    class VertexPositionNormalTextureSkinTangent extends laya.d3.graphics.VertexPositionNormalTextureSkinTangent {
    }
    class VertexPositionNormalTextureTangent extends laya.d3.graphics.VertexPositionNormalTextureTangent {
    }
    class VertexPositionNTBTexture extends laya.d3.graphics.VertexPositionNTBTexture {
    }
    class VertexPositionNTBTextureSkin extends laya.d3.graphics.VertexPositionNTBTextureSkin {
    }
    class VertexPositionTerrain extends laya.d3.graphics.VertexPositionTerrain {
    }
    class LoadModelV01 extends laya.d3.loaders.LoadModelV01 {
    }
    class LoadModelV02 extends laya.d3.loaders.LoadModelV02 {
    }
    class MeshReader extends laya.d3.loaders.MeshReader {
    }
    class BoundBox extends laya.d3.math.BoundBox {
    }
    class BoundFrustum extends laya.d3.math.BoundFrustum {
    }
    class BoundSphere extends laya.d3.math.BoundSphere {
    }
    class Collision extends laya.d3.math.Collision {
    }
    class ContainmentType extends laya.d3.math.ContainmentType {
    }
    class MathUtils3D extends laya.d3.math.MathUtils3D {
    }
    class Matrix3x3 extends laya.d3.math.Matrix3x3 {
    }
    class Matrix4x4 extends laya.d3.math.Matrix4x4 {
    }
    class OrientedBoundBox extends laya.d3.math.OrientedBoundBox {
    }
    class Plane extends laya.d3.math.Plane {
    }
    class Quaternion extends laya.d3.math.Quaternion {
    }
    class Rand extends laya.d3.math.Rand {
    }
    class RandX extends laya.d3.math.RandX {
    }
    class Ray extends laya.d3.math.Ray {
    }
    class Vector2 extends laya.d3.math.Vector2 {
    }
    class Vector3 extends laya.d3.math.Vector3 {
    }
    class Vector4 extends laya.d3.math.Vector4 {
    }
    class Viewport extends laya.d3.math.Viewport {
    }
    class BaseTexture extends laya.d3.resource.BaseTexture {
    }
    class DataTexture2D extends laya.d3.resource.DataTexture2D {
    }
    class BaseMesh extends laya.d3.resource.models.BaseMesh {
    }
    class BoxMesh extends laya.d3.resource.models.BoxMesh {
    }
    class CapsuleMesh extends laya.d3.resource.models.CapsuleMesh {
    }
    class CylinderMesh extends laya.d3.resource.models.CylinderMesh {
    }
    class Mesh extends laya.d3.resource.models.Mesh {
    }
    class PlaneMesh extends laya.d3.resource.models.PlaneMesh {
    }
    class PrimitiveMesh extends laya.d3.resource.models.PrimitiveMesh {
    }
    class QuadMesh extends laya.d3.resource.models.QuadMesh {
    }
    class Sky extends laya.d3.resource.models.Sky {
    }
    class SkyBox extends laya.d3.resource.models.SkyBox {
    }
    class SkyDome extends laya.d3.resource.models.SkyDome {
    }
    class SphereMesh extends laya.d3.resource.models.SphereMesh {
    }
    class SubMesh extends laya.d3.resource.models.SubMesh {
    }
    class RenderTexture extends laya.d3.resource.RenderTexture {
    }
    class SolidColorTexture2D extends laya.d3.resource.SolidColorTexture2D {
    }
    class SolidColorTextureCube extends laya.d3.resource.SolidColorTextureCube {
    }
    class GlitterTemplet extends laya.d3.resource.tempelet.GlitterTemplet {
    }
    class ParticleTemplet3D extends laya.d3.resource.tempelet.ParticleTemplet3D {
    }
    class Texture2D extends laya.d3.resource.Texture2D {
    }
    class TextureCube extends laya.d3.resource.TextureCube {
    }
    class Shader3D extends laya.d3.shader.Shader3D {
    }
    class ShaderCompile3D extends laya.d3.shader.ShaderCompile3D {
    }
    class ValusArray extends laya.d3.shader.ValusArray {
    }
    class ParallelSplitShadowMap extends laya.d3.shadowMap.ParallelSplitShadowMap {
    }
    class Terrain extends laya.d3.terrain.Terrain {
    }
    class TerrainChunk extends laya.d3.terrain.TerrainChunk {
    }
    class TerrainFilter extends laya.d3.terrain.TerrainFilter {
    }
    class TerrainHeightData extends laya.d3.terrain.TerrainHeightData {
    }
    class TerrainLeaf extends laya.d3.terrain.TerrainLeaf {
    }
    class TerrainRender extends laya.d3.terrain.TerrainRender {
    }
    class TerrainRes extends laya.d3.terrain.TerrainRes {
    }
    class ChunkInfo extends laya.d3.terrain.unit.ChunkInfo {
    }
    class DetailTextureInfo extends laya.d3.terrain.unit.DetailTextureInfo {
    }
    class Physics extends laya.d3.utils.Physics {
    }
    class Picker extends laya.d3.utils.Picker {
    }
    class RaycastHit extends laya.d3.utils.RaycastHit {
    }
    class Size extends laya.d3.utils.Size {
    }
    class Utils3D extends laya.d3.utils.Utils3D {
    }
    class WaterDetailMaterial extends laya.d3.water.WaterDetailMaterial {
    }
    class WaterRender extends laya.d3.water.WaterRender {
    }
    class WaterSprite extends laya.d3.water.WaterSprite {
    }
    class Geolocation extends laya.device.geolocation.Geolocation {
    }
    class GeolocationInfo extends laya.device.geolocation.GeolocationInfo {
    }
    class HtmlVideo extends laya.device.media.HtmlVideo {
    }
    class Media extends laya.device.media.Media {
    }
    class Video extends laya.device.media.Video {
    }
    class WebGLVideo extends laya.device.media.WebGLVideo {
    }
    class AccelerationInfo extends laya.device.motion.AccelerationInfo {
    }
    class Accelerator extends laya.device.motion.Accelerator {
    }
    class Gyroscope extends laya.device.motion.Gyroscope {
    }
    class RotationInfo extends laya.device.motion.RotationInfo {
    }
    class Shake extends laya.device.Shake {
    }
    class Animation extends laya.display.Animation {
    }
    class AnimationPlayerBase extends laya.display.AnimationPlayerBase {
    }
    class BitmapFont extends laya.display.BitmapFont {
    }
    class CSSStyle extends laya.display.css.CSSStyle {
    }
    class Font extends laya.display.css.Font {
    }
    class Style extends laya.display.css.Style {
    }
    class TransformInfo extends laya.display.css.TransformInfo {
    }
    class FrameAnimation extends laya.display.FrameAnimation {
    }
    class GraphicAnimation extends laya.display.GraphicAnimation {
    }
    class Graphics extends laya.display.Graphics {
    }
    interface ILayout extends laya.display.ILayout {
    }
    class Input extends laya.display.Input {
    }
    class Node extends laya.display.Node {
    }
    class Sprite extends laya.display.Sprite {
    }
    class Stage extends laya.display.Stage {
    }
    class Text extends laya.display.Text {
    }
    class Event extends laya.events.Event {
    }
    class EventDispatcher extends laya.events.EventDispatcher {
    }
    class Keyboard extends laya.events.Keyboard {
    }
    class KeyBoardManager extends laya.events.KeyBoardManager {
    }
    class KeyLocation extends laya.events.KeyLocation {
    }
    class MouseManager extends laya.events.MouseManager {
    }
    class BlurFilter extends laya.filters.BlurFilter {
    }
    class ColorFilter extends laya.filters.ColorFilter {
    }
    class ColorFilterAction extends laya.filters.ColorFilterAction {
    }
    class Filter extends laya.filters.Filter {
    }
    class FilterAction extends laya.filters.FilterAction {
    }
    class GlowFilter extends laya.filters.GlowFilter {
    }
    interface IFilter extends laya.filters.IFilter {
    }
    interface IFilterAction extends laya.filters.IFilterAction {
    }
    interface IFilterActionGL extends laya.filters.IFilterActionGL {
    }
    class BlurFilterActionGL extends laya.filters.webgl.BlurFilterActionGL {
    }
    class ColorFilterActionGL extends laya.filters.webgl.ColorFilterActionGL {
    }
    class FilterActionGL extends laya.filters.webgl.FilterActionGL {
    }
    class GlowFilterActionGL extends laya.filters.webgl.GlowFilterActionGL {
    }
    class WebGLFilter extends laya.filters.WebGLFilter {
    }
    class HTMLBrElement extends laya.html.dom.HTMLBrElement {
    }
    class HTMLDivElement extends laya.html.dom.HTMLDivElement {
    }
    class HTMLDocument extends laya.html.dom.HTMLDocument {
    }
    class HTMLElement extends laya.html.dom.HTMLElement {
    }
    class HTMLIframeElement extends laya.html.dom.HTMLIframeElement {
    }
    class HTMLImageElement extends laya.html.dom.HTMLImageElement {
    }
    class HTMLLinkElement extends laya.html.dom.HTMLLinkElement {
    }
    class HTMLStyleElement extends laya.html.dom.HTMLStyleElement {
    }
    class HTMLParse extends laya.html.utils.HTMLParse {
    }
    class Layout extends laya.html.utils.Layout {
    }
    class LayoutLine extends laya.html.utils.LayoutLine {
    }
    class GridSprite extends laya.map.GridSprite {
    }
    class MapLayer extends laya.map.MapLayer {
    }
    class TileAniSprite extends laya.map.TileAniSprite {
    }
    class TiledMap extends laya.map.TiledMap {
    }
    class TileTexSet extends laya.map.TileTexSet {
    }
    class Arith extends laya.maths.Arith {
    }
    class Bezier extends laya.maths.Bezier {
    }
    class GrahamScan extends laya.maths.GrahamScan {
    }
    class MathUtil extends laya.maths.MathUtil {
    }
    class Matrix extends laya.maths.Matrix {
    }
    class Point extends laya.maths.Point {
    }
    class Rectangle extends laya.maths.Rectangle {
    }
    class AudioSound extends laya.media.h5audio.AudioSound {
    }
    class AudioSoundChannel extends laya.media.h5audio.AudioSoundChannel {
    }
    class Sound extends laya.media.Sound {
    }
    class SoundChannel extends laya.media.SoundChannel {
    }
    class SoundManager extends laya.media.SoundManager {
    }
    class SoundNode extends laya.media.SoundNode {
    }
    class WebAudioSound extends laya.media.webaudio.WebAudioSound {
    }
    class WebAudioSoundChannel extends laya.media.webaudio.WebAudioSoundChannel {
    }
    class HttpRequest extends laya.net.HttpRequest {
    }
    class Loader extends laya.net.Loader {
    }
    class LoaderManager extends laya.net.LoaderManager {
    }
    class LocalStorage extends laya.net.LocalStorage {
    }
    class ResourceVersion extends laya.net.ResourceVersion {
    }
    class Socket extends laya.net.Socket {
    }
    class URL extends laya.net.URL {
    }
    class WorkerLoader extends laya.net.WorkerLoader {
    }
    class Emitter2D extends laya.particle.emitter.Emitter2D {
    }
    class EmitterBase extends laya.particle.emitter.EmitterBase {
    }
    class Particle2D extends laya.particle.Particle2D {
    }
    class ParticleData extends laya.particle.ParticleData {
    }
    class ParticleEmitter extends laya.particle.ParticleEmitter {
    }
    class ParticleSetting extends laya.particle.ParticleSetting {
    }
    class ParticleTemplate2D extends laya.particle.ParticleTemplate2D {
    }
    class ParticleTemplateBase extends laya.particle.ParticleTemplateBase {
    }
    class ParticleTemplateCanvas extends laya.particle.ParticleTemplateCanvas {
    }
    class ParticleTemplateWebGL extends laya.particle.ParticleTemplateWebGL {
    }
    class CanvasShader extends laya.particle.particleUtils.CanvasShader {
    }
    class CMDParticle extends laya.particle.particleUtils.CMDParticle {
    }
    class PicTool extends laya.particle.particleUtils.PicTool {
    }
    class ParticleShader extends laya.particle.shader.ParticleShader {
    }
    class ParticleShaderValue extends laya.particle.shader.value.ParticleShaderValue {
    }
    class Render extends laya.renders.Render {
    }
    class RenderContext extends laya.renders.RenderContext {
    }
    class RenderSprite extends laya.renders.RenderSprite {
    }
    class Bitmap extends laya.resource.Bitmap {
    }
    class Context extends laya.resource.Context {
    }
    class FileBitmap extends laya.resource.FileBitmap {
    }
    class HTMLCanvas extends laya.resource.HTMLCanvas {
    }
    class HTMLImage extends laya.resource.HTMLImage {
    }
    class HTMLSubImage extends laya.resource.HTMLSubImage {
    }
    interface ICreateResource extends laya.resource.ICreateResource {
    }
    interface IDestroy extends laya.resource.IDestroy {
    }
    interface IDispose extends laya.resource.IDispose {
    }
    class Resource extends laya.resource.Resource {
    }
    class ResourceManager extends laya.resource.ResourceManager {
    }
    class Texture extends laya.resource.Texture {
    }
    interface IConchNode extends laya.runtime.IConchNode {
    }
    interface IConchRenderObject extends laya.runtime.IConchRenderObject {
    }
    interface ICPlatformClass extends laya.runtime.ICPlatformClass {
    }
    interface IMarket extends laya.runtime.IMarket {
    }
    interface IPlatform extends laya.runtime.IPlatform {
    }
    interface IPlatformClass extends laya.runtime.IPlatformClass {
    }
    class System extends laya.system.System {
    }
    class AsynDialog extends laya.ui.AsynDialog {
    }
    class AutoBitmap extends laya.ui.AutoBitmap {
    }
    class Box extends laya.ui.Box {
    }
    class Button extends laya.ui.Button {
    }
    class CheckBox extends laya.ui.CheckBox {
    }
    class Clip extends laya.ui.Clip {
    }
    class ColorPicker extends laya.ui.ColorPicker {
    }
    class ComboBox extends laya.ui.ComboBox {
    }
    class Component extends laya.ui.Component {
    }
    class Dialog extends laya.ui.Dialog {
    }
    class DialogManager extends laya.ui.DialogManager {
    }
    class EffectAnimation extends laya.ui.EffectAnimation {
    }
    class FontClip extends laya.ui.FontClip {
    }
    class FrameClip extends laya.ui.FrameClip {
    }
    class HBox extends laya.ui.HBox {
    }
    class HScrollBar extends laya.ui.HScrollBar {
    }
    class HSlider extends laya.ui.HSlider {
    }
    interface IBox extends laya.ui.IBox {
    }
    interface IComponent extends laya.ui.IComponent {
    }
    interface IItem extends laya.ui.IItem {
    }
    class Image extends laya.ui.Image {
    }
    interface IRender extends laya.ui.IRender {
    }
    interface ISelect extends laya.ui.ISelect {
    }
    class Label extends laya.ui.Label {
    }
    class LayoutBox extends laya.ui.LayoutBox {
    }
    class LayoutStyle extends laya.ui.LayoutStyle {
    }
    class List extends laya.ui.List {
    }
    class Panel extends laya.ui.Panel {
    }
    class ProgressBar extends laya.ui.ProgressBar {
    }
    class Radio extends laya.ui.Radio {
    }
    class RadioGroup extends laya.ui.RadioGroup {
    }
    class ScrollBar extends laya.ui.ScrollBar {
    }
    class Slider extends laya.ui.Slider {
    }
    class Styles extends laya.ui.Styles {
    }
    class Tab extends laya.ui.Tab {
    }
    class TextArea extends laya.ui.TextArea {
    }
    class TextInput extends laya.ui.TextInput {
    }
    class TipManager extends laya.ui.TipManager {
    }
    class Tree extends laya.ui.Tree {
    }
    class UIEvent extends laya.ui.UIEvent {
    }
    class UIGroup extends laya.ui.UIGroup {
    }
    class UIUtils extends laya.ui.UIUtils {
    }
    class VBox extends laya.ui.VBox {
    }
    class View extends laya.ui.View {
    }
    class ViewStack extends laya.ui.ViewStack {
    }
    class VScrollBar extends laya.ui.VScrollBar {
    }
    class VSlider extends laya.ui.VSlider {
    }
    class Browser extends laya.utils.Browser {
    }
    class Byte extends laya.utils.Byte {
    }
    class CacheManger extends laya.utils.CacheManger {
    }
    class ClassUtils extends laya.utils.ClassUtils {
    }
    class Color extends laya.utils.Color {
    }
    class Dictionary extends laya.utils.Dictionary {
    }
    class Dragging extends laya.utils.Dragging {
    }
    class Ease extends laya.utils.Ease {
    }
    class Handler extends laya.utils.Handler {
    }
    class HitArea extends laya.utils.HitArea {
    }
    class HTMLChar extends laya.utils.HTMLChar {
    }
    class Log extends laya.utils.Log {
    }
    class Mouse extends laya.utils.Mouse {
    }
    class Pool extends laya.utils.Pool {
    }
    class PoolCache extends laya.utils.PoolCache {
    }
    class RunDriver extends laya.utils.RunDriver {
    }
    class Stat extends laya.utils.Stat {
    }
    class StringKey extends laya.utils.StringKey {
    }
    class TimeLine extends laya.utils.TimeLine {
    }
    class Timer extends laya.utils.Timer {
    }
    class Tween extends laya.utils.Tween {
    }
    class Utils extends laya.utils.Utils {
    }
    class VectorGraphManager extends laya.utils.VectorGraphManager {
    }
    class WordText extends laya.utils.WordText {
    }
    class Atlaser extends laya.webgl.atlas.Atlaser {
    }
    class AtlasGrid extends laya.webgl.atlas.AtlasGrid {
    }
    class AtlasResourceManager extends laya.webgl.atlas.AtlasResourceManager {
    }
    class AtlasWebGLCanvas extends laya.webgl.atlas.AtlasWebGLCanvas {
    }
    class MergeFillInfo extends laya.webgl.atlas.MergeFillInfo {
    }
    class BlendMode extends laya.webgl.canvas.BlendMode {
    }
    class DrawStyle extends laya.webgl.canvas.DrawStyle {
    }
    class Path extends laya.webgl.canvas.Path {
    }
    interface ISaveData extends laya.webgl.canvas.save.ISaveData {
    }
    class SaveBase extends laya.webgl.canvas.save.SaveBase {
    }
    class SaveClipRect extends laya.webgl.canvas.save.SaveClipRect {
    }
    class SaveMark extends laya.webgl.canvas.save.SaveMark {
    }
    class SaveTransform extends laya.webgl.canvas.save.SaveTransform {
    }
    class SaveTranslate extends laya.webgl.canvas.save.SaveTranslate {
    }
    class WebGLContext2D extends laya.webgl.canvas.WebGLContext2D {
    }
    class GraphicsGL extends laya.webgl.display.GraphicsGL {
    }
    interface IMergeAtlasBitmap extends laya.webgl.resource.IMergeAtlasBitmap {
    }
    class RenderTarget2D extends laya.webgl.resource.RenderTarget2D {
    }
    class RenderTargetMAX extends laya.webgl.resource.RenderTargetMAX {
    }
    class WebGLCanvas extends laya.webgl.resource.WebGLCanvas {
    }
    class WebGLCharImage extends laya.webgl.resource.WebGLCharImage {
    }
    class WebGLImage extends laya.webgl.resource.WebGLImage {
    }
    class WebGLRenderTarget extends laya.webgl.resource.WebGLRenderTarget {
    }
    class WebGLSubImage extends laya.webgl.resource.WebGLSubImage {
    }
    class BaseShader extends laya.webgl.shader.BaseShader {
    }
    class Shader2D extends laya.webgl.shader.d2.Shader2D {
    }
    class Shader2X extends laya.webgl.shader.d2.Shader2X {
    }
    class ShaderDefines2D extends laya.webgl.shader.d2.ShaderDefines2D {
    }
    class SkinMesh extends laya.webgl.shader.d2.skinAnishader.SkinMesh {
    }
    class SkinMeshBuffer extends laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer {
    }
    class SkinSV extends laya.webgl.shader.d2.skinAnishader.SkinSV {
    }
    class Color2dSV extends laya.webgl.shader.d2.value.Color2dSV {
    }
    class FillTextureSV extends laya.webgl.shader.d2.value.FillTextureSV {
    }
    class GlowSV extends laya.webgl.shader.d2.value.GlowSV {
    }
    class PrimitiveSV extends laya.webgl.shader.d2.value.PrimitiveSV {
    }
    class TextSV extends laya.webgl.shader.d2.value.TextSV {
    }
    class TextureSV extends laya.webgl.shader.d2.value.TextureSV {
    }
    class Value2D extends laya.webgl.shader.d2.value.Value2D {
    }
    class Shader extends laya.webgl.shader.Shader {
    }
    class ShaderDefines extends laya.webgl.shader.ShaderDefines {
    }
    class ShaderValue extends laya.webgl.shader.ShaderValue {
    }
    class BasePoly extends laya.webgl.shapes.BasePoly {
    }
    class Ellipse extends laya.webgl.shapes.Ellipse {
    }
    class GeometryData extends laya.webgl.shapes.GeometryData {
    }
    interface IShape extends laya.webgl.shapes.IShape {
    }
    class Line extends laya.webgl.shapes.Line {
    }
    class LoopLine extends laya.webgl.shapes.LoopLine {
    }
    class Polygon extends laya.webgl.shapes.Polygon {
    }
    class Vertex extends laya.webgl.shapes.Vertex {
    }
    interface ISubmit extends laya.webgl.submit.ISubmit {
    }
    class Submit extends laya.webgl.submit.Submit {
    }
    class SubmitCanvas extends laya.webgl.submit.SubmitCanvas {
    }
    class SubmitCMD extends laya.webgl.submit.SubmitCMD {
    }
    class SubmitCMDScope extends laya.webgl.submit.SubmitCMDScope {
    }
    class SubmitOtherIBVB extends laya.webgl.submit.SubmitOtherIBVB {
    }
    class SubmitScissor extends laya.webgl.submit.SubmitScissor {
    }
    class SubmitStencil extends laya.webgl.submit.SubmitStencil {
    }
    class SubmitTarget extends laya.webgl.submit.SubmitTarget {
    }
    class SubmitTexture extends laya.webgl.submit.SubmitTexture {
    }
    class CharSegment extends laya.webgl.text.CharSegment {
    }
    class DrawText extends laya.webgl.text.DrawText {
    }
    class FontInContext extends laya.webgl.text.FontInContext {
    }
    interface ICharSegment extends laya.webgl.text.ICharSegment {
    }
    class Buffer extends laya.webgl.utils.Buffer {
    }
    class Buffer2D extends laya.webgl.utils.Buffer2D {
    }
    class CONST3D2D extends laya.webgl.utils.CONST3D2D {
    }
    class GlUtils extends laya.webgl.utils.GlUtils {
    }
    class IndexBuffer2D extends laya.webgl.utils.IndexBuffer2D {
    }
    class MatirxArray extends laya.webgl.utils.MatirxArray {
    }
    class RenderSprite3D extends laya.webgl.utils.RenderSprite3D {
    }
    class RenderState2D extends laya.webgl.utils.RenderState2D {
    }
    class ShaderCompile extends laya.webgl.utils.ShaderCompile {
    }
    class VertexBuffer2D extends laya.webgl.utils.VertexBuffer2D {
    }
    class WebGL extends laya.webgl.WebGL {
    }
    class WebGLContext extends laya.webgl.WebGLContext {
    }
}
declare class Laya3D {
    /**
     * 初始化Laya3D相关设置。
     * @param    width  3D画布宽度。
     * @param    height 3D画布高度。
     */
    static  init(width:number, height:number, antialias?:boolean, alpha?:boolean, premultipliedAlpha?:boolean):void 
}
/**
 * <code>Laya</code> 是全局对象的引用入口集。
 */
declare class Laya {
    /** 舞台对象的引用。*/
    static stage: laya.display.Stage;
    /** 时间管理器的引用。*/
    static timer: laya.utils.Timer;
    /** 加载管理器的引用。*/
    static loader: laya.net.LoaderManager;
    /** Render 类的引用。*/
    static render: laya.renders.Render;
    /** 引擎版本。*/
    static version: string;
    /**@private */
    static stageBox: laya.display.Sprite;
    /**Market对象 只有加速器模式下才有值*/
    static conchMarket: laya.runtime.IMarket;
    /**PlatformClass类，只有加速器模式下才有值 */
    static PlatformClass: laya.runtime.ICPlatformClass;
    /**
     * 初始化引擎。
     * @param    width 游戏窗口宽度。
     * @param    height    游戏窗口高度。
     * @param    插件列表，比如 WebGL。
     * @return    返回原生canvas，方便控制
     */
    static init(width: number, height: number, ...plugins: any[]): any;
    /**
     * 表示是否捕获全局错误并弹出提示。
     */
    static alertGlobalError: boolean;
}
/**全局配置*/
declare class UIConfig {
  /**是否开启触摸滚动（针对滚动条）*/
		public static   touchScrollEnable:boolean;
		/**是否开启滑轮滚动（针对滚动条）*/
		public static   mouseWheelEnable:boolean ;
		/**是否显示滚动条按钮*/
		public static   showButtons:boolean;
		/**弹出框背景颜色*/
		public static   popupBgColor:string;
		/**弹出框背景透明度*/
		public static   popupBgAlpha:number;
		/**模式窗口点击边缘，是否关闭窗口，默认是关闭的*/
		public static   closeDialogOnSide:boolean;
}
/**
 *  Config 用于配置一些全局参数。
 */
declare class Config {
   		/**
		 * WebGL模式下文本缓存最大数量。
		 */
		public static  WebGLTextCacheCount:number;
		/**
		 * 表示是否使用了大图合集功能。
		 */
		public static  atlasEnable:boolean;
		/**
		 * 是否显示画布图边框，用于调试。
		 */
		public static  showCanvasMark:boolean;
		/**
		 * 动画 Animation 的默认播放时间间隔，单位为毫秒。
		 */
		public static  animationInterval:number;
		/**
		 * 设置是否抗锯齿，只对2D(WebGL)、3D有效。
		 */
		public static  isAntialias:boolean;
		/**
		 * 设置画布是否透明，只对2D(WebGL)、3D有效。
		 */
		public static  isAlpha:boolean;
		/**
		 * 设置画布是否预乘，只对2D(WebGL)、3D有效。
		 */
		public static  premultipliedAlpha:boolean;
		/**
		 * 设置画布的模板缓冲，只对2D(WebGL)、3D有效。
		 */
		public static  isStencil:boolean;
		/**
		 * 是否强制WebGL同步刷新。
		 */
		public static  preserveDrawingBuffer:boolean;
}
declare module laya.debug {
    /**
     *
     * @author ww
     * @version 1.0
     *
     * @created  2015-9-24 下午3:00:38
     */
    class DebugTool {
        static init(cacheAnalyseEnable?: boolean, loaderAnalyseEnable?: boolean, createAnalyseEnable?: boolean, renderAnalyseEnable?: boolean): void;
    }
}
