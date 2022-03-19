// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.storeBag.StoreBagbgbmp

package store.view.storeBag
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;
    import ddt.interfaces.IDragable;
    import com.pickgliss.utils.ObjectUtils;

    public class StoreBagbgbmp extends Sprite implements IBagDrag, Disposeable 
    {

        private var bg:Image;

        public function StoreBagbgbmp()
        {
            this.bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagViewBg");
            addChild(this.bg);
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_2:InventoryItemInfo;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                return;
            };
            if ((_arg_1.data is InventoryItemInfo))
            {
                _local_2 = (_arg_1.data as InventoryItemInfo);
                _arg_1.action = DragEffect.NONE;
                DragManager.acceptDrag(this);
            };
        }

        public function dragStop(_arg_1:DragEffect):void
        {
        }

        public function getSource():IDragable
        {
            return (this);
        }

        public function dispose():void
        {
            if (this.bg)
            {
                ObjectUtils.disposeObject(this.bg);
            };
            this.bg = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.storeBag

