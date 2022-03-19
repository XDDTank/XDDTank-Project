// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//login.view.ChooseRoleFrame

package login.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.container.VBox;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.ui.controls.ListPanel;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SelectListManager;
    import ddt.data.Role;
    import flash.events.MouseEvent;
    import com.pickgliss.events.ListItemEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ChooseRoleFrame extends Frame 
    {

        private var _visible:Boolean = true;
        private var _listBack:MutipleImage;
        private var _enterButton:BaseButton;
        private var _list:VBox;
        private var _selectedItem:RoleItem;
        private var _disenabelFilter:ColorMatrixFilter;
        private var _rename:Boolean = false;
        private var _renameFrame:RoleRenameFrame;
        private var _consortiaRenameFrame:ConsortiaRenameFrame;
        private var _roleList:ListPanel;
        private var _gradeText:FilterFrameText;
        private var _nameText:FilterFrameText;

        public function ChooseRoleFrame()
        {
            this.configUi();
        }

        private function configUi():void
        {
            this._disenabelFilter = ComponentFactory.Instance.model.getSet("login.ChooseRole.DisenableGF");
            titleStyle = "login.Title";
            titleText = LanguageMgr.GetTranslation("tank.loginstate.chooseCharacter");
            this._listBack = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.bg");
            addToContent(this._listBack);
            this._gradeText = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.gradeText");
            addToContent(this._gradeText);
            this._nameText = ComponentFactory.Instance.creatComponentByStylename("login.chooseRoleFrame.nameText");
            addToContent(this._nameText);
            this._roleList = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.RoleList");
            addToContent(this._roleList);
            this._enterButton = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.EnterButton");
            addToContent(this._enterButton);
            this.addEvent();
            var _local_1:int;
            while (_local_1 < SelectListManager.Instance.list.length)
            {
                this.addRole((SelectListManager.Instance.list[_local_1] as Role));
                _local_1++;
            };
        }

        private function addEvent():void
        {
            this._enterButton.addEventListener(MouseEvent.CLICK, this.__onEnterClick);
            this._roleList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__onRoleClick);
        }

        private function removeEvent():void
        {
            if (this._enterButton)
            {
                this._enterButton.removeEventListener(MouseEvent.CLICK, this.__onEnterClick);
            };
            this._roleList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__onRoleClick);
        }

        private function __onEnterClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._selectedItem == null)
            {
                return;
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function __onRoleClick(_arg_1:ListItemEvent):void
        {
            var _local_2:RoleItem = (_arg_1.cell as RoleItem);
            this.selectedItem = _local_2;
        }

        private function startRenameConsortia(_arg_1:Role):void
        {
            this._consortiaRenameFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaRenameFrame");
            this._consortiaRenameFrame.roleInfo = _arg_1;
            this._consortiaRenameFrame.addEventListener(Event.COMPLETE, this.__consortiaRenameComplete);
            LayerManager.Instance.addToLayer(this._consortiaRenameFrame, LayerManager.STAGE_TOP_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function startRename(_arg_1:Role):void
        {
            this._renameFrame = ComponentFactory.Instance.creatComponentByStylename("RoleRenameFrame");
            this._renameFrame.roleInfo = _arg_1;
            this._renameFrame.addEventListener(Event.COMPLETE, this.__onRenameComplete);
            LayerManager.Instance.addToLayer(this._renameFrame, LayerManager.STAGE_TOP_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function __onRenameComplete(_arg_1:Event):void
        {
            this._renameFrame.removeEventListener(Event.COMPLETE, this.__onRenameComplete);
            ObjectUtils.disposeObject(this._renameFrame);
            this._renameFrame = null;
            this.__onEnterClick(null);
        }

        private function __consortiaRenameComplete(_arg_1:Event):void
        {
            this._consortiaRenameFrame.removeEventListener(Event.COMPLETE, this.__onRenameComplete);
            ObjectUtils.disposeObject(this._consortiaRenameFrame);
            this._consortiaRenameFrame = null;
            this.__onEnterClick(null);
        }

        public function addRole(_arg_1:Role):void
        {
            this._roleList.vectorListModel.insertElementAt(_arg_1, this._roleList.vectorListModel.elements.length);
        }

        override public function dispose():void
        {
            this._visible = false;
            this.removeEvent();
            if (this._listBack)
            {
                ObjectUtils.disposeObject(this._listBack);
                this._listBack = null;
            };
            if (this._gradeText)
            {
                ObjectUtils.disposeObject(this._gradeText);
                this._gradeText = null;
            };
            if (this._nameText)
            {
                ObjectUtils.disposeObject(this._nameText);
                this._nameText = null;
            };
            if (this._roleList)
            {
                ObjectUtils.disposeObject(this._roleList);
                this._roleList = null;
            };
            if (this._enterButton)
            {
                ObjectUtils.disposeObject(this._enterButton);
                this._enterButton = null;
            };
            super.dispose();
        }

        public function get selectedRole():Role
        {
            return (this._selectedItem.roleInfo);
        }

        public function get selectedItem():RoleItem
        {
            return (this._selectedItem);
        }

        public function set selectedItem(_arg_1:RoleItem):void
        {
            var _local_2:RoleItem;
            if (this._selectedItem != _arg_1)
            {
                _local_2 = this._selectedItem;
                this._selectedItem = _arg_1;
                if (this._selectedItem != null)
                {
                    this._selectedItem.selected = true;
                    SelectListManager.Instance.currentLoginRole = this._selectedItem.roleInfo;
                };
                if (_local_2)
                {
                    _local_2.selected = false;
                    _local_2 = null;
                };
            };
        }


    }
}//package login.view

