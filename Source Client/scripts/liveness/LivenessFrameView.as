package liveness
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivenessEvent;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.tips.OneLineTipUseHtmlText;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class LivenessFrameView extends Frame
   {
       
      
      private var _titleImg:Bitmap;
      
      private var _bg:Bitmap;
      
      private var _livenessProgress:Bitmap;
      
      private var _livenessBg:Bitmap;
      
      private var _progressMask:Shape;
      
      private var _livenessValueDesc:FilterFrameText;
      
      private var _livenessValue:FilterFrameText;
      
      private var _bigStarMovie:MovieClip;
      
      private var _listTitle1:FilterFrameText;
      
      private var _listTitle2:FilterFrameText;
      
      private var _listTitle3:FilterFrameText;
      
      private var _listTitle4:FilterFrameText;
      
      private var _itemPanel:ScrollPanel;
      
      private var _itemVBox:VBox;
      
      private var _livenessBoxList:Vector.<LivenessBox>;
      
      private var _passCount:uint;
      
      private var _itemList:Vector.<LivenessItem>;
      
      private var _newLivenessValue:uint;
      
      private var _taskList:Array;
      
      private var _boxStatus:Vector.<Boolean>;
      
      private var _starTip:OneLineTipUseHtmlText;
      
      public function LivenessFrameView()
      {
         super();
         escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __getConsortionMessage(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Date = _loc2_.readDate();
         var _loc7_:Date = _loc2_.readDate();
         var _loc8_:Boolean = _loc2_.readBoolean();
         var _loc9_:int = _loc2_.readInt();
         var _loc10_:int = _loc2_.readInt();
         ConsortionModelControl.Instance.model.lastPublishDate = _loc6_;
         ConsortionModelControl.Instance.model.receivedQuestCount = _loc9_;
         ConsortionModelControl.Instance.model.consortiaQuestCount = _loc10_;
         PlayerManager.Instance.Self.consortiaInfo.Level = _loc3_;
         ConsortionModelControl.Instance.model.isMaster = _loc8_;
         ConsortionModelControl.Instance.model.currentTaskLevel = _loc5_;
         ConsortionModelControl.Instance.model.remainPublishTime = ConsortionModelControl.Instance.model.getLevelData(_loc3_).QuestCount - _loc4_;
         if(_loc6_.valueOf() == _loc7_.valueOf() || _loc5_ == 0 || _loc4_ == 0 || !this.checkPublishEnable() || _loc10_ >= ServerConfigManager.instance.getConsortiaTaskAcceptMax() || _loc9_ >= ConsortionModelControl.Instance.model.getLevelData(_loc3_).Count * 5)
         {
            ConsortionModelControl.Instance.model.canAcceptTask = false;
         }
         else
         {
            ConsortionModelControl.Instance.model.canAcceptTask = true;
         }
      }
      
      private function checkPublishEnable() : Boolean
      {
         var _loc1_:Date = ConsortionModelControl.Instance.model.lastPublishDate;
         var _loc2_:Date = TimeManager.Instance.Now();
         if(_loc2_.getFullYear() > _loc1_.getFullYear())
         {
            return true;
         }
         if(_loc2_.getMonth() > _loc1_.getMonth())
         {
            return true;
         }
         if(_loc2_.getDate() >= _loc1_.getDate())
         {
            return true;
         }
         return false;
      }
      
      private function __updateAcceptQuestTime(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:LivenessItem = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Date = _loc2_.readDate();
         var _loc4_:int = _loc2_.readInt();
         ConsortionModelControl.Instance.model.consortiaQuestCount = _loc4_;
         for each(_loc5_ in this._itemList)
         {
            if(_loc5_.type == LivenessModel.CONSORTION_TASK)
            {
               ConsortionModelControl.Instance.model.canAcceptTask = false;
               _loc5_.reflashBtnByTpye(false);
            }
         }
      }
      
      private function __reflashTaskItem(param1:ConsortionEvent) : void
      {
         var _loc2_:LivenessItem = null;
         for each(_loc2_ in this._itemList)
         {
            if(_loc2_.type == LivenessModel.CONSORTION_TASK)
            {
               _loc2_.reflashBtnByTpye(false);
            }
         }
      }
      
      private function __updateLivenessValue(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         if(_loc3_ >= 100)
         {
            _loc3_ = 100;
         }
         this._taskList = new Array();
         this._newLivenessValue = _loc3_;
         this.setBoxStatusList(_loc4_);
         this._taskList = _loc5_.split(",");
         this.initView();
         this.initEvent();
      }
      
      private function __updateLivenessBoxStatus(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:int = 0;
         var _loc9_:ItemTemplateInfo = null;
         var _loc2_:Array = new Array();
         var _loc3_:PackageIn = param1.pkg as PackageIn;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:int = _loc3_.readInt();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc3_.readInt();
            _loc9_ = ItemManager.Instance.getTemplateById(_loc8_);
            _loc2_.push(_loc9_);
            _loc7_++;
         }
         this.setBoxStatusList(_loc4_);
         this.setBoxStatus();
         DropGoodsManager.play(_loc2_,this.localToGlobal(new Point(this._livenessBoxList[_loc5_].x + this._livenessBoxList[_loc5_].width / 2,this._livenessBoxList[_loc5_].y)));
      }
      
      private function __oneKeyFinish(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:LivenessItem = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ >= 100)
         {
            _loc3_ = 100;
         }
         this._newLivenessValue = _loc3_;
         this._livenessValue.text = String(this._newLivenessValue);
         this.reflashProgress();
         for each(_loc4_ in this._itemList)
         {
            _loc4_.reflashTaskProgress();
         }
      }
      
      private function setBoxStatusList(param1:int) : void
      {
         this._boxStatus = new Vector.<Boolean>();
         var _loc2_:uint = 0;
         while(_loc2_ < 5)
         {
            if((param1 & 1 << _loc2_) == 0)
            {
               this._boxStatus.push(false);
            }
            else
            {
               this._boxStatus.push(true);
            }
            _loc2_++;
         }
      }
      
      private function setBoxStatus() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < 5)
         {
            if(this._boxStatus[_loc1_])
            {
               this._livenessBoxList[_loc1_].setStatus(LivenessModel.BOX_HAS_GET);
            }
            else if(this._newLivenessValue >= 20 * (_loc1_ + 1))
            {
               this._livenessBoxList[_loc1_].setStatus(LivenessModel.BOX_CAN_GET);
            }
            else
            {
               this._livenessBoxList[_loc1_].setStatus(LivenessModel.BOX_CANNOT_GET);
            }
            _loc1_++;
         }
      }
      
      private function initView() : void
      {
         var _loc1_:LivenessItem = null;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:QuestInfo = null;
         var _loc5_:LivenessItem = null;
         var _loc6_:LivenessBox = null;
         this._titleImg = ComponentFactory.Instance.creatBitmap("asset.liveness.title");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.liveness.allBg");
         this._livenessProgress = ComponentFactory.Instance.creatBitmap("asset.liveness.livenessProgress");
         this._livenessBg = ComponentFactory.Instance.creatBitmap("asset.liveness.ball");
         this._livenessValueDesc = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessValueDescTxt");
         this._livenessValue = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessValueTxt");
         this._listTitle1 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
         this._listTitle2 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
         this._listTitle3 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
         this._listTitle4 = ComponentFactory.Instance.creatComponentByStylename("liveness.listTieleTxt");
         PositionUtils.setPos(this._listTitle1,"liveness.listTitle1.pos");
         PositionUtils.setPos(this._listTitle2,"liveness.listTitle2.pos");
         PositionUtils.setPos(this._listTitle3,"liveness.listTitle3.pos");
         PositionUtils.setPos(this._listTitle4,"liveness.listTitle4.pos");
         this._itemPanel = ComponentFactory.Instance.creatComponentByStylename("liveness.listPanel");
         this._itemVBox = ComponentFactory.Instance.creatComponentByStylename("liveness.listVbox");
         this._livenessValueDesc.text = LanguageMgr.GetTranslation("ddt.liveness.livenessValueDesc.txt");
         this._livenessValue.text = String(this._newLivenessValue);
         this._listTitle1.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle1.txt");
         this._listTitle2.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle2.txt");
         this._listTitle3.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle3.txt");
         this._listTitle4.text = LanguageMgr.GetTranslation("ddt.liveness.listTitle4.txt");
         this._itemList = new Vector.<LivenessItem>();
         this._itemPanel.setView(this._itemVBox);
         if(this._taskList.length > 1)
         {
            for each(_loc3_ in this._taskList)
            {
               _loc4_ = TaskManager.instance.getQuestByID(int(_loc3_));
               if(_loc4_)
               {
                  if(_loc4_.Condition == LivenessModel.CONSORTION_TASK)
                  {
                     if(PlayerManager.Instance.Self.ConsortiaID == 0)
                     {
                        continue;
                     }
                     _loc5_ = new LivenessItem(LivenessModel.CONSORTION_TASK,_loc4_.id);
                  }
                  else if(_loc4_.Condition == 5)
                  {
                     if(_loc4_._conditions[0].param == LivenessModel.MONSTER_REFLASH)
                     {
                        if(PlayerManager.Instance.Self.ConsortiaID == 0)
                        {
                           continue;
                        }
                        _loc5_ = new LivenessItem(LivenessModel.MONSTER_REFLASH,_loc4_.id);
                     }
                     else if(_loc4_._conditions[0].param == LivenessModel.WORLD_BOSS)
                     {
                        _loc5_ = new LivenessItem(LivenessModel.WORLD_BOSS,_loc4_.id);
                     }
                     else if(_loc4_._conditions[0].param == LivenessModel.ARENA)
                     {
                        _loc5_ = new LivenessItem(LivenessModel.ARENA,_loc4_.id);
                     }
                     else
                     {
                        _loc5_ = new LivenessItem(LivenessModel.NORMAL,_loc4_.id);
                     }
                  }
                  else if(_loc4_.Condition == LivenessModel.CONSORTION_CONVOY)
                  {
                     if(PlayerManager.Instance.Self.ConsortiaID == 0)
                     {
                        continue;
                     }
                     _loc5_ = new LivenessItem(LivenessModel.CONSORTION_CONVOY,_loc4_.id);
                  }
                  else if(_loc4_.Condition == LivenessModel.SINGLE_DUNGEON)
                  {
                     _loc5_ = new LivenessItem(LivenessModel.SINGLE_DUNGEON,_loc4_.id);
                  }
                  else if(_loc4_.Condition == LivenessModel.RANDOM_PVE)
                  {
                     _loc5_ = new LivenessItem(LivenessModel.RANDOM_PVE,_loc4_.id);
                  }
                  else if(_loc4_.Condition == 8)
                  {
                     if(_loc4_._conditions[0].param == LivenessModel.RUNE)
                     {
                        _loc5_ = new LivenessItem(LivenessModel.RUNE,_loc4_.id);
                     }
                     else
                     {
                        _loc5_ = new LivenessItem(LivenessModel.NORMAL,_loc4_.id);
                     }
                  }
                  else
                  {
                     _loc5_ = new LivenessItem(LivenessModel.NORMAL,_loc4_.id);
                  }
                  this._itemList.push(_loc5_);
               }
            }
         }
         this._itemList = this._itemList.sort(this.sortLivenessItem);
         this._itemVBox.beginChanges();
         for each(_loc1_ in this._itemList)
         {
            this._itemVBox.addChild(_loc1_);
         }
         this._itemVBox.commitChanges();
         this._itemPanel.invalidateViewport();
         addToContent(this._titleImg);
         addToContent(this._bg);
         addToContent(this._listTitle1);
         addToContent(this._listTitle2);
         addToContent(this._listTitle3);
         addToContent(this._listTitle4);
         addToContent(this._itemPanel);
         addToContent(this._livenessBg);
         addToContent(this._livenessValueDesc);
         addToContent(this._livenessValue);
         this._livenessBoxList = new Vector.<LivenessBox>();
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc6_ = new LivenessBox(_loc2_);
            this._livenessBoxList.push(_loc6_);
            addToContent(_loc6_);
            _loc2_++;
         }
         this.setBoxStatus();
         this._progressMask = new Shape();
         this._progressMask.graphics.beginFill(0,0);
         this._progressMask.graphics.drawRect(0,0,1,this._livenessProgress.height);
         this._progressMask.graphics.endFill();
         this._progressMask.x = this._livenessProgress.x;
         this._progressMask.y = this._livenessProgress.y;
         addToContent(this._livenessProgress);
         addToContent(this._progressMask);
         this._livenessProgress.mask = this._progressMask;
         if(this._newLivenessValue != LivenessAwardManager.Instance.model.saveLivenessValue)
         {
            this._progressMask.width = this._livenessProgress.width * LivenessAwardManager.Instance.model.saveLivenessValue / 100;
            this.reflashProgress();
         }
         else
         {
            this._progressMask.width = this._livenessProgress.width * this._newLivenessValue / 100;
         }
      }
      
      private function reflashProgress() : void
      {
         TweenLite.to(this._progressMask,1,{
            "width":this._livenessProgress.width * this._newLivenessValue / 100,
            "onUpdate":this.checkBoxPointMovie,
            "onComplete":this.livenessMovieEnd
         });
         LivenessAwardManager.Instance.model.saveLivenessValue = this._newLivenessValue;
      }
      
      private function sortLivenessItem(param1:LivenessItem, param2:LivenessItem) : int
      {
         if(param1.info.SortLevel < 0 && param2.info.SortLevel < 0)
         {
            if(param1.info.SortLevel >= param2.info.SortLevel)
            {
               return 1;
            }
            return -1;
         }
         if(param1.info.SortLevel >= 0 && param2.info.SortLevel < 0)
         {
            return 1;
         }
         if(param1.info.SortLevel < 0 && param2.info.SortLevel >= 0)
         {
            return -1;
         }
         if(param1.info.SortLevel >= 0 && param2.info.SortLevel >= 0)
         {
            if(param1.isComplete && !param2.isComplete)
            {
               return 1;
            }
            if(!param1.isComplete && param2.isComplete)
            {
               return -1;
            }
            if(param1.info.SortLevel >= param2.info.SortLevel)
            {
               return 1;
            }
            return -1;
         }
         return 1;
      }
      
      private function initEvent() : void
      {
         LivenessAwardManager.Instance.addEventListener(LivenessEvent.TASK_DIRECT,this.__removeFrame);
         LivenessAwardManager.Instance.addEventListener(LivenessEvent.REFLASH_LIVENESS,this.__reflashLivenessFromItem);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST,this.__getConsortionMessage);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST,this.__updateAcceptQuestTime);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_QUEST_UPDATE,this.__updateLivenessValue);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_QUEST_REWARD,this.__updateLivenessBoxStatus);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM,this.__reflashTaskItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_QUEST_ONE_KEY,this.__oneKeyFinish);
         LivenessAwardManager.Instance.removeEventListener(LivenessEvent.TASK_DIRECT,this.__removeFrame);
         LivenessAwardManager.Instance.removeEventListener(LivenessEvent.REFLASH_LIVENESS,this.__reflashLivenessFromItem);
      }
      
      private function __removeFrame(param1:LivenessEvent) : void
      {
         this.dispose();
      }
      
      private function checkBoxPointMovie() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._livenessBoxList.length)
         {
            if(!LivenessAwardManager.Instance.model.pointMovieHasPlay[_loc1_])
            {
               if(this._progressMask.width >= this._livenessProgress.width * 0.2 * (_loc1_ + 1))
               {
                  if(!this._boxStatus[_loc1_])
                  {
                     this._livenessBoxList[_loc1_].setStatus(LivenessModel.BOX_CAN_GET);
                  }
                  LivenessAwardManager.Instance.model.pointMovieHasPlay[_loc1_] = true;
               }
            }
            _loc1_++;
         }
      }
      
      private function livenessMovieEnd() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._livenessBoxList.length)
         {
            if(!LivenessAwardManager.Instance.model.pointMovieHasPlay[_loc1_])
            {
               if(this._newLivenessValue >= 20 * (_loc1_ + 1))
               {
                  if(!this._boxStatus[_loc1_])
                  {
                     this._livenessBoxList[_loc1_].setStatus(LivenessModel.BOX_CAN_GET);
                  }
                  LivenessAwardManager.Instance.model.pointMovieHasPlay[_loc1_] = true;
               }
            }
            _loc1_++;
         }
      }
      
      private function __hideBigStarTips(param1:MouseEvent) : void
      {
         if(this._starTip)
         {
            this._starTip.visible = false;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.__onClose();
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LIVENESS);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LIVENESS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST,this.__getConsortionMessage);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST,this.__updateAcceptQuestTime);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_QUEST_UPDATE,this.__updateLivenessValue);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_QUEST_REWARD,this.__updateLivenessBoxStatus);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_QUEST_ONE_KEY,this.__oneKeyFinish);
            ConsortionModelControl.Instance.addEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM,this.__reflashTaskItem);
            ConsortionModel.TASK_CAN_ACCEPT_TIME = ServerConfigManager.instance.getConsortiaTaskVaildTime() * 1000;
            SocketManager.Instance.out.SendOpenConsortionCampaign();
            SocketManager.Instance.out.SendOpenLivenessFrame();
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __onClose(param1:Event = null) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         if(param1)
         {
            this.dispose();
         }
      }
      
      private function __reflashLivenessFromItem(param1:LivenessEvent) : void
      {
         this._newLivenessValue += int(param1.info);
         this._newLivenessValue = this._newLivenessValue > 100 ? uint(100) : uint(this._newLivenessValue);
         this._livenessValue.text = String(this._newLivenessValue);
         this.reflashProgress();
      }
      
      override public function dispose() : void
      {
         TweenLite.killTweensOf(this._progressMask);
         this.removeEvent();
         ObjectUtils.disposeObject(this._bigStarMovie);
         this._bigStarMovie = null;
         ObjectUtils.disposeObject(this._titleImg);
         this._titleImg = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._livenessProgress);
         this._livenessProgress = null;
         ObjectUtils.disposeObject(this._livenessBg);
         this._livenessBg = null;
         ObjectUtils.disposeObject(this._progressMask);
         this._progressMask = null;
         ObjectUtils.disposeObject(this._livenessValueDesc);
         this._livenessValueDesc = null;
         ObjectUtils.disposeObject(this._livenessValue);
         this._livenessValue = null;
         ObjectUtils.disposeObject(this._listTitle1);
         this._listTitle1 = null;
         ObjectUtils.disposeObject(this._listTitle2);
         this._listTitle2 = null;
         ObjectUtils.disposeObject(this._listTitle3);
         this._listTitle3 = null;
         ObjectUtils.disposeObject(this._listTitle4);
         this._listTitle4 = null;
         ObjectUtils.disposeObject(this._itemVBox);
         this._itemVBox = null;
         ObjectUtils.disposeObject(this._itemPanel);
         this._itemPanel = null;
         ObjectUtils.disposeObject(this._itemList);
         this._itemList = null;
         if(this._livenessBoxList)
         {
            while(this._livenessBoxList.length > 0)
            {
               ObjectUtils.disposeObject(this._livenessBoxList.shift());
            }
         }
         this._livenessBoxList = null;
         ObjectUtils.disposeObject(this._taskList);
         this._taskList = null;
         ObjectUtils.disposeObject(this._boxStatus);
         this._boxStatus = null;
         ObjectUtils.disposeObject(this._starTip);
         this._starTip = null;
         super.dispose();
      }
   }
}
