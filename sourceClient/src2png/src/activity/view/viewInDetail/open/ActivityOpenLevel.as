// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.open.ActivityOpenLevel

package activity.view.viewInDetail.open
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import activity.view.ActivityCell;
    import activity.ActivityController;
    import com.pickgliss.ui.ComponentFactory;

    public class ActivityOpenLevel extends ActivityBaseDetailView 
    {


        override protected function initCells():void
        {
            var _local_1:ActivityCell;
            var _local_2:int;
            while (_local_2 < _rewars.length)
            {
                _local_1 = new ActivityCell(_rewars.list[_local_2], false);
                _local_1.count = _rewars.list[_local_2].Count;
                _cellList.addChild(_local_1);
                this.setCellFilter(_local_1, conditions[_local_2]);
                _local_2++;
            };
        }

        override public function setCellFilter(_arg_1:ActivityCell, _arg_2:int):void
        {
            if (((nowState < _arg_2) || (_arg_2 <= ActivityController.instance.model.getLog(_info.ActivityId))))
            {
                _arg_1.canGet = false;
                if (_arg_2 <= ActivityController.instance.model.getLog(_info.ActivityId))
                {
                    _arg_1.hasGet = true;
                };
            };
        }

        override protected function initView():void
        {
            _cellNumInRow = 3;
            _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenLevel.cellList", [_cellNumInRow]);
            addChild(_cellList);
            super.initView();
        }


    }
}//package activity.view.viewInDetail.open

