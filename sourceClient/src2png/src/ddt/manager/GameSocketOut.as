// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.GameSocketOut

package ddt.manager
{
    import road7th.comm.ByteSocket;
    import flash.utils.ByteArray;
    import road7th.math.randRange;
    import ddt.utils.CrytoUtils;
    import road7th.comm.PackageOut;
    import ddt.data.socket.ePackageType;
    import ddt.Version;
    import flash.system.Capabilities;
    import ddt.data.AccountInfo;
    import ddt.data.socket.GameRoomPackageType;
    import email.manager.MailManager;
    import ddt.data.socket.CrazyTankPackageType;
    import ddt.data.socket.EquipSystemPackageType;
    import bead.BeadPackageType;
    import ddt.data.socket.IMPackageType;
    import baglocked.BagLockedController;
    import ddt.data.socket.ConsortiaPackageType;
    import ddt.data.socket.ChurchPackageType;
    import ddt.data.socket.HotSpringPackageType;
    import ddt.data.socket.AcademyPackageType;
    import __AS3__.vec.Vector;
    import ddt.data.player.FriendListPlayer;
    import ddt.data.socket.PetPackageType;
    import ddt.data.socket.FarmPackageType;
    import worldboss.model.WorldBossGamePackageType;
    import flash.geom.Point;
    import SingleDungeon.model.WalkSencePackageType;
    import ddt.data.socket.ExpeditionType;
    import totem.data.TotemPackageType;
    import SingleDungeon.model.MiningPackageType;
    import ddt.data.socket.DailyQuestPackageType;
    import consortion.data.ConsortiaMonsterPackageTypes;
    import arena.model.ArenaPackageTypes;
    import ddt.data.socket.TurnPlatePackageType;
    import fightRobot.FightRobotPackageType;

    public class GameSocketOut 
    {

        private var _socket:ByteSocket;

        public function GameSocketOut(_arg_1:ByteSocket)
        {
            this._socket = _arg_1;
        }

        public function sendDomainNameAndPort():void
        {
            var _local_1:String = ServerManager.Instance.current.IP;
            var _local_2:String = String(ServerManager.Instance.current.Port);
            this._socket.sendByteArrayString((((("tgw_l7_forward\r\nHost:" + _local_1) + ":") + _local_2) + "\r\n\r\n"));
        }

        public function sendLogin(_arg_1:AccountInfo):void
        {
            var _local_3:ByteArray;
            var _local_8:int;
            this._socket.resetKey();
            var _local_2:Date = new Date();
            _local_3 = new ByteArray();
            var _local_4:int = randRange(100, 10000);
            _local_3.writeShort(_local_2.fullYearUTC);
            _local_3.writeByte((_local_2.monthUTC + 1));
            _local_3.writeByte(_local_2.dateUTC);
            _local_3.writeByte(_local_2.hoursUTC);
            _local_3.writeByte(_local_2.minutesUTC);
            _local_3.writeByte(_local_2.secondsUTC);
            var _local_5:Array = [Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF)), Math.ceil((Math.random() * 0xFF))];
            var _local_6:int;
            while (_local_6 < _local_5.length)
            {
                _local_3.writeByte(_local_5[_local_6]);
                _local_6++;
            };
            _local_3.writeUTFBytes(((_arg_1.Account + ",") + _arg_1.Password));
            _local_3 = CrytoUtils.rsaEncry5(_arg_1.Key, _local_3);
            _local_3.position = 0;
            var _local_7:PackageOut = new PackageOut(ePackageType.LOGIN);
            _local_7.writeInt(Version.Build);
            _local_7.writeInt(DesktopManager.Instance.desktopType);
            _local_7.writeUTF(((Capabilities.screenResolutionX + "x") + Capabilities.screenResolutionY));
            _local_7.writeBytes(_local_3);
            this.sendPackage(_local_7);
            this._socket.setKey(_local_5);
            while (_local_8 < _local_5.length)
            {
                _local_8++;
            };
        }

        public function sendWeeklyClick():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.WEEKLY_CLICK_CNT);
            this.sendPackage(_local_1);
        }

        public function sendGameLogin(_arg_1:int, _arg_2:int, _arg_3:int=-1, _arg_4:String="", _arg_5:Boolean=false):void
        {
            var _local_6:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_6.writeInt(GameRoomPackageType.GAME_ROOM_LOGIN);
            _local_6.writeBoolean(_arg_5);
            _local_6.writeInt(_arg_1);
            _local_6.writeInt(_arg_2);
            if (_arg_2 == -1)
            {
                _local_6.writeInt(_arg_3);
                _local_6.writeUTF(_arg_4);
            };
            this.sendPackage(_local_6);
        }

        public function sendSceneLogin(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SCENE_LOGIN);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGameStyle(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_2.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendDiamondAward(_arg_1:int, _arg_2:int=0):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.DIAMOND_AWARD);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendBuyGoods(_arg_1:Array, _arg_2:Array, _arg_3:Array, _arg_4:Array, _arg_5:Array, _arg_6:Array=null, _arg_7:int=0, _arg_8:Array=null):void
        {
            if (_arg_1.length > 50)
            {
                this.sendBuyGoods(_arg_1.splice(0, 50), _arg_2.splice(0, 50), _arg_3.splice(0, 50), _arg_4.splice(0, 50), _arg_5.splice(0, 50), ((_arg_6 == null) ? null : _arg_6.splice(0, 50)), _arg_7, ((_arg_8 == null) ? null : _arg_8));
                this.sendBuyGoods(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
                return;
            };
            var _local_9:PackageOut = new PackageOut(ePackageType.BUY_GOODS);
            var _local_10:int = _arg_1.length;
            _local_9.writeInt(_local_10);
            var _local_11:uint;
            while (_local_11 < _local_10)
            {
                if ((!(_arg_8)))
                {
                    _local_9.writeInt(1);
                }
                else
                {
                    _local_9.writeInt(_arg_8[_local_11]);
                };
                _local_9.writeInt(_arg_1[_local_11]);
                _local_9.writeInt(_arg_2[_local_11]);
                _local_9.writeUTF(_arg_3[_local_11]);
                _local_9.writeBoolean(_arg_5[_local_11]);
                if (_arg_6 == null)
                {
                    _local_9.writeUTF("");
                }
                else
                {
                    _local_9.writeUTF(_arg_6[_local_11]);
                };
                _local_9.writeInt(_arg_4[_local_11]);
                _local_11++;
            };
            _local_9.writeInt(_arg_7);
            this.sendPackage(_local_9);
        }

        public function sendBuyProp(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.PROP_BUY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendSellProp(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.PROP_SELL);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendQuickBuyGoldBox(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BUY_QUICK_GOLDBOX);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBuyGiftBag(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BUY_GIFTBAG);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendPresentGoods(_arg_1:Array, _arg_2:Array, _arg_3:Array, _arg_4:Array, _arg_5:String, _arg_6:String, _arg_7:Array=null):void
        {
            var _local_8:PackageOut = new PackageOut(ePackageType.GOODS_PRESENT);
            var _local_9:int = _arg_1.length;
            _local_8.writeUTF(_arg_5);
            _local_8.writeUTF(_arg_6);
            _local_8.writeInt(_local_9);
            var _local_10:uint;
            while (_local_10 < _local_9)
            {
                _local_8.writeInt(_arg_1[_local_10]);
                _local_8.writeInt(_arg_2[_local_10]);
                _local_8.writeUTF(_arg_3[_local_10]);
                if (_arg_7 == null)
                {
                    _local_8.writeUTF("");
                }
                else
                {
                    _local_8.writeUTF(_arg_7[_local_10]);
                };
                _local_8.writeInt(_arg_4[_local_10]);
                _local_10++;
            };
            this.sendPackage(_local_8);
        }

        public function sendGoodsContinue(_arg_1:Array):void
        {
            var _local_2:int = _arg_1.length;
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_CONTINUE);
            _local_3.writeInt(_local_2);
            var _local_4:uint;
            while (_local_4 < _local_2)
            {
                _local_3.writeByte(_arg_1[_local_4][0]);
                _local_3.writeInt(_arg_1[_local_4][1]);
                _local_3.writeInt(_arg_1[_local_4][2]);
                _local_3.writeByte(_arg_1[_local_4][3]);
                _local_3.writeBoolean(_arg_1[_local_4][4]);
                _local_4++;
            };
            this.sendPackage(_local_3);
        }

        public function sendSellGoods(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SEll_GOODS);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendUpdateGoodsCount():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GOODS_COUNT);
            this.sendPackage(_local_1);
        }

        public function sendEmail(_arg_1:Object):void
        {
            var _local_3:uint;
            var _local_2:PackageOut = new PackageOut(ePackageType.SEND_MAIL);
            _local_2.writeUTF(_arg_1.NickName);
            _local_2.writeUTF(_arg_1.Title);
            _local_2.writeUTF(_arg_1.Content);
            _local_2.writeBoolean(_arg_1.isPay);
            _local_2.writeInt(_arg_1.hours);
            _local_2.writeInt(_arg_1.SendedMoney);
            while (_local_3 < MailManager.Instance.NUM_OF_WRITING_DIAMONDS)
            {
                if (_arg_1[("Annex" + _local_3)])
                {
                    _local_2.writeByte(_arg_1[("Annex" + _local_3)].split(",")[0]);
                    _local_2.writeInt(_arg_1[("Annex" + _local_3)].split(",")[1]);
                    _local_2.writeInt(_arg_1.Count);
                }
                else
                {
                    _local_2.writeByte(0);
                    _local_2.writeInt(-1);
                    _local_2.writeInt(0);
                };
                _local_3++;
            };
            this.sendPackage(_local_2);
        }

        public function sendUpdateMail(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.UPDATE_MAIL);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendDeleteMail(_arg_1:Array):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DELETE_MAIL);
            _local_2.writeInt(_arg_1.length);
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.writeInt(_arg_1[_local_3].ID);
                _local_3++;
            };
            this.sendPackage(_local_2);
        }

        public function untreadEmail(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MAIL_CANCEL);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGetMail(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GET_MAIL_ATTACHMENT);
            _local_3.writeInt(_arg_1);
            _local_3.writeByte(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendPint():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.PING);
            this.sendPackage(_local_1);
        }

        public function sendSuicide(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.SUICIDE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendKillSelf(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.KILLSELF);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendItemCompose(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_4.writeByte(EquipSystemPackageType.COMPOSE);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendItemSplite(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_3.writeByte(EquipSystemPackageType.SPLITE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendItemTransfer(_arg_1:Boolean=true, _arg_2:Boolean=true):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_TRANSFER);
            this.sendPackage(_local_3);
        }

        public function sendItemStrength(_arg_1:Boolean, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_STRENGTHEN);
            _local_3.writeBoolean(_arg_1);
            _local_3.writeBoolean(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendItemLianhua(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int):void
        {
            var _local_8:PackageOut = new PackageOut(ePackageType.ITEM_REFINERY);
            _local_8.writeInt(_arg_1);
            _local_8.writeInt(_arg_2);
            var _local_9:int;
            while (_local_9 < _arg_3.length)
            {
                _local_8.writeInt(_arg_3[_local_9]);
                _local_9++;
            };
            _local_8.writeInt(_arg_4);
            _local_8.writeInt(_arg_5);
            _local_8.writeInt(_arg_6);
            _local_8.writeInt(_arg_7);
            this.sendPackage(_local_8);
        }

        public function sendOpenEmbedHole(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_2.writeByte(EquipSystemPackageType.HOLE_EQUIP);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendItemEmbed(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_4.writeByte(EquipSystemPackageType.MOSAIC_EQUIP);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendBeadMove(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_3.writeByte(BeadPackageType.BEAD_MOVE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendBeadCombine(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_4.writeByte(BeadPackageType.BEAD_COMBINE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeByte(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendBeadLock(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_2.writeByte(BeadPackageType.BEAD_LOCK);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeadCombineOneKey(_arg_1:int=1):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_2.writeByte(BeadPackageType.BEAD_COMBINE_ONEKEY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeadSellBead(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_2.writeByte(BeadPackageType.BEAD_SELL_BEAD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeadGetBead(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_2.writeByte(BeadPackageType.BEAD_GET_BEAD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeadRequestBead(_arg_1:int, _arg_2:Boolean=false, _arg_3:int=2):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_4.writeByte(BeadPackageType.BEAD_REQUEST_BEAD);
            _local_4.writeInt(_arg_1);
            _local_4.writeBoolean(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendBeadDiscardBead(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_2.writeByte(BeadPackageType.BEAD_DISCARD_BEAD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeadExchangeBead(_arg_1:int, _arg_2:int=1):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_3.writeByte(BeadPackageType.BEAD_EXCHANGE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendBeadBuyOneKey(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_2.writeByte(BeadPackageType.BEAD_BUY_ONEKEY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeadSplit():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_1.writeByte(BeadPackageType.BEAD_SPLIT);
            this.sendPackage(_local_1);
        }

        public function sendBeadSell():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.BEAD_SYSTEM);
            _local_1.writeByte(BeadPackageType.BEAD_SELL);
            this.sendPackage(_local_1);
        }

        public function sendItemEmbedBackout(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_EMBED_BACKOUT);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendItemOpenFiveSixHole(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.OPEN_FIVE_SIX_HOLE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendItemTrend(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:PackageOut = new PackageOut(ePackageType.ITEM_TREND);
            _local_6.writeInt(_arg_1);
            _local_6.writeInt(_arg_2);
            _local_6.writeInt(_arg_3);
            _local_6.writeInt(_arg_4);
            _local_6.writeInt(_arg_5);
            this.sendPackage(_local_6);
        }

        public function sendClearStoreBag():void
        {
            PlayerManager.Instance.Self.StoreBag.items.clear();
            var _local_1:PackageOut = new PackageOut(ePackageType.CLEAR_STORE_BAG);
            this.sendPackage(_local_1);
        }

        public function sendCheckCode(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CHECK_CODE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendSBugle(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.S_BUGLE);
            _local_2.writeInt(PlayerManager.Instance.Self.ID);
            _local_2.writeUTF(PlayerManager.Instance.Self.NickName);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBBugle(_arg_1:String, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.B_BUGLE);
            _local_3.writeInt(_arg_2);
            _local_3.writeInt(PlayerManager.Instance.Self.ID);
            _local_3.writeUTF(PlayerManager.Instance.Self.NickName);
            _local_3.writeUTF(_arg_1);
            this.sendPackage(_local_3);
        }

        public function sendCBugle(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.C_BUGLE);
            _local_2.writeInt(PlayerManager.Instance.Self.ID);
            _local_2.writeUTF(PlayerManager.Instance.Self.NickName);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendDefyAffiche(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DEFY_AFFICHE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGameMode(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_2.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendAddFriend(_arg_1:String, _arg_2:int, _arg_3:Boolean=false, _arg_4:Boolean=false):void
        {
            if (_arg_1 == "")
            {
                return;
            };
            var _local_5:PackageOut = new PackageOut(ePackageType.IM_CMD);
            _local_5.writeByte(IMPackageType.FRIEND_ADD);
            _local_5.writeUTF(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeBoolean(_arg_3);
            _local_5.writeBoolean(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendDelFriend(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.IM_CMD);
            _local_2.writeByte(IMPackageType.FRIEND_REMOVE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendFriendState(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.IM_CMD);
            _local_2.writeByte(IMPackageType.FRIEND_STATE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBagLocked(_arg_1:String, _arg_2:int, _arg_3:String="", _arg_4:String="", _arg_5:String="", _arg_6:String="", _arg_7:String=""):void
        {
            var _local_8:PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
            BagLockedController.TEMP_PWD = ((!(_arg_3 == "")) ? _arg_3 : _arg_1);
            _local_8.writeUTF(_arg_1);
            _local_8.writeUTF(_arg_3);
            _local_8.writeInt(_arg_2);
            _local_8.writeUTF(_arg_4);
            _local_8.writeUTF(_arg_5);
            _local_8.writeUTF(_arg_6);
            _local_8.writeUTF(_arg_7);
            this.sendPackage(_local_8);
        }

        public function sendBagLockedII(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String):void
        {
        }

        public function sendConsortiaEquipConstrol(_arg_1:Array):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL);
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.writeInt(_arg_1[_local_3]);
                _local_3++;
            };
            this.sendPackage(_local_2);
        }

        public function sendErrorMsg(_arg_1:String):void
        {
            var _local_2:PackageOut;
            if (_arg_1.length < 1000)
            {
                _local_2 = new PackageOut(ePackageType.CLIENT_LOG);
                _local_2.writeUTF(_arg_1);
            };
        }

        public function sendItemOverDue(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_OVERDUE);
            _local_3.writeByte(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendHideLayer(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_HIDE);
            _local_3.writeBoolean(_arg_2);
            _local_3.writeInt(_arg_1);
            this.sendPackage(_local_3);
        }

        public function sendQuestAdd(_arg_1:Array):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
            _local_2.writeInt(_arg_1.length);
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.writeInt(_arg_1[_local_3]);
                _local_3++;
            };
            this.sendPackage(_local_2);
        }

        public function sendQuestRemove(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.QUEST_REMOVE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendQuestFinish(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.QUEST_FINISH);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendQuestOneToFinish(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.QUEST_ONEKEYFINISH);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendImproveQuest(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.QUEST_LEVEL_UP);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendQuestCheck(_arg_1:int, _arg_2:int, _arg_3:int=1):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.QUEST_CHECK);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendItemOpenUp(_arg_1:int, _arg_2:int, _arg_3:int=1):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.ITEM_OPENUP);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendItemEquip(_arg_1:*, _arg_2:Boolean=false):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ITEM_EQUIP);
            if ((!(_arg_2)))
            {
                _local_3.writeBoolean(true);
                _local_3.writeInt(_arg_1);
            }
            else
            {
                if (_arg_2)
                {
                    _local_3.writeBoolean(false);
                    _local_3.writeUTF(_arg_1);
                };
            };
            this.sendPackage(_local_3);
        }

        public function sendMateTime(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MATE_ONLINE_TIME);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function auctionGood(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int):void
        {
            var _local_8:PackageOut = new PackageOut(ePackageType.AUCTION_ADD);
            _local_8.writeByte(_arg_1);
            _local_8.writeInt(_arg_2);
            _local_8.writeByte(_arg_3);
            _local_8.writeInt(_arg_4);
            _local_8.writeInt(_arg_5);
            _local_8.writeInt(_arg_6);
            _local_8.writeInt(_arg_7);
            this.sendPackage(_local_8);
        }

        public function auctionCancelSell(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.AUCTION_DELETE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function auctionBid(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.AUCTION_UPDATE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function syncStep(_arg_1:int, _arg_2:Boolean=true):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
            _local_3.writeByte(1);
            _local_3.writeInt(_arg_1);
            _local_3.writeBoolean(_arg_2);
            this.sendPackage(_local_3);
        }

        public function syncWeakStep(_arg_1:int):void
        {
        }

        public function sendCreateConsortia(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_CREATE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaTryIn(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaCancelTryIn():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
            _local_1.writeInt(0);
            this.sendPackage(_local_1);
        }

        public function sendConsortiaInvate(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_INVITE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendReleaseConsortiaTask(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_TASK_RELEASE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaInvatePass(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_PASS);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaInvateDelete(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_DELETE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaUpdateDescription(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaUpdatePlacard(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaUpdateDuty(_arg_1:int, _arg_2:String, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_4.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
            _local_4.writeInt(_arg_1);
            _local_4.writeByte(((_arg_1 == -1) ? 1 : 2));
            _local_4.writeUTF(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendConsortiaUpgradeDuty(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
            _local_3.writeInt(_arg_1);
            _local_3.writeByte(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendConsoritaApplyStatusOut(_arg_1:Boolean):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_APPLY_STATE);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaOut(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_RENEGADE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaMemberGrade(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE);
            _local_3.writeInt(_arg_1);
            _local_3.writeBoolean(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendConsortiaUserRemarkUpdate(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE);
            _local_3.writeInt(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendConsortiaDutyDelete(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_DELETE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaTryinPass(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_PASS);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaTryinDelete(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_DEL);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendForbidSpeak(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE);
            _local_3.writeInt(_arg_1);
            _local_3.writeBoolean(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendConsortiaDismiss():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_DISBAND);
            this.sendPackage(_local_1);
        }

        public function sendConsortiaChangeChairman(_arg_1:String=""):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortiaRichOffer(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendDonate(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.DONATE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendConsortiaLevelUp():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_LEVEL_UP);
            this.sendPackage(_local_1);
        }

        public function sendConsortiaShopUp():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_SHOP_UP);
            this.sendPackage(_local_1);
        }

        public function sendConsortiaHallUp():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_HALL_UP);
            this.sendPackage(_local_1);
        }

        public function sendConsortiaSkillUp():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_SKILL_UP);
            this.sendPackage(_local_1);
        }

        public function sendAirPlane():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.AIRPLANE);
            this.sendPackage(_local_1);
        }

        public function useDeputyWeapon():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.USE_DEPUTY_WEAPON);
            this.sendPackage(_local_1);
        }

        public function sendUseFightKitSkill(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.FIGHT_KIT_SKILL);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGamePick(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.PICK);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendPetSkill(_arg_1:int, _arg_2:int=-1):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_3.writeByte(CrazyTankPackageType.PET_SKILL);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendPackage(_arg_1:PackageOut):void
        {
            this._socket.send(_arg_1);
        }

        public function sendMoveGoods(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int=1, _arg_6:Boolean=false):void
        {
            var _local_7:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS);
            _local_7.writeByte(_arg_1);
            _local_7.writeInt(_arg_2);
            _local_7.writeByte(_arg_3);
            _local_7.writeInt(_arg_4);
            _local_7.writeInt(_arg_5);
            _local_7.writeBoolean(_arg_6);
            this.sendPackage(_local_7);
        }

        public function reclaimGoods(_arg_1:int, _arg_2:int, _arg_3:int=1):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.REClAIM_GOODS);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendMoveGoodsAll(_arg_1:int, _arg_2:Array, _arg_3:int, _arg_4:Boolean=false):void
        {
            if (_arg_2.length <= 0)
            {
                return;
            };
            var _local_5:int = _arg_2.length;
            var _local_6:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS_ALL);
            _local_6.writeBoolean(_arg_4);
            _local_6.writeInt(_local_5);
            _local_6.writeInt(_arg_1);
            var _local_7:int;
            while (_local_7 < _local_5)
            {
                _local_6.writeInt(_arg_2[_local_7].Place);
                _local_6.writeInt((_local_7 + _arg_3));
                _local_7++;
            };
            this.sendPackage(_local_6);
        }

        public function sendForSwitch():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.ENTHRALL_SWITCH);
            this.sendPackage(_local_1);
        }

        public function sendCIDCheck():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CID_CHECK);
            this.sendPackage(_local_1);
        }

        public function sendCIDInfo(_arg_1:String, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CID_CHECK);
            _local_3.writeBoolean(false);
            _local_3.writeUTF(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendChangeColor(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:String, _arg_7:int):void
        {
            var _local_8:PackageOut = new PackageOut(ePackageType.USE_COLOR_CARD);
            _local_8.writeInt(_arg_1);
            _local_8.writeInt(_arg_2);
            _local_8.writeInt(_arg_3);
            _local_8.writeInt(_arg_4);
            _local_8.writeUTF(_arg_5);
            _local_8.writeUTF(_arg_6);
            _local_8.writeInt(_arg_7);
            this.sendPackage(_local_8);
        }

        public function sendUseCard(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int, _arg_5:Boolean=false, _arg_6:int=1):void
        {
            var _local_7:PackageOut = new PackageOut(ePackageType.CARD_USE);
            _local_7.writeInt(_arg_1);
            _local_7.writeInt(_arg_2);
            _local_7.writeInt(_arg_3[0]);
            _local_7.writeInt(_arg_6);
            _local_7.writeInt(_arg_4);
            _local_7.writeBoolean(_arg_5);
            this.sendPackage(_local_7);
        }

        public function sendUseProp(_arg_1:int, _arg_2:int, _arg_3:Array, _arg_4:int, _arg_5:Boolean=false):void
        {
            var _local_6:PackageOut = new PackageOut(ePackageType.PROP_USE);
            _local_6.writeInt(_arg_1);
            _local_6.writeInt(_arg_2);
            _local_6.writeInt(_arg_3.length);
            var _local_7:int = _arg_3.length;
            var _local_8:int;
            while (_local_8 < _local_7)
            {
                _local_6.writeInt(_arg_3[_local_8]);
                _local_8++;
            };
            _local_6.writeInt(_arg_4);
            _local_6.writeBoolean(_arg_5);
            this.sendPackage(_local_6);
        }

        public function sendUseChangeColorShell(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.USE_CHANGE_COLOR_SHELL);
            _local_3.writeByte(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendChangeColorShellTimeOver(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CHANGE_COLOR_OVER_DUE);
            _local_3.writeByte(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendRouletteBox(_arg_1:int, _arg_2:int, _arg_3:int=-1):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendFinishRoulette():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.LOTTERY_FINISH);
            this.sendPackage(_local_1);
        }

        public function sendSellAll():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CADDY_SELL_ALL_GOODS);
            this.sendPackage(_local_1);
        }

        public function sendconverted(_arg_1:Boolean, _arg_2:int=0, _arg_3:int=0):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.CADDY_CONVERTED_ALL);
            _local_4.writeBoolean(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendExchange():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CADDY_EXCHANGE_ALL);
            this.sendPackage(_local_1);
        }

        public function sendOpenDead(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendRequestAwards(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CADDY_GET_AWARDS);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendQequestBadLuck(_arg_1:Boolean=false):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CADDY_GET_BADLUCK);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendUseReworkName(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.USE_REWORK_NAME);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeUTF(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendUseConsortiaReworkName(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.USE_CONSORTIA_REWORK_NAME);
            _local_5.writeInt(_arg_1);
            _local_5.writeByte(_arg_2);
            _local_5.writeInt(_arg_3);
            _local_5.writeUTF(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendValidateMarry(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_STATUS);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendPropose(_arg_1:int, _arg_2:String, _arg_3:Boolean):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.MARRY_APPLY);
            _local_4.writeInt(_arg_1);
            _local_4.writeUTF(_arg_2);
            _local_4.writeBoolean(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendProposeRespose(_arg_1:Boolean, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.MARRY_APPLY_REPLY);
            _local_4.writeBoolean(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendUnmarry(_arg_1:Boolean=false):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DIVORCE_APPLY);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendMarryRoomLogin():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_LOGIN);
            this.sendPackage(_local_1);
        }

        public function sendExitMarryRoom():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
            this.sendPackage(_local_1);
        }

        public function sendCreateRoom(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:String):void
        {
            var _local_7:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_CREATE);
            _local_7.writeUTF(_arg_1);
            _local_7.writeUTF(_arg_2);
            _local_7.writeInt(_arg_3);
            _local_7.writeInt(_arg_4);
            _local_7.writeInt(100);
            _local_7.writeBoolean(_arg_5);
            _local_7.writeUTF(_arg_6);
            this.sendPackage(_local_7);
        }

        public function sendEnterRoom(_arg_1:int, _arg_2:String, _arg_3:int=1):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_LOGIN);
            _local_4.writeInt(_arg_1);
            _local_4.writeUTF(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendExitRoom():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.PLAYER_EXIT_MARRY_ROOM);
            this.sendPackage(_local_1);
        }

        public function sendCurrentState(_arg_1:uint):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SCENE_STATE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendUpdateRoomList(_arg_1:int, _arg_2:int, _arg_3:int=10000, _arg_4:int=1011):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_5.writeInt(GameRoomPackageType.ROOMLIST_UPDATE);
            _local_5.writeInt(_arg_1);
            _local_5.writeInt(_arg_2);
            if (((_arg_1 == 2) && (_arg_2 == -2)))
            {
                _local_5.writeInt(_arg_3);
                _local_5.writeInt(_arg_4);
            };
            this.sendPackage(_local_5);
        }

        public function sendChurchMove(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_4.writeByte(ChurchPackageType.MOVE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeUTF(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendStartWedding():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_1.writeByte(ChurchPackageType.HYMENEAL);
            this.sendPackage(_local_1);
        }

        public function sendChurchContinuation(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_2.writeByte(ChurchPackageType.CONTINUATION);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendChurchInvite(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_2.writeByte(ChurchPackageType.INVITE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendChurchLargess(_arg_1:uint):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_2.writeByte(ChurchPackageType.LARGESS);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function refund():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_1.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
            _local_1.writeByte(ChurchPackageType.CLIENTCONFIRM);
            this.sendPackage(_local_1);
        }

        public function requestRefund():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_1.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
            _local_1.writeByte(ChurchPackageType.BEGINSENDGIFT);
            this.sendPackage(_local_1);
        }

        public function sendUseFire(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_3.writeByte(ChurchPackageType.USEFIRECRACKERS);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendChurchKick(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_2.writeByte(ChurchPackageType.KICK);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendChurchMovieOver(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CHURCH_MOVIE_OVER);
            _local_3.writeInt(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendChurchForbid(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_2.writeByte(ChurchPackageType.FORBID);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendPosition(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_3.writeByte(ChurchPackageType.POSITION);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendModifyChurchDiscription(_arg_1:String, _arg_2:Boolean, _arg_3:String, _arg_4:String):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_INFO_UPDATE);
            _local_5.writeUTF(_arg_1);
            _local_5.writeBoolean(_arg_2);
            _local_5.writeUTF(_arg_3);
            _local_5.writeUTF(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendSceneChange(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_CHANGE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGunSalute(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
            _local_3.writeByte(ChurchPackageType.GUNSALUTE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendRegisterInfo(_arg_1:int, _arg_2:Boolean, _arg_3:String=null):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.MARRYINFO_ADD);
            _local_4.writeBoolean(_arg_2);
            _local_4.writeUTF(_arg_3);
            _local_4.writeInt(_arg_1);
            this.sendPackage(_local_4);
        }

        public function sendModifyInfo(_arg_1:Boolean, _arg_2:String=null):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.MARRYINFO_UPDATE);
            _local_3.writeBoolean(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendForMarryInfo(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MARRYINFO_GET);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGetLinkGoodsInfo(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
            _local_3.writeInt(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendGetTropToBag(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function createUserGuide(_arg_1:int=10):void
        {
            var _local_2:String = String(Math.random());
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_3.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
            _local_3.writeByte(_arg_1);
            _local_3.writeByte(3);
            _local_3.writeUTF("");
            _local_3.writeUTF(_local_2);
            this.sendPackage(_local_3);
        }

        public function enterUserGuide(_arg_1:int, _arg_2:int=10):void
        {
            var _local_3:String = String(Math.random());
            var _local_4:int = ((PlayerManager.Instance.Self.Grade < 5) ? 4 : 3);
            var _local_5:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_5.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
            _local_5.writeInt(_arg_1);
            _local_5.writeByte(_arg_2);
            _local_5.writeBoolean(false);
            _local_5.writeUTF(_local_3);
            _local_5.writeUTF("");
            _local_5.writeByte(_local_4);
            _local_5.writeByte(0);
            _local_5.writeInt(0);
            _local_5.writeBoolean(false);
            _local_5.writeInt(0);
            this.sendPackage(_local_5);
        }

        public function userGuideStart():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_1.writeInt(GameRoomPackageType.GAME_START);
            this.sendPackage(_local_1);
        }

        public function sendSaveDB():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.SAVE_DB);
            this.sendPackage(_local_1);
        }

        public function createMonster():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
            _local_1.writeInt(0);
            this.sendPackage(_local_1);
        }

        public function deleteMonster():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
            _local_1.writeInt(1);
            this.sendPackage(_local_1);
        }

        public function sendHotSpringEnter():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.HOTSPRING_ENTER);
            this.sendPackage(_local_1);
        }

        public function sendHotSpringRoomCreate(_arg_1:*):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_CREATE);
            _local_2.writeUTF(_arg_1.roomName);
            _local_2.writeUTF(_arg_1.roomPassword);
            _local_2.writeUTF(_arg_1.roomIntroduction);
            _local_2.writeInt(_arg_1.maxCount);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomEdit(_arg_1:*):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
            _local_2.writeByte(HotSpringPackageType.HOTSPRING_ROOM_EDIT);
            _local_2.writeUTF(_arg_1.roomName);
            _local_2.writeUTF(_arg_1.roomPassword);
            _local_2.writeUTF(_arg_1.roomIntroduction);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomQuickEnter():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_QUICK_ENTER);
            this.sendPackage(_local_1);
        }

        public function sendHotSpringRoomEnterConfirm(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomEnter(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER);
            _local_3.writeInt(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendHotSpringRoomEnterView(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_VIEW);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomPlayerRemove():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE);
            this.sendPackage(_local_1);
        }

        public function sendHotSpringRoomPlayerTargetPoint(_arg_1:*):void
        {
            var _local_5:uint;
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
            _local_2.writeByte(HotSpringPackageType.TARGET_POINT);
            var _local_3:Array = _arg_1.walkPath.concat();
            var _local_4:Array = [];
            while (_local_5 < _local_3.length)
            {
                _local_4.push(int(_local_3[_local_5].x), int(_local_3[_local_5].y));
                _local_5++;
            };
            var _local_6:String = _local_4.toString();
            _local_2.writeUTF(_local_6);
            _local_2.writeInt(_arg_1.playerInfo.ID);
            _local_2.writeInt(_arg_1.currentWalkStartPoint.x);
            _local_2.writeInt(_arg_1.currentWalkStartPoint.y);
            _local_2.writeInt(1);
            _local_2.writeInt(_arg_1.playerDirection);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomRenewalFee(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
            _local_2.writeByte(HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomInvite(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
            _local_2.writeByte(HotSpringPackageType.HOTSPRING_ROOM_INVITE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomAdminRemovePlayer(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
            _local_2.writeByte(HotSpringPackageType.HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendHotSpringRoomPlayerContinue(_arg_1:Boolean):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
            _local_2.writeByte(HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendGetTimeBox(_arg_1:int, _arg_2:int=0, _arg_3:int=-1, _arg_4:int=-1):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.GET_TIME_BOX);
            _local_5.writeInt(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeInt(_arg_3);
            _local_5.writeInt(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendAchievementFinish(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_FINISH);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendReworkRank(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.USER_CHANGE_RANK);
            _local_2.writeUTF(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendLookupEffort(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.LOOKUP_EFFORT);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBeginFightNpc():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.FIGHT_NPC);
            this.sendPackage(_local_1);
        }

        public function sendRequestUpdate():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.REQUEST_UPDATE);
            this.sendPackage(_local_1);
        }

        public function sendQuestionReply(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.QUESTION_REPLY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendOpenVip(_arg_1:String, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.VIP_RENEWAL);
            _local_3.writeUTF(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendAcademyRegister(_arg_1:int, _arg_2:Boolean, _arg_3:String=null, _arg_4:Boolean=false):void
        {
            var _local_5:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            _local_5.writeByte(AcademyPackageType.ACADEMY_REGISTER);
            _local_5.writeInt(_arg_1);
            _local_5.writeBoolean(_arg_2);
            _local_5.writeUTF(_arg_3);
            _local_5.writeBoolean(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendAcademyRemoveRegister():void
        {
            var _local_1:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            _local_1.writeByte(AcademyPackageType.ACADEMY_REMOVE);
            this.sendPackage(_local_1);
        }

        public function sendAcademyApprentice(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            _local_3.writeByte(AcademyPackageType.ACADEMY_FOR_APPRENTICE);
            _local_3.writeInt(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendAcademyMaster(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            _local_3.writeByte(AcademyPackageType.ACADEMY_FOR_MASTER);
            _local_3.writeInt(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendAcademyMasterConfirm(_arg_1:Boolean, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            if (_arg_1)
            {
                _local_3.writeByte(AcademyPackageType.MASTER_CONFIRM);
            }
            else
            {
                _local_3.writeByte(AcademyPackageType.MASTER_REFUSE);
            };
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendAcademyApprenticeConfirm(_arg_1:Boolean, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            if (_arg_1)
            {
                _local_3.writeByte(AcademyPackageType.APPRENTICE_CONFIRM);
            }
            else
            {
                _local_3.writeByte(AcademyPackageType.APPRENTICE_REFUSE);
            };
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendAcademyFireMaster(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            _local_2.writeByte(AcademyPackageType.FIRE_MASTER);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendAcademyFireApprentice(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
            _local_2.writeByte(AcademyPackageType.FIRE_APPRENTICE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendUseLog(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.USE_LOG);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBuyGift(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.USER_SEND_GIFTS);
            _local_5.writeUTF(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeInt(_arg_3);
            _local_5.writeInt(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendReloadGift():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.USER_RELOAD_GIFT);
            this.sendPackage(_local_1);
        }

        public function sendSnsMsg(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SNS_MSG_RECEIVE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendFace(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
            _local_2.writeInt(_arg_1);
            _local_2.writeInt(0);
            this.sendPackage(_local_2);
        }

        public function sendOpition(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.OPTION_UPDATE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortionMail(_arg_1:String, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.CONSORTION_MAIL);
            _local_3.writeUTF(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendConsortionPoll(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.POLL_CANDIDATE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortionSkill(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.SKILL_SOCKET);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendOns():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.IM_CMD);
            _local_1.writeByte(IMPackageType.ONS_EQUIP);
            this.sendPackage(_local_1);
        }

        public function sendWithBrithday(_arg_1:Vector.<FriendListPlayer>):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.FRIEND_BRITHDAY);
            _local_2.writeInt(_arg_1.length);
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.writeInt(_arg_1[_local_3].ID);
                _local_2.writeUTF(_arg_1[_local_3].NickName);
                _local_2.writeDate(_arg_1[_local_3].BirthdayDate);
                _local_3++;
            };
            this.sendPackage(_local_2);
        }

        public function sendCollectInfoValidate(_arg_1:int, _arg_2:String):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.COLLECTINFO);
            _local_3.writeByte(_arg_1);
            _local_3.writeUTF(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendGoodsExchange(_arg_1:String, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GOODS_EXCHANGE);
            _local_3.writeUTF(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendCustomFriends(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.IM_CMD);
            _local_4.writeByte(IMPackageType.ADD_CUSTOM_FRIENDS);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeUTF(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendOneOnOneTalk(_arg_1:int, _arg_2:String, _arg_3:Boolean=false):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.IM_CMD);
            _local_4.writeByte(IMPackageType.ONE_ON_ONE_TALK);
            _local_4.writeInt(_arg_1);
            _local_4.writeUTF(_arg_2);
            _local_4.writeBoolean(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendUserLuckyNum(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.USER_LUCKYNUM);
            _local_3.writeBoolean(_arg_2);
            _local_3.writeInt(_arg_1);
            this.sendPackage(_local_3);
        }

        public function sendBuyBadge(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.BUY_BADGE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendStartTurn_LeftGun():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_SOCKET);
            _local_1.writeInt(1);
            this.sendPackage(_local_1);
        }

        public function sendEndTurn_LeftGun():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_COMPLETTE);
            _local_1.writeInt(1);
            this.sendPackage(_local_1);
        }

        public function sendWishBeadEquip(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int):void
        {
            var _local_7:PackageOut = new PackageOut(ePackageType.WISHBEADEQUIP);
            _local_7.writeInt(_arg_1);
            _local_7.writeInt(_arg_2);
            _local_7.writeInt(_arg_3);
            _local_7.writeInt(_arg_4);
            _local_7.writeInt(_arg_5);
            _local_7.writeInt(_arg_6);
            this.sendPackage(_local_7);
        }

        public function sendPetMove(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.PET);
            _local_3.writeByte(PetPackageType.MOVE_PETBAG);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendPetChangeName(_arg_1:String, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.PET);
            _local_3.writeByte(PetPackageType.CHANGE_PETNAME);
            _local_3.writeInt(_arg_2);
            _local_3.writeUTF(_arg_1);
            this.sendPackage(_local_3);
        }

        public function sendUpdatePetSpace():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.PET);
            _local_1.writeByte(PetPackageType.UPDATE_PET_SPACE);
            this.sendPackage(_local_1);
        }

        public function sendPetMagic(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.PET);
            _local_2.writeByte(PetPackageType.MAGIC_PET);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendPetAdvance(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.PET);
            _local_2.writeByte(PetPackageType.ADVANCE_PET);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendPetTransform(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.PET);
            _local_3.writeByte(PetPackageType.TRANSFORM);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendPetSkillUp(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.PET);
            _local_4.writeByte(PetPackageType.SKILL_UP);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function refreshFarm():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.FARM);
            _local_1.writeByte(FarmPackageType.REFRASH_FARM);
            this.sendPackage(_local_1);
        }

        public function seeding(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.FARM);
            _local_3.writeByte(FarmPackageType.SEEDING);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function toGather(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.FARM);
            _local_2.writeByte(FarmPackageType.GAIN_FIELD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function farmSpeed(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.FARM);
            _local_3.writeByte(FarmPackageType.ACCELERATE_FIELD);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function farmLeaving():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.FARM);
            _local_1.writeByte(FarmPackageType.Exit_FARM);
            this.sendPackage(_local_1);
        }

        public function FieldDelete(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.FARM);
            _local_2.writeByte(FarmPackageType.UPROOT_FIELD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendWish():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.WISHOFDD);
            this.sendPackage(_local_1);
        }

        public function sendChangeSex(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.USE_CHANGE_SEX);
            _local_3.writeByte(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function getPlayerPropertyAddition():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.UPDATE_PLAYER_PROPERTY);
            this.sendPackage(_local_1);
        }

        public function enterWorldBossRoom():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_1.writeByte(WorldBossGamePackageType.ENTER_WORLDBOSSROOM);
            this.sendPackage(_local_1);
        }

        public function sendAddPlayer(_arg_1:Point):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_2.writeByte(WorldBossGamePackageType.ADDPLAYERS);
            _local_2.writeInt(_arg_1.x);
            _local_2.writeInt(_arg_1.y);
            this.sendPackage(_local_2);
        }

        public function sendWorldBossRoomMove(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_4.writeByte(WorldBossGamePackageType.MOVE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeUTF(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendWorldBossRoomStauts(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_2.writeByte(WorldBossGamePackageType.STAUTS);
            _local_2.writeByte(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendLeaveBossRoom():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_1.writeByte(WorldBossGamePackageType.LEAVE_ROOM);
            this.sendPackage(_local_1);
        }

        public function sendBuyWorldBossBuff(_arg_1:Array):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_2.writeByte(WorldBossGamePackageType.BUFF_BUY);
            _local_2.writeInt(_arg_1.length);
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.writeInt(_arg_1[_local_3]);
                _local_3++;
            };
            this.sendPackage(_local_2);
        }

        public function sendNewBuyWorldBossBuff():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_1.writeByte(WorldBossGamePackageType.BUFF_BUY);
            _local_1.writeInt(1);
            this.sendPackage(_local_1);
        }

        public function sendWorldBossRequestRevive(_arg_1:int=1):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
            _local_2.writeByte(WorldBossGamePackageType.REQUEST_REVIVE);
            _local_2.writeInt(_arg_1);
            SocketManager.Instance.socket.send(_local_2);
        }

        public function sendRevertPet(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.PET);
            _local_2.writeByte(CrazyTankPackageType.REVER_PET);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendEnterWalkScene(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
            _local_2.writeByte(WalkSencePackageType.ENTER_SENCE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function requestSavePoint(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SAVE_POINT);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function resetSavePoint(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SAVE_POINT_RESET);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendWalkScenePlayerMove(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
            _local_4.writeByte(WalkSencePackageType.PLAYER_MOVE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeUTF(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendSavePoint(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SET_SAVE_POINT);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendWalkSceneObjectClick(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
            _local_2.writeByte(WalkSencePackageType.OBJECT_CLICK);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendExitWalkScene():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
            _local_1.writeByte(WalkSencePackageType.PLAYER_EXIT);
            this.sendPackage(_local_1);
        }

        public function sendOpenBagCell(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.OPEN_BAGCELL);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendFormula(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_2.writeByte(EquipSystemPackageType.COMPOSE_SKILL);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendToGetComposeSkill():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_1.writeByte(EquipSystemPackageType.GET_COMPOSE_SKILL);
            this.sendPackage(_local_1);
        }

        public function sendRefining():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.EQUIP_SYSTEM);
            _local_1.writeByte(EquipSystemPackageType.REFINING);
            this.sendPackage(_local_1);
        }

        public function sendfightVip(_arg_1:int, _arg_2:String=null, _arg_3:int=0):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.FIGHTING_VIP);
            _local_4.writeInt(_arg_1);
            if (_arg_1 == 1)
            {
                _local_4.writeUTF(_arg_2);
                _local_4.writeInt(_arg_3);
            };
            this.sendPackage(_local_4);
        }

        public function sendVipOverdue(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.VIP_OVERDUE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBuyFatigue():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.BUY_FATIGUE);
            this.sendPackage(_local_1);
        }

        public function sendExpeditionStart(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int=0):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.EXPEDITION);
            _local_5.writeByte(ExpeditionType.START_EXPEDITION);
            _local_5.writeByte(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeInt(_arg_3);
            _local_5.writeInt(_arg_4);
            this.sendPackage(_local_5);
        }

        public function sendExpeditionAccelerate():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.EXPEDITION);
            _local_1.writeByte(ExpeditionType.ACCELERATE_EXPEDITION);
            this.sendPackage(_local_1);
        }

        public function sendExpeditionCancle():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.EXPEDITION);
            _local_1.writeByte(ExpeditionType.STOP_EXPEDITION);
            this.sendPackage(_local_1);
        }

        public function sendExpeditionUpdate():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.EXPEDITION);
            _local_1.writeByte(ExpeditionType.UPDATE_EXPEDITION);
            this.sendPackage(_local_1);
        }

        public function sendOpenOneTotem():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.TOTEM_CMD);
            _local_1.writeByte(TotemPackageType.TOTEM);
            this.sendPackage(_local_1);
        }

        public function sendHonorUp(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.TOTEM_CMD);
            _local_2.writeByte(TotemPackageType.HONOR_UP_COUNT);
            _local_2.writeByte(_arg_1);
            this.sendPackage(_local_2);
        }

        public function syncLifeTime():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.SYNC_LIFETIME);
            this.sendPackage(_local_1);
        }

        public function sendTimeValidate(_arg_1:int, _arg_2:Date):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.SYS_DATE);
            _local_3.writeByte(_arg_1);
            _local_3.writeDate(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendCDColling(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.MINING_DUNGEON);
            _local_2.writeByte(MiningPackageType.CD_COOLING_TIME);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendOnlineReawd():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.ONLINE_REWADS);
            this.sendPackage(_local_1);
        }

        public function sendEnterRemoveCD(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
            _local_2.writeByte(WalkSencePackageType.REMOVE_CD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendConsortionPublishTask(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.PUBLISH_TASK);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function SendenterConsortion(_arg_1:Boolean=false):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.ENTER_CONSORTION);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function SendenterConsortionTransport():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.ENTER_TRNSPORT);
            this.sendPackage(_local_1);
        }

        public function SendexitConsortion():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.EXIT_CONSORTION);
            this.sendPackage(_local_1);
        }

        public function SendBeginConvoy(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.GEGIN_CONVOY);
            _local_2.writeByte(_arg_1);
            this.sendPackage(_local_2);
        }

        public function SendInviteConvoy(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.INVITE_CONVOY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function SendInviteAnswer(_arg_1:int, _arg_2:String, _arg_3:Boolean):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_4.writeInt(ConsortiaPackageType.CONVOY_INVITE_ANSWER);
            _local_4.writeInt(_arg_1);
            _local_4.writeUTF(_arg_2);
            _local_4.writeBoolean(_arg_3);
            this.sendPackage(_local_4);
        }

        public function SendCancleConvoyInvite(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.CANCLE_CONVOY_INVITE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function SendexitConsortionTransport():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.EXIT_CONSORTION_TRANSPORT);
            this.sendPackage(_local_1);
        }

        public function SendCarReceive():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CAR_RECEIVE);
            this.sendPackage(_local_1);
        }

        public function SendHijackCar(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_3.writeInt(ConsortiaPackageType.HIJACK_CAR);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function SendHijackAnswer(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:Boolean):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_5.writeInt(ConsortiaPackageType.HIJACK_ANSWER);
            _local_5.writeInt(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeUTF(_arg_3);
            _local_5.writeBoolean(_arg_4);
            this.sendPackage(_local_5);
        }

        public function SendConsortionWalkScenePlayeMove(_arg_1:int, _arg_2:int, _arg_3:String):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_4.writeInt(ConsortiaPackageType.CONSORTIONSENCE_MOVEPLAYER);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeUTF(_arg_3);
            this.sendPackage(_local_4);
        }

        public function SendOpenConsortionCampaign():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.CONSORTIA_UPDATE_QUEST);
            this.sendPackage(_local_1);
        }

        public function SendOpenLivenessFrame():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
            _local_1.writeInt(DailyQuestPackageType.UPDATE);
            this.sendPackage(_local_1);
        }

        public function SendGetDailyQuestReward(_arg_1:uint):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
            _local_2.writeInt(DailyQuestPackageType.REWARD);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function SendGetDailyQuestOneKey(_arg_1:uint):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
            _local_2.writeInt(DailyQuestPackageType.ONE_KEY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendEnterRandomPve():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
            _local_1.writeInt(DailyQuestPackageType.RANDOM_PVE);
            this.sendPackage(_local_1);
        }

        public function sendEnterRandomScene(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DAILY_QUEST);
            _local_2.writeInt(DailyQuestPackageType.RANDOM_SCENE);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function SendBuyCar(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.BUY_CAR);
            _local_2.writeByte(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendRequestConsortionQuest(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaPackageType.REQUEST_CONSORTIA_QUEST);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendStartFightWithMonster(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_2.writeInt(ConsortiaMonsterPackageTypes.FIGHT_MONSTER);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendAddMonsterRequest():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaMonsterPackageTypes.ACTIVE_STATE);
            this.sendPackage(_local_1);
        }

        public function sendShopRefreshGood():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
            _local_1.writeInt(ConsortiaPackageType.SHOP_REFRESH_GOOD);
            this.sendPackage(_local_1);
        }

        public function sendAskForActiviLog(_arg_1:String, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.ACTIVE_LOG);
            _local_4.writeUTF(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendGetActivityAward(_arg_1:String, _arg_2:int, _arg_3:Object=null):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.ACTIVE_GET);
            _local_4.writeUTF(_arg_1);
            _local_4.writeInt(_arg_2);
            if (_arg_3 != null)
            {
                if (_arg_3["giftbagOrder"] != null)
                {
                    _local_4.writeInt(_arg_3["giftbagOrder"]);
                };
            };
            this.sendPackage(_local_4);
        }

        public function sendArenaEnterScene(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_3.writeInt(ArenaPackageTypes.ENTER_SCENE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendArenaExitScene(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_3.writeInt(ArenaPackageTypes.EXIT_SCENE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendArenaPlayerMove(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String):void
        {
            var _local_6:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_6.writeInt(ArenaPackageTypes.MOVE_SCENE);
            _local_6.writeInt(_arg_1);
            _local_6.writeInt(_arg_2);
            _local_6.writeInt(_arg_3);
            _local_6.writeInt(_arg_4);
            _local_6.writeUTF(_arg_5);
            this.sendPackage(_local_6);
        }

        public function sendArenaPlayerFight(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_4.writeInt(ArenaPackageTypes.FIGHT_SCENE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendArenaRelive(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_4.writeInt(ArenaPackageTypes.RELIVE_SCENE);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendArenaUpdate(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_3.writeInt(ArenaPackageTypes.UPDATE_SCENE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            this.sendPackage(_local_3);
        }

        public function sendAskForActivityType():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.ARENA);
            _local_1.writeInt(ArenaPackageTypes.ACTIVITY_TYPE);
            this.sendPackage(_local_1);
        }

        public function sendAskForRankShopRecord():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.RANK_SHOP);
            this.sendPackage(_local_1);
        }

        public function sendInvitedFriendAward(_arg_1:uint, _arg_2:uint, _arg_3:Number):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.CLOSE_FRIEND_REWARD);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeLong(_arg_3);
            this.sendPackage(_local_4);
        }

        public function sendSingleDungeonModeInfo():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.WALKSENCE_CMD);
            _local_1.writeInt(WalkSencePackageType.UPDATE_DUNGEONMODE_INFO);
            this.sendPackage(_local_1);
        }

        public function sendTurnPlateReady():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
            _local_1.writeByte(TurnPlatePackageType.LOTTERY_START);
            _local_1.writeInt(1);
            this.sendPackage(_local_1);
        }

        public function sendTurnPlateStart(_arg_1:Boolean):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
            _local_2.writeByte(TurnPlatePackageType.LOTTERY_RANDOM);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendTurnPlateStop():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
            _local_1.writeByte(TurnPlatePackageType.LOTTERY_FINISH);
            this.sendPackage(_local_1);
        }

        public function requestTurnPlateStatus():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
            _local_1.writeByte(TurnPlatePackageType.LOTTERY_STATE);
            this.sendPackage(_local_1);
        }

        public function sendQuickBuyBoguCoin(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.RANDOM_BOX);
            _local_2.writeByte(TurnPlatePackageType.LOTTERY_BUY);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendReturnEnergyRequest(_arg_1:Boolean):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.ENERGY_RETURN);
            _local_2.writeBoolean(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendOpenFightRobotView():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
            _local_1.writeByte(FightRobotPackageType.OPEN_FRAME);
            this.sendPackage(_local_1);
        }

        public function sendFightRobot():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
            _local_1.writeByte(FightRobotPackageType.BEGIN_FIGHT_ROBOT);
            this.sendPackage(_local_1);
        }

        public function sendFightRobotCoolDown():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
            _local_1.writeByte(FightRobotPackageType.CLEAR_CD);
            this.sendPackage(_local_1);
        }

        public function sendRevengeRobot(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SHADOW_NPC);
            _local_2.writeByte(FightRobotPackageType.REVENGE_ROBOT);
            _local_2.writeInt(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendDailyReceive(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
            _local_2.writeByte(_arg_1);
            this.sendPackage(_local_2);
        }

        public function sendBuyItemInActivity(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.BUY_ACTVITY);
            _local_5.writeInt(_arg_1);
            _local_5.writeUTF(_arg_2);
            _local_5.writeInt(_arg_3);
            _local_5.writeInt(_arg_4);
            this.sendPackage(_local_5);
        }


    }
}//package ddt.manager

