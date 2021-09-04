package ddt
{
   import SingleDungeon.hardMode.HardModeManager;
   import bead.BeadManager;
   import calendar.CalendarManager;
   import cityWide.CityWideManager;
   import com.pickgliss.events.ResourceLoaderEvent;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.StringUtils;
   import consortion.ConosrtionTimerManager;
   import consortion.consortionsence.ConsortionManager;
   import consortion.managers.ConsortionMonsterManager;
   import consortion.transportSence.TransportManager;
   import ddt.data.AccountInfo;
   import ddt.data.ColorEnum;
   import ddt.data.ConfigParaser;
   import ddt.data.PathInfo;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.DesktopManager;
   import ddt.manager.DialogManager;
   import ddt.manager.DynamicManager;
   import ddt.manager.EdictumManager;
   import ddt.manager.GradeExaltClewManager;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetBagManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerStateManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.QueueManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StageFocusManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.manager.TimerOpenManager;
   import ddt.states.StateCreater;
   import ddt.states.StateType;
   import ddt.utils.CrytoUtils;
   import ddt.view.chat.ChatBugleView;
   import exitPrompt.ExitPromptManager;
   import farm.FarmModelController;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import game.view.WindPowerManager;
   import im.IMController;
   import liveness.LivenessBubbleManager;
   import org.aswing.KeyboardManager;
   import par.ShapeManager;
   import room.RoomManager;
   import turnplate.TurnPlateController;
   import weekend.WeekendManager;
   import worldboss.WorldBossManager;
   
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
      
      public function DDT()
      {
         super();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         this.numCh = 0;
         var _loc2_:int = 0;
         while(_loc2_ < StageReferance.stage.numChildren)
         {
            _loc3_ = StageReferance.stage.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      private function show(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            _loc3_.visible = true;
            ++this.numCh;
            if(_loc3_ is DisplayObjectContainer)
            {
               this.show(DisplayObjectContainer(_loc3_));
            }
            _loc2_++;
         }
      }
      
      public function lunch(param1:XML, param2:String, param3:String, param4:int, param5:String = "", param6:String = "") : void
      {
         DesktopManager.Instance.checkIsDesktop();
         PlayerManager.Instance.Self.baiduEnterCode = param6;
         this._user = param2;
         this._pass = param3;
         this._rid = param5;
         PlayerManager.Instance.Self.rid = this._rid;
         ConfigParaser.paras(param1,StageReferance.stage.loaderInfo,this._user);
         this.setup();
         StartupResourceLoader.Instance.start(param4);
      }
      
      public function changeAccount(param1:String) : void
      {
         PlayerManager.Instance.Account.Password = param1;
      }
      
      public function enterGame() : void
      {
         LoadInterfaceManager.traceMsg("enterGame");
         ServerManager.Instance.addEventListener(ServerManager.GAME_BEGIN,this.__gameBegin);
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
      
      private function __gameBegin(param1:Event) : void
      {
         LoadInterfaceManager.traceMsg("GameBegin");
         ServerManager.Instance.removeEventListener(ServerManager.GAME_BEGIN,this.__gameBegin);
         StartupResourceLoader.Instance.sendGameBegin();
      }
      
      private function __onCoreSetupLoadComplete(param1:ResourceLoaderEvent) : void
      {
         StartupResourceLoader.Instance.removeEventListener(ResourceLoaderEvent.CORE_SETUP_COMPLETE,this.__onCoreSetupLoadComplete);
         ChatManager.Instance.setup();
         ChatBugleView.instance.setup();
         StageFocusManager.getInstance().setup(StageReferance.stage);
         StateManager.setState(StateType.LOGIN);
         PlayerStateManager.Instance.setup();
      }
      
      private function setup() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:AccountInfo = null;
         if(StringUtils.isEmpty(this._user))
         {
            LeavePageManager.leaveToLoginPath();
         }
         else
         {
            this.setupComponent();
            _loc1_ = "AM0UncxXJ2YzgsQzJFlG7kYIjmSEJZO362TIRJUNGu1amSPVYFN/pcKNIIWS1NxoOt5DmNlMiebxaUHcCVEMnbBd9+2QFCc+K8BkbfzDS+9MJu9Zxn5nT7+CDRvg8id2cRWsMBNc0jIzDqkLWOCFfIYrPx5YF7lHyB1QyvO5zDS3";
            _loc2_ = "AQAB";
            _loc3_ = new AccountInfo();
            _loc3_.Account = this._user;
            _loc3_.Password = this._pass;
            _loc3_.Key = CrytoUtils.generateRsaKey(_loc1_,_loc2_);
            PlayerManager.Instance.setup(_loc3_);
            TimerOpenManager.Instance.setup();
            ShowTipManager.Instance.setup();
            QueueManager.setup(StageReferance.stage);
            TimeManager.Instance.setup();
            SoundManager.instance.setup(PathInfo.MUSIC_LIST,PathManager.SITE_MAIN);
            IMController.Instance.setup();
            SharedManager.Instance.setup();
            CalendarManager.getInstance().initialize();
            RoomManager.Instance.setup();
            GameManager.Instance.setup();
            KeyboardManager.getInstance().init(StageReferance.stage);
            ChurchManager.instance.setup();
            GradeExaltClewManager.getInstance().setup();
            ColorEnum.initColor();
            StateManager.setup(LayerManager.Instance.getLayerByType(LayerManager.GAME_BASE_LAYER),new StateCreater());
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
            if(PathManager.CommunityExist())
            {
               DynamicManager.Instance.initialize();
            }
            DialogManager.Instance.setup(PathManager.getDialogConfigPath());
            HardModeManager.instance.setup();
         }
      }
      
      private function setupComponent() : void
      {
         ComponentSetting.COMBOX_LIST_LAYER = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
         ComponentSetting.PLAY_SOUND_FUNC = SoundManager.instance.play;
         ComponentSetting.SEND_USELOG_ID = SocketManager.Instance.out.sendUseLog;
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.mutiline = true;
         _loc1_.buttonGape = 15;
         _loc1_.autoDispose = true;
         _loc1_.sound = "008";
         AlertManager.Instance.setup(LayerManager.STAGE_DYANMIC_LAYER,_loc1_);
      }
      
      private function soundPlay() : void
      {
         SoundManager.instance.play("008");
      }
   }
}
