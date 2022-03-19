// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.states.BaseRoomState

package room.view.states
{
    import ddt.states.BaseStateView;
    import room.model.RoomInfo;
    import room.view.roomView.BaseRoomView;
    import par.ShapeManager;
    import par.ParticleManager;
    import ddt.manager.PathManager;
    import ddt.loader.StartupResourceLoader;
    import ddt.manager.SoundManager;
    import room.RoomManager;
    import ddt.view.MainToolBar;
    import ddt.manager.PlayerManager;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.manager.ChatManager;
    import game.GameManager;
    import ddt.manager.StateManager;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;
    import ddt.events.CrazyTankSocketEvent;

    public class BaseRoomState extends BaseStateView 
    {

        protected var _info:RoomInfo;
        protected var _roomView:BaseRoomView;

        public function BaseRoomState()
        {
            if ((!(ShapeManager.ready)))
            {
                ParticleManager.initPartical(PathManager.FLASHSITE);
            };
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1, _arg_2);
            if ((!(StartupResourceLoader.firstEnterHall)))
            {
                SoundManager.instance.playMusic("065");
            };
            this._info = RoomManager.Instance.current;
            MainToolBar.Instance.show();
            if (this._info.selfRoomPlayer.isViewer)
            {
                MainToolBar.Instance.setRoomStartState();
                MainToolBar.Instance.setReturnEnable(true);
            };
            MainToolBar.Instance.setReturnEnable(true);
            if (PlayerManager.Instance.hasTempStyle)
            {
                PlayerManager.Instance.readAllTempStyleEvent();
            };
            this.initEvents();
            CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
            CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT, 1200);
            addChild(ChatManager.Instance.view);
            ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
            ChatManager.Instance.setFocus();
            RoomManager.Instance.findLoginRoom = false;
        }

        protected function initEvents():void
        {
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading);
            StateManager.getInGame_Step_1 = true;
        }

        protected function removeEvents():void
        {
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            StateManager.getInGame_Step_8 = true;
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            this.removeEvents();
            if (this._roomView)
            {
                this._roomView.dispose();
                this._roomView = null;
            };
            this._info = null;
            if (((StateManager.isExitRoom(_arg_1.getType())) && (!(RoomManager.Instance.findLoginRoom))))
            {
                GameInSocketOut.sendGamePlayerExit();
                GameManager.Instance.reset();
                RoomManager.Instance.reset();
            };
            MainToolBar.Instance.enableAll();
            super.leaving(_arg_1);
        }

        protected function __startLoading(_arg_1:Event):void
        {
            StateManager.getInGame_Step_6 = true;
            ChatManager.Instance.input.faceEnabled = false;
            LayerManager.Instance.clearnGameDynamic();
            GameManager.Instance.gotoRoomLoading();
            StateManager.getInGame_Step_7 = true;
        }

        private function __onFightNpc(_arg_1:CrazyTankSocketEvent):void
        {
        }


    }
}//package room.view.states

