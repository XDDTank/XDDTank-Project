// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//calendar.view.SignAwardCell

package calendar.view
{
    import bagAndInfo.cell.BaseCell;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class SignAwardCell extends BaseCell 
    {

        private var _bigBack:DisplayObject;
        private var _nameField:FilterFrameText;

        public function SignAwardCell()
        {
            super(ComponentFactory.Instance.creatBitmap("asset.ddtcalendar.SignedAward.CellBack"));
            this._bigBack = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SignedAward.SignAwardCellBg");
            addChildAt(this._bigBack, 0);
            this._nameField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.AwardNameField");
            addChild(this._nameField);
            _tbxCount = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.SignedAwardCellCount");
            _tbxCount.mouseEnabled = false;
            addChild(_tbxCount);
        }

        public function setCount(_arg_1:int):void
        {
            if (_arg_1 > 0)
            {
                _tbxCount.text = _arg_1.toString();
            }
            else
            {
                _tbxCount.text = "";
            };
            _tbxCount.x = (49 - _tbxCount.width);
            _tbxCount.y = (49 - _tbxCount.height);
            setChildIndex(_tbxCount, (numChildren - 1));
        }

        override protected function createChildren():void
        {
            super.createChildren();
            _picPos = ComponentFactory.Instance.creatCustomObject("ddtcalendar.Award.pic.TopLeft");
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            super.info = _arg_1;
            if (_info)
            {
                this._nameField.text = _info.Name;
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._bigBack);
            this._bigBack = null;
            ObjectUtils.disposeObject(_tbxCount);
            _tbxCount = null;
            super.dispose();
        }


    }
}//package calendar.view

