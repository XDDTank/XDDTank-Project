package SingleDungeon
{
   import SingleDungeon.event.CDCollingEvent;
   import SingleDungeon.event.SingleDungeonEvent;
   import SingleDungeon.expedition.ExpeditionController;
   import SingleDungeon.expedition.ExpeditionHistory;
   import SingleDungeon.expedition.ExpeditionModel;
   import SingleDungeon.model.BigMapModel;
   import SingleDungeon.model.MapSceneModel;
   import SingleDungeon.model.MissionType;
   import SingleDungeon.view.DropList;
   import SingleDungeon.view.MissionView;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.TaskDirectorType;
   import ddt.data.UIModuleTypes;
   import ddt.events.TimeEvents;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.DialogManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskDirectorManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.BackgoundView;
   import ddt.view.MainToolBar;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import hall.FightPowerAndFatigue;
   import par.ParticleManager;
   import par.ShapeManager;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import store.HelpFrame;
   import store.HelpPrompt;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class SingleDungeonMainStateView extends BaseStateView
   {
       
      
      private var _mapContainer:Sprite;
      
      private var Box:MissionView;
      
      private var mapCombox:ComboBox;
      
      private var maplist:Vector.<BigMapModel>;
      
      private var mapSceneList:Vector.<MapSceneModel>;
      
      private var mapHardSceneList:Vector.<MapSceneModel>;
      
      private var currentMap:BigMapModel;
      
      public var mapMask:Sprite;
      
      private var missionArray:Array;
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var totalPageNum:int;
      
      public var dropList:DropList;
      
      private var missionViewDic:DictionaryData;
      
      private var vBmpDic:DictionaryData;
      
      private var pointBitmDic:DictionaryData;
      
      private var _hardModeExpeditionButton:TextButton;
      
      private var _modeMenu:ComboBox;
      
      private var _hardModeHelpBtn:BaseButton;
      
      private var _modeArray:Array;
      
      public function SingleDungeonMainStateView()
      {
         this._modeArray = ["singledungeon.selectMode.hardMode","singledungeon.selectMode.commonMode"];
         super();
         if(StartupResourceLoader.Instance.enterFromLoading || !ShapeManager.ready)
         {
            ParticleManager.initPartical(PathManager.FLASHSITE);
         }
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         TaskDirectorManager.instance.initSingleIndex();
         super.enter(param1,param2);
         SingleDungeonManager.Instance.mainView = this;
         BackgoundView.Instance.show();
         this.initSingleDungeonMap();
         StateManager.currentStateType = StateType.SINGLEDUNGEON;
         this.initExpedition();
         MainToolBar.Instance.showTop();
         ChatManager.Instance.chatDisabled = true;
         SingleDungeonManager.Instance.isNowBossFight = false;
         FightPowerAndFatigue.Instance.show();
      }
      
      private function initExpedition() : void
      {
         if(ExpeditionController.instance.model.lastScenceID != 0)
         {
            ExpeditionController.instance.show(PlayerManager.Instance.Self.expeditionCurrent.ExpeditionType);
         }
      }
      
      private function __onLoadSingleDungoenComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTSINGLEDUNGEON)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadSingleDungoenComplete);
            this.initSingleDungeonMap();
         }
      }
      
      private function toFarmSelf() : void
      {
         if(PlayerManager.Instance.Self.Grade < int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.FARM_OPEN_LEVEL).Value))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarmTip"));
            return;
         }
         StateManager.setState(StateType.FARM);
      }
      
      private function initSingleDungeonMap() : void
      {
         this.maplist = SingleDungeonManager.Instance.mapList;
         this.mapSceneList = SingleDungeonManager.Instance.mapSceneList;
         this.mapHardSceneList = SingleDungeonManager.Instance.mapHardSceneList;
         this.missionViewDic = new DictionaryData();
         this.vBmpDic = new DictionaryData();
         this.pointBitmDic = new DictionaryData();
         this._mapContainer = new Sprite();
         this.missionArray = new Array();
         addChild(this._mapContainer);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.leftBtn");
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.rightBtn");
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         this._modeMenu = ComponentFactory.Instance.creatComponentByStylename("singledungeon.modeMenu");
         this._modeMenu.listPanel.vectorListModel.append(LanguageMgr.GetTranslation(this._modeArray[1]));
         this._modeMenu.listPanel.vectorListModel.append(LanguageMgr.GetTranslation(this._modeArray[0]));
         this._modeMenu.textField.text = LanguageMgr.GetTranslation(this._modeArray[!!SingleDungeonManager.Instance.isHardMode ? 0 : 1]);
         addChild(this._modeMenu);
         this._hardModeHelpBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.HardMode.HelpBtn");
         this._hardModeHelpBtn.tipData = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         this._hardModeExpeditionButton = ComponentFactory.Instance.creatComponentByStylename("hardMode.Expedition.btn");
         this._hardModeExpeditionButton.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.title");
         addChild(this._hardModeHelpBtn);
         addChild(this._hardModeExpeditionButton);
         this.updataPageNum();
         this.paging(null);
         this.creatMask();
         this.initEvent();
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_FIGHT);
         if(!SavePointManager.Instance.savePoints[87])
         {
            SavePointManager.Instance.setSavePoint(87);
         }
      }
      
      private function initEvent() : void
      {
         this._mapContainer.addEventListener(MouseEvent.CLICK,this.mapClick);
         SingleDungeonEvent.dispatcher.addEventListener(SingleDungeonEvent.FRAME_EXIT,this.__framExit);
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.paging);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.paging);
         TimeManager.addEventListener(TimeEvents.SECONDS,this._showFeildGain);
         SingleDungeonManager.Instance.addEventListener(CDCollingEvent.CD_COLLING,this.__cdColling);
         this._modeMenu.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._modeMenu.button.addEventListener(MouseEvent.CLICK,this.__clickMenuBtn);
         this._hardModeHelpBtn.addEventListener(MouseEvent.CLICK,this.__onHardModeHelpBtnClick);
         this._hardModeExpeditionButton.addEventListener(MouseEvent.CLICK,this.__clickHardModeExpedition);
      }
      
      private function __onHardModeHelpBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("singledungeon.HardMode.ComposeHelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onListClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.index)
         {
            case 0:
               if(SingleDungeonManager.Instance.isHardMode)
               {
                  SingleDungeonManager.Instance.isHardMode = false;
                  this.createMissionPoints();
               }
               break;
            case 1:
               if(!SingleDungeonManager.Instance.isHardMode)
               {
                  SingleDungeonManager.Instance.isHardMode = true;
                  this.createMissionPoints();
               }
         }
      }
      
      private function __clickMenuBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __onModeBtnClick(param1:MouseEvent) : void
      {
         if(!SingleDungeonManager.Instance.isHardMode)
         {
            SingleDungeonManager.Instance.isHardMode = true;
         }
         else
         {
            SingleDungeonManager.Instance.isHardMode = false;
         }
         this.createMissionPoints();
      }
      
      private function __cdColling(param1:CDCollingEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mapSceneList.length)
         {
            if(this.mapSceneList[_loc2_].Type == MissionType.ATTACT && param1.ID == this.mapSceneList[_loc2_].ID)
            {
               this.mapSceneList[_loc2_].count = param1.count;
               this.mapSceneList[_loc2_].cdColling = param1.collingTime;
            }
            _loc2_++;
         }
      }
      
      private function _showFeildGain(param1:TimeEvents) : void
      {
         FarmModelController.instance.showFeildGain();
      }
      
      private function __framExit(param1:SingleDungeonEvent) : void
      {
         if(param1.data == "reflash" || param1.data == "arrow")
         {
            this.updataPageNum();
            this.createMissionPoints();
         }
      }
      
      private function loadMapComplete(param1:LoaderEvent) : void
      {
         var _loc2_:Bitmap = null;
         if(param1.loader.isSuccess)
         {
            _loc2_ = Bitmap(param1.loader.content);
            if(_loc2_)
            {
               this._mapContainer.addChild(_loc2_);
            }
            this.vBmpDic.add(SingleDungeonManager.Instance.maplistIndex,_loc2_);
            this.createMissionPoints();
            TaskManager.instance.checkHighLight();
         }
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.SINGLEDUNGEON;
      }
      
      private function createMissionPoints() : void
      {
         this.removeMission();
         this.setModeBtnVisable();
         if(!SingleDungeonManager.Instance.isHardMode || SingleDungeonManager.Instance.maplistIndex < 2)
         {
            this.createMissionViews(this.mapSceneList);
         }
         else if(this.mapSceneList)
         {
            this.createMissionViews(this.mapHardSceneList);
         }
         SocketManager.Instance.out.sendCDColling(int(SingleDungeonManager.Instance.maplistIndex + 1));
         TaskDirectorManager.instance.showDirector(TaskDirectorType.SINGLEDUNGEON);
         this.showHandContainer();
      }
      
      private function setModeBtnVisable() : void
      {
         if(SingleDungeonManager.Instance.maplistIndex < 2)
         {
            this._modeMenu.visible = false;
            this._hardModeHelpBtn.visible = false;
            this._hardModeExpeditionButton.visible = false;
         }
         else if(this.getHardModeMapCount(SingleDungeonManager.Instance.maplistIndex) == 0)
         {
            this._modeMenu.visible = false;
            this._hardModeHelpBtn.visible = false;
            this._hardModeExpeditionButton.visible = false;
            SingleDungeonManager.Instance.isHardMode = false;
            this._modeMenu.currentSelectedIndex = 0;
         }
         else
         {
            this._modeMenu.visible = true;
            this._hardModeExpeditionButton.visible = SingleDungeonManager.Instance.isHardMode;
            this._hardModeHelpBtn.visible = SingleDungeonManager.Instance.isHardMode;
         }
      }
      
      private function createMissionViews(param1:Vector.<MapSceneModel>) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(this.currentMap.ID == param1[_loc2_].MapID)
            {
               _loc3_ = this.creatPointBitm(param1[_loc2_]);
               if(!this.isSavePointMission(param1,_loc2_,_loc3_))
               {
                  if(PlayerManager.Instance.Self.Grade >= param1[_loc2_].MinLevel)
                  {
                     _loc4_ = ExpeditionHistory.instance.get(this.mapSceneList[_loc2_].MissionID);
                     if(SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID])
                     {
                        _loc5_ = SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID].indexOf(param1[_loc2_].ID) > -1;
                     }
                     if(!_loc4_ && !_loc5_ && !SingleDungeonManager.Instance.isHardMode)
                     {
                        this.createOpenMapAnima(param1,_loc2_,_loc3_);
                     }
                     else
                     {
                        this.createMissionBox(param1,_loc2_,_loc3_,true);
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function creatPointBitm(param1:MapSceneModel) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         if(this.pointBitmDic[param1.ID])
         {
            _loc2_ = this.pointBitmDic[param1.ID];
            _loc2_.x = param1.MapX - _loc2_.width / 2;
            _loc2_.y = param1.MapY - _loc2_.height / 2;
         }
         else
         {
            if(param1.Type == 1)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.blueMapPoint");
            }
            else if(param1.Type == 2)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.greenMapPoint");
            }
            else if(param1.Type == 3)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.RedMapPoint");
            }
            else if(param1.Type == 4)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.yellowMapPoint");
            }
            _loc2_ = new Sprite();
            _loc2_.x = param1.MapX - _loc3_.width / 2;
            _loc2_.y = param1.MapY - _loc3_.height / 2;
            _loc2_.addChild(_loc3_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.pointBitmClick);
            _loc2_.buttonMode = true;
            this.pointBitmDic.add(param1.ID,_loc2_);
         }
         return _loc2_;
      }
      
      override public function showDirect() : void
      {
         TaskDirectorManager.instance.initSingleIndex();
         if(this.maplist != null && this.vBmpDic != null)
         {
            this.paging(null);
         }
         TaskDirectorManager.instance.showDirector(TaskDirectorType.SINGLEDUNGEON);
      }
      
      private function createMissionBox(param1:Vector.<MapSceneModel>, param2:int, param3:DisplayObject, param4:Boolean = true, param5:Boolean = true) : void
      {
         var _loc6_:MissionView = null;
         if(this.missionViewDic[param1[param2].ID])
         {
            _loc6_ = this.missionViewDic[param1[param2].ID] as MissionView;
            _loc6_.updatable();
         }
         else
         {
            _loc6_ = new MissionView(param1,param2,param3);
            this.missionViewDic.add(param1[param2].ID,_loc6_);
            if(param4)
            {
               _loc6_.addEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW,this.__boxClick);
            }
            else
            {
               this.applyGray(_loc6_);
               this.applyGray(param3);
               _loc6_.mouseEnabled = false;
               _loc6_.mouseChildren = false;
            }
         }
         this.addChild(param3);
         this.missionArray.push(param3);
         this.addChild(_loc6_);
         _loc6_.visible = param5;
         param3.visible = param5;
         _loc6_.boxState = MissionView.SMALLBOX;
         this.missionArray.push(_loc6_);
      }
      
      private function updataCD(param1:SingleDungeonEvent) : void
      {
         var _loc2_:MissionView = null;
         _loc2_ = param1.currentTarget as MissionView;
         if(param1.data == "start")
         {
            this.applyGray(_loc2_.smallBox);
            this.applyGray(_loc2_.ptBitmap);
            _loc2_.removeEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW,this.__boxClick);
         }
         else if(param1.data == "end")
         {
            _loc2_.addEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW,this.__boxClick);
            _loc2_.smallBox.filters = null;
            _loc2_.ptBitmap.filters = null;
         }
      }
      
      private function createOpenMapAnima(param1:Vector.<MapSceneModel>, param2:int, param3:DisplayObject) : void
      {
         var _loc5_:MovieClipWrapper = null;
         var _loc6_:MissionView = null;
         var _loc8_:Array = null;
         var _loc4_:MovieClip = ClassUtils.CreatInstance("asset.singleDungeon.openMapAnima") as MovieClip;
         _loc5_ = new MovieClipWrapper(_loc4_);
         _loc6_ = new MissionView(param1,param2,param3);
         _loc6_.boxState = MissionView.SMALLBOX;
         _loc6_.x = _loc6_.y = 0;
         var _loc7_:MissionView = new MissionView(param1,param2,param3);
         _loc7_.boxState = MissionView.SMALLBOX;
         _loc7_.x = _loc7_.y = 0;
         _loc5_.movie.x = param3.x - _loc6_.smallFramePoint.x;
         _loc5_.movie.y = param3.y - _loc6_.smallFramePoint.y;
         param3.x = param3.y = 0;
         _loc5_.movie.pBox.addChild(param3);
         _loc5_.movie.grayBox.addChild(_loc7_);
         _loc5_.movie.colBox.addChild(_loc6_);
         _loc5_.addEventListener(Event.COMPLETE,this.openMapAnimaComplete);
         _loc6_.addEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW,this.__boxClick);
         this.addChild(_loc5_.movie);
         _loc5_.play();
         this.missionArray.push(_loc6_);
         this.missionArray.push(_loc7_);
         this.missionArray.push(_loc5_.movie);
         _loc5_.movie.mouseChildren = false;
         param3.visible = true;
         if(SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID])
         {
            _loc8_ = SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID] as Array;
            if(_loc8_.indexOf(param1[param2].ID) < 0)
            {
               _loc8_.push(param1[param2].ID);
            }
         }
         else
         {
            SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID] = [param1[param2].ID];
         }
         SharedManager.Instance.save();
      }
      
      private function openMapAnimaComplete(param1:Event) : void
      {
         var _loc3_:Sprite = null;
         (param1.target as EventDispatcher).removeEventListener(Event.COMPLETE,this.openMapAnimaComplete);
         var _loc2_:MissionView = param1.target.movie.colBox.getChildAt(1) as MissionView;
         _loc3_ = this.creatPointBitm(_loc2_.info);
         param1.target.dispose();
         param1 = null;
         this.addChild(_loc2_);
         _loc2_.mouseEnabled = true;
         _loc2_.boxState = MissionView.SMALLBOX;
         this.missionArray.push(_loc2_);
         this.addChild(_loc3_);
         this.missionArray.push(_loc3_);
         _loc3_.visible = true;
      }
      
      private function isSavePointMission(param1:Vector.<MapSceneModel>, param2:int, param3:DisplayObject) : Boolean
      {
         var _loc4_:Boolean = false;
         if(param1[param2].ID < 12)
         {
            if(param1[param2].ID == 11 && SavePointManager.Instance.savePoints[34] || param1[param2].ID == 2 && SavePointManager.Instance.savePoints[40] || param1[param2].ID == 5 && SavePointManager.Instance.savePoints[36] || param1[param2].ID == 6 && SavePointManager.Instance.savePoints[43] || param1[param2].ID == 7 && SavePointManager.Instance.savePoints[41] || param1[param2].ID == 8 && SavePointManager.Instance.savePoints[18] || param1[param2].ID == 3 && SavePointManager.Instance.savePoints[52] || param1[param2].ID == 9 && SavePointManager.Instance.savePoints[53] || param1[param2].ID == 10 && SavePointManager.Instance.savePoints[48])
            {
               if(param1[param2].ID == 11 && SavePointManager.Instance.isInSavePoint(4) || param1[param2].ID == 2 && SavePointManager.Instance.isInSavePoint(11) || param1[param2].ID == 5 && SavePointManager.Instance.isInSavePoint(6) || param1[param2].ID == 6 && SavePointManager.Instance.isInSavePoint(8) || param1[param2].ID == 7 && SavePointManager.Instance.isInSavePoint(12) || param1[param2].ID == 8 && SavePointManager.Instance.isInSavePoint(19) || param1[param2].ID == 3 && SavePointManager.Instance.isInSavePoint(22) || param1[param2].ID == 9 && SavePointManager.Instance.isInSavePoint(23) || param1[param2].ID == 10 && SavePointManager.Instance.isInSavePoint(25))
               {
                  if(SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID])
                  {
                     _loc4_ = SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID].indexOf(param1[param2].ID) > -1;
                  }
                  if(!_loc4_)
                  {
                     this.createOpenMapAnima(param1,param2,param3);
                  }
                  else
                  {
                     this.createMissionBox(param1,param2,param3,true);
                  }
               }
               else
               {
                  this.createMissionBox(param1,param2,param3,true);
               }
            }
            else
            {
               this.createMissionBox(param1,param2,param3,true,false);
            }
            return true;
         }
         if(param1[param2].ID > 1000)
         {
            param3.visible = false;
            return true;
         }
         return false;
      }
      
      private function mapComboxChanged(param1:InteractiveEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         var _loc3_:int = 0;
         while(_loc3_ < this.maplist.length)
         {
            if(this.maplist[_loc3_].Name == this.mapCombox.currentSelectedCellValue)
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         this.currentMap = this.maplist[_loc2_];
         SingleDungeonManager.Instance.maplistIndex = _loc2_;
         SingleDungeonManager.Instance.getBigMapImage(this.loadMapComplete,PathManager.solveSingleDungeonWorldMapPath(this.currentMap.Path));
         this.removeMission();
      }
      
      private function updataPageNum() : void
      {
         this.totalPageNum = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.maplist.length)
         {
            if(PlayerManager.Instance.Self.Grade >= this.maplist[_loc1_].Level)
            {
               ++this.totalPageNum;
            }
            _loc1_++;
         }
         if(this.totalPageNum == 1)
         {
            this._leftBtn.mouseEnabled = false;
            this._rightBtn.mouseEnabled = false;
            this.applyGray(this._leftBtn);
            this.applyGray(this._rightBtn);
         }
         else if(this.totalPageNum > 1)
         {
            this._leftBtn.mouseEnabled = true;
            this._rightBtn.mouseEnabled = true;
            this._leftBtn.filters = null;
            this._rightBtn.filters = null;
         }
      }
      
      private function getHardModeMapCount(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this.mapHardSceneList.length)
         {
            if(this.maplist[param1].ID == this.mapHardSceneList[_loc3_].MapID)
            {
               if(PlayerManager.Instance.Self.Grade >= this.mapHardSceneList[_loc3_].MinLevel)
               {
                  _loc2_++;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function paging(param1:MouseEvent) : void
      {
         var _loc2_:int = SingleDungeonManager.Instance.maplistIndex;
         if(param1 && param1.target == this._leftBtn)
         {
            _loc2_--;
         }
         else if(param1 && param1.target == this._rightBtn)
         {
            _loc2_++;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = this.totalPageNum - 1;
         }
         if(_loc2_ > this.totalPageNum - 1)
         {
            _loc2_ = 0;
         }
         if(_loc2_ >= 0 && _loc2_ < this.maplist.length)
         {
            this.currentMap = this.maplist[_loc2_];
            SingleDungeonManager.Instance.maplistIndex = _loc2_;
            if(this.vBmpDic[_loc2_])
            {
               this._mapContainer.removeChild(this.vBmpDic[SingleDungeonManager.Instance.maplistIndex]);
               this._mapContainer.addChild(this.vBmpDic[_loc2_]);
               this.createMissionPoints();
               TaskManager.instance.checkHighLight();
            }
            else
            {
               SingleDungeonManager.Instance.getBigMapImage(this.loadMapComplete,PathManager.solveSingleDungeonWorldMapPath(this.currentMap.Path));
            }
            SoundManager.instance.play("008");
         }
         if(this.currentMap.ID == 2)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.SINGLE_DUNGEON_MISSION);
         }
         this.showHandContainer();
      }
      
      private function __boxClick(param1:SingleDungeonEvent) : void
      {
         this.Box = param1.currentTarget as MissionView;
         if(this.Box && this.Box.state == MissionView.SMALLBOX)
         {
            this.Box.boxState = MissionView.BIGBOX;
         }
      }
      
      private function pointBitmClick(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         for each(_loc2_ in this.missionArray)
         {
            if(_loc2_ is MissionView && _loc2_.parent == this && param1.target == (_loc2_ as MissionView).ptBitmap)
            {
               this.Box = _loc2_ as MissionView;
               if(SingleDungeonManager.Instance.CanPointClick[this.Box.info.ID] && SingleDungeonManager.Instance.CanPointClick[this.Box.info.ID] != "true")
               {
                  return;
               }
               this.Box.boxState = MissionView.BIGBOX;
               break;
            }
         }
      }
      
      private function maskClick(param1:MouseEvent) : void
      {
         if(this.Box && !this.Box.isPlay)
         {
            this.addChildAt(this.mapMask,0);
            this.mapMask.alpha = 0;
            this.Box.boxState = MissionView.SMALLBOX;
         }
      }
      
      private function creatMask() : void
      {
         if(this.mapMask == null)
         {
            this.mapMask = new Sprite();
            this.mapMask.graphics.beginFill(0,1);
            this.mapMask.graphics.drawRect(0,0,1000,600);
            this.mapMask.graphics.endFill();
            this.mapMask.alpha = 0;
            this.addChildAt(this.mapMask,0);
            this.mapMask.addEventListener(MouseEvent.CLICK,this.maskClick);
         }
      }
      
      private function applyGray(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0.3086,0.6094,0.082,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         var _loc4_:Array = new Array();
         _loc4_.push(_loc3_);
         param1.filters = _loc4_;
      }
      
      private function mapClick(param1:MouseEvent) : void
      {
         if(this.Box && param1.target == this._mapContainer)
         {
            this.Box.boxState = MissionView.SMALLBOX;
            this.Box = null;
         }
      }
      
      private function showHandContainer() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.HALL_BUILD);
         NewHandContainer.Instance.clearArrowByID(ArrowType.SINGLE_DUNGEON_MISSION);
         if(this.currentMap.ID == 1)
         {
            if(SavePointManager.Instance.isInSavePoint(4))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,135,"singleDungeon.mission2ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission2tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(6))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,135,"singleDungeon.mission3ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission3tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(8) && SavePointManager.Instance.savePoints[43])
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission4ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission4tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(10) && !TaskManager.instance.isNewHandTaskCompleted(6))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission4ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission4tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(11) && !TaskManager.instance.isNewHandTaskCompleted(3))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission9ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission9tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(12))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission5ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission5tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(19))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,135,"singleDungeon.mission6ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission6tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(22) && !TaskManager.instance.isNewHandTaskCompleted(18))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission8ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission8tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(23) && (!TaskManager.instance.isNewHandTaskCompleted(19) && !TaskManager.instance.isNewHandTaskAchieved(19) || !TaskManager.instance.isNewHandTaskCompleted(20) && !TaskManager.instance.isNewHandTaskAchieved(20)) || SavePointManager.Instance.isInSavePoint(25) && !TaskManager.instance.isNewHandTaskCompleted(22) || SavePointManager.Instance.isInSavePoint(27) && (!TaskManager.instance.isNewHandTaskCompleted(24) && !TaskManager.instance.isNewHandTaskAchieved(24) || !TaskManager.instance.isNewHandTaskCompleted(25) && !TaskManager.instance.isNewHandTaskAchieved(25)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission7ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission7tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.savePoints[38] && SavePointManager.Instance.isInSavePoint(9) && !TaskManager.instance.isNewHandTaskCompleted(7) || SavePointManager.Instance.savePoints[42] && SavePointManager.Instance.isInSavePoint(14) && !TaskManager.instance.isNewHandTaskCompleted(10) || SavePointManager.Instance.isInSavePoint(26) && !TaskManager.instance.isNewHandTaskCompleted(23) || SavePointManager.Instance.isInSavePoint(55) && !TaskManager.instance.isNewHandTaskCompleted(27) || SavePointManager.Instance.isInSavePoint(28) || SavePointManager.Instance.isInSavePoint(47))
            {
               NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE,-45,"singleDungeon.missionbackArrowPos","","",this);
            }
         }
         if(this.currentMap.ID == 2)
         {
            if(SavePointManager.Instance.isInSavePoint(23))
            {
               if(!TaskManager.instance.isNewHandTaskAchieved(20))
               {
                  if(!TaskManager.instance.isNewHandTaskCompleted(20))
                  {
                     NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,180,"singleDungeon.mission10ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission10tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                  }
               }
            }
            if(SavePointManager.Instance.isInSavePoint(25) && !TaskManager.instance.isNewHandTaskCompleted(22) || SavePointManager.Instance.isInSavePoint(27) && (!TaskManager.instance.isNewHandTaskCompleted(24) && !TaskManager.instance.isNewHandTaskAchieved(24) || !TaskManager.instance.isNewHandTaskCompleted(25) && !TaskManager.instance.isNewHandTaskAchieved(25)))
            {
               NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION,135,"singleDungeon.mission11ArrowPos","asset.trainer.txtClickEnter","singleDungeon.mission11tipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
            }
            if(SavePointManager.Instance.isInSavePoint(47) || SavePointManager.Instance.isInSavePoint(55))
            {
               NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE,-45,"singleDungeon.missionbackArrowPos","","",this);
            }
         }
         if(SavePointManager.Instance.isInSavePoint(38))
         {
            this.showDialog(22);
         }
         if(SavePointManager.Instance.isInSavePoint(39))
         {
            this.showDialog(23);
         }
         if(SavePointManager.Instance.isInSavePoint(40))
         {
            this.showDialog(24);
         }
         if(SavePointManager.Instance.isInSavePoint(41))
         {
            this.showDialog(44);
         }
         if(SavePointManager.Instance.isInSavePoint(43))
         {
            this.showDialog(45);
         }
      }
      
      private function showDialog(param1:uint) : void
      {
         LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox,LayerManager.STAGE_TOP_LAYER);
         DialogManager.Instance.addEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         DialogManager.Instance.showDialog(param1);
      }
      
      private function __dialogEndCallBack(param1:Event) : void
      {
         DialogManager.Instance.removeEventListener(Event.COMPLETE,this.__dialogEndCallBack);
         if(SavePointManager.Instance.isInSavePoint(38))
         {
            SavePointManager.Instance.setSavePoint(38);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(SavePointManager.Instance.isInSavePoint(39))
         {
            SavePointManager.Instance.setSavePoint(39);
         }
         if(SavePointManager.Instance.isInSavePoint(40))
         {
            SavePointManager.Instance.setSavePoint(40);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(SavePointManager.Instance.isInSavePoint(41))
         {
            SavePointManager.Instance.setSavePoint(41);
         }
         if(SavePointManager.Instance.isInSavePoint(43))
         {
            SavePointManager.Instance.setSavePoint(43);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(SavePointManager.Instance.isInSavePoint(14))
         {
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
         if(SavePointManager.Instance.savePoints[54] && SavePointManager.Instance.isInSavePoint(55))
         {
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
         }
      }
      
      private function removeMission() : void
      {
         var _loc1_:int = this.missionArray.length - 1;
         while(_loc1_ >= 0)
         {
            if(this.missionArray[_loc1_] && this.contains(this.missionArray[_loc1_]))
            {
               if(this.missionArray[_loc1_] is MovieClip)
               {
                  this.missionArray[_loc1_].stop();
               }
               this.removeChild(this.missionArray[_loc1_]);
               this.missionArray.splice(_loc1_,1);
            }
            _loc1_--;
         }
      }
      
      private function removeEvent() : void
      {
         this._mapContainer.removeEventListener(MouseEvent.CLICK,this.mapClick);
         SingleDungeonEvent.dispatcher.removeEventListener(SingleDungeonEvent.FRAME_EXIT,this.__framExit);
         TimeManager.removeEventListener(TimeEvents.SECONDS,this._showFeildGain);
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.paging);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.paging);
         this._modeMenu.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._modeMenu.button.removeEventListener(MouseEvent.CLICK,this.__clickMenuBtn);
         this._hardModeHelpBtn.removeEventListener(MouseEvent.CLICK,this.__onHardModeHelpBtnClick);
         this._hardModeExpeditionButton.removeEventListener(MouseEvent.CLICK,this.__clickHardModeExpedition);
      }
      
      private function __clickHardModeExpedition(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ExpeditionController.instance.show(ExpeditionModel.HARD_MODE);
      }
      
      private function __onExitClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.MAIN);
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         super.leaving(param1);
      }
      
      override public function dispose() : void
      {
         var _loc2_:MissionView = null;
         var _loc3_:Bitmap = null;
         var _loc4_:Sprite = null;
         ChatManager.Instance.chatDisabled = false;
         ExpeditionController.instance.hide();
         FarmModelController.instance.deleteGainPlant();
         FightPowerAndFatigue.Instance.hide();
         this.removeEvent();
         SingleDungeonManager.Instance.removeBigLoaderListener();
         var _loc1_:int = 0;
         while(_loc1_ < this.missionArray.length)
         {
            ObjectUtils.disposeObject(this.missionArray[_loc1_]);
            this.missionArray[_loc1_] = null;
            _loc1_++;
         }
         this.missionArray = null;
         for each(_loc2_ in this.missionViewDic)
         {
            _loc2_.dispose();
            _loc2_ = null;
         }
         this.missionViewDic.clear();
         this.missionViewDic = null;
         for each(_loc3_ in this.vBmpDic)
         {
            ObjectUtils.disposeObject(_loc3_);
            _loc3_ = null;
         }
         this.vBmpDic.clear();
         this.vBmpDic = null;
         for each(_loc4_ in this.pointBitmDic)
         {
            ObjectUtils.disposeAllChildren(_loc4_);
            _loc4_ = null;
         }
         this.pointBitmDic.clear();
         this.pointBitmDic = null;
         ObjectUtils.disposeObject(this.mapCombox);
         this.mapCombox = null;
         ObjectUtils.disposeObject(this.Box);
         this.Box = null;
         if(this._mapContainer)
         {
            ObjectUtils.disposeAllChildren(this._mapContainer);
         }
         ObjectUtils.disposeObject(this._mapContainer);
         this._mapContainer = null;
         ObjectUtils.disposeObject(this.mapMask);
         this.mapMask = null;
         ObjectUtils.disposeObject(this._rightBtn);
         this._rightBtn = null;
         ObjectUtils.disposeObject(this._leftBtn);
         this._leftBtn = null;
         if(this._modeMenu)
         {
            ObjectUtils.disposeObject(this._modeMenu);
            this._modeMenu = null;
         }
         ObjectUtils.disposeObject(this.dropList);
         this.dropList = null;
         if(this._hardModeHelpBtn)
         {
            ObjectUtils.disposeObject(this._hardModeHelpBtn);
         }
         this._hardModeHelpBtn = null;
         if(this._hardModeExpeditionButton)
         {
            ObjectUtils.disposeObject(this._hardModeExpeditionButton);
         }
         this._hardModeExpeditionButton = null;
         ObjectUtils.disposeAllChildren(this);
         this.currentMap = null;
         this.maplist = null;
         this.mapSceneList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
