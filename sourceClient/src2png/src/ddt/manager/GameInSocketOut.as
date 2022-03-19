// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.GameInSocketOut

package ddt.manager
{
    import road7th.comm.ByteSocket;
    import road7th.comm.PackageOut;
    import ddt.data.socket.ePackageType;
    import ddt.data.socket.GameRoomPackageType;
    import ddt.data.socket.CrazyTankPackageType;
    import flash.geom.Point;

    public class GameInSocketOut 
    {

        private static var _socket:ByteSocket = SocketManager.Instance.socket;


        public static function sendGetScenePlayer(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.SCENE_USERS_LIST);
            _local_2.writeByte(_arg_1);
            _local_2.writeByte(7);
            sendPackage(_local_2);
        }

        public static function sendInviteGame(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_INVITE);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendInviteDungeon():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_INVITE);
            _local_1.writeInt(0);
            sendPackage(_local_1);
        }

        public static function sendBuyProp(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.PROP_BUY);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendSellProp(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.PROP_SELL);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            sendPackage(_local_3);
        }

        public static function sendGameRoomSetUp(_arg_1:int, _arg_2:int, _arg_3:Boolean=false, _arg_4:String="", _arg_5:String="", _arg_6:int=2, _arg_7:int=0, _arg_8:int=0, _arg_9:Boolean=false, _arg_10:int=0):void
        {
            var _local_11:int = ((PlayerManager.Instance.Self.Grade < 5) ? 4 : _arg_6);
            var _local_12:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_12.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
            _local_12.writeInt(_arg_1);
            _local_12.writeByte(_arg_2);
            _local_12.writeBoolean(_arg_3);
            _local_12.writeUTF(_arg_4);
            _local_12.writeUTF(_arg_5);
            _local_12.writeByte(_local_11);
            _local_12.writeByte(_arg_7);
            _local_12.writeInt(_arg_8);
            _local_12.writeBoolean(_arg_9);
            _local_12.writeInt(_arg_10);
            sendPackage(_local_12);
        }

        public static function sendCreateRoom(_arg_1:String, _arg_2:int, _arg_3:int=2, _arg_4:String=""):void
        {
            var _local_5:int = ((PlayerManager.Instance.Self.Grade < 5) ? 4 : _arg_3);
            var _local_6:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_6.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
            _local_6.writeByte(_arg_2);
            _local_6.writeByte(_local_5);
            _local_6.writeUTF(_arg_1);
            _local_6.writeUTF(_arg_4);
            sendPackage(_local_6);
        }

        public static function sendGameRoomPlaceState(_arg_1:int, _arg_2:int, _arg_3:Boolean=false, _arg_4:int=-100):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_5.writeInt(GameRoomPackageType.GAME_ROOM_UPDATE_PLACE);
            _local_5.writeByte(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeBoolean(_arg_3);
            _local_5.writeInt(_arg_4);
            sendPackage(_local_5);
        }

        public static function sendGameRoomKick(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_2.writeInt(GameRoomPackageType.GAME_ROOM_KICK);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendExitScene():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
            sendPackage(_local_1);
        }

        public static function sendGamePlayerExit():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_1.writeInt(GameRoomPackageType.GAME_ROOM_REMOVEPLAYER);
            sendPackage(_local_1);
        }

        public static function sendGameTeam(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_2.writeInt(GameRoomPackageType.GAME_TEAM);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendFlagMode(_arg_1:Boolean):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.WANNA_LEADER);
            _local_2.writeBoolean(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGameStart():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_1.writeInt(GameRoomPackageType.GAME_START);
            sendPackage(_local_1);
        }

        public static function sendGameMissionStart(_arg_1:Boolean):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_MISSION_START);
            _local_2.writeBoolean(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGameMissionPrepare(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_3.writeByte(CrazyTankPackageType.GAME_MISSION_PREPARE);
            _local_3.writeBoolean(_arg_2);
            sendPackage(_local_3);
        }

        public static function sendLoadingProgress(_arg_1:Number):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.LOAD);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendPlayerState(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_2.writeInt(GameRoomPackageType.GAME_PLAYER_STATE_CHANGE);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGameCMDBlast(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            var _local_5:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_5.writeByte(CrazyTankPackageType.BLAST);
            _local_5.writeInt(_arg_1);
            _local_5.writeInt(_arg_2);
            _local_5.writeInt(_arg_3);
            _local_5.writeInt(_arg_4);
            sendPackage(_local_5);
        }

        public static function sendGameCMDChange(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_6:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_6.writeByte(CrazyTankPackageType.CHANGEBALL);
            _local_6.writeInt(_arg_1);
            _local_6.writeInt(_arg_2);
            _local_6.writeInt(_arg_3);
            _local_6.writeInt(_arg_4);
            _local_6.writeInt(_arg_5);
            sendPackage(_local_6);
        }

        public static function sendGameCMDDirection(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.DIRECTION);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGameCMDStunt(_arg_1:int=0):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.STUNT);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGameCMDShoot(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int=0, _arg_6:Boolean=false):void
        {
            var _local_7:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_7.writeByte(CrazyTankPackageType.FIRE);
            _local_7.writeInt(_arg_5);
            _local_7.writeInt(int(_arg_1));
            _local_7.writeInt(int(_arg_2));
            _local_7.writeInt(int(_arg_3));
            _local_7.writeInt(int(_arg_4));
            _local_7.writeBoolean(_arg_6);
            sendPackage(_local_7);
        }

        public static function sendGameSkipNext(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.SKIPNEXT);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGameStartMove(_arg_1:Number, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:Boolean, _arg_6:Number):void
        {
            var _local_7:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_7.writeByte(CrazyTankPackageType.MOVESTART);
            _local_7.writeByte(_arg_1);
            _local_7.writeInt(_arg_2);
            _local_7.writeInt(_arg_3);
            _local_7.writeByte(_arg_4);
            _local_7.writeBoolean(_arg_5);
            _local_7.writeShort(_arg_6);
            sendPackage(_local_7);
        }

        public static function sendGameStopMove(_arg_1:int, _arg_2:int, _arg_3:Boolean):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_4.writeByte(CrazyTankPackageType.MOVESTOP);
            _local_4.writeInt(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeBoolean(_arg_3);
            sendPackage(_local_4);
        }

        public static function sendGameTakeOut(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.TAKE_CARD);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendBossTakeOut(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.BOSS_TAKE_CARD);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGetTropToBag(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendShootTag(_arg_1:Boolean, _arg_2:int=0):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_3.writeByte(CrazyTankPackageType.FIRE_TAG);
            _local_3.writeBoolean(_arg_1);
            if (_arg_1)
            {
                _local_3.writeByte(_arg_2);
            };
            sendPackage(_local_3);
        }

        public static function sendBeat(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_4.writeByte(CrazyTankPackageType.BEAT);
            _local_4.writeShort(_arg_1);
            _local_4.writeShort(_arg_2);
            _local_4.writeShort(_arg_3);
            sendPackage(_local_4);
        }

        public static function sendThrowProp(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(CrazyTankPackageType.PROP_DELETE);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendUseProp(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            var _local_4:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_4.writeByte(CrazyTankPackageType.PROP);
            _local_4.writeByte(_arg_1);
            _local_4.writeInt(_arg_2);
            _local_4.writeInt(_arg_3);
            sendPackage(_local_4);
        }

        public static function sendCancelWait():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_1.writeInt(GameRoomPackageType.GAME_PICKUP_CANCEL);
            sendPackage(_local_1);
        }

        public static function sendGameStyle(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
            _local_2.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
            _local_2.writeInt(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendGhostTarget(_arg_1:Point):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.GHOST_TARGET);
            _local_2.writeInt(_arg_1.x);
            _local_2.writeInt(_arg_1.y);
            sendPackage(_local_2);
        }

        public static function sendPaymentTakeCard(_arg_1:int):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.PAYMENT_TAKE_CARD);
            _local_2.writeByte(_arg_1);
            sendPackage(_local_2);
        }

        public static function sendMissionTryAgain(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_3.writeByte(CrazyTankPackageType.GAME_MISSION_TRY_AGAIN);
            _local_3.writeInt(_arg_1);
            _local_3.writeBoolean(_arg_2);
            sendPackage(_local_3);
        }

        public static function sendFightLibInfoChange(_arg_1:int, _arg_2:int=-1):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_3.writeByte(CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            sendPackage(_local_3);
        }

        public static function sendPassStory():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.PASS_STORY);
            _local_1.writeBoolean(true);
            sendPackage(_local_1);
        }

        public static function sendClientScriptStart():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
            _local_1.writeInt(3);
            sendPackage(_local_1);
        }

        public static function sendClientScriptEnd():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
            _local_1.writeInt(2);
            sendPackage(_local_1);
        }

        public static function sendFightLibAnswer(_arg_1:int, _arg_2:int):void
        {
            var _local_3:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_3.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
            _local_3.writeInt(4);
            _local_3.writeInt(_arg_1);
            _local_3.writeInt(_arg_2);
            sendPackage(_local_3);
        }

        public static function sendFightLibReanswer():void
        {
            var _local_1:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_1.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
            _local_1.writeInt(5);
            sendPackage(_local_1);
        }

        public static function sendUpdatePlayStep(_arg_1:String):void
        {
            var _local_2:PackageOut = new PackageOut(ePackageType.GAME_CMD);
            _local_2.writeByte(CrazyTankPackageType.MISSION_CMD);
            _local_2.writeInt(6);
            _local_2.writeUTF(_arg_1);
            sendPackage(_local_2);
        }

        private static function sendPackage(_arg_1:PackageOut):void
        {
            _socket.send(_arg_1);
        }


    }
}//package ddt.manager

