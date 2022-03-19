// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.container.HBox

package com.pickgliss.ui.controls.container
{
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class HBox extends BoxContainer 
    {


        override public function arrange():void
        {
            var _local_4:DisplayObject;
            _width = 0;
            _height = 0;
            var _local_1:Number = 0;
            var _local_2:Number = 0;
            var _local_3:int;
            while (_local_3 < _childrenList.length)
            {
                _local_4 = _childrenList[_local_3];
                _local_4.x = _local_1;
                _local_1 = (_local_1 + this.getItemWidth(_local_4));
                _local_1 = (_local_1 + _spacing);
                if (((_autoSize == CENTER) && (!(_local_3 == 0))))
                {
                    _local_2 = (_childrenList[0].y - ((_local_4.height - _childrenList[0].height) / 2));
                }
                else
                {
                    if (((_autoSize == RIGHT_OR_BOTTOM) && (!(_local_3 == 0))))
                    {
                        _local_2 = (_childrenList[0].y - (_local_4.height - _childrenList[0].height));
                    }
                    else
                    {
                        _local_2 = _childrenList[0].y;
                    };
                };
                _local_4.y = _local_2;
                _width = (_width + this.getItemWidth(_local_4));
                _height = Math.max(_height, _local_4.height);
                _local_3++;
            };
            _width = (_width + (_spacing * (numChildren - 1)));
            _width = Math.max(0, _width);
            dispatchEvent(new Event(Event.RESIZE));
        }

        private function getItemWidth(_arg_1:DisplayObject):Number
        {
            if (isStrictSize)
            {
                return (_strictSize);
            };
            return (_arg_1.width);
        }


    }
}//package com.pickgliss.ui.controls.container

