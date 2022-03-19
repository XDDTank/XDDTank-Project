// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.BagAndGiftFrame

package bagAndInfo
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import bead.view.BeadInsetView;
    import com.pickgliss.effect.IEffect;
    import ddt.view.tips.OneLineTip;
    import flash.display.Sprite;
    import totem.view.TotemMainView;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SharedManager;
    import com.pickgliss.effect.AlphaShinerAnimation;
    import com.pickgliss.effect.EffectColorType;
    import com.pickgliss.effect.EffectManager;
    import com.pickgliss.effect.EffectTypes;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.controls.SelectedButton;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import bead.BeadManager;
    import totem.TotemManager;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.view.MainToolBar;
    import SingleDungeon.event.SingleDungeonEvent;
    import ddt.manager.DialogManager;
    import ddt.events.TaskEvent;
    import ddt.manager.StateManager;

    public class BagAndGiftFrame extends Frame 
    {

        public static const BAGANDINFO:int = 0;
        public static const TEXPVIEW:int = 1;
        public static const PETVIEW:int = 3;
        public static const BEADVIEW:int = 1;
        public static const TOTEMVIEW:int = 2;
        private static const TEXP_OPEN_LEVEL:int = 30;
        private static const PET_OPEN_LEVEL:int = 25;
        public static const BEAD_OPEN_LEVEL:int = 9;
        public static const TOTEM_OPEN_LEVEL:int = 17;
        private static var _isFirstEfforOpen:Boolean = true;
        private static var _isFirstOpenBead:Boolean = true;

        private var _infoFrame:BagAndInfoFrame;
        private var _btnGroup:SelectedButtonGroup;
        private var _infoBtn:SelectedTextButton;
        private var _beadBtn:SelectedTextButton;
        private var _beadView:BeadInsetView;
        private var _beadBtnShine:IEffect;
        private var _beadBtnTip:OneLineTip;
        private var _beadBtnSprite:Sprite;
        private var _shineData:Object;
        private var _totemView:TotemMainView;
        private var _totemBtn:SelectedTextButton;
        private var _totemBtnSprite:Sprite;
        private var _totemBtnShine:IEffect;
        private var _totemBtnTip:OneLineTip;
        private var _titleBmp:Bitmap;
        private var _line:ScaleBitmapImage;
        private var _frame:BaseAlerFrame;

        public function BagAndGiftFrame()
        {
            escEnable = true;
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._line = ComponentFactory.Instance.creatComponentByStylename("asset.infoAndbaginfoselectedtab.line");
            this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn1");
            this._infoBtn.text = LanguageMgr.GetTranslation("ddt.bagAndGiftFrame.infoTxt");
            this._beadBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.beedBtn1");
            this._beadBtn.text = LanguageMgr.GetTranslation("ddt.bagAndGiftFrame.beedTxt");
            this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemBtn1");
            this._totemBtn.text = LanguageMgr.GetTranslation("ddt.bagAndGiftFrame.totemTxt");
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.bag.title");
            addToContent(this._line);
            addToContent(this._infoBtn);
            addToContent(this._totemBtn);
            addToContent(this._beadBtn);
            addToContent(this._titleBmp);
            this._btnGroup = new SelectedButtonGroup();
            this._btnGroup.addSelectItem(this._infoBtn);
            this._btnGroup.addSelectItem(this._beadBtn);
            this._btnGroup.addSelectItem(this._totemBtn);
            this.totemBtnEnable();
            this.BeadbtnEnable();
        }

        public function get btnGroup():SelectedButtonGroup
        {
            return (this._btnGroup);
        }

        private function totemBtnEnable():void
        {
            var _local_1:Object;
            if (PlayerManager.Instance.Self.Grade >= TOTEM_OPEN_LEVEL)
            {
                this._totemBtn.enable = true;
                if (this._totemBtnSprite)
                {
                    ObjectUtils.disposeObject(this._totemBtnSprite);
                    this._totemBtnSprite = null;
                };
                if (SharedManager.Instance.totemSystemShow)
                {
                    _local_1 = new Object();
                    _local_1[AlphaShinerAnimation.COLOR] = EffectColorType.BLUE;
                    _local_1[AlphaShinerAnimation.WIDTH] = 50;
                    this._totemBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION, this._totemBtn, _local_1);
                    this._totemBtnShine.play();
                };
            }
            else
            {
                this._totemBtn.enable = false;
                if ((!(this._totemBtnSprite)))
                {
                    this._totemBtnSprite = new Sprite();
                    this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OVER, this.__totemBtnOverHandler);
                    this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OUT, this.__totemBtnOutHandler);
                    this._totemBtnSprite.graphics.beginFill(0, 0);
                    this._totemBtnSprite.graphics.drawRect(0, 0, this._totemBtn.displayWidth, this._totemBtn.displayHeight);
                    this._totemBtnSprite.graphics.endFill();
                    this._totemBtnSprite.x = (this._totemBtn.x + 23);
                    this._totemBtnSprite.y = (this._totemBtn.y + 3);
                    addToContent(this._totemBtnSprite);
                    this._totemBtnTip = new OneLineTip();
                    this._totemBtnTip.tipData = LanguageMgr.GetTranslation("ddt.bagandgift.opentotemBtn.text", TOTEM_OPEN_LEVEL);
                    this._totemBtnTip.visible = false;
                };
            };
        }

        private function BeadbtnEnable():void
        {
            if (PlayerManager.Instance.Self.Grade >= BEAD_OPEN_LEVEL)
            {
                this._beadBtn.enable = true;
                if (this._beadBtnSprite)
                {
                    ObjectUtils.disposeObject(this._beadBtnSprite);
                };
                this._beadBtnSprite = null;
                if (this._beadBtnTip)
                {
                    ObjectUtils.disposeObject(this._beadBtnTip);
                };
                this._beadBtnTip = null;
                if (SharedManager.Instance.beadFirstShow)
                {
                    this._shineData = new Object();
                    this._shineData[AlphaShinerAnimation.COLOR] = EffectColorType.BLUE;
                    this._beadBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION, this._beadBtn, this._shineData);
                    this._beadBtnShine.play();
                };
            }
            else
            {
                this._beadBtn.enable = false;
                if ((!(this._beadBtnSprite)))
                {
                    this._beadBtnSprite = new Sprite();
                    this._beadBtnSprite.addEventListener(MouseEvent.MOUSE_OVER, this.__beadBtnOverHandler);
                    this._beadBtnSprite.addEventListener(MouseEvent.MOUSE_OUT, this.__beadBtnOutHandler);
                    this._beadBtnSprite.graphics.beginFill(0, 0);
                    this._beadBtnSprite.graphics.drawRect(0, 0, this._beadBtn.width, this._beadBtn.height);
                    this._beadBtnSprite.graphics.endFill();
                    this._beadBtnSprite.x = this._beadBtn.x;
                    this._beadBtnSprite.y = this._beadBtn.y;
                    addToContent(this._beadBtnSprite);
                    this._beadBtnTip = new OneLineTip();
                    this._beadBtnTip.tipData = LanguageMgr.GetTranslation("beadSystem.openbeadBtn.text", BEAD_OPEN_LEVEL);
                    this._beadBtnTip.visible = false;
                    this._beadBtnSprite.addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                    this._beadBtnSprite.addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
                };
            };
        }

        private function initEvent():void
        {
            this._btnGroup.addEventListener(Event.CHANGE, this.__changeHandler);
            this._infoBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._totemBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._beadBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__getFocus);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
        }

        private function __frameClose(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
                    SoundManager.instance.play("008");
                    (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
                    (_arg_1.currentTarget as BaseAlerFrame).dispose();
                    SocketManager.Instance.out.sendClearStoreBag();
                    return;
            };
        }

        private function removeEvent():void
        {
            if (this._beadBtnSprite)
            {
                this._beadBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.__beadBtnOverHandler);
                this._beadBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.__beadBtnOutHandler);
            };
            if (this._totemBtnSprite)
            {
                this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.__totemBtnOverHandler);
                this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT, this.__totemBtnOutHandler);
            };
            this._btnGroup.removeEventListener(Event.CHANGE, this.__changeHandler);
            this._infoBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._totemBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__getFocus);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
        }

        protected function __propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["Grade"])
            {
                if (PlayerManager.Instance.Self.Grade == TOTEM_OPEN_LEVEL)
                {
                    this.totemBtnEnable();
                };
                if (PlayerManager.Instance.Self.Grade == BEAD_OPEN_LEVEL)
                {
                    this.BeadbtnEnable();
                };
            };
        }

        private function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((_arg_1.target as SelectedButton).selectedStyle == "asset.infoBtn2")
            {
                this.showInfoFrame(BAGANDINFO);
            };
        }

        private function __totemBtnOverHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            this._totemBtnTip.visible = true;
            LayerManager.Instance.addToLayer(this._totemBtnTip, LayerManager.GAME_TOP_LAYER);
            _local_2 = this._totemBtn.localToGlobal(new Point(0, 0));
            this._totemBtnTip.x = _local_2.x;
            this._totemBtnTip.y = (_local_2.y + this._totemBtn.height);
        }

        private function __totemBtnOutHandler(_arg_1:MouseEvent):void
        {
            this._totemBtnTip.visible = false;
        }

        private function __beadBtnOverHandler(_arg_1:MouseEvent):void
        {
            this._beadBtnTip.visible = true;
            LayerManager.Instance.addToLayer(this._beadBtnTip, LayerManager.GAME_TOP_LAYER);
            var _local_2:Point = this._beadBtn.localToGlobal(new Point(0, 0));
            this._beadBtnTip.x = _local_2.x;
            this._beadBtnTip.y = (_local_2.y + this._totemBtn.height);
        }

        private function __beadBtnOutHandler(_arg_1:MouseEvent):void
        {
            this._beadBtnTip.visible = false;
        }

        private function __changeHandler(_arg_1:Event):void
        {
            if (this._infoFrame)
            {
                this._infoFrame.clearTexpInfo();
            };
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
            if (((((PlayerManager.Instance.Self.Grade >= TOTEM_OPEN_LEVEL) && (!(SavePointManager.Instance.savePoints[69]))) && (!(TaskManager.instance.isCompleted(TaskManager.instance.getQuestByID(593))))) && (TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(592)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, 180, "trainer.clickTotemBtn", "", "", this);
            };
            if ((((PlayerManager.Instance.Self.Grade >= BEAD_OPEN_LEVEL) && (SavePointManager.Instance.isInSavePoint(21))) && (!(TaskManager.instance.isNewHandTaskCompleted(17)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD, 180, "trainer.clickBeadBtn", "", "", this);
            };
            if (this._btnGroup.selectIndex != BEADVIEW)
            {
                if (this._beadView)
                {
                    this._beadView.leving();
                };
            };
            switch (this._btnGroup.selectIndex)
            {
                case BAGANDINFO:
                    this.showInfoFrame(BAGANDINFO);
                    break;
                case BEADVIEW:
                    this.showBeadFrame();
                    break;
                case TOTEMVIEW:
                    this.showTotem();
                    break;
            };
            if (((!(SavePointManager.Instance.savePoints[71])) && (TaskManager.instance.isNewHandTaskCompleted(17))))
            {
                SavePointManager.Instance.setSavePoint(71);
            };
        }

        private function showBeadFrame():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            if (this._beadBtnShine)
            {
                this._beadBtnShine.stop();
                SharedManager.Instance.beadFirstShow = false;
                SharedManager.Instance.save();
            };
            if ((!(this._beadView)))
            {
                BeadManager.instance.loadBeadModule(this.doShowBead);
            }
            else
            {
                this.setVisible(BEADVIEW);
            };
        }

        private function doShowBead():void
        {
            this._beadView = ComponentFactory.Instance.creatCustomObject("beadInsetView");
            addToContent(this._beadView);
            this.setVisible(BEADVIEW);
        }

        private function setVisible(_arg_1:int):void
        {
            var _local_2:Boolean = true;
            if (this._infoFrame)
            {
                if (_arg_1 == BAGANDINFO)
                {
                    _local_2 = true;
                }
                else
                {
                    _local_2 = false;
                };
                this._infoFrame.visible = _local_2;
                if (_arg_1 == BAGANDINFO)
                {
                    this._infoFrame._infoView.switchShow(false);
                };
            };
            if (this._beadView)
            {
                this._beadView.visible = ((_arg_1 == BEADVIEW) ? true : false);
            };
            if (this._totemView)
            {
                this._totemView.visible = ((_arg_1 == TOTEMVIEW) ? true : false);
            };
        }

        private function showTotem():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
            if (this._totemBtnShine)
            {
                this._totemBtnShine.stop();
                SharedManager.Instance.totemSystemShow = false;
                SharedManager.Instance.save();
            };
            if ((!(this._totemView)))
            {
                TotemManager.instance.loadTotemModule(this.doShowTotem);
            }
            else
            {
                this.setVisible(TOTEMVIEW);
                this._totemView.showUserGuilde();
            };
        }

        private function doShowTotem():void
        {
            this._totemView = ComponentFactory.Instance.creatCustomObject("totemView");
            addToContent(this._totemView);
            this.setVisible(TOTEMVIEW);
            this._totemView.showUserGuilde();
        }

        private function showInfoFrame(_arg_1:int):void
        {
            if (((_arg_1 == TOTEMVIEW) && (this._totemBtnShine)))
            {
                this._totemBtnShine.stop();
                SharedManager.Instance.totemSystemShow = false;
                SharedManager.Instance.save();
            };
            if (this._infoFrame == null)
            {
                this._infoFrame = ComponentFactory.Instance.creatCustomObject("bagAndInfoFrame");
                addToContent(this._infoFrame);
            };
            if (_arg_1 == TEXPVIEW)
            {
                this._infoFrame.isScreenTexp = true;
            }
            else
            {
                this._infoFrame.isScreenTexp = false;
            };
            this._infoFrame.switchShow(_arg_1);
            this.setVisible(BAGANDINFO);
        }

        private function __getFocus(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__getFocus);
            StageReferance.stage.focus = this;
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_CLOSE_BAG);
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TO_EQUIP);
                MainToolBar.Instance.tipTask();
                if (SavePointManager.Instance.isInSavePoint(34))
                {
                    this.showDialog(13);
                }
                else
                {
                    SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
                };
                BagAndInfoManager.Instance.IsClose = true;
            };
        }

        private function showDialog(_arg_1:uint):void
        {
            LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
            DialogManager.Instance.addEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            DialogManager.Instance.showDialog(_arg_1);
        }

        private function __dialogEndCallBack(_arg_1:Event):void
        {
            DialogManager.Instance.removeEventListener(Event.COMPLETE, this.__dialogEndCallBack);
            if (SavePointManager.Instance.isInSavePoint(34))
            {
                SavePointManager.Instance.setSavePoint(34);
            };
            TaskManager.instance.dispatchEvent(new TaskEvent(TaskEvent.BUILDING_REFLASH));
            SingleDungeonEvent.dispatcher.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.FRAME_EXIT, "reflash"));
        }

        public function show(_arg_1:int, _arg_2:String=""):void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BAG);
            this._btnGroup.selectIndex = _arg_1;
            if (StateManager.isInGame(StateManager.currentStateType))
            {
                this._infoBtn.enable = false;
                this._beadBtn.enable = false;
                this._totemBtn.enable = false;
            };
            if (SavePointManager.Instance.isInSavePoint(64))
            {
                NewHandContainer.Instance.showArrow(ArrowType.CLICK_FASHION_BTN, 45, "trainer.clickFashionTipPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            };
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
            this._beadBtnTip.visible = true;
            LayerManager.Instance.addToLayer(this._beadBtnTip, LayerManager.GAME_TOP_LAYER);
            var _local_2:Point = this._beadBtn.localToGlobal(new Point(0, 0));
            this._beadBtnTip.x = _local_2.x;
            this._beadBtnTip.y = (_local_2.y + this._beadBtn.height);
        }

        private function __outHandler(_arg_1:MouseEvent):void
        {
            this._beadBtnTip.visible = false;
        }

        override public function dispose():void
        {
            if (((!(SavePointManager.Instance.savePoints[71])) && (TaskManager.instance.isNewHandTaskCompleted(17))))
            {
                SavePointManager.Instance.setSavePoint(71);
            };
            if (this._beadBtnShine)
            {
                EffectManager.Instance.removeEffect(this._beadBtnShine);
            };
            this._beadBtnShine = null;
            if (this._totemBtnShine)
            {
                EffectManager.Instance.removeEffect(this._totemBtnShine);
            };
            this._totemBtnShine = null;
            BagAndInfoManager.Instance.clearReference();
            this.removeEvent();
            if (this._frame)
            {
                this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
                this._frame.dispose();
                this._frame = null;
            };
            if (this._infoBtn)
            {
                ObjectUtils.disposeObject(this._infoBtn);
            };
            this._infoBtn = null;
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            if (this._infoFrame)
            {
                this._infoFrame.dispose();
            };
            this._infoFrame = null;
            if (this._beadBtn)
            {
                ObjectUtils.disposeObject(this._beadBtn);
            };
            this._beadBtn = null;
            if (this._totemBtn)
            {
                ObjectUtils.disposeObject(this._totemBtn);
            };
            this._totemBtn = null;
            if (this._beadView)
            {
                ObjectUtils.disposeObject(this._beadView);
            };
            this._beadView = null;
            if (this._totemView)
            {
                ObjectUtils.disposeObject(this._totemView);
            };
            this._totemView = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package bagAndInfo

