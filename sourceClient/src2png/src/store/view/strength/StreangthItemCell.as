// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StreangthItemCell

package store.view.strength
{
    import store.StoreCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ItemManager;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import ddt.manager.DragManager;
    import ddt.data.StoneType;
    import ddt.data.goods.EquipmentTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;
    import bagAndInfo.cell.CellContentCreator;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.events.Event;

    public class StreangthItemCell extends StoreCell 
    {

        private var _stoneType:String = "";
        private var _actionState:Boolean;

        public function StreangthItemCell(_arg_1:int)
        {
            var _local_2:Sprite = new Sprite();
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
            _local_2.addChild(_local_3);
            super(_local_2, _arg_1);
            setContentSize(68, 68);
            this.PicPos = new Point(15, 27);
        }

        public function set stoneType(_arg_1:String):void
        {
            this._stoneType = _arg_1;
        }

        public function set actionState(_arg_1:Boolean):void
        {
            this._actionState = _arg_1;
        }

        public function get actionState():Boolean
        {
            return (this._actionState);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.getRemainDate() <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                }
                else
                {
                    if (((_local_2.CanStrengthen) && (this.isAdaptToStone(_local_2))))
                    {
                        if (_local_2.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_local_2.TemplateID))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                            return;
                        };
                        SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, index, 1);
                        this._actionState = true;
                        _arg_1.action = DragEffect.NONE;
                        DragManager.acceptDrag(this);
                        this.reset();
                    }
                    else
                    {
                        if ((!(this.isAdaptToStone(_local_2))))
                        {
                        };
                    };
                };
            };
        }

        private function isAdaptToStone(_arg_1:InventoryItemInfo):Boolean
        {
            if (this._stoneType == "")
            {
                return (true);
            };
            if (((this._stoneType == StoneType.STRENGTH) && (_arg_1.RefineryLevel <= 0)))
            {
                return (true);
            };
            if (((this._stoneType == StoneType.STRENGTH_1) && (_arg_1.RefineryLevel > 0)))
            {
                return (true);
            };
            return (false);
        }

        private function reset():void
        {
            this._stoneType = "";
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            if (((_info == _arg_1) && (!(_info))))
            {
                return;
            };
            if (_info)
            {
                clearCreatingContent();
                ObjectUtils.disposeObject(_pic);
                _pic = null;
                clearLoading();
                _tipData = null;
                locked = false;
            };
            _info = _arg_1;
            if (_info)
            {
                if (_showLoading)
                {
                    createLoading();
                };
                _pic = new CellContentCreator();
                _pic.info = _info;
                _pic.loadSync(createContentComplete);
                addChild(_pic);
                tipStyle = "ddtstore.StrengthTips";
                _tipData = new ItemTemplateInfo();
                _tipData = info;
            };
            updateCount();
            checkOverDate();
            if ((_info is InventoryItemInfo))
            {
                this.locked = this._info["lock"];
            };
            if (_info == null)
            {
                _local_2 = null;
                this.seteuipQualityBg(0);
            };
            if (_info != null)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_info.TemplateID);
            };
            if (((!(_local_2 == null)) && (_info.Property8 == "0")))
            {
                this.seteuipQualityBg(_local_2.QualityID);
            }
            else
            {
                this.seteuipQualityBg(0);
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        override public function seteuipQualityBg(_arg_1:int):void
        {
            if (_euipQualityBg == null)
            {
                _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            };
            _euipQualityBg.width = 68;
            _euipQualityBg.height = 68;
            _euipQualityBg.x = 13;
            _euipQualityBg.y = 25;
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

        override public function dispose():void
        {
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

