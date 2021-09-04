package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaEventInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class EventList extends Sprite implements Disposeable
   {
       
      
      private var _bg:MutipleImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _list:ScrollPanel;
      
      private var _line:MutipleImage;
      
      public function EventList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.ddtconsortion.eventbgRect");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("memberlist.Bg");
         this._bg.imageRectString = "0|590|0|436|13,0|588|0|35|13";
         this._bg.height = _loc1_.height;
         this._line = ComponentFactory.Instance.creatComponentByStylename("consortion.EventItemVLine");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("memberList.nameText");
         this._titleTxt.text = "公会日志";
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("memberList.nameText");
         this._timeTxt.text = "时间";
         PositionUtils.setPos(this._line,"asset.ddtconsortion.eventTilteLine");
         PositionUtils.setPos(this._titleTxt,"asset.ddtconsortion.eventListTitleTxt");
         PositionUtils.setPos(this._timeTxt,"asset.ddtconsortion.eventListTimeTxt");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventVbox");
         this._list = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.eventPanel");
         this._list.setView(this._vbox);
         addChild(this._bg);
         addChild(this._line);
         addChild(this._titleTxt);
         addChild(this._timeTxt);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.EVENT_LIST_CHANGE,this.__eventChangeHandler);
      }
      
      private function removeEvent() : void
      {
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.EVENT_LIST_CHANGE,this.__eventChangeHandler);
      }
      
      private function __eventChangeHandler(param1:ConsortionEvent) : void
      {
         var _loc5_:EventListItem = null;
         this._vbox.disposeAllChildren();
         var _loc2_:Vector.<ConsortiaEventInfo> = ConsortionModelControl.Instance.model.eventList;
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         if(_loc3_ == 0)
         {
            while(_loc4_ < 11)
            {
               _loc5_ = new EventListItem();
               _loc5_.updateBaceGroud(_loc4_);
               this._vbox.addChild(_loc5_);
               _loc4_++;
            }
         }
         else if(_loc3_ >= 11)
         {
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new EventListItem();
               _loc5_.updateBaceGroud(_loc4_);
               _loc5_.info = _loc2_[_loc4_];
               this._vbox.addChild(_loc5_);
               _loc4_++;
            }
         }
         else
         {
            while(_loc4_ < 11)
            {
               if(_loc4_ < _loc3_)
               {
                  _loc5_ = new EventListItem();
                  _loc5_.updateBaceGroud(_loc4_);
                  _loc5_.info = _loc2_[_loc4_];
                  this._vbox.addChild(_loc5_);
               }
               else
               {
                  _loc5_ = new EventListItem();
                  _loc5_.updateBaceGroud(_loc4_);
                  this._vbox.addChild(_loc5_);
               }
               _loc4_++;
            }
         }
         this._list.invalidateViewport();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._vbox)
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._line)
         {
            ObjectUtils.disposeObject(this._line);
         }
         this._line = null;
         if(this._titleTxt)
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(this._timeTxt)
         {
            ObjectUtils.disposeObject(this._timeTxt);
         }
         this._timeTxt = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         ObjectUtils.disposeAllChildren(this);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
