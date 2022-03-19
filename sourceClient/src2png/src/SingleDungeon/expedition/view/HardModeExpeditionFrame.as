// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.view.HardModeExpeditionFrame

package SingleDungeon.expedition.view
{
    import com.pickgliss.ui.controls.Frame;
    import SingleDungeon.expedition.IExpeditionFrame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.TextButton;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import SingleDungeon.expedition.ExpeditionController;
    import com.pickgliss.ui.ComponentFactory;
    import SingleDungeon.model.MapSceneModel;
    import SingleDungeon.hardMode.HardModeManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.utils.PositionUtils;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import SingleDungeon.expedition.msg.FightMsgItem;
    import SingleDungeon.expedition.msg.FightMsgInfo;
    import SingleDungeon.SingleDungeonManager;
    import SingleDungeon.event.SingleDungeonEvent;
    import com.pickgliss.events.FrameEvent;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class HardModeExpeditionFrame extends Frame implements IExpeditionFrame 
    {

        private static var NORMAL:int = -1;
        private static var START:int = 1;
        private static var ACCELERATE:int = 2;
        private static var STOP:int = 3;
        private static var UPDATE:int = 4;
        private static var HARD_MODE_START:int = 5;

        private var _headBg:Scale9CornerImage;
        private var _downBg:MutipleImage;
        private var _headExplain:Bitmap;
        private var _headExplainText:FilterFrameText;
        private var _mapNameText:FilterFrameText;
        private var _mapNameBg:Bitmap;
        private var _scrollHead:ScrollPanel;
        private var _scrollDown:ScrollPanel;
        private var _fightMsgVbox:VBox;
        private var _infoBefore:HardModeExpeditionInfoBefore;
        private var _infoIng:HardModeExpeditionInfoIng;
        private var _vipBg:Bitmap;
        private var _vipIcon:Bitmap;
        private var _vipText:FilterFrameText;
        private var _startBtn:TextButton;
        private var _accelerateBtn:TextButton;
        private var _stopBtn:TextButton;
        private var _start:Boolean = false;
        private var _rewardPanelBg:Bitmap;
        private var _rewardPanelTitle:Bitmap;
        private var _expeditionVLine:Bitmap;
        private var _dungeonListBg:Scale9CornerImage;
        private var _canExpeditionListBox:VBox;
        private var _canExpeditionPanel:ScrollPanel;
        private var _checkBoxList:Vector.<SelectedCheckButton>;
        private var _canExpeditionListFont:Bitmap;
        private var _accelerateFrame:BaseAlerFrame;

        public function HardModeExpeditionFrame()
        {
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_UI_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._mapNameText.text = LanguageMgr.GetTranslation("singledungeon.selectMode.hardMode");
            this.updateView();
        }

        public function updateFatigue():void
        {
            this._infoBefore.update();
        }

        private function updateView(_arg_1:int=-1):void
        {
            if (_arg_1 == NORMAL)
            {
                this._headExplainText.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.frame.hardMode.explainText");
                this._scrollHead.invalidateViewport();
                this._scrollDown.invalidateViewport();
                if (PlayerManager.Instance.checkExpedition())
                {
                    ExpeditionController.instance.sendSocket(UPDATE);
                    this._infoBefore.visible = false;
                    this._infoIng.visible = true;
                    this._infoIng.update();
                    this.megChange();
                    _arg_1 = START;
                }
                else
                {
                    this.megChange();
                };
            }
            else
            {
                switch (_arg_1)
                {
                    case START:
                        this.startExpedtion();
                        break;
                    case ACCELERATE:
                        this.accelerateExpedition();
                        break;
                    case STOP:
                        this.stopExpedtion();
                        break;
                    case UPDATE:
                        this.updateExpedition();
                        break;
                };
            };
            this.updateBtn(_arg_1);
        }

        private function addBtnFilter():void
        {
        }

        private function startExpedtion():void
        {
            var _local_1:SelectedCheckButton;
            ExpeditionController.instance.model.clearGetItemsDic();
            this.removeVboxChild();
            this.showStartMes();
            this._infoBefore.visible = false;
            this._infoIng.visible = true;
            this._infoIng.update();
            for each (_local_1 in this._checkBoxList)
            {
                _local_1.enable = false;
                if (_local_1.selected)
                {
                    _local_1.setFrame(3);
                };
                _local_1.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        private function stopExpedtion():void
        {
            this._infoBefore.visible = true;
            this._infoIng.visible = false;
            this._infoBefore.update();
            this.megChange();
        }

        private function accelerateExpedition():void
        {
        }

        private function updateExpedition():void
        {
            this._infoIng.update();
            this.megChange();
        }

        private function updateBtn(_arg_1:int):void
        {
            this._startBtn.enable = (((_arg_1 == NORMAL) || (_arg_1 == STOP)) ? true : false);
            this._accelerateBtn.enable = ((((_arg_1 == START) || (_arg_1 == UPDATE)) && (PlayerManager.Instance.checkExpedition())) ? true : false);
            this._stopBtn.enable = (((_arg_1 == START) || (_arg_1 == UPDATE)) ? true : false);
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("ddt.hardModeExpeditionFrame.title");
            this.headView();
            this.downView();
            this.buttonInitView();
        }

        private function headView():void
        {
            this._headBg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.headViewBg");
            addToContent(this._headBg);
            this._headExplainText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.headExplain.text");
            this._dungeonListBg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.hardMode.expedition.dungeonListBg");
            addToContent(this._dungeonListBg);
            this._canExpeditionListBox = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.hardModeDungeonList.vbox");
            this._canExpeditionPanel = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.hardModeList.panel");
            addToContent(this._canExpeditionPanel);
            this._canExpeditionListFont = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.canExpeditionListFont");
            addToContent(this._canExpeditionListFont);
            this._infoBefore = ComponentFactory.Instance.creatCustomObject("SingleDungeon.expedition.hardModeExpeditionInfoBefore");
            addToContent(this._infoBefore);
            this._infoBefore.update();
            this._expeditionVLine = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expedition.line");
            addToContent(this._expeditionVLine);
            this._infoIng = ComponentFactory.Instance.creatCustomObject("SingleDungeon.expedition.hardModeExpeditionInfoIng");
            this._infoIng.visible = false;
            addToContent(this._infoIng);
            this._rewardPanelBg = ComponentFactory.Instance.creatBitmap("asset.expedition.rewardPanelBg");
            addToContent(this._rewardPanelBg);
            this._rewardPanelTitle = ComponentFactory.Instance.creatBitmap("asset.expedition.rewardPanelTitle");
            addToContent(this._rewardPanelTitle);
            this._fightMsgVbox = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.downFightMsg.vbox");
            this._scrollDown = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ScrollPanel.down");
            addToContent(this._scrollDown);
            this._scrollDown.setView(this._fightMsgVbox);
            this._canExpeditionPanel.setView(this._canExpeditionListBox);
        }

        private function createCheckBoxs():void
        {
            var _local_2:MapSceneModel;
            var _local_3:SelectedCheckButton;
            var _local_4:int;
            this._canExpeditionListBox.disposeAllChildren();
            this._checkBoxList = new Vector.<SelectedCheckButton>();
            var _local_1:int = PlayerManager.Instance.Self.Fatigue;
            for each (_local_2 in HardModeManager.instance.getCanExpeditionDungeon())
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.hardModeList.itemButton");
                _local_3.text = _local_2.Name;
                if (((HardModeManager.instance.hardModeSceneList.length > 0) && (!(ExpeditionController.instance.showStop))))
                {
                    _local_3.enable = false;
                    _local_3.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    for each (_local_4 in HardModeManager.instance.hardModeSceneList)
                    {
                        if (_local_2.ID == _local_4)
                        {
                            _local_3.selected = true;
                            break;
                        };
                    };
                }
                else
                {
                    _local_3.addEventListener(MouseEvent.CLICK, this.__clickDungeon);
                    _local_3.addEventListener(Event.SELECT, this.__selectDungeon);
                    _local_1 = (_local_1 - ExpeditionController.instance.model.expeditionInfoDic[_local_2.ID].ExpeditionEnergy);
                    if (_local_1 >= 0)
                    {
                        _local_3.selected = true;
                    }
                    else
                    {
                        _local_1 = (_local_1 + ExpeditionController.instance.model.expeditionInfoDic[_local_2.ID].ExpeditionEnergy);
                    };
                };
                if (_local_3.selected)
                {
                    _local_3.setFrame(3);
                };
                this._checkBoxList.push(_local_3);
                this._canExpeditionListBox.addChild(_local_3);
            };
        }

        private function downView():void
        {
            this._downBg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.downViewBg");
            addToContent(this._downBg);
            this._mapNameBg = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
            PositionUtils.setPos(this._mapNameBg, "asset.experition.titleBg");
            addToContent(this._mapNameBg);
            this._mapNameText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.mapName.text");
            addToContent(this._mapNameText);
            this._headExplain = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expeditionHelpTitle");
            addToContent(this._headExplain);
            this._scrollHead = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ScrollPanel.head");
            addToContent(this._scrollHead);
            this._scrollHead.setView(this._headExplainText);
        }

        private function vipView():void
        {
            this._vipBg = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expedition.vipBg");
            addToContent(this._vipBg);
            this._vipIcon = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.SmallVipIcon5");
            addToContent(this._vipIcon);
            this._vipText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.vip.text");
            this._vipText.text = LanguageMgr.GetTranslation("singledungeon.expedition.vip");
            addToContent(this._vipText);
        }

        private function __clickDungeon(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function __selectDungeon(_arg_1:Event):void
        {
            var _local_3:MapSceneModel;
            var _local_4:MapSceneModel;
            var _local_5:int;
            var _local_2:SelectedCheckButton = (_arg_1.target as SelectedCheckButton);
            if (_local_2.selected)
            {
                for each (_local_3 in HardModeManager.instance.getCanExpeditionDungeon())
                {
                    if (_local_3.Name == _local_2.text)
                    {
                        HardModeManager.instance.hardModeChooseSceneList.push(_local_3.ID);
                    };
                };
            }
            else
            {
                for each (_local_4 in HardModeManager.instance.getCanExpeditionDungeon())
                {
                    if (_local_4.Name == _local_2.text)
                    {
                        _local_5 = HardModeManager.instance.hardModeChooseSceneList.indexOf(_local_4.ID);
                        HardModeManager.instance.hardModeChooseSceneList.splice(_local_5, 1);
                    };
                };
            };
            this._infoBefore.update();
            if ((!(this._infoBefore.checkFatigue())))
            {
                _local_2.selected = false;
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.fatigueNotEnought"));
            };
        }

        private function buttonInitView():void
        {
            this._startBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.start");
            this._startBtn.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.start");
            addToContent(this._startBtn);
            this._accelerateBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.accelerat");
            this._accelerateBtn.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.accelerate");
            addToContent(this._accelerateBtn);
            this._stopBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.stop");
            this._stopBtn.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.stop");
            addToContent(this._stopBtn);
        }

        private function removeVboxChild():void
        {
            this._fightMsgVbox.disposeAllChildren();
        }

        private function addVboxChild(_arg_1:FightMsgInfo):void
        {
            if (((_arg_1.templateID == -100) && (_arg_1.count == 0)))
            {
                return;
            };
            var _local_2:FightMsgItem = new FightMsgItem();
            _local_2.info = _arg_1;
            this._fightMsgVbox.addChild(_local_2);
            this._scrollDown.invalidateViewport(true);
        }

        private function showStartMes():void
        {
            var _local_1:FightMsgInfo;
            if (ExpeditionController.instance.showStart)
            {
                _local_1 = new FightMsgInfo();
                _local_1.templateID = -1;
                this.addVboxChild(_local_1);
            };
        }

        private function showStopMes():void
        {
            var _local_1:FightMsgInfo;
            if (ExpeditionController.instance.showStop)
            {
                _local_1 = new FightMsgInfo();
                _local_1.templateID = -2;
                this.addVboxChild(_local_1);
                HardModeManager.instance.resetHardModeSceneList();
                HardModeManager.instance.resetChooseSceneList();
                ExpeditionController.instance.showStart = false;
                ExpeditionController.instance.showStop = false;
                ExpeditionController.instance.model.clearGetItemsDic();
                this._infoBefore.update();
            };
        }

        private function megChange():void
        {
            var _local_2:Vector.<FightMsgInfo>;
            var _local_3:FightMsgInfo;
            var _local_4:MapSceneModel;
            var _local_5:FightMsgInfo;
            this.removeVboxChild();
            this.showStartMes();
            var _local_1:int;
            for each (_local_2 in ExpeditionController.instance.model.getItemsDic)
            {
                _local_1++;
                _local_3 = new FightMsgInfo();
                _local_3.templateID = 1;
                for each (_local_4 in SingleDungeonManager.Instance.mapHardSceneList)
                {
                    if (_local_4.ID == HardModeManager.instance.hardModeSceneList[(_local_1 - 1)])
                    {
                        _local_3.dungeonName = _local_4.Name;
                        break;
                    };
                };
                this.addVboxChild(_local_3);
                for each (_local_5 in _local_2)
                {
                    this.addVboxChild(_local_5);
                };
            };
            this.showStopMes();
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
            this.createCheckBoxs();
            this._canExpeditionPanel.invalidateViewport();
            this._scrollDown.invalidateViewport(true);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._startBtn.addEventListener(MouseEvent.CLICK, this.__start);
            this._accelerateBtn.addEventListener(MouseEvent.CLICK, this.__accelerate);
            this._stopBtn.addEventListener(MouseEvent.CLICK, this.__stop);
            ExpeditionController.instance.addEventListener(ExpeditionEvents.UPDATE, this.__updateBySocket);
        }

        private function __updateBySocket(_arg_1:ExpeditionEvents):void
        {
            var _local_2:String = _arg_1.action;
            var _local_3:int;
            switch (_local_2)
            {
                case "start":
                    _local_3 = START;
                    ExpeditionController.instance.showStart = true;
                    ExpeditionController.instance.showStop = false;
                    break;
                case "accelerate":
                    _local_3 = ACCELERATE;
                    break;
                case "stop":
                    _local_3 = STOP;
                    break;
                case "update":
                    _local_3 = UPDATE;
                    if (PlayerManager.Instance.Self.expeditionCurrent.IsOnExpedition)
                    {
                        ExpeditionController.instance.showStart = true;
                    };
                    break;
            };
            this.updateView(_local_3);
            this._start = false;
        }

        private function __stop(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._infoBefore.visible = true;
            this._infoIng.visible = false;
            var _local_2:Array = new Array();
            ExpeditionController.instance.sendSocket(STOP);
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    if (((PlayerManager.Instance.checkExpedition()) || (this._start)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
                    }
                    else
                    {
                        ExpeditionController.instance.hide();
                        ExpeditionController.instance.model.lastScenceID = 0;
                    };
                    return;
            };
        }

        private function __start(_arg_1:MouseEvent):void
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            SoundManager.instance.play("008");
            if ((!(this._infoBefore.checkFatigue())))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.fatigueNotEnought"));
                return;
            };
            if (HardModeManager.instance.hardModeChooseSceneList.length == 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.hardModeExpeditionFrame.chooseNothing"));
                return;
            };
            this._start = true;
            var _local_2:Array = new Array();
            _local_2 = [0, 0];
            var _local_3:Vector.<int> = HardModeManager.instance.hardModeChooseSceneList;
            for each (_local_4 in _local_3)
            {
                _local_5 = int(((_local_4 - ExpeditionController.PRE_SCENE) / 32));
                _local_6 = ((_local_4 - ExpeditionController.PRE_SCENE) % 32);
                _local_2[_local_5] = (_local_2[_local_5] | (1 << _local_6));
            };
            ExpeditionController.instance.sendSocket(HARD_MODE_START, _local_2);
        }

        private function __accelerate(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:AlertInfo = new AlertInfo();
            _local_2.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_2.data = LanguageMgr.GetTranslation("singledungeon.expedition.frame.accelerateAlert", HardModeManager.instance.getNeedMoney());
            _local_2.enableHtml = true;
            _local_2.moveEnable = false;
            this._accelerateFrame = AlertManager.Instance.alert("SimpleAlert", _local_2, LayerManager.ALPHA_BLOCKGOUND);
            this._accelerateFrame.addEventListener(FrameEvent.RESPONSE, this.__accelerateFrameResponse);
        }

        private function __accelerateFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.Money < PlayerManager.Instance.Self.expeditionNumLast)
                {
                    LeavePageManager.showFillFrame();
                }
                else
                {
                    this._infoBefore.visible = true;
                    this._infoIng.visible = false;
                    ExpeditionController.instance.sendSocket(ACCELERATE);
                };
            };
            this._accelerateFrame.removeEventListener(FrameEvent.RESPONSE, this.__accelerateFrameResponse);
            this._accelerateFrame.dispose();
        }

        public function updateRemainTxt(_arg_1:String):void
        {
            this._infoIng.updateRemainTxt(_arg_1);
        }

        private function removeView():void
        {
            HardModeManager.instance.resetChooseSceneList();
            ObjectUtils.disposeObject(this._downBg);
            this._downBg = null;
            ObjectUtils.disposeObject(this._headBg);
            this._headBg = null;
            ObjectUtils.disposeObject(this._mapNameBg);
            this._mapNameBg = null;
            ObjectUtils.disposeObject(this._scrollHead);
            this._scrollHead = null;
            ObjectUtils.disposeObject(this._scrollDown);
            this._scrollDown = null;
            ObjectUtils.disposeObject(this._mapNameText);
            this._mapNameText = null;
            ObjectUtils.disposeObject(this._infoIng);
            this._infoIng = null;
            ObjectUtils.disposeObject(this._infoBefore);
            this._infoBefore = null;
            ObjectUtils.disposeObject(this._vipBg);
            this._vipBg = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._vipText);
            this._vipText = null;
            ObjectUtils.disposeObject(this._startBtn);
            this._startBtn = null;
            ObjectUtils.disposeObject(this._accelerateBtn);
            this._accelerateBtn = null;
            ObjectUtils.disposeObject(this._stopBtn);
            this._stopBtn = null;
            ObjectUtils.disposeObject(this._rewardPanelBg);
            this._rewardPanelBg = null;
            ObjectUtils.disposeObject(this._rewardPanelTitle);
            this._rewardPanelTitle = null;
            ObjectUtils.disposeObject(this._expeditionVLine);
            this._expeditionVLine = null;
            ObjectUtils.disposeObject(this._headExplain);
            this._headExplain = null;
            ObjectUtils.disposeObject(this._canExpeditionListBox);
            this._canExpeditionListBox = null;
            ObjectUtils.disposeObject(this._canExpeditionPanel);
            this._canExpeditionPanel = null;
            this._checkBoxList = null;
            ObjectUtils.disposeObject(this._canExpeditionListFont);
            this._canExpeditionListFont = null;
        }

        private function removeEvent():void
        {
            var _local_1:SelectedCheckButton;
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._startBtn.removeEventListener(MouseEvent.CLICK, this.__start);
            this._accelerateBtn.removeEventListener(MouseEvent.CLICK, this.__accelerate);
            this._stopBtn.removeEventListener(MouseEvent.CLICK, this.__stop);
            ExpeditionController.instance.removeEventListener(ExpeditionEvents.UPDATE, this.__updateBySocket);
            for each (_local_1 in this._checkBoxList)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__clickDungeon);
                _local_1.removeEventListener(Event.SELECT, this.__selectDungeon);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.removeView();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package SingleDungeon.expedition.view

