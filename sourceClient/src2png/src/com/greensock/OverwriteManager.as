// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.OverwriteManager

package com.greensock
{
    import com.greensock.core.TweenCore;
    import com.greensock.core.SimpleTimeline;
    import com.greensock.core.*;

    public final class OverwriteManager 
    {

        public static const version:Number = 6.1;
        public static const NONE:int = 0;
        public static const ALL_IMMEDIATE:int = 1;
        public static const AUTO:int = 2;
        public static const CONCURRENT:int = 3;
        public static const ALL_ONSTART:int = 4;
        public static const PREEXISTING:int = 5;
        public static var mode:int;
        public static var enabled:Boolean;


        public static function init(_arg_1:int=2):int
        {
            if (TweenLite.version < 11.6)
            {
                throw (new Error("Warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com."));
            };
            TweenLite.overwriteManager = OverwriteManager;
            mode = _arg_1;
            enabled = true;
            return (mode);
        }

        public static function manageOverwrites(_arg_1:TweenLite, _arg_2:Object, _arg_3:Array, _arg_4:int):Boolean
        {
            var _local_5:int;
            var _local_6:Boolean;
            var _local_7:TweenLite;
            var _local_13:int;
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:TweenCore;
            var _local_17:Number;
            var _local_18:SimpleTimeline;
            if (_arg_4 >= 4)
            {
                _local_13 = _arg_3.length;
                _local_5 = 0;
                while (_local_5 < _local_13)
                {
                    _local_7 = _arg_3[_local_5];
                    if (_local_7 != _arg_1)
                    {
                        if (_local_7.setEnabled(false, false))
                        {
                            _local_6 = true;
                        };
                    }
                    else
                    {
                        if (_arg_4 == 5) break;
                    };
                    _local_5++;
                };
                return (_local_6);
            };
            var _local_8:Number = (_arg_1.cachedStartTime + 1E-10);
            var _local_9:Array = [];
            var _local_10:Array = [];
            var _local_11:int;
            var _local_12:int;
            _local_5 = _arg_3.length;
            while (--_local_5 > -1)
            {
                _local_7 = _arg_3[_local_5];
                if (!(((_local_7 == _arg_1) || (_local_7.gc)) || ((!(_local_7.initted)) && ((_local_8 - _local_7.cachedStartTime) <= 2E-10))))
                {
                    if (_local_7.timeline != _arg_1.timeline)
                    {
                        if ((!(getGlobalPaused(_local_7))))
                        {
                            var _local_19:* = _local_11++;
                            _local_10[_local_19] = _local_7;
                        };
                    }
                    else
                    {
                        if (((((_local_7.cachedStartTime <= _local_8) && (((_local_7.cachedStartTime + _local_7.totalDuration) + 1E-10) > _local_8)) && (!(_local_7.cachedPaused))) && (!((_arg_1.cachedDuration == 0) && ((_local_8 - _local_7.cachedStartTime) <= 2E-10)))))
                        {
                            _local_19 = _local_12++;
                            _local_9[_local_19] = _local_7;
                        };
                    };
                };
            };
            if (_local_11 != 0)
            {
                _local_14 = _arg_1.cachedTimeScale;
                _local_15 = _local_8;
                _local_18 = _arg_1.timeline;
                while (_local_18)
                {
                    _local_14 = (_local_14 * _local_18.cachedTimeScale);
                    _local_15 = (_local_15 + _local_18.cachedStartTime);
                    _local_18 = _local_18.timeline;
                };
                _local_8 = (_local_14 * _local_15);
                _local_5 = _local_11;
                while (--_local_5 > -1)
                {
                    _local_16 = _local_10[_local_5];
                    _local_14 = _local_16.cachedTimeScale;
                    _local_15 = _local_16.cachedStartTime;
                    _local_18 = _local_16.timeline;
                    while (_local_18)
                    {
                        _local_14 = (_local_14 * _local_18.cachedTimeScale);
                        _local_15 = (_local_15 + _local_18.cachedStartTime);
                        _local_18 = _local_18.timeline;
                    };
                    _local_17 = (_local_14 * _local_15);
                    if (((_local_17 <= _local_8) && ((((_local_17 + (_local_16.totalDuration * _local_14)) + 1E-10) > _local_8) || (_local_16.cachedDuration == 0))))
                    {
                        _local_19 = _local_12++;
                        _local_9[_local_19] = _local_16;
                    };
                };
            };
            if (_local_12 == 0)
            {
                return (_local_6);
            };
            _local_5 = _local_12;
            if (_arg_4 == 2)
            {
                while (--_local_5 > -1)
                {
                    _local_7 = _local_9[_local_5];
                    if (_local_7.killVars(_arg_2))
                    {
                        _local_6 = true;
                    };
                    if (((_local_7.cachedPT1 == null) && (_local_7.initted)))
                    {
                        _local_7.setEnabled(false, false);
                    };
                };
            }
            else
            {
                while (--_local_5 > -1)
                {
                    if (TweenLite(_local_9[_local_5]).setEnabled(false, false))
                    {
                        _local_6 = true;
                    };
                };
            };
            return (_local_6);
        }

        public static function getGlobalPaused(_arg_1:TweenCore):Boolean
        {
            var _local_2:Boolean;
            while (_arg_1)
            {
                if (_arg_1.cachedPaused)
                {
                    _local_2 = true;
                    break;
                };
                _arg_1 = _arg_1.timeline;
            };
            return (_local_2);
        }


    }
}//package com.greensock

