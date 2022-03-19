// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.SelfConsortiaViewFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.HelpFrame;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.ConsortiaDutyManager;
    import ddt.data.ConsortiaDutyType;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;

    public class SelfConsortiaViewFrame extends Frame 
    {

        private var _leftView:SelfConsortionHallLeftView;
        private var _consortionPeopleBtn:SelectedTextButton;
        private var _consortionRizhiBtn:SelectedTextButton;
        private var _consortionGuanliBtn:SelectedTextButton;
        private var _btnGroup:SelectedButtonGroup;
        private var _memberList:MemberList;
        private var _eventList:EventList;
        private var _applyList:ApplyList;
        private var _helpFrame:HelpFrame;

        public function SelfConsortiaViewFrame()
        {
            escEnable = true;
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.nextLevel", PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
            _helpButton = ComponentFactory.Instance.creat("consortionHall.frame.helpBtn");
            this._leftView = ComponentFactory.Instance.creatComponentByStylename("selfConsortionHallLeftView");
            addToContent(this._leftView);
            this._consortionPeopleBtn = ComponentFactory.Instance.creatComponentByStylename("SelfConsortionPeople.SelectedBtn");
            this._consortionPeopleBtn.text = LanguageMgr.GetTranslation("ddt.consortion.member");
            this._consortionRizhiBtn = ComponentFactory.Instance.creatComponentByStylename("SelfConsortionJournal.SelectedBtn");
            this._consortionRizhiBtn.text = LanguageMgr.GetTranslation("ddt.consortion.events");
            this._consortionGuanliBtn = ComponentFactory.Instance.creatComponentByStylename("SelfConsortionManagement.SelectedBtn");
            this._consortionGuanliBtn.text = LanguageMgr.GetTranslation("ddt.consortion.apply");
            this._memberList = ComponentFactory.Instance.creatCustomObject("memberList");
            PositionUtils.setPos(this._memberList, "consortion.memberList.pos");
            this._eventList = ComponentFactory.Instance.creatCustomObject("eventList");
            PositionUtils.setPos(this._eventList, "consortion.eventList.pos");
            this._applyList = ComponentFactory.Instance.creatCustomObject("applyList");
            PositionUtils.setPos(this._applyList, "consortion.applyList.pos");
            addToContent(this._consortionPeopleBtn);
            addToContent(this._consortionRizhiBtn);
            addToContent(this._consortionGuanliBtn);
            addToContent(this._memberList);
            addToContent(this._eventList);
            addToContent(this._applyList);
            this._btnGroup = new SelectedButtonGroup();
            this._btnGroup.addSelectItem(this._consortionPeopleBtn);
            this._btnGroup.addSelectItem(this._consortionRizhiBtn);
            this._btnGroup.addSelectItem(this._consortionGuanliBtn);
            this._btnGroup.selectIndex = 0;
            this.showGroup(this._btnGroup.selectIndex);
            this.initBtn();
        }

        private function initBtn():void
        {
            var _local_1:int = PlayerManager.Instance.Self.Right;
            this._consortionGuanliBtn.visible = ConsortiaDutyManager.GetRight(_local_1, ConsortiaDutyType._1_Ratify);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            _helpButton.addEventListener(MouseEvent.CLICK, this.__helpClick);
            this._consortionPeopleBtn.addEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._consortionRizhiBtn.addEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._consortionGuanliBtn.addEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._btnGroup.addEventListener(Event.CHANGE, this.__groupChangeHandler);
            ConsortionModelControl.Instance.addEventListener(ConsortionEvent.CHARMAN_CHANGE, this.__charmanChange);
        }

        private function __charmanChange(_arg_1:ConsortionEvent):void
        {
            this.initBtn();
            this._btnGroup.selectIndex = 0;
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            _helpButton.removeEventListener(MouseEvent.CLICK, this.__helpClick);
            if (this._consortionPeopleBtn)
            {
                this._consortionPeopleBtn.removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            };
            if (this._consortionRizhiBtn)
            {
                this._consortionRizhiBtn.removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            };
            if (this._consortionGuanliBtn)
            {
                this._consortionGuanliBtn.removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            };
            if (this._btnGroup)
            {
                this._btnGroup.removeEventListener(Event.CHANGE, this.__groupChangeHandler);
            };
            if (this._helpFrame)
            {
                this._helpFrame.removeEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
            };
            ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.CHARMAN_CHANGE, this.__charmanChange);
        }

        private function __helpClick(_arg_1:MouseEvent):void
        {
            onResponse(FrameEvent.HELP_CLICK);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.dispose();
            };
            if (_arg_1.responseCode == FrameEvent.HELP_CLICK)
            {
                this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("helpFrame");
                this._helpFrame.setView(ComponentFactory.Instance.creat("consortion.HelpFrame.HallText"));
                this._helpFrame.addEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
                this._helpFrame.show();
            };
        }

        private function __helpResponseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE, this.__helpResponseHandler);
            ObjectUtils.disposeObject(this._helpFrame);
            this._helpFrame = null;
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (_helpButton)
            {
                _helpButton.x = (_closeButton.x - _helpButton.width);
                _helpButton.y = _closeButton.y;
                addChild(_helpButton);
            };
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function __groupChangeHandler(_arg_1:Event):void
        {
            this.showGroup(this._btnGroup.selectIndex);
        }

        private function showGroup(_arg_1:int):void
        {
            switch (_arg_1)
            {
                case 0:
                    this._memberList.visible = true;
                    this._eventList.visible = false;
                    this._applyList.visible = false;
                    return;
                case 1:
                    this._memberList.visible = false;
                    this._eventList.visible = true;
                    this._applyList.visible = false;
                    ConsortionModelControl.Instance.loadEventList(ConsortionModelControl.Instance.eventListComplete, PlayerManager.Instance.Self.ConsortiaID);
                    return;
                case 2:
                    this._memberList.visible = false;
                    this._eventList.visible = false;
                    this._applyList.show();
                    ConsortionModelControl.Instance.getApplyRecordList(ConsortionModelControl.Instance.applyListComplete, -1, PlayerManager.Instance.Self.ConsortiaID);
                    return;
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._consortionPeopleBtn)
            {
                ObjectUtils.disposeObject(this._consortionPeopleBtn);
            };
            this._consortionPeopleBtn = null;
            if (this._consortionRizhiBtn)
            {
                ObjectUtils.disposeObject(this._consortionRizhiBtn);
            };
            this._consortionRizhiBtn = null;
            if (this._consortionGuanliBtn)
            {
                ObjectUtils.disposeObject(this._consortionGuanliBtn);
            };
            this._consortionGuanliBtn = null;
            if (this._memberList)
            {
                ObjectUtils.disposeObject(this._memberList);
            };
            this._memberList = null;
            if (this._eventList)
            {
                ObjectUtils.disposeObject(this._eventList);
            };
            this._eventList = null;
            if (this._leftView)
            {
                this._leftView.dispose();
            };
            this._leftView = null;
            ObjectUtils.disposeObject(_helpButton);
            _helpButton = null;
            ObjectUtils.disposeObject(this._helpFrame);
            this._helpFrame = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package consortion.view.selfConsortia

