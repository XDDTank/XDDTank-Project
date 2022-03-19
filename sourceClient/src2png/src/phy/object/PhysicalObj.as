// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.object.PhysicalObj

package phy.object
{
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.geom.Point;
    import road7th.utils.MathUtils;

    public class PhysicalObj extends Physics 
    {

        protected var _id:int;
        protected var _testRect:Rectangle;
        protected var _canCollided:Boolean;
        protected var _isLiving:Boolean;
        protected var _layerType:int;
        private var _drawPointContainer:Sprite;

        public function PhysicalObj(_arg_1:int, _arg_2:int=1, _arg_3:Number=1, _arg_4:Number=1, _arg_5:Number=1, _arg_6:Number=1)
        {
            super(_arg_3, _arg_4, _arg_5, _arg_6);
            this._id = _arg_1;
            this._layerType = _arg_2;
            this._canCollided = false;
            this._testRect = new Rectangle(-5, -5, 10, 10);
            this._isLiving = true;
        }

        public function get Id():int
        {
            return (this._id);
        }

        public function get layerType():int
        {
            return (this._layerType);
        }

        public function setCollideRect(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            this._testRect.top = _arg_2;
            this._testRect.left = _arg_1;
            this._testRect.right = _arg_3;
            this._testRect.bottom = _arg_4;
        }

        public function getCollideRect():Rectangle
        {
            return (this._testRect.clone());
        }

        public function get canCollided():Boolean
        {
            return (this._canCollided);
        }

        public function set canCollided(_arg_1:Boolean):void
        {
            this._canCollided = _arg_1;
        }

        public function get smallView():SmallObject
        {
            return (null);
        }

        public function get isLiving():Boolean
        {
            return (this._isLiving);
        }

        override public function moveTo(_arg_1:Point):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:int;
            var _local_5:Number;
            var _local_6:Point;
            var _local_7:Point;
            var _local_8:int;
            var _local_9:Rectangle;
            var _local_10:Array;
            if (Point.distance(_arg_1, pos) >= 3)
            {
                _local_2 = Math.abs((int(_arg_1.x) - int(x)));
                _local_3 = Math.abs((int(_arg_1.y) - int(y)));
                _local_4 = ((_local_2 > _local_3) ? _local_2 : _local_3);
                _local_5 = (1 / Number(_local_4));
                _local_6 = pos;
                _local_8 = Math.abs(_local_4);
                while (_local_8 > 0)
                {
                    _local_7 = Point.interpolate(_local_6, _arg_1, (_local_5 * _local_8));
                    _local_9 = this.getCollideRect();
                    _local_9.offset(_local_7.x, _local_7.y);
                    _local_10 = _map.getPhysicalObjects(_local_9, this);
                    if (_local_10.length > 0)
                    {
                        pos = _local_7;
                        this.collideObject(_local_10);
                    }
                    else
                    {
                        if ((!(_map.IsRectangleEmpty(_local_9))))
                        {
                            pos = _local_7;
                            this.collideGround();
                        }
                        else
                        {
                            if (_map.IsOutMap(_local_7.x, _local_7.y))
                            {
                                pos = _local_7;
                                this.flyOutMap();
                            };
                        };
                    };
                    if ((!(_isMoving)))
                    {
                        return;
                    };
                    _local_8 = (_local_8 - 3);
                };
                pos = _arg_1;
            };
        }

        public function calcObjectAngle(_arg_1:Number=16):Number
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:Point;
            var _local_5:Point;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:int;
            var _local_11:int;
            if (_map)
            {
                _local_2 = new Array();
                _local_3 = new Array();
                _local_4 = new Point();
                _local_5 = new Point();
                _local_6 = _arg_1;
                _local_7 = 1;
                while (_local_7 <= _local_6)
                {
                    _local_10 = -10;
                    while (_local_10 <= 10)
                    {
                        if (_map.IsEmpty((x + _local_7), (y - _local_10)))
                        {
                            if (_local_10 == -10) break;
                            _local_2.push(new Point((x + _local_7), (y - _local_10)));
                            break;
                        };
                        _local_10++;
                    };
                    _local_11 = -10;
                    while (_local_11 <= 10)
                    {
                        if (_map.IsEmpty((x - _local_7), (y - _local_11)))
                        {
                            if (_local_11 == -10) break;
                            _local_3.push(new Point((x - _local_7), (y - _local_11)));
                            break;
                        };
                        _local_11++;
                    };
                    _local_7 = (_local_7 + 2);
                };
                _local_4 = new Point(x, y);
                _local_5 = new Point(x, y);
                _local_8 = 0;
                while (_local_8 < _local_2.length)
                {
                    _local_4 = _local_4.add(_local_2[_local_8]);
                    _local_8++;
                };
                _local_9 = 0;
                while (_local_9 < _local_3.length)
                {
                    _local_5 = _local_5.add(_local_3[_local_9]);
                    _local_9++;
                };
                _local_4.x = (_local_4.x / (_local_2.length + 1));
                _local_4.y = (_local_4.y / (_local_2.length + 1));
                _local_5.x = (_local_5.x / (_local_3.length + 1));
                _local_5.y = (_local_5.y / (_local_3.length + 1));
                return (MathUtils.GetAngleTwoPoint(_local_4, _local_5));
            };
            return (0);
        }

        public function calcObjectAngleDebug(_arg_1:Number=16):Number
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:Point;
            var _local_5:Point;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:int;
            var _local_11:int;
            if (_map)
            {
                _local_2 = new Array();
                _local_3 = new Array();
                _local_4 = new Point();
                _local_5 = new Point();
                _local_6 = _arg_1;
                _local_7 = 1;
                while (_local_7 <= _local_6)
                {
                    _local_10 = -10;
                    while (_local_10 <= 10)
                    {
                        if (_map.IsEmpty((x + _local_7), (y - _local_10)))
                        {
                            if (_local_10 == -10) break;
                            _local_2.push(new Point((x + _local_7), (y - _local_10)));
                            break;
                        };
                        _local_10++;
                    };
                    _local_11 = -10;
                    while (_local_11 <= 10)
                    {
                        if (_map.IsEmpty((x - _local_7), (y - _local_11)))
                        {
                            if (_local_11 == -10) break;
                            _local_3.push(new Point((x - _local_7), (y - _local_11)));
                            break;
                        };
                        _local_11++;
                    };
                    _local_7 = (_local_7 + 2);
                };
                _local_4 = new Point(x, y);
                _local_5 = new Point(x, y);
                _local_8 = 0;
                while (_local_8 < _local_2.length)
                {
                    _local_4 = _local_4.add(_local_2[_local_8]);
                    _local_8++;
                };
                this.drawPoint(_local_2, true);
                _local_9 = 0;
                while (_local_9 < _local_3.length)
                {
                    _local_5 = _local_5.add(_local_3[_local_9]);
                    _local_9++;
                };
                this.drawPoint(_local_3, false);
                _local_4.x = (_local_4.x / (_local_2.length + 1));
                _local_4.y = (_local_4.y / (_local_2.length + 1));
                _local_5.x = (_local_5.x / (_local_3.length + 1));
                _local_5.y = (_local_5.y / (_local_3.length + 1));
                return (MathUtils.GetAngleTwoPoint(_local_4, _local_5));
            };
            return (0);
        }

        private function drawPoint(_arg_1:Array, _arg_2:Boolean):void
        {
            if (this._drawPointContainer == null)
            {
                this._drawPointContainer = new Sprite();
            };
            if (_arg_2)
            {
                this._drawPointContainer.graphics.clear();
            };
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                this._drawPointContainer.graphics.beginFill(0xFF0000);
                this._drawPointContainer.graphics.drawCircle(_arg_1[_local_3].x, _arg_1[_local_3].y, 2);
                this._drawPointContainer.graphics.endFill();
                _local_3++;
            };
            _map.addChild(this._drawPointContainer);
        }

        protected function flyOutMap():void
        {
            if (this._isLiving)
            {
                this.die();
            };
        }

        protected function collideObject(_arg_1:Array):void
        {
            var _local_2:PhysicalObj;
            for each (_local_2 in _arg_1)
            {
                _local_2.collidedByObject(this);
            };
        }

        protected function collideGround():void
        {
            if (_isMoving)
            {
                stopMoving();
            };
        }

        public function collidedByObject(_arg_1:PhysicalObj):void
        {
        }

        public function setActionMapping(_arg_1:String, _arg_2:String):void
        {
        }

        public function die():void
        {
            this._isLiving = false;
            if (_isMoving)
            {
                stopMoving();
            };
        }

        public function getTestRect():Rectangle
        {
            return (this._testRect.clone());
        }

        public function isBox():Boolean
        {
            return (false);
        }


    }
}//package phy.object

