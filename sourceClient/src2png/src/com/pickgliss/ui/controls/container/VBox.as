// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.container.VBox

package com.pickgliss.ui.controls.container
{
    import flash.display.DisplayObject;
    import flash.events.Event;

    public class VBox extends BoxContainer 
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
                _local_4.y = _local_1;
                _local_1 = (_local_1 + this.getItemHeight(_local_4));
                _local_1 = (_local_1 + _spacing);
                if (((_autoSize == CENTER) && (!(_local_3 == 0))))
                {
                    _local_2 = (_childrenList[0].x - ((_local_4.width - _childrenList[0].width) / 2));
                }
                else
                {
                    if (((_autoSize == RIGHT_OR_BOTTOM) && (!(_local_3 == 0))))
                    {
                        _local_2 = (_childrenList[0].x - (_local_4.width - _childrenList[0].width));
                    }
                    else
                    {
                        _local_2 = _local_4.x;
                    };
                };
                _local_4.x = _local_2;
                _height = (_height + this.getItemHeight(_local_4));
                _width = Math.max(_width, _local_4.width);
                _local_3++;
            };
            _height = (_height + (_spacing * (numChildren - 1)));
            _height = Math.max(0, _height);
            dispatchEvent(new Event(Event.RESIZE));
        }

        private function getItemHeight(_arg_1:DisplayObject):Number
        {
            if (isStrictSize)
            {
                return (_strictSize);
            };
            return (_arg_1.height);
        }


    }
}//package com.pickgliss.ui.controls.container

