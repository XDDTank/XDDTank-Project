package activity.view
{
   import activity.data.ActivityInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ActivityList extends Sprite implements Disposeable
   {
       
      
      private var _list:ScrollPanel;
      
      private var _activityMenu:ActivityMenu;
      
      public function ActivityList()
      {
         super();
         this.configUI();
         this.addEvent();
      }
      
      public function updateData(param1:ActivityInfo = null) : void
      {
         this._activityMenu.updateData(param1);
      }
      
      private function configUI() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityList");
         addChild(this._list);
         this._activityMenu = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityMenu");
         this._list.setView(this._activityMenu);
      }
      
      private function addEvent() : void
      {
         this._activityMenu.addEventListener(ActivityMenu.MENU_REFRESH,this.__menuItemClick);
      }
      
      private function removeEvent() : void
      {
         this._activityMenu.removeEventListener(ActivityMenu.MENU_REFRESH,this.__menuItemClick);
      }
      
      private function __menuItemClick(param1:Event) : void
      {
         this._list.invalidateViewport();
      }
      
      public function setActivityDate(param1:Date) : void
      {
         this._activityMenu.setActivityDate(param1);
         this._list.invalidateViewport();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._activityMenu);
         this._activityMenu = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
