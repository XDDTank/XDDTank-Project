package ddt.manager
{
   import baglocked.BaglockedManager;
   import com.pickgliss.debug.DebugStats;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.ePackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.utils.ChatHelper;
   import ddt.utils.Helpers;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.ChatModel;
   import ddt.view.chat.ChatOutputView;
   import ddt.view.chat.ChatView;
   import ddt.view.chat.chat_system;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   import game.GameManager;
   import im.IMController;
   import road7th.comm.PackageIn;
   import road7th.comm.PackageOut;
   import road7th.data.DictionaryData;
   import road7th.utils.StringHelper;
   import room.RoomManager;
   import shop.view.NewShopBugleView;
   import turnplate.TurnPlateController;
   
   use namespace chat_system;
   
   public final class ChatManager extends EventDispatcher
   {
      
      public static const CHAT_HALL_STATE:int = 0;
      
      public static const CHAT_GAME_STATE:int = 1;
      
      public static const CHAT_WEDDINGLIST_STATE:int = 3;
      
      public static const CHAT_WEDDINGROOM_STATE:int = 4;
      
      public static const CHAT_ROOM_STATE:int = 5;
      
      public static const CHAT_ROOMLIST_STATE:int = 6;
      
      public static const CHAT_DUNGEONLIST_STATE:int = 7;
      
      public static const CHAT_GAMEOVER_STATE:int = 8;
      
      public static const CHAT_GAME_LOADING:int = 9;
      
      public static const CHAT_DUNGEON_STATE:int = 10;
      
      public static const CHAT_CONSORTIA_VIEW:int = 12;
      
      public static const CHAT_CONSORTIA_TRANSPORT_VIEW:int = 13;
      
      public static const CHAT_CIVIL_VIEW:int = 14;
      
      public static const CHAT_TOFFLIST_VIEW:int = 15;
      
      public static const CHAT_SHOP_STATE:int = 16;
      
      public static const CHAT_HOTSPRING_VIEW:int = 17;
      
      public static const CHAT_HOTSPRING_ROOM_VIEW:int = 18;
      
      public static const CHAT_HOTSPRING_ROOM_GOLD_VIEW:int = 19;
      
      public static const CHAT_TRAINER_STATE:int = 20;
      
      public static const CHAT_GAMEOVER_TROPHY:int = 21;
      
      public static const CHAT_TRAINER_ROOM_LOADING:int = 22;
      
      public static const CHAT_LITTLEHALL:int = 26;
      
      public static const CHAT_LITTLEGAME:int = 24;
      
      public static const CHAT_FARM:int = 27;
      
      public static const CHAT_ARENA:int = 29;
      
      public static const CHAT_MULTI_SHOOT_GAME_STATE:int = 30;
      
      public static const CHAT_FIGHT_LIB:int = 23;
      
      public static const CHAT_ACADEMY_VIEW:int = 25;
      
      private static const CHAT_LEVEL:int = 1;
      
      public static const CHAT_WORLDBOS_ROOM:int = 28;
      
      public static var SHIELD_NOTICE:Boolean = false;
      
      private static var _instance:ChatManager;
       
      
      private var _shopBugle:NewShopBugleView;
      
      public var chatDisabled:Boolean = false;
      
      private var _chatView:ChatView;
      
      private var _model:ChatModel;
      
      private var _state:int = -1;
      
      private var _visibleSwitchEnable:Boolean = false;
      
      private var _focusFuncEnabled:Boolean = true;
      
      private var fpsContainer:DebugStats;
      
      private var _firstsetup:Boolean = true;
      
      private var _outputState:Boolean = false;
      
      private var _reportMsg:String = "";
      
      public function ChatManager()
      {
         super();
      }
      
      public static function get Instance() : ChatManager
      {
         if(_instance == null)
         {
            _instance = new ChatManager();
         }
         return _instance;
      }
      
      public function chat(param1:ChatData, param2:Boolean = true) : void
      {
         if(StateManager.currentStateType != StateType.SINGLEDUNGEON)
         {
            if(this.chatDisabled)
            {
               return;
            }
         }
         if(param2)
         {
            ChatFormats.formatChatStyle(param1);
         }
         param1.htmlMessage = Helpers.deCodeString(param1.htmlMessage);
         this._model.addChat(param1);
      }
      
      public function get isInGame() : Boolean
      {
         if(StateManager.currentStateType == StateType.SINGLEDUNGEON)
         {
            return false;
         }
         return this.output.isInGame();
      }
      
      public function set focusFuncEnabled(param1:Boolean) : void
      {
         this._focusFuncEnabled = param1;
      }
      
      public function get focusFuncEnabled() : Boolean
      {
         return this._focusFuncEnabled;
      }
      
      public function get input() : ChatInputView
      {
         return this._chatView.input;
      }
      
      public function set inputChannel(param1:int) : void
      {
         this._chatView.input.channel = param1;
      }
      
      public function get lock() : Boolean
      {
         return this._chatView.output.isLock;
      }
      
      public function set lock(param1:Boolean) : void
      {
         this._chatView.output.isLock = param1;
      }
      
      public function get model() : ChatModel
      {
         return this._model;
      }
      
      public function get output() : ChatOutputView
      {
         return this._chatView.output;
      }
      
      public function set outputChannel(param1:int) : void
      {
         this._chatView.output.channel = param1;
      }
      
      public function privateChatTo(param1:String, param2:int = 0, param3:Object = null) : void
      {
         this._chatView.input.setPrivateChatTo(param1,param2,param3);
      }
      
      public function sendBugle(param1:String, param2:int) : void
      {
         if(PlayerManager.Instance.Self.bagPwdState && PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this.input.setInputText(param1);
            return;
         }
         if(param2 == EquipType.T_BBUGLE)
         {
            if(PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.T_BBUGLE,true) <= 0 && PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.T_CBUGLE,true) <= 0)
            {
               this.showShopBugleView(param1,param2);
            }
            else
            {
               this.confirmSendMsg(param1,param2);
            }
         }
         else if(PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(param2,true) <= 0)
         {
            this.showShopBugleView(param1,param2);
         }
         else
         {
            this.confirmSendMsg(param1,param2);
         }
      }
      
      private function showShopBugleView(param1:String, param2:int) : void
      {
         if(ShopManager.Instance.getMoneyShopItemByTemplateID(param2))
         {
            this.input.setInputText(param1);
         }
         this.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.ChatManager.tool"));
         if(!this._shopBugle || !this._shopBugle.info)
         {
            this._shopBugle = new NewShopBugleView(param2);
         }
         else if(this._shopBugle.type != param2)
         {
            this._shopBugle.dispose();
            this._shopBugle = null;
            this._shopBugle = new NewShopBugleView(param2);
         }
      }
      
      private function confirmSendMsg(param1:String, param2:int) : void
      {
         param1 = Helpers.enCodeString(param1);
         if(param2 == EquipType.T_SBUGLE)
         {
            SocketManager.Instance.out.sendSBugle(param1);
         }
         else if(param2 == EquipType.T_BBUGLE)
         {
            SocketManager.Instance.out.sendCBugle(param1);
         }
         else if(param2 == EquipType.T_CBUGLE)
         {
            SocketManager.Instance.out.sendCBugle(param1);
         }
      }
      
      public function sendChat(param1:ChatData) : void
      {
         if(param1.msg == "showDebugStatus -fps")
         {
            if(!this.fpsContainer)
            {
               this.fpsContainer = new DebugStats();
               LayerManager.Instance.addToLayer(this.fpsContainer,LayerManager.STAGE_TOP_LAYER);
            }
            else
            {
               if(this.fpsContainer.parent)
               {
                  this.fpsContainer.parent.removeChild(this.fpsContainer);
               }
               this.fpsContainer = null;
            }
            return;
         }
         if(this.chatDisabled)
         {
            return;
         }
         if(param1.channel == ChatInputView.PRIVATE)
         {
            this.sendPrivateMessage(param1.receiver,param1.msg,param1.receiverID);
         }
         else if(param1.channel == ChatInputView.CROSS_BUGLE)
         {
            this.sendBugle(param1.msg,EquipType.T_BBUGLE);
         }
         else if(param1.channel == ChatInputView.BIG_BUGLE)
         {
            this.sendBugle(param1.msg,EquipType.T_BBUGLE);
         }
         else if(param1.channel == ChatInputView.SMALL_BUGLE)
         {
            this.sendBugle(param1.msg,EquipType.T_SBUGLE);
         }
         else if(param1.channel == ChatInputView.CONSORTIA)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
            dispatchEvent(new ChatEvent(ChatEvent.SEND_CONSORTIA));
         }
         else if(param1.channel == ChatInputView.TEAM)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,true);
         }
         else if(param1.channel == ChatInputView.CURRENT)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.CHURCH_CHAT)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.HOTSPRING_ROOM)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.WORLDBOSS_ROOM)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
         else if(param1.channel == ChatInputView.CONSORTIA_VIEW)
         {
            this.sendMessage(param1.channel,param1.sender,param1.msg,false);
         }
      }
      
      public function sendFace(param1:int) : void
      {
         SocketManager.Instance.out.sendFace(param1);
      }
      
      public function setFocus() : void
      {
         this._chatView.input.inputField.setFocus();
      }
      
      public function releaseFocus() : void
      {
         StageReferance.stage.focus = StageReferance.stage;
      }
      
      public function setup() : void
      {
         if(this._firstsetup)
         {
            if(this._chatView)
            {
               throw new ErrorEvent("ChatManager setup Error :",false,false,"");
            }
            this.initView();
            this.initEvent();
            this._firstsetup = false;
         }
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         if(this._state == param1 && this._state != ChatManager.CHAT_WORLDBOS_ROOM && this._state != ChatManager.CHAT_CONSORTIA_VIEW)
         {
            return;
         }
         this._state = param1;
         this._chatView.state = this._state;
      }
      
      public function switchVisible() : void
      {
         if(this._visibleSwitchEnable)
         {
            if(this._chatView.input.parent)
            {
               this._chatView.input.parent.removeChild(this._chatView.input);
               this._chatView.output.functionEnabled = false;
               this._chatView.input.fastReplyPanel.isEditing = false;
               StageReferance.stage.focus = null;
               if(!this._chatView.lockSlide && this._outputState)
               {
                  this._outputState = false;
                  this._chatView.currentType = false;
               }
            }
            else
            {
               this._chatView.addChild(this.input);
               this._chatView.output.functionEnabled = true;
               this._chatView.input.inputField.setFocus();
               if(!this._chatView.lockSlide && this._chatView.currentType == false)
               {
                  this._outputState = true;
                  this._chatView.currentType = true;
               }
            }
         }
         this._chatView.input.hidePanel();
      }
      
      public function setViewVisible(param1:Boolean) : void
      {
         if(this._chatView.canSlide && !this._chatView.lockSlide)
         {
            this._chatView.currentType = param1;
         }
      }
      
      public function sysChatRed(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = ChatInputView.SYS_NOTICE;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function sysChatYellow(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = ChatInputView.SYS_TIP;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function sysChatLinkYellow(param1:String) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.type = ChatFormats.CLICK_EFFORT;
         _loc2_.channel = ChatInputView.SYS_TIP;
         _loc2_.msg = StringHelper.trim(param1);
         this.chat(_loc2_);
      }
      
      public function get view() : ChatView
      {
         return this._chatView;
      }
      
      public function get visibleSwitchEnable() : Boolean
      {
         return this._visibleSwitchEnable;
      }
      
      public function set visibleSwitchEnable(param1:Boolean) : void
      {
         if(this._visibleSwitchEnable == param1)
         {
            return;
         }
         this._visibleSwitchEnable = param1;
      }
      
      private function __bBugle(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.bigBuggleType = _loc2_.readInt();
         _loc3_.channel = ChatInputView.BIG_BUGLE;
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __bugleBuyHandler(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         _loc2_.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         if(_loc4_ == 3 && _loc3_ == 1)
         {
            this.input.sendCurrentText();
         }
         else if(_loc4_ == 5 && _loc3_ >= 1)
         {
            dispatchEvent(new Event(CrazyTankSocketEvent.BUY_BEAD));
         }
      }
      
      private function __cBugle(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.CROSS_BUGLE;
         _loc3_.zoneID = _loc2_.readInt();
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.zoneName = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __consortiaChat(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ChatData = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         if(_loc2_.clientId != PlayerManager.Instance.Self.ID)
         {
            _loc3_ = _loc2_.readByte();
            _loc4_ = new ChatData();
            _loc4_.channel = ChatInputView.CONSORTIA;
            _loc4_.senderID = _loc2_.clientId;
            _loc4_.receiver = "";
            _loc4_.sender = _loc2_.readUTF();
            _loc4_.msg = _loc2_.readUTF();
            this.chatCheckSelf(_loc4_);
         }
      }
      
      private function __defyAffiche(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.msg = _loc2_.readUTF();
         _loc3_.channel = ChatInputView.DEFY_AFFICHE;
         this.chatCheckSelf(_loc3_);
      }
      
      private function __getItemMsgHandler(param1:CrazyTankSocketEvent) : void
      {
         var txt:String = null;
         var battle_str:String = null;
         var data:ChatData = null;
         var str:String = null;
         var event:CrazyTankSocketEvent = param1;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var nickName:String = pkg.readUTF();
         var battle_type:int = pkg.readInt();
         var templateID:int = pkg.readInt();
         var isbinds:Boolean = pkg.readBoolean();
         var isBroadcast:int = pkg.readInt();
         if(battle_type == 0)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.unexpectedBattle");
         }
         else if(battle_type == 2)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.RouletteBattle");
         }
         else if(battle_type == 1)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.dungeonBattle");
         }
         else if(battle_type == 3)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.CaddyBattle");
         }
         else if(battle_type == 4)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.beadBattle");
         }
         else if(battle_type == 5)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.GiftBattle");
         }
         else if(battle_type == 11)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.BlessBattle");
         }
         if(isBroadcast == 1)
         {
            txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip.broadcast","[" + nickName + "]",battle_str);
         }
         else if(isBroadcast == 2)
         {
            txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip",nickName,battle_str);
         }
         else if(isBroadcast == 3)
         {
            str = pkg.readUTF();
            txt = LanguageMgr.GetTranslation("tank.manager.congratulateGain","[" + nickName + "]",str);
         }
         else if(isBroadcast == 4)
         {
            txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip.broadcast",nickName,LanguageMgr.GetTranslation("ddt.turnplate.chatName.txt"));
         }
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(templateID);
         data = new ChatData();
         data.channel = ChatInputView.SYS_NOTICE;
         data.msg = txt + "[" + itemInfo.Name + "]";
         var channelTag:Array = ChatFormats.getTagsByChannel(data.channel);
         txt = StringHelper.rePlaceHtmlTextField(txt);
         var nameTag:String = ChatFormats.creatBracketsTag(txt,ChatFormats.CLICK_USERNAME);
         var goodTag:String = ChatFormats.creatGoodTag("[" + itemInfo.Name + "]",ChatFormats.CLICK_GOODS,itemInfo.TemplateID,itemInfo.Quality,isbinds,data);
         data.htmlMessage = channelTag[0] + nameTag + goodTag + channelTag[1] + "<BR>";
         data.htmlMessage = Helpers.deCodeString(data.htmlMessage);
         if(isBroadcast != 4)
         {
            this._model.addChat(data);
         }
         else
         {
            setTimeout(function():void
            {
               _model.addChat(data);
            },8000);
         }
      }
      
      private function __goodLinkGetHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         if(_loc4_ == 6)
         {
            _loc6_ = _loc3_.readUTF();
            _loc2_.Name = _loc3_.readUTF();
            _loc2_.TemplateID = _loc3_.readInt();
            _loc2_.Property2 = _loc3_.readInt().toString();
            _loc2_.Property3 = _loc3_.readInt().toString();
            _loc2_.beadLevel = _loc3_.readInt();
            _loc2_.beadExp = _loc3_.readInt();
            this.output.contentField.showBeadTip(_loc2_,1);
            return;
         }
         var _loc5_:String = _loc3_.readUTF();
         _loc2_.TemplateID = _loc3_.readInt();
         _loc2_.ItemID = _loc3_.readInt();
         _loc2_.StrengthenLevel = _loc3_.readInt();
         _loc2_.AttackCompose = _loc3_.readInt();
         _loc2_.AgilityCompose = _loc3_.readInt();
         _loc2_.LuckCompose = _loc3_.readInt();
         _loc2_.DefendCompose = _loc3_.readInt();
         _loc2_.ValidDate = _loc3_.readInt();
         _loc2_.IsBinds = _loc3_.readBoolean();
         _loc2_.IsJudge = _loc3_.readBoolean();
         _loc2_.IsUsed = _loc3_.readBoolean();
         if(_loc2_.IsUsed)
         {
            _loc2_.BeginDate = _loc3_.readUTF();
         }
         _loc2_.Hole1 = _loc3_.readInt();
         _loc2_.Hole2 = _loc3_.readInt();
         _loc2_.Hole3 = _loc3_.readInt();
         _loc2_.Hole4 = _loc3_.readInt();
         _loc2_.Hole5 = _loc3_.readInt();
         _loc2_.Hole6 = _loc3_.readInt();
         _loc2_.Hole = _loc3_.readUTF();
         ItemManager.fill(_loc2_);
         _loc2_.Pic = _loc3_.readUTF();
         _loc2_.RefineryLevel = _loc3_.readInt();
         _loc2_.DiscolorValidDate = _loc3_.readDateString();
         _loc2_.Hole5Level = _loc3_.readByte();
         _loc2_.Hole5Exp = _loc3_.readInt();
         _loc2_.Hole6Level = _loc3_.readByte();
         _loc2_.Hole6Exp = _loc3_.readInt();
         this.model.addLink(_loc5_,_loc2_);
         if(_loc2_.CategoryID == EquipType.EQUIP)
         {
            this.output.contentField.showEquipTip(_loc2_,1);
         }
         else
         {
            this.output.contentField.showLinkGoodsInfo(_loc2_,1);
         }
      }
      
      private function __privateChat(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:ChatData = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg;
         if(_loc2_.clientId)
         {
            _loc3_ = new ChatData();
            _loc3_.channel = ChatInputView.PRIVATE;
            _loc3_.receiverID = _loc2_.readInt();
            _loc3_.senderID = _loc2_.clientId;
            _loc3_.receiver = _loc2_.readUTF();
            _loc3_.sender = _loc2_.readUTF();
            _loc3_.msg = _loc2_.readUTF();
            _loc3_.isAutoReply = _loc2_.readBoolean();
            this.chatCheckSelf(_loc3_);
            if(_loc3_.senderID != PlayerManager.Instance.Self.ID)
            {
               IMController.Instance.saveRecentContactsID(_loc3_.senderID);
            }
            else if(_loc3_.receiverID != PlayerManager.Instance.Self.ID)
            {
               IMController.Instance.saveRecentContactsID(_loc3_.receiverID);
            }
         }
      }
      
      private function __receiveFace(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Object = {};
         _loc2_.playerid = param1.pkg.clientId;
         _loc2_.faceid = param1.pkg.readInt();
         _loc2_.delay = param1.pkg.readInt();
         dispatchEvent(new ChatEvent(ChatEvent.SHOW_FACE,_loc2_));
      }
      
      private function __sBugle(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = ChatInputView.SMALL_BUGLE;
         _loc3_.senderID = _loc2_.readInt();
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         this.chat(_loc3_);
      }
      
      private function __sceneChat(param1:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:ChatData = new ChatData();
         _loc3_.zoneID = _loc2_.readInt();
         _loc3_.channel = _loc2_.readByte();
         if(_loc2_.readBoolean())
         {
            _loc3_.channel = ChatInputView.TEAM;
         }
         _loc3_.senderID = _loc2_.clientId;
         _loc3_.receiver = "";
         _loc3_.sender = _loc2_.readUTF();
         _loc3_.msg = _loc2_.readUTF();
         this.chatCheckSelf(_loc3_);
         this.addRecentContacts(_loc3_.senderID);
      }
      
      private function addRecentContacts(param1:int) : void
      {
         if(StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            if(RoomManager.Instance.isIdenticalRoom(param1))
            {
               IMController.Instance.saveRecentContactsID(param1);
            }
         }
         else if(StateManager.isInFight)
         {
            if(GameManager.Instance.isIdenticalGame(param1))
            {
               IMController.Instance.saveRecentContactsID(param1);
            }
         }
      }
      
      private function __sysNotice(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var _loc2_:int = param1.pkg.readInt();
         var _loc3_:String = param1.pkg.readUTF();
         var _loc5_:ChatData = new ChatData();
         var _loc6_:Boolean = false;
         switch(_loc2_)
         {
            case 0:
               _loc5_.channel = ChatInputView.GM_NOTICE;
               break;
            case 1:
            case 4:
            case 5:
            case 21:
               _loc6_ = true;
            case 2:
            case 6:
            case 7:
               _loc5_.channel = ChatInputView.SYS_TIP;
               break;
            case 3:
               _loc5_.channel = ChatInputView.SYS_NOTICE;
               break;
            case 8:
               _loc5_.channel = 22;
               break;
            case 10:
            case 11:
            case 16:
            case 18:
            case 19:
               _loc6_ = true;
            case 13:
            case 12:
               _loc5_.zoneID = param1.pkg.readInt();
               _loc5_.channel = ChatInputView.CROSS_NOTICE;
               break;
            case 9:
               _loc5_.channel = ChatInputView.ACTIVITY;
               break;
            default:
               _loc5_.channel = ChatInputView.SYS_NOTICE;
         }
         if(param1 && param1.pkg.bytesAvailable && _loc2_ == 8)
         {
            _loc5_.anyThing = ChatHelper.readDungeonInfo(param1.pkg);
            _loc5_.sender = String(_loc5_.anyThing.inviterNickName);
         }
         else if(param1 && param1.pkg.bytesAvailable && _loc2_ == 9)
         {
            _loc5_.anyThing = param1.pkg.readUTF();
         }
         else if(param1 && param1.pkg.bytesAvailable)
         {
            _loc4_ = ChatHelper.readGoodsLinks(param1.pkg,_loc6_);
         }
         _loc5_.type = _loc2_;
         _loc5_.msg = StringHelper.rePlaceHtmlTextField(_loc3_);
         _loc5_.link = _loc4_;
         if(_loc2_ == 12 && param1.pkg.bytesAvailable)
         {
            _loc7_ = param1.pkg.readInt();
            if(_loc7_ == TurnPlateController.TURNPLATE_HISTORY)
            {
               _loc8_ = param1.pkg.readUTF();
               _loc9_ = param1.pkg.readInt();
               _loc10_ = param1.pkg.readUTF();
               setTimeout(this.chat,8000,_loc5_);
            }
            else
            {
               this.chat(_loc5_);
            }
         }
         else
         {
            this.chat(_loc5_);
         }
      }
      
      private function chatCheckSelf(param1:ChatData) : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:PlayerInfo = null;
         if(param1.zoneID != -1 && param1.zoneID != PlayerManager.Instance.Self.ZoneID)
         {
            if(param1.sender != PlayerManager.Instance.Self.NickName || param1.zoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this.chat(param1);
               return;
            }
         }
         else if(param1.sender != PlayerManager.Instance.Self.NickName)
         {
            if(param1.channel == ChatInputView.CONSORTIA)
            {
               _loc2_ = PlayerManager.Instance.blackList;
               for each(_loc3_ in _loc2_)
               {
                  if(_loc3_.NickName == param1.sender)
                  {
                     return;
                  }
               }
            }
            this.chat(param1);
         }
      }
      
      private function initEvent() : void
      {
         if(!SHIELD_NOTICE)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.S_BUGLE,this.__sBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.B_BUGLE,this.__bBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.C_BUGLE,this.__cBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_ITEM_MESS,this.__getItemMsgHandler);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_PERSONAL,this.__privateChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_CHAT,this.__sceneChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAT,this.__consortiaChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_FACE,this.__receiveFace);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_NOTICE,this.__sysNotice);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEFY_AFFICHE,this.__defyAffiche);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__bugleBuyHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LINKGOODSINFO_GET,this.__goodLinkGetHandler);
      }
      
      private function initView() : void
      {
         ChatFormats.setup();
         this._model = new ChatModel();
         this._chatView = ComponentFactory.Instance.creatCustomObject("chat.View");
         this.state = CHAT_HALL_STATE;
         this.inputChannel = ChatInputView.CURRENT;
         this.outputChannel = ChatOutputView.CHAT_OUPUT_CURRENT;
      }
      
      private function sendMessage(param1:int, param2:String, param3:String, param4:Boolean) : void
      {
         param3 = Helpers.enCodeString(param3);
         var _loc5_:PackageOut = new PackageOut(ePackageType.SCENE_CHAT);
         _loc5_.writeByte(param1);
         _loc5_.writeBoolean(param4);
         _loc5_.writeUTF(param2);
         _loc5_.writeUTF(param3);
         SocketManager.Instance.out.sendPackage(_loc5_);
      }
      
      public function sendPrivateMessage(param1:String, param2:String, param3:Number = 0, param4:Boolean = false) : void
      {
         param2 = Helpers.enCodeString(param2);
         var _loc5_:PackageOut = new PackageOut(ePackageType.CHAT_PERSONAL);
         _loc5_.writeInt(param3);
         _loc5_.writeUTF(param1);
         _loc5_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc5_.writeUTF(param2);
         _loc5_.writeBoolean(param4);
         SocketManager.Instance.out.sendPackage(_loc5_);
         if(RoomManager.Instance.current && !RoomManager.Instance.current.isCrossZone)
         {
            IMController.Instance.saveRecentContactsID(param3);
         }
      }
      
      public function set reportMsg(param1:String) : void
      {
         this._reportMsg = param1;
      }
      
      public function get reportMsg() : String
      {
         return this._reportMsg;
      }
   }
}
