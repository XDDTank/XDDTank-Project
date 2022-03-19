// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.TimelineMax

package com.greensock
{
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import com.greensock.core.TweenCore;
    import com.greensock.events.TweenEvent;
    import flash.events.Event;
    import com.greensock.core.*;
    import flash.events.*;

    public class TimelineMax extends TimelineLite implements IEventDispatcher 
    {

        public static const version:Number = 1.64;

        protected var _repeat:int;
        protected var _repeatDelay:Number;
        protected var _cyclesComplete:int;
        protected var _dispatcher:EventDispatcher;
        protected var _hasUpdateListener:Boolean;
        public var yoyo:Boolean;

        public function TimelineMax(_arg_1:Object=null)
        {
            super(_arg_1);
            this._repeat = ((this.vars.repeat) ? Number(this.vars.repeat) : 0);
            this._repeatDelay = ((this.vars.repeatDelay) ? Number(this.vars.repeatDelay) : 0);
            this._cyclesComplete = 0;
            this.yoyo = Boolean((this.vars.yoyo == true));
            this.cacheIsDirty = true;
            if ((((((!(this.vars.onCompleteListener == null)) || (!(this.vars.onUpdateListener == null))) || (!(this.vars.onStartListener == null))) || (!(this.vars.onRepeatListener == null))) || (!(this.vars.onReverseCompleteListener == null))))
            {
                this.initDispatcher();
            };
        }

        private static function onInitTweenTo(_arg_1:TweenLite, _arg_2:TimelineMax, _arg_3:Number):void
        {
            _arg_2.paused = true;
            if ((!(isNaN(_arg_3))))
            {
                _arg_2.currentTime = _arg_3;
            };
            if (_arg_1.vars.currentTime != _arg_2.currentTime)
            {
                _arg_1.duration = (Math.abs((Number(_arg_1.vars.currentTime) - _arg_2.currentTime)) / _arg_2.cachedTimeScale);
            };
        }

        private static function easeNone(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (_arg_1 / _arg_4);
        }


        public function addCallback(_arg_1:Function, _arg_2:*, _arg_3:Array=null):TweenLite
        {
            var _local_4:TweenLite = new TweenLite(_arg_1, 0, {
                "onComplete":_arg_1,
                "onCompleteParams":_arg_3,
                "overwrite":0,
                "immediateRender":false
            });
            insert(_local_4, _arg_2);
            return (_local_4);
        }

        public function removeCallback(_arg_1:Function, _arg_2:*=null):Boolean
        {
            var _local_3:Array;
            var _local_4:Boolean;
            var _local_5:int;
            if (_arg_2 == null)
            {
                return (killTweensOf(_arg_1, false));
            };
            if (typeof(_arg_2) == "string")
            {
                if ((!(_arg_2 in _labels)))
                {
                    return (false);
                };
                _arg_2 = _labels[_arg_2];
            };
            _local_3 = getTweensOf(_arg_1, false);
            _local_5 = _local_3.length;
            while (--_local_5 > -1)
            {
                if (_local_3[_local_5].cachedStartTime == _arg_2)
                {
                    remove((_local_3[_local_5] as TweenCore));
                    _local_4 = true;
                };
            };
            return (_local_4);
        }

        public function tweenTo(_arg_1:*, _arg_2:Object=null):TweenLite
        {
            var _local_4:String;
            var _local_5:TweenLite;
            var _local_3:Object = {
                "ease":easeNone,
                "overwrite":2,
                "useFrames":this.useFrames,
                "immediateRender":false
            };
            for (_local_4 in _arg_2)
            {
                _local_3[_local_4] = _arg_2[_local_4];
            };
            _local_3.onInit = onInitTweenTo;
            _local_3.onInitParams = [null, this, NaN];
            _local_3.currentTime = parseTimeOrLabel(_arg_1);
            _local_5 = new TweenLite(this, ((Math.abs((Number(_local_3.currentTime) - this.cachedTime)) / this.cachedTimeScale) || (0.001)), _local_3);
            _local_5.vars.onInitParams[0] = _local_5;
            return (_local_5);
        }

        public function tweenFromTo(_arg_1:*, _arg_2:*, _arg_3:Object=null):TweenLite
        {
            var _local_4:TweenLite = this.tweenTo(_arg_2, _arg_3);
            _local_4.vars.onInitParams[2] = parseTimeOrLabel(_arg_1);
            _local_4.duration = (Math.abs((Number(_local_4.vars.currentTime) - _local_4.vars.onInitParams[2])) / this.cachedTimeScale);
            return (_local_4);
        }

        override public function renderTime(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_8:TweenCore;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:Boolean;
            var _local_12:TweenCore;
            var _local_13:Number;
            var _local_15:Number;
            var _local_16:int;
            var _local_17:Boolean;
            var _local_18:Boolean;
            var _local_19:Boolean;
            if (this.gc)
            {
                this.setEnabled(true, false);
            }
            else
            {
                if (((!(this.active)) && (!(this.cachedPaused))))
                {
                    this.active = true;
                };
            };
            var _local_4:Number = ((this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration);
            var _local_5:Number = this.cachedTime;
            var _local_6:Number = this.cachedStartTime;
            var _local_7:Number = this.cachedTimeScale;
            var _local_14:Boolean = this.cachedPaused;
            if (_arg_1 >= _local_4)
            {
                if (((_rawPrevTime <= _local_4) && (!(_rawPrevTime == _arg_1))))
                {
                    if ((((!(this.cachedReversed)) && (this.yoyo)) && (!((this._repeat % 2) == 0))))
                    {
                        forceChildrenToBeginning(0, _arg_2);
                        this.cachedTime = 0;
                    }
                    else
                    {
                        forceChildrenToEnd(this.cachedDuration, _arg_2);
                        this.cachedTime = this.cachedDuration;
                    };
                    this.cachedTotalTime = _local_4;
                    _local_9 = (!(this.hasPausedChild()));
                    _local_10 = true;
                    if ((((this.cachedDuration == 0) && (_local_9)) && ((_arg_1 == 0) || (_rawPrevTime < 0))))
                    {
                        _arg_3 = true;
                    };
                };
            }
            else
            {
                if (_arg_1 <= 0)
                {
                    if (_arg_1 < 0)
                    {
                        this.active = false;
                        if (((this.cachedDuration == 0) && (_rawPrevTime >= 0)))
                        {
                            _arg_3 = true;
                            _local_9 = true;
                        };
                    }
                    else
                    {
                        if (((_arg_1 == 0) && (!(this.initted))))
                        {
                            _arg_3 = true;
                        };
                    };
                    if (((_rawPrevTime >= 0) && (!(_rawPrevTime == _arg_1))))
                    {
                        this.cachedTotalTime = 0;
                        forceChildrenToBeginning(0, _arg_2);
                        this.cachedTime = 0;
                        _local_10 = true;
                        if (this.cachedReversed)
                        {
                            _local_9 = true;
                        };
                    };
                }
                else
                {
                    this.cachedTotalTime = (this.cachedTime = _arg_1);
                };
            };
            _rawPrevTime = _arg_1;
            if (this._repeat != 0)
            {
                _local_15 = (this.cachedDuration + this._repeatDelay);
                _local_16 = this._cyclesComplete;
                if (_local_9)
                {
                    if (((this.yoyo) && (this._repeat % 2)))
                    {
                        this.cachedTime = 0;
                    };
                }
                else
                {
                    if (_arg_1 > 0)
                    {
                        this._cyclesComplete = ((this.cachedTotalTime / _local_15) >> 0);
                        if (this._cyclesComplete == (this.cachedTotalTime / _local_15))
                        {
                            this._cyclesComplete--;
                        };
                        if (_local_16 != this._cyclesComplete)
                        {
                            _local_11 = true;
                        };
                        this.cachedTime = (((this.cachedTotalTime / _local_15) - this._cyclesComplete) * _local_15);
                        if (((this.yoyo) && (this._cyclesComplete % 2)))
                        {
                            this.cachedTime = (this.cachedDuration - this.cachedTime);
                        }
                        else
                        {
                            if (this.cachedTime >= this.cachedDuration)
                            {
                                this.cachedTime = this.cachedDuration;
                            };
                        };
                        if (this.cachedTime < 0)
                        {
                            this.cachedTime = 0;
                        };
                    }
                    else
                    {
                        this._cyclesComplete = 0;
                    };
                };
                if ((((_local_11) && (!(_local_9))) && ((!(this.cachedTime == _local_5)) || (_arg_3))))
                {
                    _local_17 = Boolean(((!(this.yoyo)) || ((this._cyclesComplete % 2) == 0)));
                    _local_18 = Boolean(((!(this.yoyo)) || ((_local_16 % 2) == 0)));
                    _local_19 = Boolean((_local_17 == _local_18));
                    if (_local_16 > this._cyclesComplete)
                    {
                        _local_18 = (!(_local_18));
                    };
                    if (_local_18)
                    {
                        _local_5 = forceChildrenToEnd(this.cachedDuration, _arg_2);
                        if (_local_19)
                        {
                            _local_5 = forceChildrenToBeginning(0, true);
                        };
                    }
                    else
                    {
                        _local_5 = forceChildrenToBeginning(0, _arg_2);
                        if (_local_19)
                        {
                            _local_5 = forceChildrenToEnd(this.cachedDuration, true);
                        };
                    };
                    _local_10 = false;
                };
            };
            if (((this.cachedTime == _local_5) && (!(_arg_3))))
            {
                return;
            };
            if ((!(this.initted)))
            {
                this.initted = true;
            };
            if ((((_local_5 == 0) && (!(this.cachedTotalTime == 0))) && (!(_arg_2))))
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
            if (!_local_10)
            {
                if ((this.cachedTime - _local_5) > 0)
                {
                    _local_8 = _firstChild;
                    while (_local_8)
                    {
                        _local_12 = _local_8.nextNode;
                        if (((this.cachedPaused) && (!(_local_14)))) break;
                        if (((_local_8.active) || (((!(_local_8.cachedPaused)) && (_local_8.cachedStartTime <= this.cachedTime)) && (!(_local_8.gc)))))
                        {
                            if ((!(_local_8.cachedReversed)))
                            {
                                _local_8.renderTime(((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale), _arg_2, false);
                            }
                            else
                            {
                                _local_13 = ((_local_8.cacheIsDirty) ? _local_8.totalDuration : _local_8.cachedTotalDuration);
                                _local_8.renderTime((_local_13 - ((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale)), _arg_2, false);
                            };
                        };
                        _local_8 = _local_12;
                    };
                }
                else
                {
                    _local_8 = _lastChild;
                    while (_local_8)
                    {
                        _local_12 = _local_8.prevNode;
                        if (((this.cachedPaused) && (!(_local_14)))) break;
                        if (((_local_8.active) || (((!(_local_8.cachedPaused)) && (_local_8.cachedStartTime <= _local_5)) && (!(_local_8.gc)))))
                        {
                            if ((!(_local_8.cachedReversed)))
                            {
                                _local_8.renderTime(((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale), _arg_2, false);
                            }
                            else
                            {
                                _local_13 = ((_local_8.cacheIsDirty) ? _local_8.totalDuration : _local_8.cachedTotalDuration);
                                _local_8.renderTime((_local_13 - ((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale)), _arg_2, false);
                            };
                        };
                        _local_8 = _local_12;
                    };
                };
            };
            if (((_hasUpdate) && (!(_arg_2))))
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            };
            if (((this._hasUpdateListener) && (!(_arg_2))))
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            };
            if ((((_local_9) && ((_local_6 == this.cachedStartTime) || (!(_local_7 == this.cachedTimeScale)))) && ((_local_4 >= this.totalDuration) || (this.cachedTime == 0))))
            {
                this.complete(true, _arg_2);
            }
            else
            {
                if (((_local_11) && (!(_arg_2))))
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
            if (((this._dispatcher) && (!(_arg_2))))
            {
                if ((((this.cachedReversed) && (this.cachedTotalTime == 0)) && (!(this.cachedDuration == 0))))
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
                }
                else
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                };
            };
        }

        public function getActive(_arg_1:Boolean=true, _arg_2:Boolean=true, _arg_3:Boolean=false):Array
        {
            var _local_6:int;
            var _local_4:Array = [];
            var _local_5:Array = getChildren(_arg_1, _arg_2, _arg_3);
            var _local_7:int = _local_5.length;
            var _local_8:int;
            _local_6 = 0;
            while (_local_6 < _local_7)
            {
                if (TweenCore(_local_5[_local_6]).active)
                {
                    var _local_9:* = _local_8++;
                    _local_4[_local_9] = _local_5[_local_6];
                };
                _local_6 = (_local_6 + 1);
            };
            return (_local_4);
        }

        override public function invalidate():void
        {
            this._repeat = ((this.vars.repeat) ? Number(this.vars.repeat) : 0);
            this._repeatDelay = ((this.vars.repeatDelay) ? Number(this.vars.repeatDelay) : 0);
            this.yoyo = Boolean((this.vars.yoyo == true));
            if ((((((!(this.vars.onCompleteListener == null)) || (!(this.vars.onUpdateListener == null))) || (!(this.vars.onStartListener == null))) || (!(this.vars.onRepeatListener == null))) || (!(this.vars.onReverseCompleteListener == null))))
            {
                this.initDispatcher();
            };
            setDirtyCache(true);
            super.invalidate();
        }

        public function getLabelAfter(_arg_1:Number=NaN):String
        {
            if (((!(_arg_1)) && (!(_arg_1 == 0))))
            {
                _arg_1 = this.cachedTime;
            };
            var _local_2:Array = this.getLabelsArray();
            var _local_3:int = _local_2.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                if (_local_2[_local_4].time > _arg_1)
                {
                    return (_local_2[_local_4].name);
                };
                _local_4 = (_local_4 + 1);
            };
            return (null);
        }

        public function getLabelBefore(_arg_1:Number=NaN):String
        {
            if (((!(_arg_1)) && (!(_arg_1 == 0))))
            {
                _arg_1 = this.cachedTime;
            };
            var _local_2:Array = this.getLabelsArray();
            var _local_3:int = _local_2.length;
            while (--_local_3 > -1)
            {
                if (_local_2[_local_3].time < _arg_1)
                {
                    return (_local_2[_local_3].name);
                };
            };
            return (null);
        }

        protected function getLabelsArray():Array
        {
            var _local_2:String;
            var _local_1:Array = [];
            for (_local_2 in _labels)
            {
                _local_1[_local_1.length] = {
                    "time":_labels[_local_2],
                    "name":_local_2
                };
            };
            _local_1.sortOn("time", Array.NUMERIC);
            return (_local_1);
        }

        protected function initDispatcher():void
        {
            if (this._dispatcher == null)
            {
                this._dispatcher = new EventDispatcher(this);
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
            if (this._dispatcher != null)
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

        public function get totalProgress():Number
        {
            return (this.cachedTotalTime / this.totalDuration);
        }

        public function set totalProgress(_arg_1:Number):void
        {
            setTotalTime((this.totalDuration * _arg_1), false);
        }

        override public function get totalDuration():Number
        {
            var _local_1:Number;
            if (this.cacheIsDirty)
            {
                _local_1 = super.totalDuration;
                this.cachedTotalDuration = ((this._repeat == -1) ? 999999999999 : ((this.cachedDuration * (this._repeat + 1)) + (this._repeatDelay * this._repeat)));
            };
            return (this.cachedTotalDuration);
        }

        override public function set currentTime(_arg_1:Number):void
        {
            if (this._cyclesComplete == 0)
            {
                setTotalTime(_arg_1, false);
            }
            else
            {
                if (((this.yoyo) && ((this._cyclesComplete % 2) == 1)))
                {
                    setTotalTime(((this.duration - _arg_1) + (this._cyclesComplete * (this.cachedDuration + this._repeatDelay))), false);
                }
                else
                {
                    setTotalTime((_arg_1 + (this._cyclesComplete * (this.duration + this._repeatDelay))), false);
                };
            };
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

        public function get currentLabel():String
        {
            return (this.getLabelBefore((this.cachedTime + 1E-8)));
        }


    }
}//package com.greensock

