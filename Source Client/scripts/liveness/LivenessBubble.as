package liveness
{
   import arena.ArenaManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.managers.ConsortionMonsterManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class LivenessBubble extends Sprite implements Disposeable
   {
      
      public static const WORLD_BOSS:uint = 1;
      
      public static const MONSTER_REFLASH:uint = 2;
      
      public static const ARENA:uint = 3;
       
      
      private var _bubbleBg:Bitmap;
      
      private var _descTxt:FilterFrameText;
      
      private var _joinBtn:TextButton;
      
      private var _btnEnable:Boolean;
      
      private var _type:uint;
      
      private var _expeditionAlert:BaseAlerFrame;
      
      private var _line:ScaleBitmapImage;
      
      public function LivenessBubble(param1:uint, param2:Boolean)
      {
         super();
         this.mouseEnabled = false;
         this._type = param1;
         this._btnEnable = param2;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bubbleBg = ComponentFactory.Instance.creatBitmap("asset.liveness.tipsBG");
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessBubbleText");
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.bubbleBtn");
         this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
         this._line = ComponentFactory.Instance.creatComponentByStylename("liveness.bubble.line");
         if(this._btnEnable)
         {
            this._joinBtn.addEventListener(MouseEvent.CLICK,this.__clickJoinBtn);
         }
         else
         {
            this.setBtnEnable(false);
         }
         addChild(this._bubbleBg);
         addChild(this._descTxt);
         addChild(this._line);
         addChild(this._joinBtn);
      }
      
      public function setBtnEnable(param1:Boolean = true) : void
      {
         this._joinBtn.enable = param1;
         if(param1)
         {
            this._joinBtn.filters = null;
         }
         else
         {
            this._joinBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function __clickJoinBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.checkExpedition())
         {
            this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            this._expeditionAlert.moveEnable = false;
            this._expeditionAlert.addEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
         }
         else
         {
            this.checkEnter();
         }
      }
      
      private function checkEnter() : void
      {
         LivenessBubbleManager.Instance.removeBubble();
         switch(this._type)
         {
            case WORLD_BOSS:
               if(WorldBossManager.Instance.isOpen)
               {
                  SocketManager.Instance.out.enterWorldBossRoom();
               }
               break;
            case MONSTER_REFLASH:
               if(ConsortionMonsterManager.Instance.ActiveState)
               {
                  SocketManager.Instance.out.SendenterConsortion(true);
               }
               break;
            case ARENA:
               if(ArenaManager.instance.open)
               {
                  ArenaManager.instance.enter();
               }
         }
      }
      
      private function __expeditionConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            this.checkEnter();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      public function setText(param1:String) : void
      {
         this._descTxt.text = param1;
      }
      
      public function show() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 13)
         {
            if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.LOGIN)
            {
               LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER);
            }
         }
      }
      
      public function hide() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         this._joinBtn.removeEventListener(MouseEvent.CLICK,this.__clickJoinBtn);
         ObjectUtils.disposeObject(this._bubbleBg);
         this._bubbleBg = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         if(this._expeditionAlert)
         {
            this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
            ObjectUtils.disposeObject(this._expeditionAlert);
            this._expeditionAlert = null;
         }
         this.hide();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
   }
}
