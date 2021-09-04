package login.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Role;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SelectListManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
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
         super();
         this.configUi();
      }
      
      private function configUi() : void
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
         var _loc1_:int = 0;
         while(_loc1_ < SelectListManager.Instance.list.length)
         {
            this.addRole(SelectListManager.Instance.list[_loc1_] as Role);
            _loc1_++;
         }
      }
      
      private function addEvent() : void
      {
         this._enterButton.addEventListener(MouseEvent.CLICK,this.__onEnterClick);
         this._roleList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onRoleClick);
      }
      
      private function removeEvent() : void
      {
         if(this._enterButton)
         {
            this._enterButton.removeEventListener(MouseEvent.CLICK,this.__onEnterClick);
         }
         this._roleList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onRoleClick);
      }
      
      private function __onEnterClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedItem == null)
         {
            return;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function __onRoleClick(param1:ListItemEvent) : void
      {
         var _loc2_:RoleItem = param1.cell as RoleItem;
         this.selectedItem = _loc2_;
      }
      
      private function startRenameConsortia(param1:Role) : void
      {
         this._consortiaRenameFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaRenameFrame");
         this._consortiaRenameFrame.roleInfo = param1;
         this._consortiaRenameFrame.addEventListener(Event.COMPLETE,this.__consortiaRenameComplete);
         LayerManager.Instance.addToLayer(this._consortiaRenameFrame,LayerManager.STAGE_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function startRename(param1:Role) : void
      {
         this._renameFrame = ComponentFactory.Instance.creatComponentByStylename("RoleRenameFrame");
         this._renameFrame.roleInfo = param1;
         this._renameFrame.addEventListener(Event.COMPLETE,this.__onRenameComplete);
         LayerManager.Instance.addToLayer(this._renameFrame,LayerManager.STAGE_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __onRenameComplete(param1:Event) : void
      {
         this._renameFrame.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._renameFrame);
         this._renameFrame = null;
         this.__onEnterClick(null);
      }
      
      private function __consortiaRenameComplete(param1:Event) : void
      {
         this._consortiaRenameFrame.removeEventListener(Event.COMPLETE,this.__onRenameComplete);
         ObjectUtils.disposeObject(this._consortiaRenameFrame);
         this._consortiaRenameFrame = null;
         this.__onEnterClick(null);
      }
      
      public function addRole(param1:Role) : void
      {
         this._roleList.vectorListModel.insertElementAt(param1,this._roleList.vectorListModel.elements.length);
      }
      
      override public function dispose() : void
      {
         this._visible = false;
         this.removeEvent();
         if(this._listBack)
         {
            ObjectUtils.disposeObject(this._listBack);
            this._listBack = null;
         }
         if(this._gradeText)
         {
            ObjectUtils.disposeObject(this._gradeText);
            this._gradeText = null;
         }
         if(this._nameText)
         {
            ObjectUtils.disposeObject(this._nameText);
            this._nameText = null;
         }
         if(this._roleList)
         {
            ObjectUtils.disposeObject(this._roleList);
            this._roleList = null;
         }
         if(this._enterButton)
         {
            ObjectUtils.disposeObject(this._enterButton);
            this._enterButton = null;
         }
         super.dispose();
      }
      
      public function get selectedRole() : Role
      {
         return this._selectedItem.roleInfo;
      }
      
      public function get selectedItem() : RoleItem
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:RoleItem) : void
      {
         var _loc2_:RoleItem = null;
         if(this._selectedItem != param1)
         {
            _loc2_ = this._selectedItem;
            this._selectedItem = param1;
            if(this._selectedItem != null)
            {
               this._selectedItem.selected = true;
               SelectListManager.Instance.currentLoginRole = this._selectedItem.roleInfo;
            }
            if(_loc2_)
            {
               _loc2_.selected = false;
               _loc2_ = null;
            }
         }
      }
   }
}
