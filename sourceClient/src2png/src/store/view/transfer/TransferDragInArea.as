// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.transfer.TransferDragInArea

package store.view.transfer
{
    import flash.display.Sprite;
    import ddt.interfaces.IAcceptDrag;
    import __AS3__.vec.Vector;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.ItemManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.DragManager;

    public class TransferDragInArea extends Sprite implements IAcceptDrag 
    {

        public static const RECTWIDTH:int = 345;
        public static const RECTHEIGHT:int = 360;

        private var _cells:Vector.<TransferItemCell>;

        public function TransferDragInArea(_arg_1:Vector.<TransferItemCell>)
        {
            this._cells = _arg_1;
            graphics.beginFill(0xFF, 0);
            graphics.drawRect(0, 0, RECTWIDTH, RECTHEIGHT);
            graphics.endFill();
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:Boolean;
            var _local_4:EquipmentTemplateInfo;
            var _local_5:EquipmentTemplateInfo;
            var _local_6:EquipmentTemplateInfo;
            var _local_7:EquipmentTemplateInfo;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                _local_3 = false;
                if (this._cells[0].info == null)
                {
                    if (this._cells[1].info)
                    {
                        _local_4 = ItemManager.Instance.getEquipTemplateById(_arg_1.data.TemplateID);
                        _local_5 = ItemManager.Instance.getEquipTemplateById(this._cells[1].info.TemplateID);
                        if (_local_4.TemplateType != _local_5.TemplateType)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                            DragManager.acceptDrag(this);
                            return;
                        };
                    };
                    this._cells[0].dragDrop(_arg_1);
                }
                else
                {
                    if (this._cells[1].info == null)
                    {
                        if (this._cells[0])
                        {
                            _local_6 = ItemManager.Instance.getEquipTemplateById(_arg_1.data.TemplateID);
                            _local_7 = ItemManager.Instance.getEquipTemplateById(this._cells[0].info.TemplateID);
                            if (_local_7.TemplateType != _local_6.TemplateType)
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                                DragManager.acceptDrag(this);
                                return;
                            };
                        };
                        this._cells[1].dragDrop(_arg_1);
                    }
                    else
                    {
                        _local_3 = true;
                    };
                };
                if (_arg_1.target == null)
                {
                    if ((!(_local_3)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.info"));
                    };
                    DragManager.acceptDrag(this);
                };
            };
        }

        public function dispose():void
        {
            this._cells = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.transfer

