// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.MemberList

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.ListPanel;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.MessageTipManager;
    import road7th.utils.StringHelper;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;

    public class MemberList extends Sprite implements Disposeable 
    {

        private var _Bg:MutipleImage;
        private var _menberListVLine:MutipleImage;
        private var _DonateBG:Scale9CornerImage;
        private var _name:BaseButton;
        private var _job:BaseButton;
        private var _level:BaseButton;
        private var _offer:BaseButton;
        private var _fightPower:BaseButton;
        private var _offLine:BaseButton;
        private var _search:SimpleBitmapButton;
        private var _nameText:FilterFrameText;
        private var _jobText:FilterFrameText;
        private var _levelText:FilterFrameText;
        private var _offerText:FilterFrameText;
        private var _fightText:FilterFrameText;
        private var _offLineText:FilterFrameText;
        private var _list:ListPanel;
        private var _lastSort:String = "";
        private var _isDes:Boolean = false;
        private var _searchMemberFrame:SearchMemberFrame;
        private var _donateView:SelfDonateView;

        public function MemberList()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._Bg = ComponentFactory.Instance.creatComponentByStylename("memberlist.Bg");
            this._DonateBG = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.MemberlistDonateBG");
            this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortion.MemberListVLine");
            this._name = ComponentFactory.Instance.creatComponentByStylename("memberList.name");
            this._job = ComponentFactory.Instance.creatComponentByStylename("memberList.job");
            this._level = ComponentFactory.Instance.creatComponentByStylename("memberList.level");
            this._offer = ComponentFactory.Instance.creatComponentByStylename("memberList.offer");
            this._fightPower = ComponentFactory.Instance.creatComponentByStylename("memberList.fightPower");
            this._offLine = ComponentFactory.Instance.creatComponentByStylename("memberList.offLine");
            this._nameText = ComponentFactory.Instance.creatComponentByStylename("memberList.nameText");
            this._nameText.text = LanguageMgr.GetTranslation("tank.memberList.nameText.text");
            this._jobText = ComponentFactory.Instance.creatComponentByStylename("memberList.jobText");
            this._jobText.text = LanguageMgr.GetTranslation("tank.memberList.jobText.text");
            this._levelText = ComponentFactory.Instance.creatComponentByStylename("memberList.levelText");
            this._levelText.text = LanguageMgr.GetTranslation("tank.memberList.levelText.text");
            this._offerText = ComponentFactory.Instance.creatComponentByStylename("memberList.offerText");
            this._offerText.text = LanguageMgr.GetTranslation("tank.memberList.offerText.text");
            this._fightText = ComponentFactory.Instance.creatComponentByStylename("memberList.fightPowerText");
            this._fightText.text = LanguageMgr.GetTranslation("tank.memberList.fightPowerText.text");
            this._offLineText = ComponentFactory.Instance.creatComponentByStylename("memberList.offLineText");
            this._offLineText.text = LanguageMgr.GetTranslation("tank.memberList.offLineText.text");
            this._list = ComponentFactory.Instance.creatComponentByStylename("memberList.list");
            this._search = ComponentFactory.Instance.creatComponentByStylename("memberList.searchBtn");
            this._donateView = ComponentFactory.Instance.creatComponentByStylename("SelfDonateView");
            addChild(this._Bg);
            addChild(this._DonateBG);
            addChild(this._menberListVLine);
            addChild(this._name);
            addChild(this._job);
            addChild(this._level);
            addChild(this._offer);
            addChild(this._fightPower);
            addChild(this._offLine);
            addChild(this._nameText);
            addChild(this._jobText);
            addChild(this._levelText);
            addChild(this._offerText);
            addChild(this._fightText);
            addChild(this._offLineText);
            addChild(this._list);
            addChild(this._search);
            addChild(this._donateView);
            this.setTip(this._name, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.name"));
            this.setTip(this._job, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.duty"));
            this.setTip(this._level, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.level"));
            this.setTip(this._offer, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.contribute"));
            this.setTip(this._fightPower, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.battle"));
            this.setTip(this._offLine, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.time"));
            this.setTip(this._search, LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberList.tipArr.search"));
            this.setListData();
        }

        private function setTip(_arg_1:BaseButton, _arg_2:String):void
        {
            _arg_1.tipStyle = "ddt.view.tips.OneLineTip";
            _arg_1.tipDirctions = "0";
            _arg_1.tipData = _arg_2;
        }

        private function initEvent():void
        {
            this._name.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._job.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._level.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._offer.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._fightPower.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._offLine.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._search.addEventListener(MouseEvent.CLICK, this.__showSearchFrame);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBERLIST_COMPLETE, this.__listLoadCompleteHandler);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_ADD, this.__addMemberHandler);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_REMOVE, this.__removeMemberHandler);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MEMBER_UPDATA, this.__updataMemberHandler);
        }

        private function removeEvent():void
        {
            if (this._name)
            {
                this._name.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            };
            if (this._job)
            {
                this._job.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            };
            if (this._level)
            {
                this._level.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            };
            if (this._offer)
            {
                this._offer.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            };
            if (this._fightPower)
            {
                this._fightPower.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            };
            if (this._offLine)
            {
                this._offLine.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            };
            if (this._search)
            {
                this._search.removeEventListener(MouseEvent.CLICK, this.__showSearchFrame);
            };
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBERLIST_COMPLETE, this.__listLoadCompleteHandler);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_ADD, this.__addMemberHandler);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_REMOVE, this.__removeMemberHandler);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MEMBER_UPDATA, this.__updataMemberHandler);
            if (this._searchMemberFrame)
            {
                this._searchMemberFrame.removeEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
            };
        }

        public function __updataMemberHandler(_arg_1:ConsortionEvent):void
        {
            var _local_5:ConsortiaPlayerInfo;
            var _local_2:ConsortiaPlayerInfo = (_arg_1.data as ConsortiaPlayerInfo);
            var _local_3:int = this._list.vectorListModel.elements.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_5 = (this._list.vectorListModel.elements[_local_4] as ConsortiaPlayerInfo);
                _local_4++;
            };
            this._list.list.updateListView();
        }

        public function __addMemberHandler(_arg_1:ConsortionEvent):void
        {
            var _local_2:int = ConsortionModelControl.Instance.model.memberList.length;
            this._list.vectorListModel.append((_arg_1.data as ConsortiaPlayerInfo), (_local_2 - 1));
            if (_local_2 <= 9)
            {
                this._list.vectorListModel.removeElementAt((this._list.vectorListModel.elements.length - 1));
            };
            this._list.list.updateListView();
        }

        public function __removeMemberHandler(_arg_1:ConsortionEvent):void
        {
            this._list.vectorListModel.remove((_arg_1.data as ConsortiaPlayerInfo));
            var _local_2:int = ConsortionModelControl.Instance.model.memberList.length;
            if (_local_2 < 9)
            {
                this.setListData();
            };
            this._list.list.updateListView();
        }

        private function __btnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._isDes = ((this._isDes) ? false : true);
            switch (_arg_1.currentTarget)
            {
                case this._name:
                    this._lastSort = "NickName";
                    break;
                case this._job:
                    this._lastSort = "DutyLevel";
                    break;
                case this._level:
                    this._lastSort = "Grade";
                    break;
                case this._offer:
                    this._lastSort = "beforeOffer";
                    break;
                case this._fightPower:
                    this._lastSort = "UseOffer";
                    break;
                case this._offLine:
                    this._lastSort = "OffLineHour";
                    break;
            };
            this.sortOnItem(this._lastSort, this._isDes);
        }

        private function __listLoadCompleteHandler(_arg_1:ConsortionEvent):void
        {
            this.setListData();
        }

        private function __showSearchFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (((this._searchMemberFrame) && (this._searchMemberFrame.parent)))
            {
                return;
            };
            this._searchMemberFrame = ComponentFactory.Instance.creatComponentByStylename("SearchMemberFrame");
            this._searchMemberFrame.addEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
            LayerManager.Instance.addToLayer(this._searchMemberFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            this._searchMemberFrame.setFocus();
        }

        private function __onFrameEvent(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (this.search(this._searchMemberFrame.getSearchText()))
                    {
                        this.hideSearchFrame();
                    };
                    return;
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.hideSearchFrame();
                    return;
            };
        }

        private function search(_arg_1:String):Boolean
        {
            var _local_8:ConsortiaPlayerInfo;
            if (FilterWordManager.isGotForbiddenWords(_arg_1))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
                return (false);
            };
            if (((_arg_1 == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default")) || (_arg_1 == "")))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"));
                return (false);
            };
            if (StringHelper.getIsBiggerMaxCHchar(_arg_1, 7))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
                return (false);
            };
            var _local_2:String = _arg_1;
            var _local_3:Array = ConsortionModelControl.Instance.model.memberList.list;
            var _local_4:Array = [];
            var _local_5:Boolean;
            var _local_6:int;
            while (_local_6 < _local_3.length)
            {
                _local_8 = _local_3[_local_6];
                if (_local_8.NickName.indexOf(_local_2) != -1)
                {
                    _local_4.unshift(_local_8);
                    _local_5 = true;
                }
                else
                {
                    _local_4.push(_local_8);
                };
                _local_6++;
            };
            if (_local_2 == LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.default"));
                return (false);
            };
            if ((!(_local_5)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.view.selfConsortia.SearchMemberFrame.warningII"));
                return (false);
            };
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(_local_4);
            var _local_7:int = _local_4.length;
            if (_local_7 < 9)
            {
                while (_local_7 < 9)
                {
                    this._list.vectorListModel.append(null, _local_7);
                    _local_7++;
                };
            };
            this._list.list.updateListView();
            return (true);
        }

        private function hideSearchFrame():void
        {
            if (this._searchMemberFrame)
            {
                this._searchMemberFrame.removeEventListener(FrameEvent.RESPONSE, this.__onFrameEvent);
                ObjectUtils.disposeObject(this._searchMemberFrame);
                this._searchMemberFrame = null;
            };
        }

        private function setListData():void
        {
            var _local_1:int;
            if (ConsortionModelControl.Instance.model.memberList.length > 0)
            {
                this._list.vectorListModel.clear();
                this._list.vectorListModel.appendAll(ConsortionModelControl.Instance.model.memberList.list);
                _local_1 = ConsortionModelControl.Instance.model.memberList.length;
                if (_local_1 < 9)
                {
                    while (_local_1 < 9)
                    {
                        this._list.vectorListModel.append(null, _local_1);
                        _local_1++;
                    };
                };
                if (this._lastSort == "")
                {
                    this._lastSort = "Init";
                    this._isDes = false;
                };
                this.sortOnItem(this._lastSort, this._isDes);
            };
        }

        private function sortOnItem(_arg_1:String, _arg_2:Boolean=false):void
        {
            var _local_4:int;
            var _local_3:int = ConsortionModelControl.Instance.model.memberList.length;
            if (_local_3 < 9)
            {
                this._list.vectorListModel.elements.splice(_local_3, ((9 - _local_3) + 1));
            };
            if (_arg_1 == "Init")
            {
                this._list.vectorListModel.elements.sortOn("Grade", ((0x02 | 0x01) | 0x10));
                _local_4 = 0;
                while (_local_4 < this._list.vectorListModel.elements.length)
                {
                    if (((this._list.vectorListModel.elements[_local_4]) && (this._list.vectorListModel.elements[_local_4].ID == PlayerManager.Instance.Self.ID)))
                    {
                        this._list.vectorListModel.elements.unshift(this._list.vectorListModel.elements[_local_4]);
                        this._list.vectorListModel.elements.splice((_local_4 + 1), 1);
                    };
                    _local_4++;
                };
            }
            else
            {
                this._list.vectorListModel.elements.sortOn(_arg_1, ((0x02 | 0x01) | 0x10));
            };
            if (_arg_2)
            {
                this._list.vectorListModel.elements.reverse();
            };
            if (_local_3 < 9)
            {
                while (_local_3 < 9)
                {
                    this._list.vectorListModel.append(null, _local_3);
                    _local_3++;
                };
            };
            this._list.list.updateListView();
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._list)
            {
                this._list.vectorListModel.clear();
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            if (this._searchMemberFrame)
            {
                ObjectUtils.disposeObject(this._searchMemberFrame);
            };
            this._searchMemberFrame = null;
            if (this._Bg)
            {
                ObjectUtils.disposeObject(this._Bg);
            };
            this._Bg = null;
            if (this._DonateBG)
            {
                ObjectUtils.disposeObject(this._DonateBG);
            };
            this._DonateBG = null;
            if (this._menberListVLine)
            {
                ObjectUtils.disposeObject(this._menberListVLine);
            };
            this._menberListVLine = null;
            if (this._name)
            {
                ObjectUtils.disposeObject(this._name);
            };
            this._name = null;
            if (this._job)
            {
                ObjectUtils.disposeObject(this._job);
            };
            this._job = null;
            if (this._level)
            {
                ObjectUtils.disposeObject(this._level);
            };
            this._level = null;
            if (this._offer)
            {
                ObjectUtils.disposeObject(this._offer);
            };
            this._offer = null;
            if (this._fightPower)
            {
                ObjectUtils.disposeObject(this._fightPower);
            };
            this._fightPower = null;
            if (this._offLine)
            {
                ObjectUtils.disposeObject(this._offLine);
            };
            this._offLine = null;
            if (this._search)
            {
                ObjectUtils.disposeObject(this._search);
            };
            this._search = null;
            if (this._nameText)
            {
                ObjectUtils.disposeObject(this._nameText);
            };
            this._nameText = null;
            if (this._jobText)
            {
                ObjectUtils.disposeObject(this._jobText);
            };
            this._jobText = null;
            if (this._levelText)
            {
                ObjectUtils.disposeObject(this._levelText);
            };
            this._levelText = null;
            if (this._offerText)
            {
                ObjectUtils.disposeObject(this._offerText);
            };
            this._offerText = null;
            if (this._fightText)
            {
                ObjectUtils.disposeObject(this._fightText);
            };
            this._fightText = null;
            if (this._offLineText)
            {
                ObjectUtils.disposeObject(this._offLineText);
            };
            this._offLineText = null;
            if (this._donateView)
            {
                this._donateView.dispose();
            };
            this._donateView = null;
            ObjectUtils.disposeAllChildren(this);
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

