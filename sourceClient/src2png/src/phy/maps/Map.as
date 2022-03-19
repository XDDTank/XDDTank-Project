// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//phy.maps.Map

package phy.maps
{
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import flash.geom.Rectangle;
    import par.enginees.ParticleEnginee;
    import flash.display.DisplayObject;
    import par.renderer.DisplayObjectRenderer;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.display.Bitmap;
    import phy.object.PhysicalObj;
    import phy.object.PhysicsLayer;
    import phy.object.Physics;
    import flash.utils.getTimer;
    import com.pickgliss.utils.ObjectUtils;

    public class Map extends Sprite 
    {

        private static var FRAME_TIME_OVER_TAG:int = 67;
        private static var FRAME_OVER_COUNT_TAG:int = 25;
        private static var rate:Number = 0.04;

        public var wind:Number = 3;
        public var gravity:Number = 9.8;
        public var airResistance:Number = 2;
        private var _objects:Dictionary;
        private var _phyicals:Dictionary;
        private var _bound:Rectangle;
        private var _partical:ParticleEnginee;
        protected var _sky:DisplayObject;
        protected var _stone:Ground;
        protected var _ground:Ground;
        protected var _middle:DisplayObject;
        protected var _livingLayer:Sprite;
        protected var _controlLayer:Sprite;
        protected var _phyLayer:Sprite;
        protected var _mapThing:Sprite;
        private var _lastCheckTime:int = 0;
        private var _frameTimeOverCount:int = 0;
        protected var _mapChanged:Boolean = false;
        private var _isLackOfFPS:Boolean = false;

        public function Map(_arg_1:DisplayObject, _arg_2:Ground=null, _arg_3:Ground=null, _arg_4:DisplayObject=null)
        {
            this._phyicals = new Dictionary();
            this._objects = new Dictionary();
            this._sky = _arg_1;
            addChild(this._sky);
            graphics.beginFill(0, 1);
            graphics.drawRect(0, 0, (this._sky.width * 1.5), (this._sky.height * 1.5));
            graphics.endFill();
            this._stone = _arg_3;
            this._middle = _arg_4;
            if (this._middle)
            {
                addChild(this._middle);
            };
            if (this._stone)
            {
                addChild(this._stone);
            };
            this._ground = _arg_2;
            if (this._ground)
            {
                addChild(this._ground);
            };
            this._livingLayer = new Sprite();
            addChild(this._livingLayer);
            this._controlLayer = new Sprite();
            addChild(this._controlLayer);
            this._phyLayer = new Sprite();
            addChild(this._phyLayer);
            this._mapThing = new Sprite();
            addChild(this._mapThing);
            var _local_5:DisplayObjectRenderer = new DisplayObjectRenderer();
            this._phyLayer.addChild(_local_5);
            this._partical = new ParticleEnginee(_local_5);
            if (this._ground)
            {
                this._bound = new Rectangle(0, 0, this._ground.width, this._ground.height);
            }
            else
            {
                this._bound = new Rectangle(0, 0, this._stone.width, this._stone.height);
            };
            addEventListener(Event.ENTER_FRAME, this.__enterFrame);
        }

        public function get bound():Rectangle
        {
            return (this._bound);
        }

        public function get sky():DisplayObject
        {
            return (this._sky);
        }

        public function get ground():Ground
        {
            return (this._ground);
        }

        public function get stone():Ground
        {
            return (this._stone);
        }

        public function get particleEnginee():ParticleEnginee
        {
            return (this._partical);
        }

        public function Dig(_arg_1:Point, _arg_2:Bitmap, _arg_3:Bitmap=null):void
        {
            this._mapChanged = true;
            if (this._ground)
            {
                this._ground.Dig(_arg_1, _arg_2, _arg_3);
            };
            if (this._stone)
            {
                this._stone.Dig(_arg_1, _arg_2, _arg_3);
            };
        }

        public function get mapChanged():Boolean
        {
            return (this._mapChanged);
        }

        public function resetMapChanged():void
        {
            this._mapChanged = false;
        }

        public function IsEmpty(_arg_1:int, _arg_2:int):Boolean
        {
            return (((this._ground == null) || (this._ground.IsEmpty(_arg_1, _arg_2))) && ((this._stone == null) || (this._stone.IsEmpty(_arg_1, _arg_2))));
        }

        public function IsRectangleEmpty(_arg_1:Rectangle):Boolean
        {
            return (((this._ground == null) || (this._ground.IsRectangeEmptyQuick(_arg_1))) && ((this._stone == null) || (this._stone.IsRectangeEmptyQuick(_arg_1))));
        }

        public function findYLineNotEmptyPointDown(_arg_1:int, _arg_2:int, _arg_3:int):Point
        {
            _arg_1 = ((_arg_1 < 0) ? 0 : ((_arg_1 >= this._bound.width) ? (this._bound.width - 1) : _arg_1));
            _arg_2 = ((_arg_2 < 0) ? 0 : _arg_2);
            _arg_3 = (((_arg_2 + _arg_3) >= this._bound.height) ? ((this._bound.height - _arg_2) - 1) : _arg_3);
            var _local_4:int;
            while (_local_4 < _arg_3)
            {
                if (((!(this.IsEmpty((_arg_1 - 1), _arg_2))) || (!(this.IsEmpty((_arg_1 + 1), _arg_2)))))
                {
                    return (new Point(_arg_1, _arg_2));
                };
                _arg_2++;
                _local_4++;
            };
            return (null);
        }

        public function findYLineNotEmptyPointUp(_arg_1:int, _arg_2:int, _arg_3:int):Point
        {
            _arg_1 = ((_arg_1 < 0) ? 0 : ((_arg_1 > this._bound.width) ? this._bound.width : _arg_1));
            _arg_2 = ((_arg_2 < 0) ? 0 : _arg_2);
            _arg_3 = (((_arg_2 + _arg_3) > this._bound.height) ? (this._bound.height - _arg_2) : _arg_3);
            var _local_4:int;
            while (_local_4 < _arg_3)
            {
                if (((!(this.IsEmpty((_arg_1 - 1), _arg_2))) || (!(this.IsEmpty((_arg_1 + 1), _arg_2)))))
                {
                    return (new Point(_arg_1, _arg_2));
                };
                _arg_2--;
                _local_4++;
            };
            return (null);
        }

        public function findNextWalkPoint(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):Point
        {
            if (((!(_arg_3 == 1)) && (!(_arg_3 == -1))))
            {
                return (null);
            };
            var _local_6:int = (_arg_1 + (_arg_3 * _arg_4));
            if (((_local_6 < 0) || (_local_6 > this._bound.width)))
            {
                return (null);
            };
            var _local_7:Point = this.findYLineNotEmptyPointDown(_local_6, ((_arg_2 - _arg_5) - 1), this._bound.height);
            if (_local_7)
            {
                if (Math.abs((_local_7.y - _arg_2)) > _arg_5)
                {
                    _local_7 = null;
                };
            };
            return (_local_7);
        }

        public function canMove(_arg_1:int, _arg_2:int):Boolean
        {
            return ((this.IsEmpty(_arg_1, _arg_2)) && (!(this.IsOutMap(_arg_1, _arg_2))));
        }

        public function IsOutMap(_arg_1:int, _arg_2:int):Boolean
        {
            if ((((_arg_1 < this._bound.x) || (_arg_1 > this._bound.width)) || (_arg_2 > this._bound.height)))
            {
                return (true);
            };
            return (false);
        }

        public function addPhysical(_arg_1:Physics):void
        {
            if ((_arg_1 is PhysicalObj))
            {
                this._phyicals[_arg_1] = _arg_1;
                if (_arg_1.layer == PhysicsLayer.GhostBox)
                {
                    this._phyLayer.addChild(_arg_1);
                }
                else
                {
                    if (_arg_1.layer == PhysicsLayer.SimpleObject)
                    {
                        this._livingLayer.addChild(_arg_1);
                    }
                    else
                    {
                        if (_arg_1.layer == PhysicsLayer.GameLiving)
                        {
                            this._livingLayer.addChild(_arg_1);
                        }
                        else
                        {
                            if (((_arg_1.layer == PhysicsLayer.Tomb) || (_arg_1.layer == PhysicsLayer.AppointBottom)))
                            {
                                this._livingLayer.addChildAt(_arg_1, 0);
                            }
                            else
                            {
                                this._phyLayer.addChild(_arg_1);
                            };
                        };
                    };
                };
            }
            else
            {
                this._objects[_arg_1] = _arg_1;
                addChild(_arg_1);
            };
            _arg_1.setMap(this);
        }

        public function addToControlLayer(_arg_1:DisplayObject):void
        {
            this._controlLayer.addChild(_arg_1);
        }

        public function addToPhyLayer(_arg_1:DisplayObject):void
        {
            this._phyLayer.addChild(_arg_1);
        }

        public function addMapThing(_arg_1:Physics):void
        {
            this._mapThing.addChild(_arg_1);
            _arg_1.setMap(this);
            if ((_arg_1 is PhysicalObj))
            {
                this._phyicals[_arg_1] = _arg_1;
            }
            else
            {
                this._objects[_arg_1] = _arg_1;
            };
        }

        public function removeMapThing(_arg_1:Physics):void
        {
            this._mapThing.removeChild(_arg_1);
            _arg_1.setMap(null);
            if ((_arg_1 is PhysicalObj))
            {
                delete this._phyicals[_arg_1];
            }
            else
            {
                delete this._objects[_arg_1];
            };
        }

        public function setTopPhysical(_arg_1:Physics):void
        {
            _arg_1.parent.setChildIndex(_arg_1, (_arg_1.parent.numChildren - 1));
        }

        public function hasSomethingMoving():Boolean
        {
            var _local_1:PhysicalObj;
            for each (_local_1 in this._phyicals)
            {
                if (_local_1.isMoving())
                {
                    return (true);
                };
            };
            return (false);
        }

        public function removePhysical(_arg_1:Physics):void
        {
            if (_arg_1.parent)
            {
                _arg_1.parent.removeChild(_arg_1);
            };
            _arg_1.setMap(null);
            if ((_arg_1 is PhysicalObj))
            {
                if (((this._phyicals == null) || (!(this._phyicals[_arg_1]))))
                {
                    return;
                };
                delete this._phyicals[_arg_1];
            }
            else
            {
                if (((!(this._objects)) || (!(this._objects[_arg_1]))))
                {
                    return;
                };
                delete this._objects[_arg_1];
            };
        }

        public function hidePhysical(_arg_1:PhysicalObj):void
        {
            var _local_2:PhysicalObj;
            for each (_local_2 in this._phyicals)
            {
                if (_local_2 != _arg_1)
                {
                    _local_2.visible = false;
                };
            };
        }

        public function showPhysical():void
        {
            var _local_1:PhysicalObj;
            for each (_local_1 in this._phyicals)
            {
                _local_1.visible = true;
            };
        }

        public function getPhysicalObjects(_arg_1:Rectangle, _arg_2:PhysicalObj):Array
        {
            var _local_4:PhysicalObj;
            var _local_5:Rectangle;
            var _local_3:Array = new Array();
            for each (_local_4 in this._phyicals)
            {
                if ((((!(_local_4 == _arg_2)) && (_local_4.isLiving)) && (_local_4.canCollided)))
                {
                    _local_5 = _local_4.getCollideRect();
                    if (_local_5.intersects(_arg_1))
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            return (_local_3);
        }

        public function getCollidedPhysicalObjects(_arg_1:Rectangle, _arg_2:PhysicalObj):Array
        {
            var _local_4:PhysicalObj;
            var _local_5:Rectangle;
            var _local_3:Array = new Array();
            for each (_local_4 in this._phyicals)
            {
                if (((!(_local_4 == _arg_2)) && (_local_4.canCollided)))
                {
                    _local_5 = _local_4.getCollideRect();
                    _local_5.offset(_local_4.x, _local_4.y);
                    if (_local_5.intersects(_arg_1))
                    {
                        _local_3.push(_local_4);
                    };
                };
            };
            return (_local_3);
        }

        public function getPhysicalObjectByPoint(_arg_1:Point, _arg_2:Number, _arg_3:PhysicalObj=null):Array
        {
            var _local_5:PhysicalObj;
            var _local_4:Array = new Array();
            for each (_local_5 in this._phyicals)
            {
                if ((((!(_local_5 == _arg_3)) && (_local_5.isLiving)) && (Point.distance(_arg_1, _local_5.pos) <= _arg_2)))
                {
                    _local_4.push(_local_5);
                };
            };
            return (_local_4);
        }

        public function getBoxesByRect(_arg_1:Rectangle):Array
        {
            var _local_3:PhysicalObj;
            var _local_4:Rectangle;
            var _local_2:Array = new Array();
            for each (_local_3 in this._phyicals)
            {
                if (((_local_3.isBox()) && (_local_3.isLiving)))
                {
                    _local_4 = _local_3.getTestRect();
                    _local_4.offset(_local_3.x, _local_3.y);
                    if (_local_4.intersects(_arg_1))
                    {
                        _local_2.push(_local_3);
                    };
                };
            };
            return (_local_2);
        }

        private function __enterFrame(_arg_1:Event):void
        {
            this.update();
        }

        protected function update(_arg_1:Boolean=true):void
        {
            var _local_3:Physics;
            var _local_2:Number = numChildren;
            for each (_local_3 in this._phyicals)
            {
                _local_3.update(rate);
            };
            if (_arg_1)
            {
                this._partical.update();
            };
            this.checkOverFrameRate();
        }

        private function checkOverFrameRate():void
        {
            if (this._isLackOfFPS)
            {
                return;
            };
            var _local_1:int = getTimer();
            if (this._lastCheckTime == 0)
            {
                this._lastCheckTime = (_local_1 - 40);
            };
            if ((_local_1 - this._lastCheckTime) > FRAME_TIME_OVER_TAG)
            {
                this._frameTimeOverCount++;
            }
            else
            {
                if (this._frameTimeOverCount > 0)
                {
                    this._frameTimeOverCount = 0;
                };
            };
            this._lastCheckTime = _local_1;
            if (this._frameTimeOverCount > FRAME_OVER_COUNT_TAG)
            {
                this._isLackOfFPS = true;
            };
        }

        public function set groundScale(_arg_1:Number):void
        {
            if (this._ground)
            {
                this._ground.scaleX = (this._ground.scaleY = _arg_1);
            }
            else
            {
                this._stone.scaleX = (this._stone.scaleY = _arg_1);
            };
            this._livingLayer.scaleX = (this._livingLayer.scaleY = _arg_1);
            this._phyLayer.scaleX = (this._phyLayer.scaleY = _arg_1);
            this._mapThing.scaleX = (this._mapThing.scaleY = _arg_1);
        }

        public function get groundScale():Number
        {
            return (this._livingLayer.scaleX);
        }

        public function get isLackOfFPS():Boolean
        {
            return (this._isLackOfFPS);
        }

        public function getStoneRectangle():Rectangle
        {
            return (new Rectangle(0, 0, this._stone.width, this._stone.height));
        }

        public function getGroundRectangle():Rectangle
        {
            return (new Rectangle(0, 0, this._ground.width, this._ground.height));
        }

        public function getSkyRectangle():Rectangle
        {
            return (new Rectangle(this._sky.x, this._sky.y, this._sky.width, this._sky.height));
        }

        public function dispose():void
        {
            var _local_3:DisplayObject;
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            var _local_1:Number = numChildren;
            var _local_2:int = (_local_1 - 1);
            while (_local_2 >= 0)
            {
                _local_3 = getChildAt(_local_2);
                if ((_local_3 is Physics))
                {
                    Physics(_local_3).dispose();
                };
                _local_2--;
            };
            this._partical.dispose();
            ObjectUtils.disposeObject(this._ground);
            this._ground = null;
            ObjectUtils.disposeObject(this._stone);
            this._stone = null;
            if (this._middle)
            {
                if (this._middle.parent)
                {
                    this._middle.parent.removeChild(this._middle);
                };
                this._middle = null;
            };
            ObjectUtils.disposeObject(this._sky);
            this._sky = null;
            while (((this._livingLayer) && (this._livingLayer.numChildren > 0)))
            {
                this._livingLayer.removeChildAt(0);
            };
            ObjectUtils.disposeObject(this._livingLayer);
            this._livingLayer = null;
            while (((this._phyLayer) && (this._phyLayer.numChildren > 0)))
            {
                this._phyLayer.removeChildAt(0);
            };
            ObjectUtils.disposeObject(this._phyLayer);
            this._phyLayer = null;
            while (((this._mapThing) && (this._mapThing.numChildren > 0)))
            {
                this._mapThing.removeChildAt(0);
            };
            ObjectUtils.disposeObject(this._mapThing);
            this._mapThing = null;
            ObjectUtils.disposeObject(this._controlLayer);
            this._controlLayer = null;
            ObjectUtils.disposeAllChildren(this);
            this._phyicals = null;
            this._objects = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package phy.maps

