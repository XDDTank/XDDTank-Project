// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.BunIcon

package platformapi.tencent.view
{
    import com.pickgliss.ui.core.Component;
    import platformapi.tencent.interfaces.IDiamondIcon;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.UICreatShortcut;
    import com.pickgliss.utils.ObjectUtils;

    public class BunIcon extends Component implements IDiamondIcon 
    {

        private var _diamond:ScaleFrameImage;
        private var _level:int;

        public function BunIcon()
        {
            this._diamond = UICreatShortcut.creatAndAdd("platformapi.tencent.bunDiamondIcon", this);
        }

        public function set level(_arg_1:int):void
        {
            this._level = _arg_1;
            if (((_arg_1 > 0) && (_arg_1 < 7)))
            {
                this._diamond.setFrame(this._level);
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._diamond);
            this._diamond = null;
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


    }
}//package platformapi.tencent.view

