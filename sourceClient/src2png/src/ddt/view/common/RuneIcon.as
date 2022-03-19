// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.RuneIcon

package ddt.view.common
{
    import com.pickgliss.ui.core.Component;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.player.PlayerInfo;

    public class RuneIcon extends Component 
    {

        private var _icon:Bitmap;


        override protected function init():void
        {
            super.init();
            this._icon = ComponentFactory.Instance.creat("asset.ddtbagAndInfo.EmbedIcon");
            addChild(this._icon);
            tipStyle = "core.EmbedTips";
            tipGapH = 5;
            tipGapV = 5;
            tipDirctions = "2";
        }

        public function setInfo(_arg_1:PlayerInfo):void
        {
            tipData = _arg_1;
            if (_arg_1.runeLevel <= 0)
            {
                filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                filters = null;
            };
        }


    }
}//package ddt.view.common

