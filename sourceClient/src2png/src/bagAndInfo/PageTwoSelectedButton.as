// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.PageTwoSelectedButton

package bagAndInfo
{
    import com.pickgliss.ui.controls.SelectedTextButton;
    import ddt.interfaces.IDragable;
    import ddt.interfaces.IAcceptDrag;
    import ddt.manager.SoundManager;
    import bagAndInfo.cell.DragEffect;
    import bagAndInfo.bag.BreakGoodsBtn;
    import bagAndInfo.bag.SellGoodsBtn;
    import bagAndInfo.bag.ContinueGoodsBtn;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.DragManager;

    public class PageTwoSelectedButton extends SelectedTextButton implements IDragable, IAcceptDrag 
    {


        public function dragStop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            if ((((_arg_1.source is ContinueGoodsBtn) || (_arg_1.source is SellGoodsBtn)) || (_arg_1.source is BreakGoodsBtn)))
            {
                return;
            };
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                _arg_1.action = DragEffect.NONE;
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if ((((_local_2) && (!(StateManager.currentStateType == StateType.AUCTION))) && (PlayerManager.Instance.Self.bagVibleType == 0)))
            {
                _arg_1.action = DragEffect.NONE;
                DragManager.acceptDrag(this);
            }
            else
            {
                DragManager.acceptDrag(this, DragEffect.NONE);
            };
        }

        public function getSource():IDragable
        {
            return (this);
        }


    }
}//package bagAndInfo

