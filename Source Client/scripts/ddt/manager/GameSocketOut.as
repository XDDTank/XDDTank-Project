package ddt.manager
{
   import SingleDungeon.model.MiningPackageType;
   import SingleDungeon.model.WalkSencePackageType;
   import arena.model.ArenaPackageTypes;
   import baglocked.BagLockedController;
   import bead.BeadPackageType;
   import consortion.data.ConsortiaMonsterPackageTypes;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.socket.AcademyPackageType;
   import ddt.data.socket.ChurchPackageType;
   import ddt.data.socket.ConsortiaPackageType;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.DailyQuestPackageType;
   import ddt.data.socket.EquipSystemPackageType;
   import ddt.data.socket.ExpeditionType;
   import ddt.data.socket.FarmPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.HotSpringPackageType;
   import ddt.data.socket.IMPackageType;
   import ddt.data.socket.PetPackageType;
   import ddt.data.socket.TurnPlatePackageType;
   import ddt.data.socket.ePackageType;
   import ddt.utils.CrytoUtils;
   import email.manager.MailManager;
   import fightRobot.FightRobotPackageType;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   import road7th.math.randRange;
   import totem.data.TotemPackageType;
   import worldboss.model.WorldBossGamePackageType;
   
   public class GameSocketOut
   {
       
      
      private var _socket:ByteSocket;
      
      public function GameSocketOut(param1:ByteSocket)
      {
         super();
         this._socket = param1;
      }
      
      public function sendDomainNameAndPort() : void
      {
         var _loc1_:String = ServerManager.Instance.current.IP;
         var _loc2_:String = String(ServerManager.Instance.current.Port);
         this._socket.sendByteArrayString("tgw_l7_forward\r\nHost:" + _loc1_ + ":" + _loc2_ + "\r\n\r\n");
      }
      
      public function sendLogin(param1:AccountInfo) : void
      {
         var _loc3_:ByteArray = null;
         var _loc8_:int = 0;
         this._socket.resetKey();
         var _loc2_:Date = new Date();
         _loc3_ = new ByteArray();
         var _loc4_:int = randRange(100,10000);
         _loc3_.writeShort(_loc2_.fullYearUTC);
         _loc3_.writeByte(_loc2_.monthUTC + 1);
         _loc3_.writeByte(_loc2_.dateUTC);
         _loc3_.writeByte(_loc2_.hoursUTC);
         _loc3_.writeByte(_loc2_.minutesUTC);
         _loc3_.writeByte(_loc2_.secondsUTC);
         var _loc5_:Array = [Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255)];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc3_.writeByte(_loc5_[_loc6_]);
            _loc6_++;
         }
         _loc3_.writeUTFBytes(param1.Account + "," + param1.Password);
         _loc3_ = CrytoUtils.rsaEncry5(param1.Key,_loc3_);
         _loc3_.position = 0;
         var _loc7_:PackageOut = new PackageOut(ePackageType.LOGIN);
         _loc7_.writeInt(Version.Build);
         _loc7_.writeInt(DesktopManager.Instance.desktopType);
         _loc7_.writeUTF(Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
         _loc7_.writeBytes(_loc3_);
         this.sendPackage(_loc7_);
         this._socket.setKey(_loc5_);
         while(_loc8_ < _loc5_.length)
         {
            _loc8_++;
         }
      }
      
      public function sendWeeklyClick() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WEEKLY_CLICK_CNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendGameLogin(param1:int, param2:int, param3:int = -1, param4:String = "", param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc6_.writeInt(GameRoomPackageType.GAME_ROOM_LOGIN);
         _loc6_.writeBoolean(param5);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         if(param2 == -1)
         {
            _loc6_.writeInt(param3);
            _loc6_.writeUTF(param4);
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendSceneLogin(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_LOGIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGameStyle(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDiamondAward(param1:int, param2:int = 0) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.DIAMOND_AWARD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBuyGoods(param1:Array, param2:Array, param3:Array, param4:Array, param5:Array, param6:Array = null, param7:int = 0, param8:Array = null) : void
      {
         if(param1.length > 50)
         {
            this.sendBuyGoods(param1.splice(0,50),param2.splice(0,50),param3.splice(0,50),param4.splice(0,50),param5.splice(0,50),param6 == null ? null : param6.splice(0,50),param7,param8 == null ? null : param8);
            this.sendBuyGoods(param1,param2,param3,param4,param5,param6,param7,param8);
            return;
         }
         var _loc9_:PackageOut = new PackageOut(ePackageType.BUY_GOODS);
         var _loc10_:int = param1.length;
         _loc9_.writeInt(_loc10_);
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_)
         {
            if(!param8)
            {
               _loc9_.writeInt(1);
            }
            else
            {
               _loc9_.writeInt(param8[_loc11_]);
            }
            _loc9_.writeInt(param1[_loc11_]);
            _loc9_.writeInt(param2[_loc11_]);
            _loc9_.writeUTF(param3[_loc11_]);
            _loc9_.writeBoolean(param5[_loc11_]);
            if(param6 == null)
            {
               _loc9_.writeUTF("");
            }
            else
            {
               _loc9_.writeUTF(param6[_loc11_]);
            }
            _loc9_.writeInt(param4[_loc11_]);
            _loc11_++;
         }
         _loc9_.writeInt(param7);
         this.sendPackage(_loc9_);
      }
      
      public function sendBuyProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSellProp(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuickBuyGoldBox(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BUY_QUICK_GOLDBOX);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGiftBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BUY_GIFTBAG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPresentGoods(param1:Array, param2:Array, param3:Array, param4:Array, param5:String, param6:String, param7:Array = null) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.GOODS_PRESENT);
         var _loc9_:int = param1.length;
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeInt(_loc9_);
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_.writeInt(param1[_loc10_]);
            _loc8_.writeInt(param2[_loc10_]);
            _loc8_.writeUTF(param3[_loc10_]);
            if(param7 == null)
            {
               _loc8_.writeUTF("");
            }
            else
            {
               _loc8_.writeUTF(param7[_loc10_]);
            }
            _loc8_.writeInt(param4[_loc10_]);
            _loc10_++;
         }
         this.sendPackage(_loc8_);
      }
      
      public function sendGoodsContinue(param1:Array) : void
      {
         var _loc2_:int = param1.length;
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_CONTINUE);
         _loc3_.writeInt(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeByte(param1[_loc4_][0]);
            _loc3_.writeInt(param1[_loc4_][1]);
            _loc3_.writeInt(param1[_loc4_][2]);
            _loc3_.writeByte(param1[_loc4_][3]);
            _loc3_.writeBoolean(param1[_loc4_][4]);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendSellGoods(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEll_GOODS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateGoodsCount() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GOODS_COUNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendEmail(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEND_MAIL);
         _loc2_.writeUTF(param1.NickName);
         _loc2_.writeUTF(param1.Title);
         _loc2_.writeUTF(param1.Content);
         _loc2_.writeBoolean(param1.isPay);
         _loc2_.writeInt(param1.hours);
         _loc2_.writeInt(param1.SendedMoney);
         while(_loc3_ < MailManager.Instance.NUM_OF_WRITING_DIAMONDS)
         {
            if(param1["Annex" + _loc3_])
            {
               _loc2_.writeByte(param1["Annex" + _loc3_].split(",")[0]);
               _loc2_.writeInt(param1["Annex" + _loc3_].split(",")[1]);
               _loc2_.writeInt(param1.Count);
            }
            else
            {
               _loc2_.writeByte(0);
               _loc2_.writeInt(-1);
               _loc2_.writeInt(0);
            }
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateMail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.UPDATE_MAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDeleteMail(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DELETE_MAIL);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_].ID);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function untreadEmail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MAIL_CANCEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetMail(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GET_MAIL_ATTACHMENT);
         _loc3_.writeInt(param1);
         _loc3_.writeByte(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPint() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PING);
         this.sendPackage(_loc1_);
      }
      
      public function sendSuicide(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.SUICIDE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendKillSelf(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.KILLSELF);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemCompose(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc4_.writeByte(EquipSystemPackageType.COMPOSE);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemSplite(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc3_.writeByte(EquipSystemPackageType.SPLITE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemTransfer(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_TRANSFER);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemStrength(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_STRENGTHEN);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemLianhua(param1:int, param2:int, param3:Array, param4:int, param5:int, param6:int, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.ITEM_REFINERY);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         var _loc9_:int = 0;
         while(_loc9_ < param3.length)
         {
            _loc8_.writeInt(param3[_loc9_]);
            _loc9_++;
         }
         _loc8_.writeInt(param4);
         _loc8_.writeInt(param5);
         _loc8_.writeInt(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendOpenEmbedHole(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc2_.writeByte(EquipSystemPackageType.HOLE_EQUIP);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemEmbed(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc4_.writeByte(EquipSystemPackageType.MOSAIC_EQUIP);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendBeadMove(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc3_.writeByte(BeadPackageType.BEAD_MOVE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBeadCombine(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc4_.writeByte(BeadPackageType.BEAD_COMBINE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeByte(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendBeadLock(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc2_.writeByte(BeadPackageType.BEAD_LOCK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadCombineOneKey(param1:int = 1) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc2_.writeByte(BeadPackageType.BEAD_COMBINE_ONEKEY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadSellBead(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc2_.writeByte(BeadPackageType.BEAD_SELL_BEAD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadGetBead(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc2_.writeByte(BeadPackageType.BEAD_GET_BEAD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadRequestBead(param1:int, param2:Boolean = false, param3:int = 2) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc4_.writeByte(BeadPackageType.BEAD_REQUEST_BEAD);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendBeadDiscardBead(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc2_.writeByte(BeadPackageType.BEAD_DISCARD_BEAD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadExchangeBead(param1:int, param2:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc3_.writeByte(BeadPackageType.BEAD_EXCHANGE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBeadBuyOneKey(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc2_.writeByte(BeadPackageType.BEAD_BUY_ONEKEY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadSplit() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc1_.writeByte(BeadPackageType.BEAD_SPLIT);
         this.sendPackage(_loc1_);
      }
      
      public function sendBeadSell() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
         _loc1_.writeByte(BeadPackageType.BEAD_SELL);
         this.sendPackage(_loc1_);
      }
      
      public function sendItemEmbedBackout(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_EMBED_BACKOUT);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemOpenFiveSixHole(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.OPEN_FIVE_SIX_HOLE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemTrend(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.ITEM_TREND);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeInt(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendClearStoreBag() : void
      {
         PlayerManager.Instance.Self.StoreBag.items.clear();
         var _loc1_:PackageOut = new PackageOut(ePackageType.CLEAR_STORE_BAG);
         this.sendPackage(_loc1_);
      }
      
      public function sendCheckCode(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CHECK_CODE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSBugle(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.S_BUGLE);
         _loc2_.writeInt(PlayerManager.Instance.Self.ID);
         _loc2_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBBugle(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.B_BUGLE);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(PlayerManager.Instance.Self.ID);
         _loc3_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc3_.writeUTF(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendCBugle(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.C_BUGLE);
         _loc2_.writeInt(PlayerManager.Instance.Self.ID);
         _loc2_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDefyAffiche(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DEFY_AFFICHE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGameMode(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAddFriend(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(param1 == "")
         {
            return;
         }
         var _loc5_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc5_.writeByte(IMPackageType.FRIEND_ADD);
         _loc5_.writeUTF(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeBoolean(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendDelFriend(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc2_.writeByte(IMPackageType.FRIEND_REMOVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendFriendState(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc2_.writeByte(IMPackageType.FRIEND_STATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBagLocked(param1:String, param2:int, param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:String = "") : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
         BagLockedController.TEMP_PWD = param3 != "" ? param3 : param1;
         _loc8_.writeUTF(param1);
         _loc8_.writeUTF(param3);
         _loc8_.writeInt(param2);
         _loc8_.writeUTF(param4);
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeUTF(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendBagLockedII(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
      }
      
      public function sendConsortiaEquipConstrol(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendErrorMsg(param1:String) : void
      {
         var _loc2_:PackageOut = null;
         if(param1.length < 1000)
         {
            _loc2_ = new PackageOut(ePackageType.CLIENT_LOG);
            _loc2_.writeUTF(param1);
         }
      }
      
      public function sendItemOverDue(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_OVERDUE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendHideLayer(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_HIDE);
         _loc3_.writeBoolean(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestAdd(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestRemove(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_REMOVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestFinish(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.QUEST_FINISH);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestOneToFinish(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_ONEKEYFINISH);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendImproveQuest(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_LEVEL_UP);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestCheck(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.QUEST_CHECK);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemOpenUp(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ITEM_OPENUP);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemEquip(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_EQUIP);
         if(!param2)
         {
            _loc3_.writeBoolean(true);
            _loc3_.writeInt(param1);
         }
         else if(param2)
         {
            _loc3_.writeBoolean(false);
            _loc3_.writeUTF(param1);
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendMateTime(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MATE_ONLINE_TIME);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function auctionGood(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.AUCTION_ADD);
         _loc8_.writeByte(param1);
         _loc8_.writeInt(param2);
         _loc8_.writeByte(param3);
         _loc8_.writeInt(param4);
         _loc8_.writeInt(param5);
         _loc8_.writeInt(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function auctionCancelSell(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.AUCTION_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function auctionBid(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.AUCTION_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function syncStep(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         _loc3_.writeByte(1);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function syncWeakStep(param1:int) : void
      {
      }
      
      public function sendCreateConsortia(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_CREATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryIn(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaCancelTryIn() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         _loc1_.writeInt(0);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaInvate(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReleaseConsortiaTask(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TASK_RELEASE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaInvatePass(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_PASS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaInvateDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdateDescription(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdatePlacard(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdateDuty(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc4_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         _loc4_.writeInt(param1);
         _loc4_.writeByte(param1 == -1 ? int(1) : int(2));
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendConsortiaUpgradeDuty(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeByte(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsoritaApplyStatusOut(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_APPLY_STATE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_RENEGADE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaMemberGrade(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaUserRemarkUpdate(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaDutyDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryinPass(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_PASS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryinDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_DEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendForbidSpeak(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaDismiss() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_DISBAND);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaChangeChairman(param1:String = "") : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaRichOffer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDonate(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.DONATE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaLevelUp() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_LEVEL_UP);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaShopUp() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_SHOP_UP);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaHallUp() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_HALL_UP);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaSkillUp() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_SKILL_UP);
         this.sendPackage(_loc1_);
      }
      
      public function sendAirPlane() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.AIRPLANE);
         this.sendPackage(_loc1_);
      }
      
      public function useDeputyWeapon() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.USE_DEPUTY_WEAPON);
         this.sendPackage(_loc1_);
      }
      
      public function sendUseFightKitSkill(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.FIGHT_KIT_SKILL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGamePick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.PICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPetSkill(param1:int, param2:int = -1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.PET_SKILL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPackage(param1:PackageOut) : void
      {
         this._socket.send(param1);
      }
      
      public function sendMoveGoods(param1:int, param2:int, param3:int, param4:int, param5:int = 1, param6:Boolean = false) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS);
         _loc7_.writeByte(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeByte(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeBoolean(param6);
         this.sendPackage(_loc7_);
      }
      
      public function reclaimGoods(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.REClAIM_GOODS);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendMoveGoodsAll(param1:int, param2:Array, param3:int, param4:Boolean = false) : void
      {
         if(param2.length <= 0)
         {
            return;
         }
         var _loc5_:int = param2.length;
         var _loc6_:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS_ALL);
         _loc6_.writeBoolean(param4);
         _loc6_.writeInt(_loc5_);
         _loc6_.writeInt(param1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_.writeInt(param2[_loc7_].Place);
            _loc6_.writeInt(_loc7_ + param3);
            _loc7_++;
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendForSwitch() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ENTHRALL_SWITCH);
         this.sendPackage(_loc1_);
      }
      
      public function sendCIDCheck() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         this.sendPackage(_loc1_);
      }
      
      public function sendCIDInfo(param1:String, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         _loc3_.writeBoolean(false);
         _loc3_.writeUTF(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeColor(param1:int, param2:int, param3:int, param4:int, param5:String, param6:String, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.USE_COLOR_CARD);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         _loc8_.writeInt(param3);
         _loc8_.writeInt(param4);
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendUseCard(param1:int, param2:int, param3:Array, param4:int, param5:Boolean = false, param6:int = 1) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.CARD_USE);
         _loc7_.writeInt(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeInt(param3[0]);
         _loc7_.writeInt(param6);
         _loc7_.writeInt(param4);
         _loc7_.writeBoolean(param5);
         this.sendPackage(_loc7_);
      }
      
      public function sendUseProp(param1:int, param2:int, param3:Array, param4:int, param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.PROP_USE);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3.length);
         var _loc7_:int = param3.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_.writeInt(param3[_loc8_]);
            _loc8_++;
         }
         _loc6_.writeInt(param4);
         _loc6_.writeBoolean(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendUseChangeColorShell(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USE_CHANGE_COLOR_SHELL);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeColorShellTimeOver(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CHANGE_COLOR_OVER_DUE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRouletteBox(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendFinishRoulette() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LOTTERY_FINISH);
         this.sendPackage(_loc1_);
      }
      
      public function sendSellAll() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CADDY_SELL_ALL_GOODS);
         this.sendPackage(_loc1_);
      }
      
      public function sendconverted(param1:Boolean, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CADDY_CONVERTED_ALL);
         _loc4_.writeBoolean(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendExchange() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CADDY_EXCHANGE_ALL);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenDead(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendRequestAwards(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CADDY_GET_AWARDS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQequestBadLuck(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CADDY_GET_BADLUCK);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUseReworkName(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.USE_REWORK_NAME);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUseConsortiaReworkName(param1:int, param2:int, param3:int, param4:String) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.USE_CONSORTIA_REWORK_NAME);
         _loc5_.writeInt(param1);
         _loc5_.writeByte(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeUTF(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendValidateMarry(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_STATUS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPropose(param1:int, param2:String, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_APPLY);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendProposeRespose(param1:Boolean, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_APPLY_REPLY);
         _loc4_.writeBoolean(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUnmarry(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DIVORCE_APPLY);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendMarryRoomLogin() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_LOGIN);
         this.sendPackage(_loc1_);
      }
      
      public function sendExitMarryRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         this.sendPackage(_loc1_);
      }
      
      public function sendCreateRoom(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:String) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_CREATE);
         _loc7_.writeUTF(param1);
         _loc7_.writeUTF(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(100);
         _loc7_.writeBoolean(param5);
         _loc7_.writeUTF(param6);
         this.sendPackage(_loc7_);
      }
      
      public function sendEnterRoom(param1:int, param2:String, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_LOGIN);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendExitRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PLAYER_EXIT_MARRY_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function sendCurrentState(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_STATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateRoomList(param1:int, param2:int, param3:int = 10000, param4:int = 1011) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.ROOMLIST_UPDATE);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         if(param1 == 2 && param2 == -2)
         {
            _loc5_.writeInt(param3);
            _loc5_.writeInt(param4);
         }
         this.sendPackage(_loc5_);
      }
      
      public function sendChurchMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc4_.writeByte(ChurchPackageType.MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendStartWedding() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.HYMENEAL);
         this.sendPackage(_loc1_);
      }
      
      public function sendChurchContinuation(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.CONTINUATION);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchInvite(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.INVITE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchLargess(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.LARGESS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function refund() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         _loc1_.writeByte(ChurchPackageType.CLIENTCONFIRM);
         this.sendPackage(_loc1_);
      }
      
      public function requestRefund() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         _loc1_.writeByte(ChurchPackageType.BEGINSENDGIFT);
         this.sendPackage(_loc1_);
      }
      
      public function sendUseFire(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.USEFIRECRACKERS);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChurchKick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.KICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchMovieOver(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CHURCH_MOVIE_OVER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChurchForbid(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.FORBID);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.POSITION);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendModifyChurchDiscription(param1:String, param2:Boolean, param3:String, param4:String) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_INFO_UPDATE);
         _loc5_.writeUTF(param1);
         _loc5_.writeBoolean(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeUTF(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendSceneChange(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_CHANGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGunSalute(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.GUNSALUTE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRegisterInfo(param1:int, param2:Boolean, param3:String = null) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRYINFO_ADD);
         _loc4_.writeBoolean(param2);
         _loc4_.writeUTF(param3);
         _loc4_.writeInt(param1);
         this.sendPackage(_loc4_);
      }
      
      public function sendModifyInfo(param1:Boolean, param2:String = null) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRYINFO_UPDATE);
         _loc3_.writeBoolean(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendForMarryInfo(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRYINFO_GET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetLinkGoodsInfo(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendGetTropToBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function createUserGuide(param1:int = 10) : void
      {
         var _loc2_:String = String(Math.random());
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc3_.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         _loc3_.writeByte(param1);
         _loc3_.writeByte(3);
         _loc3_.writeUTF("");
         _loc3_.writeUTF(_loc2_);
         this.sendPackage(_loc3_);
      }
      
      public function enterUserGuide(param1:int, param2:int = 10) : void
      {
         var _loc3_:String = String(Math.random());
         var _loc4_:int = PlayerManager.Instance.Self.Grade < 5 ? int(4) : int(3);
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         _loc5_.writeInt(param1);
         _loc5_.writeByte(param2);
         _loc5_.writeBoolean(false);
         _loc5_.writeUTF(_loc3_);
         _loc5_.writeUTF("");
         _loc5_.writeByte(_loc4_);
         _loc5_.writeByte(0);
         _loc5_.writeInt(0);
         _loc5_.writeBoolean(false);
         _loc5_.writeInt(0);
         this.sendPackage(_loc5_);
      }
      
      public function userGuideStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_START);
         this.sendPackage(_loc1_);
      }
      
      public function sendSaveDB() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SAVE_DB);
         this.sendPackage(_loc1_);
      }
      
      public function createMonster() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(0);
         this.sendPackage(_loc1_);
      }
      
      public function deleteMonster() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomCreate(param1:*) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_CREATE);
         _loc2_.writeUTF(param1.roomName);
         _loc2_.writeUTF(param1.roomPassword);
         _loc2_.writeUTF(param1.roomIntroduction);
         _loc2_.writeInt(param1.maxCount);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomEdit(param1:*) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_EDIT);
         _loc2_.writeUTF(param1.roomName);
         _loc2_.writeUTF(param1.roomPassword);
         _loc2_.writeUTF(param1.roomIntroduction);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomQuickEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_QUICK_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomEnterConfirm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomEnter(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendHotSpringRoomEnterView(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_VIEW);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomPlayerRemove() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomPlayerTargetPoint(param1:*) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.TARGET_POINT);
         var _loc3_:Array = param1.walkPath.concat();
         var _loc4_:Array = [];
         while(_loc5_ < _loc3_.length)
         {
            _loc4_.push(int(_loc3_[_loc5_].x),int(_loc3_[_loc5_].y));
            _loc5_++;
         }
         var _loc6_:String = _loc4_.toString();
         _loc2_.writeUTF(_loc6_);
         _loc2_.writeInt(param1.playerInfo.ID);
         _loc2_.writeInt(param1.currentWalkStartPoint.x);
         _loc2_.writeInt(param1.currentWalkStartPoint.y);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1.playerDirection);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomRenewalFee(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomInvite(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_INVITE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomAdminRemovePlayer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomPlayerContinue(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetTimeBox(param1:int, param2:int = 0, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GET_TIME_BOX);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendAchievementFinish(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_FINISH);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReworkRank(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_CHANGE_RANK);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLookupEffort(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LOOKUP_EFFORT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeginFightNpc() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FIGHT_NPC);
         this.sendPackage(_loc1_);
      }
      
      public function sendRequestUpdate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.REQUEST_UPDATE);
         this.sendPackage(_loc1_);
      }
      
      public function sendQuestionReply(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUESTION_REPLY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenVip(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.VIP_RENEWAL);
         _loc3_.writeUTF(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyRegister(param1:int, param2:Boolean, param3:String = null, param4:Boolean = false) : void
      {
         var _loc5_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc5_.writeByte(AcademyPackageType.ACADEMY_REGISTER);
         _loc5_.writeInt(param1);
         _loc5_.writeBoolean(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendAcademyRemoveRegister() : void
      {
         var _loc1_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc1_.writeByte(AcademyPackageType.ACADEMY_REMOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendAcademyApprentice(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc3_.writeByte(AcademyPackageType.ACADEMY_FOR_APPRENTICE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyMaster(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc3_.writeByte(AcademyPackageType.ACADEMY_FOR_MASTER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyMasterConfirm(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(param1)
         {
            _loc3_.writeByte(AcademyPackageType.MASTER_CONFIRM);
         }
         else
         {
            _loc3_.writeByte(AcademyPackageType.MASTER_REFUSE);
         }
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyApprenticeConfirm(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(param1)
         {
            _loc3_.writeByte(AcademyPackageType.APPRENTICE_CONFIRM);
         }
         else
         {
            _loc3_.writeByte(AcademyPackageType.APPRENTICE_REFUSE);
         }
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyFireMaster(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc2_.writeByte(AcademyPackageType.FIRE_MASTER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAcademyFireApprentice(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc2_.writeByte(AcademyPackageType.FIRE_APPRENTICE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUseLog(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USE_LOG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGift(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.USER_SEND_GIFTS);
         _loc5_.writeUTF(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendReloadGift() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.USER_RELOAD_GIFT);
         this.sendPackage(_loc1_);
      }
      
      public function sendSnsMsg(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SNS_MSG_RECEIVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendFace(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
         _loc2_.writeInt(param1);
         _loc2_.writeInt(0);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpition(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.OPTION_UPDATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionMail(param1:String, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTION_MAIL);
         _loc3_.writeUTF(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortionPoll(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.POLL_CANDIDATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionSkill(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.SKILL_SOCKET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOns() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc1_.writeByte(IMPackageType.ONS_EQUIP);
         this.sendPackage(_loc1_);
      }
      
      public function sendWithBrithday(param1:Vector.<FriendListPlayer>) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FRIEND_BRITHDAY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_].ID);
            _loc2_.writeUTF(param1[_loc3_].NickName);
            _loc2_.writeDate(param1[_loc3_].BirthdayDate);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendCollectInfoValidate(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.COLLECTINFO);
         _loc3_.writeByte(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendGoodsExchange(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GOODS_EXCHANGE);
         _loc3_.writeUTF(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendCustomFriends(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc4_.writeByte(IMPackageType.ADD_CUSTOM_FRIENDS);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendOneOnOneTalk(param1:int, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc4_.writeByte(IMPackageType.ONE_ON_ONE_TALK);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUserLuckyNum(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USER_LUCKYNUM);
         _loc3_.writeBoolean(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendBuyBadge(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.BUY_BADGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendStartTurn_LeftGun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_SOCKET);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendEndTurn_LeftGun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_COMPLETTE);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendWishBeadEquip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.WISHBEADEQUIP);
         _loc7_.writeInt(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeInt(param6);
         this.sendPackage(_loc7_);
      }
      
      public function sendPetMove(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(PetPackageType.MOVE_PETBAG);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetChangeName(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(PetPackageType.CHANGE_PETNAME);
         _loc3_.writeInt(param2);
         _loc3_.writeUTF(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendUpdatePetSpace() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PET);
         _loc1_.writeByte(PetPackageType.UPDATE_PET_SPACE);
         this.sendPackage(_loc1_);
      }
      
      public function sendPetMagic(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(PetPackageType.MAGIC_PET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPetAdvance(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(PetPackageType.ADVANCE_PET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPetTransform(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(PetPackageType.TRANSFORM);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetSkillUp(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(PetPackageType.SKILL_UP);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function refreshFarm() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc1_.writeByte(FarmPackageType.REFRASH_FARM);
         this.sendPackage(_loc1_);
      }
      
      public function seeding(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.SEEDING);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function toGather(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.GAIN_FIELD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function farmSpeed(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.ACCELERATE_FIELD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function farmLeaving() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc1_.writeByte(FarmPackageType.Exit_FARM);
         this.sendPackage(_loc1_);
      }
      
      public function FieldDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.UPROOT_FIELD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendWish() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.WISHOFDD);
         this.sendPackage(_loc1_);
      }
      
      public function sendChangeSex(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USE_CHANGE_SEX);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function getPlayerPropertyAddition() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.UPDATE_PLAYER_PROPERTY);
         this.sendPackage(_loc1_);
      }
      
      public function enterWorldBossRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.ENTER_WORLDBOSSROOM);
         this.sendPackage(_loc1_);
      }
      
      public function sendAddPlayer(param1:Point) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.ADDPLAYERS);
         _loc2_.writeInt(param1.x);
         _loc2_.writeInt(param1.y);
         this.sendPackage(_loc2_);
      }
      
      public function sendWorldBossRoomMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc4_.writeByte(WorldBossGamePackageType.MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendWorldBossRoomStauts(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.STAUTS);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLeaveBossRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.LEAVE_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function sendBuyWorldBossBuff(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.BUFF_BUY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendNewBuyWorldBossBuff() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.BUFF_BUY);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendWorldBossRequestRevive(param1:int = 1) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.REQUEST_REVIVE);
         _loc2_.writeInt(param1);
         SocketManager.Instance.socket.send(_loc2_);
      }
      
      public function sendRevertPet(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.REVER_PET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEnterWalkScene(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
         _loc2_.writeByte(WalkSencePackageType.ENTER_SENCE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function requestSavePoint(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SAVE_POINT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function resetSavePoint(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SAVE_POINT_RESET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendWalkScenePlayerMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
         _loc4_.writeByte(WalkSencePackageType.PLAYER_MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendSavePoint(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SET_SAVE_POINT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendWalkSceneObjectClick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
         _loc2_.writeByte(WalkSencePackageType.OBJECT_CLICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendExitWalkScene() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
         _loc1_.writeByte(WalkSencePackageType.PLAYER_EXIT);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenBagCell(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.OPEN_BAGCELL);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendFormula(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc2_.writeByte(EquipSystemPackageType.COMPOSE_SKILL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendToGetComposeSkill() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc1_.writeByte(EquipSystemPackageType.GET_COMPOSE_SKILL);
         this.sendPackage(_loc1_);
      }
      
      public function sendRefining() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
         _loc1_.writeByte(EquipSystemPackageType.REFINING);
         this.sendPackage(_loc1_);
      }
      
      public function sendfightVip(param1:int, param2:String = null, param3:int = 0) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FIGHTING_VIP);
         _loc4_.writeInt(param1);
         if(param1 == 1)
         {
            _loc4_.writeUTF(param2);
            _loc4_.writeInt(param3);
         }
         this.sendPackage(_loc4_);
      }
      
      public function sendVipOverdue(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.VIP_OVERDUE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyFatigue() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.BUY_FATIGUE);
         this.sendPackage(_loc1_);
      }
      
      public function sendExpeditionStart(param1:int, param2:int, param3:int, param4:int = 0) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.EXPEDITION);
         _loc5_.writeByte(ExpeditionType.START_EXPEDITION);
         _loc5_.writeByte(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendExpeditionAccelerate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EXPEDITION);
         _loc1_.writeByte(ExpeditionType.ACCELERATE_EXPEDITION);
         this.sendPackage(_loc1_);
      }
      
      public function sendExpeditionCancle() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EXPEDITION);
         _loc1_.writeByte(ExpeditionType.STOP_EXPEDITION);
         this.sendPackage(_loc1_);
      }
      
      public function sendExpeditionUpdate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EXPEDITION);
         _loc1_.writeByte(ExpeditionType.UPDATE_EXPEDITION);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenOneTotem() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.TOTEM_CMD);
         _loc1_.writeByte(TotemPackageType.TOTEM);
         this.sendPackage(_loc1_);
      }
      
      public function sendHonorUp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TOTEM_CMD);
         _loc2_.writeByte(TotemPackageType.HONOR_UP_COUNT);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function syncLifeTime() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.SYNC_LIFETIME);
         this.sendPackage(_loc1_);
      }
      
      public function sendTimeValidate(param1:int, param2:Date) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.SYS_DATE);
         _loc3_.writeByte(param1);
         _loc3_.writeDate(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendCDColling(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MINING_DUNGEON);
         _loc2_.writeByte(MiningPackageType.CD_COOLING_TIME);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOnlineReawd() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ONLINE_REWADS);
         this.sendPackage(_loc1_);
      }
      
      public function sendEnterRemoveCD(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
         _loc2_.writeByte(WalkSencePackageType.REMOVE_CD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionPublishTask(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.PUBLISH_TASK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function SendenterConsortion(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.ENTER_CONSORTION);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function SendenterConsortionTransport() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.ENTER_TRNSPORT);
         this.sendPackage(_loc1_);
      }
      
      public function SendexitConsortion() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.EXIT_CONSORTION);
         this.sendPackage(_loc1_);
      }
      
      public function SendBeginConvoy(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.GEGIN_CONVOY);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function SendInviteConvoy(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.INVITE_CONVOY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function SendInviteAnswer(param1:int, param2:String, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc4_.writeInt(ConsortiaPackageType.CONVOY_INVITE_ANSWER);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function SendCancleConvoyInvite(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CANCLE_CONVOY_INVITE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function SendexitConsortionTransport() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.EXIT_CONSORTION_TRANSPORT);
         this.sendPackage(_loc1_);
      }
      
      public function SendCarReceive() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CAR_RECEIVE);
         this.sendPackage(_loc1_);
      }
      
      public function SendHijackCar(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.HIJACK_CAR);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function SendHijackAnswer(param1:int, param2:int, param3:String, param4:Boolean) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc5_.writeInt(ConsortiaPackageType.HIJACK_ANSWER);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function SendConsortionWalkScenePlayeMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc4_.writeInt(ConsortiaPackageType.CONSORTIONSENCE_MOVEPLAYER);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function SendOpenConsortionCampaign() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_UPDATE_QUEST);
         this.sendPackage(_loc1_);
      }
      
      public function SendOpenLivenessFrame() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
         _loc1_.writeInt(DailyQuestPackageType.UPDATE);
         this.sendPackage(_loc1_);
      }
      
      public function SendGetDailyQuestReward(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
         _loc2_.writeInt(DailyQuestPackageType.REWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function SendGetDailyQuestOneKey(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
         _loc2_.writeInt(DailyQuestPackageType.ONE_KEY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEnterRandomPve() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
         _loc1_.writeInt(DailyQuestPackageType.RANDOM_PVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendEnterRandomScene(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
         _loc2_.writeInt(DailyQuestPackageType.RANDOM_SCENE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function SendBuyCar(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.BUY_CAR);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendRequestConsortionQuest(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.REQUEST_CONSORTIA_QUEST);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendStartFightWithMonster(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaMonsterPackageTypes.FIGHT_MONSTER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAddMonsterRequest() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaMonsterPackageTypes.ACTIVE_STATE);
         this.sendPackage(_loc1_);
      }
      
      public function sendShopRefreshGood() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.SHOP_REFRESH_GOOD);
         this.sendPackage(_loc1_);
      }
      
      public function sendAskForActiviLog(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ACTIVE_LOG);
         _loc4_.writeUTF(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendGetActivityAward(param1:String, param2:int, param3:Object = null) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ACTIVE_GET);
         _loc4_.writeUTF(param1);
         _loc4_.writeInt(param2);
         if(param3 != null)
         {
            if(param3["giftbagOrder"] != null)
            {
               _loc4_.writeInt(param3["giftbagOrder"]);
            }
         }
         this.sendPackage(_loc4_);
      }
      
      public function sendArenaEnterScene(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc3_.writeInt(ArenaPackageTypes.ENTER_SCENE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendArenaExitScene(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc3_.writeInt(ArenaPackageTypes.EXIT_SCENE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendArenaPlayerMove(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc6_.writeInt(ArenaPackageTypes.MOVE_SCENE);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeUTF(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendArenaPlayerFight(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc4_.writeInt(ArenaPackageTypes.FIGHT_SCENE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendArenaRelive(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc4_.writeInt(ArenaPackageTypes.RELIVE_SCENE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendArenaUpdate(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc3_.writeInt(ArenaPackageTypes.UPDATE_SCENE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAskForActivityType() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ARENA);
         _loc1_.writeInt(ArenaPackageTypes.ACTIVITY_TYPE);
         this.sendPackage(_loc1_);
      }
      
      public function sendAskForRankShopRecord() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RANK_SHOP);
         this.sendPackage(_loc1_);
      }
      
      public function sendInvitedFriendAward(param1:uint, param2:uint, param3:Number) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CLOSE_FRIEND_REWARD);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeLong(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendSingleDungeonModeInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
         _loc1_.writeInt(WalkSencePackageType.UPDATE_DUNGEONMODE_INFO);
         this.sendPackage(_loc1_);
      }
      
      public function sendTurnPlateReady() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
         _loc1_.writeByte(TurnPlatePackageType.LOTTERY_START);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendTurnPlateStart(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
         _loc2_.writeByte(TurnPlatePackageType.LOTTERY_RANDOM);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendTurnPlateStop() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
         _loc1_.writeByte(TurnPlatePackageType.LOTTERY_FINISH);
         this.sendPackage(_loc1_);
      }
      
      public function requestTurnPlateStatus() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
         _loc1_.writeByte(TurnPlatePackageType.LOTTERY_STATE);
         this.sendPackage(_loc1_);
      }
      
      public function sendQuickBuyBoguCoin(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
         _loc2_.writeByte(TurnPlatePackageType.LOTTERY_BUY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReturnEnergyRequest(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ENERGY_RETURN);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenFightRobotView() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
         _loc1_.writeByte(FightRobotPackageType.OPEN_FRAME);
         this.sendPackage(_loc1_);
      }
      
      public function sendFightRobot() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
         _loc1_.writeByte(FightRobotPackageType.BEGIN_FIGHT_ROBOT);
         this.sendPackage(_loc1_);
      }
      
      public function sendFightRobotCoolDown() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
         _loc1_.writeByte(FightRobotPackageType.CLEAR_CD);
         this.sendPackage(_loc1_);
      }
      
      public function sendRevengeRobot(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
         _loc2_.writeByte(FightRobotPackageType.REVENGE_ROBOT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDailyReceive(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyItemInActivity(param1:int, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.BUY_ACTVITY);
         _loc5_.writeInt(param1);
         _loc5_.writeUTF(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
   }
}
