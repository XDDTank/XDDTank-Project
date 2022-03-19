// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.buff.buffButton.FreeBuffButton

package ddt.view.buff.buffButton
{
    import ddt.data.BuffInfo;
    import flash.events.MouseEvent;
    import ddt.view.tips.BuffTipInfo;

    public class FreeBuffButton extends BuffButton 
    {

        public function FreeBuffButton()
        {
            super("asset.core.freeAsset");
            this.info = new BuffInfo(BuffInfo.FREE);
        }

        override protected function __onclick(_arg_1:MouseEvent):void
        {
        }

        override public function set info(_arg_1:BuffInfo):void
        {
        }

        override public function get tipData():Object
        {
            if (_tipData == null)
            {
                _tipData = new BuffTipInfo();
                _tipData.isActive = true;
                _tipData.isFree = true;
            };
            return (_tipData);
        }


    }
}//package ddt.view.buff.buffButton

