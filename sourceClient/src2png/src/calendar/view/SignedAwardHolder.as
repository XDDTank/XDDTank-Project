// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.SignedAwardHolder

package calendar.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import calendar.CalendarModel;
    import __AS3__.vec.Vector;
    import ddt.data.DaylyGiveInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.ItemManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SignedAwardHolder extends Sprite implements Disposeable 
    {

        private var _back:DisplayObject;
        private var _model:CalendarModel;
        private var _awardCells:Vector.<SignAwardCell> = new Vector.<SignAwardCell>();

        public function SignedAwardHolder(_arg_1:CalendarModel)
        {
            this._model = _arg_1;
            this.configUI();
        }

        public function setAwardsByCount(_arg_1:int):void
        {
            var _local_4:DaylyGiveInfo;
            var _local_5:SignAwardCell;
            this.clean();
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("ddtcalendar.Award.cell.TopLeft");
            var _local_3:int;
            for each (_local_4 in this._model.awards)
            {
                if (_local_4.AwardDays == _arg_1)
                {
                    _local_5 = ComponentFactory.Instance.creatCustomObject("ddtcalendar.SignAwardCell");
                    this._awardCells.push(_local_5);
                    _local_5.info = ItemManager.Instance.getTemplateById(_local_4.TemplateID);
                    _local_5.x = (_local_2.x + (_local_3 * 132));
                    _local_5.y = _local_2.y;
                    _local_5.setCount(_local_4.Count);
                    addChild(_local_5);
                    _local_3++;
                };
            };
        }

        public function clean():void
        {
            var _local_1:SignAwardCell;
            while ((_local_1 = this._awardCells.shift()))
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._awardCells.shift();
            };
        }

        private function configUI():void
        {
            this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.AwardHolderBack");
            addChild(this._back);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            this.clean();
            this._model = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package calendar.view

