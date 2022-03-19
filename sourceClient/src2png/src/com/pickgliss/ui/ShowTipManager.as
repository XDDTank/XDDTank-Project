// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.ShowTipManager

package com.pickgliss.ui
{
    import flash.geom.Point;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.DisplayObjectContainer;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.Directions;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.ITransformableTipedDisplay;
    import com.pickgliss.ui.vo.DirectionPos;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.DisplayUtils;
    import __AS3__.vec.*;

    public final class ShowTipManager 
    {

        public static const StartPoint:Point = new Point(0, 0);
        private static var _instance:ShowTipManager;

        private var _currentTipObject:ITipedDisplay;
        private var _simpleTipset:Object;
        private var _tipContainer:DisplayObjectContainer;
        private var _tipedObjects:Vector.<ITipedDisplay>;
        private var _tips:Dictionary;
        private var _updateTempTarget:ITipedDisplay;

        public function ShowTipManager()
        {
            this._tips = new Dictionary();
            this._tipedObjects = new Vector.<ITipedDisplay>();
        }

        public static function get Instance():ShowTipManager
        {
            if (_instance == null)
            {
                _instance = new (ShowTipManager)();
            };
            return (_instance);
        }


        public function addTip(_arg_1:ITipedDisplay):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            this.removeTipedObject(_arg_1);
            this._tipedObjects.push(_arg_1);
            _arg_1.addEventListener(MouseEvent.ROLL_OVER, this.__onOver);
            _arg_1.addEventListener(MouseEvent.ROLL_OUT, this.__onOut);
            if (this._currentTipObject == _arg_1)
            {
                this.showTip(this._currentTipObject);
            };
        }

        public function getTipPosByDirction(_arg_1:ITip, _arg_2:ITipedDisplay, _arg_3:int):Point
        {
            var _local_4:Point = new Point();
            if (_arg_3 == Directions.DIRECTION_T)
            {
                _local_4.y = (-(_arg_1.height) - _arg_2.tipGapV);
                _local_4.x = ((_arg_2.width - _arg_1.width) / 2);
            }
            else
            {
                if (_arg_3 == Directions.DIRECTION_L)
                {
                    _local_4.x = (-(_arg_1.width) - _arg_2.tipGapH);
                    _local_4.y = ((_arg_2.height - _arg_1.height) / 2);
                }
                else
                {
                    if (_arg_3 == Directions.DIRECTION_R)
                    {
                        _local_4.x = (_arg_2.width + _arg_2.tipGapH);
                        _local_4.y = ((_arg_2.height - _arg_1.height) / 2);
                    }
                    else
                    {
                        if (_arg_3 == Directions.DIRECTION_B)
                        {
                            _local_4.y = (_arg_2.height + _arg_2.tipGapV);
                            _local_4.x = ((_arg_2.width - _arg_1.width) / 2);
                        }
                        else
                        {
                            if (_arg_3 == Directions.DIRECTION_TL)
                            {
                                _local_4.y = (-(_arg_1.height) - _arg_2.tipGapV);
                                _local_4.x = (-(_arg_1.width) - _arg_2.tipGapH);
                            }
                            else
                            {
                                if (_arg_3 == Directions.DIRECTION_TR)
                                {
                                    _local_4.y = (-(_arg_1.height) - _arg_2.tipGapV);
                                    _local_4.x = (_arg_2.width + _arg_2.tipGapH);
                                }
                                else
                                {
                                    if (_arg_3 == Directions.DIRECTION_BL)
                                    {
                                        _local_4.y = (_arg_2.height + _arg_2.tipGapV);
                                        _local_4.x = (-(_arg_1.width) - _arg_2.tipGapH);
                                    }
                                    else
                                    {
                                        if (_arg_3 == Directions.DIRECTION_BR)
                                        {
                                            _local_4.y = (_arg_2.height + _arg_2.tipGapV);
                                            _local_4.x = (_arg_2.width + _arg_2.tipGapH);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_4);
        }

        public function hideTip(_arg_1:ITipedDisplay):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:ITip = this._tips[_arg_1.tipStyle];
            if (_local_2 == null)
            {
                return;
            };
            if (this._tipContainer.contains(_local_2.asDisplayObject()))
            {
                this._tipContainer.removeChild(_local_2.asDisplayObject());
            };
            this._currentTipObject = null;
        }

        public function removeCurrentTip():void
        {
            this.hideTip(this._currentTipObject);
        }

        public function removeAllTip():void
        {
            var _local_1:ITip;
            for each (_local_1 in this._tips)
            {
                if (_local_1.asDisplayObject().parent)
                {
                    _local_1.asDisplayObject().parent.removeChild(_local_1.asDisplayObject());
                };
            };
        }

        public function removeTip(_arg_1:ITipedDisplay):void
        {
            this.removeTipedObject(_arg_1);
            if (this._currentTipObject == _arg_1)
            {
                this.hideTip(this._currentTipObject);
            };
        }

        public function setSimpleTip(_arg_1:ITipedDisplay, _arg_2:String=""):void
        {
            if (this._simpleTipset == null)
            {
                return;
            };
            if ((_arg_1 is Component))
            {
                Component(_arg_1).beginChanges();
            };
            _arg_1.tipStyle = this._simpleTipset.tipStyle;
            _arg_1.tipData = _arg_2;
            _arg_1.tipDirctions = this._simpleTipset.tipDirctions;
            _arg_1.tipGapV = this._simpleTipset.tipGapV;
            _arg_1.tipGapH = this._simpleTipset.tipGapH;
            if ((_arg_1 is Component))
            {
                Component(_arg_1).commitChanges();
            };
        }

        public function setup():void
        {
            this._tipContainer = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
        }

        public function showTip(_arg_1:*):void
        {
            var _local_2:* = this._tips[_arg_1.tipStyle];
            if ((_arg_1 is ITipedDisplay))
            {
                this.setCommonTip(_arg_1, _local_2);
                _local_2 = this._tips[_arg_1.tipStyle];
            };
            if ((_arg_1 is ITransformableTipedDisplay))
            {
                _local_2.tipWidth = _arg_1.tipWidth;
                _local_2.tipHeight = _arg_1.tipHeight;
            };
            this.configPosition(_arg_1, _local_2);
            this._currentTipObject = _arg_1;
            this._tipContainer.addChild(_local_2.asDisplayObject());
        }

        public function getTipInstanceByStylename(_arg_1:String):ITip
        {
            return (this._tips[_arg_1]);
        }

        public function updatePos():void
        {
            if ((!(this._updateTempTarget)))
            {
                return;
            };
            this.showTip(this._updateTempTarget);
        }

        private function setCommonTip(_arg_1:*, _arg_2:*):void
        {
            if (_arg_2 == null)
            {
                if (_arg_1.tipStyle == null)
                {
                    return;
                };
                _arg_2 = this.createTipByStyleName(_arg_1.tipStyle);
                if (_arg_2 == null)
                {
                    return;
                };
            };
            _arg_2.tipData = _arg_1.tipData;
        }

        public function createTipByStyleName(_arg_1:String):*
        {
            this._tips[_arg_1] = ComponentFactory.Instance.creat(_arg_1);
            return (this._tips[_arg_1]);
        }

        private function configPosition(_arg_1:*, _arg_2:*):void
        {
            var _local_3:Point = this._tipContainer.globalToLocal(_arg_1.localToGlobal(StartPoint));
            var _local_4:Point = new Point();
            var _local_5:DirectionPos = this.getTipPriorityDirction(_arg_2, _arg_1, _arg_1.tipDirctions);
            _arg_2.currentDirectionPos = _local_5;
            _local_4 = this.getTipPosByDirction(_arg_2, _arg_1, _local_5.direction);
            if (_local_5.offsetX < (int.MAX_VALUE / 2))
            {
                _arg_2.x = ((_local_4.x + _local_3.x) + _local_5.offsetX);
            }
            else
            {
                _arg_2.x = (_local_4.x + _local_3.x);
            };
            if (_local_5.offsetY < (int.MAX_VALUE / 2))
            {
                _arg_2.y = ((_local_4.y + _local_3.y) + _local_5.offsetY);
            }
            else
            {
                _arg_2.y = (_local_4.y + _local_3.y);
            };
        }

        private function __onOut(_arg_1:MouseEvent):void
        {
            var _local_2:ITipedDisplay = (_arg_1.currentTarget as ITipedDisplay);
            this.hideTip(_local_2);
            this._updateTempTarget = null;
        }

        private function __onOver(_arg_1:MouseEvent):void
        {
            var _local_2:ITipedDisplay = (_arg_1.currentTarget as ITipedDisplay);
            if (_local_2.tipStyle == null)
            {
                return;
            };
            this.showTip(_local_2);
            this._updateTempTarget = _local_2;
        }

        private function getTipPriorityDirction(_arg_1:ITip, _arg_2:ITipedDisplay, _arg_3:String):DirectionPos
        {
            var _local_5:DirectionPos;
            var _local_9:Point;
            var _local_10:Point;
            var _local_11:Point;
            var _local_12:DirectionPos;
            var _local_4:Array = _arg_3.split(",");
            var _local_6:Vector.<DirectionPos> = new Vector.<DirectionPos>();
            var _local_7:Point = this._tipContainer.globalToLocal(_arg_2.localToGlobal(StartPoint));
            var _local_8:int;
            while (_local_8 < _local_4.length)
            {
                _local_9 = this.getTipPosByDirction(_arg_1, _arg_2, _local_4[_local_8]);
                _local_10 = new Point((_local_9.x + _local_7.x), (_local_9.y + _local_7.y));
                _local_11 = new Point(((_local_9.x + _local_7.x) + _arg_1.width), ((_local_9.y + _local_7.y) + _arg_1.height));
                _local_12 = this.creatDirectionPos(_local_10, _local_11, int(_local_4[_local_8]));
                if (((_local_12.offsetX == 0) && (_local_12.offsetY == 0)))
                {
                    _local_5 = _local_12;
                    break;
                };
                _local_6.push(_local_12);
                _local_8++;
            };
            if (_local_5 == null)
            {
                _local_5 = this.searchFixedDirectionPos(_local_6);
            };
            return (_local_5);
        }

        private function searchFixedDirectionPos(_arg_1:Vector.<DirectionPos>):DirectionPos
        {
            var _local_2:DirectionPos;
            var _local_5:int;
            var _local_6:int;
            var _local_3:Vector.<DirectionPos> = _arg_1.reverse();
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                if (_local_2 == null)
                {
                    _local_2 = _local_3[_local_4];
                }
                else
                {
                    _local_5 = (Math.abs(_local_3[_local_4].offsetX) + Math.abs(_local_3[_local_4].offsetY));
                    _local_6 = (Math.abs(_local_2.offsetX) + Math.abs(_local_2.offsetY));
                    if (_local_5 <= _local_6)
                    {
                        _local_2 = _local_3[_local_4];
                    };
                };
                _local_4++;
            };
            return (_local_2);
        }

        private function creatDirectionPos(_arg_1:Point, _arg_2:Point, _arg_3:int):DirectionPos
        {
            var _local_4:DirectionPos = new DirectionPos();
            _local_4.direction = _arg_3;
            if (_arg_3 == Directions.DIRECTION_T)
            {
                if (_arg_1.y < 0)
                {
                    _local_4.offsetY = (int.MAX_VALUE / 2);
                }
                else
                {
                    _local_4.offsetY = 0;
                };
                if (_arg_1.x < 0)
                {
                    _local_4.offsetX = -(_arg_1.x);
                }
                else
                {
                    if (_arg_2.x > StageReferance.stageWidth)
                    {
                        _local_4.offsetX = (StageReferance.stageWidth - _arg_2.x);
                    }
                    else
                    {
                        _local_4.offsetX = 0;
                    };
                };
            }
            else
            {
                if (_arg_3 == Directions.DIRECTION_L)
                {
                    if (_arg_1.x < 0)
                    {
                        _local_4.offsetX = (int.MAX_VALUE / 2);
                    }
                    else
                    {
                        _local_4.offsetX = 0;
                    };
                    if (_arg_1.y < 0)
                    {
                        _local_4.offsetY = -(_arg_1.y);
                    }
                    else
                    {
                        if (_arg_2.y > StageReferance.stageHeight)
                        {
                            _local_4.offsetY = (StageReferance.stageHeight - _arg_2.y);
                        }
                        else
                        {
                            _local_4.offsetY = 0;
                        };
                    };
                }
                else
                {
                    if (_arg_3 == Directions.DIRECTION_R)
                    {
                        if (_arg_2.x > StageReferance.stageWidth)
                        {
                            _local_4.offsetX = (int.MAX_VALUE / 2);
                        }
                        else
                        {
                            _local_4.offsetX = 0;
                        };
                        if (_arg_1.y < 0)
                        {
                            _local_4.offsetY = -(_arg_1.y);
                        }
                        else
                        {
                            if (_arg_2.y > StageReferance.stageHeight)
                            {
                                _local_4.offsetY = (StageReferance.stageHeight - _arg_2.y);
                            }
                            else
                            {
                                _local_4.offsetY = 0;
                            };
                        };
                    }
                    else
                    {
                        if (_arg_3 == Directions.DIRECTION_B)
                        {
                            if (_arg_2.y > StageReferance.stageHeight)
                            {
                                _local_4.offsetY = (int.MAX_VALUE / 2);
                            }
                            else
                            {
                                _local_4.offsetY = 0;
                            };
                            if (_arg_1.x < 0)
                            {
                                _local_4.offsetX = -(_arg_1.x);
                            }
                            else
                            {
                                if (_arg_2.x > StageReferance.stageWidth)
                                {
                                    _local_4.offsetX = (StageReferance.stageWidth - _arg_2.x);
                                }
                                else
                                {
                                    _local_4.offsetX = 0;
                                };
                            };
                        }
                        else
                        {
                            if (((DisplayUtils.isInTheStage(_arg_1)) && (DisplayUtils.isInTheStage(_arg_2))))
                            {
                                _local_4.offsetX = 0;
                                _local_4.offsetY = 0;
                            }
                            else
                            {
                                _local_4.offsetY = (int.MAX_VALUE / 2);
                                _local_4.offsetX = (int.MAX_VALUE / 2);
                            };
                        };
                    };
                };
            };
            return (_local_4);
        }

        private function removeTipedObject(_arg_1:ITipedDisplay):void
        {
            var _local_2:int = this._tipedObjects.indexOf(_arg_1);
            _arg_1.removeEventListener(MouseEvent.ROLL_OVER, this.__onOver);
            _arg_1.removeEventListener(MouseEvent.ROLL_OUT, this.__onOut);
            if (_local_2 != -1)
            {
                this._tipedObjects.splice(_local_2, 1);
            };
        }


    }
}//package com.pickgliss.ui

