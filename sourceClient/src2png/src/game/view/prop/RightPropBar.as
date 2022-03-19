// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.RightPropBar

package game.view.prop
{
    import flash.geom.Point;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import game.model.LocalPlayer;
    import ddt.data.FightPropMode;
    import com.greensock.TweenLite;
    import ddt.data.PropInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.EquipType;
    import ddt.manager.SharedManager;
    import ddt.manager.ItemManager;
    import ddt.data.BuffInfo;
    import ddt.manager.SavePointManager;
    import ddt.events.GameEvent;
    import trainer.data.ArrowType;
    import trainer.view.NewHandContainer;
    import ddt.manager.SoundManager;
    import ddt.data.UsePropErrorCode;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import ddt.events.LivingEvent;
    import ddt.events.SharedEvent;
    import flash.events.Event;
    import ddt.manager.DragManager;
    import ddt.manager.InGameCursor;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import com.pickgliss.ui.ComponentFactory;
    import org.aswing.KeyboardManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.DisplayUtils;
    import ddt.utils.PositionUtils;

    public class RightPropBar extends FightPropBar 
    {

        private var _startPos:Point;
        private var _buttonPos1:Point;
        private var _buttonPos2:Point;
        private var _mouseHolded:Boolean = false;
        private var _elasped:int = 0;
        private var _last:int = 0;
        private var _container:DisplayObjectContainer;
        private var _localVisible:Boolean = true;
        private var _tweenComplete:Boolean = true;
        private var _backgroundShort:DisplayObject;
        private var _propBarShowType:Boolean = false;
        private var cell:PropCell;
        private var _tempPlace:int;

        public function RightPropBar(_arg_1:LocalPlayer, _arg_2:DisplayObjectContainer)
        {
            this._container = _arg_2;
            super(_arg_1);
            this.setItems();
        }

        public function setup(_arg_1:DisplayObjectContainer):void
        {
            this._container = _arg_1;
            this._container.addChild(this);
            if (_mode == FightPropMode.VERTICAL)
            {
                x = _background.width;
                TweenLite.to(this, 0.3, {"x":0});
            }
            else
            {
                y = 102;
                TweenLite.to(this, 0.3, {"y":0});
            };
        }

        private function setItems():void
        {
            var _local_4:String;
            var _local_5:PropInfo;
            var _local_6:Array;
            var _local_7:InventoryItemInfo;
            var _local_1:Boolean;
            var _local_2:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP, true, true);
            var _local_3:Object = SharedManager.Instance.GameKeySets;
            for (_local_4 in _local_3)
            {
                _local_5 = new PropInfo(ItemManager.Instance.getTemplateById(_local_3[_local_4]));
                if (((_local_2) || (PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))))
                {
                    if (_local_2)
                    {
                        _local_5.Place = _local_2.Place;
                    }
                    else
                    {
                        _local_5.Place = -1;
                    };
                    _local_5.Count = -1;
                    _cells[(int(_local_4) - 1)].info = _local_5;
                    _local_1 = true;
                }
                else
                {
                    _local_6 = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_local_3[_local_4]);
                    if (_local_6.length > 0)
                    {
                        _local_5.Place = _local_6[0].Place;
                        for each (_local_7 in _local_6)
                        {
                            _local_5.Count = (_local_5.Count + _local_7.Count);
                        };
                        _cells[(int(_local_4) - 1)].info = _local_5;
                        _local_1 = true;
                    }
                    else
                    {
                        _cells[(int(_local_4) - 1)].info = _local_5;
                    };
                };
            };
            if (_local_1)
            {
                this.updatePropByEnergy();
            };
        }

        override protected function updatePropByEnergy():void
        {
            var _local_1:PropCell;
            var _local_2:PropInfo;
            for each (_local_1 in _cells)
            {
                if (_local_1.info)
                {
                    _local_2 = _local_1.info;
                    if (_local_2)
                    {
                        if (((_local_1.shortcutKey == "4") && (this.propBarShowType == false)))
                        {
                            if (((_self.energy > 0) && (_self.energy >= this.getLestEnergy())))
                            {
                                _local_1.enabled = true;
                            }
                            else
                            {
                                _local_1.enabled = false;
                            };
                        }
                        else
                        {
                            if (((_self.energy < _local_2.needEnergy) || (_self.energy <= 0)))
                            {
                                _local_1.enabled = false;
                                this.clearArrowByProp(_local_2, false, true);
                            }
                            else
                            {
                                if (((!(_self.twoKillEnabled)) && (((_local_1.info.TemplateID == EquipType.ADD_TWO_ATTACK) || (_local_1.info.TemplateID == EquipType.ADD_ONE_ATTACK)) || (_local_1.info.TemplateID == EquipType.THREEKILL))))
                                {
                                    _local_1.enabled = false;
                                }
                                else
                                {
                                    if (_local_1.info.TemplateID == EquipType.THREEKILL)
                                    {
                                        _local_1.enabled = _self.threeKillEnabled;
                                    }
                                    else
                                    {
                                        _local_1.enabled = true;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function getLestEnergy():Number
        {
            var _local_1:Number = 10000;
            var _local_2:int = 3;
            while (_local_2 < 8)
            {
                _local_1 = ((_local_1 > _cells[_local_2]["info"]["needEnergy"]) ? _cells[_local_2]["info"]["needEnergy"] : _local_1);
                _local_2++;
            };
            return (_local_1);
        }

        private function clearArrowByProp(_arg_1:PropInfo, _arg_2:Boolean=true, _arg_3:Boolean=false):void
        {
            switch (_arg_1.TemplateID)
            {
                case 10002:
                    if (SavePointManager.Instance.isInSavePoint(10))
                    {
                        dispatchEvent(new GameEvent(GameEvent.USE_ADDONE));
                    };
                    this.clearArr(ArrowType.TIP_ONE);
                    this.clearArr(ArrowType.TIP_THREE);
                    return;
                case 10003:
                    if (SavePointManager.Instance.isInSavePoint(10))
                    {
                        dispatchEvent(new GameEvent(GameEvent.USE_THREE));
                    };
                    this.clearArr(ArrowType.TIP_THREE);
                    return;
                case 10008:
                    return;
            };
        }

        private function clearArr(_arg_1:int):void
        {
            if (NewHandContainer.Instance.hasArrow(_arg_1))
            {
                NewHandContainer.Instance.clearArrowByID(_arg_1);
            };
        }

        override protected function __itemClicked(_arg_1:MouseEvent):void
        {
            var _local_2:PropCell;
            var _local_3:String;
            if ((!(this._localVisible)))
            {
                return;
            };
            if (_enabled)
            {
                if (_self.isUsedPetSkillWithNoItem)
                {
                    return;
                };
                _self.isUsedItem = true;
                _local_2 = (_arg_1.currentTarget as PropCell);
                if (((_local_2.shortcutKey == "4") && (this.propBarShowType == false)))
                {
                    this.oneKeyClick();
                }
                else
                {
                    if ((!(_local_2.enabled)))
                    {
                        return;
                    };
                    SoundManager.instance.play("008");
                    _self.deputyWeaponEnabled = false;
                    _local_3 = _self.useProp(_local_2.info, 0);
                    if (((!(_local_3 == UsePropErrorCode.Done)) && (!(_local_3 == UsePropErrorCode.None))))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(("tank.game.prop." + _local_3)));
                    }
                    else
                    {
                        if (_local_3 == UsePropErrorCode.Done)
                        {
                            this.clearArrowByProp(_local_2.info);
                        };
                    };
                };
                super.__itemClicked(_arg_1);
                StageReferance.stage.focus = null;
            };
        }

        private function oneKeyClick():void
        {
            var _local_2:String;
            if ((!(_cells[3].localVisible)))
            {
                return;
            };
            var _local_1:int = 3;
            while (_local_1 < 8)
            {
                do 
                {
                    _local_2 = _self.useProp(_cells[_local_1].info, 0);
                    if (_local_2 == UsePropErrorCode.NotAttacking)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(("tank.game.prop." + _local_2)));
                        return;
                    };
                } while (_local_2 != UsePropErrorCode.EmptyEnergy);
                _local_1++;
            };
        }

        override protected function addEvent():void
        {
            _self.addEventListener(LivingEvent.THREEKILL_CHANGED, this.__threeKillChanged);
            _self.addEventListener(LivingEvent.RIGHTENABLED_CHANGED, this.__rightEnabledChanged);
            _self.addEventListener(LivingEvent.SHOOT, this.__shoot);
            _self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
            _self.addEventListener(LocalPlayer.SET_ENABLE, this.__setEnable);
            SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED, this.__transparentChanged);
            _button.addEventListener(MouseEvent.CLICK, this.__propBarButton);
            super.addEvent();
        }

        private function __setEnable(_arg_1:Event):void
        {
            var _local_2:PropCell;
            for each (_local_2 in _cells)
            {
                if (_local_2.info)
                {
                    if (_local_2.info.TemplateID == EquipType.ADD_TWO_ATTACK)
                    {
                        _local_2.enabled = false;
                    };
                    if (_local_2.info.TemplateID == EquipType.THREEKILL)
                    {
                        _local_2.enabled = false;
                    };
                    if (_local_2.info.TemplateID == EquipType.ADD_ONE_ATTACK)
                    {
                        _local_2.enabled = false;
                    };
                };
            };
        }

        private function __propBarButton(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.propBarShowType = (!(this.propBarShowType));
            SharedManager.Instance.rightPropBarType = this.propBarShowType;
            SharedManager.Instance.save();
            this.updatePropByEnergy();
        }

        protected function __transparentChanged(_arg_1:Event):void
        {
            if (((this._tweenComplete) && (parent)))
            {
                if (SharedManager.Instance.propTransparent)
                {
                    alpha = 0.5;
                }
                else
                {
                    alpha = 1;
                };
            };
        }

        private function __attackingChanged(_arg_1:LivingEvent):void
        {
            if (((_self.isAttacking) && (this._localVisible)))
            {
                TweenLite.killTweensOf(this);
                this._container.addChild(this);
                if (_mode == FightPropMode.VERTICAL)
                {
                    alpha = 1;
                    x = _background.width;
                    if (SharedManager.Instance.propTransparent)
                    {
                        TweenLite.to(this, 0.3, {
                            "x":0,
                            "alpha":0.5,
                            "onComplete":this.showComplete
                        });
                    }
                    else
                    {
                        TweenLite.to(this, 0.3, {
                            "x":0,
                            "alpha":1,
                            "onComplete":this.showComplete
                        });
                    };
                    this._tweenComplete = false;
                }
                else
                {
                    if (SharedManager.Instance.propTransparent)
                    {
                        alpha = 0.5;
                    }
                    else
                    {
                        alpha = 1;
                    };
                    x = 0;
                    TweenLite.to(this, 0.3, {"x":0});
                };
            }
            else
            {
                if ((!(_self.isAttacking)))
                {
                    if (PlayerManager.Instance.Self.Grade > 15)
                    {
                        if (parent)
                        {
                            this.hide();
                        };
                    };
                };
            };
        }

        private function showComplete():void
        {
            this._tweenComplete = true;
        }

        private function hide():void
        {
            if ((((((SavePointManager.Instance.isInSavePoint(4)) || (SavePointManager.Instance.isInSavePoint(6))) || (SavePointManager.Instance.isInSavePoint(7))) || (SavePointManager.Instance.isInSavePoint(12))) || (SavePointManager.Instance.isInSavePoint(19))))
            {
                return;
            };
            TweenLite.killTweensOf(this.cell);
            DragManager.__upDrag(null);
            InGameCursor.show();
            this._tweenComplete = false;
            TweenLite.to(this, 0.3, {
                "alpha":0,
                "onComplete":this.hideComplete
            });
        }

        private function hideComplete():void
        {
            this._tweenComplete = true;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function __shoot(_arg_1:LivingEvent):void
        {
            if (PlayerManager.Instance.Self.Grade > 15)
            {
                if (parent)
                {
                    TweenLite.killTweensOf(this, true);
                    this.hide();
                };
            };
        }

        override protected function __enabledChanged(_arg_1:LivingEvent):void
        {
            enabled = ((_self.propEnabled) && (_self.rightPropEnabled));
        }

        private function __rightEnabledChanged(_arg_1:LivingEvent):void
        {
            enabled = ((_self.propEnabled) && (_self.rightPropEnabled));
        }

        private function __threeKillChanged(_arg_1:LivingEvent):void
        {
            var _local_2:PropCell;
            for each (_local_2 in _cells)
            {
                if (_local_2.info)
                {
                    if (_local_2.info.TemplateID == EquipType.THREEKILL)
                    {
                        _local_2.enabled = _self.threeKillEnabled;
                    };
                };
            };
        }

        override protected function __keyDown(_arg_1:KeyboardEvent):void
        {
            if ((!(_enabled)))
            {
                return;
            };
            if ((!(this.visible)))
            {
                return;
            };
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_1.getCode():
                case KeyStroke.VK_NUMPAD_1.getCode():
                    _cells[0].useProp();
                    break;
                case KeyStroke.VK_2.getCode():
                case KeyStroke.VK_NUMPAD_2.getCode():
                    _cells[1].useProp();
                    break;
                case KeyStroke.VK_3.getCode():
                case KeyStroke.VK_NUMPAD_3.getCode():
                    _cells[2].useProp();
                    break;
                case KeyStroke.VK_4.getCode():
                case KeyStroke.VK_NUMPAD_4.getCode():
                    if (this.propBarShowType)
                    {
                        _cells[3].useProp();
                    }
                    else
                    {
                        this.oneKeyClick();
                    };
                    break;
                case KeyStroke.VK_5.getCode():
                case KeyStroke.VK_NUMPAD_5.getCode():
                    if (this.propBarShowType)
                    {
                        _cells[4].useProp();
                    };
                    break;
                case KeyStroke.VK_6.getCode():
                case KeyStroke.VK_NUMPAD_6.getCode():
                    if (this.propBarShowType)
                    {
                        _cells[5].useProp();
                    };
                    break;
                case KeyStroke.VK_7.getCode():
                case KeyStroke.VK_NUMPAD_7.getCode():
                    if (this.propBarShowType)
                    {
                        _cells[6].useProp();
                    };
                    break;
                case KeyStroke.VK_8.getCode():
                case KeyStroke.VK_NUMPAD_8.getCode():
                    if (this.propBarShowType)
                    {
                        _cells[7].useProp();
                    };
                    break;
            };
            if (SavePointManager.Instance.isInSavePoint(19))
            {
                SavePointManager.Instance.setSavePoint(90);
            };
        }

        override protected function configUI():void
        {
            _background = ComponentFactory.Instance.creatComponentByStylename("RightPropBack");
            _background.visible = false;
            addChild(_background);
            this._backgroundShort = ComponentFactory.Instance.creatComponentByStylename("RightPropBackShort");
            addChild(this._backgroundShort);
            _button = ComponentFactory.Instance.creatComponentByStylename("asset.game.rightProp.arrowBtn");
            addChild(_button);
            this._startPos = ComponentFactory.Instance.creatCustomObject(("RightPropPos" + _mode));
            this._buttonPos1 = ComponentFactory.Instance.creatCustomObject("RightPropButtonPos1");
            this._buttonPos2 = ComponentFactory.Instance.creatCustomObject("RightPropButtonPos2");
            super.configUI();
        }

        override protected function drawCells():void
        {
            var _local_2:PropCell;
            var _local_1:int;
            while (_local_1 < 8)
            {
                _local_2 = new PropCell(String((_local_1 + 1)), _mode);
                _local_2.addEventListener(MouseEvent.CLICK, this.__itemClicked);
                _local_2.addEventListener(MouseEvent.MOUSE_DOWN, this.__DownItemHandler);
                addChild(_local_2);
                _cells.push(_local_2);
                _local_1++;
            };
            this.propBarShowType = SharedManager.Instance.rightPropBarType;
        }

        private function __DownItemHandler(_arg_1:MouseEvent):void
        {
            this.cell = (_arg_1.currentTarget as PropCell);
            this._tempPlace = (_cells.indexOf(this.cell) + 1);
            this._container.addEventListener(MouseEvent.MOUSE_UP, this.__UpItemHandler);
            TweenLite.to(this.cell, 0.5, {"onComplete":this.OnCellComplete});
        }

        private function OnCellComplete():void
        {
            KeyboardManager.getInstance().isStopDispatching = true;
            this.cell.dragStart();
        }

        private function __UpItemHandler(_arg_1:MouseEvent):void
        {
            TweenLite.killTweensOf(this.cell);
            KeyboardManager.getInstance().isStopDispatching = false;
            this._container.removeEventListener(MouseEvent.MOUSE_UP, this.__UpItemHandler);
        }

        override public function dispose():void
        {
            if (_background)
            {
                ObjectUtils.disposeObject(_background);
                _background = null;
            };
            if (this._backgroundShort)
            {
                ObjectUtils.disposeObject(this._backgroundShort);
                this._backgroundShort = null;
            };
            super.dispose();
        }

        override protected function removeEvent():void
        {
            var _local_1:PropCell;
            for each (_local_1 in _cells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__itemClicked);
            };
            _self.removeEventListener(LivingEvent.THREEKILL_CHANGED, this.__threeKillChanged);
            _self.removeEventListener(LivingEvent.RIGHTENABLED_CHANGED, this.__rightEnabledChanged);
            _self.removeEventListener(LivingEvent.SHOOT, this.__shoot);
            _self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__attackingChanged);
            _self.removeEventListener(LocalPlayer.SET_ENABLE, this.__setEnable);
            SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED, this.__transparentChanged);
            _button.removeEventListener(MouseEvent.CLICK, this.__propBarButton);
            super.removeEvent();
        }

        public function get propBarShowType():Boolean
        {
            return (this._propBarShowType);
        }

        public function set propBarShowType(_arg_1:Boolean):void
        {
            this._propBarShowType = _arg_1;
            _cells[3].cellType = _arg_1;
            this.drawLayer();
            _background.visible = _arg_1;
            this._backgroundShort.visible = (!(_arg_1));
        }

        override protected function drawLayer():void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_1:int = _cells.length;
            if (this._propBarShowType == false)
            {
                _button.rotation = 0;
                _button.x = (this._startPos.x + 5);
                _button.y = ((this._startPos.y + 6) + (4 * (36 + 3)));
            }
            else
            {
                _button.rotation = (_button.rotation + 180);
                _button.x = ((this._startPos.x + 5) + _button.width);
                _button.y = (((this._startPos.y + 6) + (8 * (36 + 3))) + _button.height);
            };
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                if (_mode == FightPropMode.VERTICAL)
                {
                    _local_3 = (this._startPos.x + 5);
                    _local_4 = ((this._startPos.y + 6) + (_local_2 * (36 + 3)));
                }
                else
                {
                    _local_3 = ((this._startPos.x + 6) + (_local_2 * (36 + 3)));
                    _local_4 = (this._startPos.y + 5);
                };
                _cells[_local_2].setPossiton(_local_3, _local_4);
                _cells[_local_2].setMode(_mode);
                if (_inited)
                {
                    TweenLite.to(_cells[_local_2], (0.05 * (_local_1 - _local_2)), {
                        "x":_local_3,
                        "y":_local_4
                    });
                }
                else
                {
                    _cells[_local_2].x = _local_3;
                    _cells[_local_2].y = _local_4;
                };
                if (((this.propBarShowType == false) && (_local_2 > 3)))
                {
                    _cells[_local_2].visible = false;
                }
                else
                {
                    if (((_local_2 > 3) && (_cells[_local_2].visible == false)))
                    {
                        _cells[_local_2].visible = true;
                    };
                };
                _local_2++;
            };
            DisplayUtils.setFrame(_background, _mode);
            PositionUtils.setPos(_background, this._startPos);
            DisplayUtils.setFrame(this._backgroundShort, _mode);
            PositionUtils.setPos(this._backgroundShort, this._startPos);
        }

        override public function enter():void
        {
            super.enter();
        }

        public function get mode():int
        {
            return (_mode);
        }

        public function setPropVisible(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PropCell;
            if (_arg_1 < _cells.length)
            {
                _cells[_arg_1].setVisible(_arg_2);
                if (_arg_2)
                {
                    if ((!(_cells[_arg_1].parent)))
                    {
                        addChild(_cells[_arg_1]);
                    };
                }
                else
                {
                    if (_cells[_arg_1].parent)
                    {
                        _cells[_arg_1].parent.removeChild(_cells[_arg_1]);
                    };
                };
            };
            for each (_local_3 in _cells)
            {
                if (_local_3.localVisible)
                {
                    this.setVisible(true);
                    return;
                };
            };
            this.setVisible(false);
        }

        public function setBackGroundVisible(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                if (this._propBarShowType)
                {
                    _background.visible = true;
                }
                else
                {
                    _background.visible = false;
                };
            }
            else
            {
                _background.visible = false;
            };
            this._backgroundShort.visible = _arg_1;
        }

        public function setArrowVisible(_arg_1:Boolean):void
        {
            _button.visible = _arg_1;
        }

        public function setVisible(_arg_1:Boolean):void
        {
            if (this._localVisible != _arg_1)
            {
                this._localVisible = _arg_1;
                if (this._localVisible)
                {
                    if (((_self.isAttacking) && (parent == null)))
                    {
                        this._container.addChild(this);
                    };
                }
                else
                {
                    if (parent)
                    {
                        parent.removeChild(this);
                    };
                };
            };
        }

        public function hidePropBar():void
        {
            this.visible = false;
        }


    }
}//package game.view.prop

