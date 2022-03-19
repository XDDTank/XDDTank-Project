// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.scenePathSearcher.PathRoboSearcher

package ddt.view.scenePathSearcher
{
    import flash.geom.Point;
    import ddt.utils.Geometry;

    public class PathRoboSearcher implements PathIPathSearcher 
    {

        private static var LEFT:Number = -1;
        private static var RIGHT:Number = 1;

        private var step:Number;
        private var maxCount:Number;
        private var maxDistance:Number;
        private var stepTurnNum:Number;

        public function PathRoboSearcher(_arg_1:Number, _arg_2:Number, _arg_3:Number=4)
        {
            this.step = _arg_1;
            this.maxDistance = _arg_2;
            this.maxCount = (Math.ceil((_arg_2 / _arg_1)) * 2);
            this.stepTurnNum = _arg_3;
        }

        public function setStepTurnNum(_arg_1:Number):void
        {
            this.stepTurnNum = _arg_1;
        }

        public function search(_arg_1:Point, _arg_2:Point, _arg_3:PathIHitTester):Array
        {
            var _local_4:Array = [_arg_1, _arg_1];
            if (_arg_1.equals(_arg_2))
            {
                return (_local_4);
            };
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:Boolean = this.searchWithWish(_arg_1, _arg_2, _arg_3, LEFT, _local_5);
            var _local_8:Boolean = this.searchWithWish(_arg_1, _arg_2, _arg_3, RIGHT, _local_6);
            if (((_local_7) && (_local_8)))
            {
                if (_local_5.length < _local_6.length)
                {
                    return (_local_5);
                };
                return (_local_6);
            };
            if (_local_7)
            {
                return (_local_5);
            };
            if (_local_8)
            {
                return (_local_6);
            };
            return (_local_4);
        }

        private function searchWithWish(_arg_1:Point, _arg_2:Point, _arg_3:PathIHitTester, _arg_4:Number, _arg_5:Array):Boolean
        {
            var _local_7:Point;
            var _local_8:Boolean;
            var _local_9:Array;
            var _local_10:Boolean;
            var _local_11:Point;
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Point;
            if (_arg_3.isHit(_arg_2))
            {
                _arg_2 = this.findReversseNearestBlankPoint(_arg_1, _arg_2, _arg_3);
                if (_arg_2 == null)
                {
                    return (false);
                };
                if (_arg_3.isHit(_arg_1))
                {
                    _arg_5.push(_arg_1);
                    _arg_5.push(_arg_2);
                    return (true);
                };
            }
            else
            {
                if (_arg_3.isHit(_arg_1))
                {
                    _local_7 = this.findReversseNearestBlankPoint(_arg_2, _arg_1, _arg_3);
                    if (_local_7 == null)
                    {
                        return (false);
                    };
                    _local_8 = this.searchWithWish(_local_7, _arg_2, _arg_3, _arg_4, _arg_5);
                    if (_local_8)
                    {
                        _arg_5.splice(0, 0, _arg_1);
                        return (true);
                    };
                    return (false);
                };
            };
            if (Point.distance(_arg_1, _arg_2) > this.maxDistance)
            {
                _arg_5.push(_arg_1);
                _arg_2 = this.findFarestBlankPoint(_arg_1, _arg_2, _arg_3);
                if (_arg_2 == null)
                {
                    return (false);
                };
                _arg_5.push(_arg_2);
                return (true);
            };
            var _local_6:Boolean = this.doSearchWithWish(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            if ((!(_local_6)))
            {
                return (false);
            };
            if (_arg_5.length > 4)
            {
                _local_9 = new Array();
                _local_10 = this.doSearchWithWish(_arg_2, _arg_5[0], _arg_3, (0 - _arg_4), _local_9);
                if (_local_10)
                {
                    _local_11 = Point(_local_9[(_local_9.length - 2)]);
                    _local_12 = this.step;
                    _local_13 = 1;
                    while (_local_13 < (_arg_5.length - 1))
                    {
                        _local_14 = Point(_arg_5[_local_13]);
                        if (Point.distance(_local_14, _local_11) < _local_12)
                        {
                            _arg_5.splice(1, _local_13, _local_11);
                            return (true);
                        };
                        _local_13++;
                    };
                };
            };
            return (true);
        }

        private function findFarestBlankPoint(_arg_1:Point, _arg_2:Point, _arg_3:PathIHitTester):Point
        {
            var _local_10:Point;
            if (_arg_3.isHit(_arg_1))
            {
                return (this.findReversseNearestBlankPoint(_arg_2, _arg_1, _arg_3));
            };
            var _local_4:Number = this.countHeading(_arg_1, _arg_2);
            var _local_5:Number = Point.distance(_arg_1, _arg_2);
            var _local_6:Point = _arg_1;
            while ((!(_arg_3.isHit(_arg_1))))
            {
                _local_6 = _arg_1;
                _arg_1 = Geometry.nextPoint(_arg_1, _local_4, this.step);
                _local_5 = (_local_5 - this.step);
                if (_local_5 <= 0)
                {
                    return (null);
                };
            };
            _arg_1 = _local_6;
            var _local_7:Number = 8;
            var _local_8:Number = (Math.PI / _local_7);
            var _local_9:Number = 1;
            while (_local_9 < _local_7)
            {
                _local_10 = Geometry.nextPoint(_arg_1, (_local_4 + (_local_9 * _local_8)), (this.step * 2));
                if ((!(_arg_3.isHit(_local_10))))
                {
                    return (_local_10);
                };
                _local_10 = Geometry.nextPoint(_arg_1, (_local_4 - (_local_9 * _local_8)), (this.step * 2));
                if ((!(_arg_3.isHit(_local_10))))
                {
                    return (_local_10);
                };
                _local_9++;
            };
            return (_arg_1);
        }

        private function findReversseNearestBlankPoint(_arg_1:Point, _arg_2:Point, _arg_3:PathIHitTester):Point
        {
            var _local_9:Point;
            var _local_4:Number = this.countHeading(_arg_2, _arg_1);
            var _local_5:Number = Point.distance(_arg_2, _arg_1);
            while (_arg_3.isHit(_arg_2))
            {
                _arg_2 = Geometry.nextPoint(_arg_2, _local_4, this.step);
                _local_5 = (_local_5 - this.step);
                if (_local_5 <= 0)
                {
                    return (null);
                };
            };
            var _local_6:Number = 12;
            var _local_7:Number = (Math.PI / _local_6);
            _local_4 = (_local_4 + Math.PI);
            var _local_8:Number = 1;
            while (_local_8 < _local_6)
            {
                _local_9 = Geometry.nextPoint(_arg_2, (_local_4 + (_local_8 * _local_7)), (this.step * 2));
                if ((!(_arg_3.isHit(_local_9))))
                {
                    return (_local_9);
                };
                _local_9 = Geometry.nextPoint(_arg_2, (_local_4 - (_local_8 * _local_7)), (this.step * 2));
                if ((!(_arg_3.isHit(_local_9))))
                {
                    return (_local_9);
                };
                _local_8++;
            };
            return (_arg_2);
        }

        private function doSearchWithWish(_arg_1:Point, _arg_2:Point, _arg_3:PathIHitTester, _arg_4:Number, _arg_5:Array):Boolean
        {
            var _local_12:Number;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Point;
            var _local_16:Point;
            var _local_17:Number;
            var _local_18:Boolean;
            var _local_19:Number;
            _arg_5.push(_arg_1);
            var _local_6:Number = ((_arg_4 * Math.PI) / this.stepTurnNum);
            var _local_7:Number = ((_arg_4 * Math.PI) / 2);
            var _local_8:Number = 1;
            var _local_9:Number = this.step;
            var _local_10:Number = this.countHeading(_arg_1, _arg_2);
            var _local_11:Number = Point.distance(_arg_1, _arg_2);
            while (((_local_11 > _local_9) && (_local_8++ < this.maxCount)))
            {
                _local_12 = this.countHeading(_arg_1, _arg_2);
                _local_13 = (_local_10 - _local_7);
                _local_14 = this.bearing(_local_12, _local_13);
                if ((((_arg_4 > 0) && (_local_14 < 0)) || ((_arg_4 < 0) && (_local_14 > 0))))
                {
                    _local_13 = _local_12;
                };
                _local_15 = Geometry.nextPoint(_arg_1, _local_13, this.step);
                _local_16 = _arg_1;
                if (_arg_3.isHit(_local_15))
                {
                    _local_18 = false;
                    _local_19 = 2;
                    while (_local_19 < (this.stepTurnNum * 2))
                    {
                        _local_13 = (_local_13 + _local_6);
                        _local_15 = Geometry.nextPoint(_arg_1, _local_13, this.step);
                        if ((!(_arg_3.isHit(_local_15))))
                        {
                            _arg_1 = _local_15;
                            _local_17 = Point.distance(_arg_1, _arg_2);
                            _local_18 = true;
                            break;
                        };
                        _local_19++;
                    };
                    if ((!(_local_18)))
                    {
                        _arg_5.splice(0);
                        return (false);
                    };
                }
                else
                {
                    _arg_1 = _local_15;
                    _local_17 = Point.distance(_arg_1, _arg_2);
                };
                if (Math.abs(this.bearing(_local_10, _local_13)) > 0.01)
                {
                    _arg_5.push(_local_16);
                    _local_10 = _local_13;
                };
                _local_11 = _local_17;
            };
            if (_local_8 <= this.maxCount)
            {
                _arg_5.push(_arg_2);
                return (true);
            };
            return (false);
        }

        private function countHeading(_arg_1:Point, _arg_2:Point):Number
        {
            return (Math.atan2((_arg_2.y - _arg_1.y), (_arg_2.x - _arg_1.x)));
        }

        private function bearing(_arg_1:Number, _arg_2:Number):Number
        {
            var _local_3:Number = (_arg_2 - _arg_1);
            _local_3 = ((_local_3 + (Math.PI * 4)) % (Math.PI * 2));
            if (_local_3 < -(Math.PI))
            {
                _local_3 = (_local_3 + (Math.PI * 2));
            }
            else
            {
                if (_local_3 > Math.PI)
                {
                    _local_3 = (_local_3 - (Math.PI * 2));
                };
            };
            return (_local_3);
        }


    }
}//package ddt.view.scenePathSearcher

