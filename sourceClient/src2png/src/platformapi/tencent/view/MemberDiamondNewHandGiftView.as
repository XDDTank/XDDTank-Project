// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.MemberDiamondNewHandGiftView

package platformapi.tencent.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.HBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import platformapi.tencent.DiamondManager;
    import platformapi.tencent.DiamondType;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.data.DailyAwardType;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class MemberDiamondNewHandGiftView extends Sprite implements Disposeable 
    {

        private var _newHandBigTitle:Bitmap;
        private var _newHandSmallTitle:Bitmap;
        private var _cellBG:Scale9CornerImage;
        private var _textBG:Scale9CornerImage;
        private var _explainTxt:FilterFrameText;
        private var _explainBitmap1:Bitmap;
        private var _explainBitmap2:Bitmap;
        private var _explainBitmap3:Bitmap;
        private var _explainBitmap4:Bitmap;
        private var _explainBitmap5:Bitmap;
        private var _hbox:HBox;
        private var _cells:Vector.<MemberDiamondGiftCell>;
        private var _openBtn:SimpleBitmapButton;
        private var _getBtn:SimpleBitmapButton;
        private var _btnBg:ScaleBitmapImage;

        public function MemberDiamondNewHandGiftView()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainText");
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.newHandBigTitle");
                    this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.newHandsmallTitle");
                    this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtn");
                    this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtn");
                    break;
                case DiamondType.BLUE_DIAMOND:
                    this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BluenewHandBigTitle");
                    this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.BluenewHandsmallTitle");
                    this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtnI");
                    this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtnI");
                    this._explainTxt.text = LanguageMgr.GetTranslation("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainTxtI");
                    break;
                case DiamondType.MEMBER_DIAMOND:
                    this._newHandBigTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusNewHandBigTitle");
                    this._newHandSmallTitle = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.memberQPlusNewHandsmallTitle");
                    this._openBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.LeftOpenBtnII");
                    this._getBtn = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.leftgetBtnII");
                    this._explainTxt.text = LanguageMgr.GetTranslation("memberDiamondGift.view.MemberDiamondNewHandGiftView.explainTxtII");
                    break;
            };
            this._explainBitmap1 = ComponentFactory.Instance.creatBitmap("asset.memberDiamondNewHand.right1");
            this._explainBitmap2 = ComponentFactory.Instance.creatBitmap("asset.memberDiamondNewHand.right1.desc");
            this._explainBitmap3 = ComponentFactory.Instance.creatBitmap("asset.memberDiamondNewHand.right2");
            this._explainBitmap4 = ComponentFactory.Instance.creatBitmap("asset.memberDiamondNewHand.right2.desc");
            this._explainBitmap5 = ComponentFactory.Instance.creatBitmap("asset.memberDiamondNewHand.line");
            this._cellBG = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.core.scale9CornerImage22");
            this._textBG = ComponentFactory.Instance.creatComponentByStylename("MemberDiamondNewHandGiftView.core.answerBG");
            this._hbox = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.MemberDiamondNewHandGiftView.Hbox");
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.newHandView.btnBg");
            addChild(this._newHandBigTitle);
            addChild(this._cellBG);
            addChild(this._newHandSmallTitle);
            addChild(this._textBG);
            addChild(this._btnBg);
            addChild(this._hbox);
            addChild(this._explainBitmap1);
            addChild(this._explainBitmap2);
            addChild(this._explainBitmap3);
            addChild(this._explainBitmap4);
            addChild(this._explainBitmap5);
            addChild(this._explainTxt);
            addChild(this._openBtn);
            addChild(this._getBtn);
            this.createCell();
            this.update();
        }

        private function initEvent():void
        {
            this._openBtn.addEventListener(MouseEvent.CLICK, this.__onOpenBtnClick);
            this._getBtn.addEventListener(MouseEvent.CLICK, this.__ongetBtnClick);
            DiamondManager.instance.model.addEventListener(Event.CHANGE, this.__onUpdate);
        }

        protected function __onUpdate(_arg_1:Event):void
        {
            this.update();
        }

        private function removeEvent():void
        {
            this._openBtn.removeEventListener(MouseEvent.CLICK, this.__onOpenBtnClick);
            this._getBtn.removeEventListener(MouseEvent.CLICK, this.__ongetBtnClick);
            DiamondManager.instance.model.removeEventListener(Event.CHANGE, this.__onUpdate);
        }

        private function __ongetBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch (DiamondManager.instance.model.pfdata.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    SocketManager.Instance.out.sendDiamondAward(DailyAwardType.MemberDimondNewHandAward);
                    break;
                case DiamondType.BLUE_DIAMOND:
                    SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BlueMemberDimondNewHandAward);
                    break;
                case DiamondType.MEMBER_DIAMOND:
                    SocketManager.Instance.out.sendDiamondAward(DailyAwardType.memberQPlusNewHandAward);
                    break;
            };
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
            while (_local_1 < 6)
            {
                _local_2 = new MemberDiamondGiftCell(0);
                _local_2.nameTextStyle = "memberDiamondGift.view.MemberDiamondGiftRightView.cellTextII";
                this._hbox.addChild(_local_2);
                this._cells.push(_local_2);
                if (((_local_1 == 0) || (_local_1 == 1)))
                {
                    _local_2.showLight();
                };
                _local_1++;
            };
        }

        private function clearItem():void
        {
            var _local_1:int;
            while (_local_1 < 6)
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
            if (PlayerManager.Instance.Self.isGetNewHandPack)
            {
                this._getBtn.enable = false;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.clearItem();
            ObjectUtils.disposeObject(this._newHandBigTitle);
            this._newHandBigTitle = null;
            ObjectUtils.disposeObject(this._newHandSmallTitle);
            this._newHandSmallTitle = null;
            ObjectUtils.disposeObject(this._cellBG);
            this._cellBG = null;
            ObjectUtils.disposeObject(this._textBG);
            this._textBG = null;
            ObjectUtils.disposeObject(this._explainBitmap1);
            this._explainBitmap1 = null;
            ObjectUtils.disposeObject(this._explainBitmap2);
            this._explainBitmap2 = null;
            ObjectUtils.disposeObject(this._explainBitmap3);
            this._explainBitmap3 = null;
            ObjectUtils.disposeObject(this._explainBitmap4);
            this._explainBitmap4 = null;
            ObjectUtils.disposeObject(this._explainBitmap5);
            this._explainBitmap5 = null;
            ObjectUtils.disposeObject(this._explainTxt);
            this._explainTxt = null;
            ObjectUtils.disposeObject(this._hbox);
            this._hbox = null;
            ObjectUtils.disposeObject(this._openBtn);
            this._openBtn = null;
            ObjectUtils.disposeObject(this._getBtn);
            this._getBtn = null;
            ObjectUtils.disposeObject(this._btnBg);
            this._btnBg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package platformapi.tencent.view

