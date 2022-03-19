// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.SelfMarkBar

package game.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import flash.utils.Timer;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.filters.BlurFilter;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.events.LivingEvent;
    import flash.events.MouseEvent;
    import org.aswing.KeyboardManager;
    import flash.events.KeyboardEvent;
    import game.GameManager;
    import com.greensock.TweenLite;
    import ddt.utils.PositionUtils;
    import ddt.manager.SoundManager;
    import game.model.GameModeType;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.TimerEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import org.aswing.KeyStroke;
    import flash.display.Shape;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import ddt.events.GameEvent;
    import __AS3__.vec.*;

    public class SelfMarkBar extends Sprite implements Disposeable 
    {

        private var _self:LocalPlayer;
        private var _timer:Timer;
        private var _nums:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        private var _numContainer:Sprite;
        private var _alreadyTime:int;
        private var _animateFilter:BlurFilter = new BlurFilter();
        private var _scale:Number = 2;
        private var _skipButton:SkipButton;
        private var _container:DisplayObjectContainer;
        private var _waitingMC:MovieClip;
        private var _numDic:Dictionary = new Dictionary();
        private var _tickTemp:int = 0;
        private var _enabled:Boolean = true;

        public function SelfMarkBar(_arg_1:LocalPlayer, _arg_2:DisplayObjectContainer)
        {
            this._self = _arg_1;
            this._container = _arg_2;
            this._numContainer = new Sprite();
            this._numContainer.mouseChildren = (this._numContainer.mouseEnabled = false);
            addChild(this._numContainer);
            this._skipButton = ComponentFactory.Instance.creatCustomObject("SkipButton");
            this._skipButton.x = (-(this._skipButton.width) >> 1);
            this._skipButton.y = 70;
            addChild(this._skipButton);
            this.creatNums();
            this.addEvent();
        }

        private function creatNums():void
        {
            var _local_1:Bitmap;
            var _local_2:int;
            while (_local_2 < 10)
            {
                _local_1 = ComponentFactory.Instance.creatBitmap(("asset.game.mark.Blue" + _local_2));
                this._numDic[("Blue" + _local_2)] = _local_1;
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < 5)
            {
                _local_1 = ComponentFactory.Instance.creatBitmap(("asset.game.mark.Red" + _local_3));
                this._numDic[("Red" + _local_3)] = _local_1;
                _local_3++;
            };
        }

        private function addEvent():void
        {
            this._self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackChanged);
            this._self.addEventListener(LivingEvent.BEGIN_SHOOT, this.__beginShoot);
            this._skipButton.addEventListener(MouseEvent.CLICK, this.__skip);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            this._self.addEventListener(LivingEvent.READY_FOR_PLAYING, this.__onReady);
        }

        private function __onReady(_arg_1:LivingEvent):void
        {
            if (GameManager.Instance.Current.isMultiGame)
            {
                if (GameManager.Instance.Current.getTeamLiveCount(this._self.team) <= 1)
                {
                    return;
                };
                this._skipButton.enabled = false;
                TweenLite.to(this._skipButton, 0.5, {
                    "x":this._skipButton.x,
                    "y":(this._skipButton.y - this._numContainer.height),
                    "onComplete":this.showWaitingMC,
                    "alpha":0
                });
                TweenLite.to(this._numContainer, 0.5, {
                    "x":this._numContainer.x,
                    "y":(this._numContainer.y - this._numContainer.height),
                    "onComplete":this.showWaitingMC,
                    "alpha":0
                });
            };
        }

        private function showWaitingMC():void
        {
            if ((!(this._skipButton.enabled)))
            {
                TweenLite.killTweensOf(this._skipButton);
                TweenLite.killTweensOf(this._numContainer);
                if ((!(this._waitingMC)))
                {
                    this._waitingMC = (ComponentFactory.Instance.creat("ddt.gameIII.waitingMC") as MovieClip);
                    PositionUtils.setPos(this._waitingMC, "asset.gameIII.waitingMC.pos");
                    this._waitingMC.visible = false;
                    addChild(this._waitingMC);
                };
                this.updateView(true);
            };
        }

        private function __skip(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._skipButton.enabled)
            {
                this.skip();
                this.__onReady(null);
            };
        }

        private function removeEvent():void
        {
            this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackChanged);
            this._self.removeEventListener(LivingEvent.BEGIN_SHOOT, this.__beginShoot);
            this._skipButton.removeEventListener(MouseEvent.CLICK, this.__skip);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            this._self.removeEventListener(LivingEvent.READY_FOR_PLAYING, this.__onReady);
        }

        private function __beginShoot(_arg_1:LivingEvent):void
        {
            this.pause();
            this._skipButton.enabled = false;
        }

        private function __attackChanged(_arg_1:LivingEvent):void
        {
            if (((((this._self.isLiving) && (this._self.isAttacking)) && (GameManager.Instance.Current.currentLiving)) && (GameManager.Instance.Current.currentLiving.isSelf)))
            {
                this.visible = true;
                if (GameManager.Instance.Current.gameMode == GameModeType.SINGLE_DUNGOEN)
                {
                    this.startupInSingle();
                }
                else
                {
                    this.shutdown();
                    this.startup(this._self.turnTime);
                };
            }
            else
            {
                this.pause();
            };
        }

        public function dispose():void
        {
            var _local_1:String;
            this.removeEvent();
            this.shutdown();
            this.shutdownInSingle();
            this.clear();
            if (this._skipButton)
            {
                ObjectUtils.disposeObject(this._skipButton);
                this._skipButton = null;
            };
            for (_local_1 in this._numDic)
            {
                ObjectUtils.disposeObject(this._numDic[_local_1]);
                delete this._numDic[_local_1];
            };
            if (this._numContainer)
            {
                ObjectUtils.disposeObject(this._numContainer);
                this._numContainer = null;
            };
            ObjectUtils.disposeObject(this._waitingMC);
            this._waitingMC = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function startup(_arg_1:int):void
        {
            if ((!(this._enabled)))
            {
                return;
            };
            this._skipButton.enabled = true;
            this.updateView(false);
            this._alreadyTime = _arg_1;
            this.__mark(null);
            this._timer = new Timer(1000, _arg_1);
            this._timer.addEventListener(TimerEvent.TIMER, this.__mark);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__markComplete);
            this._timer.start();
            this._container.addChild(this);
            this._animateFilter.blurX = 40;
            filters = [this._animateFilter];
            TweenLite.to(this._animateFilter, 0.3, {
                "blurX":0,
                "onUpdate":this.tweenRender,
                "onComplete":this.tweenComplete
            });
        }

        private function updateView(_arg_1:Boolean):void
        {
            this._numContainer.visible = (!(_arg_1));
            this._skipButton.visible = (!(_arg_1));
            this._skipButton.alpha = 1;
            this._numContainer.alpha = 1;
            this._skipButton.y = 70;
            this._numContainer.y = 0;
            if (((this._waitingMC) && (!(this._waitingMC.visible == _arg_1))))
            {
                this._waitingMC.visible = _arg_1;
                if (_arg_1)
                {
                    this._waitingMC.gotoAndPlay(1);
                }
                else
                {
                    this._waitingMC.stop();
                };
            };
        }

        public function startupInSingle():void
        {
            if ((!(this._enabled)))
            {
                return;
            };
            this._skipButton.enabled = true;
            this.updateView(false);
            this._tickTemp = 0;
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__tickSingle);
            this._animateFilter.blurX = 40;
            filters = [this._animateFilter];
            TweenLite.to(this._animateFilter, 0.3, {
                "blurX":0,
                "onUpdate":this.tweenRender,
                "onComplete":this.tweenComplete
            });
        }

        private function __keyDown(_arg_1:KeyboardEvent):void
        {
            if (((_arg_1.keyCode == KeyStroke.VK_P.getCode()) && (this._self.isAttacking)))
            {
                SoundManager.instance.play("008");
                this.skip();
                this.__onReady(null);
            };
        }

        public function pause():void
        {
            if (this._timer)
            {
                this._timer.stop();
            };
        }

        public function shutdown():void
        {
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.__mark);
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__markComplete);
            };
            TweenLite.killTweensOf(this._skipButton);
            TweenLite.killTweensOf(this._numContainer);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function shutdownInSingle():void
        {
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__tickSingle);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function clear():void
        {
            var _local_1:DisplayObject = this._nums.shift();
            while (_local_1)
            {
                if (_local_1.parent)
                {
                    _local_1.parent.removeChild(_local_1);
                };
                _local_1 = this._nums.shift();
            };
        }

        private function skip():void
        {
            this.pause();
            this._self.shootTime = this._alreadyTime;
            this._self.skip();
        }

        private function tweenRender():void
        {
            filters = [this._animateFilter];
        }

        private function tweenComplete():void
        {
            filters = null;
        }

        private function __markComplete(_arg_1:TimerEvent):void
        {
            this.shutdown();
            this._self.shootTime = 0;
            this._self.skip();
        }

        public function get runnning():Boolean
        {
            return ((!(this._timer == null)) && (this._timer.running));
        }

        public function set enabled(_arg_1:Boolean):void
        {
            if (this._enabled != _arg_1)
            {
                this._enabled = _arg_1;
                if (((this._enabled) && (this.runnning)))
                {
                    this._container.addChild(this);
                }
                else
                {
                    this.shutdown();
                    this.shutdownInSingle();
                };
            };
        }

        private function __mark(_arg_1:TimerEvent):void
        {
            var _local_3:DisplayObject;
            var _local_4:Shape;
            var _local_5:BitmapData;
            var _local_6:Graphics;
            var _local_7:Number;
            TweenLite.killTweensOf(this);
            this.clear();
            this._alreadyTime--;
            var _local_2:String = this._alreadyTime.toString();
            if (this._alreadyTime > 9)
            {
                if ((this._alreadyTime % 11) == 0)
                {
                    _local_3 = this._numDic[("Blue" + _local_2.substr(0, 1))];
                    _local_3.x = 0;
                    this._numContainer.addChild(_local_3);
                    this._nums.push(_local_3);
                    _local_4 = new Shape();
                    _local_5 = this._numDic[("Blue" + _local_2.substr(0, 1))].bitmapData;
                    _local_6 = _local_4.graphics;
                    _local_6.beginBitmapFill(_local_5);
                    _local_6.drawRect(0, 0, _local_5.width, _local_5.height);
                    _local_6.endFill();
                    _local_4.x = this._nums[0].width;
                    this._numContainer.addChild(_local_4);
                    this._nums.push(_local_4);
                    this._numContainer.x = (-(this._numContainer.width) >> 1);
                }
                else
                {
                    _local_3 = this._numDic[("Blue" + _local_2.substr(0, 1))];
                    _local_3.x = 0;
                    this._numContainer.addChild(_local_3);
                    this._nums.push(_local_3);
                    _local_3 = this._numDic[("Blue" + _local_2.substr(1, 1))];
                    _local_3.x = this._nums[0].width;
                    this._numContainer.addChild(_local_3);
                    this._nums.push(_local_3);
                    this._numContainer.x = (-(this._numContainer.width) >> 1);
                };
                SoundManager.instance.play("014");
            }
            else
            {
                if (this._alreadyTime >= 0)
                {
                    if (this._alreadyTime <= 4)
                    {
                        _local_3 = this._numDic[("Red" + _local_2)];
                        Bitmap(_local_3).smoothing = true;
                        this._numContainer.addChild(_local_3);
                        this._nums.push(_local_3);
                        SoundManager.instance.stop("067");
                        SoundManager.instance.play("067");
                        _local_7 = (this._scale - 1);
                        this._numContainer.x = ((-(this._numContainer.width) * this._scale) >> 1);
                        this._numContainer.y = ((-(this._numContainer.height) * _local_7) >> 1);
                        this._numContainer.scaleX = (this._numContainer.scaleY = this._scale);
                        TweenLite.to(this._numContainer, 0.2, {
                            "x":(-(_local_3.width) >> 1),
                            "y":0,
                            "scaleX":1,
                            "scaleY":1
                        });
                    }
                    else
                    {
                        _local_3 = this._numDic[("Blue" + _local_2)];
                        if (_local_3)
                        {
                            _local_3.x = 0;
                            this._numContainer.addChild(_local_3);
                            this._numContainer.x = (-(this._numContainer.width) >> 1);
                            this._nums.push(_local_3);
                        };
                        SoundManager.instance.play("014");
                    };
                }
                else
                {
                    return;
                };
            };
        }

        public function setTick(_arg_1:int):void
        {
            this._tickTemp = _arg_1;
        }

        private function __tickSingle(_arg_1:TimeEvents):void
        {
            this._tickTemp++;
            if (this._tickTemp == 30)
            {
                dispatchEvent(new GameEvent(GameEvent.SINGLE_TURN_NOTICE));
            };
            if (this._tickTemp == 3600)
            {
                this.shutdownInSingle();
            };
            TweenLite.killTweensOf(this._skipButton);
            TweenLite.killTweensOf(this._numContainer);
        }


    }
}//package game.view

