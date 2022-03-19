// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetInfoFrame

package petsBag.view
{
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.ScrollPanel;
    import petsBag.view.list.PetInfoList;
    import com.pickgliss.ui.controls.BaseButton;
    import petsBag.data.PetBagModel;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import petsBag.event.PetItemEvent;
    import flash.events.MouseEvent;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import pet.date.PetInfo;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.greensock.TweenLite;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.PetBagManager;

    public class PetInfoFrame extends PetBaseFrame 
    {

        public static const MOVE_SPEED:Number = 0.5;

        private var _bg:Bitmap;
        private var _bgI:Scale9CornerImage;
        private var _btnBg:Scale9CornerImage;
        private var _scroll:ScrollPanel;
        private var _petInfoList:PetInfoList;
        private var _infoView:PetInfoView;
        private var _skillBtn:BaseButton;
        private var _changeBtn:BaseButton;
        private var _advanceBtn:BaseButton;
        private var _transformBtn:BaseButton;
        private var _rightFrame:PetRightBaseFrame;
        private var _model:PetBagModel;
        private var _infoWidth:Number;
        private var _titleBmp:Bitmap;
        private var _lastClick:BaseButton;

        public function PetInfoFrame(_arg_1:PetBagModel)
        {
            this._model = _arg_1;
            super();
            this.initEvent();
            this.update();
            this._petInfoList.selectedIndex = this.findDefaultIndex();
        }

        override protected function init():void
        {
            super.init();
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.pet.title");
            addToContent(this._titleBmp);
            this._bgI = ComponentFactory.Instance.creatComponentByStylename("asset.newpetsBag.leftBgI");
            addToContent(this._bgI);
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newpetsBag.leftBg");
            addToContent(this._bg);
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.newpetsBag.btnBg");
            addToContent(this._btnBg);
            this._petInfoList = ComponentFactory.Instance.creat("petsBag.view.petInfoList", [7]);
            addToContent(this._petInfoList);
            this._scroll = ComponentFactory.Instance.creat("petsBag.view.list.petInfoList.scroll");
            this._scroll.setView(this._petInfoList);
            addToContent(this._scroll);
            this._infoView = ComponentFactory.Instance.creat("petsBag.view.petInfoView");
            addToContent(this._infoView);
            this._skillBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.skillBtn");
            addToContent(this._skillBtn);
            this._changeBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.changeBtn");
            addToContent(this._changeBtn);
            this._advanceBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.advanceBtn");
            this._advanceBtn.visible = false;
            addToContent(this._advanceBtn);
            this._transformBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoFrame.transformBtn");
            addToContent(this._transformBtn);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._petInfoList.addEventListener(PetItemEvent.ITEM_CHANGE, this.__itemChange);
            this._skillBtn.addEventListener(MouseEvent.CLICK, this.__openFrame);
            this._changeBtn.addEventListener(MouseEvent.CLICK, this.__magicChange);
            this._advanceBtn.addEventListener(MouseEvent.CLICK, this.__openFrame);
            this._transformBtn.addEventListener(MouseEvent.CLICK, this.__openFrame);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._petInfoList.removeEventListener(PetItemEvent.ITEM_CHANGE, this.__itemChange);
            this._skillBtn.removeEventListener(MouseEvent.CLICK, this.__openFrame);
            this._changeBtn.removeEventListener(MouseEvent.CLICK, this.__magicChange);
            this._advanceBtn.removeEventListener(MouseEvent.CLICK, this.__openFrame);
            this._transformBtn.removeEventListener(MouseEvent.CLICK, this.__openFrame);
        }

        private function showWeakGuilde():void
        {
            if (((!(SavePointManager.Instance.savePoints[72])) && (TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(591)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_PET, 0, "trainer.petClick1", "", "", LayerManager.Instance.getLayerByType(LayerManager.BLCAK_BLOCKGOUND));
            };
        }

        protected function __itemChange(_arg_1:PetItemEvent):void
        {
            if (this._rightFrame)
            {
                this._rightFrame.reset();
            };
            this.update();
        }

        protected function __magicChange(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:PetInfo = this.getCurrentPet();
            if (_local_2)
            {
                if (this._model.selfInfo.Bag.getItemCountByTemplateId(_local_2.ItemId) > 0)
                {
                    SocketManager.Instance.out.sendPetMagic(this.getCurrentPet().Place);
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petInfoFrame.noMagicStone"));
                };
            };
        }

        protected function __openFrame(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_PET);
            if ((!(this.getCurrentPet())))
            {
                return;
            };
            if (this._lastClick != _arg_1.currentTarget)
            {
                switch (_arg_1.currentTarget)
                {
                    case this._skillBtn:
                        this.showFrame(0);
                        break;
                    case this._advanceBtn:
                        this.showFrame(1);
                        break;
                    case this._transformBtn:
                        this.showFrame(2);
                        break;
                };
                this._lastClick = (_arg_1.currentTarget as BaseButton);
            }
            else
            {
                this.hideFrame();
                this._lastClick = null;
            };
        }

        override public function set width(_arg_1:Number):void
        {
            super.width = _arg_1;
            this._infoWidth = _arg_1;
        }

        public function showFrame(_arg_1:int):void
        {
            var _local_2:String;
            if (this._rightFrame)
            {
                this.releaseRight(this._rightFrame);
                this._rightFrame = null;
            };
            switch (_arg_1)
            {
                case 0:
                    _local_2 = "petsBag.view.skillFrame";
                    break;
                case 1:
                    _local_2 = "petsBag.view.advanceFrame";
                    break;
                case 2:
                    _local_2 = "petsBag.view.transformFrame";
                    break;
            };
            this._rightFrame = ComponentFactory.Instance.creat(_local_2);
            this._rightFrame.info = this.getCurrentPet();
            this._rightFrame.addEventListener(FrameEvent.RESPONSE, this.__onclose);
            addChildAt(this._rightFrame, 0);
            var _local_3:int = (this._infoWidth + this._rightFrame.width);
            TweenLite.to(this, MOVE_SPEED, {"x":((StageReferance.stage.stageWidth - _local_3) / 2)});
            TweenLite.to(this._rightFrame, MOVE_SPEED, {"x":this._infoWidth});
        }

        public function setIndex(_arg_1:int):void
        {
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            if (_arg_1 < this._petInfoList.items.length)
            {
                this._petInfoList.selectedIndex = _arg_1;
            };
        }

        protected function __onclose(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                    this.hideFrame();
                    this._lastClick = null;
                    return;
                case FrameEvent.HELP_CLICK:
                    this._rightFrame.showHelp();
                    return;
            };
        }

        public function hideFrame():void
        {
            TweenLite.to(this, MOVE_SPEED, {"x":((StageReferance.stage.stageWidth - this._infoWidth) / 2)});
            TweenLite.to(this._rightFrame, MOVE_SPEED, {
                "x":0,
                "onComplete":this.releaseRight,
                "onCompleteParams":[this._rightFrame]
            });
            this._rightFrame = null;
        }

        private function releaseRight(_arg_1:PetBaseFrame):void
        {
            if (_arg_1)
            {
                _arg_1.removeEventListener(FrameEvent.RESPONSE, this.__onclose);
            };
            ObjectUtils.disposeObject(_arg_1);
        }

        protected function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.HELP_CLICK:
                    showHelp();
                    return;
            };
        }

        public function show(_arg_1:int):void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            switch (_arg_1)
            {
                case 0:
                    this._skillBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                case 1:
                    this._advanceBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                case 2:
                    this._transformBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
            };
            this.showWeakGuilde();
        }

        public function getCurrentPet():PetInfo
        {
            if (((this._petInfoList.selectedIndex > -1) && (this._petInfoList.selectedIndex < this._petInfoList.items.length)))
            {
                return (this._petInfoList.items[this._petInfoList.selectedIndex]);
            };
            return (null);
        }

        private function findDefaultIndex():int
        {
            var _local_1:int;
            while (_local_1 < this._petInfoList.items.length)
            {
                if (this._petInfoList.items[_local_1].Place == 0)
                {
                    return (_local_1);
                };
                _local_1++;
            };
            return (0);
        }

        public function update():void
        {
            this._petInfoList.items = this._model.getpetListSorted();
            var _local_1:PetInfo = this.getCurrentPet();
            this._infoView.info = _local_1;
            this._scroll.invalidateViewport();
            if (this._rightFrame)
            {
                this._rightFrame.info = _local_1;
            };
            if (((_local_1) && (_local_1.MagicLevel > 0)))
            {
                this._changeBtn.visible = false;
                this._advanceBtn.visible = true;
            }
            else
            {
                this._changeBtn.visible = true;
                this._advanceBtn.visible = false;
            };
            if (_local_1)
            {
                ShowTipManager.Instance.removeTip(this._changeBtn);
                this._changeBtn.enable = (_local_1.Level >= this._model.PetMagicLevel1);
                if (_local_1.Level < 30)
                {
                    this._changeBtn.enable = false;
                    this._changeBtn.tipStyle = "ddt.view.tips.OneLineTip";
                    this._changeBtn.tipData = LanguageMgr.GetTranslation("petsBag.view.petInfoFrame.changeBtnTip1");
                }
                else
                {
                    this._changeBtn.enable = true;
                    this._changeBtn.tipStyle = "petsBag.view.MagicTip";
                    this._changeBtn.tipData = _local_1;
                };
                ShowTipManager.Instance.addTip(this._changeBtn);
                if (_local_1.MagicLevel > 0)
                {
                    this._transformBtn.enable = true;
                    ShowTipManager.Instance.removeTip(this._transformBtn);
                }
                else
                {
                    this._transformBtn.enable = false;
                    this._transformBtn.tipStyle = "ddt.view.tips.OneLineTip";
                    this._transformBtn.tipData = LanguageMgr.GetTranslation("petsBag.view.petInfoFrame.transformBtnTip1");
                    ShowTipManager.Instance.addTip(this._transformBtn);
                };
            };
        }

        override public function dispose():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_PET);
            this.removeEvent();
            PetBagManager.instance().closePetFrame();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._bgI);
            this._bgI = null;
            ObjectUtils.disposeObject(this._btnBg);
            this._btnBg = null;
            ObjectUtils.disposeObject(this._petInfoList);
            this._petInfoList = null;
            ObjectUtils.disposeObject(this._scroll);
            this._scroll = null;
            ObjectUtils.disposeObject(this._infoView);
            this._infoView = null;
            ObjectUtils.disposeObject(this._skillBtn);
            this._skillBtn = null;
            ObjectUtils.disposeObject(this._changeBtn);
            this._changeBtn = null;
            ObjectUtils.disposeObject(this._advanceBtn);
            this._advanceBtn = null;
            ObjectUtils.disposeObject(this._rightFrame);
            this._rightFrame = null;
            ObjectUtils.disposeObject(this._transformBtn);
            this._transformBtn = null;
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            this._model = null;
            super.dispose();
        }


    }
}//package petsBag.view

