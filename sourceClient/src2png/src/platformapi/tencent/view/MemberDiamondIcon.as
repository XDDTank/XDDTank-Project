// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.MemberDiamondIcon

package platformapi.tencent.view
{
    import com.pickgliss.ui.core.Component;
    import platformapi.tencent.interfaces.IDiamondIcon;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.UICreatShortcut;
    import com.pickgliss.utils.ObjectUtils;

    public class MemberDiamondIcon extends Component implements IDiamondIcon 
    {

        private var _diamond:ScaleFrameImage;
        private var _level:int;

        public function MemberDiamondIcon()
        {
            this._diamond = UICreatShortcut.creatAndAdd("platformapi.tencent.memberDiamondIcon", this);
        }

        public function set level(_arg_1:int):void
        {
            this._level = _arg_1;
            if (this._level < 1)
            {
                this._level = 1;
            }
            else
            {
                if (this._level > 7)
                {
                    this._level = 7;
                };
            };
            this._diamond.setFrame(this._level);
        }

        override public function get width():Number
        {
            return ((this._diamond) ? this._diamond.width : 0);
        }

        override public function get height():Number
        {
            return ((this._diamond) ? this._diamond.height : 0);
        }

        public function get level():int
        {
            return (this._level);
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._diamond);
            this._diamond = null;
        }


    }
}//package platformapi.tencent.view

