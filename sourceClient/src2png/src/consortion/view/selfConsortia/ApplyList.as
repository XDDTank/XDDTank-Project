// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ApplyList

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import flash.events.MouseEvent;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaApplyInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.manager.MessageTipManager;
    import ddt.data.player.ConsortiaPlayerInfo;
    import com.pickgliss.ui.LayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ApplyList extends Sprite implements Disposeable 
    {

        private var _Bg:MutipleImage;
        private var _nameBtn:SelectedCheckButton;
        private var _levelTxt:FilterFrameText;
        private var _powerTxt:FilterFrameText;
        private var _operateTxt:FilterFrameText;
        private var _vbox:VBox;
        private var _list:ScrollPanel;
        private var _menberListVLine:MutipleImage;
        private var _agree:TextButton;
        private var _refuse:TextButton;
        private var _downBg:MutipleImage;
        private var _disband:TextButton;
        private var _transfer:TextButton;
        private var _buildGradeBtn:BaseButton;
        private var _items:Array;

        public function ApplyList()
        {
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            this.visible = true;
            this._nameBtn.selected = false;
        }

        private function initView():void
        {
            this._Bg = ComponentFactory.Instance.creatComponentByStylename("memberlist.Bg");
            this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInMemberListVLine");
            PositionUtils.setPos(this._menberListVLine, "asset.ddtconsortion.applyTilteLine");
            this._nameBtn = ComponentFactory.Instance.creatComponentByStylename("ddtClubView.MemberInSelectedbtn");
            this._nameBtn.text = LanguageMgr.GetTranslation("itemview.listname");
            this._nameBtn.selected = false;
            this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.levelTxt");
            this._levelTxt.text = LanguageMgr.GetTranslation("itemview.listlevel");
            this._powerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.powerTxt");
            this._powerTxt.text = LanguageMgr.GetTranslation("itemview.listfightpower");
            this._operateTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.operateTxt");
            this._operateTxt.text = LanguageMgr.GetTranslation("operate");
            this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.agreeBtn");
            this._agree.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
            this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.refuseBtn");
            this._refuse.text = LanguageMgr.GetTranslation("consortion.takeIn.refuseBtn.text");
            PositionUtils.setPos(this._levelTxt, "asset.ddtconsortion.applyLevelTxt");
            PositionUtils.setPos(this._powerTxt, "asset.ddtconsortion.applypowerTxt");
            PositionUtils.setPos(this._operateTxt, "asset.ddtconsortion.applyoperateTxt");
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.applyVbox");
            this._list = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.applyPanel");
            this._list.setView(this._vbox);
            this._downBg = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.applylistDownBG");
            this._disband = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
            this._disband.text = LanguageMgr.GetTranslation("ddt.consortion.buildingManager.exit");
            this._transfer = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
            this._transfer.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.titleText");
            PositionUtils.setPos(this._disband, "asset.ddtconsortion.applydisbandBtn");
            PositionUtils.setPos(this._transfer, "asset.ddtconsortion.applytransferBtn");
            this._buildGradeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomconsortion.buildingupgradesBtn");
            addChild(this._Bg);
            addChild(this._menberListVLine);
            addChild(this._nameBtn);
            addChild(this._levelTxt);
            addChild(this._powerTxt);
            addChild(this._operateTxt);
            addChild(this._list);
            addChild(this._downBg);
            addChild(this._disband);
            addChild(this._refuse);
            addChild(this._agree);
            addChild(this._transfer);
            addChild(this._buildGradeBtn);
            this.initRight();
        }

        private function initRight():void
        {
            if (PlayerManager.Instance.Self.DutyLevel == 1)
            {
                this._disband.enable = true;
                this._transfer.enable = true;
            }
            else
            {
                this._disband.enable = false;
                this._transfer.enable = false;
            };
        }

        private function clearList():void
        {
            var _local_1:int;
            this._vbox.disposeAllChildren();
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

        private function initEvent():void
        {
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE, this.__eventChangeHandler);
            this._nameBtn.addEventListener(MouseEvent.CLICK, this._selectAll);
            this._agree.addEventListener(MouseEvent.CLICK, this.__agree);
            this._refuse.addEventListener(MouseEvent.CLICK, this.__refuse);
            this._transfer.addEventListener(MouseEvent.CLICK, this.__transfer);
            this._disband.addEventListener(MouseEvent.CLICK, this.__disband);
            this._buildGradeBtn.addEventListener(MouseEvent.CLICK, this.__buildGrade);
        }

        private function removeEvent():void
        {
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE, this.__eventChangeHandler);
            this._nameBtn.removeEventListener(MouseEvent.CLICK, this._selectAll);
            this._agree.removeEventListener(MouseEvent.CLICK, this.__agree);
            this._refuse.removeEventListener(MouseEvent.CLICK, this.__refuse);
            this._transfer.removeEventListener(MouseEvent.CLICK, this.__transfer);
            this._disband.removeEventListener(MouseEvent.CLICK, this.__disband);
            this._buildGradeBtn.removeEventListener(MouseEvent.CLICK, this.__buildGrade);
        }

        private function __eventChangeHandler(_arg_1:ConsortionEvent):void
        {
            var _local_5:TakeInMemberItem;
            this.clearList();
            var _local_2:Vector.<ConsortiaApplyInfo> = ConsortionModelControl.Instance.model.myApplyList;
            var _local_3:int = _local_2.length;
            var _local_4:int;
            if (_local_3 == 0)
            {
                while (_local_4 < 9)
                {
                    _local_5 = new TakeInMemberItem();
                    _local_5.updateBaceGroud(_local_4);
                    this._vbox.addChild(_local_5);
                    _local_4++;
                };
            }
            else
            {
                if (_local_3 >= 9)
                {
                    while (_local_4 < _local_3)
                    {
                        _local_5 = new TakeInMemberItem();
                        _local_5.updateBaceGroud(_local_4);
                        _local_5.info = _local_2[_local_4];
                        this._vbox.addChild(_local_5);
                        this._items.push(_local_5);
                        _local_4++;
                    };
                }
                else
                {
                    while (_local_4 < 9)
                    {
                        if (_local_4 < _local_3)
                        {
                            _local_5 = new TakeInMemberItem();
                            _local_5.updateBaceGroud(_local_4);
                            _local_5.info = _local_2[_local_4];
                            this._vbox.addChild(_local_5);
                            this._items.push(_local_5);
                        }
                        else
                        {
                            _local_5 = new TakeInMemberItem();
                            _local_5.updateBaceGroud(_local_4);
                            this._vbox.addChild(_local_5);
                        };
                        _local_4++;
                    };
                };
            };
            this._list.invalidateViewport();
        }

        private function _selectAll(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            SoundManager.instance.play("008");
            if (((this.allHasSelected()) && (!(this._nameBtn.selected))))
            {
                _local_2 = 0;
                while (_local_2 < this._items.length)
                {
                    if (!(!(this._items[_local_2])))
                    {
                        (this._items[_local_2] as TakeInMemberItem).selected = false;
                    };
                    _local_2++;
                };
            }
            else
            {
                _local_3 = 0;
                while (_local_3 < this._items.length)
                {
                    if (!(!(this._items[_local_3])))
                    {
                        (this._items[_local_3] as TakeInMemberItem).selected = true;
                    };
                    _local_3++;
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

        private function __agree(_arg_1:MouseEvent):void
        {
            var _local_4:TakeInMemberItem;
            SoundManager.instance.play("008");
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_3 < this._items.length)
            {
                _local_4 = (this._items[_local_3] as TakeInMemberItem);
                if (!(!(_local_4)))
                {
                    if (_local_4.selected)
                    {
                        SocketManager.Instance.out.sendConsortiaTryinPass(_local_4.info.ID);
                        _local_2 = false;
                    };
                };
                _local_3++;
            };
            if (_local_2)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
            };
        }

        private function __refuse(_arg_1:MouseEvent):void
        {
            var _local_4:TakeInMemberItem;
            SoundManager.instance.play("008");
            var _local_2:Boolean = true;
            var _local_3:int;
            while (_local_3 < this._items.length)
            {
                _local_4 = (this._items[_local_3] as TakeInMemberItem);
                if (!(!(_local_4)))
                {
                    if ((this._items[_local_3] as TakeInMemberItem).selected)
                    {
                        SocketManager.Instance.out.sendConsortiaTryinDelete(_local_4.info.ID);
                        _local_2 = false;
                    };
                };
                _local_3++;
            };
            if (_local_2)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
            };
        }

        private function __transfer(_arg_1:MouseEvent):void
        {
            var _local_3:ConsortionTrasferFrame;
            SoundManager.instance.play("008");
            var _local_2:Vector.<ConsortiaPlayerInfo> = ConsortionModelControl.Instance.model.ViceChairmanConsortiaMemberList;
            if (_local_2.length == 0)
            {
                return (MessageTipManager.getInstance().show("暂无副会长,无法转让公会"));
            };
            _local_3 = ComponentFactory.Instance.creatComponentByStylename("consortionTrasferFrame");
            LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __disband(_arg_1:MouseEvent):void
        {
            var _local_2:ConsortionDisbandFrame;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            _local_2 = ComponentFactory.Instance.creatComponentByStylename("ConsortionDisbandFrame");
            _local_2.show();
            _local_2.setInputTxtFocus();
        }

        private function __buildGrade(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ConsortionUpGradeFrame = ComponentFactory.Instance.creatComponentByStylename("consortionUpGradeFrame");
            LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function dispose():void
        {
            this.clearList();
            this.removeEvent();
            if (this._vbox)
            {
                this._vbox.disposeAllChildren();
                ObjectUtils.disposeObject(this._vbox);
            };
            if (this._Bg)
            {
                ObjectUtils.disposeObject(this._Bg);
            };
            this._Bg = null;
            if (this._menberListVLine)
            {
                ObjectUtils.disposeObject(this._menberListVLine);
            };
            this._menberListVLine = null;
            if (this._nameBtn)
            {
                ObjectUtils.disposeObject(this._nameBtn);
            };
            this._nameBtn = null;
            if (this._levelTxt)
            {
                ObjectUtils.disposeObject(this._levelTxt);
            };
            this._levelTxt = null;
            if (this._powerTxt)
            {
                ObjectUtils.disposeObject(this._powerTxt);
            };
            this._powerTxt = null;
            if (this._operateTxt)
            {
                ObjectUtils.disposeObject(this._operateTxt);
            };
            this._operateTxt = null;
            if (this._agree)
            {
                ObjectUtils.disposeObject(this._agree);
            };
            this._agree = null;
            if (this._refuse)
            {
                ObjectUtils.disposeObject(this._refuse);
            };
            this._refuse = null;
            if (this._downBg)
            {
                ObjectUtils.disposeObject(this._downBg);
            };
            this._downBg = null;
            if (this._disband)
            {
                ObjectUtils.disposeObject(this._disband);
            };
            this._disband = null;
            if (this._transfer)
            {
                ObjectUtils.disposeObject(this._transfer);
            };
            this._transfer = null;
            if (this._buildGradeBtn)
            {
                ObjectUtils.disposeObject(this._buildGradeBtn);
            };
            this._buildGradeBtn = null;
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            ObjectUtils.disposeAllChildren(this);
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

