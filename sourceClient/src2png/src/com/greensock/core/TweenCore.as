// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.core.TweenCore

package com.greensock.core
{
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class TweenCore 
    {

        public static const version:Number = 1.64;
        protected static var _classInitted:Boolean;

        protected var _delay:Number;
        protected var _hasUpdate:Boolean;
        protected var _rawPrevTime:Number = -1;
        public var vars:Object;
        public var active:Boolean;
        public var gc:Boolean;
        public var initted:Boolean;
        public var timeline:SimpleTimeline;
        public var cachedStartTime:Number;
        public var cachedTime:Number;
        public var cachedTotalTime:Number;
        public var cachedDuration:Number;
        public var cachedTotalDuration:Number;
        public var cachedTimeScale:Number;
        public var cachedPauseTime:Number;
        public var cachedReversed:Boolean;
        public var nextNode:TweenCore;
        public var prevNode:TweenCore;
        public var cachedOrphan:Boolean;
        public var cacheIsDirty:Boolean;
        public var cachedPaused:Boolean;
        public var data:*;

        public function TweenCore(_arg_1:Number=0, _arg_2:Object=null)
        {
            this.vars = ((_arg_2 != null) ? _arg_2 : {});
            if (this.vars.isGSVars)
            {
                this.vars = this.vars.vars;
            };
            this.cachedDuration = (this.cachedTotalDuration = _arg_1);
            this._delay = ((this.vars.delay) ? Number(this.vars.delay) : 0);
            this.cachedTimeScale = ((this.vars.timeScale) ? Number(this.vars.timeScale) : 1);
            this.active = Boolean((((_arg_1 == 0) && (this._delay == 0)) && (!(this.vars.immediateRender == false))));
            this.cachedTotalTime = (this.cachedTime = 0);
            this.data = this.vars.data;
            if ((!(_classInitted)))
            {
                if (isNaN(TweenLite.rootFrame))
                {
                    TweenLite.initClass();
                    _classInitted = true;
                }
                else
                {
                    return;
                };
            };
            var _local_3:SimpleTimeline = ((this.vars.timeline is SimpleTimeline) ? this.vars.timeline : ((this.vars.useFrames) ? TweenLite.rootFramesTimeline : TweenLite.rootTimeline));
            _local_3.insert(this, _local_3.cachedTotalTime);
            if (this.vars.reversed)
            {
                this.cachedReversed = true;
            };
            if (this.vars.paused)
            {
                this.paused = true;
            };
        }

        public function play():void
        {
            this.reversed = false;
            this.paused = false;
        }

        public function pause():void
        {
            this.paused = true;
        }

        public function resume():void
        {
            this.paused = false;
        }

        public function restart(_arg_1:Boolean=false, _arg_2:Boolean=true):void
        {
            this.reversed = false;
            this.paused = false;
            this.setTotalTime(((_arg_1) ? -(this._delay) : 0), _arg_2);
        }

        public function reverse(_arg_1:Boolean=true):void
        {
            this.reversed = true;
            if (_arg_1)
            {
                this.paused = false;
            }
            else
            {
                if (this.gc)
                {
                    this.setEnabled(true, false);
                };
            };
        }

        public function renderTime(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
        }

        public function complete(_arg_1:Boolean=false, _arg_2:Boolean=false):void
        {
            if ((!(_arg_1)))
            {
                this.renderTime(this.totalDuration, _arg_2, false);
                return;
            };
            if (this.timeline.autoRemoveChildren)
            {
                this.setEnabled(false, false);
            }
            else
            {
                this.active = false;
            };
            if ((!(_arg_2)))
            {
                if ((((this.vars.onComplete) && (this.cachedTotalTime >= this.cachedTotalDuration)) && (!(this.cachedReversed))))
                {
                    this.vars.onComplete.apply(null, this.vars.onCompleteParams);
                }
                else
                {
                    if ((((this.cachedReversed) && (this.cachedTotalTime == 0)) && (this.vars.onReverseComplete)))
                    {
                        this.vars.onReverseComplete.apply(null, this.vars.onReverseCompleteParams);
                    };
                };
            };
        }

        public function invalidate():void
        {
        }

        public function setEnabled(_arg_1:Boolean, _arg_2:Boolean=false):Boolean
        {
            this.gc = (!(_arg_1));
            if (_arg_1)
            {
                this.active = Boolean((((!(this.cachedPaused)) && (this.cachedTotalTime > 0)) && (this.cachedTotalTime < this.cachedTotalDuration)));
                if (((!(_arg_2)) && (this.cachedOrphan)))
                {
                    this.timeline.insert(this, (this.cachedStartTime - this._delay));
                };
            }
            else
            {
                this.active = false;
                if (((!(_arg_2)) && (!(this.cachedOrphan))))
                {
                    this.timeline.remove(this, true);
                };
            };
            return (false);
        }

        public function kill():void
        {
            this.setEnabled(false, false);
        }

        protected function setDirtyCache(_arg_1:Boolean=true):void
        {
            var _local_2:TweenCore = ((_arg_1) ? this : this.timeline);
            while (_local_2)
            {
                _local_2.cacheIsDirty = true;
                _local_2 = _local_2.timeline;
            };
        }

        protected function setTotalTime(_arg_1:Number, _arg_2:Boolean=false):void
        {
            var _local_3:Number;
            var _local_4:Number;
            if (this.timeline)
            {
                _local_3 = ((this.cachedPaused) ? this.cachedPauseTime : this.timeline.cachedTotalTime);
                if (this.cachedReversed)
                {
                    _local_4 = ((this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration);
                    this.cachedStartTime = (_local_3 - ((_local_4 - _arg_1) / this.cachedTimeScale));
                }
                else
                {
                    this.cachedStartTime = (_local_3 - (_arg_1 / this.cachedTimeScale));
                };
                if ((!(this.timeline.cacheIsDirty)))
                {
                    this.setDirtyCache(false);
                };
                if (this.cachedTotalTime != _arg_1)
                {
                    this.renderTime(_arg_1, _arg_2, false);
                };
            };
        }

        public function get delay():Number
        {
            return (this._delay);
        }

        public function set delay(_arg_1:Number):void
        {
            this.startTime = (this.startTime + (_arg_1 - this._delay));
            this._delay = _arg_1;
        }

        public function get duration():Number
        {
            return (this.cachedDuration);
        }

        public function set duration(_arg_1:Number):void
        {
            var _local_2:Number = (_arg_1 / this.cachedDuration);
            this.cachedDuration = (this.cachedTotalDuration = _arg_1);
            if ((((this.active) && (!(this.cachedPaused))) && (!(_arg_1 == 0))))
            {
                this.setTotalTime((this.cachedTotalTime * _local_2), true);
            };
            this.setDirtyCache(false);
        }

        public function get totalDuration():Number
        {
            return (this.cachedTotalDuration);
        }

        public function set totalDuration(_arg_1:Number):void
        {
            this.duration = _arg_1;
        }

        public function get currentTime():Number
        {
            return (this.cachedTime);
        }

        public function set currentTime(_arg_1:Number):void
        {
            this.setTotalTime(_arg_1, false);
        }

        public function get totalTime():Number
        {
            return (this.cachedTotalTime);
        }

        public function set totalTime(_arg_1:Number):void
        {
            this.setTotalTime(_arg_1, false);
        }

        public function get startTime():Number
        {
            return (this.cachedStartTime);
        }

        public function set startTime(_arg_1:Number):void
        {
            if (((!(this.timeline == null)) && ((!(_arg_1 == this.cachedStartTime)) || (this.gc))))
            {
                this.timeline.insert(this, (_arg_1 - this._delay));
            }
            else
            {
                this.cachedStartTime = _arg_1;
            };
        }

        public function get reversed():Boolean
        {
            return (this.cachedReversed);
        }

        public function set reversed(_arg_1:Boolean):void
        {
            if (_arg_1 != this.cachedReversed)
            {
                this.cachedReversed = _arg_1;
                this.setTotalTime(this.cachedTotalTime, true);
            };
        }

        public function get paused():Boolean
        {
            return (this.cachedPaused);
        }

        public function set paused(_arg_1:Boolean):void
        {
            if (((!(_arg_1 == this.cachedPaused)) && (this.timeline)))
            {
                if (_arg_1)
                {
                    this.cachedPauseTime = this.timeline.rawTime;
                }
                else
                {
                    this.cachedStartTime = (this.cachedStartTime + (this.timeline.rawTime - this.cachedPauseTime));
                    this.cachedPauseTime = NaN;
                    this.setDirtyCache(false);
                };
                this.cachedPaused = _arg_1;
                this.active = Boolean((((!(this.cachedPaused)) && (this.cachedTotalTime > 0)) && (this.cachedTotalTime < this.cachedTotalDuration)));
            };
            if (((!(_arg_1)) && (this.gc)))
            {
                this.setTotalTime(this.cachedTotalTime, false);
                this.setEnabled(true, false);
            };
        }


    }
}//package com.greensock.core

