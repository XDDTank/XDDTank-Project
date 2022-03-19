// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionTrasferFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.VBox;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import consortion.ConsortionModelControl;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import consortion.view.club.CreateConsortionFrame;
    import ddt.manager.SocketManager;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ConsortionTrasferFrame extends Frame 
    {

        private static const ITEM_POS:String = "asset.viceChairmanItem.pos";

        private var _titleBg:Bitmap;
        private var _itemBg:Scale9CornerImage;
        private var _itemBgI:Bitmap;
        private var _Line:MutipleImage;
        private var _ok:TextButton;
        private var _cancel:TextButton;
        private var _titleTxt:FilterFrameText;
        private var _listitleTxt:FilterFrameText;
        private var _listitleTxtI:FilterFrameText;
        private var _listilteTxtII:FilterFrameText;
        private var items:Vector.<ViceChairmanItem>;
        private var _vbox:VBox;
        private var _currentItem:ViceChairmanItem;

        public function ConsortionTrasferFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.titleText");
            this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.ok");
            this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.transferFrame.cancel");
            addToContent(this._ok);
            addToContent(this._cancel);
            this._ok.text = LanguageMgr.GetTranslation("ok");
            this._cancel.text = LanguageMgr.GetTranslation("cancel");
            this._titleBg = ComponentFactory.Instance.creatBitmap("asset.taskTitle.bg");
            PositionUtils.setPos(this._titleBg, "asset.TrasferTitle.pos");
            addToContent(this._titleBg);
            this._itemBg = ComponentFactory.Instance.creatComponentByStylename("TrasferFrame.AllitemBg");
            addToContent(this._itemBg);
            this._itemBgI = ComponentFactory.Instance.creatBitmap("TrasferFrame.AllitemBgI");
            addToContent(this._itemBgI);
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.TitleText");
            this._titleTxt.text = LanguageMgr.GetTranslation("ddt.consortion.consortionTrasfer.TitleText");
            addToContent(this._titleTxt);
            this._listitleTxt = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.ListTitleText");
            this._listitleTxtI = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.ListTitleText1");
            this._listilteTxtII = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.ListTitleText2");
            this._listitleTxt.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.level.txt");
            this._listitleTxtI.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
            this._listilteTxtII.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
            addToContent(this._listitleTxt);
            addToContent(this._listitleTxtI);
            addToContent(this._listilteTxtII);
            this._Line = ComponentFactory.Instance.creatComponentByStylename("consortionTrasfer.Vline");
            addToContent(this._Line);
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("consrotionTrasfer.ItemVbox");
            this.items = new Vector.<ViceChairmanItem>(3);
            var _local_1:int;
            while (_local_1 < 3)
            {
                this.items[_local_1] = new ViceChairmanItem();
                this.items[_local_1].buttonMode = true;
                addToContent(this.items[_local_1]);
                PositionUtils.setPos(this.items[_local_1], (ITEM_POS + _local_1.toString()));
                this.items[_local_1].addEventListener(MouseEvent.CLICK, this.__clickHandler);
                this.items[_local_1].addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                this.items[_local_1].addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
                _local_1++;
            };
            this._ok.enable = false;
            this.setItem();
        }

        private function setItem():void
        {
            var _local_3:int;
            this._vbox.disposeAllChildren();
            var _local_1:Vector.<ConsortiaPlayerInfo> = ConsortionModelControl.Instance.model.ViceChairmanConsortiaMemberList;
            var _local_2:int = _local_1.length;
            if (_local_2 == 0)
            {
                return (MessageTipManager.getInstance().show("暂无副会长"));
            };
            while (_local_3 < 3)
            {
                if (_local_3 < _local_2)
                {
                    this.items[_local_3].info = _local_1[_local_3];
                    this.items[_local_3].buttonMode = true;
                    this.items[_local_3].mouseChildren = true;
                    this.items[_local_3].mouseEnabled = true;
                }
                else
                {
                    this.items[_local_3].buttonMode = false;
                    this.items[_local_3].mouseChildren = false;
                    this.items[_local_3].mouseEnabled = false;
                };
                _local_3++;
            };
        }

        public function get currentItem():ViceChairmanItem
        {
            return (this._currentItem);
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:int;
            while (_local_2 < 3)
            {
                if (this.items[_local_2] == (_arg_1.currentTarget as ViceChairmanItem))
                {
                    this.items[_local_2].isSelelct = true;
                    this._currentItem = this.items[_local_2];
                }
                else
                {
                    this.items[_local_2].isSelelct = false;
                };
                _local_2++;
            };
            this._ok.enable = true;
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.currentTarget as ViceChairmanItem).light = true;
        }

        private function __outHandler(_arg_1:MouseEvent):void
        {
            (_arg_1.currentTarget as ViceChairmanItem).light = false;
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._ok.addEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancel.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._ok.removeEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancel.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.dispose();
            };
            if (_arg_1.responseCode == FrameEvent.ENTER_CLICK)
            {
                this.__okHandler(null);
            };
        }

        private function __okHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._ok.enable = false;
            var _local_2:ConsortiaPlayerInfo = this._currentItem.info;
            if (_local_2.Grade < CreateConsortionFrame.MIN_CREAT_CONSROTIA_LEVEL)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.Grade"));
                return;
            };
            SocketManager.Instance.out.sendConsortiaChangeChairman(_local_2.NickName);
            this.dispose();
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __keyDownHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                if (this._ok.enable)
                {
                    this.__okHandler(null);
                };
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            var _local_1:int;
            while (_local_1 < 3)
            {
                this.items[_local_1].dispose();
                this.items[_local_1].removeEventListener(MouseEvent.CLICK, this.__clickHandler);
                this.items[_local_1].removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
                this.items[_local_1].removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
                this.items[_local_1] = null;
                _local_1++;
            };
            super.dispose();
            if (this._vbox)
            {
                this._vbox.disposeAllChildren();
                ObjectUtils.disposeObject(this._vbox);
            };
            this._titleBg = null;
            this._itemBg = null;
            this._itemBgI = null;
            this._Line = null;
            this._ok = null;
            this._cancel = null;
            this._currentItem = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

