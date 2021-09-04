package activity.view
{
   import activity.data.ActivityInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DisplayUtils;
   
   public class ActivityItemOpen extends ActivityItem
   {
       
      
      public function ActivityItemOpen(param1:ActivityInfo)
      {
         super(param1);
      }
      
      override protected function initView() : void
      {
         var _loc1_:int = 0;
         _back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellBg");
         DisplayUtils.setFrame(_back,!!_selected ? int(2) : int(1));
         addChild(_back);
         _titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleTextOpen");
         _titleField.htmlText = "<b>·</b> " + _info.ActivityName;
         if(_titleField.textWidth > 150)
         {
            _loc1_ = _titleField.getCharIndexAtPoint(_titleField.x + 86,_titleField.y + 2);
            if(_loc1_ != -1)
            {
               _titleField.htmlText = "<b>·</b> " + _info.ActivityName.substring(0,_loc1_) + "...";
            }
         }
         addChild(_titleField);
      }
   }
}
