package invite
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.InviteInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.GameManager;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   import turnplate.TurnPlateController;
   
   public class ResponseInviteFrame extends Frame
   {
      
      private static const InvitePool:DictionaryData = new DictionaryData(true);
       
      
      private var _titleBackground:Bitmap;
      
      private var _responseTitle:FilterFrameText;
      
      private var _modeLabel:Bitmap;
      
      private var _mode:ScaleFrameImage;
      
      private var _leftLabel:FilterFrameText;
      
      private var _leftField:FilterFrameText;
      
      private var _rightLabel:FilterFrameText;
      
      private var _rightField:FilterFrameText;
      
      private var _levelField:FilterFrameText;
      
      private var _levelLabel:FilterFrameText;
      
      private var _tipField:FilterFrameText;
      
      private var _doButton:TextButton;
      
      private var _cancelButton:TextButton;
      
      private var _startTime:int = 0;
      
      private var _elapsed:int = 0;
      
      private var _titleString:String;
      
      private var _timeUnit:String;
      
      private var _startupMark:Boolean = false;
      
      private var _markTime:int = 15;
      
      private var _visible:Boolean = true;
      
      private var _inviteInfo:InviteInfo;
      
      private var _resState:String;
      
      private var _timer:Timer;
      
      private var _uiReady:Boolean = false;
      
      private var _expeditionAlert:BaseAlerFrame;
      
      private var _turnplateAlert:BaseAlerFrame;
      
      public function ResponseInviteFrame()
      {
         this._titleString = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingni");
         this._timeUnit = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
         super();
         this.escEnable = true;
         this.configUi();
         this.addEvent();
         if(this._inviteInfo)
         {
            this.onUpdateData();
         }
         this._timer = new Timer(1000,this._markTime);
      }
      
      private static function removeInvite(param1:ResponseInviteFrame) : void
      {
         InvitePool.remove(String(param1.inviteInfo.playerid));
      }
      
      public static function clearInviteFrame() : void
      {
         var _loc2_:ResponseInviteFrame = null;
         var _loc1_:Array = InvitePool.list;
         while(_loc1_.length > 0)
         {
            _loc2_ = _loc1_[0];
            if(_loc2_)
            {
               ObjectUtils.disposeObject(_loc2_);
            }
         }
      }
      
      public static function newInvite(param1:InviteInfo) : ResponseInviteFrame
      {
         var _loc2_:ResponseInviteFrame = null;
         if(InvitePool[String(param1.playerid)] != null)
         {
            _loc2_ = InvitePool[String(param1.playerid)];
            _loc2_.inviteInfo = param1;
         }
         else
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ResponseInviteFrame");
            InvitePool.add(String(param1.playerid),_loc2_);
            _loc2_.inviteInfo = param1;
         }
         return _loc2_;
      }
      
      private function configUi() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._titleBackground = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
         PositionUtils.setPos(this._titleBackground,"asset.core.ResponeseInviteFrame.titleBg");
         addToContent(this._titleBackground);
         this._responseTitle = ComponentFactory.Instance.creatComponentByStylename("invite.response.TitleField");
         this._responseTitle.text = this._titleString;
         addToContent(this._responseTitle);
         this._modeLabel = ComponentFactory.Instance.creatBitmap("invite.response.ModeLabel");
         addToContent(this._modeLabel);
         this._mode = ComponentFactory.Instance.creatComponentByStylename("invite.response.GameMode");
         DisplayUtils.setFrame(this._mode,1);
         addToContent(this._mode);
         this._leftLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.MapLabel");
         this._leftLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
         addToContent(this._leftLabel);
         this._leftField = ComponentFactory.Instance.creatComponentByStylename("invite.response.MapField");
         addToContent(this._leftField);
         this._rightLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.TimeLabel");
         this._rightLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
         addToContent(this._rightLabel);
         this._rightField = ComponentFactory.Instance.creatComponentByStylename("invite.response.TimeField");
         addToContent(this._rightField);
         this._levelLabel = ComponentFactory.Instance.creatComponentByStylename("invite.response.LevelLabel");
         addToContent(this._levelLabel);
         this._levelField = ComponentFactory.Instance.creatComponentByStylename("invite.response.LevelField");
         addToContent(this._levelField);
         this._tipField = ComponentFactory.Instance.creatComponentByStylename("invite.response.TipField");
         this._tipField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.meifanying");
         addToContent(this._tipField);
         this._doButton = ComponentFactory.Instance.creatComponentByStylename("invite.response.DoButton");
         this._doButton.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._doButton);
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("invite.response.CancelButton");
         this._cancelButton.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._cancelButton);
         this._uiReady = true;
      }
      
      private function addEvent() : void
      {
         this._doButton.addEventListener(MouseEvent.CLICK,this.__onInviteAccept);
         this._cancelButton.addEventListener(MouseEvent.CLICK,this.__onCloseClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__toStage);
         addEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
         addEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
      }
      
      private function removeEvent() : void
      {
         this._doButton.removeEventListener(MouseEvent.CLICK,this.__onInviteAccept);
         this._cancelButton.removeEventListener(MouseEvent.CLICK,this.__onCloseClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__toStage);
         removeEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
         removeEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
         removeEventListener(MouseEvent.CLICK,this.__bodyClick,true);
      }
      
      public function show() : void
      {
         if(!stage)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __focusOut(param1:FocusEvent) : void
      {
         addEventListener(MouseEvent.CLICK,this.__bodyClick,true);
      }
      
      private function __bodyClick(param1:MouseEvent) : void
      {
         StageReferance.stage.focus = this;
      }
      
      private function __toStage(param1:Event) : void
      {
         var _loc2_:ResponseInviteFrame = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         if(InvitePool.length > 1)
         {
            _loc2_ = InvitePool.list[InvitePool.length - 2];
            _loc3_ = _loc2_.getBounds(stage);
            _loc4_ = ComponentFactory.Instance.creatCustomObject("invite.response.DispalyRect");
            _loc7_ = ComponentFactory.Instance.creatCustomObject("invite.response.FrameOffset");
            if(_loc3_.right + _loc7_.x >= _loc4_.right || _loc3_.bottom + _loc7_.y >= _loc4_.bottom)
            {
               x = _loc4_.x;
               y = _loc4_.y;
            }
            else
            {
               x = _loc3_.x + _loc7_.x;
               y = _loc3_.y + _loc7_.y;
            }
         }
         else
         {
            _loc3_ = getBounds(this);
            x = StageReferance.stageWidth - _loc3_.width >> 1;
            y = StageReferance.stageHeight - _loc3_.height >> 1;
         }
      }
      
      private function __focusIn(param1:FocusEvent) : void
      {
         removeEventListener(MouseEvent.CLICK,this.__bodyClick,true);
         this.bringToTop();
      }
      
      private function bringToTop() : void
      {
         if(parent)
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
      }
      
      private function __onInviteAccept(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.checkExpedition())
         {
            this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            this._expeditionAlert.moveEnable = false;
            this._expeditionAlert.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         }
         else if(TurnPlateController.Instance.isShow)
         {
            this._turnplateAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.turnplate.inviteStop.txt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            this._turnplateAlert.moveEnable = false;
            this._turnplateAlert.addEventListener(FrameEvent.RESPONSE,this.__turnplateConfirmResponse);
         }
         else
         {
            this.sendAnswer();
         }
      }
      
      private function __turnplateConfirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__turnplateConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            TurnPlateController.Instance.forcibleClose();
            this.sendAnswer();
         }
         if(param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            this.sendAnswer();
         }
         if(param1.responseCode == FrameEvent.CANCEL_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function sendAnswer() : void
      {
         GameManager.Instance.setup();
         if(this._inviteInfo.gameMode == 0)
         {
            SocketManager.Instance.out.sendGameLogin(1,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         else if(this._inviteInfo.gameMode == 4)
         {
            SocketManager.Instance.out.sendGameLogin(2,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         else if(this._inviteInfo.gameMode == 20)
         {
            SocketManager.Instance.out.sendGameLogin(2,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         else
         {
            SocketManager.Instance.out.sendGameLogin(4,-1,this._inviteInfo.roomid,this._inviteInfo.password,true);
         }
         this.close();
         clearInviteFrame();
      }
      
      private function onUpdateData() : void
      {
         var _loc1_:InviteInfo = this._inviteInfo;
         var _loc2_:int = 1;
         if(_loc1_.secondType == 1)
         {
            _loc2_ = 5;
         }
         if(_loc1_.secondType == 2)
         {
            _loc2_ = 7;
         }
         if(_loc1_.secondType == 3)
         {
            _loc2_ = 10;
         }
         if(_loc1_.secondType == 4)
         {
            _loc2_ = 15;
         }
         titleText = LanguageMgr.GetTranslation("tank.invite.response.title",_loc1_.nickname);
         if(_loc1_.isOpenBoss)
         {
            this._titleString = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.yaoqingniboss");
         }
         this._responseTitle.text = "“" + _loc1_.nickname + "”" + this._titleString;
         if(_loc1_.gameMode < 2)
         {
            DisplayUtils.setFrame(this._mode,_loc1_.gameMode + 1);
            this._rightLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
            this._rightField.text = _loc2_ + LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
            this._leftLabel.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
            this._leftField.text = String(MapManager.getMapName(_loc1_.mapid));
         }
         else if(_loc1_.gameMode == 2)
         {
            DisplayUtils.setFrame(this._mode,_loc1_.gameMode + 1);
            this._rightLabel.text = LanguageMgr.GetTranslation("tank.view.common.levelRange");
            this._rightField.text = this.getLevelLimits(_loc1_.levelLimits);
            this._leftLabel.text = LanguageMgr.GetTranslation("tank.view.common.roomLevel");
            this._leftField.text = MapManager.getRoomHardLevel(_loc1_.hardLevel);
         }
         else if(_loc1_.gameMode > 2)
         {
            if(_loc1_.gameMode == 7)
            {
               DisplayUtils.setFrame(this._mode,5);
            }
            else if(_loc1_.gameMode == RoomInfo.MULTI_DUNGEON)
            {
               DisplayUtils.setFrame(this._mode,5);
            }
            else
            {
               DisplayUtils.setFrame(this._mode,_loc1_.gameMode + 1);
            }
            if(_loc1_.gameMode == 11)
            {
               DisplayUtils.setFrame(this._mode,5);
            }
            this._leftLabel.text = LanguageMgr.GetTranslation("tank.view.common.duplicateName");
            this._leftLabel.x = PositionUtils.creatPoint("duplicatePos").x;
            this._leftField.text = String(MapManager.getMapName(_loc1_.mapid));
            this._leftField.x = PositionUtils.creatPoint("duplicateNamePos").x;
            this._rightLabel.text = LanguageMgr.GetTranslation("tank.view.common.gameLevel");
            this._rightLabel.x = this._leftField.x + this._leftField.width + 2;
            this._rightField.x = this._rightLabel.x + this._rightLabel.width;
            this._rightField.text = MapManager.getRoomHardLevel(_loc1_.hardLevel);
         }
         if(_loc1_.barrierNum == -1 || _loc1_.gameMode < 2)
         {
            this._levelLabel.visible = this._levelField.visible = false;
         }
         else
         {
            this._levelLabel.visible = this._levelField.visible = true;
            this._levelLabel.text = LanguageMgr.GetTranslation("tank.view.common.InviteAlertPanel.pass");
            this._levelField.text = String(_loc1_.barrierNum);
         }
         if(_loc1_.gameMode > 2 && (_loc1_.mapid <= 0 || _loc1_.mapid >= 10000))
         {
            this._leftField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
            this._rightField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
            this._levelField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.nochoice");
         }
         this.restartMark();
      }
      
      private function __onMark(param1:TimerEvent) : void
      {
         this._tipField.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.ruguo",this._markTime - this._timer.currentCount);
      }
      
      private function __onMarkComplete(param1:TimerEvent) : void
      {
         this.markComplete();
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
      }
      
      private function getLevelLimits(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
               _loc2_ = "1-10";
               break;
            case 2:
               _loc2_ = "11-20";
               break;
            case 3:
               _loc2_ = "20-30";
               break;
            case 4:
               _loc2_ = "30-40";
               break;
            default:
               _loc2_ = "";
         }
         return _loc2_ + LanguageMgr.GetTranslation("grade");
      }
      
      private function restartMark() : void
      {
         if(this._startupMark)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onMark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
            this._timer.stop();
         }
         this._startupMark = true;
         this._timer.addEventListener(TimerEvent.TIMER,this.__onMark);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
         this._timer.reset();
         this._timer.start();
      }
      
      private function markComplete() : void
      {
         this._startupMark = false;
         this._timer.removeEventListener(TimerEvent.TIMER,this.__onMark);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
         this.close();
      }
      
      public function close() : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      public function get inviteInfo() : InviteInfo
      {
         return this._inviteInfo;
      }
      
      public function set inviteInfo(param1:InviteInfo) : void
      {
         this._inviteInfo = param1;
         if(this._uiReady)
         {
            this.onUpdateData();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._timer.removeEventListener(TimerEvent.TIMER,this.__onMark);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMarkComplete);
         this._timer = null;
         if(this._titleBackground)
         {
            ObjectUtils.disposeObject(this._titleBackground);
            this._titleBackground = null;
         }
         if(this._responseTitle)
         {
            ObjectUtils.disposeObject(this._responseTitle);
            this._responseTitle = null;
         }
         if(this._modeLabel)
         {
            ObjectUtils.disposeObject(this._modeLabel);
            this._modeLabel = null;
         }
         if(this._mode)
         {
            ObjectUtils.disposeObject(this._mode);
            this._mode = null;
         }
         if(this._leftLabel)
         {
            ObjectUtils.disposeObject(this._leftLabel);
            this._leftLabel = null;
         }
         if(this._leftField)
         {
            ObjectUtils.disposeObject(this._leftField);
            this._leftField = null;
         }
         if(this._rightLabel)
         {
            ObjectUtils.disposeObject(this._rightLabel);
            this._rightLabel = null;
         }
         if(this._rightField)
         {
            ObjectUtils.disposeObject(this._rightField);
            this._rightField = null;
         }
         if(this._tipField)
         {
            ObjectUtils.disposeObject(this._tipField);
            this._tipField = null;
         }
         if(this._doButton)
         {
            ObjectUtils.disposeObject(this._doButton);
            this._doButton = null;
         }
         if(this._cancelButton)
         {
            ObjectUtils.disposeObject(this._cancelButton);
            this._cancelButton = null;
         }
         if(this._levelLabel)
         {
            ObjectUtils.disposeObject(this._levelLabel);
            this._levelLabel = null;
         }
         if(this._levelField)
         {
            ObjectUtils.disposeObject(this._levelLabel);
            this._levelField = null;
         }
         if(this._expeditionAlert)
         {
            this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            ObjectUtils.disposeObject(this._expeditionAlert);
            this._expeditionAlert = null;
         }
         if(this._turnplateAlert)
         {
            this._turnplateAlert.removeEventListener(FrameEvent.RESPONSE,this.__turnplateConfirmResponse);
            ObjectUtils.disposeObject(this._turnplateAlert);
            this._turnplateAlert = null;
         }
         removeInvite(this);
         super.dispose();
      }
   }
}
