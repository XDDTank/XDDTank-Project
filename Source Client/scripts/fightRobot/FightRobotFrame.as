package fightRobot
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.HelpFrame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.pvpRoomList.RoomListBGView;
   
   public class FightRobotFrame extends Frame implements Disposeable
   {
       
      
      private var _titleBmp:Bitmap;
      
      private var _beginBtn:BaseButton;
      
      private var _beginBtnBg:Scale9CornerImage;
      
      private var _leftView:FightRobotLeftView;
      
      private var _rightView:FightRobotRightView;
      
      private var _teamateInfo:Vector.<FightRobotTeamateView>;
      
      private var _messageList:Vector.<FightRobotMessage>;
      
      private var _lastFightDate:Date;
      
      private var _remainFightCount:int;
      
      private var _hasClearCD:Boolean;
      
      private var _helpFrame:HelpFrame;
      
      private var _waiting:Boolean;
      
      public function FightRobotFrame()
      {
         super();
         escEnable = true;
      }
      
      private function __frameOpen(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:FightRobotTeamateView = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         this.__onClose();
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            this._remainFightCount = _loc2_.readInt();
            this._lastFightDate = _loc2_.readDate();
            this._hasClearCD = _loc2_.readBoolean();
            _loc4_ = _loc2_.readInt();
            this._teamateInfo = new Vector.<FightRobotTeamateView>();
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = new FightRobotTeamateView();
               _loc7_ = _loc2_.readUTF();
               _loc8_ = _loc2_.readUTF();
               _loc9_ = _loc2_.readUTF();
               _loc10_ = _loc2_.readInt();
               _loc11_ = _loc2_.readBoolean();
               _loc6_.setStyle(_loc7_,_loc8_,_loc9_,_loc10_,_loc11_);
               _loc6_.isVIP = _loc2_.readBoolean();
               _loc6_.nickName = _loc2_.readUTF();
               _loc6_.fightPower = _loc2_.readInt();
               this._teamateInfo.push(_loc6_);
               _loc5_++;
            }
            this.initView();
            this.initEvent();
         }
         else
         {
            this.dispose();
         }
      }
      
      private function __getHistoryMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:FightRobotMessage = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new FightRobotMessage();
            _loc5_.messageID = _loc2_.readInt();
            _loc5_.challengerID = _loc2_.readInt();
            _loc5_.challengerName = _loc2_.readUTF();
            _loc5_.defenderName = _loc2_.readUTF();
            _loc5_.fightTime = _loc2_.readDate();
            _loc5_.result = _loc2_.readByte();
            if(this._messageList.length >= 10)
            {
               this.deleteLastMessage();
            }
            this._messageList.push(_loc5_);
            this._messageList.sort(this.sortMessage);
            _loc4_++;
         }
         if(this._rightView)
         {
            this._rightView.addMessage(this._messageList);
         }
      }
      
      private function __clearCD(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Boolean = _loc2_.readBoolean();
         this._hasClearCD = _loc3_;
         if(_loc3_)
         {
            if(this._rightView)
            {
               this._rightView.setLastFightTime(TimeManager.Instance.Now(),_loc3_);
            }
         }
      }
      
      private function deleteLastMessage() : void
      {
         var _loc2_:FightRobotMessage = null;
         var _loc1_:FightRobotMessage = this._messageList[0];
         for each(_loc2_ in this._messageList)
         {
            if(_loc1_.fightTime.time > _loc2_.fightTime.time)
            {
               _loc1_ = _loc2_;
            }
         }
         this._messageList.splice(this._messageList.indexOf(_loc1_),1)[0].dispose();
      }
      
      private function sortMessage(param1:FightRobotMessage, param2:FightRobotMessage) : int
      {
         if(param1.fightTime.time < param2.fightTime.time)
         {
            return 1;
         }
         return -1;
      }
      
      private function initView() : void
      {
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.fightrobot.title");
         this._beginBtnBg = ComponentFactory.Instance.creatComponentByStylename("fightrobot.beginBtn.bg");
         this._beginBtn = ComponentFactory.Instance.creatComponentByStylename("fightrobot.beginBtn");
         this._beginBtn.tipData = LanguageMgr.GetTranslation("ddt.fightrobot.beginFightBtn.tips.txt");
         this._leftView = new FightRobotLeftView();
         PositionUtils.setPos(this._leftView,"fightrobot.leftView.pos");
         this._rightView = new FightRobotRightView();
         PositionUtils.setPos(this._rightView,"fightrobot.rightView.pos");
         this._leftView.teamateList = this._teamateInfo;
         this._rightView.addMessage(this._messageList);
         if(this._remainFightCount == 0)
         {
            this._hasClearCD = true;
         }
         this._rightView.setLastFightTime(this._lastFightDate,this._hasClearCD);
         this._rightView.setRemainFightCount(this._remainFightCount);
         addToContent(this._titleBmp);
         addToContent(this._beginBtnBg);
         addToContent(this._beginBtn);
         addToContent(this._leftView);
         addToContent(this._rightView);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
         if(param1.responseCode == FrameEvent.HELP_CLICK)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("helpFrame");
            this._helpFrame.setView(ComponentFactory.Instance.creat("fightrobot.HelpFrame.txt"));
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
            this._helpFrame.show();
         }
      }
      
      private function __helpResponseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FIGHT_ROBOT);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.FIGHT_ROBOT)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this._messageList = new Vector.<FightRobotMessage>();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_OPEN_FRAME,this.__frameOpen);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_HISTORY_MESSAGE,this.__getHistoryMessage);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTROBOT_CLEAR_CD,this.__clearCD);
            SocketManager.Instance.out.sendOpenFightRobotView();
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __onClose(param1:Event = null) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         if(param1)
         {
            this.dispose();
         }
      }
      
      private function __beginFightRobot(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._waiting)
         {
            return;
         }
         this._waiting = true;
         if(PlayerManager.Instance.checkExpedition())
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__expeditionFightRobotConfirmResponse);
         }
         else
         {
            this.doFightRobot();
         }
      }
      
      private function __expeditionFightRobotConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__expeditionFightRobotConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            this.doFightRobot();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function doFightRobot() : void
      {
         if(this._remainFightCount == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.fightCountNotEnough.txt"));
            return;
         }
         if(this._lastFightDate.time + ServerConfigManager.instance.getShadowNpcCd() * 1000 > TimeManager.Instance.Now().time && !this._hasClearCD)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fightrobot.notCoolDown.txt"));
            return;
         }
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],RoomInfo.FIGHT_ROBOT,3);
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameInSocketOut.sendGameRoomSetUp(0,RoomInfo.FIGHT_ROBOT,false,"","",3,1,0,false,RoomManager.Instance.current.ID);
      }
      
      private function __onSetupChanged(param1:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         this._waiting = false;
         SocketManager.Instance.out.sendFightRobot();
      }
      
      private function initEvent() : void
      {
         this._beginBtn.addEventListener(MouseEvent.CLICK,this.__beginFightRobot);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading,false,1);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTROBOT_OPEN_FRAME,this.__frameOpen);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTROBOT_HISTORY_MESSAGE,this.__getHistoryMessage);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTROBOT_CLEAR_CD,this.__clearCD);
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__onSetupChanged);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         if(this._beginBtn)
         {
            this._beginBtn.removeEventListener(MouseEvent.CLICK,this.__beginFightRobot);
         }
         if(this._helpFrame)
         {
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         }
      }
      
      private function __startLoading(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         StateManager.getInGame_Step_6 = true;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         GameManager.Instance.gotoRoomLoading();
         StateManager.getInGame_Step_7 = true;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleBmp);
         this._titleBmp = null;
         ObjectUtils.disposeObject(this._beginBtn);
         this._beginBtn = null;
         ObjectUtils.disposeObject(this._beginBtnBg);
         this._beginBtnBg = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
         this._teamateInfo = null;
         this._lastFightDate = null;
         this._messageList = null;
         super.dispose();
      }
   }
}
