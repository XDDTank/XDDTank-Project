// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportSenceStateView

package consortion.transportSence
{
    import ddt.states.BaseStateView;
    import consortion.consortionsence.ConsortionSenceWalkMapView;
    import ddt.manager.InviteManager;
    import ddt.view.MainToolBar;
    import consortion.ConsortionModel;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.data.player.PlayerInfo;
    import consortion.consortionsence.ConsortionWalkPlayerInfo;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import consortion.consortionsence.ConsortionManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.states.StateType;

    public class TransportSenceStateView extends BaseStateView 
    {

        private var _view:ConsortionSenceWalkMapView;


        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            InviteManager.Instance.enabled = false;
            super.enter(_arg_1, _arg_2);
            MainToolBar.Instance.show();
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._view = new ConsortionSenceWalkMapView(this, ConsortionModel.CONSORTION_TRANSPORT);
            this._view.show();
        }

        private function addEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_ADDPLAYER, this.__addPlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_MOVEPLAYER, this.__movePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXIT_CONSORTION, this.__removePlayer);
        }

        private function __addPlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:PlayerInfo = new PlayerInfo();
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
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            _local_3.FightPower = _local_2.readInt();
            _local_3.WinCount = _local_2.readInt();
            _local_3.TotalCount = _local_2.readInt();
            _local_3.Offer = _local_2.readInt();
            _local_3.commitChanges();
            var _local_6:ConsortionWalkPlayerInfo = new ConsortionWalkPlayerInfo();
            _local_6.playerInfo = _local_3;
            _local_6.playerPos = new Point(_local_4, _local_5);
            if (_local_3.ID == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            TransportManager.Instance.transportModel.addPlayer(_local_6);
        }

        private function __movePlayer(_arg_1:CrazyTankSocketEvent):void
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

        private function __removePlayer(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            if (_local_2 == PlayerManager.Instance.Self.ID)
            {
                StateManager.setState(this.getBackType());
            }
            else
            {
                ConsortionManager.Instance._consortionWalkMode.removePlayer(_local_2);
            };
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_ADDPLAYER, this.__addPlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIONSENCE_MOVEPLAYER, this.__movePlayer);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.EXIT_CONSORTION, this.__removePlayer);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            InviteManager.Instance.enabled = true;
            this.removeEvent();
            SocketManager.Instance.out.SendexitConsortionTransport();
            if (this._view)
            {
                ObjectUtils.disposeObject(this._view);
            };
            this._view = null;
            super.leaving(_arg_1);
        }

        override public function getType():String
        {
            return (StateType.CONSORTION_TRANSPORT);
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._view = null;
        }


    }
}//package consortion.transportSence

