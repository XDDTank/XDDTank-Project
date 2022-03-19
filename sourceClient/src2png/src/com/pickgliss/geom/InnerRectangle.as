// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.geom.InnerRectangle

package com.pickgliss.geom
{
    import flash.geom.Rectangle;

    public class InnerRectangle 
    {

        public var lockDirection:int;
        public var para1:int;
        public var para2:int;
        public var para3:int;
        public var para4:int;
        private var _outerHeight:int;
        private var _outerWidth:int;
        private var _resultRect:Rectangle;

        public function InnerRectangle(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int=0)
        {
            this.para1 = _arg_1;
            this.para2 = _arg_2;
            this.para3 = _arg_3;
            this.para4 = _arg_4;
            this.lockDirection = _arg_5;
        }

        public function equals(_arg_1:InnerRectangle):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            return (((((this.para4 == _arg_1.para4) && (this.para1 == _arg_1.para1)) && (this.lockDirection == _arg_1.lockDirection)) && (this.para2 == _arg_1.para2)) && (this.para3 == _arg_1.para3));
        }

        public function getInnerRect(_arg_1:int, _arg_2:int):Rectangle
        {
            this._outerWidth = _arg_1;
            this._outerHeight = _arg_2;
            return (this.calculateCurrent());
        }

        private function calculateCurrent():Rectangle
        {
            var _local_1:Rectangle = new Rectangle();
            if (this.lockDirection == LockDirectionTypes.UNLOCK)
            {
                _local_1.x = this.para1;
                _local_1.y = this.para3;
                _local_1.width = ((this._outerWidth - this.para1) - this.para2);
                _local_1.height = ((this._outerHeight - this.para3) - this.para4);
            }
            else
            {
                if (this.lockDirection == LockDirectionTypes.LOCK_T)
                {
                    _local_1.x = this.para1;
                    _local_1.y = this.para3;
                    _local_1.width = ((this._outerWidth - this.para1) - this.para2);
                    _local_1.height = this.para4;
                }
                else
                {
                    if (this.lockDirection == LockDirectionTypes.LOCK_L)
                    {
                        _local_1.x = this.para1;
                        _local_1.y = this.para3;
                        _local_1.width = this.para2;
                        _local_1.height = ((this._outerHeight - this.para3) - this.para4);
                    }
                    else
                    {
                        if (this.lockDirection == LockDirectionTypes.LOCK_R)
                        {
                            _local_1.x = ((this._outerWidth - this.para1) - this.para2);
                            _local_1.y = this.para3;
                            _local_1.width = this.para1;
                            _local_1.height = ((this._outerHeight - this.para3) - this.para4);
                        }
                        else
                        {
                            if (this.lockDirection == LockDirectionTypes.LOCK_B)
                            {
                                _local_1.x = this.para1;
                                _local_1.y = ((this._outerHeight - this.para3) - this.para4);
                                _local_1.width = ((this._outerWidth - this.para1) - this.para2);
                                _local_1.height = this.para3;
                            }
                            else
                            {
                                if (this.lockDirection == LockDirectionTypes.NO_SCALE_T)
                                {
                                    _local_1.x = (((this._outerWidth - this.para1) / 2) + this.para4);
                                    _local_1.y = this.para3;
                                    _local_1.width = this.para1;
                                    _local_1.height = this.para2;
                                }
                                else
                                {
                                    if (this.lockDirection == LockDirectionTypes.NO_SCALE_B)
                                    {
                                        _local_1.x = (((this._outerWidth - this.para1) / 2) + this.para3);
                                        _local_1.y = ((this._outerHeight - this.para4) - this.para2);
                                        _local_1.width = this.para1;
                                        _local_1.height = this.para2;
                                    }
                                    else
                                    {
                                        if (this.lockDirection == LockDirectionTypes.NO_SCALE_L)
                                        {
                                            _local_1.x = this.para1;
                                            _local_1.y = (((this._outerHeight - this.para4) / 2) + this.para2);
                                            _local_1.width = this.para3;
                                            _local_1.height = this.para4;
                                        }
                                        else
                                        {
                                            if (this.lockDirection == LockDirectionTypes.NO_SCALE_R)
                                            {
                                                _local_1.x = ((this._outerWidth - this.para2) - this.para3);
                                                _local_1.y = (((this._outerHeight - this.para3) / 2) + this.para1);
                                                _local_1.width = this.para3;
                                                _local_1.height = this.para4;
                                            }
                                            else
                                            {
                                                if (this.lockDirection == LockDirectionTypes.NO_SCALE_TL)
                                                {
                                                    _local_1.x = this.para1;
                                                    _local_1.y = this.para3;
                                                    _local_1.width = this.para2;
                                                    _local_1.height = this.para4;
                                                }
                                                else
                                                {
                                                    if (this.lockDirection == LockDirectionTypes.NO_SCALE_TR)
                                                    {
                                                        _local_1.x = ((this._outerWidth - this.para1) - this.para2);
                                                        _local_1.y = this.para3;
                                                        _local_1.width = this.para1;
                                                        _local_1.height = this.para4;
                                                    }
                                                    else
                                                    {
                                                        if (this.lockDirection == LockDirectionTypes.NO_SCALE_BL)
                                                        {
                                                            _local_1.x = this.para1;
                                                            _local_1.y = ((this._outerHeight - this.para4) - this.para3);
                                                            _local_1.width = this.para2;
                                                            _local_1.height = this.para3;
                                                        }
                                                        else
                                                        {
                                                            if (this.lockDirection == LockDirectionTypes.NO_SCALE_BR)
                                                            {
                                                                _local_1.x = ((this._outerWidth - this.para1) - this.para2);
                                                                _local_1.y = ((this._outerHeight - this.para4) - this.para3);
                                                                _local_1.width = this.para1;
                                                                _local_1.height = this.para3;
                                                            }
                                                            else
                                                            {
                                                                if (this.lockDirection == LockDirectionTypes.UNLOCK_OUTSIDE)
                                                                {
                                                                    _local_1.x = -(this.para1);
                                                                    _local_1.y = -(this.para3);
                                                                    _local_1.width = ((this._outerWidth + this.para1) + this.para2);
                                                                    _local_1.height = ((this._outerHeight + this.para4) + this.para3);
                                                                }
                                                                else
                                                                {
                                                                    if (this.lockDirection == LockDirectionTypes.NO_SCALE_C)
                                                                    {
                                                                        _local_1.x = (((this._outerWidth - this.para2) / 2) + this.para1);
                                                                        _local_1.y = (((this._outerHeight - this.para4) / 2) + this.para3);
                                                                        _local_1.width = this.para2;
                                                                        _local_1.height = this.para4;
                                                                    }
                                                                    else
                                                                    {
                                                                        if (this.lockDirection == LockDirectionTypes.LOCK_TL)
                                                                        {
                                                                            _local_1.x = this.para1;
                                                                            _local_1.y = this.para2;
                                                                            _local_1.width = (this._outerWidth - this.para3);
                                                                            _local_1.height = (this._outerHeight - this.para4);
                                                                        }
                                                                        else
                                                                        {
                                                                            if (this.lockDirection == LockDirectionTypes.LOCK_OUTER_DOWN)
                                                                            {
                                                                                _local_1.x = this.para1;
                                                                                _local_1.y = this.para2;
                                                                                _local_1.width = (this._outerWidth - this.para3);
                                                                                _local_1.height = this.para4;
                                                                            };
                                                                        };
                                                                    };
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_1);
        }


    }
}//package com.pickgliss.geom

