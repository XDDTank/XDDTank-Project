// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.action.FrameShowAction

package ddt.action
{
    import com.pickgliss.action.BaseAction;

    public class FrameShowAction extends BaseAction 
    {

        private var _frame:Object;
        private var _showFun:Function;

        public function FrameShowAction(_arg_1:Object, _arg_2:Function=null, _arg_3:uint=0)
        {
            this._frame = _arg_1;
            this._showFun = _arg_2;
            super(_arg_3);
        }

        override public function act():void
        {
            if ((this._showFun is Function))
            {
                this._showFun();
            }
            else
            {
                this._frame.show();
            };
            super.act();
        }


    }
}//package ddt.action

