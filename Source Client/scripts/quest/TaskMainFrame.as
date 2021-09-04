package quest
{
   import SingleDungeon.event.SingleDungeonEvent;
   import baglocked.BaglockedManager;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.events.TaskEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskDirectorManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import roomList.pvpRoomList.RoomListBGView;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import tryonSystem.TryonSystemController;
   
   public class TaskMainFrame extends Frame
   {
      
      public static const NORMAL:int = 1;
      
      public static const GUIDE:int = 2;
      
      public static const REWARD_UDERLINE:int = 417;
      
      private static const SPINEL:int = 11555;
      
      private static const TYPE_NUMBER:int = 6;
       
      
      private const CATEVIEW_X:int = 0;
      
      private const CATEVIEW_Y:int = 0;
      
      private const CATEVIEW_H:int = 50;
      
      private var cateViewArr:Array;
      
      private var infoView:QuestInfoPanelView;
      
      private var _questBtn:BaseButton;
      
      private var _guildBtn:BaseButton;
      
      private var _goDungeonBtnShine:IEffect;
      
      private var _downClientShine:IEffect;
      
      private var _questBtnShine:IEffect;
      
      private var _guildBtnShine:IEffect;
      
      private var _buySpinelBtn:TextButton;
      
      private var _opened:Boolean = false;
      
      private var _currentCateView:QuestCateView;
      
      public var currentNewCateView:QuestCateView;
      
      private var leftPanel:ScrollPanel;
      
      private var leftPanelContent:VBox;
      
      private var _titleBmp:Bitmap;
      
      private var _rightBGStyleNormal:MutipleImage;
      
      private var _rightBottomBg:Scale9CornerImage;
      
      private var _goDungeonBtn:BaseButton;
      
      private var _downloadClientBtn:TextButton;
      
      private var _gotoGameBtn:BaseButton;
      
      private var _mcTaskTarget:MovieClip;
      
      private var _showCloseArrowTimer:Timer;
      
      private var _style:int;
      
      private var _showGuideOnce:Boolean;
      
      private var _quick:QuickBuyFrame;
      
      public function TaskMainFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      override public function get width() : Number
      {
         return _container.width;
      }
      
      override public function get height() : Number
      {
         return _container.height;
      }
      
      private function initView() : void
      {
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.quest.title");
         addToContent(this._titleBmp);
         this.initStyleNormalBG();
         this.initStyleGuideBG();
         this.leftPanel = ComponentFactory.Instance.creatComponentByStylename("core.quest.questCateList");
         addToContent(this.leftPanel);
         this.leftPanelContent = new VBox();
         this.leftPanelContent.spacing = 0;
         this.leftPanel.setView(this.leftPanelContent);
         this.addQuestList();
         this.leftPanel.invalidateViewport();
         this.infoView = new QuestInfoPanelView();
         PositionUtils.setPos(this.infoView,"quest.infoPanelPos");
         addToContent(this.infoView);
         this._questBtn = ComponentFactory.Instance.creat("quest.getAwardBtn");
         addToContent(this._questBtn);
         this._guildBtn = ComponentFactory.Instance.creat("quest.getGuildBtn");
         addToContent(this._guildBtn);
         this._guildBtn.visible = false;
         this._goDungeonBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoDungeonBtn");
         addToContent(this._goDungeonBtn);
         this._goDungeonBtn.visible = false;
         this._gotoGameBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.goGameBtn");
         addToContent(this._gotoGameBtn);
         this._gotoGameBtn.visible = false;
         this._downloadClientBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.DownloadClientBtn");
         this._downloadClientBtn.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.DownloadClient");
         addToContent(this._downloadClientBtn);
         this._downloadClientBtn.visible = false;
         this._buySpinelBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.buySpinelBtn");
         this._buySpinelBtn.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.buySpinel");
         addToContent(this._buySpinelBtn);
         var _loc1_:Object = new Object();
         _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
         this._goDungeonBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._goDungeonBtn,_loc1_);
         this._goDungeonBtnShine.stop();
         this._downClientShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._downloadClientBtn,_loc1_);
         this._downClientShine.play();
         this._questBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._questBtn,_loc1_);
         this._questBtnShine.stop();
         this._guildBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._guildBtn,_loc1_);
         this._guildBtnShine.stop();
         this._buySpinelBtn.visible = false;
         this._questBtn.enable = false;
         this.showStyle(NORMAL);
      }
      
      private function initStyleNormalBG() : void
      {
         this._rightBGStyleNormal = ComponentFactory.Instance.creatComponentByStylename("quest.background.mapBg");
         PositionUtils.setPos(this._rightBGStyleNormal,"quest.rightBgpos");
         this._rightBottomBg = ComponentFactory.Instance.creatComponentByStylename("quest.rightBottomBgImg");
         addToContent(this._rightBGStyleNormal);
         addToContent(this._rightBottomBg);
      }
      
      private function initStyleGuideBG() : void
      {
      }
      
      private function switchBG(param1:int) : void
      {
      }
      
      private function addQuestList() : void
      {
         var _loc2_:QuestCateView = null;
         if(this.cateViewArr)
         {
            return;
         }
         this.cateViewArr = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < TYPE_NUMBER)
         {
            _loc2_ = new QuestCateView(_loc1_);
            _loc2_.collapse();
            _loc2_.x = this.CATEVIEW_X;
            _loc2_.y = this.CATEVIEW_Y + this.CATEVIEW_H * _loc1_;
            _loc2_.addEventListener(QuestCateView.TITLECLICKED,this.__onTitleClicked);
            _loc2_.addEventListener(Event.CHANGE,this.__onCateViewChange);
            _loc2_.addEventListener(QuestCateView.ENABLE_CHANGE,this.__onEnbleChange);
            this.cateViewArr.push(_loc2_);
            this.leftPanelContent.addChild(_loc2_);
            _loc1_++;
         }
         this.__onEnbleChange(null);
      }
      
      private function __onEnbleChange(param1:Event) : void
      {
         var _loc4_:QuestCateView = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < TYPE_NUMBER - 1)
         {
            _loc4_ = this.cateViewArr[_loc3_];
            if(_loc4_.visible)
            {
               _loc4_.y = this.CATEVIEW_Y + this.CATEVIEW_H * _loc2_;
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      private function addEvent() : void
      {
         TaskManager.instance.addEventListener(TaskEvent.CHANGED,this.__onDataChanged);
         TaskManager.instance.addEventListener(TaskEvent.FINISH,this.__onTaskFinished);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._questBtn.addEventListener(MouseEvent.CLICK,this.__onQuestBtnClicked);
         this._guildBtn.addEventListener(MouseEvent.CLICK,this.__onGuildBtnClicked);
         this._goDungeonBtn.addEventListener(MouseEvent.CLICK,this.__onGoDungeonClicked);
         this._downloadClientBtn.addEventListener(MouseEvent.CLICK,this.__downloadClient);
         this._buySpinelBtn.addEventListener(MouseEvent.CLICK,this.__buySpinelClick);
         this._gotoGameBtn.addEventListener(MouseEvent.CLICK,this.__gotoGame);
      }
      
      protected function __onGuildBtnClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TaskDirectorManager.instance.beginGuild(this.infoView.info);
      }
      
      protected function __onTaskFinished(param1:TaskEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestItemReward = null;
         var _loc4_:ItemTemplateInfo = null;
         var _loc5_:ItemTemplateInfo = null;
         if(param1.type == "finish")
         {
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
            DropGoodsManager.play(_loc2_);
         }
      }
      
      private function removeEvent() : void
      {
         TaskManager.instance.removeEventListener(TaskEvent.CHANGED,this.__onDataChanged);
         TaskManager.instance.removeEventListener(TaskEvent.FINISH,this.__onTaskFinished);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._questBtn.removeEventListener(MouseEvent.CLICK,this.__onQuestBtnClicked);
         this._guildBtn.removeEventListener(MouseEvent.CLICK,this.__onGuildBtnClicked);
         this._goDungeonBtn.removeEventListener(MouseEvent.CLICK,this.__onGoDungeonClicked);
         this._downloadClientBtn.removeEventListener(MouseEvent.CLICK,this.__downloadClient);
         this._buySpinelBtn.removeEventListener(MouseEvent.CLICK,this.__buySpinelClick);
         this._gotoGameBtn.removeEventListener(MouseEvent.CLICK,this.__gotoGame);
      }
      
      private function __onDataChanged(param1:TaskEvent) : void
      {
         var _loc2_:uint = 0;
         if(!this._currentCateView || this.currentNewCateView != null)
         {
            return;
         }
         if(param1.info.Type == 0)
         {
            if((this.cateViewArr[0] as QuestCateView).active())
            {
               return;
            }
         }
         if(this._currentCateView.active())
         {
            return;
         }
         _loc2_ = 0;
         while(!(this.cateViewArr[_loc2_] as QuestCateView).active())
         {
            _loc2_++;
            if(_loc2_ == 6)
            {
               return;
            }
         }
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               TaskManager.instance.switchVisible();
         }
         SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT,"reflash"));
      }
      
      public function jumpToQuest(param1:QuestInfo) : void
      {
         if(param1.MapID > 0)
         {
            this.showOtherBtn(param1);
         }
         else
         {
            this._goDungeonBtn.visible = false;
            this._goDungeonBtnShine.stop();
            this._downloadClientBtn.visible = false;
            this._questBtn.visible = true;
            this._guildBtn.visible = false;
            this._gotoGameBtn.visible = false;
            this._buySpinelBtn.visible = this.existRewardId(param1,SPINEL);
            this.showStyle(NORMAL);
         }
         this.infoView.info = param1;
         var _loc2_:Boolean = param1.isCompleted || param1.data && param1.data.isCompleted;
         this.showQuestOverBtn(_loc2_);
         if(param1.QuestID < 200)
         {
            if(param1.isCompleted)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAT,0,"trainer.clickBeatArrowPos","asset.trainer.txtGetReward","trainer.clickBeatTipPos",this);
            }
         }
         if(!param1.isCompleted)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAT);
         }
      }
      
      public function showQuestTask(param1:QuestInfo, param2:int) : void
      {
         var _loc3_:QuestCateView = null;
         for each(_loc3_ in this.cateViewArr)
         {
            if(_loc3_.questType == param2)
            {
               _loc3_.active();
            }
            else
            {
               _loc3_.collapse();
            }
         }
         this.jumpToQuest(param1);
      }
      
      private function showQuestOverBtn(param1:Boolean) : void
      {
         if(param1)
         {
            this._questBtn.enable = true;
            this._questBtn.visible = true;
            this._questBtnShine.play();
            if(this._guildBtn)
            {
               this._guildBtn.visible = false;
               this._guildBtnShine.stop();
            }
            this._goDungeonBtn.visible = false;
            this._gotoGameBtn.visible = false;
         }
         else if(this.infoView.info.GuideType > 0)
         {
            this._questBtn.visible = false;
            this._questBtnShine.stop();
            this._guildBtn.visible = true;
            this._guildBtnShine.play();
         }
         else
         {
            this._questBtn.visible = true;
            this._questBtn.enable = false;
            this._questBtnShine.stop();
            this._guildBtn.visible = false;
            this._guildBtnShine.stop();
         }
      }
      
      private function showOtherBtn(param1:QuestInfo) : void
      {
         if(param1.MapID > 0)
         {
            if(param1.MapID == 2)
            {
               this._goDungeonBtn.visible = false;
               this._downloadClientBtn.visible = false;
               this._questBtn.visible = false;
               this._guildBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
            }
            else if(param1.MapID == 3)
            {
               this._downloadClientBtn.visible = true;
               this._goDungeonBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
            }
            else if(param1.MapID == 4)
            {
               this._downloadClientBtn.visible = false;
               this._goDungeonBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = true;
            }
            else if(param1.MapID > 9 && param1.MapID < 30)
            {
               this._downloadClientBtn.visible = false;
               this._goDungeonBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
            }
            else
            {
               this.showStyle(GUIDE);
               this._goDungeonBtn.visible = true;
               this._goDungeonBtn.enable = !param1.isCompleted;
               if(this._goDungeonBtn.enable)
               {
                  this._goDungeonBtnShine.play();
               }
               else
               {
                  this._goDungeonBtnShine.stop();
               }
               this._downloadClientBtn.visible = false;
               this._questBtn.visible = false;
               this._guildBtn.visible = false;
               this._buySpinelBtn.visible = false;
               this._gotoGameBtn.visible = false;
            }
         }
         else
         {
            this._downloadClientBtn.visible = false;
            this._goDungeonBtn.visible = false;
            this._gotoGameBtn.visible = false;
            this._buySpinelBtn.visible = this.existRewardId(param1,SPINEL);
         }
      }
      
      private function existRewardId(param1:QuestInfo, param2:int) : Boolean
      {
         var _loc3_:QuestItemReward = null;
         for each(_loc3_ in param1.itemRewards)
         {
            if(_loc3_.itemID == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      private function showStyle(param1:int) : void
      {
         if(this._style == param1)
         {
            return;
         }
         this._style = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.cateViewArr.length)
         {
            (this.cateViewArr[_loc2_] as QuestCateView).taskStyle = param1;
            _loc2_++;
         }
         this.switchBG(param1);
      }
      
      private function __onCateViewChange(param1:Event) : void
      {
         var _loc4_:QuestCateView = null;
         var _loc2_:int = 42;
         var _loc3_:int = 0;
         while(_loc3_ < this.cateViewArr.length)
         {
            _loc4_ = this.cateViewArr[_loc3_] as QuestCateView;
            if(_loc4_.visible)
            {
               _loc4_.y = _loc2_;
               _loc2_ += _loc4_.contentHeight + 7;
            }
            _loc3_++;
         }
      }
      
      private function __onTitleClicked(param1:Event) : void
      {
         var _loc4_:QuestCateView = null;
         if(!parent || this.currentNewCateView != null)
         {
            return;
         }
         if(this._currentCateView != param1.target as QuestCateView)
         {
         }
         this._currentCateView = param1.target as QuestCateView;
         var _loc2_:int = this.CATEVIEW_Y;
         var _loc3_:int = 0;
         while(_loc3_ < this.cateViewArr.length)
         {
            _loc4_ = this.cateViewArr[_loc3_] as QuestCateView;
            if(_loc4_ != this._currentCateView)
            {
               _loc4_.collapse();
            }
            if(_loc4_.visible)
            {
               _loc4_.y = _loc2_;
               _loc2_ += _loc4_.contentHeight + 7;
            }
            _loc3_++;
         }
      }
      
      public function switchVisible() : void
      {
         if(parent)
         {
            this.dispose();
         }
         else
         {
            this._show();
         }
      }
      
      private function _show() : void
      {
         if(this._opened == true)
         {
            this.dispose();
         }
         this._opened = true;
         MainToolBar.Instance.unReadTask = false;
         this.showGuide();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function open() : void
      {
         if(!this._opened)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
            this._show();
         }
      }
      
      private function showGuide() : void
      {
         if(SavePointManager.Instance.isInSavePoint(3))
         {
            if(!TaskManager.instance.isNewHandTaskCompleted(1))
            {
               if(!this._showGuideOnce)
               {
                  this._showGuideOnce = true;
                  if(!this._mcTaskTarget)
                  {
                     this._mcTaskTarget = ComponentFactory.Instance.creatCustomObject("trainer.mcTaskTarget");
                  }
                  addChild(this._mcTaskTarget);
                  NewHandContainer.Instance.showArrow(ArrowType.TASK_TARGET,180,"trainer.taskTargetArrowPos","","",this);
               }
            }
         }
         var _loc1_:Array = TaskManager.instance.allCurrentQuest;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].QuestID < 200)
            {
               if(TaskManager.instance.isCompleted(_loc1_[_loc2_]))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAT,0,"trainer.clickBeatArrowPos","asset.trainer.txtGetReward","trainer.clickBeatTipPos",this);
               }
            }
            _loc2_++;
         }
      }
      
      private function __onQuestBtnClicked(param1:MouseEvent) : void
      {
         if(!this.infoView.info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:QuestInfo = this.infoView.info;
         this.finishQuest(_loc2_);
         if(NewHandContainer.Instance.hasArrow(ArrowType.CLICK_BEAT))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAT);
         }
         if(_loc2_.QuestID == 1 || _loc2_.QuestID == 101)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
            SavePointManager.Instance.setSavePoint(3);
            NewHandContainer.Instance.showArrow(ArrowType.TASK_TARGET,225,"trainer.taskCloseArrowPos","","",this);
            StartupResourceLoader.Instance.addNotStartupNeededResource();
         }
         if(_loc2_.QuestID == 2 || _loc2_.QuestID == 102)
         {
            SavePointManager.Instance.setSavePoint(5);
         }
         if(_loc2_.QuestID == 4 || _loc2_.QuestID == 104)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(5))
            {
               SavePointManager.Instance.setSavePoint(7);
            }
         }
         if(_loc2_.QuestID == 5 || _loc2_.QuestID == 105)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(4))
            {
               SavePointManager.Instance.setSavePoint(7);
            }
         }
         if(_loc2_.QuestID == 3 || _loc2_.QuestID == 103)
         {
            SavePointManager.Instance.setSavePoint(11);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
         }
         if(_loc2_.QuestID == 6 || _loc2_.QuestID == 106)
         {
            SavePointManager.Instance.setSavePoint(10);
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(_loc2_.QuestID == 7 || _loc2_.QuestID == 107)
         {
            SavePointManager.Instance.setSavePoint(9);
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(_loc2_.QuestID == 8 || _loc2_.QuestID == 108)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(9))
            {
               if(!SavePointManager.Instance.savePoints[13])
               {
                  SavePointManager.Instance.setSavePoint(13);
                  MainToolBar.Instance.showIconAppear(4);
                  SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
               }
            }
         }
         if(_loc2_.QuestID == 9 || _loc2_.QuestID == 109)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(8))
            {
               if(!SavePointManager.Instance.savePoints[13])
               {
                  SavePointManager.Instance.setSavePoint(13);
                  MainToolBar.Instance.showIconAppear(4);
                  SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
               }
            }
         }
         if(_loc2_.QuestID == 10 || _loc2_.QuestID == 110)
         {
            if(!SavePointManager.Instance.savePoints[14])
            {
               SavePointManager.Instance.setSavePoint(14);
               MainToolBar.Instance.showIconAppear(2);
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            }
         }
         if(_loc2_.QuestID == 11 || _loc2_.QuestID == 111)
         {
            SavePointManager.Instance.setSavePoint(15);
         }
         if(_loc2_.QuestID == 12 || _loc2_.QuestID == 112)
         {
            SavePointManager.Instance.setSavePoint(16);
         }
         if(_loc2_.QuestID == 13 || _loc2_.QuestID == 113)
         {
            if(!SavePointManager.Instance.savePoints[17])
            {
               SavePointManager.Instance.setSavePoint(17);
               TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.ROOMLIST_REFLASH));
            }
         }
         if(_loc2_.QuestID == 14 || _loc2_.QuestID == 114)
         {
            SavePointManager.Instance.setSavePoint(18);
         }
         if(_loc2_.QuestID == 17 || _loc2_.QuestID == 117)
         {
            SavePointManager.Instance.setSavePoint(21);
         }
         if(_loc2_.QuestID == 18 || _loc2_.QuestID == 118)
         {
            SavePointManager.Instance.setSavePoint(22);
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.WALKMAP_EXIT));
         }
         if(_loc2_.QuestID == 19 || _loc2_.QuestID == 119)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(20))
            {
               SavePointManager.Instance.setSavePoint(23);
            }
         }
         if(_loc2_.QuestID == 20 || _loc2_.QuestID == 120)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(19))
            {
               SavePointManager.Instance.setSavePoint(23);
            }
         }
         if(_loc2_.QuestID == 26 || _loc2_.QuestID == 126)
         {
            SavePointManager.Instance.setSavePoint(35);
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(_loc2_.QuestID == 21 || _loc2_.QuestID == 121)
         {
            SavePointManager.Instance.setSavePoint(48);
         }
         if(_loc2_.QuestID == 22 || _loc2_.QuestID == 122)
         {
            SavePointManager.Instance.setSavePoint(25);
         }
         if(_loc2_.QuestID == 23 || _loc2_.QuestID == 123)
         {
            SavePointManager.Instance.setSavePoint(26);
         }
         if(_loc2_.QuestID == 24 || _loc2_.QuestID == 124)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(25))
            {
               SavePointManager.Instance.setSavePoint(27);
            }
         }
         if(_loc2_.QuestID == 25 || _loc2_.QuestID == 125)
         {
            if(TaskManager.instance.isNewHandTaskAchieved(24))
            {
               SavePointManager.Instance.setSavePoint(27);
            }
         }
         if(_loc2_.QuestID == 27 || _loc2_.QuestID == 127)
         {
            SavePointManager.Instance.setSavePoint(55);
         }
         if(_loc2_.QuestID == 28 || _loc2_.QuestID == 128)
         {
            SavePointManager.Instance.setSavePoint(67);
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
         }
         if(_loc2_.QuestID == 593)
         {
            SavePointManager.Instance.setSavePoint(69);
         }
         if(_loc2_.QuestID == 250)
         {
            SavePointManager.Instance.setSavePoint(78);
         }
      }
      
      private function finishQuest(param1:QuestInfo) : void
      {
         var _loc2_:Array = null;
         var _loc3_:QuestItemReward = null;
         var _loc4_:InventoryItemInfo = null;
         if(param1 && !param1.isCompleted)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.dropTaskIII"));
            this._currentCateView.active();
            return;
         }
         if(TaskManager.instance.Model.itemAwardSelected == -1)
         {
            _loc2_ = [];
            for each(_loc3_ in param1.itemRewards)
            {
               _loc4_ = new InventoryItemInfo();
               _loc4_.TemplateID = _loc3_.itemID;
               ItemManager.fill(_loc4_);
               _loc4_.ValidDate = _loc3_.ValidateTime;
               _loc4_.TemplateID = _loc3_.itemID;
               _loc4_.IsJudge = true;
               _loc4_.IsBinds = _loc3_.isBind;
               _loc4_.AttackCompose = _loc3_.AttackCompose;
               _loc4_.DefendCompose = _loc3_.DefendCompose;
               _loc4_.AgilityCompose = _loc3_.AgilityCompose;
               _loc4_.LuckCompose = _loc3_.LuckCompose;
               _loc4_.StrengthenLevel = _loc3_.StrengthenLevel;
               _loc4_.Count = _loc3_.count[param1.QuestLevel - 1];
               if(!(0 != _loc4_.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != _loc4_.NeedSex))
               {
                  if(_loc3_.isOptional == 1)
                  {
                     _loc2_.push(_loc4_);
                  }
               }
            }
            TryonSystemController.Instance.show(_loc2_,this.chooseReward,this.cancelChoose);
            return;
         }
         if(this.infoView.info)
         {
            TaskManager.instance.sendQuestFinish(this.infoView.info.QuestID);
         }
      }
      
      private function getSexByInt(param1:Boolean) : int
      {
         if(param1)
         {
            return 1;
         }
         return 2;
      }
      
      private function chooseReward(param1:ItemTemplateInfo) : void
      {
         SocketManager.Instance.out.sendQuestFinish(this.infoView.info.QuestID,param1.TemplateID);
         TaskManager.instance.Model.itemAwardSelected = -1;
         var _loc2_:Array = new Array();
         if(param1 && PlayerManager.Instance.Self.Bag.itemBagNumber + 1 <= 144)
         {
            _loc2_.push(param1);
         }
         DropGoodsManager.play(_loc2_);
      }
      
      private function cancelChoose() : void
      {
         TaskManager.instance.Model.itemAwardSelected = -1;
      }
      
      private function __onGoDungeonClicked(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._goDungeonBtn.enable = false;
         if(PlayerManager.Instance.Self.Bag.getItemAt(14) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            this._goDungeonBtn.enable = true;
            return;
         }
         if(this.infoView.info.MapID > 0)
         {
            if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            setTimeout(SocketManager.Instance.out.createUserGuide,500);
         }
      }
      
      private function __gotoGame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._gotoGameBtn.enable = false;
         StateManager.setState(StateType.ROOM_LIST);
         setTimeout(GameInSocketOut.sendCreateRoom,1000,RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],0,3);
      }
      
      private function __downloadClient(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         navigateToURL(new URLRequest(PathManager.solveClientDownloadPath()));
      }
      
      private function __buySpinelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(SPINEL);
         if(PlayerManager.Instance.Self.Money < _loc2_.getItemPrice(1).moneyValue)
         {
            LeavePageManager.showFillFrame();
         }
         else
         {
            this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            this._quick.itemID = SPINEL;
            this._quick.buyFrom = 7;
            this._quick.maxLimit = 3;
            LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      override protected function __onAddToStage(param1:Event) : void
      {
         var _loc5_:QuestCateView = null;
         var _loc6_:QuestCateView = null;
         super.__onAddToStage(param1);
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.cateViewArr.length)
         {
            _loc5_ = this.cateViewArr[_loc3_] as QuestCateView;
            _loc5_.initData();
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.cateViewArr.length)
         {
            _loc6_ = this.cateViewArr[_loc4_] as QuestCateView;
            _loc6_.initData();
            if(_loc6_.data.haveCompleted)
            {
               _loc6_.active();
               return;
            }
            if(_loc6_.length > 0 && _loc2_ < 0)
            {
               _loc2_ = _loc4_;
               _loc6_.active();
            }
            _loc4_++;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:QuestCateView = null;
         NewHandContainer.Instance.clearArrowByID(ArrowType.TASK_TARGET);
         if(!SavePointManager.Instance.savePoints[86])
         {
            SavePointManager.Instance.setSavePoint(86);
         }
         TaskManager.instance.removeNewQuestMovie();
         this.removeEvent();
         this._currentCateView = null;
         this.currentNewCateView = null;
         while(_loc1_ = this.cateViewArr.pop())
         {
            _loc1_.removeEventListener(QuestCateView.TITLECLICKED,this.__onTitleClicked);
            _loc1_.removeEventListener(QuestCateView.ENABLE_CHANGE,this.__onEnbleChange);
            _loc1_.removeEventListener(Event.CHANGE,this.__onCateViewChange);
            _loc1_.dispose();
            _loc1_ = null;
         }
         ObjectUtils.disposeObject(this.leftPanelContent);
         this.leftPanelContent = null;
         ObjectUtils.disposeObject(this.leftPanel);
         this.leftPanel = null;
         if(this._titleBmp)
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         if(this._quick && this._quick.canDispose)
         {
            this._quick.dispose();
         }
         this._quick = null;
         if(this.infoView)
         {
            this.infoView.dispose();
         }
         this.infoView = null;
         if(this._questBtn)
         {
            ObjectUtils.disposeObject(this._questBtn);
         }
         this._questBtn = null;
         if(this._guildBtn)
         {
            ObjectUtils.disposeObject(this._guildBtn);
         }
         this._guildBtn = null;
         if(this._goDungeonBtnShine)
         {
            ObjectUtils.disposeObject(this._goDungeonBtnShine);
         }
         this._goDungeonBtnShine = null;
         if(this._downClientShine)
         {
            ObjectUtils.disposeObject(this._downClientShine);
         }
         this._downClientShine = null;
         if(this._questBtnShine)
         {
            ObjectUtils.disposeObject(this._questBtnShine);
         }
         this._questBtnShine = null;
         if(this._guildBtnShine)
         {
            ObjectUtils.disposeObject(this._guildBtnShine);
         }
         this._guildBtnShine = null;
         if(this._mcTaskTarget)
         {
            ObjectUtils.disposeObject(this._mcTaskTarget);
         }
         this._mcTaskTarget = null;
         if(this._rightBottomBg)
         {
            ObjectUtils.disposeObject(this._rightBottomBg);
         }
         this._rightBottomBg = null;
         if(this._rightBGStyleNormal)
         {
            ObjectUtils.disposeObject(this._rightBGStyleNormal);
         }
         this._rightBGStyleNormal = null;
         if(this._goDungeonBtn)
         {
            ObjectUtils.disposeObject(this._goDungeonBtn);
         }
         this._goDungeonBtn = null;
         if(this._downloadClientBtn)
         {
            ObjectUtils.disposeObject(this._downloadClientBtn);
         }
         this._downloadClientBtn = null;
         if(this._gotoGameBtn)
         {
            ObjectUtils.disposeObject(this._gotoGameBtn);
            this._gotoGameBtn = null;
         }
         this._opened = false;
         TaskManager.instance.Model.selectedQuest = null;
         TaskManager.instance.Model.taskViewIsShow = false;
         NewHandContainer.Instance.clearArrowByID(ArrowType.GET_REWARD);
         MainToolBar.Instance.tipTask();
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new TaskEvent(TaskEvent.TASK_FRAME_HIDE));
      }
   }
}
