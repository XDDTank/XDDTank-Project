// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.MissionView

package SingleDungeon.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.BaseButton;
    import SingleDungeon.model.MapSceneModel;
    import ddt.data.map.DungeonInfo;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
    import ddt.data.BuffInfo;
    import SingleDungeon.model.MissionType;
    import ddt.manager.SoundManager;
    import SingleDungeon.SingleDungeonManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import SingleDungeon.event.CDCollingEvent;
    import SingleDungeon.event.SingleDungeonEvent;
    import com.greensock.TweenLite;
    import SingleDungeon.SingleDungeonMainStateView;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.PathManager;
    import SingleDungeon.hardMode.HardModeManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.quest.QuestInfo;
    import ddt.manager.TaskManager;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.MapManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.ServerConfigManager;
    import SingleDungeon.expedition.ExpeditionHistory;
    import SingleDungeon.expedition.ExpeditionController;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.loader.BitmapLoader;
    import org.bytearray.display.ScaleBitmap;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.loader.LoaderEvent;
    import SingleDungeon.expedition.ExpeditionModel;
    import ddt.manager.MessageTipManager;
    import ddt.view.MainToolBar;
    import ddt.data.EquipPlace;
    import ddt.manager.SocketManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import flash.utils.setTimeout;
    import ddt.manager.SavePointManager;
    import com.greensock.easing.Back;
    import com.greensock.easing.Sine;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;

    public class MissionView extends Sprite implements Disposeable 
    {

        public static const SMALLBOX:int = 1;
        public static const BIGBOX:int = 2;

        private var descSmallFrame:Bitmap;
        private var descBigFrame:Bitmap;
        private var taskBitm:MovieClip;
        private var taskBigBitm:MovieClip;
        private var _ifEnterBitmap:Bitmap;
        private var _challengeBtn:BaseButton;
        private var _expeditionBtn:BaseButton;
        private var _exploreBtn:BaseButton;
        private var _attackBtn:BaseButton;
        private var _collectBtn:BaseButton;
        private var _lookDropBtn:BaseButton;
        public var info:MapSceneModel;
        public var smallBox:Sprite;
        public var bigBox:Sprite;
        private var _questInfo:DungeonInfo;
        public var state:int;
        public var isPlay:Boolean;
        private var dropList:DropList;
        private var _tipData:Object;
        private var _tipDirection:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        public var smallFramePoint:Point;
        private var bigFramePoint:Point;
        private var smallImageRect:Rectangle;
        private var bigImageRect:Rectangle;
        public var mapPoint:Point;
        private var _changedMapId:int;
        private var _mapSceneList:Vector.<MapSceneModel>;
        public var ptBitmap:DisplayObject;
        private var loadMapCompleteFun:Function;
        private var _cdView:CDView;
        private var filterArr:Array = [new GlowFilter(16777062, 1, 10, 10, 1.8)];
        private var _buffInfo:BuffInfo;

        public function MissionView(_arg_1:Vector.<MapSceneModel>, _arg_2:int, _arg_3:DisplayObject)
        {
            this._mapSceneList = _arg_1;
            this.info = _arg_1[_arg_2];
            this.ptBitmap = _arg_3;
            this.init();
        }

        public function set questInfo(_arg_1:DungeonInfo):void
        {
            this._questInfo = _arg_1;
        }

        public function get questInfo():DungeonInfo
        {
            return (this._questInfo);
        }

        public function set boxState(_arg_1:int):void
        {
            this.state = _arg_1;
            if (_arg_1 == SMALLBOX)
            {
                this.setSmallBox();
                if (this.info.Type == MissionType.HARDMODE)
                {
                    this.showCarnet();
                };
            }
            else
            {
                if (_arg_1 == BIGBOX)
                {
                    this.setBigBox();
                    SoundManager.instance.play("008");
                };
            };
            SingleDungeonManager.Instance.startBtnEnabled = true;
        }

        private function init():void
        {
            this.loadMapCompleteFun = this.loadMapComplete;
            this.mapPoint = new Point(this.ptBitmap.x, this.ptBitmap.y);
            this.smallFramePoint = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.smallFramePoint");
            this.bigFramePoint = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.bigFramePoint");
            this.smallImageRect = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.smallImageRect");
            this.bigImageRect = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.bigImageRect");
            this.ptBitmap.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this.ptBitmap.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            this.info.addEventListener(CDCollingEvent.CD_UPDATE, this.__cdChangeHandle);
            SingleDungeonManager.Instance.addEventListener(SingleDungeonEvent.UPDATE_TIMES, this.__updateTimes);
        }

        private function __updateTimes(_arg_1:SingleDungeonEvent):void
        {
            this.showCarnet();
        }

        private function setSmallBox():void
        {
            if (this.smallBox)
            {
                this.smallBox.visible = true;
                TweenLite.to(this.smallBox, 0.2, {
                    "alpha":1,
                    "onComplete":this.onSmallTween
                });
            };
            if (this.bigBox)
            {
                TweenLite.to(this.bigBox, 0.2, {
                    "alpha":0,
                    "onComplete":this.onSmallTween
                });
            };
            if (this.smallBox == null)
            {
                this.creatSmallBox();
            };
            if ((parent is SingleDungeonMainStateView))
            {
                this.dropList = (parent as SingleDungeonMainStateView).dropList;
            };
            if (this.dropList != null)
            {
                this.dropList.dispose();
                this.dropList = null;
            };
            this.x = (this.mapPoint.x - this.smallFramePoint.x);
            this.y = (this.mapPoint.y - this.smallFramePoint.y);
            this.smallBox.mouseEnabled = true;
        }

        private function setBigBox():void
        {
            this.isPlay = true;
            if (this.bigBox == null)
            {
                this.creatBigBox();
            };
            if (this.smallBox)
            {
                TweenLite.to(this.smallBox, 0.2, {
                    "alpha":0,
                    "onComplete":this.onSmallTween
                });
            };
            if (this.bigBox)
            {
                TweenLite.to(this.bigBox, 0.2, {
                    "alpha":1,
                    "x":(this.bigBox.x - 50),
                    "y":(this.bigBox.y - 30),
                    "scaleX":1.2,
                    "scaleY":1.2,
                    "onComplete":this.onBigTween
                });
                parent.setChildIndex((parent as SingleDungeonMainStateView).mapMask, (parent.numChildren - 1));
                TweenLite.to((parent as SingleDungeonMainStateView).mapMask, 0.2, {"alpha":0.5});
            };
            this.x = (this.mapPoint.x - this.bigFramePoint.x);
            this.y = (this.mapPoint.y - this.bigFramePoint.y);
            this.bigBox.mouseEnabled = false;
        }

        private function onSmallTween():void
        {
            if (this.state == SMALLBOX)
            {
                if (this.bigBox)
                {
                    this.bigBox.visible = false;
                };
            }
            else
            {
                if (this.state == BIGBOX)
                {
                    if (this.smallBox)
                    {
                        this.smallBox.visible = false;
                    };
                };
            };
        }

        private function onBigTween():void
        {
            this.bigBox.visible = true;
            TweenLite.to(this.bigBox, 0.2, {
                "x":(this.bigBox.x + 50),
                "y":(this.bigBox.y + 30),
                "scaleX":1,
                "scaleY":1,
                "onComplete":this.onTweenComplete
            });
            parent.setChildIndex(this, (parent.numChildren - 1));
        }

        private function onTweenComplete():void
        {
            this.isPlay = false;
        }

        private function creatSmallBox():void
        {
            var _local_1:FilterFrameText;
            this.smallBox = new Sprite();
            this.smallBox.buttonMode = true;
            this.smallBox.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            this.smallBox.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            this.smallBox.addEventListener(MouseEvent.CLICK, this.__mouseClickSmallBox);
            this.getSmallMapImage(this.loadMapCompleteFun, PathManager.solveSingleDungeonSelectMisstionPath((this.info.Path + "/1.png")));
            if (this.info.Type == 2)
            {
                this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameGeen");
            }
            else
            {
                if (this.info.Type == 3)
                {
                    this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameRed");
                }
                else
                {
                    if (this.info.Type == 4)
                    {
                        this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameYellow");
                    }
                    else
                    {
                        this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameSilver");
                    };
                };
            };
            this.smallBox.addChild(this.descSmallFrame);
            _local_1 = ComponentFactory.Instance.creatComponentByStylename("singledungeon.levelTxt");
            _local_1.text = ((("LV:" + this.info.MinLevel) + "-") + this.info.MaxLevel);
            this.smallBox.addChild(_local_1);
            var _local_2:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.titleTxtSmall");
            _local_2.text = this.info.Name;
            this.smallBox.addChild(_local_2);
            _local_2.x = ((this.smallImageRect.width - _local_2.textWidth) - 5);
            _local_1.x = ((this.smallImageRect.width - _local_1.textWidth) - 8);
            this.createTaskBitm();
            this.addChild(this.smallBox);
            if ((((this.info.Type == 3) || (this.info.Type == 2)) || (this.info.Type == 4)))
            {
                _local_2.y = (_local_2.y - 5);
                _local_1.y = (_local_1.y - 2);
            };
            if (this.info.Type == MissionType.ATTACT)
            {
                this.setEnable(false);
            };
        }

        private function setEnable(_arg_1:Boolean):void
        {
            this.smallBox.filters = ((_arg_1) ? null : ComponentFactory.Instance.creatFilters("grayFilter"));
            this.ptBitmap.filters = ((_arg_1) ? null : ComponentFactory.Instance.creatFilters("grayFilter"));
            if (_arg_1)
            {
                if (SingleDungeonManager.Instance.CanPointClick.hasKey(this.info.ID))
                {
                    SingleDungeonManager.Instance.CanPointClick[this.info.ID] = "true";
                }
                else
                {
                    SingleDungeonManager.Instance.CanPointClick.add(this.info.ID, "true");
                };
                this.ptBitmap["buttonMode"] = true;
            }
            else
            {
                if (SingleDungeonManager.Instance.CanPointClick.hasKey(this.info.ID))
                {
                    SingleDungeonManager.Instance.CanPointClick[this.info.ID] = "false";
                }
                else
                {
                    SingleDungeonManager.Instance.CanPointClick.add(this.info.ID, "false");
                };
                this.ptBitmap["buttonMode"] = false;
            };
        }

        public function updatable():void
        {
            this.createTaskBitm();
        }

        private function showCarnet():void
        {
            if (this.info.ID < 200)
            {
                return;
            };
            var _local_1:Boolean = HardModeManager.instance.checkEnter(this.info.ID);
            if (_local_1)
            {
                if (this._ifEnterBitmap == null)
                {
                    this._ifEnterBitmap = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.carnetBitm");
                    this.addChild(this._ifEnterBitmap);
                };
            }
            else
            {
                ObjectUtils.disposeObject(this._ifEnterBitmap);
                this._ifEnterBitmap = null;
            };
            var _local_2:Boolean = HardModeManager.instance.getAllowEnter(this.info.ID);
            this.setEnable(_local_2);
        }

        private function createTaskBitm():void
        {
            var _local_1:Array;
            var _local_2:Array;
            var _local_3:int;
            var _local_4:QuestInfo;
            var _local_5:QuestInfo;
            if ((((this.info.RelevanceQuest) && (this.info.RelevanceQuest.length > 0)) && (!(this.info.Type == MissionType.HARDMODE))))
            {
                _local_1 = this.info.RelevanceQuest.split(",");
                _local_2 = TaskManager.instance.allCurrentQuest;
                this.info.questData.splice(0, this.info.questData.length);
                _local_3 = 0;
                while (_local_3 < _local_1.length)
                {
                    _local_4 = TaskManager.instance.getQuestByID(_local_1[_local_3]);
                    for each (_local_5 in _local_2)
                    {
                        if (((_local_4 == _local_5) && (!((_local_4.isCompleted) || (_local_4.isAchieved)))))
                        {
                            if (this.taskBitm == null)
                            {
                                this.taskBitm = (ClassUtils.CreatInstance("asset.singleDungeon.smallQuestSign") as MovieClip);
                                PositionUtils.setPos(this.taskBitm, "singledungeon.taskPoint1");
                                this.smallBox.addChild(this.taskBitm);
                            };
                            this.info.questData.push(_local_4);
                        };
                    };
                    _local_3++;
                };
                if (((this.info.questData.length == 0) && (this.taskBitm)))
                {
                    ObjectUtils.disposeObject(this.taskBitm);
                };
            };
        }

        private function creatBigBox():void
        {
            var _local_2:FilterFrameText;
            var _local_3:Point;
            this.bigBox = new Sprite();
            this.getSmallMapImage(this.loadMapCompleteFun, PathManager.solveSingleDungeonSelectMisstionPath((this.info.Path + "/1.png")));
            if (this.info.Type == 2)
            {
                this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameGeen");
            }
            else
            {
                if (this.info.Type == 3)
                {
                    this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameRed");
                }
                else
                {
                    if (this.info.Type == 4)
                    {
                        this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameYellow");
                    }
                    else
                    {
                        this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameSilver");
                    };
                };
            };
            this.bigBox.addChild(this.descBigFrame);
            var _local_1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.titleTxtBig");
            _local_1.text = this.info.Name;
            this.bigBox.addChild(_local_1);
            if (((this.info.Type == MissionType.FIGHT) || (this.info.Type == MissionType.HARDMODE)))
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("singledungeon.needEnergyTxt");
                _local_2.text = (LanguageMgr.GetTranslation("tank.multiDungeon.needEnergy") + MapManager.getDungeonInfo(this.info.MissionID).Energy[1].toString());
                this.bigBox.addChild(_local_2);
            };
            _local_1.x = ((this.bigImageRect.width - _local_1.textWidth) - 5);
            if (this.info.Type == MissionType.EXPLORE)
            {
                this._exploreBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.exploreBtn");
                this.bigBox.addChild(this._exploreBtn);
                this._exploreBtn.addEventListener(MouseEvent.CLICK, this.startMissionClick);
            }
            else
            {
                if (this.info.Type == MissionType.ATTACT)
                {
                    this._attackBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.attackBtn");
                    this.bigBox.addChild(this._attackBtn);
                    this._attackBtn.addEventListener(MouseEvent.CLICK, this.startMissionClick);
                }
                else
                {
                    if (this.info.Type == MissionType.HARDMODE)
                    {
                        this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.collectBtn");
                        this.bigBox.addChild(this._collectBtn);
                        this._collectBtn.addEventListener(MouseEvent.CLICK, this.startMissionClick);
                    }
                    else
                    {
                        this._challengeBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.challengeBtn");
                        this._expeditionBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.expeditionBtn");
                        this.bigBox.addChild(this._challengeBtn);
                        this.bigBox.addChild(this._expeditionBtn);
                        this._expeditionBtn.addEventListener(MouseEvent.CLICK, this.__expeditionClick);
                        this._challengeBtn.addEventListener(MouseEvent.CLICK, this.startMissionClick);
                        this.checkExpedition();
                    };
                };
            };
            if (this.taskBitm != null)
            {
                this.taskBigBitm = (ClassUtils.CreatInstance("asset.singleDungeon.bigQuestSign") as MovieClip);
                _local_3 = (ComponentFactory.Instance.creatCustomObject("singledungeon.taskPoint2") as Point);
                this.taskBigBitm.x = _local_3.x;
                this.taskBigBitm.y = _local_3.y;
                this.bigBox.addChild(this.taskBigBitm);
            };
            this._lookDropBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.lookDropBtn");
            this.bigBox.addChild(this._lookDropBtn);
            this._lookDropBtn.addEventListener(MouseEvent.CLICK, this._lookDropBtnClick);
            this.bigBox.filters = [new GlowFilter(16777062, 1, 10, 10, 1.8)];
            this.addChild(this.bigBox);
            this.bigBox.alpha = 0;
            parent.setChildIndex((parent as SingleDungeonMainStateView).mapMask, (parent.numChildren - 1));
            parent.setChildIndex(this, (parent.numChildren - 1));
        }

        private function checkExpedition():void
        {
            if ((((ExpeditionController.instance.model.expeditionInfoDic[this.info.ID]) && (ExpeditionHistory.instance.get(this.info.MissionID))) && (PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.getExpeditionLimitLevel())))
            {
                this._expeditionBtn.enable = true;
            }
            else
            {
                this._expeditionBtn.enable = false;
            };
        }

        private function loadMapComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:ScaleBitmapImage;
            if (_arg_1.loader.isSuccess)
            {
                _local_2 = new ScaleBitmapImage();
                _local_2.buttonMode = true;
                _local_2.resource = (_arg_1.loader as BitmapLoader).bitmapData;
                (_local_2.display as ScaleBitmap).smoothing = true;
                if ((((_local_2) && (this.smallBox)) && (this.state == SMALLBOX)))
                {
                    _local_2.x = this.smallImageRect.x;
                    _local_2.y = this.smallImageRect.y;
                    _local_2.width = this.smallImageRect.width;
                    _local_2.height = this.smallImageRect.height;
                    this.smallBox.addChildAt(_local_2, 0);
                }
                else
                {
                    if ((((_local_2) && (this.bigBox)) && (this.state == BIGBOX)))
                    {
                        _local_2.x = this.bigImageRect.x;
                        _local_2.y = this.bigImageRect.y;
                        _local_2.width = this.bigImageRect.width;
                        _local_2.height = this.bigImageRect.height;
                        this.bigBox.addChildAt(_local_2, 0);
                    };
                };
                ShowTipManager.Instance.addTip(_local_2);
                _local_2.tipDirctions = "1,2,4,5,0,3,6,7";
                _local_2.tipData = this.info;
                _local_2.tipStyle = "singledungeon.mapTip";
                _local_2.filterString = "null,lightFilter,lightFilter,null";
            };
        }

        private function __expeditionClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this.isPlay)
            {
                return;
            };
            if (PlayerManager.Instance.Self.Fatigue >= 0)
            {
                ExpeditionController.instance.model.currentMapId = this.info.ID;
                ExpeditionController.instance.show(ExpeditionModel.NORMAL_MODE);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.frame.noFatigue"));
            };
        }

        private function startMissionClick(_arg_1:MouseEvent):void
        {
            var _local_2:MapSceneModel;
            var _local_3:int;
            SoundManager.instance.play("008");
            MainToolBar.Instance.setReturnEnable(false);
            if (this.isPlay)
            {
                return;
            };
            if (((!(this.info.Type == MapSceneModel.WALKSCENE)) && (!(PlayerManager.Instance.Self.Bag.getItemAt(EquipPlace.WEAPON)))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"), 0, true);
                MainToolBar.Instance.setReturnEnable(true);
                return;
            };
            if (this.info.Type == MissionType.ATTACT)
            {
                SingleDungeonManager.Instance.isNowBossFight = true;
            };
            if (((this.info.Type == MissionType.HARDMODE) && (HardModeManager.instance.getRemainFightCount(this.info.ID) == 0)))
            {
                MainToolBar.Instance.setReturnEnable(true);
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.missionView.count"), 0, true);
                return;
            };
            SingleDungeonManager.Instance.currentFightType = this.info.Type;
            if (SingleDungeonManager.Instance.startBtnEnabled)
            {
                this._changedMapId = -1;
                this.checkChangeMapID();
                SingleDungeonManager.Instance.startBtnEnabled = false;
                if (this._changedMapId > 0)
                {
                    _local_3 = 0;
                    while (_local_3 < this._mapSceneList.length)
                    {
                        if (this._mapSceneList[_local_3].ID == this._changedMapId)
                        {
                            _local_2 = this._mapSceneList[_local_3];
                            break;
                        };
                        _local_3++;
                    };
                    SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel = _local_2;
                    SingleDungeonManager.Instance.currentMapId = this._changedMapId;
                    SocketManager.Instance.out.sendEnterWalkScene(this._changedMapId);
                }
                else
                {
                    SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel = this.info;
                    SingleDungeonManager.Instance.currentMapId = this.info.ID;
                    SocketManager.Instance.out.sendEnterWalkScene(this.info.ID);
                };
            };
            if (NewHandContainer.Instance.hasArrow(ArrowType.SINGLE_DUNGEON_MISSION))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.SINGLE_DUNGEON_MISSION);
            };
            setTimeout(this.ReturnBtnShow, 1000);
        }

        private function ReturnBtnShow():void
        {
            MainToolBar.Instance.setReturnEnable(true);
        }

        private function checkChangeMapID():void
        {
            if (this.info.ID == 11)
            {
                if (SavePointManager.Instance.isInSavePoint(4))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1011;
                    }
                    else
                    {
                        this._changedMapId = 2011;
                    };
                };
            };
            if (this.info.ID == 5)
            {
                if (SavePointManager.Instance.isInSavePoint(6))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1005;
                    }
                    else
                    {
                        this._changedMapId = 2005;
                    };
                };
            };
            if (this.info.ID == 6)
            {
                if (SavePointManager.Instance.isInSavePoint(8))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1006;
                    }
                    else
                    {
                        this._changedMapId = 2006;
                    };
                };
            };
            if (this.info.ID == 7)
            {
                if (SavePointManager.Instance.isInSavePoint(12))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1007;
                    }
                    else
                    {
                        this._changedMapId = 2007;
                    };
                };
            };
            if (this.info.ID == 8)
            {
                if (SavePointManager.Instance.isInSavePoint(19))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1008;
                    }
                    else
                    {
                        this._changedMapId = 2008;
                    };
                };
            };
            if (this.info.ID == 9)
            {
                if (SavePointManager.Instance.isInSavePoint(23))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1009;
                    }
                    else
                    {
                        this._changedMapId = 2009;
                    };
                };
            };
            if (this.info.ID == 10)
            {
                if (SavePointManager.Instance.isInSavePoint(25))
                {
                    if (PlayerManager.Instance.Self.Sex)
                    {
                        this._changedMapId = 1010;
                    }
                    else
                    {
                        this._changedMapId = 2010;
                    };
                };
                if (SavePointManager.Instance.isInSavePoint(27))
                {
                    this._changedMapId = 2012;
                };
            };
        }

        private function _lookDropBtnClick(evt:MouseEvent):void
        {
            var tween1:TweenLite;
            var tween2:TweenLite;
            if (this.isPlay)
            {
                return;
            };
            SoundManager.instance.play("008");
            if (this.dropList == null)
            {
                this.dropList = ComponentFactory.Instance.creatComponentByStylename("DropList");
                this.dropList.updateList(this.info.MissionID);
                this.dropList.y = (this.dropList.y + this.y);
                this.dropList.x = (this.dropList.x + this.x);
                if (((this.info.Type == 2) || (this.info.Type == 3)))
                {
                    this.dropList.x = (this.dropList.x + 4);
                };
                parent.addChildAt(this.dropList, parent.getChildIndex(this));
                tween1 = TweenLite.to(this.dropList, 0.5, {
                    "y":(this.dropList.y + 124),
                    "ease":Back.easeOut
                });
            }
            else
            {
                tween2 = TweenLite.to(this.dropList, 0.5, {
                    "y":(this.y + 10),
                    "ease":Sine.easeOut,
                    "onComplete":function ():void
                    {
                        if (dropList)
                        {
                            dropList.dispose();
                        };
                        dropList = null;
                        if (tween1)
                        {
                            tween1.kill();
                        };
                        if (tween2)
                        {
                            tween2.kill();
                        };
                    }
                });
            };
            (parent as SingleDungeonMainStateView).dropList = this.dropList;
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            if (((this._cdView) && (this.contains(this._cdView))))
            {
                return;
            };
            if (((this.info.Type == MissionType.HARDMODE) && (!(HardModeManager.instance.getAllowEnter(this.info.ID)))))
            {
                return;
            };
            if (this.checkFilters())
            {
                this.smallBox.filters = this.filterArr;
                this.ptBitmap.filters = this.filterArr;
            };
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (((this._cdView) && (this.contains(this._cdView))))
            {
                return;
            };
            if (((this.info.Type == MissionType.HARDMODE) && (!(HardModeManager.instance.getAllowEnter(this.info.ID)))))
            {
                return;
            };
            if (this.checkFilters())
            {
                this.smallBox.filters = null;
                this.ptBitmap.filters = null;
            };
        }

        private function checkFilters():Boolean
        {
            if (this.info.Type == MissionType.ATTACT)
            {
                if (((this.info.cdColling == 0) && (!((this.info.count + this.miningCount()) == 0))))
                {
                    return (true);
                };
                return (false);
            };
            return (true);
        }

        private function __mouseClickSmallBox(_arg_1:MouseEvent):void
        {
            if (((this.info.Type == MissionType.ATTACT) && ((this.info.count + this.miningCount()) == 0)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.missionView.count"));
            }
            else
            {
                if (this.info.cdColling > 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.missionView.CDing"));
                }
                else
                {
                    if (((this.info.Type == MissionType.HARDMODE) && (!(HardModeManager.instance.getAllowEnter(this.info.ID)))))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.selectMode.hadPassed"), 0, true);
                    }
                    else
                    {
                        dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.CLICK_MISSION_VIEW));
                    };
                };
            };
        }

        private function __cdChangeHandle(_arg_1:CDCollingEvent):void
        {
            if ((this.info.count + this.miningCount()) == 0)
            {
                this.setEnable(false);
            }
            else
            {
                if (this.info.cdColling != 0)
                {
                    if ((!(this._cdView)))
                    {
                        this._cdView = new CDView(this.info);
                        this.addChild(this._cdView);
                        this._cdView.x = (this.smallBox.x + 3);
                        this._cdView.y = (this.smallBox.y - 14);
                        this._cdView.showCD();
                        this.setEnable(false);
                    };
                }
                else
                {
                    if (this.info.cdColling == 0)
                    {
                        this.setEnable(true);
                        ObjectUtils.disposeObject(this._cdView);
                        this._cdView = null;
                    };
                };
            };
        }

        private function miningCount():int
        {
            if ((!(PlayerManager.Instance.Self.consortionStatus)))
            {
                return (0);
            };
            if (this.info.Type == MissionType.ATTACT)
            {
                this._buffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_SIRIKE_COPY_COUNT];
            };
            if (this._buffInfo == null)
            {
                return (0);
            };
            return (this._buffInfo.ValidCount);
        }

        private function removeEvent():void
        {
            if (this._challengeBtn)
            {
                this._challengeBtn.removeEventListener(MouseEvent.CLICK, this.startMissionClick);
            };
            if (this._expeditionBtn)
            {
                this._expeditionBtn.removeEventListener(MouseEvent.CLICK, this.__expeditionClick);
            };
            if (this._exploreBtn)
            {
                this._exploreBtn.removeEventListener(MouseEvent.CLICK, this.startMissionClick);
            };
            if (this._lookDropBtn)
            {
                this._lookDropBtn.removeEventListener(MouseEvent.CLICK, this._lookDropBtnClick);
            };
            if (this.smallBox)
            {
                this.smallBox.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
                this.smallBox.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
                this.smallBox.removeEventListener(MouseEvent.CLICK, this.__mouseClickSmallBox);
                this.info.removeEventListener(CDCollingEvent.CD_UPDATE, this.__cdChangeHandle);
            };
            SingleDungeonManager.Instance.removeEventListener(SingleDungeonEvent.UPDATE_TIMES, this.__updateTimes);
        }

        private function getSmallMapImage(_arg_1:Function, _arg_2:String):void
        {
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(_arg_2, BaseLoader.BITMAP_LOADER);
            _local_3.addEventListener(LoaderEvent.COMPLETE, this.__smallMapComplete);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        private function __smallMapComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.target.removeEventListener(LoaderEvent.COMPLETE, this.__smallMapComplete);
            if (this.loadMapCompleteFun != null)
            {
                this.loadMapCompleteFun(_arg_1);
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this.loadMapCompleteFun = null;
            while (((this.info) && (this.info.questData.length > 0)))
            {
                this.info.questData.pop();
            };
            this.info = null;
            ObjectUtils.disposeObject(this.descBigFrame);
            this.descBigFrame = null;
            ObjectUtils.disposeObject(this.descBigFrame);
            this.descBigFrame = null;
            ObjectUtils.disposeObject(this.taskBitm);
            this.taskBitm = null;
            ObjectUtils.disposeObject(this.taskBigBitm);
            this.taskBigBitm = null;
            ObjectUtils.disposeObject(this._ifEnterBitmap);
            this._ifEnterBitmap = null;
            ObjectUtils.disposeObject(this._challengeBtn);
            this._challengeBtn = null;
            ObjectUtils.disposeObject(this._expeditionBtn);
            this._expeditionBtn = null;
            ObjectUtils.disposeObject(this._exploreBtn);
            this._exploreBtn = null;
            ObjectUtils.disposeObject(this._attackBtn);
            this._attackBtn = null;
            ObjectUtils.disposeObject(this._lookDropBtn);
            this._lookDropBtn = null;
            ObjectUtils.disposeObject(this.descSmallFrame);
            this.descSmallFrame = null;
            ObjectUtils.disposeObject(this.descBigFrame);
            this.descBigFrame = null;
            ObjectUtils.disposeAllChildren(this.smallBox);
            ObjectUtils.disposeObject(this.smallBox);
            this.smallBox = null;
            ObjectUtils.disposeAllChildren(this.bigBox);
            ObjectUtils.disposeObject(this.bigBox);
            this.bigBox = null;
            ObjectUtils.disposeObject(this.dropList);
            this.dropList = null;
            ObjectUtils.disposeObject(this.ptBitmap);
            this.ptBitmap = null;
            ObjectUtils.disposeObject(this._challengeBtn);
            this._challengeBtn = null;
            ObjectUtils.disposeObject(this._cdView);
            this._cdView = null;
            this._questInfo = null;
            this._tipData = null;
            this.smallImageRect = null;
            this.bigImageRect = null;
            this._mapSceneList = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

