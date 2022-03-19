// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StrengthDragInArea

package store.view.strength
{
    import store.StoreDragInArea;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.DragManager;
    import ddt.data.StoneType;

    public class StrengthDragInArea extends StoreDragInArea 
    {

        private var _hasStone:Boolean = false;
        private var _hasItem:Boolean = false;
        private var _stonePlace:int = -1;
        private var _effect:DragEffect;

        public function StrengthDragInArea(_arg_1:Array)
        {
            super(_arg_1);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:int;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            this._effect = _arg_1;
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.getRemainDate() <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                    DragManager.acceptDrag(this);
                }
                else
                {
                    _local_3 = 0;
                    while (_local_3 < 5)
                    {
                        if ((((_local_3 == 0) || (_local_3 == 3)) || (_local_3 == 4)))
                        {
                            if (_cells[_local_3].itemInfo != null)
                            {
                                this._hasStone = true;
                                this._stonePlace = _local_3;
                                break;
                            };
                        };
                        _local_3++;
                    };
                    if (_cells[2].itemInfo != null)
                    {
                        this._hasItem = true;
                    };
                    if (_local_2.CanEquip)
                    {
                        if ((!(this._hasStone)))
                        {
                            _cells[2].dragDrop(_arg_1);
                        }
                        else
                        {
                            if ((((_local_2.RefineryLevel > 0) && (_cells[this._stonePlace].itemInfo.Property1 == "35")) || ((_local_2.RefineryLevel == 0) && (_cells[this._stonePlace].itemInfo.Property1 == StoneType.STRENGTH))))
                            {
                                _cells[2].dragDrop(_arg_1);
                                this.reset();
                            }
                            else
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
                            };
                        };
                    }
                    else
                    {
                        if ((((_cells[2].itemInfo.RefineryLevel > 0) && (_local_2.Property1 == "35")) || ((_cells[2].itemInfo.RefineryLevel == 0) && (_local_2.Property1 == StoneType.STRENGTH))))
                        {
                            if ((!(this._hasStone)))
                            {
                                this.findCellAndDrop();
                                this.reset();
                            }
                            else
                            {
                                if (_cells[this._stonePlace].itemInfo.Property1 == _local_2.Property1)
                                {
                                    this.findCellAndDrop();
                                    this.reset();
                                }
                                else
                                {
                                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                                };
                            };
                        }
                        else
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
                        };
                    };
                };
            };
        }

        private function findCellAndDrop():void
        {
            var _local_1:int;
            while (_local_1 < 5)
            {
                if ((((_local_1 == 0) || (_local_1 == 3)) || (_local_1 == 4)))
                {
                    if (_cells[_local_1].itemInfo == null)
                    {
                        _cells[_local_1].dragDrop(this._effect);
                        this.reset();
                        return;
                    };
                };
                _local_1++;
            };
            _cells[0].dragDrop(this._effect);
            this.reset();
        }

        private function reset():void
        {
            this._hasStone = false;
            this._hasItem = false;
            this._stonePlace = -1;
            this._effect = null;
        }

        override public function dispose():void
        {
            this.reset();
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

