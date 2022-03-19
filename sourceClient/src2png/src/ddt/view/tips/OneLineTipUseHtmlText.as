// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.OneLineTipUseHtmlText

package ddt.view.tips
{
    import road7th.utils.StringHelper;

    public class OneLineTipUseHtmlText extends OneLineTip 
    {


        override public function set tipData(_arg_1:Object):void
        {
            _data = _arg_1;
            if (_data)
            {
                _contentTxt.htmlText = StringHelper.trim(String(_data));
                updateTransform();
                this.visible = true;
            }
            else
            {
                this.visible = false;
            };
        }


    }
}//package ddt.view.tips

