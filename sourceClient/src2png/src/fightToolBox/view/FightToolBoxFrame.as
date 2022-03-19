// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//fightToolBox.view.FightToolBoxFrame

package fightToolBox.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.text.FilterFrameText;
    import bagAndInfo.bag.RichesButton;
    import com.pickgliss.ui.controls.BaseButton;
    import fightToolBox.FightToolBoxController;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import ddt.manager.TimeManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;

    public class FightToolBoxFrame extends Frame 
    {

        private var _BG0:ScaleBitmapImage;
        private var _titleBitmap:Bitmap;
        private var _hBox:HBox;
        private var _payNum:int;
        private var _level:int;
        private var _txtBg:Image;
        private var ButtonBottom:MutipleImage;
        private var _moneyConfirm:BaseAlerFrame;
        private var _dueDataWord:FilterFrameText;
        private var _dueData:FilterFrameText;
        private var _pictureTitleI:FilterFrameText;
        private var _pictureTitleII:FilterFrameText;
        private var _pictureTitleIII:FilterFrameText;
        private var _pictureTitleIIII:FilterFrameText;
        private var _controdution:FilterFrameText;
        private var _BG:MutipleImage;
        private var _titlePicture:Bitmap;
        private var _fourPicture:MutipleImage;
        protected var _killALLButton:RichesButton;
        protected var _distroyMoreButton:RichesButton;
        protected var _noDistroyButton:RichesButton;
        protected var _runQuicklyButton:RichesButton;
        private var _othersView:OthersView;
        private var _openBtn:BaseButton;
        private var _rechargeBtn:BaseButton;
        private var _confirmFrame:BaseAlerFrame;

        public function FightToolBoxFrame()
        {
            this.intView();
            this.intEvent();
        }

        public function update():void
        {
            if (this.checkValid())
            {
                this._openBtn.visible = false;
                this._rechargeBtn.visible = true;
            }
            else
            {
                this._openBtn.visible = true;
                this._rechargeBtn.visible = false;
            };
        }

        private function intView():void
        {
            this._level = FightToolBoxController.instance.model.fightVipTime_low;
            this._payNum = FightToolBoxController.instance.model.fightVipPrice_low;
            this._BG0 = ComponentFactory.Instance.creatComponentByStylename("FightToolBoxFrame.BG0");
            this._BG = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.BG");
            this.ButtonBottom = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxButtonBottomBG");
            this._txtBg = ComponentFactory.Instance.creatComponentByStylename("FightToolBoxFrame.TxtBg");
            this._controdution = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.controdution");
            this._killALLButton = ComponentFactory.Instance.creatCustomObject("fightToolBoxFrame.killALLButton");
            this._distroyMoreButton = ComponentFactory.Instance.creatCustomObject("fightToolBoxFrame.distroyMoreButton");
            this._noDistroyButton = ComponentFactory.Instance.creatCustomObject("fightToolBoxFrame.noDistroyButton");
            this._runQuicklyButton = ComponentFactory.Instance.creatCustomObject("fightToolBoxFrame.runQuicklyButton");
            this._titlePicture = ComponentFactory.Instance.creatBitmap("asset.fightToolBox.titlePicture");
            this._fourPicture = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.FourPictures");
            titleText = LanguageMgr.GetTranslation("ddt.fightToolBox.frameTitle");
            this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.fightToolBox.title");
            this._pictureTitleI = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.pictureTitile");
            this._pictureTitleII = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.pictureTitile");
            this._pictureTitleIII = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.pictureTitile");
            this._pictureTitleIIII = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.pictureTitile");
            this._pictureTitleI.text = LanguageMgr.GetTranslation("FightToolBoxFrame.table.killAll");
            this._pictureTitleIII.text = LanguageMgr.GetTranslation("FightToolBoxFrame.table.distroyMore");
            this._pictureTitleII.text = LanguageMgr.GetTranslation("FightToolBoxFrame.table.noDistory");
            this._pictureTitleIIII.text = LanguageMgr.GetTranslation("FightToolBoxFrame.table.runQuickly");
            this._controdution.text = LanguageMgr.GetTranslation("FightToolBoxFrame.controdution", this._payNum);
            this._killALLButton.tipData = LanguageMgr.GetTranslation("FightToolBoxFrame.table.killAll.TEXT");
            this._distroyMoreButton.tipData = LanguageMgr.GetTranslation("FightToolBoxFrame.table.distroyMore.TEXT");
            this._noDistroyButton.tipData = LanguageMgr.GetTranslation("FightToolBoxFrame.table.noDistory.TEXT");
            this._runQuicklyButton.tipData = LanguageMgr.GetTranslation("FightToolBoxFrame.table.runQuickly.TEXT");
            PositionUtils.setPos(this._pictureTitleII, "fightToolBoxFrame.leftPictureIPos");
            PositionUtils.setPos(this._pictureTitleIII, "fightToolBoxFrame.rightPicturePos");
            PositionUtils.setPos(this._pictureTitleIIII, "fightToolBoxFrame.rightPictureIPos");
            addToContent(this._BG0);
            addToContent(this._titleBitmap);
            this._openBtn = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.OpenVipBtn");
            addToContent(this._openBtn);
            addToContent(this._BG);
            this._rechargeBtn = ComponentFactory.Instance.creatComponentByStylename("fightToolBoxFrame.rechargeVipBtn");
            this._rechargeBtn.visible = false;
            addToContent(this._rechargeBtn);
            addToContent(this._txtBg);
            addToContent(this.ButtonBottom);
            addToContent(this._titlePicture);
            addToContent(this._fourPicture);
            addToContent(this._pictureTitleI);
            addToContent(this._pictureTitleII);
            addToContent(this._pictureTitleIII);
            addToContent(this._pictureTitleIIII);
            addToContent(this._controdution);
            addToContent(this._killALLButton);
            addToContent(this._distroyMoreButton);
            addToContent(this._noDistroyButton);
            addToContent(this._runQuicklyButton);
            this.update();
        }

        private function checkValid():Boolean
        {
            var _local_1:Date = new Date((PlayerManager.Instance.Self.fightVipStartTime.getTime() + ((PlayerManager.Instance.Self.fightVipValidDate * 60) * 1000)));
            var _local_2:Date = TimeManager.Instance.Now();
            if (_local_1.getTime() > _local_2.getTime())
            {
                return (true);
            };
            return (false);
        }

        private function intEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._openBtn.addEventListener(MouseEvent.CLICK, this.__sendOpen);
            this._rechargeBtn.addEventListener(MouseEvent.CLICK, this.__sendOpen);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function __sendOpen(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.Money < this._payNum)
            {
                this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.comon.lack"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                this._moneyConfirm.moveEnable = false;
                this._moneyConfirm.addEventListener(FrameEvent.RESPONSE, this.__moneyConfirmHandler);
                return;
            };
            var _local_2:String = LanguageMgr.GetTranslation("FightToolBox.yourselfView.confirm", this._level, this._payNum);
            this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("FightToolBox.ConfirmTitle"), _local_2, LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.BLCAK_BLOCKGOUND);
            this._confirmFrame.moveEnable = false;
            this._confirmFrame.addEventListener(FrameEvent.RESPONSE, this.__confirm);
        }

        private function __moneyConfirmHandler(_arg_1:FrameEvent):void
        {
            this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE, this.__moneyConfirmHandler);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    LeavePageManager.leaveToFillPath();
                    break;
            };
            this._moneyConfirm.dispose();
            if (this._moneyConfirm.parent)
            {
                this._moneyConfirm.parent.removeChild(this._moneyConfirm);
            };
            this._moneyConfirm = null;
        }

        private function __confirm(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE, this.__confirm);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    FightToolBoxController.instance.sendOpen(PlayerManager.Instance.Self.NickName, this._level);
                    break;
            };
            this._confirmFrame.dispose();
            if (this._confirmFrame.parent)
            {
                this._confirmFrame.parent.removeChild(this._confirmFrame);
            };
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    FightToolBoxController.instance.hide();
                    return;
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._openBtn.removeEventListener(MouseEvent.CLICK, this.__sendOpen);
            this._rechargeBtn.removeEventListener(MouseEvent.CLICK, this.__sendOpen);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            if (this._BG)
            {
                ObjectUtils.disposeObject(this._BG);
            };
            this._BG = null;
            if (this._dueDataWord)
            {
                ObjectUtils.disposeObject(this._dueDataWord);
            };
            this._dueDataWord = null;
            if (this._dueData)
            {
                ObjectUtils.disposeObject(this._dueData);
            };
            this._dueData = null;
            if (this._titleBitmap)
            {
                ObjectUtils.disposeObject(this._titleBitmap);
            };
            this._titleBitmap = null;
            if (this._txtBg)
            {
                ObjectUtils.disposeObject(this._txtBg);
            };
            this._txtBg = null;
            if (this._openBtn)
            {
                ObjectUtils.disposeObject(this._openBtn);
            };
            this._openBtn = null;
            if (this._rechargeBtn)
            {
                ObjectUtils.disposeObject(this._rechargeBtn);
            };
            this._rechargeBtn = null;
            if (this.ButtonBottom)
            {
                ObjectUtils.disposeObject(this.ButtonBottom);
            };
            this.ButtonBottom = null;
            if (this._titlePicture)
            {
                ObjectUtils.disposeObject(this._titlePicture);
            };
            this._titlePicture = null;
            if (this._fourPicture)
            {
                ObjectUtils.disposeObject(this._fourPicture);
            };
            this._fourPicture = null;
            if (this._pictureTitleI)
            {
                ObjectUtils.disposeObject(this._pictureTitleI);
            };
            this._pictureTitleI = null;
            if (this._pictureTitleII)
            {
                ObjectUtils.disposeObject(this._pictureTitleII);
            };
            this._pictureTitleII = null;
            if (this._pictureTitleIII)
            {
                ObjectUtils.disposeObject(this._pictureTitleIII);
            };
            this._pictureTitleIII = null;
            if (this._pictureTitleIIII)
            {
                ObjectUtils.disposeObject(this._pictureTitleIIII);
            };
            this._pictureTitleIIII = null;
            if (this._controdution)
            {
                ObjectUtils.disposeObject(this._controdution);
            };
            this._controdution = null;
            if (this._killALLButton)
            {
                ObjectUtils.disposeObject(this._killALLButton);
            };
            this._killALLButton = null;
            if (this._distroyMoreButton)
            {
                ObjectUtils.disposeObject(this._distroyMoreButton);
            };
            this._distroyMoreButton = null;
            if (this._noDistroyButton)
            {
                ObjectUtils.disposeObject(this._noDistroyButton);
            };
            this._noDistroyButton = null;
            if (this._runQuicklyButton)
            {
                ObjectUtils.disposeObject(this._runQuicklyButton);
            };
            this._runQuicklyButton = null;
        }


    }
}//package fightToolBox.view

