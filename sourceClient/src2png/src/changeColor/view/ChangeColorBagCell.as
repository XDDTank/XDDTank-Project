// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.view.ChangeColorBagCell

package changeColor.view
{
    import bagAndInfo.cell.BagCell;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.Sprite;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;

    public class ChangeColorBagCell extends BagCell 
    {

        public function ChangeColorBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:Sprite=null)
        {
            super(_arg_1, _arg_2, _arg_3, ((_arg_4) ? _arg_4 : ComponentFactory.Instance.creatComponentByStylename("core.bagAndInfo.bagCellBgAsset")));
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_2:InventoryItemInfo;
            if ((_arg_1.data is InventoryItemInfo))
            {
                _local_2 = (_arg_1.data as InventoryItemInfo);
                if (locked)
                {
                    if (_local_2 == this.info)
                    {
                        this.locked = false;
                        DragManager.acceptDrag(this);
                    }
                    else
                    {
                        DragManager.acceptDrag(this, DragEffect.NONE);
                    };
                }
                else
                {
                    _arg_1.action = DragEffect.NONE;
                    DragManager.acceptDrag(this);
                };
            };
        }


    }
}//package changeColor.view

