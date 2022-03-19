// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.PersonalInfoCell

package bagAndInfo.cell
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.manager.DragManager;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import ddt.events.CellEvent;
    import ddt.data.goods.EquipmentTemplateInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.data.BagInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import bagAndInfo.info.PlayerViewState;
    import ddt.manager.SocketManager;
    import ddt.utils.PositionUtils;
    import ddt.data.EquipType;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class PersonalInfoCell extends BagCell 
    {

        private var _shineObject:MovieClip;

        public function PersonalInfoCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true)
        {
            super(_arg_1, _arg_2, _arg_3);
            _bg.visible = false;
            _picPos = new Point(2, 1);
            this.initEvents();
        }

        private function initEvents():void
        {
            addEventListener(InteractiveEvent.CLICK, this.onClick);
            addEventListener(InteractiveEvent.DOUBLE_CLICK, this.onDoubleClick);
            DoubleClickManager.Instance.enableDoubleClick(this);
        }

        private function removeEvents():void
        {
            removeEventListener(InteractiveEvent.CLICK, this.onClick);
            removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.onDoubleClick);
            DoubleClickManager.Instance.disableDoubleClick(this);
        }

        override public function dragStart():void
        {
            if (((((_info) && (!(locked))) && (stage)) && (allowDrag)))
            {
                if (DragManager.startDrag(this, _info, createDragImg(), stage.mouseX, stage.mouseY, DragEffect.MOVE))
                {
                    SoundManager.instance.play("008");
                    locked = true;
                };
            };
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        override protected function onMouseClick(_arg_1:MouseEvent):void
        {
        }

        protected function onClick(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK, this));
        }

        protected function onDoubleClick(_arg_1:InteractiveEvent):void
        {
            SoundManager.instance.playButtonSound();
            if (info)
            {
                dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, this));
            };
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:EquipmentTemplateInfo;
            var _local_4:BaseAlerFrame;
            var _local_5:int;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                _arg_1.action = DragEffect.NONE;
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (_local_2)
            {
                _local_3 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    return;
                };
                if (((_local_2.Place < 29) && (!(_local_2.BagType == BagInfo.PROPBAG))))
                {
                    return;
                };
                if (_local_3)
                {
                    if (_local_2.NeedLevel > PlayerManager.Instance.Self.Grade)
                    {
                        DragManager.acceptDrag(this, DragEffect.NONE);
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
                        return;
                    };
                };
                if (((((_local_2.BindType == 1) || (_local_2.BindType == 2)) || (_local_2.BindType == 3)) && (_local_2.IsBinds == false)))
                {
                    _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                    _local_4.addEventListener(FrameEvent.RESPONSE, this.__onBindResponse);
                    temInfo = _local_2;
                    DragManager.acceptDrag(this, DragEffect.NONE);
                    return;
                };
                if (PlayerManager.Instance.Self.canEquip(_local_2))
                {
                    if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
                    {
                        if (this.getCellIndex(_local_2).indexOf(place) != -1)
                        {
                            _local_5 = place;
                        }
                        else
                        {
                            _local_5 = PlayerManager.Instance.getDressEquipPlace(_local_2);
                        };
                    }
                    else
                    {
                        if (this.getEquipCellIndex(_local_2).indexOf(place) != -1)
                        {
                            _local_5 = place;
                        }
                        else
                        {
                            _local_5 = PlayerManager.Instance.getEquipPlace(_local_2);
                        };
                    };
                    SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_2.Place, BagInfo.EQUIPBAG, _local_5, _local_2.Count);
                    DragManager.acceptDrag(this, DragEffect.MOVE);
                }
                else
                {
                    DragManager.acceptDrag(this, DragEffect.NONE);
                };
            };
        }

        override protected function createLoading():void
        {
            super.createLoading();
            PositionUtils.setPos(_loadingasset, "ddt.personalInfocell.loadingPos");
        }

        override public function checkOverDate():void
        {
            if (_bgOverDate)
            {
                _bgOverDate.visible = false;
            };
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.sendDefy();
            };
        }

        private function __onBindResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.sendBindDefy();
            };
        }

        private function sendDefy():void
        {
            var _local_1:int;
            if (PlayerManager.Instance.Self.canEquip(temInfo))
            {
                _local_1 = PlayerManager.Instance.getDressEquipPlace(temInfo);
                SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, temInfo.Place, BagInfo.EQUIPBAG, _local_1);
            };
        }

        private function sendBindDefy():void
        {
            if (PlayerManager.Instance.Self.canEquip(temInfo))
            {
                SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, temInfo.Place, BagInfo.EQUIPBAG, _place, temInfo.Count);
            };
        }

        private function getCellIndex(_arg_1:ItemTemplateInfo):Array
        {
            if (EquipType.isWeddingRing(_arg_1))
            {
                return ([6]);
            };
            switch (_arg_1.CategoryID)
            {
                case EquipType.HEAD:
                    return ([2]);
                case EquipType.GLASS:
                    return ([8]);
                case EquipType.HAIR:
                    return ([4]);
                case EquipType.EFF:
                    return ([3]);
                case EquipType.CLOTH:
                    return ([0]);
                case EquipType.FACE:
                    return ([1]);
                case EquipType.SUITS:
                    return ([5]);
                case EquipType.WING:
                    return ([7]);
                case EquipType.CHATBALL:
                    return ([9]);
                default:
                    return ([-1]);
            };
        }

        override public function seteuipQualityBg(_arg_1:int):void
        {
            if (_euipQualityBg == null)
            {
                _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.View");
                _euipQualityBg.width = 43;
                _euipQualityBg.height = 42;
                _euipQualityBg.x = 1;
                _euipQualityBg.y = 1;
            };
            if (_arg_1 == 0)
            {
                _euipQualityBg.visible = false;
            }
            else
            {
                if (_arg_1 == 1)
                {
                    addChildAt(_euipQualityBg, 1);
                    _euipQualityBg.setFrame(_arg_1);
                    _euipQualityBg.visible = true;
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        addChildAt(_euipQualityBg, 1);
                        _euipQualityBg.setFrame(_arg_1);
                        _euipQualityBg.visible = true;
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            addChildAt(_euipQualityBg, 1);
                            _euipQualityBg.setFrame(_arg_1);
                            _euipQualityBg.visible = true;
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                addChildAt(_euipQualityBg, 1);
                                _euipQualityBg.setFrame(_arg_1);
                                _euipQualityBg.visible = true;
                            }
                            else
                            {
                                if (_arg_1 == 5)
                                {
                                    addChildAt(_euipQualityBg, 1);
                                    _euipQualityBg.setFrame(_arg_1);
                                    _euipQualityBg.visible = true;
                                };
                            };
                        };
                    };
                };
            };
        }

        private function getEquipCellIndex(_arg_1:ItemTemplateInfo):Array
        {
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            switch (_local_2.TemplateType)
            {
                case 1:
                    return ([10]);
                case 2:
                    return ([11]);
                case 3:
                    return ([12]);
                case 4:
                    return ([13]);
                case 5:
                    return ([14]);
                case 6:
                    return ([15]);
                case 7:
                    return ([16]);
                case 8:
                    return ([17]);
                case 9:
                    return ([18]);
                case 10:
                    return ([19]);
                case 11:
                    return ([20]);
                case 12:
                    return ([21]);
                case 13:
                    return ([22]);
                case 14:
                    return ([23]);
                default:
                    return ([-1]);
            };
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                _arg_1.action = DragEffect.NONE;
                super.dragStop(_arg_1);
            };
            locked = false;
            dispatchEvent(new CellEvent(CellEvent.DRAGSTOP, null, true));
        }

        public function shine():void
        {
            if (this._shineObject == null)
            {
                this._shineObject = (ComponentFactory.Instance.creatCustomObject("asset.core.playerInfoCellShine") as MovieClip);
            };
            addChild(this._shineObject);
            this._shineObject.gotoAndPlay(1);
        }

        public function stopShine():void
        {
            if (((!(this._shineObject == null)) && (this.contains(this._shineObject))))
            {
                removeChild(this._shineObject);
            };
            if (this._shineObject != null)
            {
                this._shineObject.gotoAndStop(1);
            };
        }

        override public function updateCount():void
        {
            if (_tbxCount)
            {
                if ((((_info) && (itemInfo)) && (itemInfo.Count > 1)))
                {
                    _tbxCount.text = String(itemInfo.Count);
                    _tbxCount.visible = true;
                    addChild(_tbxCount);
                }
                else
                {
                    _tbxCount.visible = false;
                };
            };
        }

        override public function dispose():void
        {
            this.removeEvents();
            if (this._shineObject != null)
            {
                ObjectUtils.disposeObject(this._shineObject);
            };
            this._shineObject = null;
            if (_euipQualityBg)
            {
                ObjectUtils.disposeObject(_euipQualityBg);
            };
            _euipQualityBg = null;
            super.dispose();
        }


    }
}//package bagAndInfo.cell

