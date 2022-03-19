// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.transfer.TransferItemCell

package store.view.transfer
{
    import store.StoreCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.ItemManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import ddt.manager.DragManager;

    public class TransferItemCell extends StoreCell 
    {

        private var _categoryID:Number = 40;
        private var _templateType:int = -1;
        private var _isComposeStrength:Boolean;
        private var _refinery:int = -1;

        public function TransferItemCell(_arg_1:int)
        {
            var _local_2:Sprite = new Sprite();
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
            _local_2.addChild(_local_3);
            super(_local_2, _arg_1);
            setContentSize(68, 68);
            this._isComposeStrength = false;
            PicPos = new Point(-3, 1);
        }

        public function set Refinery(_arg_1:int):void
        {
            this._refinery = _arg_1;
        }

        public function get Refinery():int
        {
            return (this._refinery);
        }

        public function set isComposeStrength(_arg_1:Boolean):void
        {
            this._isComposeStrength = _arg_1;
        }

        public function set categoryId(_arg_1:Number):void
        {
            this._categoryID = _arg_1;
        }

        public function set TemplateType(_arg_1:int):void
        {
            this._templateType = _arg_1;
        }

        private function checkComposeStrengthen():Boolean
        {
            if (itemInfo.StrengthenLevel > 0)
            {
                return (true);
            };
            if (itemInfo.AttackCompose > 0)
            {
                return (true);
            };
            if (itemInfo.DefendCompose > 0)
            {
                return (true);
            };
            if (itemInfo.LuckCompose > 0)
            {
                return (true);
            };
            if (itemInfo.AgilityCompose > 0)
            {
                return (true);
            };
            return (false);
        }

        public function set index(_arg_1:int):void
        {
            _index = _arg_1;
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:EquipmentTemplateInfo;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (this._isComposeStrength)
                {
                    if ((!(this.checkComposeStrengthen())))
                    {
                        return;
                    };
                };
                if (this._categoryID > 0)
                {
                    _local_3 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                    if (((!(_local_3.TemplateType == this._templateType)) && (!(this._templateType == -1))))
                    {
                        if (_local_2.CanEquip == false)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
                            return;
                        };
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                        return;
                    };
                };
                if (_local_2.CanEquip)
                {
                    SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, index, 1);
                    DragManager.acceptDrag(this, DragEffect.NONE);
                    return;
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.current"));
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
}//package store.view.transfer

