// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.SharedManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import game.view.prop.FightModelPropBar;
    import flash.utils.Dictionary;
    import ddt.data.FightPropMode;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.LoadInterfaceManager;
    import com.pickgliss.loader.LoadInterfaceEvent;
    import flash.net.SharedObject;
    import flash.events.Event;
    import ddt.events.SharedEvent;

    [Event(name="change", type="flash.events.Event")]
    public class SharedManager extends EventDispatcher 
    {

        public static var RIGHT_PROP:Array = [10001, 10003, 10002, 10004, 10005, 10006, 10007];
        public static const KEY_SET_ABLE:Array = [10001, 10003, 10002, 10004, 10005, 10006, 10007, 10008];
        private static var instance:SharedManager = new (SharedManager)();

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
        public var fightModelPropCellSave:String = FightModelPropBar.LEAD;
        public var fastReplys:Object = new Object();
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
        public var GameKeySets:Object = new Object();
        public var AuctionInfos:Object = new Object();
        public var AuctionIDs:Object = new Object();
        public var setBagLocked:Boolean = false;
        public var hasStrength3:Object = new Object();
        public var recentContactsID:Object = new Object();
        public var StoreBuyInfo:Object = new Object();
        public var hasCheckedOverFrameRate:Boolean = false;
        public var hasEnteredFightLib:Object = new Object();
        public var isAffirm:Boolean = true;
        public var recommendNum:int = 0;
        public var isRecommend:Boolean = false;
        public var unAcceptAnswer:Array = [];
        public var isSetingMovieClip:Boolean = true;
        public var voteData:Dictionary = new Dictionary();
        public var beadFirstShow:Boolean = true;
        public var cardSystemShow:Boolean = true;
        public var totemSystemShow:Boolean = true;
        public var divorceBoolean:Boolean = false;
        public var friendBrithdayName:String = "";
        private var _autoSnsSend:Boolean = false;
        public var stoneFriend:Boolean = true;
        public var spacialReadedMail:Dictionary = new Dictionary();
        public var deleteMail:Dictionary = new Dictionary();
        public var privateChatRecord:Dictionary = new Dictionary();
        public var autoWish:Boolean = false;
        public var mouseModel:Boolean = false;
        public var capabilityNotice:Object = new Object();
        public var hijackCarFilter:uint = 0;
        public var hasShowUpdateFrame:Boolean = false;
        public var showUpdateFrameDate:String = "";
        private var _showVipCheckBtn:Boolean = false;
        public var turnPlateShowChatBall:Boolean = true;
        private var _chatOutPutType:Object = new Object();
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
        public var awayAutoReply:Object = new Object();
        public var busyAutoReply:Object = new Object();
        public var noDistrubAutoReply:Object = new Object();
        public var shoppingAutoReply:Object = new Object();
        public var firstOpenMission:Object = new Object();
        public var showMouseModelLeadFight:Boolean = true;
        public var showLastPowerPointTips:Boolean = true;
        public var showMouseModelLeadMove:Boolean = true;
        public var maplistIndex:int;
        public var coolDownFightRobot:Boolean = false;
        private var _propTransparent:Boolean = false;
        public var boxType:int = 1;


        public static function get Instance():SharedManager
        {
            return (instance);
        }


        public function set showVipCheckBtn(_arg_1:Boolean):void
        {
            if (this._showVipCheckBtn == _arg_1)
            {
                return;
            };
            this._showVipCheckBtn = _arg_1;
            this.save();
        }

        public function get showVipCheckBtn():Boolean
        {
            return (this._showVipCheckBtn);
        }

        public function get autoSnsSend():Boolean
        {
            return (this._autoSnsSend);
        }

        public function set autoSnsSend(_arg_1:Boolean):void
        {
            if (this._autoSnsSend == _arg_1)
            {
                return;
            };
            this._autoSnsSend = _arg_1;
            this.save();
        }

        public function get allowSnsSend():Boolean
        {
            return (this._allowSnsSend);
        }

        public function get autoCaddy():Boolean
        {
            return (this._autoCaddy);
        }

        public function set autoCaddy(_arg_1:Boolean):void
        {
            if (this._autoCaddy != _arg_1)
            {
                this._autoCaddy = _arg_1;
                this.save();
            };
        }

        public function get autoOfferPack():Boolean
        {
            return (this._autoOfferPack);
        }

        public function set autoOfferPack(_arg_1:Boolean):void
        {
            if (this._autoOfferPack != _arg_1)
            {
                this._autoOfferPack = _arg_1;
                this.save();
            };
        }

        public function get autoBead():Boolean
        {
            return (this._autoBead);
        }

        public function set autoWishBead(_arg_1:Boolean):void
        {
            if (this._autoWishBead != _arg_1)
            {
                this._autoWishBead = _arg_1;
                this.save();
            };
        }

        public function get autoWishBead():Boolean
        {
            return (this._autoWishBead);
        }

        public function set autoBead(_arg_1:Boolean):void
        {
            if (this._autoBead != _arg_1)
            {
                this._autoBead = _arg_1;
                this.save();
            };
        }

        public function get edictumVersion():String
        {
            return (this._edictumVersion);
        }

        public function set edictumVersion(_arg_1:String):void
        {
            if (this._edictumVersion != _arg_1)
            {
                this._edictumVersion = _arg_1;
                this.save();
            };
        }

        public function get propLayerMode():int
        {
            if (PlayerManager.Instance.Self.Grade < 4)
            {
                return (FightPropMode.VERTICAL);
            };
            return (this._propLayerMode);
        }

        public function set propLayerMode(_arg_1:int):void
        {
            if (this._propLayerMode != _arg_1)
            {
                this._propLayerMode = _arg_1;
                this.save();
            };
        }

        public function set allowSnsSend(_arg_1:Boolean):void
        {
            if (this._allowSnsSend == _arg_1)
            {
                return;
            };
            this._allowSnsSend = _arg_1;
            this.save();
        }

        public function get showInvateWindow():Boolean
        {
            return (this._showInvateWindow);
        }

        public function set showInvateWindow(_arg_1:Boolean):void
        {
            this._showInvateWindow = _arg_1;
        }

        public function get isCommunity():Boolean
        {
            return (this._isCommunity);
        }

        public function set isCommunity(_arg_1:Boolean):void
        {
            this._isCommunity = _arg_1;
        }

        public function get isWishPop():Boolean
        {
            return (this._isWishPop);
        }

        public function set isWishPop(_arg_1:Boolean):void
        {
            this._isWishPop = _arg_1;
        }

        public function get isFirstWish():Boolean
        {
            return (this._isFirstWish);
        }

        public function set isFirstWish(_arg_1:Boolean):void
        {
            this._isFirstWish = _arg_1;
        }

        public function setup():void
        {
            this.load();
            if (LoadResourceManager.instance.isMicroClient)
            {
                LoadInterfaceManager.eventDispatcher.addEventListener(LoadInterfaceEvent.SET_SOUND, this.__setSound);
            };
        }

        private function __setSound(_arg_1:LoadInterfaceEvent):void
        {
            LoadInterfaceManager.traceMsg(("setSound:" + _arg_1.paras[0]));
            if (_arg_1.paras[0] == 1)
            {
                this.allowMusic = (this.allowSound = true);
            }
            else
            {
                this.allowMusic = (this.allowSound = false);
            };
            this.changed();
        }

        public function reset():void
        {
            var _local_1:SharedObject = SharedObject.getLocal("road");
            _local_1.clear();
            _local_1.flush(((20 * 0x0400) * 0x0400));
        }

        private function load():void
        {
            var so:SharedObject;
            var key:String;
            var keyII:String;
            var keyIII:String;
            var keyIV:String;
            var keyV:String;
            var keyP:String;
            var i:int;
            var j:int;
            var k:String;
            var id:String;
            var key1:String;
            var key2:String;
            var key3:String;
            var key4:String;
            var key5:String;
            var key6:String;
            var key7:String;
            var key8:String;
            try
            {
                so = SharedObject.getLocal("road");
                this.AuctionInfos = new Object();
                if (((so) && (so.data)))
                {
                    if (so.data["allowMusic"] != undefined)
                    {
                        this.allowMusic = so.data["allowMusic"];
                    };
                    if (so.data["allowSound"] != undefined)
                    {
                        this.allowSound = so.data["allowSound"];
                    };
                    if (so.data["showTopMessageBar"] != undefined)
                    {
                        this.showTopMessageBar = so.data["showTopMessageBar"];
                    };
                    if (so.data["showInvateWindow"] != undefined)
                    {
                        this.showInvateWindow = so.data["showInvateWindow"];
                    };
                    if (so.data["showParticle"] != undefined)
                    {
                        this.showParticle = so.data["showParticle"];
                    };
                    if (so.data["showOL"] != undefined)
                    {
                        this.showOL = so.data["showOL"];
                    };
                    if (so.data["showCI"] != undefined)
                    {
                        this.showCI = so.data["showCI"];
                    };
                    if (so.data["showHat"] != undefined)
                    {
                        this.showHat = so.data["showHat"];
                    };
                    if (so.data["showGlass"] != undefined)
                    {
                        this.showGlass = so.data["showGlass"];
                    };
                    if (so.data["showSuit"] != undefined)
                    {
                        this.showSuit = so.data["showSuit"];
                    };
                    if (so.data["fightModelPropCell"] != undefined)
                    {
                        this.fightModelPropCell = so.data["fightModelPropCell"];
                    };
                    if (so.data["fightModelPropCellSave"] != undefined)
                    {
                        this.fightModelPropCellSave = so.data["fightModelPropCellSave"];
                    };
                    if (so.data["rightPropBarType"] != undefined)
                    {
                        this.rightPropBarType = so.data["rightPropBarType"];
                    };
                    if (so.data["musicVolumn"] != undefined)
                    {
                        this.musicVolumn = so.data["musicVolumn"];
                    };
                    if (so.data["soundVolumn"] != undefined)
                    {
                        this.soundVolumn = so.data["soundVolumn"];
                    };
                    if (so.data["KeyAutoSnap"] != undefined)
                    {
                        this.KeyAutoSnap = so.data["KeyAutoSnap"];
                    };
                    if (so.data["cardSystemShow"] != undefined)
                    {
                        this.cardSystemShow = so.data["cardSystemShow"];
                    };
                    if (so.data["divorceBoolean"] != undefined)
                    {
                        this.divorceBoolean = so.data["divorceBoolean"];
                    };
                    if (so.data["friendBrithdayName"] != undefined)
                    {
                        this.friendBrithdayName = so.data["friendBrithdayName"];
                    };
                    if (so.data["AutoReady"] != undefined)
                    {
                        this.AutoReady = so.data["AutoReady"];
                    };
                    if (so.data["ShowBattleGuide"] != undefined)
                    {
                        this.ShowBattleGuide = so.data["ShowBattleGuide"];
                    };
                    if (so.data["isHintPropExpire"] != undefined)
                    {
                        this.isHintPropExpire = so.data["isHintPropExpire"];
                    };
                    if (so.data["hasCheckedOverFrameRate"] != undefined)
                    {
                        this.hasCheckedOverFrameRate = so.data["hasCheckedOverFrameRate"];
                    };
                    if (so.data["isRecommend"] != undefined)
                    {
                        this.isRecommend = so.data["isRecommend"];
                    };
                    if (so.data["recommendNum"] != undefined)
                    {
                        this.recommendNum = so.data["recommendNum"];
                    };
                    if (so.data["isSetingMovieClip"] != undefined)
                    {
                        this.isSetingMovieClip = so.data["isSetingMovieClip"];
                    };
                    if (so.data["propLayerMode"] != undefined)
                    {
                        this._propLayerMode = so.data["propLayerMode"];
                    };
                    if (so.data["autoCaddy"] != undefined)
                    {
                        this._autoCaddy = so.data["autoCaddy"];
                    };
                    if (so.data["autoOfferPack"] != undefined)
                    {
                        this._autoOfferPack = so.data["autoOfferPack"];
                    };
                    if (so.data["autoBead"] != undefined)
                    {
                        this._autoBead = so.data["autoBead"];
                    };
                    if (so.data["edictumVersion"] != undefined)
                    {
                        this._edictumVersion = so.data["edictumVersion"];
                    };
                    if (so.data["isFirstWish"] != undefined)
                    {
                        this._isFirstWish = so.data["isFirstWish"];
                    };
                    if (so.data["stoneFriend"] != undefined)
                    {
                        this.stoneFriend = so.data["stoneFriend"];
                    };
                    if (so.data["hijackCarFilter"] != undefined)
                    {
                        this.hijackCarFilter = so.data["hijackCarFilter"];
                    };
                    if (so.data["hasShowUpdateFrame"] != undefined)
                    {
                        this.hasShowUpdateFrame = so.data["hasShowUpdateFrame"];
                    };
                    if (so.data["showUpdateFrameDate"] != undefined)
                    {
                        this.showUpdateFrameDate = so.data["showUpdateFrameDate"];
                    };
                    if (so.data["hasStrength3"] != undefined)
                    {
                        for (key in so.data["hasStrength3"])
                        {
                            this.hasStrength3[key] = so.data["hasStrength3"][key];
                        };
                    };
                    if (so.data["recentContactsID"] != undefined)
                    {
                        for (keyII in so.data["recentContactsID"])
                        {
                            this.recentContactsID[keyII] = so.data["recentContactsID"][keyII];
                        };
                    };
                    if (so.data["voteData"] != undefined)
                    {
                        for (keyIII in so.data["voteData"])
                        {
                            this.voteData[keyIII] = so.data["voteData"][keyIII];
                        };
                    };
                    if (so.data["spacialReadedMail"] != undefined)
                    {
                        for (keyIV in so.data["spacialReadedMail"])
                        {
                            this.spacialReadedMail[keyIV] = so.data["spacialReadedMail"][keyIV];
                        };
                    };
                    if (so.data["deleteMail"] != undefined)
                    {
                        for (keyV in so.data["deleteMail"])
                        {
                            this.deleteMail[keyV] = so.data["deleteMail"][keyV];
                        };
                    };
                    if (so.data["privateChatRecord"] != undefined)
                    {
                        for (keyP in so.data["privateChatRecord"])
                        {
                            this.privateChatRecord[keyP] = so.data["privateChatRecord"][keyP];
                        };
                    };
                    if (so.data["GameKeySets"] != undefined)
                    {
                        i = 1;
                        while (i < (KEY_SET_ABLE.length + 1))
                        {
                            this.GameKeySets[String(i)] = so.data["GameKeySets"][String(i)];
                            i = (i + 1);
                        };
                    }
                    else
                    {
                        j = 0;
                        while (j < KEY_SET_ABLE.length)
                        {
                            this.GameKeySets[String((j + 1))] = KEY_SET_ABLE[j];
                            j = (j + 1);
                        };
                    };
                    if (so.data["AuctionInfos"] != undefined)
                    {
                        for (k in so.data["AuctionInfos"])
                        {
                            this.AuctionInfos[k] = so.data["AuctionInfos"][k];
                        };
                    };
                    if (so.data["AuctionIDs"] != undefined)
                    {
                        this.AuctionIDs = so.data["AuctionIDs"];
                        for (id in so.data["AuctionInfos"])
                        {
                            this.AuctionIDs[id] = so.data["AuctionInfos"][id];
                        };
                    };
                    if (so.data[("setBagLocked" + PlayerManager.Instance.Self.ID)] != undefined)
                    {
                        this.setBagLocked = so.data["setBagLocked"];
                    };
                    if (so.data["StoreBuyInfo"] != undefined)
                    {
                        for (key1 in so.data["StoreBuyInfo"])
                        {
                            this.StoreBuyInfo[key1] = so.data["StoreBuyInfo"][key1];
                        };
                    };
                    if (so.data["hasEnteredFightLib"] != undefined)
                    {
                        for (key2 in so.data["hasEnteredFightLib"])
                        {
                            this.hasEnteredFightLib[key2] = so.data["hasEnteredFightLib"][key2];
                        };
                    };
                    if (so.data["isAffirm"] != this.isAffirm)
                    {
                        this.isAffirm = so.data["isAffirm"];
                    };
                    if (so.data["fastReplys"] != undefined)
                    {
                        for (key3 in so.data["fastReplys"])
                        {
                            this.fastReplys[key3] = so.data["fastReplys"][key3];
                        };
                    };
                    if (so.data["autoSnsSend"] != undefined)
                    {
                        this._autoSnsSend = so.data["autoSnsSend"];
                    };
                    if (so.data["allowSnsSend"] != undefined)
                    {
                        this._allowSnsSend = so.data["allowSnsSend"];
                    };
                    if (so.data["AwayAutoReply"] != undefined)
                    {
                        for (key4 in so.data["AwayAutoReply"])
                        {
                            this.awayAutoReply[key4] = so.data["AwayAutoReply"][key4];
                        };
                    };
                    if (so.data["BusyAutoReply"] != undefined)
                    {
                        for (key5 in so.data["BusyAutoReply"])
                        {
                            this.busyAutoReply[key5] = so.data["BusyAutoReply"][key5];
                        };
                    };
                    if (so.data["NoDistrubAutoReply"] != undefined)
                    {
                        for (key6 in so.data["NoDistrubAutoReply"])
                        {
                            this.noDistrubAutoReply[key6] = so.data["NoDistrubAutoReply"][key6];
                        };
                    };
                    if (so.data["ShoppingAutoReply"] != undefined)
                    {
                        for (key7 in so.data["ShoppingAutoReply"])
                        {
                            this.shoppingAutoReply[key7] = so.data["ShoppingAutoReply"][key7];
                        };
                    };
                    if (so.data["isCommunity"] != undefined)
                    {
                        this.isCommunity = so.data["isCommunity"];
                    };
                    if (so.data["isWishPop"] != undefined)
                    {
                        this.isWishPop = so.data["isWishPop"];
                    };
                    if (so.data["autoWish"] != undefined)
                    {
                        this.autoWish = so.data["autoWish"];
                    };
                    if (so.data["isRefreshPet"] != undefined)
                    {
                        this.isRefreshPet = so.data["isRefreshPet"];
                    };
                    if (so.data["firstOpenMission"] != undefined)
                    {
                        for (key8 in so.data["firstOpenMission"])
                        {
                            this.firstOpenMission[key8] = so.data["firstOpenMission"][key8];
                        };
                    };
                    if (so.data["beadFirstShow"] != undefined)
                    {
                        this.beadFirstShow = so.data["beadFirstShow"];
                    };
                    if (so.data["mouseModel"] != undefined)
                    {
                        this.mouseModel = so.data["mouseModel"];
                    };
                    if (so.data["isAddedToFavorite"] != undefined)
                    {
                        this.isAddedToFavorite = so.data["isAddedToFavorite"];
                    };
                    if (so.data["totemSystemShow"] != undefined)
                    {
                        this.totemSystemShow = so.data["totemSystemShow"];
                    };
                    if (so.data["showMouseModelLeadFight"] != undefined)
                    {
                        this.showMouseModelLeadFight = so.data["showMouseModelLeadFight"];
                    };
                    if (so.data["showLastPowerPointTips"] != undefined)
                    {
                        this.showLastPowerPointTips = so.data["showLastPowerPointTips"];
                    };
                    if (so.data["showMouseModelLeadMove"] != undefined)
                    {
                        this.showMouseModelLeadMove = so.data["showMouseModelLeadMove"];
                    };
                    if (so.data["maplistIndex"] != undefined)
                    {
                        this.maplistIndex = so.data["maplistIndex"];
                    };
                    if (so.data["capabilityNotice"] != undefined)
                    {
                        this.capabilityNotice = so.data["capabilityNotice"];
                    };
                    if (so.data["showVipCheckBtn"] != undefined)
                    {
                        this._showVipCheckBtn = so.data["showVipCheckBtn"];
                    };
                    if (so.data["isShowMultiAlert"] != undefined)
                    {
                        this.isShowMultiAlert = so.data["isShowMultiAlert"];
                    };
                    if (so.data["chatOutPutType"] != undefined)
                    {
                        this._chatOutPutType = so.data["chatOutPutType"];
                    };
                    if (so.data["turnPlateShowChatBall"] != undefined)
                    {
                        this.turnPlateShowChatBall = so.data["turnPlateShowChatBall"];
                    };
                    if (so.data["coolDownFightRobot"] != undefined)
                    {
                        this.coolDownFightRobot = so.data["coolDownFightRobot"];
                    };
                };
            }
            catch(e:Error)
            {
            }
            finally
            {
                this.changed();
            };
        }

        public function save():void
        {
            var _local_1:SharedObject;
            var _local_2:Object;
            var _local_3:String;
            try
            {
                _local_1 = SharedObject.getLocal("road");
                _local_1.data["allowMusic"] = this.allowMusic;
                _local_1.data["allowSound"] = this.allowSound;
                _local_1.data["showTopMessageBar"] = this.showTopMessageBar;
                _local_1.data["showInvateWindow"] = this.showInvateWindow;
                _local_1.data["showParticle"] = this.showParticle;
                _local_1.data["showOL"] = this.showOL;
                _local_1.data["showCI"] = this.showCI;
                _local_1.data["showHat"] = this.showHat;
                _local_1.data["showGlass"] = this.showGlass;
                _local_1.data["showSuit"] = this.showSuit;
                _local_1.data["fightModelPropCell"] = this.fightModelPropCell;
                _local_1.data["fightModelPropCellSave"] = this.fightModelPropCellSave;
                _local_1.data["rightPropBarType"] = this.rightPropBarType;
                _local_1.data["musicVolumn"] = this.musicVolumn;
                _local_1.data["soundVolumn"] = this.soundVolumn;
                _local_1.data["KeyAutoSnap"] = this.KeyAutoSnap;
                _local_1.data["cardSystemShow"] = this.cardSystemShow;
                _local_1.data["divorceBoolean"] = this.divorceBoolean;
                _local_1.data["friendBrithdayName"] = this.friendBrithdayName;
                _local_1.data["AutoReady"] = this.AutoReady;
                _local_1.data["ShowBattleGuide"] = this.ShowBattleGuide;
                _local_1.data["isHintPropExpire"] = this.isHintPropExpire;
                _local_1.data["hasCheckedOverFrameRate"] = this.hasCheckedOverFrameRate;
                _local_1.data["isAffirm"] = this.isAffirm;
                _local_1.data["isRecommend"] = this.isRecommend;
                _local_1.data["recommendNum"] = this.recommendNum;
                _local_1.data["isSetingMovieClip"] = this.isSetingMovieClip;
                _local_1.data["propLayerMode"] = this.propLayerMode;
                _local_1.data["autoCaddy"] = this._autoCaddy;
                _local_1.data["autoOfferPack"] = this._autoOfferPack;
                _local_1.data["autoBead"] = this._autoBead;
                _local_1.data["edictumVersion"] = this._edictumVersion;
                _local_1.data["stoneFriend"] = this.stoneFriend;
                _local_1.data["hijackCarFilter"] = this.hijackCarFilter;
                _local_1.data["hasShowUpdateFrame"] = this.hasShowUpdateFrame;
                _local_1.data["showUpdateFrameDate"] = this.showUpdateFrameDate;
                _local_2 = {};
                for (_local_3 in this.GameKeySets)
                {
                    _local_2[_local_3] = this.GameKeySets[_local_3];
                };
                _local_1.data["GameKeySets"] = _local_2;
                if (this.AuctionInfos)
                {
                    _local_1.data["AuctionInfos"] = this.AuctionInfos;
                };
                if (this.hasStrength3)
                {
                    _local_1.data["hasStrength3"] = this.hasStrength3;
                };
                if (this.recentContactsID)
                {
                    _local_1.data["recentContactsID"] = this.recentContactsID;
                };
                if (this.voteData)
                {
                    _local_1.data["voteData"] = this.voteData;
                };
                if (this.spacialReadedMail)
                {
                    _local_1.data["spacialReadedMail"] = this.spacialReadedMail;
                };
                if (this.deleteMail)
                {
                    _local_1.data["deleteMail"] = this.deleteMail;
                };
                if (this.privateChatRecord)
                {
                    _local_1.data["privateChatRecord"] = this.privateChatRecord;
                };
                if (this.hasEnteredFightLib)
                {
                    _local_1.data["hasEnteredFightLib"] = this.hasEnteredFightLib;
                };
                if (this.fastReplys)
                {
                    _local_1.data["fastReplys"] = this.fastReplys;
                };
                if (this.autoWish)
                {
                    _local_1.data["autoWish"] = this.autoWish;
                };
                if (this.isRefreshPet)
                {
                    _local_1.data["isRefreshPet"] = this.isRefreshPet;
                };
                _local_1.data["AuctionIDs"] = this.AuctionIDs;
                _local_1.data["setBagLocked"] = this.setBagLocked;
                _local_1.data["StoreBuyInfo"] = this.StoreBuyInfo;
                _local_1.data["autoSnsSend"] = this._autoSnsSend;
                _local_1.data["allowSnsSend"] = this._allowSnsSend;
                _local_1.data["AwayAutoReply"] = this.awayAutoReply;
                _local_1.data["BusyAutoReply"] = this.busyAutoReply;
                _local_1.data["NoDistrubAutoReply"] = this.noDistrubAutoReply;
                _local_1.data["ShoppingAutoReply"] = this.shoppingAutoReply;
                _local_1.data["isCommunity"] = this.isCommunity;
                _local_1.data["isWishPop"] = this.isWishPop;
                _local_1.data["isFirstWish"] = this.isFirstWish;
                _local_1.data["firstOpenMission"] = this.firstOpenMission;
                _local_1.data["beadFirstShow"] = this.beadFirstShow;
                _local_1.data["mouseModel"] = this.mouseModel;
                _local_1.data["isAddedToFavorite"] = this.isAddedToFavorite;
                _local_1.data["isAddedToFavorite"] = this.isAddedToFavorite;
                _local_1.data["totemSystemShow"] = this.totemSystemShow;
                _local_1.data["showMouseModelLeadFight"] = this.showMouseModelLeadFight;
                _local_1.data["showLastPowerPointTips"] = this.showLastPowerPointTips;
                _local_1.data["showMouseModelLeadMove"] = this.showMouseModelLeadMove;
                _local_1.data["maplistIndex"] = this.maplistIndex;
                _local_1.data["capabilityNotice"] = this.capabilityNotice;
                _local_1.data["showVipCheckBtn"] = this._showVipCheckBtn;
                _local_1.data["isShowMultiAlert"] = this.isShowMultiAlert;
                _local_1.data["chatOutPutType"] = this.chatOutPutType;
                _local_1.data["turnPlateShowChatBall"] = this.turnPlateShowChatBall;
                _local_1.data["coolDownFightRobot"] = this.coolDownFightRobot;
                _local_1.flush(((20 * 0x0400) * 0x0400));
                _local_1.flush(((20 * 0x0400) * 0x0400));
            }
            catch(e:Error)
            {
            };
            this.changed();
            LoadInterfaceManager.setSound((((this.allowMusic) || (this.allowSound)) ? "1" : "0"));
        }

        public function changed():void
        {
            var _local_1:String;
            SoundManager.instance.setConfig(this.allowMusic, this.allowSound, this.musicVolumn, this.soundVolumn);
            for (_local_1 in this.GameKeySets)
            {
                if (RIGHT_PROP[int((int(_local_1) - 1))])
                {
                    RIGHT_PROP[int((int(_local_1) - 1))] = this.GameKeySets[_local_1];
                };
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        public function set propTransparent(_arg_1:Boolean):void
        {
            if (this._propTransparent != _arg_1)
            {
                this._propTransparent = _arg_1;
                dispatchEvent(new SharedEvent(SharedEvent.TRANSPARENTCHANGED));
            };
        }

        public function get propTransparent():Boolean
        {
            return (this._propTransparent);
        }

        public function get chatOutPutType():Object
        {
            return (this._chatOutPutType);
        }

        public function setChatOutPutType(_arg_1:int, _arg_2:Boolean):void
        {
            this._chatOutPutType[_arg_1] = _arg_2;
            this.save();
        }


    }
}//package ddt.manager

