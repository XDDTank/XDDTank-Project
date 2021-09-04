package auctionHouse.view
{
   import bagAndInfo.bag.BagFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import email.manager.MailManager;
   import email.view.EmailEvent;
   import flash.events.MouseEvent;
   
   public class BagAuctionFrame extends BagFrame
   {
       
      
      public function BagAuctionFrame()
      {
         super();
         escEnable = true;
      }
      
      override protected function initView() : void
      {
         _bagView = new AuctionBagView();
         _bagView.info = PlayerManager.Instance.Self;
         _bagView.breakBtnEnable = false;
         _bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         _bagView.sellBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         _bagView.switchButtomVisible(true);
         _bagView.switchLockBtnVisible(false);
         _bagView.setClassBtnVisible = false;
         addToContent(_bagView);
         PositionUtils.setPos(_bagView,"AutionBagView.Pos");
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         super.__onCloseClick(null);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         MailManager.Instance.Model.addEventListener(EmailEvent.BAG_UPDATA,this._updata);
      }
      
      private function _updata(param1:EmailEvent) : void
      {
         _bagView.info = PlayerManager.Instance.Self;
      }
      
      override protected function onResponse(param1:int) : void
      {
         SoundManager.instance.play("008");
         switch(param1)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               dispatchEvent(new CellEvent(CellEvent.BAG_CLOSE));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         MailManager.Instance.Model.removeEventListener(EmailEvent.BAG_UPDATA,this._updata);
      }
   }
}
