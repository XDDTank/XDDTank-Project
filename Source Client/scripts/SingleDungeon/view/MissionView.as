package SingleDungeon.view
{
   import SingleDungeon.SingleDungeonMainStateView;
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.event.CDCollingEvent;
   import SingleDungeon.event.SingleDungeonEvent;
   import SingleDungeon.expedition.ExpeditionController;
   import SingleDungeon.expedition.ExpeditionHistory;
   import SingleDungeon.expedition.ExpeditionModel;
   import SingleDungeon.hardMode.HardModeManager;
   import SingleDungeon.model.MapSceneModel;
   import SingleDungeon.model.MissionType;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Sine;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipPlace;
   import ddt.data.map.DungeonInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import org.bytearray.display.ScaleBitmap;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
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
      
      private var filterArr:Array;
      
      private var _buffInfo:BuffInfo;
      
      public function MissionView(param1:Vector.<MapSceneModel>, param2:int, param3:DisplayObject)
      {
         this.filterArr = [new GlowFilter(16777062,1,10,10,1.8)];
         super();
         this._mapSceneList = param1;
         this.info = param1[param2];
         this.ptBitmap = param3;
         this.init();
      }
      
      public function set questInfo(param1:DungeonInfo) : void
      {
         this._questInfo = param1;
      }
      
      public function get questInfo() : DungeonInfo
      {
         return this._questInfo;
      }
      
      public function set boxState(param1:int) : void
      {
         this.state = param1;
         if(param1 == SMALLBOX)
         {
            this.setSmallBox();
            if(this.info.Type == MissionType.HARDMODE)
            {
               this.showCarnet();
            }
         }
         else if(param1 == BIGBOX)
         {
            this.setBigBox();
            SoundManager.instance.play("008");
         }
         SingleDungeonManager.Instance.startBtnEnabled = true;
      }
      
      private function init() : void
      {
         this.loadMapCompleteFun = this.loadMapComplete;
         this.mapPoint = new Point(this.ptBitmap.x,this.ptBitmap.y);
         this.smallFramePoint = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.smallFramePoint");
         this.bigFramePoint = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.bigFramePoint");
         this.smallImageRect = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.smallImageRect");
         this.bigImageRect = ComponentFactory.Instance.creatCustomObject("singledungeon.mission.bigImageRect");
         this.ptBitmap.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this.ptBitmap.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this.info.addEventListener(CDCollingEvent.CD_UPDATE,this.__cdChangeHandle);
         SingleDungeonManager.Instance.addEventListener(SingleDungeonEvent.UPDATE_TIMES,this.__updateTimes);
      }
      
      private function __updateTimes(param1:SingleDungeonEvent) : void
      {
         this.showCarnet();
      }
      
      private function setSmallBox() : void
      {
         if(this.smallBox)
         {
            this.smallBox.visible = true;
            TweenLite.to(this.smallBox,0.2,{
               "alpha":1,
               "onComplete":this.onSmallTween
            });
         }
         if(this.bigBox)
         {
            TweenLite.to(this.bigBox,0.2,{
               "alpha":0,
               "onComplete":this.onSmallTween
            });
         }
         if(this.smallBox == null)
         {
            this.creatSmallBox();
         }
         if(parent is SingleDungeonMainStateView)
         {
            this.dropList = (parent as SingleDungeonMainStateView).dropList;
         }
         if(this.dropList != null)
         {
            this.dropList.dispose();
            this.dropList = null;
         }
         this.x = this.mapPoint.x - this.smallFramePoint.x;
         this.y = this.mapPoint.y - this.smallFramePoint.y;
         this.smallBox.mouseEnabled = true;
      }
      
      private function setBigBox() : void
      {
         this.isPlay = true;
         if(this.bigBox == null)
         {
            this.creatBigBox();
         }
         if(this.smallBox)
         {
            TweenLite.to(this.smallBox,0.2,{
               "alpha":0,
               "onComplete":this.onSmallTween
            });
         }
         if(this.bigBox)
         {
            TweenLite.to(this.bigBox,0.2,{
               "alpha":1,
               "x":this.bigBox.x - 50,
               "y":this.bigBox.y - 30,
               "scaleX":1.2,
               "scaleY":1.2,
               "onComplete":this.onBigTween
            });
            parent.setChildIndex((parent as SingleDungeonMainStateView).mapMask,parent.numChildren - 1);
            TweenLite.to((parent as SingleDungeonMainStateView).mapMask,0.2,{"alpha":0.5});
         }
         this.x = this.mapPoint.x - this.bigFramePoint.x;
         this.y = this.mapPoint.y - this.bigFramePoint.y;
         this.bigBox.mouseEnabled = false;
      }
      
      private function onSmallTween() : void
      {
         if(this.state == SMALLBOX)
         {
            if(this.bigBox)
            {
               this.bigBox.visible = false;
            }
         }
         else if(this.state == BIGBOX)
         {
            if(this.smallBox)
            {
               this.smallBox.visible = false;
            }
         }
      }
      
      private function onBigTween() : void
      {
         this.bigBox.visible = true;
         TweenLite.to(this.bigBox,0.2,{
            "x":this.bigBox.x + 50,
            "y":this.bigBox.y + 30,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.onTweenComplete
         });
         parent.setChildIndex(this,parent.numChildren - 1);
      }
      
      private function onTweenComplete() : void
      {
         this.isPlay = false;
      }
      
      private function creatSmallBox() : void
      {
         var _loc1_:FilterFrameText = null;
         this.smallBox = new Sprite();
         this.smallBox.buttonMode = true;
         this.smallBox.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         this.smallBox.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
         this.smallBox.addEventListener(MouseEvent.CLICK,this.__mouseClickSmallBox);
         this.getSmallMapImage(this.loadMapCompleteFun,PathManager.solveSingleDungeonSelectMisstionPath(this.info.Path + "/1.png"));
         if(this.info.Type == 2)
         {
            this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameGeen");
         }
         else if(this.info.Type == 3)
         {
            this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameRed");
         }
         else if(this.info.Type == 4)
         {
            this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameYellow");
         }
         else
         {
            this.descSmallFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.smallFrameSilver");
         }
         this.smallBox.addChild(this.descSmallFrame);
         _loc1_ = ComponentFactory.Instance.creatComponentByStylename("singledungeon.levelTxt");
         _loc1_.text = "LV:" + this.info.MinLevel + "-" + this.info.MaxLevel;
         this.smallBox.addChild(_loc1_);
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.titleTxtSmall");
         _loc2_.text = this.info.Name;
         this.smallBox.addChild(_loc2_);
         _loc2_.x = this.smallImageRect.width - _loc2_.textWidth - 5;
         _loc1_.x = this.smallImageRect.width - _loc1_.textWidth - 8;
         this.createTaskBitm();
         this.addChild(this.smallBox);
         if(this.info.Type == 3 || this.info.Type == 2 || this.info.Type == 4)
         {
            _loc2_.y -= 5;
            _loc1_.y -= 2;
         }
         if(this.info.Type == MissionType.ATTACT)
         {
            this.setEnable(false);
         }
      }
      
      private function setEnable(param1:Boolean) : void
      {
         this.smallBox.filters = !!param1 ? null : ComponentFactory.Instance.creatFilters("grayFilter");
         this.ptBitmap.filters = !!param1 ? null : ComponentFactory.Instance.creatFilters("grayFilter");
         if(param1)
         {
            if(SingleDungeonManager.Instance.CanPointClick.hasKey(this.info.ID))
            {
               SingleDungeonManager.Instance.CanPointClick[this.info.ID] = "true";
            }
            else
            {
               SingleDungeonManager.Instance.CanPointClick.add(this.info.ID,"true");
            }
            this.ptBitmap["buttonMode"] = true;
         }
         else
         {
            if(SingleDungeonManager.Instance.CanPointClick.hasKey(this.info.ID))
            {
               SingleDungeonManager.Instance.CanPointClick[this.info.ID] = "false";
            }
            else
            {
               SingleDungeonManager.Instance.CanPointClick.add(this.info.ID,"false");
            }
            this.ptBitmap["buttonMode"] = false;
         }
      }
      
      public function updatable() : void
      {
         this.createTaskBitm();
      }
      
      private function showCarnet() : void
      {
         if(this.info.ID < 200)
         {
            return;
         }
         var _loc1_:Boolean = HardModeManager.instance.checkEnter(this.info.ID);
         if(_loc1_)
         {
            if(this._ifEnterBitmap == null)
            {
               this._ifEnterBitmap = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.carnetBitm");
               this.addChild(this._ifEnterBitmap);
            }
         }
         else
         {
            ObjectUtils.disposeObject(this._ifEnterBitmap);
            this._ifEnterBitmap = null;
         }
         var _loc2_:Boolean = HardModeManager.instance.getAllowEnter(this.info.ID);
         this.setEnable(_loc2_);
      }
      
      private function createTaskBitm() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:QuestInfo = null;
         var _loc5_:QuestInfo = null;
         if(this.info.RelevanceQuest && this.info.RelevanceQuest.length > 0 && this.info.Type != MissionType.HARDMODE)
         {
            _loc1_ = this.info.RelevanceQuest.split(",");
            _loc2_ = TaskManager.instance.allCurrentQuest;
            this.info.questData.splice(0,this.info.questData.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc4_ = TaskManager.instance.getQuestByID(_loc1_[_loc3_]);
               for each(_loc5_ in _loc2_)
               {
                  if(_loc4_ == _loc5_ && !(_loc4_.isCompleted || _loc4_.isAchieved))
                  {
                     if(this.taskBitm == null)
                     {
                        this.taskBitm = ClassUtils.CreatInstance("asset.singleDungeon.smallQuestSign") as MovieClip;
                        PositionUtils.setPos(this.taskBitm,"singledungeon.taskPoint1");
                        this.smallBox.addChild(this.taskBitm);
                     }
                     this.info.questData.push(_loc4_);
                  }
               }
               _loc3_++;
            }
            if(this.info.questData.length == 0 && this.taskBitm)
            {
               ObjectUtils.disposeObject(this.taskBitm);
            }
         }
      }
      
      private function creatBigBox() : void
      {
         var _loc2_:FilterFrameText = null;
         var _loc3_:Point = null;
         this.bigBox = new Sprite();
         this.getSmallMapImage(this.loadMapCompleteFun,PathManager.solveSingleDungeonSelectMisstionPath(this.info.Path + "/1.png"));
         if(this.info.Type == 2)
         {
            this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameGeen");
         }
         else if(this.info.Type == 3)
         {
            this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameRed");
         }
         else if(this.info.Type == 4)
         {
            this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameYellow");
         }
         else
         {
            this.descBigFrame = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.bigFrameSilver");
         }
         this.bigBox.addChild(this.descBigFrame);
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("singledungeon.titleTxtBig");
         _loc1_.text = this.info.Name;
         this.bigBox.addChild(_loc1_);
         if(this.info.Type == MissionType.FIGHT || this.info.Type == MissionType.HARDMODE)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("singledungeon.needEnergyTxt");
            _loc2_.text = LanguageMgr.GetTranslation("tank.multiDungeon.needEnergy") + MapManager.getDungeonInfo(this.info.MissionID).Energy[1].toString();
            this.bigBox.addChild(_loc2_);
         }
         _loc1_.x = this.bigImageRect.width - _loc1_.textWidth - 5;
         if(this.info.Type == MissionType.EXPLORE)
         {
            this._exploreBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.exploreBtn");
            this.bigBox.addChild(this._exploreBtn);
            this._exploreBtn.addEventListener(MouseEvent.CLICK,this.startMissionClick);
         }
         else if(this.info.Type == MissionType.ATTACT)
         {
            this._attackBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.attackBtn");
            this.bigBox.addChild(this._attackBtn);
            this._attackBtn.addEventListener(MouseEvent.CLICK,this.startMissionClick);
         }
         else if(this.info.Type == MissionType.HARDMODE)
         {
            this._collectBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.collectBtn");
            this.bigBox.addChild(this._collectBtn);
            this._collectBtn.addEventListener(MouseEvent.CLICK,this.startMissionClick);
         }
         else
         {
            this._challengeBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.challengeBtn");
            this._expeditionBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.expeditionBtn");
            this.bigBox.addChild(this._challengeBtn);
            this.bigBox.addChild(this._expeditionBtn);
            this._expeditionBtn.addEventListener(MouseEvent.CLICK,this.__expeditionClick);
            this._challengeBtn.addEventListener(MouseEvent.CLICK,this.startMissionClick);
            this.checkExpedition();
         }
         if(this.taskBitm != null)
         {
            this.taskBigBitm = ClassUtils.CreatInstance("asset.singleDungeon.bigQuestSign") as MovieClip;
            _loc3_ = ComponentFactory.Instance.creatCustomObject("singledungeon.taskPoint2") as Point;
            this.taskBigBitm.x = _loc3_.x;
            this.taskBigBitm.y = _loc3_.y;
            this.bigBox.addChild(this.taskBigBitm);
         }
         this._lookDropBtn = ComponentFactory.Instance.creatComponentByStylename("singledungeon.lookDropBtn");
         this.bigBox.addChild(this._lookDropBtn);
         this._lookDropBtn.addEventListener(MouseEvent.CLICK,this._lookDropBtnClick);
         this.bigBox.filters = [new GlowFilter(16777062,1,10,10,1.8)];
         this.addChild(this.bigBox);
         this.bigBox.alpha = 0;
         parent.setChildIndex((parent as SingleDungeonMainStateView).mapMask,parent.numChildren - 1);
         parent.setChildIndex(this,parent.numChildren - 1);
      }
      
      private function checkExpedition() : void
      {
         if(ExpeditionController.instance.model.expeditionInfoDic[this.info.ID] && ExpeditionHistory.instance.get(this.info.MissionID) && PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.getExpeditionLimitLevel())
         {
            this._expeditionBtn.enable = true;
         }
         else
         {
            this._expeditionBtn.enable = false;
         }
      }
      
      private function loadMapComplete(param1:LoaderEvent) : void
      {
         var _loc2_:ScaleBitmapImage = null;
         if(param1.loader.isSuccess)
         {
            _loc2_ = new ScaleBitmapImage();
            _loc2_.buttonMode = true;
            _loc2_.resource = (param1.loader as BitmapLoader).bitmapData;
            (_loc2_.display as ScaleBitmap).smoothing = true;
            if(_loc2_ && this.smallBox && this.state == SMALLBOX)
            {
               _loc2_.x = this.smallImageRect.x;
               _loc2_.y = this.smallImageRect.y;
               _loc2_.width = this.smallImageRect.width;
               _loc2_.height = this.smallImageRect.height;
               this.smallBox.addChildAt(_loc2_,0);
            }
            else if(_loc2_ && this.bigBox && this.state == BIGBOX)
            {
               _loc2_.x = this.bigImageRect.x;
               _loc2_.y = this.bigImageRect.y;
               _loc2_.width = this.bigImageRect.width;
               _loc2_.height = this.bigImageRect.height;
               this.bigBox.addChildAt(_loc2_,0);
            }
            ShowTipManager.Instance.addTip(_loc2_);
            _loc2_.tipDirctions = "1,2,4,5,0,3,6,7";
            _loc2_.tipData = this.info;
            _loc2_.tipStyle = "singledungeon.mapTip";
            _loc2_.filterString = "null,lightFilter,lightFilter,null";
         }
      }
      
      private function __expeditionClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.isPlay)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Fatigue >= 0)
         {
            ExpeditionController.instance.model.currentMapId = this.info.ID;
            ExpeditionController.instance.show(ExpeditionModel.NORMAL_MODE);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.frame.noFatigue"));
         }
      }
      
      private function startMissionClick(param1:MouseEvent) : void
      {
         var _loc2_:MapSceneModel = null;
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         MainToolBar.Instance.setReturnEnable(false);
         if(this.isPlay)
         {
            return;
         }
         if(this.info.Type != MapSceneModel.WALKSCENE && !PlayerManager.Instance.Self.Bag.getItemAt(EquipPlace.WEAPON))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"),0,true);
            MainToolBar.Instance.setReturnEnable(true);
            return;
         }
         if(this.info.Type == MissionType.ATTACT)
         {
            SingleDungeonManager.Instance.isNowBossFight = true;
         }
         if(this.info.Type == MissionType.HARDMODE && HardModeManager.instance.getRemainFightCount(this.info.ID) == 0)
         {
            MainToolBar.Instance.setReturnEnable(true);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.missionView.count"),0,true);
            return;
         }
         SingleDungeonManager.Instance.currentFightType = this.info.Type;
         if(SingleDungeonManager.Instance.startBtnEnabled)
         {
            this._changedMapId = -1;
            this.checkChangeMapID();
            SingleDungeonManager.Instance.startBtnEnabled = false;
            if(this._changedMapId > 0)
            {
               _loc3_ = 0;
               while(_loc3_ < this._mapSceneList.length)
               {
                  if(this._mapSceneList[_loc3_].ID == this._changedMapId)
                  {
                     _loc2_ = this._mapSceneList[_loc3_];
                     break;
                  }
                  _loc3_++;
               }
               SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel = _loc2_;
               SingleDungeonManager.Instance.currentMapId = this._changedMapId;
               SocketManager.Instance.out.sendEnterWalkScene(this._changedMapId);
            }
            else
            {
               SingleDungeonManager.Instance._singleDungeonWalkMapModel._mapSceneModel = this.info;
               SingleDungeonManager.Instance.currentMapId = this.info.ID;
               SocketManager.Instance.out.sendEnterWalkScene(this.info.ID);
            }
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.SINGLE_DUNGEON_MISSION))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.SINGLE_DUNGEON_MISSION);
         }
         setTimeout(this.ReturnBtnShow,1000);
      }
      
      private function ReturnBtnShow() : void
      {
         MainToolBar.Instance.setReturnEnable(true);
      }
      
      private function checkChangeMapID() : void
      {
         if(this.info.ID == 11)
         {
            if(SavePointManager.Instance.isInSavePoint(4))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1011;
               }
               else
               {
                  this._changedMapId = 2011;
               }
            }
         }
         if(this.info.ID == 5)
         {
            if(SavePointManager.Instance.isInSavePoint(6))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1005;
               }
               else
               {
                  this._changedMapId = 2005;
               }
            }
         }
         if(this.info.ID == 6)
         {
            if(SavePointManager.Instance.isInSavePoint(8))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1006;
               }
               else
               {
                  this._changedMapId = 2006;
               }
            }
         }
         if(this.info.ID == 7)
         {
            if(SavePointManager.Instance.isInSavePoint(12))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1007;
               }
               else
               {
                  this._changedMapId = 2007;
               }
            }
         }
         if(this.info.ID == 8)
         {
            if(SavePointManager.Instance.isInSavePoint(19))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1008;
               }
               else
               {
                  this._changedMapId = 2008;
               }
            }
         }
         if(this.info.ID == 9)
         {
            if(SavePointManager.Instance.isInSavePoint(23))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1009;
               }
               else
               {
                  this._changedMapId = 2009;
               }
            }
         }
         if(this.info.ID == 10)
         {
            if(SavePointManager.Instance.isInSavePoint(25))
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  this._changedMapId = 1010;
               }
               else
               {
                  this._changedMapId = 2010;
               }
            }
            if(SavePointManager.Instance.isInSavePoint(27))
            {
               this._changedMapId = 2012;
            }
         }
      }
      
      private function _lookDropBtnClick(param1:MouseEvent) : void
      {
         var tween1:TweenLite = null;
         var tween2:TweenLite = null;
         var evt:MouseEvent = param1;
         if(this.isPlay)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this.dropList == null)
         {
            this.dropList = ComponentFactory.Instance.creatComponentByStylename("DropList");
            this.dropList.updateList(this.info.MissionID);
            this.dropList.y += this.y;
            this.dropList.x += this.x;
            if(this.info.Type == 2 || this.info.Type == 3)
            {
               this.dropList.x += 4;
            }
            parent.addChildAt(this.dropList,parent.getChildIndex(this));
            tween1 = TweenLite.to(this.dropList,0.5,{
               "y":this.dropList.y + 124,
               "ease":Back.easeOut
            });
         }
         else
         {
            tween2 = TweenLite.to(this.dropList,0.5,{
               "y":this.y + 10,
               "ease":Sine.easeOut,
               "onComplete":function():void
               {
                  if(dropList)
                  {
                     dropList.dispose();
                  }
                  dropList = null;
                  if(tween1)
                  {
                     tween1.kill();
                  }
                  if(tween2)
                  {
                     tween2.kill();
                  }
               }
            });
         }
         (parent as SingleDungeonMainStateView).dropList = this.dropList;
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         if(this._cdView && this.contains(this._cdView))
         {
            return;
         }
         if(this.info.Type == MissionType.HARDMODE && !HardModeManager.instance.getAllowEnter(this.info.ID))
         {
            return;
         }
         if(this.checkFilters())
         {
            this.smallBox.filters = this.filterArr;
            this.ptBitmap.filters = this.filterArr;
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._cdView && this.contains(this._cdView))
         {
            return;
         }
         if(this.info.Type == MissionType.HARDMODE && !HardModeManager.instance.getAllowEnter(this.info.ID))
         {
            return;
         }
         if(this.checkFilters())
         {
            this.smallBox.filters = null;
            this.ptBitmap.filters = null;
         }
      }
      
      private function checkFilters() : Boolean
      {
         if(this.info.Type == MissionType.ATTACT)
         {
            if(this.info.cdColling == 0 && this.info.count + this.miningCount() != 0)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      private function __mouseClickSmallBox(param1:MouseEvent) : void
      {
         if(this.info.Type == MissionType.ATTACT && this.info.count + this.miningCount() == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.missionView.count"));
         }
         else if(this.info.cdColling > 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.missionView.CDing"));
         }
         else if(this.info.Type == MissionType.HARDMODE && !HardModeManager.instance.getAllowEnter(this.info.ID))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.selectMode.hadPassed"),0,true);
         }
         else
         {
            dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.CLICK_MISSION_VIEW));
         }
      }
      
      private function __cdChangeHandle(param1:CDCollingEvent) : void
      {
         if(this.info.count + this.miningCount() == 0)
         {
            this.setEnable(false);
         }
         else if(this.info.cdColling != 0)
         {
            if(!this._cdView)
            {
               this._cdView = new CDView(this.info);
               this.addChild(this._cdView);
               this._cdView.x = this.smallBox.x + 3;
               this._cdView.y = this.smallBox.y - 14;
               this._cdView.showCD();
               this.setEnable(false);
            }
         }
         else if(this.info.cdColling == 0)
         {
            this.setEnable(true);
            ObjectUtils.disposeObject(this._cdView);
            this._cdView = null;
         }
      }
      
      private function miningCount() : int
      {
         if(!PlayerManager.Instance.Self.consortionStatus)
         {
            return 0;
         }
         if(this.info.Type == MissionType.ATTACT)
         {
            this._buffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_SIRIKE_COPY_COUNT];
         }
         if(this._buffInfo == null)
         {
            return 0;
         }
         return this._buffInfo.ValidCount;
      }
      
      private function removeEvent() : void
      {
         if(this._challengeBtn)
         {
            this._challengeBtn.removeEventListener(MouseEvent.CLICK,this.startMissionClick);
         }
         if(this._expeditionBtn)
         {
            this._expeditionBtn.removeEventListener(MouseEvent.CLICK,this.__expeditionClick);
         }
         if(this._exploreBtn)
         {
            this._exploreBtn.removeEventListener(MouseEvent.CLICK,this.startMissionClick);
         }
         if(this._lookDropBtn)
         {
            this._lookDropBtn.removeEventListener(MouseEvent.CLICK,this._lookDropBtnClick);
         }
         if(this.smallBox)
         {
            this.smallBox.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
            this.smallBox.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
            this.smallBox.removeEventListener(MouseEvent.CLICK,this.__mouseClickSmallBox);
            this.info.removeEventListener(CDCollingEvent.CD_UPDATE,this.__cdChangeHandle);
         }
         SingleDungeonManager.Instance.removeEventListener(SingleDungeonEvent.UPDATE_TIMES,this.__updateTimes);
      }
      
      private function getSmallMapImage(param1:Function, param2:String) : void
      {
         var _loc3_:BaseLoader = LoadResourceManager.instance.createLoader(param2,BaseLoader.BITMAP_LOADER);
         _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__smallMapComplete);
         LoadResourceManager.instance.startLoad(_loc3_);
      }
      
      private function __smallMapComplete(param1:LoaderEvent) : void
      {
         param1.target.removeEventListener(LoaderEvent.COMPLETE,this.__smallMapComplete);
         if(this.loadMapCompleteFun != null)
         {
            this.loadMapCompleteFun(param1);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.loadMapCompleteFun = null;
         while(this.info && this.info.questData.length > 0)
         {
            this.info.questData.pop();
         }
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
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
