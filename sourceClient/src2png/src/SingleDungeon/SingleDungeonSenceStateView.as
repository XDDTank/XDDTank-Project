// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.SingleDungeonSenceStateView

package SingleDungeon
{
    import ddt.states.BaseStateView;
    import SingleDungeon.view.SingleDungeonWalkMapView;
    import ddt.manager.InviteManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.MainToolBar;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.data.player.PlayerInfo;
    import SingleDungeon.model.SingleDungeonPlayerInfo;
    import road7th.comm.PackageIn;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.states.StateType;

    public class SingleDungeonSenceStateView extends BaseStateView 
    {

        public static const MAX_PLAYER_COUNT:int = 5;
        private static var _instance:SingleDungeonSenceStateView;

        private var _view:SingleDungeonWalkMapView;


        public static function get Instance():SingleDungeonSenceStateView
        {
            if ((!(_instance)))
            {
                _instance = new (SingleDungeonSenceStateView)();
            };
            return (_instance);
        }


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            InviteManager.Instance.enabled = false;
            super.enter(_arg_1, _arg_2);
            LayerManager.Instance.clearnGameDynamic();
            LayerManager.Instance.clearnStageDynamic();
            MainToolBar.Instance.show();
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._view = new SingleDungeonWalkMapView(this, SingleDungeonManager.Instance._singleDungeonWalkMapModel);
            this._view.show();
        }

        private function addEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_INFO, this.__addPlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_MOVE, this.__movePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_EXIT, this.__removePlayer);
        }

        public function __addPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:PlayerInfo;
            var _local_4:int;
            var _local_5:int;
            var _local_6:SingleDungeonPlayerInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_arg_1.pkg.bytesAvailable > 10)
            {
                _local_3 = new PlayerInfo();
                _local_3.beginChanges();
                _local_3.Grade = _local_2.readInt();
                _local_3.Hide = _local_2.readInt();
                _local_3.Repute = _local_2.readInt();
                _local_3.ID = _local_2.readInt();
                _local_3.NickName = _local_2.readUTF();
                _local_3.VIPtype = _local_2.readByte();
                _local_3.VIPLevel = _local_2.readInt();
                _local_3.Sex = _local_2.readBoolean();
                _local_3.Style = _local_2.readUTF();
                _local_3.Colors = _local_2.readUTF();
                _local_3.Skin = _local_2.readUTF();
                _local_4 = _local_2.readInt();
                _local_5 = _local_2.readInt();
                _local_3.FightPower = _local_2.readInt();
                _local_3.WinCount = _local_2.readInt();
                _local_3.TotalCount = _local_2.readInt();
                _local_3.Offer = _local_2.readInt();
                _local_3.commitChanges();
                _local_6 = new SingleDungeonPlayerInfo();
                _local_6.playerInfo = _local_3;
                _local_6.playerPos = new Point(_local_4, _local_5);
                if (_local_3.ID == PlayerManager.Instance.Self.ID)
                {
                    return;
                };
                SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(_local_6);
                SingleDungeonManager.Instance._singleDungeonWalkMapModel.removeRobot();
            };
        }

        public function __removePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                StateManager.setState(this.getBackType());
            }
            else
            {
                SingleDungeonManager.Instance._singleDungeonWalkMapModel.removePlayer(_local_2);
                SingleDungeonManager.Instance._singleDungeonWalkMapModel.addPlayer(SingleDungeonManager.Instance.robotList.pop());
            };
        }

        public function __movePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_9:Point;
            var _local_2:int = _arg_1.pkg.readInt();
            var _local_3:int = _arg_1.pkg.readInt();
            var _local_4:int = _arg_1.pkg.readInt();
            var _local_5:String = _arg_1.pkg.readUTF();
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            var _local_6:Array = _local_5.split(",");
            var _local_7:Array = [];
            var _local_8:uint;
            while (_local_8 < _local_6.length)
            {
                _local_9 = new Point(_local_6[_local_8], _local_6[(_local_8 + 1)]);
                _local_7.push(_local_9);
                _local_8 = (_local_8 + 2);
            };
            this._view.movePlayer(_local_2, _local_7);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            InviteManager.Instance.enabled = true;
            SocketManager.Instance.out.sendExitWalkScene();
            this.removeEvent();
            if (this._view)
            {
                ObjectUtils.disposeObject(this._view);
            };
            this._view = null;
            super.leaving(_arg_1);
        }

        override public function getBackType():String
        {
            return (StateType.SINGLEDUNGEON);
        }

        override public function getType():String
        {
            return (StateType.SINGLEDUNGEON_WALK_MAP);
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_INFO, this.__addPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_MOVE, this.__movePlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_PLAYER_EXIT, this.__removePlayer);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._view = null;
        }


    }
}//package SingleDungeon

