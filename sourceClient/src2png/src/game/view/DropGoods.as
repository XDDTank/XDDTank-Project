// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.DropGoods

package game.view
{
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import com.greensock.TweenMax;
    import com.greensock.TimelineLite;
    import ddt.manager.SoundManager;
    import com.greensock.easing.Bounce;
    import com.pickgliss.utils.ClassUtils;
    import flash.utils.setTimeout;
    import com.greensock.TweenLite;
    import flash.utils.clearTimeout;
    import com.greensock.easing.Quint;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Sprite;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.utils.ObjectUtils;

    public class DropGoods implements Disposeable 
    {

        public static var count:int;
        public static var isOver:Boolean = true;

        public const MONSTER_DROP:int = 1;
        public const CHESTS_DROP:int = 2;

        private var goodBox:MovieClip;
        private var bagMc:MovieClipWrapper;
        private var goldNumText:FilterFrameText;
        private var goods:DisplayObject;
        private var container:DisplayObjectContainer;
        private var goldNum:int;
        private var beginPoint:Point;
        private var midPoint:Point;
        private var endPoint:Point;
        private var headGlow:MovieClip;
        private var _type:int;
        private var timeId:uint;
        private var timeOutId:uint;
        private var _goodsId:int;
        private var currentCount:int;
        private var tweenUp:TweenMax;
        private var tweenDown:TweenMax;
        private var timeline:TimelineLite;

        public function DropGoods(_arg_1:DisplayObjectContainer, _arg_2:DisplayObject, _arg_3:Point, _arg_4:Point, _arg_5:int)
        {
            this.container = _arg_1;
            this.goods = _arg_2;
            this.beginPoint = _arg_3;
            this.endPoint = _arg_4;
            this.goldNum = _arg_5;
        }

        public function start(_arg_1:int=1):void
        {
            if (((this.goods == null) || (this.beginPoint == null)))
            {
                return;
            };
            this._type = _arg_1;
            this.goods.x = this.beginPoint.x;
            this.goods.y = this.beginPoint.y;
            this.container.addChild(this.goods);
            this.midPoint = this.getLinePoint(this.beginPoint);
            var _local_2:Point = new Point((this.beginPoint.x - ((this.beginPoint.x - this.midPoint.x) / 2)), (this.beginPoint.y - 200));
            this.goDown(this.midPoint, _local_2);
            isOver = false;
        }

        private function getLinePoint(_arg_1:Point):Point
        {
            var _local_4:int;
            var _local_2:Point = new Point();
            var _local_3:Number = 45;
            this._goodsId = count;
            if (this._type == this.MONSTER_DROP)
            {
                _local_4 = 3;
                _local_2.y = (_arg_1.y - 30);
            }
            else
            {
                if (this._type == this.CHESTS_DROP)
                {
                    _local_4 = 2;
                    _local_2.y = ((_arg_1.y + (Math.random() * 90)) + 10);
                };
            };
            if ((((count % 2) == 0) && ((_arg_1.x - ((_local_3 * count) / _local_4)) > (_arg_1.x - 350))))
            {
                _local_2.x = (_arg_1.x - ((_local_3 * count) / _local_4));
            }
            else
            {
                if ((((count % 2) == 1) && ((_arg_1.x + ((_local_3 * count) / _local_4)) < (_arg_1.x + 300))))
                {
                    _local_2.x = (_arg_1.x + ((_local_3 * count) / _local_4));
                }
                else
                {
                    _local_2.x = ((count % 2) ? (_arg_1.x + ((_local_3 * Math.random()) * (count / _local_4))) : (_arg_1.x - ((_local_3 * Math.random()) * (count / _local_4))));
                };
            };
            if (this.container.localToGlobal(_local_2).x < 100)
            {
                _local_2.x = (_arg_1.x + ((_local_3 * count) / _local_4));
            };
            if (this.container.localToGlobal(_local_2).x > 900)
            {
                _local_2.x = (_arg_1.x - ((_local_3 * count) / _local_4));
            };
            count++;
            return (_local_2);
        }

        private function goDown(_arg_1:Point, _arg_2:Point):void
        {
            SoundManager.instance.play("170");
            if (this._type == this.MONSTER_DROP)
            {
                this.tweenDown = TweenMax.to(this.goods, (1.2 + (this._goodsId / 10)), {
                    "bezier":[{
                        "x":_arg_2.x,
                        "y":_arg_2.y
                    }, {
                        "x":_arg_1.x,
                        "y":_arg_1.y
                    }, {
                        "x":_arg_1.x,
                        "y":_arg_1.y
                    }],
                    "scaleX":1,
                    "scaleY":1,
                    "ease":Bounce.easeOut,
                    "onComplete":this.__onCompleteGodown
                });
            }
            else
            {
                if (this._type == this.CHESTS_DROP)
                {
                    this.tweenDown = TweenMax.to(this.goods, (1.2 + (this._goodsId / 10)), {
                        "bezier":[{
                            "x":_arg_2.x,
                            "y":_arg_2.y
                        }, {
                            "x":_arg_1.x,
                            "y":(this.beginPoint.y - 10)
                        }, {
                            "x":_arg_1.x,
                            "y":_arg_1.y
                        }],
                        "scaleX":1,
                        "scaleY":1,
                        "ease":Bounce.easeOut,
                        "onComplete":this.__onCompleteGodown
                    });
                };
            };
        }

        private function __onCompleteGodown():void
        {
            var _local_1:Point;
            this.tweenDown.kill();
            this.tweenDown = null;
            if (this.goods == null)
            {
                return;
            };
            if (this._type == this.MONSTER_DROP)
            {
                _local_1 = new Point((this.midPoint.x - ((this.midPoint.x - this.endPoint.x) / 2)), (this.midPoint.y - 100));
                this.goodBox = (ClassUtils.CreatInstance("asset.game.GoodFlashBox") as MovieClip);
                this.timeOutId = setTimeout(this.goPackUp, (500 + (this._goodsId * 50)), this.endPoint, _local_1);
            }
            else
            {
                if (this._type == this.CHESTS_DROP)
                {
                    _local_1 = new Point((this.midPoint.x - ((this.midPoint.x - this.endPoint.x) / 2)), (this.midPoint.y - 100));
                    this.goodBox = (ClassUtils.CreatInstance("asset.game.FlashLight") as MovieClip);
                    this.timeOutId = setTimeout(this.goPackUp, (600 + (this._goodsId * 100)), this.endPoint, _local_1);
                };
            };
            this.goodBox.x = this.goods.x;
            this.goodBox.y = this.goods.y;
            this.goods.x = 0;
            this.goods.y = 0;
            this.goodBox.gotoAndPlay(int((Math.random() * this.goodBox.totalFrames)));
            this.goodBox.box.addChild(this.goods);
            this.container.addChild(this.goodBox);
            SoundManager.instance.play("172");
        }

        private function goPackUp(p1:Point, p2:Point):void
        {
            var p:Point;
            var tl:TweenLite;
            clearTimeout(this.timeOutId);
            if (this.goods == null)
            {
                return;
            };
            if (this.container.contains(this.goodBox))
            {
                this.container.removeChild(this.goodBox);
            };
            this.goods.x = this.goodBox.x;
            this.goods.y = this.goodBox.y;
            if (this._type == this.MONSTER_DROP)
            {
                this.container.addChild(this.goods);
                this.tweenUp = TweenMax.to(this.goods, 0.8, {
                    "alpha":0,
                    "scaleX":0.5,
                    "scaleY":0.5,
                    "bezierThrough":[{
                        "x":p2.x,
                        "y":p2.y
                    }, {
                        "x":p1.x,
                        "y":p1.y
                    }],
                    "ease":Quint.easeInOut,
                    "orientToBezier":true,
                    "onComplete":this.onCompletePackUp
                });
            }
            else
            {
                if (this._type == this.CHESTS_DROP)
                {
                    p = this.container.localToGlobal(new Point(this.goods.x, this.goods.y));
                    this.goods.x = p.x;
                    this.goods.y = p.y;
                    this.container.stage.addChild(this.goods);
                    p2 = this.container.localToGlobal(p2);
                    p1 = new Point(650, 550);
                    this.tweenUp = TweenMax.to(this.goods, 0.8, {
                        "alpha":0.5,
                        "scaleX":0.5,
                        "scaleY":0.5,
                        "bezierThrough":[{
                            "x":p2.x,
                            "y":p2.y
                        }, {
                            "x":p1.x,
                            "y":p1.y
                        }],
                        "ease":Quint.easeInOut,
                        "orientToBezier":true,
                        "onComplete":this.onCompletePackUp
                    });
                };
            };
            this.goldNumText = ComponentFactory.Instance.creatComponentByStylename("dropGoods.goldNumText");
            if (this.goldNumText)
            {
                this.goldNumText.x = this.midPoint.x;
                this.goldNumText.y = this.midPoint.y;
                this.goldNumText.text = this.goldNum.toString();
                this.container.addChild(this.goldNumText);
                tl = TweenLite.to(this.goldNumText, 1, {
                    "y":(this.midPoint.y - 200),
                    "alpha":0,
                    "onComplete":function ():void
                    {
                        tl.kill();
                    }
                });
            };
        }

        private function onCompletePackUp():void
        {
            var _local_1:Sprite;
            this.tweenUp.kill();
            this.tweenUp = null;
            if (this.goods == null)
            {
                return;
            };
            if (((this.goldNumText) && (this.container.contains(this.goldNumText))))
            {
                this.container.removeChild(this.goldNumText);
            };
            if (this._type == this.MONSTER_DROP)
            {
                this.timeline = new TimelineLite();
                if ((this.goods is BaseCell))
                {
                    _local_1 = (this.goods as BaseCell).getContent();
                    if (_local_1)
                    {
                        _local_1.x = (_local_1.x - (_local_1.width / 2));
                        _local_1.y = (_local_1.y - (_local_1.height / 2));
                    };
                };
                this.headGlow = (ClassUtils.CreatInstance("asset.game.HeadGlow") as MovieClip);
                this.headGlow.x = this.endPoint.x;
                this.headGlow.y = this.endPoint.y;
                this.container.addChild(this.headGlow);
                this.goods.rotationX = (this.goods.rotationY = (this.goods.rotationZ = 0));
                this.timeline.append(TweenLite.to(this.goods, 0.2, {
                    "alpha":1,
                    "scaleX":0.8,
                    "scaleY":0.8,
                    "x":(this.goods.x + 5),
                    "y":(this.goods.y - 50)
                }));
                this.timeline.append(TweenLite.to(this.goods, 0.4, {
                    "y":(this.goods.y - 150),
                    "alpha":0.2,
                    "rotationY":(360 * 5),
                    "onComplete":this.completeHead
                }));
            }
            else
            {
                if (this._type == this.CHESTS_DROP)
                {
                    if (((this.goods) && (this.container.stage.contains(this.goods))))
                    {
                        this.container.stage.removeChild(this.goods);
                    };
                    this.bagMc = this.getBagAniam();
                    if (this.bagMc.movie)
                    {
                        this.container.stage.addChild(this.bagMc.movie);
                    };
                    this.timeId = setTimeout(this.dispose, 500);
                    this.currentCount = count;
                };
            };
            SoundManager.instance.play("171");
        }

        private function completeHead():void
        {
            this.timeline.kill();
            this.timeline = null;
            if (((this.goods) && (this.container.contains(this.goods))))
            {
                this.container.removeChild(this.goods);
            };
            this.timeId = setTimeout(this.dispose, 500);
            this.currentCount = count;
        }

        private function getBagAniam():MovieClipWrapper
        {
            var _local_1:MovieClip;
            var _local_2:Point;
            _local_1 = (ClassUtils.CreatInstance("asset.game.bagAniam") as MovieClip);
            _local_2 = ComponentFactory.Instance.creatCustomObject("dropGoods.bagPoint");
            _local_1.x = _local_2.x;
            _local_1.y = _local_2.y;
            return (new MovieClipWrapper(_local_1, true, true));
        }

        public function dispose():void
        {
            clearTimeout(this.timeId);
            clearTimeout(this.timeOutId);
            ObjectUtils.disposeObject(this.goods);
            this.goods = null;
            if (this.goldNumText)
            {
                TweenLite.killTweensOf(this.goldNumText);
                ObjectUtils.disposeObject(this.goldNumText);
                this.goldNumText = null;
            };
            ObjectUtils.disposeObject(this.headGlow);
            this.headGlow = null;
            ObjectUtils.disposeObject(this.goodBox);
            this.goodBox = null;
            if (this.bagMc)
            {
                this.bagMc.dispose();
                this.bagMc = null;
            };
            this.goods = null;
            if (this.currentCount == count)
            {
                isOver = true;
            };
            count = 0;
        }


    }
}//package game.view

