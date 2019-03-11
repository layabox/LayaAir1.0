/**
* v1.0.0 by @ManfredHu 2018-03-29
* Matter.js 渲染器在 LayaAir 的实现。
* License MIT
*/

/**
 * The MIT License (MIT)
 * 
 * Copyright (c) Liam Brummitt and contributors.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

;(function (name, definition) {
    // 检测上下文环境是否为AMD或CMD
    var hasDefine = typeof define === 'function',
        // 检查上下文环境是否为Node
        hasExports = typeof module !== 'undefined' && module.exports;

    if (hasDefine) {
        // AMD环境或CMD环境
        define(definition);
    } else if (hasExports) {
        // 定义为普通Node模块
        module.exports = definition();
    } else {
        // 将模块的执行结果挂在window变量中，在浏览器中this指向window对象
        this[name] = definition();
    }
})('RenderLaya', function () {
    if(!Matter) {
        console.log("请引入Matter.js");
    }
    var RenderLaya = {};
    var Composite = Matter.Composite;
    var Common = Matter.Common;
    var Bounds = Matter.Bounds;
    var Events = Matter.Events;
    var Grid = Matter.Grid;
    var Vector = Matter.Vector;

    RenderLaya.create = function (options) {
        var defaults = {
            controller: RenderLaya,
            engine: null,
            element: null,
            canvas: null,
            container: null,
            spriteContainer: null,
            options: {
                width: 800,
                height: 600,
                background: '#fff', //可以传入16进制颜色值、图片URL或者是transparent
                wireframeBackground: '#222', //线框背景颜色
                hasBounds: false,
                enabled: true,
                wireframes: true, //默认没有图片，只有线框
                // showSleeping: true,
                // showDebug: false,
                // showBroadphase: false,
                // showShadows: false,
                // showCollisions: false,
                showBounds: false,
                showVelocity: false,
                showAxes: false, //显示坐标轴
                showPositions: false,
                showAngleIndicator: false, //角度指示器
                showIds: false,
                hideWireFrames: false //隐藏所有刚体线框和指示器，一般在正式环境建议开启
            }
        };
        var render = Common.extend(defaults, options);

        render.mouse = options.mouse;
        render.engine = options.engine;

        //容器,如果用户没有指定contaienr，默认使用stage
        render.container = render.container || Laya.stage;
        //图片容器，便于管理和提高渲染效率
        if (!Laya.Box) {
            throw new Error("must import Laya");
            return;
        }
        render.spriteContainer = render.spriteContainer || new Laya.Box();
        render.bounds = render.bounds || {
            min: {
                x: 0,
                y: 0
            },
            max: {
                x: render.option && render.option.width,
                y: render.option && render.option.height
            }
        };

        // caches
        // render.textures = {};
        render.sprites = {};
        render.primitives = {};

        render.container.addChild(render.spriteContainer);

        // 如果有传入canvas
        if (render.canvas) {
            //禁止掉一些交互
            render.canvas.oncontextmenu = function () {
                return false;
            }; //右键呼出菜单
            render.canvas.onselectstart = function () {
                return false;
            }; //鼠标选中文字
        }
        return render;
    }

    /**
     * 运行渲染器。
     * @param  {render} render 渲染的目标是RenderLaya.create()返回的对象
     * @return {void}
     */
    RenderLaya.run = function (render) {
        //每一帧执行RenderLaya.world，传入参数render，覆盖之前的回调执行
        Laya.timer.frameLoop(1, this, RenderLaya.world, [render], true);
        //绑定事件afterRemove
        Events.on(render.engine.world, 'afterRemove', RenderLaya.onRemoveSprite);
    };

    /**
     * 停止渲染器。
     * @param  {render} RenderLaya.create()返回的对象
     * @return {void}
     */
    RenderLaya.stop = function (render) {
        //清楚在run()定义的定时器
        Laya.timer.clear(this, RenderLaya.world);
        //移除事件afterRemove
        Events.off(render.engine.world, 'afterRemove', RenderLaya.onRemoveSprite);
    }

    RenderLaya.onRemoveSprite = function (args) {
        //有子元素遍历删除
        if (args.object && args.object.bodies && Array.isArray(args.object.bodies)) {
            for (var i = 0, len = args.object.bodies.length; i < len; i++) {
                RenderLaya.onRemoveSprite({
                    object: args.object.bodies[i]
                })
            }
        }
        //再删除自己
        var sprite = args.object && args.object.render && args.object.render.layaSprite;
        if (sprite && sprite.parent) {
            sprite.parent.removeChild(sprite);
        }
    }

    /**
     * 设置背景色或者背景图片。
     * @param {render} render
     * @param {string} background 16进制颜色字符串或者图片路径
     */
    RenderLaya.setBackground = function (render, background) {
        if (render.currentBackground !== background) {
            var isColor = background.indexOf && background.indexOf('#') !== -1,
                bgSprite = render.sprites['bg-0'],
                isTransparent = !render.options.wireframes && render.options.background === 'transparent';
            if (isColor) {
                // 使用纯色背景
                if (render.container === Laya.stage) {
                    render.container.bgColor = background;
                } else if (render.container && render.container.graphics) {
                    render.container.graphics.clear();
                    render.container.graphics.drawRect(0, 0, Laya.stage.width, Laya.stage.height, background);
                }
            } else if (isTransparent) {
                if (render.container === Laya.stage) {
                    render.container.bgColor = null;
                }
            } else {
                render.container.loadImage(background);
                // 使用背景图片时把背景色设置为白色
                render.container.bgColor = "#FFFFFF";
            }
            render.currentBackground = background;
        }
    }

    /**
     * 渲染给定的 engine 的 Matter.World 对象。
     * 这是渲染的入口，每次场景改变时都应该被调用。
     * @param  {render} render
     * @return {void}
     */
    RenderLaya.world = function (render) {
        var engine = render.engine,
            world = engine.world,
            container = render.container,
            options = render.options,
            bodies = Composite.allBodies(world),
            allConstraints = Composite.allConstraints(world),
            constraints = [],
            i;

        if (options.wireframes) {
            RenderLaya.setBackground(render, options.wireframeBackground);
        } else {
            RenderLaya.setBackground(render, options.background);
        }

        // 处理 bounds
        var boundsWidth = render.bounds.max.x - render.bounds.min.x,
            boundsHeight = render.bounds.max.y - render.bounds.min.y,
            boundsScaleX = boundsWidth / render.options.width,
            boundsScaleY = boundsHeight / render.options.height;

        if (options.hasBounds) {
            // 隐藏不在视口内的bodies
            for (i = 0; i < bodies.length; i++) {
                var body = bodies[i];
                body.render.sprite.visible = Bounds.overlaps(body.bounds, render.bounds);
            }

            // 过滤掉不在视口内的 constraints
            for (i = 0; i < allConstraints.length; i++) {
                var constraint = allConstraints[i],
                    bodyA = constraint.bodyA,
                    bodyB = constraint.bodyB,
                    pointAWorld = constraint.pointA,
                    pointBWorld = constraint.pointB;

                if (bodyA) pointAWorld = Vector.add(bodyA.position, constraint.pointA);
                if (bodyB) pointBWorld = Vector.add(bodyB.position, constraint.pointB);

                if (!pointAWorld || !pointBWorld)
                    continue;

                if (Bounds.contains(render.bounds, pointAWorld) || Bounds.contains(render.bounds, pointBWorld))
                    constraints.push(constraint);
            }

            // 改变视口
            container.scale(1 / boundsScaleX, 1 / boundsScaleY);
            container.pos(-render.bounds.min.x * (1 / boundsScaleX), -render.bounds.min.y * (1 / boundsScaleY));
        } else {
            constraints = allConstraints;
        }

        for (i = 0; i < bodies.length; i++) {
            RenderLaya.body(render, bodies[i]);
        }

        for (i = 0; i < constraints.length; i++) {
            RenderLaya.constraint(render, constraints[i]);
        }
    };

    /**
     * 绘制 constraint。
     * @param  {render} render
     * @param  {constraint} constraint
     * @return {void}
     */
    RenderLaya.constraint = function (render, constraint) {
        var engine = render.engine,
            options = render.options,
            bodyA = constraint.bodyA,
            bodyB = constraint.bodyB,
            pointA = constraint.pointA,
            pointB = constraint.pointB,
            container = render.container,
            constraintRender = constraint.render,
            primitiveId = 'c-' + constraint.id, //注意这里的id，c-开头为constraint
            primitive = render.primitives && render.primitives[primitiveId];

        // 如果sprite不存在，则初始化一个
        if (!primitive) {
            primitive = render.primitives[primitiveId] = new Laya.Sprite();
        }

        // constraint 没有两个终点时不渲染
        if (!constraintRender.visible || !constraint.pointA || !constraint.pointB) {
            primitive.graphics.clear();
            return;
        }

        // 如果sprite未在显示列表，则添加至显示列表
        if (!container.contains(primitive))
            container.addChild(primitive);

        // 渲染 constraint
        primitive.graphics.clear();

        var fromX, fromY, toX, toY;
        if (bodyA) {
            fromX = bodyA.position.x + pointA.x;
            fromY = bodyA.position.y + pointA.y;
        } else {
            fromX = pointA.x;
            fromY = pointA.y;
        }

        if (bodyB) {
            toX = bodyB.position.x + pointB.x;
            toY = bodyB.position.y + pointB.y;
        } else {
            toX = pointB.x;
            toY = pointB.y;
        }

        if(!options.hideWireFrames){
            primitive.graphics.drawLine(fromX, fromY, toX, toY, constraintRender.strokeStyle, constraintRender.lineWidth);
        }
    };

    /**
     * 渲染 body
     * @param  {render} render
     * @param  {body} body
     * @return {void}
     */
    RenderLaya.body = function (render, body) {
        var engine = render.engine,
            options = render.options,
            bodyRender = body.render;

        if (!bodyRender.visible)
            return;

        // 有纹理的body
        if (bodyRender.sprite && bodyRender.sprite.texture && !options.wireframes) {
            var spriteId = 'b-' + body.id, //注意这里的id，b-开头为body
                sprite = render.sprites && render.sprites[spriteId],
                spriteContainer = render.spriteContainer;

            // 如果sprite不存在，则初始化一个
            if (!sprite) {
                sprite = render.sprites[spriteId] = _createBodySprite(render, body);
                bodyRender.layaSprite = sprite; //给body挂载图片资源，方便销毁的时候调取
            }

            // 如果sprite未在显示列表，则添加至显示列表
            if (!spriteContainer.contains(sprite)) {
                spriteContainer.addChild(sprite);
            }

            // 更新sprite位置
            sprite.x = body.position.x;
            sprite.y = body.position.y;
            sprite.rotation = body.angle * 180 / Math.PI;
            sprite.scaleX = bodyRender.sprite.xScale || 1;
            sprite.scaleY = bodyRender.sprite.yScale || 1;
        } else { // 没有纹理的body
            var primitiveId = 'b-' + body.id,
                primitive = render.primitives[primitiveId],
                container = render.container;

            // 如果sprite不存在，则初始化一个
            if (!primitive) {
                primitive = render.primitives[primitiveId] = _createBodyPrimitive(render, body);
                primitive.initialAngle = body.angle; //记录初始弧度
            }

            // 如果sprite未在显示列表，则添加至显示列表
            if (!container.contains(primitive)) {
                container.addChild(primitive);
            }

            //绘制出来
            RenderLaya.bodyWireframes(render, body, primitive);
        }
    };

    RenderLaya.bodyWireframes = function (render, body, primitive) {
        var bodyRender = body.render,
            options = render.options,
            fillStyle, strokeStyle, lineWidth,
            part,
            points = [],
            k,
            bodyPosition;

        primitive.graphics.clear();

        // 处理 compound parts
        for (var k = body.parts.length > 1 ? 1 : 0; k < body.parts.length; k++) {
            bodyPosition = body.position;
            part = body.parts[k];

            //显示边框，bodyBounds，在这里绘制不会挡住主框体
            if (options.showBounds && !options.hideWireFrames) {
                lineWidth = 1; //边框线宽度
                strokeStyle = '#3b3b3b';
                primitive.graphics.drawRect(part.bounds.min.x, part.bounds.min.y, part.bounds.max.x - part.bounds.min.x, part.bounds.max.y - part.bounds.min.y, null, strokeStyle, lineWidth);
            }

            //绘制主框体
            if (!options.wireframes) {
                //有颜色的实体填充
                fillStyle = bodyRender.fillStyle;
                strokeStyle = bodyRender.strokeStyle;
                lineWidth = bodyRender.lineWidth;
            } else {
                //画线框
                fillStyle = null; //不填充颜色，只有线条
                strokeStyle = '#bbb'; //线框颜色
                lineWidth = 1; //线框宽度
            }

            for (var j = 0; j < part.vertices.length; j++) {
                points.push(part.vertices[j].x - bodyPosition.x, part.vertices[j].y - bodyPosition.y);
            }

            //选项有线框选项才画，否则不画出来
            //fix:微信顶部有细线条bug
            if (!options.hideWireFrames) {
                primitive.graphics.drawPoly(bodyPosition.x, bodyPosition.y, points, fillStyle, strokeStyle, lineWidth);
            }

            //一些debug手段，一般正式环境关闭，否则会出现一些意外的线框导致位置不准确
            if (!options.hideWireFrames) {
                // 角度指示器，bodyAxes
                if (options.showAngleIndicator || options.showAxes) {
                    lineWidth = 1; //角度指示器线宽度
                    if (options.wireframes) {
                        strokeStyle = '#CD5C5C'; //角度指示器线颜色
                    } else {
                        strokeStyle = bodyRender.strokeStyle || '#f00'; //角度指示器线颜色
                    }

                    if (options.showAxes) { //显示坐标轴
                        for (k = 0; k < part.axes.length; k++) {
                            var axis = part.axes[k];
                            primitive.graphics.drawLine(part.position.x, part.position.y, part.position.x + axis.x * 20, part.position.y + axis.y * 20, strokeStyle, lineWidth);
                        }
                    } else { //显示角度指示器
                        for (k = 0; k < part.axes.length; k++) {
                            // render a single axis indicator
                            primitive.graphics.drawLine(part.position.x, part.position.y, (part.vertices[0].x + part.vertices[part.vertices.length - 1].x) / 2, (part.vertices[0].y + part.vertices[part.vertices.length - 1].y) / 2, strokeStyle, lineWidth);
                        }
                    }
                }

                //显示中心点，bodyPositions
                if (options.showPositions) {
                    if (options.wireframes) {
                        strokeStyle = '#CD5C5C';
                    } else {
                        strokeStyle = bodyRender.strokeStyle || '#f00';
                    }
                    primitive.graphics.drawCircle(part.position.x, part.position.y, 3, strokeStyle);
                }

                //显示速度，bodyVelocity
                if (options.showVelocity) {
                    lineWidth = 3; //速度线宽度
                    strokeStyle = '#6495ED';
                    primitive.graphics.drawLine(bodyPosition.x, bodyPosition.y, bodyPosition.x + (bodyPosition.x - body.positionPrev.x) * 2, bodyPosition.y + (bodyPosition.y - body.positionPrev.y) * 2, strokeStyle, lineWidth);
                }

                //显示ID，bodyIds
                if (options.showIds && Laya && Laya.Text) {
                    // 这句不起作用,Laya原生的fillText方法报错了
                    // primitive.graphics.fillText(part.id, part.position.x + 10, part.position.y - 10, "12px Arial", '#fff073');
                }
            }
        }

    }

    /**
     * 创建使用纹理的Sprite对象。
     * @param  {render} render
     * @param  {body} body
     * @return {void}
     */
    var _createBodySprite = function (render, body) {
        var bodyRender = body.render,
            texturePath = bodyRender.sprite.texture,
            sprite = new Laya.Sprite();

        sprite.loadImage(texturePath);
        //设定中心点偏移量
        sprite.pivotX = body.render.sprite.xOffset;
        sprite.pivotY = body.render.sprite.yOffset;

        return sprite;
    };

    /**
     * 创建使用矢量绘图的Sprite对象。
     * @param  {render} render
     * @param  {body} body
     * @return {void}
     */
    var _createBodyPrimitive = function (render, body) {
        if (!Laya.Sprite) {
            throw new Error("must import Laya.");
            return;
        }
        return new Laya.Sprite();
    };

    return RenderLaya;
});
