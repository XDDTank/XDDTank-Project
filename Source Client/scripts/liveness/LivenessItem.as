package liveness
{
   import arena.ArenaManager;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.FilterFrameTextWithTips;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.consortionTask.ConsortionTaskViewFrame;
   import consortion.managers.ConsortionMonsterManager;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivenessEvent;
   import ddt.events.TaskEvent;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskDirectorManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   import worldboss.WorldBossAwardController;
   import worldboss.WorldBossManager;
   
   public class LivenessItem extends Sprite implements Disposeable
   {
       
      
      private var _type:int;
      
      private var _questId:int;
      
      private var _joinBtn:TextButton;
      
      private var _line:MovieClip;
      
      private var _info:QuestInfo;
      
      private var _title:FilterFrameTextWithTips;
      
      private var _progress:FilterFrameText;
      
      private var _descript:FilterFrameText;
      
      private var _award:FilterFrameTextWithTips;
      
      private var _quickDoneBtn:BaseButton;
      
      private var _taskLiveness:FilterFrameText;
      
      private var _isMaster:Boolean;
      
      private var _chooseLevelView:ConsortionTaskViewFrame;
      
      private var _completeImage:Bitmap;
      
      private var _consortionTaskList:Array;
      
      private var _isComplete:Boolean;
      
      private var _exclamatory:Bitmap;
      
      private var _itemShine:MovieClip;
      
      private var _helpBtn:BaseButton;
      
      private var _helpFrame:LivenessHelpFrame;
      
      private var _getRewardBtn:TextButton;
      
      private var _livenessStartPoint:Point;
      
      private var _pointMovie:MovieClip;
      
      private var _pointEndMovie:MovieClip;
      
      private var _expeditionAlert:BaseAlerFrame;
      
      public function LivenessItem(param1:int, param2:int)
      {
         super();
         this._type = param1;
         this._questId = param2;
         this.initView();
         this.initEvent();
         this.init();
      }
      
      private function initView() : void
      {
         this._line = ComponentFactory.Instance.creat("asset.liveness.item.line");
         this._title = ComponentFactory.Instance.creatComponentByStylename("liveness.taskTitleTips");
         this._progress = ComponentFactory.Instance.creatComponentByStylename("liveness.taskProgress");
         this._award = ComponentFactory.Instance.creatComponentByStylename("liveness.taskAwardTips");
         this._taskLiveness = ComponentFactory.Instance.creatComponentByStylename("liveness.taskLiveness");
         this._descript = ComponentFactory.Instance.creatComponentByStylename("liveness.taskDescript");
         this._quickDoneBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.quickDoneBtn");
         this._exclamatory = ComponentFactory.Instance.creatBitmap("asset.liveness.exclamatory");
         this._itemShine = ComponentFactory.Instance.creat("asset.liveness.itemShine") as MovieClip;
         PositionUtils.setPos(this._itemShine,"liveness.livenessItem.shine.pos");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.helpBtn");
         this._helpBtn.tipData = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         this._helpFrame = ComponentFactory.Instance.creat("liveness.frame.LivenessHelpFrame");
         this._completeImage = ComponentFactory.Instance.creatBitmap("asset.liveness.completeImage");
         this._getRewardBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.getRewardBtn");
         this._getRewardBtn.text = LanguageMgr.GetTranslation("ddt.livenessFrame.getRewardBtn.txt");
         if(this._type == LivenessModel.CONSORTION_TASK)
         {
            this._isMaster = ConsortionModelControl.Instance.model.isMaster;
            if(ConsortionModelControl.Instance.model.canAcceptTask)
            {
               this.createMemberBtn();
            }
            else if(this._isMaster && ConsortionModelControl.Instance.model.remainPublishTime > 0)
            {
               this.createMasterBtn();
            }
            else
            {
               this.createMemberBtn();
            }
            this._quickDoneBtn.visible = false;
            this.addTitleTips();
         }
         else
         {
            this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.joinBtn");
            this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
            if(this._type == LivenessModel.ARENA)
            {
               if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getArenaOpenLevel())
               {
                  this.setBtnEnable(false);
               }
            }
            if(this._type == LivenessModel.MONSTER_REFLASH)
            {
               if(!ConsortionMonsterManager.Instance.ActiveState)
               {
                  this.setBtnEnable(false);
               }
            }
            if(this._type == LivenessModel.ARENA)
            {
               if(!ArenaManager.instance.open)
               {
                  this.setBtnEnable(false);
               }
            }
         }
         PositionUtils.setPos(this._line,"liveness.livenessItem.line.pos");
         addChild(this._line);
         addChild(this._itemShine);
         addChild(this._title);
         addChild(this._exclamatory);
         addChild(this._progress);
         addChild(this._award);
         addChild(this._taskLiveness);
         addChild(this._descript);
         addChild(this._joinBtn);
         addChild(this._getRewardBtn);
         addChild(this._helpBtn);
         addChild(this._quickDoneBtn);
         addChild(this._completeImage);
      }
      
      private function initEvent() : void
      {
         this._joinBtn.addEventListener(MouseEvent.CLICK,this.__clickItem);
         this._quickDoneBtn.addEventListener(MouseEvent.CLICK,this.__clickOneKey);
         if(this._type == LivenessModel.SINGLE_DUNGEON)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RANDOM_SCENE,this.__enterRandomSingleDungeon);
         }
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__clickHelp);
         this._helpFrame.addEventListener(Event.COMPLETE,this.__clickItem);
         this._getRewardBtn.addEventListener(MouseEvent.CLICK,this.__clickGetReward);
         TaskManager.instance.addEventListener(TaskEvent.FINISH,this.__onTaskFinished);
      }
      
      private function removeEvent() : void
      {
         this._joinBtn.removeEventListener(MouseEvent.CLICK,this.__clickItem);
         this._quickDoneBtn.removeEventListener(MouseEvent.CLICK,this.__clickOneKey);
         if(this._type == LivenessModel.SINGLE_DUNGEON)
         {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.RANDOM_SCENE,this.__enterRandomSingleDungeon);
         }
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__clickHelp);
         this._helpFrame.removeEventListener(Event.COMPLETE,this.__clickItem);
         this._getRewardBtn.removeEventListener(MouseEvent.CLICK,this.__clickGetReward);
         TaskManager.instance.removeEventListener(TaskEvent.FINISH,this.__onTaskFinished);
         if(this._pointEndMovie)
         {
            this._pointEndMovie.removeEventListener(Event.COMPLETE,this.__removePointEndMovie);
         }
         if(this._pointMovie)
         {
            this._pointMovie.removeEventListener(Event.COMPLETE,this.__pointBeginMove);
         }
      }
      
      private function init() : void
      {
         var _loc1_:String = null;
         this._info = TaskManager.instance.getQuestByID(this._questId);
         this._title.text = this._info.Title;
         this._award.text = this._info.Objective;
         this._descript.text = this._info.Detail;
         this.addRewardTips();
         this._quickDoneBtn.tipData = LanguageMgr.GetTranslation("ddt.liveness.quickDone.tip.txt",this._info.OneKeyFinishNeedMoney);
         this._taskLiveness.text = String(this._info.RewardDailyActivity);
         this._exclamatory.visible = false;
         this._itemShine.visible = false;
         this._helpBtn.visible = false;
         this._completeImage.visible = false;
         this._getRewardBtn.visible = false;
         this._exclamatory.x = this._title.x + this._title.textWidth + 7;
         if(this._type != LivenessModel.CONSORTION_TASK)
         {
            _loc1_ = "";
            _loc1_ += this._info._conditions[0].description;
            this._title.tipData = _loc1_;
            if(this._info.OneKeyFinishNeedMoney > 0)
            {
               this._quickDoneBtn.visible = true;
            }
            else
            {
               this._quickDoneBtn.visible = false;
            }
            if(this._type == LivenessModel.WORLD_BOSS && WorldBossManager.Instance.isOpen)
            {
               this._itemShine.visible = true;
            }
            if(this._type == LivenessModel.MONSTER_REFLASH)
            {
               this._helpBtn.visible = true;
               if(ConsortionMonsterManager.Instance.ActiveState)
               {
                  this._itemShine.visible = true;
               }
            }
            if(this._type == LivenessModel.ARENA)
            {
               this._helpBtn.visible = true;
               if(ArenaManager.instance.open)
               {
                  this._itemShine.visible = true;
               }
            }
            if(this._type == LivenessModel.CONSORTION_CONVOY)
            {
               this._helpBtn.visible = true;
            }
         }
         else
         {
            this.checkBtnEnable();
         }
         this.reflashTaskProgress();
      }
      
      private function addTitleTips() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         this._consortionTaskList = TaskManager.instance.getAvailableQuests(5).list;
         if(this._consortionTaskList.length > 0)
         {
            _loc1_ = "";
            _loc2_ = 0;
            while(_loc2_ < this._consortionTaskList.length)
            {
               _loc1_ += this._consortionTaskList[_loc2_]._conditions[0].description;
               if(this._consortionTaskList[_loc2_]._conditions[0].param2 == 200)
               {
                  _loc1_ += "(0/1)";
               }
               else
               {
                  _loc1_ += "(" + (this._consortionTaskList[_loc2_]._conditions[0].param2 - this._consortionTaskList[_loc2_].data.progress[0]) + "/" + this._consortionTaskList[_loc2_]._conditions[0].param2 + ")";
               }
               if(this._consortionTaskList.length > 1 && _loc2_ < this._consortionTaskList.length - 1)
               {
                  _loc1_ += "\n";
               }
               _loc2_++;
            }
            this._title.tipData = _loc1_;
         }
         else
         {
            this._title.tipData = null;
         }
      }
      
      private function addRewardTips() : void
      {
         var _loc2_:QuestItemReward = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc1_:String = "";
         if(this._type == LivenessModel.CONSORTION_TASK)
         {
            if(this._consortionTaskList.length > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text") + " " + this._consortionTaskList[0].RewardOffer * this._info._conditions[0].param2 + "\n";
               _loc1_ += LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.Exp.text") + " " + this._consortionTaskList[0].RewardConsortiaGP * this._info._conditions[0].param2 + "\n";
            }
         }
         else
         {
            if(this._info.RewardGP > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("exp") + " " + this._info.RewardGP + "\n";
            }
            if(this._info.RewardGold > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("tank.hotSpring.gold") + " " + this._info.RewardGold + "\n";
            }
            if(this._info.RewardBindMoney > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("gift") + " " + this._info.RewardBindMoney + "\n";
            }
            if(this._info.RewardHonor > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("ddt.quest.Honor") + " " + this._info.RewardHonor + "\n";
            }
            if(this._info.RewardMagicSoul > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("magicSoul") + " " + this._info.RewardMagicSoul + "\n";
            }
            if(this._info.RewardConsortiaRiches > 0)
            {
               _loc1_ += LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text") + " " + this._info.RewardConsortiaRiches + "\n";
            }
            if(this._info.itemRewards && this._info.itemRewards.length > 0)
            {
               for each(_loc2_ in this._info.itemRewards)
               {
                  _loc3_ = new InventoryItemInfo();
                  _loc3_.TemplateID = _loc2_.itemID;
                  ItemManager.fill(_loc3_);
                  _loc1_ += _loc3_.Name + " " + _loc2_.count[0] + "\n";
               }
            }
         }
         if(_loc1_ != "")
         {
            _loc1_ = _loc1_.substr(0,_loc1_.length - 1);
            this._award.tipData = LanguageMgr.GetTranslation("ddt.liveness.reward.tips.txt",_loc1_);
         }
         else
         {
            this._award.tipData = null;
         }
      }
      
      public function reflashBtnByTpye(param1:Boolean) : void
      {
         if(this._type != LivenessModel.CONSORTION_TASK)
         {
            return;
         }
         removeChild(this._joinBtn);
         this._joinBtn = null;
         if(param1)
         {
            this.createMasterBtn();
         }
         else
         {
            this.createMemberBtn();
            if(this._chooseLevelView)
            {
               if(this._chooseLevelView.parent)
               {
                  this._chooseLevelView.dispose();
               }
            }
            this.addTitleTips();
            this.addRewardTips();
            if(TaskManager.instance.getAvailableQuests(5).list.length > 0)
            {
               this._exclamatory.visible = true;
            }
         }
         addChild(this._joinBtn);
         this.checkBtnEnable();
         this._joinBtn.addEventListener(MouseEvent.CLICK,this.__clickItem);
      }
      
      private function createMasterBtn() : void
      {
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.publishBtn");
         this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.publishBtn.text");
      }
      
      private function createMemberBtn() : void
      {
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("liveness.getTaskBtn");
         this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.getMissionBtn.text");
      }
      
      private function __clickItem(param1:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._type)
         {
            case LivenessModel.CONSORTION_TASK:
               if(ConsortionModelControl.Instance.model.canAcceptTask)
               {
                  SocketManager.Instance.out.sendRequestConsortionQuest(ConsortionModelControl.Instance.model.currentTaskLevel);
               }
               else if(this._isMaster)
               {
                  if(PlayerManager.Instance.Self.bagPwdState)
                  {
                     if(PlayerManager.Instance.Self.bagLocked)
                     {
                        BaglockedManager.Instance.show();
                        return;
                     }
                     this.showQuestChooseFrame();
                  }
                  else
                  {
                     this.showQuestChooseFrame();
                  }
               }
               break;
            case LivenessModel.WORLD_BOSS:
               if(WorldBossManager.Instance.isOpen)
               {
                  if(PlayerManager.Instance.checkExpedition())
                  {
                     this.showExpeditionAlert();
                  }
                  else
                  {
                     SocketManager.Instance.out.enterWorldBossRoom();
                  }
               }
               else if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.getWorldBossMinEnterLevel())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.minenterlevel",ServerConfigManager.instance.getWorldBossMinEnterLevel()));
               }
               else
               {
                  WorldBossManager.Instance.showWorldBossAward(WorldBossAwardController.Instance.setup,UIModuleTypes.WORLDBOSS_MAP);
               }
               break;
            case LivenessModel.CONSORTION_CONVOY:
               SocketManager.Instance.out.SendenterConsortionTransport();
               break;
            case LivenessModel.MONSTER_REFLASH:
               if(PlayerManager.Instance.checkExpedition())
               {
                  this.showExpeditionAlert();
               }
               else
               {
                  SocketManager.Instance.out.SendenterConsortion(true);
               }
               break;
            case LivenessModel.NORMAL:
            case LivenessModel.RUNE:
               TaskDirectorManager.instance.beginGuild(this._info);
               LivenessAwardManager.Instance.dispatchEvent(new LivenessEvent(LivenessEvent.TASK_DIRECT));
               break;
            case LivenessModel.SINGLE_DUNGEON:
               SocketManager.Instance.out.sendEnterRandomScene(this._info.id);
               break;
            case LivenessModel.RANDOM_PVE:
               if(PlayerManager.Instance.checkExpedition())
               {
                  this.showExpeditionAlert();
               }
               else
               {
                  SocketManager.Instance.out.sendEnterRandomPve();
               }
               break;
            case LivenessModel.ARENA:
               if(PlayerManager.Instance.checkExpedition())
               {
                  this.showExpeditionAlert();
               }
               else
               {
                  ArenaManager.instance.enter();
               }
         }
      }
      
      private function showExpeditionAlert() : void
      {
         this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         this._expeditionAlert.moveEnable = false;
         this._expeditionAlert.addEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
      }
      
      private function checkEnterByTpye() : void
      {
         switch(this._type)
         {
            case LivenessModel.WORLD_BOSS:
               if(WorldBossManager.Instance.isOpen)
               {
                  SocketManager.Instance.out.enterWorldBossRoom();
               }
               break;
            case LivenessModel.MONSTER_REFLASH:
               if(ConsortionMonsterManager.Instance.ActiveState)
               {
                  SocketManager.Instance.out.SendenterConsortion(true);
               }
               break;
            case LivenessModel.ARENA:
               if(ArenaManager.instance.open)
               {
                  ArenaManager.instance.enter();
               }
               break;
            case LivenessModel.RANDOM_PVE:
               SocketManager.Instance.out.sendEnterRandomPve();
         }
      }
      
      private function __expeditionConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            this.checkEnterByTpye();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __clickOneKey(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.liveness.oneKeyFinish.tips.txt",this._info.OneKeyFinishNeedMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.totalMoney < this._info.OneKeyFinishNeedMoney)
            {
               ObjectUtils.disposeObject(_loc2_);
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.SendGetDailyQuestOneKey(this._info.id);
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      public function setBtnEnable(param1:Boolean = true) : void
      {
         this._joinBtn.enable = param1;
         if(param1)
         {
            this._joinBtn.filters = null;
         }
         else
         {
            this._joinBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function checkBtnEnable() : void
      {
         if(!ConsortionModelControl.Instance.model.canAcceptTask)
         {
            if(!this._isMaster && ConsortionModelControl.Instance.model.currentTaskLevel == 0 || ConsortionModelControl.Instance.model.consortiaQuestCount >= ServerConfigManager.instance.getConsortiaTaskAcceptMax() && ConsortionModelControl.Instance.model.remainPublishTime == 0 || ConsortionModelControl.Instance.model.remainPublishTime == 0 && this._isMaster && ConsortionModelControl.Instance.model.currentTaskLevel != 0 || ConsortionModelControl.Instance.model.receivedQuestCount >= ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Count * 5)
            {
               this.setBtnEnable(false);
               if(TaskManager.instance.getAvailableQuests(5).list.length == 0 && ConsortionModelControl.Instance.model.currentTaskLevel != 0)
               {
                  this._completeImage.visible = true;
               }
               else
               {
                  this._completeImage.visible = false;
               }
            }
         }
      }
      
      public function reflashTaskProgress() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._consortionTaskList = TaskManager.instance.getAvailableQuests(5).list;
         _loc1_ = this._info._conditions[0].param2;
         if(this._type == LivenessModel.CONSORTION_TASK)
         {
            if(ConsortionModelControl.Instance.model.consortiaQuestCount == 0)
            {
               _loc2_ = 0;
               this._progress.text = "0/" + this._info._conditions[0].param2;
            }
            else if(this._consortionTaskList.length == 0)
            {
               _loc2_ = this._info._conditions[0].param2;
               this._exclamatory.visible = false;
               this._progress.text = this._info._conditions[0].param2 + "/" + this._info._conditions[0].param2;
            }
            else
            {
               _loc2_ = this._info._conditions[0].param2 - this._consortionTaskList.length;
               this._exclamatory.visible = true;
               this._progress.text = this._info._conditions[0].param2 - this._consortionTaskList.length + "/" + this._info._conditions[0].param2;
            }
         }
         else
         {
            if(this._info.data)
            {
               if(this._info.data.progress[0] < 0)
               {
                  _loc2_ = _loc1_;
               }
               else
               {
                  _loc2_ = _loc1_ - this._info.data.progress[0];
                  if(this._info.data.isAchieved)
                  {
                     _loc2_ = _loc1_;
                  }
               }
            }
            else
            {
               _loc2_ = _loc1_;
            }
            this._progress.text = _loc2_ + "/" + _loc1_;
         }
         if(_loc2_ == _loc1_)
         {
            this._isComplete = true;
            this._exclamatory.visible = false;
            if(this._info.OneKeyFinishNeedMoney > 0)
            {
               this._quickDoneBtn.visible = false;
            }
            if(!this._info.data || this._info.isAchieved)
            {
               this._completeImage.visible = true;
               this._joinBtn.visible = true;
               this._getRewardBtn.visible = false;
               if(this._type != LivenessModel.ARENA && this._type != LivenessModel.MONSTER_REFLASH && this._type != LivenessModel.CONSORTION_CONVOY && this._type != LivenessModel.WORLD_BOSS)
               {
                  this.setBtnEnable(false);
               }
            }
            else
            {
               this._joinBtn.visible = false;
               this._getRewardBtn.visible = true;
            }
         }
         else
         {
            if(this._type == LivenessModel.SINGLE_DUNGEON)
            {
               this._exclamatory.visible = true;
            }
            this._isComplete = false;
         }
      }
      
      private function showQuestChooseFrame() : void
      {
         this._chooseLevelView = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionTaskViewFrame");
         this._chooseLevelView.show();
      }
      
      private function __enterRandomSingleDungeon(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         LivenessAwardManager.Instance.currentSingleDungeonId = _loc3_;
         TaskDirectorManager.instance.beginGuild(this._info);
      }
      
      private function __clickHelp(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         SoundManager.instance.play("008");
         var _loc3_:String = "liveness.livenessItem.helpText.pos";
         if(this._type == LivenessModel.MONSTER_REFLASH)
         {
            _loc2_ = "asset.liveness.monsterHelp";
         }
         if(this._type == LivenessModel.ARENA)
         {
            _loc2_ = "asset.liveness.arenaHelp";
         }
         if(this._type == LivenessModel.CONSORTION_CONVOY)
         {
            _loc2_ = "asset.liveness.transportHelp";
         }
         this._helpFrame.setView(ComponentFactory.Instance.creat(_loc2_),_loc3_);
         this._helpFrame.btnEnable = this._joinBtn.enable;
         this._helpFrame.show();
      }
      
      private function __clickGetReward(param1:MouseEvent) : void
      {
         TaskManager.instance.sendQuestFinish(this._info.QuestID);
      }
      
      private function __onTaskFinished(param1:TaskEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestItemReward = null;
         var _loc4_:ItemTemplateInfo = null;
         var _loc5_:ItemTemplateInfo = null;
         if(param1.type == "finish" && param1.info.QuestID == this._info.QuestID)
         {
            this.reflashTaskProgress();
            _loc2_ = new Array();
            for each(_loc3_ in param1.info.itemRewards)
            {
               if(_loc3_)
               {
                  _loc4_ = ItemManager.Instance.getTemplateById(_loc3_.itemID);
                  _loc2_.push(_loc4_);
               }
            }
            if(param1.info.RewardGold > 0)
            {
               _loc5_ = ItemManager.Instance.getTemplateById(EquipType.GOLD);
               _loc2_.push(_loc5_);
            }
            DropGoodsManager.play(_loc2_,this.localToGlobal(new Point(this._joinBtn.x - 30,this._joinBtn.y)));
            this._pointMovie = ComponentFactory.Instance.creat("asset.liveness.pointFly");
            this._pointMovie.addEventListener(Event.COMPLETE,this.__pointBeginMove);
            this._livenessStartPoint = this.localToGlobal(new Point(this._taskLiveness.x + 5,this._taskLiveness.y + 5));
            this._pointMovie.x = this._livenessStartPoint.x;
            this._pointMovie.y = this._livenessStartPoint.y;
            LayerManager.Instance.addToLayer(this._pointMovie,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      private function __pointBeginMove(param1:Event) : void
      {
         this._pointMovie.removeEventListener(Event.COMPLETE,this.__pointBeginMove);
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("liveness.livenessItem.livenessEndPoint.pos") as Point;
         var _loc3_:Number = Math.atan((this._livenessStartPoint.x - _loc2_.x) / (this._livenessStartPoint.y - _loc2_.y)) * (-180 / Math.PI);
         this._pointMovie.alpha = 0;
         this._pointMovie.rotation = _loc3_;
         TweenLite.to(this._pointMovie,0.5,{
            "x":_loc2_.x,
            "y":_loc2_.y,
            "alpha":1,
            "onComplete":this.pointMoveEnd
         });
      }
      
      private function pointMoveEnd() : void
      {
         this._pointMovie.parent.removeChild(this._pointMovie);
         this._pointMovie = null;
         this._pointEndMovie = ComponentFactory.Instance.creat("asset.liveness.pointReachShine") as MovieClip;
         PositionUtils.setPos(this._pointEndMovie,"liveness.livenessItem.pointMovieEndPoint.pos");
         this._pointEndMovie.addEventListener(Event.COMPLETE,this.__removePointEndMovie);
         LayerManager.Instance.addToLayer(this._pointEndMovie,LayerManager.GAME_TOP_LAYER);
      }
      
      private function __removePointEndMovie(param1:Event) : void
      {
         this._pointEndMovie.removeEventListener(Event.COMPLETE,this.__removePointEndMovie);
         this._pointEndMovie.parent.removeChild(this._pointEndMovie);
         this._pointEndMovie = null;
         LivenessAwardManager.Instance.dispatchEvent(new LivenessEvent(LivenessEvent.REFLASH_LIVENESS,this._info.RewardDailyActivity));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         TweenLite.killTweensOf(this._pointMovie);
         ObjectUtils.disposeObject(this._joinBtn);
         this._joinBtn = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         this._info = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._descript);
         this._descript = null;
         ObjectUtils.disposeObject(this._award);
         this._award = null;
         ObjectUtils.disposeObject(this._quickDoneBtn);
         this._quickDoneBtn = null;
         ObjectUtils.disposeObject(this._taskLiveness);
         this._taskLiveness = null;
         ObjectUtils.disposeObject(this._chooseLevelView);
         this._chooseLevelView = null;
         ObjectUtils.disposeObject(this._completeImage);
         this._completeImage = null;
         ObjectUtils.disposeObject(this._consortionTaskList);
         this._consortionTaskList = null;
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
         ObjectUtils.disposeObject(this._pointMovie);
         this._pointMovie = null;
         ObjectUtils.disposeObject(this._pointEndMovie);
         this._pointEndMovie = null;
         this._livenessStartPoint = null;
         if(this._expeditionAlert)
         {
            this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
            ObjectUtils.disposeObject(this._expeditionAlert);
            this._expeditionAlert = null;
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      override public function get height() : Number
      {
         return 48;
      }
      
      override public function get width() : Number
      {
         return 566;
      }
   }
}
