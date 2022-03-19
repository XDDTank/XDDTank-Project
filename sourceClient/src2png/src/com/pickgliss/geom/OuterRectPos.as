// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.geom.OuterRectPos

package com.pickgliss.geom
{
    import flash.geom.Point;

    public class OuterRectPos 
    {

        private var _posX:int;
        private var _posY:int;
        private var _lockDirection:int;

        public function OuterRectPos(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            this._posX = _arg_1;
            this._posY = _arg_2;
            this._lockDirection = _arg_3;
        }

        public function getPos(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):Point
        {
            var _local_5:Point = new Point();
            if (this._lockDirection == LockDirectionTypes.LOCK_T)
            {
                _local_5.x = (((_arg_3 - _arg_1) / 2) + this._posX);
                _local_5.y = this._posY;
            }
            else
            {
                if (this._lockDirection == LockDirectionTypes.LOCK_TL)
                {
                    _local_5.x = this._posX;
                    _local_5.y = this._posY;
                }
                else
                {
                    if (this._lockDirection == LockDirectionTypes.LOCK_TR)
                    {
                    };
                };
            };
            return (_local_5);
        }


    }
}//package com.pickgliss.geom

