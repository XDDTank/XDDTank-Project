// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.BlueDiamondNewHandGiftView

package platformapi.tencent.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.HBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.ComponentFactory;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.data.DailyAwardType;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class BlueDiamondNewHandGiftView extends BaseAlerFrame 
    {

        private var _newHandBigTitle:Bitmap;
        private var _newHandSmallTitle:Bitmap;
        private var _cellBG:Scale9CornerImage;
        private var _textBG:Scale9CornerImage;
        private var _explainTxt:FilterFrameText;
        private var _hbox:HBox;
        private var _cells:Vector.<MemberDiamondGiftCell>;
        private var _openBtn:SimpleBitmapButton;
        private var _getBtn:SimpleBitmapButton;

        public function BlueDiamondNewHandGiftView()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            super.init();
            var _local_1:AlertInfo = new AlertInfo("", "", "", false, false);
            this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BlueDiamondNewHandGiftView.explainText");
            if (DiamondManager.instance.pfType == DiamondType.MEMBER_DIAMOND)
            {
                this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusNewHandBigTitle");
                this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusNewHandsmallTitle");
                this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtnII");
                this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtnII");
                this._explainTxt.text = LanguageMgr.GetTranslation("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainTxtII");
            }
            else
            {
                this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BluenewHandBigTitle");
                this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BluenewHandsmallTitle");
                this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtnI");
                this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtnI");
                this._explainTxt.text = LanguageMgr.GetTranslation("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainTxtI");
            };
            info = _local_1;
            this._cellBG = ComponentFactory.Instance.creatComponentByStylename("BlueDiamondNewHandGiftView.core.scale9CornerImage22");
            this._textBG = ComponentFactory.Instance.creatComponentByStylename("BlueDiamondNewHandGiftView.core.answerBG");
            this._hbox = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BlueDiamondNewHandGiftView.Hbox");
            addToContent(this._newHandBigTitle);
            addToContent(this._cellBG);
            addToContent(this._newHandSmallTitle);
            addToContent(this._textBG);
            addToContent(this._hbox);
            addToContent(this._explainTxt);
            addToContent(this._openBtn);
            addToContent(this._getBtn);
            this.createCell();
            this.update();
        }

        private function initEvent():void
        {
            this._openBtn.addEventListener(MouseEvent.CLICK, this.__onOpenBtnClick);
            this._getBtn.addEventListener(MouseEvent.CLICK, this.__ongetBtnClick);
            DiamondManager.instance.model.addEventListener(Event.CHANGE, this.__onUpdate);
            addEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
        }

        private function removeEvent():void
        {
            this._openBtn.removeEventListener(MouseEvent.CLICK, this.__onOpenBtnClick);
            this._getBtn.removeEventListener(MouseEvent.CLICK, this.__ongetBtnClick);
            DiamondManager.instance.model.removeEventListener(Event.CHANGE, this.__onUpdate);
            removeEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
        }

        protected function __onUpdate(_arg_1:Event):void
        {
            this.update();
        }

        private function __ongetBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BlueMemberDimondNewHandAward);
            PlayerManager.Instance.Self.isGetNewHandPack = true;
        }

        private function __onOpenBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            DiamondManager.instance.openMemberDiamond();
        }

        private function createCell():void
        {
            var _local_2:MemberDiamondGiftCell;
            this._cells = new Vector.<MemberDiamondGiftCell>();
            var _local_1:int;
            while (_local_1 < 4)
            {
                _local_2 = new MemberDiamondGiftCell(0);
                _local_2.nameTextStyle = "memberDiamondGift.view.MemberDiamondGiftRightView.cellTextII";
                this._hbox.addChild(_local_2);
                this._cells.push(_local_2);
                _local_1++;
            };
        }

        private function clearItem():void
        {
            var _local_1:int;
            while (_local_1 < 4)
            {
                this._cells[_local_1].dispose();
                this._cells[_local_1] = null;
                _local_1++;
            };
        }

        private function update():void
        {
            var _local_1:Array = DiamondManager.instance.model.newHandAwardList.list;
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                this._cells[_local_2].setInfo(_local_1[_local_2]);
                _local_2++;
            };
            if (((PlayerManager.Instance.Self.MemberDiamondLevel > 0) && (PlayerManager.Instance.Self.isYellowVip)))
            {
                this._openBtn.visible = false;
                this._getBtn.visible = true;
            }
            else
            {
                this._openBtn.visible = true;
                this._getBtn.visible = false;
            };
            this._getBtn.enable = (!(PlayerManager.Instance.Self.isGetNewHandPack));
        }

        protected function __onFrameEvent(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    break;
                case FrameEvent.SUBMIT_CLICK:
                    break;
            };
            this.dispose();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.clearItem();
            ObjectUtils.disposeObject(this._newHandBigTitle);
            addChild(this._newHandBigTitle);
            ObjectUtils.disposeObject(this._newHandSmallTitle);
            addChild(this._newHandSmallTitle);
            ObjectUtils.disposeObject(this._cellBG);
            addChild(this._cellBG);
            ObjectUtils.disposeObject(this._textBG);
            addChild(this._textBG);
            ObjectUtils.disposeObject(this._explainTxt);
            addChild(this._explainTxt);
            ObjectUtils.disposeObject(this._hbox);
            addChild(this._hbox);
            ObjectUtils.disposeObject(this._openBtn);
            addChild(this._openBtn);
            ObjectUtils.disposeObject(this._getBtn);
            addChild(this._getBtn);
            super.dispose();
        }


    }
}//package platformapi.tencent.view

