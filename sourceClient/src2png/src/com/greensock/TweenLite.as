// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.TweenLite

package com.greensock
{
    import com.greensock.core.TweenCore;
    import flash.utils.Dictionary;
    import com.greensock.core.SimpleTimeline;
    import flash.display.Shape;
    import com.greensock.core.PropTween;
    import flash.utils.getTimer;
    import flash.events.Event;
    import flash.utils.*;
    import flash.display.*;
    import com.greensock.core.*;
    import flash.events.*;
    import com.greensock.plugins.*;

    public class TweenLite extends TweenCore 
    {

        public static const version:Number = 11.62;
        public static var plugins:Object = {};
        public static var fastEaseLookup:Dictionary = new Dictionary(false);
        public static var onPluginEvent:Function;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
        public static var defaultEase:Function = TweenLite.easeOut;
        public static var overwriteManager:Object;
        public static var rootFrame:Number;
        public static var rootTimeline:SimpleTimeline;
        public static var rootFramesTimeline:SimpleTimeline;
        public static var masterList:Dictionary = new Dictionary(false);
        private static var _shape:Shape = new Shape();
        protected static var _reservedProps:Object = {
            "ease":1,
            "delay":1,
            "overwrite":1,
            "onComplete":1,
            "onCompleteParams":1,
            "useFrames":1,
            "runBackwards":1,
            "startAt":1,
            "onUpdate":1,
            "onUpdateParams":1,
            "onStart":1,
            "onStartParams":1,
            "onInit":1,
            "onInitParams":1,
            "onReverseComplete":1,
            "onReverseCompleteParams":1,
            "onRepeat":1,
            "onRepeatParams":1,
            "proxiedEase":1,
            "easeParams":1,
            "yoyo":1,
            "onCompleteListener":1,
            "onUpdateListener":1,
            "onStartListener":1,
            "onReverseCompleteListener":1,
            "onRepeatListener":1,
            "orientToBezier":1,
            "timeScale":1,
            "immediateRender":1,
            "repeat":1,
            "repeatDelay":1,
            "timeline":1,
            "data":1,
            "paused":1
        };

        public var target:Object;
        public var propTweenLookup:Object;
        public var ratio:Number = 0;
        public var cachedPT1:PropTween;
        protected var _ease:Function;
        protected var _overwrite:int;
        protected var _overwrittenProps:Object;
        protected var _hasPlugins:Boolean;
        protected var _notifyPluginsOfEnabled:Boolean;

        public function TweenLite(_arg_1:Object, _arg_2:Number, _arg_3:Object)
        {
            var _local_5:TweenLite;
            super(_arg_2, _arg_3);
            if (_arg_1 == null)
            {
                throw (new Error("Cannot tween a null object."));
            };
            this.target = _arg_1;
            if (((this.target is TweenCore) && (this.vars.timeScale)))
            {
                this.cachedTimeScale = 1;
            };
            this.propTweenLookup = {};
            this._ease = defaultEase;
            this._overwrite = (((!(Number(_arg_3.overwrite) > -1)) || ((!(overwriteManager.enabled)) && (_arg_3.overwrite > 1))) ? overwriteManager.mode : int(_arg_3.overwrite));
            var _local_4:Array = masterList[_arg_1];
            if ((!(_local_4)))
            {
                masterList[_arg_1] = [this];
            }
            else
            {
                if (this._overwrite == 1)
                {
                    for each (_local_5 in _local_4)
                    {
                        if ((!(_local_5.gc)))
                        {
                            _local_5.setEnabled(false, false);
                        };
                    };
                    masterList[_arg_1] = [this];
                }
                else
                {
                    _local_4[_local_4.length] = this;
                };
            };
            if (((this.active) || (this.vars.immediateRender)))
            {
                this.renderTime(0, false, true);
            };
        }

        public static function initClass():void
        {
            rootFrame = 0;
            rootTimeline = new SimpleTimeline(null);
            rootFramesTimeline = new SimpleTimeline(null);
            rootTimeline.cachedStartTime = (getTimer() * 0.001);
            rootFramesTimeline.cachedStartTime = rootFrame;
            rootTimeline.autoRemoveChildren = true;
            rootFramesTimeline.autoRemoveChildren = true;
            _shape.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
            if (overwriteManager == null)
            {
                overwriteManager = {
                    "mode":1,
                    "enabled":false
                };
            };
        }

        public static function to(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenLite
        {
            return (new TweenLite(_arg_1, _arg_2, _arg_3));
        }

        public static function from(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenLite
        {
            _arg_3.runBackwards = true;
            if ((!("immediateRender" in _arg_3)))
            {
                _arg_3.immediateRender = true;
            };
            return (new TweenLite(_arg_1, _arg_2, _arg_3));
        }

        public static function delayedCall(_arg_1:Number, _arg_2:Function, _arg_3:Array=null, _arg_4:Boolean=false):TweenLite
        {
            return (new TweenLite(_arg_2, 0, {
                "delay":_arg_1,
                "onComplete":_arg_2,
                "onCompleteParams":_arg_3,
                "immediateRender":false,
                "useFrames":_arg_4,
                "overwrite":0
            }));
        }

        protected static function updateAll(_arg_1:Event=null):void
        {
            var _local_2:Dictionary;
            var _local_3:Object;
            var _local_4:Array;
            var _local_5:int;
            rootTimeline.renderTime((((getTimer() * 0.001) - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale), false, false);
            rootFrame = (rootFrame + 1);
            rootFramesTimeline.renderTime(((rootFrame - rootFramesTimeline.cachedStartTime) * rootFramesTimeline.cachedTimeScale), false, false);
            if ((!(rootFrame % 60)))
            {
                _local_2 = masterList;
                for (_local_3 in _local_2)
                {
                    _local_4 = _local_2[_local_3];
                    _local_5 = _local_4.length;
                    while (--_local_5 > -1)
                    {
                        if (TweenLite(_local_4[_local_5]).gc)
                        {
                            _local_4.splice(_local_5, 1);
                        };
                    };
                    if (_local_4.length == 0)
                    {
                        delete _local_2[_local_3];
                    };
                };
            };
        }

        public static function killTweensOf(_arg_1:Object, _arg_2:Boolean=false, _arg_3:Object=null):void
        {
            var _local_4:Array;
            var _local_5:int;
            var _local_6:TweenLite;
            if ((_arg_1 in masterList))
            {
                _local_4 = masterList[_arg_1];
                _local_5 = _local_4.length;
                while (--_local_5 > -1)
                {
                    _local_6 = _local_4[_local_5];
                    if ((!(_local_6.gc)))
                    {
                        if (_arg_2)
                        {
                            _local_6.complete(false, false);
                        };
                        if (_arg_3 != null)
                        {
                            _local_6.killVars(_arg_3);
                        };
                        if (((_arg_3 == null) || ((_local_6.cachedPT1 == null) && (_local_6.initted))))
                        {
                            _local_6.setEnabled(false, false);
                        };
                    };
                };
                if (_arg_3 == null)
                {
                    delete masterList[_arg_1];
                };
            };
        }

        protected static function easeOut(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (1 - ((_arg_1 = (1 - (_arg_1 / _arg_4))) * _arg_1));
        }


        protected function init():void
        {
            var _local_1:String;
            var _local_2:int;
            var _local_3:*;
            var _local_4:Boolean;
            var _local_5:Array;
            var _local_6:PropTween;
            if (this.vars.onInit)
            {
                this.vars.onInit.apply(null, this.vars.onInitParams);
            };
            if (typeof(this.vars.ease) == "function")
            {
                this._ease = this.vars.ease;
            };
            if (this.vars.easeParams)
            {
                this.vars.proxiedEase = this._ease;
                this._ease = this.easeProxy;
            };
            this.cachedPT1 = null;
            this.propTweenLookup = {};
            for (_local_1 in this.vars)
            {
                if (!((_local_1 in _reservedProps) && (!((_local_1 == "timeScale") && (this.target is TweenCore)))))
                {
                    if (((_local_1 in plugins) && ((_local_3 = new ((plugins[_local_1] as Class))()).onInitTween(this.target, this.vars[_local_1], this))))
                    {
                        this.cachedPT1 = new PropTween(_local_3, "changeFactor", 0, 1, ((_local_3.overwriteProps.length == 1) ? _local_3.overwriteProps[0] : "_MULTIPLE_"), true, this.cachedPT1);
                        if (this.cachedPT1.name == "_MULTIPLE_")
                        {
                            _local_2 = _local_3.overwriteProps.length;
                            while (--_local_2 > -1)
                            {
                                this.propTweenLookup[_local_3.overwriteProps[_local_2]] = this.cachedPT1;
                            };
                        }
                        else
                        {
                            this.propTweenLookup[this.cachedPT1.name] = this.cachedPT1;
                        };
                        if (_local_3.priority)
                        {
                            this.cachedPT1.priority = _local_3.priority;
                            _local_4 = true;
                        };
                        if (((_local_3.onDisable) || (_local_3.onEnable)))
                        {
                            this._notifyPluginsOfEnabled = true;
                        };
                        this._hasPlugins = true;
                    }
                    else
                    {
                        this.cachedPT1 = new PropTween(this.target, _local_1, Number(this.target[_local_1]), ((typeof(this.vars[_local_1]) == "number") ? (Number(this.vars[_local_1]) - this.target[_local_1]) : Number(this.vars[_local_1])), _local_1, false, this.cachedPT1);
                        this.propTweenLookup[_local_1] = this.cachedPT1;
                    };
                };
            };
            if (_local_4)
            {
                onPluginEvent("onInitAllProps", this);
            };
            if (this.vars.runBackwards)
            {
                _local_6 = this.cachedPT1;
                while (_local_6)
                {
                    _local_6.start = (_local_6.start + _local_6.change);
                    _local_6.change = -(_local_6.change);
                    _local_6 = _local_6.nextNode;
                };
            };
            _hasUpdate = Boolean((!(this.vars.onUpdate == null)));
            if (this._overwrittenProps)
            {
                this.killVars(this._overwrittenProps);
                if (this.cachedPT1 == null)
                {
                    this.setEnabled(false, false);
                };
            };
            if (((((this._overwrite > 1) && (this.cachedPT1)) && (_local_5 = masterList[this.target])) && (_local_5.length > 1)))
            {
                if (overwriteManager.manageOverwrites(this, this.propTweenLookup, _local_5, this._overwrite))
                {
                    this.init();
                };
            };
            this.initted = true;
        }

        override public function renderTime(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_4:Boolean;
            var _local_5:Number = this.cachedTime;
            if (_arg_1 >= this.cachedDuration)
            {
                this.cachedTotalTime = (this.cachedTime = this.cachedDuration);
                this.ratio = 1;
                _local_4 = true;
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
                    this.cachedTotalTime = (this.cachedTime = (this.ratio = 0));
                    if (_arg_1 < 0)
                    {
                        this.active = false;
                        if (this.cachedDuration == 0)
                        {
                            if (_rawPrevTime >= 0)
                            {
                                _arg_3 = true;
                                _local_4 = true;
                            };
                            _rawPrevTime = _arg_1;
                        };
                    };
                    if (((this.cachedReversed) && (!(_local_5 == 0))))
                    {
                        _local_4 = true;
                    };
                }
                else
                {
                    this.cachedTotalTime = (this.cachedTime = _arg_1);
                    this.ratio = this._ease(_arg_1, 0, 1, this.cachedDuration);
                };
            };
            if (((this.cachedTime == _local_5) && (!(_arg_3))))
            {
                return;
            };
            if ((!(this.initted)))
            {
                this.init();
                if (((!(_local_4)) && (this.cachedTime)))
                {
                    this.ratio = this._ease(this.cachedTime, 0, 1, this.cachedDuration);
                };
            };
            if (((!(this.active)) && (!(this.cachedPaused))))
            {
                this.active = true;
            };
            if (((((_local_5 == 0) && (this.vars.onStart)) && ((!(this.cachedTime == 0)) || (this.cachedDuration == 0))) && (!(_arg_2))))
            {
                this.vars.onStart.apply(null, this.vars.onStartParams);
            };
            var _local_6:PropTween = this.cachedPT1;
            while (_local_6)
            {
                _local_6.target[_local_6.property] = (_local_6.start + (this.ratio * _local_6.change));
                _local_6 = _local_6.nextNode;
            };
            if (((_hasUpdate) && (!(_arg_2))))
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            };
            if (((_local_4) && (!(this.gc))))
            {
                if (((this._hasPlugins) && (this.cachedPT1)))
                {
                    onPluginEvent("onComplete", this);
                };
                complete(true, _arg_2);
            };
        }

        public function killVars(_arg_1:Object, _arg_2:Boolean=true):Boolean
        {
            var _local_3:String;
            var _local_4:PropTween;
            var _local_5:Boolean;
            if (this._overwrittenProps == null)
            {
                this._overwrittenProps = {};
            };
            for (_local_3 in _arg_1)
            {
                if ((_local_3 in this.propTweenLookup))
                {
                    _local_4 = this.propTweenLookup[_local_3];
                    if (((_local_4.isPlugin) && (_local_4.name == "_MULTIPLE_")))
                    {
                        _local_4.target.killProps(_arg_1);
                        if (_local_4.target.overwriteProps.length == 0)
                        {
                            _local_4.name = "";
                        };
                        if (((!(_local_3 == _local_4.target.propName)) || (_local_4.name == "")))
                        {
                            delete this.propTweenLookup[_local_3];
                        };
                    };
                    if (_local_4.name != "_MULTIPLE_")
                    {
                        if (_local_4.nextNode)
                        {
                            _local_4.nextNode.prevNode = _local_4.prevNode;
                        };
                        if (_local_4.prevNode)
                        {
                            _local_4.prevNode.nextNode = _local_4.nextNode;
                        }
                        else
                        {
                            if (this.cachedPT1 == _local_4)
                            {
                                this.cachedPT1 = _local_4.nextNode;
                            };
                        };
                        if (((_local_4.isPlugin) && (_local_4.target.onDisable)))
                        {
                            _local_4.target.onDisable();
                            if (_local_4.target.activeDisable)
                            {
                                _local_5 = true;
                            };
                        };
                        delete this.propTweenLookup[_local_3];
                    };
                };
                if (((_arg_2) && (!(_arg_1 == this._overwrittenProps))))
                {
                    this._overwrittenProps[_local_3] = 1;
                };
            };
            return (_local_5);
        }

        override public function invalidate():void
        {
            if (((this._notifyPluginsOfEnabled) && (this.cachedPT1)))
            {
                onPluginEvent("onDisable", this);
            };
            this.cachedPT1 = null;
            this._overwrittenProps = null;
            _hasUpdate = (this.initted = (this.active = (this._notifyPluginsOfEnabled = false)));
            this.propTweenLookup = {};
        }

        override public function setEnabled(_arg_1:Boolean, _arg_2:Boolean=false):Boolean
        {
            var _local_3:Array;
            if (_arg_1)
            {
                _local_3 = TweenLite.masterList[this.target];
                if ((!(_local_3)))
                {
                    TweenLite.masterList[this.target] = [this];
                }
                else
                {
                    _local_3[_local_3.length] = this;
                };
            };
            super.setEnabled(_arg_1, _arg_2);
            if (((this._notifyPluginsOfEnabled) && (this.cachedPT1)))
            {
                return (onPluginEvent(((_arg_1) ? "onEnable" : "onDisable"), this));
            };
            return (false);
        }

        protected function easeProxy(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            return (this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams)));
        }


    }
}//package com.greensock

