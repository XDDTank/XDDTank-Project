package ddt.manager
{
   import com.pickgliss.loader.LoadInterfaceEvent;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.FightPropMode;
   import ddt.events.SharedEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import game.view.prop.FightModelPropBar;
   
   [Event(name="change",type="flash.events.Event")]
   public class SharedManager extends EventDispatcher
   {
      
      public static var RIGHT_PROP:Array = [10001,10003,10002,10004,10005,10006,10007];
      
      public static const KEY_SET_ABLE:Array = [10001,10003,10002,10004,10005,10006,10007,10008];
      
      private static var instance:SharedManager = new SharedManager();
       
      
      public var allowMusic:Boolean = true;
      
      public var allowSound:Boolean = true;
      
      public var showTopMessageBar:Boolean = true;
      
      private var _showInvateWindow:Boolean = true;
      
      public var showParticle:Boolean = true;
      
      public var isAddedToFavorite:Boolean = false;
      
      public var showOL:Boolean = true;
      
      public var showCI:Boolean = true;
      
      public var showHat:Boolean = true;
      
      public var showGlass:Boolean = true;
      
      public var showSuit:Boolean = true;
      
      public var fightModelPropCell:Boolean = true;
      
      public var fightModelPropCellSave:String;
      
      public var fastReplys:Object;
      
      public var rightPropBarType:Boolean = false;
      
      public var musicVolumn:int = 50;
      
      public var soundVolumn:int = 50;
      
      public var StrengthMoney:int = 1000;
      
      public var ComposeMoney:int = 1000;
      
      public var FusionMoney:int = 1000;
      
      public var TransferMoney:int = 1000;
      
      public var KeyAutoSnap:Boolean = true;
      
      public var ShowBattleGuide:Boolean = true;
      
      public var isHintPropExpire:Boolean = true;
      
      public var AutoReady:Boolean = true;
      
      public var GameKeySets:Object;
      
      public var AuctionInfos:Object;
      
      public var AuctionIDs:Object;
      
      public var setBagLocked:Boolean = false;
      
      public var hasStrength3:Object;
      
      public var recentContactsID:Object;
      
      public var StoreBuyInfo:Object;
      
      public var hasCheckedOverFrameRate:Boolean = false;
      
      public var hasEnteredFightLib:Object;
      
      public var isAffirm:Boolean = true;
      
      public var recommendNum:int = 0;
      
      public var isRecommend:Boolean = false;
      
      public var unAcceptAnswer:Array;
      
      public var isSetingMovieClip:Boolean = true;
      
      public var voteData:Dictionary;
      
      public var beadFirstShow:Boolean = true;
      
      public var cardSystemShow:Boolean = true;
      
      public var totemSystemShow:Boolean = true;
      
      public var divorceBoolean:Boolean = false;
      
      public var friendBrithdayName:String = "";
      
      private var _autoSnsSend:Boolean = false;
      
      public var stoneFriend:Boolean = true;
      
      public var spacialReadedMail:Dictionary;
      
      public var deleteMail:Dictionary;
      
      public var privateChatRecord:Dictionary;
      
      public var autoWish:Boolean = false;
      
      public var mouseModel:Boolean = false;
      
      public var capabilityNotice:Object;
      
      public var hijackCarFilter:uint = 0;
      
      public var hasShowUpdateFrame:Boolean = false;
      
      public var showUpdateFrameDate:String = "";
      
      private var _showVipCheckBtn:Boolean = false;
      
      public var turnPlateShowChatBall:Boolean = true;
      
      private var _chatOutPutType:Object;
      
      private var _allowSnsSend:Boolean = false;
      
      private var _autoCaddy:Boolean = false;
      
      private var _autoOfferPack:Boolean = false;
      
      private var _autoBead:Boolean = false;
      
      private var _autoWishBead:Boolean = false;
      
      private var _edictumVersion:String = "";
      
      private var _propLayerMode:int = 2;
      
      private var _isCommunity:Boolean = true;
      
      private var _isWishPop:Boolean;
      
      private var _isFirstWish:Boolean;
      
      public var isRefreshPet:Boolean = false;
      
      public var isWorldBossBuyBuff:Boolean = false;
      
      public var isShowMultiAlert:Boolean = true;
      
      public var isResurrect:Boolean = false;
      
      public var isReFight:Boolean = false;
      
      public var awayAutoReply:Object;
      
      public var busyAutoReply:Object;
      
      public var noDistrubAutoReply:Object;
      
      public var shoppingAutoReply:Object;
      
      public var firstOpenMission:Object;
      
      public var showMouseModelLeadFight:Boolean = true;
      
      public var showLastPowerPointTips:Boolean = true;
      
      public var showMouseModelLeadMove:Boolean = true;
      
      public var maplistIndex:int;
      
      public var coolDownFightRobot:Boolean = false;
      
      private var _propTransparent:Boolean = false;
      
      public var boxType:int = 1;
      
      public function SharedManager()
      {
         this.fightModelPropCellSave = FightModelPropBar.LEAD;
         this.fastReplys = new Object();
         this.GameKeySets = new Object();
         this.AuctionInfos = new Object();
         this.AuctionIDs = new Object();
         this.hasStrength3 = new Object();
         this.recentContactsID = new Object();
         this.StoreBuyInfo = new Object();
         this.hasEnteredFightLib = new Object();
         this.unAcceptAnswer = [];
         this.voteData = new Dictionary();
         this.spacialReadedMail = new Dictionary();
         this.deleteMail = new Dictionary();
         this.privateChatRecord = new Dictionary();
         this.capabilityNotice = new Object();
         this._chatOutPutType = new Object();
         this.awayAutoReply = new Object();
         this.busyAutoReply = new Object();
         this.noDistrubAutoReply = new Object();
         this.shoppingAutoReply = new Object();
         this.firstOpenMission = new Object();
         super();
      }
      
      public static function get Instance() : SharedManager
      {
         return instance;
      }
      
      public function set showVipCheckBtn(param1:Boolean) : void
      {
         if(this._showVipCheckBtn == param1)
         {
            return;
         }
         this._showVipCheckBtn = param1;
         this.save();
      }
      
      public function get showVipCheckBtn() : Boolean
      {
         return this._showVipCheckBtn;
      }
      
      public function get autoSnsSend() : Boolean
      {
         return this._autoSnsSend;
      }
      
      public function set autoSnsSend(param1:Boolean) : void
      {
         if(this._autoSnsSend == param1)
         {
            return;
         }
         this._autoSnsSend = param1;
         this.save();
      }
      
      public function get allowSnsSend() : Boolean
      {
         return this._allowSnsSend;
      }
      
      public function get autoCaddy() : Boolean
      {
         return this._autoCaddy;
      }
      
      public function set autoCaddy(param1:Boolean) : void
      {
         if(this._autoCaddy != param1)
         {
            this._autoCaddy = param1;
            this.save();
         }
      }
      
      public function get autoOfferPack() : Boolean
      {
         return this._autoOfferPack;
      }
      
      public function set autoOfferPack(param1:Boolean) : void
      {
         if(this._autoOfferPack != param1)
         {
            this._autoOfferPack = param1;
            this.save();
         }
      }
      
      public function get autoBead() : Boolean
      {
         return this._autoBead;
      }
      
      public function set autoWishBead(param1:Boolean) : void
      {
         if(this._autoWishBead != param1)
         {
            this._autoWishBead = param1;
            this.save();
         }
      }
      
      public function get autoWishBead() : Boolean
      {
         return this._autoWishBead;
      }
      
      public function set autoBead(param1:Boolean) : void
      {
         if(this._autoBead != param1)
         {
            this._autoBead = param1;
            this.save();
         }
      }
      
      public function get edictumVersion() : String
      {
         return this._edictumVersion;
      }
      
      public function set edictumVersion(param1:String) : void
      {
         if(this._edictumVersion != param1)
         {
            this._edictumVersion = param1;
            this.save();
         }
      }
      
      public function get propLayerMode() : int
      {
         if(PlayerManager.Instance.Self.Grade < 4)
         {
            return FightPropMode.VERTICAL;
         }
         return this._propLayerMode;
      }
      
      public function set propLayerMode(param1:int) : void
      {
         if(this._propLayerMode != param1)
         {
            this._propLayerMode = param1;
            this.save();
         }
      }
      
      public function set allowSnsSend(param1:Boolean) : void
      {
         if(this._allowSnsSend == param1)
         {
            return;
         }
         this._allowSnsSend = param1;
         this.save();
      }
      
      public function get showInvateWindow() : Boolean
      {
         return this._showInvateWindow;
      }
      
      public function set showInvateWindow(param1:Boolean) : void
      {
         this._showInvateWindow = param1;
      }
      
      public function get isCommunity() : Boolean
      {
         return this._isCommunity;
      }
      
      public function set isCommunity(param1:Boolean) : void
      {
         this._isCommunity = param1;
      }
      
      public function get isWishPop() : Boolean
      {
         return this._isWishPop;
      }
      
      public function set isWishPop(param1:Boolean) : void
      {
         this._isWishPop = param1;
      }
      
      public function get isFirstWish() : Boolean
      {
         return this._isFirstWish;
      }
      
      public function set isFirstWish(param1:Boolean) : void
      {
         this._isFirstWish = param1;
      }
      
      public function setup() : void
      {
         this.load();
         if(LoadResourceManager.instance.isMicroClient)
         {
            LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.SET_SOUND,this.__setSound);
         }
      }
      
      private function __setSound(param1:LoadInterfaceEvent) : void
      {
         LoadInterfaceManager.traceMsg("setSound:" + param1.paras[0]);
         if(param1.paras[0] == 1)
         {
            this.allowMusic = this.allowSound = true;
         }
         else
         {
            this.allowMusic = this.allowSound = false;
         }
         this.changed();
      }
      
      public function reset() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("road");
         _loc1_.clear();
         _loc1_.flush(20 * 1024 * 1024);
      }
      
      private function load() : void
      {
         var so:SharedObject = null;
         var key:String = null;
         var keyII:String = null;
         var keyIII:String = null;
         var keyIV:String = null;
         var keyV:String = null;
         var keyP:String = null;
         var i:int = 0;
         var j:int = 0;
         var k:String = null;
         var id:String = null;
         var key1:String = null;
         var key2:String = null;
         var key3:String = null;
         var key4:String = null;
         var key5:String = null;
         var key6:String = null;
         var key7:String = null;
         var key8:String = null;
         try
         {
            so = SharedObject.getLocal("road");
            this.AuctionInfos = new Object();
            if(so && so.data)
            {
               if(so.data["allowMusic"] != undefined)
               {
                  this.allowMusic = so.data["allowMusic"];
               }
               if(so.data["allowSound"] != undefined)
               {
                  this.allowSound = so.data["allowSound"];
               }
               if(so.data["showTopMessageBar"] != undefined)
               {
                  this.showTopMessageBar = so.data["showTopMessageBar"];
               }
               if(so.data["showInvateWindow"] != undefined)
               {
                  this.showInvateWindow = so.data["showInvateWindow"];
               }
               if(so.data["showParticle"] != undefined)
               {
                  this.showParticle = so.data["showParticle"];
               }
               if(so.data["showOL"] != undefined)
               {
                  this.showOL = so.data["showOL"];
               }
               if(so.data["showCI"] != undefined)
               {
                  this.showCI = so.data["showCI"];
               }
               if(so.data["showHat"] != undefined)
               {
                  this.showHat = so.data["showHat"];
               }
               if(so.data["showGlass"] != undefined)
               {
                  this.showGlass = so.data["showGlass"];
               }
               if(so.data["showSuit"] != undefined)
               {
                  this.showSuit = so.data["showSuit"];
               }
               if(so.data["fightModelPropCell"] != undefined)
               {
                  this.fightModelPropCell = so.data["fightModelPropCell"];
               }
               if(so.data["fightModelPropCellSave"] != undefined)
               {
                  this.fightModelPropCellSave = so.data["fightModelPropCellSave"];
               }
               if(so.data["rightPropBarType"] != undefined)
               {
                  this.rightPropBarType = so.data["rightPropBarType"];
               }
               if(so.data["musicVolumn"] != undefined)
               {
                  this.musicVolumn = so.data["musicVolumn"];
               }
               if(so.data["soundVolumn"] != undefined)
               {
                  this.soundVolumn = so.data["soundVolumn"];
               }
               if(so.data["KeyAutoSnap"] != undefined)
               {
                  this.KeyAutoSnap = so.data["KeyAutoSnap"];
               }
               if(so.data["cardSystemShow"] != undefined)
               {
                  this.cardSystemShow = so.data["cardSystemShow"];
               }
               if(so.data["divorceBoolean"] != undefined)
               {
                  this.divorceBoolean = so.data["divorceBoolean"];
               }
               if(so.data["friendBrithdayName"] != undefined)
               {
                  this.friendBrithdayName = so.data["friendBrithdayName"];
               }
               if(so.data["AutoReady"] != undefined)
               {
                  this.AutoReady = so.data["AutoReady"];
               }
               if(so.data["ShowBattleGuide"] != undefined)
               {
                  this.ShowBattleGuide = so.data["ShowBattleGuide"];
               }
               if(so.data["isHintPropExpire"] != undefined)
               {
                  this.isHintPropExpire = so.data["isHintPropExpire"];
               }
               if(so.data["hasCheckedOverFrameRate"] != undefined)
               {
                  this.hasCheckedOverFrameRate = so.data["hasCheckedOverFrameRate"];
               }
               if(so.data["isRecommend"] != undefined)
               {
                  this.isRecommend = so.data["isRecommend"];
               }
               if(so.data["recommendNum"] != undefined)
               {
                  this.recommendNum = so.data["recommendNum"];
               }
               if(so.data["isSetingMovieClip"] != undefined)
               {
                  this.isSetingMovieClip = so.data["isSetingMovieClip"];
               }
               if(so.data["propLayerMode"] != undefined)
               {
                  this._propLayerMode = so.data["propLayerMode"];
               }
               if(so.data["autoCaddy"] != undefined)
               {
                  this._autoCaddy = so.data["autoCaddy"];
               }
               if(so.data["autoOfferPack"] != undefined)
               {
                  this._autoOfferPack = so.data["autoOfferPack"];
               }
               if(so.data["autoBead"] != undefined)
               {
                  this._autoBead = so.data["autoBead"];
               }
               if(so.data["edictumVersion"] != undefined)
               {
                  this._edictumVersion = so.data["edictumVersion"];
               }
               if(so.data["isFirstWish"] != undefined)
               {
                  this._isFirstWish = so.data["isFirstWish"];
               }
               if(so.data["stoneFriend"] != undefined)
               {
                  this.stoneFriend = so.data["stoneFriend"];
               }
               if(so.data["hijackCarFilter"] != undefined)
               {
                  this.hijackCarFilter = so.data["hijackCarFilter"];
               }
               if(so.data["hasShowUpdateFrame"] != undefined)
               {
                  this.hasShowUpdateFrame = so.data["hasShowUpdateFrame"];
               }
               if(so.data["showUpdateFrameDate"] != undefined)
               {
                  this.showUpdateFrameDate = so.data["showUpdateFrameDate"];
               }
               if(so.data["hasStrength3"] != undefined)
               {
                  for(key in so.data["hasStrength3"])
                  {
                     this.hasStrength3[key] = so.data["hasStrength3"][key];
                  }
               }
               if(so.data["recentContactsID"] != undefined)
               {
                  for(keyII in so.data["recentContactsID"])
                  {
                     this.recentContactsID[keyII] = so.data["recentContactsID"][keyII];
                  }
               }
               if(so.data["voteData"] != undefined)
               {
                  for(keyIII in so.data["voteData"])
                  {
                     this.voteData[keyIII] = so.data["voteData"][keyIII];
                  }
               }
               if(so.data["spacialReadedMail"] != undefined)
               {
                  for(keyIV in so.data["spacialReadedMail"])
                  {
                     this.spacialReadedMail[keyIV] = so.data["spacialReadedMail"][keyIV];
                  }
               }
               if(so.data["deleteMail"] != undefined)
               {
                  for(keyV in so.data["deleteMail"])
                  {
                     this.deleteMail[keyV] = so.data["deleteMail"][keyV];
                  }
               }
               if(so.data["privateChatRecord"] != undefined)
               {
                  for(keyP in so.data["privateChatRecord"])
                  {
                     this.privateChatRecord[keyP] = so.data["privateChatRecord"][keyP];
                  }
               }
               if(so.data["GameKeySets"] != undefined)
               {
                  i = 1;
                  while(i < KEY_SET_ABLE.length + 1)
                  {
                     this.GameKeySets[String(i)] = so.data["GameKeySets"][String(i)];
                     i++;
                  }
               }
               else
               {
                  j = 0;
                  while(j < KEY_SET_ABLE.length)
                  {
                     this.GameKeySets[String(j + 1)] = KEY_SET_ABLE[j];
                     j++;
                  }
               }
               if(so.data["AuctionInfos"] != undefined)
               {
                  for(k in so.data["AuctionInfos"])
                  {
                     this.AuctionInfos[k] = so.data["AuctionInfos"][k];
                  }
               }
               if(so.data["AuctionIDs"] != undefined)
               {
                  this.AuctionIDs = so.data["AuctionIDs"];
                  for(id in so.data["AuctionInfos"])
                  {
                     this.AuctionIDs[id] = so.data["AuctionInfos"][id];
                  }
               }
               if(so.data["setBagLocked" + PlayerManager.Instance.Self.ID] != undefined)
               {
                  this.setBagLocked = so.data["setBagLocked"];
               }
               if(so.data["StoreBuyInfo"] != undefined)
               {
                  for(key1 in so.data["StoreBuyInfo"])
                  {
                     this.StoreBuyInfo[key1] = so.data["StoreBuyInfo"][key1];
                  }
               }
               if(so.data["hasEnteredFightLib"] != undefined)
               {
                  for(key2 in so.data["hasEnteredFightLib"])
                  {
                     this.hasEnteredFightLib[key2] = so.data["hasEnteredFightLib"][key2];
                  }
               }
               if(so.data["isAffirm"] != this.isAffirm)
               {
                  this.isAffirm = so.data["isAffirm"];
               }
               if(so.data["fastReplys"] != undefined)
               {
                  for(key3 in so.data["fastReplys"])
                  {
                     this.fastReplys[key3] = so.data["fastReplys"][key3];
                  }
               }
               if(so.data["autoSnsSend"] != undefined)
               {
                  this._autoSnsSend = so.data["autoSnsSend"];
               }
               if(so.data["allowSnsSend"] != undefined)
               {
                  this._allowSnsSend = so.data["allowSnsSend"];
               }
               if(so.data["AwayAutoReply"] != undefined)
               {
                  for(key4 in so.data["AwayAutoReply"])
                  {
                     this.awayAutoReply[key4] = so.data["AwayAutoReply"][key4];
                  }
               }
               if(so.data["BusyAutoReply"] != undefined)
               {
                  for(key5 in so.data["BusyAutoReply"])
                  {
                     this.busyAutoReply[key5] = so.data["BusyAutoReply"][key5];
                  }
               }
               if(so.data["NoDistrubAutoReply"] != undefined)
               {
                  for(key6 in so.data["NoDistrubAutoReply"])
                  {
                     this.noDistrubAutoReply[key6] = so.data["NoDistrubAutoReply"][key6];
                  }
               }
               if(so.data["ShoppingAutoReply"] != undefined)
               {
                  for(key7 in so.data["ShoppingAutoReply"])
                  {
                     this.shoppingAutoReply[key7] = so.data["ShoppingAutoReply"][key7];
                  }
               }
               if(so.data["isCommunity"] != undefined)
               {
                  this.isCommunity = so.data["isCommunity"];
               }
               if(so.data["isWishPop"] != undefined)
               {
                  this.isWishPop = so.data["isWishPop"];
               }
               if(so.data["autoWish"] != undefined)
               {
                  this.autoWish = so.data["autoWish"];
               }
               if(so.data["isRefreshPet"] != undefined)
               {
                  this.isRefreshPet = so.data["isRefreshPet"];
               }
               if(so.data["firstOpenMission"] != undefined)
               {
                  for(key8 in so.data["firstOpenMission"])
                  {
                     this.firstOpenMission[key8] = so.data["firstOpenMission"][key8];
                  }
               }
               if(so.data["beadFirstShow"] != undefined)
               {
                  this.beadFirstShow = so.data["beadFirstShow"];
               }
               if(so.data["mouseModel"] != undefined)
               {
                  this.mouseModel = so.data["mouseModel"];
               }
               if(so.data["isAddedToFavorite"] != undefined)
               {
                  this.isAddedToFavorite = so.data["isAddedToFavorite"];
               }
               if(so.data["totemSystemShow"] != undefined)
               {
                  this.totemSystemShow = so.data["totemSystemShow"];
               }
               if(so.data["showMouseModelLeadFight"] != undefined)
               {
                  this.showMouseModelLeadFight = so.data["showMouseModelLeadFight"];
               }
               if(so.data["showLastPowerPointTips"] != undefined)
               {
                  this.showLastPowerPointTips = so.data["showLastPowerPointTips"];
               }
               if(so.data["showMouseModelLeadMove"] != undefined)
               {
                  this.showMouseModelLeadMove = so.data["showMouseModelLeadMove"];
               }
               if(so.data["maplistIndex"] != undefined)
               {
                  this.maplistIndex = so.data["maplistIndex"];
               }
               if(so.data["capabilityNotice"] != undefined)
               {
                  this.capabilityNotice = so.data["capabilityNotice"];
               }
               if(so.data["showVipCheckBtn"] != undefined)
               {
                  this._showVipCheckBtn = so.data["showVipCheckBtn"];
               }
               if(so.data["isShowMultiAlert"] != undefined)
               {
                  this.isShowMultiAlert = so.data["isShowMultiAlert"];
               }
               if(so.data["chatOutPutType"] != undefined)
               {
                  this._chatOutPutType = so.data["chatOutPutType"];
               }
               if(so.data["turnPlateShowChatBall"] != undefined)
               {
                  this.turnPlateShowChatBall = so.data["turnPlateShowChatBall"];
               }
               if(so.data["coolDownFightRobot"] != undefined)
               {
                  this.coolDownFightRobot = so.data["coolDownFightRobot"];
               }
            }
         }
         catch(e:Error)
         {
         }
         finally
         {
            this.changed();
         }
      }
      
      public function save() : void
      {
         var _loc1_:SharedObject = null;
         var _loc2_:Object = null;
         var _loc3_:* = null;
         try
         {
            _loc1_ = SharedObject.getLocal("road");
            _loc1_.data["allowMusic"] = this.allowMusic;
            _loc1_.data["allowSound"] = this.allowSound;
            _loc1_.data["showTopMessageBar"] = this.showTopMessageBar;
            _loc1_.data["showInvateWindow"] = this.showInvateWindow;
            _loc1_.data["showParticle"] = this.showParticle;
            _loc1_.data["showOL"] = this.showOL;
            _loc1_.data["showCI"] = this.showCI;
            _loc1_.data["showHat"] = this.showHat;
            _loc1_.data["showGlass"] = this.showGlass;
            _loc1_.data["showSuit"] = this.showSuit;
            _loc1_.data["fightModelPropCell"] = this.fightModelPropCell;
            _loc1_.data["fightModelPropCellSave"] = this.fightModelPropCellSave;
            _loc1_.data["rightPropBarType"] = this.rightPropBarType;
            _loc1_.data["musicVolumn"] = this.musicVolumn;
            _loc1_.data["soundVolumn"] = this.soundVolumn;
            _loc1_.data["KeyAutoSnap"] = this.KeyAutoSnap;
            _loc1_.data["cardSystemShow"] = this.cardSystemShow;
            _loc1_.data["divorceBoolean"] = this.divorceBoolean;
            _loc1_.data["friendBrithdayName"] = this.friendBrithdayName;
            _loc1_.data["AutoReady"] = this.AutoReady;
            _loc1_.data["ShowBattleGuide"] = this.ShowBattleGuide;
            _loc1_.data["isHintPropExpire"] = this.isHintPropExpire;
            _loc1_.data["hasCheckedOverFrameRate"] = this.hasCheckedOverFrameRate;
            _loc1_.data["isAffirm"] = this.isAffirm;
            _loc1_.data["isRecommend"] = this.isRecommend;
            _loc1_.data["recommendNum"] = this.recommendNum;
            _loc1_.data["isSetingMovieClip"] = this.isSetingMovieClip;
            _loc1_.data["propLayerMode"] = this.propLayerMode;
            _loc1_.data["autoCaddy"] = this._autoCaddy;
            _loc1_.data["autoOfferPack"] = this._autoOfferPack;
            _loc1_.data["autoBead"] = this._autoBead;
            _loc1_.data["edictumVersion"] = this._edictumVersion;
            _loc1_.data["stoneFriend"] = this.stoneFriend;
            _loc1_.data["hijackCarFilter"] = this.hijackCarFilter;
            _loc1_.data["hasShowUpdateFrame"] = this.hasShowUpdateFrame;
            _loc1_.data["showUpdateFrameDate"] = this.showUpdateFrameDate;
            _loc2_ = {};
            for(_loc3_ in this.GameKeySets)
            {
               _loc2_[_loc3_] = this.GameKeySets[_loc3_];
            }
            _loc1_.data["GameKeySets"] = _loc2_;
            if(this.AuctionInfos)
            {
               _loc1_.data["AuctionInfos"] = this.AuctionInfos;
            }
            if(this.hasStrength3)
            {
               _loc1_.data["hasStrength3"] = this.hasStrength3;
            }
            if(this.recentContactsID)
            {
               _loc1_.data["recentContactsID"] = this.recentContactsID;
            }
            if(this.voteData)
            {
               _loc1_.data["voteData"] = this.voteData;
            }
            if(this.spacialReadedMail)
            {
               _loc1_.data["spacialReadedMail"] = this.spacialReadedMail;
            }
            if(this.deleteMail)
            {
               _loc1_.data["deleteMail"] = this.deleteMail;
            }
            if(this.privateChatRecord)
            {
               _loc1_.data["privateChatRecord"] = this.privateChatRecord;
            }
            if(this.hasEnteredFightLib)
            {
               _loc1_.data["hasEnteredFightLib"] = this.hasEnteredFightLib;
            }
            if(this.fastReplys)
            {
               _loc1_.data["fastReplys"] = this.fastReplys;
            }
            if(this.autoWish)
            {
               _loc1_.data["autoWish"] = this.autoWish;
            }
            if(this.isRefreshPet)
            {
               _loc1_.data["isRefreshPet"] = this.isRefreshPet;
            }
            _loc1_.data["AuctionIDs"] = this.AuctionIDs;
            _loc1_.data["setBagLocked"] = this.setBagLocked;
            _loc1_.data["StoreBuyInfo"] = this.StoreBuyInfo;
            _loc1_.data["autoSnsSend"] = this._autoSnsSend;
            _loc1_.data["allowSnsSend"] = this._allowSnsSend;
            _loc1_.data["AwayAutoReply"] = this.awayAutoReply;
            _loc1_.data["BusyAutoReply"] = this.busyAutoReply;
            _loc1_.data["NoDistrubAutoReply"] = this.noDistrubAutoReply;
            _loc1_.data["ShoppingAutoReply"] = this.shoppingAutoReply;
            _loc1_.data["isCommunity"] = this.isCommunity;
            _loc1_.data["isWishPop"] = this.isWishPop;
            _loc1_.data["isFirstWish"] = this.isFirstWish;
            _loc1_.data["firstOpenMission"] = this.firstOpenMission;
            _loc1_.data["beadFirstShow"] = this.beadFirstShow;
            _loc1_.data["mouseModel"] = this.mouseModel;
            _loc1_.data["isAddedToFavorite"] = this.isAddedToFavorite;
            _loc1_.data["isAddedToFavorite"] = this.isAddedToFavorite;
            _loc1_.data["totemSystemShow"] = this.totemSystemShow;
            _loc1_.data["showMouseModelLeadFight"] = this.showMouseModelLeadFight;
            _loc1_.data["showLastPowerPointTips"] = this.showLastPowerPointTips;
            _loc1_.data["showMouseModelLeadMove"] = this.showMouseModelLeadMove;
            _loc1_.data["maplistIndex"] = this.maplistIndex;
            _loc1_.data["capabilityNotice"] = this.capabilityNotice;
            _loc1_.data["showVipCheckBtn"] = this._showVipCheckBtn;
            _loc1_.data["isShowMultiAlert"] = this.isShowMultiAlert;
            _loc1_.data["chatOutPutType"] = this.chatOutPutType;
            _loc1_.data["turnPlateShowChatBall"] = this.turnPlateShowChatBall;
            _loc1_.data["coolDownFightRobot"] = this.coolDownFightRobot;
            _loc1_.flush(20 * 1024 * 1024);
            _loc1_.flush(20 * 1024 * 1024);
         }
         catch(e:Error)
         {
         }
         this.changed();
         LoadInterfaceManager.setSound(this.allowMusic || this.allowSound ? "1" : "0");
      }
      
      public function changed() : void
      {
         var _loc1_:* = null;
         SoundManager.instance.setConfig(this.allowMusic,this.allowSound,this.musicVolumn,this.soundVolumn);
         for(_loc1_ in this.GameKeySets)
         {
            if(RIGHT_PROP[int(int(_loc1_) - 1)])
            {
               RIGHT_PROP[int(int(_loc1_) - 1)] = this.GameKeySets[_loc1_];
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set propTransparent(param1:Boolean) : void
      {
         if(this._propTransparent != param1)
         {
            this._propTransparent = param1;
            dispatchEvent(new SharedEvent(SharedEvent.TRANSPARENTCHANGED));
         }
      }
      
      public function get propTransparent() : Boolean
      {
         return this._propTransparent;
      }
      
      public function get chatOutPutType() : Object
      {
         return this._chatOutPutType;
      }
      
      public function setChatOutPutType(param1:int, param2:Boolean) : void
      {
         this._chatOutPutType[param1] = param2;
         this.save();
      }
   }
}
