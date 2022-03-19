// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.TakeInMemberFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.Sprite;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.Event;
    import ddt.manager.MessageTipManager;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaApplyInfo;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;

    public class TakeInMemberFrame extends Frame 
    {

        private var _bg:MovieImage;
        private var _nameTxt:FilterFrameText;
        private var _levelTxt:FilterFrameText;
        private var _powerTxt:FilterFrameText;
        private var _operateTxt:FilterFrameText;
        private var _level:TextButton;
        private var _power:TextButton;
        private var _selectAll:TextButton;
        private var _agree:TextButton;
        private var _refuse:TextButton;
        private var _setRefuse:SelectedCheckButton;
        private var _refuseImg:FilterFrameText;
        private var _takeIn:TextButton;
        private var _close:TextButton;
        private var _list:VBox;
        private var _lastSort:String;
        private var _items:Array;
        private var _turnPage:TakeInTurnPage;
        private var _itemBG:MutipleImage;
        private var _menberListVLine:MutipleImage;
        private var _powerBtn:Sprite;
        private var _levelBtn:Sprite;
        private var _pageCount:int = 8;

        public function TakeInMemberFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaAuditingApplyList.titleText");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("takeInMemberFrame.BG");
            this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInMemberListVLine");
            this._itemBG = ComponentFactory.Instance.creatComponentByStylename("takeInMemberItem.BG");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.nameTxt");
            this._nameTxt.text = LanguageMgr.GetTranslation("itemview.listname");
            this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.levelTxt");
            this._levelTxt.text = LanguageMgr.GetTranslation("itemview.listlevel");
            this._powerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.powerTxt");
            this._powerTxt.text = LanguageMgr.GetTranslation("itemview.listfightpower");
            this._operateTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.operateTxt");
            this._operateTxt.text = LanguageMgr.GetTranslation("operate");
            this._selectAll = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.selectAllBtn");
            this._selectAll.text = LanguageMgr.GetTranslation("consortion.takeIn.selectAllBtn.text");
            this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.agreeBtn");
            this._agree.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
            this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.refuseBtn");
            this._refuse.text = LanguageMgr.GetTranslation("consortion.takeIn.refuseBtn.text");
            this._setRefuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.setRefuse");
            this._refuseImg = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.setRefuseText");
            this._refuseImg.text = LanguageMgr.GetTranslation("consortion.takeIn.setRefuseText.text");
            this._takeIn = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.takeIn");
            this._close = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.close");
            this._list = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.list");
            this._turnPage = ComponentFactory.Instance.creatCustomObject("takeInTurnPage");
            this._levelBtn = new Sprite();
            this._levelBtn.graphics.beginFill(0xFFFFFF, 1);
            this._levelBtn.graphics.drawRect(0, 0, 65, 30);
            this._levelBtn.graphics.endFill();
            this._levelBtn.alpha = 0;
            this._levelBtn.buttonMode = true;
            this._levelBtn.mouseEnabled = true;
            this._levelBtn.x = 165;
            this._powerBtn = new Sprite();
            this._powerBtn.graphics.beginFill(0xFFFFFF, 1);
            this._powerBtn.graphics.drawRect(0, 0, 80, 30);
            this._powerBtn.graphics.endFill();
            this._powerBtn.alpha = 0;
            this._powerBtn.buttonMode = true;
            this._powerBtn.mouseEnabled = true;
            this._powerBtn.x = 232;
            this._powerBtn.y = (this._levelBtn.y = 45);
            addToContent(this._bg);
            addToContent(this._menberListVLine);
            addToContent(this._itemBG);
            addToContent(this._nameTxt);
            addToContent(this._levelTxt);
            addToContent(this._powerTxt);
            addToContent(this._operateTxt);
            addToContent(this._selectAll);
            addToContent(this._agree);
            addToContent(this._refuse);
            addToContent(this._setRefuse);
            this._setRefuse.addChild(this._refuseImg);
            addToContent(this._takeIn);
            addToContent(this._close);
            addToContent(this._list);
            addToContent(this._turnPage);
            addToContent(this._levelBtn);
            addToContent(this._powerBtn);
            this._takeIn.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaAuditingApplyList.okLabel");
            this._close.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
            this._setRefuse.visible = ((PlayerManager.Instance.Self.consortiaInfo.ChairmanID == PlayerManager.Instance.Self.ID) ? true : false);
            this._setRefuse.selected = (!(PlayerManager.Instance.Self.consortiaInfo.OpenApply));
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._levelBtn.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._powerBtn.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._selectAll.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._agree.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._refuse.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._setRefuse.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._takeIn.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._close.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._turnPage.addEventListener(TakeInTurnPage.PAGE_CHANGE, this.__pageChangeHandler);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE, this.__refishListHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE, this.__consortiaApplyStatusResult);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._levelBtn.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._powerBtn.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._selectAll.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._agree.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._refuse.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._setRefuse.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._takeIn.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._close.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._turnPage.removeEventListener(TakeInTurnPage.PAGE_CHANGE, this.__pageChangeHandler);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE, this.__refishListHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE, this.__consortiaApplyStatusResult);
        }

        private function __pageChangeHandler(_arg_1:Event):void
        {
            this.setList(ConsortionModelControl.Instance.model.getapplyListWithPage(this._turnPage.present, this._pageCount));
        }

        private function __consortiaApplyStatusResult(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:String = _arg_1.pkg.readUTF();
            MessageTipManager.getInstance().show(_local_4);
            this._setRefuse.selected = Boolean((!(_local_2)));
            PlayerManager.Instance.Self.consortiaInfo.OpenApply = Boolean(_local_2);
        }

        private function __refishListHandler(_arg_1:ConsortionEvent):void
        {
            this._lastSort = "";
            this._turnPage.sum = Math.ceil((ConsortionModelControl.Instance.model.myApplyList.length / this._pageCount));
            this.setList(ConsortionModelControl.Instance.model.getapplyListWithPage(this._turnPage.present, this._pageCount));
        }

        private function clearList():void
        {
            var _local_1:int;
            this._list.disposeAllChildren();
            if (this._items)
            {
                _local_1 = 0;
                while (_local_1 < this._items.length)
                {
                    this._items[_local_1] = null;
                    _local_1++;
                };
                this._items = null;
            };
            this._items = new Array();
        }

        private function setList(_arg_1:Vector.<ConsortiaApplyInfo>):void
        {
            var _local_4:TakeInMemberItem;
            this.clearList();
            var _local_2:int = _arg_1.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = new TakeInMemberItem();
                _local_4.info = _arg_1[_local_3];
                this._list.addChild(_local_4);
                this._items.push(_local_4);
                _local_3++;
            };
            if (this._lastSort != "")
            {
                this.sort(this._lastSort);
            };
        }

        private function sort(_arg_1:String):void
        {
            var _local_4:TakeInMemberItem;
            var _local_5:TakeInMemberItem;
            var _local_2:int;
            while (_local_2 < this._items.length)
            {
                _local_4 = (this._items[_local_2] as TakeInMemberItem);
                this._list.removeChild(_local_4);
                _local_2++;
            };
            this._items.sortOn(_arg_1, (Array.DESCENDING | Array.NUMERIC));
            var _local_3:int;
            while (_local_3 < this._items.length)
            {
                _local_5 = (this._items[_local_3] as TakeInMemberItem);
                this._list.addChild(_local_5);
                _local_3++;
            };
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            var _local_2:WantTakeInFrame;
            SoundManager.instance.play("008");
            switch (_arg_1.currentTarget)
            {
                case this._levelBtn:
                    this._lastSort = "Level";
                    this.sort(this._lastSort);
                    return;
                case this._powerBtn:
                    this._lastSort = "FightPower";
                    this.sort(this._lastSort);
                    return;
                case this._selectAll:
                    this.selectAll();
                    return;
                case this._agree:
                    this.agree();
                    return;
                case this._refuse:
                    this.refuse();
                    return;
                case this._setRefuse:
                    SocketManager.Instance.out.sendConsoritaApplyStatusOut((!(this._setRefuse.selected)));
                    return;
                case this._takeIn:
                    _local_2 = ComponentFactory.Instance.creatComponentByStylename("wantTakeInFrame");
                    LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                    return;
                case this._close:
                    this.dispose();
                    return;
            };
        }

        private function selectAll():void
        {
            var _local_1:int;
            var _local_2:int;
            if (this.allHasSelected())
            {
                _local_1 = 0;
                while (_local_1 < this._items.length)
                {
                    if (!(!(this._items[_local_1])))
                    {
                        (this._items[_local_1] as TakeInMemberItem).selected = false;
                    };
                    _local_1++;
                };
            }
            else
            {
                _local_2 = 0;
                while (_local_2 < this._items.length)
                {
                    if (!(!(this._items[_local_2])))
                    {
                        (this._items[_local_2] as TakeInMemberItem).selected = true;
                    };
                    _local_2++;
                };
            };
        }

        private function allHasSelected():Boolean
        {
            var _local_1:uint;
            while (_local_1 < this._items.length)
            {
                if ((!((this._items[_local_1] as TakeInMemberItem).selected)))
                {
                    return (false);
                };
                _local_1++;
            };
            return (true);
        }

        private function agree():void
        {
            var _local_3:TakeInMemberItem;
            var _local_1:Boolean = true;
            var _local_2:int;
            while (_local_2 < this._items.length)
            {
                _local_3 = (this._items[_local_2] as TakeInMemberItem);
                if (!(!(_local_3)))
                {
                    if (_local_3.selected)
                    {
                        SocketManager.Instance.out.sendConsortiaTryinPass(_local_3.info.ID);
                        _local_1 = false;
                    };
                };
                _local_2++;
            };
            if (_local_1)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
            };
        }

        private function refuse():void
        {
            var _local_3:TakeInMemberItem;
            var _local_1:Boolean = true;
            var _local_2:int;
            while (_local_2 < this._items.length)
            {
                _local_3 = (this._items[_local_2] as TakeInMemberItem);
                if (!(!(_local_3)))
                {
                    if ((this._items[_local_2] as TakeInMemberItem).selected)
                    {
                        SocketManager.Instance.out.sendConsortiaTryinDelete(_local_3.info.ID);
                        _local_1 = false;
                    };
                };
                _local_2++;
            };
            if (_local_1)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.clearList();
            super.dispose();
            this._bg = null;
            this._menberListVLine = null;
            this._itemBG = null;
            this._nameTxt = null;
            this._levelTxt = null;
            this._powerTxt = null;
            this._operateTxt = null;
            this._levelBtn = null;
            this._powerBtn = null;
            this._selectAll = null;
            this._agree = null;
            this._refuse = null;
            this._setRefuse = null;
            this._takeIn = null;
            this._close = null;
            this._list = null;
            this._refuseImg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

