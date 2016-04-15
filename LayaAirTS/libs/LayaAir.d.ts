declare module laya.ani.bone {
    class Skeleton extends laya.display.Animation {
        _tp_: Templet;
        constructor(tmplete?: any);
        setTpl(tpl: Templet): void;
        setAnim(index: number): void;
        stAnimName(str: string): void;
        setGraphics(graphics: Array<any>): void;
        pause(frame?: number): void;
        index: number;
    }
}
declare module laya.ani.bone {
    /**
     * ...
     * @author ww
     */
    class SkeletonPlayer extends laya.ani.bone.Skeleton {
        completeHandler: laya.utils.Handler;
        dataUrl: string;
        imgUrl: string;
        constructor(tmplete?: any);
        skin: string;
        load(baseURL: string): void;
    }
}
declare module laya.ani.bone {
    class Templet {
        static ANIMLEN: number;
        static SRC_ANIMLEN: number;
        frameCount: number;
        frameRate: number;
        animNames: any;
        _graphicsArrs_: Array<any>;
        _texture: any;
        textureWidth: number;
        textureHeight: number;
        constructor(data: any, tex: any);
        planish(i: number, _index_: number): laya.display.Graphics;
    }
}
declare module laya.ani.swf {
    /**
     * ...
     * @author laya
     */
    class MovieClip extends laya.display.Sprite {
        protected static _ValueList: Array<any>;
        interval: number;
        /**
         * id_data起始位置表
         */
        _ids: any;
        /**
         * id_实例表
         */
        _idOfSprite: Array<any>;
        /**
         * 资源根目录
         */
        basePath: string;
        constructor();
        currentFrame: number;
        totalFrames: number;
        update(): void;
        stop(): void;
        gotoStop(frame: number): void;
        clear(): void;
        play(frameIndex?: number): void;
        _setData(data: laya.utils.Byte, start: number): void;
        skin: string;
        load(url: string): void;
    }
}
declare module laya.asyn {
    /**
     * ...
     * @author laya
     */
    class Asyn {
        static loops: Array<any>;
        static loadDo: Function;
        static onceEvent: Function;
        static onceTimer: Function;
        static _caller_: any;
        static _callback_: Function;
        static _nextLine_: number;
        static wait(conditions: any): any;
        static callLater(d: Deferred): void;
        static notify(conditions?: any, value?: any): void;
        static load(url: string, type?: string): Deferred;
        static sleep(delay: number): void;
        static _loop_(): void;
    }
}
declare module laya.asyn {
    /**
     * ...
     * @author laya
     */
    class Deferred {
        static _TIMECOUNT_: number;
        constructor();
        setValue(v: any): void;
        getValue(): any;
        _reset(): void;
        callback(value?: any): void;
        errback(value?: any): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Animation</code> 类是位图动画,用于创建位图动画。</p>
     * <p> <code>Animation</code> 类可以加载并显示一组位图图片，并组成动画进行播放。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
     * <p>[EXAMPLE-AS-BEGIN]</p>
     * <listing version="3.0">
     * package
     * {
     * 	import laya.display.Animation;
     * 	import laya.net.Loader;
     * 	import laya.utils.Handler;
     *
     * 	public class Animation_Example
     * 	{
     * 		public function Animation_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			Laya.loader.load("resource/ani/fighter.json", Handler.create(this, onLoadComplete), null, Loader.ATLAS);
     * 		}
     *
     * 		private function onLoadComplete():void
     * 		{
     * 			var animation:Animation = Animation.fromUrl("resource/ani/fighter/rollSequence{0000}.png", 30);//创建一个 Animation 类的实例对象 animation 。
     * 			animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     * 			animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     * 			animation.interval = 30;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
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
     *     Laya.loader.load("resource/ani/fighter.json", laya.utils.Handler.create(this, onLoadComplete), null, laya.net.Loader.ATLAS);
     * }
     * function onLoadComplete()
     * {
     *     var animation = laya.display.Animation.fromUrl("resource/ani/fighter/rollSequence{0000}.png", 30);//创建一个 Animation 类的实例对象 animation 。
     *     animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *     animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *     animation.interval = 30;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
     *     animation.play();//播放动画。
     *     Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
     * }
     * </listing>
     * <listing version="3.0">
     * import Loader = laya.net.Loader;
     * import Handler = laya.utils.Handler;
     *  class Animation_Example {
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ani/fighter.json", Handler.create(this, this.onLoadComplete), null, Loader.ATLAS);
     *     }
     *
     *     private onLoadComplete(): void {
     *         var animation: Animation = Animation.fromUrl("resource/ani/fighter/rollSequence{0000}.png", 30);//创建一个 Animation 类的实例对象 animation 。
     *         animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *         animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
     *         animation.interval = 30;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
     *         animation.play();//播放动画。
     *         Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
     *     }
     * }
     * </listing>
     *
     */
    class Animation extends Sprite {
        frames: Array<any>;
        /**播放间隔(单位：毫秒)*/
        interval: number;
        /**
         * 创建一个新的 <code>Animation</code> 实例。
         */
        constructor();
        /**
         *@inheritDoc
         */
        destroy(destroyChild?: boolean): void;
        /**
         * 播放动画。
         */
        play(): void;
        /**
         * 停止播放。
         */
        stop(): void;
        /**当前播放索引。*/
        index: number;
        /**动画长度。*/
        count: number;
        clear(): void;
        /**
         * 加载图片集合，组成动画。
         * @param    urls 图片地址集合
         */
        loadImages(urls: Array<any>): Animation;
        /**
         * 根据地址创建一个动画
         * @param    url 第一张图片的url地址，变化的参数用“
         * @param    count 动画数量，会根据此数量替换url参数，比如url=res/ani
         * @return    返回一个Animation对象
         */
        static fromUrl(url: string, count: number): Animation;
    }
}
declare module laya.display {
    /**
     * 位图字体，用于自定义字体及一些儿字体性能优化
     * @author ...
     */
    class BitmapFont {
        /**
         * 当前位图字体字号
         */
        fontSize: number;
        /**
         * 启用字体缩放后（字体会根据当前位图字体字号去匹配实际使用字号）
         */
        useFontScaleKey: boolean;
        /**
         * 通过指定位图字体文件路径，加载位图字体文件
         * @param    path            位图字体文件的路径，不含扩展名（需要.fnt跟.png文件同名）
         * @param    callHandler        加载完成的回调，通知上层字体文件已经完成加载并解析
         */
        loadFont(path: string, callHandler: laya.utils.Handler): void;
        /**
         * 解析字体文件
         * @param    xml            字体文件XML
         * @param    texture        字体的纹理
         */
        parseFontXml(xml: any, texture: laya.resource.Texture): void;
        /**
         * @private
         * 通过字符找到相对应的字体纹理
         * @param    text
         * @return
         */
        getBitmapByText(text: string): laya.resource.Texture;
        /**
         * 销毁位图字体，调用Text.unregisterBitmapFont时，默认会销毁
         */
        destory(): void;
        /**
         * 设置空格的宽（如果有字体库有空格，这里就可以不用设置了）
         * @param    spaceWidth
         */
        setSpaceWidth(spaceWidth: number): void;
        /**
         * @private
         * 得到单个字符的宽
         * @param    word
         * @return
         */
        getWordWidth(word: string): number;
        /**
         * @private
         * 得到最大字符的宽
         * @return
         */
        getWordMaxWidth(): number;
        /**
         * @private
         * 得到一段文本的宽
         * @param    words
         * @return
         */
        getWordsWidth(words: string): number;
        /**
         * 得到当前字符的高度（这里用最大字符的高度）
         * @return
         */
        getWordHeight(): number;
        /**
         * @private
         * 画一段文字
         * @param    words
         * @param    sprite
         * @param    drawX
         * @param    drawY
         * @param    align
         * @param    width
         */
        drawWords(words: string, sprite: Sprite, drawX: number, drawY: number, align: string, width: number): void;
    }
}
declare module laya.display.css {
    /**
     * <code>CSSStyle</code> 类是元素CSS样式定义类。
     * @author laya
     */
    class CSSStyle extends laya.display.css.Style {
        static EMPTY: CSSStyle;
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
        /**添加布局。 */
        static ADDLAYOUTED: number;
        /**行高。 */
        lineHeight: number;
        /**
         * 创建一个新的 <code>CSSStyle</code> 类实例。
         * @param    ower
         */
        constructor(ower: laya.display.Sprite);
        /**@inheritDoc     */
        destroy(): void;
        /**
         * 复制传入的 CSSStyle 属性值。
         * @param    src
         */
        inherit(src: CSSStyle): void;
        _widthAuto(): boolean;
        /**@inheritDoc     */
        widthed(sprite: laya.display.Sprite): boolean;
        /**
         * 表示宽度。
         */
        width: any;
        /**
         * 表示高度。
         */
        height: any;
        /**
         *
         * @param    sprite
         * @return
         */
        heighted(sprite: laya.display.Sprite): boolean;
        /**
         * 设置宽高。
         * @param    w
         * @param    h
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
         * 字体、字号。
         */
        font: string;
        /**
         * 设置文本的粗细。
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
         * 边框属性。
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
        /**@inheritDoc     */
        render(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**@inheritDoc     */
        getCSSStyle(): CSSStyle;
        /**
         * 设置CSS样式字符串。
         * @param    text
         */
        cssText(text: string): void;
        /**
         * 根据传入的属性名、属性值列表，设置此对象的属性值。
         * @param    attrs
         */
        attrs(attrs: Array<any>): void;
        /**
         * 元素的定位类型。
         */
        position: string;
        /**@inheritDoc     */
        absolute: boolean;
        /**
         * 规定元素应该生成的框的类型。
         */
        display: string;
        /**@inheritDoc     */
        transform: any;
        /**@inheritDoc     */
        paddingLeft: number;
        /**@inheritDoc     */
        paddingTop: number;
        _enableLayout(): boolean;
        /**
         * 通过传入的分割符，分割解析CSS样式字符串，返回样式列表。
         * @param    text CSS样式字符串。
         * @param    clipWord 分割符；
         * @return 样式列表。
         */
        static parseOneCSS(text: string, clipWord: string): Array<any>;
        /**
         * 解析CSS样式文本。
         * @param    text
         * @param    uri
         * @internal 此处需要再详细点注释。
         */
        static parseCSS(text: string, uri: laya.net.URL): void;
    }
}
declare module laya.display.css {
    /**
     * <code>Font</code> 类是字体显示定义类。
     * @author laya
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
         * @param    src
         */
        constructor(src: Font);
        /**
         * 设置字体样式字符串。
         * @param    value
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
         * @return
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
         * @param    dec
         */
        copyTo(dec: Font): void;
    }
}
declare module laya.display.css {
    /**
     * <code>Style</code> 类是元素样式定义类。
     * @author yung
     */
    class Style {
        protected static _createTransform(): any;
        static __init__(): void;
        /**
         * 一个默认样式 <code>Style</code> 对象。
         */
        static EMPTY: laya.display.css.Style;
        _type: number;
        /**
         * 透明度。
         */
        alpha: number;
        /**
         * 表示是否显示。
         */
        visible: boolean;
        /**
         * 表示滚动区域。
         */
        scrollRect: laya.maths.Rectangle;
        /**
         * 混合模式。
         */
        blendMode: string;
        /**
         * 创建一个新的 <code>Style</code> 类实例。
         */
        constructor();
        /**
         * 元素应用的 2D 或 3D 转换的值。该属性允许我们对元素进行旋转、缩放、移动或倾斜。
         */
        transform: any;
        /**
         * 返回是否需要 2D、3D 转化。
         * @return
         */
        withTransform(): boolean;
        /**
         * 定义 X 轴、Y 轴移动转换。
         * @param    x
         * @param    y
         */
        translate(x: number, y: number): void;
        /**
         * 定义转换，只是用 X 轴的值。
         */
        translateX: number;
        /**
         * 定义转换，只是用 Y 轴的值。
         */
        translateY: number;
        /**
         * 定义 缩放转换。
         * @param    x
         * @param    y
         */
        scale(x: number, y: number): void;
        /**
         * X 轴缩放值。
         */
        scaleX: number;
        /**
         * Y 轴缩放值。
         */
        scaleY: number;
        /**
         * 定义旋转角度。
         */
        rotate: number;
        /**
         * 定义沿着 X 轴的 2D 倾斜转换。
         */
        skewX: number;
        /**
         * 定义沿着 Y 轴的 2D 倾斜转换。
         */
        skewY: number;
        /**
         * 表示元素是否显示为块级元素。
         */
        block: boolean;
        /**
         *  表示元素的左内边距。
         */
        paddingLeft: number;
        /**
         *  表示元素的上内边距。
         */
        paddingTop: number;
        /**
         * 是否为绝对定位。
         */
        absolute: boolean;
        /**
         * 销毁此对象。
         */
        destroy(): void;
        /**
         * 判断传入的对象是否设置了有效的 width 属性。
         * @param    sprite
         * @return
         */
        widthed(sprite: laya.display.Sprite): boolean;
        /**
         * 渲染传入的显示对象。
         * @param    sprite
         * @param    context
         * @param    x
         * @param    y
         */
        render(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 获取默认的CSS样式对象。
         * @return
         */
        getCSSStyle(): laya.display.css.CSSStyle;
        _enableLayout(): boolean;
    }
}
declare module laya.display {
    /**
     * <code>Graphics</code> 类用于创建绘图显示对象。
     *
     * @see laya.display.Sprite#graphics
     * @author yung
     */
    class Graphics {
        _one: Array<any>;
        _render: Function;
        sp: Sprite;
        /**
         *  创建一个新的 <code>Graphics</code> 类实例。
         */
        constructor();
        /**
         * <p>销毁此对象。</p>
         */
        destroy(): void;
        /**
         * <p>清理此对象。</p>
         */
        clear(): void;
        empty(): boolean;
        /**
         * 重绘此对象。
         */
        repaint(): void;
        _isOnlyOne(): boolean;
        /**
         * 命令流。
         * @private
         */
        cmds: Array<any>;
        /**
         * 获取位置及宽高信息矩阵(比较耗，尽量少用)。
         */
        getBounds(): laya.maths.Rectangle;
        /**
         * @private
         * 获取端点列表。
         * @return
         */
        getBoundPoints(): Array<any>;
        /**
         * 绘制纹理。
         * @param    tex 纹理。
         * @param    x X轴偏移量。
         * @param    y Y轴偏移量。
         * @param    width 宽度。
         * @param    height 高度。
         * @param    m 矩阵信息。
         */
        drawTexture(tex: laya.resource.Texture, x: number, y: number, width?: number, height?: number, m?: laya.maths.Matrix): void;
        /**
         * 绘制纹理对象。
         * @param    tex
         * @param    x
         * @param    y
         * @param    width
         * @param    height
         */
        drawRenderTarget(tex: laya.resource.Texture, x: number, y: number, width: number, height: number): void;
        /**
         * @private
         * 保存到命令流。
         * @param    fun
         * @param    args
         * @return
         */
        _saveToCmd(fun: Function, args: Array<any>): Array<any>;
        /**
         * 画布的剪裁区域,超出剪裁区域的坐标可以画图,但不能显示。
         * @param    x X轴偏移量。
         * @param    y Y轴偏移量。
         * @param    width 宽度。
         * @param    height 高度。
         */
        clipRect(x: number, y: number, width: number, height: number): void;
        /**
         * 在画布上绘制“被填充的”文本。
         * @param    text 在画布上输出的文本。
         * @param    x 开始绘制文本的 x 坐标位置（相对于画布）。
         * @param    y 开始绘制文本的 y 坐标位置（相对于画布）。
         * @param    font 定义字体和字号。
         * @param    color 定义文本颜色。
         * @param    textAlign 文本对齐反式。
         */
        fillText(text: string, x: number, y: number, font: string, color: string, textAlign: string): void;
        /**
         * 在画布上绘制“被填充且镶边的”文本。
         * @param    text 在画布上输出的文本。
         * @param    x 开始绘制文本的 x 坐标位置（相对于画布）。
         * @param    y 开始绘制文本的 y 坐标位置（相对于画布）。
         * @param    font 定义字体和字号。
         * @param    fillColor 定义文本颜色。
         * @param    borderColor 定义镶边文本颜色。
         * @param    lineWidth 镶边线条宽度。
         * @param    textAlign 文本对齐方式。
         */
        fillBorderText(text: any, x: number, y: number, font: string, fillColor: string, borderColor: string, lineWidth: number, textAlign: string): void;
        /**
         * 在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
         * @param    text 在画布上输出的文本。
         * @param    x 开始绘制文本的 x 坐标位置（相对于画布）。
         * @param    y 开始绘制文本的 y 坐标位置（相对于画布）。
         * @param    font 定义字体和字号。
         * @param    color 定义文本颜色。
         * @param    lineWidth 线条宽度。
         * @param    textAlign 文本对齐方式。
         */
        strokeText(text: any, x: number, y: number, font: string, color: string, lineWidth: number, textAlign: string): void;
        /**
         * 设置透明度。
         * @param    value
         */
        alpha(value: number): void;
        /**
         * 设置混合模式。
         * @param    value
         */
        blendMode(value: string): void;
        /**
         * 替换绘图的当前转换矩阵。
         * @param    mat 矩阵。
         * @param    pivotX 水平方向轴心点坐标。
         * @param    pivotY 垂直方向轴心点坐标。
         */
        transform(mat: laya.maths.Matrix, pivotX?: number, pivotY?: number): void;
        /**
         * 旋转当前绘图。
         * @param    angle 旋转角度，以弧度计。
         * @param    pivotX 水平方向轴心点坐标。
         * @param    pivotY 垂直方向轴心点坐标。
         */
        rotate(angle: number, pivotX?: number, pivotY?: number): void;
        /**
         * 缩放当前绘图至更大或更小。
         * @param    scaleX 水平方向缩放值。
         * @param    scaleY 垂直方向缩放值。
         * @param    pivotX 水平方向轴心点坐标。
         * @param    pivotY 垂直方向轴心点坐标。
         */
        scale(scaleX: number, scaleY: number, pivotX?: number, pivotY?: number): void;
        /**
         * 重新映射画布上的 (0,0) 位置。
         * @param    x 添加到水平坐标（x）上的值。
         * @param    y 添加到垂直坐标（y）上的值。
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
         * 替换文本内容。
         * @param    text 文本内容。
         * @return
         */
        replaceText(text: string): boolean;
        /**
         * 替换文本颜色。
         * @param    color 颜色。
         * @return
         */
        replaceTextColor(color: string): boolean;
        /**
         * 加载并显示一个图片。
         * @param    url 图片地址。
         * @param    x 显示图片的x位置
         * @param    y 显示图片的y位置
         * @param    width 显示图片的宽度，设置为0表示使用图片默认宽度
         * @param    height 显示图片的高度，设置为0表示使用图片默认高度
         * @param    complete 加载完成回调
         */
        loadImage(url: string, x: number, y: number, width?: number, height?: number, complete?: Function): void;
        /**
         * @private
         * @param    sprite
         * @param    context
         * @param    x
         * @param    y
         */
        _renderEmpty(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         * @param    sprite
         * @param    context
         * @param    x
         * @param    y
         */
        _renderAll(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         * @param    sprite
         * @param    context
         * @param    x
         * @param    y
         */
        _renderOne(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * @private
         * @param    sprite
         * @param    context
         * @param    x
         * @param    y
         */
        _renderOneImg(sprite: Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 绘制一条线。
         * @param    fromX X开始位置。
         * @param    fromY Y开始位置。
         * @param    toX    X结束位置。
         * @param    toY    Y结束位置。
         * @param    lineColor 颜色。
         * @param    lineWidth 线条宽度。
         */
        drawLine(fromX: number, fromY: number, toX: number, toY: number, lineColor: string, lineWidth?: number): void;
        /**
         * 绘制一系列线段。
         * @param    points    线段的点集合，格式[x,y,x,y,x,y...]。
         * @param    lineColor 线段颜色，或者填充绘图的渐变对象。
         * @param    lineWidth 线段宽度。
         */
        drawLines(x: number, y: number, points: Array<any>, lineColor: any, lineWidth?: number): void;
        /**
         * 绘制一系列曲线。
         * @param    points    线段的点集合，格式[startx,starty,ctrx,ctry,startx,starty...]。
         * @param    lineColor 线段颜色，或者填充绘图的渐变对象。
         * @param    lineWidth 线段宽度。
         */
        drawCurves(x: number, y: number, points: Array<any>, lineColor: any, lineWidth?: number): void;
        /**
         * 绘制矩形。
         * @param    x 开始绘制的x位置。
         * @param    y 开始绘制的y位置。
         * @param    width 矩形宽度。
         * @param    height 矩形高度。
         * @param    fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param    lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param    lineWidth 边框宽度。
         */
        drawRect(x: number, y: number, width: number, height: number, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制圆形。
         * @param    x 圆点x位置。
         * @param    y 圆点y位置。
         * @param    radius 半径。
         * @param    fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param    lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param    lineWidth 边框宽度。
         */
        drawCircle(x: number, y: number, radius: number, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制扇形。
         * @param    x 开始绘制的x位置。
         * @param    y 开始绘制的y位置。
         * @param    radius 扇形半径。
         * @param    startAngle 开始角度。
         * @param    endAngle 结束角度。
         * @param    fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param    lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param    lineWidth 边框宽度。
         */
        drawPie(x: number, y: number, radius: number, startAngle: number, endAngle: number, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制多边形。
         * @param    points 多边形的点集合。
         * @param    fillColor 填充颜色，或者填充绘图的渐变对象。
         * @param    lineColor 边框颜色，或者填充绘图的渐变对象。
         * @param    lineWidth 边框宽度。
         */
        drawPoly(x: number, y: number, points: Array<any>, fillColor: any, lineColor?: any, lineWidth?: number): void;
        /**
         * 绘制路径。
         * @param    x 开始绘制的x位置。
         * @param    y 开始绘制的y位置。
         * @param    paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
         * @param    brush 刷子定义，支持以下设置
         * @param    pen 画笔定义，支持以下设置
         */
        drawPath(x: number, y: number, paths: Array<any>, brush?: any, pen?: any): void;
    }
}
declare module laya.display {
    /**
     *  <code>ILayout</code> 类是显示对象的布局接口。
     * @author laya
     */
    interface ILayout {
    }
}
declare module laya.display {
    /**
     * <p><code>Input</code> 类用于创建显示对象以显示和输入文本。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
     * <p>[EXAMPLE-AS-BEGIN]</p>
     * <listing version="3.0">
     * package
     * {
     * 	import laya.display.Input;
     * 	import laya.events.Event;
     *
     * 	public class Input_Example
     * 	{
     * 		private var input:Input;
     * 		public function Input_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			onInit();
     * 		}
     *
     * 		private function onInit():void
     * 		{
     * 			input = new Input();//创建一个 Input 类的实例对象 input 。
     * 			input.text = "这个是一个 Input 文本示例。";
     * 			input.color = "#008fff";//设置 input 的文本颜色。
     * 			input.font = "Arial";//设置 input 的文本字体。
     * 			input.bold = true;//设置 input 的文本显示为粗体。
     * 			input.fontSize = 30;//设置 input 的字体大小。
     * 			input.wordWrap = true;//设置 input 的文本自动换行。
     * 			input.x = 100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
     * 			input.y = 100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
     * 			input.width = 300;//设置 input 的宽度。
     * 			input.height = 200;//设置 input 的高度。
     * 			input.italic = true;//设置 input 的文本显示为斜体。
     * 			input.borderColor = "#fff000";//设置 input 的文本边框颜色。
     * 			Laya.stage.addChild(input);//将 input 添加到显示列表。
     * 			input.on(Event.FOCUS, this, onFocus);//给 input 对象添加获得焦点事件侦听。
     * 			input.on(Event.BLUR, this, onBlur);//给 input 对象添加失去焦点事件侦听。
     * 			input.on(Event.INPUT, this, onInput);//给 input 对象添加输入字符事件侦听。
     * 			input.on(Event.ENTER, this, onEnter);//给 input 对象添加敲回车键事件侦听。
     * 		}
     *
     * 		private function onFocus():void
     * 		{
     * 			trace("输入框 input 获得焦点。");
     * 		}
     *
     * 		private function onBlur():void
     * 		{
     * 			trace("输入框 input 失去焦点。");
     * 		}
     *
     * 		private function onInput():void
     * 		{
     * 			trace("用户在输入框 input 输入字符。文本内容：", input.text);
     * 		}
     *
     * 		private function onEnter():void
     * 		{
     * 			trace("用户在输入框 input 内敲回车键。");
     * 		}
     * 	}
     * }
     * </listing>
     * <listing version="3.0">
     * var input;
     * Input_Example();
     * function Input_Example()
     * {
     *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *     onInit();
     * }
     * function onInit()
     * {
     *     input = new laya.display.Input();//创建一个 Input 类的实例对象 input 。
     *     input.text = "这个是一个 Input 文本示例。";
     *     input.color = "#008fff";//设置 input 的文本颜色。
     *     input.font = "Arial";//设置 input 的文本字体。
     *     input.bold = true;//设置 input 的文本显示为粗体。
     *     input.fontSize = 30;//设置 input 的字体大小。
     *     input.wordWrap = true;//设置 input 的文本自动换行。
     *     input.x = 100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
     *     input.y = 100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
     *     input.width = 300;//设置 input 的宽度。
     *     input.height = 200;//设置 input 的高度。
     *     input.italic = true;//设置 input 的文本显示为斜体。
     *     input.borderColor = "#fff000";//设置 input 的文本边框颜色。
     *     Laya.stage.addChild(input);//将 input 添加到显示列表。
     *     input.on(laya.events.Event.FOCUS, this, onFocus);//给 input 对象添加获得焦点事件侦听。
     *     input.on(laya.events.Event.BLUR, this, onBlur);//给 input 对象添加失去焦点事件侦听。
     *     input.on(laya.events.Event.INPUT, this, onInput);//给 input 对象添加输入字符事件侦听。
     *     input.on(laya.events.Event.ENTER, this, onEnter);//给 input 对象添加敲回车键事件侦听。
     * }
     * function onFocus()
     * {
     *     console.log("输入框 input 获得焦点。");
     * }
     * function onBlur()
     * {
     *     console.log("输入框 input 失去焦点。");
     * }
     * function onInput()
     * {
     *     console.log("用户在输入框 input 输入字符。文本内容：", input.text);
     * }
     * function onEnter()
     * {
     *     console.log("用户在输入框 input 内敲回车键。");
     * }
     * </listing>
     * <listing version="3.0">
     * import Input = laya.display.Input;
     * class Input_Example {
     *     private input: Input;
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         this.onInit();
     *     }
     *     private onInit(): void {
     *         this.input = new Input();//创建一个 Input 类的实例对象 input 。
     *         this.input.text = "这个是一个 Input 文本示例。";
     *         this.input.color = "#008fff";//设置 input 的文本颜色。
     *         this.input.font = "Arial";//设置 input 的文本字体。
     *         this.input.bold = true;//设置 input 的文本显示为粗体。
     *         this.input.fontSize = 30;//设置 input 的字体大小。
     *         this.input.wordWrap = true;//设置 input 的文本自动换行。
     *         this.input.x = 100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
     *         this.input.y = 100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
     *         this.input.width = 300;//设置 input 的宽度。
     *         this.input.height = 200;//设置 input 的高度。
     *         this.input.italic = true;//设置 input 的文本显示为斜体。
     *         this.input.borderColor = "#fff000";//设置 input 的文本边框颜色。
     *         Laya.stage.addChild(this.input);//将 input 添加到显示列表。
     *         this.input.on(laya.events.Event.FOCUS, this, this.onFocus);//给 input 对象添加获得焦点事件侦听。
     *         this.input.on(laya.events.Event.BLUR, this, this.onBlur);//给 input 对象添加失去焦点事件侦听。
     *         this.input.on(laya.events.Event.INPUT, this, this.onInput);//给 input 对象添加输入字符事件侦听。
     *         this.input.on(laya.events.Event.ENTER, this, this.onEnter);//给 input 对象添加敲回车键事件侦听。
     *     }
     *     private onFocus(): void {
     *         console.log("输入框 input 获得焦点。");
     *     }
     *     private onBlur(): void {
     *         console.log("输入框 input 失去焦点。");
     *     }
     *     private onInput(): void {
     *         console.log("用户在输入框 input 输入字符。文本内容：", this.input.text);
     *     }
     *     private onEnter(): void {
     *         console.log("用户在输入框 input 内敲回车键。");
     *     }
     * }
     * </listing>
     * @author yung
     */
    class Input extends Text {
        /**原生输入框x调整值，用来调整输入框坐标*/
        inputElementXAdjuster: number;
        /**原生输入框y调整值，用来调整输入框坐标*/
        inputElementYAdjuster: number;
        /**移动平台输入期间的标题*/
        title: string;
        /**
         * 边框样式。
         */
        static borderStyle: string;
        /**
         * 背景样式。
         */
        static backgroundStyle: string;
        /**
         * 表示是否处于输入状态。
         */
        static isInputting: boolean;
        /**
         * 创建一个新的 <code>Input</code> 类实例。
         */
        constructor();
        /**表示是否是多行输入框。*/
        multiline: boolean;
        /**
         * 获取对输入框的引用实例。
         */
        nativeInput: any;
        /**@inheritDoc     */
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 表示焦点是否在显示对象上。
         */
        focus: boolean;
        /**选中所有文本*/
        select(): void;
        /**@inheritDoc */
        text: string;
        color: string;
        /**限制输入的字符*/
        restrict: string;
        /**
         * 设置可编辑状态。
         */
        editable: boolean;
        /**
         * 获取字符数量限制，默认为10000
         * 设置字符数量限制，小于等于0的值将会限制字符数量为10000
         */
        maxChars: number;
    }
}
declare module laya.display {
    /**
     * <code>Node</code> 类用于创建节点对象，节点是最基本的元素。
     * @author yung
     */
    class Node extends laya.events.EventDispatcher {
        /**类询问为类对象。 */
        static ASK_CLASS: number;
        /**值询问为NODE。 */
        static ASK_VALUE_NODE: number;
        /**值询问为NODE。 */
        static ASK_VALUE_SPRITE: number;
        /**值询问为HTMLELEMENT。 */
        static ASK_VALUE_HTMLELEMENT: number;
        /**值询问为SPRITE3D。 */
        static ASK_VALUE_SPRITE3D: number;
        _childs: Array<any>;
        /**节点名称。*/
        name: string;
        /**是否已经销毁。*/
        destroyed: boolean;
        /**时间控制器。*/
        timer: laya.utils.Timer;
        _privates: any;
        /**
         * <p>销毁此对象。</p>
         * @param    destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
         */
        destroy(destroyChild?: boolean): void;
        /**
         * 销毁所有子对象，不销毁自己本身。
         */
        destroyChildren(): void;
        /**
         * 添加子节点。
         * @param    node 节点对象
         * @return    返回添加的节点
         */
        addChild(node: Node): Node;
        /**
         * 批量增加子节点
         * @param    ...args 无数子节点
         */
        addChildren(...args: any[]): void;
        /**
         * 添加子节点到指定的索引位置。
         * @param    node 节点对象。
         * @param    index 索引位置。
         * @return    返回添加的节点。
         */
        addChildAt(node: Node, index: number): Node;
        /**
         * 根据子节点对象，获取子节点的索引位置。
         * @param    node 子节点。
         * @return    子节点所在的索引位置。
         */
        getChildIndex(node: Node): number;
        /**
         * 根据子节点的名字，获取子节点对象。
         * @param    name 子节点的名字。
         * @return    节点对象。
         */
        getChildByName(name: string): Node;
        getPrivates(): any;
        /**
         * 根据子节点的索引位置，获取子节点对象。
         * @param    index 索引位置
         * @return    子节点
         */
        getChildAt(index: number): Node;
        /**
         * 设置子节点的索引位置。
         * @param    node 子节点。
         * @param    index 新的索引。
         * @return    返回子节点本身。
         */
        setChildIndex(node: Node, index: number): Node;
        /**
         * @private
         * 子节点发生改变。
         */
        childChanged(child?: Node): void;
        /**
         * 删除子节点。
         * @param    node 子节点
         * @return    被删除的节点
         */
        removeChild(node: Node): Node;
        /**
         * 从父容器删除自己，如已经被删除则不会抛出异常。
         */
        removeSelf(): Node;
        /**
         * 根据子节点名字删除对应的子节点对象，如找不到不会抛出异常。
         * @param    name 对象名字。
         */
        removeChildByName(name: string): Node;
        /**
         * 根据子节点索引位置，删除对应的子节点对象。
         * @param    index 节点索引位置。
         * @return    被删除的节点。
         */
        removeChildAt(index: number): Node;
        /**
         * 删除所有子对象。
         */
        removeChildren(beginIndex?: number, endIndex?: number): Node;
        /**
         * 替换子节点。
         * @internal 将传入的新节点对象替换到已有子节点索引位置处。
         * @param    newNode 新节点。
         * @param    oldNode 老节点。
         * @return    返回新节点。
         */
        replaceChild(newNode: Node, oldNode: Node): Node;
        /**
         * 子对象数量。
         */
        numChildren: number;
        /**父节点。*/
        parent: Node;
        /**表示是否在显示列表中显示。是否在显示渲染列表中。*/
        displayInStage: boolean;
        _setDisplay(value: boolean): void;
        /**
         * 询问是否为某类型的某值。
         * <p>常用来对对象类型进行快速判断。</p>
         * @param    type
         * @param    value
         * @return
         */
        ask(type: number, value: any): boolean;
        /**
         * 当前容器是否包含 <code>node</code> 节点。
         * @param    node  某一个节点 <code>Node</code>。
         * @return    一个布尔值表示是否包含<code>node</code>节点。
         */
        contains(node: Node): boolean;
        /**
         * 定时重复执行某函数。
         * @param    delay    间隔时间(单位毫秒)。
         * @param    caller    执行域(this)。
         * @param    method    结束时的回调方法。
         * @param    args    回调参数。
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false。
         */
        timerLoop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行某函数一次。
         * @param    delay    延迟时间(单位毫秒)。
         * @param    caller    执行域(this)。
         * @param    method    结束时的回调方法。
         * @param    args    回调参数。
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false。
         */
        timerOnce(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时重复执行某函数(基于帧率)。
         * @param    delay    间隔几帧(单位为帧)。
         * @param    caller    执行域(this)。
         * @param    method    结束时的回调方法。
         * @param    args    回调参数。
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false。
         */
        frameLoop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行一次某函数(基于帧率)。
         * @param    delay    延迟几帧(单位为帧)。
         * @param    caller    执行域(this)
         * @param    method    结束时的回调方法
         * @param    args    回调参数
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false
         */
        frameOnce(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 清理定时器。
         * @param    caller 执行域(this)。
         * @param    method 结束时的回调方法。
         */
        clearTimer(caller: any, method: Function): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Sprite</code> 类是基本显示列表构造块：一个可显示图形并且也可包含子项的显示列表节点。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
     * <p>[EXAMPLE-AS-BEGIN]</p>
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
     *
     * 		public function Sprite_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			onInit();
     * 		}
     *
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
     *
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
     *
     * 		private function onClickSprite():void
     * 		{
     * 			trace("点击 sprite 对象。");
     * 			sprite.rotation += 5;//旋转 sprite 对象。
     * 		}
     *
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
     *
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
     *
     *     private onClickSprite(): void {
     *         console.log("点击 sprite 对象。");
     *         this.sprite.rotation += 5;//旋转 sprite 对象。
     *     }
     *
     *     private onClickShape(): void {
     *         console.log("点击 shape 对象。");
     *         this.shape.rotation += 5;//旋转 shape 对象。
     *     }
     * }
     * </listing>
     * @author yung
     *
     */
    class Sprite extends Node implements ILayout {
        /**指定当mouseEnabled=true时，是否可穿透。默认值为false，如果设置为true，则点击空白区域可以穿透过去。*/
        mouseThrough: boolean;
        _width: number;
        _height: number;
        _zOrder: number;
        _style: laya.display.css.Style;
        _graphics: Graphics;
        _renderType: number;
        _$P: any;
        /**
         * 指定是否自动计算宽高数据。默认值为 false 。
         * 自动计算计算量较大，对性能有一定影响。
         * 在手动设置宽高属性之后该属性不起作用。
         */
        autoSize: boolean;
        /**
         * <p>指定是否对使用了 scrollRect 的显示对象进行优化处理。</p>
         * <p>默认为false(不优化)。</p>
         * <p>当值为ture时：将对此对象使用了scrollRect 设定的显示区域以外的显示内容不进行渲染，以提高性能。</p>
         */
        optimizeFloat: boolean;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**根据Z进行重新排序。*/
        updateOrder(): void;
        /**
         * 功能同cacheAs
         */
        cacheAsBitmap: boolean;
        /**指定显示对象是否缓存为静态图像，cacheAsBitmap=true时，子对象发生变化，会自动重新缓存，同时也可以手动调用reCache方法更新缓存。
         * 建议把不经常变化的复杂内容缓存为静态图像，能极大提高渲染性能，有"none"，"normal"和"bitmap"三个值可选
         * <p>默认为"none"，不做任何缓存。</p>
         * <p>当值为"normal"时，canvas下进行画布缓存，webgl模式下进行命令缓存。</p>
         * <p>当值为"bitmap"时，canvas下进行依然是画布缓存，webgl模式下使用renderTarget缓存。</p>
         * webgl下renderTarget缓存模式有最大2048大小限制，会额外增加内存开销，不断重绘时开销比较大，但是会减少drawcall，渲染性能最高。
         * webgl下命令缓存模式只会减少节点遍历及命令组织，不会减少drawcall，性能中等。
         */
        cacheAs: string;
        /**cacheAsBitmap=true时此值才有效，staticCache=true时，子对象变化时不会自动更新缓存，只能通过调用reCache方法手动刷新*/
        staticCache: boolean;
        /**在设置cacheAsBtimap=true或者staticCache=true的情况下，调用此方法会重新刷新缓存*/
        reCache(): void;
        /**表示显示对象相对于父容器的水平方向坐标值。*/
        x: number;
        /**表示显示对象相对于父容器的垂直方向坐标值。*/
        y: number;
        /**
         * 表示显示对象的宽度，以像素为单位。
         * @return
         */
        width: number;
        /**
         * 表示显示对象的高度，以像素为单位。
         * @return
         */
        height: number;
        /**
         * 表示显示对象的显示宽度，以像素为单位。
         * @return
         *
         */
        viewWidth: number;
        /**
         * 表示显示对象的显示高度，以像素为单位。
         * @return
         *
         */
        viewHeight: number;
        setBounds(bound: laya.maths.Rectangle): void;
        /**
         * 获取本对象在父容器坐标系的矩形显示区域。
         * 计算量较大，尽量少用。
         * @return 矩形区域
         */
        getBounds(): laya.maths.Rectangle;
        /**
         * 获取本对象在自己坐标系的矩形显示区域。
         * 计算量较大，尽量少用。
         * @return 矩形区域
         */
        getSelfBounds(): laya.maths.Rectangle;
        /**
         * 获取本对象在父容器坐标系的显示区域多边形顶点列表。
         * 当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
         * @param ifRotate 之前的对象链中是否有旋转。
         * @return 顶点列表
         */
        boundPointsToParent(ifRotate?: boolean): Array<any>;
        /**
         * 返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域。
         * @return
         *
         */
        getGraphicBounds(): laya.maths.Rectangle;
        /**
         * @private
         * 获取自己坐标系的显示区域多边形顶点列表
         * @param ifRotate 当前的显示对象链是否由旋转
         * @return 顶点列表
         */
        _getBoundPointsM(ifRotate?: boolean): Array<any>;
        /**
         * 获取样式。
         * @return
         * @private
         */
        getStyle(): laya.display.css.Style;
        get$P(): any;
        /**
         * 设置样式。
         * @param    value
         */
        setStyle(value: laya.display.css.Style): void;
        /**X轴缩放值，默认值为1。*/
        scaleX: number;
        /**Y轴缩放值，默认值为1。*/
        scaleY: number;
        /**旋转角度，默认值为0。*/
        rotation: number;
        /**水平倾斜角度，默认值为0。*/
        skewX: number;
        /**垂直倾斜角度，默认值为0。*/
        skewY: number;
        /**
         * 对象的矩阵信息。
         */
        transform: laya.maths.Matrix;
        /**X轴心点的位置，默认为0，轴心点会影响对象位置，缩放，旋转。*/
        pivotX: number;
        /**Y轴心点的位置，默认为0，轴心点会影响对象位置，缩放，旋转。*/
        pivotY: number;
        /**透明度，值为0-1，默认为1表示不透明。*/
        alpha: number;
        /**表示是否可见，默认为true。*/
        visible: boolean;
        /**指定要使用的混合模式。*/
        blendMode: string;
        /**绘图对象。*/
        graphics: Graphics;
        /**显示对象的滚动矩形范围。*/
        scrollRect: laya.maths.Rectangle;
        /**
         * 设置坐标位置。
         * @param    x X轴坐标
         * @param    y Y轴坐标
         * @return    返回对象本身
         */
        pos(x: number, y: number): Sprite;
        /**
         * 设置轴心点。
         * @param    x X轴心点
         * @param    y Y轴心点
         * @return    返回对象本身
         */
        pivot(x: number, y: number): Sprite;
        /**
         * 设置宽高。
         * @param    width 宽度
         * @param    hegiht 高度
         * @return    返回对象本身
         */
        size(width: number, height: number): Sprite;
        /**
         * 设置缩放。
         * @param    scaleX X轴缩放比例
         * @param    scaleY Y轴缩放比例
         * @return    返回对象本身
         */
        scale(scaleX: number, scaleY: number): Sprite;
        /**
         * 设置倾斜角度。
         * @param    skewX 水平倾斜角度
         * @param    skewY 垂直倾斜角度
         * @return    返回对象本身
         */
        skew(skewX: number, skewY: number): Sprite;
        _removeRenderType(type: number): void;
        _addRenderType(type: number): void;
        /**
         * 更新、呈现显示对象。
         * @param    context
         * @param    x
         * @param    y
         */
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 绘制 <code>Sprite</code> 到 <code>canvas</code> 上。
         * @param    canvasWidth 画布宽度。
         * @param    canvasHeight 画布高度。
         * @param    x 绘制的X轴偏移量。
         * @param    y 绘制的Y轴偏移量。
         * @return
         */
        drawToCanvas(canvasWidth: number, canvasHeight: number, offsetX: number, offsetY: number): laya.resource.HTMLCanvas;
        /**
         * 自定义更新、呈现显示对象。
         * 【注意】不要在此函数内增加或删除树节点，否则会树节点遍历照成影响
         * @param    context
         * @param    x
         * @param    y
         */
        customRender(context: laya.renders.RenderContext, x: number, y: number): void;
        /**
         * 应用滤镜。
         */
        applyFilters(): void;
        /**滤镜集合。*/
        filters: Array<any>;
        /**@inheritDoc */
        ask(type: number, value: any): boolean;
        /**
         * 本地坐标转全局坐标
         * @param point 要转换的点
         * @return 转换后的点
         */
        localToGlobal(point: laya.maths.Point, createNewPoint?: boolean): laya.maths.Point;
        /**
         * 全局坐标转本地坐标
         * @param point 要转换的点
         * @return 转换后的点
         */
        globalToLocal(point: laya.maths.Point, createNewPoint?: boolean): laya.maths.Point;
        /**
         * 将本地坐标系坐标转换到父容器坐标系
         * @param point 要转换的点
         * @return  转换后的点
         */
        toParentPoint(point: laya.maths.Point): laya.maths.Point;
        /**
         * 将父容器坐标系坐标转换到本地坐标系
         * @param point 要转换的点
         * @return  转换后的点
         */
        fromParentPoint(point: laya.maths.Point): laya.maths.Point;
        /**
         *
         * 增加事件监听，如果侦听鼠标事件，则会自动设置自己和父亲节点的mouseEnable=true
         * @param    type 事件类型，可以参考Event类定义
         * @param    caller 执行域(this域)，默认为监听对象的this域
         * @param    listener 回调方法，如果为空，则移除所有type类型的事件监听
         * @param    args 回调参数
         * @return    返回对象本身
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        /**
         * 增加一次性事件监听，执行后会自动移除监听，如果侦听鼠标事件，则会自动设置自己和父亲节点的mouseEnable=true
         * @param    type 事件类型，可以参考Event类定义
         * @param    caller 执行域(this域)，默认为监听对象的this域
         * @param    listener 回调方法，如果为空，则移除所有type类型的事件监听
         * @param    args 回调参数
         * @return    返回对象本身
         */
        once(type: string, caller: any, listener: Function, args?: Array<any>): laya.events.EventDispatcher;
        /**
         * 加载并显示一个图片【注意】同一对象调用多次，会导致渲染多张图片。
         * @param    url    图片地址。
         * @param    x 显示图片的x位置
         * @param    y 显示图片的y位置
         * @param    width 显示图片的宽度，设置为0表示使用图片默认宽度
         * @param    height 显示图片的高度，设置为0表示使用图片默认高度
         * @param    complete 加载完成回调
         * @return    返回精灵对象本身
         */
        loadImage(url: string, x?: number, y?: number, width?: number, height?: number, complete?: laya.utils.Handler): Sprite;
        /**
         * 根据图片地址创建一个新的 <code>Sprite</code> 对象加载并显示此图片。
         * @param    url 图片地址。
         * @return    返回新的 <code>Sprite</code> 对象。
         */
        static fromImage(url: string): Sprite;
        /**cacheAsBitmap=true时，手动重新缓存本对象。*/
        repaint(): void;
        /**
         * 获取是否重新缓存。
         * @return
         */
        isRepaint(): boolean;
        /**@inheritDoc    */
        childChanged(child?: Node): void;
        /**cacheAsBitmap=true时，手动重新缓存父对象。 */
        parentRepaint(child: Sprite): void;
        /** 对舞台 <code>stage</code> 的引用。*/
        stage: Stage;
        /** 手动设置的可点击区域。*/
        hitArea: laya.maths.Rectangle;
        /**遮罩。*/
        mask: Sprite;
        /**
         * 是否接受鼠标事件。
         * 默认为false，如果监听鼠标事件，则会自动设置本对象及父节点的 mouseEnable 都为 true。
         * */
        mouseEnabled: boolean;
        /**
         * 开始拖动此对象。
         * @param    area 拖动区域，此区域为当前对象注册点活动区域（不包括对象宽高），可选。
         * @param    hasInertia 鼠标松开后，是否还惯性滑动，默认为false，可选。
         * @param    elasticDistance 橡皮筋效果的距离值，0为无橡皮筋效果，默认为0，可选。
         * @param    elasticBackTime 橡皮筋回弹时间，单位为毫秒，默认为300毫秒，可选。
         * @param    data 拖动事件携带的数据，可选。
         * @param    disableMouseEvent禁用其他对象的鼠标检测，默认为false，设置为true能提高性能
         */
        startDrag(area?: laya.maths.Rectangle, hasInertia?: boolean, elasticDistance?: number, elasticBackTime?: number, data?: any, disableMouseEvent?: boolean): void;
        /**停止拖动此对象。*/
        stopDrag(): void;
        _setDisplay(value: boolean): void;
        /**
         * 检测某个点是否在此对象内。
         * @param    x 全局x坐标。
         * @param    y 全局y坐标。
         * @return  表示是否在对象内。
         */
        hitTestPoint(x: number, y: number): boolean;
        /**获得相对于本对象上的鼠标坐标信息。*/
        getMousePoint(): laya.maths.Point;
        /**允许webgl绘制时指令合并优化。*/
        enableRenderMerge: boolean;
        /**
         * 表示鼠标在此对象上的X轴坐标信息。
         */
        mouseX: number;
        /**
         * 表示鼠标在此对象上的Y轴坐标信息。
         */
        mouseY: number;
        /**z排序，更改此值，能按照值大小显示先后顺序。*/
        zOrder: number;
        _getWords(): Array<any>;
        _addChildsToLayout(out: Array<any>): boolean;
        _addToLayout(out: Array<any>): void;
        _isChar(): boolean;
        _getCSSStyle(): laya.display.css.CSSStyle;
        /**
         * 通过属名设置对应属性的值。
         * @param    name 属性名。
         * @param    value 属性值。
         */
        setValue(name: string, value: string): void;
        /**
         * @private
         */
        layoutLater(): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Stage</code> 类是显示对象的根节点。</p>
     * 可以通过Laya.stage访问。
     */
    class Stage extends Sprite {
        /**整个应用程序的大小固定，因此，即使播放器窗口的大小更改，它也会保持不变。如果播放器窗口比内容小，则可能进行一些裁切。*/
        static SCALE_NOSCALE: string;
        /**整个应用程序在指定区域中可见，但不尝试保持原始高宽比。可能会发生扭曲，应用程序可能会拉伸或压缩显示。*/
        static SCALE_EXACTFIT: string;
        /**整个应用程序在指定区域中可见，且不发生扭曲，同时保持应用程序的原始高宽比。应用程序的两侧可能会显示边框。*/
        static SCALE_SHOWALL: string;
        /**整个应用程序根据屏幕的尺寸等比缩放内容，缩放后应用程序内容向较窄方向填满播放器窗口，另一个方向的两侧可能会超出播放器窗口而被裁切，只显示中间的部分。*/
        static SCALE_NOBORDER: string;
        /**按照设计宽高显示，画布大小不变，stage同设计大小*/
        static SIZE_NONE: string;
        /**按照屏幕宽高显示，画布充满全屏，stage大小等于屏幕大小。*/
        static SIZE_FULL: string;
        /**宽度充满全屏，画布高度不变，宽度根据屏幕比充满全屏，stage高度为设计宽度，宽度为根据屏幕比率计算的宽度。*/
        static SIZE_FULL_WIDTH: string;
        /**高度充满全屏，画布宽度不变，高度根据屏幕比充满全屏，stage宽度为设计宽度，高度为根据屏幕比率计算的宽度。*/
        static SIZE_FULL_HEIGHT: string;
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
        /**如果小于48帧，以30的帧率运行。*/
        static FRAME_AUTO: string;
        /**当前焦点对象，此对象会影响当前键盘事件的派发主体。*/
        focus: Node;
        /**相对浏览器左上角的偏移。*/
        offset: laya.maths.Point;
        /**帧率类型，支持三种模式：fast-60帧(默认)，slow-30帧，auto-30帧，但鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗。*/
        frameRate: string;
        /**本帧开始时间，只读，如果不是对精度要求过高，建议使用此时间，比Browser.now()快3倍。*/
        now: number;
        _canvasTransform: laya.maths.Matrix;
        /**画布是否发送翻转*/
        canvasRotation: boolean;
        constructor();
        /**@inheritDoc     */
        size(width: number, height: number): Sprite;
        /**
         * 设置画布大小。
         * @param    canvasWidth    画布宽度。
         * @param    canvasHeight 画布高度。
         */
        setCanvasSize(canvasWidth: number, canvasHeight: number): void;
        /**
         * <p>缩放模式。</p>
         *
         * <p><ul>取值范围：
         * <li>"noScale" ：不缩放；</li>
         * <li>"exactFit" ：全屏不等比缩放；</li>
         * <li>"showAll" ：最小比例缩放；</li>
         * <li>"noBorder" ：最大比例缩放；</li>
         * </ul></p>
         * 默认值为"noScale"。
         * */
        scaleMode: string;
        /**
         * 应用程序大小模式。
         * <p><ul>取值范围：
         * <li>"full"；</li>
         * <li>"none"；</li>
         * </ul></p>
         * 默认值为"none"。
         * */
        sizeMode: string;
        /**
         * 水平对齐方式。
         * <p><ul>取值范围：
         * <li>"left" ：居左对齐；</li>
         * <li>"center" ：居中对齐；</li>
         * <li>"right" ：居右对齐；</li>
         * </ul></p>
         * 默认值为"left"。
         * */
        alignH: string;
        /**
         * 垂直对齐方式。
         * <p><ul>取值范围：
         * <li>"top" ：居顶部对齐；</li>
         * <li>"middle" ：居中对齐；</li>
         * <li>"bottom" ：居底部对齐；</li>
         * </ul></p>
         * */
        alignV: string;
        /**使用高清渲染，默认为true*/
        useHDRendering: boolean;
        /**舞台的背景颜色，默认为黑色，null为透明。*/
        bgColor: string;
        /**鼠标在 Stage 上的X坐标。*/
        mouseX: number;
        /**鼠标在 Stage 上的Y坐标。*/
        mouseY: number;
        /**当前视窗X轴缩放大小。*/
        clientScaleX: number;
        /**当前视窗Y轴缩放大小。*/
        clientScaleY: number;
        /**
         * 场景布局类型
         * <p><ul>取值范围：
         * <li>"none" ：不更改屏幕</li>
         * <li>"horizontal" ：自动横屏</li>
         * <li>"vertical" ：自动竖屏</li>
         * </ul></p>
         * */
        screenMode: string;
        /**@inheritDoc */
        repaint(): void;
        /**@inheritDoc */
        parentRepaint(child: Sprite): void;
        _loop(): boolean;
        /**@inheritDoc */
        render(context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.display {
    /**
     * <p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
     * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
     * <p>[EXAMPLE-AS-BEGIN]</p>
     * <listing version="3.0">
     * package
     * {
     * 	import laya.display.Text;
     *
     * 	public class Text_Example
     * 	{
     * 		public function Text_Example()
     * 		{
     * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     * 			onInit();
     * 		}
     *
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
     * <p>[EXAMPLE-AS-END]</p>
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
     * @author yung
     */
    class Text extends Sprite {
        /**语言包*/
        static langPacks: any;
        /**
         * 创建一个新的 <code>Text</code> 实例。
         */
        constructor();
        /**
         * 注册位图字体
         * @param    name        位图字体的名称
         * @param    bitmapFont    位图字体文件
         */
        static registerBitmapFont(name: string, bitmapFont: BitmapFont): void;
        /**
         * 取消注册的位图字体文件
         * @param    name        位图字体的名称
         * @param    destory        是否销毁当前字体文件
         */
        static unregisterBitmapFont(name: string, destory?: boolean): void;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**
         * @private
         * @inheritDoc
         *
         */
        _getBoundPointsM(ifRotate?: boolean): Array<any>;
        /**@inheritDoc */
        getGraphicBounds(): laya.maths.Rectangle;
        /**
         * @inheritDoc
         * @return
         *
         */
        width: number;
        /**
         * @private
         * @inheritDoc
         * */
        _getCSSStyle(): laya.display.css.CSSStyle;
        /**
         * @inheritDoc
         * @return
         *
         */
        height: number;
        /**
         * 表示文本的宽度，以像素为单位。
         * @return
         *
         */
        textWidth: number;
        /**
         * 表示文本的高度，以像素为单位。
         * @return
         *
         */
        textHeight: number;
        /**当前文本的内容字符串。*/
        text: string;
        /**
         * 设置语言包
         * @param    text    文本，可以增加参数，比如"abc
         * @param    ...args    文本参数，比如"d","h",4
         */
        lang(text: string, arg1?: any, arg2?: any, arg3?: any, arg4?: any, arg5?: any, arg6?: any, arg7?: any, arg8?: any, arg9?: any, arg10?: any): void;
        /**
         * 文本的字体名称，以字符串形式表示。
         *
         * <p>默认值为："Arial"，可以通过Text.defaultFont设置默认字体。</p>
         *
         * @see Text.defaultFont
         * @return
         *
         */
        font: string;
        /**
         * 指定文本的字体大小（以像素为单位）。
         *
         * <p>默认为20像素，可以通过 <code>Text.defaultSize</code> 设置默认大小。</p>
         * @return
         *
         */
        fontSize: number;
        /**
         * 指定文本是否为粗体字。
         *
         * <p>默认值为 false，这意味着不使用粗体字。如果值为 true，则文本为粗体字。</p>
         *
         * @return
         *
         */
        bold: boolean;
        /**
         * 表示文本的颜色值。可以通过 <code>Text.defaultColor</code> 设置默认颜色。
         * <p>默认值为黑色。</p>
         * @return
         *
         */
        color: string;
        /**
         * 表示使用此文本格式的文本是否为斜体。
         *
         * <p>默认值为 false，这意味着不使用斜体。如果值为 true，则文本为斜体。</p>
         * @return
         *
         */
        italic: boolean;
        /**
         * 表示文本的水平显示方式。
         *
         * <p><b>取值：</b>
         * <li>"left"： 居左对齐显示。</li>
         * <li>"center"： 居中对齐显示。</li>
         * <li>"right"： 居右对齐显示。</li>
         * </p>
         * @return
         *
         */
        align: string;
        /**
         * 表示文本的垂直显示方式。
         *
         * <p><b>取值：</b>
         * <li>"top"： 居顶部对齐显示。</li>
         * <li>"middle"： 居中对齐显示。</li>
         * <li>"bottom"： 居底部对齐显示。</li>
         * </p>
         * @return
         *
         */
        valign: string;
        /**
         * 表示文本是否自动换行，默认为false。
         *
         * <p>若值为true，则自动换行；否则不自动换行。</p>
         * @return
         *
         */
        wordWrap: boolean;
        /**
         * 垂直行间距（以像素为单位）。
         * @return
         *
         */
        leading: number;
        /**
         * 边距信息。
         *
         * <p>[上边距，右边距，下边距，左边距]（边距以像素为单位）。</p>
         * @return
         *
         */
        padding: Array<any>;
        /**
         * 文本背景颜色，以字符串表示。
         * @return
         *
         */
        bgColor: string;
        /**
         * 文本边框背景颜色，以字符串表示。
         * @return
         *
         */
        borderColor: string;
        /**
         * <p>指定文本字段是否是密码文本字段。</p>
         * <p>如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。</p>
         * <p>默认值为false。</p>
         * @return
         *
         */
        asPassword: boolean;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         * @return
         *
         */
        stroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * 默认值为 "#000000"（黑色）;
         * @return
         *
         */
        strokeColor: string;
        protected isChanged: boolean;
        protected renderTextAndBg(begin: number, visibleLineCount: number): void;
        /**
         * <p>排版文本。</p>
         * <p>进行宽高计算，渲染、重绘文本。</p>
         */
        typeset(): void;
        /**
         * 快速更改显示文本。不进行排版计算，效率较高。
         *
         * <p>如果只更改文字内容，不更改文字样式，建议使用此接口，能提高效率。</p>
         * @param text 文本内容。
         *
         */
        changeText(text: string): void;
        protected parseWordWrap(text: string): Array<any>;
        /**
         * 返回字符的位置信息。
         * @param    charIndex 索引位置
         * @param    out 输出的Point引用
         * @return    返回Point位置信息
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
    }
}
declare module laya.events {
    /**
     * 事件类型
     * @author yung
     */
    class Event {
        static EMPTY: Event;
        static MOUSE_DOWN: string;
        static MOUSE_UP: string;
        static CLICK: string;
        static RIGHT_MOUSE_DOWN: string;
        static RIGHT_MOUSE_UP: string;
        static RIGHT_CLICK: string;
        static MOUSE_MOVE: string;
        static MOUSE_OVER: string;
        static MOUSE_OUT: string;
        static MOUSE_WHEEL: string;
        static ROLL_OVER: string;
        static ROLL_OUT: string;
        static DOUBLE_CLICK: string;
        static CHANGE: string;
        static CHANGED: string;
        static RESIZE: string;
        static ADDED: string;
        static REMOVED: string;
        static DISPLAY: string;
        static UNDISPLAY: string;
        static ERROR: string;
        static COMPLETE: string;
        static LOADED: string;
        static PROGRESS: string;
        static INPUT: string;
        static RENDER: string;
        static OPEN: string;
        static MESSAGE: string;
        static CLOSE: string;
        static KEY_DOWN: string;
        static KEY_PRESS: string;
        static KEY_UP: string;
        static ENTER_FRAME: string;
        static DRAG_START: string;
        static DRAG_MOVE: string;
        static DRAG_END: string;
        static ENTER: string;
        static SELECT: string;
        static BLUR: string;
        static FOCUS: string;
        static PLAYED: string;
        static PAUSED: string;
        static STOPPED: string;
        static START: string;
        static END: string;
        static ENABLED_CHANGED: string;
        static COMPONENT_ADDED: string;
        static COMPONENT_REMOVED: string;
        static ACTIVE_CHANGED: string;
        static LAYER_CHANGED: string;
        static HIERARCHY_LOADED: string;
        static MEMORY_CHANGED: string;
        static RECOVERED: string;
        static RELEASED: string;
        static LINK: string;
        /**事件类型*/
        type: string;
        /**原生浏览器事件*/
        nativeEvent: any;
        /**事件目标触发对象*/
        target: laya.display.Sprite;
        /**事件当前冒泡对象*/
        currentTarget: laya.display.Sprite;
        _stoped: boolean;
        /**touch事件唯一ID，用来区分多点触摸事件*/
        touchId: number;
        /**
         * 设置事件数据
         * @param    type 事件类型
         * @param    currentTarget 事件目标触发对象
         * @param    target 事件当前冒泡对象
         * @return
         */
        setTo(type: string, currentTarget: laya.display.Sprite, target: laya.display.Sprite): Event;
        /**停止事件冒泡*/
        stopPropagation(): void;
        /**多点触摸时，返回触摸点的集合*/
        touches: Array<any>;
        /**鼠标事件的同时是否按下alt键*/
        altKey: boolean;
        /**鼠标事件的同时是否按下ctrl键*/
        ctrlKey: boolean;
        /**鼠标事件的同时是否按下shift键*/
        shiftKey: boolean;
    }
}
declare module laya.events {
    /**
     * 事件调度类
     * @author yung
     */
    class EventDispatcher {
        static MOUSE_EVENTS: any;
        /**
         * 是否有某种事件监听
         * @param    type 事件名称
         * @return    是否有某种事件监听
         */
        hasListener(type: string): boolean;
        /**
         * 发送事件
         * @param    type 事件类型
         * @param    data 回调数据，可以是单数据或者Array(作为多参)
         * @return    如果没有监听者，则返回false，否则true
         */
        event(type: string, data?: any): boolean;
        /**
         * 增加事件监听
         * @param    type 事件类型，可以参考Event类定义
         * @param    caller 执行域(this域)，默认为监听对象的this域
         * @param    listener 回调方法，如果为空，则移除所有type类型的事件监听
         * @param    args 回调参数
         * @return    返回对象本身
         */
        on(type: string, caller: any, listener: Function, args?: Array<any>): EventDispatcher;
        /**
         * 增加一次性事件监听，执行后会自动移除监听
         * @param    type 事件类型，可以参考Event类定义
         * @param    caller 执行域(this域)，默认为监听对象的this域
         * @param    listener 回调方法，如果为空，则移除所有type类型的事件监听
         * @param    args 回调参数
         * @return    返回对象本身
         */
        once(type: string, caller: any, listener: Function, args?: Array<any>): EventDispatcher;
        /**
         * 移除事件监听，同removeListener方法
         * @param    type 事件类型，可以参考Event类定义
         * @param    caller 执行域(this域)，默认为监听对象的this域
         * @param    listener 回调方法，如果为空，则移除所有type类型的事件监听
         * @param    onceOnly 是否只移除once监听，默认为false
         * @return    返回对象本身
         */
        off(type: string, caller: any, listener: Function, onceOnly?: boolean): EventDispatcher;
        /**
         * 移除某类型所有事件监听
         * @param    type 事件类型，如果为空，则移除本对象所有事件监听
         * @return    返回对象本身
         */
        offAll(type?: string): EventDispatcher;
        /**
         * 是否是鼠标事件
         * @param    type 事件类型
         * @return    是否鼠标事件
         */
        isMouseEvent(type: string): boolean;
    }
    class EventHandler extends laya.utils.Handler {
        EventHandler(caller: any, method: Function, args: Array<any>, once: boolean): any;
        recover(): void;
        /**
         * 从对象池内创建一个Handler，默认会执行一次回收，如果不需要自动回收，设置once参数为false
         * @param    caller 执行域(this)
         * @param    method 回调方法
         * @param    args 携带的参数
         * @param    once 是否只执行一次，如果为true，回调后执行recover()进行回收，默认为true
         * @return  返回创建的handler实例
         */
        static create(caller: any, method: Function, args?: Array<any>, once?: boolean): laya.utils.Handler;
    }
}
declare module laya.events {
    /**
     * 键盘code对应表
     * @author
     */
    class Keyboard {
        static NUMBER_0: number;
        static NUMBER_1: number;
        static NUMBER_2: number;
        static NUMBER_3: number;
        static NUMBER_4: number;
        static NUMBER_5: number;
        static NUMBER_6: number;
        static NUMBER_7: number;
        static NUMBER_8: number;
        static NUMBER_9: number;
        static A: number;
        static B: number;
        static C: number;
        static D: number;
        static E: number;
        static F: number;
        static G: number;
        static H: number;
        static I: number;
        static J: number;
        static K: number;
        static L: number;
        static M: number;
        static N: number;
        static O: number;
        static P: number;
        static Q: number;
        static R: number;
        static S: number;
        static T: number;
        static U: number;
        static V: number;
        static W: number;
        static X: number;
        static Y: number;
        static Z: number;
        static SEMICOLON: number;
        static EQUAL: number;
        static COMMA: number;
        static MINUS: number;
        static PERIOD: number;
        static SLASH: number;
        static BACKQUOTE: number;
        static LEFTBRACKET: number;
        static BACKSLASH: number;
        static RIGHTBRACKET: number;
        static QUOTE: number;
        static ALTERNATE: number;
        static BACKSPACE: number;
        static CAPS_LOCK: number;
        static COMMAND: number;
        static CONTROL: number;
        static DELETE: number;
        static DOWN: number;
        static END: number;
        static ENTER: number;
        static ESCAPE: number;
        static F1: number;
        static F2: number;
        static F3: number;
        static F4: number;
        static F5: number;
        static F6: number;
        static F7: number;
        static F8: number;
        static F9: number;
        static F10: number;
        static F11: number;
        static F12: number;
        static F13: number;
        static F14: number;
        static F15: number;
        static HOME: number;
        static INSERT: number;
        static LEFT: number;
        static NUMPAD: number;
        static NUMPAD_0: number;
        static NUMPAD_1: number;
        static NUMPAD_2: number;
        static NUMPAD_3: number;
        static NUMPAD_4: number;
        static NUMPAD_5: number;
        static NUMPAD_6: number;
        static NUMPAD_7: number;
        static NUMPAD_8: number;
        static NUMPAD_9: number;
        static NUMPAD_ADD: number;
        static NUMPAD_DECIMAL: number;
        static NUMPAD_DIVIDE: number;
        static NUMPAD_ENTER: number;
        static NUMPAD_MULTIPLY: number;
        static NUMPAD_SUBTRACT: number;
        static PAGE_DOWN: number;
        static PAGE_UP: number;
        static RIGHT: number;
        static SHIFT: number;
        static SPACE: number;
        static TAB: number;
        static UP: number;
    }
}
declare module laya.events {
    /**
     * 键盘事件管理类
     * 该类从浏览器中接收键盘事件，并转发该事件
     * 转发事件时若Stage.focus为空则只从Stage上派发该事件，不然将从Stage.focus对象开始一直冒泡派发该事件
     * 所以在Laya.stage上监听键盘事件一定能够收到，如果在其他地方监听，则必须处在Stage.focus的冒泡链上才能收到该事件
     * 用户可以通过代码Laya.stage.focus=someNode的方式来设置focus对象
     * 用户可统一的根据事件对象中 e.keyCode来判断按键类型，该属性兼容了不同浏览器的实现
     * 其他事件属性可自行从 e 中获取
     * @author ww
     * @version 1.0
     * @created  2015-9-23 上午10:57:26
     */
    class KeyBoardManager {
        static __init__(): void;
        /**
         * 某个键是否被按下
         * @param    key 键值
         * @return
         */
        static hasKeyDown(key: number): boolean;
    }
}
declare module laya.events {
    /**
     * 鼠标交互管理器
     * @author yung
     */
    class MouseManager {
        static instance: MouseManager;
        /**canvas上的鼠标X坐标*/
        mouseX: number;
        /**canvas上的鼠标Y坐标*/
        mouseY: number;
        /**禁用除stage意外的鼠标事件检测*/
        disableMouseEvent: boolean;
        /**鼠标是否按下*/
        mouseDownTime: number;
        _event: Event;
        __init__(): void;
        runEvent(): void;
    }
}
declare module laya.filters {
    /**
     * webgl ok ,canvas unok
     *
     */
    class BlurFilter extends Filter {
        _blurX: number;
        _blurY: number;
        strength: number;
        constructor(strength?: number);
        action: IFilterAction;
        type: number;
    }
}
declare module laya.filters {
    /**
     * 颜色变化滤镜
     * @author ww
     * @version 1.0
     *
     * @created  2015-9-18 上午10:52:10
     */
    class ColorFilter extends Filter implements IFilter {
        /**
         *  创建颜色滤镜
         * @param matrix  由 20 个项（排列成 4 x 5 矩阵）组成的数组
         */
        static DEFAULT: ColorFilter;
        static GRAY: ColorFilter;
        _elements: Float32Array;
        constructor(mat?: Array<any>);
        type: number;
        action: IFilterAction;
    }
}
declare module laya.filters {
    class ColorFilterAction implements IFilterAction {
        constructor();
        apply(srcCanvas: any): any;
    }
}
declare module laya.filters {
    /**
     * ...
     * @author wk
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
        _action: any;
        constructor();
        type: number;
        action: IFilterAction;
    }
}
declare module laya.filters {
    /**
     *  发光滤镜
     * @author ww
     * @version 1.0
     * @created  2015-9-18 下午7:10:26
     */
    class GlowFilter extends Filter {
        _color: laya.utils.Color;
        _blurX: boolean;
        /**
         *顺序R,G,B,A,blurWidth,offX,offY;
         */
        elements: Float32Array;
        /**
         * 创建发光滤镜
         * @param color 颜色值 “#ffffff”格式
         * @param blur 宽度
         * @param offX x偏移
         * @param offY y偏移
         */
        constructor(color: string, blur?: number, offX?: number, offY?: number);
        type: number;
        offY: number;
        offX: number;
        color: string;
        blur: number;
    }
}
declare module laya.filters {
    class GlowFilterAction implements IFilterAction {
        static Canvas: any;
        static Ctx: any;
        data: GlowFilter;
        constructor();
        apply(srcCanvas: any): any;
    }
}
declare module laya.filters {
    /**
     * 滤镜接口
     */
    interface IFilter {
    }
}
declare module laya.filters {
    interface IFilterAction {
    }
}
declare module laya.filters {
    interface IFilterActionGL extends IFilterAction {
    }
}
declare module laya.filters.webgl {
    class BlurFilterActionGL extends FilterActionGL {
        constructor();
        typeMix: number;
        setValueMix(shader: laya.webgl.shader.d2.value.Value2D): void;
        apply3d(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): any;
    }
}
declare module laya.filters.webgl {
    class ColorFilterActionGL extends FilterActionGL implements laya.filters.IFilterActionGL {
        data: laya.filters.ColorFilter;
        constructor();
        setValue(shader: any): void;
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
    class GlowFilterActionGL extends FilterActionGL implements laya.filters.IFilterActionGL {
        constructor();
        typeMix: number;
        setValueMix(shader: laya.webgl.shader.d2.value.Value2D): void;
        static tmpTarget(scope: any, sprite: any, context: any, x: number, y: number): void;
        static startOut(scope: any, sprite: any, context: any, x: number, y: number): void;
        static recycleTarget(scope: any, sprite: any, context: any, x: number, y: number): void;
        apply3d(scope: laya.webgl.submit.SubmitCMDScope, sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): any;
    }
}
declare module laya.filters {
    class WebGLFilter {
        static enable(): void;
    }
}
declare module laya.html.dom {
    /**
     * ...
     * @author laya
     */
    class HTMLBrElement extends HTMLElement {
        constructor();
    }
}
declare module laya.html.dom {
    /**
     * ...
     * @author laya
     */
    class HTMLDivElement extends HTMLElement {
        contextHeight: number;
        contextWidth: number;
        constructor();
        innerHTML: string;
        appendHTML(text: string): void;
        _addChildsToLayout(out: Array<any>): boolean;
        _addToLayout(out: Array<any>): void;
        layout(): void;
        height: number;
        width: number;
    }
}
declare module laya.html.dom {
    /**
     * ...
     * @author laya
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
     * ...
     * @author laya
     */
    class HTMLElement extends laya.display.Sprite {
        URI: laya.net.URL;
        constructor();
        id: string;
        text: string;
        innerTEXT: string;
        parent: laya.display.Node;
        appendChild(c: HTMLElement): HTMLElement;
        style: laya.display.css.CSSStyle;
        _getWords(): Array<any>;
        showLinkSprite(): void;
        layoutLater(): void;
        onClick: string;
        setValue(name: string, value: string): void;
        href: string;
        formatURL(url: string): string;
        color: string;
        className: string;
    }
}
declare module laya.html.dom {
    /**
     * ...
     * @author laya
     */
    class HTMLIframeElement extends HTMLDivElement {
        constructor();
        href: string;
    }
}
declare module laya.html.dom {
    /**
     * ...
     * @author laya
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
     * ...
     * @author laya
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
     * ...
     * @author laya
     */
    class HTMLStyleElement extends HTMLElement {
        constructor();
        text: string;
    }
}
declare module laya.html.utils {
    class HTMLParse {
        /**
         * 解析HTML
         */
        static parse(ower: laya.html.dom.HTMLDivElement, xmlString: string, url: laya.net.URL): void;
    }
}
declare module laya.html.utils {
    /**
     * ...
     * @author laya
     */
    class Layout {
        static later(element: laya.display.Sprite): void;
        static layout(element: laya.display.Sprite): Array<any>;
        static _multiLineLayout(element: laya.display.Sprite): Array<any>;
    }
}
declare module laya.html.utils {
    /**
     * ...
     * @author laya
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
         * @param    left
         * @param    width
         * @param    dy
         * @param    align        水平
         * @param    valign        垂直
         * @param    lineHeight    行高
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
        isAloneObjectKey: boolean;
        /**当前GRID中是否有动画*/
        haveAnimationKey: boolean;
        /**当前GRID包含的动画*/
        aniSpriteArray: Array<any>;
        /**当前GRID包含多少个TILE(包含动画)*/
        drawImageNum: number;
        /**
         * 传入必要的参数，用于裁剪，跟确认此对象类型
         * @param    map    把地图的引用传进来，参与一些裁剪计算
         * @param    objectKey true:表示当前GridSprite是个活动对象，可以控制，false:地图层的组成块
         */
        initData(map: TiledMap, objectKey?: boolean): void;
        /**
         * 把一个动画对象绑定到当前GridSprite
         * @param    sprite 动画的显示对象
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
         * @param    layerData 地图数据中，layer数据的引用
         * @param    map 地图的引用
         */
        init(layerData: any, map: TiledMap): void;
        /**
         * 通过名字获取控制对象，如果找不到返回为null
         * @param    objName 所要获取对象的名字
         * @return
         */
        getObjectByName(objName: string): laya.map.GridSprite;
        /**
         * 得到指定格子的数据
         * @param    tileX 格子坐标X
         * @param    tileY 格子坐标Y
         * @return
         */
        getTileData(tileX: number, tileY: number): number;
        /**
         * 通过地图坐标得到屏幕坐标
         * @param    tileX 格子坐标X
         * @param    tileY 格子坐标Y
         * @param    screenPos 把计算好的屏幕坐标数据，放到此对象中
         */
        getScreenPositionByTilePos(tileX: number, tileY: number, screenPos?: laya.maths.Point): void;
        /**
         * 通过屏幕坐标来获取选中格子的数据
         * @param    screenX 屏幕坐标x
         * @param    screenY 屏幕坐标y
         * @return
         */
        getTileDataByScreenPos(screenX: number, screenY: number): number;
        /**
         * 通过屏幕坐标来获取选中格子的索引
         * @param    screenX 屏幕坐标x
         * @param    screenY 屏幕坐标y
         * @param    result 把计算好的格子坐标，放到此对象中
         * @return
         */
        getTilePositionByScreenPos(screenX: number, screenY: number, result?: laya.maths.Point): boolean;
        /**
         * 得到一个GridSprite
         * @param    gridX 当前Grid的X轴索引
         * @param    gridY 当前Grid的Y轴索引
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
         * @param    gridSprite 被指定显示的目标
         * @param    tileX 格子的X轴坐标
         * @param    tileY 格子的Y轴坐标
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
         * @param    aniName    当前动画显示对象的名字，名字唯一
         * @param    tileTextureSet 当前显示对象属于哪个动画（一个动画，可以绑定多个同类显示对象）
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
         * @param    mapName JSON文件名字
         * @param    viewRect 视口区域
         * @param    completeHandler 地图创建完成的回调函数
         * @param    viewRectPadding 视口扩充区域，把视口区域上、下、左、右扩充一下，防止视口移动时的穿帮
         * @param    gridSize grid大小
         */
        createMap(mapName: string, viewRect: laya.maths.Rectangle, completeHandler: laya.utils.Handler, viewRectPadding?: laya.maths.Rectangle, gridSize?: laya.maths.Point): void;
        /**
         * 得到一块指定的地图纹理
         * @param    index 纹理的索引值，默认从1开始
         * @return
         */
        getTexture(index: number): TileTexSet;
        /**
         * 通过纹理索引，生成一个可控制物件
         * @param    index 纹理的索引值，默认从1开始
         * @return
         */
        getSprite(index: number): laya.map.GridSprite;
        /**
         * 移动视口
         * @param    moveX 视口的坐标x
         * @param    moveY 视口的坐标y
         */
        moveViewPort(moveX: number, moveY: number): void;
        /**
         * 改变视口大小
         * @param    moveX    视口的坐标x
         * @param    moveY    视口的坐标y
         * @param    width    视口的宽
         * @param    height    视口的高
         */
        changeViewPort(moveX: number, moveY: number, width: number, height: number): void;
        /**
         * 得到对象层上的某一个物品
         * @param    layerName   层的名称
         * @param    objectName    所找物品的名称
         * @return
         */
        getLayerObject(layerName: string, objectName: string): laya.map.GridSprite;
        /**
         * 销毁地图
         */
        destory(): void;
        /**
         * 格子的宽度
         */
        TileWidth: number;
        /**
         * 格子的高度
         */
        TileHeight: number;
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
        MapWidth: number;
        /**
         * 地图竖向的格子数
         */
        MapHeight: number;
        /**
         * 视口x坐标
         */
        viewPortX: number;
        /**
         * 视口的y坐标
         */
        viewPortY: number;
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
        gridW: number;
        /**
         * 地图的坚向块数
         */
        gridH: number;
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
         * @param    index 要找的层索引
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
        /**当前动画每帧的时间间隔*/
        durationTimeArray: Array<any>;
        /**true表示当前纹理，是一组动画，false表示当前只有一个纹理*/
        animationKey: boolean;
        /**
         * 加入一个动画显示对象到此动画中
         * @param    aniName    //显示对象的名字
         * @param    sprite    //显示对象
         */
        addAniSprite(aniName: string, sprite: laya.map.TileAniSprite): void;
        /**
         * 移除不需要更新的SPRITE
         * @param    _name
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
    class Arith {
        static formatR(r: number): number;
        static isPOT(w: number, h: number): boolean;
        static setMatToArray(mat: Matrix, array: any): void;
    }
}
declare module laya.maths {
    /**
     * 计算贝塞尔曲线的工具类
     * ...
     * @author ww
     */
    class Bezier {
        static I: Bezier;
        controlPoints: Array<any>;
        /**
         * 计算二次贝塞尔点
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
         * 获取贝塞尔曲线上的点
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
     * 凸包算法
     * @author ww
     * @version 1.0
     *
     * @created  2015-9-22 下午4:16:41
     */
    class GrahamScan {
        static multiply(p1: Point, p2: Point, p0: Point): number;
        static dis(p1: Point, p2: Point): number;
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
     * 数据工具类
     */
    class MathUtil {
        static subtractVector3(l: Float32Array, r: Float32Array, o: Float32Array): void;
        static lerp(left: number, right: number, amount: number): number;
        static scaleVector3(f: Float32Array, b: number, e: Float32Array): void;
        static lerpVector3(l: Float32Array, r: Float32Array, t: number, o: Float32Array): void;
        static lerpVector4(l: Float32Array, r: Float32Array, t: number, o: Float32Array): void;
        static slerpQuaternionArray(a: Float32Array, Offset1: number, b: Float32Array, Offset2: number, t: number, out: Float32Array, Offset3: number): Float32Array;
        static getRotation(x0: number, y0: number, x1: number, y1: number): number;
        static SortBigFirst(a: number, b: number): number;
        static SortSmallFirst(a: number, b: number): number;
        static SortNumBigFirst(a: any, b: any): number;
        static SortNumSmallFirst(a: any, b: any): number;
        static SortByKey(key: string, bigFirst?: boolean, forceNum?: boolean): Function;
    }
}
declare module laya.maths {
    /**
     * 矩阵
     * @author yung
     */
    class Matrix {
        static EMPTY: Matrix;
        static TEMP: Matrix;
        static _cache: any;
        cos: number;
        sin: number;
        a: number;
        b: number;
        c: number;
        d: number;
        tx: number;
        ty: number;
        bTransform: boolean;
        inPool: boolean;
        constructor(a?: number, b?: number, c?: number, d?: number, tx?: number, ty?: number);
        identity(): Matrix;
        _checkTransform(): boolean;
        setTranslate(x: number, y: number): void;
        translate(x: number, y: number): Matrix;
        scale(x: number, y: number): void;
        rotate(angle: number): void;
        skew(x: number, y: number): Matrix;
        invertTransformPoint(out: Point): void;
        transformPoint(x: number, y: number, out: Point): void;
        transformPointArray(data: Array<any>, out: Array<any>): void;
        transformPointArrayScale(data: Array<any>, out: Array<any>): void;
        getScaleX(): number;
        getScaleY(): number;
        invert(): Matrix;
        setTo(a: number, b: number, c: number, d: number, tx: number, ty: number): Matrix;
        concat(mtx: Matrix): Matrix;
        static mul(m1: Matrix, m2: Matrix, out: Matrix): Matrix;
        static mulPre(m1: Matrix, ba: number, bb: number, bc: number, bd: number, btx: number, bty: number, out: Matrix): Matrix;
        static mulPos(m1: Matrix, aa: number, ab: number, ac: number, ad: number, atx: number, aty: number, out: Matrix): Matrix;
        static preMul(parent: Matrix, self: Matrix, out: Matrix): Matrix;
        static preMulXY(parent: Matrix, x: number, y: number, out: Matrix): Matrix;
        clone(): Matrix;
        copy(dec: Matrix): Matrix;
        toString(): string;
        destroy(): void;
        static create(): Matrix;
    }
}
declare module laya.maths {
    /**
     * Point类
     * @author yung
     */
    class Point {
        /**
         * 临时使用的公用对象
         */
        static TEMP: Point;
        static EMPTY: Point;
        x: number;
        y: number;
        constructor(x?: number, y?: number);
        setTo(x: number, y: number): Point;
    }
}
declare module laya.maths {
    /**
     * 矩形
     * @author yung
     */
    class Rectangle {
        /**全局空的矩形区域x=0,y=0,width=0,height=0*/
        static EMPTY: Rectangle;
        /**全局临时的矩形区域，此对象用于全局复用，以减少对象创建*/
        static TEMP: Rectangle;
        /**矩形左上角的 x 坐标。*/
        x: number;
        /**矩形左上角的 y 坐标。*/
        y: number;
        /**矩形的宽度。*/
        width: number;
        /**矩形的高度。*/
        height: number;
        constructor(x?: number, y?: number, width?: number, height?: number);
        /**x 和 width 属性的和。*/
        right: number;
        /**y 和 height 属性的和。*/
        bottom: number;
        /**
         * 将 Rectangle 的成员设置为指定值
         * @param    x    矩形左上角的 x 坐标。
         * @param    y    矩形左上角的 y 坐标。
         * @param    width    矩形的宽度。
         * @param    height    矩形的高。
         * @return    返回矩形对象本身
         */
        setTo(x: number, y: number, width: number, height: number): Rectangle;
        /**
         * 复制 source 对象的值到此矩形对象中。
         * @param    sourceRect    源 Rectangle 对象
         * @return    返回对象本身
         */
        copyFrom(source: Rectangle): Rectangle;
        /**
         * 确定此矩形对象是否包含指定的点。
         * @param    x    点的 x 坐标（水平位置）。
         * @param    y    点的 y 坐标（垂直位置）。
         * @return    如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
         */
        contains(x: number, y: number): boolean;
        /**
         * 确定在 rect 参数中指定的对象是否与此 Rectangle 对象相交。
         * @param    rect 要与此 Rectangle 对象比较的 Rectangle 对象
         * @return    如果相交，则返回 true 值，否则返回 false
         */
        intersects(rect: Rectangle): boolean;
        /**
         * 获取和某个矩形区域相交的区域
         * @param    rect 比较的矩形区域
         * @param    out    输出的矩形区域，尽量用此对象复用对象，减少对象创建消耗
         * @return    返回相交的矩形区域
         */
        intersection(rect: Rectangle, out?: Rectangle): Rectangle;
        /**
         * 通过填充两个矩形之间的水平和垂直空间，将这两个矩形组合在一起以创建一个新的 Rectangle 对象
         * @param    目标矩形对象
         * @param    out    输出的矩形区域，尽量用此对象复用对象，减少对象创建消耗
         * @return    充当两个矩形的联合的新 Rectangle 对象
         */
        union(source: Rectangle, out?: Rectangle): Rectangle;
        /**
         * 返回一个新的 Rectangle 对象，其 x、y、width 和 height 属性的值与原始 Rectangle 对象的对应值相同。
         * @param    out    输出的矩形区域，尽量用此对象复用对象，减少对象创建消耗
         * @return    新的 Rectangle 对象，其 x、y、width 和 height 属性的值与原始 Rectangle 对象的对应值相同。
         */
        clone(out?: Rectangle): Rectangle;
        /**
         * 生成并返回一个字符串，该字符串列出 Rectangle 对象的水平位置和垂直位置以及高度和宽度。
         */
        toString(): string;
        /**
         * 确定在 rect 参数中指定的对象是否等于此 Rectangle 对象。
         * @param    rect 要与此 Rectangle 对象进行比较的矩形
         * @return    如果对象具有与此 Rectangle 对象完全相同的 x、y、width 和 height 属性值，则返回 true 值，否则返回 false
         */
        equal(rect: Rectangle): boolean;
        /**
         * 在矩形区域中加一个点
         * @param x    x坐标
         * @param y    y坐标
         * @return 返回此对象
         */
        addPoint(x: number, y: number): Rectangle;
        /**
         * 返回代表当前矩形的顶点数据
         * @return 顶点数据
         * @private
         */
        _getBoundPoints(): Array<any>;
        /**
         * 返回矩形的顶点数据
         * @private
         */
        static _getBoundPointS(x: number, y: number, width: number, height: number): Array<any>;
        /**
         * 返回包括所有点的最小矩形
         * @param pointList 点列表
         * @return 最小矩形
         * @private
         */
        static _getWrapRec(pointList: Array<any>, rst?: Rectangle): Rectangle;
    }
}
declare module laya.media.h5audio {
    /**
     * 使用Audio标签播放声音
     * @author ww
     */
    class AudioSound extends laya.events.EventDispatcher {
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
    }
}
declare module laya.media.h5audio {
    /**
     * audio标签播放声音的音轨控制
     * @author ww
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
     * 声音类
     * @author ww
     */
    class Sound extends laya.events.EventDispatcher {
        /**
         * 加载声音
         * @param url
         *
         */
        load(url: string): void;
        /**
         * 播放声音
         * @param startTime 开始时间,单位秒
         * @param loops 循环次数,0表示一直循环
         * @return
         *
         */
        play(startTime?: number, loops?: number): SoundChannel;
        /**
         * 释放声音资源
         *
         */
        dispose(): void;
    }
}
declare module laya.media {
    /**
     * 声音播放控制
     * @author ww
     */
    class SoundChannel extends laya.events.EventDispatcher {
        /**
         * 声音url
         */
        url: string;
        /**
         * 循环次数
         */
        loops: number;
        /**
         * 开始时间
         */
        startTime: number;
        /**
         * 是否已暂停
         */
        isStopped: boolean;
        completeHandler: laya.utils.Handler;
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
        /**
         * 获取当前播放时间
         * @return
         *
         */
        position: number;
        /**
         * 播放
         *
         */
        play(): void;
        /**
         * 停止
         *
         */
        stop(): void;
    }
}
declare module laya.media {
    /**
     * 声音管理类
     * @author ww
     * @version 1.0
     * @created  2015-9-10 下午2:35:21
     */
    class SoundManager {
        /**背景音乐音量*/
        static musicVolume: number;
        /**音效音量*/
        static soundVolume: number;
        /**
         * 添加播放的声音实例
         * @param channel
         *
         */
        static addChannel(channel: SoundChannel): void;
        /**
         * 移除播放的声音实例
         * @param channel
         *
         */
        static removeChannel(channel: SoundChannel): void;
        /**
         * 是否失去焦点后自动停止背景音乐
         * @return
         *
         */
        /**
         * 是否失去焦点后自动停止背景音乐
         * @param v
         *
         */
        static autoStopMusic: boolean;
        /**是否静音*/
        static muted: boolean;
        /**是否音效静音*/
        static soundMuted: boolean;
        /**是否背景音乐静音*/
        static musicMuted: boolean;
        /**
         * 播放音效
         * @param url 声音文件url
         * @param loops 循环次数,0表示无限循环
         * @param complete 声音播放完成回调  Handler对象
         * @return SoundChannel对象
         */
        static playSound(url: string, loops?: number, complete?: laya.utils.Handler): SoundChannel;
        /**
         * 释放声音资源
         * @param url 声音文件url
         */
        static destroySound(url: string): void;
        /**
         * 播放背景音乐
         * @param url 声音文件url
         * @param loops 循环次数,0表示无限循环
         * @param complete  声音播放完成回调
         * @return audio对象
         */
        static playMusic(url: string, loops?: number, complete?: laya.utils.Handler): SoundChannel;
        /**
         * 停止声音播放
         * @param url  声音文件url
         */
        static stopSound(url: string): void;
        /**
         * 停止背景音乐播放
         * @param url  声音文件url
         */
        static stopMusic(): void;
        /**
         * 设置声音音量
         * @param volume 音量 标准值为1
         * @param url  声音文件url，为null(默认值)时对所有音效起作用，不为空时仅对对于声音生效
         */
        static setSoundVolume(volume: number, url?: string): void;
        /**
         * 设置背景音乐音量
         * @param volume 音量  标准值为1
         */
        static setMusicVolume(volume: number): void;
    }
}
declare module laya.media.webaudio {
    /**
     * web audio api方式播放声音
     * @author ww
     */
    class WebAudioSound extends laya.events.EventDispatcher {
        static window: any;
        /**
         * 是否支持web audio api
         */
        static webAudioOK: boolean;
        /**
         * 播放设备
         */
        static ctx: any;
        /**
         * 当前要解码的声音文件列表
         */
        static buffs: Array<any>;
        /**
         * 解码声音文件
         *
         */
        static decode(): void;
        constructor();
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
        dispose(): void;
    }
}
declare module laya.media.webaudio {
    /**
     * web audio api方式播放声音的音轨控制
     * @author ww
     */
    class WebAudioSoundChannel extends laya.media.SoundChannel {
        /**
         * 声音原始文件数据
         */
        audioBuffer: any;
        constructor();
        /**
         * 播放声音
         *
         */
        play(): void;
        /**
         * 获取当前播放位置
         * @return
         *
         */
        position: number;
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
declare module laya.net {
    /**
     * HTTP请求
     * @author yung
     */
    class HttpRequest extends laya.events.EventDispatcher {
        /**
         * 发送请求
         * @param    url 请求的地址
         * @param    data 发送的数据，可选
         * @param    method 发送数据方式，值为"get"或"post"，默认为get方式
         * @param    responseType 返回消息类型，可设置为"text"，"json"，"xml","arraybuffer"
         * @param    headers 头信息，key value数组，比如["Content-Type", "application/json"]
         */
        send(url: string, data?: any, method?: string, responseType?: string, headers?: Array<any>): void;
        protected onProgress(e: any): void;
        protected onAbort(e: any): void;
        protected onError(e: any): void;
        protected onLoad(e: any): void;
        protected error(message: string): void;
        protected complete(): void;
        protected clear(): void;
        /**请求的地址*/
        url: string;
        /**返回的数据*/
        data: any;
    }
}
declare module laya.net {
    /**
     * 加载器，实现了文本，JSON，XML,二进制,图像的加载及管理
     * @author yung
     */
    class Loader extends laya.events.EventDispatcher {
        /**根路径，完整路径由basePath+url组成*/
        static basePath: string;
        static TEXT: string;
        static JSOn: string;
        static XML: string;
        static BUFFER: string;
        static IMAGE: string;
        static SOUND: string;
        static TEXTURE: string;
        static ATLAS: string;
        /**文件后缀和类型对应表*/
        static typeMap: any;
        /**每帧回调最大超时时间*/
        static maxTimeOut: number;
        /**
         * 加载资源
         * @param    url 地址
         * @param    type 类型，如果为null，则根据文件后缀，自动分析类型
         * @param    cache 是否缓存数据
         */
        load(url: string, type?: string, cache?: boolean): void;
        protected getTypeFromUrl(url: string): string;
        protected _loadImage(url: string): void;
        protected _loadSound(url: string): void;
        protected onLoaded(data: any): void;
        protected complete(data: any): void;
        _endLoad(): void;
        /**加载地址，只读*/
        url: string;
        /**加载类型，只读*/
        type: string;
        /**是否缓存，只读*/
        cache: boolean;
        /**返回的数据*/
        data: any;
        /**
         * 清理缓存
         * @param    url 地址
         */
        static clearRes(url: string): void;
        /**
         * 获取已加载资源(如有缓存)
         * @param    url 地址
         * @return    返回资源
         */
        static getRes(url: string): any;
        /**
         * 缓存资源
         * @param    url 地址
         * @param    data 要缓存的内容
         */
        static cacheRes(url: string, data: any): void;
    }
}
declare module laya.net {
    /**
     * <p> <code>LoaderManager</code> 类用于用于批量加载资源、数据。</p>
     * <p>批量加载器，单例，可以通过Laya.loader访问。</p>
     * 多线程(默认5个线程)，5个优先级(0最快，4最慢,默认为1)
     * 某个资源加载失败后，会按照最低优先级重试加载(属性retryNum决定重试几次)，如果重试后失败，则调用complete函数，并返回null
     * @author yung
     */
    class LoaderManager extends laya.events.EventDispatcher {
        /**加载出错后的重试次数，默认重试一次*/
        retryNum: number;
        /**最大下载线程，默认为5个*/
        maxLoader: number;
        /**
         * 创建一个新的 <code>LoaderManager</code> 实例。
         */
        constructor();
        /**
         * 加载资源
         * @param    url 地址，或者数组
         * @param    type 类型
         * @param    complete 结束回调，如果加载失败，则返回null
         * @param    progress 进度回调，回调参数为当前文件加载的进度信息(0-1)
         * @param    priority 优先级，0-4，五个优先级，0优先级最高，默认为1
         * @param    cache 是否缓存加载结果
         */
        load(url: any, complete?: laya.utils.Handler, progress?: laya.utils.Handler, type?: string, priority?: number, cache?: boolean): LoaderManager;
        /**
         * 清理缓存
         * @param    url 地址
         */
        clearRes(url: string): void;
        /**
         * 获取已加载资源(如有缓存)
         * @param    url 地址
         * @return    返回资源
         */
        getRes(url: string): any;
        /**
         * 缓存资源
         * @param    url 地址
         * @param    data 要缓存的内容
         */
        static cacheRes(url: string, data: any): void;
        /**清理当前未完成的加载*/
        clearUnLoaded(): void;
    }
    class ResInfo extends laya.events.EventDispatcher {
        url: string;
        type: string;
        cache: boolean;
    }
}
declare module laya.net {
    /**
     *
     * <p> <code>LocalStorage</code> 类用于没有时间限制的数据存储。</p>
     * @author yung
     */
    class LocalStorage {
        /**
         *  数据列表。
         */
        static items: any;
        /**
         * 表示是否支持  <code>LocalStorage</code>。
         */
        static support: boolean;
        /**
         * 以“key”为名称存储一个值“value”。
         * @param key
         * @param value
         */
        static setItem(key: string, value: string): void;
        /**
         * 获取以“key”为名称存储的值。
         * @param key
         * @return
         */
        static getItem(key: string): string;
        /**
         * 以“key”为名称存储的JSON格式的值。
         * @param key
         * @param value
         *
         */
        static setJSON(key: string, value: any): void;
        /**
         * 获取以“key”为名称存储的JSON格式的值。
         * @param key
         * @return
         *
         */
        static getJSON(key: string): any;
        /**
         * 删除名称为“key”的信息。
         * @param key
         *
         */
        static removeItem(key: string): void;
        /**
         * 清除本地存贮信息。
         */
        static clear(): void;
    }
}
declare module laya.net {
    /**
     *
     * @author laiyuanyuan
     *
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
        /**
         * 表示建立连接时需等待的毫秒数。
         */
        timeout: number;
        /**
         * 在写入或读取对象时，控制所使用的 AMF 的版本。
         */
        objectEncoding: number;
        /**
         * 表示服务端发来的数据。
         * @return
         *
         */
        input: laya.utils.Byte;
        /**
         * 表示需要发送至服务端的缓冲区中的数据。
         * @return
         *
         */
        output: laya.utils.Byte;
        /**
         * 表示此 Socket 对象目前是否已连接。
         * @return
         *
         */
        connected: boolean;
        /**
         * 表示数据的字节顺序。
         * @return
         *
         */
        endian: string;
        /**
         * <p>创建一个新的 <code>Socket</code> 实例。</p>
         * 创建 websocket ,如果host port有效直接连接。         *
         * @param host 服务器地址。
         * @param port 服务器端口。
         * @param byteClass 用来接收和发送数据的Byte类，默认使用Byte类，也可传入Byte类的子类。
         *
         */
        constructor(host?: string, port?: number, byteClass?: any);
        /**
         * 连接到指定的主机和端口。
         * @param host
         * @param port
         *
         */
        connect(host: string, port: number): void;
        /**
         * 关闭连接。
         */
        close(): void;
        protected onOpenHandler(...args: any[]): void;
        protected onMessageHandler(msg: any): void;
        protected onCloseHandler(...args: any[]): void;
        protected onErrorHandler(...args: any[]): void;
        /**
         * 发送字符串数据到服务器，测试用函数。
         * @param    _str
         */
        sendString(_str: string): void;
        /**
         * 发送缓冲区中的数据到服务器。
         */
        flush(): void;
    }
}
declare module laya.net {
    /**
     * <p> <code>URL</code> 类用于定义地址信息。</p>
     * @author laya
     */
    class URL {
        /**
         * 版本号。
         */
        static version: any;
        /**
         * 创建一个新的 <code>URL</code> 实例。
         */
        constructor(url: string);
        url: string;
        path: string;
        static basePath: string;
        static rootPath: string;
    }
}
declare module laya.particle.emitter {
    /**
     *
     * @author ww
     * @version 1.0
     *
     * @created  2015-12-21 下午4:37:29
     */
    class Emitter2D extends EmitterBase {
        settiong: laya.particle.ParticleSettings;
        constructor(_template: laya.particle.ParticleTemplateBase);
        emit(): void;
        getRandom(value: number): number;
        webGLEmit(): void;
        canvasEmit(): void;
    }
}
declare module laya.particle.emitter {
    /**
     * ...
     * @author ww
     */
    class EmitterBase {
        constructor();
        /**
         * 发射粒子最小时间间隔
         */
        minEmissionTime: number;
        _particleTemplate: laya.particle.ParticleTemplateBase;
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
        emit(): void;
        advanceTime(passedTime?: number): void;
    }
}
declare module laya.particle {
    class Particle2D extends laya.display.Sprite {
        constructor(setting: ParticleSettings);
        emitter: laya.particle.emitter.EmitterBase;
        play(): void;
        stop(): void;
        advanceTime(passedTime?: number): void;
        customRender(context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.particle {
    /**
     * ...
     * @author
     */
    class ParticleData {
        position: Float32Array;
        velocity: Float32Array;
        color: Float32Array;
        sizeRotation: Float32Array;
        radiusRadian: Float32Array;
        durationAddScale: number;
        time: number;
        constructor();
        static Create(settings: ParticleSettings, position: Float32Array, velocity: Float32Array, time: number): ParticleData;
    }
}
declare module laya.particle {
    /**
     * ...
     * @author laya
     */
    class ParticleEmitter {
        constructor(templet: ParticleTemplateBase, particlesPerSecond: number, initialPosition: Float32Array);
        update(elapsedTime: number, newPosition: Float32Array): void;
    }
}
declare module laya.particle {
    class ParticleINITGL {
        constructor();
    }
}
declare module laya.particle {
    /**
     * ...
     * @author ww
     */
    class ParticlePlayer extends laya.display.Sprite {
        constructor();
        file: string;
        loadParticleFile(fileName: string): void;
        setParticleSetting(settings: ParticleSettings): void;
    }
}
declare module laya.particle {
    /**
     * ...
     * @author ...
     */
    class ParticleSettings {
        /**贴图*/
        textureName: string;
        /**贴图个数*/
        textureCount: number;
        /**由于循环队列判断算法，最大饱和粒子数为maxPartices-1*/
        maxPartices: number;
        /**粒子持续时间(单位:秒）*/
        duration: number;
        /**如果大于0，某些粒子的持续时间会小于其他粒子,并具有随机性(单位:无）*/
        ageAddScale: number;
        /**最小水平速度（单位：2D像素、3D坐标）*/
        minHorizontalVelocity: number;
        /**最大水平速度（单位：2D像素、3D坐标）*/
        maxHorizontalVelocity: number;
        /**最小垂直速度（单位：2D像素、3D坐标）*/
        minVerticalVelocity: number;
        /**最大垂直速度（单位：2D像素、3D坐标）*/
        maxVerticalVelocity: number;
        /**（单位：2D像素、3D坐标）*/
        gravity: Float32Array;
        /**等于1时粒子从出生到消亡保持一致的速度，等于0时粒子消亡时速度为0，大于1时粒子会保持加速（单位：无）*/
        endVelocity: number;
        /**false代表RGBA整体插值，true代表RGBA逐分量插值*/
        colorComponentInter: boolean;
        /**最小颜色*/
        minColor: Float32Array;
        /**最大颜色*/
        maxColor: Float32Array;
        /**最小旋转速度（单位：2D弧度/秒、3D弧度/秒）*/
        minRotateSpeed: number;
        /**最大旋转速度（单位：2D弧度/秒、3D弧度/秒）*/
        maxRotateSpeed: number;
        /**最小开始尺寸（单位：2D像素、3D坐标）*/
        minStartSize: number;
        /**最大开始尺寸（单位：2D像素、3D坐标）*/
        maxStartSize: number;
        /**最小结束尺寸（单位：2D像素、3D坐标）*/
        minEndSize: number;
        /**最大结束尺寸（单位：2D像素、3D坐标）*/
        maxEndSize: number;
        /**粒子受发射器速度的敏感度（需在自定义发射器中编码设置）*/
        emitterVelocitySensitivity: number;
        /**最小开始半径（单位：2D像素、3D坐标）*/
        minStartRadius: number;
        /**最大开始半径（单位：2D像素、3D坐标）*/
        maxStartRadius: number;
        /**最小结束半径（单位：2D像素、3D坐标）*/
        minEndRadius: number;
        /**最大结束半径（单位：2D像素、3D坐标）*/
        maxEndRadius: number;
        /**最小水平结束弧度（单位：2D弧度、3D弧度）*/
        minHorizontalEndRadian: number;
        /**最大水平结束弧度（单位：2D弧度、3D弧度）*/
        maxHorizontalEndRadian: number;
        /**最小垂直结束弧度（单位：2D弧度、3D弧度）*/
        minVerticalEndRadian: number;
        /**最大垂直结束弧度（单位：2D弧度、3D弧度）*/
        maxVerticalEndRadian: number;
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
        constructor();
        static fromFile(particleSettingFile: string): void;
    }
}
declare module laya.particle {
    class ParticleTemplate2D extends ParticleTemplateWebGL implements laya.webgl.submit.ISubmit {
        static activeBlendType: number;
        x: number;
        y: number;
        blendType: number;
        sv: laya.particle.shader.value.ParticleShaderValue;
        getRenderType(): number;
        releaseRender(): void;
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
        renderSubmit(): number;
        blend(): void;
    }
}
declare module laya.particle {
    /**
     * ...
     * @author
     */
    class ParticleTemplateBase {
        settings: ParticleSettings;
        constructor();
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
    }
}
declare module laya.particle {
    /**
     * ...
     * @author ww
     */
    class ParticleTemplateCanvas extends ParticleTemplateBase {
        constructor(parSetting: ParticleSettings);
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
        clear(clearTexture?: boolean): void;
        /**
         * 设置纹理
         * @param texture
         *
         */
        setTexture(texture: any): void;
        static changeTexture(texture: any, rst: Array<any>): Array<any>;
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
        advanceTime(passedTime?: number): void;
        render(context: laya.renders.RenderContext, x: number, y: number): void;
        noColorRender(context: laya.renders.RenderContext, x: number, y: number): void;
        canvasRender(context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.particle {
    /**
     * ...
     * @author laya
     */
    class ParticleTemplateWebGL extends ParticleTemplateBase {
        constructor(parSetting: ParticleSettings);
        protected initialize(): void;
        protected loadContent(): void;
        update(elapsedTime: number): void;
        addNewParticlesToVertexBuffer(): void;
        addParticleArray(position: Float32Array, velocity: Float32Array): void;
    }
}
declare module laya.particle.particleUtils {
    /**
     * ...
     * @author ww
     */
    class CanvasShader {
        constructor();
        getLen(position: Float32Array): number;
        u_EndVelocity: number;
        u_Gravity: Float32Array;
        u_Duration: number;
        a_RadiusRadian: Float32Array;
        a_Position: Float32Array;
        a_SizeRotation: Float32Array;
        a_Color: Float32Array;
        a_Velocity: Float32Array;
        _position: Float32Array;
        ComputeParticlePosition(position: Float32Array, velocity: Float32Array, age: number, normalizedAge: number): Float32Array;
        ComputeParticleSize(startSize: number, endSize: number, normalizedAge: number): number;
        ComputeParticleRotation(rot: number, age: number): number;
        _color: Float32Array;
        ComputeParticleColor(projectedPosition: Float32Array, color: Float32Array, normalizedAge: number): Float32Array;
        clamp(value: number, min: number, max: number): number;
        gl_Position: Float32Array;
        v_Color: Float32Array;
        a_AgeAddScale: number;
        oSize: number;
        getData(age: number): Array<any>;
    }
}
declare module laya.particle.particleUtils {
    /**
     *
     * @author ww
     * @version 1.0
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
    /**
     *
     * @author ww
     * @version 1.0
     *
     * @created  2015-8-26 下午7:22:26
     */
    class PicTool {
        constructor();
        static getCanvasPic(img: any, color: number): any;
        static getRGBPic(img: any): Array<any>;
    }
}
declare module laya.particle.shader {
    class ParticleShader extends laya.webgl.shader.Shader {
        static vs: string;
        static ps: string;
        constructor();
    }
}
declare module laya.particle.shader.value {
    class ParticleShaderValue extends laya.webgl.shader.d2.value.Value2D {
        a_CornerTextureCoordinate: Array<any>;
        a_Position: Array<any>;
        a_Velocity: Array<any>;
        a_Color: Array<any>;
        a_SizeRotation: Array<any>;
        a_RadiusRadian: Array<any>;
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
     * ...
     * @author laya
     */
    interface ISubmit {
    }
}
declare module laya.renders {
    /**
     * Render管理类，单例，可以通过Laya.render访问
     * @author yung
     */
    class Render {
        static _context: RenderContext;
        static _mainCanvas: laya.resource.HTMLCanvas;
        static WebGL: any;
        static clear: Function;
        static clearAtlas: Function;
        static finish: Function;
        /**
         * 初始化引擎
         * @param    width 游戏窗口宽度
         * @param    height    游戏窗口高度
         * @param    renderType    渲染类型(auto,canvas,webgl) 默认为auto，优先用webgl渲染，如果webgl不可用，则用canvas渲染
         */
        constructor(width: number, height: number);
        /**目前使用的渲染器*/
        static context: RenderContext;
        /**是否是WebGl模式*/
        static isWebGl: boolean;
        /**渲染使用的画布*/
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
        _drawTexture(x: number, y: number, args: Array<any>): void;
        drawTextureWithTransform(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, m: laya.maths.Matrix): void;
        _drawTextureWithTransform(x: number, y: number, args: Array<any>): void;
        fillQuadrangle(tex: any, x: number, y: number, point4: Array<any>, m: laya.maths.Matrix): void;
        _fillQuadrangle(x: number, y: number, args: Array<any>): void;
        drawCanvas(canvas: laya.resource.HTMLCanvas, x: number, y: number, width: number, height: number): void;
        drawRect(x: number, y: number, width: number, height: number, color: string, lineWidth?: number): void;
        _drawRect(x: number, y: number, args: Array<any>): void;
        _drawPoly(x: number, y: number, args: Array<any>): void;
        _drawPath(x: number, y: number, args: Array<any>): void;
        _drawPie(x: number, y: number, args: Array<any>): void;
        _drawPieWebGL(x: number, y: number, args: Array<any>): void;
        clipRect(x: number, y: number, width: number, height: number): void;
        _clipRect(x: number, y: number, args: Array<any>): void;
        fillRect(x: number, y: number, width: number, height: number, fillStyle: any): void;
        _fillRect(x: number, y: number, args: Array<any>): void;
        drawCircle(x: number, y: number, radius: number, color: string, lineWidth?: number): void;
        _drawCircle(x: number, y: number, args: Array<any>): void;
        _drawCircleWebGL(x: number, y: number, args: Array<any>): void;
        fillCircle(x: number, y: number, radius: number, color: string): void;
        _fillCircle(x: number, y: number, args: Array<any>): void;
        setShader(shader: any): void;
        _setShader(x: number, y: number, args: Array<any>): void;
        drawLine(fromX: number, fromY: number, toX: number, toY: number, color: string, lineWidth?: number): void;
        drawLinesWebGL(x: number, y: number, args: Array<any>): void;
        _drawLine(x: number, y: number, args: Array<any>): void;
        drawLines(x: number, y: number, args: Array<any>): void;
        drawCurves(x: number, y: number, args: Array<any>): void;
        draw(x: number, y: number, args: Array<any>): void;
        clear(): void;
        transform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        transformByMatrix(value: laya.maths.Matrix): void;
        _transformByMatrix(x: number, y: number, args: Array<any>): void;
        setTransform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        _setTransform(x: number, y: number, args: Array<any>): void;
        setTransformByMatrix(value: laya.maths.Matrix): void;
        _setTransformByMatrix(x: number, y: number, args: Array<any>): void;
        save(): void;
        restore(): void;
        enableMerge: boolean;
        translate(x: number, y: number): void;
        _translate(x: number, y: number, args: Array<any>): void;
        rotate(angle: number): void;
        _transform(x: number, y: number, args: Array<any>): void;
        _rotate(x: number, y: number, args: Array<any>): void;
        _scale(x: number, y: number, args: Array<any>): void;
        scale(scaleX: number, scaleY: number): void;
        alpha(value: number): void;
        _alpha(x: number, y: number, args: Array<any>): void;
        setAlpha(value: number): void;
        _setAlpha(x: number, y: number, args: Array<any>): void;
        fillWords(words: Array<any>, x: number, y: number, font: string, color: string): void;
        fillText(text: string, x: number, y: number, font: string, color: string, textAlign: string): void;
        _fillText(x: number, y: number, args: Array<any>): void;
        strokeText(text: string, x: number, y: number, font: string, color: string, lineWidth: number, textAlign: string): void;
        _strokeText(x: number, y: number, args: Array<any>): void;
        _fillBorderText(x: number, y: number, args: Array<any>): void;
        blendMode(type: string): void;
        _blendMode(x: number, y: number, args: Array<any>): void;
        flush(): void;
        addRenderObject(o: any): void;
        beginClip(x: number, y: number, w: number, h: number): void;
        _beginClip(x: number, y: number, args: Array<any>): void;
        endClip(): void;
        _setIBVB(x: number, y: number, args: Array<any>): void;
        fillTrangles(x: number, y: number, args: Array<any>): void;
        _fillTrangles(x: number, y: number, args: Array<any>): void;
        drawPath(x: number, y: number, args: Array<any>): void;
        drawPoly(x: number, y: number, args: Array<any>): void;
        drawParticle(x: number, y: number, args: Array<any>): void;
    }
}
declare module laya.renders {
    /**
     * ...
     * @author laya
     */
    class RenderSprite {
        static IMAGE: number;
        static FILTERS: number;
        static ALPHA: number;
        static TRANSFORM: number;
        static CANVAS: number;
        static BLEND: number;
        static CLIP: number;
        static STYLE: number;
        static GRAPHICS: number;
        static CUSTOM: number;
        static ENABLERENDERMERGE: number;
        static CHILDS: number;
        static INIT: number;
        static renders: Array<any>;
        static __init__(): void;
        _next: RenderSprite;
        _fun: Function;
        constructor(type: number, next: RenderSprite);
        protected onCreate(type: number): void;
        _style(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _no(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _custom(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _clip(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _enableRenderMerge(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
        _blend(sprite: laya.display.Sprite, context: RenderContext, x: number, y: number): void;
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
     * ...
     * @author laya
     */
    class Bitmap extends Resource {
        _id: number;
        /***
         * 获取图片宽度
         * @return 图片宽度
         */
        width: number;
        /***
         * 获取图片高度
         * @return 图片高度
         */
        height: number;
        /***
         * 获取HTML Image或HTML Canvas或WebGL Texture
         * @return HTML Image或HTML Canvas或WebGL Texture
         */
        source: any;
        constructor();
        /***复制资源,此方法为浅复制*/
        copyTo(dec: Bitmap): void;
        /**彻底清理资源*/
        dispose(): void;
    }
}
declare module laya.resource {
    /**
     * @private
     * Context扩展类
     */
    class Context {
        _canvas: HTMLCanvas;
        static _init(canvas: HTMLCanvas, ctx: any): void;
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
        drawCanvas(canvas: HTMLCanvas, x: number, y: number, width: number, height: number): void;
        fillRect(x: number, y: number, width: number, height: number, style: any): void;
        fillText(text: string, x: number, y: number, font: string, color: string, textAlign: string): void;
        fillBorderText(text: string, x: number, y: number, font: string, fillColor: string, borderColor: string, lineWidth: number, textAlign: string): void;
        strokeText(text: string, x: number, y: number, font: string, color: string, lineWidth: number, textAlign: string): void;
        transformByMatrix(value: laya.maths.Matrix): void;
        setTransformByMatrix(value: laya.maths.Matrix): void;
        clipRect(x: number, y: number, width: number, height: number): void;
        drawTexture(tex: Texture, x: number, y: number, width: number, height: number, tx: number, ty: number): void;
        drawTextureWithTransform(tex: Texture, x: number, y: number, width: number, height: number, m: laya.maths.Matrix, tx: number, ty: number): void;
        drawTexture2(x: number, y: number, pivotX: number, pivotY: number, m: laya.maths.Matrix, alpha: number, blendMode: string, args2: Array<any>): void;
        flush(): number;
        fillWords(words: Array<any>, x: number, y: number, font: string, color: string): void;
        destroy(): void;
        clear(): void;
        enableMerge: boolean;
    }
}
declare module laya.resource {
    /**
     * ...
     * @author
     */
    class FileBitmap extends Bitmap {
        /**
         * 获取文件路径全名
         * @return 文件路径全名
         */
        /**
         * 设置文件路径全名
         * @param 文件路径全名
         */
        src: string;
        /***
         * 设置onload函数,override it!
         * @param value onload函数
         */
        onload: Function;
        /***
         * 设置onerror函数,override it!
         * @param value onerror函数
         */
        onerror: Function;
    }
}
declare module laya.resource {
    /**
     * ...
     * @author laya
     */
    class HTMLCanvas extends Bitmap {
        static TYPE2D: string;
        static TYPE3D: string;
        static TYPEAUTO: string;
        static _createContext: Function;
        constructor(type: string);
        clear(): void;
        destroy(): void;
        release(): void;
        context: Context;
        _setContext(context: Context): void;
        getContext(contextID: string, other?: any): Context;
        copyTo(dec: Bitmap): void;
        getMemSize(): number;
    }
}
declare module laya.resource {
    /**
     * ...
     * @author laya
     */
    class HTMLImage extends FileBitmap {
        /***
         * 获取HTML Image
         * @return HTML Image
         */
        source: any;
        /**
         * 设置文件路径全名
         * @param 文件路径全名
         */
        src: string;
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
        constructor(im?: any);
        protected recreateResource(): void;
        protected detoryResource(): void;
    }
}
declare module laya.resource {
    /**
     * ...
     * @author ...
     */
    class HTMLSubImage extends Bitmap {
        constructor(canvas: any, offsetX: number, offsetY: number, width: number, height: number, atlasImage: any, src: string, createOwnSource?: boolean);
    }
}
declare module laya.resource {
    /**
     * ...
     * @author
     */
    interface IDispose {
    }
}
declare module laya.resource {
    /**
     * ...
     * @author
     */
    class Resource extends laya.events.EventDispatcher implements IDispose {
        static animationCache: any;
        static meshCache: any;
        /**
         * 通过索引返回本类型已载入资源
         * @param index 索引
         * @return 资源
         */
        static getLoadedResourceByIndex(index: number): Resource;
        /**
         * 返回本类型已载入资源个数
         *  @return  本类型已载入资源个数
         */
        static getLoadedResourcesCount(): number;
        /**
         * 返回本类型排序后的已载入资源
         *  @return  本类型排序后的已载入资源
         */
        static sortedLoadedResourcesByName: Array<any>;
        /**所属资源管理器,通常禁止修改,如果为null则不受资源管理器，可能受大图合集资源管理*/
        _resourceManager: ResourceManager;
        /**是否加锁，true为不能使用自动释放机制*/
        lock: boolean;
        /**
         * 获取唯一标识ID
         * @return 编号
         */
        id: number;
        /**
         * 获取名字
         *   @return 名字
         */
        /**
         * 设置名字
         * @param    value 名字
         */
        name: string;
        /**
         * 获取资源管理员
         * @return 资源管理员
         */
        resourceManager: ResourceManager;
        /**
         * 获取距离上次使用帧率
         * @return 距离上次使用帧率
         */
        lastUseFrameCount: number;
        /**
         * 获取占用内存尺寸
         * @return 占用内存尺寸
         */
        /**
         * 设置内存尺寸(as3中属性不能使用protected，开发者避免修改，或待优化)
         * @param value 尺寸
         */
        memorySize: number;
        /**
         * 获取是否已释放
         * @return 是否已释放
         */
        released: boolean;
        constructor();
        protected recreateResource(): void;
        protected detoryResource(): void;
        /**
         * 激活资源，使用资源前应先调用此函数激活
         * @param forceCreate 是否强制创建
         */
        activeResource(forceCreate?: boolean): void;
        /**
         * 释放资源
         * @return 是否成功释放
         */
        releaseResource(): boolean;
        /**
         * 设置唯一名字,如果名字重复则自动加上“-copy”
         * @param newName 名字
         */
        setUniqueName(newName: string): void;
        /**彻底清理资源,注意会强制解锁清理*/
        dispose(): void;
        protected compoleteCreate(): void;
    }
}
declare module laya.resource {
    /**
     * ...
     * @author
     */
    class ResourceManager implements IDispose {
        /**当前资源管理器*/
        static currentResourceManager: ResourceManager;
        /**资源加载根目录*/
        static resourcesDirectory: string;
        /**
         * 返回本类型排序后的已载入资源
         *  @return  本类型排序后的已载入资源
         */
        static systemResourceManager: ResourceManager;
        static __init__(): void;
        /**
         * 通过索引返回资源管理器
         * @param index 索引
         * @return 资源管理器
         */
        static getLoadedResourceManagerByIndex(index: number): ResourceManager;
        /**
         * 返回资源管理器个数
         *  @return  资源管理器个数
         */
        static getLoadedResourceManagersCount(): number;
        /**
         * 获取排序后资源管理器列表
         *   @return 排序后资源管理器列表
         */
        static sortedResourceManagersByName: Array<any>;
        /**重新强制创建资源管理员以及所拥有资源（显卡丢失时处理）*/
        static recreateContentManagers(): void;
        /**是否启用自动释放机制*/
        autoRelease: boolean;
        /**自动释放机制的内存触发上限,以字节为单位*/
        autoReleaseMaxSize: number;
        /**资源载入器*/
        /**
         * 获取唯一标识ID
         * @return 编号
         */
        id: number;
        /**
         * 获取名字
         *   @return 名字
         */
        /**
         * 设置名字
         * @param    value 名字
         */
        name: string;
        /**
         * 获取所管理资源的累计内存,以字节为单位
         *   @return 内存尺寸
         */
        memorySize: number;
        constructor();
        /**
         * 通过索引获取资源
         * @param 索引
         * @return 资源
         */
        getResourceByIndex(index: number): Resource;
        /**
         * 获取资源长度
         * @return 资源
         */
        getResourcesLength(): number;
        /**
         * 添加资源
         * @param 资源
         * @return 是否成功
         */
        addResource(resource: Resource): boolean;
        /**
         * 移除资源
         * @param 资源
         * @return 是否成功
         */
        removeResource(resource: Resource): boolean;
        /**卸载所有被本资源管理员载入的资源*/
        unload(): void;
        /**
         * 设置唯一名字
         * @param newName 名字,如果名字重复则自动加上“-copy”
         */
        setUniqueName(newName: string): void;
        /**释放资源*/
        dispose(): void;
    }
}
declare module laya.resource {
    /**
     * 纹理
     * @author yung
     */
    class Texture extends laya.events.EventDispatcher {
        static TEXTURE2D: number;
        static TEXTURE3D: number;
        static DEF_UV: Array<any>;
        static INV_UV: Array<any>;
        /**
         * 平移UV
         * @param offsetX 偏移x
         * @param offsetY 偏移y
         * @param uv 要移动的UV
         * @return 平移后的UV
         */
        static moveUV(offsetX: number, offsetY: number, uv: Array<any>): Array<any>;
        /**
         * 通过显示区域信息创建Texture
         * @param source 绘图资源img或者Texture
         * @param x 起始绝对坐标 x
         * @param y 起始绝对坐标 y
         * @param width 宽绝对值
         * @param height 高绝对值
         * @return 区域对应的Texture
         */
        static create(source: any, x: number, y: number, width: number, height: number, offsetX?: number, offsetY?: number): Texture;
        /**图片或者canvas*/
        bitmap: any;
        /**UV信息*/
        uv: Array<any>;
        offsetX: number;
        offsetY: number;
        /**
         * 是否加载成功，只能表示初次载入成功（通常包含下载和载入）,并不能完全表示资源是否可立即使用（资源管理机制释放影响等）
         * @return  是否成功
         */
        loaded: boolean;
        released: boolean;
        constructor(bitmapResource?: Bitmap, uv?: Array<any>);
        set(bitmapResource?: Bitmap, uv?: Array<any>): void;
        /**激活资源*/
        active(): void;
        /**激活并获取资源*/
        source: any;
        /**销毁*/
        destroy(): void;
        /**实际宽度*/
        width: number;
        /**实际高度*/
        height: number;
        /**
         * 从一个图片加载
         * @param    url 图片地址
         */
        load(url: string): void;
        repeat: boolean;
    }
}
declare module laya.system {
    /**
     * ...
     * @author laya
     */
    class System {
        static isConchApp: boolean;
        static FILTER_ACTIONS: Array<any>;
        static createRenderSprite: Function;
        static createGLTextur: Function;
        static createWebGLContext2D: Function;
        static changeWebGLSize: Function;
        static createGraphics: Function;
        static createFilterAction: Function;
        static drawToCanvas: Function;
        /**替换函数定义，用来动态更改类的定义*/
        static changeDefinition(name: string, classObj: any): void;
        static addToAtlas: Function;
        static createParticleTemplate2D: Function;
        static __init__(): void;
    }
}
declare module laya.ui {
    /**
     * <code>AutoBitmap</code> 类是用于表示位图图像或绘制图形的显示对象。
     *
     * <p>封装了位置，宽高及九宫格的处理，供UI组件使用。</p>
     *
     * @author lai
     */
    class AutoBitmap extends laya.display.Graphics {
        autoCacheCmd: boolean;
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
         *
         * @param value
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
         *
         * @see laya.resource.Texture
         * @return
         */
        source: laya.resource.Texture;
        /**
         *  清理命令缓存。
         */
        static clearCache(): void;
    }
}
declare module laya.ui {
    /**
     * <code>Box</code> 类是一个控件容器类。
     * @author yung
     */
    class Box extends Component implements IBox {
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**
     * <code>Button</code> 组件用来表示常用的多态按钮。 <code>Button</code> 组件可显示文本标签、图标或同时显示两者。
     *
     * <p>可以是单态，两态和三态，默认三态(up,over,down)。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Button</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.Button;
     *		import laya.utils.Handler;
     *
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
     *
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
     *import Button=laya.ui.Button;
     *import Handler=laya.utils.Handler;
     *class Button_Example{
     *    constructor()
     *    {
     *        Laya.init(640, 800);
     *        Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *        Laya.loader.load("resource/ui/button.png", laya.utils.Handler.create(this,this.onLoadComplete));//加载资源。
     *    }
     *    private onLoadComplete()
     *    {
     *        var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
     *        button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
     *        button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
     *        button.clickHandler = new Handler(this, this.onClickButton,[button]);//设置 button 的点击事件处理器。
     *        Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
     *    }
     *    private onClickButton(button:Button):void
     *    {
     *        console.log("按钮button被点击了！")
     *    }
     *}
     * </listing>
     *
     * @author yung
     */
    class Button extends Component implements ISelect {
        /**
         * 指定按钮按下时是否是切换按钮的显示状态。
         *
         * @example 以下示例代码，创建了一个 <code>Button</code> 实例，并设置为切换按钮。
         * <p>[EXAMPLE-AS-BEGIN]</p>
         * <listing version="3.0">
         * package
         *    {
         *		import laya.ui.Button;
         *		import laya.utils.Handler;
         *
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
        /**
         * 创建一个新的 <code>Button</code> 类实例。
         *
         *
         * @param skin 皮肤资源地址。
         * @param label 按钮的文本内容。
         */
        constructor(skin?: string, label?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected initialize(): void;
        protected onMouse(e: laya.events.Event): void;
        /**
         * <p>对象的皮肤资源地址。</p>
         * 支持单态，两态和三态，用 <code>stateNum</code> 属性设置
         *
         * <p>对象的皮肤地址，以字符串表示。</p>
         *
         * @see #stateNum
         * @return
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
         * @return
         */
        stateNum: number;
        protected changeClips(): void;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * 按钮的文本内容。
         * @return
         */
        label: string;
        /**
         * 表示按钮的选中状态。
         *
         * <p>如果值为true，表示该对象处于选中状态。否则该对象处于未选中状态。</p>
         * @return
         */
        selected: boolean;
        protected state: number;
        protected changeState(): void;
        /**
         * 表示按钮各个状态下的文本颜色。
         *
         * <p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
         * @return
         */
        labelColors: string;
        /**
         * 表示按钮各个状态下的描边颜色。
         * <p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
         * @return
         */
        strokeColors: string;
        /**
         * 表示按钮文本标签的边距。
         *
         * <p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
         * @return
         */
        labelPadding: string;
        /**
         * 表示按钮文本标签的字体大小。
         *
         * @see laya.display.Text.fontSize()
         * @return
         */
        labelSize: number;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         * @see laya.display.Text.stroke()
         * @return
         */
        labelStroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * 默认值为 "#000000"（黑色）;
         * @see laya.display.Text.strokeColor()
         * @return
         */
        labelStrokeColor: string;
        /**
         * 表示按钮文本标签是否为粗体字。
         *
         * @see laya.display.Text.bold()
         * @return
         */
        labelBold: boolean;
        /**
         * 表示按钮文本标签的字体名称，以字符串形式表示。
         *
         * @see laya.display.Text.font()
         * @return
         */
        labelFont: string;
        /**
         * 对象的点击事件处理器函数（无默认参数）。
         * @return
         */
        clickHandler: laya.utils.Handler;
        /**
         * 按钮文本标签 <code>Text</code> 控件。
         * @return
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
        /**标签对齐模式，默认为居中对齐*/
        labelAlign: string;
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
     *    {
     *		import laya.ui.CheckBox;
     *		import laya.utils.Handler;
     *
     *		public class CheckBox_Example
     *		{
     *			public function CheckBox_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     * 				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/check.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     *				trace("资源加载完成！");
     *				var checkBox:CheckBox = new CheckBox("resource/ui/check.png", "这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
     *				checkBox.x = 100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
     *				checkBox.y = 100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
     *				checkBox.clickHandler = new Handler(this, onClick, [checkBox]);//设置 checkBox 的点击事件处理器。
     *				Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
     *			}
     *
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
     *     var checkBox = new laya.ui.CheckBox("resource/ui/check.png", "这个是一个CheckBox组件。");//创建一个 CheckBox 类的类的实例对象 checkBox ,传入它的皮肤skin和标签label。
     *     checkBox.x =100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
     *     checkBox.y =100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
     *     checkBox.clickHandler = new laya.utils.Handler(this,onClick,[checkBox],false);//设置 checkBox 的点击事件处理器。
     *     Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
     * }
     * function onClick(checkBox)
     * {
     *     console.log("checkBox.selected = ",checkBox.selected);
     * }
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
     *import CheckBox= laya.ui.CheckBox;
     *import Handler=laya.utils.Handler;
     *class CheckBox_Example{
     *    constructor()
     *    {
     *        Laya.init(640, 800);
     *        Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *        Laya.loader.load("resource/ui/check.png", Handler.create(this,this.onLoadComplete));//加载资源。
     *    }
     *    private onLoadComplete()
     *    {
     *        var checkBox:CheckBox = new CheckBox("resource/ui/check.png", "这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
     *        checkBox.x = 100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
     *        checkBox.y = 100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
     *        checkBox.clickHandler = new Handler(this, this.onClick,[checkBox]);//设置 checkBox 的点击事件处理器。
     *        Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
     *    }
     *    private onClick(checkBox:CheckBox):void
     *    {
     *        console.log("输出选中状态: checkBox.selected = " + checkBox.selected);
     *    }
     *}
     * </listing>
     * @author yung
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
     *
     * @example 以下示例代码，创建了一个 <code>Clip</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.Clip;
     *
     *		public class Clip_Example
     *		{
     *			private var clip:Clip;
     *
     *			public function Clip_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				onInit();
     *			}
     *
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
     *
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
     *
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
     *
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
     * @author yung
     */
    class Clip extends Component {
        /**
         * 创建一个新的 <code>Clip</code> 示例。
         * @param url 资源类库名或者地址
         * @param clipX x方向分割个数
         * @param clipY y方向分割个数
         */
        constructor(url?: string, clipX?: number, clipY?: number);
        /**
         *
         * @inheritDoc
         */
        destroy(clearFromCache?: boolean): void;
        /**
         * 销毁对象并释放加载的皮肤资源。
         */
        dispose(): void;
        protected createChildren(): void;
        protected initialize(): void;
        protected _onDisplay(e: laya.events.Event): void;
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
    }
}
declare module laya.ui {
    /**
     * <code>ColorPicker</code> 组件将显示包含多个颜色样本的列表，用户可以从中选择颜色。
     *
     * @example 以下示例代码，创建了一个 <code>ColorPicker</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.ColorPicker;
     *		import laya.utils.Handler;
     *
     *		public class ColorPicker_Example
     *		{
     *
     *			public function ColorPicker_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/color.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *
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
     *
     *		}
     *
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
     *
     * class ColorPicker_Example {
     *
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load("resource/ui/color.png", Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *
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
     *
     * }
     * </listing>
     * @author yung
     */
    class ColorPicker extends Component {
        /**
         * 当颜色发生改变时执行的函数处理器。
         * 默认返回参数color：颜色值字符串。
         */
        changeHandler: laya.utils.Handler;
        /**
         *@inheritDoc
         */
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
         * @return
         */
        selectedColor: string;
        /**
         * @copy laya.ui.Button#skin
         * @return
         */
        skin: string;
        /**
         * 表示颜色样本列表面板的背景颜色值。
         * @return
         */
        bgColor: string;
        /**
         * 表示颜色样本列表面板的边框颜色值。
         * @return
         */
        borderColor: string;
        /**
         * 表示颜色样本列表面板选择或输入的颜色值。
         * @return
         */
        inputColor: string;
        /**
         * 表示颜色输入框的背景颜色值。
         * @return
         */
        inputBgColor: string;
    }
}
declare module laya.ui {
    /**
     * <code>ComboBox</code> 组件包含一个下拉列表，用户可以从该列表中选择单个值。
     *
     * @example 以下示例代码，创建了一个 <code>ComboBox</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.ComboBox;
     *		import laya.utils.Handler;
     *
     *		public class ComboBox_Example
     *		{
     *			public function ComboBox_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/button.png", Handler.create(this,onLoadComplete));//加载资源。
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     *				trace("资源加载完成！");
     *				var comboBox:ComboBox = new ComboBox("resource/ui/button.png", "item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
     *				comboBox.x = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *				comboBox.y = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *				comboBox.selectHandler = new Handler(this, onSelect);//设置 comboBox 选择项改变时执行的处理器。
     *				Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
     *			}
     *
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选中的项对象索引： ",index);
     *			}
     *
     *		}
     *
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
     *
     *     private onLoadComplete(): void {
     *         console.log("资源加载完成！");
     *         var comboBox: ComboBox = new ComboBox("resource/ui/button.png", "item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
     *         comboBox.x = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *         comboBox.y = 100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
     *         comboBox.selectHandler = new Handler(this, this.onSelect);//设置 comboBox 选择项改变时执行的处理器。
     *         Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
     *     }
     *
     *     private onSelect(index: number): void {
     *         console.log("当前选中的项对象索引： ", index);
     *     }
     *
     * }
     *
     * </listing>
     */
    class ComboBox extends Component {
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
         * @return
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
         * @return
         */
        labels: string;
        protected changeItem(): void;
        /**
         * 表示选择的下拉列表项的索引。
         * @return
         */
        selectedIndex: number;
        /**
         * 改变下拉列表的选择项时执行的处理器(默认返回参数index:int)。
         * @return
         */
        selectHandler: laya.utils.Handler;
        /**
         * 表示选择的下拉列表项的的标签。
         * @return
         */
        selectedLabel: string;
        /**
         * 获取或设置没有滚动条的下拉列表中可显示的最大行数。
         * @return
         */
        visibleNum: number;
        /**
         * 下拉列表项颜色。
         * <p><b>格式：</b>"悬停或被选中时背景颜色,悬停或被选中时标签颜色,标签颜色,边框颜色,背景颜色"</p>
         * @return
         */
        itemColors: string;
        /**
         * 下拉列表项标签的字体大小。
         * @return
         */
        itemSize: number;
        /**
         * 表示下拉列表的打开状态。
         * @return
         */
        isOpen: boolean;
        protected removeList(e: laya.events.Event): void;
        /**
         * 滚动条皮肤。
         * @return
         */
        scrollBarSkin: string;
        /**
         * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         * @return
         */
        sizeGrid: string;
        /**
         * 获取对 <code>ComboBox</code> 组件所包含的 <code>VScrollBar</code> 滚动条组件的引用。
         * @return
         */
        scrollBar: VScrollBar;
        /**
         * 获取对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的引用。
         */
        button: Button;
        /**
         * 获取对 <code>ComboBox</code> 组件所包含的 <code>List</code> 列表组件的引用。
         * @return
         */
        list: List;
        /**@inheritDoc */
        dataSource: any;
        /**
         * 获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的文本标签颜色。
         * <p><b>格式：</b>upColor,overColor,downColor,disableColor</p>
         * @return
         */
        labelColors: string;
        /**
         * 获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的文本边距。
         * <p><b>格式：</b>上边距,右边距,下边距,左边距</p>
         * @return
         */
        labelPadding: string;
        /**
         * 获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的标签字体大小。
         * @return
         */
        labelSize: number;
        /**
         * 表示按钮文本标签是否为粗体字。
         *
         * @see laya.display.Text#bold
         * @return
         */
        labelBold: boolean;
        /**
         * 表示按钮文本标签的字体名称，以字符串形式表示。
         *
         * @see laya.display.Text#font
         * @return
         */
        labelFont: string;
        /**
         * 表示按钮的状态值。
         *
         * @see laya.ui.Button#stateNum
         * @return
         */
        stateNum: number;
    }
}
declare module laya.ui {
    /**
     * <code>Component</code> 是ui控件类的基类。
     *
     *
     * <p>生命周期：preinitialize > createChildren > initialize > 组件构造函数</p>
     */
    class Component extends laya.display.Sprite implements IComponent {
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
         * @return
         * @internal #TM
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
         * @return
         * @internal #TM
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
         * @return
         */
        top: number;
        /**
         * <p>从组件底边到其内容区域底边之间的垂直距离（以像素为单位）。</p>
         * @return
         */
        bottom: number;
        /**
         * <p>从组件左边到其内容区域左边之间的水平距离（以像素为单位）。</p>
         * @return
         */
        left: number;
        /**
         * <p>从组件右边到其内容区域右边之间的水平距离（以像素为单位）。</p>
         * @return
         */
        right: number;
        /**
         * <p>在父容器中，此对象的水平方向中轴线与父容器的水平方向中心线的距离（以像素为单位）。</p>
         * @return
         */
        centerX: number;
        /**
         * <p>在父容器中，此对象的垂直方向中轴线与父容器的垂直方向中心线的距离（以像素为单位）。</p>
         * @return
         */
        centerY: number;
        /**
         * <p>对象的标签。</p>
         * @return
         * @internal 冗余字段，可以用来储存数据。
         */
        tag: any;
        /**
         * <p>鼠标悬停提示。</p>
         * <p>可以赋值为文本 <code>String</code> 或函数 <code>Function</code> ，用来实现自定义样式的鼠标提示和参数携带等。</p>
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
                App.tip.addChild(_testTips);
            }
         private function showTips2(name:String):void {
                _testTips.label.text = "这里是" + name;
                App.tip.addChild(_testTips);
            }
         </listing>
         * @return
         */
        /**
         *
         * @param value
         */
        toolTip: any;
        comXml: any;
        x: number;
        y: number;
        /**是否禁用页面(变灰)*/
        disabled: boolean;
    }
}
declare module laya.ui {
    /**
     * <code>Dialog</code> 组件是一个弹出对话框。
     *
     * @example 以下示例代码，创建了一个 <code>Dialog</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.Dialog;
     *		import laya.utils.Handler;
     *
     *		public class Dialog_Example
     *		{
     *			private var dialog:Dialog_Instance;
     *			public function Dialog_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load("resource/ui/btn_close.png", Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     *				dialog = new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
     *				dialog.dragArea = "0,0,150,50";//设置 dialog 的拖拽区域。
     *				dialog.show();//显示 dialog。
     *				dialog.closeHandler = new Handler(this, onClose);//设置 dialog 的关闭函数处理器。
     *			}
     *
     *			private function onClose(name:String):void
     *			{
     *				if (name == Dialog.CLOSE)
     *				{
     *					trace("通过点击 name 为" + name +"的组件，关闭了dialog。");
     *				}
     *			}
     *		}
     *	}
     *
     *    import laya.ui.Button;
     *    import laya.ui.Dialog;
     *    import laya.ui.Image;
     *
     *    class Dialog_Instance extends Dialog
     *    {
     *		function Dialog_Instance():void
     *		{
     *			var bg:Image = new Image("resource/ui/bg.png");
     *			bg.sizeGrid = "40,10,5,10";
     *			bg.width = 150;
     *			bg.height = 250;
     *			addChild(bg);
     *
     *			var image:Image = new Image("resource/ui/image.png");
     *			addChild(image);
     *
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
     *
     * (function (_super) {//新建一个类Dialog_Instance继承自laya.ui.Dialog。
     *     function Dialog_Instance() {
     *         Dialog_Instance.__super.call(this);//初始化父类
     *
     *         var bg = new laya.ui.Image("resource/ui/bg.png");//新建一个 Image 类的实例 bg 。
     *         bg.sizeGrid = "10,40,10,5";//设置 bg 的网格信息。
     *         bg.width = 150;//设置 bg 的宽度。
     *         bg.height = 250;//设置 bg 的高度。
     *         this.addChild(bg);//将 bg 添加到显示列表。
     *
     *         var image = new laya.ui.Image("resource/ui/image.png");//新建一个 Image 类的实例 image 。
     *         this.addChild(image);//将 image 添加到显示列表。
     *
     *         var button = new laya.ui.Button("resource/ui/btn_close.png");//新建一个 Button 类的实例 bg 。
     *         button.name = laya.ui.Dialog.CLOSE;//设置 button 的 name 属性值。
     *         button.x = 0;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
     *         button.y = 0;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
     *         this.addChild(button);//将 button 添加到显示列表。
     *     };
     *
     *     Laya.class(Dialog_Instance,"mypackage.dialogExample.Dialog_Instance",_super);//注册类Dialog_Instance。
     * })(laya.ui.Dialog);
     *
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
     * @author yung
     */
    class Dialog extends View {
        static CLOSE: string;
        static CANCEL: string;
        static SURE: string;
        static NO: string;
        static OK: string;
        static YES: string;
        static manager: DialogManager;
        /**
         * 一个布尔值，指定对话框是否居中弹出。
         *
         * <p>如果值为true，则居中弹出。</p>
         */
        popupCenter: boolean;
        /**
         * 对话框被关闭时会触发的回调函数处理器。
         *
         * <p>回调函数参数为用户点击的按钮名字name:String。</p>
         */
        closeHandler: laya.utils.Handler;
        protected initialize(): void;
        protected onClick(e: laya.events.Event): void;
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
        /**
         * 关闭对话框。
         * @param type 如果是点击默认关闭按钮触发，则传入关闭按钮的名字(name)，否则为null。
         */
        close(type?: string): void;
        /**关闭所有对话框。*/
        static closeAll(): void;
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
         * @return
         */
        isPopup: boolean;
    }
    class DialogManager extends laya.display.Sprite {
        dialogLayer: laya.display.Sprite;
        modalLayer: laya.display.Sprite;
        /**
         * 创建一个新的 <code>DialogManager</code> 类实例。
         */
        DialogManager(): any;
        /**
         * 显示对话框(非模式窗口类型)。
         * @param dialog 需要显示的对象框 <code>Dialog</code> 实例。
         * @param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
         */
        show(dialog: laya.ui.Dialog, closeOther?: boolean): void;
        /**
         * 显示对话框(模式窗口类型)。
         * @param dialog 需要显示的对象框 <code>Dialog</code> 实例。
         * @param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
         */
        popup(dialog: laya.ui.Dialog, closeOther?: boolean): void;
        /**
         * 关闭对话框。
         * @param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
         */
        close(dialog: laya.ui.Dialog): void;
        /**
         * 关闭所有的对话框。
         */
        closeAll(): void;
    }
}
declare module laya.ui {
    /**
     * <code>Group</code> 是一个可以自动布局的项集合控件。
     *
     * <p> <code>Group</code> 的默认项对象为 <code>Button</code> 类实例。
     * <code>Group</code> 是 <code>Tab</code> 和 <code>RadioGroup</code> 的基类。</p>
     */
    class Group extends Box implements IItem {
        /**
         * 改变 <code>Group</code> 的选择项时执行的处理器，(默认返回参数： 项索引（index:int）)。
         *
         */
        selectHandler: laya.utils.Handler;
        /**
         * 创建一个新的 <code>Group</code> 类实例。
         *
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
         *
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
         * @return
         */
        selectedIndex: number;
        protected setSelect(index: number, selected: boolean): void;
        /**
         * @copy laya.ui.Image#skin
         * @return
         */
        skin: string;
        /**
         * 标签集合字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
         * @return
         */
        labels: string;
        protected createItem(skin: string, label: string): laya.display.Sprite;
        /**
         *
         * @copy laya.ui.Button#labelColors()
         * @return
         */
        /**
         *
         * @param value
         */
        labelColors: string;
        /**
         * <p>描边宽度（以像素为单位）。</p>
         * 默认值0，表示不描边。
         * @see laya.display.Text.stroke()
         * @return
         */
        labelStroke: number;
        /**
         * <p>描边颜色，以字符串表示。</p>
         * 默认值为 "#000000"（黑色）;
         * @see laya.display.Text.strokeColor()
         * @return
         */
        labelStrokeColor: string;
        /**
         * <p>表示各个状态下的描边颜色。</p>
         * @see laya.display.Text.strokeColor()
         * @return
         */
        strokeColors: string;
        /**
         * 表示按钮文本标签的字体大小。
         *
         * @return
         */
        /**
         *
         * @param value
         */
        labelSize: number;
        /**
         * 表示按钮文本标签的字体大小。
         *
         * @return
         */
        /**
         *
         * @param value
         */
        stateNum: number;
        /**
         * 表示按钮文本标签是否为粗体字。
         * @return
         */
        /**
         *
         * @param value
         */
        labelBold: boolean;
        /**
         * 表示按钮文本标签的边距。
         *
         * <p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
         * @return
         */
        /**
         *
         * @param value
         */
        labelPadding: string;
        /**
         * 布局方向。
         *
         * <p>默认值为"horizontal"。</p>
         * <p><b>取值：</b>
         * <li>"horizontal"：表示水平布局。</li>
         * <li>"vertical"：表示垂直布局。</li>
         * </p>
         * @return
         */
        /**
         *
         * @param value
         */
        direction: string;
        /**
         * 项对象们之间的间隔（以像素为单位）。
         * @return
         */
        space: number;
        protected changeLabels(): void;
        protected commitMeasure(): void;
        /**
         * 项对象们的存放数组。
         * @return
         */
        items: Array<any>;
        /**
         * 获取或设置当前选择的项对象。
         * @return
         */
        /**
         *
         * @param value
         */
        selection: ISelect;
        /**@inheritDoc */
        dataSource: any;
    }
}
declare module laya.ui {
    /**HBox容器*/
    class HBox extends LayoutBox {
        static NONE: string;
        static TOP: string;
        static MIDDLE: string;
        static BOTTOM: string;
        constructor();
        protected sortItem(items: Array<any>): void;
        protected changeItems(): void;
    }
}
declare module laya.ui {
    /**
     * 使用 <code>HScrollBar</code> （水平 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
     *
     *
     * @example 以下示例代码，创建了一个 <code>HScrollBar</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.HScrollBar;
     *		import laya.utils.Handler;
     *
     *		public class HScrollBar_Example
     *		{
     *			private var hScrollBar:HScrollBar;
     *			public function HScrollBar_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/hscroll.png", "resource/ui/hscroll$bar.png", "resource/ui/hscroll$down.png", "resource/ui/hscroll$up.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     *				hScrollBar = new HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
     *				hScrollBar.skin = "resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
     *				hScrollBar.x = 100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
     *				hScrollBar.y = 100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
     *				hScrollBar.changeHandler = new Handler(this, onChange);//设置 hScrollBar 的滚动变化处理器。
     *				Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
     *			}
     *
     *			private function onChange(value:Number):void
     *			{
     *				trace("滚动条的位置： value=" + value);
     *			}
     *
     *		}
     *
     *	}
     * </listing>
     * <listing version="3.0">
     * Laya.init(640, 800);//设置游戏画布宽高
     * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
     * var hScrollBar;
     * var res  = ["resource/ui/hscroll.png", "resource/ui/hscroll$bar.png", "resource/ui/hscroll$down.png", "resource/ui/hscroll$up.png"];
     * Laya.loader.load(res,laya.utils.Handler.create(this, onLoadComplete));//加载资源。
     *
     * function onLoadComplete() {
     *     console.log("资源加载完成！");
     *     hScrollBar = new laya.ui.HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
     *     hScrollBar.skin = "resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
     *     hScrollBar.x = 100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
     *     hScrollBar.y = 100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
     *     hScrollBar.changeHandler = new laya.utils.Handler(this, onChange);//设置 hScrollBar 的滚动变化处理器。
     *     Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
     * }
     *
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
     * @author yung
     */
    class HScrollBar extends ScrollBar {
        protected initialize(): void;
    }
}
declare module laya.ui {
    /**
     * 使用 <code>HSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
     *
     * <p> <code>HSlider</code> 控件采用水平方向。滑块轨道从左向右扩展，而标签位于轨道的顶部或底部。</p>
     *
     * @example 以下示例代码，创建了一个 <code>HSlider</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.HSlider;
     *		import laya.utils.Handler;
     *
     *		public class HSlider_Example
     *		{
     *			private var hSlider:HSlider;
     *
     *			public function HSlider_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/hslider.png", "resource/ui/hslider$bar.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
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
     *
     *			private function onChange(value:Number):void
     *			{
     *				trace("滑块的位置： value=" + value);
     *			}
     *
     *		}
     *
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
     *
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
     *
     *     private onChange(value: number): void {
     *         console.log("滑块的位置： value=" + value);
     *     }
     *
     * }
     * </listing>
     *
     * @see laya.ui.Slider
     * @author yung
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
     * @author yung
     */
    interface IItem {
    }
}
declare module laya.ui {
    /**
     * <code>Image</code> 类是用于表示位图图像或绘制图形的显示对象。
     *
     *
     * @example 以下示例代码，创建了一个新的 <code>Image</code> 实例，设置了它的皮肤、位置信息，并添加到舞台上。
     * <listing version="3.0">
     *    package
     *     {
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
     *
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
     *
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
     *
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
        /**
         * 创建一个 <code>Image</code> 实例
         * @param skin 皮肤资源地址。
         */
        constructor(skin?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        /**
         * 销毁对象并释放加载的皮肤资源
         */
        dispose(): void;
        protected createChildren(): void;
        /**
         * <p>对象的皮肤地址，以字符串表示。</p>
         * <p>如果资源未加载，则先加载资源，加载完成然后应用于此对象。</p>
         * <b>注意：</b>资源加载完成后，会自动缓存至资源库中。
         *
         * @return
         */
        skin: string;
        /**
         * @copy laya.ui.AutoBitmap#source
         * @return
         */
        source: laya.resource.Texture;
        protected setSource(url: string, value: any): void;
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
     * @author yung
     */
    interface IRender {
    }
}
declare module laya.ui {
    /**
     * <code>ISelect</code> 接口，实现对象的 <code>selected</code> 属性和 <code>clickHandler</code> 选择回调函数处理器。
     * @author yung
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
     *    {
     *		import laya.ui.Label;
     *
     *		public class Label_Example
     *		{
     *			public function Label_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				onInit();
     *			}
     *
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
     *
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
     *
     *		}
     *
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
     *
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
     * @author yung
     */
    class Label extends laya.ui.Component {
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
         *
         * @see laya.display.Text.text
         * @return
         */
        text: string;
        /**
         * @copy laya.display.Text#wordWrap
         */
        /**
         * @copy laya.display.Text#wordWrap
         */
        wordWrap: boolean;
        /**
         * @copy laya.display.Text#color
         * @return
         */
        color: string;
        /**
         * @copy laya.display.Text#font
         */
        font: string;
        /**
         * @copy laya.display.Text#align
         * @return
         */
        align: string;
        /**
         * @copy laya.display.Text#valign
         * @return
         */
        valign: string;
        /**
         * @copy laya.display.Text#bold
         * @return
         */
        bold: boolean;
        /**
         * @copy laya.display.Text#italic
         * @return
         */
        italic: boolean;
        /**
         * @copy laya.display.Text#leading
         * @return
         */
        leading: number;
        /**
         * @copy laya.display.Text#fontSize
         * @return
         */
        fontSize: number;
        /**
         * <p>边距信息</p>
         * <p>"上边距，右边距，下边距 , 左边距（边距以像素为单位）"</p>
         * @see laya.display.Text.padding
         * @return
         */
        padding: string;
        /**
         * @copy laya.display.Text#bgColor
         * @return
         */
        bgColor: string;
        /**
         * @copy laya.display.Text#borderColor
         * @return
         */
        borderColor: string;
        /**
         * @copy laya.display.Text#stroke
         * @return
         */
        stroke: number;
        /**
         * @copy laya.display.Text#strokeColor
         * @return
         */
        strokeColor: string;
        /**
         * @copy laya.display.Text#asPassword
         * @return
         */
        asPassword: boolean;
        /**
         * 文本控件实体 <code>Text</code> 实例。
         * @return
         */
        textField: laya.display.Text;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * @inheritDoc
         * @return
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
    }
}
declare module laya.ui {
    /**布局容器*/
    class LayoutBox extends Box {
        constructor();
        addChild(child: laya.display.Node): laya.display.Node;
        addChildAt(child: laya.display.Node, index: number): laya.display.Node;
        removeChild(child: laya.display.Node): laya.display.Node;
        removeChildAt(index: number): laya.display.Node;
        /**刷新*/
        refresh(): void;
        protected changeItems(): void;
        /**子对象的间隔*/
        space: number;
        /**子对象对齐方式*/
        align: string;
        protected sortItem(items: Array<any>): void;
    }
}
declare module laya.ui {
    /**
     * <code>LayoutStyle</code> 是一个布局样式类。
     * @author yung
     */
    class LayoutStyle {
        /**
         * 一个已初始化的 <code>LayoutStyle</code> 实例。
         */
        static EMPTY: LayoutStyle;
        /**
         * 表示距顶边的距离（以像素为单位）。
         */
        top: number;
        /**
         * 表示距底边的距离（以像素为单位）。
         */
        bottom: number;
        /**
         * 表示距左边的距离（以像素为单位）。
         */
        left: number;
        /**
         * 表示距右边的距离（以像素为单位）。
         */
        right: number;
        /**
         * 表示距水平方向中心轴的距离（以像素为单位）。
         */
        centerX: number;
        /**
         * 表示距垂直方向中心轴的距离（以像素为单位）。
         */
        centerY: number;
        /**
         * 一个布尔值，表示是否有效。
         * @internal #?
         */
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
     *    {
     *		import laya.ui.List;
     *		import laya.utils.Handler;
     *
     *		public class List_Example
     *		{
     *			public function List_Example()
     *			{
     *				Laya.init(640, 800, "false");//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, onLoadComplete));
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     *				var arr:Array = [];//创建一个数组，用于存贮列表的数据信息。
     *				for (var i:int = 0; i &lt; 20; i++)
     *				{
     *					arr.push({label: "item" + i});
     *				}
     *
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
     *
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选择的项目索引： index= ", index);
     *			}
     *		}
     *	}
     *    import laya.ui.Box;
     *    import laya.ui.Label;
     *    class Item extends Box
     *    {
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
     *
     * @author yung
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
        /**是否缓存内容，如果数据源较少，并且list内无动画，设置此属性为true能大大提高性能 */
        cacheContent: boolean;
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        cacheAsBitmap: boolean;
        /**
         * 获取对 <code>List</code> 组件所包含的内容容器 <code>Box</code> 组件的引用。
         * @return
         */
        content: Box;
        /**
         * 垂直方向滚动条皮肤。
         * @return
         */
        vScrollBarSkin: string;
        /**
         * 水平方向滚动条皮肤。
         * @return
         */
        hScrollBarSkin: string;
        /**
         * 获取对 <code>List</code> 组件所包含的滚动条 <code>ScrollBar</code> 组件的引用。
         * @return
         */
        scrollBar: ScrollBar;
        /**
         * 单元格渲染器。
         * <p><b>取值：</b>
         * <ol>
         * <li>单元格类对象。</li>
         * <li> UI 的 JSON 描述。</li>
         * </ol></p>
         * @return
         */
        itemRender: any;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * 水平方向显示的单元格数量。
         * @return
         */
        repeatX: number;
        /**
         * 垂直方向显示的单元格数量。
         * @return
         */
        repeatY: number;
        /**
         * 水平方向显示的单元格之间的间距（以像素为单位）。
         * @return
         */
        spaceX: number;
        /**
         * 垂直方向显示的单元格之间的间距（以像素为单位）。
         * @return
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
         *
         * <p>以（0，0，width参数，height参数）组成的矩形区域为可视区域。</p>
         * @param width 可视区域宽度。
         * @param height 可视区域高度。
         */
        setContentSize(width: number, height: number): void;
        protected onCellMouse(e: laya.events.Event): void;
        protected changeCellState(cell: Box, visable: boolean, index: number): void;
        protected changeSize(): void;
        protected onScrollBarChange(e: laya.events.Event): void;
        /**
         * 表示当前选择的项索引。
         * @return
         */
        selectedIndex: number;
        protected changeSelectStatus(): void;
        /**
         * 当前选中的单元格数据源。
         * @return
         */
        selectedItem: any;
        /**
         * 获取或设置当前选择的单元格对象。
         * @return
         */
        selection: Box;
        /**
         * 当前显示的单元格列表的开始索引。
         * @return
         */
        startIndex: number;
        protected renderItems(): void;
        protected renderItem(cell: Box, index: number): void;
        /**
         * 列表数据源。
         * @return
         */
        array: Array<any>;
        /**
         * 列表的当前页码。
         * @return
         */
        page: number;
        /**
         * 列表的数据总个数。
         * @return
         */
        length: number;
        /**@inheritDoc */
        dataSource: any;
        /**
         * 单元格集合。
         * @return
         */
        cells: Array<any>;
        /**
         * 刷新列表数据源。
         */
        refresh(): void;
        /**
         * 获取单元格数据源。
         * @param index 单元格索引。
         * @return
         */
        getItem(index: number): any;
        /**
         * 修改单元格数据源。
         * @param index 单元格索引。
         * @param source 单元格数据源。
         */
        changeItem(index: number, source: any): void;
        /**
         * 添加单元格数据源。
         * @param souce
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
         * @param index
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
    }
}
declare module laya.ui {
    /**
     * <code>Panel</code> 是一个面板容器类。
     *
     *
     *
     * @author yung
     *
     */
    class Panel extends Box {
        /**
         * 创建一个新的 <code>Panel</code> 类实例。
         *
         * <p>在 <code>Panel</code> 构造函数中设置属性width、height的值都为100。</p>
         */
        constructor();
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
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
        /**
         * @private
         * 获取内容宽度（以像素为单位）。
         * @return
         */
        contentWidth: number;
        /**
         * @private
         * 获取内容高度（以像素为单位）。
         * @return
         */
        contentHeight: number;
        /**
         * @inheritDoc
         * @param value
         */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * 垂直方向滚动条皮肤。
         * @return
         */
        vScrollBarSkin: string;
        /**
         * 水平方向滚动条皮肤。
         * @return
         */
        hScrollBarSkin: string;
        /**
         * 垂直方向滚动条对象。
         * @return
         */
        vScrollBar: ScrollBar;
        /**
         * 水平方向滚动条对象。
         * @return
         */
        hScrollBar: ScrollBar;
        /**
         * 获取内容容器对象。
         * @return
         */
        content: laya.display.Sprite;
        protected onScrollBarChange(scrollBar: ScrollBar, e: laya.events.Event): void;
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
        cacheAsBitmap: boolean;
    }
}
declare module laya.ui {
    /**
     * <code>ProgressBar</code> 组件显示内容的加载进度。
     * @example 以下示例代码，创建了一个新的 <code>ProgressBar</code> 实例，设置了它的皮肤、位置、宽高、网格等信息，并添加到舞台上。
     * <listing version="3.0">
     * package
     *    {
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
     *
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
     *
     *			private function changeValue():void
     *			{
     *				trace("改变进度条的进度值。");
     *				progressBar.value = 0.6;
     *			}
     *
     *			private function onChange(value:Number):void
     *			{
     *				trace("进度发生改变： value=" ,value);
     *			}
     *		}
     *	}
     *
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
     *
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
     * @author yung
     */
    class ProgressBar extends laya.ui.Component {
        /**
         * 当 <code>ProgressBar</code> 实例的 <code>value</code> 属性发生变化时的函数处理器。
         *
         * <p>默认返回参数<code>value</code> 属性（进度值）。</p>
         */
        changeHandler: laya.utils.Handler;
        /**
         * 创建一个新的 <code>ProgressBar</code> 类实例。
         * @param skin
         */
        constructor(skin?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        /**
         * @copy laya.ui.Image#skin
         * @return
         */
        skin: string;
        protected measureWidth: number;
        protected measureHeight: number;
        /**
         * 当前的进度量。
         * <p><b>取值：</b>介于0和1之间。</p>
         * @return
         */
        value: number;
        protected changeValue(): void;
        /**
         * 获取进度条对象。
         * @return
         */
        bar: laya.ui.Image;
        /**
         * 获取背景条对象。
         * @return
         */
        bg: laya.ui.Image;
        /**
         * <p>当前 <code>ProgressBar</code> 实例的进度条背景位图（ <code>Image</code> 实例）的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         * @return
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
     *
     *
     * @see laya.ui.RadioGroup
     * @author yung
     */
    class Radio extends laya.ui.Button {
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
         *
         * @internal ##?
         * @return
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
     *    {
     *		import laya.ui.Radio;
     *		import laya.ui.RadioGroup;
     *		import laya.utils.Handler;
     *
     *		public class RadioGroup_Example
     *		{
     *
     *			public function RadioGroup_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/radio.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
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
     *
     *			private function onSelect(index:int):void
     *			{
     *				trace("当前选择的单选按钮索引: index= ", index);
     *			}
     *
     *		}
     *
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
     *  class RadioGroup_Example {
     *
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/radio.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *
     *     private onLoadComplete(): void {
     *         var radioGroup: RadioGroup = new RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
     *         radioGroup.pos(100, 100);//设置 radioGroup 的位置信息。
     *         radioGroup.labels = "item0,item1,item2";//设置 radioGroup 的标签集。
     *         radioGroup.skin = "resource/ui/radio.png";//设置 radioGroup 的皮肤。
     *         radioGroup.space = 10;//设置 radioGroup 的项间隔距离。
     *         radioGroup.selectHandler = new Handler(this, this.onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
     *         Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
     *     }
     *
     *     private onSelect(index: number): void {
     *         console.log("当前选择的单选按钮索引: index= ", index);
     *     }
     *
     * }
     * </listing>
     * @author yung
     */
    class RadioGroup extends Group {
        protected createItem(skin: string, label: string): laya.display.Sprite;
    }
}
declare module laya.ui {
    /**
     * <code>ScrollBar</code> 组件是一个滚动条组件。
     *
     * <p>当数据太多以至于显示区域无法容纳时，最终用户可以使用 <code>ScrollBar</code> 组件控制所显示的数据部分。</p>
     * <p> 滚动条由四部分组成：两个箭头按钮、一个轨道和一个滑块。 </p>     *
     *
     * @see laya.ui.VScrollBar
     * @see laya.ui.HScrollBar
     * @author yung
     */
    class ScrollBar extends Component {
        /**滚动变化时回调，回传value参数。*/
        changeHandler: laya.utils.Handler;
        /**是否缩放滑动条，默认值为true。 */
        scaleBar: boolean;
        /**一个布尔值，指定是否自动隐藏滚动条(无需滚动时)，默认值为false。*/
        autoHide: boolean;
        /**橡皮筋效果极限距离，0为没有橡皮筋效果。*/
        elasticDistance: number;
        /**橡皮筋回弹时间，单位为毫秒*/
        elasticBackTime: number;
        /**
         * 创建一个新的 <code>ScrollBar</code> 实例。
         * @param skin 皮肤资源地址。
         */
        constructor(skin?: string);
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected initialize(): void;
        protected onSliderChange(e: laya.events.Event): void;
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
         * 设置滚动对象。*
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
         * 停止滑动
         */
        stopScroll(): void;
    }
}
declare module laya.ui {
    /**
     * 使用 <code>Slider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
     *
     * <p>滑块的当前值由滑块端点（对应于滑块的最小值和最大值）之间滑块的相对位置确定。</p>
     * <p>滑块允许最小值和最大值之间特定间隔内的值。滑块还可以使用数据提示显示其当前值。</p>
     *
     * @see laya.ui.HSlider
     * @see laya.ui.VSlider
     * @author yung
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
         * 表示当前的刻度值。默认值为1。
         * @return
         */
        tick: number;
        protected changeValue(): void;
        /**
         * 获取或设置表示最高位置的数字。 默认值为100。
         * @return
         */
        max: number;
        /**
         * 获取或设置表示最低位置的数字。 默认值为0。
         * @return
         */
        min: number;
        /**
         * 获取或设置表示当前滑块位置的数字。
         * @return
         */
        value: number;
        /**
         * 一个布尔值，指定是否允许通过点击滑动条改变 <code>Slider</code> 的 <code>value</code> 属性值。
         * @return
         */
        allowClickBack: boolean;
        protected onBgMouseDown(e: laya.events.Event): void;
        /**@inheritDoc */
        dataSource: any;
        /**
         * 表示滑块按钮的引用。
         * @return
         */
        bar: Button;
    }
}
declare module laya.ui {
    /**
     * <code>Styles</code> 定义了组件常用的样式属性。
     * @author yung
     */
    class Styles {
        /**
         * 默认九宫格信息。
         *
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
     * <code>Tab</code> 组件用来定义选项卡按钮组。
     *
     * @internal <p>属性：<code>selectedIndex</code> 的默认值为-1。</p>
     *
     * @example 以下示例代码，创建了一个 <code>Tab</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.Tab;
     *		import laya.utils.Handler;
     *
     *		public class Tab_Example
     *		{
     *
     *			public function Tab_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/tab.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
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
     *
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
     *
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
     *
     *     constructor() {
     *         Laya.init(640, 800);//设置游戏画布宽高。
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *         Laya.loader.load(["resource/ui/tab.png"], Handler.create(this, this.onLoadComplete));//加载资源。
     *     }
     *
     *     private onLoadComplete(): void {
     *         var tab: Tab = new Tab();//创建一个 Tab 类的实例对象 tab 。
     *         tab.skin = "resource/ui/tab.png";//设置 tab 的皮肤。
     *         tab.labels = "item0,item1,item2";//设置 tab 的标签集。
     *         tab.x = 100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
     *         tab.y = 100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
     *         tab.selectHandler = new Handler(this, this.onSelect);//设置 tab 的选择项发生改变时执行的处理器。
     *         Laya.stage.addChild(tab);//将 tab 添到显示列表。
     *     }
     *
     *     private onSelect(index: number): void {
     *         console.log("当前选择的表情页索引: index= ", index);
     *     }
     * }
     * </listing>
     * @author yung
     */
    class Tab extends laya.ui.Group {
        protected createItem(skin: string, label: string): laya.display.Sprite;
    }
}
declare module laya.ui {
    /**
     * <code>TextArea</code> 类用于创建显示对象以显示和输入文本。
     *
     *
     * @example 以下示例代码，创建了一个 <code>TextArea</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.TextArea;
     *		import laya.utils.Handler;
     *
     *		public class TextArea_Example
     *		{
     *
     *			public function TextArea_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/input.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
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
     *
     *		}
     *
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
     * @author yung
     */
    class TextArea extends TextInput {
        /**
         * <p>创建一个新的 <code>TextArea</code> 示例。</p>
         * @param text 文本内容字符串。
         */
        constructor(text?: string);
    }
}
declare module laya.ui {
    /**
     * <code>TextInput</code> 类用于创建显示对象以显示和输入文本。
     *
     * @example 以下示例代码，创建了一个 <code>TextInput</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.display.Stage;
     *		import laya.ui.TextInput;
     *		import laya.utils.Handler;
     *
     *		public class TextInput_Example
     *		{
     *			public function TextInput_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/input.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
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
     *
     *		}
     *
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
     *
     * }
     * </listing>
     * @author yung
     */
    class TextInput extends Label {
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
         * @return
         */
        bg: laya.ui.AutoBitmap;
        /**
         * @copy laya.ui.Image#skin
         * @return
         */
        skin: string;
        /**
         * <p>当前实例的背景图（ <code>AutoBitmap</code> ）实例的有效缩放网格数据。</p>
         * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
         * <ul><li>例如："4,4,4,4,1"</li></ul></p>
         * @see laya.ui.AutoBitmap.sizeGrid
         * @return
         */
        sizeGrid: string;
        /**@inheritDoc */
        width: number;
        /**@inheritDoc */
        height: number;
        /**
         * <p>指示当前是否是文本域。</p>
         * 值为true表示当前是文本域，否则不是文本域。
         * @return
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
        /**选中输入框内的文本*/
        select(): void;
        /**限制输入的字符*/
        restrict: string;
        /**移动平台输入期间的标题*/
        title: string;
        /**
         * @copy laya.display.Input#maxChars
         */
        maxChars: number;
    }
}
declare module laya.ui {
    /**
     * <code>Tree</code> 控件使用户可以查看排列为可扩展树的层次结构数据。
     *
     * @example 以下示例代码，创建了一个 <code>Tree</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.Tree;
     *		import laya.utils.Browser;
     *		import laya.utils.Handler;
     *
     *		public class Tree_Example
     *		{
     *
     *			public function Tree_Example()
     *			{
     *				Laya.init(640, 800);
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder.png", "resource/ui/clip_tree_arrow.png"], Handler.create(this, onLoadComplete));
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     * 				var xmlString:String;//创建一个xml字符串，用于存储树结构数据。
     *				xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
     *				var domParser:* = new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
     *				var xml:* = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
     *
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
     *
     * import laya.ui.Box;
     * import laya.ui.Clip;
     * import laya.ui.Label;
     *    class Item extends Box
     *    {
     *		public function Item()
     *		{
     *			this.name = "render";
     *			this.right = 0;
     *			this.left = 0;
     *
     *			var selectBox:Clip = new Clip("resource/ui/clip_selectBox.png", 1, 2);
     *			selectBox.name = "selectBox";
     *			selectBox.height = 24;
     *			selectBox.x = 13;
     *			selectBox.y = 0;
     *			selectBox.left = 12;
     *			addChild(selectBox);
     *
     *			var folder:Clip = new Clip("resource/ui/clip_tree_folder.png", 1, 3);
     *			folder.name = "folder";
     *			folder.x = 14;
     *			folder.y = 4;
     *			addChild(folder);
     *
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
     *
     *			var arrow:Clip = new Clip("resource/ui/clip_tree_arrow.png", 1, 2);
     *			arrow.name = "arrow";
     *			arrow.x = 0;
     *			arrow.y = 5;
     *			addChild(arrow);
     *		}
     *	 }
     *
     *
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
     *
     *     constructor() { *
     *         Laya.init(640, 800); *
     *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。 *
     *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder * . * png", "resource/ui/clip_tree_arrow.png"], Handler.create(this, this.onLoadComplete)); *
     *     } *
     *     private onLoadComplete(): void { *
     *         var xmlString: String;//创建一个xml字符串，用于存储树结构数据。 *
     *         xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc  * label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
     *         var domParser: any = new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
     *         var xml: any = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
     *
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
     *
     *         var folder: Clip = new Clip("resource/ui/clip_tree_folder.png", 1, 3);
     *         folder.name = "folder";
     *         folder.x = 14;
     *         folder.y = 4;
     *         this.addChild(folder);
     *
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
     *
     *         var arrow: Clip = new Clip("resource/ui/clip_tree_arrow.png", 1, 2);
     *         arrow.name = "arrow";
     *         arrow.x = 0;
     *         arrow.y = 5;
     *         this.addChild(arrow);
     *     }
     * }
     * </listing>
     * @author yung
     */
    class Tree extends Box implements IRender {
        /**
         * 创建一个新的 <code>Tree</code> 类实例。
         *
         * <p>在 <code>Tree</code> 构造函数中设置属性width、height的值都为200。</p>
         */
        constructor();
        /**@inheritDoc */
        destroy(destroyChild?: boolean): void;
        protected createChildren(): void;
        protected onListChange(e: laya.events.Event): void;
        /**
         * 数据源发生变化后，是否保持之前打开状态，默认为true。
         *
         * <p><b>取值：</b>
         * <li>true：保持之前打开状态。</li>
         * <li>false：不保持之前打开状态。</li>
         * </p>
         * @return
         */
        keepStatus: boolean;
        /**
         * 列表数据源，只包含当前可视节点数据。
         * @return
         */
        array: Array<any>;
        /**
         * 数据源，全部节点数据。
         * @return
         */
        source: Array<any>;
        /**
         * 此对象包含的<code>List</code>实例对象。
         * @return
         */
        list: List;
        /**
         * 此对象包含的<code>List</code>实例的单元格渲染器。
         *
         * <p><b>取值：</b>
         * <ol>
         * <li>单元格类对象。</li>
         * <li> UI 的 JSON 描述。</li>
         * </ol></p>
         *
         * @return
         */
        itemRender: any;
        /**
         * 滚动条皮肤。
         * @return
         */
        scrollBarSkin: string;
        /**滚动条*/
        scrollBar: ScrollBar;
        /**
         * 单元格鼠标事件处理器。
         * <p>默认返回参数（e:Event,index:int）。</p>
         * @return
         */
        mouseHandler: laya.utils.Handler;
        /**
         * <code>Tree</code> 实例的渲染处理器。
         * @return
         */
        renderHandler: laya.utils.Handler;
        /**
         * 左侧缩进距离（以像素为单位）。
         * @return
         */
        spaceLeft: number;
        /**
         * 每一项之间的间隔距离（以像素为单位）。
         * @return
         */
        spaceBottom: number;
        /**
         * 表示当前选择的项索引。
         * @return
         */
        selectedIndex: number;
        /**
         * 当前选中的项对象的数据源。
         * @return
         */
        selectedItem: any;
        /**
         * @inheritDoc
         * @param value
         */
        width: number;
        /**@inheritDoc */
        height: number;
        protected getArray(): Array<any>;
        protected getDepth(item: any, num?: number): number;
        protected getParentOpenStatus(item: any): boolean;
        protected renderItem(cell: Box, index: number): void;
        /**
         * 通过数据项索引，设置项对象的打开状态。
         * @param index
         * @param isOpen
         */
        setItemState(index: number, isOpen: boolean): void;
        fresh(): void;
        /**@inheritDoc */
        dataSource: any;
        /**
         *  xml结构的数据源。
         * @param value
         */
        xml: any;
        protected parseXml(xml: any, source: Array<any>, nodeParent: any, isRoot: boolean): void;
        protected parseOpenStatus(oldSource: Array<any>, newSource: Array<any>): void;
        protected isSameParent(item1: any, item2: any): boolean;
        /**
         * 表示选择的树节点项的<code>path</code>属性值。
         * @return
         */
        selectedPath: string;
        /**
         * @internal ##??
         * @param key
         */
        filter(key: string): void;
    }
}
declare module laya.ui {
    /**
     * <code>UIEvent</code> 类用来定义UI组件类的事件类型。
     * @author yung
     *
     */
    class UIEvent extends laya.events.Event {
        /**
         */
        static SHOW_TIP: string;
        /**
         */
        static HIDE_TIP: string;
    }
}
declare module laya.ui {
    /**
     * 文本工具集。
     * @author yung
     */
    class UIUtils {
        /**
         * 用字符串填充数组，并返回数组副本。
         * @param arr
         * @param str
         * @param type
         * @return
         */
        static fillArray(arr: Array<any>, str: string, type?: any): Array<any>;
        /**
         * 转换uint类型颜色值为字符串。
         * @param color uint颜色值。
         * @return
         */
        static toColor(color: number): string;
        /**让显示对象变成灰色*/
        static gray(traget: laya.display.Sprite, isGray?: boolean): void;
        /**添加滤镜*/
        static addFilter(target: laya.display.Sprite, filter: laya.filters.IFilter): void;
        /**清除滤镜*/
        static clearFilter(target: laya.display.Sprite, filterType: any): void;
    }
}
declare module laya.ui {
    /**VBox容器*/
    class VBox extends LayoutBox {
        static NONE: string;
        static LEFT: string;
        static CENTER: string;
        static RIGHT: string;
        constructor();
        protected changeItems(): void;
    }
}
declare module laya.ui {
    /**
     * <code>View</code> 是一个视图类。
     *
     * @internal <p><code>View</code></p>
     * @author yung
     */
    class View extends laya.ui.Box {
        /**
         * 存储UI配置数据(用于加载模式)。
         */
        static uiMap: any;
        /**
         * UI类映射。
         */
        static uiClassMap: any;
        protected createView(uiView: any): void;
        protected loadUI(path: string): void;
        /**
         * 根据UI数据实例化组件。
         * @param uiView UI数据。
         * @param comp 组件本体，如果为空，会新创建一个。
         * @param view 组件所在的视图实例，用来注册var全局变量，如果值为空则不注册。
         * @return
         */
        static createComp(uiView: any, comp?: laya.ui.Component, view?: View): laya.ui.Component;
        protected static getCompInstance(json: any): laya.ui.Component;
        /**
         * 注册组件类映射。
         * <p>用于扩展组件及修改组件对应关系。</p>
         * @param key 组件类的关键字。
         * @param compClass 组件类对象。
         */
        static regComponent(key: string, compClass: any): void;
        /**
         * 注册UI视图类的逻辑处理类。
         *
         * @internal 注册runtime解析。
         * @param key UI视图类的关键字。
         * @param compClass UI视图类对应的逻辑处理类。
         */
        static regViewRuntime(key: string, compClass: any): void;
    }
}
declare module laya.ui {
    /**
     * <code>ViewStack</code> 类用于视图堆栈类，用于视图的显示等设置处理。
     * @author yung
     */
    class ViewStack extends laya.ui.Box implements IItem {
        /**
         * 批量设置视图对象。
         * @param views 视图对象数组。
         */
        setItems(views: Array<any>): void;
        /**
         * 添加视图。
         *
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
         * @return
         */
        selectedIndex: number;
        protected setSelect(index: number, selected: boolean): void;
        /**
         * 获取或设置当前选择的项对象。
         * @return
         */
        selection: laya.display.Node;
        /**
         *  索引设置处理器。
         * <p>默认回调参数：index:int</p>
         * @return
         */
        setIndexHandler: laya.utils.Handler;
        protected setIndex(index: number): void;
        /**
         * 视图集合数组。
         * @return
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
     *    {
     *		import laya.ui.vScrollBar;
     *		import laya.ui.VScrollBar;
     *		import laya.utils.Handler;
     *
     *		public class VScrollBar_Example
     *		{
     *			private var vScrollBar:VScrollBar;
     *			public function VScrollBar_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, onLoadComplete));
     *			}
     *
     *			private function onLoadComplete():void
     *			{
     *				vScrollBar = new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
     *				vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
     *				vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
     *				vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
     *				vScrollBar.changeHandler = new Handler(this, onChange);//设置 vScrollBar 的滚动变化处理器。
     *				Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
     *			}
     *
     *			private function onChange(value:Number):void
     *			{
     *				trace("滚动条的位置： value=" + value);
     *			}
     *
     *		}
     *
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
     *
     *     private onLoadComplete(): void {
     *         this.vScrollBar = new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
     *         this.vScrollBar.skin = "resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
     *         this.vScrollBar.x = 100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
     *         this.vScrollBar.y = 100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
     *         this.vScrollBar.changeHandler = new Handler(this, this.onChange);//设置 vScrollBar 的滚动变化处理器。
     *         Laya.stage.addChild(this.vScrollBar);//将此 vScrollBar 对象添加到显示列表。
     *     }
     *
     *     private onChange(value: number): void {
     *         console.log("滚动条的位置： value=" + value);
     *     }
     *
     * }
     * </listing>
     * @author yung
     */
    class VScrollBar extends ScrollBar {
    }
}
declare module laya.ui {
    /**
     * 使用 <code>VSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
     *
     * <p> <code>VSlider</code> 控件采用垂直方向。滑块轨道从下往上扩展，而标签位于轨道的左右两侧。</p>
     *
     * @example 以下示例代码，创建了一个 <code>VSlider</code> 实例。
     * <listing version="3.0">
     * package
     *    {
     *		import laya.ui.HSlider;
     *		import laya.ui.VSlider;
     *		import laya.utils.Handler;
     *
     *		public class VSlider_Example
     *		{
     *			private var vSlider:VSlider;
     *
     *			public function VSlider_Example()
     *			{
     *				Laya.init(640, 800);//设置游戏画布宽高。
     *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
     *				Laya.loader.load(["resource/ui/vslider.png", "resource/ui/vslider$bar.png"], Handler.create(this, onLoadComplete));//加载资源。
     *			}
     *
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
     *
     *			private function onChange(value:Number):void
     *			{
     *				trace("滑块的位置： value=" + value);
     *			}
     *
     *		}
     *
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
     *
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
     *
     *     private onChange(value: number): void {
     *         console.log("滑块的位置： value=" + value);
     *     }
     *
     * }
     * </listing>
     * @see laya.ui.Slider
     * @author yung
     */
    class VSlider extends Slider {
    }
}
declare module laya.utils {
    /**
     * 浏览器代理类，封装浏览器及原生js提供的一些功能
     * @author yung
     */
    class Browser {
        /**浏览器原生window对象引用*/
        static window: any;
        /**浏览器原生document对象引用*/
        static document: any;
        /**浏览器代理信息*/
        static userAgent: string;
        /**ios设备*/
        static onIOS: boolean;
        /**移动设备*/
        static onMobile: boolean;
        /**iphone设备*/
        static onIPhone: boolean;
        /**ipad设备*/
        static onIPad: boolean;
        /**andriod设备*/
        static onAndriod: boolean;
        /**Windows Phone设备*/
        static onWP: boolean;
        /**QQ浏览器*/
        static onQQBrowser: boolean;
        /**移动端QQ或QQ浏览器*/
        static onMQQBrowser: boolean;
        /**微信内*/
        static onWeiXin: boolean;
        /**PC端*/
        static onPC: boolean;
        static webAudioOK: boolean;
        static soundType: string;
        /**全局画布实例。*/
        static canvas: laya.resource.HTMLCanvas;
        /**全局画布上绘图的环境。 */
        static ctx: laya.resource.Context;
        /**
         * 创建浏览器原生节点
         * @param    type 节点类型
         * @return    创建的节点
         */
        static createElement(type: string): any;
        /**
         * 获取浏览器原生节点
         * @param    type 节点类型
         * @return    节点
         */
        static getElementById(type: string): any;
        /**
         * 移除浏览器原生节点
         * @param    type 节点类型
         */
        static removeElement(ele: any): void;
        /**
         * 获取浏览器当前时间
         */
        static now(): number;
        /**浏览器可视宽度*/
        static clientWidth: number;
        /**浏览器可视高度*/
        static clientHeight: number;
        /**浏览器物理宽度*/
        static width: number;
        /**浏览器物理高度*/
        static height: number;
        /**设备像素比*/
        static pixelRatio: number;
    }
}
declare module laya.utils {
    class Byte {
        static BIG_ENDIAN: string;
        static LITTLE_ENDIAN: string;
        static getSystemEndian(): string;
        constructor(d?: any);
        buffer: any;
        endian: string;
        length: number;
        getString(): string;
        getFloat32Array(start: number, len: number): any;
        getUint8Array(start: number, len: number): Uint8Array;
        getInt16Array(start: number, len: number): any;
        getFloat32(): number;
        writeFloat32(value: number): void;
        getInt32(): number;
        getUint32(): number;
        writeInt32(value: number): void;
        writeUint32(value: number): void;
        getInt16(): number;
        getUint16(): number;
        writeUint16(value: number): void;
        writeInt16(value: number): void;
        getUint8(): number;
        writeUint8(value: number): void;
        _getUInt8(pos: number): number;
        _getUint16(pos: number): number;
        _getMatrix(): laya.maths.Matrix;
        getCustomString(len: number): string;
        pos: number;
        bytesAvailable: number;
        clear(): void;
        __getBuffer(): ArrayBuffer;
        /**
         *  写字符串，该方法写的字符串要使用 readUTFBytes方法读
         * @param value 要写入的字符串
         */
        writeUTFBytes(value: string): void;
        writeUTFString(value: string): void;
        readUTFString(): string;
        /**
         * 读字符串，必须是 writeUTFBytes方法写入的字符串
         * @param len 要读的buffer长度,默认将读取缓冲区全部数据
         * @return 读取的字符串
         */
        readUTFBytes(len?: number): string;
        writeByte(value: number): void;
        ensureWrite(lengthToEnsure: number): void;
        writeArrayBuffer(arraybuffer: any, offset?: number, length?: number): void;
    }
}
declare module laya.utils {
    /**
     * 类工具
     * @author yung
     */
    class ClassUtils {
        /**
         * 注册Class映射
         * @param    className 映射的名字，或者类名简写
         * @param    classDef 类的全名或者类的引用，全名比如:"laya.display.Sprite"
         */
        static regClass(className: string, classDef: any): void;
        /**
         * 返回注册Class映射
         * @param    className 映射的名字
         */
        static getRegClass(className: string): any;
        /**
         * 根据名字返回类对象
         * @param    className 类名
         * @return
         */
        static getClass(className: string): any;
        /**
         * 根据名称创建Class实例
         * @param    className 类名
         * @return    返回类的实例
         */
        static getInstance(className: string): any;
        /**
         * 根据json创建节点
         * 比如:
         *
         "type":"Sprite",
         "props":
         "x":100,
         "y":
         "scale":
         },
         "child":[
         "type":"Text",
         "props":
         "text":"this is a test",
         "var":"label",
         "rumtime":""
         }
         }
         ]
         }
         * @param    json json字符串或者Object对象
         * @param    node node节点，如果为空，则新创建一个
         * @param    root 根节点，用来设置var定义
         * @return    生成的节点
         */
        static createByJson(json: any, node?: any, root?: laya.display.Node): any;
    }
}
declare module laya.utils {
    /**
     * ...
     * @author laya
     */
    class Color {
        static _SAVE: any;
        static _SAVE_SIZE: number;
        _color: Array<any>;
        strColor: string;
        numColor: number;
        constructor(str: any);
        static _initDefault(): any;
        static _initSaveMap(): void;
        static create(str: any): Color;
    }
}
declare module laya.utils {
    /**
     * ...
     * @author laya
     */
    class Dictionary {
        constructor();
        elements: Array<any>;
        keys: Array<any>;
        set(key: any, value: any): void;
        indexOf(key: any): number;
        get(key: any): any;
        remove(key: any): boolean;
        clear(): void;
    }
}
declare module laya.utils {
    /**
     * 触摸滑动控件
     * @author yung
     */
    class Dragging {
        /**被拖动的对象*/
        target: laya.display.Sprite;
        /**缓动衰减系数*/
        ratio: number;
        /**单帧最大偏移量*/
        maxOffset: number;
        /**滑动范围*/
        area: laya.maths.Rectangle;
        /**拖动是否有惯性*/
        hasInertia: boolean;
        /**橡皮筋最大值*/
        elasticDistance: number;
        /**橡皮筋回弹时间，单位为毫秒*/
        elasticBackTime: number;
        /**事件携带数据*/
        data: any;
        start(target: laya.display.Sprite, area: laya.maths.Rectangle, hasInertia: boolean, elasticDistance: number, elasticBackTime: number, data: any, disableMouseEvent: boolean): void;
        stop(): void;
    }
}
declare module laya.utils {
    /**
     * Ease
     * @author yung
     */
    class Ease {
        static strongIn(t: number, b: number, c: number, d: number): number;
        static strongOut(t: number, b: number, c: number, d: number): number;
        static strongInOut(t: number, b: number, c: number, d: number): number;
        static sineIn(t: number, b: number, c: number, d: number): number;
        static sineOut(t: number, b: number, c: number, d: number): number;
        static sineInOut(t: number, b: number, c: number, d: number): number;
        static quintIn(t: number, b: number, c: number, d: number): number;
        static quintOut(t: number, b: number, c: number, d: number): number;
        static quintInOut(t: number, b: number, c: number, d: number): number;
        static quartIn(t: number, b: number, c: number, d: number): number;
        static quartOut(t: number, b: number, c: number, d: number): number;
        static quartInOut(t: number, b: number, c: number, d: number): number;
        static QuadIn(t: number, b: number, c: number, d: number): number;
        static QuadOut(t: number, b: number, c: number, d: number): number;
        static QuadInOut(t: number, b: number, c: number, d: number): number;
        static linearNone(t: number, b: number, c: number, d: number): number;
        static linearIn(t: number, b: number, c: number, d: number): number;
        static linearOut(t: number, b: number, c: number, d: number): number;
        static linearInOut(t: number, b: number, c: number, d: number): number;
        static expoIn(t: number, b: number, c: number, d: number): number;
        static expoOut(t: number, b: number, c: number, d: number): number;
        static expoInOut(t: number, b: number, c: number, d: number): number;
        static elasticIn(t: number, b: number, c: number, d: number, a?: number, p?: number): number;
        static elasticOut(t: number, b: number, c: number, d: number, a?: number, p?: number): number;
        static elasticInOut(t: number, b: number, c: number, d: number, a?: number, p?: number): number;
        static cubicIn(t: number, b: number, c: number, d: number): number;
        static cubicOut(t: number, b: number, c: number, d: number): number;
        static cubicInOut(t: number, b: number, c: number, d: number): number;
        static circIn(t: number, b: number, c: number, d: number): number;
        static circOut(t: number, b: number, c: number, d: number): number;
        static circInOut(t: number, b: number, c: number, d: number): number;
        static bounceOut(t: number, b: number, c: number, d: number): number;
        static bounceIn(t: number, b: number, c: number, d: number): number;
        static bounceInOut(t: number, b: number, c: number, d: number): number;
        static backIn(t: number, b: number, c: number, d: number, s?: number): number;
        static backOut(t: number, b: number, c: number, d: number, s?: number): number;
        static backInOut(t: number, b: number, c: number, d: number, s?: number): number;
    }
}
declare module laya.utils {
    /**
     * 处理器，推荐使用Handler.create()方法从对象池创建，减少对象创建消耗
     * 【注意】由于鼠标事件也用本对象池，不正确的回收及调用，可能会影响鼠标事件的执行
     * @author yung
     */
    class Handler {
        /**执行域(this)*/
        caller: any;
        /**处理方法*/
        method: Function;
        /**参数*/
        args: Array<any>;
        /**是否只执行一次，如果为true，回调后执行recover()进行回收，回收后会被再利用，默认为false*/
        once: boolean;
        constructor(caller?: any, method?: Function, args?: Array<any>, once?: boolean);
        /**
         * 设置处理器
         * @param    caller 执行域(this)
         * @param    method 回调方法
         * @param    args 携带的参数
         * @param    once 是否只执行一次，如果为true，执行后执行recover()进行回收
         * @return  返回handler本身
         */
        setTo(caller: any, method: Function, args: Array<any>, once: boolean): Handler;
        /**
         * 执行处理器
         */
        run(): void;
        /**
         * 执行处理器，携带额外数据
         * @param    data 附加的回调数据，可以是单数据或者Array(作为多参)
         */
        runWith(data: any): void;
        /**
         * 清理对象引用
         */
        clear(): Handler;
        /**
         * clear()并回收到Handler对象池内
         */
        recover(): void;
        /**
         * 从对象池内创建一个Handler，默认会执行一次回收，如果不需要自动回收，设置once参数为false
         * @param    caller 执行域(this)
         * @param    method 回调方法
         * @param    args 携带的参数
         * @param    once 是否只执行一次，如果为true，回调后执行recover()进行回收，默认为true
         * @return  返回创建的handler实例
         */
        static create(caller: any, method: Function, args?: Array<any>, once?: boolean): Handler;
    }
}
declare module laya.utils {
    /**
     * ...
     * @author laya
     */
    class HTMLChar implements laya.display.ILayout {
        isWord: boolean;
        char: string;
        charNum: number;
        style: laya.display.css.CSSStyle;
        constructor(char: string, w: number, h: number, style: laya.display.css.CSSStyle);
        setSprite(sprite: laya.display.Sprite): void;
        getSprite(): laya.display.Sprite;
        x: number;
        y: number;
        width: number;
        height: number;
        _isChar(): boolean;
        _getCSSStyle(): laya.display.css.CSSStyle;
    }
}
declare module laya.utils {
    /**
     * ...
     * @author laya
     */
    class LaterEvent {
        /**每帧回调最大超时时间*/
        static maxTimeOut: number;
        constructor();
        static add(caller: any, fun: Function, args: any, msg: string): void;
        static update(): void;
    }
    class LaterOneEvent {
        caller: any;
        fun: Function;
        args: any;
        msg: string;
    }
}
declare module laya.utils {
    /**
     * ...
     * @author laya
     */
    class Log {
        static start(): void;
        static print(value: string): void;
        static enable(): boolean;
    }
}
declare module laya.utils {
    /**
     * 对象池类
     * @author ww
     */
    class Pool {
        constructor();
        /**
         * 是否在对象池中的属性Key
         */
        static InPoolSign: string;
        /**
         * 将对象放回到池中
         * @param sign 对象类型标识
         * @param item 对象
         *
         */
        static recover(sign: string, item: any): void;
        /**
         * 根据对象类型标识获取对象
         * @param sign 对象类型标识
         * @param clz 当对象池中无对象是用于创建对象的类
         * @return
         *
         */
        static getItemByClass(sign: string, clz: any): any;
        /**
         * 根据对象类型标识获取对象
         * @param sign 对象类型标识
         * @param createFun 当对象池中无对象是用于创建对象的方法
         * @return
         *
         */
        static getItemByCreateFun(sign: string, createFun: Function): any;
        /**
         * 根据对象类型标识获取对象
         * @param sign 对象类型标识
         * @return 当对象池中无对象时返回null
         *
         */
        static getItem(sign: string): any;
    }
}
declare module laya.utils {
    /**
     * 帧率统计
     * @author yung
     */
    class Stat {
        static loopCount: number;
        static maxMemorySize: number;
        static currentMemorySize: number;
        static texturesMemSize: number;
        static buffersMemSize: number;
        static shaderCall: number;
        static drawCall: number;
        static trianglesFaces: number;
        static spriteDraw: number;
        static FPS: number;
        static canvasNormal: number;
        static canvasBitmap: number;
        static canvasReCache: number;
        static interval: number;
        static preFrameTime: number;
        static bufferLen: number;
        static renderSlow: boolean;
        static show(x?: number, y?: number): void;
        static hide(): void;
        static clear(): void;
        static onclick: Function;
        static loop(): void;
    }
}
declare module laya.utils {
    /**
     * ...
     * @author laya
     */
    class StringKey {
        add(str: string): number;
        get(str: string): number;
    }
}
declare module laya.utils {
    /**
     * 根据时间去创建一个合理的动画效果
     * @author ...
     */
    class TimeLine {
        /**缩放动画播放的速度*/
        scale: number;
        /**
         * 控制一个对象，从当前点移动到目标点
         * @param    target        要控制的对象
         * @param    props        要控制对象的属性
         * @param    duration    对象TWEEN的时间
         * @param    offset        相对于上一个对象，偏移多长时间（单位：毫秒）
         */
        to(target: any, props: any, duration: number, ease?: Function, offset?: number): void;
        /**
         * 从props属性，缓动到当前状态
         * @param    target        target 目标对象(即将更改属性值的对象)
         * @param    props        要控制对象的属性
         * @param    duration    对象TWEEN的时间
         * @param    offset        相对于上一个对象，偏移多长时间（单位：毫秒）
         */
        from(target: any, props: any, duration: number, ease?: Function, offset?: number): void;
        /**
         * 在时间队列中加入一个标签
         * @param    label    标签名称
         * @param    offset    标签相对于上个动画的偏移时间(单位：毫秒)
         */
        add(label: string, offset: number): void;
        /**
         * 动画从整个动画的某一时间开始
         * @param    time(单位：毫秒)
         */
        gotoTime(time: number): void;
        /**
         * 从指定的标签开始播
         * @param    Label
         */
        gotoLabel(Label: string): void;
        /**
         * 暂停整个动画
         */
        pause(): void;
        /**
         * 恢复暂停动画的播放
         */
        resume(): void;
        /**
         * 播放动画
         */
        play(timeOrLabel?: any, loop?: boolean): void;
        /**
         * 重置所有对象，复用对象的时候使用
         */
        reset(): void;
        /**
         * 彻底销毁
         */
        destory(): void;
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
     * 时钟管理类，单例，可以通过Laya.timer访问
     * @author yung
     */
    class Timer {
        /**时针缩放*/
        scale: number;
        /**当前时间*/
        currTimer: number;
        /**当前的帧数*/
        currFrame: number;
        static DELTA: number;
        constructor();
        _update(): void;
        _create(useFrame: boolean, repeat: boolean, delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行一次
         * @param    delay    延迟时间(单位毫秒)
         * @param    caller    执行域(this)
         * @param    method    定时器回调函数
         * @param    args    回调参数
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false
         */
        once(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时重复执行
         * @param    delay    间隔时间(单位毫秒)
         * @param    caller    执行域(this)
         * @param    method    定时器回调函数
         * @param    args    回调参数
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false
         */
        loop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时执行一次(基于帧率)
         * @param    delay    延迟几帧(单位为帧)
         * @param    caller    执行域(this)
         * @param    method    定时器回调函数
         * @param    args    回调参数
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false
         */
        frameOnce(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**
         * 定时重复执行(基于帧率)
         * @param    delay    间隔几帧(单位为帧)
         * @param    caller    执行域(this)
         * @param    method    定时器回调函数
         * @param    args    回调参数
         * @param    coverBefore    是否覆盖之前的延迟执行，默认为false
         */
        frameLoop(delay: number, caller: any, method: Function, args?: Array<any>, coverBefore?: boolean): void;
        /**输出统计信息*/
        toString(): string;
        /**
         * 清理定时器
         * @param    caller 执行域(this)
         * @param    method 定时器回调函数
         */
        clear(caller: any, method: Function): void;
        /**
         * 清理对象身上的所有定时器
         * @param    caller 执行域(this)
         */
        clearAll(caller: any): void;
        /**
         * 延迟执行
         * @param    caller 执行域(this)
         * @param    method 定时器回调函数
         * @param    args 回调参数
         */
        callLater(caller: any, method: Function, args?: Array<any>): void;
        /**
         * 立即执行callLater
         * @param    caller 执行域(this)
         * @param    method 定时器回调函数
         */
        runCallLater(caller: any, method: Function): void;
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
        run(widthClear: boolean): void;
    }
}
declare module laya.utils {
    /**
     * 缓动类
     * @author yung
     */
    class Tween {
        /**唯一标识，TimeLintLite用到*/
        gid: number;
        /**
         * 缓动对象的props属性到目标值
         * @param    target 目标对象(即将更改属性值的对象)
         * @param    props 变化的属性列表，比如
         * @param    duration 花费的时间，单位毫秒
         * @param    ease 缓动类型，默认为匀速运动
         * @param    complete 结束回调函数
         * @param    delay 延迟执行时间
         * @param    coverBefore 是否覆盖之前的缓动
         * @param    usePool 是否使用对象池，默认为true(启用对象池，当前tween会从对象池创建，并回收)
         * @return    返回Tween对象
         */
        static to(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean, usePool?: boolean): Tween;
        /**
         * 从props属性，缓动到当前状态
         * @param    target 目标对象(即将更改属性值的对象)
         * @param    props 变化的属性列表，比如
         * @param    duration 花费的时间，单位毫秒
         * @param    ease 缓动类型，默认为匀速运动
         * @param    complete 结束回调函数
         * @param    delay 延迟执行时间
         * @param    coverBefore 是否覆盖之前的缓动
         * @param    usePool 是否使用对象池，默认为true(启用对象池，当前tween会从对象池创建，并回收)
         * @return    返回Tween对象
         */
        static from(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean, usePool?: boolean): Tween;
        /**
         * 缓动对象的props属性到目标值
         * @param    target 目标对象(即将更改属性值的对象)
         * @param    props 变化的属性列表，比如
         * @param    duration 花费的时间，单位毫秒
         * @param    ease 缓动类型，默认为匀速运动
         * @param    complete 结束回调函数
         * @param    delay 延迟执行时间
         * @param    coverBefore 是否覆盖之前的缓动
         * @return    返回Tween对象
         */
        to(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean): Tween;
        /**
         * 从props属性，缓动到当前状态
         * @param    target 目标对象(即将更改属性值的对象)
         * @param    props 变化的属性列表，比如
         * @param    duration 花费的时间，单位毫秒
         * @param    ease 缓动类型，默认为匀速运动
         * @param    complete 结束回调函数
         * @param    delay 延迟执行时间
         * @param    coverBefore 是否覆盖之前的缓动
         * @return    返回Tween对象
         */
        from(target: any, props: any, duration: number, ease?: Function, complete?: Handler, delay?: number, coverBefore?: boolean): Tween;
        _create(target: any, props: any, duration: number, ease: Function, complete: Handler, delay: number, coverBefore: boolean, isTo: boolean, usePool: boolean, runNow: boolean): Tween;
        updateEase(time: number): void;
        /**
         * 立即结束缓动并到终点
         */
        complete(): void;
        /**
         * 暂停缓动，可以通过resume或restart重新开始
         */
        pause(): void;
        /**
         * 设置开始时间
         * @param    startTime
         */
        setStartTime(startTime: number): void;
        /**
         * 清理target对象身上的所有缓动
         * @param    target 目标对象
         */
        static clearAll(target: any): void;
        /**
         * 清理某个缓动
         * @param    tween 缓动对象
         */
        static clear(tween: Tween): void;
        /**同clearAll，废弃掉，尽量别用*/
        static clearTween(target: any): void;
        /**
         * 停止并清理当前缓动
         */
        clear(): void;
        _clear(): void;
        /**
         * 重新开始暂停的缓动
         */
        restart(): void;
        /**
         * 恢复暂停的缓动
         */
        resume(): void;
    }
}
declare module laya.utils {
    /**
     * 工具类
     * @author yung
     */
    class Utils {
        /**
         * 角度转弧度
         * @param    angle 角度值
         * @return    返回弧度值
         */
        static toRadian(angle: number): number;
        /**
         * 弧度转换为角度
         * @param    radian 弧度值
         * @return    返回角度值
         */
        static toAngle(radian: number): number;
        /**
         * 转换uint类型颜色值为字符串。
         * @param color 颜色值。
         * @return
         */
        static toHexColor(color: number): string;
        /**获取全局唯一ID*/
        static getGID(): number;
        /**
         * 将字符串解析成XML
         * @param value 要解析的字符串
         * @return js原生的XML对象
         */
        static parseXMLFromString(value: string): any;
        /**
         * 补齐数字，比如num=1，len=3，会返回001
         * @param    num 数字
         * @param    strLen 要返回的字符串长度
         * @return    返回一个字符串
         */
        static preFixNumber(num: number, strLen: number): string;
        static concatArr(src: Array<any>, a: Array<any>): Array<any>;
        static clearArr(arr: Array<any>): Array<any>;
        static setValueArr(src: Array<any>, v: Array<any>): Array<any>;
        static getFrom(rst: Array<any>, src: Array<any>, count: number): Array<any>;
        static getFromR(rst: Array<any>, src: Array<any>, count: number): Array<any>;
        static getGlobalRec(sprite: laya.display.Sprite): laya.maths.Rectangle;
        static getGlobalRecByPoints(sprite: laya.display.Sprite, x0: number, y0: number, x1: number, y1: number): laya.maths.Rectangle;
        static getGlobalPosAndScale(sprite: laya.display.Sprite): laya.maths.Rectangle;
        static enableDisplayTree(dis: laya.display.Sprite): void;
        static bind(fun: Function, _scope: any): Function;
        static copyFunction(src: any, dec: any, permitOverrides: boolean): void;
        static measureText(txt: string, font: string): any;
        static regClass(className: string, fullClassName: string): void;
        static New(className: string): any;
        static updateOrder(childs: Array<any>): boolean;
        static _attachAllClassTimeDelay: number;
        /**
         * 检查函数的调用延时，
         * @param    timeout:显示大于此值的函数调用
         * @param    exclude:排除此数组里面类下所有函数
         */
        static attachAllClassTimeDelay(timeout: number, exclude: Array<any>): void;
        static attachClassTimeDelay(_class: any, className: string, timeout: number): void;
    }
}
declare module laya.webgl.atlas {
    class Atlas extends AtlasGrid {
        texture: AtlasWebGLTexture;
        webGLImages: Array<any>;
        constructor(gridNumX: number, gridNumY: number, width: number, height: number, atlasID: number);
        /**
         *
         * @param    inAtlasRes
         * @return  是否已经存在队列中
         */
        addToAtlasTexture(bitmap: any, offsetX: number, offsetY: number): void;
        addToAtlas(inAtlasRes: laya.resource.Texture): void;
        clear(): void;
        destroy(): void;
    }
}
declare module laya.webgl.atlas {
    class Atlaser extends AtlasGrid {
        texture: AtlasWebGLCanvas;
        webGLImages: Array<any>;
        constructor(gridNumX: number, gridNumY: number, width: number, height: number, atlasID: number);
        /**
         *
         * @param    inAtlasRes
         * @return  是否已经存在队列中
         */
        addToAtlasTexture(bitmap: any, offsetX: number, offsetY: number): void;
        addToAtlas(inAtlasRes: laya.resource.Texture): void;
        clear(): void;
        destroy(): void;
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
    class TexMergeCellInfo {
        type: number;
        successionWidth: number;
        successionHeight: number;
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
    class AtlasManager {
        static atlasTextureWidth: number;
        static atlasTextureHeight: number;
        static gridSize: number;
        static maxTextureCount: number;
        static BOARDER_TYPE_NO: number;
        static BOARDER_TYPE_RIGHT: number;
        static BOARDER_TYPE_LEFT: number;
        static BOARDER_TYPE_BOTTOM: number;
        static BOARDER_TYPE_TOP: number;
        static BOARDER_TYPE_ALL: number;
        static instance: AtlasManager;
        static enabled: boolean;
        static atlasLimitWidth: number;
        static atlasLimitHeight: number;
        static enable(): void;
        static __init__(): void;
        constructor(width: number, height: number, gridSize: number, maxTexNum: number);
        Initialize(): boolean;
        setAtlasParam(width: number, height: number, gridSize: number, maxTexNum: number): boolean;
        pushData(texture: laya.resource.Texture): boolean;
        addToAtlas(tex: laya.resource.Texture): void;
        /**
         * 回收大图合集,不建议手动调用
         * @return
         */
        garbageCollection(): boolean;
        freeAll(): void;
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
        protected recreateResource(): void;
        protected detoryResource(): void;
        /**采样image到WebGLTexture的一部分*/
        texSubImage2D(source: AtlasWebGLCanvas, xoffset: number, yoffset: number, bitmap: any): void;
        /**采样image到WebGLTexture的一部分*/
        texSubImage2DPixel(source: AtlasWebGLCanvas, xoffset: number, yoffset: number, width: number, height: number, pixel: any): void;
    }
}
declare module laya.webgl.atlas {
    class AtlasWebGLTexture extends laya.resource.Bitmap {
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
        protected recreateResource(): void;
        protected detoryResource(): void;
        /**采样image到WebGLTexture的一部分*/
        texSubImage2D(source: AtlasWebGLTexture, xoffset: number, yoffset: number, bitmap: any): void;
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
        static NAMES: Array<any>;
        static TOINT: any;
        static NORMAL: string;
        static ADD: string;
        static MULTIPLY: string;
        static SCREEN: string;
        static LIGHT: string;
        static OVERLAY: string;
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
    }
}
declare module laya.webgl.canvas {
    /**
     * ...
     * @author laya
     */
    class DrawStyle {
        static DEFAULT: DrawStyle;
        _color: laya.utils.Color;
        constructor(value: any);
        setValue(value: any): void;
        reset(): void;
        equal(value: any): boolean;
        toColorStr(): string;
    }
}
declare module laya.webgl.canvas {
    /**
     * ...
     * @author laya
     */
    class Path {
        _x: number;
        _y: number;
        _rect: laya.maths.Rectangle;
        ib: laya.webgl.utils.Buffer;
        vb: laya.webgl.utils.Buffer;
        dirty: boolean;
        geomatrys: Array<any>;
        _curGeomatry: laya.webgl.shapes.IShape;
        offset: number;
        count: number;
        constructor();
        clear(): void;
        rect2(x: number, y: number, w: number, h: number, color: number, borderWidth?: number, borderColor?: number): void;
        rect(x: number, y: number, width: number, height: number): void;
        strokeRect(x: number, y: number, width: number, height: number): void;
        circle(x: number, y: number, r: number, color: number, borderWidth: number, borderColor: number, fill: boolean): void;
        fan(x: number, y: number, r: number, r0: number, r1: number, color: number, borderWidth: number, borderColor: number): void;
        ellipse(x: number, y: number, rw: number, rh: number, color: number, borderWidth: number, borderColor: number): void;
        polygon(x: number, y: number, r: number, edges: number, color: number, borderWidth: number, borderColor: any): void;
        drawPath(x: number, y: number, points: Array<any>, color: number, borderWidth: number): void;
        update(): void;
        sector(x: number, y: number, rW: number, rH: number): void;
        roundRect(x: number, y: number, w: number, h: number, rW: number, rH: number): void;
        reset(): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    interface ISaveData {
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
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
        static _createArray(): Array<any>;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D, type: number, dataObj: any, newSubmit: boolean): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveClipRect implements ISaveData {
        _clipSaveRect: laya.maths.Rectangle;
        _clipRect: laya.maths.Rectangle;
        _submitScissor: laya.webgl.submit.SubmitScissor;
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D, submitScissor: laya.webgl.submit.SubmitScissor): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveFont implements ISaveData {
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveIBVB implements ISaveData {
        _ib: laya.webgl.utils.Buffer;
        _vb: laya.webgl.utils.Buffer;
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveMark implements ISaveData {
        _saveuse: number;
        _preSaveMark: SaveMark;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static Create(context: laya.webgl.canvas.WebGLContext2D): SaveMark;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveShader implements ISaveData {
        _preShader: laya.webgl.shader.Shader;
        _type: string;
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D, shader: laya.webgl.shader.Shader, type: string): void;
        getData(ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, start: number): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveTransform implements ISaveData {
        _savematrix: laya.maths.Matrix;
        _matrix: laya.maths.Matrix;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D): void;
    }
}
declare module laya.webgl.canvas.save {
    /**
     * ...
     * @author laya
     */
    class SaveTranslate implements ISaveData {
        _x: number;
        _y: number;
        constructor();
        isSaveMark(): boolean;
        restore(context: laya.webgl.canvas.WebGLContext2D): void;
        static save(context: laya.webgl.canvas.WebGLContext2D): void;
    }
}
declare module laya.webgl.canvas {
    /**
     * ...
     * @author laya
     */
    class WebGLContext2D extends laya.resource.Context {
        static _SUBMITVBSIZE: number;
        static _MAXSIZE: number;
        static _RECTVBSIZE: number;
        static MAXCLIPRECT: laya.maths.Rectangle;
        static _COUNT: number;
        static _tmpMatrix: laya.maths.Matrix;
        static __init__(): void;
        _x: number;
        _y: number;
        _id: number;
        _submits: any;
        _mergeID: number;
        _curSubmit: any;
        _ib: laya.webgl.utils.Buffer;
        _vb: laya.webgl.utils.Buffer;
        _clipRect: laya.maths.Rectangle;
        _curMat: laya.maths.Matrix;
        _nBlendType: number;
        _save: any;
        _targets: laya.webgl.resource.RenderTargetMAX;
        _saveMark: laya.webgl.canvas.save.SaveMark;
        _shader2D: laya.webgl.shader.d2.Shader2D;
        constructor(c: laya.resource.HTMLCanvas);
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
        enableMerge: boolean;
        textBaseline: string;
        globalCompositeOperation: string;
        strokeStyle: any;
        translate(x: number, y: number): void;
        lineWidth: number;
        save(): void;
        restore(): void;
        measureText(text: string): any;
        font: string;
        fillWords(words: Array<any>, x: number, y: number, fontStr: string, color: string): void;
        fillText(txt: string, x: number, y: number, fontStr: string, color: string, textAlign: string): void;
        strokeText(txt: string, x: number, y: number, fontStr: string, color: string, lineWidth: number, textAlign: string): void;
        fillBorderText(txt: string, x: number, y: number, fontStr: string, fillColor: string, borderColor: string, lineWidth: number, textAlign: string): void;
        fillRect(x: number, y: number, width: number, height: number, fillStyle: any): void;
        setShader(shader: laya.webgl.shader.Shader): void;
        setFilters(value: Array<any>): void;
        /**
         * 请保证图片已经在内存
         * @param    ... args
         */
        drawImage(...args: any[]): void;
        _drawText(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, m: laya.maths.Matrix, tx: number, ty: number, dx: number, dy: number): void;
        drawTextureWithTransform(tex: laya.resource.Texture, x: number, y: number, width: number, height: number, transform: laya.maths.Matrix, tx: number, ty: number): void;
        fillQuadrangle(tex: laya.resource.Texture, x: number, y: number, point4: Array<any>, m: laya.maths.Matrix): void;
        drawTexture2(x: number, y: number, pivotX: number, pivotY: number, transform: laya.maths.Matrix, alpha: number, blendMode: string, args: Array<any>): void;
        drawCanvas(canvas: laya.resource.HTMLCanvas, x: number, y: number, width: number, height: number): void;
        transform(a: number, b: number, c: number, d: number, tx: number, ty: number): void;
        setTransformByMatrix(value: laya.maths.Matrix): void;
        transformByMatrix(value: laya.maths.Matrix): void;
        rotate(angle: number): void;
        scale(scaleX: number, scaleY: number): void;
        clipRect(x: number, y: number, width: number, height: number): void;
        setIBVB(x: number, y: number, ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, numElement: number, mat: laya.maths.Matrix, shader: laya.webgl.shader.Shader, shaderValues: laya.webgl.shader.d2.value.Value2D, startIndex?: number, offset?: number): void;
        addRenderObject(o: laya.webgl.submit.ISubmit): void;
        fillTrangles(tex: laya.resource.Texture, x: number, y: number, points: Array<any>, m: laya.maths.Matrix): void;
        arc(x: number, y: number, r: number, sAngle: number, eAngle: number, counterclockwise?: boolean): void;
        fill(): void;
        closePath(): void;
        beginPath(): void;
        rect(x: number, y: number, width: number, height: number): void;
        strokeRect(x: number, y: number, width: number, height: number, lineWidth?: number): void;
        clip(): void;
        stroke(): void;
        moveTo(x: number, y: number): void;
        lineTo(x: number, y: number): void;
        line(fromX: number, fromY: number, toX: number, toY: number, lineWidth: number, mat: laya.maths.Matrix): void;
        submitElement(start: number, end: number): void;
        finish(): void;
        flush(): number;
        fan(x: number, y: number, r: number, sAngle: number, eAngle: number, fillColor: number, lineColor: number): void;
        drawPoly(x: number, y: number, r: number, edges: number, boderColor: number, lineWidth: number, color: number): void;
        drawPath(x: number, y: number, points: Array<any>, color: number, lineWidth: number): void;
        drawParticle(x: number, y: number, pt: any): void;
        drawLines(x: number, y: number, points: Array<any>, color: number, lineWidth: number): void;
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
        setIBVB(x: number, y: number, ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, numElement: number, shader: laya.webgl.shader.Shader): void;
        drawParticle(x: number, y: number, ps: any): void;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author
     */
    class GLRenderTargetCube {
        constructor();
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author laya
     */
    class RenderTarget2D extends laya.resource.Texture implements laya.resource.IDispose {
        static TYPE2D: number;
        static TYPE3D: number;
        surfaceFormat: number;
        surfaceType: number;
        depthFormat: number;
        mipMap: boolean;
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
        constructor(width: number, height: number, mipMap: boolean, surfaceFormat: number, surfaceType: number, depthFormat: number);
        getType(): number;
        getTexture(): laya.resource.Texture;
        size(w: number, h: number): void;
        release(): void;
        recycle(): void;
        static create(w: number, h: number, type?: number): RenderTarget2D;
        start(): RenderTarget2D;
        clear(r?: number, g?: number, b?: number, a?: number): void;
        end(): void;
        getData(x: number, y: number, width: number, height: number): Uint8Array;
        /**彻底清理资源,注意会强制解锁清理*/
        destroy(): void;
        dispose(): void;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author laya
     */
    class RenderTargetMAX {
        targets: Array<any>;
        oneTargets: OneTarget;
        repaint: boolean;
        _width: number;
        _height: number;
        constructor();
        size(w: number, h: number): void;
        flush(context: laya.webgl.canvas.WebGLContext2D): void;
        drawTo(context: laya.webgl.canvas.WebGLContext2D, x: number, y: number, width: number, height: number): void;
        destroy(): void;
    }
    class OneTarget {
        x: number;
        y: number;
        width: number;
        height: number;
        target: laya.webgl.resource.RenderTarget2D;
        OneTarget(w: number, h: number): any;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author
     */
    class WebGLCanvas extends laya.resource.Bitmap {
        static _createContext: Function;
        /***是否创建WebGLTexture,值为false时不根据src创建私有WebGLTexture,同时销毁时也只清空source=null,不调用WebGL.mainContext.deleteTexture，目前只有大图合集用到,将HTML Image subImage到公共纹理上*/
        createOwnSource: boolean;
        /**
         * 返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
         * @param HTML Image
         */
        canvas: any;
        constructor(type: string);
        clear(): void;
        destroy(): void;
        context: laya.resource.Context;
        _setContext(context: laya.resource.Context): void;
        getContext(contextID: string, other?: any): laya.resource.Context;
        copyTo(dec: laya.resource.Bitmap): void;
        size(w: number, h: number): void;
        asBitmap: boolean;
        protected recreateResource(): void;
        protected detoryResource(): void;
        texSubImage2D(webglCanvas: WebGLCanvas, xoffset: number, yoffset: number): void;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author
     */
    class WebGLCharImage extends laya.resource.Bitmap {
        /**HTML Canvas，绘制字符载体,非私有数据载体*/
        canvas: any;
        /**字符*/
        char: laya.webgl.text.DrawTextChar;
        /***是否创建WebGLTexture,值为false时不根据src创建私有WebGLTexture,同时销毁时也只清空source=null,不调用WebGL.mainContext.deleteTexture，目前只有大图合集用到,将HTML Image subImage到公共纹理上*/
        createOwnSource: boolean;
        /**
         * WebGLCharImage依赖于外部canvas,自身并无私有数据载体
         * @param    canvas
         * @param    char
         */
        constructor(canvas: any, char?: laya.webgl.text.DrawTextChar);
        protected recreateResource(): void;
        copyTo(dec: laya.resource.Bitmap): void;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author
     */
    class WebGLImage extends laya.resource.FileBitmap {
        /**是否使用重复模式纹理寻址*/
        repeat: boolean;
        /**是否使用mipLevel*/
        mipmap: boolean;
        /**缩小过滤器*/
        minFifter: number;
        /**放大过滤器*/
        magFifter: number;
        /***是否创建WebGLTexture,值为false时不根据src创建私有WebGLTexture,同时销毁时也只清空source=null,不调用WebGL.mainContext.deleteTexture，目前只有大图合集用到,将HTML Image subImage到公共纹理上*/
        createOwnSource: boolean;
        /**
         * 返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
         * @param HTML Image
         */
        image: any;
        /**
         * 设置文件路径全名
         * @param 文件路径全名
         */
        src: string;
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
        constructor(im?: any);
        protected recreateResource(): void;
        /***复制资源,此方法为浅复制*/
        copyTo(dec: laya.resource.Bitmap): void;
        protected detoryResource(): void;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author laya
     */
    class WebGLRenderTarget extends laya.resource.Bitmap {
        frameBuffer: any;
        depthBuffer: any;
        constructor(width: number, height: number, mipMap?: boolean, surfaceFormat?: number, surfaceType?: number, depthFormat?: number);
        protected recreateResource(): void;
        protected detoryResource(): void;
    }
}
declare module laya.webgl.resource {
    /**
     * ...
     * @author
     */
    class WebGLSubImage extends laya.resource.Bitmap {
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
        /***是否创建WebGLTexture,值为false时不根据src创建私有WebGLTexture,同时销毁时也只清空source=null,不调用WebGL.mainContext.deleteTexture，目前只有大图合集用到,将HTML Image subImage到公共纹理上*/
        createOwnSource: boolean;
        atlasImage: any;
        offsetX: number;
        offsetY: number;
        src: string;
        constructor(canvas: any, offsetX: number, offsetY: number, width: number, height: number, atlasImage: any, src: string, createOwnSource?: boolean);
        copyTo(dec: laya.resource.Bitmap): void;
        protected recreateResource(): void;
        protected detoryResource(): void;
    }
}
declare module laya.webgl.shader.d2.filters {
    /**
     * @author wk
     */
    class ColorFilter extends laya.webgl.shader.Shader {
        constructor();
    }
}
declare module laya.webgl.shader.d2.filters {
    /**
     * @author wk
     */
    class GlowFilterShader extends laya.webgl.shader.Shader {
        constructor();
    }
}
declare module laya.webgl.shader.d2 {
    class Shader2D {
        ALPHA: number;
        glTexture: laya.webgl.resource.WebGLImage;
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
    /**
     * ...
     * @author laya
     */
    class Shader2X extends laya.webgl.shader.Shader {
        _params2dQuick1: Array<any>;
        _params2dQuick2: Array<any>;
        _shaderValueWidth: number;
        _shaderValueHeight: number;
        _shaderValueAlpha: number;
        constructor(vs: string, ps: string, saveName?: any, nameMap?: any);
        upload2dQuick1(shaderValue: laya.webgl.shader.ShaderValue): void;
        _make2dQuick1(): Array<any>;
        upload2dQuick2(shaderValue: laya.webgl.shader.ShaderValue): void;
        _make2dQuick2(): Array<any>;
        static create(vs: string, ps: string, saveName?: any, nameMap?: any): laya.webgl.shader.Shader;
    }
}
declare module laya.webgl.shader.d2 {
    /**
     * ...
     * @author laya
     */
    class ShaderDefines2D extends laya.webgl.shader.ShaderDefines {
        static TEXTURE2D: number;
        static COLOR2D: number;
        static PRIMITIVE: number;
        static FILTERGLOW: number;
        static FILTERBLUR: number;
        static FILTERCOLOR: number;
        static COLORADD: number;
        static __init__(): void;
        constructor();
        static reg(name: string, value: number): void;
        static toText(value: number, _int2name: Array<any>, _int2nameMap: any): any;
        static toInt(names: string): number;
    }
}
declare module laya.webgl.shader.d2.value {
    class Color2dSV extends Value2D {
        constructor();
        setValue(value: laya.webgl.shader.d2.Shader2D): void;
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
        constructor();
        setValue(vo: laya.webgl.shader.d2.Shader2D): void;
        clear(): void;
    }
}
declare module laya.webgl.shader.d2.value {
    class PrimitiveSV extends Value2D {
        a_color: Array<any>;
        constructor();
    }
}
declare module laya.webgl.shader.d2.value {
    class TextSV extends TextureSV {
        static pool: Array<any>;
        constructor();
        release(): void;
        clear(): void;
        static create(): TextSV;
    }
}
declare module laya.webgl.shader.d2.value {
    class TextureSV extends Value2D {
        texcoord: Array<any>;
        u_colorMatrix: Array<any>;
        constructor(subID?: number);
        setValue(vo: laya.webgl.shader.d2.Shader2D): void;
        clear(): void;
    }
}
declare module laya.webgl.shader.d2.value {
    /**
     * ...
     * @author laya
     */
    class Value2D extends laya.webgl.shader.ShaderValue {
        static _POSITION: Array<any>;
        static _TEXCOORD: Array<any>;
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
        textureHost: any;
        texture: any;
        fillStyle: laya.webgl.canvas.DrawStyle;
        color: Array<any>;
        strokeStyle: laya.webgl.canvas.DrawStyle;
        colorAdd: Array<any>;
        glTexture: laya.resource.Bitmap;
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
    /**
     * ...
     * @author laya
     */
    class Shader {
        static SHADERNAME2ID: number;
        static activeShader: Shader;
        static nameKey: laya.utils.StringKey;
        static sharders: Array<any>;
        static getShader(name: any): Shader;
        static create(vs: string, ps: string, saveName?: any, nameMap?: any): Shader;
        tag: any;
        _program: any;
        _params: Array<any>;
        _paramsMap: any;
        _offset: number;
        _id: number;
        /**
         * 根据vs和ps信息生成shader对象
         * @param    vs
         * @param    ps
         * @param    name:
         * @param    nameMap 帮助里要详细解释为什么需要nameMap
         */
        constructor(vs: string, ps: string, saveName?: any, nameMap?: any);
        compile(): void;
        /**
         * 根据变量名字获得
         * @param    name
         * @return
         */
        getUniform(name: string): any;
        uploadOne(name: string, value: any): void;
        /**
         * 提交shader到GPU
         * @param    shaderValue
         */
        upload(shaderValue: ShaderValue, params?: Array<any>): void;
        /**
         * 按数组的定义提交
         * @param    shaderValue 数组格式[name,[value,id],...]
         */
        uploadArray(shaderValue: Array<any>, length: number, _bufferUsage: any): void;
        /**
         * 得到编译后的变量及相关预定义
         * @return
         */
        getParams(): Array<any>;
        static addInclude(fileName: string, txt: string): void;
        /**
         * 预编译shader文件，主要是处理宏定义
         * @param    nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
         * @param    vs
         * @param    ps
         */
        static preCompile(nameID: number, mainID: number, vs: string, ps: string, nameMap: any): void;
        /**
         * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
         * @param    name
         * @param    vs
         * @param    ps
         * @param    define 宏定义，格式:
         * @return
         */
        static withCompile(nameID: number, mainID: number, define: any, shaderName: any, createShader: Function): Shader;
        protected preCompile(vs: string, ps: string): any;
    }
}
declare module laya.webgl.shader {
    /**
     * ...
     * @author laya
     */
    class ShaderDefines {
        _value: number;
        constructor(name2int: any, int2name: Array<any>, int2nameMap: Array<any>);
        add(value: any): number;
        addInt(value: number): number;
        remove(value: any): number;
        isDefine(def: number): boolean;
        getValue(): number;
        setValue(value: number): void;
        toString(): string;
        static _reg(name: string, value: number, _name2int: any, _int2name: Array<any>): void;
        static _toText(value: number, _int2name: Array<any>, _int2nameMap: any): any;
        static _toInt(names: string, _name2int: any): number;
    }
}
declare module laya.webgl.shader {
    /**
     * ...
     * @author laya
     */
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
        constructor(x: number, y: number, width: number, height: number, edges: number, color: number, borderWidth: number, borderColor: number, round?: number);
        getData(ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, start: number): void;
        protected circle(outVert: Array<any>, outIndex: Array<any>, start: number): void;
        protected sector(outVert: Array<any>, outIndex: Array<any>, start: number): void;
        protected createFanLine(p: Array<any>, indices: Array<any>, lineWidth: number, len: number, outVertex: Array<any>, outIndex: Array<any>): Array<any>;
        protected createLine2(p: Array<any>, indices: Array<any>, lineWidth: number, len: number, outVertex: Array<any>, indexCount: number): Array<any>;
    }
}
declare module laya.webgl.shapes {
    class Circle extends BasePoly {
        constructor(x: number, y: number, r: number, color: number, borderWidth: number, borderColor: number, fill: boolean);
    }
}
declare module laya.webgl.shapes {
    class Ellipse extends BasePoly {
        constructor(x: number, y: number, width: number, height: number, color: number, borderWidth: number, borderColor: number);
    }
}
declare module laya.webgl.shapes {
    class Fan extends BasePoly {
        constructor(x: number, y: number, r: number, r0: number, r1: number, color: number, borderWidth: number, borderColor: number, round?: number);
        getData(ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, start: number): void;
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
        constructor(x: number, y: number, points: Array<any>, color: number, borderWidth: number);
        getData(ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, start: number): void;
    }
}
declare module laya.webgl.shapes {
    class Polygon extends BasePoly {
        constructor(x: number, y: number, r: number, edges: number, color: number, borderWidth: number, borderColor: number);
    }
}
declare module laya.webgl.shapes {
    class Rect extends BasePoly {
        constructor(x: number, y: number, width: number, height: number, color: number, borderWidth: number, borderColor: number);
    }
}
declare module laya.webgl.shapes {
    class RoundPolygon extends BasePoly {
        constructor(x: number, y: number, width: number, height: number, edges: number, color: number, borderWidth: number, borderColor: number, round: number);
    }
}
declare module laya.webgl.shapes {
    class Vertex implements IShape {
        points: Float32Array;
        constructor(p: any);
        getData(ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, start: number): void;
    }
}
declare module laya.webgl.submit {
    /**
     * ...
     * @author laya
     */
    interface ISubmit {
    }
}
declare module laya.webgl.submit {
    /**
     * ...
     * @author River
     */
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
        static RENDERBASE: Submit;
        static activeBlendFunction: Function;
        static _cache: Array<any>;
        _vb: laya.webgl.utils.Buffer;
        _startIdx: number;
        _numEle: number;
        _submitID: number;
        _mergID: number;
        shaderValue: laya.webgl.shader.d2.value.Value2D;
        static __init__(): void;
        constructor(renderType?: number);
        releaseRender(): void;
        getRenderType(): number;
        renderSubmit(): number;
        static create(context: laya.webgl.canvas.WebGLContext2D, submitID: number, mergID: number, ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, pos: number, sv: laya.webgl.shader.d2.value.Value2D): Submit;
        static createShape(ctx: laya.webgl.canvas.WebGLContext2D, ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, numEle: number, offset: number, sv: laya.webgl.shader.d2.value.Value2D): Submit;
    }
}
declare module laya.webgl.submit {
    /**
     * ...
     * @author wk
     */
    class SubmitCanvas extends Submit {
        _matrix: laya.maths.Matrix;
        _ctx_src: laya.webgl.canvas.WebGLContext2D;
        _alpha: number;
        _matrix4: Array<any>;
        _filters: Array<any>;
        _shaderDefines: laya.webgl.shader.ShaderDefines;
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
    /**
     * ...
     * @author wk
     */
    class SubmitOtherIBVB implements laya.webgl.submit.ISubmit {
        static create(context: laya.webgl.canvas.WebGLContext2D, vb: laya.webgl.utils.Buffer, ib: laya.webgl.utils.Buffer, numElement: number, shader: laya.webgl.shader.Shader, shaderValue: laya.webgl.shader.d2.value.Value2D, startIndex: number, offset: number): SubmitOtherIBVB;
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
        constructor();
        renderSubmit(): number;
        getRenderType(): number;
        releaseRender(): void;
        static create(step: number): SubmitStencil;
    }
}
declare module laya.webgl.submit {
    class SubmitTarget implements laya.webgl.submit.ISubmit {
        _startIdx: number;
        _numEle: number;
        shaderValue: laya.webgl.shader.d2.value.Value2D;
        blendType: number;
        static activeBlendType: number;
        proName: string;
        scope: SubmitCMDScope;
        constructor();
        static _cache: Array<any>;
        renderSubmit(): number;
        blend(): void;
        getRenderType(): number;
        releaseRender(): void;
        static create(context: laya.webgl.canvas.WebGLContext2D, ib: laya.webgl.utils.Buffer, vb: laya.webgl.utils.Buffer, pos: number, sv: laya.webgl.shader.d2.value.Value2D, proName: string): SubmitTarget;
    }
}
declare module laya.webgl.text {
    /**
     * ...
     * @author ...
     */
    class CharValue {
        txtID: number;
        font: any;
        fillColor: string;
        borderColor: string;
        lineWidth: number;
        size: number;
        scaleX: number;
        scaleY: number;
        value(font: any, fillColor: string, borderColor: string, lineWidth: number, size: number, scaleX: number, scaleY: number): void;
    }
}
declare module laya.webgl.text {
    /**
     * ...
     * @author laya
     */
    class DrawText {
        static _drawValue: CharValue;
        static getChar(char: string, id: number, drawValue: CharValue): DrawTextChar;
        static drawText(ctx: laya.webgl.canvas.WebGLContext2D, txt: string, words: Array<any>, curMat: laya.maths.Matrix, font: FontInContext, textAlign: string, fillColor: string, borderColor: string, lineWidth: number, x: number, y: number): void;
    }
}
declare module laya.webgl.text {
    /**
     * ...
     * @author ...
     */
    class DrawTextChar {
        xs: number;
        ys: number;
        width: number;
        height: number;
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
        constructor(content: string, drawValue: CharValue);
        active(): void;
        static createOneChar(content: string, drawValue: CharValue): DrawTextChar;
    }
}
declare module laya.webgl.text {
    /**
     * ...
     * @author laya
     */
    class FontInContext {
        static EMPTY: FontInContext;
        constructor(font?: string);
        setFont(value: string): void;
        size: number;
        hasType(name: string): number;
        removeType(name: string): void;
        copyTo(dec: FontInContext): FontInContext;
        toString(): string;
    }
}
declare module laya.webgl.utils {
    /**
     * ...
     * @author laya
     */
    class Buffer extends laya.resource.Resource {
        static INDEX: string;
        static POSITION0: string;
        static NORMAL0: string;
        static COLOR0: string;
        static UV0: string;
        static NEXTUV0: string;
        static UV1: string;
        static NEXTUV1: string;
        static BLENDWEIGHT0: string;
        static BLENDINDICES0: string;
        static MATRIX0: string;
        static MATRIX1: string;
        static MATRIX2: string;
        static DIFFUSETEXTURE: string;
        static NORMALTEXTURE: string;
        static SPECULARTEXTURE: string;
        static EMISSIVETEXTURE: string;
        static AMBIENTTEXTURE: string;
        static REFLECTTEXTURE: string;
        static MATRIXARRAY0: string;
        static FLOAT0: string;
        static UVAGEX: string;
        static CAMERAPOS: string;
        static LUMINANCE: string;
        static ALPHATESTVALUE: string;
        static FOGCOLOR: string;
        static FOGSTART: string;
        static FOGRANGE: string;
        static MATERIALAMBIENT: string;
        static MATERIALDIFFUSE: string;
        static MATERIALSPECULAR: string;
        static LIGHTDIRECTION: string;
        static LIGHTDIRDIFFUSE: string;
        static LIGHTDIRAMBIENT: string;
        static LIGHTDIRSPECULAR: string;
        static POINTLIGHTPOS: string;
        static POINTLIGHTRANGE: string;
        static POINTLIGHTATTENUATION: string;
        static POINTLIGHTDIFFUSE: string;
        static POINTLIGHTAMBIENT: string;
        static POINTLIGHTSPECULAR: string;
        static SPOTLIGHTPOS: string;
        static SPOTLIGHTDIRECTION: string;
        static SPOTLIGHTSPOT: string;
        static SPOTLIGHTRANGE: string;
        static SPOTLIGHTATTENUATION: string;
        static SPOTLIGHTDIFFUSE: string;
        static SPOTLIGHTAMBIENT: string;
        static SPOTLIGHTSPECULAR: string;
        static CORNERTEXTURECOORDINATE: string;
        static VELOCITY: string;
        static SIZEROTATION: string;
        static RADIUSRADIAN: string;
        static AGEADDSCALE: string;
        static TIME: string;
        static VIEWPORTSCALE: string;
        static CURRENTTIME: string;
        static DURATION: string;
        static GRAVITY: string;
        static ENDVELOCITY: string;
        static FLOAT32: number;
        static SHORT: number;
        static QuadrangleIB: Buffer;
        static __int__(gl: laya.webgl.WebGLContext): void;
        _length: number;
        _upload: boolean;
        /**
         *
         * @param    glTarget    缓冲区类型
         * @param    usage    如果指定glType为ELEMENT_ARRAY_BUFFER 后 usage会被设置为 INDEX;  多buffr 时候 要对应Shader的别名
         * @param    frome    数据
         * @param    bufferUsage  可以使设置为 gl.STATIC_DRAW   gl.DYNAMIC_DRAW
         *  example
         *  多Buffer usage
         *  public static var bVertex:Buffer = new Buffer(Buffer.ARRAY_BUFFER,Buffer.POSITION,vertices);
         *    public static var bColors:Buffer = new Buffer(Buffer.ARRAY_BUFFER,Buffer.COLOR, colors);
         *    public static var bIndices:Buffer = new Buffer(Buffer.ELEMENT_ARRAY_BUFFER, Buffer.INDEX, indices);
         *    example
         *  var _gib = gl.createBuffer();
         *  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, _gib);
         *  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, 9000 * bytesPerElement, gl.STATIC_DRAW);
         */
        Buffer(glTarget: any, usage?: string, frome?: any, bufferUsage?: number): any;
        getFloat32Array(): Float32Array;
        getUint16Array(): Uint16Array;
        clear(): void;
        append(data: any): void;
        setdata(data: any): void;
        getBuffer(): ArrayBuffer;
        _uint16: Uint16Array;
        uintArray16: Uint16Array;
        bufferLength: number;
        length: number;
        seLength(value: number): void;
        usage: string;
        _resizeBuffer(nsz: number, copy: boolean): Buffer;
        setNeedUpload(): void;
        getNeedUpload(): boolean;
        bind(): void;
        protected recreateResource(): void;
        protected detoryResource(): void;
        upload(): boolean;
        subUpload(offset?: number, dataStart?: number, dataLength?: number): boolean;
        upload_bind(): void;
        /**
         * 释放CPU中的内存（upload()后确定不再使用时可使用）
         */
        disposeCPUData(): void;
        dispose(): void;
    }
}
declare module laya.webgl.utils {
    /**
     * ...
     * @author laya
     */
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
    /**
     * ...
     * @author laya
     */
    class GlUtils {
        static make2DProjection(width: number, height: number, depth: number): any;
        /**
         *  初始化全局IB,IB索引如下:
         *   0___1
         *     |\  |
         *     | \ |
         *     |__\|
         *     3   2
         */
        static fillIBQuadrangle(buffer: Buffer, count: number): boolean;
        static expandIBQuadrangle(buffer: Buffer, count: number): void;
        static mathCeilPowerOfTwo(value: number): number;
        static fillQuadrangleImgVb(vb: Buffer, x: number, y: number, point4: Array<any>, uv: Array<any>, m: laya.maths.Matrix, _x: number, _y: number): boolean;
        static fillTranglesVB(vb: Buffer, x: number, y: number, points: Array<any>, m: laya.maths.Matrix, _x: number, _y: number): boolean;
        static fillRectImgVb(vb: Buffer, clip: laya.maths.Rectangle, x: number, y: number, width: number, height: number, uv: Array<any>, m: laya.maths.Matrix, _x: number, _y: number, dx: number, dy: number): boolean;
        static fillLineVb(vb: Buffer, clip: laya.maths.Rectangle, fx: number, fy: number, tx: number, ty: number, width: number, mat: laya.maths.Matrix): boolean;
    }
}
declare module laya.webgl.utils {
    /**
     * ...
     * @author laya
     */
    class RenderSprite3D extends laya.renders.RenderSprite {
        constructor(type: number, next: laya.renders.RenderSprite);
        protected onCreate(type: number): void;
        _blend(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
        _transform(sprite: laya.display.Sprite, context: laya.renders.RenderContext, x: number, y: number): void;
    }
}
declare module laya.webgl.utils {
    /**
     * ...
     * @author laya
     */
    class RenderState2D {
        static _MAXSIZE: number;
        static TEMPMAT4_ARRAY: Array<any>;
        static worldMatrix4: Array<any>;
        static worldMatrix: laya.maths.Matrix;
        static worldAlpha: number;
        static worldScissorTest: boolean;
        static worldFilters: Array<any>;
        static worldShaderDefinesValue: number;
        static worldClipRect: laya.maths.Rectangle;
        static curRenderTarget: laya.webgl.resource.RenderTarget2D;
        static width: number;
        static height: number;
        static mat2MatArray(mat: laya.maths.Matrix, matArray: Array<any>): Array<any>;
        static restoreTempArray(): void;
        static clear(): void;
    }
}
declare module laya.webgl.utils {
    /**
     * ...
     * @author laya
     */
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
declare module laya.webgl {
    /**
     * ...
     * @author laya
     */
    class WebGL {
        static mainCanvas: laya.resource.HTMLCanvas;
        static mainContext: WebGLContext;
        static antialias: boolean;
        static enable(): boolean;
        static isWebGLSupported(): string;
        static onStageResize(width: number, height: number): void;
        static init(canvas: laya.resource.HTMLCanvas, width: number, height: number): void;
    }
}
declare module laya.webgl {
    /**
     * ...
     * @author laya
     */
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
        static _depthMask: number;
        static _blend: boolean;
        static _sFactor: number;
        static _dFactor: number;
        static _cullFace: boolean;
        static _frontFace: number;
        static setDepthTest(gl: WebGLContext, value: boolean): void;
        static setDepthMask(gl: WebGLContext, value: number): void;
        static setBlend(gl: WebGLContext, value: boolean): void;
        static setBlendFunc(gl: WebGLContext, sFactor: number, dFactor: number): void;
        static setCullFace(gl: WebGLContext, value: boolean): void;
        static setFrontFaceCCW(gl: WebGLContext, value: number): void;
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
        blendColor(red: any, green: any, blue: any, alpha: number): void;
        blendEquation(mode: any): void;
        blendEquationSeparate(modeRGB: any, modeAlpha: any): void;
        blendFunc(sfactor: any, dfactor: any): void;
        blendFuncSeparate(srcRGB: any, dstRGB: any, srcAlpha: any, dstAlpha: any): void;
        bufferData(target: any, size: any, usage: any): void;
        bufferSubData(target: any, offset: number, data: any): void;
        checkFramebufferStatus(target: any): any;
        clear(mask: any): void;
        clearColor(red: any, green: any, blue: any, alpha: number): void;
        clearDepth(depth: any): void;
        clearStencil(s: any): void;
        colorMask(red: any, green: any, blue: any, alpha: any): void;
        compileShader(shader: any): void;
        copyTexImage2D(target: any, level: any, internalformat: any, x: number, y: number, width: number, height: number, border: any): void;
        copyTexSubImage2D(target: any, level: any, xoffset: number, yoffset: number, x: number, y: number, width: number, height: number): void;
        createBuffer(): void;
        createFramebuffer(): void;
        createProgram(): void;
        createRenderbuffer(): void;
        createShader(type: any): void;
        createTexture(): void;
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
        getAttribLocation(program: any, name: string): number;
        getParameter(pname: any): any;
        getBufferParameter(target: any, pname: any): any;
        getError(): any;
        getFramebufferAttachmentParameter(target: any, attachment: any, pname: any): void;
        getProgramParameter(program: any, pname: any): number;
        getProgramInfoLog(program: any): any;
        getRenderbufferParameter(target: any, pname: any): any;
        getShaderParameter(shader: any, pname: any): void;
        getShaderInfoLog(shader: any): any;
        getShaderSource(shader: any): any;
        getTexParameter(target: any, pname: any): void;
        getUniform(program: any, location: number): void;
        getUniformLocation(program: any, name: string): number;
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
        stencilFunc(func: any, ref: any, mask: any): void;
        stencilFuncSeparate(face: any, func: any, ref: any, mask: any): void;
        stencilMask(mask: any): void;
        stencilMaskSeparate(face: any, mask: any): void;
        stencilOp(fail: any, zfail: any, zpass: any): void;
        stencilOpSeparate(face: any, fail: any, zfail: any, zpass: any): void;
        texImage2D(...args: any[]): void;
        texParameterf(target: any, pname: any, param: any): void;
        texParameteri(target: any, pname: any, param: any): void;
        texSubImage2D(...args: any[]): void;
        uniform1f(location: number, x: number): void;
        uniform1fv(location: number, v: any): void;
        uniform1i(location: number, x: number): void;
        uniform1iv(location: number, v: any): void;
        uniform2f(location: number, x: number, y: number): void;
        uniform2fv(location: number, v: any): void;
        uniform2i(location: number, x: number, y: number): void;
        uniform2iv(location: number, v: any): void;
        uniform3f(location: number, x: number, y: number, z: number): void;
        uniform3fv(location: number, v: any): void;
        uniform3i(location: number, x: number, y: number, z: number): void;
        uniform3iv(location: number, v: any): void;
        uniform4f(location: number, x: number, y: number, z: number, w: number): void;
        uniform4fv(location: number, v: any): void;
        uniform4i(location: number, x: number, y: number, z: number, w: number): void;
        uniform4iv(location: number, v: any): void;
        uniformMatrix2fv(location: number, transpose: any, value: any): void;
        uniformMatrix3fv(location: number, transpose: any, value: any): void;
        uniformMatrix4fv(location: number, transpose: any, value: any): void;
        useProgram(program: any): void;
        validateProgram(program: any): void;
        vertexAttrib1f(indx: number, x: number): void;
        vertexAttrib1fv(indx: number, values: any): void;
        vertexAttrib2f(indx: number, x: number, y: number): void;
        vertexAttrib2fv(indx: number, values: any): void;
        vertexAttrib3f(indx: number, x: number, y: number, z: number): void;
        vertexAttrib3fv(indx: number, values: any): void;
        vertexAttrib4f(indx: number, x: number, y: number, z: number, w: number): void;
        vertexAttrib4fv(indx: number, values: any): void;
        vertexAttribPointer(indx: number, size: any, type: any, normalized: any, stride: any, offset: number): void;
        viewport(x: number, y: number, width: number, height: number): void;
    }
}
declare class Laya {
    /**舞台信息*/
    static stage: laya.display.Stage;
    /**时间管理器*/
    static timer: laya.utils.Timer;
    /**加载管理器*/
    static loader: laya.net.LoaderManager;
    /**Render类*/
    static render: laya.renders.Render;
    /**引擎版本*/
    static version: string;
    /**是否是3d模式*/
    static is3DMode: boolean;
    /**
     * 初始化引擎
     * @param    width 游戏窗口宽度
     * @param    height    游戏窗口高度
     * @param    插件列表，比如WebGL
     */
    static init(width: number, height: number, ...plugins: any[]): void;
    /**初始化异步函数调用*/
    protected static initAsyn(): void;
    /**是否捕获全局错误并弹出提示*/
    static alertGlobalError(value: boolean): void;
}
declare class Config {
    static CPUMemoryLimit: number;
    static GPUMemoryLimit: number;
}
/**全局配置*/
declare class UIConfig {
    /**资源路径*/
    static resPath: string;
    /**UI路径(UI加载模式可用)*/
    static uiPath: string;
    /**是否开启触摸*/
    static touchScrollEnable: boolean;
    /**是否开启滑轮滚动*/
    static mouseWheelEnable: boolean;
    /**是否显示滚动条按钮*/
    static showButtons: boolean;
    /**弹出框背景颜色*/
    static popupBgColor: string;
    /**弹出框背景透明度*/
    static popupBgAlpha: number;
}
declare class XmlDom {
    childNodes: Array<any>;
    firstChild: XmlDom;
    lastChild: XmlDom;
    localName: String;
    nextSibling: XmlDom;
    nodeName: string;
    nodeType: number;
    nodeValue: any;
    parentNode: XmlDom;
    attributes: any;
    textContent: string;
    appendChild(node: XmlDom): XmlDom;
    removeChild(node: XmlDom): XmlDom;
    cloneNode(): XmlDom;
    getElementsByTagName(name: String): Array<any>;
    getElementsByTagNameNS(ns: String, name: String): Array<any>;
    setAttribute(name: String, value: any): void;
    getAttribute(name: string): any;
    setAttributeNS(ns: string, name: string, value: any): void;
    getAttributeNS(ns: string, name: string): any;
}
