// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.maps.Ground

package phy.maps
{
    import flash.geom.Rectangle;
    import flash.display.BitmapData;

    public class Ground extends Tile 
    {

        private var _bound:Rectangle;

        public function Ground(_arg_1:BitmapData, _arg_2:Boolean)
        {
            super(_arg_1, _arg_2);
            this._bound = new Rectangle(0, 0, width, height);
        }

        public function IsEmpty(_arg_1:int, _arg_2:int):Boolean
        {
            return (GetAlpha(_arg_1, _arg_2) <= 150);
        }

        public function IsRectangleEmpty(_arg_1:Rectangle):Boolean
        {
            _arg_1 = this._bound.intersection(_arg_1);
            if (((_arg_1.width == 0) || (_arg_1.height == 0)))
            {
                return (true);
            };
            if ((!(this.IsXLineEmpty(_arg_1.x, _arg_1.y, _arg_1.width))))
            {
                return (false);
            };
            if (_arg_1.height > 1)
            {
                if ((!(this.IsXLineEmpty(_arg_1.x, ((_arg_1.y + _arg_1.height) - 1), _arg_1.width))))
                {
                    return (false);
                };
                if ((!(this.IsYLineEmtpy(_arg_1.x, (_arg_1.y + 1), (_arg_1.height - 1)))))
                {
                    return (false);
                };
                if (((_arg_1.width > 1) && (!(this.IsYLineEmtpy(((_arg_1.x + _arg_1.width) - 1), _arg_1.y, (_arg_1.height - 1))))))
                {
                    return (false);
                };
            };
            return (true);
        }

        public function IsRectangeEmptyQuick(_arg_1:Rectangle):Boolean
        {
            _arg_1 = this._bound.intersection(_arg_1);
            if (((((this.IsEmpty(_arg_1.right, _arg_1.bottom)) && (this.IsEmpty(_arg_1.left, _arg_1.bottom))) && (this.IsEmpty(_arg_1.right, _arg_1.top))) && (this.IsEmpty(_arg_1.left, _arg_1.top))))
            {
                return (true);
            };
            return (false);
        }

        public function IsXLineEmpty(_arg_1:int, _arg_2:int, _arg_3:int):Boolean
        {
            _arg_1 = ((_arg_1 < 0) ? 0 : _arg_1);
            _arg_3 = (((_arg_1 + _arg_3) > width) ? (width - _arg_1) : _arg_3);
            var _local_4:int;
            while (_local_4 < _arg_3)
            {
                if ((!(this.IsEmpty((_arg_1 + _local_4), _arg_2))))
                {
                    return (false);
                };
                _local_4++;
            };
            return (true);
        }

        public function IsYLineEmtpy(_arg_1:int, _arg_2:int, _arg_3:int):Boolean
        {
            _arg_2 = ((_arg_2 < 0) ? 0 : _arg_2);
            _arg_3 = (((_arg_2 + _arg_3) > height) ? (height - _arg_2) : _arg_3);
            var _local_4:int;
            while (_local_4 < _arg_3)
            {
                if ((!(this.IsEmpty(_arg_1, (_arg_2 + _local_4)))))
                {
                    return (false);
                };
                _local_4++;
            };
            return (true);
        }


    }
}//package phy.maps

