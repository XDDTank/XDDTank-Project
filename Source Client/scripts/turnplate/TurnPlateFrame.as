package turnplate
{
   import bagAndInfo.cell.BaseCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.greensock.plugins.TransformAroundCenterPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.chatBall.ChatBallAlways;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   import store.HelpPrompt;
   
   public class TurnPlateFrame extends Frame
   {
       
      
      private const REFLASH:uint = 0;
      
      private const RAMDOM:uint = 1;
      
      private const SPEED:uint = 80;
      
      private const ACCELERATION:uint = 40;
      
      private var _titleBmp:Bitmap;
      
      private var _plateBg:Bitmap;
      
      private var _plateCells:Bitmap;
      
      private var _rewardListBg:Bitmap;
      
      private var _rewardItemBg:Scale9CornerImage;
      
      private var _starShine:MovieClip;
      
      private var _boguLiving:MovieClip;
      
      private var _rewardTitle:Bitmap;
      
      private var _rewardTitleTxt:FilterFrameText;
      
      private var _rewardCellHBox:HBox;
      
      private var _rewardItemCellList:Vector.<BaseCell>;
      
      private var _openNeedTxt:FilterFrameText;
      
      private var _currentOwnTxt:FilterFrameText;
      
      private var _rewardHistoryVBox:VBox;
      
      private var _rewardHistoryPanel:ScrollPanel;
      
      private var _oneKeyBtn:SelectedButton;
      
      private var _reflashBtn:BaseButton;
      
      private var _randomCellsHBoxI:HBox;
      
      private var _randomCellsHBoxII:HBox;
      
      private var _randomCellsVBoxI:VBox;
      
      private var _randomCellsVBoxII:VBox;
      
      private var _randomCellsList:Vector.<TurnPlateShowCell>;
      
      private var _helpBtn:BaseButton;
      
      private var _boguClickArea:Sprite;
      
      private var _chatballview:ChatBallAlways;
      
      private var _isPlaying:Boolean;
      
      private var _chatBallComplete:Boolean;
      
      private var _turnplateComplete:Boolean;
      
      private var _currentItemId:int = 0;
      
      private var _currentItemCount:int = 0;
      
      private var _currentCellIndex:int;
      
      private var _endCellIndex:uint;
      
      private var _saveEndCellIndex:uint = 0;
      
      private var _beginSlowIndex:uint;
      
      private var _startMoveTimer:Timer;
      
      private var _findEndIndexTimer:Timer;
      
      private var _slowDelay:uint = 100;
      
      private var _slowTimeout:Number;
      
      private var _quickBuyBtn:BaseButton;
      
      private var _moveAnimaCell:TurnPlateShowCell;
      
      private var _clickTooFast:Boolean;
      
      private var _checkFullTimeout:Number;
      
      private var _currentOpenIndex:uint;
      
      private var _lastPressTime:Number = 0;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      private var _slowSound:Array;
      
      private var _slowSoundIndex:uint;
      
      private var _livingLoader:BaseLoader;
      
      private var _stopOneKey:Boolean;
      
      private var _oneKeyTurnOn:Boolean;
      
      public function TurnPlateFrame()
      {
         this._slowSound = ["130","131","133","132","135","134","129","128","127","132","135","134","129","128","127"];
         super();
         this._helpBtn = ComponentFactory.Instance.creat("baseHelpBtn");
         escEnable = true;
      }
      
      private function initView() : void
      {
         var _loc2_:Scale9CornerImage = null;
         var _loc3_:BaseCell = null;
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.turnplate.frameTitle");
         this._plateBg = ComponentFactory.Instance.creatBitmap("asset.turnplate.plateBg");
         this._plateCells = ComponentFactory.Instance.creatBitmap("asset.turnplate.plateCells");
         this._rewardListBg = ComponentFactory.Instance.creatBitmap("asset.turnplate.rewardHistoryBg");
         this._rewardItemBg = ComponentFactory.Instance.creatComponentByStylename("turnplate.getItemBg");
         this._starShine = ComponentFactory.Instance.creat("asset.turnplate.starShine");
         PositionUtils.setPos(this._starShine,"turnPlate.starShine.Pos");
         this._boguLiving = ComponentFactory.Instance.creat("game.living.turnplate");
         this._boguLiving.scaleX = this._boguLiving.scaleY = 0.9;
         PositionUtils.setPos(this._boguLiving,"turnPlate.boguLiving.Pos");
         this._rewardTitle = ComponentFactory.Instance.creatBitmap("asset.corei.consortion.upGrade.bg");
         this._rewardTitleTxt = ComponentFactory.Instance.creatComponentByStylename("turnplate.rewardTitle");
         this._rewardTitleTxt.text = LanguageMgr.GetTranslation("ddt.turnplate.rewardTitle.txt");
         this._rewardCellHBox = ComponentFactory.Instance.creatComponentByStylename("turnplate.rewardCellHBox");
         this._openNeedTxt = ComponentFactory.Instance.creatComponentByStylename("turnplate.openNeed");
         this._currentOwnTxt = ComponentFactory.Instance.creatComponentByStylename("turnplate.currentOwn");
         this._rewardHistoryVBox = ComponentFactory.Instance.creatComponentByStylename("turnplate.rewardHistory.vbox");
         this._rewardHistoryPanel = ComponentFactory.Instance.creatComponentByStylename("turnplate.rewardHistory.scrollPanel");
         this._rewardHistoryPanel.setView(this._rewardHistoryVBox);
         this._oneKeyBtn = ComponentFactory.Instance.creatComponentByStylename("turnplate.oneKeyBtn");
         this._reflashBtn = ComponentFactory.Instance.creatComponentByStylename("turnplate.reflashBtn");
         this._reflashBtn.tipData = LanguageMgr.GetTranslation("ddt.turnplate.reflashBtn.tips.txt",ServerConfigManager.instance.getTurnPlateRefreshGold());
         this._randomCellsHBoxI = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsHBox");
         this._randomCellsHBoxII = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsHBox");
         this._randomCellsVBoxI = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsVBox");
         this._randomCellsVBoxII = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsVBox");
         PositionUtils.setPos(this._randomCellsHBoxII,"turnPlate.randomCellHboxII.Pos");
         PositionUtils.setPos(this._randomCellsVBoxII,"turnPlate.randomCellVboxII.Pos");
         this._boguClickArea = new Sprite();
         this._boguClickArea.graphics.beginFill(0,0);
         this._boguClickArea.graphics.drawRect(0,0,155,160);
         this._boguClickArea.graphics.endFill();
         this._boguClickArea.buttonMode = true;
         this._boguClickArea.useHandCursor = true;
         PositionUtils.setPos(this._boguClickArea,"turnPlate.boguClickArea.Pos");
         this._chatballview = new ChatBallAlways();
         this._chatballview.setText(LanguageMgr.GetTranslation("ddt.turnplate.chatBall.txt"));
         PositionUtils.setPos(this._chatballview,"turnPlate.chatBall.Pos");
         this._chatballview.show();
         this._quickBuyBtn = ComponentFactory.Instance.creatComponentByStylename("turnplate.quickBuyBtn");
         this._currentOpenIndex = 0;
         addToContent(this._titleBmp);
         addToContent(this._plateBg);
         addToContent(this._boguLiving);
         if(SharedManager.Instance.turnPlateShowChatBall)
         {
            addToContent(this._chatballview);
         }
         addToContent(this._plateCells);
         addToContent(this._starShine);
         addToContent(this._rewardListBg);
         addToContent(this._rewardItemBg);
         addToContent(this._rewardTitle);
         addToContent(this._rewardTitleTxt);
         addToContent(this._rewardCellHBox);
         addToContent(this._openNeedTxt);
         addToContent(this._currentOwnTxt);
         addToContent(this._rewardHistoryPanel);
         addToContent(this._randomCellsHBoxI);
         addToContent(this._randomCellsVBoxI);
         addToContent(this._randomCellsHBoxII);
         addToContent(this._randomCellsVBoxII);
         addToContent(this._oneKeyBtn);
         addToContent(this._reflashBtn);
         addToContent(this._boguClickArea);
         addToContent(this._quickBuyBtn);
         this.reflashCostTxt();
         this._currentOwnTxt.text = String(TurnPlateController.Instance.getBoguCoinCount());
         this._rewardItemCellList = new Vector.<BaseCell>();
         var _loc1_:uint = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("turnplate.rewardItemBg");
            _loc3_ = new BaseCell(_loc2_);
            _loc3_.isShowCount = true;
            this._rewardItemCellList.push(_loc3_);
            this._rewardCellHBox.addChild(_loc3_);
            _loc1_++;
         }
      }
      
      private function addRandomCells() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this._randomCellsHBoxI.addChild(this._randomCellsList[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 6;
         while(_loc1_ < 9)
         {
            this._randomCellsVBoxI.addChild(this._randomCellsList[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 14;
         while(_loc1_ > 8)
         {
            this._randomCellsHBoxII.addChild(this._randomCellsList[_loc1_]);
            _loc1_--;
         }
         _loc1_ = 17;
         while(_loc1_ > 14)
         {
            this._randomCellsVBoxII.addChild(this._randomCellsList[_loc1_]);
            _loc1_--;
         }
      }
      
      private function clearRandomCells() : void
      {
         ObjectUtils.disposeAllChildren(this._randomCellsHBoxI);
         ObjectUtils.disposeAllChildren(this._randomCellsVBoxI);
         ObjectUtils.disposeAllChildren(this._randomCellsHBoxII);
         ObjectUtils.disposeAllChildren(this._randomCellsVBoxII);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isPlaying && TimeManager.Instance.Now().time - this._lastPressTime < 10000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.turnplate.isTurning"));
            return;
         }
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.forcibleClose();
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
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TURN_PLATE);
      }
      
      private function __onUIComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHAT_BALL)
         {
            this._chatBallComplete = true;
         }
         if(param1.module == UIModuleTypes.TURN_PLATE)
         {
            this._turnplateComplete = true;
         }
         if(this._chatBallComplete && this._turnplateComplete)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            this.loadResFile(PathManager.solveGameLivingPath("living004"),BaseLoader.MODULE_LOADER);
         }
      }
      
      private function __onUIProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function loadLivingComplete(param1:LoaderEvent) : void
      {
         this.__onClose();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
         this.initEvent();
         TurnPlateController.Instance.isFrameOpen = true;
         SocketManager.Instance.out.sendRequestAwards(3);
         SocketManager.Instance.out.sendTurnPlateReady();
      }
      
      private function loadResFile(param1:String, param2:int) : void
      {
         this._livingLoader = LoadResourceManager.instance.createLoader(param1,param2);
         this._livingLoader.addEventListener(LoaderEvent.COMPLETE,this.loadLivingComplete);
         this._livingLoader.addEventListener(LoaderEvent.PROGRESS,this.__uiProgress);
         LoadResourceManager.instance.startLoad(this._livingLoader);
      }
      
      private function __uiProgress(param1:LoaderEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __onClose(param1:Event = null) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         if(this._livingLoader)
         {
            this._livingLoader.removeEventListener(LoaderEvent.COMPLETE,this.loadLivingComplete);
            this._livingLoader.removeEventListener(LoaderEvent.PROGRESS,this.__uiProgress);
         }
         if(param1)
         {
            TurnPlateController.Instance.hide();
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_START,this.__plateReady);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_RANDOM,this.__randomBoxHandler);
         this._oneKeyBtn.addEventListener(MouseEvent.CLICK,this.__clickOneKey);
         this._reflashBtn.addEventListener(MouseEvent.CLICK,this.__clickReflash);
         this._boguClickArea.addEventListener(MouseEvent.CLICK,this.__clickBogu);
         this._boguClickArea.addEventListener(MouseEvent.ROLL_OVER,this.__boguOver);
         this._boguClickArea.addEventListener(MouseEvent.ROLL_OUT,this.__boguOut);
         this._quickBuyBtn.addEventListener(MouseEvent.CLICK,this.__clickQuickBuy);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateBag);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
      }
      
      private function removeEvent() : void
      {
         var _loc1_:TurnPlateShowCell = null;
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_START,this.__plateReady);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_RANDOM,this.__randomBoxHandler);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateBag);
         if(this._helpBtn)
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         }
         if(this._oneKeyBtn)
         {
            this._oneKeyBtn.removeEventListener(MouseEvent.CLICK,this.__clickOneKey);
         }
         if(this._reflashBtn)
         {
            this._reflashBtn.removeEventListener(MouseEvent.CLICK,this.__clickReflash);
         }
         if(this._boguClickArea)
         {
            this._boguClickArea.removeEventListener(MouseEvent.CLICK,this.__clickBogu);
            this._boguClickArea.removeEventListener(MouseEvent.ROLL_OVER,this.__boguOver);
            this._boguClickArea.removeEventListener(MouseEvent.ROLL_OUT,this.__boguOut);
         }
         if(this._quickBuyBtn)
         {
            this._quickBuyBtn.removeEventListener(MouseEvent.CLICK,this.__clickQuickBuy);
         }
         if(this._startMoveTimer)
         {
            this._startMoveTimer.removeEventListener(TimerEvent.TIMER,this.__randomMove);
            this._startMoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__findBeginSlowIndex);
         }
         if(this._findEndIndexTimer)
         {
            this._findEndIndexTimer.removeEventListener(TimerEvent.TIMER,this.__finding);
         }
         if(this._moveAnimaCell)
         {
            this._moveAnimaCell.removeEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE,this.__equipShineComplete);
            this._moveAnimaCell.removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE,this.__bottomItemShineComplete);
         }
         for each(_loc1_ in this._randomCellsList)
         {
            _loc1_.removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE,this.__itemShineComplete);
         }
      }
      
      protected function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("turnPlate.ComposeHelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("ddt.turnplate.chatName.txt");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __updateBag(param1:BagEvent) : void
      {
         this._currentOwnTxt.text = String(TurnPlateController.Instance.getBoguCoinCount());
      }
      
      private function __clickQuickBuy(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quickBuyFrame.itemID = EquipType.BOGU_COIN;
         LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __boguOver(param1:MouseEvent) : void
      {
         if(this._isPlaying)
         {
            return;
         }
      }
      
      private function __boguOut(param1:MouseEvent) : void
      {
         if(this._isPlaying)
         {
            return;
         }
      }
      
      private function __clickOneKey(param1:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            this._oneKeyBtn.selected = false;
            BaglockedManager.Instance.show();
            return;
         }
         if(!this.checkClickEnable(0))
         {
            this._oneKeyTurnOn = false;
            this._oneKeyBtn.selected = false;
            return;
         }
         this._boguLiving.gotoAndPlay("up");
         this._clickTooFast = true;
         this.btnsEnable = false;
         if(!this.checkOneKeyCoinEnough())
         {
            this._stopOneKey = true;
         }
         if(param1)
         {
            this._oneKeyTurnOn = !this._oneKeyTurnOn;
         }
         SocketManager.Instance.out.sendTurnPlateStart(true);
      }
      
      private function __clickReflash(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this.checkClickEnable(1))
         {
            return;
         }
         this._boguLiving.gotoAndPlay("down");
         this._clickTooFast = true;
         this.dropGoods();
         SocketManager.Instance.out.sendTurnPlateStop();
         SocketManager.Instance.out.sendTurnPlateReady();
      }
      
      private function __clickBogu(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this.checkClickEnable(2))
         {
            return;
         }
         SharedManager.Instance.turnPlateShowChatBall = false;
         SharedManager.Instance.save();
         if(this._chatballview.parent)
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
         this._clickTooFast = true;
         this.btnsEnable = false;
         SocketManager.Instance.out.sendTurnPlateStart(false);
      }
      
      private function checkClickEnable(param1:uint) : Boolean
      {
         if(this._isPlaying)
         {
            return false;
         }
         if(this._clickTooFast)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityState.getAward.click"));
            return false;
         }
         if(param1 == 1)
         {
            if(ServerConfigManager.instance.getTurnPlateRefreshGold() > PlayerManager.Instance.Self.Gold)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.lessGoldmsg"));
               return false;
            }
         }
         else if(int(this._currentOwnTxt.text) < int(this._openNeedTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.turnplate.notEnoughCoin"));
            this.__clickQuickBuy(new MouseEvent(MouseEvent.CLICK));
            return false;
         }
         return true;
      }
      
      private function __plateReady(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:TurnPlateShowCell = null;
         var _loc6_:TurnPlateShowCell = null;
         var _loc7_:Sprite = null;
         var _loc8_:InventoryItemInfo = null;
         var _loc9_:Boolean = false;
         this._clickTooFast = false;
         this._currentOpenIndex = 0;
         this.reflashCostTxt();
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         if(this._randomCellsList)
         {
            for each(_loc5_ in this._randomCellsList)
            {
               _loc5_.dispose();
            }
         }
         this._randomCellsList = new Vector.<TurnPlateShowCell>();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = this.createCellBg(51);
            _loc8_ = new InventoryItemInfo();
            _loc8_.TemplateID = _loc2_.readInt();
            _loc8_.Count = _loc2_.readInt();
            ItemManager.fill(_loc8_);
            _loc6_ = new TurnPlateShowCell(_loc7_);
            _loc9_ = _loc2_.readBoolean();
            if(_loc9_)
            {
               _loc6_.showSpecial();
            }
            _loc6_.isShowCount = true;
            _loc6_.index = _loc4_;
            _loc6_.info = _loc8_;
            this._randomCellsList.push(_loc6_);
            _loc4_++;
         }
         this.clearRandomCells();
         this.addRandomCells();
         this.btnsEnable = true;
         if(this._oneKeyTurnOn)
         {
            this.__clickOneKey();
         }
      }
      
      private function __randomBoxHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:TurnPlateShowCell = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:BaseCell = null;
         var _loc11_:InventoryItemInfo = null;
         var _loc12_:TurnPlateShowCell = null;
         this._starShine.gotoAndStop("playing");
         this._clickTooFast = false;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         if(_loc4_ == 0)
         {
            this.btnsEnable = true;
            return;
         }
         if(!_loc3_)
         {
            this._boguLiving.gotoAndPlay("renew");
            ++this._currentOpenIndex;
            this._currentItemId = _loc2_.readInt();
            this._currentItemCount = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            for each(_loc6_ in this._randomCellsList)
            {
               if(_loc6_.info.TemplateID == this._currentItemId && _loc6_.itemInfo.Count == this._currentItemCount)
               {
                  this._endCellIndex = this._randomCellsList.indexOf(_loc6_);
                  break;
               }
            }
            this._currentCellIndex = this._endCellIndex;
            _loc7_ = 7 + int(Math.random() * 3);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               this.minRandomIndex();
               this._beginSlowIndex = this._currentCellIndex;
               _loc8_++;
            }
            this.startRandomMove();
         }
         else
         {
            _loc9_ = 0;
            while(_loc9_ < _loc4_)
            {
               for each(_loc10_ in this._rewardItemCellList)
               {
                  if(!_loc10_.info)
                  {
                     _loc11_ = new InventoryItemInfo();
                     _loc11_.TemplateID = _loc2_.readInt();
                     _loc11_.Count = _loc2_.readInt();
                     _loc5_ = _loc2_.readInt();
                     ItemManager.fill(_loc11_);
                     _loc10_.info = _loc11_;
                     for each(_loc12_ in this._randomCellsList)
                     {
                        if(_loc12_.info)
                        {
                           if(_loc12_.info.TemplateID == _loc11_.TemplateID && _loc12_.itemInfo.Count == _loc11_.Count)
                           {
                              _loc12_.info = null;
                              _loc12_.enable = false;
                              this._randomCellsList.splice(this._randomCellsList.indexOf(_loc12_),1);
                              break;
                           }
                        }
                     }
                     break;
                  }
               }
               _loc9_++;
            }
            this._currentOpenIndex += _loc4_;
            this._saveEndCellIndex = 0;
            this.reflashCostTxt();
            if(this._stopOneKey)
            {
               this._oneKeyBtn.selected = false;
               this._stopOneKey = false;
               this._oneKeyTurnOn = false;
            }
            this._checkFullTimeout = setTimeout(this.checkRewardItemIsFull,2000,true);
         }
      }
      
      private function checkRewardItemIsFull(param1:Boolean = false) : void
      {
         var _loc3_:BaseCell = null;
         var _loc2_:Boolean = true;
         for each(_loc3_ in this._rewardItemCellList)
         {
            if(!_loc3_.info)
            {
               _loc2_ = false;
               break;
            }
         }
         if(_loc2_)
         {
            this.dropGoods();
            this._saveEndCellIndex = 0;
            this.btnsEnable = false;
            SocketManager.Instance.out.sendTurnPlateStop();
            SocketManager.Instance.out.sendTurnPlateReady();
         }
         else if(param1)
         {
            this.btnsEnable = true;
         }
         this._starShine.gotoAndStop("waiting");
      }
      
      private function dropGoods() : void
      {
         var _loc2_:BaseCell = null;
         var _loc3_:ItemTemplateInfo = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._rewardItemCellList)
         {
            if(_loc2_.info)
            {
               _loc3_ = ItemManager.Instance.getTemplateById(_loc2_.info.TemplateID);
               _loc1_.push(_loc3_);
               _loc2_.info = null;
            }
         }
         if(_loc1_.length > 0)
         {
            DropGoodsManager.play(_loc1_);
         }
      }
      
      private function startRandomMove() : void
      {
         this._startMoveTimer = new Timer(this.SPEED,20);
         this._startMoveTimer.addEventListener(TimerEvent.TIMER,this.__randomMove);
         this._startMoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__findBeginSlowIndex);
         this._currentCellIndex = this._saveEndCellIndex;
         this._startMoveTimer.start();
      }
      
      private function __randomMove(param1:TimerEvent) : void
      {
         SoundManager.instance.play("130");
         this._randomCellsList[this._currentCellIndex].choosenAnima();
         this.addRandomIndex();
      }
      
      private function __findBeginSlowIndex(param1:TimerEvent) : void
      {
         this._startMoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__randomMove);
         this._startMoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__findBeginSlowIndex);
         this._startMoveTimer = null;
         this._findEndIndexTimer = new Timer(this.SPEED);
         this._findEndIndexTimer.addEventListener(TimerEvent.TIMER,this.__finding);
         this._findEndIndexTimer.start();
      }
      
      private function __finding(param1:TimerEvent) : void
      {
         if(this._currentCellIndex != this._beginSlowIndex)
         {
            SoundManager.instance.play("130");
            this._randomCellsList[this._currentCellIndex].choosenAnima();
            this.addRandomIndex();
         }
         else
         {
            this._findEndIndexTimer.removeEventListener(TimerEvent.TIMER,this.__finding);
            this._findEndIndexTimer = null;
            this._slowSoundIndex = 0;
            this._slowDelay = 100;
            this._slowTimeout = setTimeout(this.beginToSlow,this._slowDelay);
         }
      }
      
      private function beginToSlow() : void
      {
         if(this._currentCellIndex != this._endCellIndex)
         {
            SoundManager.instance.play(this._slowSound[this._slowSoundIndex]);
            ++this._slowSoundIndex;
            this._randomCellsList[this._currentCellIndex].choosenAnima();
            this.addRandomIndex();
            this._slowDelay += this.ACCELERATION;
            this._slowTimeout = setTimeout(this.beginToSlow,this._slowDelay);
         }
         else
         {
            this._randomCellsList[this._endCellIndex].addEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE,this.__itemShineComplete);
            this._randomCellsList[this._endCellIndex].shine(6);
            SoundManager.instance.play("135",false,true,3);
         }
      }
      
      private function __itemShineComplete(param1:Event) : void
      {
         this._randomCellsList[this._endCellIndex].removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE,this.__itemShineComplete);
         this._randomCellsList[this._endCellIndex].info = null;
         this._randomCellsList[this._endCellIndex].enable = false;
         if(this._moveAnimaCell)
         {
            this._moveAnimaCell.removeEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE,this.__equipShineComplete);
            ObjectUtils.disposeObject(this._moveAnimaCell);
            this._moveAnimaCell = null;
         }
         var _loc2_:Sprite = this.createCellBg(51);
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         _loc3_.TemplateID = this._currentItemId;
         _loc3_.Count = this._currentItemCount;
         ItemManager.fill(_loc3_);
         this._moveAnimaCell = new TurnPlateShowCell(_loc2_,_loc3_);
         var _loc4_:Point = this._randomCellsList[this._endCellIndex].localToGlobal(new Point(0,0));
         PositionUtils.setPos(this._moveAnimaCell,_loc4_);
         LayerManager.Instance.addToLayer(this._moveAnimaCell,LayerManager.GAME_TOP_LAYER);
         TweenPlugin.activate([TransformAroundCenterPlugin]);
         TweenLite.to(this._moveAnimaCell,0.5,{
            "transformAroundCenter":{
               "scaleX":1.5,
               "scaleY":1.5
            },
            "onComplete":this.itemScaleComplete
         });
         this._moveAnimaCell.addEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE,this.__equipShineComplete);
         this._moveAnimaCell.showEquipShine();
         SoundManager.instance.play("125");
         this._saveEndCellIndex = this._endCellIndex;
         this._randomCellsList.splice(this._endCellIndex,1);
      }
      
      private function itemScaleComplete() : void
      {
         TweenLite.killTweensOf(this._moveAnimaCell);
      }
      
      private function __equipShineComplete(param1:Event) : void
      {
         var _loc3_:BaseCell = null;
         this._moveAnimaCell.removeEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE,this.__equipShineComplete);
         var _loc2_:Point = new Point(0,0);
         for each(_loc3_ in this._rewardItemCellList)
         {
            if(!_loc3_.info)
            {
               _loc2_ = _loc3_.localToGlobal(new Point(0,0));
               break;
            }
         }
         TweenLite.to(this._moveAnimaCell,0.5,{
            "x":_loc2_.x,
            "y":_loc2_.y,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.itemMoveToButtomComplete
         });
         this.reflashCostTxt();
      }
      
      private function itemMoveToButtomComplete() : void
      {
         this.btnsEnable = true;
         TweenLite.killTweensOf(this._moveAnimaCell);
         SoundManager.instance.play("205");
         this._moveAnimaCell.addEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE,this.__bottomItemShineComplete);
         this._moveAnimaCell.shine(4);
      }
      
      private function __bottomItemShineComplete(param1:Event) : void
      {
         this._moveAnimaCell.removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE,this.__bottomItemShineComplete);
         this.manualFillRewardItem(this._moveAnimaCell.info.TemplateID,this._moveAnimaCell.itemInfo.Count);
         ObjectUtils.disposeObject(this._moveAnimaCell);
         this._moveAnimaCell = null;
         this._checkFullTimeout = setTimeout(this.checkRewardItemIsFull,1000);
      }
      
      public function forcibleClose() : void
      {
         var _loc1_:InventoryItemInfo = null;
         if(this._moveAnimaCell)
         {
            this.manualFillRewardItem(this._moveAnimaCell.info.TemplateID,this._moveAnimaCell.itemInfo.Count);
         }
         else if(this._startMoveTimer || this._findEndIndexTimer)
         {
            this.manualFillRewardItem(this._currentItemId,this._currentItemCount);
         }
         this.dropGoods();
         SocketManager.Instance.out.sendTurnPlateStop();
         TurnPlateController.Instance.hide();
      }
      
      private function manualFillRewardItem(param1:int, param2:int = 1) : void
      {
         var _loc3_:BaseCell = null;
         var _loc4_:InventoryItemInfo = null;
         for each(_loc3_ in this._rewardItemCellList)
         {
            if(!_loc3_.info)
            {
               _loc4_ = new InventoryItemInfo();
               _loc4_.TemplateID = param1;
               _loc4_.Count = param2;
               ItemManager.fill(_loc4_);
               _loc3_.info = _loc4_;
               break;
            }
         }
      }
      
      public function addHistoryMessage(param1:Vector.<FilterFrameText>) : void
      {
         if(!this._rewardHistoryVBox)
         {
            return;
         }
         this._rewardHistoryVBox.beginChanges();
         this._rewardHistoryVBox.disposeAllChildren();
         var _loc2_:int = param1.length - 1;
         while(_loc2_ >= 0)
         {
            this._rewardHistoryVBox.addChild(param1[_loc2_]);
            _loc2_--;
         }
         this._rewardHistoryVBox.commitChanges();
         this._rewardHistoryPanel.invalidateViewport();
      }
      
      public function set btnsEnable(param1:Boolean) : void
      {
         this._isPlaying = !param1;
         if(!this._oneKeyBtn.selected)
         {
            this._oneKeyBtn.enable = param1;
         }
         this._reflashBtn.enable = param1;
         this._quickBuyBtn.enable = param1;
         this._boguClickArea.buttonMode = param1;
         this._boguClickArea.useHandCursor = param1;
         if(!param1)
         {
            this._lastPressTime = TimeManager.Instance.Now().time;
         }
      }
      
      private function createCellBg(param1:uint) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawRect(0,0,param1,param1);
         _loc2_.graphics.endFill();
         return _loc2_;
      }
      
      private function reflashCostTxt() : void
      {
         if(this._currentOpenIndex > 7)
         {
            this._currentOpenIndex = 0;
         }
         this._openNeedTxt.text = ServerConfigManager.instance.getTurnPlateCost()[this._currentOpenIndex].split(",")[1];
      }
      
      private function checkOneKeyCoinEnough() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = ServerConfigManager.instance.getTurnPlateCost();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ += int(_loc2_[_loc3_].split(",")[1]);
            _loc3_++;
         }
         if(TurnPlateController.Instance.getBoguCoinCount() >= _loc1_)
         {
            return true;
         }
         return false;
      }
      
      private function addRandomIndex() : void
      {
         ++this._currentCellIndex;
         if(this._currentCellIndex > this._randomCellsList.length - 1)
         {
            this._currentCellIndex = 0;
         }
      }
      
      private function minRandomIndex() : void
      {
         --this._currentCellIndex;
         if(this._currentCellIndex < 0)
         {
            this._currentCellIndex = this._randomCellsList.length - 1;
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._helpBtn && _closeButton)
         {
            this._helpBtn.x = _closeButton.x - this._helpBtn.width;
            this._helpBtn.y = _closeButton.y;
            addChild(this._helpBtn);
         }
      }
      
      override public function dispose() : void
      {
         TweenLite.killTweensOf(this._moveAnimaCell);
         clearTimeout(this._slowTimeout);
         clearTimeout(this._checkFullTimeout);
         this.removeEvent();
         TurnPlateController.Instance.clearHistoryList();
         ObjectUtils.disposeObject(this._titleBmp);
         this._titleBmp = null;
         ObjectUtils.disposeObject(this._plateBg);
         this._plateBg = null;
         ObjectUtils.disposeObject(this._plateCells);
         this._plateCells = null;
         ObjectUtils.disposeObject(this._rewardListBg);
         this._rewardListBg = null;
         ObjectUtils.disposeObject(this._rewardItemBg);
         this._rewardItemBg = null;
         ObjectUtils.disposeObject(this._starShine);
         this._starShine = null;
         ObjectUtils.disposeObject(this._boguLiving);
         this._boguLiving = null;
         ObjectUtils.disposeObject(this._rewardTitle);
         this._rewardTitle = null;
         ObjectUtils.disposeObject(this._rewardTitleTxt);
         this._rewardTitleTxt = null;
         ObjectUtils.disposeObject(this._rewardCellHBox);
         this._rewardCellHBox = null;
         this._rewardItemCellList = null;
         ObjectUtils.disposeObject(this._openNeedTxt);
         this._openNeedTxt = null;
         ObjectUtils.disposeObject(this._currentOwnTxt);
         this._currentOwnTxt = null;
         if(this._rewardHistoryVBox)
         {
            ObjectUtils.removeChildAllChildren(this._rewardHistoryVBox);
         }
         this._rewardHistoryVBox = null;
         ObjectUtils.disposeObject(this._rewardHistoryPanel);
         this._rewardHistoryPanel = null;
         ObjectUtils.disposeObject(this._oneKeyBtn);
         this._oneKeyBtn = null;
         ObjectUtils.disposeObject(this._reflashBtn);
         this._reflashBtn = null;
         ObjectUtils.disposeObject(this._randomCellsHBoxI);
         this._randomCellsHBoxI = null;
         ObjectUtils.disposeObject(this._randomCellsHBoxII);
         this._randomCellsHBoxII = null;
         ObjectUtils.disposeObject(this._randomCellsVBoxI);
         this._randomCellsVBoxI = null;
         ObjectUtils.disposeObject(this._randomCellsVBoxII);
         this._randomCellsVBoxII = null;
         this._randomCellsList = null;
         ObjectUtils.disposeObject(this._boguClickArea);
         this._boguClickArea = null;
         ObjectUtils.disposeObject(this._chatballview);
         this._chatballview = null;
         ObjectUtils.disposeObject(this._startMoveTimer);
         this._startMoveTimer = null;
         ObjectUtils.disposeObject(this._findEndIndexTimer);
         this._findEndIndexTimer = null;
         ObjectUtils.disposeObject(this._quickBuyBtn);
         this._quickBuyBtn = null;
         ObjectUtils.disposeObject(this._moveAnimaCell);
         this._moveAnimaCell = null;
         ObjectUtils.disposeObject(this._quickBuyFrame);
         this._quickBuyFrame = null;
         ObjectUtils.disposeObject(this._slowSound);
         this._slowSound = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         super.dispose();
      }
   }
}
