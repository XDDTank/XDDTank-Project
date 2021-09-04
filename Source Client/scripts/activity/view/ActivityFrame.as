package activity.view
{
   import activity.ActivityController;
   import activity.data.ActivityInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   
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
         super();
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this.refreshList();
      }
      
      public function setData(param1:ActivityInfo) : void
      {
         this._currentState.setData(param1);
      }
      
      public function updateData(param1:ActivityInfo = null) : void
      {
         if(!ActivityController.instance.checkFinish(param1))
         {
            this._currentState.updataData();
         }
         this._activityList.updateData(param1);
      }
      
      private function refreshList() : void
      {
         this._activityList.setActivityDate(TimeManager.Instance.Now());
      }
      
      private function initView() : void
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
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               ActivityController.instance.hideFrame();
         }
      }
      
      public function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      override public function dispose() : void
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
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
