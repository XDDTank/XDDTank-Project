// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.open.ActivityOpenDivoce

package activity.view.viewInDetail.open
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import activity.view.ActivityCell;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityOpenDivoce extends ActivityBaseDetailView 
    {

        private var _bg:ScaleBitmapImage;


        override public function setCellFilter(_arg_1:ActivityCell, _arg_2:int):void
        {
            if ((!(canAcceptByRecieveNum)))
            {
                _arg_1.canGet = false;
                _arg_1.hasGet = true;
            };
        }

        override protected function initView():void
        {
            _cellNumInRow = 4;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcalendar.ActivityChurchCell.bg");
            addChild(this._bg);
            _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenDivoce.cellList", [_cellNumInRow]);
            addChild(_cellList);
            _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityOpenDivoce.cellPanel");
            addChild(_panel);
            _panel.setView(_cellList);
            super.initView();
        }

        override protected function initCells():void
        {
            var _local_1:ActivityCell;
            var _local_2:int;
            while (_local_2 < _rewars.length)
            {
                _local_1 = new ActivityCell(_rewars.list[_local_2], true, ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBgI"));
                _local_1.count = _rewars.list[_local_2].Count;
                _cellList.addChild(_local_1);
                if (_local_2 >= conditions.length)
                {
                    this.setCellFilter(_local_1, conditions[0]);
                }
                else
                {
                    this.setCellFilter(_local_1, conditions[_local_2]);
                };
                _local_2++;
            };
            if (_cellList.numChildren == 1)
            {
                this._bg.width = 126;
                this._bg.height = 89;
                this._bg.x = -46;
                this._bg.y = 44;
                _panel.x = -12;
                _panel.y = 44;
            }
            else
            {
                if (_cellList.numChildren == 2)
                {
                    this._bg.width = 226;
                    this._bg.height = 89;
                    this._bg.x = -98;
                    this._bg.y = 42;
                    _panel.x = -48;
                    _panel.y = 42;
                }
                else
                {
                    if (_cellList.numChildren == 3)
                    {
                        this._bg.width = 226;
                        this._bg.height = 89;
                        this._bg.x = -98;
                        this._bg.y = 42;
                        _panel.x = -76;
                        _panel.y = 42;
                    }
                    else
                    {
                        this._bg.width = 286;
                        this._bg.height = 107;
                        this._bg.x = -99;
                        this._bg.y = 38;
                    };
                };
            };
            _panel.vScrollProxy = ((_cellList.numChildren > _cellNumInRow) ? 0 : 2);
        }

        override public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            super.dispose();
        }


    }
}//package activity.view.viewInDetail.open

