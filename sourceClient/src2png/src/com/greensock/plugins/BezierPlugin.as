// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.BezierPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;
    import com.greensock.*;

    public class BezierPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;
        protected static const _RAD2DEG:Number = (180 / Math.PI);//57.2957795130823

        protected var _target:Object;
        protected var _orientData:Array;
        protected var _orient:Boolean;
        protected var _future:Object = {};
        protected var _beziers:Object;

        public function BezierPlugin()
        {
            this.propName = "bezier";
            this.overwriteProps = [];
        }

        public static function parseBeziers(_arg_1:Object, _arg_2:Boolean=false):Object
        {
            var _local_3:int;
            var _local_4:Array;
            var _local_5:Object;
            var _local_6:String;
            var _local_7:Object = {};
            if (_arg_2)
            {
                for (_local_6 in _arg_1)
                {
                    _local_4 = _arg_1[_local_6];
                    _local_7[_local_6] = (_local_5 = []);
                    if (_local_4.length > 2)
                    {
                        _local_5[_local_5.length] = [_local_4[0], (_local_4[1] - ((_local_4[2] - _local_4[0]) / 4)), _local_4[1]];
                        _local_3 = 1;
                        while (_local_3 < (_local_4.length - 1))
                        {
                            _local_5[_local_5.length] = [_local_4[_local_3], (_local_4[_local_3] + (_local_4[_local_3] - _local_5[(_local_3 - 1)][1])), _local_4[(_local_3 + 1)]];
                            _local_3 = (_local_3 + 1);
                        };
                    }
                    else
                    {
                        _local_5[_local_5.length] = [_local_4[0], ((_local_4[0] + _local_4[1]) / 2), _local_4[1]];
                    };
                };
            }
            else
            {
                for (_local_6 in _arg_1)
                {
                    _local_4 = _arg_1[_local_6];
                    _local_7[_local_6] = (_local_5 = []);
                    if (_local_4.length > 3)
                    {
                        _local_5[_local_5.length] = [_local_4[0], _local_4[1], ((_local_4[1] + _local_4[2]) / 2)];
                        _local_3 = 2;
                        while (_local_3 < (_local_4.length - 2))
                        {
                            _local_5[_local_5.length] = [_local_5[(_local_3 - 2)][2], _local_4[_local_3], ((_local_4[_local_3] + _local_4[(_local_3 + 1)]) / 2)];
                            _local_3 = (_local_3 + 1);
                        };
                        _local_5[_local_5.length] = [_local_5[(_local_5.length - 1)][2], _local_4[(_local_4.length - 2)], _local_4[(_local_4.length - 1)]];
                    }
                    else
                    {
                        if (_local_4.length == 3)
                        {
                            _local_5[_local_5.length] = [_local_4[0], _local_4[1], _local_4[2]];
                        }
                        else
                        {
                            if (_local_4.length == 2)
                            {
                                _local_5[_local_5.length] = [_local_4[0], ((_local_4[0] + _local_4[1]) / 2), _local_4[1]];
                            };
                        };
                    };
                };
            };
            return (_local_7);
        }


        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if ((!(_arg_2 is Array)))
            {
                return (false);
            };
            this.init(_arg_3, (_arg_2 as Array), false);
            return (true);
        }

        protected function init(_arg_1:TweenLite, _arg_2:Array, _arg_3:Boolean):void
        {
            var _local_6:int;
            var _local_7:String;
            var _local_8:Object;
            this._target = _arg_1.target;
            var _local_4:Object = ((_arg_1.vars.isTV == true) ? _arg_1.vars.exposedVars : _arg_1.vars);
            if (_local_4.orientToBezier == true)
            {
                this._orientData = [["x", "y", "rotation", 0, 0.01]];
                this._orient = true;
            }
            else
            {
                if ((_local_4.orientToBezier is Array))
                {
                    this._orientData = _local_4.orientToBezier;
                    this._orient = true;
                };
            };
            var _local_5:Object = {};
            _local_6 = 0;
            while (_local_6 < _arg_2.length)
            {
                for (_local_7 in _arg_2[_local_6])
                {
                    if (_local_5[_local_7] == undefined)
                    {
                        _local_5[_local_7] = [_arg_1.target[_local_7]];
                    };
                    if (typeof(_arg_2[_local_6][_local_7]) == "number")
                    {
                        _local_5[_local_7].push(_arg_2[_local_6][_local_7]);
                    }
                    else
                    {
                        _local_5[_local_7].push((_arg_1.target[_local_7] + Number(_arg_2[_local_6][_local_7])));
                    };
                };
                _local_6 = (_local_6 + 1);
            };
            for (_local_7 in _local_5)
            {
                this.overwriteProps[this.overwriteProps.length] = _local_7;
                if (_local_4[_local_7] != undefined)
                {
                    if (typeof(_local_4[_local_7]) == "number")
                    {
                        _local_5[_local_7].push(_local_4[_local_7]);
                    }
                    else
                    {
                        _local_5[_local_7].push((_arg_1.target[_local_7] + Number(_local_4[_local_7])));
                    };
                    _local_8 = {};
                    _local_8[_local_7] = true;
                    _arg_1.killVars(_local_8, false);
                    delete _local_4[_local_7];
                };
            };
            this._beziers = parseBeziers(_local_5, _arg_3);
        }

        override public function killProps(_arg_1:Object):void
        {
            var _local_2:String;
            for (_local_2 in this._beziers)
            {
                if ((_local_2 in _arg_1))
                {
                    delete this._beziers[_local_2];
                };
            };
            super.killProps(_arg_1);
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_2:int;
            var _local_3:String;
            var _local_4:Object;
            var _local_5:Number;
            var _local_6:int;
            var _local_7:Number;
            var _local_8:Object;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:Array;
            var _local_12:Number;
            var _local_13:Object;
            var _local_14:Boolean;
            _changeFactor = _arg_1;
            if (_arg_1 == 1)
            {
                for (_local_3 in this._beziers)
                {
                    _local_2 = (this._beziers[_local_3].length - 1);
                    this._target[_local_3] = this._beziers[_local_3][_local_2][2];
                };
            }
            else
            {
                for (_local_3 in this._beziers)
                {
                    _local_6 = this._beziers[_local_3].length;
                    if (_arg_1 < 0)
                    {
                        _local_2 = 0;
                    }
                    else
                    {
                        if (_arg_1 >= 1)
                        {
                            _local_2 = (_local_6 - 1);
                        }
                        else
                        {
                            _local_2 = ((_local_6 * _arg_1) >> 0);
                        };
                    };
                    _local_5 = ((_arg_1 - (_local_2 * (1 / _local_6))) * _local_6);
                    _local_4 = this._beziers[_local_3][_local_2];
                    if (this.round)
                    {
                        _local_7 = (_local_4[0] + (_local_5 * (((2 * (1 - _local_5)) * (_local_4[1] - _local_4[0])) + (_local_5 * (_local_4[2] - _local_4[0])))));
                        if (_local_7 > 0)
                        {
                            this._target[_local_3] = ((_local_7 + 0.5) >> 0);
                        }
                        else
                        {
                            this._target[_local_3] = ((_local_7 - 0.5) >> 0);
                        };
                    }
                    else
                    {
                        this._target[_local_3] = (_local_4[0] + (_local_5 * (((2 * (1 - _local_5)) * (_local_4[1] - _local_4[0])) + (_local_5 * (_local_4[2] - _local_4[0])))));
                    };
                };
            };
            if (this._orient)
            {
                _local_2 = this._orientData.length;
                _local_8 = {};
                while (_local_2--)
                {
                    _local_11 = this._orientData[_local_2];
                    _local_8[_local_11[0]] = this._target[_local_11[0]];
                    _local_8[_local_11[1]] = this._target[_local_11[1]];
                };
                _local_13 = this._target;
                _local_14 = this.round;
                this._target = this._future;
                this.round = false;
                this._orient = false;
                _local_2 = this._orientData.length;
                while (_local_2--)
                {
                    _local_11 = this._orientData[_local_2];
                    this.changeFactor = (_arg_1 + ((_local_11[4]) || (0.01)));
                    _local_12 = ((_local_11[3]) || (0));
                    _local_9 = (this._future[_local_11[0]] - _local_8[_local_11[0]]);
                    _local_10 = (this._future[_local_11[1]] - _local_8[_local_11[1]]);
                    _local_13[_local_11[2]] = ((Math.atan2(_local_10, _local_9) * _RAD2DEG) + _local_12);
                };
                this._target = _local_13;
                this.round = _local_14;
                this._orient = true;
            };
        }


    }
}//package com.greensock.plugins

