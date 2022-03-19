// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityList

package activity.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ScrollPanel;
    import activity.data.ActivityInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityList extends Sprite implements Disposeable 
    {

        private var _list:ScrollPanel;
        private var _activityMenu:ActivityMenu;

        public function ActivityList()
        {
            this.configUI();
            this.addEvent();
        }

        public function updateData(_arg_1:ActivityInfo=null):void
        {
            this._activityMenu.updateData(_arg_1);
        }

        private function configUI():void
        {
            this._list = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityList");
            addChild(this._list);
            this._activityMenu = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityMenu");
            this._list.setView(this._activityMenu);
        }

        private function addEvent():void
        {
            this._activityMenu.addEventListener(ActivityMenu.MENU_REFRESH, this.__menuItemClick);
        }

        private function removeEvent():void
        {
            this._activityMenu.removeEventListener(ActivityMenu.MENU_REFRESH, this.__menuItemClick);
        }

        private function __menuItemClick(_arg_1:Event):void
        {
            this._list.invalidateViewport();
        }

        public function setActivityDate(_arg_1:Date):void
        {
            this._activityMenu.setActivityDate(_arg_1);
            this._list.invalidateViewport();
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._list);
            this._list = null;
            ObjectUtils.disposeObject(this._activityMenu);
            this._activityMenu = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package activity.view

