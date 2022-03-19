// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.VIPPrivilegeFrame

package vip.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class VIPPrivilegeFrame extends Frame 
    {

        private var _btnBg:Scale9CornerImage;
        private var _view:Sprite;
        private var _currentViewIndex:int = -1;
        private var _growthRules:SelectedTextButton;
        private var _levelPrivilege:SelectedTextButton;
        private var _selectedBtnGroup:SelectedButtonGroup;
        private var _openVipBtn:BaseButton;

        public function VIPPrivilegeFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._selectedBtnGroup.removeEventListener(Event.CHANGE, this.__onSelectedBtnChanged);
            this._openVipBtn.removeEventListener(MouseEvent.CLICK, this.__onOpenVipBtnClick);
        }

        protected function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.dispose();
                    return;
            };
        }

        private function initView():void
        {
            this.titleText = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.VipPrivilegeTxt");
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeFrameBtnBg");
            this._growthRules = ComponentFactory.Instance.creatComponentByStylename("vip.vipPrivilegeFrame.GrowthRulesBtn");
            this._growthRules.text = LanguageMgr.GetTranslation("vip.vipPrivilegeFrame.GrowthRulesTxt");
            this._levelPrivilege = ComponentFactory.Instance.creatComponentByStylename("vip.vipPrivilegeFrame.LevelPrivilegeBtn");
            this._levelPrivilege.text = LanguageMgr.GetTranslation("vip.vipPrivilegeFrame.LevelPrivilegeTxt");
            addToContent(this._btnBg);
            addToContent(this._growthRules);
            addToContent(this._levelPrivilege);
            this._selectedBtnGroup = new SelectedButtonGroup();
            this._selectedBtnGroup.addSelectItem(this._growthRules);
            this._selectedBtnGroup.addSelectItem(this._levelPrivilege);
            this._selectedBtnGroup.addEventListener(Event.CHANGE, this.__onSelectedBtnChanged);
            this._selectedBtnGroup.selectIndex = 0;
            if (((!(PlayerManager.Instance.Self.IsVIP)) && (PlayerManager.Instance.Self.VIPExp <= 0)))
            {
                this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VIPPrivilegeFrame.OpenVipBtn");
            }
            else
            {
                this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VIPPrivilegeFrame.RenewalVipBtn");
            };
            this._openVipBtn.addEventListener(MouseEvent.CLICK, this.__onOpenVipBtnClick);
            addToContent(this._openVipBtn);
        }

        protected function __onOpenVipBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        protected function __onSelectedBtnChanged(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this.updateView(this._selectedBtnGroup.selectIndex);
        }

        private function updateView(_arg_1:int):void
        {
            if (_arg_1 == this._currentViewIndex)
            {
                return;
            };
            if (this._view)
            {
                Disposeable(this._view).dispose();
            };
            this._currentViewIndex = _arg_1;
            if (_arg_1 == 0)
            {
                this._view = new GrowthRuleView();
                PositionUtils.setPos(this._view, "GrowthRuleViewPos");
            }
            else
            {
                this._view = new LevelPrivilegeView();
                PositionUtils.setPos(this._view, "LevelPrivilegeViewPos");
            };
            addToContent(this._view);
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._view)
            {
                ObjectUtils.disposeObject(this._view);
            };
            this._view = null;
            if (this._btnBg)
            {
                ObjectUtils.disposeObject(this._btnBg);
            };
            if (this._growthRules)
            {
                ObjectUtils.disposeObject(this._growthRules);
            };
            if (this._levelPrivilege)
            {
                ObjectUtils.disposeObject(this._levelPrivilege);
            };
            if (this._openVipBtn)
            {
                ObjectUtils.disposeObject(this._openVipBtn);
            };
            if (this._selectedBtnGroup)
            {
                this._selectedBtnGroup.dispose();
            };
            this._btnBg = null;
            this._growthRules = null;
            this._levelPrivilege = null;
            this._openVipBtn = null;
            super.dispose();
        }


    }
}//package vip.view

