package bagAndInfo
{
   import bagAndInfo.bag.BreakGoodsBtn;
   import bagAndInfo.bag.ContinueGoodsBtn;
   import bagAndInfo.bag.SellGoodsBtn;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   
   public class PageTwoSelectedButton extends SelectedTextButton implements IDragable, IAcceptDrag
   {
       
      
      public function PageTwoSelectedButton()
      {
         super();
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         if(param1.source is ContinueGoodsBtn || param1.source is SellGoodsBtn || param1.source is BreakGoodsBtn)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && StateManager.currentStateType != StateType.AUCTION && PlayerManager.Instance.Self.bagVibleType == 0)
         {
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
         else
         {
            DragManager.acceptDrag(this,DragEffect.NONE);
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
   }
}
