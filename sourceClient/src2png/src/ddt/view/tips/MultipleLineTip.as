// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.MultipleLineTip

package ddt.view.tips
{
    public class MultipleLineTip extends OneLineTip 
    {

        public function MultipleLineTip()
        {
            _contentTxt.wordWrap = true;
        }

        override protected function updateTransform():void
        {
            _bg.width = _tipWidth;
            _contentTxt.width = (_bg.width - 16);
            _bg.height = (_contentTxt.height + 8);
            _contentTxt.x = (_bg.x + 8);
            _contentTxt.y = (_bg.y + 4);
        }


    }
}//package ddt.view.tips

