package SingleDungeon.view
{
   import SingleDungeon.model.MapSceneModel;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class CDView extends Sprite implements Disposeable
   {
       
      
      private var _CDbg:ScaleBitmapImage;
      
      private var _CDtimerText:FilterFrameText;
      
      private var _CDFFButton:BaseButton;
      
      private var intervalID:uint;
      
      private var _timerDown:int = 0;
      
      private var _info:MapSceneModel;
      
      private var _alertFrame:BaseAlerFrame;
      
      public function CDView(param1:MapSceneModel)
      {
         super();
         this._info = param1;
         this._timerDown = this._info.cdColling;
      }
      
      public function showCD() : void
      {
         this._CDbg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.CDBG");
         this._CDtimerText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.CDtimerText");
         this._CDFFButton = ComponentFactory.Instance.creatComponentByStylename("singledungeon.CDFFButton");
         this.addChild(this._CDbg);
         this.addChild(this._CDtimerText);
         this.addChild(this._CDFFButton);
         this._CDtimerText.text = this._timerDown.toString();
         this._CDFFButton.addEventListener(MouseEvent.CLICK,this.__CDFFClick);
         this.intervalID = setInterval(this.updateCD,1000);
         this.updateTime(this._timerDown);
      }
      
      private function updateCD() : void
      {
         --this._timerDown;
         this.updateTime(this._timerDown);
         if(this._timerDown == 0)
         {
            this._info.cdColling = 0;
            clearInterval(this.intervalID);
            this.dispose();
         }
      }
      
      private function updateTime(param1:int) : void
      {
         var _loc2_:int = param1;
         var _loc3_:int = _loc2_ / 60 / 60;
         var _loc4_:int = _loc2_ / 60;
         var _loc5_:int = _loc2_ % 60;
         var _loc6_:String = "";
         if(_loc3_ < 10)
         {
            _loc6_ += "0" + _loc3_;
         }
         else
         {
            _loc6_ += _loc3_;
         }
         _loc6_ += ":";
         if(_loc4_ < 10)
         {
            _loc6_ += "0" + _loc4_;
         }
         else
         {
            _loc6_ += _loc4_;
         }
         _loc6_ += ":";
         if(_loc5_ < 10)
         {
            _loc6_ += "0" + _loc5_;
         }
         else
         {
            _loc6_ += _loc5_;
         }
         this._CDtimerText.text = _loc6_;
      }
      
      private function __CDFFClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc2_.data = LanguageMgr.GetTranslation("singleDungeon.bissionView.immedEnterFrame",this._info.CoolMoney);
         _loc2_.enableHtml = true;
         _loc2_.moveEnable = false;
         this._alertFrame = AlertManager.Instance.alert("SimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
         this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__frameResponse);
      }
      
      private function __frameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.totalMoney < Number(this._info.CoolMoney))
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendEnterRemoveCD(this._info.ID);
            }
         }
         this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse);
         this._alertFrame.dispose();
      }
      
      public function dispose() : void
      {
         clearInterval(this.intervalID);
         ObjectUtils.disposeObject(this._CDbg);
         this._CDbg = null;
         ObjectUtils.disposeObject(this._CDtimerText);
         this._CDtimerText = null;
         ObjectUtils.disposeObject(this._CDFFButton);
         this._CDFFButton = null;
         ObjectUtils.disposeObject(this._alertFrame);
         this._alertFrame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
