// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.Battle

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class Battle extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _battle_txt:FilterFrameText;

        public function Battle(_arg_1:int)
        {
            this.init();
            this.BattleNum = _arg_1;
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.core.leveltip.BattleBg");
            this._battle_txt = ComponentFactory.Instance.creat("core.BattleTxt");
            addChild(this._bg);
            addChild(this._battle_txt);
        }

        public function set BattleNum(_arg_1:int):void
        {
            this._battle_txt.text = _arg_1.toString();
        }

        public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._battle_txt)
            {
                ObjectUtils.disposeObject(this._battle_txt);
            };
            this._battle_txt = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

