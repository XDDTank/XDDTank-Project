// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.core.SimpleTimeline

package com.greensock.core
{
    public class SimpleTimeline extends TweenCore 
    {

        protected var _firstChild:TweenCore;
        protected var _lastChild:TweenCore;
        public var autoRemoveChildren:Boolean;

        public function SimpleTimeline(_arg_1:Object=null)
        {
            super(0, _arg_1);
        }

        public function insert(_arg_1:TweenCore, _arg_2:*=0):TweenCore
        {
            if (((!(_arg_1.cachedOrphan)) && (_arg_1.timeline)))
            {
                _arg_1.timeline.remove(_arg_1, true);
            };
            _arg_1.timeline = this;
            _arg_1.cachedStartTime = (Number(_arg_2) + _arg_1.delay);
            if (_arg_1.gc)
            {
                _arg_1.setEnabled(true, true);
            };
            if (_arg_1.cachedPaused)
            {
                _arg_1.cachedPauseTime = (_arg_1.cachedStartTime + ((this.rawTime - _arg_1.cachedStartTime) / _arg_1.cachedTimeScale));
            };
            if (this._lastChild)
            {
                this._lastChild.nextNode = _arg_1;
            }
            else
            {
                this._firstChild = _arg_1;
            };
            _arg_1.prevNode = this._lastChild;
            this._lastChild = _arg_1;
            _arg_1.nextNode = null;
            _arg_1.cachedOrphan = false;
            return (_arg_1);
        }

        public function remove(_arg_1:TweenCore, _arg_2:Boolean=false):void
        {
            if (_arg_1.cachedOrphan)
            {
                return;
            };
            if ((!(_arg_2)))
            {
                _arg_1.setEnabled(false, true);
            };
            if (_arg_1.nextNode)
            {
                _arg_1.nextNode.prevNode = _arg_1.prevNode;
            }
            else
            {
                if (this._lastChild == _arg_1)
                {
                    this._lastChild = _arg_1.prevNode;
                };
            };
            if (_arg_1.prevNode)
            {
                _arg_1.prevNode.nextNode = _arg_1.nextNode;
            }
            else
            {
                if (this._firstChild == _arg_1)
                {
                    this._firstChild = _arg_1.nextNode;
                };
            };
            _arg_1.cachedOrphan = true;
        }

        override public function renderTime(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_5:Number;
            var _local_6:TweenCore;
            var _local_4:TweenCore = this._firstChild;
            this.cachedTotalTime = _arg_1;
            this.cachedTime = _arg_1;
            while (_local_4)
            {
                _local_6 = _local_4.nextNode;
                if (((_local_4.active) || (((_arg_1 >= _local_4.cachedStartTime) && (!(_local_4.cachedPaused))) && (!(_local_4.gc)))))
                {
                    if ((!(_local_4.cachedReversed)))
                    {
                        _local_4.renderTime(((_arg_1 - _local_4.cachedStartTime) * _local_4.cachedTimeScale), _arg_2, false);
                    }
                    else
                    {
                        _local_5 = ((_local_4.cacheIsDirty) ? _local_4.totalDuration : _local_4.cachedTotalDuration);
                        _local_4.renderTime((_local_5 - ((_arg_1 - _local_4.cachedStartTime) * _local_4.cachedTimeScale)), _arg_2, false);
                    };
                };
                _local_4 = _local_6;
            };
        }

        public function get rawTime():Number
        {
            return (this.cachedTotalTime);
        }


    }
}//package com.greensock.core

