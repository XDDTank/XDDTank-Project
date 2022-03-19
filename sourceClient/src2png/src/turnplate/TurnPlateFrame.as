// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//turnplate.TurnPlateFrame

package turnplate
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.HBox;
    import __AS3__.vec.Vector;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Sprite;
    import ddt.view.chat.chatBall.ChatBallAlways;
    import flash.utils.Timer;
    import ddt.command.QuickBuyFrame;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.SharedManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import ddt.manager.TimeManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import ddt.manager.PathManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import flash.events.TimerEvent;
    import store.HelpPrompt;
    import store.HelpFrame;
    import baglocked.BaglockedManager;
    import ddt.data.EquipType;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.comm.PackageIn;
    import ddt.manager.ItemManager;
    import flash.utils.setTimeout;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.DropGoodsManager;
    import flash.geom.Point;
    import com.greensock.plugins.TweenPlugin;
    import com.greensock.plugins.TransformAroundCenterPlugin;
    import com.greensock.TweenLite;
    import flash.utils.clearTimeout;
    import __AS3__.vec.*;

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
        private var _slowSound:Array = ["130", "131", "133", "132", "135", "134", "129", "128", "127", "132", "135", "134", "129", "128", "127"];
        private var _slowSoundIndex:uint;
        private var _livingLoader:BaseLoader;
        private var _stopOneKey:Boolean;
        private var _oneKeyTurnOn:Boolean;

        public function TurnPlateFrame()
        {
            this._helpBtn = ComponentFactory.Instance.creat("baseHelpBtn");
            escEnable = true;
        }

        private function initView():void
        {
            var _local_2:Scale9CornerImage;
            var _local_3:BaseCell;
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.turnplate.frameTitle");
            this._plateBg = ComponentFactory.Instance.creatBitmap("asset.turnplate.plateBg");
            this._plateCells = ComponentFactory.Instance.creatBitmap("asset.turnplate.plateCells");
            this._rewardListBg = ComponentFactory.Instance.creatBitmap("asset.turnplate.rewardHistoryBg");
            this._rewardItemBg = ComponentFactory.Instance.creatComponentByStylename("turnplate.getItemBg");
            this._starShine = ComponentFactory.Instance.creat("asset.turnplate.starShine");
            PositionUtils.setPos(this._starShine, "turnPlate.starShine.Pos");
            this._boguLiving = ComponentFactory.Instance.creat("game.living.turnplate");
            this._boguLiving.scaleX = (this._boguLiving.scaleY = 0.9);
            PositionUtils.setPos(this._boguLiving, "turnPlate.boguLiving.Pos");
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
            this._reflashBtn.tipData = LanguageMgr.GetTranslation("ddt.turnplate.reflashBtn.tips.txt", ServerConfigManager.instance.getTurnPlateRefreshGold());
            this._randomCellsHBoxI = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsHBox");
            this._randomCellsHBoxII = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsHBox");
            this._randomCellsVBoxI = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsVBox");
            this._randomCellsVBoxII = ComponentFactory.Instance.creatComponentByStylename("turnplate.randomCellsVBox");
            PositionUtils.setPos(this._randomCellsHBoxII, "turnPlate.randomCellHboxII.Pos");
            PositionUtils.setPos(this._randomCellsVBoxII, "turnPlate.randomCellVboxII.Pos");
            this._boguClickArea = new Sprite();
            this._boguClickArea.graphics.beginFill(0, 0);
            this._boguClickArea.graphics.drawRect(0, 0, 155, 160);
            this._boguClickArea.graphics.endFill();
            this._boguClickArea.buttonMode = true;
            this._boguClickArea.useHandCursor = true;
            PositionUtils.setPos(this._boguClickArea, "turnPlate.boguClickArea.Pos");
            this._chatballview = new ChatBallAlways();
            this._chatballview.setText(LanguageMgr.GetTranslation("ddt.turnplate.chatBall.txt"));
            PositionUtils.setPos(this._chatballview, "turnPlate.chatBall.Pos");
            this._chatballview.show();
            this._quickBuyBtn = ComponentFactory.Instance.creatComponentByStylename("turnplate.quickBuyBtn");
            this._currentOpenIndex = 0;
            addToContent(this._titleBmp);
            addToContent(this._plateBg);
            addToContent(this._boguLiving);
            if (SharedManager.Instance.turnPlateShowChatBall)
            {
                addToContent(this._chatballview);
            };
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
            var _local_1:uint;
            while (_local_1 < 8)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("turnplate.rewardItemBg");
                _local_3 = new BaseCell(_local_2);
                _local_3.isShowCount = true;
                this._rewardItemCellList.push(_local_3);
                this._rewardCellHBox.addChild(_local_3);
                _local_1++;
            };
        }

        private function addRandomCells():void
        {
            var _local_1:uint;
            _local_1 = 0;
            while (_local_1 < 6)
            {
                this._randomCellsHBoxI.addChild(this._randomCellsList[_local_1]);
                _local_1++;
            };
            _local_1 = 6;
            while (_local_1 < 9)
            {
                this._randomCellsVBoxI.addChild(this._randomCellsList[_local_1]);
                _local_1++;
            };
            _local_1 = 14;
            while (_local_1 > 8)
            {
                this._randomCellsHBoxII.addChild(this._randomCellsList[_local_1]);
                _local_1--;
            };
            _local_1 = 17;
            while (_local_1 > 14)
            {
                this._randomCellsVBoxII.addChild(this._randomCellsList[_local_1]);
                _local_1--;
            };
        }

        private function clearRandomCells():void
        {
            ObjectUtils.disposeAllChildren(this._randomCellsHBoxI);
            ObjectUtils.disposeAllChildren(this._randomCellsVBoxI);
            ObjectUtils.disposeAllChildren(this._randomCellsHBoxII);
            ObjectUtils.disposeAllChildren(this._randomCellsVBoxII);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((this._isPlaying) && ((TimeManager.Instance.Now().time - this._lastPressTime) < 10000)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.turnplate.isTurning"));
                return;
            };
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.forcibleClose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHAT_BALL);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TURN_PLATE);
        }

        private function __onUIComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.CHAT_BALL)
            {
                this._chatBallComplete = true;
            };
            if (_arg_1.module == UIModuleTypes.TURN_PLATE)
            {
                this._turnplateComplete = true;
            };
            if (((this._chatBallComplete) && (this._turnplateComplete)))
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
                this.loadResFile(PathManager.solveGameLivingPath("living004"), BaseLoader.MODULE_LOADER);
            };
        }

        private function __onUIProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function loadLivingComplete(_arg_1:LoaderEvent):void
        {
            this.__onClose();
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this.initView();
            this.initEvent();
            TurnPlateController.Instance.isFrameOpen = true;
            SocketManager.Instance.out.sendRequestAwards(3);
            SocketManager.Instance.out.sendTurnPlateReady();
        }

        private function loadResFile(_arg_1:String, _arg_2:int):void
        {
            this._livingLoader = LoadResourceManager.instance.createLoader(_arg_1, _arg_2);
            this._livingLoader.addEventListener(LoaderEvent.COMPLETE, this.loadLivingComplete);
            this._livingLoader.addEventListener(LoaderEvent.PROGRESS, this.__uiProgress);
            LoadResourceManager.instance.startLoad(this._livingLoader);
        }

        private function __uiProgress(_arg_1:LoaderEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private function __onClose(_arg_1:Event=null):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
            if (this._livingLoader)
            {
                this._livingLoader.removeEventListener(LoaderEvent.COMPLETE, this.loadLivingComplete);
                this._livingLoader.removeEventListener(LoaderEvent.PROGRESS, this.__uiProgress);
            };
            if (_arg_1)
            {
                TurnPlateController.Instance.hide();
            };
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_START, this.__plateReady);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_RANDOM, this.__randomBoxHandler);
            this._oneKeyBtn.addEventListener(MouseEvent.CLICK, this.__clickOneKey);
            this._reflashBtn.addEventListener(MouseEvent.CLICK, this.__clickReflash);
            this._boguClickArea.addEventListener(MouseEvent.CLICK, this.__clickBogu);
            this._boguClickArea.addEventListener(MouseEvent.ROLL_OVER, this.__boguOver);
            this._boguClickArea.addEventListener(MouseEvent.ROLL_OUT, this.__boguOut);
            this._quickBuyBtn.addEventListener(MouseEvent.CLICK, this.__clickQuickBuy);
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__updateBag);
            this._helpBtn.addEventListener(MouseEvent.CLICK, this.__helpClick);
        }

        private function removeEvent():void
        {
            var _local_1:TurnPlateShowCell;
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_START, this.__plateReady);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_RANDOM, this.__randomBoxHandler);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__updateBag);
            if (this._helpBtn)
            {
                this._helpBtn.removeEventListener(MouseEvent.CLICK, this.__helpClick);
            };
            if (this._oneKeyBtn)
            {
                this._oneKeyBtn.removeEventListener(MouseEvent.CLICK, this.__clickOneKey);
            };
            if (this._reflashBtn)
            {
                this._reflashBtn.removeEventListener(MouseEvent.CLICK, this.__clickReflash);
            };
            if (this._boguClickArea)
            {
                this._boguClickArea.removeEventListener(MouseEvent.CLICK, this.__clickBogu);
                this._boguClickArea.removeEventListener(MouseEvent.ROLL_OVER, this.__boguOver);
                this._boguClickArea.removeEventListener(MouseEvent.ROLL_OUT, this.__boguOut);
            };
            if (this._quickBuyBtn)
            {
                this._quickBuyBtn.removeEventListener(MouseEvent.CLICK, this.__clickQuickBuy);
            };
            if (this._startMoveTimer)
            {
                this._startMoveTimer.removeEventListener(TimerEvent.TIMER, this.__randomMove);
                this._startMoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__findBeginSlowIndex);
            };
            if (this._findEndIndexTimer)
            {
                this._findEndIndexTimer.removeEventListener(TimerEvent.TIMER, this.__finding);
            };
            if (this._moveAnimaCell)
            {
                this._moveAnimaCell.removeEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE, this.__equipShineComplete);
                this._moveAnimaCell.removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE, this.__bottomItemShineComplete);
            };
            for each (_local_1 in this._randomCellsList)
            {
                _local_1.removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE, this.__itemShineComplete);
            };
        }

        protected function __helpClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            var _local_2:HelpPrompt = ComponentFactory.Instance.creat("turnPlate.ComposeHelpPrompt");
            var _local_3:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_3.setView(_local_2);
            _local_3.titleText = LanguageMgr.GetTranslation("ddt.turnplate.chatName.txt");
            LayerManager.Instance.addToLayer(_local_3, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __updateBag(_arg_1:BagEvent):void
        {
            this._currentOwnTxt.text = String(TurnPlateController.Instance.getBoguCoinCount());
        }

        private function __clickQuickBuy(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            this._quickBuyFrame.itemID = EquipType.BOGU_COIN;
            LayerManager.Instance.addToLayer(this._quickBuyFrame, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __boguOver(_arg_1:MouseEvent):void
        {
            if (this._isPlaying)
            {
                return;
            };
        }

        private function __boguOut(_arg_1:MouseEvent):void
        {
            if (this._isPlaying)
            {
                return;
            };
        }

        private function __clickOneKey(_arg_1:MouseEvent=null):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                this._oneKeyBtn.selected = false;
                BaglockedManager.Instance.show();
                return;
            };
            if ((!(this.checkClickEnable(0))))
            {
                this._oneKeyTurnOn = false;
                this._oneKeyBtn.selected = false;
                return;
            };
            this._boguLiving.gotoAndPlay("up");
            this._clickTooFast = true;
            this.btnsEnable = false;
            if ((!(this.checkOneKeyCoinEnough())))
            {
                this._stopOneKey = true;
            };
            if (_arg_1)
            {
                this._oneKeyTurnOn = (!(this._oneKeyTurnOn));
            };
            SocketManager.Instance.out.sendTurnPlateStart(true);
        }

        private function __clickReflash(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if ((!(this.checkClickEnable(1))))
            {
                return;
            };
            this._boguLiving.gotoAndPlay("down");
            this._clickTooFast = true;
            this.dropGoods();
            SocketManager.Instance.out.sendTurnPlateStop();
            SocketManager.Instance.out.sendTurnPlateReady();
        }

        private function __clickBogu(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if ((!(this.checkClickEnable(2))))
            {
                return;
            };
            SharedManager.Instance.turnPlateShowChatBall = false;
            SharedManager.Instance.save();
            if (this._chatballview.parent)
            {
                this._chatballview.parent.removeChild(this._chatballview);
            };
            this._clickTooFast = true;
            this.btnsEnable = false;
            SocketManager.Instance.out.sendTurnPlateStart(false);
        }

        private function checkClickEnable(_arg_1:uint):Boolean
        {
            if (this._isPlaying)
            {
                return (false);
            };
            if (this._clickTooFast)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityState.getAward.click"));
                return (false);
            };
            if (_arg_1 == 1)
            {
                if (ServerConfigManager.instance.getTurnPlateRefreshGold() > PlayerManager.Instance.Self.Gold)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.lessGoldmsg"));
                    return (false);
                };
            }
            else
            {
                if (int(this._currentOwnTxt.text) < int(this._openNeedTxt.text))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.turnplate.notEnoughCoin"));
                    this.__clickQuickBuy(new MouseEvent(MouseEvent.CLICK));
                    return (false);
                };
            };
            return (true);
        }

        private function __plateReady(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:TurnPlateShowCell;
            var _local_6:TurnPlateShowCell;
            var _local_7:Sprite;
            var _local_8:InventoryItemInfo;
            var _local_9:Boolean;
            this._clickTooFast = false;
            this._currentOpenIndex = 0;
            this.reflashCostTxt();
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            if (this._randomCellsList)
            {
                for each (_local_5 in this._randomCellsList)
                {
                    _local_5.dispose();
                };
            };
            this._randomCellsList = new Vector.<TurnPlateShowCell>();
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_7 = this.createCellBg(51);
                _local_8 = new InventoryItemInfo();
                _local_8.TemplateID = _local_2.readInt();
                _local_8.Count = _local_2.readInt();
                ItemManager.fill(_local_8);
                _local_6 = new TurnPlateShowCell(_local_7);
                _local_9 = _local_2.readBoolean();
                if (_local_9)
                {
                    _local_6.showSpecial();
                };
                _local_6.isShowCount = true;
                _local_6.index = _local_4;
                _local_6.info = _local_8;
                this._randomCellsList.push(_local_6);
                _local_4++;
            };
            this.clearRandomCells();
            this.addRandomCells();
            this.btnsEnable = true;
            if (this._oneKeyTurnOn)
            {
                this.__clickOneKey();
            };
        }

        private function __randomBoxHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:int;
            var _local_6:TurnPlateShowCell;
            var _local_7:uint;
            var _local_8:uint;
            var _local_9:uint;
            var _local_10:BaseCell;
            var _local_11:InventoryItemInfo;
            var _local_12:TurnPlateShowCell;
            this._starShine.gotoAndStop("playing");
            this._clickTooFast = false;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Boolean = _local_2.readBoolean();
            var _local_4:int = _local_2.readInt();
            if (_local_4 == 0)
            {
                this.btnsEnable = true;
                return;
            };
            if ((!(_local_3)))
            {
                this._boguLiving.gotoAndPlay("renew");
                this._currentOpenIndex++;
                this._currentItemId = _local_2.readInt();
                this._currentItemCount = _local_2.readInt();
                _local_5 = _local_2.readInt();
                for each (_local_6 in this._randomCellsList)
                {
                    if (((_local_6.info.TemplateID == this._currentItemId) && (_local_6.itemInfo.Count == this._currentItemCount)))
                    {
                        this._endCellIndex = this._randomCellsList.indexOf(_local_6);
                        break;
                    };
                };
                this._currentCellIndex = this._endCellIndex;
                _local_7 = (7 + int((Math.random() * 3)));
                _local_8 = 0;
                while (_local_8 < _local_7)
                {
                    this.minRandomIndex();
                    this._beginSlowIndex = this._currentCellIndex;
                    _local_8++;
                };
                this.startRandomMove();
            }
            else
            {
                _local_9 = 0;
                while (_local_9 < _local_4)
                {
                    for each (_local_10 in this._rewardItemCellList)
                    {
                        if ((!(_local_10.info)))
                        {
                            _local_11 = new InventoryItemInfo();
                            _local_11.TemplateID = _local_2.readInt();
                            _local_11.Count = _local_2.readInt();
                            _local_5 = _local_2.readInt();
                            ItemManager.fill(_local_11);
                            _local_10.info = _local_11;
                            for each (_local_12 in this._randomCellsList)
                            {
                                if (_local_12.info)
                                {
                                    if (((_local_12.info.TemplateID == _local_11.TemplateID) && (_local_12.itemInfo.Count == _local_11.Count)))
                                    {
                                        _local_12.info = null;
                                        _local_12.enable = false;
                                        this._randomCellsList.splice(this._randomCellsList.indexOf(_local_12), 1);
                                        break;
                                    };
                                };
                            };
                            break;
                        };
                    };
                    _local_9++;
                };
                this._currentOpenIndex = (this._currentOpenIndex + _local_4);
                this._saveEndCellIndex = 0;
                this.reflashCostTxt();
                if (this._stopOneKey)
                {
                    this._oneKeyBtn.selected = false;
                    this._stopOneKey = false;
                    this._oneKeyTurnOn = false;
                };
                this._checkFullTimeout = setTimeout(this.checkRewardItemIsFull, 2000, true);
            };
        }

        private function checkRewardItemIsFull(_arg_1:Boolean=false):void
        {
            var _local_3:BaseCell;
            var _local_2:Boolean = true;
            for each (_local_3 in this._rewardItemCellList)
            {
                if ((!(_local_3.info)))
                {
                    _local_2 = false;
                    break;
                };
            };
            if (_local_2)
            {
                this.dropGoods();
                this._saveEndCellIndex = 0;
                this.btnsEnable = false;
                SocketManager.Instance.out.sendTurnPlateStop();
                SocketManager.Instance.out.sendTurnPlateReady();
            }
            else
            {
                if (_arg_1)
                {
                    this.btnsEnable = true;
                };
            };
            this._starShine.gotoAndStop("waiting");
        }

        private function dropGoods():void
        {
            var _local_2:BaseCell;
            var _local_3:ItemTemplateInfo;
            var _local_1:Array = new Array();
            for each (_local_2 in this._rewardItemCellList)
            {
                if (_local_2.info)
                {
                    _local_3 = ItemManager.Instance.getTemplateById(_local_2.info.TemplateID);
                    _local_1.push(_local_3);
                    _local_2.info = null;
                };
            };
            if (_local_1.length > 0)
            {
                DropGoodsManager.play(_local_1);
            };
        }

        private function startRandomMove():void
        {
            this._startMoveTimer = new Timer(this.SPEED, 20);
            this._startMoveTimer.addEventListener(TimerEvent.TIMER, this.__randomMove);
            this._startMoveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__findBeginSlowIndex);
            this._currentCellIndex = this._saveEndCellIndex;
            this._startMoveTimer.start();
        }

        private function __randomMove(_arg_1:TimerEvent):void
        {
            SoundManager.instance.play("130");
            this._randomCellsList[this._currentCellIndex].choosenAnima();
            this.addRandomIndex();
        }

        private function __findBeginSlowIndex(_arg_1:TimerEvent):void
        {
            this._startMoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__randomMove);
            this._startMoveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__findBeginSlowIndex);
            this._startMoveTimer = null;
            this._findEndIndexTimer = new Timer(this.SPEED);
            this._findEndIndexTimer.addEventListener(TimerEvent.TIMER, this.__finding);
            this._findEndIndexTimer.start();
        }

        private function __finding(_arg_1:TimerEvent):void
        {
            if (this._currentCellIndex != this._beginSlowIndex)
            {
                SoundManager.instance.play("130");
                this._randomCellsList[this._currentCellIndex].choosenAnima();
                this.addRandomIndex();
            }
            else
            {
                this._findEndIndexTimer.removeEventListener(TimerEvent.TIMER, this.__finding);
                this._findEndIndexTimer = null;
                this._slowSoundIndex = 0;
                this._slowDelay = 100;
                this._slowTimeout = setTimeout(this.beginToSlow, this._slowDelay);
            };
        }

        private function beginToSlow():void
        {
            if (this._currentCellIndex != this._endCellIndex)
            {
                SoundManager.instance.play(this._slowSound[this._slowSoundIndex]);
                this._slowSoundIndex++;
                this._randomCellsList[this._currentCellIndex].choosenAnima();
                this.addRandomIndex();
                this._slowDelay = (this._slowDelay + this.ACCELERATION);
                this._slowTimeout = setTimeout(this.beginToSlow, this._slowDelay);
            }
            else
            {
                this._randomCellsList[this._endCellIndex].addEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE, this.__itemShineComplete);
                this._randomCellsList[this._endCellIndex].shine(6);
                SoundManager.instance.play("135", false, true, 3);
            };
        }

        private function __itemShineComplete(_arg_1:Event):void
        {
            this._randomCellsList[this._endCellIndex].removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE, this.__itemShineComplete);
            this._randomCellsList[this._endCellIndex].info = null;
            this._randomCellsList[this._endCellIndex].enable = false;
            if (this._moveAnimaCell)
            {
                this._moveAnimaCell.removeEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE, this.__equipShineComplete);
                ObjectUtils.disposeObject(this._moveAnimaCell);
                this._moveAnimaCell = null;
            };
            var _local_2:Sprite = this.createCellBg(51);
            var _local_3:InventoryItemInfo = new InventoryItemInfo();
            _local_3.TemplateID = this._currentItemId;
            _local_3.Count = this._currentItemCount;
            ItemManager.fill(_local_3);
            this._moveAnimaCell = new TurnPlateShowCell(_local_2, _local_3);
            var _local_4:Point = this._randomCellsList[this._endCellIndex].localToGlobal(new Point(0, 0));
            PositionUtils.setPos(this._moveAnimaCell, _local_4);
            LayerManager.Instance.addToLayer(this._moveAnimaCell, LayerManager.GAME_TOP_LAYER);
            TweenPlugin.activate([TransformAroundCenterPlugin]);
            TweenLite.to(this._moveAnimaCell, 0.5, {
                "transformAroundCenter":{
                    "scaleX":1.5,
                    "scaleY":1.5
                },
                "onComplete":this.itemScaleComplete
            });
            this._moveAnimaCell.addEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE, this.__equipShineComplete);
            this._moveAnimaCell.showEquipShine();
            SoundManager.instance.play("125");
            this._saveEndCellIndex = this._endCellIndex;
            this._randomCellsList.splice(this._endCellIndex, 1);
        }

        private function itemScaleComplete():void
        {
            TweenLite.killTweensOf(this._moveAnimaCell);
        }

        private function __equipShineComplete(_arg_1:Event):void
        {
            var _local_3:BaseCell;
            this._moveAnimaCell.removeEventListener(TurnPlateShowCell.EQUIP_SHINE_COMPLETE, this.__equipShineComplete);
            var _local_2:Point = new Point(0, 0);
            for each (_local_3 in this._rewardItemCellList)
            {
                if ((!(_local_3.info)))
                {
                    _local_2 = _local_3.localToGlobal(new Point(0, 0));
                    break;
                };
            };
            TweenLite.to(this._moveAnimaCell, 0.5, {
                "x":_local_2.x,
                "y":_local_2.y,
                "scaleX":1,
                "scaleY":1,
                "onComplete":this.itemMoveToButtomComplete
            });
            this.reflashCostTxt();
        }

        private function itemMoveToButtomComplete():void
        {
            this.btnsEnable = true;
            TweenLite.killTweensOf(this._moveAnimaCell);
            SoundManager.instance.play("205");
            this._moveAnimaCell.addEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE, this.__bottomItemShineComplete);
            this._moveAnimaCell.shine(4);
        }

        private function __bottomItemShineComplete(_arg_1:Event):void
        {
            this._moveAnimaCell.removeEventListener(TurnPlateShowCell.SELECT_SHINE_COMPLETE, this.__bottomItemShineComplete);
            this.manualFillRewardItem(this._moveAnimaCell.info.TemplateID, this._moveAnimaCell.itemInfo.Count);
            ObjectUtils.disposeObject(this._moveAnimaCell);
            this._moveAnimaCell = null;
            this._checkFullTimeout = setTimeout(this.checkRewardItemIsFull, 1000);
        }

        public function forcibleClose():void
        {
            var _local_1:InventoryItemInfo;
            if (this._moveAnimaCell)
            {
                this.manualFillRewardItem(this._moveAnimaCell.info.TemplateID, this._moveAnimaCell.itemInfo.Count);
            }
            else
            {
                if (((this._startMoveTimer) || (this._findEndIndexTimer)))
                {
                    this.manualFillRewardItem(this._currentItemId, this._currentItemCount);
                };
            };
            this.dropGoods();
            SocketManager.Instance.out.sendTurnPlateStop();
            TurnPlateController.Instance.hide();
        }

        private function manualFillRewardItem(_arg_1:int, _arg_2:int=1):void
        {
            var _local_3:BaseCell;
            var _local_4:InventoryItemInfo;
            for each (_local_3 in this._rewardItemCellList)
            {
                if ((!(_local_3.info)))
                {
                    _local_4 = new InventoryItemInfo();
                    _local_4.TemplateID = _arg_1;
                    _local_4.Count = _arg_2;
                    ItemManager.fill(_local_4);
                    _local_3.info = _local_4;
                    break;
                };
            };
        }

        public function addHistoryMessage(_arg_1:Vector.<FilterFrameText>):void
        {
            if ((!(this._rewardHistoryVBox)))
            {
                return;
            };
            this._rewardHistoryVBox.beginChanges();
            this._rewardHistoryVBox.disposeAllChildren();
            var _local_2:int = (_arg_1.length - 1);
            while (_local_2 >= 0)
            {
                this._rewardHistoryVBox.addChild(_arg_1[_local_2]);
                _local_2--;
            };
            this._rewardHistoryVBox.commitChanges();
            this._rewardHistoryPanel.invalidateViewport();
        }

        public function set btnsEnable(_arg_1:Boolean):void
        {
            this._isPlaying = (!(_arg_1));
            if ((!(this._oneKeyBtn.selected)))
            {
                this._oneKeyBtn.enable = _arg_1;
            };
            this._reflashBtn.enable = _arg_1;
            this._quickBuyBtn.enable = _arg_1;
            this._boguClickArea.buttonMode = _arg_1;
            this._boguClickArea.useHandCursor = _arg_1;
            if ((!(_arg_1)))
            {
                this._lastPressTime = TimeManager.Instance.Now().time;
            };
        }

        private function createCellBg(_arg_1:uint):Sprite
        {
            var _local_2:Sprite = new Sprite();
            _local_2.graphics.beginFill(0, 0);
            _local_2.graphics.drawRect(0, 0, _arg_1, _arg_1);
            _local_2.graphics.endFill();
            return (_local_2);
        }

        private function reflashCostTxt():void
        {
            if (this._currentOpenIndex > 7)
            {
                this._currentOpenIndex = 0;
            };
            this._openNeedTxt.text = ServerConfigManager.instance.getTurnPlateCost()[this._currentOpenIndex].split(",")[1];
        }

        private function checkOneKeyCoinEnough():Boolean
        {
            var _local_1:uint;
            var _local_2:Array = ServerConfigManager.instance.getTurnPlateCost();
            var _local_3:uint;
            while (_local_3 < _local_2.length)
            {
                _local_1 = (_local_1 + int(_local_2[_local_3].split(",")[1]));
                _local_3++;
            };
            if (TurnPlateController.Instance.getBoguCoinCount() >= _local_1)
            {
                return (true);
            };
            return (false);
        }

        private function addRandomIndex():void
        {
            this._currentCellIndex++;
            if (this._currentCellIndex > (this._randomCellsList.length - 1))
            {
                this._currentCellIndex = 0;
            };
        }

        private function minRandomIndex():void
        {
            this._currentCellIndex--;
            if (this._currentCellIndex < 0)
            {
                this._currentCellIndex = (this._randomCellsList.length - 1);
            };
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (((this._helpBtn) && (_closeButton)))
            {
                this._helpBtn.x = (_closeButton.x - this._helpBtn.width);
                this._helpBtn.y = _closeButton.y;
                addChild(this._helpBtn);
            };
        }

        override public function dispose():void
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
            if (this._rewardHistoryVBox)
            {
                ObjectUtils.removeChildAllChildren(this._rewardHistoryVBox);
            };
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
}//package turnplate

