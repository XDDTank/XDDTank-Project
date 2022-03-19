// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.club.CreateConsortionFrame

package consortion.view.club
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.command.QuickBuyFrame;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import road7th.utils.StringHelper;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.data.analyze.ReworkNameAnalyzer;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LeavePageManager;
    import ddt.data.EquipType;
    import ddt.utils.FilterWordManager;
    import baglocked.BaglockedManager;
    import flash.ui.Keyboard;

    public class CreateConsortionFrame extends Frame 
    {

        public static const MIN_CREAT_CONSROTIA_LEVEL:int = 13;
        public static const MIN_CREAT_CONSORTIA_MONEY:int = 50;
        public static const MIN_CREAT_CONSORTIA_GOLD:int = 100000;

        private var _bg:Bitmap;
        private var _input:TextInput;
        private var _okBtn:TextButton;
        private var _cancelBtn:TextButton;
        private var _img:MutipleImage;
        private var _conditionText:FilterFrameText;
        private var _ticketText1:FilterFrameText;
        private var _goldAlertFrame:BaseAlerFrame;
        private var _moneyAlertFrame:BaseAlerFrame;
        private var _quickBuyFrame:QuickBuyFrame;

        public function CreateConsortionFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.titleText");
            this._bg = ComponentFactory.Instance.creatBitmap("asset.createConsortionFrame.BG");
            this._input = ComponentFactory.Instance.creatComponentByStylename("club.createConsortion.input");
            this._img = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.img");
            this._conditionText = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.ticketText2");
            this._conditionText.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.conditionText.Text");
            this._ticketText1 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.ticketText1");
            this._ticketText1.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text1");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.OKBtn");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.cancelBtn");
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
            addToContent(this._bg);
            addToContent(this._input);
            addToContent(this._img);
            addToContent(this._conditionText);
            addToContent(this._ticketText1);
            addToContent(this._okBtn);
            addToContent(this._cancelBtn);
            this._okBtn.enable = false;
        }

        private function initEvent():void
        {
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._okBtn.addEventListener(MouseEvent.CLICK, this.__okFun);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelFun);
            this._input.addEventListener(Event.CHANGE, this.__inputHandler);
            this._input.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyboardHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._okBtn.removeEventListener(MouseEvent.CLICK, this.__okFun);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__cancelFun);
            this._input.removeEventListener(Event.CHANGE, this.__inputHandler);
            this._input.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyboardHandler);
        }

        private function createAction():void
        {
            var _local_3:BaseAlerFrame;
            this._input.text = StringHelper.trim(this._input.text);
            if (PlayerManager.Instance.Self.Money < MIN_CREAT_CONSORTIA_MONEY)
            {
                _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                _local_3.moveEnable = false;
                _local_3.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                this._okBtn.enable = true;
                return;
            };
            if ((!(this.checkCanCreatConsortia())))
            {
                this._okBtn.enable = true;
                return;
            };
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["id"] = PlayerManager.Instance.Self.ID;
            _local_1["NickName"] = this._input.text;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaNameCheck.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.analyzer = new ReworkNameAnalyzer(this.checkCallBack);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        private function sendName():void
        {
            SocketManager.Instance.out.sendCreateConsortia(this._input.text);
            this.dispose();
        }

        protected function checkCallBack(_arg_1:ReworkNameAnalyzer):void
        {
            var _local_2:XML = _arg_1.result;
            if (_local_2.@value == "true")
            {
                this.sendName();
            }
            else
            {
                this._okBtn.enable = true;
                MessageTipManager.getInstance().show(_local_2.@message);
            };
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
        }

        private function __quickBuyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            this._goldAlertFrame.dispose();
            this._goldAlertFrame = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
                this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                LayerManager.Instance.addToLayer(this._quickBuyFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        private function checkCanCreatConsortia():Boolean
        {
            var _local_1:Array = ["%"];
            if (this._input.text == "")
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.inputPlease"));
                return (false);
            };
            if (PlayerManager.Instance.Self.Grade < MIN_CREAT_CONSROTIA_LEVEL)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.yourGrade"));
                return (false);
            };
            if (FilterWordManager.isGotForbiddenWords(this._input.text, "name"))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.consortiaName"));
                return (false);
            };
            if (this._input.text.indexOf(_local_1[0]) > -1)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.consortiaName"));
                return (false);
            };
            return (true);
        }

        private function __addToStageHandler(_arg_1:Event):void
        {
            this._input.setFocus();
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                    this.createAction();
                    return;
            };
        }

        private function __okFun(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._okBtn.enable = false;
            this.createAction();
        }

        private function __cancelFun(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __inputHandler(_arg_1:Event):void
        {
            if (this._input.text != "")
            {
                this._okBtn.enable = true;
            }
            else
            {
                this._okBtn.enable = false;
            };
            StringHelper.checkTextFieldLength(this._input.textField, 12);
        }

        private function __keyboardHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.createAction();
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            this._bg = null;
            this._input = null;
            this._img = null;
            this._conditionText = null;
            this._ticketText1 = null;
            this._okBtn = null;
            this._cancelBtn = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.club

