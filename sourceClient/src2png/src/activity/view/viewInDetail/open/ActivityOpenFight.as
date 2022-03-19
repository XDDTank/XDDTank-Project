// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.open.ActivityOpenFight

package activity.view.viewInDetail.open
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import com.pickgliss.ui.ComponentFactory;

    public class ActivityOpenFight extends ActivityBaseDetailView 
    {


        override protected function initView():void
        {
            _cellNumInRow = 3;
            _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenFight.cellList", [_cellNumInRow]);
            addChild(_cellList);
            _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityOpenFight.cellPanel");
            addChild(_panel);
            _panel.setView(_cellList);
            super.initView();
        }


    }
}//package activity.view.viewInDetail.open

