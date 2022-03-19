// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.split.SplitItemCell

package store.view.split
{
    import store.StoreCell;
    import store.view.StoneCellFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.geom.Point;
    import flash.display.Sprite;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.EquipType;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.MessageTipManager;
    import ddt.manager.ItemManager;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import ddt.manager.DragManager;
    import com.pickgliss.utils.ObjectUtils;

    public class SplitItemCell extends StoreCell 
    {

        public static const CONTENTSIZE:int = 77;
        public static const PICPOS:int = 25;

        private var _cellBg:StoneCellFrame = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIISplitBG.EquipmentCell");

        public function SplitItemCell(_arg_1:int)
        {
            this._cellBg.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
            super(this._cellBg, _arg_1);
            setContentSize(CONTENTSIZE, CONTENTSIZE);
            PicPos = new Point(PICPOS, PICPOS);
        }

        override protected function updateSize(_arg_1:Sprite):void
        {
            if (_arg_1)
            {
                _arg_1.width = (_contentWidth - 18);
                _arg_1.height = (_contentHeight - 18);
                if (_picPos != null)
                {
                    _arg_1.x = _picPos.x;
                }
                else
                {
                    _arg_1.x = (Math.abs((_arg_1.width - _contentWidth)) / 2);
                };
                if (_picPos != null)
                {
                    _arg_1.y = _picPos.y;
                }
                else
                {
                    _arg_1.y = (Math.abs((_arg_1.height - _contentHeight)) / 2);
                };
            };
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (_local_2.CategoryID != EquipType.EQUIP)
            {
                return;
            };
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (_local_2.getRemainDate() <= 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                }
                else
                {
                    if ((!(ItemManager.Instance.getSpliteInfoByID(_local_2.TemplateID))))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.cannotCompose"));
                    }
                    else
                    {
                        SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, index, _local_2.Count, true);
                        _arg_1.action = DragEffect.NONE;
                        DragManager.acceptDrag(this);
                    };
                };
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._cellBg)
            {
                ObjectUtils.disposeObject(this._cellBg);
            };
            this._cellBg = null;
        }


    }
}//package store.view.split

