// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.YellowDiamondIcon

package platformapi.tencent.view
{
    import com.pickgliss.ui.core.Component;
    import platformapi.tencent.interfaces.IDiamondIcon;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.UICreatShortcut;
    import com.pickgliss.utils.ObjectUtils;

    public class YellowDiamondIcon extends Component implements IDiamondIcon 
    {

        private var _diamond:Bitmap;
        private var _levelTxt:FilterFrameText;
        private var _level:int;

        public function YellowDiamondIcon()
        {
            this._diamond = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.IMDiamond", this);
            this._levelTxt = UICreatShortcut.creatAndAdd("IM.view.memberIconText", this);
        }

        public function set level(_arg_1:int):void
        {
            this._level = _arg_1;
            this._levelTxt.text = _arg_1.toString();
        }

        public function get level():int
        {
            return (this._level);
        }

        override public function get width():Number
        {
            return ((this._diamond) ? this._diamond.width : 0);
        }

        override public function get height():Number
        {
            return ((this._diamond) ? this._diamond.height : 0);
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._diamond);
            this._diamond = null;
            ObjectUtils.disposeObject(this._levelTxt);
            this._levelTxt = null;
        }


    }
}//package platformapi.tencent.view

