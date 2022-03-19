// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityFrame

package activity.view
{
    import com.pickgliss.ui.controls.Frame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.LayerManager;
    import activity.data.ActivityInfo;
    import activity.ActivityController;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityFrame extends Frame 
    {

        private var _stateback:Bitmap;
        private var _activityback:Bitmap;
        private var _currentState:ActivityState;
        private var _state:int;
        private var _activityList:ActivityList;
        private var _titlebitmap:Bitmap;

        public function ActivityFrame()
        {
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            this.refreshList();
        }

        public function setData(_arg_1:ActivityInfo):void
        {
            this._currentState.setData(_arg_1);
        }

        public function updateData(_arg_1:ActivityInfo=null):void
        {
            if ((!(ActivityController.instance.checkFinish(_arg_1))))
            {
                this._currentState.updataData();
            };
            this._activityList.updateData(_arg_1);
        }

        private function refreshList():void
        {
            this._activityList.setActivityDate(TimeManager.Instance.Now());
        }

        private function initView():void
        {
            this._stateback = ComponentFactory.Instance.creatBitmap("ddtcalendar.StateBg");
            addToContent(this._stateback);
            this._activityback = ComponentFactory.Instance.creatBitmap("ddtcalendar.ActivityBg");
            addToContent(this._activityback);
            this._activityList = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityList");
            addToContent(this._activityList);
            this._titlebitmap = ComponentFactory.Instance.creatBitmap("asset.activity.CalendarTitle");
            addToContent(this._titlebitmap);
            this._currentState = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityState");
            addToContent(this._currentState);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    ActivityController.instance.hideFrame();
                    return;
            };
        }

        public function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._stateback);
            this._stateback = null;
            ObjectUtils.disposeObject(this._activityback);
            this._activityback = null;
            ObjectUtils.disposeObject(this._activityList);
            this._activityList = null;
            ObjectUtils.disposeObject(this._currentState);
            this._currentState = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package activity.view

