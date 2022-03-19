// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.GuildRepute

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;

    public class GuildRepute extends Sprite implements Disposeable 
    {

        private var _reputeTxt:FilterFrameText;
        private var _reputeBg:Bitmap;

        public function GuildRepute()
        {
            this._reputeBg = ComponentFactory.Instance.creat("asset.core.leveltip.ReputeBg");
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("asset.core.guildReputePos");
            this._reputeBg.x = _local_1.x;
            this._reputeTxt = ComponentFactory.Instance.creat("core.guildReputeTxt");
            addChild(this._reputeBg);
            addChild(this._reputeTxt);
        }

        public function setRepute(_arg_1:int):void
        {
            this._reputeTxt.text = String(_arg_1);
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

