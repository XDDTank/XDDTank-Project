// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.SingleDungeonMainStateView

package SingleDungeon
{
    import ddt.states.BaseStateView;
    import flash.display.Sprite;
    import SingleDungeon.view.MissionView;
    import com.pickgliss.ui.controls.ComboBox;
    import __AS3__.vec.Vector;
    import SingleDungeon.model.BigMapModel;
    import SingleDungeon.model.MapSceneModel;
    import com.pickgliss.ui.controls.BaseButton;
    import SingleDungeon.view.DropList;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.controls.TextButton;
    import par.ShapeManager;
    import ddt.loader.StartupResourceLoader;
    import par.ParticleManager;
    import ddt.manager.PathManager;
    import ddt.manager.TaskDirectorManager;
    import ddt.view.BackgoundView;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import ddt.view.MainToolBar;
    import ddt.manager.ChatManager;
    import hall.FightPowerAndFatigue;
    import SingleDungeon.expedition.ExpeditionController;
    import ddt.manager.PlayerManager;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.manager.SavePointManager;
    import flash.events.MouseEvent;
    import SingleDungeon.event.SingleDungeonEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import SingleDungeon.event.CDCollingEvent;
    import com.pickgliss.events.ListItemEvent;
    import ddt.manager.SoundManager;
    import store.HelpPrompt;
    import store.HelpFrame;
    import com.pickgliss.ui.LayerManager;
    import SingleDungeon.model.MissionType;
    import farm.FarmModelController;
    import flash.display.Bitmap;
    import ddt.manager.TaskManager;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.SocketManager;
    import ddt.data.TaskDirectorType;
    import flash.display.DisplayObject;
    import SingleDungeon.expedition.ExpeditionHistory;
    import ddt.manager.SharedManager;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import com.pickgliss.events.InteractiveEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import flash.filters.ColorMatrixFilter;
    import ddt.manager.DialogManager;
    import SingleDungeon.expedition.ExpeditionModel;
    import com.pickgliss.utils.ObjectUtils;

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
        private var _modeArray:Array = ["singledungeon.selectMode.hardMode", "singledungeon.selectMode.commonMode"];

        public function SingleDungeonMainStateView()
        {
            if (((StartupResourceLoader.Instance.enterFromLoading) || (!(ShapeManager.ready))))
            {
                ParticleManager.initPartical(PathManager.FLASHSITE);
            };
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            TaskDirectorManager.instance.initSingleIndex();
            super.enter(_arg_1, _arg_2);
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

        private function initExpedition():void
        {
            if (ExpeditionController.instance.model.lastScenceID != 0)
            {
                ExpeditionController.instance.show(PlayerManager.Instance.Self.expeditionCurrent.ExpeditionType);
            };
        }

        private function __onLoadSingleDungoenComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSINGLEDUNGEON)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onLoadSingleDungoenComplete);
                this.initSingleDungeonMap();
            };
        }

        private function toFarmSelf():void
        {
            if (PlayerManager.Instance.Self.Grade < int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.FARM_OPEN_LEVEL).Value))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarmTip"));
                return;
            };
            StateManager.setState(StateType.FARM);
        }

        private function initSingleDungeonMap():void
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
            this._modeMenu.textField.text = LanguageMgr.GetTranslation(this._modeArray[((SingleDungeonManager.Instance.isHardMode) ? 0 : 1)]);
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
            if ((!(SavePointManager.Instance.savePoints[87])))
            {
                SavePointManager.Instance.setSavePoint(87);
            };
        }

        private function initEvent():void
        {
            this._mapContainer.addEventListener(MouseEvent.CLICK, this.mapClick);
            SingleDungeonEvent.dispatcher.addEventListener(SingleDungeonEvent.FRAME_EXIT, this.__framExit);
            this._leftBtn.addEventListener(MouseEvent.CLICK, this.paging);
            this._rightBtn.addEventListener(MouseEvent.CLICK, this.paging);
            TimeManager.addEventListener(TimeEvents.SECONDS, this._showFeildGain);
            SingleDungeonManager.Instance.addEventListener(CDCollingEvent.CD_COLLING, this.__cdColling);
            this._modeMenu.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__onListClick);
            this._modeMenu.button.addEventListener(MouseEvent.CLICK, this.__clickMenuBtn);
            this._hardModeHelpBtn.addEventListener(MouseEvent.CLICK, this.__onHardModeHelpBtnClick);
            this._hardModeExpeditionButton.addEventListener(MouseEvent.CLICK, this.__clickHardModeExpedition);
        }

        private function __onHardModeHelpBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            var _local_2:HelpPrompt = ComponentFactory.Instance.creat("singledungeon.HardMode.ComposeHelpPrompt");
            var _local_3:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_3.setView(_local_2);
            _local_3.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
            LayerManager.Instance.addToLayer(_local_3, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __onListClick(_arg_1:ListItemEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.index)
            {
                case 0:
                    if (SingleDungeonManager.Instance.isHardMode)
                    {
                        SingleDungeonManager.Instance.isHardMode = false;
                        this.createMissionPoints();
                    };
                    return;
                case 1:
                    if ((!(SingleDungeonManager.Instance.isHardMode)))
                    {
                        SingleDungeonManager.Instance.isHardMode = true;
                        this.createMissionPoints();
                    };
                    return;
            };
        }

        private function __clickMenuBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function __onModeBtnClick(_arg_1:MouseEvent):void
        {
            if ((!(SingleDungeonManager.Instance.isHardMode)))
            {
                SingleDungeonManager.Instance.isHardMode = true;
            }
            else
            {
                SingleDungeonManager.Instance.isHardMode = false;
            };
            this.createMissionPoints();
        }

        private function __cdColling(_arg_1:CDCollingEvent):void
        {
            var _local_2:int;
            while (_local_2 < this.mapSceneList.length)
            {
                if (((this.mapSceneList[_local_2].Type == MissionType.ATTACT) && (_arg_1.ID == this.mapSceneList[_local_2].ID)))
                {
                    this.mapSceneList[_local_2].count = _arg_1.count;
                    this.mapSceneList[_local_2].cdColling = _arg_1.collingTime;
                };
                _local_2++;
            };
        }

        private function _showFeildGain(_arg_1:TimeEvents):void
        {
            FarmModelController.instance.showFeildGain();
        }

        private function __framExit(_arg_1:SingleDungeonEvent):void
        {
            if (((_arg_1.data == "reflash") || (_arg_1.data == "arrow")))
            {
                this.updataPageNum();
                this.createMissionPoints();
            };
        }

        private function loadMapComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:Bitmap;
            if (_arg_1.loader.isSuccess)
            {
                _local_2 = Bitmap(_arg_1.loader.content);
                if (_local_2)
                {
                    this._mapContainer.addChild(_local_2);
                };
                this.vBmpDic.add(SingleDungeonManager.Instance.maplistIndex, _local_2);
                this.createMissionPoints();
                TaskManager.instance.checkHighLight();
            };
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function getType():String
        {
            return (StateType.SINGLEDUNGEON);
        }

        private function createMissionPoints():void
        {
            this.removeMission();
            this.setModeBtnVisable();
            if (((!(SingleDungeonManager.Instance.isHardMode)) || (SingleDungeonManager.Instance.maplistIndex < 2)))
            {
                this.createMissionViews(this.mapSceneList);
            }
            else
            {
                if (this.mapSceneList)
                {
                    this.createMissionViews(this.mapHardSceneList);
                };
            };
            SocketManager.Instance.out.sendCDColling(int((SingleDungeonManager.Instance.maplistIndex + 1)));
            TaskDirectorManager.instance.showDirector(TaskDirectorType.SINGLEDUNGEON);
            this.showHandContainer();
        }

        private function setModeBtnVisable():void
        {
            if (SingleDungeonManager.Instance.maplistIndex < 2)
            {
                this._modeMenu.visible = false;
                this._hardModeHelpBtn.visible = false;
                this._hardModeExpeditionButton.visible = false;
            }
            else
            {
                if (this.getHardModeMapCount(SingleDungeonManager.Instance.maplistIndex) == 0)
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
                };
            };
        }

        private function createMissionViews(_arg_1:Vector.<MapSceneModel>):void
        {
            var _local_3:DisplayObject;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_2:int;
            while (_local_2 < _arg_1.length)
            {
                if (this.currentMap.ID == _arg_1[_local_2].MapID)
                {
                    _local_3 = this.creatPointBitm(_arg_1[_local_2]);
                    if ((!(this.isSavePointMission(_arg_1, _local_2, _local_3))))
                    {
                        if (PlayerManager.Instance.Self.Grade >= _arg_1[_local_2].MinLevel)
                        {
                            _local_4 = ExpeditionHistory.instance.get(this.mapSceneList[_local_2].MissionID);
                            if (SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID])
                            {
                                _local_5 = (SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID].indexOf(_arg_1[_local_2].ID) > -1);
                            };
                            if ((((!(_local_4)) && (!(_local_5))) && (!(SingleDungeonManager.Instance.isHardMode))))
                            {
                                this.createOpenMapAnima(_arg_1, _local_2, _local_3);
                            }
                            else
                            {
                                this.createMissionBox(_arg_1, _local_2, _local_3, true);
                            };
                        };
                    };
                };
                _local_2++;
            };
        }

        private function creatPointBitm(_arg_1:MapSceneModel):Sprite
        {
            var _local_2:Sprite;
            var _local_3:Bitmap;
            if (this.pointBitmDic[_arg_1.ID])
            {
                _local_2 = this.pointBitmDic[_arg_1.ID];
                _local_2.x = (_arg_1.MapX - (_local_2.width / 2));
                _local_2.y = (_arg_1.MapY - (_local_2.height / 2));
            }
            else
            {
                if (_arg_1.Type == 1)
                {
                    _local_3 = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.blueMapPoint");
                }
                else
                {
                    if (_arg_1.Type == 2)
                    {
                        _local_3 = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.greenMapPoint");
                    }
                    else
                    {
                        if (_arg_1.Type == 3)
                        {
                            _local_3 = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.RedMapPoint");
                        }
                        else
                        {
                            if (_arg_1.Type == 4)
                            {
                                _local_3 = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.yellowMapPoint");
                            };
                        };
                    };
                };
                _local_2 = new Sprite();
                _local_2.x = (_arg_1.MapX - (_local_3.width / 2));
                _local_2.y = (_arg_1.MapY - (_local_3.height / 2));
                _local_2.addChild(_local_3);
                _local_2.addEventListener(MouseEvent.CLICK, this.pointBitmClick);
                _local_2.buttonMode = true;
                this.pointBitmDic.add(_arg_1.ID, _local_2);
            };
            return (_local_2);
        }

        override public function showDirect():void
        {
            TaskDirectorManager.instance.initSingleIndex();
            if (((!(this.maplist == null)) && (!(this.vBmpDic == null))))
            {
                this.paging(null);
            };
            TaskDirectorManager.instance.showDirector(TaskDirectorType.SINGLEDUNGEON);
        }

        private function createMissionBox(_arg_1:Vector.<MapSceneModel>, _arg_2:int, _arg_3:DisplayObject, _arg_4:Boolean=true, _arg_5:Boolean=true):void
        {
            var _local_6:MissionView;
            if (this.missionViewDic[_arg_1[_arg_2].ID])
            {
                _local_6 = (this.missionViewDic[_arg_1[_arg_2].ID] as MissionView);
                _local_6.updatable();
            }
            else
            {
                _local_6 = new MissionView(_arg_1, _arg_2, _arg_3);
                this.missionViewDic.add(_arg_1[_arg_2].ID, _local_6);
                if (_arg_4)
                {
                    _local_6.addEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW, this.__boxClick);
                }
                else
                {
                    this.applyGray(_local_6);
                    this.applyGray(_arg_3);
                    _local_6.mouseEnabled = false;
                    _local_6.mouseChildren = false;
                };
            };
            this.addChild(_arg_3);
            this.missionArray.push(_arg_3);
            this.addChild(_local_6);
            _local_6.visible = _arg_5;
            _arg_3.visible = _arg_5;
            _local_6.boxState = MissionView.SMALLBOX;
            this.missionArray.push(_local_6);
        }

        private function updataCD(_arg_1:SingleDungeonEvent):void
        {
            var _local_2:MissionView;
            _local_2 = (_arg_1.currentTarget as MissionView);
            if (_arg_1.data == "start")
            {
                this.applyGray(_local_2.smallBox);
                this.applyGray(_local_2.ptBitmap);
                _local_2.removeEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW, this.__boxClick);
            }
            else
            {
                if (_arg_1.data == "end")
                {
                    _local_2.addEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW, this.__boxClick);
                    _local_2.smallBox.filters = null;
                    _local_2.ptBitmap.filters = null;
                };
            };
        }

        private function createOpenMapAnima(_arg_1:Vector.<MapSceneModel>, _arg_2:int, _arg_3:DisplayObject):void
        {
            var _local_5:MovieClipWrapper;
            var _local_6:MissionView;
            var _local_8:Array;
            var _local_4:MovieClip = (ClassUtils.CreatInstance("asset.singleDungeon.openMapAnima") as MovieClip);
            _local_5 = new MovieClipWrapper(_local_4);
            _local_6 = new MissionView(_arg_1, _arg_2, _arg_3);
            _local_6.boxState = MissionView.SMALLBOX;
            _local_6.x = (_local_6.y = 0);
            var _local_7:MissionView = new MissionView(_arg_1, _arg_2, _arg_3);
            _local_7.boxState = MissionView.SMALLBOX;
            _local_7.x = (_local_7.y = 0);
            _local_5.movie.x = (_arg_3.x - _local_6.smallFramePoint.x);
            _local_5.movie.y = (_arg_3.y - _local_6.smallFramePoint.y);
            _arg_3.x = (_arg_3.y = 0);
            _local_5.movie.pBox.addChild(_arg_3);
            _local_5.movie.grayBox.addChild(_local_7);
            _local_5.movie.colBox.addChild(_local_6);
            _local_5.addEventListener(Event.COMPLETE, this.openMapAnimaComplete);
            _local_6.addEventListener(SingleDungeonEvent.CLICK_MISSION_VIEW, this.__boxClick);
            this.addChild(_local_5.movie);
            _local_5.play();
            this.missionArray.push(_local_6);
            this.missionArray.push(_local_7);
            this.missionArray.push(_local_5.movie);
            _local_5.movie.mouseChildren = false;
            _arg_3.visible = true;
            if (SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID])
            {
                _local_8 = (SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID] as Array);
                if (_local_8.indexOf(_arg_1[_arg_2].ID) < 0)
                {
                    _local_8.push(_arg_1[_arg_2].ID);
                };
            }
            else
            {
                SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID] = [_arg_1[_arg_2].ID];
            };
            SharedManager.Instance.save();
        }

        private function openMapAnimaComplete(_arg_1:Event):void
        {
            var _local_3:Sprite;
            (_arg_1.target as EventDispatcher).removeEventListener(Event.COMPLETE, this.openMapAnimaComplete);
            var _local_2:MissionView = (_arg_1.target.movie.colBox.getChildAt(1) as MissionView);
            _local_3 = this.creatPointBitm(_local_2.info);
            _arg_1.target.dispose();
            _arg_1 = null;
            this.addChild(_local_2);
            _local_2.mouseEnabled = true;
            _local_2.boxState = MissionView.SMALLBOX;
            this.missionArray.push(_local_2);
            this.addChild(_local_3);
            this.missionArray.push(_local_3);
            _local_3.visible = true;
        }

        private function isSavePointMission(_arg_1:Vector.<MapSceneModel>, _arg_2:int, _arg_3:DisplayObject):Boolean
        {
            var _local_4:Boolean;
            if (_arg_1[_arg_2].ID < 12)
            {
                if (((((((((((_arg_1[_arg_2].ID == 11) && (SavePointManager.Instance.savePoints[34])) || ((_arg_1[_arg_2].ID == 2) && (SavePointManager.Instance.savePoints[40]))) || ((_arg_1[_arg_2].ID == 5) && (SavePointManager.Instance.savePoints[36]))) || ((_arg_1[_arg_2].ID == 6) && (SavePointManager.Instance.savePoints[43]))) || ((_arg_1[_arg_2].ID == 7) && (SavePointManager.Instance.savePoints[41]))) || ((_arg_1[_arg_2].ID == 8) && (SavePointManager.Instance.savePoints[18]))) || ((_arg_1[_arg_2].ID == 3) && (SavePointManager.Instance.savePoints[52]))) || ((_arg_1[_arg_2].ID == 9) && (SavePointManager.Instance.savePoints[53]))) || ((_arg_1[_arg_2].ID == 10) && (SavePointManager.Instance.savePoints[48]))))
                {
                    if (((((((((((_arg_1[_arg_2].ID == 11) && (SavePointManager.Instance.isInSavePoint(4))) || ((_arg_1[_arg_2].ID == 2) && (SavePointManager.Instance.isInSavePoint(11)))) || ((_arg_1[_arg_2].ID == 5) && (SavePointManager.Instance.isInSavePoint(6)))) || ((_arg_1[_arg_2].ID == 6) && (SavePointManager.Instance.isInSavePoint(8)))) || ((_arg_1[_arg_2].ID == 7) && (SavePointManager.Instance.isInSavePoint(12)))) || ((_arg_1[_arg_2].ID == 8) && (SavePointManager.Instance.isInSavePoint(19)))) || ((_arg_1[_arg_2].ID == 3) && (SavePointManager.Instance.isInSavePoint(22)))) || ((_arg_1[_arg_2].ID == 9) && (SavePointManager.Instance.isInSavePoint(23)))) || ((_arg_1[_arg_2].ID == 10) && (SavePointManager.Instance.isInSavePoint(25)))))
                    {
                        if (SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID])
                        {
                            _local_4 = (SharedManager.Instance.firstOpenMission[PlayerManager.Instance.Self.ID].indexOf(_arg_1[_arg_2].ID) > -1);
                        };
                        if ((!(_local_4)))
                        {
                            this.createOpenMapAnima(_arg_1, _arg_2, _arg_3);
                        }
                        else
                        {
                            this.createMissionBox(_arg_1, _arg_2, _arg_3, true);
                        };
                    }
                    else
                    {
                        this.createMissionBox(_arg_1, _arg_2, _arg_3, true);
                    };
                }
                else
                {
                    this.createMissionBox(_arg_1, _arg_2, _arg_3, true, false);
                };
                return (true);
            };
            if (_arg_1[_arg_2].ID > 1000)
            {
                _arg_3.visible = false;
                return (true);
            };
            return (false);
        }

        private function mapComboxChanged(_arg_1:InteractiveEvent):void
        {
            var _local_2:int;
            SoundManager.instance.play("008");
            var _local_3:int;
            while (_local_3 < this.maplist.length)
            {
                if (this.maplist[_local_3].Name == this.mapCombox.currentSelectedCellValue)
                {
                    _local_2 = _local_3;
                };
                _local_3++;
            };
            this.currentMap = this.maplist[_local_2];
            SingleDungeonManager.Instance.maplistIndex = _local_2;
            SingleDungeonManager.Instance.getBigMapImage(this.loadMapComplete, PathManager.solveSingleDungeonWorldMapPath(this.currentMap.Path));
            this.removeMission();
        }

        private function updataPageNum():void
        {
            this.totalPageNum = 0;
            var _local_1:int;
            while (_local_1 < this.maplist.length)
            {
                if (PlayerManager.Instance.Self.Grade >= this.maplist[_local_1].Level)
                {
                    this.totalPageNum++;
                };
                _local_1++;
            };
            if (this.totalPageNum == 1)
            {
                this._leftBtn.mouseEnabled = false;
                this._rightBtn.mouseEnabled = false;
                this.applyGray(this._leftBtn);
                this.applyGray(this._rightBtn);
            }
            else
            {
                if (this.totalPageNum > 1)
                {
                    this._leftBtn.mouseEnabled = true;
                    this._rightBtn.mouseEnabled = true;
                    this._leftBtn.filters = null;
                    this._rightBtn.filters = null;
                };
            };
        }

        private function getHardModeMapCount(_arg_1:uint):uint
        {
            var _local_2:uint;
            var _local_3:uint;
            while (_local_3 < this.mapHardSceneList.length)
            {
                if (this.maplist[_arg_1].ID == this.mapHardSceneList[_local_3].MapID)
                {
                    if (PlayerManager.Instance.Self.Grade >= this.mapHardSceneList[_local_3].MinLevel)
                    {
                        _local_2++;
                    };
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function paging(_arg_1:MouseEvent):void
        {
            var _local_2:int = SingleDungeonManager.Instance.maplistIndex;
            if (((_arg_1) && (_arg_1.target == this._leftBtn)))
            {
                _local_2--;
            }
            else
            {
                if (((_arg_1) && (_arg_1.target == this._rightBtn)))
                {
                    _local_2++;
                };
            };
            if (_local_2 < 0)
            {
                _local_2 = (this.totalPageNum - 1);
            };
            if (_local_2 > (this.totalPageNum - 1))
            {
                _local_2 = 0;
            };
            if (((_local_2 >= 0) && (_local_2 < this.maplist.length)))
            {
                this.currentMap = this.maplist[_local_2];
                SingleDungeonManager.Instance.maplistIndex = _local_2;
                if (this.vBmpDic[_local_2])
                {
                    this._mapContainer.removeChild(this.vBmpDic[SingleDungeonManager.Instance.maplistIndex]);
                    this._mapContainer.addChild(this.vBmpDic[_local_2]);
                    this.createMissionPoints();
                    TaskManager.instance.checkHighLight();
                }
                else
                {
                    SingleDungeonManager.Instance.getBigMapImage(this.loadMapComplete, PathManager.solveSingleDungeonWorldMapPath(this.currentMap.Path));
                };
                SoundManager.instance.play("008");
            };
            if (this.currentMap.ID == 2)
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.SINGLE_DUNGEON_MISSION);
            };
            this.showHandContainer();
        }

        private function __boxClick(_arg_1:SingleDungeonEvent):void
        {
            this.Box = (_arg_1.currentTarget as MissionView);
            if (((this.Box) && (this.Box.state == MissionView.SMALLBOX)))
            {
                this.Box.boxState = MissionView.BIGBOX;
            };
        }

        private function pointBitmClick(_arg_1:MouseEvent):void
        {
            var _local_2:Sprite;
            for each (_local_2 in this.missionArray)
            {
                if ((((_local_2 is MissionView) && (_local_2.parent == this)) && (_arg_1.target == (_local_2 as MissionView).ptBitmap)))
                {
                    this.Box = (_local_2 as MissionView);
                    if (((SingleDungeonManager.Instance.CanPointClick[this.Box.info.ID]) && (!(SingleDungeonManager.Instance.CanPointClick[this.Box.info.ID] == "true"))))
                    {
                        return;
                    };
                    this.Box.boxState = MissionView.BIGBOX;
                    break;
                };
            };
        }

        private function maskClick(_arg_1:MouseEvent):void
        {
            if (((this.Box) && (!(this.Box.isPlay))))
            {
                this.addChildAt(this.mapMask, 0);
                this.mapMask.alpha = 0;
                this.Box.boxState = MissionView.SMALLBOX;
            };
        }

        private function creatMask():void
        {
            if (this.mapMask == null)
            {
                this.mapMask = new Sprite();
                this.mapMask.graphics.beginFill(0, 1);
                this.mapMask.graphics.drawRect(0, 0, 1000, 600);
                this.mapMask.graphics.endFill();
                this.mapMask.alpha = 0;
                this.addChildAt(this.mapMask, 0);
                this.mapMask.addEventListener(MouseEvent.CLICK, this.maskClick);
            };
        }

        private function applyGray(_arg_1:DisplayObject):void
        {
            var _local_2:Array = new Array();
            _local_2 = _local_2.concat([0.3086, 0.6094, 0.082, 0, 0]);
            _local_2 = _local_2.concat([0.3086, 0.6094, 0.082, 0, 0]);
            _local_2 = _local_2.concat([0.3086, 0.6094, 0.082, 0, 0]);
            _local_2 = _local_2.concat([0, 0, 0, 1, 0]);
            var _local_3:ColorMatrixFilter = new ColorMatrixFilter(_local_2);
            var _local_4:Array = new Array();
            _local_4.push(_local_3);
            _arg_1.filters = _local_4;
        }

        private function mapClick(_arg_1:MouseEvent):void
        {
            if (((this.Box) && (_arg_1.target == this._mapContainer)))
            {
                this.Box.boxState = MissionView.SMALLBOX;
                this.Box = null;
            };
        }

        private function showHandContainer():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALL_BUILD);
            NewHandContainer.Instance.clearArrowByID(ArrowType.SINGLE_DUNGEON_MISSION);
            if (this.currentMap.ID == 1)
            {
                if (SavePointManager.Instance.isInSavePoint(4))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 135, "singleDungeon.mission2ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission2tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (SavePointManager.Instance.isInSavePoint(6))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 135, "singleDungeon.mission3ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission3tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((SavePointManager.Instance.isInSavePoint(8)) && (SavePointManager.Instance.savePoints[43])))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission4ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission4tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((SavePointManager.Instance.isInSavePoint(10)) && (!(TaskManager.instance.isNewHandTaskCompleted(6)))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission4ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission4tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((SavePointManager.Instance.isInSavePoint(11)) && (!(TaskManager.instance.isNewHandTaskCompleted(3)))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission9ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission9tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (SavePointManager.Instance.isInSavePoint(12))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission5ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission5tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (SavePointManager.Instance.isInSavePoint(19))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 135, "singleDungeon.mission6ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission6tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((SavePointManager.Instance.isInSavePoint(22)) && (!(TaskManager.instance.isNewHandTaskCompleted(18)))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission8ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission8tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((((SavePointManager.Instance.isInSavePoint(23)) && (((!(TaskManager.instance.isNewHandTaskCompleted(19))) && (!(TaskManager.instance.isNewHandTaskAchieved(19)))) || ((!(TaskManager.instance.isNewHandTaskCompleted(20))) && (!(TaskManager.instance.isNewHandTaskAchieved(20)))))) || ((SavePointManager.Instance.isInSavePoint(25)) && (!(TaskManager.instance.isNewHandTaskCompleted(22))))) || ((SavePointManager.Instance.isInSavePoint(27)) && (((!(TaskManager.instance.isNewHandTaskCompleted(24))) && (!(TaskManager.instance.isNewHandTaskAchieved(24)))) || ((!(TaskManager.instance.isNewHandTaskCompleted(25))) && (!(TaskManager.instance.isNewHandTaskAchieved(25))))))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission7ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission7tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((((((((SavePointManager.Instance.savePoints[38]) && (SavePointManager.Instance.isInSavePoint(9))) && (!(TaskManager.instance.isNewHandTaskCompleted(7)))) || (((SavePointManager.Instance.savePoints[42]) && (SavePointManager.Instance.isInSavePoint(14))) && (!(TaskManager.instance.isNewHandTaskCompleted(10))))) || ((SavePointManager.Instance.isInSavePoint(26)) && (!(TaskManager.instance.isNewHandTaskCompleted(23))))) || ((SavePointManager.Instance.isInSavePoint(55)) && (!(TaskManager.instance.isNewHandTaskCompleted(27))))) || (SavePointManager.Instance.isInSavePoint(28))) || (SavePointManager.Instance.isInSavePoint(47))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE, -45, "singleDungeon.missionbackArrowPos", "", "", this);
                };
            };
            if (this.currentMap.ID == 2)
            {
                if (SavePointManager.Instance.isInSavePoint(23))
                {
                    if ((!(TaskManager.instance.isNewHandTaskAchieved(20))))
                    {
                        if ((!(TaskManager.instance.isNewHandTaskCompleted(20))))
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 180, "singleDungeon.mission10ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission10tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                        };
                    };
                };
                if ((((SavePointManager.Instance.isInSavePoint(25)) && (!(TaskManager.instance.isNewHandTaskCompleted(22)))) || ((SavePointManager.Instance.isInSavePoint(27)) && (((!(TaskManager.instance.isNewHandTaskCompleted(24))) && (!(TaskManager.instance.isNewHandTaskAchieved(24)))) || ((!(TaskManager.instance.isNewHandTaskCompleted(25))) && (!(TaskManager.instance.isNewHandTaskAchieved(25))))))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SINGLE_DUNGEON_MISSION, 135, "singleDungeon.mission11ArrowPos", "asset.trainer.txtClickEnter", "singleDungeon.mission11tipPos", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
                };
                if (((SavePointManager.Instance.isInSavePoint(47)) || (SavePointManager.Instance.isInSavePoint(55))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE, -45, "singleDungeon.missionbackArrowPos", "", "", this);
                };
            };
            if (SavePointManager.Instance.isInSavePoint(38))
            {
                this.showDialog(22);
            };
            if (SavePointManager.Instance.isInSavePoint(39))
            {
                this.showDialog(23);
            };
            if (SavePointManager.Instance.isInSavePoint(40))
            {
                this.showDialog(24);
            };
            if (SavePointManager.Instance.isInSavePoint(41))
            {
                this.showDialog(44);
            };
            if (SavePointManager.Instance.isInSavePoint(43))
            {
                this.showDialog(45);
            };
        }

        private function showDialog(_arg_1:uint):void
        {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.showDialog(_arg_1);
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            if (SavePointManager.Instance.isInSavePoint(38))
            {
                SavePointManager.Instance.setSavePoint(38);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            };
            if (SavePointManager.Instance.isInSavePoint(39))
            {
                SavePointManager.Instance.setSavePoint(39);
            };
            if (SavePointManager.Instance.isInSavePoint(40))
            {
                SavePointManager.Instance.setSavePoint(40);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            };
            if (SavePointManager.Instance.isInSavePoint(41))
            {
                SavePointManager.Instance.setSavePoint(41);
            };
            if (SavePointManager.Instance.isInSavePoint(43))
            {
                SavePointManager.Instance.setSavePoint(43);
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            };
            if (SavePointManager.Instance.isInSavePoint(14))
            {
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            };
            if (((SavePointManager.Instance.savePoints[54]) && (SavePointManager.Instance.isInSavePoint(55))))
            {
                SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            };
        }

        private function removeMission():void
        {
            var _local_1:int = (this.missionArray.length - 1);
            while (_local_1 >= 0)
            {
                if (((this.missionArray[_local_1]) && (this.contains(this.missionArray[_local_1]))))
                {
                    if ((this.missionArray[_local_1] is MovieClip))
                    {
                        this.missionArray[_local_1].stop();
                    };
                    this.removeChild(this.missionArray[_local_1]);
                    this.missionArray.splice(_local_1, 1);
                };
                _local_1--;
            };
        }

        private function removeEvent():void
        {
            this._mapContainer.removeEventListener(MouseEvent.CLICK, this.mapClick);
            SingleDungeonEvent.dispatcher.removeEventListener(SingleDungeonEvent.FRAME_EXIT, this.__framExit);
            TimeManager.removeEventListener(TimeEvents.SECONDS, this._showFeildGain);
            this._leftBtn.removeEventListener(MouseEvent.CLICK, this.paging);
            this._rightBtn.removeEventListener(MouseEvent.CLICK, this.paging);
            this._modeMenu.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__onListClick);
            this._modeMenu.button.removeEventListener(MouseEvent.CLICK, this.__clickMenuBtn);
            this._hardModeHelpBtn.removeEventListener(MouseEvent.CLICK, this.__onHardModeHelpBtnClick);
            this._hardModeExpeditionButton.removeEventListener(MouseEvent.CLICK, this.__clickHardModeExpedition);
        }

        private function __clickHardModeExpedition(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ExpeditionController.instance.show(ExpeditionModel.HARD_MODE);
        }

        private function __onExitClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            StateManager.setState(StateType.MAIN);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            this.dispose();
            super.leaving(_arg_1);
        }

        override public function dispose():void
        {
            var _local_2:MissionView;
            var _local_3:Bitmap;
            var _local_4:Sprite;
            ChatManager.Instance.chatDisabled = false;
            ExpeditionController.instance.hide();
            FarmModelController.instance.deleteGainPlant();
            FightPowerAndFatigue.Instance.hide();
            this.removeEvent();
            SingleDungeonManager.Instance.removeBigLoaderListener();
            var _local_1:int;
            while (_local_1 < this.missionArray.length)
            {
                ObjectUtils.disposeObject(this.missionArray[_local_1]);
                this.missionArray[_local_1] = null;
                _local_1++;
            };
            this.missionArray = null;
            for each (_local_2 in this.missionViewDic)
            {
                _local_2.dispose();
                _local_2 = null;
            };
            this.missionViewDic.clear();
            this.missionViewDic = null;
            for each (_local_3 in this.vBmpDic)
            {
                ObjectUtils.disposeObject(_local_3);
                _local_3 = null;
            };
            this.vBmpDic.clear();
            this.vBmpDic = null;
            for each (_local_4 in this.pointBitmDic)
            {
                ObjectUtils.disposeAllChildren(_local_4);
                _local_4 = null;
            };
            this.pointBitmDic.clear();
            this.pointBitmDic = null;
            ObjectUtils.disposeObject(this.mapCombox);
            this.mapCombox = null;
            ObjectUtils.disposeObject(this.Box);
            this.Box = null;
            if (this._mapContainer)
            {
                ObjectUtils.disposeAllChildren(this._mapContainer);
            };
            ObjectUtils.disposeObject(this._mapContainer);
            this._mapContainer = null;
            ObjectUtils.disposeObject(this.mapMask);
            this.mapMask = null;
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
            if (this._modeMenu)
            {
                ObjectUtils.disposeObject(this._modeMenu);
                this._modeMenu = null;
            };
            ObjectUtils.disposeObject(this.dropList);
            this.dropList = null;
            if (this._hardModeHelpBtn)
            {
                ObjectUtils.disposeObject(this._hardModeHelpBtn);
            };
            this._hardModeHelpBtn = null;
            if (this._hardModeExpeditionButton)
            {
                ObjectUtils.disposeObject(this._hardModeExpeditionButton);
            };
            this._hardModeExpeditionButton = null;
            ObjectUtils.disposeAllChildren(this);
            this.currentMap = null;
            this.maplist = null;
            this.mapSceneList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon

