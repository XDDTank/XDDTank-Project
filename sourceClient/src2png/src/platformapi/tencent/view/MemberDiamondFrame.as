// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.MemberDiamondFrame

package platformapi.tencent.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class MemberDiamondFrame extends Frame 
    {

        private var _bg:Scale9CornerImage;
        private var _memberDiamondNewHandGiftView:MemberDiamondNewHandGiftView;
        private var _memberDiamondGiftView:MemberDiamondGiftView;
        private var _memberDiamondRepaymentView:MemberDiamondRepaymentFrame;
        private var _btnGroup:SelectedButtonGroup;
        private var _newHandBtn:SelectedButton;
        private var _giftBtn:SelectedButton;
        private var _repaymentBtn:SelectedButton;

        public function MemberDiamondFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("memberDiamondFrame.title");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.bg");
            this._newHandBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.newHandBtn");
            this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.giftBtn");
            this._repaymentBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame.repaymentBtn");
            addToContent(this._bg);
            addToContent(this._newHandBtn);
            addToContent(this._giftBtn);
            addToContent(this._repaymentBtn);
            this._btnGroup = new SelectedButtonGroup();
            this._btnGroup.addSelectItem(this._newHandBtn);
            this._btnGroup.addSelectItem(this._giftBtn);
            this._btnGroup.addSelectItem(this._repaymentBtn);
            this._btnGroup.selectIndex = 0;
            this.__changeHandler(null);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._btnGroup.addEventListener(Event.CHANGE, this.__changeHandler);
            this._newHandBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._giftBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._repaymentBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
        }

        private function __changeHandler(_arg_1:Event):void
        {
            switch (this._btnGroup.selectIndex)
            {
                case 0:
                    this.showNewHandView();
                    return;
                case 1:
                    this.showGiftView();
                    return;
                case 2:
                    this.showRepaymentView();
                    return;
            };
        }

        private function showNewHandView():void
        {
            if ((!(this._memberDiamondNewHandGiftView)))
            {
                this._memberDiamondNewHandGiftView = ComponentFactory.Instance.creatCustomObject("MemberDiamondFrame.newHandGiftView");
                addToContent(this._memberDiamondNewHandGiftView);
            };
            this.setVisible(0);
        }

        private function showGiftView():void
        {
            if ((!(this._memberDiamondGiftView)))
            {
                this._memberDiamondGiftView = ComponentFactory.Instance.creatCustomObject("MemberDiamondFrame.giftView");
                addToContent(this._memberDiamondGiftView);
            };
            this.setVisible(1);
        }

        private function showRepaymentView():void
        {
            if ((!(this._memberDiamondRepaymentView)))
            {
                this._memberDiamondRepaymentView = ComponentFactory.Instance.creatCustomObject("MemberDiamondFrame.repaymentView");
                addToContent(this._memberDiamondRepaymentView);
            };
            this.setVisible(2);
        }

        private function setVisible(_arg_1:int):void
        {
            if (this._memberDiamondNewHandGiftView)
            {
                this._memberDiamondNewHandGiftView.visible = ((_arg_1 == 0) ? true : false);
            };
            if (this._memberDiamondGiftView)
            {
                this._memberDiamondGiftView.visible = ((_arg_1 == 1) ? true : false);
            };
            if (this._memberDiamondRepaymentView)
            {
                this._memberDiamondRepaymentView.visible = ((_arg_1 == 2) ? true : false);
            };
        }

        private function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        public function show(_arg_1:int):void
        {
            this._btnGroup.selectIndex = _arg_1;
            this.__changeHandler(null);
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._btnGroup.removeEventListener(Event.CHANGE, this.__changeHandler);
            this._newHandBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._giftBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._repaymentBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            super.dispose();
        }


    }
}//package platformapi.tencent.view

