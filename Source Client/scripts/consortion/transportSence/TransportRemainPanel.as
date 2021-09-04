package consortion.transportSence
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TransportRemainPanel extends Sprite implements Disposeable
   {
       
      
      private var _bg:MutipleImage;
      
      private var _fontBg:MutipleImage;
      
      private var _beginBtn:IconButton;
      
      private var _confirmPanel:TransportConfirmPanel;
      
      private var _remainTxt:FilterFrameText;
      
      private var _convoyTxt:FilterFrameText;
      
      private var _hijackTxt:FilterFrameText;
      
      public function TransportRemainPanel()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:TransportCar = null;
         var _loc2_:ConsortiaPlayerInfo = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("TransportRemainPanel.BG");
         this._fontBg = ComponentFactory.Instance.creatComponentByStylename("TransportRemainPanel.FontBmp");
         this._beginBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.BtnBeginTransport");
         this._remainTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportRemainPanel.remainText");
         this._convoyTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportRemainPanel.convoyText");
         this._hijackTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportRemainPanel.hijackText");
         addChild(this._bg);
         addChild(this._fontBg);
         addChild(this._beginBtn);
         addChild(this._remainTxt);
         addChild(this._convoyTxt);
         addChild(this._hijackTxt);
         for each(_loc1_ in TransportManager.Instance.transportModel.getObjects())
         {
            if(_loc1_.info.ownerId == PlayerManager.Instance.Self.ID || _loc1_.info.guarderId == PlayerManager.Instance.Self.ID)
            {
               this._beginBtn.enable = false;
               break;
            }
         }
         _loc2_ = ConsortionModelControl.Instance.model.getConsortiaMemberInfo(PlayerManager.Instance.Self.ID);
         if(_loc2_ && _loc2_.ConvoyTimes >= _loc2_.MaxConvoyTimes)
         {
            this._beginBtn.enable = false;
         }
      }
      
      public function __updateMyInfo(param1:ConsortionEvent = null) : void
      {
         this._remainTxt.text = String(ConsortionModel.REMAIN_CONVOY_TIME);
         this._convoyTxt.text = String(ConsortionModel.REMAIN_GUARD_TIME);
         this._hijackTxt.text = String(ConsortionModel.REMAIN_HIJACK_TIME);
      }
      
      private function addEvent() : void
      {
         TransportManager.Instance.addEventListener(ConsortionEvent.TRANSPORT_CAR_BEGIN_CONVOY,this.__beginConvoy);
         TransportManager.Instance.addEventListener(ConsortionEvent.UPDATE_MY_INFO,this.__updateMyInfo);
         this._beginBtn.addEventListener(MouseEvent.CLICK,this.__showConfirmPanel);
      }
      
      private function removeEvent() : void
      {
         TransportManager.Instance.removeEventListener(ConsortionEvent.TRANSPORT_CAR_BEGIN_CONVOY,this.__beginConvoy);
         TransportManager.Instance.removeEventListener(ConsortionEvent.UPDATE_MY_INFO,this.__updateMyInfo);
         this._beginBtn.removeEventListener(MouseEvent.CLICK,this.__showConfirmPanel);
      }
      
      private function __beginConvoy(param1:ConsortionEvent) : void
      {
         this._beginBtn.enable = false;
      }
      
      private function __showConfirmPanel(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagPwdState)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.showCarryView();
         }
         else
         {
            this.showCarryView();
         }
      }
      
      private function showCarryView() : void
      {
         this._confirmPanel = ComponentFactory.Instance.creatCustomObject("ddtConsortionTransportConfirmPanel");
         this._confirmPanel.show();
      }
      
      public function setBeginBtnEnable(param1:Boolean) : void
      {
         this._beginBtn.enable = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this._bg = null;
         this._fontBg = null;
         this._beginBtn = null;
      }
   }
}
