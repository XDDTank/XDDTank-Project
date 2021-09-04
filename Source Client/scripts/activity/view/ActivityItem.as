package activity.view
{
   import activity.ActivityController;
   import activity.data.ActivityInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ActivityItem extends Sprite implements Disposeable
   {
       
      
      protected var _back:ScaleFrameImage;
      
      protected var _icon:ScaleFrameImage;
      
      protected var _titleField:FilterFrameText;
      
      protected var _quanMC:MovieClip;
      
      protected var _info:ActivityInfo;
      
      protected var _selected:Boolean = false;
      
      public function ActivityItem(param1:ActivityInfo)
      {
         super();
         this._info = param1;
         buttonMode = true;
         this.initView();
         this.initEvent();
      }
      
      public function get info() : ActivityInfo
      {
         return this._info;
      }
      
      public function set info(param1:ActivityInfo) : void
      {
         this._info = param1;
      }
      
      protected function initView() : void
      {
         var _loc1_:int = 0;
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellBg");
         DisplayUtils.setFrame(this._back,!!this._selected ? int(2) : int(1));
         addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleText");
         this._titleField.htmlText = "<b>·</b> " + this._info.ActivityName;
         if(this._titleField.textWidth > 90)
         {
            _loc1_ = this._titleField.getCharIndexAtPoint(this._titleField.x + 86,this._titleField.y + 2);
            if(_loc1_ != -1)
            {
               this._titleField.htmlText = "<b>·</b> " + this._info.ActivityName.substring(0,_loc1_) + "...";
            }
         }
         addChild(this._titleField);
         this._icon = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleIcon");
         DisplayUtils.setFrame(this._icon,this.getActivityDispType(this._info.ActivityType));
         addChild(this._icon);
         if(!this._quanMC)
         {
            this._quanMC = ClassUtils.CreatInstance("asset.ddtActivity.MC");
            this._quanMC.mouseChildren = false;
            this._quanMC.mouseEnabled = false;
            this._quanMC.gotoAndPlay(1);
            this._quanMC.x = -3;
            this._quanMC.y = 4;
         }
         addChild(this._quanMC);
         if(ActivityController.instance.checkFinish(this._info))
         {
            this._quanMC.visible = false;
         }
         else
         {
            this._quanMC.visible = true;
         }
      }
      
      protected function initEvent() : void
      {
      }
      
      protected function getActivityDispType(param1:int) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 1:
               _loc2_ = 1;
               break;
            case 2:
               _loc2_ = 2;
               break;
            case 3:
               _loc2_ = 3;
               break;
            case 4:
               _loc2_ = 4;
               break;
            case 5:
               _loc2_ = 5;
               break;
            case 6:
               _loc2_ = 6;
               break;
            case 0:
            case 7:
               _loc2_ = 7;
               break;
            case 8:
               _loc2_ = 3;
               break;
            case 9:
               _loc2_ = 3;
               break;
            case 10:
               _loc2_ = 1;
               break;
            default:
               _loc2_ = 6;
         }
         return _loc2_;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         DisplayUtils.setFrame(this._back,!!this._selected ? int(2) : int(1));
         DisplayUtils.setFrame(this._titleField,!!this._selected ? int(2) : int(1));
      }
      
      protected function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         if(this._quanMC)
         {
            ObjectUtils.disposeObject(this._quanMC);
         }
         this._quanMC = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
