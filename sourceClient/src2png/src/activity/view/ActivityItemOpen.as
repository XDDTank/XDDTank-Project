// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityItemOpen

package activity.view
{
    import activity.data.ActivityInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;

    public class ActivityItemOpen extends ActivityItem 
    {

        public function ActivityItemOpen(_arg_1:ActivityInfo)
        {
            super(_arg_1);
        }

        override protected function initView():void
        {
            var _local_1:int;
            _back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellBg");
            DisplayUtils.setFrame(_back, ((_selected) ? 2 : 1));
            addChild(_back);
            _titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleTextOpen");
            _titleField.htmlText = ("<b>·</b> " + _info.ActivityName);
            if (_titleField.textWidth > 150)
            {
                _local_1 = _titleField.getCharIndexAtPoint((_titleField.x + 86), (_titleField.y + 2));
                if (_local_1 != -1)
                {
                    _titleField.htmlText = (("<b>·</b> " + _info.ActivityName.substring(0, _local_1)) + "...");
                };
            };
            addChild(_titleField);
        }


    }
}//package activity.view

