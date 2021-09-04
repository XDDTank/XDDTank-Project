package bagAndInfo.cell
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   
   public class AuctionBagCell extends LockBagCell
   {
       
      
      private var _mouseOverEffBoolean:Boolean;
      
      public function AuctionBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,null,true,ComponentFactory.Instance.creatComponentByStylename("core.bagAndInfo.bagCellBgAsset"),true);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            param1.action = DragEffect.NONE;
            if(param1.action == DragEffect.NONE)
            {
               locked = false;
            }
            return;
         }
         param1.action = DragEffect.NONE;
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         if(param1.action == DragEffect.NONE || param1.target == null)
         {
            locked = false;
         }
      }
   }
}
