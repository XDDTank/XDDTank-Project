// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.DDT

package ddt
{
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import ddt.manager.DesktopManager;
    import ddt.manager.PlayerManager;
    import ddt.data.ConfigParaser;
    import ddt.loader.StartupResourceLoader;
    import com.pickgliss.loader.LoadInterfaceManager;
    import ddt.manager.ServerManager;
    import par.ShapeManager;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatBugleView;
    import ddt.manager.StageFocusManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.manager.PlayerStateManager;
    import bead.BeadManager;
    import turnplate.TurnPlateController;
    import weekend.WeekendManager;
    import flash.events.Event;
    import com.pickgliss.events.ResourceLoaderEvent;
    import ddt.data.AccountInfo;
    import com.pickgliss.utils.StringUtils;
    import ddt.manager.LeavePageManager;
    import ddt.utils.CrytoUtils;
    import ddt.manager.TimerOpenManager;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.QueueManager;
    import ddt.manager.TimeManager;
    import ddt.manager.SoundManager;
    import ddt.data.PathInfo;
    import ddt.manager.PathManager;
    import im.IMController;
    import ddt.manager.SharedManager;
    import calendar.CalendarManager;
    import room.RoomManager;
    import game.GameManager;
    import org.aswing.KeyboardManager;
    import ddt.manager.ChurchManager;
    import ddt.manager.GradeExaltClewManager;
    import ddt.data.ColorEnum;
    import com.pickgliss.ui.LayerManager;
    import ddt.states.StateCreater;
    import exitPrompt.ExitPromptManager;
    import cityWide.CityWideManager;
    import game.view.WindPowerManager;
    import ddt.manager.QQtipsManager;
    import ddt.manager.EdictumManager;
    import farm.FarmModelController;
    import ddt.manager.PetBagManager;
    import worldboss.WorldBossManager;
    import consortion.consortionsence.ConsortionManager;
    import consortion.transportSence.TransportManager;
    import consortion.managers.ConsortionMonsterManager;
    import consortion.ConosrtionTimerManager;
    import liveness.LivenessBubbleManager;
    import ddt.manager.DynamicManager;
    import ddt.manager.DialogManager;
    import SingleDungeon.hardMode.HardModeManager;
    import com.pickgliss.ui.ComponentSetting;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.AlertManager;

    public class DDT 
    {

        public static var SERVER_ID:int = -1;
        public static const THE_HIGHEST_LV:int = 60;

        private var _alerLayer:Sprite;
        private var _allowMulti:Boolean;
        private var _gameLayer:Sprite;
        private var _musicList:Array;
        private var _pass:String;
        private var _user:String;
        private var _rid:String;
        private var numCh:Number;
        private var _loaded:Boolean = false;


        private function onClick(_arg_1:MouseEvent):void
        {
            var _local_3:DisplayObject;
            this.numCh = 0;
            var _local_2:int;
            while (_local_2 < StageReferance.stage.numChildren)
            {
                _local_3 = StageReferance.stage.getChildAt(_local_2);
                _local_3.visible = true;
                this.numCh++;
                if ((_local_3 is DisplayObjectContainer))
                {
                    this.show(DisplayObjectContainer(_local_3));
                };
                _local_2++;
            };
        }

        private function show(_arg_1:DisplayObjectContainer):void
        {
            var _local_3:DisplayObject;
            var _local_2:int;
            while (_local_2 < _arg_1.numChildren)
            {
                _local_3 = _arg_1.getChildAt(_local_2);
                _local_3.visible = true;
                this.numCh++;
                if ((_local_3 is DisplayObjectContainer))
                {
                    this.show(DisplayObjectContainer(_local_3));
                };
                _local_2++;
            };
        }

        public function lunch(_arg_1:XML, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:String="", _arg_6:String=""):void
        {
            DesktopManager.Instance.checkIsDesktop();
            PlayerManager.Instance.Self.baiduEnterCode = _arg_6;
            this._user = _arg_2;
            this._pass = _arg_3;
            this._rid = _arg_5;
            PlayerManager.Instance.Self.rid = this._rid;
            ConfigParaser.paras(_arg_1, StageReferance.stage.loaderInfo, this._user);
            this.setup();
            StartupResourceLoader.Instance.start(_arg_4);
        }

        public function changeAccount(_arg_1:String):void
        {
            PlayerManager.Instance.Account.Password = _arg_1;
        }

        public function enterGame():void
        {
            LoadInterfaceManager.traceMsg("enterGame");
            ServerManager.Instance.addEventListener(ServerManager.GAME_BEGIN, this.__gameBegin);
            ShapeManager.clear();
            ChatManager.Instance.setup();
            ChatBugleView.instance.setup();
            StageFocusManager.getInstance().setup(StageReferance.stage);
            StateManager.setState(StateType.LOGIN);
            PlayerStateManager.Instance.setup();
            BeadManager.instance.setup();
            TurnPlateController.Instance.setup();
            WeekendManager.instance.setup();
        }

        private function __gameBegin(_arg_1:Event):void
        {
            LoadInterfaceManager.traceMsg("GameBegin");
            ServerManager.Instance.removeEventListener(ServerManager.GAME_BEGIN, this.__gameBegin);
            StartupResourceLoader.Instance.sendGameBegin();
        }

        private function __onCoreSetupLoadComplete(_arg_1:ResourceLoaderEvent):void
        {
            StartupResourceLoader.Instance.removeEventListener(ResourceLoaderEvent.CORE_SETUP_COMPLETE, this.__onCoreSetupLoadComplete);
            ChatManager.Instance.setup();
            ChatBugleView.instance.setup();
            StageFocusManager.getInstance().setup(StageReferance.stage);
            StateManager.setState(StateType.LOGIN);
            PlayerStateManager.Instance.setup();
        }

        private function setup():void
        {
            var _local_1:String;
            var _local_2:String;
            var _local_3:AccountInfo;
            if (StringUtils.isEmpty(this._user))
            {
                LeavePageManager.leaveToLoginPath();
            }
            else
            {
                this.setupComponent();
                _local_1 = "AM0UncxXJ2YzgsQzJFlG7kYIjmSEJZO362TIRJUNGu1amSPVYFN/pcKNIIWS1NxoOt5DmNlMiebxaUHcCVEMnbBd9+2QFCc+K8BkbfzDS+9MJu9Zxn5nT7+CDRvg8id2cRWsMBNc0jIzDqkLWOCFfIYrPx5YF7lHyB1QyvO5zDS3";
                _local_2 = "AQAB";
                _local_3 = new AccountInfo();
                _local_3.Account = this._user;
                _local_3.Password = this._pass;
                _local_3.Key = CrytoUtils.generateRsaKey(_local_1, _local_2);
                PlayerManager.Instance.setup(_local_3);
                TimerOpenManager.Instance.setup();
                ShowTipManager.Instance.setup();
                QueueManager.setup(StageReferance.stage);
                TimeManager.Instance.setup();
                SoundManager.instance.setup(PathInfo.MUSIC_LIST, PathManager.SITE_MAIN);
                IMController.Instance.setup();
                SharedManager.Instance.setup();
                CalendarManager.getInstance().initialize();
                RoomManager.Instance.setup();
                GameManager.Instance.setup();
                KeyboardManager.getInstance().init(StageReferance.stage);
                ChurchManager.instance.setup();
                GradeExaltClewManager.getInstance().setup();
                ColorEnum.initColor();
                StateManager.setup(LayerManager.Instance.getLayerByType(LayerManager.GAME_BASE_LAYER), new StateCreater());
                ExitPromptManager.Instance.init();
                CityWideManager.Instance.init();
                WindPowerManager.Instance.init();
                QQtipsManager.instance.setup();
                EdictumManager.Instance.setup();
                FarmModelController.instance.setup();
                PetBagManager.instance().setup();
                WorldBossManager.Instance.setup();
                ConsortionManager.Instance.setup();
                TransportManager.Instance.setup();
                ConsortionMonsterManager.Instance.setup();
                ConosrtionTimerManager.Instance.setup();
                LivenessBubbleManager.Instance.setup();
                if (PathManager.CommunityExist())
                {
                    DynamicManager.Instance.initialize();
                };
                DialogManager.Instance.setup(PathManager.getDialogConfigPath());
                HardModeManager.instance.setup();
            };
        }

        private function setupComponent():void
        {
            ComponentSetting.COMBOX_LIST_LAYER = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
            ComponentSetting.PLAY_SOUND_FUNC = SoundManager.instance.play;
            ComponentSetting.SEND_USELOG_ID = SocketManager.Instance.out.sendUseLog;
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.mutiline = true;
            _local_1.buttonGape = 15;
            _local_1.autoDispose = true;
            _local_1.sound = "008";
            AlertManager.Instance.setup(LayerManager.STAGE_DYANMIC_LAYER, _local_1);
        }

        private function soundPlay():void
        {
            SoundManager.instance.play("008");
        }


    }
}//package ddt

