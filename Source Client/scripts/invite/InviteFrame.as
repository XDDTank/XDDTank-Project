package invite
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import im.IMController;
   import invite.data.InvitePlayerInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import shop.view.NewShopBugleView;
   
   public class InviteFrame extends Frame
   {
      
      public static const RECENT:int = 0;
      
      public static const Brotherhood:int = 1;
      
      public static const Friend:int = 2;
      
      public static const Hall:int = 3;
       
      
      private var _visible:Boolean = true;
      
      private var _resState:String;
      
      private var _listBack:MutipleImage;
      
      private var _refreshButton:TextButton;
      
      private var _inviteButton:TextButton;
      
      private var _hbox:HBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _hallButton:SelectedButton;
      
      private var _frientButton:SelectedButton;
      
      private var _brotherhoodButton:SelectedButton;
      
      private var _recentContactBtn:SelectedButton;
      
      private var _list:ListPanel;
      
      private var _changeComplete:Boolean = false;
      
      private var _refleshCount:int = 0;
      
      private var _invitePlayerInfos:Array;
      
      public var roomType:int;
      
      private var _shopBugle:NewShopBugleView;
      
      private var _oldSelected:int;
      
      public function InviteFrame()
      {
         super();
         this.configUi();
         if(StateManager.currentStateType != StateType.DUNGEON_ROOM && StateManager.currentStateType != StateType.MISSION_ROOM)
         {
            this._inviteButton.enable = false;
         }
         this.addEvent();
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            this.refleshList(Brotherhood);
         }
         else
         {
            this.refleshList(Friend);
         }
      }
      
      private function configUi() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._listBack = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame.bg");
         addToContent(this._listBack);
         this._refreshButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.RefreshButton");
         this._refreshButton.text = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
         addToContent(this._refreshButton);
         this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.InviteButton");
         this._inviteButton.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.inviteBu");
         addToContent(this._inviteButton);
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.hbox");
         addToContent(this._hbox);
         this._btnGroup = new SelectedButtonGroup();
         this._recentContactBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.recentButton");
         this._btnGroup.addSelectItem(this._recentContactBtn);
         this._brotherhoodButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.consortiaButton");
         this._btnGroup.addSelectItem(this._brotherhoodButton);
         this._frientButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.friendButton");
         this._btnGroup.addSelectItem(this._frientButton);
         this._hallButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.HallButton");
         this._btnGroup.addSelectItem(this._hallButton);
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            this._hbox.addChild(this._recentContactBtn);
            this._hbox.addChild(this._frientButton);
            this._hbox.addChild(this._hallButton);
            this._hbox.addChild(this._brotherhoodButton);
         }
         else
         {
            this._hbox.addChild(this._recentContactBtn);
            this._hbox.addChild(this._brotherhoodButton);
            this._hbox.addChild(this._frientButton);
            this._hbox.addChild(this._hallButton);
         }
         this._list = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.List");
         addToContent(this._list);
         IMController.Instance.loadRecentContacts();
      }
      
      private function addEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__btnChangeHandler);
         this._refreshButton.addEventListener(MouseEvent.CLICK,this.__onRefreshClick);
         this._inviteButton.addEventListener(MouseEvent.CLICK,this.__onInviteClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,this.__onGetList);
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __btnChangeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._hbox.arrange();
         if(this._changeComplete)
         {
            this._changeComplete = false;
            switch(this._btnGroup.selectIndex)
            {
               case RECENT:
                  this.refleshList(RECENT);
                  break;
               case Brotherhood:
                  if(PlayerManager.Instance.Self.ConsortiaID != 0)
                  {
                     this.refleshList(Brotherhood);
                  }
                  else
                  {
                     this._changeComplete = true;
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.consortiaRateI"));
                     this._btnGroup.selectIndex = this._oldSelected;
                  }
                  break;
               case Friend:
                  this.refleshList(Friend);
                  break;
               case Hall:
                  this.refleshList(Hall);
            }
            this._oldSelected = this._btnGroup.selectIndex;
         }
      }
      
      private function __response(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.__onCloseClick(null);
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.__onRefreshClick(null);
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__btnChangeHandler);
         if(this._refreshButton)
         {
            this._refreshButton.removeEventListener(MouseEvent.CLICK,this.__onRefreshClick);
         }
         if(this._inviteButton)
         {
            this._inviteButton.removeEventListener(MouseEvent.CLICK,this.__onInviteClick);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_USERS_LIST,this.__onGetList);
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __onInviteClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         if(RoomManager.Instance.current.mapId == 0 || RoomManager.Instance.current.mapId == 10000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.noChooseDungeon"));
            return;
         }
         if(!InviteManager.Instance.canUseDungeonBugle)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.tooQuiklyToInvite"));
            return;
         }
         if(PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.DUNGEON_BUGLE) > 0)
         {
            GameInSocketOut.sendInviteDungeon();
            InviteManager.Instance.StartTimer();
         }
         else if(PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.T_BBUGLE) <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dungeonInvite.noBugles"));
            this._shopBugle = new NewShopBugleView(EquipType.T_BBUGLE);
         }
         else
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.dungeonInvite.bigBuglesAlert"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         }
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            GameInSocketOut.sendInviteDungeon();
            InviteManager.Instance.StartTimer();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __onRefreshClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._changeComplete)
         {
            if(this._btnGroup.selectIndex == Hall)
            {
               this.refleshList(Hall,++this._refleshCount);
            }
            else
            {
               this.refleshList(this._btnGroup.selectIndex);
            }
         }
      }
      
      private function __onGetList(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:PlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Array = [];
         var _loc4_:int = _loc2_.readByte();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new PlayerInfo();
            _loc6_.ID = _loc2_.readInt();
            _loc6_.NickName = _loc2_.readUTF();
            _loc6_.VIPtype = _loc2_.readByte();
            _loc6_.VIPLevel = _loc2_.readInt();
            _loc6_.Sex = _loc2_.readBoolean();
            _loc6_.Grade = _loc2_.readInt();
            _loc6_.ConsortiaID = _loc2_.readInt();
            _loc6_.ConsortiaName = _loc2_.readUTF();
            _loc6_.Offer = _loc2_.readInt();
            _loc6_.WinCount = _loc2_.readInt();
            _loc6_.TotalCount = _loc2_.readInt();
            _loc6_.EscapeCount = _loc2_.readInt();
            _loc6_.Repute = _loc2_.readInt();
            _loc6_.FightPower = _loc2_.readInt();
            _loc6_.isOld = _loc2_.readBoolean();
            _loc3_.push(_loc6_);
            _loc5_++;
         }
         this.updateList(Hall,_loc3_);
      }
      
      override protected function __onCloseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function updateList(param1:int, param2:Array) : void
      {
         var _loc3_:InvitePlayerInfo = null;
         var _loc5_:BasePlayer = null;
         var _loc6_:Array = null;
         this._changeComplete = true;
         this.clearList();
         this._invitePlayerInfos = [];
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param2[_loc4_] as BasePlayer;
            if(_loc5_.ID != PlayerManager.Instance.Self.ID)
            {
               _loc3_ = new InvitePlayerInfo();
               _loc3_.NickName = _loc5_.NickName;
               _loc3_.VIPtype = _loc5_.VIPtype;
               _loc3_.Sex = _loc5_.Sex;
               _loc3_.Grade = _loc5_.Grade;
               _loc3_.Repute = _loc5_.Repute;
               _loc3_.WinCount = _loc5_.WinCount;
               _loc3_.TotalCount = _loc5_.TotalCount;
               _loc3_.FightPower = _loc5_.FightPower;
               _loc3_.ID = _loc5_.ID;
               _loc3_.Offer = _loc5_.Offer;
               _loc3_.isOld = _loc5_.isOld;
               this._list.vectorListModel.insertElementAt(_loc3_,this.getInsertIndex(_loc5_));
               this._invitePlayerInfos.push(_loc3_);
            }
            _loc4_++;
         }
         if(param1 == Friend)
         {
            _loc6_ = this._invitePlayerInfos;
            _loc6_ = IMController.Instance.sortAcademyPlayer(_loc6_);
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(_loc6_);
         }
         this._list.list.updateListView();
      }
      
      private function clearList() : void
      {
         this._list.vectorListModel.clear();
      }
      
      private function getInsertIndex(param1:BasePlayer) : int
      {
         var _loc2_:int = 0;
         var _loc5_:PlayerInfo = null;
         var _loc3_:Array = this._list.vectorListModel.elements;
         if(_loc3_.length == 0)
         {
            return 0;
         }
         var _loc4_:int = _loc3_.length - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = _loc3_[_loc4_] as PlayerInfo;
            if(!(param1.IsVIP && !_loc5_.IsVIP))
            {
               if(!param1.IsVIP && _loc5_.IsVIP)
               {
                  return _loc4_ + 1;
               }
            }
            _loc4_--;
         }
         return _loc2_;
      }
      
      private function __onResError(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
      }
      
      private function __onResComplete(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
         if(param1.module == UIModuleTypes.DDTINVITE && this._visible)
         {
            this._resState = "complete";
            this.configUi();
            this.addEvent();
            if(PlayerManager.Instance.Self.ConsortiaID != 0)
            {
               this.refleshList(Brotherhood);
            }
            else
            {
               this.refleshList(Friend);
            }
         }
      }
      
      private function refleshList(param1:int, param2:int = 0) : void
      {
         this._btnGroup.selectIndex = param1;
         this._oldSelected = param1;
         if(param1 == Hall)
         {
            GameInSocketOut.sendGetScenePlayer(param2);
         }
         else if(param1 == Friend)
         {
            this.updateList(Friend,PlayerManager.Instance.onlineFriendList);
         }
         else if(param1 == Brotherhood)
         {
            this.updateList(Brotherhood,ConsortionModelControl.Instance.model.onlineConsortiaMemberList);
         }
         else if(param1 == RECENT)
         {
            this.updateList(RECENT,this.rerecentContactList);
         }
      }
      
      private function get rerecentContactList() : Array
      {
         var _loc3_:FriendListPlayer = null;
         var _loc5_:int = 0;
         var _loc6_:PlayerState = null;
         var _loc1_:DictionaryData = PlayerManager.Instance.recentContacts;
         var _loc2_:Array = IMController.Instance.recentContactsList;
         var _loc4_:Array = [];
         if(_loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               if(_loc2_[_loc5_] != 0)
               {
                  _loc3_ = _loc1_[_loc2_[_loc5_]];
                  if(_loc3_ && _loc4_.indexOf(_loc3_) == -1)
                  {
                     if(PlayerManager.Instance.findPlayer(_loc3_.ID,PlayerManager.Instance.Self.ZoneID))
                     {
                        _loc6_ = new PlayerState(PlayerManager.Instance.findPlayer(_loc3_.ID,PlayerManager.Instance.Self.ZoneID).playerState.StateID);
                        _loc3_.playerState = _loc6_;
                     }
                     if(_loc3_.playerState.StateID != PlayerState.OFFLINE)
                     {
                        _loc4_.push(_loc3_);
                     }
                  }
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      override public function dispose() : void
      {
         this._visible = false;
         if(this._resState == "loading")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onResError);
         }
         else
         {
            this.removeEvent();
            if(this._list)
            {
               ObjectUtils.disposeObject(this._list);
               this._list = null;
            }
            if(this._hbox)
            {
               ObjectUtils.disposeObject(this._hbox);
               this._hbox = null;
            }
            if(this._brotherhoodButton)
            {
               ObjectUtils.disposeObject(this._brotherhoodButton);
               this._brotherhoodButton = null;
            }
            if(this._frientButton)
            {
               ObjectUtils.disposeObject(this._frientButton);
               this._frientButton = null;
            }
            if(this._hallButton)
            {
               ObjectUtils.disposeObject(this._hallButton);
               this._hallButton = null;
            }
            if(this._refreshButton)
            {
               ObjectUtils.disposeObject(this._refreshButton);
               this._refreshButton = null;
            }
            if(this._inviteButton)
            {
               ObjectUtils.disposeObject(this._inviteButton);
            }
            if(this._listBack)
            {
               ObjectUtils.disposeObject(this._listBack);
               this._listBack = null;
            }
            if(this._recentContactBtn)
            {
               ObjectUtils.disposeObject(this._recentContactBtn);
               this._recentContactBtn = null;
            }
         }
         super.dispose();
      }
   }
}
