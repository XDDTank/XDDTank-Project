// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.Repute

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class Repute extends Sprite implements Disposeable 
    {

        public static const LEFT:String = "left";
        public static const RIGHT:String = "right";

        protected var _repute:int;
        protected var _level:int;
        protected var _reputeTxt:FilterFrameText;
        protected var _reputeBg:Bitmap;
        protected var _align:String = "right";
        protected var dx:int;

        public function Repute(_arg_1:int=0, _arg_2:int=0)
        {
            this._repute = _arg_1;
            this._level = _arg_2;
            this._reputeBg = ComponentFactory.Instance.creat("asset.core.leveltip.ReputeBg");
            this._reputeTxt = ComponentFactory.Instance.creat("core.ReputeTxt");
            this.dx = this._reputeTxt.x;
            addChild(this._reputeBg);
            addChild(this._reputeTxt);
            this.setRepute(this._repute);
        }

        public function set level(_arg_1:int):void
        {
            this._level = _arg_1;
        }

        public function setRepute(_arg_1:int):void
        {
            this._repute = _arg_1;
            this._reputeTxt.text = ((((this._level <= 3) || (_arg_1 > 9999999)) || (_arg_1 == 0)) ? LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.new") : String(_arg_1));
            this._reputeTxt.width = (this._reputeTxt.textWidth + 3);
            if (this._align == LEFT)
            {
                this._reputeBg.x = 0;
                this._reputeTxt.x = (this._reputeBg.x + this.dx);
            }
            else
            {
                this._reputeTxt.x = -(this._reputeTxt.textWidth);
                this._reputeBg.x = (this._reputeTxt.x - this.dx);
            };
        }

        public function set align(_arg_1:String):void
        {
            this._align = _arg_1;
            if (_arg_1 == LEFT)
            {
                this._reputeBg.x = 0;
                this._reputeTxt.x = (this._reputeBg.x + this.dx);
            }
            else
            {
                this._reputeTxt.x = -(this._reputeTxt.textWidth);
                this._reputeBg.x = (this._reputeTxt.x - this.dx);
            };
        }

        public function dispose():void
        {
            if (this._reputeTxt)
            {
                ObjectUtils.disposeObject(this._reputeTxt);
            };
            this._reputeTxt = null;
            if (this._reputeBg)
            {
                ObjectUtils.disposeObject(this._reputeBg);
            };
            this._reputeBg = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

