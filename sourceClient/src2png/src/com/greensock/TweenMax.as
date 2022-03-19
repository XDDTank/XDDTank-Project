// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.TweenMax

package com.greensock
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import com.greensock.plugins.TweenPlugin;
    import com.greensock.plugins.AutoAlphaPlugin;
    import com.greensock.plugins.EndArrayPlugin;
    import com.greensock.plugins.FramePlugin;
    import com.greensock.plugins.RemoveTintPlugin;
    import com.greensock.plugins.TintPlugin;
    import com.greensock.plugins.VisiblePlugin;
    import com.greensock.plugins.VolumePlugin;
    import com.greensock.plugins.BevelFilterPlugin;
    import com.greensock.plugins.BezierPlugin;
    import com.greensock.plugins.BezierThroughPlugin;
    import com.greensock.plugins.BlurFilterPlugin;
    import com.greensock.plugins.ColorMatrixFilterPlugin;
    import com.greensock.plugins.ColorTransformPlugin;
    import com.greensock.plugins.DropShadowFilterPlugin;
    import com.greensock.plugins.FrameLabelPlugin;
    import com.greensock.plugins.GlowFilterPlugin;
    import com.greensock.plugins.HexColorsPlugin;
    import com.greensock.plugins.RoundPropsPlugin;
    import com.greensock.plugins.ShortRotationPlugin;
    import com.greensock.events.TweenEvent;
    import com.greensock.core.TweenCore;
    import flash.utils.Dictionary;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import com.greensock.core.SimpleTimeline;
    import flash.utils.getTimer;
    import com.greensock.core.PropTween;
    import flash.events.Event;
    import com.greensock.plugins.*;
    import com.greensock.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class TweenMax extends TweenLite implements IEventDispatcher 
    {

        public static const version:Number = 11.64;
        private static var _overwriteMode:int = ((OverwriteManager.enabled) ? OverwriteManager.mode : OverwriteManager.init(2));
        public static var killTweensOf:Function = TweenLite.killTweensOf;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;

        protected var _dispatcher:EventDispatcher;
        protected var _hasUpdateListener:Boolean;
        protected var _repeat:int = 0;
        protected var _repeatDelay:Number = 0;
        protected var _cyclesComplete:int = 0;
        protected var _easePower:int;
        protected var _easeType:int;
        public var yoyo:Boolean;

        {
            TweenPlugin.activate([AutoAlphaPlugin, EndArrayPlugin, FramePlugin, RemoveTintPlugin, TintPlugin, VisiblePlugin, VolumePlugin, BevelFilterPlugin, BezierPlugin, BezierThroughPlugin, BlurFilterPlugin, ColorMatrixFilterPlugin, ColorTransformPlugin, DropShadowFilterPlugin, FrameLabelPlugin, GlowFilterPlugin, HexColorsPlugin, RoundPropsPlugin, ShortRotationPlugin, {}]);
        }

        public function TweenMax(_arg_1:Object, _arg_2:Number, _arg_3:Object)
        {
            super(_arg_1, _arg_2, _arg_3);
            if (TweenLite.version < 11.2)
            {
                throw (new Error("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com."));
            };
            this.yoyo = Boolean(this.vars.yoyo);
            this._repeat = uint(this.vars.repeat);
            this._repeatDelay = ((this.vars.repeatDelay) ? Number(this.vars.repeatDelay) : 0);
            this.cacheIsDirty = true;
            if (((((((this.vars.onCompleteListener) || (this.vars.onInitListener)) || (this.vars.onUpdateListener)) || (this.vars.onStartListener)) || (this.vars.onRepeatListener)) || (this.vars.onReverseCompleteListener)))
            {
                this.initDispatcher();
                if (((_arg_2 == 0) && (_delay == 0)))
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                };
            };
            if (((this.vars.timeScale) && (!(this.target is TweenCore))))
            {
                this.cachedTimeScale = this.vars.timeScale;
            };
        }

        public static function to(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenMax
        {
            return (new TweenMax(_arg_1, _arg_2, _arg_3));
        }

        public static function from(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenMax
        {
            _arg_3.runBackwards = true;
            if ((!("immediateRender" in _arg_3)))
            {
                _arg_3.immediateRender = true;
            };
            return (new TweenMax(_arg_1, _arg_2, _arg_3));
        }

        public static function fromTo(_arg_1:Object, _arg_2:Number, _arg_3:Object, _arg_4:Object):TweenMax
        {
            _arg_4.startAt = _arg_3;
            if (_arg_3.immediateRender)
            {
                _arg_4.immediateRender = true;
            };
            return (new TweenMax(_arg_1, _arg_2, _arg_4));
        }

        public static function allTo(targets:Array, duration:Number, vars:Object, stagger:Number=0, onCompleteAll:Function=null, onCompleteAllParams:Array=null):Array
        {
            var i:int;
            var varsDup:Object;
            var p:String;
            var onCompleteProxy:Function;
            var onCompleteParamsProxy:Array;
            var l:int = targets.length;
            var a:Array = [];
            var curDelay:Number = (("delay" in vars) ? Number(vars.delay) : 0);
            onCompleteProxy = vars.onComplete;
            onCompleteParamsProxy = vars.onCompleteParams;
            var lastIndex:int = (l - 1);
            i = 0;
            while (i < l)
            {
                varsDup = {};
                for (p in vars)
                {
                    varsDup[p] = vars[p];
                };
                varsDup.delay = curDelay;
                if (((i == lastIndex) && (!(onCompleteAll == null))))
                {
                    varsDup.onComplete = function ():void
                    {
                        if (onCompleteProxy != null)
                        {
                            onCompleteProxy.apply(null, onCompleteParamsProxy);
                        };
                        onCompleteAll.apply(null, onCompleteAllParams);
                    };
                };
                a[i] = new TweenMax(targets[i], duration, varsDup);
                curDelay = (curDelay + stagger);
                i = (i + 1);
            };
            return (a);
        }

        public static function allFrom(_arg_1:Array, _arg_2:Number, _arg_3:Object, _arg_4:Number=0, _arg_5:Function=null, _arg_6:Array=null):Array
        {
            _arg_3.runBackwards = true;
            if ((!("immediateRender" in _arg_3)))
            {
                _arg_3.immediateRender = true;
            };
            return (allTo(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6));
        }

        public static function allFromTo(_arg_1:Array, _arg_2:Number, _arg_3:Object, _arg_4:Object, _arg_5:Number=0, _arg_6:Function=null, _arg_7:Array=null):Array
        {
            _arg_4.startAt = _arg_3;
            if (_arg_3.immediateRender)
            {
                _arg_4.immediateRender = true;
            };
            return (allTo(_arg_1, _arg_2, _arg_4, _arg_5, _arg_6, _arg_7));
        }

        public static function delayedCall(_arg_1:Number, _arg_2:Function, _arg_3:Array=null, _arg_4:Boolean=false):TweenMax
        {
            return (new TweenMax(_arg_2, 0, {
                "delay":_arg_1,
                "onComplete":_arg_2,
                "onCompleteParams":_arg_3,
                "immediateRender":false,
                "useFrames":_arg_4,
                "overwrite":0
            }));
        }

        public static function getTweensOf(_arg_1:Object):Array
        {
            var _local_4:int;
            var _local_5:int;
            var _local_2:Array = masterList[_arg_1];
            var _local_3:Array = [];
            if (_local_2)
            {
                _local_4 = _local_2.length;
                _local_5 = 0;
                while (--_local_4 > -1)
                {
                    if ((!(TweenLite(_local_2[_local_4]).gc)))
                    {
                        var _local_6:* = _local_5++;
                        _local_3[_local_6] = _local_2[_local_4];
                    };
                };
            };
            return (_local_3);
        }

        public static function isTweening(_arg_1:Object):Boolean
        {
            var _local_4:TweenLite;
            var _local_2:Array = getTweensOf(_arg_1);
            var _local_3:int = _local_2.length;
            while (--_local_3 > -1)
            {
                _local_4 = _local_2[_local_3];
                if (((_local_4.active) || ((_local_4.cachedStartTime == _local_4.timeline.cachedTime) && (_local_4.timeline.active))))
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function getAllTweens():Array
        {
            var _local_4:Array;
            var _local_5:int;
            var _local_1:Dictionary = masterList;
            var _local_2:int;
            var _local_3:Array = [];
            for each (_local_4 in _local_1)
            {
                _local_5 = _local_4.length;
                while (--_local_5 > -1)
                {
                    if ((!(TweenLite(_local_4[_local_5]).gc)))
                    {
                        var _local_8:* = _local_2++;
                        _local_3[_local_8] = _local_4[_local_5];
                    };
                };
            };
            return (_local_3);
        }

        public static function killAll(_arg_1:Boolean=false, _arg_2:Boolean=true, _arg_3:Boolean=true):void
        {
            var _local_5:Boolean;
            var _local_4:Array = getAllTweens();
            var _local_6:int = _local_4.length;
            while (--_local_6 > -1)
            {
                _local_5 = (_local_4[_local_6].target == _local_4[_local_6].vars.onComplete);
                if (((_local_5 == _arg_3) || (!(_local_5 == _arg_2))))
                {
                    if (_arg_1)
                    {
                        _local_4[_local_6].complete(false);
                    }
                    else
                    {
                        _local_4[_local_6].setEnabled(false, false);
                    };
                };
            };
        }

        public static function killChildTweensOf(_arg_1:DisplayObjectContainer, _arg_2:Boolean=false):void
        {
            var _local_4:Object;
            var _local_5:DisplayObjectContainer;
            var _local_3:Array = getAllTweens();
            var _local_6:int = _local_3.length;
            while (--_local_6 > -1)
            {
                _local_4 = _local_3[_local_6].target;
                if ((_local_4 is DisplayObject))
                {
                    _local_5 = _local_4.parent;
                    while (_local_5)
                    {
                        if (_local_5 == _arg_1)
                        {
                            if (_arg_2)
                            {
                                _local_3[_local_6].complete(false);
                            }
                            else
                            {
                                _local_3[_local_6].setEnabled(false, false);
                            };
                        };
                        _local_5 = _local_5.parent;
                    };
                };
            };
        }

        public static function pauseAll(_arg_1:Boolean=true, _arg_2:Boolean=true):void
        {
            changePause(true, _arg_1, _arg_2);
        }

        public static function resumeAll(_arg_1:Boolean=true, _arg_2:Boolean=true):void
        {
            changePause(false, _arg_1, _arg_2);
        }

        private static function changePause(_arg_1:Boolean, _arg_2:Boolean=true, _arg_3:Boolean=false):void
        {
            var _local_5:Boolean;
            var _local_4:Array = getAllTweens();
            var _local_6:int = _local_4.length;
            while (--_local_6 > -1)
            {
                _local_5 = (TweenLite(_local_4[_local_6]).target == TweenLite(_local_4[_local_6]).vars.onComplete);
                if (((_local_5 == _arg_3) || (!(_local_5 == _arg_2))))
                {
                    TweenCore(_local_4[_local_6]).paused = _arg_1;
                };
            };
        }

        public static function get globalTimeScale():Number
        {
            return ((TweenLite.rootTimeline == null) ? 1 : TweenLite.rootTimeline.cachedTimeScale);
        }

        public static function set globalTimeScale(_arg_1:Number):void
        {
            if (_arg_1 == 0)
            {
                _arg_1 = 0.0001;
            };
            if (TweenLite.rootTimeline == null)
            {
                TweenLite.to({}, 0, {});
            };
            var _local_2:SimpleTimeline = TweenLite.rootTimeline;
            var _local_3:Number = (getTimer() * 0.001);
            _local_2.cachedStartTime = (_local_3 - (((_local_3 - _local_2.cachedStartTime) * _local_2.cachedTimeScale) / _arg_1));
            _local_2 = TweenLite.rootFramesTimeline;
            _local_3 = TweenLite.rootFrame;
            _local_2.cachedStartTime = (_local_3 - (((_local_3 - _local_2.cachedStartTime) * _local_2.cachedTimeScale) / _arg_1));
            TweenLite.rootFramesTimeline.cachedTimeScale = (TweenLite.rootTimeline.cachedTimeScale = _arg_1);
        }


        override protected function init():void
        {
            var _local_1:TweenMax;
            if (this.vars.startAt)
            {
                this.vars.startAt.overwrite = 0;
                this.vars.startAt.immediateRender = true;
                _local_1 = new TweenMax(this.target, 0, this.vars.startAt);
            };
            if (this._dispatcher)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.INIT));
            };
            super.init();
            if ((_ease in fastEaseLookup))
            {
                this._easeType = fastEaseLookup[_ease][0];
                this._easePower = fastEaseLookup[_ease][1];
            };
        }

        override public function invalidate():void
        {
            this.yoyo = Boolean((this.vars.yoyo == true));
            this._repeat = ((this.vars.repeat) ? Number(this.vars.repeat) : 0);
            this._repeatDelay = ((this.vars.repeatDelay) ? Number(this.vars.repeatDelay) : 0);
            this._hasUpdateListener = false;
            if ((((!(this.vars.onCompleteListener == null)) || (!(this.vars.onUpdateListener == null))) || (!(this.vars.onStartListener == null))))
            {
                this.initDispatcher();
            };
            setDirtyCache(true);
            super.invalidate();
        }

        public function updateTo(_arg_1:Object, _arg_2:Boolean=false):void
        {
            var _local_4:String;
            var _local_5:Number;
            var _local_6:PropTween;
            var _local_7:Number;
            var _local_3:Number = this.ratio;
            if ((((_arg_2) && (!(this.timeline == null))) && (this.cachedStartTime < this.timeline.cachedTime)))
            {
                this.cachedStartTime = this.timeline.cachedTime;
                this.setDirtyCache(false);
                if (this.gc)
                {
                    this.setEnabled(true, false);
                }
                else
                {
                    this.timeline.insert(this, (this.cachedStartTime - _delay));
                };
            };
            for (_local_4 in _arg_1)
            {
                this.vars[_local_4] = _arg_1[_local_4];
            };
            if (this.initted)
            {
                this.initted = false;
                if ((!(_arg_2)))
                {
                    if (((_notifyPluginsOfEnabled) && (this.cachedPT1)))
                    {
                        onPluginEvent("onDisable", this);
                    };
                    this.init();
                    if ((((!(_arg_2)) && (this.cachedTime > 0)) && (this.cachedTime < this.cachedDuration)))
                    {
                        _local_5 = (1 / (1 - _local_3));
                        _local_6 = this.cachedPT1;
                        while (_local_6)
                        {
                            _local_7 = (_local_6.start + _local_6.change);
                            _local_6.change = (_local_6.change * _local_5);
                            _local_6.start = (_local_7 - _local_6.change);
                            _local_6 = _local_6.nextNode;
                        };
                    };
                };
            };
        }

        public function setDestination(_arg_1:String, _arg_2:*, _arg_3:Boolean=true):void
        {
            var _local_4:Object = {};
            _local_4[_arg_1] = _arg_2;
            this.updateTo(_local_4, (!(_arg_3)));
        }

        public function killProperties(_arg_1:Array):void
        {
            var _local_2:Object = {};
            var _local_3:int = _arg_1.length;
            while (--_local_3 > -1)
            {
                _local_2[_arg_1[_local_3]] = true;
            };
            killVars(_local_2);
        }

        override public function renderTime(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_6:Boolean;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_10:Number;
            var _local_11:int;
            var _local_12:int;
            var _local_13:Number;
            var _local_4:Number = ((this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration);
            var _local_5:Number = this.cachedTime;
            if (_arg_1 >= _local_4)
            {
                this.cachedTotalTime = _local_4;
                this.cachedTime = this.cachedDuration;
                this.ratio = 1;
                _local_6 = true;
                if (this.cachedDuration == 0)
                {
                    if ((((_arg_1 == 0) || (_rawPrevTime < 0)) && (!(_rawPrevTime == _arg_1))))
                    {
                        _arg_3 = true;
                    };
                    _rawPrevTime = _arg_1;
                };
            }
            else
            {
                if (_arg_1 <= 0)
                {
                    if (_arg_1 < 0)
                    {
                        this.active = false;
                        if (this.cachedDuration == 0)
                        {
                            if (_rawPrevTime >= 0)
                            {
                                _arg_3 = true;
                                _local_6 = true;
                            };
                            _rawPrevTime = _arg_1;
                        };
                    }
                    else
                    {
                        if (((_arg_1 == 0) && (!(this.initted))))
                        {
                            _arg_3 = true;
                        };
                    };
                    this.cachedTotalTime = (this.cachedTime = (this.ratio = 0));
                    if (((this.cachedReversed) && (!(_local_5 == 0))))
                    {
                        _local_6 = true;
                    };
                }
                else
                {
                    this.cachedTotalTime = (this.cachedTime = _arg_1);
                    _local_8 = true;
                };
            };
            if (this._repeat != 0)
            {
                _local_10 = (this.cachedDuration + this._repeatDelay);
                if (_local_6)
                {
                    if (((this.yoyo) && (this._repeat % 2)))
                    {
                        this.cachedTime = (this.ratio = 0);
                    };
                }
                else
                {
                    if (_arg_1 > 0)
                    {
                        _local_11 = this._cyclesComplete;
                        this._cyclesComplete = ((this.cachedTotalTime / _local_10) >> 0);
                        if (this._cyclesComplete == (this.cachedTotalTime / _local_10))
                        {
                            this._cyclesComplete--;
                        };
                        if (_local_11 != this._cyclesComplete)
                        {
                            _local_7 = true;
                        };
                        this.cachedTime = (((this.cachedTotalTime / _local_10) - this._cyclesComplete) * _local_10);
                        if (((this.yoyo) && (this._cyclesComplete % 2)))
                        {
                            this.cachedTime = (this.cachedDuration - this.cachedTime);
                        }
                        else
                        {
                            if (this.cachedTime >= this.cachedDuration)
                            {
                                this.cachedTime = this.cachedDuration;
                                this.ratio = 1;
                                _local_8 = false;
                            };
                        };
                        if (this.cachedTime <= 0)
                        {
                            this.cachedTime = (this.ratio = 0);
                            _local_8 = false;
                        };
                    }
                    else
                    {
                        this._cyclesComplete = 0;
                    };
                };
            };
            if (((_local_5 == this.cachedTime) && (!(_arg_3))))
            {
                return;
            };
            if ((!(this.initted)))
            {
                this.init();
            };
            if (((!(this.active)) && (!(this.cachedPaused))))
            {
                this.active = true;
            };
            if (_local_8)
            {
                if (this._easeType)
                {
                    _local_12 = this._easePower;
                    _local_13 = (this.cachedTime / this.cachedDuration);
                    if (this._easeType == 2)
                    {
                        this.ratio = (_local_13 = (1 - _local_13));
                        while (--_local_12 > -1)
                        {
                            this.ratio = (_local_13 * this.ratio);
                        };
                        this.ratio = (1 - this.ratio);
                    }
                    else
                    {
                        if (this._easeType == 1)
                        {
                            this.ratio = _local_13;
                            while (--_local_12 > -1)
                            {
                                this.ratio = (_local_13 * this.ratio);
                            };
                        }
                        else
                        {
                            if (_local_13 < 0.5)
                            {
                                this.ratio = (_local_13 = (_local_13 * 2));
                                while (--_local_12 > -1)
                                {
                                    this.ratio = (_local_13 * this.ratio);
                                };
                                this.ratio = (this.ratio * 0.5);
                            }
                            else
                            {
                                this.ratio = (_local_13 = ((1 - _local_13) * 2));
                                while (--_local_12 > -1)
                                {
                                    this.ratio = (_local_13 * this.ratio);
                                };
                                this.ratio = (1 - (0.5 * this.ratio));
                            };
                        };
                    };
                }
                else
                {
                    this.ratio = _ease(this.cachedTime, 0, 1, this.cachedDuration);
                };
            };
            if ((((_local_5 == 0) && ((!(this.cachedTotalTime == 0)) || (this.cachedDuration == 0))) && (!(_arg_2))))
            {
                if (this.vars.onStart)
                {
                    this.vars.onStart.apply(null, this.vars.onStartParams);
                };
                if (this._dispatcher)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
                };
            };
            var _local_9:PropTween = this.cachedPT1;
            while (_local_9)
            {
                _local_9.target[_local_9.property] = (_local_9.start + (this.ratio * _local_9.change));
                _local_9 = _local_9.nextNode;
            };
            if (((_hasUpdate) && (!(_arg_2))))
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            };
            if (((this._hasUpdateListener) && (!(_arg_2))))
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            };
            if (((_local_6) && (!(this.gc))))
            {
                if (((_hasPlugins) && (this.cachedPT1)))
                {
                    onPluginEvent("onComplete", this);
                };
                this.complete(true, _arg_2);
            }
            else
            {
                if ((((_local_7) && (!(_arg_2))) && (!(this.gc))))
                {
                    if (this.vars.onRepeat)
                    {
                        this.vars.onRepeat.apply(null, this.vars.onRepeatParams);
                    };
                    if (this._dispatcher)
                    {
                        this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
                    };
                };
            };
        }

        override public function complete(_arg_1:Boolean=false, _arg_2:Boolean=false):void
        {
            super.complete(_arg_1, _arg_2);
            if (((!(_arg_2)) && (this._dispatcher)))
            {
                if (((this.cachedTotalTime == this.cachedTotalDuration) && (!(this.cachedReversed))))
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                }
                else
                {
                    if (((this.cachedReversed) && (this.cachedTotalTime == 0)))
                    {
                        this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
                    };
                };
            };
        }

        protected function initDispatcher():void
        {
            if (this._dispatcher == null)
            {
                this._dispatcher = new EventDispatcher(this);
            };
            if ((this.vars.onInitListener is Function))
            {
                this._dispatcher.addEventListener(TweenEvent.INIT, this.vars.onInitListener, false, 0, true);
            };
            if ((this.vars.onStartListener is Function))
            {
                this._dispatcher.addEventListener(TweenEvent.START, this.vars.onStartListener, false, 0, true);
            };
            if ((this.vars.onUpdateListener is Function))
            {
                this._dispatcher.addEventListener(TweenEvent.UPDATE, this.vars.onUpdateListener, false, 0, true);
                this._hasUpdateListener = true;
            };
            if ((this.vars.onCompleteListener is Function))
            {
                this._dispatcher.addEventListener(TweenEvent.COMPLETE, this.vars.onCompleteListener, false, 0, true);
            };
            if ((this.vars.onRepeatListener is Function))
            {
                this._dispatcher.addEventListener(TweenEvent.REPEAT, this.vars.onRepeatListener, false, 0, true);
            };
            if ((this.vars.onReverseCompleteListener is Function))
            {
                this._dispatcher.addEventListener(TweenEvent.REVERSE_COMPLETE, this.vars.onReverseCompleteListener, false, 0, true);
            };
        }

        public function addEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false, _arg_4:int=0, _arg_5:Boolean=false):void
        {
            if (this._dispatcher == null)
            {
                this.initDispatcher();
            };
            if (_arg_1 == TweenEvent.UPDATE)
            {
                this._hasUpdateListener = true;
            };
            this._dispatcher.addEventListener(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void
        {
            if (this._dispatcher)
            {
                this._dispatcher.removeEventListener(_arg_1, _arg_2, _arg_3);
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            return ((this._dispatcher == null) ? false : this._dispatcher.hasEventListener(_arg_1));
        }

        public function willTrigger(_arg_1:String):Boolean
        {
            return ((this._dispatcher == null) ? false : this._dispatcher.willTrigger(_arg_1));
        }

        public function dispatchEvent(_arg_1:Event):Boolean
        {
            return ((this._dispatcher == null) ? false : this._dispatcher.dispatchEvent(_arg_1));
        }

        public function get currentProgress():Number
        {
            return (this.cachedTime / this.duration);
        }

        public function set currentProgress(_arg_1:Number):void
        {
            if (this._cyclesComplete == 0)
            {
                setTotalTime((this.duration * _arg_1), false);
            }
            else
            {
                setTotalTime(((this.duration * _arg_1) + (this._cyclesComplete * this.cachedDuration)), false);
            };
        }

        public function get totalProgress():Number
        {
            return (this.cachedTotalTime / this.totalDuration);
        }

        public function set totalProgress(_arg_1:Number):void
        {
            setTotalTime((this.totalDuration * _arg_1), false);
        }

        override public function set currentTime(_arg_1:Number):void
        {
            if (this._cyclesComplete != 0)
            {
                if (((this.yoyo) && ((this._cyclesComplete % 2) == 1)))
                {
                    _arg_1 = ((this.duration - _arg_1) + (this._cyclesComplete * (this.cachedDuration + this._repeatDelay)));
                }
                else
                {
                    _arg_1 = (_arg_1 + (this._cyclesComplete * (this.duration + this._repeatDelay)));
                };
            };
            setTotalTime(_arg_1, false);
        }

        override public function get totalDuration():Number
        {
            if (this.cacheIsDirty)
            {
                this.cachedTotalDuration = ((this._repeat == -1) ? 999999999999 : ((this.cachedDuration * (this._repeat + 1)) + (this._repeatDelay * this._repeat)));
                this.cacheIsDirty = false;
            };
            return (this.cachedTotalDuration);
        }

        override public function set totalDuration(_arg_1:Number):void
        {
            if (this._repeat == -1)
            {
                return;
            };
            this.duration = ((_arg_1 - (this._repeat * this._repeatDelay)) / (this._repeat + 1));
        }

        public function get timeScale():Number
        {
            return (this.cachedTimeScale);
        }

        public function set timeScale(_arg_1:Number):void
        {
            if (_arg_1 == 0)
            {
                _arg_1 = 0.0001;
            };
            var _local_2:Number = (((this.cachedPauseTime) || (this.cachedPauseTime == 0)) ? this.cachedPauseTime : this.timeline.cachedTotalTime);
            this.cachedStartTime = (_local_2 - (((_local_2 - this.cachedStartTime) * this.cachedTimeScale) / _arg_1));
            this.cachedTimeScale = _arg_1;
            setDirtyCache(false);
        }

        public function get repeat():int
        {
            return (this._repeat);
        }

        public function set repeat(_arg_1:int):void
        {
            this._repeat = _arg_1;
            setDirtyCache(true);
        }

        public function get repeatDelay():Number
        {
            return (this._repeatDelay);
        }

        public function set repeatDelay(_arg_1:Number):void
        {
            this._repeatDelay = _arg_1;
            setDirtyCache(true);
        }


    }
}//package com.greensock

