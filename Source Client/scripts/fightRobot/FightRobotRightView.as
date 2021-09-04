package fightRobot
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FightRobotRightView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _leftFightCountBmp:Bitmap;
      
      private var _leftCountTxt:MovieClip;
      
      private var _coolDownTxt:MovieClip;
      
      private var _coolDownBtn:BaseButton;
      
      private var _messageVBox:VBox;
      
      private var _coolDownTime:Number;
      
      private var _coolDownBmp:Bitmap;
      
      private var _coolDownAlert:BaseAlerFrame;
      
      public function FightRobotRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.fightrobot.right.bg");
         this._leftFightCountBmp = ComponentFactory.Instance.creatBitmap("asset.fightrobot.leftFightCount.bmp");
         this._leftCountTxt = ComponentFactory.Instance.creat("asset.ddtcorei.leftCount");
         this._coolDownTxt = ComponentFactory.Instance.creat("asset.corei.coolDown");
         this._coolDownBtn = ComponentFactory.Instance.creatComponentByStylename("fightrobot.coolDownBtn");
         this._coolDownBmp = ComponentFactory.Instance.creatBitmap("asset.fightrobot.coolDownTime");
         this._messageVBox = ComponentFactory.Instance.creatComponentByStylename("fightrobot.messageVbox");
         PositionUtils.setPos(this._leftCountTxt,"fightrobot.leftCountTxt.pos");
         PositionUtils.setPos(this._coolDownTxt,"fightrobot.coolDownTxt.pos");
         this._coolDownBtn.tipData = LanguageMgr.GetTranslation("ddt.fightrobot.coolDownBtn.tips.txt",ServerConfigManager.instance.getShadowNpcClearCdPrice());
         this._coolDownBtn.enable = false;
         addChild(this._bg);
         addChild(this._leftFightCountBmp);
         addChild(this._leftCountTxt);
         addChild(this._coolDownTxt);
         addChild(this._coolDownBtn);
         addChild(this._coolDownBmp);
         addChild(this._messageVBox);
      }
      
      private function initEvent() : void
      {
         this._coolDownBtn.addEventListener(MouseEvent.CLICK,this.__coolDown);
      }
      
      private function removeEvent() : void
      {
         this._coolDownBtn.removeEventListener(MouseEvent.CLICK,this.__coolDown);
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__coolDownTimeHandler);
      }
      
      private function __coolDown(param1:Event) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!SharedManager.Instance.coolDownFightRobot)
         {
            this._coolDownAlert = ComponentFactory.Instance.creatComponentByStylename("fightRobot.coolDownConfirm") as FightRobotCoolDownConfirmFrame;
            this._coolDownAlert.addEventListener(FrameEvent.RESPONSE,this.__sendCoolDown);
            LayerManager.Instance.addToLayer(this._coolDownAlert,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            if(this._coolDownTime <= TimeManager.Instance.Now().time)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.coolDown.timeUp"));
               return;
            }
            if(PlayerManager.Instance.Self.totalMoney < ServerConfigManager.instance.getShadowNpcClearCdPrice())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
               return;
            }
            SocketManager.Instance.out.sendFightRobotCoolDown();
         }
      }
      
      private function __sendCoolDown(param1:FrameEvent) : void
      {
         this._coolDownAlert.removeEventListener(FrameEvent.RESPONSE,this.__sendCoolDown);
         this._coolDownAlert = null;
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._coolDownTime <= TimeManager.Instance.Now().time)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.coolDown.timeUp"));
                  break;
               }
               if(PlayerManager.Instance.Self.totalMoney < ServerConfigManager.instance.getShadowNpcClearCdPrice())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
                  break;
               }
               SocketManager.Instance.out.sendFightRobotCoolDown();
               break;
         }
      }
      
      public function addMessage(param1:Vector.<FightRobotMessage>) : void
      {
         var _loc2_:FightRobotMessage = null;
         ObjectUtils.removeChildAllChildren(this._messageVBox);
         for each(_loc2_ in param1)
         {
            _loc2_.buildText();
            this._messageVBox.addChild(_loc2_);
         }
      }
      
      public function setLastFightTime(param1:Date, param2:Boolean) : void
      {
         this._coolDownTime = param1.time + ServerConfigManager.instance.getShadowNpcCd() * 1000;
         if(this._coolDownTime > TimeManager.Instance.Now().time && !param2)
         {
            this._coolDownBtn.enable = true;
            this.__coolDownTimeHandler();
            TimeManager.addEventListener(TimeEvents.SECONDS,this.__coolDownTimeHandler);
         }
         else
         {
            this._coolDownBtn.enable = false;
            this.resetCoolDownTime();
         }
      }
      
      public function setRemainFightCount(param1:int) : void
      {
         if(param1 > 9 || param1 < 0)
         {
            this._leftCountTxt.num.gotoAndStop("num_0");
            return;
         }
         this._leftCountTxt.num.gotoAndStop("num_" + param1);
      }
      
      private function __coolDownTimeHandler(param1:TimeEvents = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         if(this._coolDownTime > TimeManager.Instance.Now().time)
         {
            _loc2_ = this._coolDownTime - TimeManager.Instance.Now().time;
            _loc3_ = TimeManager.Instance.getHour(_loc2_);
            _loc4_ = TimeManager.Instance.getMinute(_loc2_);
            _loc5_ = TimeManager.Instance.getSecond(_loc2_);
            _loc6_ = StringUtils.padLeft(String(int(_loc3_)),"0",2);
            this._coolDownTxt.timeHour2.gotoAndStop("num_" + _loc6_.substr(0,1));
            this._coolDownTxt.timeHour.gotoAndStop("num_" + _loc6_.substr(1,1));
            _loc7_ = StringUtils.padLeft(String(int(_loc4_)),"0",2);
            this._coolDownTxt.timeMinutes2.gotoAndStop("num_" + _loc7_.substr(0,1));
            this._coolDownTxt.timeMinutes.gotoAndStop("num_" + _loc7_.substr(1,1));
            _loc8_ = StringUtils.padLeft(String(int(_loc5_)),"0",2);
            this._coolDownTxt.timeSecond2.gotoAndStop("num_" + _loc8_.substr(0,1));
            this._coolDownTxt.timeSecond.gotoAndStop("num_" + _loc8_.substr(1,1));
         }
         else
         {
            this.resetCoolDownTime();
         }
      }
      
      private function resetCoolDownTime() : void
      {
         this._coolDownTxt.timeHour2.gotoAndStop(1);
         this._coolDownTxt.timeHour.gotoAndStop(1);
         this._coolDownTxt.timeMinutes2.gotoAndStop(1);
         this._coolDownTxt.timeMinutes.gotoAndStop(1);
         this._coolDownTxt.timeSecond2.gotoAndStop(1);
         this._coolDownTxt.timeSecond.gotoAndStop(1);
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__coolDownTimeHandler);
         this._coolDownBtn.enable = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._leftFightCountBmp);
         this._leftFightCountBmp = null;
         ObjectUtils.disposeObject(this._coolDownTxt);
         this._coolDownTxt = null;
         ObjectUtils.disposeObject(this._leftCountTxt);
         this._leftCountTxt = null;
         ObjectUtils.disposeObject(this._coolDownBtn);
         this._coolDownBtn = null;
         ObjectUtils.disposeObject(this._coolDownBmp);
         this._coolDownBmp = null;
         ObjectUtils.disposeObject(this._messageVBox);
         this._messageVBox = null;
         this._coolDownAlert = null;
      }
   }
}
