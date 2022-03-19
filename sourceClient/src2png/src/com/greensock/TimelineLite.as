// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.TimelineLite

package com.greensock
{
    import com.greensock.core.SimpleTimeline;
    import com.greensock.core.TweenCore;
    import com.greensock.core.*;

    public class TimelineLite extends SimpleTimeline 
    {

        public static const version:Number = 1.64;
        private static var _overwriteMode:int = ((OverwriteManager.enabled) ? OverwriteManager.mode : OverwriteManager.init(2));

        protected var _labels:Object;
        protected var _endCaps:Array;

        public function TimelineLite(_arg_1:Object=null)
        {
            super(_arg_1);
            this._endCaps = [null, null];
            this._labels = {};
            this.autoRemoveChildren = Boolean((this.vars.autoRemoveChildren == true));
            _hasUpdate = Boolean((typeof(this.vars.onUpdate) == "function"));
            if ((this.vars.tweens is Array))
            {
                this.insertMultiple(this.vars.tweens, 0, ((this.vars.align != null) ? this.vars.align : "normal"), ((this.vars.stagger) ? Number(this.vars.stagger) : 0));
            };
        }

        override public function remove(_arg_1:TweenCore, _arg_2:Boolean=false):void
        {
            if (_arg_1.cachedOrphan)
            {
                return;
            };
            if ((!(_arg_2)))
            {
                _arg_1.setEnabled(false, true);
            };
            var _local_3:TweenCore = ((this.gc) ? this._endCaps[0] : _firstChild);
            var _local_4:TweenCore = ((this.gc) ? this._endCaps[1] : _lastChild);
            if (_arg_1.nextNode)
            {
                _arg_1.nextNode.prevNode = _arg_1.prevNode;
            }
            else
            {
                if (_local_4 == _arg_1)
                {
                    _local_4 = _arg_1.prevNode;
                };
            };
            if (_arg_1.prevNode)
            {
                _arg_1.prevNode.nextNode = _arg_1.nextNode;
            }
            else
            {
                if (_local_3 == _arg_1)
                {
                    _local_3 = _arg_1.nextNode;
                };
            };
            if (this.gc)
            {
                this._endCaps[0] = _local_3;
                this._endCaps[1] = _local_4;
            }
            else
            {
                _firstChild = _local_3;
                _lastChild = _local_4;
            };
            _arg_1.cachedOrphan = true;
            setDirtyCache(true);
        }

        override public function insert(_arg_1:TweenCore, _arg_2:*=0):TweenCore
        {
            var _local_5:TweenCore;
            var _local_6:Number;
            var _local_7:SimpleTimeline;
            if (typeof(_arg_2) == "string")
            {
                if ((!(_arg_2 in this._labels)))
                {
                    this.addLabel(_arg_2, this.duration);
                };
                _arg_2 = Number(this._labels[_arg_2]);
            };
            if (((!(_arg_1.cachedOrphan)) && (_arg_1.timeline)))
            {
                _arg_1.timeline.remove(_arg_1, true);
            };
            _arg_1.timeline = this;
            _arg_1.cachedStartTime = (Number(_arg_2) + _arg_1.delay);
            if (_arg_1.cachedPaused)
            {
                _arg_1.cachedPauseTime = (_arg_1.cachedStartTime + ((this.rawTime - _arg_1.cachedStartTime) / _arg_1.cachedTimeScale));
            };
            if (_arg_1.gc)
            {
                _arg_1.setEnabled(true, true);
            };
            setDirtyCache(true);
            var _local_3:TweenCore = ((this.gc) ? this._endCaps[0] : _firstChild);
            var _local_4:TweenCore = ((this.gc) ? this._endCaps[1] : _lastChild);
            if (_local_4 == null)
            {
                _local_3 = (_local_4 = _arg_1);
                _arg_1.nextNode = (_arg_1.prevNode = null);
            }
            else
            {
                _local_5 = _local_4;
                _local_6 = _arg_1.cachedStartTime;
                while (((!(_local_5 == null)) && (_local_6 < _local_5.cachedStartTime)))
                {
                    _local_5 = _local_5.prevNode;
                };
                if (_local_5 == null)
                {
                    _local_3.prevNode = _arg_1;
                    _arg_1.nextNode = _local_3;
                    _arg_1.prevNode = null;
                    _local_3 = _arg_1;
                }
                else
                {
                    if (_local_5.nextNode)
                    {
                        _local_5.nextNode.prevNode = _arg_1;
                    }
                    else
                    {
                        if (_local_5 == _local_4)
                        {
                            _local_4 = _arg_1;
                        };
                    };
                    _arg_1.prevNode = _local_5;
                    _arg_1.nextNode = _local_5.nextNode;
                    _local_5.nextNode = _arg_1;
                };
            };
            _arg_1.cachedOrphan = false;
            if (this.gc)
            {
                this._endCaps[0] = _local_3;
                this._endCaps[1] = _local_4;
            }
            else
            {
                _firstChild = _local_3;
                _lastChild = _local_4;
            };
            if (((this.gc) && ((this.cachedStartTime + ((_arg_1.cachedStartTime + (_arg_1.cachedTotalDuration / _arg_1.cachedTimeScale)) / this.cachedTimeScale)) > this.timeline.cachedTime)))
            {
                this.setEnabled(true, false);
                _local_7 = this.timeline;
                while (((_local_7.gc) && (_local_7.timeline)))
                {
                    if ((_local_7.cachedStartTime + (_local_7.totalDuration / _local_7.cachedTimeScale)) > _local_7.timeline.cachedTime)
                    {
                        _local_7.setEnabled(true, false);
                    };
                    _local_7 = _local_7.timeline;
                };
            };
            return (_arg_1);
        }

        public function append(_arg_1:TweenCore, _arg_2:Number=0):TweenCore
        {
            return (this.insert(_arg_1, (this.duration + _arg_2)));
        }

        public function prepend(_arg_1:TweenCore, _arg_2:Boolean=false):TweenCore
        {
            this.shiftChildren(((_arg_1.totalDuration / _arg_1.cachedTimeScale) + _arg_1.delay), _arg_2, 0);
            return (this.insert(_arg_1, 0));
        }

        public function insertMultiple(_arg_1:Array, _arg_2:*=0, _arg_3:String="normal", _arg_4:Number=0):Array
        {
            var _local_5:int;
            var _local_6:TweenCore;
            var _local_7:Number = ((Number(_arg_2)) || (0));
            var _local_8:int = _arg_1.length;
            if (typeof(_arg_2) == "string")
            {
                if ((!(_arg_2 in this._labels)))
                {
                    this.addLabel(_arg_2, this.duration);
                };
                _local_7 = this._labels[_arg_2];
            };
            _local_5 = 0;
            while (_local_5 < _local_8)
            {
                _local_6 = (_arg_1[_local_5] as TweenCore);
                this.insert(_local_6, _local_7);
                if (_arg_3 == "sequence")
                {
                    _local_7 = (_local_6.cachedStartTime + (_local_6.totalDuration / _local_6.cachedTimeScale));
                }
                else
                {
                    if (_arg_3 == "start")
                    {
                        _local_6.cachedStartTime = (_local_6.cachedStartTime - _local_6.delay);
                    };
                };
                _local_7 = (_local_7 + _arg_4);
                _local_5 = (_local_5 + 1);
            };
            return (_arg_1);
        }

        public function appendMultiple(_arg_1:Array, _arg_2:Number=0, _arg_3:String="normal", _arg_4:Number=0):Array
        {
            return (this.insertMultiple(_arg_1, (this.duration + _arg_2), _arg_3, _arg_4));
        }

        public function prependMultiple(_arg_1:Array, _arg_2:String="normal", _arg_3:Number=0, _arg_4:Boolean=false):Array
        {
            var _local_5:TimelineLite = new TimelineLite({
                "tweens":_arg_1,
                "align":_arg_2,
                "stagger":_arg_3
            });
            this.shiftChildren(_local_5.duration, _arg_4, 0);
            this.insertMultiple(_arg_1, 0, _arg_2, _arg_3);
            _local_5.kill();
            return (_arg_1);
        }

        public function addLabel(_arg_1:String, _arg_2:Number):void
        {
            this._labels[_arg_1] = _arg_2;
        }

        public function removeLabel(_arg_1:String):Number
        {
            var _local_2:Number = this._labels[_arg_1];
            delete this._labels[_arg_1];
            return (_local_2);
        }

        public function getLabelTime(_arg_1:String):Number
        {
            return ((_arg_1 in this._labels) ? Number(this._labels[_arg_1]) : -1);
        }

        protected function parseTimeOrLabel(_arg_1:*):Number
        {
            if (typeof(_arg_1) == "string")
            {
                if ((!(_arg_1 in this._labels)))
                {
                    throw (new Error((("TimelineLite error: the " + _arg_1) + " label was not found.")));
                };
                return (this.getLabelTime(String(_arg_1)));
            };
            return (Number(_arg_1));
        }

        public function stop():void
        {
            this.paused = true;
        }

        public function gotoAndPlay(_arg_1:*, _arg_2:Boolean=true):void
        {
            setTotalTime(this.parseTimeOrLabel(_arg_1), _arg_2);
            play();
        }

        public function gotoAndStop(_arg_1:*, _arg_2:Boolean=true):void
        {
            setTotalTime(this.parseTimeOrLabel(_arg_1), _arg_2);
            this.paused = true;
        }

        public function _SafeStr_1(_arg_1:*, _arg_2:Boolean=true):void
        {
            setTotalTime(this.parseTimeOrLabel(_arg_1), _arg_2);
        }

        override public function renderTime(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_8:TweenCore;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:TweenCore;
            var _local_12:Number;
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
            var _local_13:Boolean = this.cachedPaused;
            if (_arg_1 >= _local_4)
            {
                if (((_rawPrevTime <= _local_4) && (!(_rawPrevTime == _arg_1))))
                {
                    this.cachedTotalTime = (this.cachedTime = _local_4);
                    this.forceChildrenToEnd(_local_4, _arg_2);
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
                        this.forceChildrenToBeginning(0, _arg_2);
                        this.cachedTotalTime = 0;
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
            if (((this.cachedTime == _local_5) && (!(_arg_3))))
            {
                return;
            };
            if ((!(this.initted)))
            {
                this.initted = true;
            };
            if (((((_local_5 == 0) && (this.vars.onStart)) && (!(this.cachedTime == 0))) && (!(_arg_2))))
            {
                this.vars.onStart.apply(null, this.vars.onStartParams);
            };
            if (!_local_10)
            {
                if ((this.cachedTime - _local_5) > 0)
                {
                    _local_8 = _firstChild;
                    while (_local_8)
                    {
                        _local_11 = _local_8.nextNode;
                        if (((this.cachedPaused) && (!(_local_13)))) break;
                        if (((_local_8.active) || (((!(_local_8.cachedPaused)) && (_local_8.cachedStartTime <= this.cachedTime)) && (!(_local_8.gc)))))
                        {
                            if ((!(_local_8.cachedReversed)))
                            {
                                _local_8.renderTime(((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale), _arg_2, false);
                            }
                            else
                            {
                                _local_12 = ((_local_8.cacheIsDirty) ? _local_8.totalDuration : _local_8.cachedTotalDuration);
                                _local_8.renderTime((_local_12 - ((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale)), _arg_2, false);
                            };
                        };
                        _local_8 = _local_11;
                    };
                }
                else
                {
                    _local_8 = _lastChild;
                    while (_local_8)
                    {
                        _local_11 = _local_8.prevNode;
                        if (((this.cachedPaused) && (!(_local_13)))) break;
                        if (((_local_8.active) || (((!(_local_8.cachedPaused)) && (_local_8.cachedStartTime <= _local_5)) && (!(_local_8.gc)))))
                        {
                            if ((!(_local_8.cachedReversed)))
                            {
                                _local_8.renderTime(((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale), _arg_2, false);
                            }
                            else
                            {
                                _local_12 = ((_local_8.cacheIsDirty) ? _local_8.totalDuration : _local_8.cachedTotalDuration);
                                _local_8.renderTime((_local_12 - ((this.cachedTime - _local_8.cachedStartTime) * _local_8.cachedTimeScale)), _arg_2, false);
                            };
                        };
                        _local_8 = _local_11;
                    };
                };
            };
            if (((_hasUpdate) && (!(_arg_2))))
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            };
            if ((((_local_9) && ((_local_6 == this.cachedStartTime) || (!(_local_7 == this.cachedTimeScale)))) && ((_local_4 >= this.totalDuration) || (this.cachedTime == 0))))
            {
                complete(true, _arg_2);
            };
        }

        protected function forceChildrenToBeginning(_arg_1:Number, _arg_2:Boolean=false):Number
        {
            var _local_4:TweenCore;
            var _local_5:Number;
            var _local_3:TweenCore = _lastChild;
            var _local_6:Boolean = this.cachedPaused;
            while (_local_3)
            {
                _local_4 = _local_3.prevNode;
                if (((this.cachedPaused) && (!(_local_6)))) break;
                if (((_local_3.active) || (((!(_local_3.cachedPaused)) && (!(_local_3.gc))) && ((!(_local_3.cachedTotalTime == 0)) || (_local_3.cachedDuration == 0)))))
                {
                    if (((_arg_1 == 0) && ((!(_local_3.cachedDuration == 0)) || (_local_3.cachedStartTime == 0))))
                    {
                        _local_3.renderTime(((_local_3.cachedReversed) ? _local_3.cachedTotalDuration : 0), _arg_2, false);
                    }
                    else
                    {
                        if ((!(_local_3.cachedReversed)))
                        {
                            _local_3.renderTime(((_arg_1 - _local_3.cachedStartTime) * _local_3.cachedTimeScale), _arg_2, false);
                        }
                        else
                        {
                            _local_5 = ((_local_3.cacheIsDirty) ? _local_3.totalDuration : _local_3.cachedTotalDuration);
                            _local_3.renderTime((_local_5 - ((_arg_1 - _local_3.cachedStartTime) * _local_3.cachedTimeScale)), _arg_2, false);
                        };
                    };
                };
                _local_3 = _local_4;
            };
            return (_arg_1);
        }

        protected function forceChildrenToEnd(_arg_1:Number, _arg_2:Boolean=false):Number
        {
            var _local_4:TweenCore;
            var _local_5:Number;
            var _local_3:TweenCore = _firstChild;
            var _local_6:Boolean = this.cachedPaused;
            while (_local_3)
            {
                _local_4 = _local_3.nextNode;
                if (((this.cachedPaused) && (!(_local_6)))) break;
                if (((_local_3.active) || (((!(_local_3.cachedPaused)) && (!(_local_3.gc))) && ((!(_local_3.cachedTotalTime == _local_3.cachedTotalDuration)) || (_local_3.cachedDuration == 0)))))
                {
                    if (((_arg_1 == this.cachedDuration) && ((!(_local_3.cachedDuration == 0)) || (_local_3.cachedStartTime == this.cachedDuration))))
                    {
                        _local_3.renderTime(((_local_3.cachedReversed) ? 0 : _local_3.cachedTotalDuration), _arg_2, false);
                    }
                    else
                    {
                        if ((!(_local_3.cachedReversed)))
                        {
                            _local_3.renderTime(((_arg_1 - _local_3.cachedStartTime) * _local_3.cachedTimeScale), _arg_2, false);
                        }
                        else
                        {
                            _local_5 = ((_local_3.cacheIsDirty) ? _local_3.totalDuration : _local_3.cachedTotalDuration);
                            _local_3.renderTime((_local_5 - ((_arg_1 - _local_3.cachedStartTime) * _local_3.cachedTimeScale)), _arg_2, false);
                        };
                    };
                };
                _local_3 = _local_4;
            };
            return (_arg_1);
        }

        public function hasPausedChild():Boolean
        {
            var _local_1:TweenCore = ((this.gc) ? this._endCaps[0] : _firstChild);
            while (_local_1)
            {
                if (((_local_1.cachedPaused) || ((_local_1 is TimelineLite) && ((_local_1 as TimelineLite).hasPausedChild()))))
                {
                    return (true);
                };
                _local_1 = _local_1.nextNode;
            };
            return (false);
        }

        public function getChildren(_arg_1:Boolean=true, _arg_2:Boolean=true, _arg_3:Boolean=true, _arg_4:Number=-9999999999):Array
        {
            var _local_5:Array = [];
            var _local_6:int;
            var _local_7:TweenCore = ((this.gc) ? this._endCaps[0] : _firstChild);
            while (_local_7)
            {
                if (_local_7.cachedStartTime >= _arg_4)
                {
                    if ((_local_7 is TweenLite))
                    {
                        if (_arg_2)
                        {
                            var _local_8:* = _local_6++;
                            _local_5[_local_8] = _local_7;
                        };
                    }
                    else
                    {
                        if (_arg_3)
                        {
                            _local_8 = _local_6++;
                            _local_5[_local_8] = _local_7;
                        };
                        if (_arg_1)
                        {
                            _local_5 = _local_5.concat(TimelineLite(_local_7).getChildren(true, _arg_2, _arg_3));
                        };
                    };
                };
                _local_7 = _local_7.nextNode;
            };
            return (_local_5);
        }

        public function getTweensOf(_arg_1:Object, _arg_2:Boolean=true):Array
        {
            var _local_5:int;
            var _local_3:Array = this.getChildren(_arg_2, true, false);
            var _local_4:Array = [];
            var _local_6:int = _local_3.length;
            var _local_7:int;
            _local_5 = 0;
            while (_local_5 < _local_6)
            {
                if (TweenLite(_local_3[_local_5]).target == _arg_1)
                {
                    var _local_8:* = _local_7++;
                    _local_4[_local_8] = _local_3[_local_5];
                };
                _local_5 = (_local_5 + 1);
            };
            return (_local_4);
        }

        public function shiftChildren(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Number=0):void
        {
            var _local_5:String;
            var _local_4:TweenCore = ((this.gc) ? this._endCaps[0] : _firstChild);
            while (_local_4)
            {
                if (_local_4.cachedStartTime >= _arg_3)
                {
                    _local_4.cachedStartTime = (_local_4.cachedStartTime + _arg_1);
                };
                _local_4 = _local_4.nextNode;
            };
            if (_arg_2)
            {
                for (_local_5 in this._labels)
                {
                    if (this._labels[_local_5] >= _arg_3)
                    {
                        this._labels[_local_5] = (this._labels[_local_5] + _arg_1);
                    };
                };
            };
            this.setDirtyCache(true);
        }

        public function killTweensOf(_arg_1:Object, _arg_2:Boolean=true, _arg_3:Object=null):Boolean
        {
            var _local_6:TweenLite;
            var _local_4:Array = this.getTweensOf(_arg_1, _arg_2);
            var _local_5:int = _local_4.length;
            while (--_local_5 > -1)
            {
                _local_6 = _local_4[_local_5];
                if (_arg_3 != null)
                {
                    _local_6.killVars(_arg_3);
                };
                if (((_arg_3 == null) || ((_local_6.cachedPT1 == null) && (_local_6.initted))))
                {
                    _local_6.setEnabled(false, false);
                };
            };
            return (Boolean((_local_4.length > 0)));
        }

        override public function invalidate():void
        {
            var _local_1:TweenCore = ((this.gc) ? this._endCaps[0] : _firstChild);
            while (_local_1)
            {
                _local_1.invalidate();
                _local_1 = _local_1.nextNode;
            };
        }

        public function clear(_arg_1:Array=null):void
        {
            if (_arg_1 == null)
            {
                _arg_1 = this.getChildren(false, true, true);
            };
            var _local_2:int = _arg_1.length;
            while (--_local_2 > -1)
            {
                TweenCore(_arg_1[_local_2]).setEnabled(false, false);
            };
        }

        override public function setEnabled(_arg_1:Boolean, _arg_2:Boolean=false):Boolean
        {
            var _local_3:TweenCore;
            if (_arg_1 == this.gc)
            {
                if (_arg_1)
                {
                    _firstChild = (_local_3 = this._endCaps[0]);
                    _lastChild = this._endCaps[1];
                    this._endCaps = [null, null];
                }
                else
                {
                    _local_3 = _firstChild;
                    this._endCaps = [_firstChild, _lastChild];
                    _firstChild = (_lastChild = null);
                };
                while (_local_3)
                {
                    _local_3.setEnabled(_arg_1, true);
                    _local_3 = _local_3.nextNode;
                };
            };
            return (super.setEnabled(_arg_1, _arg_2));
        }

        public function get currentProgress():Number
        {
            return (this.cachedTime / this.duration);
        }

        public function set currentProgress(_arg_1:Number):void
        {
            setTotalTime((this.duration * _arg_1), false);
        }

        override public function get duration():Number
        {
            var _local_1:Number;
            if (this.cacheIsDirty)
            {
                _local_1 = this.totalDuration;
            };
            return (this.cachedDuration);
        }

        override public function set duration(_arg_1:Number):void
        {
            if (((!(this.duration == 0)) && (!(_arg_1 == 0))))
            {
                this.timeScale = (this.duration / _arg_1);
            };
        }

        override public function get totalDuration():Number
        {
            var _local_1:Number;
            var _local_2:Number;
            var _local_3:TweenCore;
            var _local_4:Number;
            var _local_5:TweenCore;
            if (this.cacheIsDirty)
            {
                _local_1 = 0;
                _local_3 = ((this.gc) ? this._endCaps[0] : _firstChild);
                _local_4 = -(Infinity);
                while (_local_3)
                {
                    _local_5 = _local_3.nextNode;
                    if (_local_3.cachedStartTime < _local_4)
                    {
                        this.insert(_local_3, (_local_3.cachedStartTime - _local_3.delay));
                        _local_4 = _local_3.prevNode.cachedStartTime;
                    }
                    else
                    {
                        _local_4 = _local_3.cachedStartTime;
                    };
                    if (_local_3.cachedStartTime < 0)
                    {
                        _local_1 = (_local_1 - _local_3.cachedStartTime);
                        this.shiftChildren(-(_local_3.cachedStartTime), false, -9999999999);
                    };
                    _local_2 = (_local_3.cachedStartTime + (_local_3.totalDuration / _local_3.cachedTimeScale));
                    if (_local_2 > _local_1)
                    {
                        _local_1 = _local_2;
                    };
                    _local_3 = _local_5;
                };
                this.cachedDuration = (this.cachedTotalDuration = _local_1);
                this.cacheIsDirty = false;
            };
            return (this.cachedTotalDuration);
        }

        override public function set totalDuration(_arg_1:Number):void
        {
            if (((!(this.totalDuration == 0)) && (!(_arg_1 == 0))))
            {
                this.timeScale = (this.totalDuration / _arg_1);
            };
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

        public function get useFrames():Boolean
        {
            var _local_1:SimpleTimeline = this.timeline;
            while (_local_1.timeline)
            {
                _local_1 = _local_1.timeline;
            };
            return (Boolean((_local_1 == TweenLite.rootFramesTimeline)));
        }

        override public function get rawTime():Number
        {
            if (((!(this.cachedTotalTime == 0)) && (!(this.cachedTotalTime == this.cachedTotalDuration))))
            {
                return (this.cachedTotalTime);
            };
            return ((this.timeline.rawTime - this.cachedStartTime) * this.cachedTimeScale);
        }


    }
}//package com.greensock

// _SafeStr_1 = "goto" (String#108, DoABC#106)


